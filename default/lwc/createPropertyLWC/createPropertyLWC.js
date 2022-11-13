import { LightningElement, track, api } from 'lwc';
 
let button = false;
let viewButtonHelp = true;

export default class LwcRadioGroup extends LightningElement {
    
    nextButton = button;
    viewButton = viewButtonHelp;
    nextButtonClick() {
        button = true;
        viewButtonHelp = false;
        this.viewButton = viewButtonHelp;
        this.nextButton = button;
    } // импортируй метод из childCreateProperty, которое вызывает событие submit
}