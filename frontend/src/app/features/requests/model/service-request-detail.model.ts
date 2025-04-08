import { Service } from "./service.model";

export interface ServiceRequestDetail{
    id: number;
    service: Service;
    request: number;
    observations: string;
    creationAt: string;
}