import { 
    LambdaEvent, 
    PresignedUrlRequest,
    s3Service,
    successResponse,
    errorResponse,
    withErrorHandling,
    validateRequiredFields,
    ErrorCode
  } from '@castor/common';
  
  /**
   * Handler for generating presigned URLs for S3 file uploads
   * 
   * @param event API Gateway event
   * @returns API Gateway response
   */
  const handler = async (event: LambdaEvent) => {
    // Validate HTTP method
    if (event.httpMethod !== 'POST') {
      return errorResponse(
        'Method not allowed',
        405,
        ErrorCode.INVALID_INPUT
      );
    }
    
    // Validate request body
    if (!event.body) {
      return errorResponse(
        'Request body is required',
        400,
        ErrorCode.INVALID_INPUT
      );
    }
    
    // Parse request body
    let requestBody: PresignedUrlRequest;
    try {
      requestBody = JSON.parse(event.body) as PresignedUrlRequest;
    } catch (error) {
      return errorResponse(
        'Invalid JSON in request body',
        400,
        ErrorCode.INVALID_INPUT
      );
    }
    
    // Validate required fields
    validateRequiredFields(requestBody, ['fileName', 'fileType', 'employeeId']);
    
    // Generate presigned URL using the common S3 service
    const presignedUrlResponse = s3Service.generatePresignedUrl(requestBody);
    
    // Return successful response
    return successResponse(presignedUrlResponse, 200, 'Presigned URL generated successfully');
  };
  
  // Export the handler with error handling wrapper
  export const lambdaHandler = withErrorHandling(handler);