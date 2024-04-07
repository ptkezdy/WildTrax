import boto3
import json
from decimal import Decimal

dynamodb = boto3.resource('dynamodb', region_name='us-east-2')

def lambda_handler(event, context):
    try:

        headers = {
        'Access-Control-Allow-Origin': '*',  
        'Access-Control-Allow-Methods': 'OPTIONS, GET, PUT',
        'Access-Control-Allow-Headers': 'Content-Type'
        }


        
        table = dynamodb.Table('TodoList')
        body = json.loads(event['body'])

        # Mandatory fields check
        mandatory_fields = ['userID', 'name', 'type']
        if not all(field in body for field in mandatory_fields):
            return {'statusCode': 400, 'body': json.dumps({'error': 'Missing mandatory field'})}
        
        # make sure 
        if body.get('type').lower() not in ['event', 'task']:
            return {'statusCode': 400, 'body' : json.dumps({'error': 'Missing mandatory field'})}
        
        

        # Update or create the item in DynamoDB
        response = table.put_item(
            Item={
                'userID': body.get('userID'),
                'taskID': body.get('taskID'),
                'name': body.get('name'),
                'desc': body.get('desc'),
                'startDate': body.get('startDate'),
                'endDate': body.get('endDate'),
                'type': body.get('type'),
                'complete': False # item getting added should automatically be false 
            }
        )
        
        return {'statusCode': 200, 'headers': headers, 'body': json.dumps('Operation successful')}

    except Exception as e:
        return {'statusCode': 500, 'headers': headers, 'body': json.dumps({'error': str(e)})}
