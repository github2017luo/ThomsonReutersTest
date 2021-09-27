/*
@Author: Navjyoti Mohanta
@JIRA Story: CRM-8058
@Purpose: This Batch class is for to find out whether the GLI Contacts hold any Active Entitlement Record or not.
@Version: 

* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
*   01/04/2018  Navjyoti Mohanta        For EQA comments and CRM-13693 Bug    
*	16/04/2018	Navjyoti Mohanta		For CPU Time Limit exceed error                               
* =============================================================================
*/
global class LCRMBatchForActiveContactEntitlements implements Database.Batchable<SObject> {
    
    
    global Database.QueryLocator start (Database.BatchableContext BC){
        Id gliCdsConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact - CDS').getRecordTypeId();
        Id gliConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        List<Id> listOfContactRecordTypeId = new list<Id>();
        listOfContactRecordTypeId.add(gliCdsConRecordTypeId);
        listOfContactRecordTypeId.add(gliConRecordTypeId);
        system.debug('@@@listOfContactRecordTypeId'+listOfContactRecordTypeId);
        
        //Id tempId = '0031B00002Ziobk';
        String query ='SELECT Id , RecordType.Name  ';
        query += 'from Contact where RecordTypeId IN: listOfContactRecordTypeId';
        //query += ' AND Id =: tempId';
        system.debug('the final query is '+query);
        
        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext BC, List<Contact> scope){
        list<Id> listOfIds = new list<Id>();
        list<Contact> listOfUpdateContact = new list<Contact>();
        Date presentDay = Date.TODAY();
        checkRecursive.runConTrigger = false ;
        list<Contact> listOfContactWithEntitlement = new list<Contact>();
        if(scope.size()>0){
            for( contact con : scope){
                listOfIds.add(con.Id);
            }
        }
        if(listOfIds.size()> 0){
         listOfContactWithEntitlement = [Select Id , LCRM_Active_Entitlement__c , Name ,
                                                    (Select Id, LCRM_Contact__c, LCRM_Access_Start_Date__c, LCRM_Access_End_Date__c from Contact_Entitlements__r)
                                                    from Contact where Id IN : listOfIds];
        
        }
        
        system.debug('@@@@listOfContactWithEntitlement.size--->'+listOfContactWithEntitlement.size()); 
        system.debug('@@@@listOfContactWithEntitlement--->'+listOfContactWithEntitlement);
         
         if(listOfContactWithEntitlement.size()> 0){
         for(Contact con :listOfContactWithEntitlement ){             
             list<LCRM_Contact_Entitlement__c> listOfContactEntitlements = con.Contact_Entitlements__r;
             if(listOfContactEntitlements.size()>0){
                 system.debug('@@@listOfContactEntitlements'+listOfContactEntitlements.size()+'completelist'+listOfContactEntitlements);
                 for(LCRM_Contact_Entitlement__c conEntitle :listOfContactEntitlements){
                     if(presentDay <= conEntitle.LCRM_Access_End_Date__c && presentDay >= conEntitle.LCRM_Access_Start_Date__c){
                         con.LCRM_Active_Entitlement__c = true ;
                         break;
                     }else{
                         con.LCRM_Active_Entitlement__c = false;
                     }                     
                 }
             }
             listOfUpdateContact.add(con);            
         }
        }
         
         try{
             if(listOfUpdateContact.size()>0){
                 Database.SaveResult[] srList = Database.Update(listOfUpdateContact,false);
             }
         }Catch(Exception e){
             System.debug('Exception is'+e);             
             
         }         
         
    }
    global void finish(Database.BatchableContext BC){
        
    }
}