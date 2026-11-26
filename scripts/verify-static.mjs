import assert from 'node:assert/strict';
import { readFile, readdir, stat } from 'node:fs/promises';
import { resolve, relative, extname, sep } from 'node:path';

const root = resolve('dist/genvira');
const config = await readFile('zola.toml', 'utf8');
const base_url = new URL(process.argv[2] || config.match(/^base_url\s*=\s*"([^"]+)"/m)[1]);
base_url.pathname = `${base_url.pathname.replace(/\/$/, '')}/`;
const files = await readdir(root, { recursive: true, withFileTypes: true });
const documents = new Map();
const decode_entities = value => value.replace(/&(?:amp|quot|apos|lt|gt|#\d+|#x[\da-f]+);/gi, entity => ({ '&amp;': '&', '&quot;': '"', '&apos;': "'", '&lt;': '<', '&gt;': '>' })[entity] || String.fromCodePoint(entity[2].toLowerCase() === 'x' ? parseInt(entity.slice(3, -1), 16) : Number(entity.slice(2, -1))));

for (const file of files.filter(file => file.isFile())) {
    const path = resolve(file.parentPath, file.name);
    const extension = extname(path);
    assert(!['.php', '.sql', '.log'].includes(extension), `server file in output: ${path}`);
    if (!['.html', '.css', '.js', '.json', '.svg', '.xml', '.txt'].includes(extension)) continue;
    const text = await readFile(path, 'utf8');
    const local_urls = text.match(/https?:\/\/(?:localhost|127\.0\.0\.1)(?::\d+)?/g) || [];
    assert(local_urls.every(url => url === base_url.origin), `unexpected local server reference: ${path}`);
    if (extension === '.html') {
        assert(!/\{\{|\{%|<\?php|\/wp-(?:admin|json|content)\//.test(text), `unprocessed content: ${path}`);
        assert.equal([...text.matchAll(/<h1\b/gi)].length, 1, `expected one heading: ${path}`);
        documents.set(path, text);
    }
}

async function check_url(value, source_url, source_path) {
    const url = new URL(decode_entities(value), source_url);
    if (url.origin !== base_url.origin || !['http:', 'https:'].includes(url.protocol)) return;
    assert(url.pathname.startsWith(base_url.pathname), `wrong deployment path: ${url.href} in ${source_path}`);
    let target = resolve(root, decodeURIComponent(url.pathname.slice(base_url.pathname.length)));
    assert(target === root || target.startsWith(root + sep), `path outside output: ${url.href}`);
    const info = await stat(target).catch(() => null);
    assert(info, `missing link or asset: ${url.href} in ${source_path}`);
    if (info.isDirectory()) target = resolve(target, 'index.html');
    assert((await stat(target)).isFile(), `missing document: ${target}`);
    if (url.hash && documents.has(target)) {
        const ids = [...documents.get(target).matchAll(/\bid\s*=\s*["']([^"']+)["']/gi)].map(match => decode_entities(match[1]));
        assert(ids.includes(decodeURIComponent(url.hash.slice(1))), `missing anchor: ${url.href}`);
    }
}

for (const [path, text] of documents) {
    const source_url = new URL(relative(root, path).split(sep).join('/').replace(/index\.html$/, ''), base_url);
    for (const match of text.matchAll(/\b(?:href|src|poster)\s*=\s*(["'])(.*?)\1/gi)) await check_url(match[2], source_url, path);
}

for (const file of files.filter(file => file.isFile() && extname(file.name) === '.css')) {
    const path = resolve(file.parentPath, file.name);
    const source_url = new URL(relative(root, path).split(sep).join('/'), base_url);
    const text = await readFile(path, 'utf8');
    for (const match of text.matchAll(/url\(\s*["']?([^\s"')]+)["']?\s*\)/g)) await check_url(match[1], source_url, path);
}

for (const path of ['index.html', '404.html', 'licenses/OFL.txt', 'licenses/LEAFLET.txt', 'robots.txt', 'sitemap.xml']) assert((await stat(resolve(root, path))).isFile(), `missing required file: ${path}`);
const sitemap = await readFile(resolve(root, 'sitemap.xml'), 'utf8');
for (const match of sitemap.matchAll(/<loc>(.*?)<\/loc>/g)) await check_url(match[1], base_url, 'sitemap.xml');
console.log(`verified ${documents.size} HTML documents, local links, anchors, CSS assets, licenses, and deployment path ${base_url.pathname}`);
