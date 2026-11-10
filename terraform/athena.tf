resource "aws_athena_workgroup" "analytics" {
  name = "${local.name_prefix}-wg"

  configuration {
    enforce_workgroup_configuration = true
    result_configuration {
      output_location = "s3://${aws_s3_bucket.lake.id}/athena-results/"
    }
  }

  tags = local.tags
}