# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

shopt -s nocaseglob
shopt -s histappend
shopt -s cdspell

REDBK='\[\033[41m\]'
NC='\[\033[00m\]'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

kubeconfig() {
    basename ${KUBECONFIG:=""} | xargs -n1 -I% printf "% "
}

export PS1="• \[\033[91m\]\$(kubeconfig)\[\033[00m\]\h:\W \[\033[32m\]\$(parse_git_branch)\[\033[00m\]$ "
