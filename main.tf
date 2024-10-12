terraform {
  backend "s3" {
    bucket         = var.bucket_name
    key            = "terraform/state/terraform.tfstate"
    region         = var.region
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_iam_role" "github_actions_role" {
  name = "GithubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::287703574697:oidc-provider/token.actions.githubusercontent.com"
        }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:sub" : "repo:woodo01/rsschool-devops-course-tasks:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_policies" {
  for_each = toset([
    "AmazonEC2FullAccess",
    "AmazonRoute53FullAccess",
    "AmazonS3FullAccess",
    "IAMFullAccess",
    "AmazonVPCFullAccess",
    "AmazonSQSFullAccess",
    "AmazonEventBridgeFullAccess"
  ])

  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}
