import { NgModule } from '@angular/core';
import { NbCardModule } from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import { ThemeModule } from '../../@theme/theme.module';
import { ActivitiesComponent } from './activities.component';

@NgModule({
  imports: [
    NbCardModule,
    ThemeModule,
    Ng2SmartTableModule,
  ],
  declarations: [
    ActivitiesComponent
  ],
})
export class ActivitiesModule { }
