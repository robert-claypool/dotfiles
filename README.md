## dotfiles
My dotfiles, except [.vim](https://github.com/robert-claypool/.vim).

1. `cd` into this directory, then run `./bootstrap.sh`
2. Configure Bash
3. ?
4. PROFIT

## Optional Bash Configs

```bash
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR="/home/robert/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

export TERM="xterm-256color"

# Add the PATH where pip installs the AWS EB CLI
# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html
export PATH="$PATH:~/.local/bin"
```
