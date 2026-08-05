---
schema: v1
id: dotfiles-7dr
title: Stop [bat warning] from delta by overriding git pager syntax theme
status: closed
type: task
priority: p2
deps: []
tags: []
created_at: "2026-02-09T22:30:54Z"
closed_at: "2026-08-05T22:29:40Z"
---
## Context


## Plan

## Decisions

## Evidence

## Journal


- 2026-08-05T22:29:40Z | Resolved by managing delta.syntax-theme=ansi; the live git diff to delta pipeline emits no Bat warnings.

## Lessons

- Use a portable built-in Delta/Bat syntax theme in convergent dotfiles instead of assuming a separately installed custom theme.
