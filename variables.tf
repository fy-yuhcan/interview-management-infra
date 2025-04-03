variable "instance_type" {
  default = "t2.micro"
}


variable "ALB_SUBNET_C" {
  description = "ALB を配置するサブネットID (AZ C)"
  type        = string
  sensitive   = true
}

variable "ALB_SUBNETS_A" {
  description = "ALB を配置するサブネットID (AZ A)"
  type        = string
  sensitive   = true
}

variable "CERTIFICATE_ARN" {
  description = "ACM で発行した証明書の ARN"
  type        = string
  sensitive   = true
}

variable "CODE_DEPLOY_SERVICE_ROLE_ARN" {
  description = "CodeDeploy のサービスロールの ARN"
  type        = string
  sensitive   = true
}

variable "EC2_AMI" {
  description = "EC2 インスタンス用の AMI ID"
  type        = string
  sensitive   = true
}

variable "RDB_PASSWORD" {
  description = "RDS のマスター・ユーザーのパスワード"
  type        = string
  sensitive   = true
}

variable "RDB_USER_NAME" {
  description = "RDS のマスター・ユーザー名"
  type        = string
  sensitive   = true
}


variable "VPC_ID" {
  description = "VPC のID"
  type        = string
  sensitive   = true
}

variable "RDB_PVT_SUBNET_1"{
  description = "RDS サブネットグループ名"
  type        = string
  sensitive   = true
}

variable "RDB_PVT_SUBNET_2"{
  description = "RDS サブネットグループ名"
  type        = string
  sensitive   = true
}