. /usr/local/etc/profile.d/z.sh

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias map="xargs -n1"
alias ll="ls -lha"
