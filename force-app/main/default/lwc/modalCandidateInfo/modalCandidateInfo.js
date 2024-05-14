import { api, track, wire } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ModalCandidateInfo extends LightningModal {
    @api candidate;
    @api jobApplication;
    @api owner;
    @api creator;
    @api modifier;
    @api displayAvatars;

    connectedCallback(){
        console.log("Opened");
    }

    handleOkay() {
        this.close('okay');
    }

    navigateToRecordPage() {
        console.log("Navigate");
        this.close({navigateToPage: true, candidateId: this.candidate.Id});
    }
}
