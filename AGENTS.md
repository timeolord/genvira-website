# Repository instructions

Read the README before changing the development or deployment workflow.

## Change log

For every repository change, append an entry to the root `changelog.txt` and include it in the same commit. This applies to code, content, artwork, configuration, and documentation.

Use `YYYY-MM-DDTHH:MM:SSZ | description`, with the actual current UTC time from `date -u '+%Y-%m-%dT%H:%M:%SZ'`. Write one concise line per cohesive change, describing the result and relevant verification when applicable. Keep entries in chronological order and preserve previous entries. Do not invent timestamps or include private data in the log.

## Development preferences

Use Nix for dependencies, keep `flake.nix` and `flake.lock` current, and keep `.envrc` set to `use flake`. Use fish for shell commands and scripts. Keep functions concise, prefer functional patterns, and use snakecase names. Comments should be lowercase, informal, concise, and contain no dashes. Prefer Rust, Zig, or Haskell when introducing a new tool where appropriate; use constructors instead of default values in Zig. Keep the existing WordPress PHP, CSS, JavaScript, and SVG implementation where appropriate.

Use plain prose without em dashes, emojis, or unnecessary bold formatting.

## WordPress and publishing

Keep theme and shared artwork changes under `wp-content/themes/genvira`. Update the README when behavior or setup changes, and refresh relevant saved previews when artwork changes.

WordPress content and settings live in the database. Refresh and review the sanitized `database/initial.sql` snapshot when changing them. Seed HTML changes must also be applied to WordPress before taking the snapshot; avoid overwriting unrelated editorial work. Never commit raw database exports, credentials, or local state.

Run checks appropriate to the change. Use desktop and mobile previews for visual changes and static-export validation when export behavior changes. Documentation-only changes need link and diff checks, without rebuilding the website.

Pushing `main` automatically deploys the static prototype through GitHub Actions. Preserve the `/genvira-website/` deployment path and inherited domain configuration. The personal domain is temporary during prototyping; deployment belongs entirely to this repository. Do not modify the personal website or add integration steps for it. Do not stop an existing local development server unless you started it or the user asks you to.

Preserve unrelated user files. The untracked `old-website/` directory is reference material; do not stage it wholesale.
