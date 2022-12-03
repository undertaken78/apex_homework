import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import CONTACT_OBJECT from '@salesforce/schema/Contact';
import CONTACT_ID from '@salesforce/schema/Contact.Id';
import CONTACT_FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import CONTACT_LAST_NAME from '@salesforce/schema/Contact.LastName';
import CONTACT_PHONE from '@salesforce/schema/Contact.Phone';
import CONTACT_EMAIL from '@salesforce/schema/Contact.Email';
import CONTACT_TOTAL_PRICE from '@salesforce/schema/Contact.Total_Property_Price__c';

import PROPERTY_OBJECT from '@salesforce/schema/Property__c';
import PROPERTY_NAME from '@salesforce/schema/Property__c.Name';
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

const PROPERTY_PAGE_FIELDS = 'Id, Name, Sold_Price__c, Picture__c';
const PROPERTY_PAGE_SIZE = 8;

const CONTACT_DETAIL_FIELDS = [
    CONTACT_ID,
    CONTACT_OBJECT,
    CONTACT_FIRST_NAME,
    CONTACT_LAST_NAME,
    CONTACT_PHONE,
    CONTACT_EMAIL,
    CONTACT_TOTAL_PRICE,
];

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

import LOG_LWC_OBJECT_TYPE from '@salesforce/schema/LogLWC__c.ObjectType__c';
import LOG_LWC_ACTION_TYPE from '@salesforce/schema/LogLWC__c.ActionType__c';
import LOG_LWC_DESCRIPTION from '@salesforce/schema/LogLWC__c.Description__c';
import LOG_LWC_IS_SUCCESSFUL from '@salesforce/schema/LogLWC__c.IsSuccessful__c';
import LOG_LWC_ERROR_MESSAGE from '@salesforce/schema/LogLWC__c.ErrorMessage__c';
import LOG_LWC_CREATED_DATE from '@salesforce/schema/LogLWC__c.CreatedDate';

const LOG_LWC_TABLE_FIELDS = 'ObjectType__c, ActionType__c, Description__c, IsSuccessful__c, ErrorMessage__c, CreatedDate';

const LOG_LWC_TABLE_COLUMNS = [
    { label: 'ObjectType', fieldName: 'ObjectType__c', hideDefaultActions: true},
    { label: 'ActionType', fieldName: 'ActionType__c', hideDefaultActions: true},
    { label: 'Description', fieldName: 'Description__c', hideDefaultActions: true },
    { label: 'IsSuccessful', fieldName: 'IsSuccessful__c', hideDefaultActions: true},
    { label: 'ErrorMessage', fieldName: 'ErrorMessage__c', hideDefaultActions: true},
    { label: 'CreatedDate', fieldName: 'CreatedDate', hideDefaultActions: true},
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

export function reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }
 
    return (
        errors
            .filter((error) => !!error)
            .map((error) => {
                if (error.body.duplicateResults && error.body.duplicateResults.length > 0) {
                    return error.body.duplicateResults.map((e) => e.message);
                }

                else if (error.body.fieldErrors && error.body.fieldErrors.length > 0 && Array.isArray(error.body.fieldErrors)) {
                    return error.body.fieldErrors.map((e) => e.message);
                }

                else if (error.body.pageErrors && error.body.pageErrors.length > 0 && Array.isArray(error.body.pageErrors)) {
                    return error.body.pageErrors.map((e) => e.message);
                }

                else if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                }
                else if (typeof error.message === 'string') {
                    return error.message;
                }
                return error.statusText;
            })
            .reduce((prev, curr) => prev.concat(curr), [])
            .filter((message) => !!message)
    );
}

export {
    CONTACT_OBJECT,
    CONTACT_FIRST_NAME,
    CONTACT_LAST_NAME,
    CONTACT_PHONE,
    CONTACT_EMAIL,
    CONTACT_TOTAL_PRICE,
    CONTACT_DETAIL_FIELDS,
    PROPERTY_NAME,
    PROPERTY_OWNER_INFO_FIELDS,
    PROPERTY_OBJECT,
    PROPERTY_PAGE_FIELDS,
    PROPERTY_PAGE_SIZE,
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
    LOG_LWC_OBJECT_TYPE,
    LOG_LWC_ACTION_TYPE,
    LOG_LWC_DESCRIPTION,
    LOG_LWC_IS_SUCCESSFUL,
    LOG_LWC_ERROR_MESSAGE,
    LOG_LWC_CREATED_DATE,
    LOG_LWC_TABLE_FIELDS,
    LOG_LWC_TABLE_COLUMNS,
    showNotification
}