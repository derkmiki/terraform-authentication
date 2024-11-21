variable "environment" {
  description = "The environment where the resources will be provision."
  type        = string
}

variable "pool_name" {
  description = "The name of the user pool."
  type        = string
}

variable "sources" {
  description = "The list of source of lambda function files. These are folders under the src"
  type = list(string)
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
