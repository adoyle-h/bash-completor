make_get_varnames() {
  echo ""

  declare -p word_to_varname | sed -e "s/word_to_varname/_${cmd}_comp_word_to_varname/"

  declare -f get_varname | sed -e "s/get_varname/_${cmd}_comp_util_get_varname/" -e 's/ *$//g' \
    -e "s/word_to_varname/_${cmd}_comp_word_to_varname/"
}

make_dumped_variables() {
  echo ""
  local name
  for name in $(compgen -A variable var_); do
    declare -p "$name" | sed "s/^declare -.* var_/_${cmd}_comp_var_/"
  done
}
