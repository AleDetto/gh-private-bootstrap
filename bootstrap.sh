#!/bin/bash
set -euo pipefail

# ==============================
# CHECK VARIABILI
# ==============================
if [ -z "${PAT:-}" ] || [ -z "${USER:-}" ] || [ -z "${REPO:-}" ] || [ -z "${TAG:-}" ] || [ -z "${FILE:-}" ]; then
    echo "Errore: devi impostare le seguenti variabili d'ambiente:"
    echo "PAT=... USER=... REPO=... TAG=... FILE=... bash -c \"\$(curl -fsSL https://link-al-tuo-bootstrap.sh)\""
    exit 1
fi

# ==============================
# PREPARAZIONE CARTELLA TEMP
# ==============================
WORKDIR="bootstrap_tmp"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# ==============================
# TROVA ASSET ID TRAMITE GITHUB API
# ==============================
echo "Cerco $FILE nella release $TAG del repo $USER/$REPO..."
ASSET_ID=$(curl -s -H "Authorization: token $PAT" \
  "https://api.github.com/repos/$USER/$REPO/releases/tags/$TAG" \
  | grep "\"name\": \"$FILE\"" -B 3 \
  | grep '"id":' \
  | head -n1 \
  | awk '{print $2}' \
  | tr -d ',')

if [ -z "$ASSET_ID" ]; then
    echo "Errore: asset $FILE non trovato nella release $TAG"
    exit 1
fi

# ==============================
# SCARICO ASSET CON RESUME
# ==============================
echo "Scarico $FILE con ID $ASSET_ID (resume automatico)..."
curl -C - -L -H "Authorization: token $PAT" \
     -H "Accept: application/octet-stream" \
     "https://api.github.com/repos/$USER/$REPO/releases/assets/$ASSET_ID" \
     -o "$FILE"

echo "$FILE scaricato con successo!"

# ==============================
# LANCIO FILE SE ESEGUIBILE
# ==============================
if [[ -x "$FILE" ]]; then
    echo "Eseguo $FILE..."
    ./"$FILE"
else
    echo "Attenzione: $FILE non è eseguibile. Scaricato solo il file."
    chmod +x $FILE
fi
