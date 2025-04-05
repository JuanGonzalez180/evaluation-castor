import {
    LambdaResponse,
    HttpHeaders,
    DEFAULT_CORS_HEADERS,
    ISuccessResponse,
    IErrorResponse
} from '../types';

/**
 * Format a success response
 * 
 * @template T - The type of the response data
 * @param {T} data - The response data to include in the success response
 * @param {string} [message] - An optional success message
 * @returns {ISuccessResponse<T>} - A formatted success response object
 */
export function formatSuccessResponse<T>(data: T, message?: string): ISuccessResponse<T> {
    return {
        success: true,
        data,
        ...(message && { message })
    };
}

/**
 * Format an error response
 * @param {string | Error} error Error message or object
 * @param {string} code Optional error code
 * @returns {IErrorResponse} Formatted error response
 */
export function formatErrorResponse(error: string | Error, code?: string): IErrorResponse {
    const errorMessage = error instanceof Error ? error.message : error;

    return {
        success: false,
        error: errorMessage,
        ...(code && { code })
    };
}

/**
 * Format a standardized HTTP response for API Gateway
 * 
 * @param {number} statusCode - HTTP status code
 * @param {Record<string, any> | string} body - Response body (will be JSON stringified)
 * @param {HttpHeaders} [headers={}] - Optional additional headers
 * @returns {LambdaResponse} Formatted Lambda response
 */
export function formatResponse(
    statusCode: number,
    body: Record<string, any> | string,
    headers: HttpHeaders = {}
): LambdaResponse {
    return {
        statusCode,
        headers: {
            'Content-Type': 'application/json',
            ...DEFAULT_CORS_HEADERS,
            ...headers
        },
        body: typeof body === 'string' ? body : JSON.stringify(body)
    };
}

/**
 * Creates a success HTTP response
 * 
 * @param {T} data Data to return in the response
 * @param {number} statusCode HTTP status code (defaults to 200)
 * @param {string} message Optional success message
 * @returns {LambdaResponse} Formatted Lambda success response
 */
export function successResponse<T>(
    data: T,
    statusCode: number = 200,
    message?: string
): LambdaResponse {
    return formatResponse(
        statusCode,
        formatSuccessResponse(data, message)
    );
}

/**
 * Creates an error HTTP response
 * 
 * @param {string | Error} error Error message or object
 * @param {number} statusCode HTTP status code (defaults to 500)
 * @param {string} code Optional error code
 * @returns {LambdaResponse} Formatted Lambda error response
 */
export function errorResponse(
    error: string | Error,
    statusCode: number = 500,
    code?: string
): LambdaResponse {
    return formatResponse(
        statusCode,
        formatErrorResponse(error, code)
    );
}