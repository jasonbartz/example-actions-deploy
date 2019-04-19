workflow "Build & Deploy" {
  on = "push"
  resolves = ["Push Image to ECR"]
}

action "Build" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t jasonbartz/example-actions-deploy ."
}

action "Docker Fetch ECR" {
  needs = ["Build"]
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  args = "ecr get-login > loginscript && chmod +x loginscript && ./loginscript"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}

action "Push Image to ECR" {
  needs = ["Docker Fetch ECR"]
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "push jasonbartz/example-actions-deploy"
}
