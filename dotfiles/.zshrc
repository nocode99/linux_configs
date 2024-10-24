# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZPROF=1

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
  if [[ ! -d ~/src/keplergroup/$1 ]]; then
    git clone git@github.com:KeplerGroup$2/$1.git ~/src/keplergroup$2/$1
  else
    echo "Repo is already kloned!"
  fi
}

function clone() {
  if [[ ! -d ./$2 ]]; then
    git clone git@github.com:$1/$2.git
  fi
}

# up = update_program
function up() {
  case $1 in
    kitty)
      curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
      ;;
    zoom)
      if [[ ! -f /tmp/zoom_amd64.deb ]]; then
        curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
      fi
      dpkg-sig --verify /tmp/zoom_amd64.deb
      sudo dpkg -i /tmp/zoom_amd64.deb
      ;;
    vault)
      if [ -z $2 ]; then
        echo "missing vault version!"
      else
        curl -Lsf https://releases.hashicorp.com/vault/${2}/vault_${2}_linux_amd64.zip -o /tmp/vault.zip
        unzip -o -d $HOME/.local/bin/ /tmp/vault.zip
        echo "updated vault to $2"
      fi
      ;;
    lsd)
      if [ -z $2 ]; then
        echo "missing lsd version!"
      else
        curl -Lsf https://github.com/Peltoche/lsd/releases/download/$2/lsd_$2_amd64.deb \
          -o /tmp/lsd.deb
        sudo dpkg -i /tmp/lsd.deb
        echo "updated lsd to $2"
      fi
      ;;
  esac
}

function include() {
  [[ -f "$1" ]] && source "$1"
}

function doit() {
  sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
}

function copy() {
  # paste contents of a file to clipboard
  cat $1 | xclip -selection clipboard
}

#-------------------------------------------------------------------------------
# zinit
#-------------------------------------------------------------------------------

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zi light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk

zinit light zdharma/fast-syntax-highlighting
zinit light paulirish/git-open
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git

zinit ice wait lucid
zinit light felixr/docker-zsh-completion
zinit light zsh-users/zsh-completions
# performance issue
# zinit light Dbz/kube-aliases
# zinit light qoomon/zjump
zinit light junegunn/fzf
#-------------------------------------------------------------------------------
# end zinit
#-------------------------------------------------------------------------------


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

#######################################################################
# Unset options
#######################################################################

# do not automatically complete
unsetopt MENU_COMPLETE

# do not automatically remove the slash
unsetopt AUTO_REMOVE_SLASH

################################################################################
# CUSTOM SETTINGS
################################################################################

if [[ "$OSTYPE" == *"linux"* ]]; then
    # alias ll='ls -alh --color=auto --group-directories-first'
    alias cat='bat'
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -select clipboard -o'
    # Disables CTRL+S/CTRL+Q in Terminal
    stty -ixon 2>/dev/null
elif [[ "$OSTYPE" == *"darwin"* ]]; then
  bindkey "\e[1;3D" backward-word # ⌥←
  bindkey "\e[1;3C" forward-word # ⌥→
  eval $(/opt/homebrew/bin/brew shellenv)
  alias kvpn='/Applications/Pritunl.app/Contents/Resources/pritunl-client start odx --mode=ovpn'

  # autocompletion for macos
  autoload -Uz compinit
  compinit
fi


#######################################################################
# fzf SETTINGS
#######################################################################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [[ "$OSTYPE" == *"darwin"* ]]; then
  source <("$HOME/.fzf/bin/fzf" --zsh)
fi

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

# zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

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
fpath+=($HOME/.local/share/zinit/completions $fpath)
fpath+=~/autocompleters
zmodload -i zsh/complist

# Add autocompletion path
fpath+=~/.zfunc

if [ -d $HOME/autocompleters ]; then
  for file in $HOME/autocompleters/*sh; do
    source $file
  done
fi

#mise
eval "$($HOME/.local/bin/mise activate zsh)"

# kubernetes settings
alias k=kubecolor
export KUBE_EDITOR=nvim
# [[ $commands[kubectl] ]] && echo "hello"
# [[ $commands[kubectl] ]] && source <(kubectl completion zsh)

function kga {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i

    if [ -z "$1" ]
    then
        kubectl get --ignore-not-found ${i}
    else
        kubectl -n ${1} get --ignore-not-found ${i}
    fi
  done
}

function left_click() {
  # fix left click on mouse when waking up computer
  sudo udevadm trigger
}

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
alias tff='terragrunt force-unlock -force'

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
export ASDF_GOLANG_MOD_VERSION_ENABLED=true

################################################################################
# ASDF
###############################################################################

# if [[ ! -d $HOME/.asdf ]]; then
#   git clone https://github.com/asdf-vm/asdf.git ~/.asdf
# fi

# source $HOME/.asdf/asdf.sh
# source $HOME/.asdf/completions/asdf.bash

################################################################################
# PATHS
###############################################################################

CARGO_ROOT="$HOME/.cargo/bin"
LOCAL_ROOT="$HOME/.local/bin"
# ASDF_SHIMS="$HOME/.asdf/shims"

# export PATH=$PATH:$CARGO_ROOT:$LOCAL_ROOT:$POETRY_ROOT:$ASDF_SHIMS:$KNOT_ROOT:$HOME/.serverless/bin:/usr/local/sbin
export PATH=$PATH:$CARGO_ROOT:$LOCAL_ROOT:$POETRY_ROOT:$KNOT_ROOT:$HOME/.serverless/bin:/usr/local/sbin

typeset -aU path

if [[ -f $(which direnv) ]]; then
  eval "$(direnv hook zsh)"
fi

if [[ -f $(which zoxide) ]]; then
  eval "$(zoxide init zsh --cmd j)"
fi

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

if [ ! -z $ZPROF ]; then
  zprof
fi
