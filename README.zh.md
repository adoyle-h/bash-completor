# BashCompletor

声明式编写 Bash 补全脚本。

[English](./README.md) | [中文](./README.zh.md)

## 功能

- 声明式编程。你只需要懂最基础的 bash 语法。
- 编译时只依赖 bash 和 sed。运行时只依赖 bash。无其他依赖。
- 支持命令格式如 `<cmd> [options] [arguments]`。
- 支持子命令。命令格式如 `<cmd> [cmd-options] <subcmd> [subcmd-options] [arguments]`。
- 支持 `-o`, `--option`, `--option <value>`, `--option=`, `+o`, `+option` 格式的参数。
- 支持补全文件或目录路径。
- 支持补全单词列表。
- 支持自定义补全函数。
- 友好的配置项填错检查和提示。

## 依赖

- 编译补全脚本时
  - Bash v4.3+
  - cat, sed (兼容 GNU 和 BSD)
- 运行补全脚本
  - Bash v4.0+

## Versioning

版本详见 [tags][]。
版本命名遵守 [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html)。

## 安装

你可以用 `curl` 或者 `git` 安装它。

### Curl

```sh
VERSION=v0.1.0

# 下载 bash-completor
curl -LO "https://github.com/adoyle-h/bash-completor/releases/download/$VERSION/bash-completor{,.md5}"

# 检查文件完整性
md5sum -c ./*.md5

# 使文件可执行
chmod +x ./bash-completor

# 创建软链接，或者把它拷贝到你本机的 $PATH 目录下
sudo ln -s "$PWD/bash-completor" /usr/local/bin/bash-completor
```

这有个 bash-completor 自身的补全脚本。如果你需要可以安装它。

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

## 用法

执行 `bash-completor` 查看帮助。

1. 创建配置文件 `completor.bash`。
2. 运行 `bash-completor -c ./completor.bash` 生成补全脚本。

## 配置

### 例子

- [./completor.bash](./completor.bash) 一个很简单的例子。运行 `make build` 构建 bash-completor 自身的补全脚本。
- [zig.completor.bash](https://github.com/adoyle-h/shell-completions/blob/feat/bash/zig.completor.bash)
- [nvim-shell-completions/nvim.completor.bash](https://github.com/adoyle-h/nvim-shell-completions/blob/master/nvim.completor.bash)
- 其他例子见 [./example/](./example/)

### [语法](./docs/syntax.md)

## 补全脚本

生成的补全脚本遵循以下代码风格。无需担心重名问题。而且这也便于在运行时调试。

- 主命令的补全函数必须是 `_${cmd}_completions`。
- 所有子命令的补全函数必须以 `_${cmd}_completions_${subcmd}` 为前缀命名。
- 其他所有的变量和函数都必须以 `_${cmd}_comp_` 为前缀命名。
- 主命令的选项必须是 `_${cmd}_comp_cmd_opts`
- 子命令的选项必须以 `_${cmd}_comp_subcmd_opts_${subcmd}` 为前缀命名。
- 所有 reply 函数必须以 `_${cmd}_comp_reply_` 为前缀命名。
- 所有自定义的 reply 函数必须以 `_${cmd}_comp_reply_custom_` 为前缀命名。


## 提建议，修 Bug，做贡献

**在创建新的 Issue/Discussion/PR，以及发表评论之前**，请先阅读[贡献指南](https://gcg.adoyle.me/CONTRIBUTING.zh).

对于未翻译的文档，推荐使用 [DeepL 翻译器](https://www.deepl.com/translator)阅读。

### 测试

在终端执行 `make test`。

## 版权声明

Copyright 2023 ADoyle (adoyle.h@gmail.com). Some Rights Reserved.
The project is licensed under the **Apache License Version 2.0**.

See the [LICENSE][] file for the specific language governing permissions and limitations under the License.

See the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## 其他项目

- [lobash](https://github.com/adoyle-h/lobash): A modern, safe, powerful utility/library for Bash script development.
- [one.bash](https://github.com/one-bash/one.bash): An elegant framework to manage commands, completions, dotfiles for bash players.
- 我创建的[其他 shell 项目](https://github.com/adoyle-h?tab=repositories&q=&type=source&language=shell&sort=stargazers)。


<!-- links -->

[tags]: https://github.com/adoyle-h/bash-completor/tags
[LICENSE]: ./LICENSE
[NOTICE]: ./NOTICE
