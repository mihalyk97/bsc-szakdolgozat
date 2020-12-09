import { Component, OnInit } from '@angular/core';
import { NbDialogService } from '@nebular/theme';
import { AdminService, CommonAppointment } from 'app/network';
import { NewAppointmentComponent } from 'app/pages/appointments/new-appointment/new-appointment.component'


@Component({
  selector: 'ngx-appointments',
  templateUrl: './appointments.component.html',
  styleUrls: ['./appointments.component.scss']
})
export class AppointmentsComponent implements OnInit {
  appointments: CommonAppointment[] = new Array<CommonAppointment>();
  
  constructor(private service: AdminService, private dialogService: NbDialogService) { 
    this.getAppointments();
  }

  ngOnInit(): void {
  }

  createNewAppointment(event): void {
    const dialog = this.dialogService.open(NewAppointmentComponent);
    const instance = dialog.componentRef.instance;
    dialog.onClose.subscribe(() => this.getAppointments());
    
  }

  getAppointments(): void {
    this.service.adminAppointmentsGet()
    .subscribe((data: CommonAppointment[]) =>{ 
      this.appointments=data.sort((a, b) => a.startTime - b.startTime); 
      });
  }

  deleteAppointment(event): void {
    let appointmentId: string = event;
    this.service.adminAppointmentsAppointmentIdDelete(appointmentId).subscribe(() => this.getAppointments());

  }
  
  openAppointmentDetails(event): void {
    let appointment: CommonAppointment = event;
    if(appointment.isPrivate)
    {
      return;
    }
    const dialog = this.dialogService.open(NewAppointmentComponent);
    const instance = dialog.componentRef.instance;
    instance.exsistingAppointment=appointment;
    dialog.onClose.subscribe(() => this.getAppointments());
  }
}

