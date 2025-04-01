#既存のvpcを使用する
data "aws_vpc" "existing_vpc" {
    id = var.VPC_ID
}

#既存のセキュリティグループを使用する
data "aws_subnet" "alb_subnet_a" {
  id = var.ALB_SUBNETS_A
}

data "aws_subnet" "alb_subnet_c" {
  id = var.ALB_SUBNET_C
}

data "aws_subnet" "private_a" {
  id = var.RDB_PVT_SUBNET_1
}

data "aws_subnet" "private_b" {
  id = var.RDB_PVT_SUBNET_2
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}


#ロードバランサーの作成
resource "aws_lb" "app_alb" {
  name               = "interview-management"
  internal           = false #外部からのアクセス許可
  load_balancer_type = "application" #alb
  subnets            = [data.aws_subnet.alb_subnet_a,data.aws_subnet.alb_subnet_c] #albを配置するサブネット

  security_groups = [aws_security_group.alb_sg.id] #albのセキュリティグループ
}

#ターゲットグループの設定
resource "aws_lb_target_group" "app_tg" {
  name     = "interview-management"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.existing_vpc.id #ターゲットグループを配置するVPC

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
  load_balancer_arn = aws_lb.app_alb.arn
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
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  
  #sslポリシーと証明書の設定
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.CERTIFICATE_ARN
  
  #ターゲットグループの設定
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
