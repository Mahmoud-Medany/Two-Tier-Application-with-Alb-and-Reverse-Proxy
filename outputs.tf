output "external_alb_dns" {
  value       = "http://${aws_lb.external.dns_name}"
  description = "Copy this URL to your browser to test the architecture"
}