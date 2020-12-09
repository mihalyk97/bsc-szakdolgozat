import { Component, OnInit } from '@angular/core';
import { NbSortDirection, NbSortRequest, NbTreeGridDataSource, NbTreeGridDataSourceBuilder } from '@nebular/theme';
import { AdminService, ForAdminReport, ForAdminReportAppointment } from 'app/network';

export interface TreeNode<T> {
  data: T;
  children?: TreeNode<T>[];
  expanded: boolean;
}

export interface FSEntry {
  activityEmployee: string;
  date: string;
  online: string;
  hours: string;
  income: string;
}

@Component({
  selector: 'ngx-report',
  templateUrl: './report.component.html',
  styleUrls: ['./report.component.scss']
})
export class ReportComponent implements OnInit {
  max: Date = new Date();
  organizationName: String;
  fromDate:Date;
  toDate:Date;
  sumHours:number;
  sumIncome:number;

  customColumnTitle = 'Tevékenység és alkalmazott';
  customColumn = 'activityEmployee';
  defaultColumnsTitle = [ 'Dátum', 'Online időpont', 'Munkaórák', 'Bevétel' ];
  defaultColumns = [ 'date', 'online', 'hours', 'income' ];
  allColumns = [ 'activityEmployee', 'date', 'online', 'hours', 'income' ];
  allColumnTitles = [ 'Tevékenység és alkalmazott', 'Dátum', 'Online időpont', 'Munkaórák', 'Bevétel' ];

  sortColumn: string;
  sortDirection: NbSortDirection = NbSortDirection.NONE;
  dataSource: NbTreeGridDataSource<FSEntry>;
  data: TreeNode<FSEntry>[];

  constructor(private service: AdminService, private dataSourceBuilder: NbTreeGridDataSourceBuilder<FSEntry>) { 
  }

  ngOnInit(): void {

  }
  rangeSelected(event): void {
    this.fromDate=null;
    this.toDate=null;
    if(event.start && event.end) {
      this.fromDate=event.start;
      this.toDate=event.end;
    }
  }

  updateSort(sortRequest: NbSortRequest): void {
    this.sortColumn = sortRequest.column;
    this.sortDirection = sortRequest.direction;
  }

  getSortDirection(column: string): NbSortDirection {
    if (this.sortColumn === column) {
      return this.sortDirection;
    }
    return NbSortDirection.NONE;
  }

  getShowOn(index: number) {
    const minWithForMultipleColumns = 400;
    const nextColumnStep = 100;
    return minWithForMultipleColumns + (nextColumnStep * index);
  }

  getReport(): void {
    let fromQueryDate = new Date(this.fromDate);
    fromQueryDate.setHours(0,0,0,0);
    let toQueryDate = new Date(this.toDate);
    toQueryDate.setHours(23,59,59,59);
    this.service.adminReportGet(fromQueryDate.getTime(), toQueryDate.getTime())
    .subscribe((report:ForAdminReport) => {
      this.organizationName=report.organizationName
     let grouped: Map<string,ForAdminReportAppointment[]> = new Map<string, ForAdminReportAppointment[]>();

     for(let a of report.appointments.sort((a,b) => a.appointmentDate-b.appointmentDate)) {       
      
       let activityAppointments = grouped.get(a.activityName);
       if(!activityAppointments) {
         activityAppointments = [];
       }
       activityAppointments.push(a);
       grouped.set(a.activityName,activityAppointments);
     }
        this.data=[];
        this.sumHours=0;
        this.sumIncome=0;
        for (let [key, value] of grouped) {
          
          let entrySumIncome: number=0;
          let entrySumHours: number=0;
          let node:TreeNode<FSEntry>={
            children:value.map((a)=>{
              entrySumHours+=a.duration;
              entrySumIncome+=a.income;
              let c_entry:FSEntry={
                activityEmployee: a.employeeName,
                date: (new Date(a.appointmentDate)).toLocaleDateString("hu"),
                online: a.isOnline ? "Igen":"Nem",
                hours: a.duration.toString(),
                income: a.income.toString() + " Ft"
              };
  
              let c_node: TreeNode<FSEntry>={
                data: c_entry,
                expanded: true
              };
            return c_node;
            }),
            expanded: true,
            data:{
              activityEmployee: key,
              date: "",
              online: "",
              hours: "-",
              income: "-"
            }
          };
          this.data.push(node);
          this.sumHours+=entrySumHours;
          this.sumIncome+=entrySumIncome;
      }

      let emptyNode:TreeNode<FSEntry>={
        expanded: true,
        data:{
          activityEmployee: "",
          date: "",
          online: "",
          hours: "",
          income: ""
        }
      };
      let sumNode:TreeNode<FSEntry>={
        expanded: true,
        data:{
          activityEmployee: "Összesen",
          date: "",
          online: "",
          hours: this.sumHours.toString(),
          income: this.sumIncome.toString() + " Ft"
        }
      };      
      this.data.push(emptyNode);
      this.data.push(sumNode);

      this.dataSource = this.dataSourceBuilder.create(this.data);

    });
  }
}
