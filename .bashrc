# do nothing if not interactive
case $- in
	*i*) ;;
	*) return;;
esac

export HISTSIZE=50000
export HISTFILESIZE=100000

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:$HOME/bin

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

alias map="xargs -n1 -I%"
alias ll="ls -lha"
alias ..="cd .."

PS1='\h:\W \u\$ '
