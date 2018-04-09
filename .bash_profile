# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

shopt -s nocaseglob
shopt -s histappend
shopt -s cdspell

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

export PS1="• \h:\w \[\033[32m\]\$(parse_git_branch)\[\033[00m\]$ "
