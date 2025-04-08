import { Requester } from './requester.model';
import { RequestStatus } from './request-status.model';
import { ServiceRequestDetail } from './service-request-detail.model';

export interface ServiceRequest {
    requestId: number;
    requestDate: string;
    requester: Requester;
    status: RequestStatus;
    creationAt: string;
    serviceRequestDetails: ServiceRequestDetail[];
}