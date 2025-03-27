terraform {
  backend "s3" {
    #terraform用のバケット作成
    bucket  = "my-interview-management-terraform" 
    #stateファイル
    key     = "terraform.tfstate" 
    region  = "ap-northeast-1"
    #暗号化
    encrypt = true
  }
}
