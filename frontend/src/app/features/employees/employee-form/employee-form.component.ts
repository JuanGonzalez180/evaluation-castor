import { Component, OnInit, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MessageService } from 'primeng/api';

// PrimeNG Imports
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { SelectModule } from 'primeng/select';
import { DatePickerModule } from 'primeng/datepicker';
import { FileUploadModule, FileUpload } from 'primeng/fileupload';
import { ToastModule } from 'primeng/toast';
import { CardModule } from 'primeng/card';
import { RippleModule } from 'primeng/ripple';

// Models and Services
import { Employee } from '../employee.model';
import { EmployeeService } from '../employee.service';
import { Position } from '../../positions/position.model';
import { PositionService } from '../../positions/position.service';

@Component({
  selector: 'app-employee-form',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    ButtonModule,
    InputTextModule,
    SelectModule,
    DatePickerModule,
    FileUploadModule,
    ToastModule,
    CardModule,
    RippleModule
  ],
  providers: [MessageService],
  templateUrl: './employee-form.component.html',
})
export class EmployeeFormComponent implements OnInit {
  @ViewChild('fileUpload') fileUpload!: FileUpload;
  
  employeeForm!: FormGroup;
  employee: Employee = {
    identificationNumber: 0,
    name: '',
    hireDate: new Date(),
    positionId: 0,
  };
  positions: Position[] = [];
  isEditMode = false;
  submitted = false;
  loading = false;
  photoPreview: string | ArrayBuffer | null = null;
  photoError: string | null = null;
  photoFile: File | null = null;

  constructor(
    private readonly formBuilder: FormBuilder,
    private readonly employeeService: EmployeeService,
    private readonly positionService: PositionService,
    private readonly route: ActivatedRoute,
    private readonly router: Router,
    private readonly messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.createForm();
    this.loadPositions();
    
    // Check if we're in edit mode
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.loadEmployee(+id);
    }
  }

  get f() { return this.employeeForm.controls; }

  createForm(): void {
    this.employeeForm = this.formBuilder.group({
      identificationNumber: [this.employee.identificationNumber, [Validators.required]],
      name: [this.employee.name, [Validators.required]],
      hireDate: [this.employee.hireDate, [Validators.required]],
      positionId: [this.employee.positionId, [Validators.required]],
      photoUrl: [this.employee.photoUrl]
    });
  }

  loadPositions(): void {
    this.positionService.getPositions().subscribe({
      next: (data) => {
        this.positions = data;
      },
      error: (error) => {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'No se pudieron cargar los cargos'
        });
        console.error('Error loading positions', error);
      }
    });
  }

  loadEmployee(id: number): void {
    this.loading = true;
    this.employeeService.getEmployeeById(id).subscribe({
      next: (data) => {
        this.employee = data;
        this.employeeForm.patchValue({
          identificationNumber: data.identificationNumber,
          name: data.name,
          hireDate: new Date(data.hireDate),
          positionId: data.positionId,
          photoUrl: data.photoUrl
        });
        
        if (data.photoUrl) {
          this.photoPreview = data.photoUrl;
        }
        
        this.loading = false;
      },
      error: (error) => {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'No se pudo cargar el empleado'
        });
        this.loading = false;
        console.error('Error loading employee', error);
      }
    });
  }

  onPhotoSelect(event: any): void {
    this.photoError = null;
    if (event.files.length > 0) {
      const file = event.files[0];
      
      // Validate file type
      if (!file.type.includes('image/')) {
        this.photoError = 'Por favor, seleccione un archivo de imagen válido';
        return;
      }
      
      // Validate file size (max 1MB)
      if (file.size > 1000000) {
        this.photoError = 'La imagen no debe superar 1MB';
        return;
      }
      
      this.photoFile = file;
      
      // Create preview
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.photoPreview = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  onPhotoUpload(event: any): void {
    // This method will be implemented with your file upload service
    // For now, we'll simulate a successful upload
    console.log('Photo upload handler', event);
    
    // Normally, you would upload the file to your backend or S3
    // this.fileUploadService.uploadFile(this.photoFile).subscribe(...)
    
    // For the demo, we'll just set a dummy URL and continue the form submission
    this.employeeForm.patchValue({
      photoUrl: 'https://example.com/photo/' + Math.random().toString(36).substring(7)
    });
    
    this.onSubmit();
  }

  onSubmit(): void {
    this.submitted = true;
    
    // Stop if form is invalid
    if (this.employeeForm.invalid) {
      return;
    }
    
    // If we have a photo to upload, trigger the upload process
    if (this.photoFile && !this.employeeForm.value.photoUrl) {
      this.fileUpload.upload();
      return;
    }
    
    const employeeData: Employee = {
      ...this.employee,
      ...this.employeeForm.value,
    };
    
    this.loading = true;
    
    if (this.isEditMode) {
      // Update existing employee
      this.employeeService.updateEmployee(this.employee.id!, employeeData).subscribe({
        next: () => {
          this.messageService.add({
            severity: 'success',
            summary: 'Éxito',
            detail: 'Empleado actualizado correctamente'
          });
          this.loading = false;
          this.router.navigate(['/employees']);
        },
        error: (error) => {
          this.messageService.add({
            severity: 'error',
            summary: 'Error',
            detail: 'No se pudo actualizar el empleado'
          });
          this.loading = false;
          console.error('Error updating employee', error);
        }
      });
    } else {
      // Create new employee
      this.employeeService.createEmployee(employeeData).subscribe({
        next: () => {
          this.messageService.add({
            severity: 'success',
            summary: 'Éxito',
            detail: 'Empleado creado correctamente'
          });
          this.loading = false;
          this.router.navigate(['/employees']);
        },
        error: (error) => {
          this.messageService.add({
            severity: 'error',
            summary: 'Error',
            detail: 'No se pudo crear el empleado'
          });
          this.loading = false;
          console.error('Error creating employee', error);
        }
      });
    }
  }

  onCancel(): void {
    this.router.navigate(['/employees']);
  }
}