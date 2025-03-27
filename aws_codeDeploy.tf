#codeDeployの設定
resource "aws_codedeploy_app" "app" {
  name = "interview-management"
}

#codedeployデプロイメントグループの作成
resource "aws_codedeploy_deployment_group" "app_group" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = "aws-code-deploy-group"
  #codedeployが使うロール
  service_role_arn      = var.CODE_DEPLOY_SERVICE_ROLE_ARN
  #一台ずつデプロイ
  deployment_config_name = "CodeDeployDefault.OneAtATime"

  #トラフィック制御あり、ec3インスタンスをその場で更新
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
  #ターゲットグループに紐付け
  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.app_tg.name
    }
  }
  #デプロイ失敗時に自動ロールバック
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  #デプロイ対象のインスタンスを特定
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      value = "interview-management"
      type  = "KEY_AND_VALUE"
    }
  }
}

