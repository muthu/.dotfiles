#HISTFILE=~/.zsh_directory
#setopt appendhistory

# refer to this for the features https://zsh.sourceforge.io/Intro/intro_2.html
setopt extendedglob

# if directory name is specified without cd it will automatically cd
setopt autocd

# remove beeping
unsetopt beep

# when you paste text on the terminal it higlights it. To disable it use this command
zle_highlight=('paste:none')


#autoload -Uz colors && colors

# taken from https://github.com/ChristianChiarulli/Machfiles
source "$ZDOTDIR/zsh-functions"

# source other files using zsh_add_file defined in zsh_functions
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"
zsh_add_file "zsh-options"

#add plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"


# interesting plugin activate when the use arrives
# zsh_add_plugin "hlissner/zsh-autopair"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/muthukrishnakrishnakumar/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/muthukrishnakrishnakumar/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/muthukrishnakrishnakumar/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/muthukrishnakrishnakumar/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
