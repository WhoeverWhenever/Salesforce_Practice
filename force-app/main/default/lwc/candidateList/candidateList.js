import { LightningElement, track, wire, api } from 'lwc';
import getRelatedCandidatesWithJAs from '@salesforce/apex/PositionControllerLWC.getRelatedCandidatesWithJAs';
import getOwnerDetails from '@salesforce/apex/CandidateControllerLWC.getOwnerDetails';
import getCreatorDetails from '@salesforce/apex/CandidateControllerLWC.getCreatorDetails';
import getModifierDetails from '@salesforce/apex/CandidateControllerLWC.getModifierDetails';
import modalWindow from 'c/modalCandidateInfo';
import { NavigationMixin } from 'lightning/navigation';
import PaginationChannel from '@salesforce/messageChannel/paginationChannel__c';
import { MessageContext, subscribe, publish } from 'lightning/messageService';

export default class CandidateList extends NavigationMixin(LightningElement) {
    @api recordId;
    @api displayAvatars;
    @track selectedCandidate;
    @track relatedJobApplication;
    @track dataList = [];
    @track errorMessages = [];
    @track candidateData;
    @track owner;
    @track creator;
    @track modifier;
    @track startIndex = 0;
    @track endIndex = 0;
    recordsPerPage;
    currentPage = 1;
    visibleData = [];

    @wire(MessageContext)
    messageContext;

    @wire(getRelatedCandidatesWithJAs, {positionId: "$recordId"})
    candidateData(result){
        this.candidateData = result;
        if(result.data){
            this.dataList = JSON.parse(JSON.stringify(result.data));
            this.sendNumberOfRecords();
        }
        else if(result.error){
            this.dataList = undefined;
            this.errorMessages.push(result.error.body.message);
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
                          objectApiName: "Candidate__c",
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
        this.visibleData = this.dataList.slice(this.startIndex, this.endIndex);
     }

     get candidateListTitle(){
        return `Candidates (${this.startIndex+1}-${this.endIndex}/${this.dataList.length})`;
     }
}
