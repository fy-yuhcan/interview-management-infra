output "alb_dns" {
  value = aws_lb.app_alb.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.app_db.endpoint
}
