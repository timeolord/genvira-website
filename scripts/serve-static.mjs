import { createServer } from 'node:http';
import { readFile, stat } from 'node:fs/promises';
import { resolve, extname, sep } from 'node:path';

const root = resolve('dist/genvira');
const sitemap = await readFile(resolve(root, 'sitemap.xml'), 'utf8');
const base_path = new URL(sitemap.match(/<loc>(.*?)<\/loc>/)[1]).pathname;
const port = Number(process.env.GENVIRA_PREVIEW_PORT || 8090);
const mime_types = { '.html': 'text/html; charset=utf-8', '.css': 'text/css; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.svg': 'image/svg+xml', '.png': 'image/png', '.jpg': 'image/jpeg', '.webp': 'image/webp', '.woff': 'font/woff', '.woff2': 'font/woff2', '.json': 'application/json' };
const server = createServer(async (request, response) => {
    try {
        const url = new URL(request.url, `http://localhost:${port}`);
        if (base_path !== '/' && url.pathname === base_path.slice(0, -1)) {
            response.writeHead(301, { Location: `${base_path}${url.search}` }).end();
            return;
        }
        if (!url.pathname.startsWith(base_path)) throw new Error('outside preview path');
        let file = resolve(root, decodeURIComponent(url.pathname.slice(base_path.length)));
        if (file !== root && !file.startsWith(root + sep)) throw new Error('outside preview directory');
        if ((await stat(file)).isDirectory()) {
            if (!url.pathname.endsWith('/')) {
                response.writeHead(301, { Location: `${url.pathname}/${url.search}` }).end();
                return;
            }
            file = resolve(file, 'index.html');
        }
        response.writeHead(200, { 'Content-Type': mime_types[extname(file)] || 'application/octet-stream' });
        response.end(await readFile(file));
    } catch {
        response.writeHead(404, { 'Content-Type': 'text/html; charset=utf-8' });
        response.end(await readFile(resolve(root, '404.html')).catch(() => 'Not found'));
    }
});
server.listen(port, '127.0.0.1', () => console.log(`static preview: http://127.0.0.1:${port}${base_path}`));
