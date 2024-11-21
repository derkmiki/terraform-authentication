terraform {
  required_version = "~>1.9.2"
  backend "s3" {
    bucket = "terraform-authentication-eaf"
    key = "dev/authentication-module/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "dev-authentication-module"    
  } 
}


# create the lambda functions
module "lambda_functions" {
  source = "./modules/lambda-function"
  environment = "${var.environment}"
  prefix = "${var.pool_name}"
  source_root = "${path.root}/src"
  sources = var.sources
}

#create the user pool
module "cognito" {
  source = "./modules/cognito"
  environment = "${var.environment}"
  pool_clients = var.pool_clients
  pool_name = "${var.pool_name}"
  cognito_domain = "${var.cognito_domain}"
  auto_verified_attributes = var.auto_verified_attributes
  lambda_config = module.lambda_functions.function_arns
}