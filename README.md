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
script, you'll need to install Oh My Zsh and the required plugins:

1. Install [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh#basic-installation)

2. Install the following plugins:
   - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
   - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
   - [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
   - [zsh-completions](https://github.com/zsh-users/zsh-completions)

3. Install [Spaceship prompt](https://github.com/spaceship-prompt/spaceship-prompt)

4. Install additional tools:
   - [fzf](https://github.com/junegunn/fzf)
   - [zoxide](https://github.com/ajeetdsouza/zoxide)

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