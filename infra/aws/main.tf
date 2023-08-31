terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "pg" {
    conn_str = "postgres://ssamko@223.130.138.20:5432/terraform_backend"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create IAM user
resource "aws_iam_user" "dev" {
  for_each = toset([ "apple", "banana", "grape" ])

  name = each.key
  path = "/dev/"
}

resource "aws_iam_access_key" "lion" {
  for_each = aws_iam_user.dev
  
  user = each.key
}

data "aws_iam_policy_document" "lion_ro" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

# resource "aws_iam_user_policy" "lion_ro" {
#   name   = "tf-test"
#   user   = aws_iam_user.lion.name
#   policy = data.aws_iam_policy_document.lion_ro.json
# }

# resource "aws_iam_user_login_profile" "example" {
#   user    = aws_iam_user.lion.name
# }

# output "password" {
#   value = aws_iam_user_login_profile.example.password
#   sensitive = true
# }

# resource "local_file" "users" {
#   content  = "${aws_iam_user_login_profile.example.password}"
#   filename = "${path.module}/users.txt"
# }
