import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getFieldSetNamesWithPaths from '@salesforce/apex/MetadataControllerLWC.getFieldSetNamesWithPaths';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CANDIDATE_OBJECT from '@salesforce/schema/Candidate__c';
import JOB_APPLICATION_OBJECT from '@salesforce/schema/Job_Application__c';

export default class ModalCandidateNew extends NavigationMixin(LightningElement) {

    @track isModalOpen;
    @track candidateFields;
    @track jobApplicationFields;
    @track newCandidateId;
    @track candidateFormIsSubmitted = false;
    candidateApiName = CANDIDATE_OBJECT.objectApiName;
    jobApplicationApiName = JOB_APPLICATION_OBJECT.objectApiName;
    jaFieldsAreEmpty = true;
    candidateForm;
    jaForm;
    hiddenCandidateSubmit;
    hiddenJASubmit;
    hasRendered = false;

    @wire(getFieldSetNamesWithPaths, {sObjectName: 'Candidate__c', fieldSetName: 'Candidate_Modal_New'})
    wiredCandidateFields({error, data}){
        if(data){
            this.candidateFields = Object.values(data).map((field) => {
                return {name: field, showAsterisk: field === 'Name'};
            });
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

    renderedCallback(){
        if(!this.hasRendered){
            this.candidateForm = this.template.querySelector('.candidate-form');
            this.jaForm = this.template.querySelector('.ja-form');
            this.hiddenCandidateSubmit = this.template.querySelector('.candidate-form__hidden-submit');
            this.hiddenJASubmit = this.template.querySelector('.ja-form__hidden-submit');
            this.hasRendered = true;
        }
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

    navigateToCandidateRecordPage(){
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: this.newCandidateId,
                objectApiName: "Candidate__c",
                actionName: "view"
            }
        })
    }

    handleSubmitForm(){
        this.jaFieldsAreEmpty = Object.values(this.template.querySelectorAll(".ja-form lightning-input-field")).every(el => !el.value);
        this.hiddenCandidateSubmit.click();
        if (this.candidateFormIsSubmitted){
            this.candidateForm.submit();
        }
    }


    handleCandidateSubmit(event){
        event.preventDefault();

        event.target.submit(event.detail.fields);
    }

    handleJASubmit(event){
        event.preventDefault();

        const jaFields = event.detail.fields;
        jaFields.Candidate__c = this.newCandidateId;
        
        event.target.submit(jaFields);
    }

    handleCandidateSuccess(event){
        this.showToast('Success!', 'Candidate was successfully created', 'success', 'dismissable');
        this.newCandidateId = event.detail.id;
        this.candidateFormIsSubmitted = true;
        if(this.newCandidateId && this.jaFieldsAreEmpty){
            this.navigateToCandidateRecordPage();
        }
        else if(this.newCandidateId){
            this.hiddenJASubmit.click();
        }
    }

    handleJASuccess(){
        this.showToast('Success!', 'Job Application was successfully created', 'success', 'dismissable');
        this.navigateToCandidateRecordPage();
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
}
