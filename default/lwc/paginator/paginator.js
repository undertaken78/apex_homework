import { LightningElement, api, track, wire } from 'lwc';

export default class Paginator extends LightningElement {
    @api numberOfPage;
    @api pageSize;
    @api totalItemsCount;

    isNextButtonDisabled = false;
    isPreviousButtonDisabled = true;

    get countOfPages() {
        return Math.ceil(this.totalItemsCount / this.pageSize);
    }

    buttonsDisabling() {
        this.countOfPages - this.numberOfPage == 0 ? this.isNextButtonDisabled = true : this.isNextButtonDisabled = false;
        this.numberOfPage == 1 ? this.isPreviousButtonDisabled = true : this.isPreviousButtonDisabled = false;
    }

    renderedCallback() {
        this.buttonsDisabling();
    }

    previousPage() {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    nextPage() {
        this.dispatchEvent(new CustomEvent('next'));
    }
}