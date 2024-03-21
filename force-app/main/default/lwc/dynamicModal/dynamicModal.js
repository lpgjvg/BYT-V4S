import { api } from 'lwc';
import customModal from '@salesforce/resourceUrl/customModal';
import {loadStyle} from 'lightning/platformResourceLoader';
import LightningModal from 'lightning/modal';
   /** Dynamic modal to run the flows */


export default class DynamicModal extends LightningModal {
    @api flowName;
    @api inputVariables;

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

   
    handleStatusChange(Event) {
        console.log('handleStatusChange', Event.detail);
        if (Event.detail.status === 'FINISHED') {
            this.handleClose();
        }
    }

    handleClose() {
        this.close('okay');
    }


}