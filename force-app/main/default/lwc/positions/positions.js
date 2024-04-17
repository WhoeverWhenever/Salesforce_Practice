import { LightningElement, track, wire } from 'lwc';
import getPositions from '@salesforce/apex/PositionControllerLWC.getPositions';

const columns = [
    {label:'Position Title', fieldName:'Name', type:'text'},
    {label:'Status', fieldName:'Status__c', type:'picklist'},
    {label:'Opened Date', fieldName:'Opened_Date__c', type:'date'},
    {label:'Closed Date', fieldName:'Closed_Date__c', type:'date'},
    {label:'Min Pay', fieldName:'Min_Pay__c', type:'currency'},
    {label:'Max Pay', fieldName:'Max_Pay__c', type:'currency'}
];


export default class Positions extends LightningElement {

@track selectedFilterOption = 'None';
@track filterOptions = [
    {label:'None', value:'None'},
    {label:'Open', value:'Open'},
    {label:'Open Hot', value:'Open Hot'},
    {label:'Closed', value:'Closed'},
    {label:'Closed Cancelled', value:'Closed Cancelled'}
];

@wire(getPositions, {selectedFilterOption: '$selectedFilterOption'})
positions;

get columns(){
    return columns;
}

handleFilterChange(event){
    this.selectedFilterOption = event.detail.value;
}

}