import { Requester } from './requester.model';
import { RequestStatus } from './request-status.model';

export interface Request {
    request_id: number;
    request_date: string;
    requester_id: number;
    status_id: number;
    creation_date: string;
    
    requester?: Requester;
    status?: RequestStatus;
}
