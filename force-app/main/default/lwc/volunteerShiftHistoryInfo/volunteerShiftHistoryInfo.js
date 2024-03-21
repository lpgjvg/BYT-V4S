import { LightningElement,api,wire,track} from 'lwc';
import getShiftsByContact from '@salesforce/apex/VolunteerController.getHistoricalShiftsByContact';

const columns = [{label: 'Date', fieldName: "GW_Volunteers__Planned_Start_Date_Time__c", type:"date",
typeAttributes:{
    weekday: "long",
   year: "numeric",
   month: "long",
     day: "2-digit" }

},
{label:'Job',fieldName: "job", type:"text"},
{label:'Hours Worked',fieldName: "GW_Volunteers__Hours_Worked__c", type:"number"}
]

export default class VolunteerShiftHistoryInfo extends LightningElement {

    @api contactid;
    @api fromparent;
@track shifts;
@track allshifts;
@track dataset;
@track columns = columns;
@track error;
@track currentPage = 1;
@track pageSize = 10;
@track totalRecords = 0;



@wire(getShiftsByContact, {contactid: '$contactid'})
    wiredShifts(result) {
        this.dataset = result;
        if (result.data) {
            this.totalRecords = result.data.length;
            this.error = undefined;
            this.allshifts = result.data.map(
                record => Object.assign(
              { "job": record.GW_Volunteers__Volunteer_Job__r.Name},
               record
               )
             );
                this.shifts = this.allshifts.slice(0,this.pageSize);
                } else if (result.error) {
            this.error = result.error;
            console.log(result.error);
            this.shifts = undefined;
        }
    }

    handlePagination(event){
        const start = (event.detail-1)*this.pageSize;
        const end = this.pageSize*event.detail;
        this.shifts = this.allshifts.slice(start, end);
    }

}