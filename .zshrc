[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="awesomepanda"

plugins=(git zsh-autosuggestions nvm)

bindkey '^ ' autosuggest-accept

source $ZSH/oh-my-zsh.sh

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,target}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
