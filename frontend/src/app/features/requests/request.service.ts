import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { environment } from '../../../environments/environment';
import { ServiceRequest } from './model/request.model';

@Injectable({
  providedIn: 'root'
})
export class ServiceRequestService {
  private readonly apiUrl = `${environment.baseApiUrl}/request`;

  constructor(private readonly http: HttpClient) { }

  getServiceRequests(): Observable<ServiceRequest[]> {
    return this.http.get<ServiceRequest[]>(this.apiUrl);
  }
}
