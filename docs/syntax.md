# Syntax

## Examples

- [../completor.bash](../completor.bash)
- [zig.completor.bash](https://github.com/ziglang/shell-completions/blob/master/zig.completor.bash)
- [nvim-shell-completions/nvim.completor.bash](https://github.com/adoyle-h/nvim-shell-completions/blob/master/nvim.completor.bash)
- Other examples in [../example/](../example/)

## Meta fields

- (Optional) `version=''`                     The version of complete script.
- (Optional) `license=''`                     The license of complete script.
- (Optional) `description=''`                 The description of complete script.
- (Optional) `authors=('name1' 'name2')`      The contacts of authors.
- (Optional) `maintainers=('name1' 'name2')`  The contacts of maintainers.
- (Optional) `notice=''`                      Write notice for user

Source codes: [src/make/header.bash](../src/make/header.bash)

## Command fields

- **(Required)** `output='filepath'`
  - The output path of completion script.
  - The output path is relative to current config file.
- **(Required)** `cmd=''`
  - The command name.
- (Optional) `cmd_args='@files'`
  - To complete the arguments of command when cursor is after space. Defaults to `@files`.
- (Optional) `cmd_opts=(-h,--help,+k)` or `cmd_opts=(-h --help +k)`
  - To complete the options of command when cursor is after `-` or `+`.
- (Optional) `cmd_opts_fallback='@files'`
  - Fallback action for options not matched in `cmd_opts`. Defaults to the value of `cmd_args`.

## Sub command fields

- (Optional) `subcmds=(cmd1 cmd2)`
  - The sub-command list. Defaults to empty.
  - If `subcmds` is not empty, to complete the sub-command when cursor is after space. It overrides the `cmd_args` behavior.
- (Optional) `subcmd_args_${subcmd}='@files'`
  - The action how to completion the arguments of sub-command. Defaults to the value of `subcmd_args__fallback`.
  - To complete the arguments of sub-command when cursor is after space.
  - The `${subcmd}` must be the item of `subcmds`.
  - `subcmd_args_${subcmd}=''` means no argument for the sub-command.
- (Optional) `subcmd_opts_${subcmd}=()`
  - The options of sub-command. Defaults to the value of `subcmd_opts__fallback.`
  - To complete the options of sub-command when cursor is after `-` or `+`.
  - The `${subcmd}` must be the item of `subcmds`.
- (Optional) `subcmd_opts_${subcmd}_fallback='@files'`
  - Fallback action for options not matched in `subcmd_opts_${subcmd}`. Defaults to the value of `subcmd_args__fallback`.
- (Optional) `subcmd_args__fallback='@files'`
  - Fallback action for sub-command when `subcmd_args_${subcmd}` not defined. Defaults to `@files`.
- (Optional) `subcmd_opts__fallback='@files'`
  - Fallback action for sub-command when `subcmd_opts_${subcmd}` not defined. Defaults to the value of `subcmd_args__fallback`.

### subcmd_comp_alias

- (Optional) `subcmd_comp_alias=([alias]=subcmd)`
  - It will create a completion of sub-command `alias`, and point to the completion of sub-command `subcmd`.

For example

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

- (Optional) `word_to_varname=([c++]=cpp)`
  - Convert matched words to valid variable names.
  - For example, when cmd or subcmd equals `c++`, the completion variables will naming with `cpp_comp_` and so on. Because `+` is invalid as variable name.
  - For characters not defined in `word_to_varname`, them will be converted to `_` by default。

## Dump variables

*It's an advanced feature that you won't need it in most situations.*

All variables named with prefix `var_` will be dumped to completion script.

```sh
cmd=example
var_a=(a b c)
var_b=123
```

will convert to

```sh
_example_comp_var_a=([0]="a" [1]="b" [2]="c")
_example_comp_var_b="123"
```

## Reply action

The syntax `@action` will call a "reply action".

The reply action can be used in `cmp_opts`, `cmp_args`, `cmd_opts_fallback`, `subcmd_args_${subcmd}`, `subcmd_opts_${subcmd}`, `subcmd_opts_${subcmd}_fallback`, `subcmd_args__fallback`, `subcmd_opts__fallback`.

### Builtin reply actions

- `<option>:@dirs`              To complete directory path for `<option>`.
- `<option>:@files`             To complete file path for `<option>`.
- `<option>:'w1,w2,w3'`         To complete `w1` `w2` `w3` for `<option>`.
- `<option>:'w1 w2 w3'`         Same to above. **Note: space separator may cause bug when reusing in new array. For example, `new_opts=( ${opts[@]} )`. It is better to use comma separator.**
- `<option>:'w1,w2 w3'`         Same to above.
- `<option>:@words:'w1,w2,w3'`  Same to above.
- `<option>:@hold`              No completion and hold for user input for `<option>`.
- `<option>:@set:'a1,a2,a3'`    To completion the items of arrays `a1`, `a2`, `a3`.
- `<option>:@files_in_pattern:'pattern'` Not recommended. Use [custom reply action](#custom-your-reply-action).
  - To completion the filepath which matches a pattern (It's based on [Bash Pattern Matching](https://www.gnu.org/s/bash/manual/html_node/Pattern-Matching.html))

See the [example](../example/reply.completor.bash) and try it in shell.

```sh
make examples
. ./example/reply-completion.bash

# To complete the options
example -<Tab>
```

### Custom your reply action

Read the [example/reply.completor.bash](../example/reply.completor.bash) for more custom reply examples.

#### Example 1

Add variable naming prefixed `reply_` into the completor configuration.

```bash
reply_zig_file=(
  'reply_files_in_pattern' '\.(zig|zir|o|obj|lib|a|so|dll|dylib|tbd|s|S|c|cxx|cc|C|cpp|stub|m|mm|bc|cu)$'
)
```

Or, declare a function whose name prefixed with `reply_`.

```bash
reply_zig_file() {
  reply_files_in_pattern '\.(zig|zir)$'
}
```

These two definitions have same result in generation.

And the reply action `@zig_file` is available now. `cmd_opts=( -z:@zig_file )`.

#### Example 2

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

And the reply action `@custom_words` is available now. `cmd_opts=( --custom:@custom_words )`.

#### Builtin gloabl variables

- [The completion variables defined by Bash](https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html).
- The completion variables defined by bash-completor
  - `cur` = `${COMP_WORDS[COMP_CWORD]}` current word on cursor
  - `prev` = `${COMP_WORDS[COMP_CWORD-1]}` the word before current cursor

## --option=

For options `--option=`, `-o=`, press `<Tab>` will completion from `--o|` to `--option=|` (`|` is the cursor) without adding space. And it will stop to complete other options and wait user to input.

The reply actions also support `--option=` options.
Like `--option=:@files`, `--option=:@dirs`, `--option=:'word'`.
And the `--option=:@hold` is same to `--option=`.
