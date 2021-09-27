/*
======================================================================================================================
TRIGGER NAME:    AccountAfterEventListener 
======================================================================================================================
=
PURPOSE:   Processes Account records after a DML event is processed by the system

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Karthi                  Optimized the code as per JIRA STORY: PS0-1
2018-05-03       Radhika Pawar           Data Loads by Informatica - Performance Issue (CRM-14872)
2018-05-10       Harika Kalidindi        Added Booelan check to bypass trigger while informatica performs data load(CRM -14346)
======================================================================================================================
*/
trigger AccountAfterEventListener on Account (after delete, after insert, after undelete, after update) {

//LTS_5222 : Exclusion framework
   System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
   if(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
   {return;}
  
  
  
if(Boolean.valueOf(System.Label.DisableTrigger_Account) == False){ // Added as a part of CRM -14346 to bypass trigger while informatica performs data load
    //List<Account> lstAcc = new List<Account>(); Commented by Shovon for ECM dataload issue
    //List<Account> lstAccPhoneUpdt = new List<Account>(); Commented by Shovon for ECM dataload issue
    List<Id> lstAccId = new List<Id>();
    List<Id> lstAccPhoneUpdtId = new List<Id>();
    List<Account> lstAccAddrsUpdt = new List<Account>();
   
    if (trigger.isInsert) {
       if(!Test.isRunningTest()) {
            AccountUtil.executeMDBAccountUpsertService(trigger.new, true);
        }
        for(Account oAccount : trigger.new){
            if(oAccount.Legacy_System_Id__C!=null){
                lstAccAddrsUpdt.add(oAccount);
            }
        }
    }
    if (trigger.isUpdate) {
      if(!Test.isRunningTest()) {
            AccountUtil.executeMDBAccountUpsertService(trigger.new);    
        }
       // AccountHandler.updatePhoneonContactOpportunity(trigger.old, trigger.newMap);
       // AccountHandler.updateLeadBillingAddress(trigger.new,trigger.oldmap);
        for(Account oAccount : trigger.new){
            if(oAccount.Sales_Org__c!=trigger.oldmap.get(oAccount.Id).Sales_Org__c){
               //lstAcc.add(oAccount); Commented by Shovon for ECM dataload issue
               lstAccId.add(oAccount.Id);
               // AccountHandler.updateContactSalesOrg(trigger.new,trigger.oldmap);
            }
            if(oAccount.Phone!=trigger.oldmap.get(oAccount.Id).Phone){
                // lstAccPhoneUpdt.add(oAccount); Commented by Shovon for ECM dataload issue
                lstAccPhoneUpdtId.add(oAccount.Id);
            }
            if(oAccount.BillingCity!=trigger.oldmap.get(oAccount.Id).BillingCity 
                    || oAccount.BillingState!=trigger.oldmap.get(oAccount.Id).BillingState
                    || oAccount.BillingStreet!=trigger.oldmap.get(oAccount.Id).BillingStreet 
                    || oAccount.BillingPostalCode!=trigger.oldmap.get(oAccount.Id).BillingPostalCode
                    || oAccount.BillingCountry!=trigger.oldmap.get(oAccount.Id).BillingCountry
                    || oAccount.URL_2__c!=trigger.oldmap.get(oAccount.Id).URL_2__c
                    || oAccount.Phone!=trigger.oldmap.get(oAccount.Id).Phone                    
                    || oAccount.Sales_Org__c!=trigger.oldmap.get(oAccount.Id).Sales_Org__c
                    || oAccount.Industry!=trigger.oldmap.get(oAccount.Id).Industry
                    || oAccount.Customer_Type__c !=trigger.oldmap.get(oAccount.Id).Customer_Type__c 
                    || oAccount.Customer_Group__c !=trigger.oldmap.get(oAccount.Id).Customer_Group__c 
                    || oAccount.Customer_Class_c__c!=trigger.oldmap.get(oAccount.Id).Customer_Class_c__c
                    || oAccount.MDBID__c!=trigger.oldmap.get(oAccount.Id).MDBID__c
                    || oAccount.Legacy_System_Id__c!=trigger.oldmap.get(oAccount.Id).Legacy_System_Id__c){
                lstAccAddrsUpdt.add(oAccount);
            }
       }
       //AccountHandler.updateContactSalesOrg(lstAcc); ommented by Shovon for ECM dataload issue
       //AccountHandler.updatePhoneonContactOpportunity(lstAccPhoneUpdt, trigger.newMap); Commented by Shovon for ECM dataload issue
       // Commented by @radhika bez facing the Problem while executing OpptyRenewalCancellation_Batch.
       if(lstAccId.size()>0){
       AccountHandler.updateContactSalesOrg(lstAccId);
       }
       if(lstAccPhoneUpdtId.size()>0){
       AccountHandler.updatePhoneonContactOpportunity(lstAccPhoneUpdtId);
       }
       //End Radhika Comment
       AccountHandler.updateQuote(trigger.newMap, trigger.oldMap);
       
     }
     
     if(!lstAccAddrsUpdt.IsEmpty()){
       AccountHandler.updateLeadBillingAddress(lstAccAddrsUpdt,trigger.newMap);
     }
    //Commented as part of DPS-6078
     //Start : LCRM Project : StrikeIron verification
    
     /*  KeyValueListStore__c LCRMStrikeIronFlagINS = KeyValueListStore__c.getValues('LCRMDisableStrikeIronServices');
        Boolean LCRMStrikeIronFlag = LCRMStrikeIronFlagINS != null ? Boolean.valueof(LCRMStrikeIronFlagINS.TextValue__c) : False;
        System.debug('LCRMStrikeIronFlag****'+LCRMStrikeIronFlag);
    
    if(!LCRMStrikeIronFlag){
        AccountHandler handlerObj = new AccountHandler();
        if(Trigger.IsBefore && Trigger.IsInsert){
            handlerObj.verifyEmailAndPhone(null,Trigger.New);
        } 
    }*/

//End : LCRM Project : StrikeIron verification
    }
}