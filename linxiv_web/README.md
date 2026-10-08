# linXiv for Home Assistant

linXiv is a self-hosted paper library. You can search and import papers from arXiv, bioRxiv and PubMed, read and annotate the PDFs, keep notes and projects, and browse the citation graph. This add-on runs [linXiv-web](https://github.com/ToledoEM/linXiv-web) (Apache-2.0) on your Home Assistant instance.

## Installation

1. In Home Assistant, go to Settings > Add-ons > Add-on Store.
2. Open the `···` menu and choose Repositories.
3. Add `https://github.com/ToledoEM/HA-addon-linXiv-web`.
4. Find linXiv in the store and install it.
5. On the Configuration tab, set a password.
6. Start the add-on and open `http://<your-HA-IP>:8086`.

## Configuration

| Option | Default | Description |
| -------- | --------- | ------------- |
| `pdf_path` | `/share/linxiv` | PDF directory. Must be under `/share`, `/media` or `/config`. |
| `password` | *(none)* | Web UI login password. Required. |
| `max_upload_mb` | `200` | Largest single upload or import, in MB. |

API keys (Gemini, OpenAI, Anthropic, NCBI) and the polite-pool contact emails go in the app itself, under Settings > Contacts & API keys.

[DOCS.md](DOCS.md) covers where data is stored, backups and MCP access.

## Support

- Add-on issues: [github.com/ToledoEM/HA-addon-linXiv-web](https://github.com/ToledoEM/HA-addon-linXiv-web/issues)
- Application: [github.com/ToledoEM/linXiv-web](https://github.com/ToledoEM/linXiv-web)
- linXiv CLI: [github.com/linxiv-dev/linXiv](https://github.com/linxiv-dev/linXiv)
