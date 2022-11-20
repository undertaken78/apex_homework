import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import { 
    PROPERTY_OWNER_INFO_FIELDS, 
    PROPERTY_OWNER_FIRST_NAME_FIELD,
    PROPERTY_OWNER_LAST_NAME_FIELD,
    PROPERTY_OWNER_PHONE_FIELD,
    PROPERTY_OWNER_HOME_PHONE_FIELD,
    PROPERTY_OWNER_EMAIL_FIELD,
    PROPERTY_OWNER_TOTAL_PROPERTY_PRICE_FIELD, 
    PROPERTY_OWNER_ID 
} from "c/utils"

export default class PropertyOwner extends NavigationMixin(LightningElement) {

    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: PROPERTY_OWNER_INFO_FIELDS })
    property;

    get firstName() {
        return getFieldValue(this.property.data, PROPERTY_OWNER_FIRST_NAME_FIELD) ?? '';
    }

    get lastName() {
        return getFieldValue(this.property.data, PROPERTY_OWNER_LAST_NAME_FIELD) ?? '';
    }

    get phone() {
        return getFieldValue(this.property.data, PROPERTY_OWNER_PHONE_FIELD) ?? '';
    }

    get homePhone() {
        return getFieldValue(this.property.data, PROPERTY_OWNER_HOME_PHONE_FIELD) ?? '';
    }

    get email() {
        return getFieldValue(this.property.data, PROPERTY_OWNER_EMAIL_FIELD) ?? '';
    }

    get totalPropertyPrice() {
        return getFieldValue(this.property.data, PROPERTY_OWNER_TOTAL_PROPERTY_PRICE_FIELD) ?? '';
    }

    get owner() {
        return getFieldValue(this.property.data, PROPERTY_OWNER_ID);
    }

    navigateToOwnerPage(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
            attributes: {
                recordId: this.owner,
                objectApiName:'Contact__c',
                actionName: 'view',
            },
        });
    }
}