import { mkdir, writeFile } from 'node:fs/promises';

const origin = (process.env.GENVIRA_QA_URL || 'http://localhost:8080').replace(/\/$/, '');
const path_prefix = new URL(origin).pathname.replace(/\/$/, '');
const debug_url = process.env.GENVIRA_QA_BROWSER || 'http://localhost:9227';
const output_dir = process.env.GENVIRA_QA_OUTPUT || '/tmp/genvira-prototype-qa';
const target = await fetch(`${debug_url}/json/new?about:blank`, { method: 'PUT' }).then(response => response.json());
if (!target.webSocketDebuggerUrl) throw new Error('start chromium with remote debugging on port 9227 first');
const socket = new WebSocket(target.webSocketDebuggerUrl);
await new Promise((resolve, reject) => { socket.onopen = resolve; socket.onerror = reject; });
let sequence = 0;
const pending = new Map();
const exceptions = [];
socket.onmessage = event => {
    const message = JSON.parse(event.data);
    if (message.method === 'Runtime.exceptionThrown') exceptions.push(message.params.exceptionDetails.text);
    if (!message.id) return;
    const request = pending.get(message.id);
    pending.delete(message.id);
    if (message.error) request.reject(new Error(message.error.message));
    else request.resolve(message.result);
};
function command(method, params = {}) {
    return new Promise((resolve, reject) => {
        const id = ++sequence;
        pending.set(id, { resolve, reject });
        socket.send(JSON.stringify({ id, method, params }));
    });
}
async function evaluate(expression) {
    const result = await command('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
    if (result.exceptionDetails) throw new Error(result.exceptionDetails.text);
    return result.result.value;
}
function assert(condition, message) {
    if (!condition) throw new Error(message);
}
async function navigate(path) {
    await command('Page.navigate', { url: `${origin}${path}` });
    for (let attempt = 0; attempt < 100; attempt++) {
        if (await evaluate(`location.pathname === ${JSON.stringify(`${path_prefix}${path}`)} && document.readyState === 'complete'`)) break;
        await new Promise(resolve => setTimeout(resolve, 100));
    }
    await evaluate('document.fonts.ready.then(() => true)');
    await new Promise(resolve => setTimeout(resolve, 100));
    await evaluate('scrollTo(0, 0)');
    assert(await evaluate("document.querySelectorAll('h1').length === 1"), `expected one h1 at ${path}`);
    assert(!await evaluate("/Warning:|Fatal error:/.test(document.body.innerText)"), `php warning at ${path}`);
    assert(await evaluate("[...document.images].every(image => image.complete && image.naturalWidth > 0)"), `missing image at ${path}`);
}
async function screenshot(name) {
    const result = await command('Page.captureScreenshot', { format: 'png' });
    await writeFile(`${output_dir}/${name}.png`, Buffer.from(result.data, 'base64'));
}
async function viewport(width, height) {
    await command('Emulation.setDeviceMetricsOverride', { width, height, deviceScaleFactor: 1, mobile: width < 640 });
}

try {
    await mkdir(output_dir, { recursive: true });
    await command('Page.enable');
    await command('Emulation.setScriptExecutionDisabled', { value: false });
    await command('Runtime.enable');
    await viewport(1440, 1100);
    const paths = ['/', '/gvb-2030/', '/pipeline/', '/platform/', '/research/', '/about/', '/partnering/', '/contact/', '/research-tools/', '/careers/', '/privacy/'];
    for (const path of paths) {
        const response = await fetch(`${origin}${path}`);
        assert(response.status === 200, `${path} returned ${response.status}`);
        await navigate(path);
        assert(await evaluate('document.documentElement.scrollWidth <= innerWidth'), `desktop overflow at ${path}`);
        if (path === '/') await screenshot('home-desktop');
    }
    await navigate('/platform/');
    await evaluate("document.querySelector('[data-step=translate]').click()");
    assert(await evaluate("!document.querySelector('[data-panel=translate]').hidden && document.querySelector('[data-panel=design]').hidden"), 'platform controls failed');
    await evaluate("document.querySelector('[data-platform]').scrollIntoView()");
    await screenshot('platform-desktop');
    await navigate('/research/');
    await evaluate("document.querySelector('[data-filter=news]').click()");
    assert(await evaluate("document.querySelectorAll('.research-archive .research-entry:not([hidden])').length === 1"), 'news filter failed');
    await evaluate("document.querySelector('[data-filter=publication]').click()");
    assert(await evaluate("document.querySelectorAll('.research-archive .research-entry:not([hidden])').length === 3"), 'publication filter failed');
    await evaluate("document.querySelector('#research-search').value='no matching publication'; document.querySelector('#research-search').dispatchEvent(new Event('input'))");
    assert(await evaluate("!document.querySelector('.empty-results').hidden"), 'empty research search failed');
    await evaluate("document.querySelector('#research-search').value=''; document.querySelector('[data-filter=all]').click()");
    await screenshot('research-desktop');
    const detail_links = (await evaluate("[...document.querySelectorAll('.research-archive h3 a')].map(link => new URL(link.href).pathname)")).map(path => path.slice(path_prefix.length));
    for (const path of detail_links) await navigate(path);
    await navigate('/contact/');
    await evaluate("document.querySelector('[data-contact-topic]').value='Investor inquiry'; document.querySelector('[data-contact-topic]').dispatchEvent(new Event('change'))");
    assert(await evaluate("document.querySelector('[data-email-link]').href.includes('Investor%20inquiry')"), 'contact topic link failed');
    await viewport(390, 844);
    for (const path of paths) {
        await navigate(path);
        assert(await evaluate('document.documentElement.scrollWidth <= innerWidth'), `mobile overflow at ${path}`);
        if (path === '/') {
            await screenshot('home-mobile');
            await evaluate("document.querySelector('.menu-toggle').click()");
            assert(await evaluate("document.querySelector('.menu-toggle').getAttribute('aria-expanded') === 'true'"), 'mobile menu failed to open');
            await evaluate("document.dispatchEvent(new KeyboardEvent('keydown', {key:'Escape',bubbles:true}))");
            assert(await evaluate("document.querySelector('.menu-toggle').getAttribute('aria-expanded') === 'false'"), 'mobile menu failed to close');
        }
        if (path === '/pipeline/') {
            await evaluate("document.querySelector('.pipeline-table').scrollIntoView()");
            await screenshot('pipeline-mobile');
        }
    }
    await command('Emulation.setScriptExecutionDisabled', { value: true });
    await navigate('/platform/');
    assert(await evaluate("[...document.querySelectorAll('[data-panel]')].every(panel => !panel.hidden)"), 'platform content requires javascript');
    await navigate('/research/');
    assert(await evaluate("document.querySelectorAll('.research-entry:not([hidden])').length === 4"), 'research content requires javascript');
    await command('Emulation.setScriptExecutionDisabled', { value: false });
    assert((await fetch(`${origin}/missing-prototype-page/`)).status === 404, 'missing page did not return 404');
    assert(exceptions.length === 0, `browser exceptions: ${exceptions.join(', ')}`);
    console.log(`passed: ${paths.length} pages at desktop and mobile widths, ${detail_links.length} article pages, platform controls, research filters/search, contact links, mobile menu, no javascript fallback, and 404`);
    console.log(`screenshots: ${output_dir}`);
} finally {
    await command('Emulation.setScriptExecutionDisabled', { value: false });
    await command('Page.close');
    socket.close();
}
