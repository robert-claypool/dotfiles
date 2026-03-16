---
schema: v1
id: dotfiles-4px
title: Investigate Ghostty instability with Claude Code
status: closed
type: task
priority: p2
deps: []
tags: []
created_at: "2026-01-10T19:49:18Z"
closed_at: "2026-02-02T23:12:51Z"
---
## Context

Two issues when Ghostty becomes unstable (possibly triggered by Claude Code TUI): 1) Tab auto-switching to last tab in a loop, 2) Scroll buffer snapping back to bottom. macOS Sequoia 15.6.1, M2 Max.

## Plan

## Decisions

## Evidence

## Journal

- 2026-01-10T19:50:26Z | rc: Research findings - Issue 2 (scroll snap-back) is a KNOWN Claude Code bug: - Issue #826 (498+ thumbs up): Scroll flashes to top and back every keystroke when history is long - Issue #9935: 4000-6700 scroll events/second causing jitter - Issue #1413: Jump to top then slow scroll down with long history - Issue #16040: Scrolls through entire history repeatedly on new prompt This affects ALL terminals (iTerm2, VS Code, Warp, Ghostty, tmux). Not Ghostty-specific.
- 2026-01-10T19:52:10Z | rc: More Claude+Ghostty specific issues found: - #5939: Ghostty tab freezes with Claude after git commits (CLOSED) - #8421: Terminal flashes when Ghostty backgrounded (confirmed Claude bug) - #9658: Multiple Claude instances spawning, terminal flicker (v2.0.14-2.0.19) Issue 1 (tab auto-switching) - NOT FOUND in any tracker. Closest matches: - focus-follows-mouse bug (Ghostty #3229) but user doesn't have this enabled - Could be unique/unreported interaction between Claude's TUI and Ghostty tabs NEXT: Reproduce and report if still occurring
- 2026-01-10T20:36:07Z | rc: Current setup: - Ghostty 1.2.3 (latest stable, installed via brew cask, auto-updates) - macOS Sequoia 15.6.1, M2 Max Waiting for upstream fixes: - Scroll snap-back: Claude Code issue #826, #9935 (assigned to chrislloyd@anthropic) - Tab auto-switching: Not yet reported - need reproduction steps To retest: 1. Check Claude Code changelog for scroll/rendering fixes 2. Check Ghostty releases for TUI/tab focus fixes 3. If tab issue recurs, capture: Activity Monitor state, recent actions, whether killing Claude fixes it
- 2026-01-11T00:11:15Z | rc: CRASH ANALYSIS (actually a hang): - Event: hang, Duration: 1756s (29 min) - Footprint: 194.54 GB on 32GB machine (!!) - Main thread deadlocked in __ulock_wait2 - Trigger: _windowBecameVisible notification handler in Ghostty Root cause: Claude Code scroll event flood → massive scrollback buffer → memory exhaustion → Ghostty hangs when processing window visibility changes This explains the tab switching issue: when trying to switch tabs, Ghostty processes window visibility notifications, but the memory-starved process deadlocks. MITIGATION: Reduce scrollback-limit from 10000000 to something sane like 50000
- 2026-01-11T02:08:57Z | rc: Bug report posted to anthropics/claude-code#9935. Config fix applied: scrollback-limit reduced to 50K.
- 2026-02-02T20:22:38Z | Robert Claypool: Follow-up: user wants to move to Ghostty nightly to access upcoming features (accepting stability tradeoff). Consider documenting/install option in bootstrap.

## Lessons

- None
