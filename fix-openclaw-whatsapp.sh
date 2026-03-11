#!/usr/bin/env bash
set -euo pipefail

OPENCLAW_BIN="${OPENCLAW_BIN:-$HOME/.npm-global/bin/openclaw}"
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
BACKUP_DIR="$HOME/.openclaw/backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/openclaw.json.backup-$TIMESTAMP"

echo "========================================"
echo " OpenClaw WhatsApp Channel Repair Tool"
echo "========================================"
echo

if [[ ! -x "$OPENCLAW_BIN" ]]; then
  echo "ERROR: openclaw CLI not found:"
  echo "  $OPENCLAW_BIN"
  exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "ERROR: openclaw.json not found:"
  echo "  $CONFIG_FILE"
  exit 1
fi

mkdir -p "$BACKUP_DIR"
cp "$CONFIG_FILE" "$BACKUP_FILE"

echo "Backup saved:"
echo "  $BACKUP_FILE"
echo

python3 - <<'PY'
import json
import os

config_path = os.path.expanduser("~/.openclaw/openclaw.json")

with open(config_path) as f:
    data = json.load(f)

removed = []

for k in ["channels", "web"]:
    if k in data:
        del data[k]
        removed.append(k)

with open(config_path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")

if removed:
    print("Removed keys:")
    for r in removed:
        print(" -", r)
else:
    print("No manual channel configuration found.")
PY

echo
echo "Running OpenClaw doctor..."
"$OPENCLAW_BIN" doctor || true

echo
echo "Stopping existing OpenClaw processes..."
pkill -f openclaw || true

echo
echo "Repair complete."
echo
echo "Next steps:"
echo
echo "1) Start gateway:"
echo "   $OPENCLAW_BIN gateway"
echo
echo "2) Login WhatsApp channel:"
echo "   $OPENCLAW_BIN channels login --channel whatsapp"
echo
echo "3) Check status:"
echo "   $OPENCLAW_BIN channels list"
echo
