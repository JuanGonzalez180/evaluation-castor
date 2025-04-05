# Lambda for generating presigned URLs
module "lambda_presigned_url" {
    source = "./modules/lambda"
    
    lambda_name           = "presigned-url-generator"
    source_dir            = "lambdas/presigned-url"
    handler               = "index.handler"
    runtime               = "nodejs20.x"
    environment_variables = {
        S3_BUCKET_NAME = module.s3_storage.bucket_name
        EXPIRATION     = "3600"
    }
    environment           = var.environment
    
    # Add specific permissions for S3 access
    additional_policies = [
        module.s3_storage.s3_access_policy_arn
    ]
}

# # Lambda for retrieving files
# module "lambda_file_retriever" {
#     source = "./modules/lambda"
#     
#     lambda_name           = "file-retriever"
#     source_dir            = "lambdas/file-retriever"
#     handler               = "index.handler"
#     runtime               = "nodejs20.x"
#     environment_variables = {
#         S3_BUCKET_NAME = module.s3_storage.bucket_name
#         EXPIRATION     = "3600"
#     }
#     environment           = var.environment
#     
#     # Add specific permissions for S3 access
#     additional_policies = [
#         module.s3_storage.s3_access_policy_arn
#     ]
# }