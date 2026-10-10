# Changelog

## 0.1.0-1

- Initial release.
- Wraps the published `ghcr.io/toledoem/linxiv-web:0.1.0` image (FastAPI, React SPA and the Rust `linxiv` CLI) with s6-overlay. Published as `ghcr.io/toledoem/linxiv_web-{arch}`.
- Serves the web UI and MCP endpoint on host port 8086 (container port 8000).
- `password` is optional. Without it, the first visitor creates the admin password (first-run setup), which can then be changed in the app. The app generates the session signing key and keeps it in its data directory.
- Options for reverse proxies and app settings: `trusted_proxies`, `cookie_secure`, `hsts`, `remember_days`, `ai_allowed_hosts`, `log_level`.
- Store icon and logo, with dark-theme variants.
- Stores the library database in the add-on's `/config` volume and PDFs in a configurable directory (default `/share/linxiv`).
