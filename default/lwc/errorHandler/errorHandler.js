import { LightningElement, api } from 'lwc';

import ERROR_MESSAGE from '@salesforce/label/c.Error_Labels';

import{
    reduceErrors
} from "c/utils"

export default class ErrorHandler extends LightningElement {
    @api errors;
    errorDescription = '';
    errorMessageFromLabel = ERROR_MESSAGE;
    
    connectedCallback() {
        if(this.errors.body) {
            reduceErrors(this.errors);
        }
    }
}