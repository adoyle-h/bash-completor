make_subcmd_opts() {
  local subcmd_opts
  for subcmd_opts in $(compgen -A variable subcmd_opts_); do
    make_opts_variable "$subcmd_opts"
  done
}

make_subcmds() {
  cat <<EOF

_${cmd}_comp_subcmds=( ${subcmds[*]} )
EOF
}

make_subcmd_completion() {
  local subcmd_varname=$1

  local reply_args
  if [[ -v "subcmd_args_${subcmd_varname}" ]]; then
    reply_args=$(make_reply_action "subcmd_args_${subcmd_varname}")
  else
    reply_args=$(make_reply_action subcmd_args__fallback)
  fi

  local reply_opts_fallback
  if [[ -v "subcmd_opts_${subcmd_varname}_fallback" ]]; then
    reply_opts_fallback=$(make_reply_action "subcmd_opts_${subcmd_varname}_fallback")
  else
    reply_opts_fallback=$reply_args
  fi

  cat <<EOF

_${cmd}_completions_$subcmd_varname() {
$(make_cmd_core "subcmd_opts_${subcmd_varname}" "$reply_args" "$reply_opts_fallback")
}
EOF
}

make_subcmd_alias_completion() {
  local src
  for src in "${!subcmd_comp_alias[@]}"; do
    printf '_%s_completions_%s() { _%s_completions_%s; }\n' \
      "$cmd" "$(get_varname "$src")" "$cmd" "$(get_varname "${subcmd_comp_alias[$src]}")"
  done
}

make_subcmd_completions() {
  local subcmd subcmd_varname
  for subcmd in "${subcmds[@]}"; do
    subcmd_varname=$(get_varname "$subcmd")
    if is_array "subcmd_opts_${subcmd_varname}"; then
      make_equal_sign_opts_func "subcmd_opts_${subcmd_varname}"
      make_subcmd_completion "$subcmd_varname"
    fi
  done

  make_subcmd_alias_completion
  make_subcmd_completion _fallback
}

