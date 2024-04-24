import { LightningElement, api, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountControllerLWC.getAccounts';

const columns = [
    {label:'Account Name', fieldName:'Name', type:'text'},
    {label:'Account Number', fieldName:'AccountNumber', type:'text'},
    {label:'Annual Revenue', fieldName:'AnnualRevenue', type:'currency'},
    {label:'Phone', fieldName:'Phone', type:'phone'}
];

export default class AccountList extends LightningElement {

    columns = columns;

    @track accountData;
    @api recordsPerPage = 5;
    @track visibleData = [];

    @wire(getAccounts)
    accountList({data, error}){
        if(data){
            this.accountData = data;
        }
        else{
            console.log(error);
        }
    }

    handleDisplayData(event){
        if(event.detail.records){
            this.visibleData = [...event.detail.records];
        }
        else{
            this.visibleData = this.accountData;
        }
    }
}
