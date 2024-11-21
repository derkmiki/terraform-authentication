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

  lambda_config {
    create_auth_challenge = var.lambda_config.create_auth_challenge == null ? null :  var.lambda_config.create_auth_challenge
    user_migration = var.lambda_config.user_migration == null ? null :  var.lambda_config.user_migration    
    custom_message = var.lambda_config.custom_message == null ? null :  var.lambda_config.custom_message    
    define_auth_challenge = var.lambda_config.define_auth_challenge == null ? null :  var.lambda_config.define_auth_challenge    
    post_authentication = var.lambda_config.post_authentication == null ? null :  var.lambda_config.post_authentication    
    post_confirmation = var.lambda_config.post_confirmation == null ? null :  var.lambda_config.post_confirmation           
    pre_authentication = var.lambda_config.pre_authentication == null ? null :  var.lambda_config.pre_authentication           
    pre_sign_up = var.lambda_config.pre_sign_up == null ? null :  var.lambda_config.pre_sign_up           
  }
}

resource "aws_lambda_permission" "cognito" {
  for_each = { for key, val in var.lambda_config: key => val if val != null }
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.cognito.arn
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

