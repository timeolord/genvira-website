# Static demonstration export

`wp_dev export` creates an uploadable copy of the rendered Genvira prototype. It requires the local WordPress site to be running while the export is generated. The finished copy needs only a static host.

The default base path is `/genvira/`. The folder is `dist/genvira`, and the downloadable archive is `dist/genvira-static.zip`. Both are generated output and are ignored by Git.

The exporter starts from the public prototype pages and publication/news categories. It fetches those pages anonymously, copies referenced public assets, rewrites HTML and CSS URLs, removes WordPress discovery metadata and emoji bootstrap scripts, and includes the font licenses. Essential UI behavior is contained in the theme's standalone JavaScript.

Only a successful build replaces an existing recognized export. Failed builds leave the previous output in place. The exporter refuses to overwrite an unrelated `dist/genvira` directory. The source WordPress database is only read.

See the root README for alternate base paths, local static preview, browser checks, and the Hakyll copy rule for the personal website.

## Verification

The generated bundle was served from a plain static server under `/genvira/`. The browser checks passed for eleven pages at desktop and mobile widths, four article pages, the platform controls, research filters and search, mobile menu, email links, JavaScript-disabled content, and the 404 response. An artifact audit verified all internal HTML links, asset destinations, ZIP integrity and contents, bundled font licensing, and the absence of PHP, SQL, and references to the local WordPress server.

## GitHub Pages

`.github/workflows/pages.yml` builds this export from the committed snapshot on pushes to `main` and deploys `dist/genvira`. Pull requests build without deploying. The workflow reads the Pages base path; the inherited personal domain serves this repository at `https://www.melkyway.ca/genvira-website/`. This repository does not set its own custom domain.

`scripts/build-static.fish` requires a fresh checkout and cleans up its temporary server. It imports the snapshot and normalizes its source URL before export. `scripts/verify-static.php` checks page files, asset files, local links, deployment prefixes, and the absence of server files and localhost references before upload.

Local verification used a fresh temporary checkout and a separate port, preserving the active development site. The resulting export contained fifteen public pages and five assets under `/genvira-website/`.
