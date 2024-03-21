import { LightningElement,wire,track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getRankingByContact from '@salesforce/apex/VolunteerController.getRankingInfo';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const FIELDS = ['Contact.GW_Volunteers__Volunteer_Hours__c', 'Contact.GW_Volunteers__First_Volunteer_Date__c', 'Contact.GW_Volunteers__Last_Volunteer_Date__c', 'Contact.GW_Volunteers__Volunteer_Last_Web_Signup_Date__c'];

export default class VolunteerRatingInfo extends LightningElement {

    currentPageReference = null; 
    urlStateParameters = null;
    volunteer_hours;
    volunteer_first_date;
    volunteer_last_date;
    volunteer_web_date;
    @track urlId = null;
    @api contactid ;
    @track contact;
    @track dataset;
    @track dataset_rank;
    @track rank;
    @track error;
    @track errorank;
    isLoading = true;
    dummy = false;
    
    
  

   /* @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        this.urlId = currentPageReference.state.contactid;
          if(this.urlId)
          {
            console.log(this.urlId);
          }
          else {
            this.urlId='003AD000009PCAUYA4';
          }
       }
    }*/

    @wire(getRankingByContact, {contactid: '$contactid'})
    wiredRanks(result) {
        console.log('Rating results' + result);
        this.dataset_rank = result;
            if (result.data) {
            this.errorrank = undefined;
            this.ranks = result.data;
            console.log('rating ranks' + this.ranks);
                } else if (result.error) {
            this.errorrank = result.error;
            console.log('rating error>>' + result.error);
            this.ranks = undefined;
            
        }
        if(result.data || result.error)
        {
            this.isLoading = false;
        }
    }
  

    @wire(getRecord, { recordId: '$contactid' , fields: FIELDS})
    wiredcontact(result) {
        this.dataset = result;
        if (result.error) {
            let message = 'Unknown error';
            if (Array.isArray(result.error.body)) {
                message = result.error.body.map(e => e.message).join(', ');
            } else if (typeof result.error.body.message === 'string') {
                message = result.error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message,
                    variant: 'error',
                }),
            );
        } else if (result.data) {
            console.log(result.data);
    this.contact=result.data;
    this.volunteer_hours = this.contact.fields.GW_Volunteers__Volunteer_Hours__c.value;
    this.volunteer_first_date = this.formatDate(this.contact.fields.GW_Volunteers__First_Volunteer_Date__c.value);
    this.volunteer_last_date = this.formatDate(this.contact.fields.GW_Volunteers__Last_Volunteer_Date__c.value);
    this.volunteer_web_date = this.formatDate(this.contact.fields.GW_Volunteers__Volunteer_Last_Web_Signup_Date__c.value);
   
    
}
}

@api handleRatingRefreshFromParent(){
    console.log('Refresh from parent Attempted for Ratings');
    return refreshApex(this.dataset);
}

 formatDate(inputDate) {
    if (!inputDate) {
        return null;
    }

    const parts = inputDate.split('-');
    if (parts.length !== 3) {
        throw new Error("Invalid input date format. Expected YYYY-MM-DD.");
    }
    
    const year = parts[0];
    const month = parts[1];
    const day = parts[2];

    return `${day}/${month}/${year}`;
}


}