[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="random"

plugins=(git zsh-autosuggestions)

bindkey '^ ' autosuggest-accept

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/llvm/12.0.0/bin:$HOME/opt/GNAT/2021/bin:$HOME/opt/GNAT/2021/libexec/gnatstudio/als:$PATH"
export LLVM_SYS_120_PREFIX="$HOME/llvm/12.0.0/"
