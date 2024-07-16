provider "aws" {
  region = var.aws_region
}

# Crear Buckets de S3
resource "aws_s3_bucket" "pre_landing_zone" {
  bucket = "pre-landing-zone"

  # Crear carpetas dentro del bucket
  resource "aws_s3_bucket_object" "sdz_folder" {
    bucket = aws_s3_bucket.pre_landing_zone.bucket
    key    = "SDZ/"
  }

  resource "aws_s3_bucket_object" "error_folder" {
    bucket = aws_s3_bucket.pre_landing_zone.bucket
    key    = "ERROR/"
  }

  resource "aws_s3_bucket_object" "gsdz_folder" {
    bucket = aws_s3_bucket.pre_landing_zone.bucket
    key    = "GSDZ/"
  }
}

resource "aws_s3_bucket" "landing_zone" {
  bucket = "landing-zone"

  # Crear carpetas dentro del bucket
  resource "aws_s3_bucket_object" "lsdz_folder" {
    bucket = aws_s3_bucket.landing_zone.bucket
    key    = "LSDZ/"
  }

  resource "aws_s3_bucket_object" "error_folder" {
    bucket = aws_s3_bucket.landing_zone.bucket
    key    = "ERROR/"
  }
}

# Crear función Lambda
resource "aws_lambda_function" "process_sdz" {
  filename         = "lambda_function.zip"
  function_name    = "process_sdz"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.8"
}

# Rol para Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Adjuntar políticas al rol de Lambda
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Configurar evento S3 para Lambda
resource "aws_s3_bucket_notification" "pre_landing_zone_notification" {
  bucket = aws_s3_bucket.pre_landing_zone.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_sdz.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "SDZ/"
  }

  depends_on = [
    aws_lambda_permission.allow_s3_to_invoke
  ]
}

# Permiso para que S3 invoque Lambda
resource "aws_lambda_permission" "allow_s3_to_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_sdz.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.pre_landing_zone.arn
}

# Crear Job de AWS Glue para GSDZ
resource "aws_glue_job" "gsdz_job" {
  name     = "gsdz_job"
  role_arn = aws_iam_role.glue_exec.arn

  command {
    name            = "glueetl"
    script_location = "s3://path-to-glue-scripts/glue_script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language" = "python"
  }
}

# Crear Job de AWS Glue para LSDZ
resource "aws_glue_job" "lsdz_job" {
  name     = "lsdz_job"
  role_arn = aws_iam_role.glue_exec.arn

  command {
    name            = "glueetl"
    script_location = "s3://path-to-glue-scripts/glue_script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language" = "python"
  }
}

# Rol para AWS Glue
resource "aws_iam_role" "glue_exec" {
  name = "glue_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

# Adjuntar políticas al rol de Glue
resource "aws_iam_role_policy_attachment" "glue_policy" {
  role       = aws_iam_role.glue_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Configurar evento S3 para AWS Glue GSDZ
resource "aws_s3_bucket_notification" "gsdz_bucket_notification" {
  bucket = aws_s3_bucket.pre_landing_zone.id

  eventbridge {
    eventbridge_enabled = true
  }

  depends_on = [
    aws_s3_bucket.pre_landing_zone,
    aws_glue_job.gsdz_job
  ]
}

# Configurar evento S3 para AWS Glue LSDZ
resource "aws_s3_bucket_notification" "lsdz_bucket_notification" {
  bucket = aws_s3_bucket.landing_zone.id

  eventbridge {
    eventbridge_enabled = true
  }

  depends_on = [
    aws_s3_bucket.landing_zone,
    aws_glue_job.lsdz_job
  ]
}
