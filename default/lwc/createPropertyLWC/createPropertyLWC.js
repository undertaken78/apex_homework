import { LightningElement, api } from 'lwc';
 
export default class CreatePropertyLWC extends LightningElement {
    
    @api recordId;
    recordType;
    isVisiblePage = true;

    @api nextButton(event) {
        console.log(this.recordId);
        this.recordType = event.detail.recordType;
        this.isVisiblePage = event.detail.isVisiblePage;
    }
}