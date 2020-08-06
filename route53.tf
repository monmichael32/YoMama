resource "aws_route53_zone" "main" {
  name = "considerthesource.io"
}

resource "aws_route53_record" "YoMama-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "YoMama-ns.considerthesource.io"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.main.name_servers
}

resource "aws_route53_record" "YoMama" {
  name = "YoMama.considerthesource.io"
  zone_id = aws_route53_zone.main.zone_id
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.default.dns_name]
  #tags = {
    #Environment = "YoMama"
  #}
}

  
