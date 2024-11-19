terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.65.0"
    }
  }
  required_version = "~>1.9.2"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_cognito_user_pool" "cognito" {
  name = "${var.environment}-${var.pool_name}"

  username_attributes = ["email"]

  auto_verified_attributes = var.auto_verified_attributes

  password_policy {
    minimum_length    = 6
    require_lowercase = true
    require_uppercase = true
    require_symbols   = true
    require_numbers   = true
  }
}

resource "aws_cognito_user_pool_domain" "cognito" {
  domain       = "${var.environment}-${var.cognito_domain}"
  user_pool_id = aws_cognito_user_pool.cognito.id
}

resource "aws_cognito_user_pool_client" "cognito" {
  for_each =  {
    for index, client in var.pool_clients: 
      client.name => client
  }

  name                                 = "${var.environment}-${each.value.name}"
  user_pool_id                         = aws_cognito_user_pool.cognito.id
  allowed_oauth_flows_user_pool_client = each.value.allowed_oauth_flows_user_pool_client
  callback_urls                        = each.value.callback_urls
  supported_identity_providers         = each.value.supported_identity_providers
  allowed_oauth_scopes                 = each.value.allowed_oauth_scopes
  allowed_oauth_flows                  = each.value.allowed_oauth_flows
  generate_secret                      = each.value.generate_secret
}

