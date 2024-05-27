import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getFieldSetNamesWithPaths from '@salesforce/apex/MetadataControllerLWC.getFieldSetNamesWithPaths';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ModalCandidateNew extends NavigationMixin(LightningElement) {

    @track isModalOpen;
    @track candidateFields;
    @track jobApplicationFields;
    newCandidateId;
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
        this.hiddenCandidateSubmit.click();
        this.hiddenJASubmit.click();
    }


    handleCandidateSubmit(event){
        event.preventDefault();
        console.log('Candidate Fields')
        console.log(event.detail.fields);
        console.log(this.template.querySelectorAll(".ja-form lightning-input-field"));
        this.jaFieldsAreEmpty = Object.values(this.template.querySelectorAll(".ja-form lightning-input-field")).every(el => {
            console.log(el.value);
            return !el.value}
        );
        console.log(this.jaFieldsAreEmpty);
        if(this.jaFieldsAreEmpty){
            event.target.submit();
        }
    }

    handleJASubmit(event){
        event.preventDefault();
        console.log('JA Fields')
        console.log(event.detail.fields);
        // this.jaFieldsAreEmpty = Object.values(event.detail.fields).every(value => !value);
        // console.log(this.jaFieldsAreEmpty);
    }

    handleCandidateSuccess(event){
        this.showToast('Success!', 'Candidate was successfully created', 'success', 'dismissable');
        this.newCandidateId = event.detail.id;
        console.log()
        if(this.newCandidateId){
            this.navigateToCandidateRecordPage();
        }
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
