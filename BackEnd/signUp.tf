data "archive_file" "lambda3" {
  type        = "zip"
  source_file = "Lambda/signUp.py"
  output_path = "Lambda/signUp.zip"
}


resource "aws_lambda_function" "sign_up" {
  function_name    = "sign_up"
  handler          = "signUp.lambda_handler"
  role             = aws_iam_role.lambda_exec_2.arn
  runtime          = "python3.8"
  filename         = data.archive_file.lambda3.output_path
  source_code_hash = data.archive_file.lambda3.output_base64sha256
}



data "aws_iam_policy_document" "assume_role_3" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "lambda_exec_2" {
  name               = "lambda_execution_role_2"
  assume_role_policy = data.aws_iam_policy_document.assume_role_3.json

}