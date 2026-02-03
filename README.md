# dotfiles

My dotfiles, except for [my.nvim](https://github.com/robert-claypool/my.nvim).

## Setup

1. Clone this repository:
   ```
   git clone https://github.com/robert-claypool/dotfiles.git
   cd dotfiles
   ```

2. Run the bootstrap script:
   ```
   ./bootstrap.sh
   ```

   This script will:
   - Set up symbolic links for various config files
   - Install tools on macOS (Homebrew Bundle via `Brewfile`)
   - Install tools on Omarchy/Arch (pacman)
   - Configure Ghostty (and install `ghostty@tip` by default on macOS)
   - Set up Git defaults (and optional identity prompts)

3. Install and configure Zsh (if not already installed)

4. Install additional tools and plugins

## Zsh configuration

The .zshrc file is already set up with various plugins and configurations. After running the bootstrap
script, you'll need to install Oh My Zsh:

1.  **Install Oh My Zsh:** Follow instructions at [ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh#basic-installation).

2.  **Install Plugins & Tools:** The `bootstrap.sh` script automatically installs necessary Zsh plugins (like `zsh-syntax-highlighting` and `you-should-use`) and tools (like `fzf` and `zoxide`).

## Enhanced Shell Interaction

This setup uses [Starship](https://starship.rs/) for a fast, powerful, and highly-configurable prompt. It has been configured for a more intuitive command-line experience.

### Vi Mode Command Line Editing

Vim keybindings are enabled for the command line.
- Press `Esc` to enter **Normal Mode**. You can use Vim motions like `b`, `w`, `0`, `$` to navigate.
- Press `i` or `a` to enter **Insert Mode** for typing.
- The prompt will display `(N)` for Normal mode and `(I)` for Insert mode, provided by Starship.

### Smarter History Search

History search has been improved to be less disruptive:
- **Up-Arrow**: Cycles through your normal shell history (classic behavior).
- **`Ctrl-R`**: Opens Atuin's history search UI (synced history).

### Ghostty channel (macOS)

By default, `./bootstrap.sh` installs `ghostty@tip` (nightly). To use stable instead:

```bash
DOTFILES_GHOSTTY_CHANNEL=stable ./bootstrap.sh
```

## Quality gates

Run `bin/check` from the repo root.

## Additional notes

- The .zshrc file includes configurations for various tools and languages. Make sure to install the
  relevant tools as needed (e.g., Node.js, Python, Ruby, Go, etc.).
- Shared shell config (env/aliases/functions) lives in `~/.config/shell/` with local-only overrides in
  `~/.local_aliases` (not checked in).
- Git configuration is set up by the bootstrap script. Review and adjust the settings as needed.
- This setup includes configurations for Docker, Rancher Desktop, Neovim, NVM, kubectl, Angular CLI,
  and Terraform. Ensure you have these tools installed if you plan to use them.
- The FZF configuration uses ripgrep (rg) for file searching. Make sure to install ripgrep for optimal
  performance.

For any issues or questions, please open an issue in this repository.
