import { LightningElement} from 'lwc';

import{
    PERSONS,
    PERSON_COLUMNS,
    PERSON_OPTIONS
} from 'c/utils'


export default class PersonsInformation extends LightningElement {
    data = [...PERSONS];
    filterGender = '';
    dateRange = ['', ''];
    sortByKey = '';
    emailSearchKey = '';
    columns = PERSON_COLUMNS;
    options = PERSON_OPTIONS;
    value = 'firstName';

    recordsSort() {
        this.data = [...PERSONS];
        this.emailSearchFilter();
        this.dateRangeFilter();
        this.genderFilter();
        this.sortBy();
    }

    emailSearchFilter() {
        this.data = this.data.filter(record => record.email.startsWith(this.emailSearchKey));
    }

    dateRangeFilter() {
        const fromDate = new Date(this.dateRange[0]);
        const toDate = new Date(this.dateRange[1]);

        const element = this.template.querySelector('lightning-input[data-id="fromSort"]');
        if (this.dateRange[0] && this.dateRange[1] && fromDate > toDate) {
            element.setCustomValidity('Wrong date range');
        }
        else element.setCustomValidity('');
        element.reportValidity();

        let searchRecords = [];
        for (let record of this.data) {
            if ((!this.dateRange[0] || this.dateRange[0].length == 0 || record.birthday >= fromDate) && 
                (!this.dateRange[1] || this.dateRange[1].length == 0 || record.birthday <= toDate)) {       
                searchRecords.push(record);
            }
        }
        this.data = searchRecords;
    }

    genderFilter() {
        if (this.filterGender != '') { 
            this.data = this.data.filter(record => record.gender == this.filterGender);
        }
        else this.checkGenders();
    }

    checkGenders() {
        const male = this.data.find(person => person.gender == 'Male');
        const female = this.data.find(person => person.gender == 'Female');
        const checkboxes = Array.from(this.template.querySelectorAll('[data-id="checkbox"]'));
        checkboxes.forEach(element => element.disabled = false);

        if (male == undefined) {
            const element = checkboxes.find(element => element.name == 'Male');
            element.disabled = true;
        }

        if (female == undefined) {
            const element = checkboxes.find(element => element.name == 'Female');
            element.disabled = true;
        }
    }

    sortBy() {
        let keyValue = (key) => {return key[this.sortByKey];};
        let parseData = JSON.parse(JSON.stringify(this.data));

        parseData.sort((firstValue, secondValue) => {
            firstValue = keyValue(firstValue) ? keyValue(firstValue) : ''; 
            secondValue = keyValue(secondValue) ? keyValue(secondValue) : '';
           
            return (firstValue > secondValue) - (secondValue > firstValue);
        });
        this.data = parseData;
    }

    handleChange(event){
        this.emailSearchKey = event.target.value.toLowerCase();
        this.recordsSort();
    }

    handleSort(event){
        this.sortByKey = event.detail.value;
        this.recordsSort();
    }

    handleGenderFilter(event) {
        this.filterGender = '';
        Array.from(this.template.querySelectorAll('[data-id="checkbox"]')).forEach(element => {
            if (element == event.target && element.checked) {
                this.filterGender = element.name;
            }
            else element.checked = false;
        });
        this.recordsSort();
    }

    handleDateChange(event) {
        const from = this.template.querySelector('lightning-input[data-id="fromSort"]').value;
        const to = this.template.querySelector('lightning-input[data-id="toSort"]').value;
        this.dateRange = [from, to];
        this.recordsSort();
    }

    handleReset(event) {
        this.data = [...PERSONS];
        this.filterGender = '';
        this.dateRange = ['', ''];
        this.sortByKey = '';
        this.emailSearchKey = '';

        this.template.querySelector('[data-id="sortByBox"]').value = 'firstName';
        this.template.querySelector('[data-id="fromSort"]').value = '';
        this.template.querySelector('[data-id="toSort"]').value = '';
        this.template.querySelector('[data-id="emailInput"]').value = '';
        Array.from(this.template.querySelectorAll('[data-id = "checkbox"]')).forEach(element => {
            element.checked = false;
        });
    }
}