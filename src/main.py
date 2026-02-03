
import sys
import os
print("sys.executable:", sys.executable)
print("PYSPARK_PYTHON:", os.environ.get("PYSPARK_PYTHON"))
print("PYSPARK_DRIVER_PYTHON:", os.environ.get("PYSPARK_DRIVER_PYTHON"))
print("CWD:", os.getcwd())
print("Files:", os.listdir("."))
print("System: ", sys.version)
print("ENV:", os.environ.get("app_env"))

from pyspark.sql import SparkSession
from zipfile import ZipFile
from pyspark.sql import functions as f


with ZipFile('/home/hadoop/pyfiles.zip', 'r') as zip_ref:
    zip_ref.extractall("/home/hadoop/")

env = 'dev'
spark = SparkSession.builder.appName("emr-serverless-job").getOrCreate()

input_path = f"s3://raw-bucket-{env}-source/data/leagues.csv"
output_db = f"aa_teams_{env}_analytics"
output_table = "teams_table"

def transform_data(df):
    df = df.withColumn('execution_date', f.current_date())
    return df

# from transform import transform_data
df = spark.read.csv(input_path, header=True)
result_df = transform_data(df)

result_df.write.mode("overwrite").format("parquet") \
    .saveAsTable(f"{output_db}.{output_table}")
