import { LightningElement, api } from 'lwc';
import {loadStyle} from 'lightning/platformResourceLoader';
import customModal from '@salesforce/resourceUrl/customModal';

export default class VolunteerReportHours extends LightningElement {

    @api flowName;
    @api contactid;
    @api fromparent;
    diff;
    
    get TZoffset() {
        const d = new Date();
        this.diff = d.getTimezoneOffset()/60;
        console.log('TZ Offset>>>' + this.diff )
        return this.diff

    }

    connectedCallback() {

        Promise.all([
                loadStyle(this, customModal + '/customModal/customModal.css') //specified filename
            ])
            .then(() => {
                console.log('Loaded style');
            }).catch(error => {
                console.log('errror' + error);
                
            });
        }

    get inputVariables() {
        return [
            { name: 'contactid', type: 'String', value: this.contactid },
            { name: 'TZoffset', type: 'Number', value: this.TZoffset }

        ]}

        handleStatusChange(Event) {
            console.log('handleStatusChange', Event.detail);
            if (Event.detail.status === 'FINISHED') {
                this.handleClose();
            }
        }
    
        handleClose() {
            console.log('Volunteer Report Hours Completed');
        }

}