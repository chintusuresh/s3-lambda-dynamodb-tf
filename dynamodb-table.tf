# Create DynamoDB table

resource "aws_dynamodb_table" "json_feeds_table" {
  name           = "WEEKENDS_FEEDS"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}