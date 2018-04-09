# do nothing if not interactive
case $- in
	*i*) ;;
	*) return;;
esac

export AWSUSER=curt

export HISTSIZE=50000
export HISTFILESIZE=100000

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/opt/go/libexec/bin:$GOPATH/bin:$HOME/bin

# fzf
test -f ~/.fzf.bash && . $_
# z
test -f /usr/local/etc/profile.d/z.sh && . $_
# Use bash-completion, if available
test -f /usr/local/etc/bash_completion.d/git-completion.bash && . $_
test -f $HOME/.ktx-completion.sh && . $_

alias map="xargs -n1 -I%"
alias ll="ls -lha"
alias ..="cd .."

# Default gists to private
alias gist='gist -p'
alias delmerged='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
