#!/usr/bin/with-contenv bash
# shellcheck shell=bash
set -Eeuo pipefail

# Translates /data/options.json into LINXIV_* env vars, links the PDF directory
# the way the upstream entrypoint.sh does, then starts the linXiv-web server.

OPTIONS_JSON="/data/options.json"
DATA_DIR="/config/data"
SECRET_FILE="/config/.secret_key"
DEFAULT_PDF_PATH="/share/linxiv"

log() {
    echo "[linxiv_web] $*"
}

die() {
    echo "[linxiv_web] ERROR: $*" >&2
    exit 1
}

read_opt() {
    local key="$1"
    jq -er --arg k "$key" '.[$k] // empty' "$OPTIONS_JSON" 2> /dev/null || true
}

normalize_path() {
    local raw="$1"
    if command -v realpath > /dev/null 2>&1; then
        realpath -m "$raw"
        return
    fi

    case "$raw" in
        /*) printf '%s\n' "$raw" ;;
        *) printf '/%s\n' "$raw" ;;
    esac
}

is_allowed_path() {
    case "$1" in
        /share/* | /media/* | /config/*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

require_mapped_path() {
    local label="$1"
    local raw="$2"
    local resolved

    resolved="$(normalize_path "$raw")"
    if ! is_allowed_path "$resolved"; then
        die "${label} '${raw}' resolves to '${resolved}', which is not a sub-directory of /share, /media or /config"
    fi

    printf '%s\n' "$resolved"
}

# linxiv always stores PDFs in <data>/pdfs, so make that a symlink to PDF_DIR.
link_pdf_dir() {
    local link="${DATA_DIR}/pdfs"

    if [[ -L "$link" ]]; then
        ln -sfn "$PDF_DIR" "$link"
    elif [[ -d "$link" ]]; then
        # An empty dir left by an earlier run is safe to replace; files are not.
        rmdir "$link" 2> /dev/null \
            || die "${link} holds files; move them into ${PDF_DIR}, then remove it"
        ln -s "$PDF_DIR" "$link"
    elif [[ -e "$link" ]]; then
        die "${link} exists and is not a directory"
    else
        ln -s "$PDF_DIR" "$link"
    fi
}

log "linXiv add-on ${LXW_ADDON_VERSION:-unknown} (${LXW_ADDON_ARCH:-$(uname -m)})"

[[ -r "$OPTIONS_JSON" ]] || die "cannot read ${OPTIONS_JSON} (add-on must run as root)"
jq -e . "$OPTIONS_JSON" > /dev/null 2>&1 || die "${OPTIONS_JSON} is not valid JSON"

PDF_PATH_RAW="$(read_opt pdf_path)"
PDF_PATH_RAW="${PDF_PATH_RAW:-$DEFAULT_PDF_PATH}"
PASSWORD="$(read_opt password)"
MAX_UPLOAD_MB="$(read_opt max_upload_mb)"
MAX_UPLOAD_MB="${MAX_UPLOAD_MB:-200}"

[[ "$MAX_UPLOAD_MB" =~ ^[0-9]+$ ]] || die "max_upload_mb must be a positive integer"
# linXiv-web refuses to bind off loopback without a password.
[[ -n "$PASSWORD" ]] || die "password is empty; set it in the add-on configuration"

PDF_DIR="$(require_mapped_path "pdf_path" "$PDF_PATH_RAW")"

mkdir -p "$DATA_DIR" || die "cannot create ${DATA_DIR}"
mkdir -p "$PDF_DIR" || die "pdf_path '${PDF_DIR}' does not exist and could not be created"
link_pdf_dir

# Session signing key: persisted so a restart does not change the signing key.
if [[ ! -s "$SECRET_FILE" ]]; then
    (umask 077 && head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n' > "$SECRET_FILE")
fi

# Override unconditionally: the upstream image bakes /data and /pdfs into ENV.
export LINXIV_DATA_DIR="$DATA_DIR"
export LINXIV_WEB_DATA_DIR="$DATA_DIR"
export LINXIV_WEB_PDF_DIR="$PDF_DIR"
export LINXIV_WEB_HOST="0.0.0.0"
export LINXIV_WEB_PORT="8000"
export LINXIV_WEB_MAX_UPLOAD_MB="$MAX_UPLOAD_MB"
LINXIV_WEB_SECRET_KEY="$(cat "$SECRET_FILE")"
export LINXIV_WEB_SECRET_KEY
unset LINXIV_WEB_PASSWORD_HASH
export LINXIV_WEB_PASSWORD="$PASSWORD"

log "Configuration summary:"
log "  data_dir=${DATA_DIR}"
log "  pdf_path=${PDF_DIR}"
log "  max_upload_mb=${MAX_UPLOAD_MB}"

cd /app/server
exec python -m app
