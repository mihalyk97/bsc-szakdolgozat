import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';

import { NgxAuthRoutingModule } from './auth-routing.module';
import { 
  NbAlertModule,
  NbButtonModule,
  NbCheckboxModule,
  NbInputModule
} from '@nebular/theme';

import { NbAuthJWTToken, NbPasswordAuthStrategy, NbAuthModule, NbAuthService } from '@nebular/auth';
import { NgxLoginComponent } from './login/login.component';
import { NgxRequestPasswordComponent } from './request-password/request-password.component';
import { NgxResetPasswordComponent } from './reset-password/reset-password.component';


@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    NbAlertModule,
    NbInputModule,
    NbButtonModule,
    NbCheckboxModule,
    NgxAuthRoutingModule, 
  ],
  declarations: [
    NgxLoginComponent,
    NgxRequestPasswordComponent,
    NgxResetPasswordComponent
  ],
})
export class NgxAuthModule {
    
}