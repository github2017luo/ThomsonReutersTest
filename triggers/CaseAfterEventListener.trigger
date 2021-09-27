/**
 * This trigger will handle the after events on Case.
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2016-07-18   Anshu Thakur            Created to handle method in RenewalRequestController.cls
 * 2016-08-03   Amartya Goswami         To update GracePeriodDays on Opportunity related to Case on Closer
 * 2016-08-05   Spandan                 updateEmailForGracePeriodOnQuoteCase
 * 2017-01-23   Saloni Sukhija          sendEmailtoSalesRep
 * 2017-09-04   Ajay Gundaveni          Added ESCCoreCheck flag to skip the apex calls for core related record types
 * ============================================================================
 */
trigger CaseAfterEventListener on Case (after insert, after update,after delete) {
    
     //LTS_6301 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
    
    Boolean ESCCoreCheck = false;
    if(trigger.newMap != NULL && !trigger.newMap.isEmpty()){
               for(Case c:trigger.new){
                   //Herin Acharya - OR condition added for UE as part of DUE-5712  
                 /*  if(c.Is_ESC_Case__c  || c.Origin == Label.UE_Account){ 
                       ESCCoreCheck = true;
                   }else{
                       ESCCoreCheck = false;}    */
                 ESCCoreCheck =   (c.Is_ESC_Case__c  || c.Origin == Label.UE_Account)? true : false ;
             }
    }
     
    if(trigger.isInsert || trigger.isUpdate){
        if(ESCCoreCheck == false ){
        CaseTriggerHandler.updateCaseTeamManager(trigger.oldmap, trigger.new, trigger.isInsert);
        CaseTriggerHandler.updateCaseShareRec(trigger.oldmap, trigger.new, trigger.isInsert);
        }
    }
    
    if(Trigger.isUpdate && trigger.isAfter && !ESCCoreCheck){
        //if(ESCCoreCheck == false){
       CaseTriggerHandlerForCloseCase.updateQuoteOnCaseClosure(trigger.new);
       // Added as part of MCL-2335
       if(checkRecursive.emailAlertCheck){
           CaseCommentHandler.sendEmailonCaseFieldUpdate(trigger.newmap, trigger.oldmap);
           checkRecursive.emailAlertCheck = false;
       }
        CaseTriggerHandlerForCloseCase.updateOpptyGracePeriodDaysOnCaseCloser(trigger.oldmap, trigger.new);  
        
        //added by Saloni for CPQ
        CaseTriggerHandler.insertCaseTeamMember(trigger.oldmap, trigger.newmap);
        CaseTriggerHandler.sendEmailtoSalesRep(trigger.oldmap,trigger.newmap); 
        CaseTriggerHandler.sendQuoteRequestCancellationEmail(trigger.oldmap,trigger.newmap); 
        //}
    }
    
    
   /* if(Trigger.IsUpdate && Trigger.isAfter){
        if(ESCCoreCheck == false){
         CaseTriggerHandlerForCloseCase.updateOpptyGracePeriodDaysOnCaseCloser(trigger.oldmap, trigger.new);  
        
        //added by Saloni for CPQ
        CaseTriggerHandler.insertCaseTeamMember(trigger.oldmap, trigger.newmap);
        CaseTriggerHandler.sendEmailtoSalesRep(trigger.oldmap,trigger.newmap); 
        CaseTriggerHandler.sendQuoteRequestCancellationEmail(trigger.oldmap,trigger.newmap); 
        }
        }
    }*/
    
    //Uncomment later
    
    if((Trigger.IsInsert|| Trigger.IsUpdate) && Trigger.isAfter && !ESCCoreCheck){
        //if(ESCCoreCheck == false){
        CaseTriggerHandlerForCloseCase.updateEmailForGracePeriodOnQuoteCase(trigger.new);
       // }
    
    }
    
    if(Trigger.IsInsert && Trigger.isAfter){
        if(ESCCoreCheck == false){
        CaseTriggerHandlerForCloseCase.submitForApprovalCase(trigger.new);
        }
         LCRMGenericComponent.checkArchiveAccountType(trigger.new);
    }
    
    //Added as part of DPS-18602
    if(Trigger.IsInsert && !CaseTriggerHandler.chkRecursion){
    	CaseTriggerHandler.addCaseTeamEntry(trigger.new);
    }
    
     
}