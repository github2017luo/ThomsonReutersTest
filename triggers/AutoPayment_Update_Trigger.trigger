/**
 * @author: Pathra S
 * @version 2016-11-23
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2016-11-23   Pathra S              Created
 * =============================================================================
 */
trigger AutoPayment_Update_Trigger on Apttus_Proposal__Proposal__c (after insert,after update) {
    
  Boolean isBulkLoad=false;
    Boolean isTestrun=false;
    //Added by Tejaswi (GLI-OC) to deactive triggers during data load

    if(!Test.isRunningTest()){
        isTestrun=false;
        GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());        
        if(loadValues!=null && (loadValues.APTS_Disable_Triggers__c)) isBulkLoad=true;
    }else {
    
        isTestrun=true;
    
    }
    //End of trigger Deactivate logic
    
     if((isTestrun || (isTestrun== false && isBulkLoad ==false)))
     {
    try{
        list<id> ids=new list<id>();
        set<id> updatedId = new set<id>();
        set<id> insertedId = new set<id>();
        
        list<Apttus_Config2__Order__c> updateorder = new list<Apttus_Config2__Order__c>();
        for(Apttus_Proposal__Proposal__c prop:trigger.new){
        ids.add(prop.id);
        }
        Map<id,Apttus_Config2__Order__c> order=new Map<id,Apttus_Config2__Order__c>();
        List<Apttus_Config2__Order__c> lorder=[select id,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,AutopaymentEmailButton__c,name,paymenturl__c,Apttus_QPConfig__ProposalId__c from Apttus_Config2__Order__c where Apttus_QPConfig__ProposalId__c in :ids];
        for(Apttus_Config2__Order__c ord:lorder){
        order.put(ord.Apttus_QPConfig__ProposalId__c,ord);
        }
        system.debug('map'+order);
        //fetch customsettings 
        WebServiceSettings__c PGWebServiceSettings = new WebServiceSettings__c();
        if(Test.isRunningTest()){
        PGWebServiceSettings.Endpoint__c='www.google.com';
        }else{
        PGWebServiceSettings = AppUtil.getWebServiceSettings('Payment AutoCharge'); 
        }  
         system.debug('PGWebServiceSettings ...'+PGWebServiceSettings );
         List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
         PaymentgatewayUtil encryptData = new PaymentgatewayUtil();
         if(trigger.isInsert){
             for(Apttus_Proposal__Proposal__c proposal:trigger.new){
                    if((proposal.APTS_Payment_Option__c == 'Auto Charge') || (proposal.APTS_Payment_Option__c == 'Auto EFT/Auto Charge')||(proposal.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge')){   
                         insertedId.add(proposal.Id);
                   }
              }
             if(insertedId.size()>0)
             for(Apttus_Proposal__Proposal__c proposal : [select id,APTS_SSD_Sold_To__r.Name,APTS_Proposal_Business_Unit__c,APTS_Order_Confirmation_Contact__r.name,APTS_Order_Confirmation_Contact__r.email,OwnerId,Owner.Name,APTS_Sold_To_SAP_Account_Number__c,APTS_Assent_Name_of_Rep__r.Name,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,Apttus_Proposal__Account__r.Name,Name,APTS_Quote_Value__c,APTS_One_Time_Ship_To__c ,APTS_Assent_Customer_Name__c,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact_Email__c,APTS_Payment_Option__c,APTS_SSD_Sold_To__r.City__c,APTS_SSD_Sold_To__r.Number_Street__c,APTS_SSD_Sold_To__r.State__c,APTS_SSD_Sold_To__r.Country__c,APTS_SSD_Sold_To__r.LCRM_Phone__c,APTS_SSD_Sold_To__r.Postal_Code__c,Languagecode__c,currencyISOCode  from Apttus_Proposal__Proposal__c where Id IN :insertedId]){
                    String urlData = encryptData.encryption(proposal);
                    string ccurl=isFrenchTemplate(proposal.Languagecode__c ,PGWebServiceSettings.Endpoint__c,proposal.APTS_Proposal_Business_Unit__c) + urlData ;
                        //string ccurl=PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;
                        system.debug('proposal'+proposal);
                       Apttus_Config2__Order__c temp = order.get(proposal.id); 
                       temp.paymenturl__c=ccurl;
                       temp.AutopaymentEmailButton__c = true;
                        System.debug('insert temp'+temp);
                       updateorder.add(temp);
                
             }
         }else{
              for(Apttus_Proposal__Proposal__c proposal:trigger.new){
                   Apttus_Proposal__Proposal__c oldProposal = Trigger.oldMap.get(proposal.Id);
                   if((oldProposal.APTS_Payment_Option__c!=proposal.APTS_Payment_Option__c  )){
                       if((proposal.APTS_Payment_Option__c == 'Auto Charge') || (proposal.APTS_Payment_Option__c == 'Auto EFT/Auto Charge')||(proposal.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge')){                                             
                      
                           updatedId.add(proposal.Id);
                           }
                   }
              }
              if(updatedId.size()>0)
              for(Apttus_Proposal__Proposal__c proposal : [select id,APTS_Proposal_Business_Unit__c,OwnerId,APTS_SSD_Sold_To__r.Name,Owner.Name,APTS_Sold_To_SAP_Account_Number__c,APTS_Order_Confirmation_Contact__r.name,APTS_Order_Confirmation_Contact__r.email,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_Assent_Name_of_Rep__r.Name,APTS_PaymentGateway_URL__c,Name,APTS_Quote_Value__c,Apttus_Proposal__Account__r.Name,Apttus_Proposal__Amount__c,APTS_One_Time_Ship_To__c ,APTS_Order_Confirmation_Contact__c,APTS_Assent_Customer_Name__c,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact_Email__c,APTS_Payment_Option__c,APTS_SSD_Sold_To__r.City__c,APTS_SSD_Sold_To__r.Number_Street__c,APTS_SSD_Sold_To__r.State__c,APTS_SSD_Sold_To__r.Country__c,APTS_SSD_Sold_To__r.LCRM_Phone__c,APTS_SSD_Sold_To__r.Postal_Code__c,Languagecode__c,currencyISOCode  from Apttus_Proposal__Proposal__c where Id IN :updatedId]){
                  
                  String urlData = encryptData.encryption(proposal);
                      string ccurl=isFrenchTemplate(proposal.Languagecode__c ,PGWebServiceSettings.Endpoint__c,proposal.APTS_Proposal_Business_Unit__c) + urlData ;
                      // string ccurl=PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;
                       Apttus_Config2__Order__c temp = order.get(proposal.id); 
                       temp.paymenturl__c=ccurl;
                       temp.AutopaymentEmailButton__c = true;
                       System.debug('update temp'+temp);
                       updateorder.add(temp);
                    
                
            }
         }
         update updateorder;
         System.debug('url++3'+updateorder);
     }
     catch(exception e){
         system.debug('exception...'+e.getMessage()+e.getLineNumber());
     }
     
     //Credit Increase
     
    set<id> creditIncrease = new set<id>();
     if(trigger.isInsert){
         for(Apttus_Proposal__Proposal__c proposal:trigger.new){
            if(proposal.APTS_Sold_To_SAP_Account_Number__c !=null ){
                creditIncrease.add(proposal.id);
            }
      }
    }else{
        for(Apttus_Proposal__Proposal__c proposal:trigger.new){
             Apttus_Proposal__Proposal__c oldProposal = Trigger.oldMap.get(proposal.Id);
            if((oldProposal.APTS_Sold_To_SAP_Account_Number__c!=proposal.APTS_Sold_To_SAP_Account_Number__c)){
                creditIncrease.add(proposal.id);
            }
        }
    
    }
    if(creditIncrease.size()>0){
        list<Apttus_Proposal__Proposal__c> lproposal = new list<Apttus_Proposal__Proposal__c>();
        WebServiceSettings__c PGWebServiceSettings = new WebServiceSettings__c();
         PaymentgatewayUtil encryptData = new PaymentgatewayUtil();
        if(!Test.isRunningTest())
            PGWebServiceSettings = AppUtil.getWebServiceSettings('PaymentCreditIncrease');
        else {
            PGWebServiceSettings.Name = 'PaymentCreditIncrease';
            PGWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';    
        }
        try{
            for(Apttus_Proposal__Proposal__c proposal : [select id,APTS_Proposal_Business_Unit__c,OwnerId,APTS_SSD_Sold_To__r.Name,Apttus_Proposal__Account__r.billingstreet,Apttus_Proposal__Account__r.billingcity,Apttus_Proposal__Account__r.billingstate,Apttus_Proposal__Account__r.billingcountry,Apttus_Proposal__Account__r.phone,Apttus_Proposal__Account__r.billingPostalCode,APTS_SSD_Sold_To__c,Owner.Name,APTS_Amount__c,APTS_Card_Type__c,APTS_Authorization_Transaction__c,APTS_Card_Expiration_Date__c,APTS_Authorization_Number__c,APTS_Credit_Card_Token__c,APTS_SSD_Sold_To__r.LCRM_Customer_Group__c,APTS_SSD_Sold_To__r.LCRM_Credit_Risk_Category__c,Apttus_Proposal__Approval_Stage__c,APTS_Send_NACI_Form__c,APTS_Sold_To_SAP_Account_Number__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Fax__c,APTS_SSD_Sold_To__r.LCRM_Website__c,APTS_Assent_Name_of_Rep__r.Name,APTS_PaymentGateway_URL__c,Name,APTS_Quote_Value__c,Apttus_Proposal__Account__r.Name,Apttus_Proposal__Amount__c,APTS_One_Time_Ship_To__c ,APTS_Order_Confirmation_Contact__c,APTS_Assent_Customer_Name__c,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact_Email__c,APTS_Payment_Option__c,APTS_SSD_Sold_To__r.City__c,APTS_SSD_Sold_To__r.Number_Street__c,APTS_SSD_Sold_To__r.State__c,APTS_SSD_Sold_To__r.Country__c,APTS_SSD_Sold_To__r.LCRM_Phone__c,APTS_SSD_Sold_To__r.Postal_Code__c,Languagecode__c,currencyISOCode  from Apttus_Proposal__Proposal__c where Id IN :creditIncrease]){
               
                System.debug('PROPOSAL credit:'+proposal);
                String urlData = encryptData.creditIncreaseEncryption(proposal);
                string ccurl=isFrenchTemplate(proposal.Languagecode__c ,PGWebServiceSettings.Endpoint__c,proposal.APTS_Proposal_Business_Unit__c) + urlData ;
                //string ccurl=PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;
                if(ccurl!=proposal.APTS_PaymentGateway_URL__c){
                    system.debug('Inside if');
                    proposal.APTS_PaymentGateway_URL__c=ccurl;
                    System.debug(LoggingLevel.INFO,'URL'+proposal.APTS_PaymentGateway_URL__c);
                    lproposal.add(proposal);
            }
        }
        update lproposal;
        }
        catch(exception e){
            system.debug('exception...'+e.getMessage()+e.getLineNumber()+'track'+e.getStackTraceString());
        }
    }
    
    }
    private String isFrenchTemplate(String lan,String ccurl,String pbu){
    String retccUrl='';
        if(lan=='fr_CA' && pbu=='Canada'){
             retccUrl=ccurl + '?lan=1&Paydet=' ;   
        }
        else{
            retccUrl=ccurl +'?Paydet=';
            
        }
        return retccUrl;
    }
}