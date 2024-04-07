data "archive_file" "lambda5" {
  type        = "zip"
  source_file = "Lambda/getTask.py"
  output_path = "Lambda/getTask.zip"
}


resource "aws_lambda_function" "get_task" {
  function_name    = "getTask"
  handler          = "getTask.lambda_handler"
  role             = aws_iam_role.lambda_exec_4.arn
  runtime          = "python3.8"
  filename         = data.archive_file.lambda5.output_path
  source_code_hash = data.archive_file.lambda5.output_base64sha256
}



data "aws_iam_policy_document" "assume_role_5" {
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

resource "aws_iam_role" "lambda_exec_4" {
  name               = "lambda_execution_role_4"
  assume_role_policy = data.aws_iam_policy_document.assume_role_5.json

}


data "aws_iam_policy_document" "lambda_dynamodb_access_3" {
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query"
    ]
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/TodoList"] //adjust to correct database 
  }
}

resource "aws_iam_role_policy" "lambda_dynamodb_access_3" {
  name   = "lambda_dynamodb_access"
  role   = aws_iam_role.lambda_exec_4.id
  policy = data.aws_iam_policy_document.lambda_dynamodb_access_3.json
}
