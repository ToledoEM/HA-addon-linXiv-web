#!/usr/bin/with-contenv bash
# shellcheck shell=bash
set -Eeuo pipefail

# Translates /data/options.json into LINXIV_* env vars, links the PDF directory
# the way the upstream entrypoint.sh does, then starts the linXiv-web server.

OPTIONS_JSON="/data/options.json"
DATA_DIR="/config/data"
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

log "linXiv-web add-on ${LXW_ADDON_VERSION:-unknown} (${LXW_ADDON_ARCH:-$(uname -m)})"

[[ -r "$OPTIONS_JSON" ]] || die "cannot read ${OPTIONS_JSON} (add-on must run as root)"
jq -e . "$OPTIONS_JSON" > /dev/null 2>&1 || die "${OPTIONS_JSON} is not valid JSON"

PDF_PATH_RAW="$(read_opt pdf_path)"
PDF_PATH_RAW="${PDF_PATH_RAW:-$DEFAULT_PDF_PATH}"
PASSWORD="$(read_opt password)"
MAX_UPLOAD_MB="$(read_opt max_upload_mb)"
MAX_UPLOAD_MB="${MAX_UPLOAD_MB:-200}"

TRUSTED_PROXIES="$(read_opt trusted_proxies)"
COOKIE_SECURE="$(read_opt cookie_secure)"
HSTS="$(read_opt hsts)"
REMEMBER_DAYS="$(read_opt remember_days)"
AI_ALLOWED_HOSTS="$(read_opt ai_allowed_hosts)"
LOG_LEVEL="$(read_opt log_level)"

[[ "$MAX_UPLOAD_MB" =~ ^[0-9]+$ ]] || die "max_upload_mb must be a positive integer"
[[ -z "$REMEMBER_DAYS" || "$REMEMBER_DAYS" =~ ^[0-9]+$ ]] || die "remember_days must be a positive integer"

PDF_DIR="$(require_mapped_path "pdf_path" "$PDF_PATH_RAW")"

mkdir -p "$DATA_DIR" || die "cannot create ${DATA_DIR}"
mkdir -p "$PDF_DIR" || die "pdf_path '${PDF_DIR}' does not exist and could not be created"
link_pdf_dir

# Export an optional setting only when set, so linXiv-web keeps its own default.
export_opt() {
    local name="$1"
    local value="$2"
    if [[ -n "$value" ]]; then
        export "${name}=${value}"
    else
        unset "$name"
    fi
}

# Override unconditionally: the upstream image bakes /data and /pdfs into ENV.
export LINXIV_DATA_DIR="$DATA_DIR"
export LINXIV_WEB_DATA_DIR="$DATA_DIR"
export LINXIV_WEB_PDF_DIR="$PDF_DIR"
export LINXIV_WEB_HOST="0.0.0.0"
export LINXIV_WEB_PORT="8000"
export LINXIV_WEB_MAX_UPLOAD_MB="$MAX_UPLOAD_MB"
# linXiv-web generates the session signing key and keeps it in the data dir.
unset LINXIV_WEB_SECRET_KEY
unset LINXIV_WEB_PASSWORD_HASH
# No password: linXiv-web starts in first-run setup and stores the admin
# password the first visitor creates in <data dir>/linxiv-web-auth.json.
export_opt LINXIV_WEB_PASSWORD "$PASSWORD"
export_opt LINXIV_WEB_TRUSTED_PROXIES "$TRUSTED_PROXIES"
export_opt LINXIV_WEB_COOKIE_SECURE "$COOKIE_SECURE"
export_opt LINXIV_WEB_HSTS "$HSTS"
export_opt LINXIV_WEB_REMEMBER_DAYS "$REMEMBER_DAYS"
export_opt LINXIV_WEB_AI_ALLOWED_HOSTS "$AI_ALLOWED_HOSTS"
export_opt LINXIV_WEB_LOG_LEVEL "$LOG_LEVEL"

log "Configuration summary:"
log "  data_dir=${DATA_DIR}"
log "  pdf_path=${PDF_DIR}"
log "  max_upload_mb=${MAX_UPLOAD_MB}"
if [[ -n "$PASSWORD" ]]; then
    log "  password=set in add-on configuration"
else
    log "  password=not set (first-run setup or password stored by the app)"
fi
log "  trusted_proxies=${TRUSTED_PROXIES:-<none>}"
log "  cookie_secure=${COOKIE_SECURE:-false}"
log "  hsts=${HSTS:-false}"
log "  remember_days=${REMEMBER_DAYS:-90}"
log "  ai_allowed_hosts=${AI_ALLOWED_HOSTS:-<any>}"
log "  log_level=${LOG_LEVEL:-info}"

cd /app/server
exec python -m app
