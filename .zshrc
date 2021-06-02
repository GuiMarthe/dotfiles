
source ~/dotfiles/my_prompt.zsh-theme
stty -ixon

if [[ $TERM == xterm ]]; then TERM=xterm-256color; fi

### History for commands
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

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



