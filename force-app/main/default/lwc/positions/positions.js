import { LightningElement, track, wire } from 'lwc';
import getPositions from '@salesforce/apex/PositionControllerLWC.getPositions';

import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import POSITION_OBJECT from '@salesforce/schema/Position__c';
import  PICKLIST_FIELD from '@salesforce/schema/Position__c.Status__c';
import { RefreshEvent } from "lightning/refresh";

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

    @track positions;
    @track positionData=[];
     saveDraftValues = [];
    @track pickListOptions;
    lastSavedData=[];

    @wire(getObjectInfo, { objectApiName: POSITION_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: PICKLIST_FIELD
    })
    wirePickList({ error, data }) {
        if (data) {
            this.pickListOptions = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getPositions,{selectedFilterOption: '$selectedFilterOption', pickList: '$pickListOptions'})
    positionList(result) {
       
        if(result.data!=null && JSON.stringify(result.data)!='undefined')
        {
            this.positions = JSON.parse(JSON.stringify(result.data));
            this.lastSavedData=this.positions;
            this.positions.forEach(ele => {
                ele.pickListOptions=this.pickListOptions;
            })
        }
        if (result.error) {
            this.positions = undefined;
        }
    };

    updateColumnData(updatedItem)
    {
        let copyData = JSON.parse(JSON.stringify(this.positions));
 
        copyData.forEach(item => {
            if (item.Id === updatedItem.Id) {
                for (let field in updatedItem) {
                    item[field] = updatedItem[field];
                }
            }
        });
 
        this.positions = [...copyData];
    }

    updateDraftValuesAndData(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.saveDraftValues];

       copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
 
        if (draftValueChanged) {
            this.saveDraftValues = [...copyDraftValues];
        } else {
            this.saveDraftValues = [...copyDraftValues, updateItem];
        }
    }

    handleCellChange(event) {
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele=>{
            this.updateDraftValuesAndData(ele);
            this.updateColumnData(ele);
        })
    }

    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
       
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.ShowToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
            this.saveDraftValues = [];
            return this.refresh();
        }).catch(error => {
            this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
        }).finally(() => {
            this.saveDraftValues = [];
        });
    }

    handleCancel(event) {
        let savepicklist=this.pickListOptions;
        this.positions =[];
        this.pickListOptions=null;
        this.pickListOptions=savepicklist;
    }

    ShowToast(title, message, variant, mode){
        const evt = new ShowToastEvent({
                title: title,
                message:message,
                variant: variant,
                mode: mode
            });
            this.dispatchEvent(evt);
    }
 
    async refresh() {
        await refreshApex(this.positions);
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
    }

}