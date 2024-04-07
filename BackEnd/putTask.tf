data "archive_file" "lambda4" {
  type        = "zip"
  source_file = "Lambda/putTask.py"
  output_path = "Lambda/putTask.zip"
}


resource "aws_lambda_function" "put_task" {
  function_name    = "putTask"
  handler          = "putTask.lambda_handler"
  role             = aws_iam_role.lambda_exec_3.arn
  runtime          = "python3.8"
  filename         = data.archive_file.lambda4.output_path
  source_code_hash = data.archive_file.lambda4.output_base64sha256
}



data "aws_iam_policy_document" "assume_role_4" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

// should have all iam polices one file and import 

resource "aws_iam_role" "lambda_exec_3" {
  name               = "lambda_execution_role_3"
  assume_role_policy = data.aws_iam_policy_document.assume_role_4.json

}


data "aws_iam_policy_document" "lambda_dynamodb_access_2" {
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
    ]
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/TodoList"] //adjust to correct database 
  }
}

resource "aws_iam_role_policy" "lambda_dynamodb_access_2" {
  name   = "lambda_dynamodb_access"
  role   = aws_iam_role.lambda_exec_3.id
  policy = data.aws_iam_policy_document.lambda_dynamodb_access_2.json
}

