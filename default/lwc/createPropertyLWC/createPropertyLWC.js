import { LightningElement, api } from 'lwc';
 
export default class CreatePropertyLWC extends LightningElement {
    
    @api ownerId;
    recordType;
    isVisiblePage = true;

    @api nextButton(event) {
        this.recordType = event.detail.recordType;
        this.isVisiblePage = event.detail.isVisiblePage;
    }
}