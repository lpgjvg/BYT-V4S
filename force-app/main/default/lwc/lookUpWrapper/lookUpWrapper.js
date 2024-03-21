import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class lookUpWrapper extends LightningElement {
    parentAccountSelectedRecord;
    parentContactSelectedRecord;
    messageTitle;
    messageBody;
    variant;
    childcount;
    hasShifts = false;
    success=false;
    spinner = false;
    error=false;
    @api jobId;
    @api shiftId='';
    @api contactid;
    @api dateValue;
    @api hourValue = '';
    userClicked = false;

    get inputVariables() {
        console.log('Job Id>>>' + this.jobId);
        return [
            { name: 'contactid', type: 'String', value: this.contactid },
            { name: 'jobid', type: 'String', value: this.jobId },
            { name: 'shiftid', type: 'String', value: this.shiftId },
            { name: 'datevalue', type: 'Date', value: this.dateValue },
            { name: 'hourvalue', type: 'Number', value: this.hourValue }

        ];
    }

    get success() {
        return this.success;
    }

    get error() {
        return this.error;
    }

    get spinner() {
        return this.spinner;
    }
        
        handleStatusChange(Event) {
            console.log('Entered handleStatusChange', Event.detail);
            this.spinner=false;
            if (Event.detail.status === 'FINISHED' || Event.detail.status === 'FINISHED_SCREEN') {
                console.log('handleStatusChange', Event.detail);
                this.messageTitle = 'Success';
                this.messageBody = 'Record saved successfully!';
                this.variant = 'success';
                this.success = true;
                this.showToast();
            }
            if (Event.detail.status === 'ERROR') {
                console.log('handleStatusChange', Event.detail);
                this.messageTitle = 'Error';
                this.messageBody = 'An error occurred while saving the record.';
                this.variant = 'error';
                this.error = true;
                this.showToast();
            }
        }
    
        
        showToast() {
            const event = new ShowToastEvent({
                title: this.messageTitle,
                message: this.messageBody,
                variant: this.variant
            });
            this.dispatchEvent(event);
        }

        get isButtonDisabled() {
            return !(this.jobId && (this.shiftId || this.dateValue) && this.hourValue );
        }

        get hasChildShifts() {
            //console.log('Has Child Shifts>>>', this.hasShifts);
            return this.hasShifts;
        }


        
        get userClicked() {
            //console.log('User clicked', this.userClicked);
            return this.userClicked;
        }

    handleValueSelectedOnAccount(event) {
        this.parentAccountSelectedRecord = event.detail;
        this.jobId = event.detail.id;
        this.childcount = event.detail.childCount;
        if(this.childcount > 0)
        {
            this.hasShifts = true;
        }
       // console.log('ID>>>',this.jobId);
       // console.log('Main Field>>>',event.detail.mainField);
       // console.log('Child Count>>>',event.detail.childCount);
    }

    handleValueSelectedOnContact(event) {
        this.parentContactSelectedRecord = event.detail;
        this.shiftId = event.detail.id;
        //console.log('ID>>>',this.shiftId);
        //console.log('shift Main Field>>>',event.detail.mainField);
    }

    handleValueDeselectedOnContact() {
        this.parentContactSelectedRecord = '';
        this.shiftId='';
        this.success = false;
        this.userClicked = false;
    }

    handleValueDeselectedOnAccount() {
        this.parentAccountSelectedRecord = '';
        this.parentContactSelectedRecord = '';
        this.jobId='';
        this.success = false;
        this.userClicked = false;
        this.hasShifts = false;
    }

    handleDateChange(event) {
        this.dateValue = event.target.value;

    }

    handleHoursChange(event) {
        this.hourValue = event.target.value;
    }

    handleClick() {
        this.userClicked = true;
        this.success = false;
        this.error = false;
        this.spinner = true;
    }
}