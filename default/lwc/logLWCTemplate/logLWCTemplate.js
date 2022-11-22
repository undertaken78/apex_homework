import { LightningElement, track, wire } from 'lwc';
import getLogsLWC from '@salesforce/apex/LogLWCController.getLogsLWC';
import {LOG_LWC_TABLE_FIELDS, LOG_LWC_TABLE_COLUMNS} from 'c/utils'

export default class LogLWCTemplate extends LightningElement {

    @track data = [];

    @wire(getLogsLWC, { fields: LOG_LWC_TABLE_FIELDS })
    logsList({ error, data }) {
        if (data) {
            this.data = this.sortByDate(data);
        }
        else if (error) {
            this.data = [];
        }
    }

    sortByDate(data) {
        let parseData = JSON.parse(JSON.stringify(data));
        return parseData.sort((a, b) => new Date(a.CreatedDate) > new Date(b.CreatedDate) ? -1 : 1);
    }

    get columns() {
        return LOG_LWC_TABLE_COLUMNS;
    }
}