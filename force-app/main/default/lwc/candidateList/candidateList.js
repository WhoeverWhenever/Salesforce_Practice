import { LightningElement, track, wire, api } from 'lwc';
import getRelatedCandidatesWithJAsByQuery from '@salesforce/apex/PositionControllerLWC.getRelatedCandidatesWithJAsByQuery';
import getOwnerDetails from '@salesforce/apex/CandidateControllerLWC.getOwnerDetails';
import getCreatorDetails from '@salesforce/apex/CandidateControllerLWC.getCreatorDetails';
import getModifierDetails from '@salesforce/apex/CandidateControllerLWC.getModifierDetails';
import modalWindow from 'c/modalCandidateInfo';
import { NavigationMixin } from 'lightning/navigation';
import PaginationChannel from '@salesforce/messageChannel/paginationChannel__c';
import { MessageContext, subscribe, publish } from 'lightning/messageService';
import getCurrentUserProfileName from '@salesforce/apex/UserControllerLWC.getCurrentUserProfileName';
import getCurrentUserPermissionsNames from '@salesforce/apex/UserControllerLWC.getCurrentUserPermissionsNames';
import getRecruitingAppSettings from '@salesforce/apex/MetadataControllerLWC.getRecruitingAppSettings';
import getFieldSetNamesWithPaths from '@salesforce/apex/MetadataControllerLWC.getFieldSetNamesWithPaths';

export default class CandidateList extends NavigationMixin(LightningElement) {
    @api recordId;
    @api displayAvatars;
    @track selectedCandidate;
    @track relatedJobApplication;
    @track dataList = [];
    @track errorMessages = [];
    @track owner;
    @track creator;
    @track modifier;
    @track startIndex = 0;
    @track endIndex = 0;
    @track currentUserPermissionsNames = [];
    @track recruitingAppSettings;
    @track candidateTileData = [];
    @track candidateModalData = [];
    @track jobApplicationModalData = [];
    @track candidateTileFields = [];
    @track candidateModalFields = [];
    @track jobApplicationModalFields = [];
    recordsPerPage;
    currentPage = 1;
    visibleData = [];
    candidateSObjectName = 'Candidate__c';
    jobApplicationSObjectName = 'Job_Application__c';
    

    @wire(MessageContext)
    messageContext;

    @wire(getRelatedCandidatesWithJAsByQuery, {positionId: "$recordId", candidateQueryData: '$candidateQueryData', jobApplicationQueryData: '$jobApplicationModalData'})
    candidateData({error, data}){
        if(data){
            this.dataList = data;
            this.sendNumberOfRecords();
            //this.errorMessages.shift();
        }
        else if(error){
            this.dataList = [];
            console.error(error);
            //this.errorMessages.push(error.body.message);
        }
    }

    @wire(getCurrentUserProfileName)
    wiredUserProfileName({error, data}){
        if(data){
            this.currentUserProfileName = data;
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    @wire(getCurrentUserPermissionsNames)
    wiredPermissionNames({error, data}){
        if(data){
            this.currentUserPermissionsNames = data;
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    @wire(getRecruitingAppSettings, {developerName: '$devName'})
    wiredRecruitingAppSettings({error, data}){
        if(data){
            this.recruitingAppSettings = data;
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    @wire(getFieldSetNamesWithPaths, {sObjectName: '$candidateSObjectName', fieldSetName: '$recruitingAppSettings.Candidate_Tile__c'})
    wiredCandidateTileFields({error, data}){
        if(data){
            let tileData = data;
            this.candidateTileData = Object.values(tileData);
            this.candidateTileFields = Object.keys(tileData);
            console.log(JSON.stringify(this.candidateModalFields));
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    @wire(getFieldSetNamesWithPaths, {sObjectName: '$candidateSObjectName', fieldSetName: '$recruitingAppSettings.Candidate_Modal__c'})
    wiredCandidateModalFields({error, data}){
        if(data){
            let modalData = data;
            this.candidateModalData = Object.values(modalData);
            this.candidateModalFields = Object.keys(modalData);
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    @wire(getFieldSetNamesWithPaths, {sObjectName: '$jobApplicationSObjectName', fieldSetName: '$recruitingAppSettings.Job_Application_Candidate_Modal__c'})
    wiredJobApplicationFields({error, data}){
        if(data){
            let jaData = data;
            this.jobApplicationModalData = Object.values(jaData);
            this.jobApplicationModalFields = Object.keys(jaData);
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    async handleOpenClick(event) {
        const candidateId = event.currentTarget.dataset.id;
        this.selectedCandidate = this.dataList.find(candidate => candidate.Id === candidateId);
        this.relatedJobApplication = Object.assign({}, ...this.selectedCandidate.Job_Applications__r);
        this.owner = await getOwnerDetails({candidateId: this.selectedCandidate.Id});
        this.creator = await getCreatorDetails({candidateId: this.selectedCandidate.Id});
        this.modifier = await getModifierDetails({candidateId: this.selectedCandidate.Id});

        modalWindow.open({
            candidate : this.selectedCandidate,
            owner: this.owner,
            creator: this.creator,
            modifier: this.modifier,
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
                          objectApiName: this.candidateSObjectName,
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
        if(this.dataList.length === 0){
            const message = {
                action: "sendNumberOfRecords",
                actionData: {totalRecords: 0}
            }
            publish(this.messageContext, PaginationChannel, message);
        }
        else{
            const message = {
                action: "sendNumberOfRecords",
                actionData: {totalRecords: this.dataList.length}
            }
            publish(this.messageContext, PaginationChannel, message);
        }
    }

    pageData = ()=>{
        this.startIndex = this.recordsPerPage*(this.currentPage-1);
        this.endIndex = this.recordsPerPage*this.currentPage;
        this.visibleData = this.dataList.slice(this.startIndex, this.endIndex);
     }

     get hasInterviewerPermissionSet(){
        return this.currentUserPermissionsNames.some(item => item === 'Interviewer');
     }

     get devName(){
        if(this.hasInterviewerPermissionSet && this.currentUserProfileName !== 'Recruiter'){
            return 'Interviewer_Settings';
        }
        else{
            return 'Recruiter_Settings';
        }
     }

     get candidateQueryData(){
        return [...this.candidateTileData, ...this.candidateModalData].filter((item, index) => 
                [...this.candidateTileData, ...this.candidateModalData].indexOf(item) === index);
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
