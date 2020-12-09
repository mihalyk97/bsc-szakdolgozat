import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NbButtonModule, NbCardModule, NbCheckboxModule, NbIconModule, NbInputModule, NbRadioModule, NbTreeGridModule } from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import { ThemeModule } from '../../@theme/theme.module';
import { ClientsComponent } from './clients.component';
import { NewClientComponent } from './new-client/new-client.component';

@NgModule({
  imports: [
    NbCardModule,
    NbTreeGridModule,
    NbIconModule,
    NbInputModule,
    ThemeModule,
    Ng2SmartTableModule,
    NbCheckboxModule,
    FormsModule,
    NbRadioModule,
    NbButtonModule,
    ReactiveFormsModule
  ],
  declarations: [
    ClientsComponent,
    NewClientComponent
],
})
export class ClientsModule { }
