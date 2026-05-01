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

## Evidence

## Journal

## Lessons
