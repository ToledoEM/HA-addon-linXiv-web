# Changelog

## 0.1.0-1

- Initial release.
- Wraps the published `ghcr.io/toledoem/linxiv-web:0.1.0` image (FastAPI, React SPA and the Rust `linxiv` CLI) with s6-overlay. Published as `ghcr.io/toledoem/linxiv_web-{arch}`.
- Serves the web UI and MCP endpoint on host port 8086 (container port 8000). A password is required.
- Stores the library database in the add-on's `/config` volume and PDFs in a configurable directory (default `/share/linxiv`).
