#ロードバランサーの作成
resource "aws_lb" "app_alb" {
  name               = "interview-management"
  internal           = false #外部からのアクセス許可
  load_balancer_type = "application" #alb
  subnets            = [var.ALB_SUBNETS_A, var.ALB_SUBNET_C] #albを配置するサブネット

  security_groups = [var.ALB_SECURITY_GROUPS] #albのセキュリティグループ
}

#ターゲットグループの設定
resource "aws_lb_target_group" "app_tg" {
  name     = "interview-management"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPC_ID #ターゲットグループを配置するVPC

  health_check {
    path                = "/events" #ヘルスチェックのパス
    port                = "80" #ヘルスチェックのポート
    protocol            = "HTTP" #ヘルスチェックのプロトコル
    unhealthy_threshold = 2 #ヘルスチェックのしきい値
    healthy_threshold   = 2 #ヘルスチェックのしきい値
    interval            = 30 #ヘルスチェックの間隔
  }
}

#ターゲットグループのリスナー設定
#HTTPアクセスをHTTPSにリダイレクト
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = var.LOAD_BALANCER_ARN
  port              = 80
  protocol          = "HTTP"

  #リダイレクト設定
  default_action {
    type = "redirect"

    redirect {
        protocol    = "HTTPS"
        port        = "443"
        status_code = "HTTP_301"
    }
  }
}

#HTTPSリスナー設定
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = var.LOAD_BALANCER_ARN
  port              = 443
  protocol          = "HTTPS"
  
  #sslポリシーと証明書の設定
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.CERTIFICATE_ARN
  
  #ターゲットグループの設定
  default_action {
    type             = "forward"
    target_group_arn = var.TARGET_GROUP_ARN
  }
}
