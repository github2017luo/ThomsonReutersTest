/**********************************
Class Name: GenericTestutility
Purpose: Generic utility class to get Account, Contact and Cases.
Author:Manish/Karthi
Date Created:11/05/2017
Date Updated:Version0
***********************************/
@IsTest
public class ESC_GenericTestutility{
     
     public static Account testAccountUtil(String name, String accountNumber,String phone) {    
         Account objAccount= new Account();
         objAccount.Name= name;
         objAccount.AccountNumber= accountNumber;
         objAccount.Phone= phone;
         return objAccount;
     }
    
     public  static Contact testContactUtil(Id accountId,String  lastName,String email) {
         Contact objContact= New Contact();
         objContact.accountId = accountId;
         objContact.lastName= lastName;
         objContact.email =email ;
         return objContact;
     }
     
     public  static Contact testContactUtil(Id accountId,String  lastName,String firstName, String email) {
         Contact objContact= New Contact();
         objContact.accountId = accountId;
         objContact.firstName= firstName;
         objContact.lastName= lastName;
         objContact.email =email ;
         return objContact;
     }
 
     public static Case testCaseUtil(Id contactId,Id accountId,String  status) {
         Case objCase= New Case();
         objCase.accountId = accountId;
         objCase.contactId=contactId;
         objCase.status = status  ;
         return objCase;
     }
     public static ESC_Special_Instruction__c testSIUtil(Id accountId ,Id contactId,String status){
         ESC_Special_Instruction__c si = new ESC_Special_Instruction__c();
         si.ESC_Account__c = accountId;
         si.ESC_Contact__c=contactId;
         si.ESC_Status__c = status;
         return si;
     }
     public static ESC_Case_Special_Instruction__c testCaSIUtil(Id siId,Id caseid){
         ESC_Case_Special_Instruction__c caSI = new ESC_Case_Special_Instruction__c();
         caSI.ESC_Special_Instruction__c=siId;
         caSI.ESC_Case__c = caseid;
         return caSI;
     }
     public static ESC_Contact_Special_Instruction__c testConSIUtil(Id siId,Id conid){
         ESC_Contact_Special_Instruction__c conSI = new ESC_Contact_Special_Instruction__c();
         conSI.ESC_Special_Instruction__c=siId;
         conSI.ESC_Contact__c = conid;
         return conSI;
     }
     public static ESC_Account_Special_Instruction__c testAccSIUtil(Id siId,Id accid){
         ESC_Account_Special_Instruction__c accSI = new ESC_Account_Special_Instruction__c();
         accSI.ESC_Special_Instruction__c=siId;
         accSI.ESC_Account__c = accid;
         return accSI;
     }
}