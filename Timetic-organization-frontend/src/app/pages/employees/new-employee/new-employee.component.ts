import { ChangeDetectorRef, Component, Input, OnInit } from '@angular/core';
import { NbComponentStatus, NbDialogRef, NbToastrService } from '@nebular/theme';
import { AdminService, CommonActivity, CommonDataForAppointmentCreation, CommonEmployee, ForAdminOrganization } from 'app/network';
import { AssignedActivity } from './models';

@Component({
  selector: 'ngx-new-employee',
  templateUrl: './new-employee.component.html',
  styleUrls: ['./new-employee.component.scss']
})
export class NewEmployeeComponent implements OnInit {

  @Input() employee: CommonEmployee;
  possibleActivities: AssignedActivity[];
  //activity: CommonActivity;
  constructor(private service: AdminService, protected dialogRef: NbDialogRef<NewEmployeeComponent>, private toastrService: NbToastrService) { 
    this.service.adminActivitiesGet()
        .subscribe((data: CommonActivity[]) => {
          this.possibleActivities=data.map((activity) => {
           let assigned = new AssignedActivity();
            assigned.id=activity.id;
            assigned.name=activity.name;
            assigned.assignedToEmployee= this.employee.activities ? (this.employee.activities.some(a => a.id === activity.id)) : false;
            return assigned;
          });
        });
  }

  ngOnInit(): void {
    if(!this.employee) {
      this.employee={};
    }
  }

  save(): void {
    this.employee.activities=this.possibleActivities.filter((possibleActivity) => {
      if(possibleActivity.assignedToEmployee)
      {
        return true;
      }
      return false;
    })
    .map((possibleActivity) => {
        let activity: CommonActivity = {};
        activity.id=possibleActivity.id;
        activity.name=possibleActivity.name;
        return activity;
     });
     if(this.employee.name == null || this.employee.name == "" ||
        this.employee.phone == null || this.employee.phone == "" ||
        this.employee.email == null || this.employee.email == "" ) {
          this.showToast("danger","Hiba","Minden adat megadása kötelező!");
          return;
        }
        if(this.employee.activities == null || this.employee.activities.length == 0) {
          this.showToast("danger","Hiba","Legalább egy tevékenység kiválasztása kötelező!");
          return;
        }
     if(this.employee.id == null){
        this.service.adminEmployeesPost(this.employee).subscribe((e)=>{
          this.showToast("success","Siker","Alkalmazott létrehozva");
          this.close();
        });
     }
     else {
      this.service.adminEmployeesPut(this.employee).subscribe((e)=>{
        this.showToast("success","Siker","Alkalmazott adatai módosítva");
        this.close();
      });
     }
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
}

