import { LightningElement, api, track } from 'lwc';
import getFieldSetNames from '@salesforce/apex/MetadataControllerLWC.getFieldSetNames';

export default class ProgramSettingsSection extends LightningElement {
    @api comboboxOptions;
    @api objectName;
    @api comboboxLabel;
    @track selectedOption;

    async handleOptions(event) {
        if(this.comboboxOptions && this.objectName){
            this.selectedOption = {...this.comboboxOptions.find(option => option.value === event.detail.value)};
            try{
                this.selectedOption.fields = await getFieldSetNames({sObjectName: this.objectName, fieldSetName: this.selectedOption.label});
            }
            catch(e){
                console.error(JSON.stringify(e));
            }
        }
    }

    get comboboxName(){
        if(this.comboboxLabel){
            return this.comboboxLabel.replace(' ', '');
        }
    }

}