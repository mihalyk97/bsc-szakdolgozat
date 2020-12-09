import { Component } from '@angular/core';
import { CommonOrganization } from 'app/network';
import { AdminService } from 'app/network';

import { LocalDataSource } from 'ng2-smart-table';

@Component({
  selector: 'ngx-smart-table',
  templateUrl: './organizations.component.html',
  styleUrls: ['./organizations.component.scss'],
})
export class OrganizationsComponent {

  settings = {
    actions: {
      add: true,
      edit: true,
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
    edit: {
      editButtonContent: '<i class="nb-edit"></i>',
      saveButtonContent: '<i class="nb-checkmark"></i>',
      cancelButtonContent: '<i class="nb-close"></i>',
      confirmSave: true,
    },
    delete: {
      deleteButtonContent: '<i class="nb-trash"></i>',
      confirmDelete: true,
    },
    columns: {
      name: {
        title: 'Szervezet neve',
        type: 'string',
      },
      serverUrl: {
        title: 'Szervezet szerverének URL-je',
        type: 'string',
      },
    },
  };

  source: LocalDataSource = new LocalDataSource();

  constructor(private service: AdminService) {
    this.service.adminOrganizationsGet()
    .subscribe((data: CommonOrganization[]) => this.source.load(data));
  }

  onDeleteConfirm(event): void {
    if (window.confirm('Biztos törölni szeretné?')) {
      var organization: CommonOrganization = event.data;
      this.service.adminOrganizationsOrganizationIdDelete(organization.id).subscribe(() => event.confirm.resolve());
    } else {
      event.confirm.reject();
    }
  }

  onCreateConfirm(event): void {
    if (window.confirm('Létre szeretné hozni?')) {
      var organization: CommonOrganization = event.newData;
      console.log(organization);
    this.service.adminOrganizationsPost(organization)
    .subscribe((data: CommonOrganization) => event.confirm.resolve());
      
    } else {
      event.confirm.reject();
    }
  }

  onEditConfirm(event): void {
    if (window.confirm('Módosítani szeretné?')) {
      var organization: CommonOrganization = event.newData;
      console.log(event.data);
      console.log(event.newData);
      this.service.adminOrganizationsPut(organization)
      .subscribe((data: CommonOrganization) => event.confirm.resolve()); 
    } else {
      event.confirm.reject();
    }
   
  }
}
