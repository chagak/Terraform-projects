resource "aws_acm_certificate" "cert" {
  domain_name       = "fodek.homes"
  validation_method = "DNS"
  
  tags = {
    Name = "fodek.homes"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Add validation resource
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
  
  depends_on = [aws_route53_record.cert_validation]  # Ensure records exist before validation
}

