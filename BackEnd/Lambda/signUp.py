import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):

    client = boto3.client('cognito-idp', region_name='us-east-2')
    
    # Extract the email and password from the event body
    body = json.loads(event['body'])
    email = body['email']
    password = body['password']
    
    user_pool_id = 'us-east-2_PbmKiUp9w'
    client_id = '5mqnor5ufuojmi9c8q7dq9tfm0'
    
    try:
        # Attempt to sign up the user
        response = client.sign_up(
            ClientId=client_id,
            Username=email,
            Password=password,
            UserAttributes=[
                {
                    'Name': 'email',
                    'Value': email
                },
            ]
        )
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'User registration successful',
                'userSub': response['UserSub']
            })
        }
    except ClientError as e:
        # Handle Cognito errors (e.g., user already exists)
        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': 'Error registering user',
                'error': str(e)
            })
        }
    except Exception as e:
        # Handle unexpected errors
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Internal server error',
                'error': str(e)
            })
        }
