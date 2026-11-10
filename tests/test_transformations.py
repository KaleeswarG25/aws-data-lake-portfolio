import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pytest
from pyspark.sql import SparkSession
from glue_jobs.raw_to_curated import clean_data


@pytest.fixture(scope="session")
def spark():
    return (SparkSession.builder
            .master("local[1]")
            .appName("test")
            .getOrCreate())


def test_clean_data_drops_nulls_and_dupes(spark):
    df = spark.createDataFrame([
        ("1", "2024-01-01T00:00:00", "cust_a", 10.0, "A"),
        ("2", "2024-01-01T01:00:00", None,     20.0, "B"),  # null customer
        ("3", "2024-01-01T02:00:00", "cust_c", None, "C"),  # null amount
        ("1", "2024-01-02T00:00:00", "cust_a", 15.0, "A"),  # dup id
    ], ["id", "event_ts", "customer", "amount", "product"])

    result = clean_data(df)

    ids = [r["id"] for r in result.collect()]
    assert set(ids) == {"1"}              # only id=1 survives
    assert result.count() == 1
    assert "dt" in result.columns         # date partition derived