data "archive_file" "init" {
  type        = "zip"
  source_file = "./scripts/lambda_function.py"
  output_path = "./scripts/lambda_function.zip"
}

resource "aws_lambda_function" "json_lambda" {
  filename      = data.archive_file.init.output_path
  function_name = "weekendsProcessJSONFeedsTf"
  role          = aws_iam_role.json_feed_role.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256(data.archive_file.init.output_path)

  runtime = "python3.8"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.json_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.json_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

# Granting permissions to s3 to invoke lambda function

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.json_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.json_bucket.arn
}