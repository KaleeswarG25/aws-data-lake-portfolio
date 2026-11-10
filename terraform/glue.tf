resource "aws_glue_catalog_database" "raw_db" {
  name = "${replace(local.name_prefix, "-", "_")}_raw"
}

resource "aws_glue_catalog_database" "curated_db" {
  name = "${replace(local.name_prefix, "-", "_")}_curated"
}

resource "aws_glue_crawler" "raw_crawler" {
  name          = "${local.name_prefix}-raw-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.raw_db.name
  table_prefix  = "raw_"

  s3_target {
    path = "s3://${aws_s3_bucket.lake.id}/raw/"
  }

  tags = local.tags
}

resource "aws_glue_crawler" "curated_crawler" {
  name          = "${local.name_prefix}-curated-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.curated_db.name
  table_prefix  = "curated_"

  s3_target {
    path = "s3://${aws_s3_bucket.lake.id}/curated/"
  }

  tags = local.tags
}

resource "aws_glue_job" "raw_to_curated" {
  name         = "${local.name_prefix}-raw-to-curated"
  role_arn     = aws_iam_role.glue_role.arn
  glue_version = "4.0"
  worker_type  = "G.1X"
  number_of_workers = 2

  command {
    script_location = "s3://${aws_s3_bucket.lake.id}/scripts/raw_to_curated.py"
    python_version  = "3"
  }

  default_arguments = {
    "--JOB_NAME"          = "${local.name_prefix}-raw-to-curated"
    "--RAW_PATH"          = "s3://${aws_s3_bucket.lake.id}/raw/"
    "--CURATED_PATH"      = "s3://${aws_s3_bucket.lake.id}/curated/"
    "--enable-continuous-cloudwatch-log" = "true"
  }

  tags = local.tags
}