import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getFieldSetNamesWithPaths from '@salesforce/apex/MetadataControllerLWC.getFieldSetNamesWithPaths';

export default class ModalCandidateNew extends NavigationMixin(LightningElement) {

    @track isModalOpen;
    @track candidateFields;
    @track jobApplicationFields;

    @wire(getFieldSetNamesWithPaths, {sObjectName: 'Candidate__c', fieldSetName: 'Candidate_Modal_New'})
    wiredCandidateFields({error, data}){
        if(data){
            this.candidateFields = Object.values(data);
        }
        else if(error){
            console.error(JSON.stringify(error));
        }
    }

    @wire(getFieldSetNamesWithPaths, {sObjectName: 'Job_Application__c', fieldSetName: 'Job_Application_Modal_New'})
    wiredJobApplicationFields({error, data}){
        if(data){
            this.jobApplicationFields = Object.values(data);
        }
        else if(error){
            console.error(JSON.stringify(error));
        }
    }

    connectedCallback(){
        this.isModalOpen = true;
    }

    openModal(){
        this.isModalOpen = true;
    }

    closeModal(){
        this.isModalOpen = false;
        this.navigateToListView();
    }

    navigateToListView(){
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Candidate__c",
                actionName: "list"
            }
        })
    }

}
