import { LightningElement, track, wire, api} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class ChildChooseRecordType extends LightningElement {
    value;
    @api recordType;
    @track objectName = 'Property__c';
    @track propertyRecordTypes = [];

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
            this.recordType = this.propertyRecordTypes[0].value;
        }
        else if (error) {
            this.propertyRecordTypes = [];
        }
    }
 
    get options() {
        return this.propertyRecordTypes;
    }

    handleRadioChange(event) {
        this.recordType = event.target.value;
    }

    nextButtonClick() {
        this.dispatchEvent(new CustomEvent("nextbuttonclick", {
            detail:{
                recordType: this.recordType, 
                isVisiblePage: false
            }
        }));
    }
}