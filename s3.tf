# Create S3 bucket

resource "aws_s3_bucket" "json_bucket" {
  bucket = "weekends-json-feeds-bucket"
  acl    = "private"
  depends_on = [
    aws_dynamodb_table.json_feeds_table
  ]
}
