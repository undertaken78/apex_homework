import { LightningElement, track, wire, api } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import PROPERTY_DETAILS_CHANNEL from '@salesforce/messageChannel/Property_Details__c'

export default class PropertyItem extends LightningElement {
    /**Компонент, который отображает картинку (создать картинки для всех записей Property),
     *  а также минимальную информацию, например, имя и стоимость продажи (отображать валюту). */

    @api propertyObject; // _property
    nameOfProperty;
    costOfProperty;
    pictureOfProperty;

    @api get property() {
        return this.propertyObject;
    }

    set property(value) {
        this.propertyObject = value;
        this.nameOfProperty = value.Name;
        this.costOfProperty = value.Sold_Price__c;
        this.pictureOfProperty = value.Picture__c;
    }

    @wire (MessageContext)
    messageContext; 

    handlePropertyClick(event) {
        const payload = { 
            propertyId: this.propertyObject.Id,
            propertyName: this.nameOfProperty,
            propertyImage: this.pictureOfProperty,
        };
        publish(this.messageContext, PROPERTY_DETAILS_CHANNEL, payload);
    }
}