import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NbAuthService, NbRequestPasswordComponent } from '@nebular/auth';

@Component({
  selector: 'ngx-request-password',
  templateUrl: './request-password.component.html',
})
export class NgxRequestPasswordComponent extends NbRequestPasswordComponent {


}
