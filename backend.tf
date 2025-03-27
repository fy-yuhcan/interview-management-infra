terraform {
  backend "s3" {
    #terraform用のバケット作成
    bucket  = var.TF_BUCKET
    #stateファイル
    key     = "terraform.tfstate" 
    region  = var.AWS_REGION
    #暗号化
    encrypt = true
  }
}
