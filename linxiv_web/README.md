# linXiv-web for Home Assistant

linXiv-web is a self-hosted paper library. You can search and import papers from arXiv, bioRxiv and PubMed, read and annotate the PDFs, keep notes and projects, and browse the citation graph. This add-on runs [linXiv-web](https://github.com/ToledoEM/linXiv-web) (Apache-2.0) on your Home Assistant instance.

## Installation

1. In Home Assistant, go to Settings > Add-ons > Add-on Store.
2. Open the `···` menu and choose Repositories.
3. Add `https://github.com/ToledoEM/HA-addon-linXiv-web`.
4. Find linXiv-web in the store and install it.
5. Optional: on the Configuration tab, set a password.
6. Start the add-on and open `http://<your-HA-IP>:8086`. Without a configured password, the first visitor creates the admin password.

## Configuration

| Option | Default | Description |
| -------- | --------- | ------------- |
| `pdf_path` | `/share/linxiv` | PDF directory. Must be under `/share`, `/media` or `/config`. |
| `password` | *(none)* | Web UI login password. Optional; empty means first-run setup in the browser. |
| `max_upload_mb` | `200` | Largest single upload or import, in MB. |
| `trusted_proxies` | *(none)* | Reverse proxy IPs or CIDRs whose `X-Forwarded-For` is trusted. |
| `cookie_secure` | `false` | Login cookie over HTTPS only. |
| `hsts` | `false` | Send `Strict-Transport-Security`. HTTPS only. |
| `remember_days` | `90` | "Remember me" session lifetime, in days. |
| `ai_allowed_hosts` | *(any)* | Hosts the OpenAI-compatible AI base URL may use. |
| `log_level` | `info` | `debug`, `info`, `warning` or `error`. |

API keys (Gemini, OpenAI, Anthropic, NCBI) and the polite-pool contact emails go in the app itself, under Settings > Contacts & API keys.

[DOCS.md](DOCS.md) covers where data is stored, backups and MCP access.

## Support

- Add-on issues: [github.com/ToledoEM/HA-addon-linXiv-web](https://github.com/ToledoEM/HA-addon-linXiv-web/issues)
- Application: [github.com/ToledoEM/linXiv-web](https://github.com/ToledoEM/linXiv-web)
- linXiv CLI: [github.com/linxiv-dev/linXiv](https://github.com/linxiv-dev/linXiv)
