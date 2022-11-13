import { LightningElement, track, wire, api} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class ChildChooseRecordType extends LightningElement {
    value;
    recordType = '';
    @track objectName = 'Property__c';
    @track propertyRecordTypes =[];

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
        }
        else if (error) {
            console.log('Error while get record types');
            this.propertyRecordTypes = [];
        }
    }
 

    get options() {
        return this.propertyRecordTypes;
    }

    handleRadioChange(event) {
        const selectedOption = event.detail.value;
        this.recordType = selectedOption; // рекорд тип надо засунуть во второй чайлд
        if (selectedOption == 'Industrial') {
            
        }
        else {
        }
      
        
        if (selectedOption == 'Office') {
        }
        else {
        }
        
 
        if (selectedOption == 'Space') {
        }   
        else {
        }
    }


    
    
}