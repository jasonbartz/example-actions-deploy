workflow "Build & Deploy" {
  on = "push"
  resolves = ["Docker Login ECR"]
}

action "Build" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t jasonbartz/example-actions-deploy ."
}

action "Docker Login ECR" {
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  args = "$(aws ecr get-login)"
  needs = ["Build"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}
