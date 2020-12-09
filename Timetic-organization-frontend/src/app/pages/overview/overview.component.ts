import { Component, OnInit } from '@angular/core';
import { NbDialogService } from '@nebular/theme';
import { AdminService, CommonAppointment, ForAdminOverview } from 'app/network';
import { NewAppointmentComponent } from '../appointments/new-appointment/new-appointment.component';

@Component({
  selector: 'ngx-overview',
  templateUrl: './overview.component.html',
  styleUrls: ['./overview.component.scss']
})
export class OverviewComponent implements OnInit {
  date: Date = new Date();
  overview: ForAdminOverview;
  appointments: CommonAppointment[] = [];
  constructor(private service: AdminService, private dialogService: NbDialogService) { 
    let todaysMidnight = new Date(this.date);
    todaysMidnight.setHours(0,0,0,0);
    this.service.adminOverviewGet(todaysMidnight.getTime())
    .subscribe((data: ForAdminOverview) => this.overview=data);
    this.getAppointmentsForSelectedDate(this.date);
  }

  ngOnInit(): void {
    this.overview = {
      appointmentsToday: 0,
      onlineAppointmentsToday: 0,
      registeredUsers: 0,
      activeEmployeesToday: 0
    };
  }

  handleDateChange(event): void {
    this.getAppointmentsForSelectedDate(this.date);
  }

  appointmentSelected(appointment): void {
    if(appointment.isPrivate)
    {
      return;
    }
    this.service.adminAppointmentsAppointmentIdGet(appointment.id).subscribe((a) => {
      const dialog = this.dialogService.open(NewAppointmentComponent);
      const instance = dialog.componentRef.instance;
      instance.exsistingAppointment=a;
      dialog.onClose.subscribe(() => this.getAppointmentsForSelectedDate(this.date));
    });
  }

  getAppointmentsForSelectedDate(queryDate: Date): void {
    let fromQueryDate = new Date(queryDate);
    fromQueryDate.setHours(0,0,0,0);
    let toQueryDate = new Date(queryDate);
    toQueryDate.setHours(23,59,59,59);
    this.service.adminAppointmentsGet(fromQueryDate.getTime(), toQueryDate.getTime())
    .subscribe((data: CommonAppointment[]) =>       
    this.appointments=data.sort((a, b) => a.startTime - b.startTime));
  }

}
