import boto3
import pymssql
import pandas as pd
import json
from io import BytesIO, StringIO
from datetime import datetime

SERVER='database-1.cmvbubhpyb1l.us-east-2.rds.amazonaws.com'
DATABASE='finances'
USER='webuser'
PWD='HedgeH0g'

AWS_ACCESS_KEY=''
AWS_SECRET_KEY=''
    
def file_handler(event,context):
    
    print (f"File Handler started at { str(datetime.now())}")

    bucket=event['Records'][0]['s3']['bucket']['name']
    file = event['Records'][0]['s3']['object']['key'].replace('+',' ')

    session=boto3.Session(aws_access_key_id=AWS_ACCESS_KEY,aws_secret_access_key=AWS_SECRET_KEY)
    s3=session.resource('s3')
    file_contents=s3.Object(bucket,file).get()['Body'].read()
    fileLength=file_contents.decode('utf8').count('\n')-1

    print (f"Read {fileLength} lines from {bucket}/{file} ")

    sqlConn=pymssql.connect(SERVER,USER,PWD,DATABASE)
    sqlCursor=sqlConn.cursor()

    prepRawTableQuery = 'Truncate table raw.transaction_file'
    sqlCursor.execute(prepRawTableQuery)

    metaQuery='INSERT INTO raw.imported (import_id, filename, import_date ) SELECT next value for raw.imported_sq,%s,%s'
    sqlCursor.execute(metaQuery,(file,str(datetime.now())))
    sqlConn.commit()

    maxIdQuery = "SELECT max(import_id) iid from raw.imported where filename = %s"
    sqlCursor.execute(maxIdQuery,(file,))

    import_id=sqlCursor.fetchone()[0]
    df=pd.read_csv(BytesIO(file_contents))
    df['import_id']=import_id

    print(f"Import session {import_id} created")

    csv_buffer=StringIO()
    df.to_csv(csv_buffer,index=False)
    b=boto3.client('s3',region_name = 'us-east-2',aws_access_key_id = AWS_ACCESS_KEY,aws_secret_access_key = AWS_SECRET_KEY)
    b.put_object(Bucket=bucket,Key='work/transactions.csv',Body=csv_buffer.getvalue())

    sqlCursor.close()
    sqlConn.close()

    print(f"Transient File Created; starting glue...")

    glue=boto3.client('glue',region_name='us-east-2', aws_access_key_id = AWS_ACCESS_KEY,aws_secret_access_key = AWS_SECRET_KEY)
    #job=os.environ['glueJob']
    job='S3TransactionsToSQLRaw'

    response=glue.start_job_run(JobName=job)
    job_id=response['JobRunId']
    
    print(f"Started job {job} with job id {job_id} at {datetime.now()}")
    
    return {
        'statusCode': 200,
        'body':f"File Handler Complete: session id {import_id}"
    }

def import_handler(event,context):    

    print("process_handler starting")

    sqlConn=pymssql.connect(SERVER,USER,PWD,DATABASE)
    sqlCursor=sqlConn.cursor()

    importIdQuery="SELECT MIN(import_id) import_id from raw.transaction_file"
    sqlCursor.execute(importIdQuery)
    import_id=sqlCursor.fetchone()[0]

    importPrepQuery="""
            insert into bankTransactionLoad (transactionDate,OrigDescription,category,amount,memo,account,accountid,Classification) 
            select 
            [tf].[DATE],
            [tf].[description],
            [tf].[category],
            [tf].[amount],
            [tf].[tags],
            [tf].[account],
            a.accountid,
            cast([tf].[import_id] as varchar(255)) + '|'+cast([tf].[rn] as varchar(255)) 
            from raw.transaction_file tf inner join transactionAccount a on tf.account=a.transactionAccountName
    """

    sqlCursor.execute("delete dbo.bankTransactionLoad")
    sqlCursor.execute(importPrepQuery)
    
    sqlCursor.callproc("bankTransactionLoad_Process",("",import_id))
    sqlCursor.callproc("utilities.DailyBalance_updateAll",(0,))
    sqlCursor.callproc("utilities.autocategory_calculate")

    sqlConn.commit()
        
    
    sqlCursor.close()
    sqlConn.close()
    
    sns=boto3.client('sns',region_name='us-east-2',aws_access_key_id = AWS_ACCESS_KEY,aws_secret_access_key = AWS_SECRET_KEY)
    response = sns.publish(
        TargetArn="arn:aws:sns:us-east-2:189126084951:Finances",
        Message=json.dumps('Finance Update Complete')
    )
    return {
        'statusCode': 200,
        'body':"process_handler complete"
    }
