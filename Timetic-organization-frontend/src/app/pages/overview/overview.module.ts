import { NgModule } from '@angular/core';
import { 
    NbCalendarModule, 
    NbCardModule, 
    NbIconModule, 
    NbInputModule, 
    NbTreeGridModule,
    NbListModule } from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import { ThemeModule } from '../../@theme/theme.module';
import { OverviewComponent } from './overview.component';

@NgModule({
  imports: [
    NbCardModule,
    NbTreeGridModule,
    NbIconModule,
    NbInputModule,
    ThemeModule,
    Ng2SmartTableModule,
    NbCalendarModule,
    NbListModule
  ],
  declarations: [
    OverviewComponent
  ],
})
export class OverviewModule { }
