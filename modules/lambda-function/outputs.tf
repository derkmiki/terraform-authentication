output "function_arns" {
  value   =  { 
      for function in aws_lambda_function.lambda_function :
          "${function.tags.config_name}" => function.arn
  }
  description = "The lambda function arns."
}
