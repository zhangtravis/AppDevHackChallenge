import boto3

def upload_file(file_name, bucket):
  """
  Method used to upload a file to an S3 bucket

  @param file_name: Name of file to upload
  @param bucket: S3 bucket to upload to
  """
  s3_client = boto3.client('s3')
  response = s3_client.upload_file(file_name, bucket, file_name)
  
  return response

def download_file(file_name, bucket):
  """
  Method used to download a file from an S3 bucket

  @param file_name: Name of file to download
  @param bucket: S3 bucket to download from
  """
  s3 = boto3.resource('s3')
  download_dir = f'downloads/{file_name}'
  s3.Bucket(bucket).download_file(file_name, download_dir)

  return download_dir

def list_files(bucket):
  """
  Method to list files in a given S3 bucket

  @param bucket: S3 bucket to look into
  """
  s3 = boto3.client('s3')
  contents = []
  for item in s3.list_objects(Bucket=bucket)['Contents']:
    contents.append(item)

  return contents