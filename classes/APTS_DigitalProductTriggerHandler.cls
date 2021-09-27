/* Created By - Raviteja Murukutla
   Purpose - Digital Quote Automation for Best offer
   Jira Story - DLT-1070
   
*/   
public with sharing class APTS_DigitalProductTriggerHandler {
  
    public APTS_DigitalProductTriggerHandler() {
    }
    
    public void OnBeforeInsert(Product_Account_Detail__c[] newPrdAccts){ 
        APTS_DigitalProductTriggerHelper.updatePrdAccountDetails(newPrdAccts);
    }
    
    
    public void OnBeforeUpdate(Product_Account_Detail__c[] newPrdAccts){
        APTS_DigitalProductTriggerHelper.updatePrdAccountDetails(newPrdAccts);
    } 
       
}