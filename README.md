# Genvira website

WordPress prototype for the Genvira website. Themes and plugins live in this repository; each developer runs their own local WordPress installation.

## Development

### With Nix

On Linux, enter the development environment with:

```fish
direnv allow
```

Or start a fish shell directly:

```fish
nix develop --command fish
```

Then run:

```fish
wp_dev up
```

Open <http://localhost:8080> and complete the WordPress installer. Choose your own administrator credentials. Keep the terminal open while developing; Ctrl+C stops the site and database. Run `wp_dev up` again to resume.

The flake provides WordPress, PHP, MariaDB, and WP-CLI. `flake.lock` pins their versions. WordPress core is copied into `.local/wordpress`, and the database is stored in `.local/mariadb`. Themes, plugins, and uploads use the repository's `wp-content` directory.

Run WordPress commands from another terminal in the development environment:

```fish
wp_dev cli core version
wp_dev cli plugin list
```

Update WordPress core through the flake. Changes to the flake or scripts require reloading the development environment and restarting `wp_dev up`. When adding files referenced by the flake, add them to Git so Nix can see them.

### Without Nix

Install Git and [Local](https://localwp.com/help-docs/getting-started/installing-local/), which provides a WordPress development environment for Windows, macOS, and supported Linux distributions. Clone this repository, create a new WordPress site in Local, and open its site folder.

In the new site's `app/public/wp-content` directory, rename `themes` to `themes-backup` and `plugins` to `plugins-backup`. Link the repository's directories in their place so edits and Git updates appear directly in WordPress.

On macOS or Linux, run these commands from that directory, replacing the example repository path:

```sh
ln -s "/absolute/path/to/genvira-website/wp-content/themes" themes
ln -s "/absolute/path/to/genvira-website/wp-content/plugins" plugins
```

On Windows, open PowerShell in that directory and use directory junctions:

```powershell
New-Item -ItemType Junction -Path themes -Target "C:\path\to\genvira-website\wp-content\themes"
New-Item -ItemType Junction -Path plugins -Target "C:\path\to\genvira-website\wp-content\plugins"
```

Start the site in Local and open its WordPress admin page. Use Local's generated configuration and database. The files in `scripts` configure the Nix environment only.

Choose compatible PHP and WordPress versions with the team; Local's environment is managed separately from `flake.lock`. Check the Nix versions with `php --version` and `wp_dev cli core version`. Local's “Open Site Shell” provides WP-CLI, where the equivalent WordPress commands are:

```sh
wp core version
wp plugin list
```

## Website prototype

The `genvira` theme implements the proposed website. With `wp_dev up` running, reload the development environment and prepare the pages in another terminal:

```fish
wp_dev prototype
```

This activates the theme, creates eleven pages and four source-linked research updates, selects the homepage, and configures readable URLs. Re-running it refreshes only content marked as belonging to this prototype; back up editorial changes before doing so. Unrelated pages and posts are preserved. It refuses to replace an existing, unmarked page or post with the same slug.

Open <http://localhost:8080>. Edit the seeded pages and research posts in WordPress, or change the initial content in `wp-content/themes/genvira/content` and run the setup again. Design styles and behavior live in the theme's `style.css` and `assets/site.js`. To add a research update in WordPress, create a post and assign the Publication or Company news category; those categories populate the research archive and homepage.

The site includes a dedicated GVB-2030 page, an HTML pipeline, a separate engineering platform, Research & Updates, About, Partnering, Contact, Careers, and a separate pseudovirus research-tools page. Research filters and platform step controls enhance server-rendered content. Contact links open the visitor's email application; no message is submitted by the site.

With Local, start the site and run this in its site shell, using the actual path to the repository:

```sh
wp --skip-plugins --skip-themes eval-file "/absolute/path/to/genvira-website/scripts/setup-prototype.php"
```

The theme and plugin directory links described above must already be in place. Alternatively, import the updated database snapshot and activate the `genvira` theme. Follow the snapshot instructions to create a local administrator and update the URL.

Research notes and content sources are recorded in `docs`. The logo is copied from Genvira's current public website, and typography is bundled locally under the SIL Open Font License. The diagrams are conceptual illustrations, not study data. Program status and all publication links should be reviewed with the scientific team before a public launch.

## Automatic GitHub Pages deployment

The deployment target is <https://www.melkyway.ca/genvira-website/>. The `deploy prototype` workflow builds and publishes the static site whenever `main` is pushed. Pull requests run the build without publishing. It can also be started manually from the Actions tab.

One-time repository setup: open Settings → Pages and select GitHub Actions as the build source. This project inherits the domain configured on `timeolord.github.io`; do not set `www.melkyway.ca` as this repository's own custom domain. The workflow reads GitHub Pages metadata to choose the correct URL prefix. No extra DNS record or Hakyll copy rule is needed for this deployment.

Each build uses `flake.lock`, PHP 8.4, MariaDB, the checked-in theme and plugins, and `database/initial.sql`. It starts a temporary local WordPress instance, imports the snapshot, normalizes the local source URL, exports the site, validates links and assets, and uploads only `dist/genvira` to Pages. The temporary server is stopped after the build. No WordPress server or database is hosted publicly.

For theme code, CSS, or JavaScript changes, commit and push the changes. For page content, settings, and research articles edited in WordPress, refresh the snapshot first:

```fish
wp_dev snapshot
git add database/initial.sql wp-content/themes wp-content/plugins
git commit -m "update the website prototype"
git push
```

Review the sanitized snapshot before committing it. Local dashboard edits are published only after they are captured in the committed snapshot. If you change the initial HTML under the theme's `content` directory, run `wp_dev prototype` locally to apply it, then take a new snapshot; the deployment deliberately restores the snapshot without overwriting editorial changes with the initial seed content.

The fresh build command is:

```fish
nix develop --command fish scripts/build-static.fish /genvira-website/
```

Run it only in a fresh checkout. It refuses a directory containing an existing local WordPress database. `WP_DEV_PORT` can select another local port when testing a separate checkout alongside the development server. Validate the workflow with `nix develop .#qa --command actionlint`.

The workflow uses the repository's built-in GitHub token and Pages deployment permissions. It does not need a personal access token, database credentials secret, or a separate hosting account. Successful deployment URLs appear in the `github-pages` environment and the workflow run.

## Static demonstration

Export a copy that can be hosted on a normal static website. Keep WordPress running with `wp_dev up`, reload the Nix environment in another terminal, then run:

```fish
wp_dev export
```

The command writes `dist/genvira/` and `dist/genvira-static.zip`. The ZIP contains a `genvira` directory ready to place under your website's public root. At `www.melkyway.ca`, that would make the demo available at `https://www.melkyway.ca/genvira/` after you upload and publish it.

The default destination path is `/genvira/`. To use a different location, export again with its leading and trailing slashes:

```fish
wp_dev export /projects/genvira/
```

For a standalone domain, use `wp_dev export /` and upload the contents of `dist/genvira` at that domain's root. The output directory is always named `genvira`; its placement on the host must match the path chosen for the export. Nested pages use directory indexes such as `pipeline/index.html`.

The export includes the public prototype pages, research and news posts in the Publication or Company news categories, their assets, a missing-page document, and font licenses. The menu, platform controls, research filters, and email links work in the browser. WordPress administration, the database, login, API discovery links, feeds, and private or password protected content are excluded. The demo includes a `noindex` directive.

Edit the site in WordPress and export again when you want to refresh the demonstration. Generated files are ignored by Git. The exporter replaces its own previous `dist/genvira` output, so keep manual changes in the WordPress theme or content instead. A link to a local page outside the exported prototype causes a build error rather than silently producing a broken link.

For a Local installation, run the PHP exporter from this repository directory, pointing WP-CLI at Local's WordPress directory:

```sh
wp --path="/absolute/path/to/Local Sites/genvira/app/public" --skip-plugins --skip-themes eval-file scripts/export-static.php /genvira/
```

Local must be running, and the source WordPress installation must use its domain root. PHP needs the DOM and zip extensions. Outputs are written under the current repository directory.

### Preview the static copy

In the QA environment, run:

```fish
nix develop .#qa --command node scripts/serve-static.mjs
```

Open <http://127.0.0.1:8090/genvira/>. This server reads only exported files; it does not connect to WordPress. Use this preview for an export built with the default `/genvira/` destination path. Opening `index.html` directly from the file manager does not reproduce normal website URL routing.

With a browser running as described in Browser checks, validate the default export with:

```fish
env GENVIRA_QA_URL=http://127.0.0.1:8090/genvira node scripts/check-prototype.mjs
```

### Include it in the personal Hakyll site

Copy the exported `genvira` directory into the personal website's source root, alongside `site.hs`. Add this rule inside `hakyllWith config $ do`:

```haskell
match "genvira/**" $ do
    route idRoute
    compile copyFileCompiler
```

Build and publish the personal website as usual. Hakyll will copy the demo to `docs/genvira` without applying the blog templates. Replace the source `genvira` folder when updating the export. Copying only into the generated `docs` folder is temporary because a clean rebuild can remove it.

The export command prepares local files; publishing those files to the personal website is a separate step.

## Working together

Commit theme and plugin files under `wp-content/themes` and `wp-content/plugins`, including third party code used by the site. This gives collaborators the same versions and records changes made through the dashboard. Review `git status` after installing or updating either. WordPress core remains managed by each development environment.

Activate the agreed theme and plugins in each local dashboard. Activation status, pages, posts, menus, users, and settings live in the database. Layout and style changes made in WordPress's Site Editor can also live in the database; committing PHP and CSS files does not copy them. Uploaded images are separate files. A fresh clone provides the code, but matching the complete site also requires a database and uploads snapshot.

Commit reviewed, sanitized snapshots in `database/initial.sql` when the team needs a new shared starting point. Keep raw database exports, credentials, and uploads out of Git. After pulling, review updates before refreshing your local site; directory links make code changes visible immediately.

## Shared database snapshot

`database/initial.sql` contains the initial prototype content and settings. It has no user accounts, password hashes, sessions, or comments. Each developer creates their own administrator account after importing it. Uploads are not included.

Use snapshots as agreed starting points. Importing one replaces the matching local WordPress tables, including local users and content; it is not a merge. Back up local work first, and do not automatically import snapshots after pulling from Git. Once the site is hosted, its live database becomes the source of truth for content. Deploy code without replacing that database with a development snapshot.

Keep design changes in theme files where possible. WordPress's Site Editor can save templates and styles in the database; exporting those changes into the theme makes them easier to review in Git. SQL snapshots are useful for shared content and settings but are difficult to merge.

### Import with Nix

Start the site with `wp_dev up`. In another terminal with the development environment loaded, run:

```fish
wp_dev cli db export "$PWD/.local/before-snapshot.sql"
wp_dev cli db import "$PWD/database/initial.sql"
wp_dev cli user create developer developer@example.invalid --role=administrator --prompt=user_pass
wp_dev cli option update admin_email developer@example.invalid
```

Replace the example username and email with your own, and enter a new password at the prompt. The first user receives ID 1, which owns the snapshot's starter content. Log in at <http://localhost:8080/wp-admin/>.

### Import with Local

Start the site and open Local's site shell. Back up its current database with `wp db export` to a private location, then run these commands using your repository's absolute path and your own account details:

```sh
wp db import "/absolute/path/to/genvira-website/database/initial.sql"
wp user create developer developer@example.invalid --role=administrator --prompt=user_pass
wp option update admin_email developer@example.invalid
wp search-replace 'http://localhost:8080' 'http://genvira.local' --all-tables-with-prefix --skip-columns=guid
```

Replace `http://genvira.local` with the actual URL shown in Local. On Windows, use a path such as `C:/projects/genvira-website/database/initial.sql`. The snapshot uses the `wp_` table prefix; Local's `wp-config.php` must use that prefix too. The search-replace command handles serialized settings safely.

### Update the snapshot

With the Nix site running, reload the development environment if the snapshot command was just added, then run:

```fish
wp_dev snapshot
```

This copies the twelve standard WordPress tables to a temporary database, sanitizes that copy with `scripts/sanitize-snapshot.sql`, exports it to `database/initial.sql`, and removes the temporary database. The working database is unchanged. Users, comments, private and password protected posts, revisions, and temporary drafts are removed. The remaining posts use author ID 1. Only selected core options and metadata, plus the prototype page and article metadata, are kept; plugin tables and other plugin settings are excluded. Theme settings and widget content are retained.

Review the SQL before committing it. Published content, ordinary drafts, theme settings, and widgets can still contain information you do not want in Git; this is a prototype baseline, not a general anonymizer for a live site. If a plugin needs database data to reproduce the prototype, review and extend the sanitizer deliberately. Coordinate snapshot changes rather than trying to merge independent SQL dumps. Share any required uploads separately.

## Exporting the site

With the Nix site running, export its database:

```fish
wp_dev cli db export "$PWD/wordpress.sql"
```

With Local, use its export feature, or run `wp db export` with an absolute destination path from its site shell. Include the uploaded files when sharing a complete site.

To move between local environments or to another host, restore the database and `wp-content`, then use a WordPress migration tool or WP-CLI search-replace to update the site URL. Plain text replacement can corrupt serialized settings. The destination needs its own configuration and secrets.

## Browser checks

Start the WordPress site, then enter the browser tools environment in another terminal:

```fish
nix develop .#qa --command fish
chromium --headless --no-sandbox --disable-gpu --remote-debugging-port=9227 --user-data-dir=/tmp/genvira-browser-qa
```

Keep Chromium running. In another terminal with the same QA environment, run:

```fish
node scripts/check-prototype.mjs
```

The checks cover all eleven prototype pages at desktop and mobile widths, the four research articles, menu controls, platform steps, research filtering and search, contact links, the no-JavaScript fallback, and the missing-page response. Screenshots are saved to `/tmp/genvira-prototype-qa`. Stop Chromium when finished.

## Troubleshooting

For the Nix environment, database startup logs are in `.local/mariadb.log`, initialization logs in `.local/db-init.log`, and WordPress debug logs in `wp-content/debug.log`.

If a hard shutdown leaves `.local/running` behind, stop the previous PHP and MariaDB processes before removing that empty directory. The local database and uploads persist across normal restarts.
