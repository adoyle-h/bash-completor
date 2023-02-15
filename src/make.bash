make() {
  make_header
  make_opts_variable cmd_opts
  make_dumped_variables

  if $has_subcmds; then
    make_subcmd_opts
    make_get_varnames
  fi

  make_reply_utils

  if $has_subcmds; then
    make_subcmds
    make_subcmd_completions
  fi
  make_main_completion
}

do_make() {
  # NOTE: Naming variable should avoid some prefixes like "reply_" and "subcmd_opts_". Search "compgen -A".
  local conf_path=$1
  local has_subcmds=false
  local equal_sign_idx=0
  local -A map_reply_funcs=() map_equal_signs=()
  local output cmd cmd_name cmd_args notice
  local -a authors=() maintainers=() subcmds=() cmd_opts=()
  local -A subcmd_comp_alias=() word_to_varname=()

  check_conf "$conf_path"

  local output_path
  output_path="$(dirname "$conf_path")/$output"
  make > "$output_path"
  printf '%bGenerated file: %s%b\n' "${GREEN}" "$output_path" "$RESET_ALL"
}
