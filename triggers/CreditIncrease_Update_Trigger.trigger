/**
* @author: Pathra S
* @version 2016-12-19
*/
/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                Description
* 2016-12-19   Pathra S              Created
* =============================================================================
*/
trigger CreditIncrease_Update_Trigger on Apttus_Proposal__Proposal__c (after insert,after update) {
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
        for(Apttus_Proposal__Proposal__c proposal : [select id,OwnerId,Owner.Name,APTS_Amount__c,APTS_Card_Type__c,APTS_Authorization_Transaction__c,APTS_Card_Expiration_Date__c,APTS_Authorization_Number__c,APTS_Credit_Card_Token__c,Apttus_Proposal__Account__r.Customer_Group__c,Apttus_Proposal__Account__r.Credit_Risk_Category__c,Apttus_Proposal__Approval_Stage__c,APTS_Send_NACI_Form__c,APTS_Sold_To_SAP_Account_Number__c,Apttus_Proposal__Account__r.SAPAccountNumber__c,Apttus_Proposal__Account__r.fax,Apttus_Proposal__Account__r.Website,APTS_Assent_Name_of_Rep__r.Name,APTS_PaymentGateway_URL__c,Name,APTS_Quote_Value__c,Apttus_Proposal__Account__r.Name,Apttus_Proposal__Amount__c,APTS_One_Time_Ship_To__c ,APTS_Order_Confirmation_Contact__c,APTS_Assent_Customer_Name__c,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact_Email__c,APTS_Payment_Option__c,Apttus_Proposal__Account__r.billingcity,Apttus_Proposal__Account__r.billingstreet,Apttus_Proposal__Account__r.billingstate,Apttus_Proposal__Account__r.billingcountry,Apttus_Proposal__Account__r.Phone,Apttus_Proposal__Account__r.billingPostalCode from Apttus_Proposal__Proposal__c where Id IN :trigger.new]){
           
            System.debug('PROPOSAL credit:'+proposal);
            String urlData = encryptData.creditIncreaseEncryption(proposal);
            string ccurl=PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;
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
        system.debug('exception...'+e.getMessage()+e.getLineNumber());
    }
}