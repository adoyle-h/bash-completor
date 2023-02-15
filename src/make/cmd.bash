make_main_completion() {
  make_equal_sign_opts_func "cmd_opts"

  cat <<EOF

_${cmd}_completions() {
  COMPREPLY=()
  local cur=\${COMP_WORDS[COMP_CWORD]}
  local prev=\${COMP_WORDS[COMP_CWORD-1]}

  # Uncomment this line for debug
  # echo "[COMP_CWORD:\$COMP_CWORD][cur:\$cur][prev:\$prev][WORD_COUNT:\${#COMP_WORDS[*]}][COMP_WORDS:\${COMP_WORDS[*]}]" >> bash-debug.log
EOF

  local reply_args

  if $has_subcmds; then
    cat <<EOF

  if (( COMP_CWORD > 1 )); then
    # Enter the subcmd completion
    local subcmd_varname
    subcmd_varname="\$(_${cmd}_comp_util_get_varname "\${COMP_WORDS[1]}")"
    if type "_${cmd}_completions_\$subcmd_varname" &>/dev/null; then
      "_${cmd}_completions_\$subcmd_varname"
    else
      # If subcmd completion function not defined, use the fallback
      "_${cmd}_completions__fallback"
    fi
    return 0
  fi
EOF

    reply_args="_${cmd}_comp_reply_list _${cmd}_comp_subcmds"
  else
    reply_args=$(make_reply_action cmd_args)
  fi

  local reply_opts_fallback
  if [[ -v cmd_opts_fallback ]]; then
    reply_opts_fallback=$(make_reply_action cmd_opts_fallback)
  else
    reply_opts_fallback=$(make_reply_action cmd_args)
  fi

    cat <<EOF

  # Enter the cmd completion
$(make_cmd_core "cmd_opts" "$reply_args" "$reply_opts_fallback")
}

complete -F _${cmd}_completions -o bashdefault ${cmd_name}
# vi: sw=2 ts=2
EOF
}

