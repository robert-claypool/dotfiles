---
schema: v1
id: sa6rxa
title: Migrate dotfiles to a convergent Chezmoi workstation profile
status: closed
type: task
priority: p1
deps: []
tags: []
created_at: "2026-08-05T21:29:34Z"
closed_at: "2026-08-05T22:14:12Z"
---
<!-- ksmem:managed: direct edits bypass validation; use ksmem commands -->
## Context

## Plan

Adopt Chezmoi with this Git checkout as source; preserve separately owned state and secrets; migrate shell, Ghostty, Git/SSH, my.nvim linkage, and curated macOS defaults; provide plan/apply/doctor surfaces; prove rendering and idempotence in an isolated target; review before changing Wasabi; then validate, commit, and push.

## Decisions

## Evidence

## Journal

- 2026-08-05T21:46:20Z | Dogfood friction observed on Wasabi:
- Homebrew Bundle 2026 rejects the legacy --no-lock option; package apply must use brew bundle install --file.
- Chezmoi --destination does not redefine .chezmoi.homeDir; a faithful isolated-home test must also set HOME.
- Chezmoi execute-template has prompt overrides but no --promptDefaults; init is the canonical default-render test.
- A scheduled Ghostty font script that edits the managed base config creates permanent drift; machine-time UI changes belong in the unmanaged Ghostty local overlay.

- 2026-08-05T21:59:18Z | User validation on Wasabi: native Zsh setup feels good and Atuin is working in Ghostty. Interactive PTY smoke test passes, completion audit is clean, and measured startup is ~68 ms.

- 2026-08-05T22:13:00Z | Container runtime decision deliberately deferred. Keystone currently has Docker Compose compatibility needs, so Docker/Colima is the pragmatic front-runner, while Apple container remains an interesting future isolation experiment. No runtime, VM, image store, or dotfiles declaration was added during onboarding.

- 2026-08-05T22:13:56Z | Additional Wasabi dogfood friction: macOS case-insensitive storage preserves an existing directory spelling, so treating macOS/ and macos/ as independent paths can delete the live file. Case-only normalization must rename through a temporary path. Other portability findings: isolate HOME and every XDG directory in Chezmoi tests; .chezmoiroot changes the effective source path, so external repo symlinks need explicit dotfilesDir data; use private_ source attributes to preserve sensitive directory modes; and PATH setup must remove/reinsert entries after path_helper rather than only prepend-if-absent.

## Lessons

- A convergent workstation profile needs explicit ownership boundaries, isolated HOME/XDG validation, and real PTY/runtime checks. Fresh-machine dogfooding exposed tool-version drift, path-helper ordering, private-mode, managed-overlay, completion-security, and case-insensitive-filesystem failures that static migration alone would have missed.
