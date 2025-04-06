import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Position } from './position.model';

@Injectable({
  providedIn: 'root'
})
export class PositionService {
  private readonly apiUrl = '/api/positions';

  constructor(private readonly http: HttpClient) { }

  getPositions(): Observable<Position[]> {
    return this.http.get<Position[]>(this.apiUrl);
  }

  getPositionById(id: number): Observable<Position> {
    return this.http.get<Position>(`${this.apiUrl}/${id}`);
  }
}