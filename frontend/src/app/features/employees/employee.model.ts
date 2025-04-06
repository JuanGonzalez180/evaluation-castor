import { Position } from "../positions/position.model";

export interface Employee {
    id?: number;
    identificationNumber: number;
    name: string;
    photoUrl?: string;
    hireDate: Date;
    positionId: number;
    position?: Position;
    createdAt?: Date;
}

