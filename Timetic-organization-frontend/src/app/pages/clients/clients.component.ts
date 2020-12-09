import { Component, OnInit } from '@angular/core';
import { NbDialogService } from '@nebular/theme';
import { AdminService, CommonClient, ForAdminOrganization } from 'app/network';
import { LocalDataSource } from 'ng2-smart-table';
import { NewClientComponent } from './new-client/new-client.component';

@Component({
  selector: 'ngx-clients',
  templateUrl: './clients.component.html',
  styleUrls: ['./clients.component.scss']
})
export class ClientsComponent implements OnInit {

  settings = {
    actions: {
      add: false,
      edit: false,
      delete: false,
      position: 'right',
      columnTitle: 'Műveletek'
    },
    columns: {
      name: {
        title: 'Ügyfél neve',
        type: 'string',
      },
    },
  };

  source: LocalDataSource = new LocalDataSource();

  constructor(private service: AdminService, private dialogService: NbDialogService) {
    this.getClients();
  }
  ngOnInit(): void {
  }
  createNewClient(event): void {
    const dialog = this.dialogService.open(NewClientComponent);
    const instance = dialog.componentRef.instance
    dialog.onClose.subscribe(() => this.getClients());
  }

  onRowSelection(event): void {
    const dialog = this.dialogService.open(NewClientComponent);
    const instance = dialog.componentRef.instance
    instance.client = event.data;
    dialog.onClose.subscribe(() => this.getClients());
  }

  getClients(): void {
    this.service.adminClientsGet()
    .subscribe((data: CommonClient[]) => this.source.load(data));
  }

}
