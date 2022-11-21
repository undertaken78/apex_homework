import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import PROPERTY_OBJECT from '@salesforce/schema/Property__c';
import PROPERTY_OWNER_ID from '@salesforce/schema/Property__c.Property_Owner__r.Id';
import SOLD_PRICE_FIELD from "@salesforce/schema/Property__c.Sold_Price__c"
import RENT_PRICE_FIELD from "@salesforce/schema/Property__c.Rent_Price__c"
import COUNTRY_FIELD from '@salesforce/schema/Property__c.City__c';
import CITY_FIELD from '@salesforce/schema/Property__c.Country__c';
import ADDRESS_FIELD from '@salesforce/schema/Property__c.Address__c';
import RECORDTYPEID_FIELD from "@salesforce/schema/Property__c.RecordTypeId"

import PROPERTY_OWNER_FIELD from '@salesforce/schema/Property__c.Property_Owner__c';
import PROPERTY_OWNER_FIRST_NAME_FIELD from '@salesforce/schema/Property__c.Property_Owner__r.FirstName';
import PROPERTY_OWNER_LAST_NAME_FIELD from '@salesforce/schema/Property__c.Property_Owner__r.LastName';
import PROPERTY_OWNER_PHONE_FIELD from '@salesforce/schema/Property__c.Property_Owner__r.Phone';
import PROPERTY_OWNER_HOME_PHONE_FIELD from '@salesforce/schema/Property__c.Property_Owner__r.HomePhone';
import PROPERTY_OWNER_EMAIL_FIELD from '@salesforce/schema/Property__c.Property_Owner__r.Email';
import PROPERTY_OWNER_TOTAL_PROPERTY_PRICE_FIELD from '@salesforce/schema/Property__c.Property_Owner__r.Total_Property_Price__c';

const PROPERTY_OWNER_INFO_FIELDS = [
    PROPERTY_OWNER_ID,
    PROPERTY_OWNER_FIRST_NAME_FIELD,
    PROPERTY_OWNER_LAST_NAME_FIELD,
    PROPERTY_OWNER_PHONE_FIELD,
    PROPERTY_OWNER_HOME_PHONE_FIELD,
    PROPERTY_OWNER_EMAIL_FIELD,
    PROPERTY_OWNER_TOTAL_PROPERTY_PRICE_FIELD,
];

const PERSONS = [
    {firstName: 'Alexey', lastName: 'Jgurov', gender: 'Male', birthday: new Date(1995, 1, 10), email: 'alex.agurov@mail.ru'},
    {firstName: 'Bogdan', lastName: 'Iagurov', gender: 'Male', birthday: new Date(1996, 2, 11), email: 'bogda.agurov@mail.ru'},
    {firstName: 'Cristian', lastName: 'Hagurov', gender: 'Male', birthday: new Date(1997, 3, 12), email: 'zris.agurov@mail.ru'},
    {firstName: 'Daniel', lastName: 'Gagurov', gender: 'Male', birthday: new Date(1998, 4, 13), email: 'nanil.agurov@mail.ru'},
    {firstName: 'Egor', lastName: 'Fgurov', gender: 'Male', birthday: new Date(1999, 5, 14), email: 'ngor.agurov@mail.ru'},
    {firstName: 'Fedor', lastName: 'Ogurov', gender: 'Male', birthday: new Date(2000, 6, 15), email: 'eedos.agurov@mail.ru'},
    {firstName: 'Georgiy', lastName: 'Iurov', gender: 'Male', birthday: new Date(2001, 7, 16), email: 'georg.agurov@mail.ru'},
    {firstName: 'Halina', lastName: 'Xagurov', gender: 'Female', birthday: new Date(2002, 8, 17), email: 'hal.agurov@mail.ru'},
    {firstName: 'Iliya', lastName: 'Ygurov', gender: 'Male', birthday: new Date(2003, 9, 18), email: 'ol.agurov@mail.ru'},
    {firstName: 'Jane', lastName: 'Lagurov', gender: 'Female', birthday: new Date(2004, 10, 19), email: 'jane.agurov@mail.ru'},
]

const PERSON_COLUMNS = [
    { label: 'FirstName', fieldName: 'firstName', hideDefaultActions: true},
    { label: 'LastName', fieldName: 'lastName', hideDefaultActions: true},
    { label: 'Gender', fieldName: 'gender', hideDefaultActions: true},
    { label: 'Birthday', fieldName: 'birthday', type: 'date', hideDefaultActions: true},
    { label: 'Email', fieldName: 'email', type: 'email', hideDefaultActions: true},
];

const PERSON_OPTIONS = [
    { value: 'firstName', label: 'FirstName'},
    { value: 'lastName', label: 'LastName'},
    { value: 'email', label: 'Email'},
];

const showNotification = (page, title, message, variant) => {
    page.dispatchEvent(
        new ShowToastEvent({
            title,      
            message,    
            variant     
        })
    );
}

export {
    PROPERTY_OWNER_INFO_FIELDS,
    PROPERTY_OBJECT,
    PROPERTY_OWNER_ID,
    PROPERTY_OWNER_FIELD,
    SOLD_PRICE_FIELD,
    RENT_PRICE_FIELD,
    COUNTRY_FIELD,
    CITY_FIELD,
    ADDRESS_FIELD,
    RECORDTYPEID_FIELD,
    PROPERTY_OWNER_FIRST_NAME_FIELD,
    PROPERTY_OWNER_LAST_NAME_FIELD,
    PROPERTY_OWNER_PHONE_FIELD,
    PROPERTY_OWNER_HOME_PHONE_FIELD,
    PROPERTY_OWNER_EMAIL_FIELD,
    PROPERTY_OWNER_TOTAL_PROPERTY_PRICE_FIELD,
    PERSONS,
    PERSON_COLUMNS,
    PERSON_OPTIONS,
    showNotification
}