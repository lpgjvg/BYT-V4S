import { LightningElement,api,wire,track} from 'lwc';
import getShiftsByContact from '@salesforce/apex/VolunteerController.getShiftsByContact';
import { refreshApex } from '@salesforce/apex';
import myModal from 'c/dynamicModal';
//import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

const columns = [{label: 'Date', fieldName: "GW_Volunteers__Planned_Start_Date_Time__c", sortable:true, type:"date",
typeAttributes:{
    weekday: "long",
   year: "numeric",
   month: "long",
     day: "2-digit" }

},
{label:'Time',fieldName: "GW_Volunteers__Planned_Start_Date_Time__c", type:"date",
typeAttributes:{
    hour:"2-digit",
    minute:"2-digit"
 }
},
{label:'Job',fieldName: "job", sortable: true, type:"text"},
/*{label:'Desc',fieldName: "Volunteer_Job_Description__c", type:"text"},*/
{label:'Cancel',type:'button-icon',initialWidth: 75,
typeAttributes: {
iconName: 'action:close',
title: 'Cancel',
variant: 'border-filled',
alternativeText: 'Details'
}}
]

export default class VolunteerShiftInfo extends LightningElement {
@api contactid;
@api fromparent;
@track shifts;
@track allshifts;
@track dataset;
@track columns = columns;
@track error;
@track currentRow;
@track sortBy;
@track sortDirection;
@track currentPage = 1;
@track pageSize = 10;
@track totalRecords = 0;

/*get totalPages() {
    return Math.ceil(this.totalRecords / this.pageSize);
}

get currentPageShifts() {
    const start = (this.currentPage - 1) * this.pageSize;
    const end = start + this.pageSize;
    return this.shifts.slice(start, end);
}

handlePageChange(event) {
    this.currentPage = event.detail.currentPage;
}*/


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
                console.log('Wire is called in child>>'+this.shifts);
                console.log('Wire is called in child>>'+this.contactid+' '+this.fromparent);
                } else if (result.error) {
            this.error = result.error;
            console.log('No result>>' + result.error);
            this.shifts = undefined;
        }
    }

    handlePagination(event){
        const start = (event.detail-1)*this.pageSize;
        const end = this.pageSize*event.detail;
        this.shifts = this.allshifts.slice(start, end);
    }

    handleRowActions(event) {
        let row = event.detail.row;
        this.currentRow = row.Id;
        window.console.log('actionName ====> ' + this.currentRow);
        this.handleClick();

    }

    async handleClick(currentRow) {
        const modalresult = await myModal.open({
            label:'Cancel Volunteer Shift',
            size: 'medium',
            description: 'Accessible description of modal\'s purpose',
            flowName: 'Volunteer_Shift_Cancellation',
            inputVariables: this.inputVariables
        });
        console.log('Modal Result>>' + modalresult);
        if(modalresult === 'okay')
        {
            
            this.refreshData();
        }
    }

    @api handleRefreshFromParent(){
        
        this.refreshData();
        
    }

    refreshData()
    {
        refreshApex(this.dataset)
        .then(() => {
           console.log('Confirmed Shift Refresh from parent Attempted');
       });
    }

    get inputVariables() {
        return [
            { name: 'shiftid', type: 'String', value: this.currentRow }            

        ]}

        doSorting(event) {
            this.sortBy = event.detail.fieldName;
            this.sortDirection = event.detail.sortDirection;
            this.sortData(this.sortBy, this.sortDirection);
        }
    
        sortData(fieldname, direction) {
            let parseData = JSON.parse(JSON.stringify(this.shifts));
            // Return the value stored in the field
            let keyValue = (a) => {
                return a[fieldname];
            };
            // cheking reverse direction
            let isReverse = direction === 'asc' ? 1: -1;
            // sorting data
            parseData.sort((x, y) => {
                x = keyValue(x) ? keyValue(x) : ''; // handling null values
                y = keyValue(y) ? keyValue(y) : '';
                // sorting values based on direction
                return isReverse * ((x > y) - (y > x));
            });
            this.shifts = parseData;
            console.log('SORT>>'+  this.shifts);
        }    

}