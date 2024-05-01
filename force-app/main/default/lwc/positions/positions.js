import { LightningElement, track, wire } from 'lwc';
import getPositions from '@salesforce/apex/PositionControllerLWC.getPositions';
import { MessageContext, publish, subscribe } from 'lightning/messageService';
import PaginationChannel from '@salesforce/messageChannel/paginationChannel__c';
import errorMessageLabel from '@salesforce/label/c.Error_Message';
import toastErrorTitleLabel from '@salesforce/label/c.Toast_Error_Title';
import updatedMessageLabel from '@salesforce/label/c.Successfully_Updated';
import toastSuccessTitleLabel from '@salesforce/label/c.Toast_Success_Title';

import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import POSITION_OBJECT from '@salesforce/schema/Position__c';
import  PICKLIST_FIELD from '@salesforce/schema/Position__c.Status__c';

const columns = [
    {label:'Position Title', fieldName:'Name', type:'text'},
    {
        label: 'Status', fieldName: 'Status__c', type: 'picklistColumn', editable: true,
         typeAttributes: {
            placeholder: 'Choose Status', options: { fieldName: 'pickListOptions' }, 
            value: { fieldName: 'Status__c' }, 
            context: { fieldName: 'Id' }
        }
    },
    {label:'Opened Date', fieldName:'Opened_Date__c', type:'date'},
    {label:'Closed Date', fieldName:'Closed_Date__c', type:'date'},
    {label:'Min Pay', fieldName:'Min_Pay__c', type:'currency'},
    {label:'Max Pay', fieldName:'Max_Pay__c', type:'currency'}
];

export default class Positions extends LightningElement {

    columns = columns;
    showSpinner = false;
    @track data = [];
    @track positionData;
    @track draftValues = [];
    lastSavedData = [];
    @track pickListOptions;
    recordsPerPage;
    currentPage = 1;
    visibleData = [];
    @track errorMessages = [];
 
    @wire(getObjectInfo, { objectApiName: POSITION_OBJECT })
    objectInfo;
 
    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: PICKLIST_FIELD
    })
    wirePickList({ error, data }) {
        if (data) {
            this.pickListOptions = data.values;
        } 
        else if (error) {
            this.errorMessages.push(error.body.message);
        }
    }

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        try{
            this.handleSubscribe();
        }
        catch(error){
            console.log(error);
        }
    }
 
    handleSubscribe() {
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.messageContext, PaginationChannel, (message) => {
            this.handlePaginationMessage(message);           
        });
    }

    handlePaginationMessage(message){
        switch (message.action) {
            case 'sendRecordsPerPage':
                this.recordsPerPage = message.actionData.recordsPerPage;
                this.pageData();
                break;
            case 'sendCurrentPage':
                this.currentPage = message.actionData.currentPage;
                this.pageData();
                break;
        }
    }
 
    @wire(getPositions, {selectedFilterOption: '$selectedFilterOption', pickList: '$pickListOptions'})
    positionData(result) {
        this.positionData = result;
        if (result.data) {
            this.data = JSON.parse(JSON.stringify(result.data));
 
            this.data.forEach(ele => {
                ele.pickListOptions = this.pickListOptions;
            })
 
            this.lastSavedData = JSON.parse(JSON.stringify(this.data));
            this.sendNumberOfRecords();
 
        } 
        else if (result.error) {
            this.data = undefined;
            this.errorMessages.push(result.error.body.message);
        }
    };

    sendNumberOfRecords(){
        const message = {
            action: "sendNumberOfRecords",
            actionData: {totalRecords: this.data.length}
        }
        publish(this.messageContext, PaginationChannel, message);
    }
 
    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.data));
 
        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
        this.data = [...copyData];
    }
 
    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
 
        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }
 
    handleCellChange(event) {
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele=>{
            this.updateDraftValues(ele);
        })
    }
 
    handleSave(event) {
        this.showSpinner = true;
        this.saveDraftValues = this.draftValues;
 
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);

            return { fields };
        });
 
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.showToast(toastSuccessTitleLabel, updatedMessageLabel, 'success', 'dismissable');
            this.draftValues = [];

            return this.refresh();
        }).catch(error => {
            console.log(error);
            this.showToast(toastErrorTitleLabel, errorMessageLabel, 'error', 'dismissable');
        }).finally(() => {
            this.draftValues = [];
            this.showSpinner = false;
        });
    }
 
    handleCancel(event) {
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }
 
    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
 
    async refresh() {
        await refreshApex(this.positionData);
    }

    @track selectedFilterOption = 'None';
    @track filterOptions = [
        {label:'None', value:'None'},
        {label:'Open', value:'Open'},
        {label:'Open Hot', value:'Open Hot'},
        {label:'Closed', value:'Closed'},
        {label:'Closed Cancelled', value:'Closed Cancelled'}
    ];

    handleFilterChange(event){
        this.selectedFilterOption = event.detail.value;
        this.sendFilterSelected();
        this.pageData();
        refreshApex(this.positionData);
    }

    sendFilterSelected(){
        const message = {
            action: "sendFilterSelected"
        }
        publish(this.messageContext, PaginationChannel, message);
    }

    pageData = ()=>{
        let startIndex = this.recordsPerPage*(this.currentPage-1);
        let endIndex = this.recordsPerPage*this.currentPage;
        this.visibleData = this.data.slice(startIndex,endIndex);
     }
}
