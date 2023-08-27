import json
import pandas as pd
import boto3
from io import BytesIO

def lambda_handler(event, context):
    # TODO implement
    bucket=event['Records'][0]['s3']['bucket']['name']
    file = event['Records'][0]['s3']['object']['key'].replace('+',' ')
    print(f"Parsing transaction file '{file}' in {bucket}")

    return {
        'statusCode': 200,
        'body':parseFile(bucket,file)
    }
    
    
def parseFile(bucket, file):
    
    bucket_name=bucket
    file_key=file
    
    s3=boto3.resource('s3')
    file_object = s3.Object(bucket_name,file_key)
    file_content = file_object.get()['Body'].read()
    
    # Load bytes-like object directly into a DataFrame
    df = pd.read_csv(BytesIO(file_content))
    
    return df.head(10).to_json()