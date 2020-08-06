resource "aws_route53_zone" "main" {
  name = "cardealers.services"
}

resource "aws_route53_zone" "YoMama" {
  name = "YoMama.cardealers.services"

  tags = {
    Environment = "YoMama"
  }
}

resource "aws_route53_record" "YoMama-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "YoMama.cardealers.services"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.YoMama.name_servers
}
