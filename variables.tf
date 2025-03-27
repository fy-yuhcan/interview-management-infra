variable "instance_type" {
  default = "t2.micro"
}

variable "ALB_SECURITY_GROUPS" {
  description = "ALB にアタッチするセキュリティグループ"
  type        = string
  sensitive   = true
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

variable "EC2_SECURITY_GROUP_ID" {
  description = "EC2 インスタンスにアタッチするセキュリティグループID"
  type        = string
  sensitive   = true
}

variable "EC2_SUBNET_ID" {
  description = "EC2 インスタンスを起動するサブネットID"
  type        = string
  sensitive   = true
}

variable "LOAD_BALANCER_ARN" {
  description = "ALB の ARN"
  type        = string
  sensitive   = true
}

variable "RDB_IDENTIFIER" {
  description = "RDS のインスタンス識別子"
  type        = string
  sensitive   = true
}

variable "RDB_PASSWORD" {
  description = "RDS のマスター・ユーザーのパスワード"
  type        = string
  sensitive   = true
}

variable "RDB_SECURITY_GROUP_ID" {
  description = "RDS にアタッチするセキュリティグループID"
  type        = string
  sensitive   = true
}

variable "RDB_SECURITY_GROUP_ID_2" {
  description = "RDS にアタッチするセキュリティグループID 2"
  type        = string
  sensitive   = true
}

variable "RDB_SUBNET_NAME" {
  description = "RDS サブネットグループ名"
  type        = string
  sensitive   = true
}

variable "RDB_USER_NAME" {
  description = "RDS のマスター・ユーザー名"
  type        = string
  sensitive   = true
}

variable "TARGET_GROUP_ARN" {
  description = "ALB のターゲットグループ ARN"
  type        = string
  sensitive   = true
}

variable "VPC_ID" {
  description = "VPC のID"
  type        = string
  sensitive   = true
}

variable "TF_BUCKET" {
  description = "Terraform のバックエンド用 S3 バケット名"
  type        = string
  sensitive   = true
}

variable "AWS_REGION" {
  description = "AWS リージョン"
  type        = string
  sensitive   = true
}