from pyspark.sql import SparkSession
from transform import transform_data
import chispa

print("Chispa Version", chispa.__version__)
env = 'dev'
spark = SparkSession.builder.appName("emr-serverless-job").getOrCreate()

input_path = f"s3://raw-bucket-{env}-source/data/leagues.csv"
output_db = f"{env}_analytics"
output_table = "processed"

df = spark.read.csv(input_path, header=True)
result_df = transform_data(df)

result_df.write.mode("overwrite").format("parquet") \
    .saveAsTable(f"{output_db}.{output_table}")
