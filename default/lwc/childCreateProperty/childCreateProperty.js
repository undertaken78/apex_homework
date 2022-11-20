import { LightningElement, api} from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

import{
    PROPERTY_OBJECT,
    PROPERTY_OWNER_FIELD,
    SOLD_PRICE_FIELD,
    RENT_PRICE_FIELD,
    COUNTRY_FIELD,
    CITY_FIELD,
    ADDRESS_FIELD,
    RECORDTYPEID_FIELD,
    showNotification
} from "c/utils"

export default class ChildCreateProperty extends LightningElement {

    @api recordTypeId;
    @api recordId;
    city = '';
    country = '';
    address = '';
    rentPrice;
    soldPrice;
    
        
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
        this.rentPrice = this.template.querySelector('[data-id="rentprice"]').value;
        this.soldPrice = this.template.querySelector('[data-id="soldprice"]').value;
        this.city = this.template.querySelector('[data-id="city"]').value;
        this.country = this.template.querySelector('[data-id="country"]').value;
        this.address = this.template.querySelector('[data-id="address"]').value;

        const fieldsProperty = {};

        fieldsProperty[SOLD_PRICE_FIELD.fieldApiName] = this.soldPrice;
        fieldsProperty[RENT_PRICE_FIELD.fieldApiName] = this.rentPrice;
        fieldsProperty[RECORDTYPEID_FIELD.fieldApiName] = this.recordTypeId;
        fieldsProperty[PROPERTY_OWNER_FIELD.fieldApiName] = this.recordId;
        fieldsProperty[CITY_FIELD.fieldApiName] = this.city;
        fieldsProperty[COUNTRY_FIELD.fieldApiName] = this.country;
        fieldsProperty[ADDRESS_FIELD.fieldApiName] = this.address;

        const recordInput = {
            ApiName: PROPERTY_OBJECT.objectApiName,
            fieldsProperty
        };

        createRecord(recordInput)
            .then(property => {
                showNotification('Success', 'Property record has been created', 'success');
                this.dispatchEvent(
                    new CustomEvent("nextbuttonclick", {
                    detail:{
                        isVisiblePage: true
                    }
                }));
            })
            .catch(error => {
                showNotification('Error creating property', error.body.message, 'error');
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