# Genvira website

The Genvira prototype is built with [Zola](https://www.getzola.org/). Content, templates, styles, and artwork live in this repository. Development and deployment require no WordPress installation, PHP, or database.

## Development

### With Nix

On NixOS or another Linux system with Nix, load the pinned environment:

```fish
direnv allow
```

Or start a shell explicitly:

```fish
nix develop --command fish
```

Start the live preview:

```fish
zola serve
```

Open <http://127.0.0.1:1111>. Zola rebuilds and reloads when content, templates, or assets change. Stop the server with Ctrl+C. Use `zola serve --port 1112` if the default port is occupied.

The flake provides Zola, Node.js for validation, and fish. `flake.lock` pins their versions. Keep `.envrc` set to `use flake`. The templates use the Tera content templating introduced in Zola 0.23.

### Windows without Nix

Use PowerShell in Windows Terminal or the normal PowerShell app. Zola does not support PowerShell ISE. You do not need Nix, WSL, fish, WordPress, or a Rust compiler.

Install [Git for Windows](https://git-scm.com/install/windows) and Zola 0.23.6 using WinGet:

```powershell
winget install --id Git.Git --exact --source winget
winget install --id getzola.zola --exact --version 0.23.6 --source winget
```

If WinGet is unavailable or does not offer that Zola version, use the Git installer linked above and download the Windows ZIP from the [Zola 0.23.6 release](https://github.com/getzola/zola/releases/tag/v0.23.6). Extract `zola.exe` into a permanent folder, such as `C:\Tools\Zola`. Search Windows for “Edit environment variables for your account”, edit your user's `Path`, and add that folder. Other installation options are in the [Zola installation guide](https://www.getzola.org/documentation/getting-started/installation/).

Install Node.js 24 using the Windows `.msi` installer from the [Node.js 24 downloads](https://nodejs.org/download/release/latest-v24.x/). Choose `x64.msi` for a typical Intel or AMD computer, or `arm64.msi` for Windows on ARM. Keep the installer's option to add Node.js to `PATH`. Node.js is used for build validation and static previews; Zola alone is enough for editing with `zola serve`.

Close and reopen PowerShell after installation, then check:

```powershell
git --version
zola --version
node --version
```

Expect Zola `0.23.6` and Node.js `v24.x`. Clone the repository into a folder of your choice, then start the preview:

```powershell
git clone https://github.com/timeolord/genvira-website.git
Set-Location genvira-website
zola serve
```

If you already have a clone, use `Set-Location` with its path instead. Run all commands below from the repository folder containing `zola.toml`. Open <http://127.0.0.1:1111> and edit the source files in your text editor. Changes reload automatically. Stop the preview with Ctrl+C. If a command is not recognized, reopen PowerShell and check that its installation folder is on `PATH`.

Build and validate from PowerShell by running these commands in order. Continue to validation only if the build succeeds:

```powershell
zola build --force
node scripts/verify-static.mjs
```

The output is `dist/genvira/`. These commands perform the same build and validation as `scripts/build-static.fish`, without requiring fish. No `npm install` is needed. Publishing still happens through GitHub Actions when changes reach `main`.

### macOS or Linux without Nix

Install Git, Zola 0.23.6, and Node.js 24 using their official installers or your package manager. Zola provides prebuilt binaries for these platforms in its [release downloads](https://github.com/getzola/zola/releases/tag/v0.23.6). Check `zola --version` and `node --version`, then run `zola serve` from the repository folder. Build with `zola build --force`, followed by `node scripts/verify-static.mjs` after a successful build. The direct commands in the Windows section also work in other shells; use `cd` instead of `Set-Location`.

### Blender for 3D artwork

Launch Blender from its separate Nix environment:

```fish
nix develop .#blender --command blender
```

Or enter an interactive shell with Blender available:

```fish
nix develop .#blender --command fish
```

The Blender version comes from the same `flake.lock` as the website tools. Keep `.envrc` set to `use flake` for normal website work. Store editable `.blend` projects outside `static/`, and place exported images or web models under `static/assets/` so only the web assets are published.

## Editing

- `content/_index.md` contains the homepage.
- `content/*.md` contains the other main pages.
- `content/research/_index.md` configures the research archive.
- `content/research/*.md` contains publication and company news articles.
- `templates/` contains shared layouts, navigation, article cards, and the 404 page.
- `static/style.css`, `static/markdown.css`, and `static/assets/` contain styles, JavaScript, fonts, portraits, and artwork.
- `zola.toml` contains site metadata, navigation links, and the deployment URL.

Content files start with TOML metadata between `+++` lines. All page and article bodies use ordinary Markdown. Use `##` for section headings, `###` for subsections, blank lines for paragraphs, `>` for citations or quotes, and Markdown lists and tables. Use validated internal links such as `[Our team](@/team.md)` and images such as `![Description](/assets/tumor-environment.svg)`. The templates resolve image paths under `/assets/` against the deployment prefix. No HTML, CSS classes, or template expressions are needed in the body.

The homepage and other designed pages use `---` on its own line to separate layout blocks. Keep those separators in order when editing; their templates arrange the blocks into the existing columns, cards, diagrams, and controls. Section labels and other small layout details live under `[extra]` in the same file. Team biographies use `### Name`, an image, a role in bold, and ordinary paragraphs. The pipeline uses a Markdown table. The privacy page and research articles use the shared prose layout and do not need layout separators.

Layout markup lives in `templates/layouts/`, with shared text and button formatting in `templates/partials/`. Research articles share `templates/article.html` and the prose styles in `static/markdown.css`, including headings, citations, quotations, and source links. In templates, use `get_url` for links and assets that need the deployment prefix.

### Publish a research update

Create `content/research/your-update.md`:

```markdown
+++
title = "Your update title"
date = 2026-11-26T12:00:00Z
path = "your-update"
description = "A short summary for the research cards."
[extra]
kind = "news"
date_label = "November 26, 2026"
+++

Write the update here, with links to its sources.
```

For a publication, put the citation in a blockquote followed by an Abstract heading. A backslash at the end of a line keeps a line break without adding HTML:

```markdown
> Author names.\
> Journal name and publication details.\
> DOI: your DOI

## Abstract

The publication abstract, preserving the supplied wording.

[Read the paper ↗](https://doi.org/your-doi)

[View on PubMed](https://pubmed.ncbi.nlm.nih.gov/your-id/)
```

The shared article template styles DOI links as primary buttons and other standalone source links consistently. Company announcements use the same typography; prefix quoted paragraphs with `>`.

Set `kind` to `news` or `publication`. The `path` keeps articles at `/your-update/`, matching the existing article URL scheme. Dates control archive ordering; `date_label` can show just the verified publication year. Omit `date_label` to display the full date. Set `draft = true` before `[extra]` to keep unfinished work out of production; preview drafts with `zola serve --drafts`.

Published articles appear automatically in Research & Updates, newest first. The homepage shows the latest three. There is no separate index or database snapshot to update. Review the local preview, append a timestamped changelog entry, and commit the source files.

### Design and features

The prototype includes eleven main pages and four initial research updates. Navigation, platform steps, research filtering, and search run in the browser. Contact uses bundled Leaflet with OpenStreetMap tiles and retains a Google Maps link without JavaScript. Navigation, biographies, publications, and platform descriptions remain readable without JavaScript.
The homepage introduces the lead program and gives pharma teams, drug developers, government agencies, investors, and prospective hires links to relevant next steps. Homepage headings animate on entry and respect the browser’s reduced motion preference.

The homepage and GVB-2030 page share [tumor-environment.svg](static/assets/tumor-environment.svg), a conceptual illustration showing a TLS within an enlarged tumor rather than study data. The logo, portraits, locally bundled fonts, and scientific source links are preserved from the WordPress prototype. Research and content notes are in [docs/prototype.md](docs/prototype.md). Scientific status, publication links, and privacy copy need the team's review before public launch. The prototype retains `noindex` metadata and a robots exclusion.

## Build and deployment

Build and validate the production bundle:

```fish
nix develop --command fish scripts/build-static.fish
```

The output is `dist/genvira/`, ready for a static host. The build validates HTML links, anchors, CSS assets, deployment prefixes, bundled licenses, and the absence of server files or localhost references. It works in an ordinary checkout and does not read or replace local databases. `dist/` is generated output; edit source files instead.

The prototype address remains <https://www.melkyway.ca/genvira-website/>. Pushing `main` builds and publishes through `.github/workflows/pages.yml`; pull requests build and validate without publishing. GitHub Pages must use GitHub Actions as its build source. The workflow uses Pages metadata for the deployment URL and the repository's built-in GitHub token. It does not need database credentials or a separate hosting account.

This repository inherits the domain from `timeolord.github.io`. Do not configure the personal domain as this repository's own custom domain or modify the personal website. Deployment belongs entirely to this repository.

To build for another host or path, pass the complete destination URL:

```fish
nix develop --command fish scripts/build-static.fish https://example.org/projects/genvira/
```

Without Nix or fish, run these commands in order, continuing only after a successful build:

```powershell
zola build --force --base-url https://example.org/projects/genvira/
node scripts/verify-static.mjs https://example.org/projects/genvira/
```

For a standalone domain, use `https://example.org/`. Upload the contents of `dist/genvira/` at the selected location. Nested pages use directory indexes. See [docs/static-export.md](docs/static-export.md) for static preview details.

## Checks and previews

The production build above includes static validation. Check the GitHub Actions workflow with:

```fish
nix develop .#qa --command actionlint
```

For browser checks, build with the local preview URL so absolute links stay on the local server, then serve the generated bundle:

```fish
nix develop --command fish scripts/build-static.fish http://127.0.0.1:8090/genvira-website/
nix develop --command node scripts/serve-static.mjs
```

Open <http://127.0.0.1:8090/genvira-website/>. This preview reads the deployment path from the generated sitemap and returns the generated 404 page for missing URLs. Rebuild before previewing source changes. Run the production build again before uploading output manually; GitHub Actions always builds its own production output.

On Windows or another system without Nix, run the equivalent commands in order, continuing only if each command succeeds:

```powershell
zola build --force --base-url http://127.0.0.1:8090/genvira-website/
node scripts/verify-static.mjs http://127.0.0.1:8090/genvira-website/
node scripts/serve-static.mjs
```

Keep that terminal open while previewing, then stop the server with Ctrl+C. Before a manual upload, restore production output with `zola build --force` and `node scripts/verify-static.mjs`.

For automated browser checks using the Linux Nix QA environment, start the QA browser in another terminal:

```fish
nix develop .#qa --command chromium --headless --no-sandbox --disable-gpu --remote-debugging-port=9227 --user-data-dir=/tmp/genvira-browser-qa
```

Then run:

```fish
nix develop .#qa --command env GENVIRA_QA_URL=http://127.0.0.1:8090/genvira-website node scripts/check-prototype.mjs
```

The checks cover all eleven main pages at desktop and mobile widths, research articles, image loading, responsive navigation, platform steps, research filters and search, contact details and map controls, content without JavaScript, and 404 responses. Screenshots are saved to `/tmp/genvira-prototype-qa`. Stop the browser and preview server you started when finished.

Rebuild the decorative symbol font when its source changes:

```fish
nix develop .#fonts --command python3 scripts/build-symbol-font.py
```

## Working together

Record every repository change in [changelog.txt](changelog.txt) in the same commit, using the actual UTC timestamp from `date -u '+%Y-%m-%dT%H:%M:%SZ'`. Keep source changes reviewable in Git and preserve unrelated files. Repository instructions are in [AGENTS.md](AGENTS.md).

On Windows, append the equivalent UTC entry from PowerShell, replacing the example description with your change and verification:

```powershell
Add-Content -Path changelog.txt -Encoding utf8 -Value (([DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")) + " | Describe the change and relevant checks.")
```

The Zola migration preserves the fifteen published prototype records from the sanitized WordPress snapshot, including metadata and article URLs. WordPress starter records were outside the published prototype. The old theme, plugins, database snapshot, and WordPress scripts are available in Git history. Ignored `.local/` data and uploads are preserved for recovery, but are no longer used. The untracked `old-website/` directory remains reference material.
