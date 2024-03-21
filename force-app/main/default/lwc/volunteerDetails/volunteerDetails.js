import { LightningElement,api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import {loadStyle} from 'lightning/platformResourceLoader';
import customModal from '@salesforce/resourceUrl/customModal';
const FIELDS = ['Contact.Name'];

export default class VolunteerDetails extends LightningElement {

    @api contactid;
    @api flexipageRegionWidth;
    @api dashboardHeader;
    @api tabOne;
    @api tabTwo;
    @api tabThree;
    @api tabFour;
    @api tabFive;
    @api tabSix;
    @api tabSeven;
    @api tabEight;
    @api allowpastshifts;
    @api monthsToShow;
    @api objectName ='GW_Volunteers__Volunteer_Shift__c';
    @api titleField ='Job_Name__c';
  @api startField ='GW_Volunteers__Start_Date_Time__c';
  @api endField ='Shift_End_Date_Time__c';
  @api colorField ='Calendar_Shift_Color__c';
  @api additionalFilter ='';
  @api aspectRatio = 1;
  @api allDayField ='';
  @api height = '450px';
  @api weekView = 'timeGridWeek';
  @api dayView = 'timeGridDay';
  @api listView = 'listWeek';
  @api AdhocflowName = 'Report_Adhoc_Hours';
   @api flowName ='Report_Volunteer_Hours'; 
   @api signupflowName ='New_Volunteer_Sign_Up_Flow';
   @api lookupflowName ='Volunteer_Contact_Lookup';   
   contactrec;
   @api isLoaded = false;
   timeSpan = 1500;


   connectedCallback() {

    Promise.all([
            loadStyle(this, customModal + '/customModal/customModal.css') //specified filename
        ])
        .then(() => {
            console.log('Loaded style');
        }).catch(error => {
            console.log('css load errror' + error);
            
        });

      this.setVisibility();
    }
   
    get inputVariables() {
        return [
            { name: 'contactid', type: 'String', value: this.contactid }

        ]}

   @wire(getRecord, { recordId: '$contactid', fields: FIELDS})
   wiredRecord({ error, data }) {
    
       if (data) {
           console.log('Contact Found >>' + data);
          // console.log('MOnths to display >>' + this.monthsToShow);
           this.contactrec = data;
           
           
       } else if (error) {
           console.log('Contact Not Found >>' + error);
           this.error = error;
           
       }

   }
   
   setVisibility()
   {
    setTimeout(() => {
        this.isLoaded=true;
      }, this.timeSpan);
    }
   

    get fromparent() {
        return true;
    }

    get contactexists() {
        /*return this.contactrec;*/
        return this.contactrec;
    }

    

    async handleActive(event){
        const activeTab = event.target.value;
        const volunteerShiftInfo = this.template.querySelector('c-volunteer-Shift-Info');
        const volunteerHoursChart = this.template.querySelector('c-volunteer-Hours-Chart');
        const volunteerRatingInfo = this.template.querySelector('c-volunteer-Rating-Info');
       
        switch(activeTab){
            case "two":
        if (volunteerShiftInfo) {
            volunteerShiftInfo.handleRefreshFromParent();
            console.log('Child shift Info Refresh Called >> ' + volunteerShiftInfo);
                    }
                    
        break;
        case "one":
        if (volunteerHoursChart) {
            volunteerHoursChart.handleChartRefreshFromParent();
        }
        if (volunteerRatingInfo) {
            volunteerRatingInfo.handleRatingRefreshFromParent();
        }
        
        console.log('Child Tab 1 Refresh Called >> ');
        break;
        default:
            break;
    }
    }
    
}