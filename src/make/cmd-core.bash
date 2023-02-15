_make_cmd_option() {
  local opt=$1
  local indent=$2
  local default_action=$3

  if [[ $opt =~ : ]]; then
    local option=${opt/:*/}
    local var=${opt/${option}:/}
  else
    local option=$opt
    local var=''
  fi

  if [[ ${option: -1} == '=' ]]; then
    # skip --option=
    return 0
  fi

  if [[ $option == "$opt" ]]; then
    # skip --option without :
    return 0
  fi

  local action
  action=$(parse_action "$var" "$opt")

  # Skip to print case condition. Because this condition action is same to default_action.
  # default_action means "*) $default_action ;;"
  if [[ "$action" != "$default_action" ]]; then
    printf -- '%s) %s ;;\n' "$indent$option" "$action"
  fi
}

_make_cmd_options() {
  echo "      # rely the value of command option"
  local opt
  for opt in "${opts[@]}"; do
    _make_cmd_option "$opt" "$SPACES_6" "$reply_opts_fallback"
  done
}

_make_equal_sign_option() {
  local opt=$1
  local indent="$SPACES_4"

  if [[ $opt =~ : ]]; then
    local option=${opt/:*/}
    local var=${opt/${option}:/}
  else
    local option=$opt
    local var=''
  fi

  if [[ $option =~ =$ ]]; then
    local action
    action=$(parse_action "$var" "$opt")
    printf -- '%s) %s ;;\n' "$indent$option" "$action"
  else
    if [[ $option =~ =[@-_a-zA-Z] ]]; then
      local recommend=${option/=/=:}
      recommend=${recommend// /,}  # developer may use space delimiter
      warn "The option '$option' maybe missing the ':'. Do you need '${recommend}'?"
    fi
  fi
}

_make_equal_sign_options() {
  for opt in "${opts[@]}"; do
    _make_equal_sign_option "$opt"
  done
}

make_equal_sign_opts_func() {
  local opts_varname=$1
  local -n opts=$opts_varname

  local equal_sign_options
  equal_sign_options=$(_make_equal_sign_options)

  if [[ -n $equal_sign_options ]]; then
    cat <<EOF

_${cmd}_comp_equal_sign_${opts_varname}() {
  case "\${1}=" in
$equal_sign_options
  esac
}
EOF
    map_equal_signs[${opts_varname}]=true
  fi
}

make_cmd_core() {
  local opts_varname=$1
  local reply_args=$2
  local reply_opts_fallback=$3
  local -n opts=$opts_varname

  if [[ " ${opts[*]} " == *' -- '* ]]; then
    cat <<EOF
  if [[ \$COMP_LINE == *' -- '* ]]; then
    # When current command line contains the "--" option, other options are forbidden.
    ${reply_args}
  elif [[ \${cur:0:1} == [-+] ]]; then
EOF
  else
  cat <<EOF
  if [[ \${cur:0:1} == [-+] ]]; then
EOF
  fi

  cat <<EOF
    # rely options of command
    _${cmd}_comp_reply_list _${cmd}_comp_${opts_varname}
EOF

  if [[ "${opts[*]}" =~ = ]]; then
    # The options contain equal_sign
    cat <<EOF
    if [[ \${COMPREPLY[*]} =~ =\$ ]]; then compopt -o nospace; fi
EOF
  fi

  if [[ -n ${map_equal_signs[${opts_varname}]:-} ]]; then
  cat <<EOF
  elif [[ \${cur} == = ]]; then
    _${cmd}_comp_equal_sign_${opts_varname} "\$prev"
EOF
  fi

  cat <<EOF
  elif [[ \${prev:0:1} == [-+] ]]; then
    case "\${prev}" in
$(_make_cmd_options)
      *) $reply_opts_fallback ;;
    esac
EOF

  if [[ -n ${map_equal_signs[${opts_varname}]:-} ]]; then
  cat <<EOF
  elif [[ \${prev} == = ]]; then
    _${cmd}_comp_equal_sign_${opts_varname} "\${COMP_WORDS[\$(( COMP_CWORD - 2 ))]}"
EOF
  fi

  cat <<EOF
  else
    # rely the argument of command
    $reply_args
  fi
EOF
}

