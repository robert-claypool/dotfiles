# dotfiles

My dotfiles, except for [my.nvim](https://github.com/robert-claypool/my.nvim).

1. `cd` into this directory, then run `./bootstrap.sh`
2. Configure Zsh
3. Set up Yabai and skhd (for macOS only)

## Zsh configuration

[Install Zsh](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH)
and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh#basic-installation),
then the following plugins and themes:

### spaceship

https://github.com/denysdovhan/spaceship-zsh-theme

### autojump

https://github.com/wting/autojump

### zsh-syntax-highlighting

https://github.com/zsh-users/zsh-syntax-highlighting

### zsh-autosuggestions

https://github.com/zsh-users/zsh-autosuggestions

### zsh-history-substring-search

https://github.com/zsh-users/zsh-history-substring-search

### zsh-completions

https://github.com/zsh-users/zsh-completions

### h

https://github.com/paoloantinori/hhighlighter

## Yabai and skhd setup (macOS only)

The `bootstrap.sh` script will automatically set up Yabai and skhd if you're on
macOS. This includes:

1. Installing Yabai and skhd via Homebrew
2. Creating symlinks for Yabai and skhd configs
3. Setting up launch agents for Yabai and skhd
4. Creating a sudoers file for Yabai's scripting addition

After running `bootstrap.sh`, you may need to:

1. Restart your computer to ensure all changes take effect
2. Enable the Yabai scripting addition by running:
   ```
   sudo yabai --install-sa
   ```
3. If you encounter any issues with Yabai, check the system logs or
   run `yabai --verbose --debug-output` for more information

Note: Yabai requires System Integrity Protection (SIP) to be partially disabled
for full functionality. Please refer to the [Yabai
documentation](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
for more information on this process.
