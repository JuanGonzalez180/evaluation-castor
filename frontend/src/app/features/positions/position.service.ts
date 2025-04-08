import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Position } from './position.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class PositionService {
  private readonly apiUrl = `${environment.baseApiUrl}/position`;

  constructor(private readonly http: HttpClient) { }

  getPositions(): Observable<Position[]> {
    return this.http.get<Position[]>(this.apiUrl);
  }

  getPositionById(id: number): Observable<Position> {
    return this.http.get<Position>(`${this.apiUrl}/${id}`);
  }
}