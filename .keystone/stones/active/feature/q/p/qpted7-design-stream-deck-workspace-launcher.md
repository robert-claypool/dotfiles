---
schema: v1
id: qpted7
title: Design Stream Deck workspace launcher
status: open
type: feature
priority: p2
deps: []
tags: [chrome, ghostty, streamdeck]
created_at: "2026-05-01T14:59:23Z"
---
<!-- ksmem:managed: direct edits bypass validation; use ksmem commands -->
## Context

User wants Stream Deck to navigate by workspace/place, not just launch apps: browser profiles/windows, Chrome named windows/tabs, Ghostty windows/tabs, and eventually other terminal apps. Repo is public, so checked-in config should be generic with local private overlays for profile IDs, company/project URLs, and machine-specific details.

## Plan

Explore a project-first launcher design: checked-in scripts under bin/, public workspace examples under .config/workspaces/, ignored local overlays for real profile IDs and private URLs, and Stream Deck buttons/folders that call stable scripts. Prototype START first before generalizing.

## Decisions

Avoid tmux as the default navigation layer for now; use Ghostty-native tabs/windows plus named Chrome windows/profiles. Treat tmux as optional for detached sessions or pane logging only if it pays for its added modality.

Stream Deck calls the stable ws command through the installed OSA Script plugin. Robert retired Hammerspoon in favor of native macOS window management, so the URL bridge, Lua config, and compatibility surface are intentionally removed.

## Evidence

Implemented the workspace toolkit: bin/ws for Chrome/Ghostty workspace focus, bin/tabtitle for terminal title escapes, bin/ghostty-titlebar for ignored local titlebar experiments, bin/ttylog for opt-in CLI session logging, public .config/workspaces/example.sh, and docs/streamdeck-workspaces.md. Stream Deck integration uses direct ws commands through OSA Script; the former Hammerspoon URL bridge was retired in August 2026.

## Journal

- 2026-05-02T07:33:15Z | Next implementation step after this commit: create ignored local workspace configs for real projects (START/FOLIO/etc.), test Chrome named-window focus outside sandbox, test Ghostty titlebar mode readability, then map physical Stream Deck buttons to ws commands.

- 2026-08-07T10:39:56Z | rewrote section decisions (old_lines=3 new_lines=3): Retire the obsolete Hammerspoon integration decision

- 2026-08-07T10:39:56Z | Removed the retired Hammerspoon URL bridge, Lua config, and documentation while preserving the direct ws CLI and OSA Script path. Focused shell checks and CLI smoke checks pass. Open because: physical Stream Deck button mapping and real private workspace validation remain user-driven follow-up.

- 2026-08-07T10:40:01Z | rewrote section evidence (old_lines=1 new_lines=1): Keep evidence aligned with the retired Hammerspoon bridge

## Lessons
