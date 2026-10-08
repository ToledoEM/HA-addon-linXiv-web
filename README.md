# linXiv Home Assistant add-on

[![Build add-on images](https://github.com/ToledoEM/HA-addon-linXiv-web/actions/workflows/build.yaml/badge.svg)](https://github.com/ToledoEM/HA-addon-linXiv-web/actions/workflows/build.yaml)
[![PR Check](https://github.com/ToledoEM/HA-addon-linXiv-web/actions/workflows/pr-check.yaml/badge.svg)](https://github.com/ToledoEM/HA-addon-linXiv-web/actions/workflows/pr-check.yaml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

Home Assistant add-on repository for [linXiv-web](https://github.com/ToledoEM/linXiv-web), a self-hosted paper library with PDF reader, notes and citation graph.

## Add this repository to Home Assistant

[![Add to Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FToledoEM%2FHA-addon-linXiv-web)

Or add manually:

1. **Settings** → **Add-ons** → **Add-on Store**
2. Click ⋮ (top right) → **Manage add-on repositories**
3. Paste `https://github.com/ToledoEM/HA-addon-linXiv-web`

## Add-ons

| Add-on | Description |
|--------|-------------|
| [linXiv](linxiv_web/) | arXiv / bioRxiv / PubMed paper library with PDF reader, notes and citation graph |

## Releasing

Images are built by `.github/workflows/build.yaml` on a `linxiv_web@<version>` tag (or manual dispatch) and pushed to `ghcr.io/toledoem/linxiv_web-{arch}`. Bump `version` in `linxiv_web/config.yaml`, `BUILD_VERSION`/`UPSTREAM_VERSION` in the Dockerfile, `build.yaml` and `CHANGELOG.md` together.
