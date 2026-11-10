output "raw_bucket_name" {
  value = aws_s3_bucket.lake.id
}

output "glue_job_name" {
  value = aws_glue_job.raw_to_curated.name
}

output "athena_workgroup" {
  value = aws_athena_workgroup.analytics.name
}

output "curated_database" {
  value = aws_glue_catalog_database.curated_db.name
}