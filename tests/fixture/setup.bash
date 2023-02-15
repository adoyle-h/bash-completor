{
  # Hack in run() at tests/fixture/bats/lib/bats-core/test_functions.bash
  # set -eETu in run() command
  # shellcheck disable=2016
  eval "$(declare -f run | \
    sed 's/$("$pre_command"/$(set -eETu; "$pre_command"/' | \
    sed 's/ && status=0 || status=$?;/; status=$?;/')"  # this line fix errexit ignored in test condition

  # For debug:
  # declare -f run | sed 's/$("$pre_command"/$(set -eETu; "$pre_command"/' | sed 's/ && status=0 || status=$?;/; status=$?;/' > /dev/tty
}

{
  # To load assert helpers
  if [[ -n ${DOCKER:-} ]]; then
    load /test/support/load.bash
    load /test/assert/load.bash
    load /test/bats-file/load.bash
  else
    load "$TEST_DIR"/fixture/support/load.bash
    load "$TEST_DIR"/fixture/assert/load.bash
    load "$TEST_DIR"/fixture/bats-file/load.bash
  fi

  # To fix run --separate-stderr
  bats_require_minimum_version 1.5.0

  load "$TEST_DIR/fixture/asserts.bash"
}
