# 语法

## 例子

- [../completor.bash](../completor.bash)
- [zig.completor.bash](https://github.com/ziglang/shell-completions/blob/master/zig.completor.bash)
- [nvim-shell-completions/nvim.completor.bash](https://github.com/adoyle-h/nvim-shell-completions/blob/master/nvim.completor.bash)
- 其他例子见 [../example/](../example/)

## 元字段

- (可选) `version=''`                     补全脚本的版本。
- (可选) `license=''`                     补全脚本的许可证。
- (可选) `description=''`                 补全脚本的描述。
- (可选) `authors=('name1' 'name2')`      补全脚本的作者列表。
- (可选) `maintainers=('name1' 'name2')`  补全脚本的维护者列表。
- (可选) `notice=''`                      补全脚本的注意点。

这些变量定义在 [src/make/header.bash](../src/make/header.bash)。

## 命令字段

- **(必选)** `output='filepath'`
  - 生成补全脚本的路径。
  - 路径是相对于当前配置文件的。
- **(必选)** `cmd=''`
  - 命令名称
- (可选) `cmd_args='@files'`
  - 补全命令的 arguments。当光标处于空格后补全。默认是 `@files`.
- (可选) `cmd_opts=(-h,--help,+k)` or `cmd_opts=(-h --help +k)`
  - 补全命令的 options。当光标处于 `-` 或 `+` 后补全。
- (可选) `cmd_opts_fallback='@files'`
  - 若当前 option 在 `cmd_opts` 没有匹配的选项，则会触发这里的动作。默认是 `cmd_args` 的值。

## 子命令字段

- (可选) `subcmds=(cmd1 cmd2)`
  - 子命令列表。默认是空的。
  - 如果 `subcmds` 不为空，当光标处于空格后，会补全子命令。此行为会覆盖 `cmd_args` 的行为。
- (可选) `subcmd_args_${subcmd}='@files'`
  - 如何补全子命令的 arguments。默认是 `subcmd_args__fallback` 的值。
  - 当光标处于空格后，会触发这个补全。
  - `${subcmd}` 必须是 `subcmds` 的成员。
  - `subcmd_args_${subcmd}=''` 意味着子命令没有 arguments。
- (可选) `subcmd_opts_${subcmd}=()`
  - 如何补全子命令的 options。默认是 `subcmd_opts__fallback` 的值。
  - 当光标处于 `-` 或 `+`，会触发这个补全。
  - `${subcmd}` 必须是 `subcmds` 的成员。
- (可选) `subcmd_opts_${subcmd}_fallback='@files'`
  - 当没有匹配 `subcmd_opts_${subcmd}` 里的选项时触发这个动作。默认是 `subcmd_args__fallback` 的值。
- (可选) `subcmd_args__fallback='@files'`
  - 当 `subcmd_args_${subcmd}` 没有定义时触发这个动作。默认是 `@files`。
- (可选) `subcmd_opts__fallback='@files'`
  - 当 `subcmd_opts_${subcmd}` 没有定义时触发这个动作。默认是 `subcmd_args__fallback` 的值。

### subcmd_comp_alias

- (可选) `subcmd_comp_alias=([alias]=subcmd)`
  - 它会创建别名命令的补全，把别名 `alias` 的补全指向到子命令 `subcmd` 的补全函数。

例如

```sh
subcmd_opts_build=(
  -f
)
subcmd_comp_alias=(
  ['build-exe']=run
  ['build-lib']=run
)
```

## word_to_varname

- (可选) `word_to_varname=([c++]=cpp)`
  - 把匹配到的单词转换成有效的变量名。
  - 比如，当命令和子命令匹配到 `c++`，对应的补全变量会是 `cpp_comp_` 等。因为对于变量名，`+` 是无效字符。
  - 对于 `word_to_varname` 没定义的字符，默认都会被转成 `_`。

## 转存变量

*这个高级功能在绝大多数场景都用不到。*

所有 `var_` 开头的变量，都会被转存到补全函数里。

```sh
cmd=example
var_a=(a b c)
var_b=123
```

会被转换成这样

```sh
_example_comp_var_a=([0]="a" [1]="b" [2]="c")
_example_comp_var_b="123"
```

## 回复动作

`@action` 称之为“回复动作”。

回复动作可以用在 `cmp_opts`, `cmp_args`, `cmd_opts_fallback`, `subcmd_args_${subcmd}`, `subcmd_opts_${subcmd}`, `subcmd_opts_${subcmd}_fallback`, `subcmd_args__fallback`, `subcmd_opts__fallback` 字段里。

### 内置的回复动作

- `<option>:@dirs`              补全目录路径。
- `<option>:@files`             补全文件路径。
- `<option>:'w1,w2,w3'`         补全单词 `w1` `w2` `w3`。
- `<option>:'w1 w2 w3'`         同上。 **注意：当重用数组变量时，空格分隔符会引起 BUG。例如 `new_opts=( ${opts[@]} )`。所以最好使用逗号分隔符。**
- `<option>:'w1,w2 w3'`         同上。
- `<option>:@words:'w1,w2,w3'`  同上。
- `<option>:@hold`              没补全，等待用户输入。
- `<option>:@set:'a1,a2,a3'`    补全数组 `a1`, `a2`, `a3` 里的列表。
- `<option>:@files_in_pattern:'pattern'` 不推荐直接使用。应该使用 [自定义回复动作](#自定义回复动作).
  - 补全匹配的文件路径 (这根据 [Bash Pattern Matching](https://www.gnu.org/s/bash/manual/html_node/Pattern-Matching.html))

你可以在终端尝试[这些例子](../example/)。

```sh
make examples
. ./example/reply-completion.bash

# To complete the options
example -<Tab>
```

### 自定义回复动作

更多自定义回复动作的例子请阅读 [example/reply.completor.bash](../example/reply.completor.bash)。

#### 例子 1

把这个 `reply_` 开头的变量添加到配置文件中。

```bash
reply_zig_file=(
  'reply_files_in_pattern' '\.(zig|zir|o|obj|lib|a|so|dll|dylib|tbd|s|S|c|cxx|cc|C|cpp|stub|m|mm|bc|cu)$'
)
```

或者，定义一个 `reply_` 开头的函数。

```bash
reply_zig_file() {
  reply_files_in_pattern '\.(zig|zir)$'
}
```

这两种定义方式是一样的生成结果。

现在回复动作 `@zig_file` 就可用了。`cmd_opts=( -z:@zig_file )`。

#### 例子 2

```bash
# How to write programmable completion
# https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html
# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html
reply_custom_words() {
  local words=(nyan cat)
  # The "cur" is a global variable defined by bash-completor
  COMPREPLY=( $(compgen -W "${words[*]}" -- "$cur") )
}
```

现在回复动作 `@custom_words` 就可用了。`cmd_opts=( --custom:@custom_words )`。
。

#### 内置的全局变量

- [Bahs 定义的补全变量](https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html)
- bash-completor 定义的补全变量
  - `cur` = `${COMP_WORDS[COMP_CWORD]}` 当前光标所在的单词
  - `prev` = `${COMP_WORDS[COMP_CWORD-1]}` 当前光标位置之前的单词

## --option=

对于参数 `--option=`, `-o=`，按下 `<Tab>` 会从 `--o|` 补全到 `--option=|`（`|` 代表光标），不会在补全后增加空格。
并且它会停止补全其他参数，等待用户输入。

回复动作也支持 `--option=` 参数。比如 `--option=:@files`, `--option=:@dirs`, `--option=:'word'`。
`--option=:@hold` 等同于 `--option=`。
