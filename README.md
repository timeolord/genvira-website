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

This copies the twelve standard WordPress tables to a temporary database, sanitizes that copy with `scripts/sanitize-snapshot.sql`, exports it to `database/initial.sql`, and removes the temporary database. The working database is unchanged. Users, comments, private and password protected posts, revisions, and temporary drafts are removed. The remaining posts use author ID 1. Only selected core options and metadata are kept; plugin tables and other plugin settings are excluded. Theme settings and widget content are retained.

Review the SQL before committing it. Published content, ordinary drafts, theme settings, and widgets can still contain information you do not want in Git; this is a prototype baseline, not a general anonymizer for a live site. If a plugin needs database data to reproduce the prototype, review and extend the sanitizer deliberately. Coordinate snapshot changes rather than trying to merge independent SQL dumps. Share any required uploads separately.

## Exporting the site

With the Nix site running, export its database:

```fish
wp_dev cli db export "$PWD/wordpress.sql"
```

With Local, use its export feature, or run `wp db export` with an absolute destination path from its site shell. Include the uploaded files when sharing a complete site.

To move between local environments or to another host, restore the database and `wp-content`, then use a WordPress migration tool or WP-CLI search-replace to update the site URL. Plain text replacement can corrupt serialized settings. The destination needs its own configuration and secrets.

## Troubleshooting

For the Nix environment, database startup logs are in `.local/mariadb.log`, initialization logs in `.local/db-init.log`, and WordPress debug logs in `wp-content/debug.log`.

If a hard shutdown leaves `.local/running` behind, stop the previous PHP and MariaDB processes before removing that empty directory. The local database and uploads persist across normal restarts.
