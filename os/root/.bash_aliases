#export CHOKIDAR_USEPOLLING=yes
export TERM='xterm-256color'
export VISUAL="vim"
export EDITOR="vim"
alias ag="ag --noaffinity"
alias t=tb
if [ -f ~/.py3env/bin/activate ]; then
    source ~/.py3env/bin/activate
fi

alias ls=exa
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
