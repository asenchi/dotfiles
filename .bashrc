export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:$HOME/bin

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias map="xargs -n1 -I%"
alias ll="ls -lha"

PS1='\h:\W \u\$ '
