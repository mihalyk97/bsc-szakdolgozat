import { Component, OnInit } from '@angular/core';
import { AdminService, ForAdminOrganization } from 'app/network';
import { LocalDataSource } from 'ng2-smart-table';

@Component({
  selector: 'ngx-organization',
  templateUrl: './organization.component.html',
  styleUrls: ['./organization.component.scss']
})
export class OrganizationComponent implements OnInit {

  clientInfoSettings = {
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
        title: 'Adatmező megnevezése',
        type: 'string'
      }
    },
  };

  addressesSettings = {
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
        title: 'Cím megnevezése',
        type: 'string'
      }
    },
  };

  clientInfoSource: LocalDataSource = new LocalDataSource();
  addressesSource: LocalDataSource = new LocalDataSource();
  organization: ForAdminOrganization={};

  constructor(private service: AdminService) {
    this.service.adminOrganizationGet()
    .subscribe((data: ForAdminOrganization) =>
    { 
      this.organization = data;
      this.clientInfoSource.load(data.clientPersonalInfoFields.map((elem: String)=>{return {name:elem}}));
      this.addressesSource.load(data.addresses.map((elem: String)=>{return {name:elem}}))
    });
  }

  ngOnInit(): void {
    this.organization = {};
    this.organization.defaultContact={
      name: "",
      email: "",
      phone: ""
    }
  }

  onSaveClick(event): void {
    this.service.adminOrganizationPut(this.organization).subscribe(() => {} );
  }

  onAddressesDeleteConfirm(event): void {
    if (window.confirm('Biztos törölni szeretné?')) {
      var address: string = event.data.name;
      const index: number = this.organization.addresses.indexOf(address);
      if(index > -1)
      {
        this.organization.addresses.splice(index, 1);
        this.service.adminOrganizationPut(this.organization).subscribe(() => event.confirm.resolve());
      }
      else
       {
        event.confirm.reject();
       }
    } else {
      event.confirm.reject();
    }
  }

  onAddressesCreateConfirm(event): void {
    if (window.confirm('Létre szeretné hozni?')) {
      var address: string = event.newData.name;
      this.organization.addresses.push(address);
      this.service.adminOrganizationPut(this.organization).subscribe(() => event.confirm.resolve());
    } else {
      event.confirm.reject();
    }
  }

  onClientInfoDeleteConfirm(event): void {
    if (window.confirm('Biztos törölni szeretné?')) {
      var clientInfo: string = event.data.name;
      const index: number = this.organization.clientPersonalInfoFields.indexOf(clientInfo);
      if(index > -1)
      {
        this.organization.clientPersonalInfoFields.splice(index, 1);
        this.service.adminOrganizationPut(this.organization).subscribe(() => event.confirm.resolve());
      }
      else
       {
        event.confirm.reject();
       }
    } else {
      event.confirm.reject();
    }
  }

  onClientInfoCreateConfirm(event): void {
    if (window.confirm('Létre szeretné hozni?')) {
      var clientInfo: string = event.newData.name;
      this.organization.clientPersonalInfoFields.push(clientInfo);
      this.service.adminOrganizationPut(this.organization).subscribe(() => event.confirm.resolve());
    } else {
      event.confirm.reject();
    }
  }

}
