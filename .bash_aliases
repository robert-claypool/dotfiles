# Alias definitions live in ~/.config/shell/aliases.sh.
# Keep this file as a stable entry point for Bash and for Zsh users who
# (optionally) source ~/.bash_aliases.
# shellcheck disable=SC1090
dotfiles_shell_dir="$HOME/.config/shell"
if [ ! -d "$dotfiles_shell_dir" ]; then
    dotfiles_bash_aliases_target="$(readlink "$HOME/.bash_aliases" 2>/dev/null || true)"
    if [ -n "$dotfiles_bash_aliases_target" ]; then
        dotfiles_shell_dir="$(cd "$(dirname "$dotfiles_bash_aliases_target")" && pwd)/.config/shell"
    fi
fi
[ -f "$dotfiles_shell_dir/aliases.sh" ] && . "$dotfiles_shell_dir/aliases.sh"
unset dotfiles_shell_dir dotfiles_bash_aliases_target

# Put machine- or job-specific aliases (like project paths) in ~/.local_aliases
# (not checked in).
