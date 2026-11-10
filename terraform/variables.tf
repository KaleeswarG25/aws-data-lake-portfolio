variable "project" {
    description ="project name"
    type = "string"
    default="de-portfolio"
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}