variable "environment" {
  description = "The environment where the resources will be provision."
  type        = string
}

variable "pool_name" {
  description = "The name of the user pool."
  type        = string
}

variable "cognito_domain" {
  description = "The domain name for cognito client."
}

variable "auto_verified_attributes" {
  type        = list(string)
  description = "Valid attribute to be auto-verified. Possible values: email, phone_number."
}

variable "pool_clients" {
  description = "List of pool clients configuration, make sure name is unique within the list."
  type = list(object({
    name                                 = string
    allowed_oauth_flows_user_pool_client = bool
    callback_urls                        = list(string)
    supported_identity_providers         = list(string)
    allowed_oauth_scopes                 = list(string)
    allowed_oauth_flows                  = list(string)
    generate_secret                      = bool
  }))
}

variable "lambda_config" {
  description = "Contains the config for lambda with configname => arn format. This config usually came from lambda-function output."
  type = object({
    create_auth_challenge = optional(string)
    user_migration = optional(string)
    custom_message = optional(string)
    define_auth_challenge = optional(string)    
    post_authentication = optional(string)    
    post_confirmation = optional(string)
    pre_authentication = optional(string)
    pre_sign_up = optional(string)
  })
}