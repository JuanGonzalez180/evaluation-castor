import AWS from 'aws-sdk';
import { 
  PresignedUrlRequest, 
  PresignedUrlResponse,
  FileRetrievalRequest,
  FileRetrievalResponse
} from '../types';
import { AppError, ErrorCode } from '../utils/error-handler';

/**
 * S3 Service class for common S3 operations
 */
export class S3Service {
  private s3: AWS.S3;
  private bucketName: string;
  private expiration: number;

  /**
   * Creates a new S3Service instance
   * @throws AppError if S3_BUCKET_NAME environment variable is not set
   */
  constructor() {
    this.s3 = new AWS.S3();
    this.bucketName = process.env.S3_BUCKET_NAME || '';
    this.expiration = parseInt(process.env.EXPIRATION || '3600');
    
    if (!this.bucketName) {
      throw new AppError(
        'S3_BUCKET_NAME environment variable is required',
        ErrorCode.INTERNAL_ERROR
      );
    }
  }

  /**
   * Generate a presigned URL for uploading a file to S3
   * 
   * @param request Upload request details
   * @returns Presigned URL and file information
   */
  public generatePresignedUrl(request: PresignedUrlRequest): PresignedUrlResponse {
    try {
      const { fileName, fileType, employeeId } = request;
      
      // Generate unique key for the S3 object
      const key = `employees/${employeeId}/photos/${Date.now()}-${fileName}`;
      
      // Configure parameters for the presigned URL
      const params: AWS.S3.PresignedPost.Params = {
        Bucket: this.bucketName,
        Fields: {
          key: key,
          'Content-Type': fileType
        },
        Expires: this.expiration
      };
      
      // Generate presigned URL for PUT
      const presignedUrl = this.s3.getSignedUrl('putObject', params);
      const expiresAt = Math.floor(Date.now() / 1000) + this.expiration;
      
      return {
        presignedUrl,
        fileKey: key,
        url: `https://${this.bucketName}.s3.amazonaws.com/${key}`,
        expiresAt
      };
    } catch (error) {
      console.error('Error generating presigned URL:', error);
      throw new AppError(
        'Failed to generate presigned URL',
        ErrorCode.S3_ERROR
      );
    }
  }

  /**
   * Generate a presigned URL for downloading a file from S3
   * 
   * @param request Download request details
   * @returns Download URL and file information
   */
  public async generateDownloadUrl(request: FileRetrievalRequest): Promise<FileRetrievalResponse> {
    try {
      const { fileKey, downloadFileName } = request;
      
      // Check if the object exists in the bucket
      try {
        await this.s3.headObject({
          Bucket: this.bucketName,
          Key: fileKey
        }).promise();
      } catch (error) {
        throw new AppError(
          `File not found: ${fileKey}`,
          ErrorCode.RESOURCE_NOT_FOUND
        );
      }
      
      // Get object metadata to determine content type
      const metadata = await this.s3.headObject({
        Bucket: this.bucketName,
        Key: fileKey
      }).promise();
      
      const contentType = metadata.ContentType || 'application/octet-stream';
      
      // Configure parameters for the presigned URL
      const params: AWS.S3.GetObjectRequest = {
        Bucket: this.bucketName,
        Key: fileKey,
        ResponseContentDisposition: downloadFileName 
          ? `attachment; filename="${downloadFileName}"` 
          : undefined
      };
      
      // Generate presigned URL for GET
      const downloadUrl = this.s3.getSignedUrl('getObject', {
        ...params,
        Expires: this.expiration
      });
      
      const expiresAt = Math.floor(Date.now() / 1000) + this.expiration;
      
      return {
        downloadUrl,
        fileName: downloadFileName || fileKey.split('/').pop() || 'download',
        contentType,
        expiresAt
      };
    } catch (error) {
      // Re-throw AppError instances
      if (error instanceof AppError) {
        throw error;
      }
      
      console.error('Error generating download URL:', error);
      throw new AppError(
        'Failed to generate download URL',
        ErrorCode.S3_ERROR
      );
    }
  }

  /**
   * Check if a file exists in S3
   * 
   * @param fileKey S3 object key
   * @returns True if the file exists, false otherwise
   */
  public async fileExists(fileKey: string): Promise<boolean> {
    try {
      await this.s3.headObject({
        Bucket: this.bucketName,
        Key: fileKey
      }).promise();
      
      return true;
    } catch (error) {
      return false;
    }
  }

  /**
   * Delete a file from S3
   * 
   * @param fileKey S3 object key
   * @returns True if the file was deleted, false if it didn't exist
   */
  public async deleteFile(fileKey: string): Promise<boolean> {
    try {
      // Check if file exists first
      const exists = await this.fileExists(fileKey);
      
      if (!exists) {
        return false;
      }
      
      // Delete the file
      await this.s3.deleteObject({
        Bucket: this.bucketName,
        Key: fileKey
      }).promise();
      
      return true;
    } catch (error) {
      console.error('Error deleting file:', error);
      throw new AppError(
        `Failed to delete file: ${fileKey}`,
        ErrorCode.S3_ERROR
      );
    }
  }
}

// Export a singleton instance
export default new S3Service();