resource "aws_dynamodb_table" "todo_list" {
  name           = "TodoList"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userID"
  range_key      = "taskID"

  attribute {
    name = "userID"
    type = "S"
  }

  attribute {
    name = "taskID"
    type = "S"
  }

  
  
}