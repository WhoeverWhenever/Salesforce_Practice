import { api, track, wire } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ModalCandidateInfo extends LightningModal {
    @api candidate;
    @api jobApplication;
    @api displayAvatars;

    handleOkay() {
        this.close('okay');
    }

    navigateToRecordPage() {
        this.close({navigateToPage: true, candidateId: this.candidate.id});
    }
}
