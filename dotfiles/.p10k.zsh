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
    else
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
      # custom_tf_signal        # show what tf version is being used
      # kubecontext
      virtualenv
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
