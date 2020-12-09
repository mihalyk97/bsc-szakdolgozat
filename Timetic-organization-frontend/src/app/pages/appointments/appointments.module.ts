import { NgModule } from '@angular/core';
import { NbRadioModule, NbButtonModule, NbCardModule, NbCheckboxModule, NbDatepickerModule, NbIconModule, NbInputModule, NbListModule, NbSelectModule, NbTreeGridModule, NbUserModule, NbTimepickerModule, NbTimePickerComponent } from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import { ThemeModule } from '../../@theme/theme.module';
import { AppointmentsComponent } from './appointments.component';
import { AppointmentComponent } from './appointment/appointment.component';
import { NewAppointmentComponent } from './new-appointment/new-appointment.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';


@NgModule({
  imports: [
    NbCardModule,
    NbTreeGridModule,
    NbIconModule,
    NbInputModule,
    ThemeModule,
    Ng2SmartTableModule,
    NbListModule,
    NbButtonModule,
    NbUserModule,
    NbCheckboxModule,
    NbDatepickerModule,
    NbTimepickerModule,
    FormsModule,
    NbRadioModule,
    NbSelectModule,
    ReactiveFormsModule
  ],
  declarations: [
    AppointmentsComponent,
    AppointmentComponent,
    NewAppointmentComponent
  ],
})
export class AppointmentsModule { }
