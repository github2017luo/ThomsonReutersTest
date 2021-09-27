import { LightningElement,api, track } from 'lwc';
import checkTRAdministratorAssigned from '@salesforce/apex/OmniEndTrialsController.checkTRAdministratorAssigned';
import OmniEndTrialTrialAdministrator from '@salesforce/label/c.OmniEndTrialTrialAdministrator'; 
import getExistingTrailDetails from '@salesforce/apex/OmniTrialsDetailToWrapper.getExistingTrailDetails';
import callToEndTrail from '@salesforce/apex/OmniCalltoEndTrial.callToEndTrail';   
import getPicklistValues from '@salesforce/apex/OmniEndTrialsController.getPicklistValues';
import OmniEndTrialSuccess from '@salesforce/label/c.OmniEndTrialSuccess';
import OmniEndTrialFailure from '@salesforce/label/c.OmniEndTrialFailure';
import OmniEndReasonRequired from '@salesforce/label/c.OmniEndReasonRequired'; 
import OmniNoActiveTrialContact from '@salesforce/label/c.OmniNoActiveTrialContact'; 
import { NavigationMixin } from 'lightning/navigation';

//Custom js class import 
import {showToast} from './omniShowToast';
export default class OmniExtendTrialLWC extends NavigationMixin(LightningElement)  {

    @api recordId;
    @track activeTrialContList = [];
    @track trialStatus;
    @track endReasonOptions;//Picklist value
    @track endReasonSelected; //selected value
    @track isErrorSpinner = false;
    connectedCallback()
    {
        this.isErrorSpinner = true;
        var isPermissionSetAssigned;
        var entTrialsWrap = [];
        let checkPermissionSetPromise = checkTRAdministratorAssigned()
                            .then(result=>{
                                isPermissionSetAssigned = result;
                            })
                            .catch(error =>{
                                console.log(JSON.stringify(error));
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while checking Permission Set exists or not.'));
                            })

        checkPermissionSetPromise.then(()=>{
            
            if(isPermissionSetAssigned === false){
                this.dispatchEvent(showToast('error','sticky','Error!',OmniEndTrialTrialAdministrator));
                this.closeQuickAction();
            }
            else
            {
                let entTrialPromise = getExistingTrailDetails({trialId : this.recordId, optyId : '', trialStatus : 'Active'})
                            .then(result=>{
                                console.log('entTrialsWrap: '+JSON.stringify(result));
                                entTrialsWrap = JSON.parse(JSON.stringify(result));
                                
                            })
                            .catch(error =>{
                                console.log(JSON.stringify(error));
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching existing Trial Details.'));
                            })
                let getPicklistPromise = getPicklistValues({objectName : 'Ent_Trial__c', fieldName : 'End_Reason__c'})
                .then(result=>{
                    console.log('End Reason Picklist: '+JSON.stringify(result));
                    let options = [];
                    if (result) {
                        result.forEach(r => {
                          options.push({
                            label: r,
                            value: r,
                          });
                        });
                      }
                      this.endReasonOptions = options;
              
                    
                })
                .catch(error =>{
                    console.log(JSON.stringify(error));
                    this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching End Reason Picklist.'));
                })
                entTrialPromise.then(()=>{
                    getPicklistPromise.then(()=>{

                    if(entTrialsWrap != null && entTrialsWrap != undefined){
                        this.trialStatus = entTrialsWrap.entTrial.Trial_Status__c;
                        this.activeTrialContList = entTrialsWrap.trialContacts;

                        if(this.activeTrialContList.length <= 0){
                            this.dispatchEvent(showToast('error','sticky','Error!',OmniNoActiveTrialContact));
                            this.closeQuickAction();
                        }
                        else{
                            //call to End Trial API callout 
                            this.isErrorSpinner = false;
                        }
                    }
                });
            });
            }
            
        });
    }
    closeQuickAction() {
        this.dispatchEvent( new CustomEvent('closeQuickAction'));
    }
    getEndReasonPicklistValue(event){
        console.log('ENd Reason: '+event.target.value);
        this.endReasonSelected = event.target.value;
    }

    endTrials(){
        this.isErrorSpinner = true;

        if(this.endReasonSelected === undefined || this.endReasonSelected === null){
            this.dispatchEvent(showToast('error','dismissible','Error!',OmniEndReasonRequired));
            this.isErrorSpinner = false;
        }
        else
        {
            //call to End Trial API
            var endTrialResponse;
            let endTrialPromise = callToEndTrail({trialId : this.recordId, endReason : this.endReasonSelected, requestType : 'TRIAL_END'})
                            .then(result=>{
                                console.log('callToEndTrail: '+JSON.stringify(result));
                                endTrialResponse = result;
                                
                            })
                            .catch(error =>{
                                console.log(JSON.stringify(error));
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching existing Trial Details.'));
                                this.isErrorSpinner = false;
                            })
            endTrialPromise.then(()=>{
                if(endTrialResponse !== true || endTrialResponse === undefined || endTrialResponse === null){
                    this.dispatchEvent(showToast('error','sticky','Error!',OmniEndTrialFailure));
                    
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
                    this.dispatchEvent(showToast('success','sticky','Success!',OmniEndTrialSuccess));
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
}