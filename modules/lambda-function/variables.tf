variable "environment" {
  description = "The environment where the resources will be provision."
  type        = string
}

variable "sources" {
  description = "The list of lambda function sources. These are the directories where lambda function files where saved"
  type        =  list(string)
}

variable "prefix" {
  description = "The lambda function name prefix"
  type = string
}

variable "source_root" {
    description = "The  root working directory where the lambda function sources where saved"
  type = string
}

