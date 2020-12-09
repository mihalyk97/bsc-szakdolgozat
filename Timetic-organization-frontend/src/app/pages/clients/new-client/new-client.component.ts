import { Component, Input, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { NbComponentStatus, NbDialogRef, NbToastrService } from '@nebular/theme';
import { AdminService, CommonClient, ForAdminOrganization } from 'app/network';

@Component({
  selector: 'ngx-new-client',
  templateUrl: './new-client.component.html',
  styleUrls: ['./new-client.component.scss']
})
export class NewClientComponent implements OnInit {

  @Input() client: CommonClient;
  personalInfoFields: string[];
  personalInfosForm: FormGroup;

//https://stackoverflow.com/questions/50374174/how-to-dynamically-define-formcontrol-name-within-ngfor-loop
  constructor(private service: AdminService, private formBuilder: FormBuilder, protected dialogRef: NbDialogRef<NewClientComponent>, private toastrService: NbToastrService) {
    this.service.adminOrganizationGet()
        .subscribe((data: ForAdminOrganization) => {
          this.personalInfoFields = data.clientPersonalInfoFields;
          this.personalInfoFields.forEach((field) => 
          { 
            this.personalInfosForm.addControl(field, this.formBuilder.control(''));
            let value = this.client.personalInfos[field]
            this.personalInfosForm.controls[field].setValue(value ?? "");

          });
        });
   }

  ngOnInit(): void {
    this.personalInfoFields = [];
    this.personalInfosForm = this.formBuilder.group({});
    if(!this.client) {
      this.client={
        personalInfos:{}
      };
    }
  }

 

  save(): void {
    var missingPersonalInfo = false;
    this.personalInfoFields.forEach((field) => {
      let value = this.personalInfosForm.controls[field].value;
      if(value == null || value == "") 
      {
        missingPersonalInfo = true;
      }
      this.client.personalInfos[field]=value;
    });

    if(this.client.name == null || this.client.name == "" ||
        this.client.phone == null || this.client.phone == "" ||
        this.client.email == null || this.client.email == "" ||
        missingPersonalInfo ) {
          this.showToast("danger","Hiba","Minden adat megadása kötelező!");
          return;
    }
    


     if(this.client.id == null){
        this.service.adminClientsPost(this.client).subscribe((c)=>{
          this.showToast("success","Siker","Ügyfél létrehozva");
          this.close();
        });
     }
     else {
       this.service.adminClientsPut(this.client).subscribe((c)=>{
        this.showToast("success","Siker","Ügyfél adatai módosítva");
        this.close();
      });
     }    
  }

  private showToast(type: NbComponentStatus, title: string, body: string) {
    const config = {
      status: type,
      duration: 2000,
    };
    this.toastrService.show(
      body,
      title,
      config);
  }

  close(): void {
    this.dialogRef.close();
  }

}
