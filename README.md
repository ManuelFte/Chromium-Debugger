# Chromium Debugger

Bash script to launch a Chromium profile for debugging.

## Usage

```bash
chrumdebug.sh [<keyword>] \
  [-p|--port <port>] \
  [-nrd|--no-remote-debugging] \
  [-rdp|--remote-debugging-port <port>] \
  [-rd|--random] \
  [-h|--help]
```

## Behavior

- **Without any arguments**: opens http://localhost:8080/
- **`<keyword>`**: opens one of the predefined dev server ports (see keyword list below)
- **`-p|--port <port>`**: opens a custom port (overrides the previous setting)
- **Remote debugging**: enabled by default as `--remote-debugging-port=9222`
  - Disable with `-nrd` or `--no-remote-debugging`
  - Customize with `-rdp <port>` or `--remote-debugging-port <port>`
- **Profile**:
  - Default: uses/creates a persistent profile at `~/.config/chromium-debugger`
  - `-rd` or `--random`: use a random, temporary profile under `~/.config` (auto-cleaned on exit)

## Keywords → Ports

| Keyword | Port |
|---------|------|
| `react`, `next`, `remix` | 3000 |
| `angular`, `ng` | 4200 |
| `vite`, `svelte`, `sveltekit` | 5173 |
| `storybook`, `sb` | 6006 |
| `gatsby` | 8000 |
| `react-native`, `rn`, `metro` | 8081 |
| `parcel` | 1234 |
| `vue`, `webpack`, `wds` | 8080 |

## Examples

```bash
# Launch with Next.js defaults (port 3000)
chrumdebug.sh next

# Custom port
chrumdebug.sh -p 3000

# Remix with custom remote debugging port
chrumdebug.sh remix -rdp 9333

# Disable remote debugging
chrumdebug.sh -nrd

# Use temporary profile
chrumdebug.sh -rd
```

## Options

- `-h`, `--help`: Show help message
- `-p <port>`, `--port <port>`: Specify custom port number
- `-nrd`, `--no-remote-debugging`: Disable remote debugging
- `-rdp <port>`, `--remote-debugging-port <port>`: Set custom remote debugging port (default: 9222)
- `-rd`, `--random`: Use random temporary profile instead of persistent profile
