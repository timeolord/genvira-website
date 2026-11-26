# Static build

Zola renders the site directly from the content and templates in this repository. No WordPress server, database restore, or crawling step is involved.

```fish
nix develop --command fish scripts/build-static.fish
```

The default deployment URL is `https://www.melkyway.ca/genvira-website/`, configured in `zola.toml`. Pass a complete URL to build for another destination:

```fish
nix develop --command fish scripts/build-static.fish https://example.org/projects/genvira/
```

The output is always `dist/genvira/`. Upload its contents at the destination path. The build replaces generated output; keep edits in `content/`, `templates/`, and `static/`. Zola copies all bundled assets and licenses. The bundle includes eleven main pages, the published research articles, directory indexes, `404.html`, a sitemap, and prototype robots exclusions. There is no generated ZIP.

`scripts/verify-static.mjs` checks all generated HTML links, internal anchors, CSS asset references, sitemap destinations, the deployment prefix, required licenses, and the absence of server files, unprocessed templates, and local server URLs. It requires only Node.js, supplied by the flake.

## Preview

```fish
nix develop --command fish scripts/build-static.fish http://127.0.0.1:8090/genvira-website/
nix develop --command node scripts/serve-static.mjs
```

The preview serves `dist/genvira/` under the deployment path found in its sitemap. The local build keeps absolute links on <http://127.0.0.1:8090/genvira-website/>. Missing URLs return the generated 404 document with HTTP status 404. Set `GENVIRA_PREVIEW_PORT` and the build URL to use another port. This is a static preview, so rebuild before reviewing source changes. Use `zola serve` for automatic local rebuilding. Build again with the production URL before uploading output manually.

The root [README](../README.md) documents browser checks at desktop and mobile widths, interaction checks, and content editing.

## GitHub Pages

`.github/workflows/pages.yml` builds and validates on pushes to `main` and on pull requests. Only `main` and manual workflow runs publish. GitHub Pages metadata supplies the full destination URL. Pull requests use the repository's GitHub Pages path without deploying.

The workflow uploads `dist/genvira/` using the existing Pages artifact and deployment actions. The inherited domain and `/genvira-website/` path remain unchanged. No `CNAME` is added and the personal website needs no changes.
