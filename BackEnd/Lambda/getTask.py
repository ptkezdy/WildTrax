import boto3
import json

# Initialize Boto3 DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='us-east-2')

def lambda_handler(event, context):
    table_name = 'TodoList'  # Ensure this matches your actual table name
    table = dynamodb.Table(table_name)

    # Extract userID from query string parameters
    userID = event['queryStringParameters'].get('userID')

    headers = {
        'Access-Control-Allow-Origin': '*',  
        'Access-Control-Allow-Methods': 'GET',
        'Access-Control-Allow-Headers': 'Content-Type'
    }

    if not userID:
        return {
            'statusCode': 400,
            'headers': headers,
            'body': json.dumps({'error': 'userID is a required field'})
        }
    
    try:
        # Query table for items with the given userID
        response = table.query(
            KeyConditionExpression='userID = :userID',
            ExpressionAttributeValues={
                ':userID': userID
            }
        )

        items = response.get('Items', [])

        if items:
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps(items)  # Returning the list of items directly
            }
        else:
            return {
                'statusCode': 404,
                'headers': headers,
                'body': json.dumps({'error': 'No items found for the given userID'})
            }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }