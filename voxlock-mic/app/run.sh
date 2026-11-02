#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
here="$(cd "$(dirname "$0")" && pwd)"
log="$HOME/Library/Logs/voxlock-mic.log"
mkdir -p "$(dirname "$log")"
if ! command -v uv >/dev/null; then
  echo "$(date '+%F %T') uv not found: brew install uv" >> "$log"
  exit 1
fi
exec uv run --script "$here/voxlock-mic" --tray >> "$log" 2>&1
