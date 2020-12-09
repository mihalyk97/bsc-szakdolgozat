import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { NbDialogService } from '@nebular/theme';
import { AdminService, CommonAppointment } from 'app/network';
import { NewAppointmentComponent } from '../new-appointment/new-appointment.component';

@Component({
  selector: 'ngx-appointment',
  templateUrl: './appointment.component.html',
  styleUrls: ['./appointment.component.scss']
})
export class AppointmentComponent implements OnInit {

  @Input() appointment: CommonAppointment;
  @Output() public onDelete: EventEmitter<any> = new EventEmitter();
  @Output() public onDetails: EventEmitter<any> = new EventEmitter();

  constructor(private service: AdminService,private dialogService: NbDialogService) { 
  }

  ngOnInit(): void {
  }

  cancelAppointment(): void {
    this.onDelete.emit(this.appointment.id);
  }

  openAppointment(): void {
    this.onDetails.emit(this.appointment);
  }

}
