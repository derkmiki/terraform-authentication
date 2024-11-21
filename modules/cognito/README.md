# Terraform Cognito

This module is cognito implementation allows a user pool to be attached to multiple app clients.
Triggers can be added to cognito via lambda_config which came from lambda-function module output.

## How to use the module?


```hcl
module "cognito" {
  source = "../cogito"

  environment = "dev"
  pool_name = "test-pool"
  cognito_domain = "testpool"
  auto_verified_attributes = []
  pool_clients = [
    {
        name                                 = "client-1"
        allowed_oauth_flows_user_pool_client = true
        callback_urls = [
            "http://localhost",
        ]
        supported_identity_providers = ["COGNITO"]
        allowed_oauth_scopes         = ["email", "openid", "profile", "aws.cognito.signin.user.admin"]
        allowed_oauth_flows          = ["code", "implicit"]
    }
  ]
  lambda_config = {
    create_auth_challenge = "lambda.function.arn"
    user_migration = "lambda.function.arn"
  }
}
```

Note the following parameters:

* `environment`: The environment where the resources will be provision.

* `pool_name`: The name of the user pool.

* `cognito_domain`: The domain name for cognito client.

* `auto_verified_attributes`: Valid attribute to be auto-verified. Possible values: email, phone_number.

* `pool_clients`: List of pool clients configuration, make sure name is unique within the list.

* `lambda_config`: Contains the config for lambda with configname => arn format. This config usually came from lambda-function output.

Provided outputs:

* `cognito_domain`: The created cognito domain.

* `user_pool_id`: The user pool id of created cognito user pool.

* `pool_client_ids`: The mapped of created ids for each app client created.


## LICENSE: 
MIT  