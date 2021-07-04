import json
import boto3

s3_client = boto3.client('s3')

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('JAVAHOME_FEED')

def lambda_handler(event, context):
    data = get_s3_file(event)
    print(event)
    table.put_item(
        Item = {
            "id": data["id"],
            "name": data["name"]
        } 
    )

def get_s3_file(event):
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    # get file from S3
    s3_resp = s3_client.get_object(
        Bucket = bucket_name,
        Key = file_key
    )
    data = s3_resp['Body'].read().decode('utf-8')
    data = json.loads(data)
    return data
