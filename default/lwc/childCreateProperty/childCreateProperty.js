import { LightningElement, api, track} from 'lwc';

import{
    showNotification
} from "c/utils"

export default class ChildCreateProperty extends LightningElement {
    @api recordTypeId;
    @api recordId;

    @track rowsCount = [{ id: 0 }];;
    
    index = 0;
    disableUp = false;
    disableDown = true;

    buttonUp() {
        this.index++;
        const newRow = { id: this.index };
        this.rowsCount.push(newRow);
        this.disableUp = this.rowsCount.length == 3 ? true : false
        this.disableDown = this.rowsCount.length == 1 ? true : false
    }
    
    buttonDown(event) {
        this.rowsCount = this.rowsCount.filter(function (element) {
            return element.id != parseInt(event.target.accessKey);
        });
        this.disableUp = this.rowsCount.length == 3 ? true : false
        this.disableDown = this.rowsCount.length == 1 ? true : false
    }

    handleSubmitButton() {
        let isInputValid;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isInputValid = element.reportValidity();
        });
        if (isInputValid) {
            try {
                this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                    element.submit();
                });
                this.handleCloseButton();
                showNotification(this, "Success", "Property record has been created", "success");
            } 
            catch(error) {
                showNotification("Error creating property", error.getMessage(), "error");
            }
        } 
    }

    handleCloseButton() {  
        this.dispatchEvent(new CustomEvent("nextbuttonclick", {
            detail:{
                isVisiblePage: true
            }
        }));
    }
}