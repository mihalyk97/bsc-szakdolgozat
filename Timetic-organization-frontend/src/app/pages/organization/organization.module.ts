import { NgModule } from '@angular/core';
import { 
    NbCalendarModule, 
    NbCardModule, 
    NbIconModule, 
    NbInputModule, 
    NbTreeGridModule,
    NbListModule, 
    NbButtonModule,
    NbCheckboxModule,
    NbSelectModule,
    NbRadioModule} from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import { ThemeModule } from '../../@theme/theme.module';
import { OrganizationComponent } from './organization.component';
import { FormsModule } from '@angular/forms';

@NgModule({
  imports: [
    NbCardModule,
    NbIconModule,
    NbInputModule,
    ThemeModule,
    Ng2SmartTableModule,
    NbInputModule,
    NbCardModule,
    NbButtonModule,
    NbCheckboxModule,
    NbRadioModule,
    NbSelectModule,
    NbIconModule,
    FormsModule
  ],
  declarations: [
    OrganizationComponent
  ],
})
export class OrganizationModule { }
