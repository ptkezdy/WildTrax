resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"] // allows anyone to send request, need to change 
    allow_methods = ["POST", "GET", "OPTIONS"]
    allow_headers = ["content-type"]
    max_age       = 300
  }
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_hackathon.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "sign_up" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.sign_up.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "sign_up" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /signUp"
  target    = "integrations/${aws_apigatewayv2_integration.sign_up.id}"
}

resource "aws_cloudwatch_log_group" "api_gw_hackathon" {
  name = "/aws/api_gw_hackathon/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sign_up.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}


output "http_api_url" {
  value       = aws_apigatewayv2_api.lambda.api_endpoint
  description = "The endpoint URL of the HTTP API Gateway"
}


/*
Lambda funcion for puting new events/tasks in DB
*/


resource "aws_apigatewayv2_integration" "put_task" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.put_task.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "put_task" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /putTask"
  target    = "integrations/${aws_apigatewayv2_integration.put_task.id}"
}


resource "aws_lambda_permission" "api_gw_put" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_task.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}


/*

Lambda function for getting events 

*/


resource "aws_apigatewayv2_integration" "get_task" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.get_task.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_task" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /getTask"
  target    = "integrations/${aws_apigatewayv2_integration.get_task.id}"
}


resource "aws_lambda_permission" "api_gw_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_task.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}