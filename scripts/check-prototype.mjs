import { mkdir, writeFile } from 'node:fs/promises';

const origin = (process.env.GENVIRA_QA_URL || 'http://127.0.0.1:1111').replace(/\/$/, '');
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
    await evaluate(`(async () => {
        for (const image of document.querySelectorAll('img:not(.leaflet-tile)')) {
            if (image.complete) continue;
            image.scrollIntoView();
            await new Promise(resolve => {
                image.addEventListener('load', resolve, {once: true});
                image.addEventListener('error', resolve, {once: true});
                setTimeout(resolve, 3000);
            });
        }
        scrollTo(0, 0);
    })()`);
    assert(await evaluate("document.querySelectorAll('h1').length === 1"), `expected one h1 at ${path}`);
    assert(!await evaluate("document.body.innerText.includes('{{')"), `unprocessed template at ${path}`);
    assert(await evaluate("[...document.querySelectorAll('img:not(.leaflet-tile)')].every(image => image.complete && image.naturalWidth > 0)"), `missing image at ${path}`);
}
async function check_contact_layout(mobile) {
    assert(await evaluate(`(() => {
        const email = document.querySelector('.contact-details span.email-address');
        const email_box = email.getBoundingClientRect();
        const phone = document.querySelector('.contact-details a[href^="tel:"]').getBoundingClientRect();
        const map = document.querySelector('.contact-map');
        const contact = document.querySelector('.contact-layout > div').getBoundingClientRect();
        const frame = map.getBoundingClientRect();
        return email.textContent === 'info@genvira.com' && getComputedStyle(email).textDecorationLine === 'underline' &&
            email_box.left === phone.left && email_box.bottom < phone.top &&
            map.dataset.latitude === '45.337208' && map.dataset.longitude === '-75.685013' &&
            map.querySelectorAll('.leaflet-marker-icon').length === 1 &&
            !!map.querySelector('.leaflet-control-attribution a[href="https://www.openstreetmap.org/copyright"]') &&
            frame.width > 0 && frame.height >= 320 && frame.right <= innerWidth &&
            (${mobile} ? frame.top > contact.bottom : frame.left > contact.right);
    })()`), 'contact details and map layout are incorrect');
    await evaluate("document.querySelector('.office-pin').click()");
    assert(await evaluate("document.querySelector('.leaflet-popup-content').textContent.includes('Suite 304')"), 'office pin did not open the address');
    assert(await evaluate(`(() => {
        const panel_address = document.querySelector('.office-map-card address');
        const contact_address = document.querySelector('.contact-details address');
        if (!panel_address || panel_address.textContent !== contact_address.textContent) return false;

        map.setView([45.34, -75.68], 17, { animate: false });
        document.querySelector('.office-map-reset').click();
        return map.getCenter().equals([45.337208, -75.685013]) && map.getZoom() === 16;
    })()`), 'map address or back-to-office control did not work');
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
    const paths = ['/', '/gvb-2030/', '/gvb-2040/', '/pipeline/', '/platform/', '/research/', '/about/', '/team/', '/partnering/', '/contact/', '/careers/', '/privacy/'];
    for (const path of paths) {
        const response = await fetch(`${origin}${path}`);
        assert(response.status === 200, `${path} returned ${response.status}`);
        await navigate(path);
        assert(await evaluate('document.documentElement.scrollWidth <= innerWidth'), `desktop overflow at ${path}`);
        if (path === '/') await screenshot('home-desktop');
    }
    await navigate('/team/');
    assert(await evaluate("document.querySelectorAll('.team-profile').length === 9"), 'team roster incomplete');
    assert(await evaluate("document.querySelector('.site-nav a[aria-current=page]').textContent === 'Team'"), 'team navigation missing');
    await screenshot('team-desktop');
    for (const width of [901, 1024, 1150, 1280]) {
        await viewport(width, 1000);
        assert(await evaluate('document.documentElement.scrollWidth <= innerWidth'), `header overflow at ${width}`);
        assert(await evaluate("document.querySelector('.site-nav').getBoundingClientRect().right <= innerWidth"), `navigation clipped at ${width}`);
    }
    await viewport(1440, 1100);
    await navigate('/platform/');
    await evaluate("document.querySelector('[data-step=translate]').click()");
    assert(await evaluate("!document.querySelector('[data-panel=translate]').hidden && document.querySelector('[data-panel=design]').hidden"), 'platform controls failed');
    await evaluate("document.querySelector('[data-platform]').scrollIntoView()");
    await screenshot('platform-desktop');
    await navigate('/research/');
    for (const category of ['news', 'publication']) {
        await evaluate(`document.querySelector('[data-filter=${category}]').click()`);
        assert(await evaluate(`(() => {
            const entries = [...document.querySelectorAll('.research-archive .research-entry')];
            return entries.some(entry => entry.dataset.kind === '${category}') &&
                entries.every(entry => entry.hidden === (entry.dataset.kind !== '${category}'));
        })()`), `${category} filter failed`);
    }
    await evaluate("document.querySelector('#research-search').value='no matching publication'; document.querySelector('#research-search').dispatchEvent(new Event('input'))");
    assert(await evaluate("!document.querySelector('.empty-results').hidden"), 'empty research search failed');
    await evaluate("document.querySelector('#research-search').value=''; document.querySelector('[data-filter=all]').click()");
    await screenshot('research-desktop');
    const detail_links = (await evaluate("[...document.querySelectorAll('.research-archive h3 a')].map(link => new URL(link.href).pathname)")).map(path => path.slice(path_prefix.length));
    for (const path of detail_links) await navigate(path);
    await navigate('/contact/');
    await check_contact_layout(false);
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
        if (path === '/contact/') await check_contact_layout(true);
        if (path === '/team/') await screenshot('team-mobile');
        if (path === '/pipeline/') {
            await evaluate("document.querySelector('.pipeline-table').scrollIntoView()");
            await screenshot('pipeline-mobile');
        }
    }
    await command('Emulation.setScriptExecutionDisabled', { value: true });
    await navigate('/contact/');
    assert(await evaluate("document.querySelector('.contact-map').hidden && !!document.querySelector('.contact-details a[href^=\"https://www.google.com/maps/search/\"]')"), 'Contact must retain an external map link without JavaScript');
    await navigate('/platform/');
    assert(await evaluate("[...document.querySelectorAll('[data-panel]')].every(panel => !panel.hidden)"), 'platform content requires javascript');
    await navigate('/team/');
    assert(await evaluate("[...document.querySelectorAll('.team-profile-bio')].every(bio => bio.getBoundingClientRect().height > 0)"), 'team bios require javascript');
    await navigate('/research/');
    assert(await evaluate("document.querySelectorAll('.research-entry:not([hidden])').length") === detail_links.length, 'research content requires javascript');
    await command('Emulation.setScriptExecutionDisabled', { value: false });
    assert((await fetch(`${origin}/missing-prototype-page/`)).status === 404, 'missing page did not return 404');
    assert((await fetch(`${origin}/research-tools/`)).status === 404, 'retired research tools page should return 404');
    assert(exceptions.length === 0, `browser exceptions: ${exceptions.join(', ')}`);
    console.log(`passed: ${paths.length} pages at desktop and mobile widths, ${detail_links.length} article pages, platform controls, research filters/search, contact details and map layout, mobile menu, no javascript fallback, and 404`);
    console.log(`screenshots: ${output_dir}`);
} finally {
    await command('Emulation.setScriptExecutionDisabled', { value: false });
    await command('Page.close');
    socket.close();
}
