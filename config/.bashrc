#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

#fastfetch
eval "$(starship init bash)"
export PATH="$PATH:/home/bk/.softwares/flutter/bin"
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

source /usr/share/nvm/init-nvm.sh


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"


#alias vim='nvim'
#alias vi='nvim'

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/bk/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"


