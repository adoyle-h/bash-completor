make_opts_variable() {
  local opts_varname=$1
  local -n opts=$opts_varname

  printf '\n_%s_comp_%s=( ' "$cmd" "$opts_varname"
  for opt in "${opts[@]}"; do
    printf '%s ' "${opt/:*/}"
  done
  printf ')\n'
}

parse_action() {
  local var=$1
  local position=$2

  if [[ ${var:0:1} == '@' ]]; then
    case $var in
      @hold)
        printf ''
        ;;

      *)
        local func_name=${var:1}
        func_name=${func_name/:*/}

        if [[ ${map_reply_funcs["reply_${func_name}"]:-} == true ]]; then
          local func_arg=${var/@${func_name}:/}
          if (( ${#func_arg} > 0 )) && [[ ${func_arg[*]:0:1} != '@' ]]; then
            printf -- "_%s_comp_reply_%s '%s'" "$cmd" "$func_name" "$func_arg"
          else
            printf -- '_%s_comp_reply_%s' "$cmd" "$func_name"
          fi
        else
          error "Invalid '$position': The action '$var' is not defined."

          case $var in
            @f*) suggest "Try '@files' instead of '$var'." ;;
            @d*) suggest "Try '@dirs' instead of '$var'." ;;
            @h*) suggest "Try '@hold' instead of '$var'." ;;
            *) suggest "Try '@files', '@dirs', '@hold' or other reply functions. See https://github.com/adoyle-h/bash-completor/docs/syntax.md#reply-functions "
          esac

          exit 5
        fi
        ;;
    esac
  else
    if [[ -n "$var" ]]; then
      printf -- "_%s_comp_reply_words '%s'" "$cmd" "$var"
    else
      printf ':'
    fi
  fi
}

make_reply_action() {
  local varname=$1
  local -n var=$varname
  local reply

  if [[ -v "$varname" ]]; then
    reply=$(parse_action "$var" "$varname=$var")
  elif is_array "$varname"; then
    reply="_${cmd}_comp_reply_list '${var}'"
  else
    reply="_${cmd}_comp_reply_files"
  fi

  echo "$reply"
}
