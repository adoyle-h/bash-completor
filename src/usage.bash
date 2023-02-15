usage() {
  cat <<EOF
Usage: bash-completor [options]

Options:
  -c <config_path>     To generate Bash completion script based on configuration
  -h|--help            Print the usage
  --version            Print the version of bash-completor

Description: Quickly generate Bash completion script based on configuration.

Config Syntax: https://github.com/adoyle-h/bash-completor/docs/syntax.md

Project: https://github.com/adoyle-h/bash-completor

Version: $VERSION
EOF
}
