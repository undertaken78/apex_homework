import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import PROPERTY_DETAILS_CHANNEL from '@salesforce/messageChannel/Property_Details__c'
import {
    PROPERTY_NAME,
    PROPERTY_OBJECT,
    SOLD_PRICE_FIELD,
    PROPERTY_OWNER_ID,
    CITY_FIELD,
    ADDRESS_FIELD,
} from 'c/utils';
export default class PropertyDetails extends LightningElement {
    error;
    subscription = null;
    propertyId;
    propertyName;
    propertyPicture;
    propertyApiName = PROPERTY_OBJECT.objectApiName;

    fields = [
        PROPERTY_NAME,
        SOLD_PRICE_FIELD,
        CITY_FIELD,
        ADDRESS_FIELD,
        PROPERTY_OWNER_ID,
    ];

    @wire(MessageContext)
    messageContext;

    subscribeToMessageChannel() {
        try {
            this.subscription = subscribe(
                this.messageContext,
                PROPERTY_DETAILS_CHANNEL,
                (message) => this.handleMessage(message)
            );
        } 
        catch (error) {
            this.error = error;
        }
    }

    handleMessage(message) {
        this.propertyId = message.propertyId;
        this.propertyName = message.propertyName;
        this.propertyPicture = message.propertyImage;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }
}