import { Routes } from '@angular/router';

export const routes: Routes = [
    {
        path: '',
        redirectTo: 'dashboard',
        pathMatch: 'full',
    },
    {
        path: 'dashboard',
        loadComponent: () =>
            import('./features/dashboard/dashboard.component').then(
                (c) => c.DashboardComponent
            ),
    },
    {
        path: 'employees',
        loadChildren: () =>
            import('./features/employees/employee.routes').then(
                (r) => r.EMPLOYEE_ROUTES
            ),
    },
    {
        path: 'requests',
        loadChildren: () =>
            import('./features/requests/request.routes').then(
                (r) => r.REQUEST_ROUTES
            ),
    },
    {
        path: '**',
        redirectTo: 'dashboard',
    },
];
