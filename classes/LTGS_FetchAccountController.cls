/**
* Controller for the LTGS_ChangeRequest_GLI Lightning Component 
* 
* @author  Samarpreet
* @version 2019-02-26
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2012-05-22   Samarpreet              Created     
                                                  
* =============================================================================
*/


public without sharing class LTGS_FetchAccountController {

    // Method to get Account Id and Name Based on the Account ID
    @AuraEnabled
     Public static Account getAccList(Id accId){
        Account acc = new Account();
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.isQueryable()){
        acc = [SELECT id,Name FROM Account where Id =: accId];
        }
        return acc;
    }
    
    //This method returns a list of Account and Contact based on the Parameters based to the method
     @AuraEnabled
    public static list<sobject> getSObjDetails(Id objId, string obj){
        String query;
        if(obj.equals('Account')){
             query = 'SELECT Id, Name from ' +string.escapeSingleQuotes(obj) + ' where id ='+'\''+string.escapeSingleQuotes(objId)+ '\'';
            system.debug(query);
        } else if(obj.equals('Contact')){
             query = 'SELECT Id, Name, AccountID,Contact_Inactive__c  from ' +string.escapeSingleQuotes(obj) + ' where id ='+'\''+string.escapeSingleQuotes(objId)+ '\'';
        }
        system.debug(query);
        list<sobject> sobjrec = Database.query(query);
        return sobjrec;
    }
    
    //This method query to get the record-type id for DQA Request Record Type for Case
    @AuraEnabled
   public static Id getCaseRecordTypeID() {
        Id CaseRTID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('DQA Request').getRecordTypeId();
        return CaseRTID;
    }  
    
    //This Method returns Recordtype id for Account
    @AuraEnabled
    public static String getRecTypeId(Id accId){
        List<Account> accList = new List<Account>();
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.isQueryable()){
        accList = [select id,recordtypeid from Account where id=:accId];
        }
        return accList[0].recordtypeid;
    } 
    
}