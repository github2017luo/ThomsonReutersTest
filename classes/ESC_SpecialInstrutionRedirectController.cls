/**********************************
Class Name: SpecialInstrutionRedirectController
Purpose:Used in by Page 'SpecialInstrutionRedirectAccount' and 'SpecialInstrutionRedirectContact' to Create Special Instruction from Account and Contact related list
Author:Mousumi Panda
Date Created:11/05/2017
Date Updated:V0:
**********************************/
public class ESC_SpecialInstrutionRedirectController {
  Id parentId;
  Contact con;
  Account acc;
  String prefix; 
  public string callfunc{get;set;}
    public ESC_SpecialInstrutionRedirectController(ApexPages.StandardSetController controller) {
   
    parentId=ApexPages.currentPage().getParameters().get('id');
     prefix = Schema.getGlobalDescribe().get('ESC_Special_Instruction__c').getDescribe().getKeyPrefix();
    }
    
    public PageReference redirctSIContact(){
        if(UserInfo.getUiThemeDisplayed() =='Theme4u')  {
            callfunc=system.label.Accout_Special_Instruction_RLErr;
            return null;
        }else{  
            con=[Select Id,Name From Contact where Id =: parentId];
            ESC_Static_Values__c escStatic1 = ESC_Static_Values__c.getValues('ContactNameId');
            String contactNameID = escStatic1.ESC_Value__C;
            String contactIDLookUP = escStatic1.ESC_Value__C+'_lkid';
            String recordtypeId = Schema.SObjectType.ESC_Special_Instruction__c.RecordTypeInfosByName.get('Contact Instruction').recordTypeId;
            
            String contctname=EncodingUtil.urlEncode(con.Name,'UTF-8');
            return new PageReference('/'+prefix+'/e?'+contactNameID+'='+contctname+'&'+contactIDLookUP+'='+parentId+'&RecordType='+recordtypeId+'&retURL='+parentId+'&nooverride=1');
            
        }
    }
    
    
    
    public PageReference redirctSIAccount(){
        if(UserInfo.getUiThemeDisplayed() =='Theme4u')  {
            callfunc=system.label.Accout_Special_Instruction_RLErr;
            return null;
        }else{
            acc=[Select Id,Name From Account where Id =: parentId];
            ESC_Static_Values__c escStatic1 = ESC_Static_Values__c.getValues('AccountNameId');
            String accountNameID = escStatic1.ESC_Value__C;
            String accountIDLookUP = escStatic1.ESC_Value__C+'_lkid';
            String recordtypeId = Schema.SObjectType.ESC_Special_Instruction__c.RecordTypeInfosByName.get('Account Instruction').recordTypeId;
            
            String Accname=EncodingUtil.urlEncode(acc.Name,'UTF-8');
            return new PageReference('/'+prefix+'/e?'+accountNameID+'='+accname+'&'+accountIDLookUP+'='+parentId+'&RecordType='+recordtypeId+'&retURL='+parentId+'&nooverride=1');
        }
    }
    
}