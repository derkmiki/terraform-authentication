# Terraform Lambda Function

This module is lambda function implementation that is configured to cognito user pool triggers.
It creates couple of lambda functions based on the sources added in source root directory.

## How to use the module?


```hcl

module "lambda_functions" {
  source = "./lambda-function"
  environment = "dev"
  prefix = "test-pool"
  source_root = "../src"
  sources = ['pre_authentication', 'user_migration']
}

```

Note the following parameters:

* `environment`: The environment where the resources will be provision.

* `prefix`: The name of the user pool.

* `source_root`: The root working directory where the lambda function sources where saved.

* `sources`: The list of lambda function sources. These are the directories where lambda function files where saved.

Provided outputs:

* `function_arns`: The lambda function arns.


## LICENSE: 
MIT  
