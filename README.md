# linXiv-web Home Assistant add-on

[![Build add-on images](https://github.com/ToledoEM/HA-addon-linXiv-web/actions/workflows/build.yaml/badge.svg)](https://github.com/ToledoEM/HA-addon-linXiv-web/actions/workflows/build.yaml)
[![PR Check](https://github.com/ToledoEM/HA-addon-linXiv-web/actions/workflows/pr-check.yaml/badge.svg)](https://github.com/ToledoEM/HA-addon-linXiv-web/actions/workflows/pr-check.yaml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

This repository packages [linXiv-web](https://github.com/ToledoEM/linXiv-web), a self-hosted paper library, as a Home Assistant add-on.

## Add this repository to Home Assistant

[![Add to Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FToledoEM%2FHA-addon-linXiv-web)

To add it by hand:

1. Go to Settings > Add-ons > Add-on Store.
2. Open the `⋮` menu (top right) and choose Manage add-on repositories.
3. Paste `https://github.com/ToledoEM/HA-addon-linXiv-web`.

## Add-ons

| Add-on | Description |
|--------|-------------|
| [linXiv-web](linxiv_web/) | Paper library for arXiv, bioRxiv and PubMed, with a PDF reader, notes and a citation graph |

## Releasing

`.github/workflows/build.yaml` builds the images when you push a `linxiv_web@<version>` tag or run the workflow by hand, and pushes them to `ghcr.io/toledoem/linxiv_web-{arch}`. When you release, update these together: `version` in `linxiv_web/config.yaml`, `BUILD_VERSION` and `UPSTREAM_VERSION` in the Dockerfile, `build.yaml` and `CHANGELOG.md`.
