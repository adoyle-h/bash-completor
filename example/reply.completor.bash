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
)
var_array1=(a b)
var_array2=(c d)
