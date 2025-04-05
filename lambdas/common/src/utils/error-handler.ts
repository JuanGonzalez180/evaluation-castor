import { errorResponse } from './response';
import { LambdaEvent, LambdaResponse } from '../types';

/**
 * Error codes for common error scenarios
 */
export enum ErrorCode {
    INVALID_INPUT = 'INVALID_INPUT',
    RESOURCE_NOT_FOUND = 'RESOURCE_NOT_FOUND',
    UNAUTHORIZED = 'UNAUTHORIZED',
    FORBIDDEN = 'FORBIDDEN',
    INTERNAL_ERROR = 'INTERNAL_ERROR',
    S3_ERROR = 'S3_ERROR'
}

/**
 * Map of HTTP status codes to use for each error code
 */
const ERROR_STATUS_CODES: Record<ErrorCode, number> = {
    [ErrorCode.INVALID_INPUT]: 400,
    [ErrorCode.RESOURCE_NOT_FOUND]: 404,
    [ErrorCode.UNAUTHORIZED]: 401,
    [ErrorCode.FORBIDDEN]: 403,
    [ErrorCode.INTERNAL_ERROR]: 500,
    [ErrorCode.S3_ERROR]: 500
};

/**
 * Custom error class with additional properties
 */
export class AppError extends Error {
    code: ErrorCode;
    statusCode: number;

    constructor(message: string, code: ErrorCode = ErrorCode.INTERNAL_ERROR) {
        super(message);
        this.name = this.constructor.name;
        this.code = code;
        this.statusCode = ERROR_STATUS_CODES[code];

        // Ensures proper stack trace in NodeJS
        Error.captureStackTrace(this, this.constructor);
    }
}

/**
 * Global error handler for Lambda functions
 * 
 * @param handler Lambda handler function
 * @returns Wrapped handler function with error handling
 */
export function withErrorHandling(
    handler: (event: LambdaEvent) => Promise<LambdaResponse>
): (event: LambdaEvent) => Promise<LambdaResponse> {
    return async (event: LambdaEvent): Promise<LambdaResponse> => {
        try {
            return await handler(event);
        } catch (error) {
            console.error('Error processing request:', error);

            if (error instanceof AppError) {
                return errorResponse(error.message, error.statusCode, error.code);
            }

            return errorResponse(
                'An unexpected error occurred',
                500,
                ErrorCode.INTERNAL_ERROR
            );
        }
    };
}

/**
 * Validates that required fields exist in an object
 * 
 * @param obj Object to validate
 * @param requiredFields Array of required field names
 * @throws AppError if any required field is missing
 */
export function validateRequiredFields<T>(obj: T, requiredFields: (keyof T)[]): void {
    const missingFields = requiredFields.filter(field => !obj[field]);

    if (missingFields.length > 0) {
        throw new AppError(
            `Missing required fields: ${missingFields.join(', ')}`,
            ErrorCode.INVALID_INPUT
        );
    }
}