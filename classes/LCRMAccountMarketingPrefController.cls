/**
* Class Description :Created as part of CRM -4943 to  Restrict visiblity of Do Not Call,Do Not Mail,Do Not Pay a Visit fields to only accounts  where country equal to United States
                      and to enable edit button for only users having Edit access to those fields 
* Test Class : LCRMAccountMarketingPrefController_Test                       
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2018-04-20   Harika Kalidindi        Created
* =============================================================================
*/ 
public class LCRMAccountMarketingPrefController{

    public ApexPages.StandardController oStandardController;
    public Account oAccount;
    public boolean isEditable{get;set;}
       
    public String profileName;
    public boolean CheckPermission{get;set;}
    public boolean isCountryUS{get;set;}
    
    
    public LCRMAccountMarketingPrefController(ApexPages.StandardController oController) {
            oStandardController = oController;
            oAccount= (Account) oController.getRecord();
            isEditable = false;
            CheckPermission = false;
            isCountryUS  = false;
            //Call Helper Class for Prefernce Link
            profileName = [SELECT Id,Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
            //User username = [SELECT Id,Sub_Bu__c FROM User where Id =:UserInfo.getUserId()];
            Account acc = [SELECT Id,BillingCountry from Account where Id=:oAccount.Id];
            if(acc.BillingCountry.equals('US'))
            {
             isCountryUS = true;
            }
            
            
            Schema.DescribeFieldResult getDoNotMail = Schema.SObjectType.Account.fields.Do_Not_Mail__c; 
            Schema.DescribeFieldResult getDoNotCall = Schema.SObjectType.Account.fields.Do_Not_Call__c; 
            Schema.DescribeFieldResult getDoNotpayVisit = Schema.SObjectType.Account.fields.Do_Not_Pay_a_Visit__c; 
            
            if(getDoNotMail.Updateable || getDoNotCall.Updateable ||  getDoNotpayVisit.Updateable  || profileName=='System Administrator' || profileName=='System Administrator Read Only'){
            
            CheckPermission=true;
            }
            
      }
     
     
     public void changeToEdit()
     {
        
        //Changing  'CheckPermission' to false to disable Edit Button 
         CheckPermission = false;
         //Changing 'isEditable'  to true to enable Save and Cancel Button
         isEditable = true;
     }
     
     public PageReference save()
     {
         Database.update(oAccount,false);
         //Changing  'CheckPermission' to true  to enable Edit Button 
         CheckPermission =true ;
         //Changing 'isEditable'  to false to disable Save and Cancel Button
         isEditable = false;
         PageReference oPage = Page.LCRMAccountMarketingPreferencesSection;
         oPage.getParameters().put('id',oAccount.id);
         oPage.setRedirect(true);
         return oPage;
     }
     
     public PageReference cancel()
     {
         
         //Changing  'CheckPermission' to true  to enable Edit Button 
         CheckPermission =true ;
         //Changing 'isEditable'  to false to disable Save and Cancel Button
         isEditable = false;
         return null;
     }
}