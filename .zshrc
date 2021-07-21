
source ~/dotfiles/my_prompt.zsh-theme
stty -ixon

if [[ $TERM == xterm ]]; then TERM=xterm-256color; fi

### History for commands
export HISTFILE=~/.histfile
export HISTFILESIZE=10000000
export HISTSIZE=1000000
setopt HIST_FIND_NO_DUPS
## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

## Completion

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

### Up arrow partial matching completion
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey '^[[Z' reverse-menu-complete

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
autoload -U compinit; compinit
autoload -U +X bashcompinit && bashcompinit


#### My aliases
if [ -f ~/dotfiles/.aliases ]; then
	source ~/dotfiles/.aliases
else 
	print "404: my personal aliases not found."
fi

### Local aliases
if [ -f ~/.local_aliases ]; then
	source ~/.local_aliases
else 
	print "404: my local aliases not found."
fi

export EDITOR=nvim
export PAGER=less
export MANPAGER='nvim +Man!'

# pyenv stuff
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

bindkey -v
bindkey "^?" backward-delete-char



