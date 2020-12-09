import { DatePipe } from '@angular/common';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnInit } from '@angular/core';
import { NbComponentStatus, NbDialogRef, NbToastrService } from '@nebular/theme';
import { AdminService, CommonActivity, CommonAppointment, CommonDataForAppointmentCreation, CommonEmployee } from 'app/network';

@Component({
  selector: 'ngx-new-appointment',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './new-appointment.component.html',
  styleUrls: ['./new-appointment.component.scss']
})
export class NewAppointmentComponent implements OnInit {

  appointment: CommonAppointment;
  @Input() exsistingAppointment: CommonAppointment;
  minDate = new Date();
  date: Date = new Date();
  hours: number = 8;
  minutes: number = 0;
  duration: number=0;
  appointmentCreationData: CommonDataForAppointmentCreation;
  activities: CommonActivity[] = [];
  disabled: boolean = true;
  constructor(private service: AdminService, private ref: ChangeDetectorRef, protected dialogRef: NbDialogRef<NewAppointmentComponent>, private toastrService: NbToastrService) { 
    this.service.adminAppointmentCreationDataGet()
        .subscribe((data: CommonDataForAppointmentCreation) => {
          this.appointmentCreationData=data;
          if(this.exsistingAppointment) {
            let now = new Date().getTime();
            this.disabled = this.exsistingAppointment.startTime < now;
            this.appointment.id = this.exsistingAppointment.id;
            this.appointment.employee = this.appointmentCreationData.employees.find((e)=>e.id === this.exsistingAppointment.employee.id);
            if(this.disabled) {
              this.activities = [this.exsistingAppointment.activity]
            } else {
              this.activities = this.appointment.employee.activities;
            }
            this.appointment.activity = this.activities.find((a)=>a.id === this.exsistingAppointment.activity.id);
            this.appointment.client = this.appointmentCreationData.clients.find((c)=>c.id === this.exsistingAppointment.client.id);
            this.appointment.place = this.appointmentCreationData.places.find((p)=>p === this.exsistingAppointment.place);
            this.appointment.price = this.exsistingAppointment.price;
            this.appointment.online = this.exsistingAppointment.online;
            this.appointment.note = this.exsistingAppointment.note;
            this.date=new Date(this.exsistingAppointment.startTime);
            this.setStartTime(this.date);
            this.date.setUTCHours((this.date.getTimezoneOffset()/60),0,0,0);
            this.duration=Math.round((this.exsistingAppointment.endTime-this.exsistingAppointment.startTime)/1000/60);
        } else {
          this.disabled = false;
        }
          this.ref.detectChanges();
        });
  }

  ngOnInit(): void {
    this.appointmentCreationData = {
      activities: [],
      clients: [],
      employees: [],
      places: []
    }
    
    let tempDate=new Date();
    tempDate.setDate(this.date.getDate()+1);
    this.date=new Date(tempDate.getTime());
    this.date.setUTCHours((tempDate.getTimezoneOffset()/60),0,0,0);
    this.appointment= {
      employee: {
        id: ""
      },
      client: {
        id: ""
      },
      activity: {
        id: ""
      },
      online: false,
      price: 0,
      note: ""
    };
  
  this.ref.detectChanges();
  }

  save(): void {
    this.appointment.startTime=this.date.getTime() + (((this.hours*60)+this.minutes)*60*1000);
    this.appointment.endTime=this.appointment.startTime+(this.duration*60*1000);
    this.appointment.isPrivate=false;
    if(this.appointment.place == null || this.appointment.place == "" ||
        this.appointment.price == null || this.appointment.price <= 0 ||
        this.appointment.note == null || this.appointment.note == "" ) {
          this.showToast("danger","Hiba","Minden adat megadása kötelező!");
          return;
        }
    if (this.appointment.id) {
      this.service.adminAppointmentsPut(this.appointment).subscribe((a) => {
        this.showToast("success", "Siker", "Időpont adatai módosítva");
        this.close();
      });
    }
    else {
      this.service.adminAppointmentsPost(this.appointment).subscribe((a) => {
        this.showToast("success", "Siker", "Időpont létrehozva");
        this.close();
      });
    }
  }

  employeeSelected(event): void {
    this.appointment.employee=event;
    this.activities = this.appointment.employee.activities;
    if(this.activities.length > 0) {
      this.appointment.activity = this.activities[0];
    } else {
      this.appointment.activity = {};
    }
    this.ref.detectChanges();
  }

  clientSelected(event): void {
    this.appointment.client=this.appointmentCreationData.clients.find((c)=> c.id === event);
  }

  activitySelected(event): void {
    this.activities = this.appointment.employee.activities;
    this.appointment.activity=event;
  }

  close(): void {
    this.dialogRef.close();
  }

  private showToast(type: NbComponentStatus, title: string, body: string) {
    const config = {
      status: type,
      duration: 2000,
    };
    this.toastrService.show(
      body,
      title,
      config);
  }

  private setStartTime(timeFromDate: Date): void {
    this.hours = timeFromDate.getUTCHours() - (timeFromDate.getTimezoneOffset()/60);
    if(this.hours === 24) {
      this.hours = 0;
      this.date.setDate(this.date.getDate()+1);
    }
    this.minutes = timeFromDate.getUTCMinutes();
  }
}
