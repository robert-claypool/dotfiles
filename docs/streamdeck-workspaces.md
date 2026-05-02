# Stream Deck Workspaces

This setup treats Stream Deck buttons as navigation to places, not just app
launchers.

## Commands

Workspace configs live in:

- `.config/workspaces/<name>.sh` for public defaults/examples
- `.config/workspaces/local/<name>.sh` for private machine/account/project data

Useful commands:

```bash
ws list
ws show example
ws chrome example
ws ghostty example 3
ws ghostty example codex
tabtitle EXAMPLE:codex
ghostty-titlebar native
ttylog --name claude-example -- claude
```

## Stream Deck Wiring

Preferred wiring with the installed OSA Script plugin:

```applescript
do shell script "/Users/rc/bin/ws chrome example"
```

```applescript
do shell script "/Users/rc/bin/ws ghostty example 3"
```

Alternative wiring through Hammerspoon:

```text
hammerspoon://ws?workspace=example&target=chrome
hammerspoon://ws?workspace=example&target=ghostty&tab=3
```

The Hammerspoon URL approach is convenient when a Stream Deck action can open a
URL more easily than it can pass command-line arguments.

## Chrome

Use Chrome's `Window > Name Window...` with the same value as
`WS_CHROME_WINDOW`. The command first tries to focus that named living window. If
it does not exist, it opens `WS_CHROME_URLS` in a new Chrome window and names the
front window.

Keep real Chrome profile directories and private URLs in ignored local files.

## Ghostty

Ghostty on macOS does not currently expose direct AppleScript tab/window
objects. The workflow here is:

1. Give each workspace window a clear title.
2. Keep tab positions stable.
3. Use `tabtitle` inside tabs for readable names.
4. Use `ws ghostty <workspace> <tab>` from Stream Deck.

For AI CLI sessions where scrollback is not enough, use `ttylog`:

```bash
ttylog --name claude-folio -- claude
ttylog --name codex-start -- codex
```

Do not use `ttylog --keys` unless you accept that typed secrets may be captured.
