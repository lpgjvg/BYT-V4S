import { LightningElement,wire,track, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import myModal from 'c/dynamicModal';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';
//import contactPresented from '@salesforce/messageChannel/ContactPresented__c';

const FIELDS = ['Contact.Name', 'Contact.MobilePhone', 'Contact.Email', 'Contact.HomePhone', 'Contact.GW_Volunteers__Volunteer_Availability__c', 'Contact.GW_Volunteers__Volunteer_Skills__c'];

export default class ContactInfo extends LightningElement {

  //  currentPageReference = null; 
    //urlStateParameters = null;
    //@track urlId = null;
    @api contactid;
    @track contact;
    @track dataset;
    name;
    phone;
    email;
    skills;
    availability;
    mobile;
    
    
    @wire(MessageContext)
    messageContext;

   
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
    this.name = this.contact.fields.Name.value;
    this.phone = this.contact.fields.HomePhone.value;
    this.mobile = this.contact.fields.MobilePhone.value;
    this.email = this.contact.fields.Email.value;
    this.availability = this.contact.fields.GW_Volunteers__Volunteer_Availability__c.value;
    this.skills = this.contact.fields.GW_Volunteers__Volunteer_Skills__c.value;
    const payload = { cotactId: this.contactid };
    console.log('payload before publish>>>' + payload);
      //  publish(this.messageContext, contactPresented, payload);
}
}




async handleClick() {
    const modalresult = await myModal.open({
        label:'Update Volunteer Info',
        size: 'medium',
        description: 'Accessible description of modal\'s purpose',
        flowName: 'Update_Volunteer_Info',
        inputVariables: this.inputVariables
    });
    console.log('Modal Result>>' + modalresult);
    if(modalresult === 'okay')
    {
        console.log('Refresh Attempted');
        return refreshApex(this.dataset);
        
    }

   

}

get inputVariables() {
    return [
        { name: 'contactid', type: 'String', value: this.contactid }

    ]}


}