import { NgModule } from '@angular/core';
import { NbMenuModule } from '@nebular/theme';

import { ThemeModule } from '../@theme/theme.module';
import { PagesComponent } from './pages.component';
import { PagesRoutingModule } from './pages-routing.module';
import { ActivitiesModule } from './activities/activities.module';
import { OverviewModule } from './overview/overview.module';
import { AppointmentsModule } from './appointments/appointments.module';
import { ReportModule } from './report/report.module';
import { EmployeesModule } from './employees/employees.module';
import { OrganizationModule } from './organization/organization.module';
import { ClientsModule } from './clients/clients.module';


@NgModule({
  imports: [
    PagesRoutingModule,
    ThemeModule,
    NbMenuModule,
    OverviewModule,
    AppointmentsModule,
    EmployeesModule,
    ActivitiesModule,
    ReportModule,
    OrganizationModule,
    ClientsModule
  ],
  declarations: [
    PagesComponent,
  ],
})
export class PagesModule {
}
