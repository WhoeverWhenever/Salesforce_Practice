import { LightningElement, track, wire, api } from 'lwc';
import getRelatedCandidatesWithJAs from '@salesforce/apex/PositionControllerLWC.getRelatedCandidatesWithJAs';
import modalWindow from 'c/modalCandidateInfo';
import { NavigationMixin } from 'lightning/navigation';
import PaginationChannel from '@salesforce/messageChannel/paginationChannel__c';
import { MessageContext, subscribe, publish } from 'lightning/messageService';

export default class CandidateList extends NavigationMixin(LightningElement) {
    @api recordId;
    @track selectedCandidate;
    @track relatedJobApplication;
    @track dataList = [];
    @track candidateData;
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
        }
    }

    handleOpenClick(event) {
        const candidateId = event.currentTarget.dataset.id;
        this.selectedCandidate = this.dataList.find(candidate => candidate.Id === candidateId);
        this.relatedJobApplication = Object.assign({}, ...this.selectedCandidate.Job_Applications__r);
        modalWindow.open({
            candidate : this.selectedCandidate,
            jobApplication: this.relatedJobApplication,
            size: 'medium'
        }).then((result) => {
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
        });
      }

    connectedCallback(){
        console.log("Deployed");
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

    sendNumberOfRecords(){
        const message = {
            action: "sendNumberOfRecords",
            actionData: {totalRecords: this.dataList.length}
        }
        publish(this.messageContext, PaginationChannel, message);
    }

    pageData = ()=>{
        let startIndex = this.recordsPerPage*(this.currentPage-1);
        let endIndex = this.recordsPerPage*this.currentPage;
        this.visibleData = this.dataList.slice(startIndex,endIndex);
     }
}
