import { DatePipe, formatDate } from '@angular/common';
import { Component, Output, EventEmitter, OnChanges } from '@angular/core';
import { AdminService, CommonUser } from 'app/network';
import { LocalDataSource } from 'ng2-smart-table';
import { MobileUser } from './mobile-user.model';

@Component({
  selector: 'ngx-smart-table',
  templateUrl: './mobile-users.component.html',
  styleUrls: ['./mobile-users.component.scss'],
})
export class MobileUsersComponent {

  settings = {
    actions: {
      add: false,
      edit: false,
      delete: true,
      position: 'right',
      columnTitle: 'Törlés'
    },
    add: {
      addButtonContent: '<i class="nb-plus"></i>',
      createButtonContent: '<i class="nb-checkmark"></i>',
      cancelButtonContent: '<i class="nb-close"></i>',
    },
    delete: {
      deleteButtonContent: '<i class="nb-trash"></i>',
      confirmDelete: true,
    },
    columns: {
      name: {
        title: 'Név',
        type: 'string',
      },
      email: {
        title: 'E-mail cím',
        type: 'string',
      },
      registrationDate: {
        title: 'Regisztráció ideje',
        type: 'string',
      },
    },
  };

  source: LocalDataSource = new LocalDataSource();

  constructor(private service: AdminService) {
    this.service.adminUsersGet()
    .subscribe((data: CommonUser[]) => {
      let users = data.map((userDto)=> {
        let user = {
          id: userDto.id,
          name: userDto.name, 
          email: userDto.email,
          registrationDate: (new Date(userDto.registrationDate)).toLocaleDateString("hu")
        };
        return user;
      }
      ).sort((a,b) => (new Date(b.registrationDate)).getTime() - (new Date(a.registrationDate).getTime()));
      this.source.load(users);
    });
  }

  onDeleteConfirm(event): void {
    if (window.confirm('Biztos törölni szeretné?')) {
      var user: CommonUser = event.data;
      this.service.adminUsersUserIdDelete(user.id)
      .subscribe(() => event.confirm.resolve());
    } else {
      event.confirm.reject();
    }
  }
}
