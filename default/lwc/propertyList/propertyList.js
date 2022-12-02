import { LightningElement, track, wire} from 'lwc';
import getProperties from '@salesforce/apex/PropertyController.getProperties';
import getPropertiesCount from '@salesforce/apex/PropertyController.getPropertiesCount';
import {PROPERTY_PAGE_FIELDS, PROPERTY_PAGE_SIZE} from 'c/utils';

export default class PropertyList extends LightningElement {
    isLoading = true;
    error;

    numberOfPage = 1;
    sizeOfPage = PROPERTY_PAGE_SIZE;
    totalPropertiesCount = 0;

    @track propertyList = [];

    @wire(getPropertiesCount)
    totalItemCount({data, error}) {
        if (data) {
            this.totalPropertiesCount = data;
        }
        else if (error) {
            this.error = error;
            this.totalPropertiesCount = 0;
        }
    }

    @wire(getProperties, {fields: PROPERTY_PAGE_FIELDS, numberOfPage: '$numberOfPage', pageSize: '$sizeOfPage'})
    properties({error, data}){
        if(data) {
            this.propertyList = data;
        }
        else if (error) {
            this.error = error;
            this.propertyList = [];
        }
        this.isLoading = false;
    }

    nextPage() {
        this.isLoading = true;
        ++this.numberOfPage;
    }

    previousPage() {
        this.isLoading = true;
        --this.numberOfPage;
    }
}