resource "aws_s3_bucket" "lake" {
  bucket        = "${local.name_prefix}-lake-${random_id.suffix.hex}"
  force_destroy = true
  tags          = local.tags
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_object" "raw_prefix" {
    bucket=aws_s3_bucket.lake.id
    content=""
    key="raw/
}

resource "aws_s3_object" "processed_prefix" {
    bucket=aws_s3_bucket.lake.id
    content=""
    key="processed/"
}
resource "aws_s3_object" "curated_prefix" {
    bucket=aws_s3_bucket.lake.id
    content=""
    key="curated/"
}
resource "aws_s3_bucket_versioning" "lake" {
  bucket = aws_s3_bucket.lake.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "lake" {
  bucket = aws_s3_bucket.lake.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}