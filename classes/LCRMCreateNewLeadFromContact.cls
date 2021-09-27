/**
 @description LCRMCreateNewLeadFromContact Description
 @comment LCRMCreateNewLeadFromContact Comment
 */
public without sharing class LCRMCreateNewLeadFromContact {
    
   
    /**
     @description Aura Method 
     @comment getAccountDetails description      
     @param contactId (Id): contactId
     @return Map<String,String>: Return description
     */
    @AuraEnabled
    public static  Map<String,String> getAccountDetails(Id contactId) {
        Map<String,String> accountValuesMap = new Map<String,String>();
        Contact con = [SELECT id,Accountid,FirstName,LastName,ESC_tocLanguage__c,Phone,email,Account.Name,Account.Bu_Segment__c,Account.BillingCountryCode,
                       Account.BillingStreet, Account.BillingCity, Account.BillingState,Account.BillingStateCode,
                       Account.BillingPostalCode,Account.BillingCountry 
                       FROM contact WHERE id =: contactId WITH SECURITY_ENFORCED];
        Id  recordTypeid=Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Create_New_Lead').getRecordTypeId();
        accountValuesMap.put('LEADRECORDTYPEID',recordTypeid);           
        //other fields
        accountValuesMap.put('ACCOUNTID',con.AccountId);   
        accountValuesMap.put('ACCOUNTNAME',con.account.Name);  
        accountValuesMap.put('ACCOUNTFROZENSEGMENT',con.account.Bu_Segment__c);  
        accountValuesMap.put('CONTACTTFIRSTNAME',con.FirstName);   
        accountValuesMap.put('CONTACTLASTNAME',con.LastName);   
        accountValuesMap.put('CONTACTLANGUAGEPRESFERENCE',con.ESC_tocLanguage__c);   
        accountValuesMap.put('CONTACTPHONE',con.Phone);   
        accountValuesMap.put('CONTACTEMAIL',con.Email);
        //Address Field
        accountValuesMap.put('ACCOUNBILLINGCOUNTRY',con.account.BillingCountry);
        accountValuesMap.put('ACCOUNBILLINGSTATE',con.account.BillingState);
        accountValuesMap.put('ACCOUNBILLINGCITY',con.account.BillingCity);
        accountValuesMap.put('ACCOUNTSTREET',con.account.BillingStreet);
        accountValuesMap.put('ACCOUNBILLINGPOSTALCODE',con.account.BillingPostalCode);
        accountValuesMap.put('ACCOUNBILLINGCOUNTRYCODE',con.account.BillingCountryCode);
        accountValuesMap.put('ACCOUNBILLINGSTATECODE',con.account.BillingStateCode);
        return accountValuesMap;
        
    }
    
}