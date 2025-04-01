#albに接続する
resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 80
}

#ec2インスタンスを作成
resource "aws_instance" "app_server" {
  ami                         = var.EC2_AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.alb_subnet_a.id
  #セキュリティグループ
  vpc_security_group_ids          = [aws_security_group.alb_sg.id]
  #codedeployアクセス用のIAMロール
  iam_instance_profile        = "codedeploy"
  associate_public_ip_address = true
  #インスタンス起動時に実行するスクリプト
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              
              # nginxとPHP-FPMをインストール
              yum install -y nginx php-fpm php-cli php-json php-mysqlnd php-gd php-xml php-mbstring php-bcmath php-tokenizer
              
              # nginxとphp-fpmの起動と自動起動設定
              systemctl start nginx
              systemctl enable nginx
              systemctl start php-fpm
              systemctl enable php-fpm

              # CodeDeployAgentをインストール
              yum install -y ruby wget
              cd /home/ec2-user
              wget https://aws-codedeploy-ap-northeast-1.s3.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              systemctl start codedeploy-agent
              systemctl enable codedeploy-agent

              yum install -y amazon-ssm-agent
              systemctl start amazon-ssm-agent
              systemctl enable amazon-ssm-agent

              # Composerのインストール
              curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
              EOF

  tags = {
    Name = "interview-management"
  }
}
