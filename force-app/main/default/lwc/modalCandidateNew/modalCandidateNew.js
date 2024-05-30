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
    jobApplicationFieldsAreEmpty = true;
    candidateForm;
    jobApplicationForm;
    hiddenCandidateSubmit;
    hiddenJobApplicationSubmit;
    hasRendered = false;

    @wire(getFieldSetNamesWithPaths, {sObjectName: CANDIDATE_OBJECT.objectApiName, fieldSetName: 'Candidate_Modal_New'})
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

    @wire(getFieldSetNamesWithPaths, {sObjectName: JOB_APPLICATION_OBJECT.objectApiName, fieldSetName: 'Job_Application_Modal_New'})
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
            this.jobApplicationForm = this.template.querySelector('.job-application-form');
            this.hiddenCandidateSubmit = this.template.querySelector('.candidate-form__hidden-submit');
            this.hiddenJobApplicationSubmit = this.template.querySelector('.job-application-form__hidden-submit');
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
                objectApiName: CANDIDATE_OBJECT.objectApiName,
                actionName: "list"
            }
        })
    }

    navigateToCandidateRecordPage(){
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: this.newCandidateId,
                objectApiName: CANDIDATE_OBJECT.objectApiName,
                actionName: "view"
            }
        })
    }

    handleSubmitForm(){
        this.jobApplicationFieldsAreEmpty = Object.values(this.template.querySelectorAll(".job-application-form lightning-input-field")).every(el => !el.value);
        this.hiddenCandidateSubmit.click();
        if (this.candidateFormIsSubmitted){
            this.candidateForm.submit();
        }
    }

    handleCandidateSubmit(event){
        event.preventDefault();

        event.target.submit(event.detail.fields);
    }

    handleJobApplicationSubmit(event){
        event.preventDefault();

        const jobApplicationFields = event.detail.fields;
        jobApplicationFields.Candidate__c = this.newCandidateId;
        
        event.target.submit(jobApplicationFields);
    }

    handleCandidateSuccess(event){
        if(this.newCandidateId){
            this.showToast('Success!', 'Candidate was successfully updated', 'success', 'dismissable');
        }
        else{
            this.showToast('Success!', 'Candidate was successfully created', 'success', 'dismissable');
            this.newCandidateId = event.detail.id;
        }

        this.candidateFormIsSubmitted = true;
        
        if(this.newCandidateId && this.jobApplicationFieldsAreEmpty){
            this.navigateToCandidateRecordPage();
        }
        else if(this.newCandidateId){
            this.hiddenJobApplicationSubmit.click();
        }
    }

    handleJobApplicationSuccess(){
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
