import { createServer } from 'node:http';
import { readFile, stat } from 'node:fs/promises';
import { resolve, extname, sep } from 'node:path';

const root = resolve('dist');
const mime_types = { '.html': 'text/html; charset=utf-8', '.css': 'text/css; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.svg': 'image/svg+xml', '.png': 'image/png', '.jpg': 'image/jpeg', '.webp': 'image/webp', '.woff2': 'font/woff2', '.json': 'application/json' };
const server = createServer(async (request, response) => {
    try {
        const url = new URL(request.url, 'http://localhost:8090');
        let file = resolve(root, `.${decodeURIComponent(url.pathname)}`);
        if (!file.startsWith(root + sep)) {
            response.writeHead(404).end('Not found');
            return;
        }
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
        response.end(await readFile(resolve(root, 'genvira/404.html')).catch(() => 'Not found'));
    }
});
server.listen(8090, '127.0.0.1', () => console.log('static preview: http://127.0.0.1:8090/genvira/'));
