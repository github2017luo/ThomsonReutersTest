import { LightningElement,api, track } from 'lwc';
import getExistingTrailDetails from '@salesforce/apex/OmniTrialsDetailToWrapper.getExistingTrailDetails';
import OmniNoBounceBackContAlert from '@salesforce/label/c.OmniNoBounceBackContAlert';
import OmniEloquaCallSuccessMsg from '@salesforce/label/c.OmniEloquaCallSuccessMsg';
import OmniEloquaCallFailureMsg from '@salesforce/label/c.OmniEloquaCallFailureMsg';
import OmniEloquaResendValidationMsg from '@salesforce/label/c.OmniEloquaResendValidationMsg';
import getOmniTrialsEloquaCallsLWC from '@salesforce/apex/OmniCalltoEloqua.getOmniTrialsEloquaCallsLWC';
import { NavigationMixin } from 'lightning/navigation';
//Custom js class import 
import {showToast} from './omniShowToast';
export default class OmniResendTrials extends NavigationMixin(LightningElement)  {

    @api recordId;
    @api objectApiName; 
    
    @track trailContactsSelected = [];//Omni - Both GSI and Online Contacts

    @track isErrorSpinner = false;
    @track trailContactsToDisplay = [];//Omni - Both GSI and Online Contacts

    @track trialContTableColumns = [
        { label: 'First Name', fieldName: 'firstName', type: 'text' },
        { label: 'Last Name', fieldName: 'lastName', type: 'text' },
        { label: 'Email', fieldName: 'email', type: 'email'},
        { label: 'Status', fieldName: 'trialStatus', type: 'text'},
    ];

    @track  trialPrdIds= [];
    @track seletedProductList = [];
    connectedCallback(){
        this.isErrorSpinner = true;
        var entTrialsWrap = [];
        let entTrialPromise = getExistingTrailDetails({trialId : this.recordId, optyId : '', trialStatus : 'Bounceback'})
                            .then(result=>{
                                entTrialsWrap = JSON.parse(JSON.stringify(result));
                            })
                            .catch(error =>{
                                console.log(JSON.stringify(error));
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching existing Trial Details.'));
                            })
        entTrialPromise.then(()=>{
            if(entTrialsWrap != null && entTrialsWrap != undefined){

                this.trailContactsToDisplay = entTrialsWrap.trialContacts;
                this.seletedProductList = entTrialsWrap.trialProducts;

                var trialPrdSeleted = JSON.parse(JSON.stringify(this.seletedProductList));
                for (let i = 0; i < trialPrdSeleted.length; i++) {
                    this.trialPrdIds.push(trialPrdSeleted[i].trialPrdRecordId);
                }

                if(this.trailContactsToDisplay.length <= 0){
                    this.dispatchEvent(showToast('error','sticky','Error!',OmniNoBounceBackContAlert));
                    this.closeQuickAction();
                    this.isErrorSpinner  = true;
                }else{
                    this.isErrorSpinner=false;
                }
            }

        });
    }

    submitTrials(event){

        this.isErrorSpinner  = true;

        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows(); 
        
        if(selectedRecords !== null && selectedRecords.length > 0){
            //Create List for Trial Prd Ids and Trial Contact Ids
            let trialContIds = [];
            var trialContSeleted = JSON.parse(JSON.stringify(selectedRecords));
            for (let i = 0; i < trialContSeleted.length; i++) {
                trialContIds.push(trialContSeleted[i].trialContRecordId);
            }

            console.log('trialContIds:'+JSON.stringify(trialContIds));
            console.log('trialPrdIdss:'+JSON.stringify(this.trialPrdIds));
            console.log('recordId:'+JSON.stringify(this.recordId));

            var eloquaResult;
            //calling Submit Trial button to Eloqua
            let eloqua = getOmniTrialsEloquaCallsLWC({trialId : JSON.stringify(this.recordId),trialContIds : JSON.stringify(trialContIds), trialProdIds :JSON.stringify(this.trialPrdIds)})
            .then(result =>{
                console.log('result: '+JSON.stringify(result));
                eloquaResult = result;
            })
            .catch(error =>{
                console.log(JSON.stringify(error));
                this.dispatchEvent(showToast('error','sticky','Error!','Error while doing Eloqua Call.'));
            })
            eloqua.then(()=>{
                
                console.log('eloquaResult: '+JSON.stringify(eloquaResult));

                if(eloquaResult === true){
                    this.dispatchEvent(showToast('success','sticky','Success!',OmniEloquaCallSuccessMsg));
                    
                    this.closeQuickAction();
                    this.isErrorInInitialCheck  = true;

                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.recordId,
                            objectApiName: 'Ent_Trial__c',
                            actionName: 'view'
                        }
                    });

                }
                else{
                    this.dispatchEvent(showToast('error','sticky','Error!',OmniEloquaCallFailureMsg));
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.recordId,
                            objectApiName: 'Ent_Trial__c',
                            actionName: 'view'
                        }
                    });
                }    
                this.isErrorSpinner  = false;  
            });
        }
        else{
            this.dispatchEvent(showToast('error','dismissible','Error!',OmniEloquaResendValidationMsg));
            this.isErrorSpinner = false;  
        }
    }

    closeQuickAction() {
        this.dispatchEvent( new CustomEvent('closeQuickAction'));
    }
}