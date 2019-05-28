################################################################################
# FUNCTIONS
################################################################################

# docker
function dsp() {
  docker system prune -f
  docker images
}

function drun() {
  if [[ $2 == 'bash' ]]; then
    docker run --rm -it $1 /bin/bash
  else
    docker run --rm -it $1 /bin/sh
  fi
}

function dsh() {
  docker run --rm -it \
    $(docker images --format "{{.ID}}" | head -n1) /bin/sh
}

function dbash() {
  docker run --rm -it \
    $(docker images --format "{{.ID}}" | head -n1) /bin/bash
}

function drmi() {
  for img in "$@"
  do
    docker image rm \
      $(docker images --format "{{.Repository}}:{{.Tag}}" | grep $img)
    echo "rm $img"
  done
}

function klone() {
  if [[ ! -d ~/src/KeplerGroup/$1 ]]; then
    git clone git@github.com:KeplerGroup/$1.git ~/src/KeplerGroup/$1
  else
    echo "Repo is already kloned!"
  fi
}

function dato() {
  PAYLOAD=$(jq -n \
    --arg user "$1" \
    --arg email "$2" \
    '{adhoc: true, username: $user, recipient: $email}')
  echo $PAYLOAD
  aws lambda invoke \
    --function-name kip-credential-rotater \
    --log-type Tail \
    --payload $PAYLOAD \
    /tmp/lambda.txt
}

function include() {
  [[ -f "$1" ]] && source "$1"
}

function doit() {
  apt update && apt upgrade -y && apt autoremove -y
}

################################################################################
# ZPLUG SETTINGS
################################################################################

if [ -f ~/.zplug/init.zsh ]; then
  source ~/.zplug/init.zsh

  zplug "paulirish/git-open", as:plugin
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin
  zplug "nobeans/zsh-sdkman", as:plugin
  zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf
  zplug "mdumitru/git-aliases", as:plugin

  zplug "romkatv/powerlevel10k", use:powerlevel10k.zsh-theme

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
          echo; zplug install
      fi
  fi

  # Then, source plugins and add commands to $PATH
  zplug load
else
  echo "zplug not installed"
fi

################################################################################
# SET OPTIONS
################################################################################
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt LIST_BEEP

# completions
setopt COMPLETE_ALIASES

# automatically CD without typing cd
setopt AUTOCD

# Dealing with history
setopt HIST_IGNORE_SPACE
setopt APPENDHISTORY
setopt SHAREHISTORY
setopt INCAPPENDHISTORY
HIST_STAMPS="mm/dd/yyyy"

# History: How many lines of history to keep in memory
export HISTSIZE=5000

# History: ignore leading space, where to save history to disk
export HISTCONTROL=ignorespace
export HISTFILE=~/.zsh_history

# History: Number of history entries to save to disk
export SAVEHIST=5000

#######################################################################
# keybindings
#######################################################################
# emacs .... shudders
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# bindkey "^A" vi-beginning-of-line
# bindkey "^E" vi-end-of-line

#######################################################################
# Unset options
#######################################################################

# do not automatically complete
unsetopt MENU_COMPLETE

# do not automatically remove the slash
unsetopt AUTO_REMOVE_SLASH

#######################################################################
# fzf SETTINGS
#######################################################################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# export FZF_COMPLETION_TRIGGER=''
# export FZF_DEFAULT_OPTS="--bind=ctrl-o:accept --ansi"
# FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# export FZF_DEFAULT_COMMAND


################################################################################
# POWERLEVEL10k THEME
################################################################################
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_beginning"
POWERLEVEL9K_RVM_BACKGROUND="black"
POWERLEVEL9K_RVM_FOREGROUND="249"
POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_TIME_BACKGROUND="black"
POWERLEVEL9K_TIME_FOREGROUND="249"
POWERLEVEL9K_TIME_FORMAT="\UF43A %D{%I:%M  \UF133  %m.%d.%y}"
POWERLEVEL9K_RVM_BACKGROUND="black"
POWERLEVEL9K_RVM_FOREGROUND="249"
POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='red'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='orange1'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='black'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='blue'
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'
POWERLEVEL9K_VCS_COMMIT_ICON="\uf417"
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%f "
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv context ssh root_indicator dir dir_writable vcs status)

# You may need to manually set your language environment
export LANG=en_US.UTF-8

################################################################################
# ZShell Auto Completion
################################################################################

autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# CURRENT STATE: does not select any sort of searching
# searching was too annoying and I didn't really use it
# If you want it back, use "search-backward" as an option
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Fuzzy completion
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:|?=** m:{a-z\-A-Z}={A-Z\_a-z}'
fpath=(/usr/local/share/zsh-completions $fpath)
zmodload -i zsh/complist

# Manual libraries

# vault, by Hashicorp
_vault_complete() {
  local word completions
  word="$1"
  completions="$(vault --cmplt "${word}")"
  reply=( "${(ps:\n:)completions}" )
}
compctl -f -K _vault_complete vault

# stack
# eval "$(stack --bash-completion-script stack)"

# Add autocompletion path
fpath+=~/.zfunc

################################################################################
# CUSTOM SETTINGS
################################################################################

# Disables CTRL+S/CTRL+Q in Terminal
stty -ixon

include ~/.sensitive/zsh

if [ -d $HOME/autocompleters ]; then
  for file in $HOME/autocompleters/*sh; do
    source $file
  done
fi

# Check to see if Linux or Mac
BASE_OS="$(uname)"
case $BASE_OS in
  'Linux')
    OS='linux'
    ;;
  'Darwin')
    OS='darwin'
    ;;
esac

if [[ $OS == 'linux' ]]; then
    # fortune | cowsay -f calvin | lolcat
    # alias ll='ls -alh --color=auto --group-directories-first'
    alias ll='exa -alh --group-directories-first --color-scale'
    alias l='exa -alh --group-directories-first --color-scale'
elif [[ $OS == 'darwin' ]] ; then
    alias ll='ls -alhG'
fi

################################################################################
# EXPORT / ALIAS
###############################################################################
export EDITOR='/usr/bin/nvim'
export TERM=screen-256color
export ANSIBLE_COW_SELECTION='tux'

alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'

alias mkdir='mkdir -p'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -select clipboard -o'
alias vim='nvim'
alias grep='grep --color=auto'
alias di='docker images'

alias kip='cd ~/src/KeplerGroup'
alias kvpn='sudo openvpn --config ~/openvpn/openvpn.conf'
alias zo='source ~/.zshrc'
alias ap='ansible-playbook'

# python
alias va='source ./venv/bin/activate'
alias venv='python3 -m venv venv'

# vault
alias vauth='unset VAULT_TOKEN && vault login -method=github'
alias vgit='echo $VAULT_AUTH_GITHUB_TOKEN | pbcopy'
alias smux='mux start kepler'

################################################################################
# PATHS
###############################################################################

NODENV_PATH="$HOME/.nodenv/bin"
TFENV_ROOT="$HOME/.tfenv/bin"
CARGO_ROOT="$HOME/.cargo/bin"
LOCAL_ROOT="$HOME/.local/bin"
GOENV_ROOT="$HOME/.goenv"
GOENV_BIN="$GOENV_ROOT/bin"
GO_ROOT="$HOME/go"
GO_BIN="$GO_ROOT/bin"
POETRY_ROOT="$HOME/.poetry/bin"
KNOT_ROOT="$HOME/src/knotel/mono/tools/knot/bin2"
PYENV_ROOT="$HOME/.pyenv"
PYENV_BIN="$PYENV_ROOT/bin"

PATH=$PATH:$TFENV_ROOT:$CARGO_ROOT:$LOCAL_ROOT:$GOENV_BIN:$NODENV_PATH:$GO_BIN:$POETRY_ROOT:$KNOT_ROOT:$PYENV_BIN

################################################################################
# APP_ENV CONFIGURATIONS
###############################################################################

# Goenv autocompletion
goenv() {
  eval "$(command goenv init -)"
  goenv "$@"
}

nodenv() {
  eval "$(command nodenv init -)"
  nodenv "@"
}

pyenv() {
  eval "$(command pyenv init -)"
  pyenv "$@"
}

# gcloud autocompletion
PATH_GCLOUD_AUTO="$HOME/.gcloud-zsh-completion/src"

if [[ -d "$PATH_GCLOUD_AUTO" ]]; then
  fpath=($PATH_GCLOUD_AUTO $fpath)
fi

# kubectl autocomplete
if [ $commands[kubectl] ]; then
  kubectl() {
    unfunction "$0"
    source <(kubectl completion zsh)
    $0 "$@"
  }
fi

typeset -aU path

if [[ -f /usr/bin/direnv ]]; then
  eval "$(direnv hook zsh)"
fi

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-${HOME}}/$ZSH_COMPDUMP(#qN.mh+24) ]]; then
  compinit -d $ZSH_COMPDUMP;
else
  compinit -C;
fi;
