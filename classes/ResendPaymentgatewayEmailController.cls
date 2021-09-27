/*
===============================================================================
Resend Email for Autopayment and creditIncrease
===============================================================================

PURPOSE: Resend Email
COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-05-03     Pathra                 Created                                          
===============================================================================
*/

public without sharing class ResendPaymentgatewayEmailController{

    public Apttus_Proposal__Proposal__c oQuote {get;set;} 
    public Apttus_Config2__Order__c oOrder {get;set;} 
    OrgWideEmailAddress owea;
  
    public ResendPaymentgatewayEmailController(ApexPages.StandardController oController) {
        try{
             if(Apttus_Proposal__Proposal__c.sObjectType.getDescribe().isAccessible() && Apttus_Config2__Order__c.sObjectType.getDescribe().isAccessible() ){
            oQuote = (Apttus_Proposal__Proposal__c) oController.getRecord();
            oQuote = [select id,OwnerId,Owner.Name,Owner.Email,Apttus_Proposal__Account__r.name,APTS_Amount__c,APTS_Order_Confirmation_Contact_Name__c,CreditincreaseEmailButton__c,APTS_SSD_Sold_To__c,APTS_SSD_Sold_To__r.name,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_Card_Type__c,APTS_Authorization_Transaction__c,APTS_Card_Expiration_Date__c,APTS_Authorization_Number__c,APTS_Credit_Card_Token__c,Apttus_Proposal__Account__r.Customer_Group__c,Apttus_Proposal__Account__r.Credit_Risk_Category__c,Apttus_Proposal__Approval_Stage__c,APTS_Send_NACI_Form__c,APTS_Sold_To_SAP_Account_Number__c,Apttus_Proposal__Account__r.fax,Apttus_Proposal__Account__r.Website,APTS_Assent_Name_of_Rep__r.Name,APTS_PaymentGateway_URL__c,Name,APTS_Quote_Value__c,Apttus_Proposal__Amount__c,APTS_One_Time_Ship_To__c ,APTS_Order_Confirmation_Contact__c,APTS_Assent_Customer_Name__c,APTS_Order_Confirmation_Contact__r.name,APTS_Order_Confirmation_Contact__r.email,APTS_Payment_Option__c,Apttus_Proposal__Account__r.billingcity,Apttus_Proposal__Account__r.billingstreet,Apttus_Proposal__Account__r.billingstate,Apttus_Proposal__Account__r.billingcountry,Apttus_Proposal__Account__r.Phone,Apttus_Proposal__Account__r.billingPostalCode from Apttus_Proposal__Proposal__c where Id =:oQuote.Id];
            if(([select id,name,AutopaymentEmailButton__c,paymenturl__c,Apttus_QPConfig__ProposalId__c from Apttus_Config2__Order__c where Apttus_QPConfig__ProposalId__c =:oQuote.Id]).size()!=0)
            oOrder = [select id,name,OwnerId,AutopaymentEmailButton__c,paymenturl__c,Apttus_QPConfig__ProposalId__c,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c from Apttus_Config2__Order__c where Apttus_QPConfig__ProposalId__c =:oQuote.Id];
            system.debug(oOrder);
             //Get Organization Wide Address
             }
            owea = [select Id from OrgWideEmailAddress where DisplayName = 'Thomson Reuters(no-reply)'];
        }
        catch(Exception e){
        system.debug('exception...'+e.getMessage()+e.getLineNumber());
        }
    }
    public void AutoPaymentEmail(){
     try{
         List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
         if(EmailTemplate.sObjectType.getDescribe().isAccessible()){
            EmailTemplate templateId = [Select id,Body,HtmlValue,subject from EmailTemplate where name = 'APTS_PaymentGateway_Template_VF_French'];
                   Messaging.SingleEmailMessage message =Messaging.renderStoredEmailTemplate(templateId.id ,oOrder.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c,oOrder.id);
                   system.debug('@@@'+oQuote.APTS_Order_Confirmation_Contact__r.email);
                   // message.setToAddresses(new String[] {'pathra.selvapandian@tcs.com'});
                   //Set From Address
                    //if(UserInfo.getUserId() != oOrder.OwnerId)
                        message.setOrgWideEmailAddressId(owea.Id);
                    messages.add(message);
                    Messaging.sendEmail(messages);
                    }
        }
        catch(Exception e){
        system.debug('exception...'+e.getMessage()+e.getLineNumber());
        }
    }
    
    public void CreditIncreaseEmail(){
    try{
         List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
          if(EmailTemplate.sObjectType.getDescribe().isAccessible()){
        EmailTemplate templateId = [Select id,Body,HtmlValue,subject from EmailTemplate where name = 'APTS NACI Form Template French'];
                    Messaging.SingleEmailMessage message =Messaging.renderStoredEmailTemplate(templateId.id ,oQuote.APTS_Order_Confirmation_Contact__c,oQuote.id);
                    //Set From Address
                    //if(UserInfo.getUserId() != oOrder.OwnerId)
                        message.setOrgWideEmailAddressId(owea.Id);
                    messages.add(message);
                    System.debug('%%%%'+message);
                    Messaging.sendEmail(messages);
                    }
        }
        catch(Exception e){
        system.debug('exception...'+e.getMessage()+e.getLineNumber());
        }
    }
}