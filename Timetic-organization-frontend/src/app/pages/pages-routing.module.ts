import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';

import { PagesComponent } from './pages.component';
import { ActivitiesComponent } from './activities/activities.component';
import { OverviewComponent } from './overview/overview.component';
import { AppointmentsComponent } from './appointments/appointments.component';
import { EmployeesComponent } from './employees/employees.component';
import { ReportComponent } from './report/report.component';
import { OrganizationComponent } from './organization/organization.component';
import { ClientsComponent } from './clients/clients.component';


const routes: Routes = [{
  path: '',
  component: PagesComponent,
  children: [
    {
      path: 'overview',
      component: OverviewComponent,
    },
    {
      path: 'appointments',
      component: AppointmentsComponent,
    },
    {
      path: 'employees',
      component: EmployeesComponent,
    },
    {
      path: 'activities',
      component: ActivitiesComponent,
    },
    {
      path: 'clients',
      component: ClientsComponent,
    },
    {
      path: 'report',
      component: ReportComponent,
    },
    {
      path: 'organization',
      component: OrganizationComponent,
    },
    {
      path: '',
      redirectTo: 'overview',
      pathMatch: 'full',
    },
    {
      path: '**',
      component: OverviewComponent,
    },
  ],
}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class PagesRoutingModule {
}
