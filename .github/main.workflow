workflow "Build & Deploy" {
  on = "push"
  resolves = ["Push Image to ECR SHA", "Push Image to ECR Latest"]
}

action "Build" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t jasonbartz/example-actions-deploy ."
}

action "Docker Fetch ECR" {
  needs = ["Build"]
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  args = "ecr get-login --no-include-email > loginscript && chmod +x loginscript && ./loginscript"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}

action "Docker Tag for ECR SHA" {
  needs = ["Docker Fetch ECR"]
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "tag jasonbartz/example-actions-deploy 936848799764.dkr.ecr.us-east-1.amazonaws.com/example-github-actions:$GITHUB_SHA"
}

action "Push Image to ECR SHA" {
  needs = ["Docker Tag for ECR SHA"]
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "push 936848799764.dkr.ecr.us-east-1.amazonaws.com/example-github-actions:$GITHUB_SHA"
}

action "Docker Tag for ECR Latest" {
  needs = ["Docker Fetch ECR"]
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "tag jasonbartz/example-actions-deploy 936848799764.dkr.ecr.us-east-1.amazonaws.com/example-github-actions:latest"
}

action "Push Image to ECR Latest" {
  needs = ["Docker Tag for ECR Latest"]
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "push 936848799764.dkr.ecr.us-east-1.amazonaws.com/example-github-actions:latest"
}
