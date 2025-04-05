/**
 * S3 presigned URL request interface
 */
export interface PresignedUrlRequest {
    fileName: string;
    fileType: string;
    employeeId: string;
}

/**
 * S3 presigned URL response interface
 */
export interface PresignedUrlResponse {
    presignedUrl: string;
    fileKey: string;
    url: string;
    expiresAt: number;
}

/**
 * S3 file retrieval request interface
 */
export interface FileRetrievalRequest {
    fileKey: string;
    downloadFileName?: string;
}

/**
 * S3 file retrieval response interface
 */
export interface FileRetrievalResponse {
    downloadUrl: string;
    fileName: string;
    contentType: string;
    expiresAt: number;
}