# OpenClaw WhatsApp Channel Fix

Repair tool for broken WhatsApp channel configuration in OpenClaw.

Sometimes manual edits to `openclaw.json` (especially `channels` or `web` sections) can break the WhatsApp integration and cause errors such as:

Channel login failed: Channel is required (no configured channels detected)

or:

whatsapp default: configured but not linked

This script safely resets the configuration so OpenClaw can recreate the channel automatically.

## What the script does

- Creates a backup of `~/.openclaw/openclaw.json`
- Removes manual `channels` and `web` configuration blocks
- Runs `openclaw doctor`
- Stops any running OpenClaw processes

After running the script you can re-link WhatsApp normally.

## Installation

Clone the repository:

```bash
git clone https://github.com/YOURNAME/openclaw-whatsapp-fix.git
cd openclaw-whatsapp-fix
