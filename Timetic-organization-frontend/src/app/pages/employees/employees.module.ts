import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { NbButtonModule, NbCardModule, NbCheckboxModule, NbIconModule, NbInputModule, NbRadioModule, NbTreeGridModule } from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import { ThemeModule } from '../../@theme/theme.module';
import { EmployeesComponent } from './employees.component';
import { NewEmployeeComponent } from './new-employee/new-employee.component';

@NgModule({
  imports: [
    NbCardModule,
    NbTreeGridModule,
    NbIconModule,
    NbInputModule,
    ThemeModule,
    Ng2SmartTableModule,
    NbCheckboxModule,
    FormsModule,
    NbRadioModule,
    NbButtonModule
  ],
  declarations: [
    EmployeesComponent,
    NewEmployeeComponent
  ],
})
export class EmployeesModule { }
