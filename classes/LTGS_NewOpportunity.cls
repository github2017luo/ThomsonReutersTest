/* Class: LTGS_NewOpportunity
 * Purpose:Controller class to fetch related Account and Contact data inorder for creating Lightning Component which is used
   to Achieve 'New Opportunity' button functionality.
 * Created: 2/25/2019
 * Author: Vaishali Gayatri 
 */
public without sharing class LTGS_NewOpportunity {
  
        
/********************************************************************************************************
  getOppRecordTypeID: Method to get GLI Pipeline Opportunity record Type and recordtype id..
********************************************************************************************************/  
     @AuraEnabled 
     public static Id getOppRecordTypeID() {
        Id oppRTID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        return OppRTID;
    }
    
   
/********************************************************************************************************
  getSObjDetails: Method to fetch contact and associated Account details.
********************************************************************************************************/  
     @AuraEnabled
        public static list<Contact> getSObjDetails(Id objId){
        String query;
        query = 'SELECT Id, Name, AccountID  from Contact where id =\''+string.escapeSingleQuotes(objId)+ '\'';
        
        system.debug(query);
        list<sobject>sobjrec = Database.query(query);
        return sobjrec;
    }
}