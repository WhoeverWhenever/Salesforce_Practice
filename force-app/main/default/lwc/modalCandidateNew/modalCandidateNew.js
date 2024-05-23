import { LightningElement, track } from 'lwc';

export default class ModalCandidateNew extends LightningElement {

    @track isModalOpen;

    openModal(){
        this.isModalOpen = true;
    }

    closeModal(){
        this.isModalOpen = false;
    }

}
