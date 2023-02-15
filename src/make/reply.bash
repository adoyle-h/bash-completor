make_reply_set() {
  cat <<EOF

_${cmd}_comp_reply_set() {
  local IFS=', '
  local array_list="" array_name
  # shellcheck disable=2068
  for array_name in \$@; do
    array_list="\$array_list \\\${_${cmd}_comp_var_\${array_name}[*]}"
  done
  array_list="\${array_list[*]:1}"

  IFS=\$'\n'' '
  eval "COMPREPLY=( \\\$(compgen -W \"\$array_list\" -- \"\\\$cur\") )"
}
EOF

  map_reply_funcs[reply_set]=true
}

if is_gnu_sed; then
  # For GNU sed
  sed_reply_utils() {
    declare -f "$name" | sed -e "s/reply_/_${cmd}_comp_reply_/g" -e 's/ *$//g' |\
      sed -e ":a;N;\$!ba;s/IFS='\n'/IFS=\$'\\\\n'/g"
  }
else
  # For BSD sed
  sed_reply_utils() {
    declare -f "$name" | sed -e "s/reply_/_${cmd}_comp_reply_/g" -e 's/ *$//g' |\
      sed -e ':a' -e 'N' -e '$!ba' -e "s/IFS='\n'/IFS=\$'\\\\n'/g"
  }
fi

make_reply_utils() {
  local name

  map_reply_funcs[reply_hold]=true

  # Make framework and developer defined reply functions
  for name in $(compgen -A function reply_); do
    echo ""
    sed_reply_utils

    map_reply_funcs[$name]=true
  done

  make_reply_set

  # Make developer custom reply functions
  for name in $(compgen -A variable reply_); do
    local -n list="$name"
    local func_name=${list[0]}

    if is_func "$func_name"; then
      local rest=()
      local str
      for str in "${list[@]:1}"; do
        rest+=("'$str'")
      done

      cat <<EOF

_${cmd}_comp_${name}() {
  _${cmd}_comp_${func_name} ${rest[@]}
}
EOF
    else
      error "Not found function '$func_name' for config '$name'"
      exit 7
    fi

    map_reply_funcs[$name]=true
  done
}
