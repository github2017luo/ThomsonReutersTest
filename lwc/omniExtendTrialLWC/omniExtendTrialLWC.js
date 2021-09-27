import { LightningElement,api, track } from 'lwc';
import getExistingTrailDetails from '@salesforce/apex/OmniTrialsDetailToWrapper.getExistingTrailDetails';
import callToEndTrail from '@salesforce/apex/OmniCalltoEndTrial.callToEndTrail';
import OmniExtendNoActiveMsg from '@salesforce/label/c.OmniExtendNoActiveMsg';
import OmniExtendExpiredTrialMsg from '@salesforce/label/c.OmniExtendExpiredTrialMsg';
import OmniExtendTrialOnlyOnceMsg from '@salesforce/label/c.OmniExtendTrialOnlyOnceMsg'; 
import omniTrialNoOfDayRequiredLabel from '@salesforce/label/c.OmniTrialNoOfDayRequiredLabel'; 
import omniExtendTrialDateValidation from '@salesforce/label/c.OmniExtendTrialDateValidation'; 
import omniExtendTrialFailure from '@salesforce/label/c.OmniExtendTrialFailure'; 
import omniExtendTrialSuccess from '@salesforce/label/c.OmniExtendTrialSuccess'; 

import { NavigationMixin } from 'lightning/navigation';
//Custom js class import 
import {showToast} from './omniShowToast';
export default class OmniExtendTrialLWC extends NavigationMixin(LightningElement)  {

    @api recordId;
    @api objectApiName; 
    

    @track isErrorSpinner = false;

    @track trialStatus;
    @track extendedFlag;
    @track trialEndDate;
    @track NoOfDaysToExtend;
    //to store trial record details and passto apex for record update
   
    connectedCallback(){
        this.isErrorSpinner = true;
        var entTrialsWrap = [];
        let entTrialPromise = getExistingTrailDetails({trialId : this.recordId, optyId : '', trialStatus : ''})
                            .then(result=>{
                                console.log('entTrialsWrap: '+JSON.stringify(result));
                                entTrialsWrap = JSON.parse(JSON.stringify(result));
                                
                            })
                            .catch(error =>{
                                console.log(JSON.stringify(error));
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching existing Trial Details.'));
                            })
        entTrialPromise.then(()=>{
            if(entTrialsWrap != null && entTrialsWrap != undefined){
               
                this.trialStatus = entTrialsWrap.entTrial.Trial_Status__c;
                this.extendedFlag = entTrialsWrap.entTrial.Extended__c;
                this.trialEndDate = entTrialsWrap.entTrial.Trial_End_Date__c;

                if(this.trialStatus !== null && this.trialStatus === 'Expired'){
                    this.dispatchEvent(showToast('error','sticky','Error!',OmniExtendExpiredTrialMsg));
                    this.closeQuickAction();
                } 
                else if(this.extendedFlag !== null && this.extendedFlag === true){
                    this.dispatchEvent(showToast('error','sticky','Error!',OmniExtendTrialOnlyOnceMsg));
                    this.closeQuickAction();
                } 
                else if(this.trialStatus !== null && this.trialStatus !== 'Active'){
                    this.dispatchEvent(showToast('error','sticky','Error!',OmniExtendNoActiveMsg));
                    this.closeQuickAction();
                } 
                
                  

                console.log('openlwc ');
            this.isErrorSpinner = false;
            }
            
        });
    }

    getNumberOfDays(event){

        this.NoOfDaysToExtend = event.target.value;
        var days =event.target.value;
        var result = new Date(this.trialEndDate);
        var updatedDate = result.setDate(result.getDate() + parseInt(days));
        this.trialEndDate = formatDate(new Date(updatedDate));

    }

    extendTrials(){
        console.log('NoOfDaysToExtend: '+JSON.stringify(this.NoOfDaysToExtend));
        this.isErrorSpinner = true;
        /*this.trialRecord.Trial_End_Date__c = this.trialEndDate;
        this.trialRecord.Trial_Status__c = 'Active';
        this.trialRecord.Extended__c = true;
        this.trialRecord.Trial_Extend_Date__c = formatDate(new Date());
        this.trialRecord.Number_of_Days_to_Extend__c= parseInt(this.NoOfDaysToExtend);
        this.trialRecord.Number_of_Times_Extended__c = 1;
        this.trialRecord.Id = this.recordId;*/
        var extendTrialResponse;
        
        if(this.NoOfDaysToExtend === undefined || this.NoOfDaysToExtend === null || this.NoOfDaysToExtend <= 0){
            this.dispatchEvent(showToast('error','dismissible','Error!',omniTrialNoOfDayRequiredLabel));
            this.isErrorSpinner = false;
        }
        else if(! (parseInt(this.NoOfDaysToExtend) >= 1 &&  parseInt(this.NoOfDaysToExtend) <= 30)){
            this.dispatchEvent(showToast('error','dismissible','Error!',omniExtendTrialDateValidation));
            this.isErrorSpinner = false;
        }
        else{
            //endReason parameter variable name to be changed
             let extendTrialPromise = callToEndTrail({trialId : this.recordId, endReason : this.NoOfDaysToExtend, requestType : 'TRIAL_EXTEND'})
                            .then(result=>{
                                console.log('ExtendTrial: '+JSON.stringify(result));
                                extendTrialResponse = result;
                                
                            })
                            .catch(error =>{
                                console.log(JSON.stringify(error));
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching existing Trial Details.'));
                                this.isErrorSpinner = false;
                            })
         extendTrialPromise.then(()=>{
                if(extendTrialResponse !== true || extendTrialResponse === undefined || extendTrialResponse === null){
                    this.dispatchEvent(showToast('error','sticky','Error!',omniExtendTrialFailure));
                    
                    this.closeQuickAction();
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
                    this.dispatchEvent(showToast('success','sticky','Success!',omniExtendTrialSuccess));
                    this.closeQuickAction();
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.recordId,
                            objectApiName: 'Ent_Trial__c',
                            actionName: 'view'
                        }
                    });
                    
                }
            });
        }
        
    }   

    closeQuickAction() {
        this.dispatchEvent( new CustomEvent('closeQuickAction'));
    }

}
function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;

    return [year, month, day].join('-');
}