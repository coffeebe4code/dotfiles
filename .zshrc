[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="random"

plugins=(git zsh-autosuggestions)

bindkey '^ ' autosuggest-accept

source $ZSH/oh-my-zsh.sh

alias gs="git status"
alias gcm="git commit -m"
alias gpo="git push -u origin"
alias gps="git push"
alias gpl="git pull"
alias ga="git add -A"
