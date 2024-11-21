# Terraform Authentication

An implementation of AWS authentication provisioned via terraform.

This project contains two modules:
- lambda-function
- cogito

## Module lambda-function 

This module is lambda function implementation that is configured to cognito user pool triggers.
It creates couple of lambda functions based on the sources added in source root directory.

## Module cognito

This module is cognito implementation allows a user pool to be attached to multiple app clients.
Triggers can be added to cognito via lambda_config which came from lambda-function module output.

## When Adding new source do the following

1. Add the new source code by creating new folder in src directory.
2. The folder contains all the needed file to be zipped. 
3. Make sure the main js is named main.js and has handler function.
4. Create your own terraform.tfvars in parent directory.
5. Add the new source in terraform.tfvars under sources configuration.
6. Run the following:
`
terraform apply --target "module.lambda_functions"
`
then
`
terraform apply
`

## LICENSE: 
MIT