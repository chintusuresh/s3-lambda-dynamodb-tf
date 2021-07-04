resource "aws_iam_role_policy" "json_feed_policy" {
  name = "weekends_json_feed_policy"
  role = aws_iam_role.json_feed_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
            "Sid" = "Stmt1625283308906",
            "Action" = [
                "s3:GetObject"
            ],
            "Effect" = "Allow",
            "Resource" = "${aws_s3_bucket.json_bucket.arn}/*"
        },
        {
            "Sid" = "Stmt1625283420359",
            "Action" = [
                "dynamodb:PutItem"
            ],
            "Effect" = "Allow",
            "Resource" = aws_dynamodb_table.json_feeds_table.arn
        },
        {
            "Sid" = "Stmt1625283440661",
            "Action" = "logs:*",
            "Effect" = "Allow",
            "Resource" = "*"
        }
    ]
  })
}

resource "aws_iam_role" "json_feed_role" {
  name = "weekend_json_feed_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}