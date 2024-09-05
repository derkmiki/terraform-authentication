output "cognito_domain" {
    value = aws_cognito_user_pool_domain.cognito.domain
    description = "The created cognito domain."
}

output "user_pool_id" {
    value = aws_cognito_user_pool.cognito.id
    description = "The user pool id of created cognito user pool."
}

output "pool_client_ids" {
  value = { for key, client in aws_cognito_user_pool_client.cognito: key => client.id}
  description = "The mapped of created ids for each app client created."
}

