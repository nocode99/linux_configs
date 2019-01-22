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
  if [[ -f $1 ]]; then
    source $1
  fi
}

################################################################################
# ZGEN SETTINGS
################################################################################
include ~/.zgen/zgen.zsh

if ! zgen saved; then
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/aws
  zgen oh-my-zsh plugins/pyenv
  zgen oh-my-zsh plugins/terraform
  zgen load bhilburn/powerlevel9k powerlevel9k
  zgen save
fi



################################################################################
# ZSH THEME
################################################################################

ZSH_THEME="powerlevel9k/powerlevel9k"


POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
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
HIST_STAMPS="mm/dd/yyyy"
DISABLE_UPDATE_PROMPT=true
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(
#   git
#   pyenv
# )


# You may need to manually set your language environment
export LANG=en_US.UTF-8

################################################################################
# CUSTOM SETTINGS
################################################################################

# Disables CTRL+S/CTRL+Q in Terminal
stty -ixon

include ~/.sensitive/zsh
include $(which aws_zsh_completer.sh)
include ~/.bin/tmuxinator.zsh

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
    fortune | lolcat
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

###############################################################################

# system
# Easier directory navigation for going up a directory tree
# alias a='cd - &> /dev/null'

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
alias ava='aws-vault exec --no-session --assume-role-ttl 12h --debug admin'
alias smux='mux start infra'

NODENV_PATH="$HOME/.nodenv/bin"
TFENV_ROOT="$HOME/.tfenv/bin"
CARGO_ROOT="$HOME/.cargo/bin"
LOCAL_ROOT="$HOME/.local/bin"
GOENV_ROOT="$HOME/.goenv"
GOENV_BIN="$GOENV_ROOT/bin"
GO_ROOT="$HOME/go"
GO_BIN="$GO_ROOT/bin"

PATH=$PATH:$TFENV_ROOT:$CARGO_ROOT:$LOCAL_ROOT:$GOENV_BIN:$NODENV_PATH:$GO_BIN

# Goenv autocompletion
if [[ -f $GOENV_BIN/goenv ]]; then
  eval "$(goenv init -)"
fi

# nodenv init
if [[ -f $NODENV_PATH/nodenv ]]; then
  eval "$(nodenv init -)"
fi


# gcloud autocompletion
PATH_GCLOUD_AUTO="$HOME/.gcloud-zsh-completion/src"

if [[ -d "$PATH_GCLOUD_AUTO" ]]; then
  fpath=($PATH_GCLOUD_AUTO $fpath)
  autoload -U compinit compdef
  compinit
fi

# kubectl autocomplete
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

typeset -aU path
