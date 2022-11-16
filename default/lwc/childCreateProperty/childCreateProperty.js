import { LightningElement, api} from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import PROPERTY_OBJECT from '@salesforce/schema/Property__c';
import PROPERTY_OWNER_FIELD from '@salesforce/schema/Property__c.Property_Owner__c';
import COUNTRY_FIELD from '@salesforce/schema/Property__c.City__c';
import CITY_FIELD from '@salesforce/schema/Property__c.Country__c';
import ADDRESS_FIELD from '@salesforce/schema/Property__c.Address__c';
import RECORDTYPEID_FIELD from "@salesforce/schema/Property__c.RecordTypeId"

export default class ChildCreateProperty extends LightningElement {

    @api recordTypeId;
    @api contactId;
    city = '';
    country = '';
    address = '';
    
        
    countryName = COUNTRY_FIELD;
    cityName = CITY_FIELD;
    addressName = ADDRESS_FIELD;

    contactIdView = true;
    countryView = true;
    cityView = true;
    addressView = true;

    counterOfView = 3;

    disableUp = true;
    disableDown = false;

    countOfViewInputFields() {
        if (this.cityView & this.countryView & this.addressView) {
            this.counterOfView = 3;
        }

        if (this.cityView & this.countryView & !this.addressView) {
            this.counterOfView = 2;
        }

        if (this.cityView & !this.countryView & !this.addressView) {
            this.counterOfView = 1;
        }
    }

    buttonUp(event) {
        this.countOfViewInputFields();

        if(this.counterOfView === 2) {
            this.addressView = true;
            this.disableDown = false;
            this.disableUp = true;
        }

        if(this.counterOfView === 1) {
            this.countryView = true;
            this.disableDown = false;
            this.disableUp = false;
        }
    }

    buttonDown(event) {
        this.countOfViewInputFields();
        if(this.counterOfView === 3) {
            this.addressView = false;
            this.disableUp = false;
        }

        if(this.counterOfView === 2) {
            this.countryView = false;
            this.disableUp = false;
            this.disableDown = true;
        }

    }

    propertyChangeVal(event) {
        if(event.target.label === 'City') {
            this.city = event.target.label;
        }

        if(event.target.label === 'Country') {
            this.country = event.target.label;
        }

        if(event.target.label === 'Address') {
            this.address = event.target.label;
        }
    }

    handleButtonSubmit() {
        this.city = this.template.querySelector('[data-id="city"]').value;
        this.country = this.template.querySelector('[data-id="country"]').value;
        this.address = this.template.querySelector('[data-id="address"]').value;

        const fieldsProperty = {};

        fieldsProperty[RECORDTYPEID_FIELD.fieldApiName] = this.recordTypeId;
        fieldsProperty[PROPERTY_OWNER_FIELD.fieldApiName] = this.contactId;
        fieldsProperty[CITY_FIELD.fieldApiName] = this.city;
        fieldsProperty[COUNTRY_FIELD.fieldApiName] = this.country;
        fieldsProperty[ADDRESS_FIELD.fieldApiName] = this.address;

        const recordInput = {
            apiName: PROPERTY_OBJECT.objectApiName,
            fieldsProperty
        };

        createRecord(recordInput)
            .then(property => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title:'Success',
                        message: 'Property record has been created',
                        variant: 'success'
                    })
                );
                this.dispatchEvent(
                    new CustomEvent("nextbuttonclick", {
                    detail:{
                        isVisiblePage: true
                    }
                }));
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title:'Error creating property',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            }
        );

        
    }

    handleCloseButton(event) {
        this.dispatchEvent(new CustomEvent("nextbuttonclick", {
            detail:{
                isVisiblePage: true
            }
        }));
    }
}