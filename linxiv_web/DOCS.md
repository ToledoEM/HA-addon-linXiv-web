# linXiv documentation

## Installation

1. In Home Assistant, go to Settings > Add-ons > Add-on Store, open the `⋮` menu, choose Repositories and paste `https://github.com/ToledoEM/HA-addon-linXiv-web`.
2. Install linXiv from the store.
3. Set a password on the Configuration tab. The add-on will not start without one.
4. Start the add-on and open `http://<your-ha-host>:8086`.

## Networking

The app listens on port `8000` inside the container, and Home Assistant publishes it on host port `8086`. You can change the host port in the add-on's Network settings. Traffic is plain HTTP, so keep it on your LAN.

MCP clients connect to `http://<your-ha-host>:8086/mcp`. Create the bearer token in the app under Settings > MCP server.

## Configuration options

| Option | Required | Default | Description |
| -------- | ---------- | --------- | ------------- |
| `pdf_path` | Yes | `/share/linxiv` | PDF directory. Must be a sub-directory of `/share`, `/media` or `/config`. Created if missing. |
| `password` | Yes | *(none)* | Web UI login password. |
| `max_upload_mb` | Yes | `200` | Largest single PDF or backup upload or import, in MB. |

## Data and backups

| What | Where | In HA backups |
|------|-------|---------------|
| Library database (`papers.db`), app settings, caches | `/addon_configs/<repo>_linxiv_web/data` (`/config/data` in the container) | Yes |
| Session signing key | `/config/.secret_key` | Yes |
| PDFs | `pdf_path` (default `/share/linxiv`) | Only if `pdf_path` is under `/config` |

You can reach `/share/linxiv` through the Samba add-on. Keep the database on local disk. PDFs can sit on network storage mounted under `/share` or `/media`.

The app has its own backup and restore under Settings > Backup.

## Changing `pdf_path`

At start the add-on links `<data>/pdfs` to `pdf_path`. To move existing PDFs, stop the add-on, move the files into the new directory, change `pdf_path` and start the add-on again.
