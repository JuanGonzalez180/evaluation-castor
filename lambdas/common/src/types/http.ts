import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';

/**
 * Base response interface for all API responses
 */
export interface IBaseResponse {
    success: boolean;
    message?: string;
}

/**
 * Success response interface
 */
export interface ISuccessResponse<T> extends IBaseResponse {
    success: true;
    data: T;
}

/**
 * Error response interface
 */
export interface IErrorResponse extends IBaseResponse {
    success: false;
    error: string;
    code?: string;
}

/**
 * HTTP headers type
 */
export type HttpHeaders = {
    [header: string]: string | number | boolean;
};

/**
 * Default CORS headers
 */
export const DEFAULT_CORS_HEADERS: HttpHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Amz-Date, X-Api-Key, X-Amz-Security-Token',
    'Access-Control-Allow-Credentials': true
};

/**
 * Lambda event type shorthand
 */
export type LambdaEvent = APIGatewayProxyEvent;

/**
 * Lambda response type shorthand
 */
export type LambdaResponse = APIGatewayProxyResult;