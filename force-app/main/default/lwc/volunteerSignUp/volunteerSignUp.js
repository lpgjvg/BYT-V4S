import { LightningElement, api } from 'lwc';
import {loadStyle} from 'lightning/platformResourceLoader';
import customModal from '@salesforce/resourceUrl/customModal';

export default class VolunteerSignUp extends LightningElement {

    @api flowName;
    @api fromparent;
  
    connectedCallback() {

        Promise.all([
                loadStyle(this, customModal + '/customModal.css') //specified filename
            ])
            .then(() => {
                console.log('Loaded style');
            }).catch(error => {
                console.log('errror' + error);
                
            });
        }

        handleStatusChange(Event) {
            console.log('handleStatusChange', Event.detail);
            if (Event.detail.status === 'FINISHED') {
                this.handleClose();
            }
        }
    
        handleClose() {
            console.log('Sign Up Completed');
        }

}