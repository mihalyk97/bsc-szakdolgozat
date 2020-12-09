import { NgModule } from '@angular/core';
import { NbButtonModule, NbCardModule, NbDatepickerModule, NbIconModule, NbInputModule, NbTreeGridModule, NbUserModule } from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import { ThemeModule } from '../../@theme/theme.module';
import { ReportComponent } from './report.component';
import { FormsModule as ngFormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

@NgModule({
  imports: [
    NbCardModule,
    NbIconModule,
    NbInputModule,
    ThemeModule,
    Ng2SmartTableModule,
    NbButtonModule,
    NbUserModule,
    NbDatepickerModule,
    NbIconModule,
    ngFormsModule,
    NbTreeGridModule,
    NgxPrintModule
  ],
  declarations: [
    ReportComponent
  ],
})
export class ReportModule { }
