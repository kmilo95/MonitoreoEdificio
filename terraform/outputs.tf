output "pre_landing_zone_bucket" {
  value = aws_s3_bucket.pre_landing_zone.id
}

output "landing_zone_bucket" {
  value = aws_s3_bucket.landing_zone.id
}
