import { NgModule } from '@angular/core';
import { NbMenuModule } from '@nebular/theme';

import { ThemeModule } from '../@theme/theme.module';
import { PagesComponent } from './pages.component';
import { PagesRoutingModule } from './pages-routing.module';
import { OrganizationsModule } from './organizations/organizations.module';
import { MobileUsersModule } from './mobile-users/mobile-users.module';


@NgModule({
  imports: [
    PagesRoutingModule,
    ThemeModule,
    NbMenuModule,
    OrganizationsModule,
    MobileUsersModule
  ],
  declarations: [
    PagesComponent,
  ],
})
export class PagesModule {
}
