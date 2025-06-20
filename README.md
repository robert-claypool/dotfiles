# dotfiles

My dotfiles, except for [my.nvim](https://github.com/robert-claypool/my.nvim).

## Setup

1. Clone this repository:
   ```
   git clone https://github.com/your-username/dotfiles.git
   cd dotfiles
   ```

2. Run the bootstrap script:
   ```
   ./bootstrap.sh
   ```

   This script will:
   - Set up symbolic links for various config files
   - Configure macOS-specific settings (if on macOS)
   - Set up Linux-specific configurations (if on Linux)
   - Set up Git configuration

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
- **Up-Arrow**: Type any part of a command, then press the up arrow to cycle through matching commands from your history without clearing the screen. This is provided by `zsh-history-substring-search`.
- **`Ctrl-R`**: Press `Ctrl-R` to activate Atuin's powerful inline history search. It searches your synced history without taking over your full screen.

## macOS-specific setup (Yabai and skhd)

If you're on macOS, the bootstrap script will set up Yabai and skhd. After running the script:

1. Restart your computer to ensure all changes take effect.

2. Enable the Yabai scripting addition:
   ```
   sudo yabai --install-sa
   ```

3. If you encounter issues, check the system logs or run:
   ```
   yabai --verbose --debug-output
   ```

Note: Yabai requires System Integrity Protection (SIP) to be partially disabled for full functionality.
Refer to the [Yabai documentation](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
for more information.

## Additional notes

- The .zshrc file includes configurations for various tools and languages. Make sure to install the
  relevant tools as needed (e.g., Node.js, Python, Ruby, Go, etc.).
- Custom aliases and functions are defined in separate files: ~/.bashrc_shared, ~/.bash_aliases, and
  ~/.local_aliases. Review them to familiarize yourself with available shortcuts.
- Git configuration is set up by the bootstrap script. Review and adjust the settings as needed.
- This setup includes configurations for Docker, Rancher Desktop, Neovim, NVM, kubectl, Angular CLI,
  and Terraform. Ensure you have these tools installed if you plan to use them.
- The FZF configuration uses ripgrep (rg) for file searching. Make sure to install ripgrep for optimal
  performance.

For any issues or questions, please open an issue in this repository.