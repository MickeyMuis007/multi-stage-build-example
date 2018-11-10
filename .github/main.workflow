workflow "Quality" {
  on = "push"
  resolves = ["debug", "debug-docker", "check", "test", "lint", "security", "validate"]
}

action "check" {
  uses = "actions/docker/cli@master"
  args = "build --target check ."
}

action "test" {
  uses = "actions/docker/cli@master"
  args = "build --target test ."
}

action "security" {
  uses = "actions/docker/cli@master"
  secrets = ["MICROSCANNER"]
  args = "build --target security --build-arg MICROSCANNER=${MICROSCANNER} ."
}

action "lint" {
  uses = "actions/docker/cli@master"
  args = "run -i hadolint/hadolint hadolint --ignore SC2035 - < Dockerfile"
}

action "build" {
  uses = "actions/docker/cli@master"
  args = "build -t sample ."
}

action "debug" {
  uses = "actions/docker/cli@master"
  runs = "sh -c"
  args = "ls"
}

action "debug-docker" {
  uses = "actions/docker/cli@master"
  args = "run -v ${PWD}:/home/ gcr.io/gcp-runtimes/container-structure-test alpine ls /home"
}

action "validate" {
  uses = "actions/docker/cli@master"
  needs = "build"
  args = "run -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}:/home/ gcr.io/gcp-runtimes/container-structure-test test --image sample --config /home/structure-tests.yaml"
}

