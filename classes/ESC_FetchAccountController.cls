public without sharing class ESC_FetchAccountController{
    
    public static Map<Id, String> recordtypemap {get;set;}
    @AuraEnabled
    Public static List<RecordType> getRecordTypeId(){
        return [SELECT Id, Name FROM Recordtype where SObjectType = 'ESC_Special_Instruction__c'];
    }

    @AuraEnabled        
     public static Id getCaseRecordTypeID() {
        Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GLI Archive Requests').getRecordTypeId();
        return caseRTID;
    }
    
   @AuraEnabled
     Public static Account getAccList(Id accId){
        Account acc = new Account();
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.isQueryable()){
        acc = [SELECT id,Name FROM Account where Id =: accId];
        }
        return acc;
    }
    
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
    
    @AuraEnabled
    public static String getRecTypeId(Id accId){
        List<Account> accList = new List<Account>();
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.isQueryable()){
        accList = [select id,recordtypeid from Account where id=:accId];
        }
        return accList[0].recordtypeid;
    } 
    
    
   
}