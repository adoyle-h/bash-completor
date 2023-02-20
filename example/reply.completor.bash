output=reply-completion.bash
cmd=example
cmd_opts=(
  -f:@files
  -d:@dirs
  -h:@hold
  -w:'hello,world'
  -W:@words:'w1,w2,w3'
  -s:@set:'array1,array2'
  --equal=:'wow,such,doge'
  --hold=
  --custom:@custom_words
  --zig:@zig_file
)
var_array1=(a b)
var_array2=(c d)

# How to write programmable completion
# https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html
# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html
reply_custom_words() {
  local words=(nyan cat)
  # The "cur" is a global variable defined by bash-completor
  COMPREPLY=( $(compgen -W "${words[*]}" -- "$cur") )
}

reply_zig_file() {
  # The "reply_files_in_pattern" function is defined by bash-completor
  reply_files_in_pattern '\.(zig|zir)$'
}
