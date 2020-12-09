import { Component } from '@angular/core';
import { NbComponentStatus, NbToastrService } from '@nebular/theme';
import { AdminService, CommonActivity } from 'app/network';
import { LocalDataSource } from 'ng2-smart-table';

@Component({
  selector: 'ngx-activities',
  templateUrl: './activities.component.html',
  styleUrls: ['./activities.component.scss']
})
export class ActivitiesComponent {
  settings = {
    actions: {
      add: true,
      edit: false,
      delete: true,
      position: 'right',
      columnTitle: 'Műveletek'
    },
    add: {
      addButtonContent: '<i class="nb-plus"></i>',
      createButtonContent: '<i class="nb-checkmark"></i>',
      cancelButtonContent: '<i class="nb-close"></i>',
      confirmCreate: true,
    },
    delete: {
      deleteButtonContent: '<i class="nb-trash"></i>',
      confirmDelete: true,
    },
    columns: {
      name: {
        title: 'Tevékenység neve',
        type: 'string'
      }
    },
  };

  source: LocalDataSource = new LocalDataSource();
  
  constructor(private service: AdminService,private toastrService: NbToastrService) {
    this.service.adminActivitiesGet()
    .subscribe((data: CommonActivity[]) => this.source.load(data));
  }

  onDeleteConfirm(event): void {
    if (window.confirm('Biztos törölni szeretné?')) {
      var activity: CommonActivity = event.data;
      this.service.adminActivitiesActivityIdDelete(activity.id).subscribe(() => event.confirm.resolve());
    } else {
      event.confirm.reject();
    }
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

  onCreateConfirm(event): void {
    if (window.confirm('Létre szeretné hozni?')) {
      var activity: CommonActivity = event.newData;
      if(activity.name == null || activity.name == "") {
        this.showToast("danger","Hiba","Minden adat megadása kötelező!");
      }
    this.service.adminActivitiesPost(activity)
    .subscribe((data: CommonActivity) => event.confirm.resolve());
      
    } else {
      event.confirm.reject();
    }
  }

}
