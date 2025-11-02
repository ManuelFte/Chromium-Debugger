#!/bin/bash
set -euo pipefail

usage() {
  cat <<'EOF'
Chromium Debugger - see README.md for full documentation

Usage: chrumdebug.sh [<keyword>] \
  [-p|--port <port>] \
  [-nrd|--no-remote-debugging] \
  [-rdp|--remote-debugging-port <port>] \
  [-rd|--random] \
  [-h|--help]
EOF
}

keyword=""
mapped_port=""
custom_port=""
port=8080

remote_debug=true
remote_port=9222

use_random_profile=false

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
PERSISTENT_PROFILE="${CONFIG_HOME}/chromium-debugger"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage; exit 0
      ;;
    -p|--port)
      [[ $# -ge 2 ]] || { echo "Error: -p/--port requires a port" >&2; exit 2; }
      [[ "$2" =~ ^[0-9]+$ ]] || { echo "Error: -p/--port must be numeric" >&2; exit 2; }
      custom_port="$2"
      shift 2
      ;;
    -nrd|--no-remote-debugging)
      remote_debug=false
      shift
      ;;
    -rdp|--remote-debugging-port)
      [[ $# -ge 2 ]] || { echo "Error: -rdp/--remote-debugging-port requires a port" >&2; exit 2; }
      [[ "$2" =~ ^[0-9]+$ ]] || { echo "Error: -rdp/--remote-debugging-port must be numeric" >&2; exit 2; }
      remote_port="$2"
      shift 2
      ;;
    -rd|--random)
      use_random_profile=true
      shift
      ;;
    --) shift; break ;;
    -*)
      echo "Error: invalid option '$1'" >&2; usage; exit 2
      ;;
    *)
      if [[ -z "$keyword" ]]; then
        keyword="${1,,}"
        shift
      else
        echo "Error: unexpected extra argument '$1'" >&2; usage; exit 2
      fi
      ;;
  esac
done

case "${keyword}" in
  react|next|remix)        mapped_port=3000 ;;
  angular|ng)              mapped_port=4200 ;;
  vite|svelte|sveltekit)   mapped_port=5173 ;;
  storybook|sb)            mapped_port=6006 ;;
  gatsby)                  mapped_port=8000 ;;
  react-native|rn|metro)   mapped_port=8081 ;;
  parcel)                  mapped_port=1234 ;;
  vue|webpack|wds|"")      mapped_port=8080 ;;
  *)
    echo "Error: unknown keyword '${keyword}'" >&2
    usage; exit 2
    ;;
esac

if [[ -n "$custom_port" ]]; then
  port="$custom_port"
else
  port="${mapped_port}"
fi

if $use_random_profile; then
  mkdir -p "$CONFIG_HOME"
  PROFILE="$(mktemp -d "${CONFIG_HOME}/chromium-debugger.XXXXXX")"
  cleanup() { rm -rf "$PROFILE"; }
  trap cleanup EXIT INT TERM
else
  PROFILE="$PERSISTENT_PROFILE"
  mkdir -p "$PROFILE"
fi

cmd=(chromium --user-data-dir="$PROFILE" "http://localhost:${port}/")
if $remote_debug; then
  cmd+=(--remote-debugging-port="${remote_port}")
fi

exec "${cmd[@]}"
