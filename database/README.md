# Prototype snapshot

`initial.sql` was generated on 12 November 2026 from the local WordPress 7.1.4 prototype at `http://localhost:8080` using `wp_dev snapshot`.

It includes eleven Genvira prototype pages and four research updates, with the `genvira` theme selected and no plugins active. Existing WordPress starter records are preserved. Page summaries and prototype article metadata are retained so the restored theme and research archive work immediately.

Users, password hashes, sessions, comments, private posts, and nonapproved settings are excluded. Uploads are not included. Each developer creates a local administrator after import; the first account receives ID 1, which owns the sanitized content.

See the root README for backup, import, account creation, and snapshot update instructions. Import only into a local prototype database you intend to replace. Do not import this snapshot into a live website as part of a code deployment.
