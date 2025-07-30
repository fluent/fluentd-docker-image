#!/usr/bin/env bats


@test "ruby version is 3.4" {
  run docker run --rm $IMAGE sh -c "ruby --version | cut -d ' ' -f 2"
  [ "$status" -eq 0 ]

  major=$(echo "$output" | cut -d '.' -f 1)
  minor=$(echo "$output" | cut -d '.' -f 2)
  [ "$major" -eq "3" ]
  [[ "$minor" -eq "4" ]]
}


@test "fluentd is installed" {
  run docker run --rm $IMAGE which fluentd
  [ "$status" -eq 0 ]
}

@test "fluentd runs ok" {
  run docker run --rm $IMAGE fluentd --help
  [ "$status" -eq 0 ]
}

@test "fluentd has correct version" {
  run docker run --rm $IMAGE fluentd --version
  [ "$status" -eq 0 ]
  actual=$(echo "$output" | cut -d ' ' -f 2 | tr -d " \n")

  run sh -c "cat Makefile | grep $DOCKERFILE: | cut -d ':' -f 2 \
                                              | cut -d ',' -f 1 \
                                              | cut -d '-' -f 1 \
                                              | tr -d ' v'"
  [ "$status" -eq 0 ]
  [ "$output" != '' ]
  expected="$output"

  [ "$actual" == "$expected" ]
}


@test "gem 'oj' is installed " {
  run docker run --rm $IMAGE sh -c "gem list --local oj | grep -e '^oj '"
  [ "$status" -eq 0 ]
}

@test "gem 'json' is installed " {
  run docker run --rm $IMAGE sh -c "gem list --local json | grep -e '^json '"
  [ "$status" -eq 0 ]
}
