import { LightningElement, track, wire, api } from 'lwc';
import getRelatedCandidatesWithJAsByQuery from '@salesforce/apex/PositionControllerLWC.getRelatedCandidatesWithJAsByQuery';
import getUserDetails from '@salesforce/apex/CandidateControllerLWC.getUserDetails';
import modalWindow from 'c/modalCandidateInfo';
import { NavigationMixin } from 'lightning/navigation';
import PaginationChannel from '@salesforce/messageChannel/paginationChannel__c';
import { MessageContext, subscribe, publish } from 'lightning/messageService';
import getCurrentUserProfileName from '@salesforce/apex/UserControllerLWC.getCurrentUserProfileName';
import getCurrentUserPermissionsNames from '@salesforce/apex/UserControllerLWC.getCurrentUserPermissionsNames';
import getRecruitingAppSettings from '@salesforce/apex/MetadataControllerLWC.getRecruitingAppSettings';
import getFieldSetNamesWithPaths from '@salesforce/apex/MetadataControllerLWC.getFieldSetNamesWithPaths';
import CANDIDATE_OBJECT from '@salesforce/schema/Candidate__c';
import JOB_APPLICATION_OBJECT from '@salesforce/schema/Job_Application__c';

export default class CandidateList extends NavigationMixin(LightningElement) {
    @api recordId;
    @api displayAvatars;
    @track selectedCandidate;
    @track relatedJobApplication;
    @track dataList = [];
    @track errorMessages = [];
    @track startIndex = 0;
    @track endIndex = 0;
    @track currentUserPermissionsNames = [];
    @track recruitingAppSettings;
    @track candidateTileData;
    @track candidateModalData;
    @track jobApplicationModalData;
    recordsPerPage;
    currentPage = 1;
    visibleData = [];
    candidateAvatarFields = ['Owner ID', 'Created By ID', 'Last Modified By ID'];
    

    @wire(MessageContext)
    messageContext;

    @wire(getRelatedCandidatesWithJAsByQuery, {positionId: "$recordId", candidateQueryData: '$candidateQueryData', jobApplicationQueryData: '$jobApplicationQueryData'})
    candidateData({error, data}){
        if(data){
            this.dataList = data;
            this.sendNumberOfRecords();
        }
        else if(error){
            this.dataList = [];
            this.errorMessages.push(JSON.stringify(error));
        }
    }

    @wire(getCurrentUserProfileName)
    wiredUserProfileName({error, data}){
        if(data){
            this.currentUserProfileName = data;
        }
        else if(error){
            console.error(error.body.message);
        }
    }

    @wire(getCurrentUserPermissionsNames)
    wiredPermissionNames({error, data}){
        if(data){
            this.currentUserPermissionsNames = data;
        }
        else if(error){
            console.error(error.body.message);
        }
    }

    @wire(getRecruitingAppSettings, {developerName: '$devName'})
    wiredRecruitingAppSettings({error, data}){
        if(data){
            this.recruitingAppSettings = data;
        }
        else if(error){
            console.error(error.body.message);
        }
    }

    @wire(getFieldSetNamesWithPaths, {sObjectName: CANDIDATE_OBJECT.objectApiName, fieldSetName: '$recruitingAppSettings.Candidate_Tile__c'})
    wiredCandidateTileFields({error, data}){
        if(data){
            this.candidateTileData = data;
        }
        else if(error){
            this.candidateTileData = undefined;
            console.error(error.body.message);
        }
    }

    @wire(getFieldSetNamesWithPaths, {sObjectName: CANDIDATE_OBJECT.objectApiName, fieldSetName: '$recruitingAppSettings.Candidate_Modal__c'})
    wiredCandidateModalFields({error, data}){
        if(data){
            this.candidateModalData  = data;
        }
        else if(error){
            this.candidateModalData  = undefined;
            console.error(error.body.message);
        }
    }

    @wire(getFieldSetNamesWithPaths, {sObjectName: JOB_APPLICATION_OBJECT.objectApiName, fieldSetName: '$recruitingAppSettings.Job_Application_Candidate_Modal__c'})
    wiredJobApplicationFields({error, data}){
        if(data){
            this.jobApplicationModalData = data;
        }
        else if(error){
            this.jobApplicationModalData = undefined;
            console.error(error.body.message);
        }
    }

    async handleOpenClick(event) {
        const candidateId = event.currentTarget.dataset.id;
        this.selectedCandidate = this.candidateModalFields.find(candidate => candidate.id === candidateId);
        this.relatedJobApplication = this.getJobApplicationModalFields(Object.assign({}, ...this.selectedCandidate.jobApplication));
        await this.getCandidateAvatarFieldIds(this.selectedCandidate.avatarFields);

        modalWindow.open({
            candidate : this.selectedCandidate,
            jobApplication: this.relatedJobApplication,
            displayAvatars: this.displayAvatars,
            size: 'medium'
        }).then((result) => {
            if(result){
                if(result.navigateToPage){
                    this[NavigationMixin.Navigate]({
                        type: "standard__recordPage",
                        attributes: {
                          recordId: result.candidateId,
                          objectApiName: CANDIDATE_OBJECT.objectApiName,
                          actionName: "view",
                        },
                      });
                }
            }
        }).catch((error)=>{
            this.errorMessages.push(error.body.message);
        });
      }

    connectedCallback(){
        try{
            this.handleSubscribe();
        }
        catch(error){
            this.errorMessages.push(error.body.message);
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

    sendNumberOfRecords(){
        const message = {
            action: "sendNumberOfRecords",
            actionData: {totalRecords: this.dataList.length}
        }
        publish(this.messageContext, PaginationChannel, message);
    }

    pageData = ()=>{
        this.startIndex = this.recordsPerPage*(this.currentPage-1);
        this.endIndex = this.recordsPerPage*this.currentPage;
        this.visibleData = this.candidateTileFields.slice(this.startIndex, this.endIndex);
     }

     getJobApplicationModalFields(jobApplication){
        if(this.jobApplicationModalData && jobApplication){
            let fieldValues = {id: jobApplication.Id,
                               coverLetter: jobApplication.Cover_Letter__c,
                               fields: []};

            Object.keys(this.jobApplicationModalData).forEach((field) => {
                fieldValues.fields.push({key: field, value: jobApplication[this.jobApplicationModalData[field]]})
            });

            return fieldValues;
        }
     }

     async getCandidateAvatarFieldIds(candidateAvatarFields){
        const ids = new Set();
        if(candidateAvatarFields){
            Object.values(candidateAvatarFields).forEach((field) => {
                ids.add(field.value);
            });

            const users = await getUserDetails({userIds: Array.from(ids)});
            Object.values(candidateAvatarFields).forEach((field) => {
                field.value = users.find((user) => user.Id === field.value);
            });
        }
     }

     get devName(){
        if(this.currentUserPermissionsNames.length > 0){
            let hasInterviewerPermissionSet = this.currentUserPermissionsNames.some(item => item === 'Interviewer');
            if(hasInterviewerPermissionSet && this.currentUserProfileName !== 'Recruiter'){
                return 'Interviewer_Settings';
            }
            else{
                return 'Recruiter_Settings';
            }
        }
     }

     get candidateQueryData(){
        if(this.candidateTileData && this.candidateModalData){
            const candidateTileFieldAPIs = Object.values(this.candidateTileData);
            const candidateModalFieldAPIs = Object.values(this.candidateModalData);

            return [...candidateTileFieldAPIs, ...candidateModalFieldAPIs].filter((item, index) => 
                [...candidateTileFieldAPIs, ...candidateModalFieldAPIs].indexOf(item) === index);
        }
     }

     get jobApplicationQueryData(){
        if(this.jobApplicationModalData){
            return Object.values(this.jobApplicationModalData);
        }
     }

     get candidateTileFields(){
        if(this.candidateTileData && this.dataList.length > 0){
            return this.dataList.map((obj) => {
                let fieldValues = {id: obj.Id, 
                                   name: obj.Name,
                                   avatar: obj.Avatar_Image__c,
                                   jobApplication: obj.Job_Applications__r,
                                   fields: []};
                                   
                Object.keys(this.candidateTileData).forEach((field) => {
                    fieldValues.fields.push({key: field, value: obj[this.candidateTileData[field]]})
                });

                return fieldValues;
            })
        }
     }

     get candidateModalFields(){
        if(this.candidateModalData && this.dataList.length > 0){
            return this.dataList.map((obj) => {
                let fieldValues = {id: obj.Id, 
                                   name: obj.Name,
                                   avatar: obj.Avatar_Image__c,
                                   jobApplication: obj.Job_Applications__r,
                                   fields: [],
                                   avatarFields: []};

                Object.keys(this.candidateModalData).forEach((field) => {
                    if(this.candidateAvatarFields.includes(field)){
                        fieldValues.avatarFields.push({key: field.slice(0, field.length-3), value: obj[this.candidateModalData[field]]});
                    }
                    else{
                        fieldValues.fields.push({key: field, value: obj[this.candidateModalData[field]]});
                    }
                });

                return fieldValues;
            })
        }
     }

     get candidateListTitle(){
        if(this.dataList.length > 0){
            return `Candidates (${this.startIndex+1}-${this.endIndex}/${this.dataList.length})`;
        }
        else{
            return 'No Candidates';
        }
     }
}
