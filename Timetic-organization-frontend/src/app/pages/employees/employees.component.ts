import { Component } from '@angular/core';
import { NbDialogService } from '@nebular/theme';
import { AdminService, CommonEmployee, ForAdminOrganization } from 'app/network';
import { LocalDataSource } from 'ng2-smart-table';
import { NewEmployeeComponent } from './new-employee/new-employee.component';

@Component({
  selector: 'ngx-employees',
  templateUrl: './employees.component.html',
  styleUrls: ['./employees.component.scss']
})
export class EmployeesComponent {

  settings = {
    actions: {
      add: false,
      edit: false,
      delete: true,
      position: 'right',
      columnTitle: 'Törlés'
    },
    delete: {
      deleteButtonContent: '<i class="nb-trash"></i>',
      confirmDelete: true,
    },
    columns: {
      name: {
        title: 'Alkalmazott neve',
        type: 'string',
      },
    },
  };

  source: LocalDataSource = new LocalDataSource();

  constructor(private service: AdminService, private dialogService: NbDialogService) {
    this.getEmployees();
  }

  onDeleteConfirm(event): void {
    if (window.confirm('Are you sure you want to delete?')) {
      var employee: CommonEmployee = event.data;
      this.service.adminEmployeesEmployeeIdDelete(employee.id).subscribe(() => event.confirm.resolve());
    } else {
      event.confirm.reject();
    }
  }

  createNewEmployee(event): void {
    const dialog = this.dialogService.open(NewEmployeeComponent);
    const instance = dialog.componentRef.instance
    dialog.onClose.subscribe(() => this.getEmployees());
  }

  onRowSelection(event): void {
    const dialog = this.dialogService.open(NewEmployeeComponent);
    const instance = dialog.componentRef.instance
    instance.employee = event.data;
    dialog.onClose.subscribe(() => this.getEmployees());
  }

  getEmployees(): void {
    this.service.adminEmployeesGet()
    .subscribe((data: CommonEmployee[]) => this.source.load(data));
  }

}
