#!/bin/bash
set -euo pipefail

# ==============================
# COLOR DEFINITIONS
# ==============================
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
RESET="\033[0m"

log_info()    { echo -e "${BLUE}[BOOTSTRAP-INFO]${RESET} $1"; }
log_success() { echo -e "${GREEN}[BOOTSTRAP-OK]${RESET} $1"; }
log_warn()    { echo -e "${YELLOW}[BOOTSTRAP-WARN]${RESET} $1"; }
log_error()   { echo -e "${RED}[BOOTSTRAP-ERROR]${RESET} $1"; }

# ==============================
# CHECK VARIABLES
# ==============================
if [ -z "${PAT:-}" ] || [ -z "${USER:-}" ] || [ -z "${REPO:-}" ] || [ -z "${TAG:-}" ] || [ -z "${FILE:-}" ]; then
    log_error "You must set the following environment variables:"
    echo "PAT=... USER=... REPO=... TAG=... FILE=... bash -c \"\$(curl -fsSL https://link-to-your-bootstrap.sh)\""
    exit 1
fi

# ==============================
# CHECK WORKDIR
# ==============================
WORKDIR_DEFAULT="bootstrap_tmp"
if [ -z "${WORKDIR:-}" ]; then
    log_warn "WORKDIR not defined... using default WORKDIR=${WORKDIR_DEFAULT}"
    WORKDIR=$WORKDIR_DEFAULT
fi

# ==============================
# PREPARE TEMP DIRECTORY
# ==============================
log_info "Creating temporary directory: $WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# ==============================
# GET ASSET ID VIA GITHUB API
# ==============================
log_info "Looking for $FILE in release $TAG of repo $USER/$REPO..."
ASSET_ID=$(curl -s -H "Authorization: token $PAT" \
  "https://api.github.com/repos/$USER/$REPO/releases/tags/$TAG" \
  | grep "\"name\": \"$FILE\"" -B 3 \
  | grep '"id":' \
  | head -n1 \
  | awk '{print $2}' \
  | tr -d ',')

if [ -z "$ASSET_ID" ]; then
    log_error "Asset $FILE not found in release $TAG"
    exit 1
fi

# ==============================
# DOWNLOAD ASSET WITH RESUME
# ==============================
log_info "Downloading $FILE with ID $ASSET_ID (automatic resume)..."
curl -C - -L -H "Authorization: token $PAT" \
     -H "Accept: application/octet-stream" \
     "https://api.github.com/repos/$USER/$REPO/releases/assets/$ASSET_ID" \
     -o "$FILE"

log_success "$FILE downloaded successfully!"

# ==============================
# DIVIDER BEFORE EXECUTING FILE
# ==============================
echo -e "\n${BLUE}======================================================${RESET}"
echo -e "${BLUE}=== STARTING EXECUTION OF $FILE ===${RESET}"
echo -e "======================================================\n"

# ==============================
# EXECUTE FILE IF EXECUTABLE
# ==============================
if [[ -x "$FILE" ]]; then
    ./"$FILE"
else
    log_warn "$FILE is not executable. Making it executable..."
    chmod +x "$FILE"
    ./"$FILE"
fi

echo -e "\n${BLUE}======================================================${RESET}"
echo -e "${BLUE}=== FINISHED EXECUTION OF $FILE ===${RESET}"
echo -e "======================================================\n"

log_success "Bootstrap completed successfully!"