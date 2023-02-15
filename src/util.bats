#!/usr/bin/env bats

setup_fixture

setup() {
  load util.bash
}

@test "is_array string" {
  local v=abc
  run is_array v
  assert_failure
  assert_output ''
}

@test "is_array number" {
  local v=1
  run is_array v
  assert_failure
  assert_output ''
}

@test "is_array array" {
  # shellcheck disable=2034
  local v=( 1 )
  run is_array v
  assert_success
  assert_output ''
}

