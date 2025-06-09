#-------------------------------------------------------#------------------------------------------------------------------------------
# Prompt-once key-chain unlock for SSH / Mosh sessions
#
# macOS treats every SSH / Mosh login as “user not present.”  The login
# key-chain stays locked even when you already have an unlocked GUI session,
# so CLI tools that keep tokens there (gh, Claude, AWS, etc.) will prompt.
#
# This block asks for the macOS login password once per remote session and
# tries to unlock login.keychain-db.  Press Enter to skip; the key-chain then
# stays locked and each CLI will fall back to its own /login flow.
#
# Nothing is written to disk or to environment variables; the password lives
# only in a shell variable for a moment and is unset immediately.
#------------------------------------------------------------------------------

# Homebrew path (Intel Macs use /usr/local/bin)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -n "$SSH_CONNECTION" && -t 0 ]]; then
  keychain=$(security login-keychain | tr -d '"' | xargs)

  # --- read password silently, portable bash/zsh ---
  if [[ -n "$ZSH_VERSION" ]]; then
    read -s "?Unlock macOS key-chain – enter login password (or just Enter to skip): " pw
  else
    read -s -p "Unlock macOS key-chain – enter login password (or just Enter to skip): " pw
    echo
  fi
  # -------------------------------------------------

  if [[ -n "$pw" ]] && security unlock-keychain -p "$pw" "$keychain" >/dev/null 2>&1; then
    echo "login.keychain unlocked for this SSH/Mosh session."
  else
    echo "Key-chain remains locked; apps like gh and claude may not have access to tokens/credentials they have stored."
  fi
  unset pw
fi
