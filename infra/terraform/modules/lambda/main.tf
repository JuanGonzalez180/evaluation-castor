# Resource to build the Lambda function
resource "null_resource" "lambda_build" {
  # Executes local commands to install dependencies and build the project
  provisioner "local-exec" {
    command = "cd ${path.module}/../../../${var.source_dir} && npm install && npm run build"
  }

  # Forces a rebuild when the source code changes
  triggers = {
    source_code_hash = filebase64sha256("${path.module}/../../../${var.source_dir}/src/")
  }
}

# Create the ZIP file for the Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../${var.source_dir}/dist"
  output_path = "${path.module}/lambda-${var.lambda_name}-${var.environment}.zip"
  
  depends_on = [null_resource.lambda_build]
}

# Create the IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_name}-role-${var.environment}"

  # Trust policy to allow Lambda to assume this role
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

  tags = {
    Name        = "${var.lambda_name}-role"
    Environment = var.environment
  }
}

# IAM policy for CloudWatch logs
resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.lambda_name}-logging-${var.environment}"
  description = "IAM policy for Lambda function logging"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach the logging policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

# Attach additional policies to the Lambda role
resource "aws_iam_role_policy_attachment" "additional_policies" {
  count      = length(var.additional_policies)
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.additional_policies[count.index]
}

# Lambda function resource
resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.lambda_name}-${var.environment}"
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size

  # Environment variables for the Lambda function
  environment {
    variables = var.environment_variables
  }
  
  tags = {
    Name        = var.lambda_name
    Environment = var.environment
  }
}