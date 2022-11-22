import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import createLogLWC from '@salesforce/apex/LogLWCController.createLogLWC';
import{
    showNotification,
    PROPERTY_OBJECT
} from "c/utils"
import propertyRecordTypeChooseTemplate from './propertyRecordTypeChoose.html';
import propertyCreatingTemplate from './propertyCreatingFE4.html';

export default class PropertyCreatingFE4 extends LightningElement {
    @api recordId;
    recordTypeId;

    @track rowsCount = [{ id: 0 }];
    @track objectName = PROPERTY_OBJECT.objectApiName;
    @track propertyRecordTypes = [];

    isVisiblePage = true;
    index = 0;
    disableUp = false;
    disableDown = true;

    value;

    @wire(getObjectInfo, { objectApiName: '$objectName' })
   
    getObjectInfo({ error, data }) {
        if (data) {
            this.propertyRecordTypes = [];
            for (let key in data.recordTypeInfos) {
                if(data.recordTypeInfos[key].name != 'Master') {
                this.propertyRecordTypes.push({ value: key, label:data.recordTypeInfos[key].name});
                }
            }
            this.value = this.propertyRecordTypes[0].value;
            this.recordTypeId = this.propertyRecordTypes[0].value;
        }
        else if (error) {
            this.propertyRecordTypes = [];
        }
    }
 
    get options() {
        return this.propertyRecordTypes;
    }

    handleRadioChange(event) {
        this.recordTypeId = event.target.value;
    }

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
        let isInputValid = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isInputValid = isInputValid && element.reportValidity();
        });
        if (isInputValid) {
            const descriptionForLogLWC = this.rowsCount.length + ' property\nRecordType: ' + this.recordTypeId;
            let errorMessageForLog = '';

            try {
                this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                    element.submit();
                });
                this.handleCloseButton();
                showNotification(this, "Success", "Property record has been created", "success");
            } 
            catch(error) {
                showNotification("Error creating property", error.getMessage(), "error");
                errorMessageForLog = error.getMessage();
            }
            finally{
            createLogLWC({objectType: PROPERTY_OBJECT.objectApiName, actionType: 'Insert', description: descriptionForLogLWC, errorMessage: errorMessageForLog});
            }
        } 
    }

    render() {
        return this.isVisiblePage ? propertyRecordTypeChooseTemplate : propertyCreatingTemplate;
    }

    nextButtonClick() {
        this.isVisiblePage = !this.isVisiblePage;
    }

    handleCloseButton() {  
        this.isVisiblePage = true;
    }
}