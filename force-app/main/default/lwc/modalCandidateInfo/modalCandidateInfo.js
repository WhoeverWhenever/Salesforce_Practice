import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';
import { NavigationMixin } from 'lightning/navigation';

export default class ModalCandidateInfo extends LightningModal {
    @api candidate;
    @api jobApplication;

    connectedCallback(){
        console.log("Opened");
        console.log(JSON.stringify(this.jobApplication));
    }

    handleOkay() {
        this.close('okay');
    }

    navigateToRecordPage() {
        console.log("Navigate");
        console.log(this.candidate.Id);
        this.close({navigateToPage: true, candidateId: this.candidate.Id});
    }
}