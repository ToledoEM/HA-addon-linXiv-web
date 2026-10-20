# Wraps the published linXiv-web image (FastAPI + React SPA + Rust linxiv CLI,
# built by the linXiv-web repo's CI for amd64/arm64) with s6-overlay so the HA
# Supervisor can run it. The upstream image is Debian (python:3.11-slim), not an
# HA base image, so s6-overlay is installed here.

# linXiv-web release to wrap. Tracked separately from BUILD_VERSION so the
# add-on can carry its own revision suffix (e.g. 0.1.0-1). Bump alongside
# config.yaml and build.yaml.
ARG UPSTREAM_VERSION=0.1.2

FROM ghcr.io/toledoem/linxiv-web:${UPSTREAM_VERSION}

# Defaulted so a bare `docker build` works; pr-check.yaml passes only
# BUILD_FROM/BUILD_ARCH, and the HA builder injects both of these itself.
ARG BUILD_ARCH=amd64
ARG BUILD_VERSION=0.1.2-1
ARG S6_OVERLAY_VERSION=3.2.0.2

ENV LXW_ADDON_VERSION=${BUILD_VERSION} \
    LXW_ADDON_ARCH=${BUILD_ARCH}

# Supervisor mounts /data, /config and /share root-owned, so drop the upstream
# non-root appuser.
# hadolint ignore=DL3002
USER 0

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends bash curl jq xz-utils ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install s6-overlay, mapping BUILD_ARCH to the s6-overlay release architecture.
RUN set -eux; \
    case "${BUILD_ARCH}" in \
      amd64) S6_ARCH="x86_64" ;; \
      aarch64) S6_ARCH="aarch64" ;; \
      *) echo "Unsupported BUILD_ARCH for s6-overlay: ${BUILD_ARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/s6-overlay-noarch.tar.xz \
      "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz"; \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz; \
    curl -fsSL -o /tmp/s6-overlay-arch.tar.xz \
      "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz"; \
    tar -C / -Jxpf /tmp/s6-overlay-arch.tar.xz; \
    rm -f /tmp/s6-overlay-noarch.tar.xz /tmp/s6-overlay-arch.tar.xz; \
    ln -s /command/with-contenv /usr/bin/with-contenv

COPY run.sh /run.sh
COPY rootfs /

RUN chmod +x /run.sh \
    && chmod +x /etc/s6-overlay/s6-rc.d/linxiv_web/run \
    && chmod +x /etc/s6-overlay/s6-rc.d/linxiv_web/finish

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="addon" \
  io.hass.arch="aarch64|amd64"

# hadolint ignore=DL3025
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -fsS http://127.0.0.1:8000/api/health || exit 1

WORKDIR /app/server

ENTRYPOINT ["/init"]
CMD []
