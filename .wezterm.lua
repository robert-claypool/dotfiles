-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- Create a configuration table
local config = {}

-- Use OpenGL for GPU acceleration
config.front_end = "OpenGL"

-- Font configuration with ligatures and Nerd Font support
config.font = wezterm.font_with_fallback({
  "RobotoMono Nerd Font Mono",
  "JetBrainsMono Nerd Font",
})
config.font_size = 20.0
config.harfbuzz_features = {"calt=0", "clig=0", "liga=1"}

-- Color scheme inspired by your preferences
config.colors = {
  foreground = "#EBEBEB",
  background = "#001529", -- Navy blue / near-black background
  cursor_bg = "#FFFFFF",
  cursor_border = "#FFFFFF",
  cursor_fg = "#000000",
  selection_bg = "#4D4D4D",
  selection_fg = "#FFFFFF",

  ansi = {"#0D0D0D", "#FC3F42", "#67D637", "#FFC620", "#2697FF", "#C870CC", "#00C2D3", "#EBEBEB"},
  brights = {"#6D7070", "#FF4352", "#B8E466", "#FFD750", "#3A5CFF", "#A578EA", "#03C89C", "#FEFEF8"},
}

-- Enable live configuration reload
config.automatically_reload_config = true

-- Hide mouse cursor when typing
config.hide_mouse_cursor_when_typing = true

-- Enable smooth scrolling and true color support
config.enable_scroll_bar = true
config.scrollback_lines = 10000

-- Window settings
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Clipboard integration
config.enable_wayland = false
config.use_ime = true

-- Return the configuration to WezTerm
return config
