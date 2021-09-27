/*
======================================================================================================================
CLASS NAME:  OpptyRenewalCancellation_Batch
======================================================================================================================
PURPOSE:  On Expiration date, system updates Opportunity to Closed Lost stage and those Opportunity Product have renewal action that will be update to cancel .
                Also creates a task for Opportunity Owner to go enter in the Reason field.

CHANGE HISTORY:
======================================================================================================================
DATE              NAME              DESC
23/8/2017      Radhika      
======================================================================================================================
*/

global class OpptyRenewalCancellation_Batch implements Database.Batchable<SObject>{ 
    private String Query;
    List<OpportunityLineItem> listOfOpptyProductUpdate = new List<OpportunityLineItem>();
    List<Task> listOfTask = New List<Task>();
    List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
    Map<Id, Opportunity> optyMap = new Map<Id, Opportunity>();
    boolean isOppty= false;
    List<Id> optyIdList = new List<Id>();
    
    // Start Method
global Database.QueryLocator start(Database.BatchableContext BcthCon){ 
   //Query = 'Select Id,Name,Key_Contact__c,LCRM_Cancellation_Process__c,LCRM_Cancellation_Approval_Status__c,Renewal_Flag__c,StageName,ownerId,LCRM_Status__c,LCRM_Sub_BU__c,Is_GLI__c,LCRM_Owners_Manager_Email__c,Expiration_Date__c,Was_There_a_Competitor__c,Reason__c,Win_Loss__c,(SELECT Id,OpportunityId,LCRM_Action__c,LCRM_Cancel_Reason__c,Opportunity.LCRM_Status__c,Opportunity.StageName FROM OpportunityLineItems where LCRM_Action__c= \'Renew\') FROM Opportunity WHERE Is_GLI__c =True And LCRM_Sub_BU__c = \'UKI\' And Expiration_Date__c <= Today AND Renewal_Flag__c = true And LCRM_Cancellation_Process__c = false And LCRM_Cancellation_Approval_Status__c = \'Approved\' And (LCRM_Status__c IN (\'Pending Cancel\',\'Cancelled\') OR StageName = \'Closed Lost\')';
   //Query = 'Select Id,Name,Key_Contact__c,LCRM_Cancellation_Process__c,LCRM_Cancellation_Approval_Status__c,Renewal_Flag__c,StageName,ownerId,LCRM_Status__c,LCRM_Sub_BU__c,Is_GLI__c,LCRM_Owners_Manager_Email__c,Expiration_Date__c,Was_There_a_Competitor__c,Reason__c,Win_Loss__c,(SELECT Id,OpportunityId,LCRM_Action__c,LCRM_Cancel_Reason__c,Opportunity.LCRM_Status__c,Opportunity.StageName FROM OpportunityLineItems where LCRM_Action__c IN (\'Renew\',\'Add\')) FROM Opportunity WHERE Is_GLI__c =True And LCRM_Sub_BU__c = \'UKI\' And Expiration_Date__c <= Today AND Renewal_Flag__c = true And LCRM_Cancellation_Process__c = false And ((LCRM_Cancellation_Approval_Status__c = \'Approved\' AND LCRM_Status__c IN (\'Pending Cancel\',\'Cancelled\')) OR (LCRM_Status__c IN (\'Suspended\',\'Terminated\')) OR StageName = \'Closed Lost\' )';
   Query = 'Select Id,Name,Key_Contact__c,LCRM_Cancellation_Process__c,LCRM_Cancellation_Approval_Status__c,Renewal_Flag__c,StageName,ownerId,LCRM_Status__c,LCRM_Sub_BU__c,Is_GLI__c,LCRM_Owners_Manager_Email__c,Expiration_Date__c,Was_There_a_Competitor__c,Reason__c,Win_Loss__c,(SELECT Id,OpportunityId,LCRM_Action__c,LCRM_Cancel_Reason__c,Opportunity.LCRM_Status__c,Opportunity.StageName FROM OpportunityLineItems where LCRM_Action__c IN (\'Renew\',\'Add\')) FROM Opportunity WHERE Is_GLI__c =True And LCRM_Sub_BU__c = \'UKI\' And Expiration_Date__c < Today AND Renewal_Flag__c = true And LCRM_Cancellation_Process__c = false And ((LCRM_Cancellation_Approval_Status__c = \'Approved\' AND (LCRM_Status__c IN (\'Pending Cancel\',\'Cancelled\') OR StageName = \'Closed Lost\'))     OR (LCRM_Status__c IN (\'Suspended\',\'Terminated\') AND StageName != \'Closed Lost\' ))';
   System.debug('Opportunity Query:-'+Query);
   return Database.getQueryLocator(Query);
 }
    //Execute Method
global void execute(Database.BatchableContext BtchCon, List<Opportunity> scope){
 try{
     system.debug('++++ Scope is '+ scope.size());
     system.debug('+++ scope value is '+ scope);
     //AccountHandler.renewalCancellationFlow = true;
	 AccountHandler.renewalCancellationFlow = true;
	 ContactTriggerHandler.renewalCancellationFlowContact = true;
    Recordtype TaskRecordtype = new Recordtype ();
    TaskRecordtype = [Select Id from RecordType where developername ='GLI_Record_Type' and IsActive=true and SobjectType='Task' limit 1];
  
    System.debug('TaskRecordtype:-'+TaskRecordtype);
    List<Opportunity> listOfOpportunityUpdate = new List<Opportunity>();
    
    if(scope!= null && scope.size()>0){ 
    for(Opportunity Oppty : scope){
        system.debug('Oppty List is ++++ '+ scope);
        //When Opportunity Closed Lost and Opportunity Product present then Update Opportunuty Product and Create Task.
        if(Oppty.StageName =='Closed Lost'){
            
            Oppty.LCRM_Cancellation_Process__c=true;
            listOfOpportunityUpdate.add(Oppty);
            System.debug('Update Opportunity when Oppty Closed Lost:-'+listOfOpportunityUpdate);
          if(Oppty.OpportunityLineItems != null & Oppty.OpportunityLineItems.size() > 0){
            System.debug('Oppty.OpportunityLineItems: ' + Oppty.OpportunityLineItems);
            //Update Oppty Product with cancel Action 
            CancelOpportunityLineItems(Oppty.OpportunityLineItems);
            System.debug('Update Opportunity Product when Oppty Closed Lost:-'+listOfOpptyProductUpdate );
            //Create Task
            //if(listOfOpptyProductUpdate.size()>0){
               //createTask(Oppty,TaskRecordtype);
            //}
            System.debug('Update listOfTask  when Oppty Closed Lost:-'+listOfTask );
                   
         }//End Opportunity Product size check  
        }else if((Oppty.LCRM_Status__c=='Pending Cancel' ||Oppty.LCRM_Status__c=='Suspended' ||Oppty.LCRM_Status__c=='Terminated' || Oppty.LCRM_Status__c=='Cancelled')&& Oppty.StageName !='Closed Lost'){
            System.debug('Oppty ID:'+Oppty.Id);
            Oppty.Reason__c = KeyValueListStore__c.getValues('LCRM Oppty Reason').TextValue__c;
            if(Oppty.StageName != 'Closed Lost'){
                Oppty.StageName = 'Closed Lost';
                system.debug('++++ Adding Oppty to Map '+ Oppty.Name);
                optyMap.put(Oppty.Id, Oppty);
            }
            
            if(Oppty.LCRM_Status__c=='Pending Cancel'){
                Oppty.LCRM_Status__c = 'Cancelled';
            }
            
            Oppty.Was_There_a_Competitor__c = KeyValueListStore__c.getValues('LCRM Oppty Competitor?').TextValue__c;Oppty.Win_Loss__c = KeyValueListStore__c.getValues('LCRM Oppty Win Loss').TextValue__c;
            Oppty.LCRM_Cancellation_Process__c=true;
            listOfOpportunityUpdate.add(Oppty);
            
            System.debug('Update Opportunity when Oppty not Closed Lost:-'+listOfOpportunityUpdate);
            //Update Opportunity Product
            if(Oppty.OpportunityLineItems != null & Oppty.OpportunityLineItems.size() > 0){
             CancelOpportunityLineItems(Oppty.OpportunityLineItems);
             System.debug('Update Opportunity Product when Oppty not Closed Lost:-'+listOfOpptyProductUpdate );
            }
            //Create Task
            //createTask(Oppty,TaskRecordtype);
            System.debug('Update listOfTask  when Oppty not Closed Lost:-'+listOfTask );
        }
       
      }//End For
    }//End Opportunity Updates
    
    if(listOfOpptyProductUpdate.size()>0){
       // update listOfOpptyProductUpdate;
        List<Database.SaveResult> results = Database.update(listOfOpptyProductUpdate, false);
         trackDatabaseStaus(results);
    } 

     if(listOfOpportunityUpdate.size() > 0){
      //  update listOfOpportunityUpdate;
      List<Database.SaveResult> results = Database.update(listOfOpportunityUpdate, false);
      isOppty = true;
      trackDatabaseStaus(results);
         for(Id optyId: optyIdList){
             system.debug('+++ Inside task creation');
             if(optyMap.get(optyId) != null){
                 system.debug('+++ Task creation Map '+ optyMap.get(optyId).Name );
                 createTask(optyMap.get(optyId),TaskRecordtype);
             }
             
         }
   }

     if(listOfTask.size()> 0){
       system.debug('+++ Insert Insert of task');
         isOppty = false;
       Database.SaveResult[] srList = Database.insert(listOfTask, false);
       trackDatabaseStaus(srList);

    } //

     if(exceptionList.size() > 0){
         insert exceptionList;
     }      
       
    }Catch(Exception Excep){
        System.debug('Error:'+Excep);
        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c = Excep.getMessage();
        excepObj.LCRM_Exception_Trace__c = 'OpptyRenewalCancellation_Batch class'+(Excep.getStackTraceString());
        excepObj.LCRM_Exception_Type__c = 'Error found in Opportunity Renewal Cancellation';                
        excepObj.LCRM_User_ID__c = userinfo.getUserId();
        exceptionList.add(excepObj);
        if(exceptionList.size()>0){
        insert exceptionList;
        }
    }  
}
    //Finish Method
    global void finish(Database.BatchableContext BtchCon){
    }

    /*
    *@Method:- createTask
    * @purpose: Opportunity stage is Closed Lost and Opportunity Product action is Renewal then only Task is Created.
    */
    private void createTask(Opportunity Oppty,Recordtype TaskRecordtype)
    {   System.debug('Oppty:-'+Oppty);
        System.debug('Task Record Type:'+TaskRecordtype);
        List<Task> oTask = new List<Task>();
        Task taskRec = new Task();
        taskRec.OwnerId = Oppty.OwnerID;
        taskRec.Type = KeyValueListStore__c.getValues('LCRM Task Type').TextValue__c; 
        taskRec.Status = KeyValueListStore__c.getValues('LCRM Task Status').TextValue__c;
        taskRec.Subject = KeyValueListStore__c.getValues('LCRM Task Subject').TextValue__c;
        taskRec.ActivityDate = system.today().adddays(7);
        taskRec.WhatId = Oppty.Id;  
        taskRec.WhoID = Oppty.Key_Contact__c;
        taskRec.Priority = KeyValueListStore__c.getValues('LCRM Task Priority').TextValue__c;
        taskRec.LCRM_Sub_BU__c = Oppty.LCRM_Sub_BU__c;
        if(TaskRecordtype!=null){
        taskRec.RecordTypeId = TaskRecordtype.id;
        }
        listOfTask.add(taskRec);
       
    }
    /*
    *@Method:- CancelOpportunityLineItems
    * @purpose: Update Renew action's Oppty Products to cancel with cancellation reason
    */
    private void CancelOpportunityLineItems(List<OpportunityLineItem> lstOpptyLineItem)
    {
    List<OpportunityLineItem> lstOpptyLineItemToUpdate = new List<OpportunityLineItem>();
    if(lstOpptyLineItem.size()>0){
        //For Loop
        for(OpportunityLineItem oLineItem : lstOpptyLineItem)
        {
            if(oLineItem.LCRM_Action__c == 'Renew'){
               oLineItem.LCRM_Cancel_Reason__c = KeyValueListStore__c.getValues('LCRM Oppty Prod CancelReason').TextValue__c;
               oLineItem.LCRM_Action__c = KeyValueListStore__c.getValues('LCRM Oppty Prod Action').TextValue__c;
             }else if(oLineItem.LCRM_Action__c == 'Add'){
               oLineItem.LCRM_Action__c = KeyValueListStore__c.getValues('LCRM Oppty Prod Action - Remove').TextValue__c;
               oLineItem.LCRM_Cancel_Reason__c = KeyValueListStore__c.getValues('LCRM Oppty Prod CancelReason').TextValue__c;
               
             }
            
        listOfOpptyProductUpdate.add(oLineItem);

        }
     }
    }
     /*
    *@Method:- TrackDatabaseStaus
    * @purpose: Represents information about an error that occurred during a DML operation
    */
    
    public void trackDatabaseStaus(List<Database.SaveResult> results){
        // Iterate through each returned result
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Opportunity ID: ' + sr.getId());
                System.debug('++++++++++ Is Opportunity : ' + isOppty);
                if(isOppty){
                    system.debug('+++ Is Opportunity is TRUE');
                    optyIdList.add(sr.getId());
                    system.debug('+++ optyIdList '+ optyIdList);
                }
            }
            else {
            // Operation failed, so get all errors                
            for(Database.Error err : sr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Opportunity fields that affected this error: ' + err.getFields());
                LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                excepObj.LCRM_Exception_Message__c = err.getMessage();
                excepObj.LCRM_Exception_Trace__c = 'OpptyRenewalCancellation_Batch class'+String.valueof(err.getFields());
                excepObj.LCRM_Exception_Type__c = 'Error found in Opportunity Renewal Cancellation';                
                excepObj.LCRM_User_ID__c = userinfo.getUserId();
                exceptionList.add(excepObj);
                
                }//
                
            }
         }
    }//End Method

}