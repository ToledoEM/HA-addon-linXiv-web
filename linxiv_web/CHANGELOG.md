# Changelog

## 0.1.3-1

- Update linXiv-web to 0.1.3 (`ghcr.io/toledoem/linxiv-web:0.1.3`). No add-on option changes.
- linXiv-web 0.1.3: optional multi-user mode with per-account libraries and a read-only shared library; Server Admin maintenance operations (find duplicate papers, complete metadata, check PDF files, database backups, clean unused authors, empty trash) run on demand or nightly; settings download and import; built against linXiv v0.7.1.
- In multi-user mode, PDFs of the shared and per-account libraries are stored under `/config/data/libraries`. The nightly maintenance hour follows the Home Assistant time zone.

## 0.1.2-1

- Update linXiv-web to 0.1.2 (`ghcr.io/toledoem/linxiv-web:0.1.2`). No add-on option changes.
- linXiv-web 0.1.1: Add paper and Upload merged into one `/add` page; Library state kept in the URL; DOIs read from PDFs are cleaned before metadata lookup; PDF link downloads are protected against DNS rebinding.
- linXiv-web 0.1.2: Home feed takes several RSS/Atom feeds; Knowledge Graph exports to GraphML and CSV; batch edit on project and reading list pages; redesigned paper page with the PDF beside a details rail.

## 0.1.0-1

- Initial release.
- Wraps the published `ghcr.io/toledoem/linxiv-web:0.1.0` image (FastAPI, React SPA and the Rust `linxiv` CLI) with s6-overlay. Published as `ghcr.io/toledoem/linxiv_web-{arch}`.
- Serves the web UI and MCP endpoint on host port 8086 (container port 8000).
- `password` is optional. Without it, the first visitor creates the admin password (first-run setup), which can then be changed in the app. The app generates the session signing key and keeps it in its data directory.
- Options for reverse proxies and app settings: `trusted_proxies`, `cookie_secure`, `hsts`, `remember_days`, `ai_allowed_hosts`, `log_level`.
- Store icon and logo, with dark-theme variants.
- Stores the library database in the add-on's `/config` volume and PDFs in a configurable directory (default `/share/linxiv`).
