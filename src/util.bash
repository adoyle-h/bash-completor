debug() {
  printf "%b[Debug] %s%b\n" "$CYAN" "$*" "$RESET_ALL" >/dev/tty
}

warn() {
  printf "%b[Warn] %s%b\n" "$YELLOW" "$*" "$RESET_ALL" >/dev/tty
}

error() {
  printf "%b[Error] %s%b\n" "$RED" "$*" "$RESET_ALL" >/dev/tty
}

suggest() {
  printf "%b[Suggest] %s%b\n" "$GREEN" "$*" "$RESET_ALL" >/dev/tty
}

# Copy from https://github.com/adoyle-h/lobash/blob/develop/src/modules/is_array.bash
is_array() {
  local attrs
  # shellcheck disable=2207
  attrs=$(declare -p "$1" 2>/dev/null | sed -E "s/^declare -([-a-zA-Z]+) .+/\\1/" || true)

  # a: array
  # A: associate array
  if [[ ${attrs} =~ a|A ]]; then return 0; else return 1; fi
}

is_func() {
  declare -F "$1" &>/dev/null
}

get_varname() {
  local name=${1:-}
  local encoded=${word_to_varname[$name]:-}

  if [[ -z ${encoded} ]]; then
    encoded=${name//[^a-zA-Z_]/_}
  fi

  echo "${encoded}"
}

is_gnu_sed() {
  local out
  out=$(${1:-sed} --version 2>/dev/null)
  [[ $out =~ 'GNU sed' ]]
}
