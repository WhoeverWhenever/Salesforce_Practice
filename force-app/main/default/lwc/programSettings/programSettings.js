import { LightningElement, track, wire } from 'lwc';
import getAllRecruitingAppSettings from '@salesforce/apex/MetadataControllerLWC.getAllRecruitingAppSettings';
import getFieldSetNames from '@salesforce/apex/MetadataControllerLWC.getFieldSetNames';
import CANDIDATE_OBJECT from '@salesforce/schema/Candidate__c';
import JOB_APPLICATION_OBJECT from '@salesforce/schema/Job_Application__c';

export default class ProgramSettings extends LightningElement {
    @track customMetadataTypes = [];
    @track selectedModalCandidateOption;
    @track selectedModalJobApplicationOption;
    @track tileOptions;
    @track modalCandidateOptions;
    @track modalJobApplicationOptions;

    @wire(getAllRecruitingAppSettings)
    wiredCustomMetadataTypes({error, data}){
        if(data){
            this.customMetadataTypes = data;
            this.tileOptions = this.customMetadataTypes.map(item => ({label: item.Candidate_Tile__c, value: item.Candidate_Tile__c}));
            this.modalCandidateOptions = this.customMetadataTypes.map(item => ({label: item.Candidate_Modal__c, value: item.Candidate_Modal__c}));
            this.modalJobApplicationOptions = this.customMetadataTypes.map(item => ({label: item.Job_Application_Candidate_Modal__c, value: item.Job_Application_Candidate_Modal__c}));
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    get candidateObjectName(){
        return CANDIDATE_OBJECT.objectApiName;
    }

    get jobApplicationObjectName(){
        return JOB_APPLICATION_OBJECT.objectApiName;
    }
}
