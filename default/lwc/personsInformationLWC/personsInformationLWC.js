import { LightningElement, api } from 'lwc';

class Person {
    constructor(firstName, lastName, gender, birthday, email) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.gender = gender;
    this.birthday = birthday;
    this.email = email;
    }
}

const person1 = new Person("Виталий", "Цаль", "Мужской", new Date(2004, 2, 27), "arthasWK@mail.ru");
const person2 = new Person("Даниил", "Сорока", "Мужской", new Date(2003, 2, 24), "danila.gorilla@gmail.com");
const person3 = new Person("Александр", "Смирнов", "Мужской", new Date(2002, 4, 26), "ssasha.moscow@yandex.ru");
const person4 = new Person("Юлия", "Кустанович", "Женский", new Date(2001, 5, 25), "finch203@gmail.com");
const person5 = new Person("Маргарита", "Фабишевская", "Женский", new Date(2000, 6, 24), "exusiai@mail.ru");
const person6 = new Person("Канеки", "Кен", "Мужской", new Date(1999, 7, 23), "dead.inside@gmail.com");
const person7 = new Person("Павел", "Сенла", "Мужской", new Date(1998, 8, 22), "undertaken789@gmail.com");
const person8 = new Person("Наруто", "Узумаки", "Мужской", new Date(1997, 9, 21), "surtur@gmail.com");
const person9 = new Person("Ангелина", "Евлеева", "Женский", new Date(1996, 10, 20), "silver.ash@yandex.ru");
const person10 = new Person("Акаме", "Гуреева", "Женский", new Date(1995, 11, 19), "nname@mail.ru");
const persons = [person1, person2, person3, person4, person5, person6, person7, person8, person9, person10];

const columns = [
    { label: 'FirstName', fieldName: 'firstName', hideDefaultActions: true},
    { label: 'LastName', fieldName: 'lastName', hideDefaultActions: true},
    { label: 'Gender', fieldName: 'gender', hideDefaultActions: true},
    { label: 'Birthday', fieldName: 'birthday', type: 'date', hideDefaultActions: true},
    { label: 'Email', fieldName: 'email', type: 'email', hideDefaultActions: true},
];

const options = [
    { value: 'firstName', label: 'FirstName'},
    { value: 'lastName', label: 'LastName'},
    { value: 'email', label: 'Email'},
];

export default class PersonsInformation extends LightningElement {
    data = [...persons];
    filterGender = '';
    dateRange = ['', ''];
    sortBy = '';
    emailSearchKey = '';
    columns = columns;
    options = options;
    value = 'firstName';

    recordsSort() {
        this.data = [...persons];
        this.emailSearchSort();
        this.dateRangeSort();
        this.genderSort();
        this.sortBySort();
    }

    emailSearchSort() {
        let searchRecords = [];
        for (let record of this.data) {
            if(record.email.startsWith(this.emailSearchKey)){
                searchRecords.push(record);
            }
        }
        this.data = searchRecords;
    }

    dateRangeSort() {
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

    genderSort() {
        let records = [];
        if (this.filterGender != '')
        {
            for (let record of this.data) {
                if (record.gender == this.filterGender) {
                    records.push(record);             
                }           
            }      
            this.data = records;
        }
        else this.checkGenders();
    }

    checkGenders() {
        const male = this.data.find(person => person.gender == 'Мужской');
        const female = this.data.find(person => person.gender == 'Женский');
        let checkboxes = Array.from(this.template.querySelectorAll('[data-id="checkbox"]'));
        checkboxes.forEach(element => element.disabled = false);

        if (male == undefined) {
            let element = checkboxes.find(element => element.name == 'Мужской');
            element.disabled = true;
        }

        if (female == undefined) {
            let element = checkboxes.find(element => element.name == 'Женский');
            element.disabled = true;
        }
    }

    sortBySort() {
        let keyValue = (key) => {return key[this.sortBy];};
        let parseData = JSON.parse(JSON.stringify(this.data));

        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
           
            return (x > y) - (y > x);
        });
        this.data = parseData;
    }

    handleChange(event){
        this.emailSearchKey = event.target.value.toLowerCase();
        this.recordsSort();
    }

    handleSort(event){
        this.sortBy = event.detail.value;
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
        this.data = [...persons];
        this.filterGender = '';
        this.dateRange = ['', ''];
        this.sortBy = '';
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