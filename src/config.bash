check_conf() {
  local conf_path=$1

  if [[ ! -f $conf_path ]]; then
    echo "Not found config file at $conf_path" >&2
    exit 3
  fi

  # shellcheck disable=1090
  . "$conf_path"

  # Set default values of config options
  cmd_name=$cmd
  cmd=$(get_varname "$cmd_name")
  cmd_args=${cmd_args:-@files}
  subcmd_args__fallback=${subcmd_args__fallback:-@files}

  if (( ${#subcmds[@]} > 0 )); then
    has_subcmds=true
  fi
}
