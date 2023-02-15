reply_words() {
  local IFS=$'\n'
  # shellcheck disable=2207
  COMPREPLY=( $(IFS=', ' compgen -W "$*" -- "${cur#=}") )
}

reply_list() {
  local IFS=', '
  local array_list="" array_name
  # shellcheck disable=2068
  for array_name in $@; do
    array_list="$array_list \${${array_name}[*]}"
  done
  array_list="${array_list[*]:1}"

  IFS=$'\n'' '
  eval "COMPREPLY=( \$(compgen -W \"$array_list\" -- \"\$cur\") )"
}

reply_files() {
  local IFS=$'\n'
  compopt -o nospace -o filenames
  # shellcheck disable=2207
  COMPREPLY=( $(compgen -A file -- "$cur") )
}

reply_files_in_pattern() {
  compopt -o nospace -o filenames

  local path
  while read -r path; do
    if [[ $path =~ $1 ]] || [[ -d $path ]]; then
      COMPREPLY+=( "$path" )
    fi
  done < <(compgen -A file -- "$cur")
}

reply_dirs() {
  local IFS=$'\n'
  compopt -o nospace -o filenames
  # shellcheck disable=2207
  COMPREPLY=( $(compgen -A directory -- "$cur") )
}

