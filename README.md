# BashCompletor

Creating a bash completion script in a declarative way.

[English](./README.md) | [中文](./README.zh.md)

## Feature

- Declarative programming. You only need to know the most basic bash syntax.
- Only `bash` and `sed` are needed on at compile time. Only `bash` is needed on at run time. No other dependencies.
- Support for command format looks like `<cmd> [options] [arguments]`.
- Support for sub-commands, which looks like `<cmd> [cmd-options] <subcmd> [subcmd-options] [arguments]`.
- Support for `-o`, `--option`, `--option <value>`, `--option=`, `+o`, `+option` format.
- Support for completing file or directory paths.
- Support for completing word lists.
- Support for custom completion functions.
- Friendly config typo checking and suggestions.

## Requirements

- For building script.
  - Bash v4.3+
  - cat, sed (GNU or BSD compatible)
- For runtime. Bash v4.0+

## Versioning

Read [tags][] for versions.
The versions follow the rules of [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).

## Installation

You can install it by `curl` or `git`.

### Curl

```sh
VERSION=v0.1.0

# To download bash-completor
curl -LO "https://github.com/adoyle-h/bash-completor/releases/download/$VERSION/bash-completor{,.md5}"

# Check files integrity
md5sum -c ./*.md5

# Make it executable
chmod +x ./bash-completor

# Create symbol link or copy it to somewhere in your local $PATH
sudo ln -s "$PWD/bash-completor" /usr/local/bin/bash-completor
```

There is a completion script of bash-completor. You can install it if you need.

```sh
# To download the completion script of bash-completor
curl -LO "https://github.com/adoyle-h/bash-completor/releases/download/$VERSION/bash-completor.completion.bash{,.md5}"

# Check files integrity
md5sum -c ./*.md5

echo ". $PWD/bash-completor.completion.bash" >> ~/.bashrc
```

### Git

```sh
# Clone this repo
git clone --depth 1 https://github.com/adoyle-h/bash-completor.git

make build

# Create symbol link or copy it to somewhere in your local $PATH
sudo ln -s "$PWD/dist/bash-completor" /usr/local/bin/bash-completor
```

## Usage

Enter `bash-completor` for help.

1. Write a config file `completor.bash`.
2. Run `bash-completor -c ./completor.bash` to generate completion script.

## Configuration

### Examples

- [./completor.bash](./completor.bash) It's a simple example. Run `make build` to build the completion script of bash-completor.
- [zig.completor.bash](https://github.com/adoyle-h/shell-completions/blob/feat/bash/zig.completor.bash)
- [nvim-shell-completions/nvim.completor.bash](https://github.com/adoyle-h/nvim-shell-completions/blob/master/nvim.completor.bash)
- Other examples in [./example/](./example/)

### [Syntax](./docs/syntax.md)

## The completion script

The generated completion script follows below code style. No worry about naming conflict.
And it's easy to debug at runtime.

- The main command completion function must be `_${cmd}_completions`
- All subcmd completion functions must be named with prefix `_${cmd}_completions_${subcmd}`.
- All other variables and functions must be named with prefix `_${cmd}_comp_`.
- The variable of main command options must be `_${cmd}_comp_cmd_opts`.
- The variable of subcmd options must be named with prefix `_${cmd}_comp_subcmd_opts_${subcmd}`.
- All reply functions must be named with prefix `_${cmd}_comp_reply_`.
- All customized reply functions must be named with prefix `_${cmd}_comp_reply_custom_`.

## Suggestion, Bug Reporting, Contributing

**Before opening new Issue/Discussion/PR and posting any comments**, please read [Contributing Guidelines](https://gcg.adoyle.me/CONTRIBUTING).

### Test

Run `make test` in shell.

## Copyright and License

Copyright 2023 ADoyle (adoyle.h@gmail.com). Some Rights Reserved.
The project is licensed under the **Apache License Version 2.0**.

See the [LICENSE][] file for the specific language governing permissions and limitations under the License.

See the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## Other Projects

- [lobash](https://github.com/adoyle-h/lobash): A modern, safe, powerful utility/library for Bash script development.
- [one.bash](https://github.com/one-bash/one.bash): An elegant framework to manage commands, completions, dotfiles for bash players.
- [Other shell projects](https://github.com/adoyle-h?tab=repositories&q=&type=source&language=shell&sort=stargazers) created by me.


<!-- links -->

[tags]: https://github.com/adoyle-h/bash-completor/tags
[LICENSE]: ./LICENSE
[NOTICE]: ./NOTICE
