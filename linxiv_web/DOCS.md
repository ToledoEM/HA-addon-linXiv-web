# linXiv-web documentation

## Installation

1. In Home Assistant, go to Settings > Add-ons > Add-on Store, open the `⋮` menu, choose Repositories and paste `https://github.com/ToledoEM/HA-addon-linXiv-web`.
2. Install linXiv-web from the store.
3. Optional: set a password on the Configuration tab.
4. Start the add-on and open `http://<your-ha-host>:8086`. Without a password in the configuration, the first visitor creates the admin password, so open the page straight after the first start.

## Login

With `password` empty, the app stores the admin password created at first-run setup in `/config/data/linxiv-web-auth.json`. You can change it in the app under Settings > Server & data > Login, or log out other sessions there. A password set in the add-on configuration takes priority and is read-only in the app.

Logins survive restarts. The session store and signing key live in `/config/data/linxiv-web-state.db`.

## Networking

The app listens on port `8000` inside the container, and Home Assistant publishes it on host port `8086`. You can change the host port in the add-on's Network settings. Traffic is plain HTTP, so keep it on your LAN.

Only loopback, private LAN and link-local clients are served. Requests from public IP addresses get 403.

Behind a reverse proxy (for example the NGINX or Cloudflared add-ons), list the proxy in `trusted_proxies` so the app sees the real client address for the login throttle and the public-IP check. Add-ons on the Supervisor network use `172.30.32.0/23`. When the proxy serves HTTPS, enable `cookie_secure` and, optionally, `hsts`.

MCP clients connect to `http://<your-ha-host>:8086/mcp`. Create the bearer token in the app under Settings > MCP server.

## Configuration options

| Option | Required | Default | Description |
| -------- | ---------- | --------- | ------------- |
| `pdf_path` | Yes | `/share/linxiv` | PDF directory. Must be a sub-directory of `/share`, `/media` or `/config`. Created if missing. |
| `password` | No | *(none)* | Web UI login password. Empty: first-run setup in the browser. |
| `max_upload_mb` | Yes | `200` | Largest single PDF or backup upload or import, in MB. |
| `trusted_proxies` | No | *(none)* | Comma-separated reverse proxy IPs or CIDRs whose `X-Forwarded-For` is trusted. |
| `cookie_secure` | No | `false` | Send the login cookie over HTTPS only. |
| `hsts` | No | `false` | Send `Strict-Transport-Security` (one year). HTTPS only. |
| `remember_days` | No | `90` | Session lifetime in days when "Remember me" is ticked. |
| `ai_allowed_hosts` | No | *(any)* | Comma-separated hosts the OpenAI-compatible AI base URL may use. Cloud metadata addresses are always refused. |
| `log_level` | No | `info` | `debug`, `info`, `warning` or `error`. |

## Data and backups

| What | Where | In HA backups |
|------|-------|---------------|
| Library database (`papers.db`), app settings, caches | `/addon_configs/<repo>_linxiv_web/data` (`/config/data` in the container) | Yes |
| Admin password (first-run setup), sessions and signing key | `linxiv-web-auth.json`, `linxiv-web-state.db` in `/config/data` | Yes |
| Activity log | `/config/data/logs/activity.jsonl` | Yes |
| PDFs | `pdf_path` (default `/share/linxiv`) | Only if `pdf_path` is under `/config` |

You can reach `/share/linxiv` through the Samba add-on. Keep the database on local disk. PDFs can sit on network storage mounted under `/share` or `/media`.

The app has its own backup and restore under Settings > Backup.

## Changing `pdf_path`

At start the add-on links `<data>/pdfs` to `pdf_path`. To move existing PDFs, stop the add-on, move the files into the new directory, change `pdf_path` and start the add-on again.
