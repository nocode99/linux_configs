'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh
  setopt no_unset extended_glob
  zmodload zsh/langinfo
  if [[ ${langinfo[CODESET]:-} != (utf|UTF)(-|)8 ]]; then
    local LC_ALL=${${(@M)$(locale -a):#*.(utf|UTF)(-|)8}[1]:-en_US.UTF-8}
  fi

  # Unset all configuration options.
  unset -m 'POWERLEVEL9K_*'

  ##############################################################################
  # CUSTOM SETTINGS
  ##############################################################################
  function my_tf() {
    emulate -L zsh
    # Returns the version of terraform being used either by .terraform-version
    # file or global terraform installed.
    local color='%F{129}'
    if [ -f .terraform-version ]; then
      echo -n "%{$color%}$(cat .terraform-version)"
    elif; then
      echo -n "%{$color%}$(terraform --version | head -n1 | awk '{print $2}')"
    fi
  }

  # {{{ global settings
  typeset -g POWERLEVEL9K_BACKGROUND=236

  # enables default icons
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT=true
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      time                    # show time in seconds
      aws                     # aws profile
      dir                     # current directory
      custom_tf_signal        # show what tf version is being used
      kubecontext
      virtualenv
      vcs                     # git status
      status
  )
  # }}}

  # {{{ prompt
  # Add an empty line before each prompt.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  # removes separator between elements
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''
  # removes icon at end of top left prompt
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  # hides the connecting brackets between two lines
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=" \Ubb "
  # }}}

  typeset -g POWERLEVEL9K_TIME_BACKGROUND="clear"
  typeset -g POWERLEVEL9K_TIME_FORMAT="%D{%I:%M:%S}"
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=66
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=
  # updates the time in terminal in realtime
  typeset -g POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME=true

  typeset -g POWERLEVEL9K_AWS_BACKGROUND="clear"
  typeset -g POWERLEVEL9K_AWS_FOREGROUND=208
  typeset -g POWERLEVEL9K_AWS_ICON='AWS'

  typeset -g POWERLEVEL9K_DIR_BACKGROUND="clear"
  typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="clear"
  # Default current directory color.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=none
  # Replace removed segment suffixes with this symbol.
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='%F{008} …%F{008}'
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=4
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
  typeset -g POWERLEVEL9K_DIR_CLASSES=(
      '~/src/KeplerGroup(/*)#'  WORK     '(╯°□°）╯︵┻━┻'
      '~(/*)#'       HOME     '\U1f3e0'
      '*'            DEFAULT  ''
      )

  typeset -g POWERLEVEL9K_VCS_BACKGROUND="clear"
  typeset -g POWERLEVEL9K_STATUS_BACKGROUND="clear"

  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND="clear"
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=37
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  typeset -g POWERLEVEL9K_CUSTOM_TF_SIGNAL_BACKGROUND="clear"
  typeset -g POWERLEVEL9K_CUSTOM_TF_SIGNAL="my_tf"
  typeset -g POWERLEVEL9K_CUSTOM_TF_SIGNAL_FOREGROUND="129"
  typeset -g POWERLEVEL9K_CUSTOM_TF_SIGNAL_ICON=$'\U271D'



  #####################################[ vcs: git status ]######################################
  # Branch icon. Set this parameter to '\uF126 ' for the popular Powerline branch icon.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}

  # Untracked files icon. It's really a question mark, your font isn't broken.
  # Change the value of this parameter to show a different icon.
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON=${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}

  # VCS_STATUS_* parameters are set by gitstatus plugin. See reference:
  # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.
  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
      # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
      my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      # Styling for up-to-date Git status.
      local       meta='%f'     # default foreground
      local      clean='%76F'   # green foreground
      local   modified='%178F'  # yellow foreground
      local  untracked='%39F'   # blue foreground
      local conflicted='%196F'  # red foreground
      local    loading='%244F'  # grey foreground
    else
      # Styling for incomplete and stale Git status.
      local       meta='%244F'  # grey foreground
      local      clean='%244F'  # grey foreground
      local   modified='%244F'  # grey foreground
      local  untracked='%244F'  # grey foreground
      local conflicted='%244F'  # grey foreground
      local    loading='%244F'  # grey foreground
    fi

    local res
    local where  # branch name, tag or commit
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      res+="${clean}${POWERLEVEL9K_VCS_BRANCH_ICON}"
      where=${(V)VCS_STATUS_LOCAL_BRANCH}
    elif [[ -n $VCS_STATUS_TAG ]]; then
      res+="${meta}#"
      where=${(V)VCS_STATUS_TAG}
    else
      res+="${meta}@"
      where=${VCS_STATUS_COMMIT[1,8]}
    fi

    # If local branch name or tag is at most 32 characters long, show it in full.
    # Otherwise show the first 12 … the last 12.
    (( $#where > 32 )) && where[13,-13]="…"
    res+="${clean}${where//\%/%%}"  # escape %

    # Show tracking branch name if it differs from local branch.
    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"  # escape %
    fi

    # ⇣42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    # *42 if have stashes.
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    # 'merge' if the repo is in an unusual state.
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    # ~42 if have merge conflicts.
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    # +42 if have staged changes.
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    # !42 if have unstaged changes.
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    # ?42 if have untracked files. It's really a question mark, your font isn't broken.
    # See POWERLEVEL9K_VCS_UNTRACKED_ICON above if you want to use a different icon.
    # Remove the next line if you don't want to see untracked files at all.
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"

    my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  # Disable the default Git status formatting.
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  # Install our own Git status formatter.
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  # Enable counters for staged, unstaged, etc.
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=76
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=244
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=76
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  # Status on success. No content, just an icon. No need to show it if prompt_char is enabled as
  # it will signify success by turning green.
  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=70
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'

  # Status when some part of a pipe command fails but the overall exit status is zero. It may look
  # like this: 1|0.
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=70
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'

  # Status when it's just an error code (e.g., '1'). No need to show it if prompt_char is enabled as
  # it will signify error by turning red.
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='↵'

  # Status when the last command was terminated by a signal.
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=160
  # Use terse signal names: "INT" instead of "SIGINT(2)".
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='↵'

  # Status when some part of a pipe command fails and the overall exit status is also non-zero.
  # It may look like this: 1|0.
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=160
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='↵'

  function prompt_example() {
    p10k segment -f 208 -i '⭐' -t 'hello, %n'
  }

  # User-defined prompt segments can be customized the same way as built-in segments.
  typeset -g POWERLEVEL9K_EXAMPLE_FOREGROUND=208
  typeset -g POWERLEVEL9K_EXAMPLE_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
