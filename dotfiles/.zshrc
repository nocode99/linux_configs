# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ ! -z $ZPROF ]; then
  zmodload zsh/zprof
fi
################################################################################
# FUNCTIONS
################################################################################

# docker
function dsp() {
  docker system prune -f
  docker images
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
    git clone git@github.com:KeplerGroup$2/$1.git ~/src/KeplerGroup$2/$1
  else
    echo "Repo is already kloned!"
  fi
}

function clone() {
  if [[ ! -d ./$2 ]]; then
    git clone git@github.com:$1/$2.git
  fi
}

function update_program() {
  case $1 in
    kitty)
      curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
      ;;
    zoom)
      if [[ ! -f /tmp/zoom_amd64.deb ]]; then
        curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
      fi
      sudo dpkg -i /tmp/zoom_amd64.deb
      ;;
    vault)
      if [ -z $2 ]; then
        echo "Missing Vault Version!"
      else
        curl -Lsf https://releases.hashicorp.com/vault/${2}/vault_${2}_linux_amd64.zip -o /tmp/vault.zip
        unzip -o -d $HOME/.local/bin/ /tmp/vault.zip
        echo "Updated Vault to $2"
      fi
      ;;
    yy) # yakyak
      local yy_version=$(get_github_latest_release "yakyak/yakyak")
      local yy_sem="${yy_version//v}"
      curl -o /tmp/yakyak.deb  \
        -Lsf https://github.com/yakyak/yakyak/releases/download/$yy_version/yakyak-$yy_sem-linux-amd64.deb
      sudo dpkg -i /tmp/yakyak.deb
      rm -f /tmp/yakyak.deb
      ;;
  esac
}

function switchenv() {
  # Switch only the environment in the CWD
  # Requires environment as an argument
  # Example: switchenv master
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  ENV=$(echo ${DIR} | sed "s/^.*\/kepler-terraform\///" | cut -d / -f 1)
  DIR_PREFIX=$(echo $DIR | awk -F "${ENV}" '{print $1}')
  DIR_SUFFIX=$(echo $DIR | awk -F "${ENV}" '{print $2}')
  if [[ $ENV == 'master' ]]; then
    NEW_ENV='integration'
  elif [[ $ENV == 'integration' ]]; then
    NEW_ENV='master'
  else
    NEW_ENV=$1
  fi
  cd "$DIR_PREFIX/$NEW_ENV/$DIR_SUFFIX"
}

function s3size() {
  # USAGE: returns s3 bucket size in GB
  # s3size s3-bucket (returns todays storage)
  # s3size s3-bucket 7 (returns storage from 7 days ago)
  if [[ -z $1 ]]; then
    echo "pass in S3 Bucket name! e.g. s3size kepler-devops"
    return 1
  fi
  S3_BUCKET=$1
  REGION=${REGION:-us-east-1}
  DATE_NOW=$(date +"%Y-%m-%d")
  if [[ ! -z $2 ]]; then
    DATE=$(date --date="$2 days ago" +"%Y-%m-%d")
  else
    DATE=$DATE_NOW
  fi

  aws cloudwatch get-metric-statistics \
    --namespace AWS/S3 \
    --start-time "${DATE}T00:00:00" \
    --end-time "${DATE}T01:00:00" \
    --statistics Average \
    --region $REGION \
    --period 86400 \
    --metric-name BucketSizeBytes \
    --dimensions Name=BucketName,Value=$S3_BUCKET Name=StorageType,Value=StandardStorage \
    | jq '.Datapoints[].Average' -r \
    | awk '{print $1/1024/1024/1024 " GB "}'
}

function include() {
  [[ -f "$1" ]] && source "$1"
}

function doit() {
  sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
}

function params() {
  aws ssm get-parameters-by-path \
    --path / \
    --recursive \
    | jq '.Parameters[].Name' -r \
    | sort
}

function copy() {
  # paste contents of a file to clipboard
  cat $1 | xclip -selection clipboard
}

function ssm {
  # AWS SSM connect to instance. Pass in ECS cluster to select any instance
  # in the cluster or pass in instance-id
  if [ -z "$1" ]; then
    echo "Must Define a cluster! eg mgmt-ecs"
    return 1
  fi

  if [ -z "$2" ]; then
    local INSTANCE_INDEX=0
  else
    local INSTANCE_INDEX=$2
  fi

  local ARN=$(aws ecs list-container-instances --cluster $1 --status ACTIVE | jq ".containerInstanceArns [$INSTANCE_INDEX]" | tr -d '"')
  local ID=$(aws ecs describe-container-instances --cluster $1 --container-instances $ARN | jq '.containerInstances [0].ec2InstanceId' | tr -d '"')
  aws ssm start-session --target $ID
}

################################################################################
# ZPLUG SETTINGS
################################################################################

if [ -f ~/.zplug/init.zsh ]; then
  source ~/.zplug/init.zsh

  zplug "paulirish/git-open", as:plugin
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "qoomon/zjump", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zdharma/fast-syntax-highlighting", as:plugin
  zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf
  zplug "mdumitru/git-aliases", as:plugin
  zplug "blimmer/zsh-aws-vault", as:plugin
  zplug "plugins/git",   from:oh-my-zsh

  zplug "romkatv/powerlevel10k", as:theme, depth:1

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

# You may need to manually set your language environment
export LANG=en_US.UTF-8

################################################################################
# Auto Completion
################################################################################

autoload -U +X bashcompinit
bashcompinit

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
fpath+=(/usr/local/share/zsh-completions $fpath)
fpath+=~/autocompleters
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

# Add autocompletion path
fpath+=~/.zfunc

if [ -d $HOME/autocompleters ]; then
  for file in $HOME/autocompleters/*sh; do
    source $file
  done
fi

# kubectl autocomplete
if [ $commands[kubectl] ]; then
  kubectl() {
    unfunction "$0"
    source <(kubectl completion zsh)
    $0 "$@"
  }
fi

################################################################################
# tldr SETTINGS
################################################################################

complete -W "$(tldr 2>/dev/null --list)" tldr
export TLDR_HEADER='blue bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='cyan'
export TLDR_CODE='magenta'
export TLDR_PARAM='blue'

################################################################################
# CUSTOM SETTINGS
################################################################################
include ~/.sensitive/zsh

if [[ "$OSTYPE" == *"linux"* ]]; then
    # alias ll='ls -alh --color=auto --group-directories-first'
    alias cat='bat'
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -select clipboard -o'
    # Disables CTRL+S/CTRL+Q in Terminal
    stty -ixon
elif [[ "$OSTYPE" == *"darwin"* ]]; then
  bindkey "\e[1;3D" backward-word # ⌥←
  bindkey "\e[1;3C" forward-word # ⌥→
fi

################################################################################
# ALIAS
###############################################################################
alias ll='lsd -al'
alias l='lsd -al'

alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'

alias mkdir='mkdir -p'
alias vim='nvim'
alias grep='grep --color=auto'
alias di='docker images'
alias assume="source assume"

alias kip='cd ~/src/KeplerGroup'
alias zo='source ~/.zshrc'
alias ap='ansible-playbook'

# python
alias va='source ./venv/bin/activate'
alias venv='python3 -m venv venv'

# vault
alias vauth='unset VAULT_TOKEN && vault login -method=github'
alias vgit='echo $VAULT_AUTH_GITHUB_TOKEN | pbcopy'
alias smux='mux start kepler'

# terraform/terragrunt
alias tgp='terragrunt plan'
alias tg='terragrunt'
alias tga='terragrunt apply'
alias tgi='terragrunt init'
alias tgir='terragrunt init -reconfigure'
alias tgo='terragrunt output'
alias tgr='terragrunt refresh'

# returns current public IP
alias myip='curl -sq checkip.amazonaws.com | pbcopy'

if [ -d "$HOME/.terraform.d/plugin-cache" ]; then
  mkdir $HOME/.terraform.d/plugin-cache
fi

################################################################################
# EXPORT
###############################################################################
export EDITOR='/usr/bin/nvim'
export TERM=screen-256color
export ANSIBLE_COW_SELECTION='tux'
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export MANPAGER='nvim +Man!'.
# customize exa output
# export EXA_COLORS="uu=36:da=34"


################################################################################
# ASDF
###############################################################################

if [[ ! -d $HOME/.asdf ]]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
fi

source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash

################################################################################
# PATHS
###############################################################################

CARGO_ROOT="$HOME/.cargo/bin"
LOCAL_ROOT="$HOME/.local/bin"
POETRY_ROOT="$HOME/.poetry/bin"
ASDF_SHIMS="$HOME/.asdf/shims"

export PATH=$PATH:$CARGO_ROOT:$LOCAL_ROOT:$POETRY_ROOT:$ASDF_SHIMS:$KNOT_ROOT:$HOME/.serverless/bin:/usr/local/sbin

typeset -aU path

if [[ -f $(which direnv) ]]; then
  eval "$(direnv hook $SHELL)"
fi

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

if [ ! -z $ZPROF ]; then
  zprof
fi

export PATH="$HOME/.poetry/bin:$PATH"
