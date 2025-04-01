provider "aws" {
  region = "ap-northeast-1"
}

# バケットの作成
resource "aws_s3_bucket" "deploy_bucket" {
  bucket = "my-interview-management"

  tags = {
    Name = "interview-management-deploy-bucket"
  }
}

# バケットのバージョニング設定
resource "aws_s3_bucket_versioning" "deploy_bucket_versioning" {
  bucket = aws_s3_bucket.deploy_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# バケットのライフサイクル設定
resource "aws_s3_bucket_lifecycle_configuration" "deploy_bucket_lifecycle" {
  bucket = aws_s3_bucket.deploy_bucket.id

  rule {
    id     = "expire-objects"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 90
    }
  }
}
