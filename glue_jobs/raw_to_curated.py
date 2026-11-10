"""
Glue PySpark job: raw CSV -> cleaned Parquet (curated layer).

Business logic:
- Drop rows with null in required fields (id, event_ts, amount)
- Cast types, derive date partition (dt)
- Deduplicate on id keeping latest event_ts
- Write Parquet partitioned by dt
"""
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext
from pyspark.sql import functions as F


def clean_data(df):
    """Transformations used by both the Glue job and unit tests."""
    required = ["id", "event_ts", "amount", "customer"]
    df = df.dropna(subset=required)
    df = df.withColumn("event_ts", F.to_timestamp("event_ts"))
    df = df.withColumn("amount", F.col("amount").cast("double"))
    df = df.withColumn("dt", F.to_date("event_ts"))
    df = df.dropDuplicates(["id"])
    return df


def main():
    args = getResolvedOptions(sys.argv, ["JOB_NAME", "RAW_PATH", "CURATED_PATH"])
    sc = SparkContext()
    glue = GlueContext(sc)
    spark = glue.spark_session
    job = Job(glue)
    job.init(args["JOB_NAME"], args)

    raw = spark.read.option("header", "true").csv(args["RAW_PATH"])
    curated = clean_data(raw)

    (curated.write
        .mode("overwrite")
        .partitionBy("dt")
        .parquet(args["CURATED_PATH"]))

    job.commit()


if __name__ == "__main__":
    main()