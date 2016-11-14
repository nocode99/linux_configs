if [ -f ~/.bash/sensitive ] ; then
    source ~/.bash/sensitive
fi

if [ -f /etc/bash.bashrc ] ; then
    source /etc/bash.bashrc
fi

# Add timestamp to history
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "
# ignore duplicates
export HISTCONTROL=ignoreboth
# Number of lines to keep in bash history
export HISTSIZE=3000
# When shell exits, append to history file instead of overwriting
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export PATH="$PATH:/usr/local/go/bin"
export AWS_PRIVATE_KEY="~/.ssh/ansible"
export EDITOR='/usr/bin/vim'

export TF_VAR_dir_ansible='/home/bkim/src/KeplerGroup/kepler-ansible'
export TF_VAR_private_key='/home/bkim/.ssh/ansible'

alias mkdir='mkdir -p'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -select clipboard -o'

alias ll='ls -alh --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias kip='cd ~/src/KeplerGroup'
alias ovpn='sudo openvpn --config ~/openvpn/old/bkim.conf'
alias kvpn='sudo openvpn --config ~/openvpn/new/bkim.conf'
alias apv='ansible-playbook --ask-vault-pass'
alias ap='ansible-playbook'
alias gitall='find . -name '.git' -type d | while read dir ; \
              do sh -c "echo $dir && cd $dir/../ && git status" ; done'

#######################################################################
# Set command to include git branch in my prompt
#######################################################################
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_PURPLE="\033[1;35m"
COLOR_ORANGE="\033[38;5;202m"
COLOR_BLUE="\033[34;5;115m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"
BOLD="$(tput bold)"

function git_color {
  local git_status="$(git status 2> /dev/null)"
  local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  local git_commit="$(git --no-pager diff --stat origin/${branch} 2>/dev/null)"
  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]] && \
      [[ ! -n $git_commit ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_ORANGE
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch) "
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit) "
  fi
}
#User and pwd
PS1_DIR="\[$BOLD\]\[$COLOR_BLUE\]\u@\h \[$BOLD\]\[$COLOR_PURPLE\][\w] "
PS1_GIT="\[\$(git_color)\]\[$BOLD\]\$(git_branch)\[$BOLD\]\[$COLOR_RESET\]"
PS1_END="\[$BOLD\]$ \[$COLOR_RESET\]"
PS1="${PS1_DIR}${PS1_GIT}\

${PS1_END}"

#export LESS="--RAW-CONTROL-CHARS"
#[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP
