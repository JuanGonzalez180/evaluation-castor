import { Component, OnInit } from '@angular/core';
import { ServiceRequest } from '../model/request.model';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { RippleModule } from 'primeng/ripple';
import { DropdownModule } from 'primeng/dropdown';
import { InputTextModule } from 'primeng/inputtext';
import { CardModule } from 'primeng/card';
import { TooltipModule } from 'primeng/tooltip';
import { ServiceRequestService } from '../request.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-request-list',
  standalone: true, // Agregar esta línea si no está
  imports: [
    CommonModule,
    FormsModule,
    TableModule,
    ButtonModule,
    RippleModule,
    DropdownModule,
    InputTextModule,
    CardModule,
    TooltipModule
  ],
  templateUrl: './request-list.component.html',
  styleUrl: './request-list.component.scss'
})
export class RequestListComponent implements OnInit {
  serviceRequests: ServiceRequest[] = [];
  expandedRows: { [key: number]: boolean } = {};

  constructor(private readonly serviceRequestService: ServiceRequestService) {}
  
  ngOnInit(): void {
    this.loadServiceRequests();
  }

  loadServiceRequests(): void {
    this.serviceRequestService.getServiceRequests().subscribe({
      next: (data) => {
        this.serviceRequests = data;
      },
      error: (error) => {
        console.error('Error al cargar solicitudes:', error);
      }
    });    
  }

  getContrastColor(hexColor: string): string {
    const r = parseInt(hexColor.slice(1, 3), 16);
    const g = parseInt(hexColor.slice(3, 5), 16);
    const b = parseInt(hexColor.slice(5, 7), 16);
    const yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000;
    return (yiq >= 128) ? '#000000' : '#ffffff';
  }

  getStatusStyle(color: string): any {
    return {
      'background-color': color,
      'border-radius': '4px',
      'padding': '2px 6px',
      'color': this.getContrastColor(color),
      'display': 'inline-block'
    };
  }
}