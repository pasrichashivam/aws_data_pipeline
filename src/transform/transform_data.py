from pyspark.sql import functions as f

def transform_data(df):
    df = df.withColumn('execution_date', f.to_date(f.current_date))
    return df