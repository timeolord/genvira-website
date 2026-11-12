# WordPress prototyping

Nix provides WordPress, PHP, MariaDB, and WP-CLI. PHP serves the website; MariaDB stores pages, settings, and user accounts. Everything runs as your user with local project data. No system services are needed.

## Start

From this directory, make the flake and scripts visible to Nix, then enter the environment:

```fish
git add flake.nix scripts .envrc
nix develop --command fish
wp_dev up
```

With direnv and its fish integration enabled, use `direnv allow` instead of `nix develop --command fish`. The `.envrc` contains `use flake`.

Open <http://localhost:8080> and complete the WordPress installer. Choose your administrator username and password. Keep the terminal open while working; press Ctrl+C to stop PHP and MariaDB. Run `wp_dev up` again to resume with your existing data.

The first Nix invocation generates `flake.lock`; commit it so everyone gets the same package versions. WordPress core comes from the locked Nix package and is copied into `.local/wordpress` on each start. Update core through Nix rather than the WordPress dashboard. Installed plugins and themes have their own versions; track those in Git.

## Working on the site

Edit themes in `wp-content/themes` and plugins in `wp-content/plugins`. You can also install them from the dashboard. Uploaded images live in `wp-content/uploads`; the database lives in `.local/mariadb`. Both persist across restarts and are ignored by Git.

In a second terminal with the same Nix environment, run WordPress commands with:

```fish
wp_dev cli plugin list
```

Database startup logs are in `.local/mariadb.log`; WordPress debug logs are in `wp-content/debug.log`. If a hard shutdown leaves `.local/running` behind, check that the previous PHP and MariaDB processes have stopped before removing that empty directory.

The PHP development server listens on localhost, and MariaDB accepts only local socket connections. The database uses local development credentials. This setup is for local prototyping.

## Moving the site

With the site running, export the database:

```fish
wp_dev cli db export "$PWD/wordpress.sql"
```

Back up that file along with `wp-content`, which contains themes, plugins, and uploads. Restore them using the destination host's instructions. Use a migration tool or WP-CLI search-replace to change `http://localhost:8080` to the destination URL; plain text replacement can corrupt serialized settings. The destination needs its own WordPress configuration and secrets.
