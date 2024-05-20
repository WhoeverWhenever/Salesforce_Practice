import { LightningElement, track, wire } from 'lwc';
import getAllRecruitingAppSettings from '@salesforce/apex/MetadataControllerLWC.getAllRecruitingAppSettings';
import getFieldSetNames from '@salesforce/apex/MetadataControllerLWC.getFieldSetNames';

export default class ProgramSettings extends LightningElement {
    @track customMetadataTypes = [];
    @track selectedTileOption;
    @track selectedModalCandidateOption;
    @track selectedModalJobApplicationOption;
    fieldSetData = 'names';
    candidateSObjectName = 'Candidate__c';
    jobApplicationSObjectName = 'Job_Application__c';

    async handleTileOptions(event) {
        this.selectedTileOption = this.tileOptions.find(option => option.value === event.detail.value);
        this.selectedTileOption.fields = await getFieldSetNames({sObjectName: this.candidateSObjectName, 
                                                                 fieldSetName: this.selectedTileOption.label});
    }
    async handleModalCandidateOptions(event) {
        this.selectedModalCandidateOption = this.modalCandidateOptions.find(option => option.value === event.detail.value);
        this.selectedModalCandidateOption.fields = await getFieldSetNames({sObjectName: this.candidateSObjectName, 
                                                                           fieldSetName: this.selectedModalCandidateOption.label});
    }
    async handleModalJobApplicationOptions(event) {
        this.selectedModalJobApplicationOption = this.modalJobApplicationOptions.find(option => option.value === event.detail.value);
        this.selectedModalJobApplicationOption.fields = await getFieldSetNames({sObjectName: this.jobApplicationSObjectName, 
                                                                                fieldSetName: this.selectedModalJobApplicationOption.label});
    }

    @wire(getAllRecruitingAppSettings)
    wiredCustomMetadataTypes({error, data}){
        if(data){
            this.customMetadataTypes = data;
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    get tileOptions(){
        return this.customMetadataTypes.map(item => ({label: item.Candidate_Tile__c, 
                                                      value: item.Candidate_Tile__c}));
    }

    get modalCandidateOptions(){
        return this.customMetadataTypes.map(item => ({label: item.Candidate_Modal__c, 
                                                      value: item.Candidate_Modal__c}));
    }

    get modalJobApplicationOptions(){
        return this.customMetadataTypes.map(item => ({label: item.Job_Application_Candidate_Modal__c, 
                                                      value: item.Job_Application_Candidate_Modal__c}));
    }
}
