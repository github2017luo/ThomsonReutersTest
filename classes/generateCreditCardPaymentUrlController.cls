/*
===============================================================================
Generate Encrypted generateCreditCardPaymentlink
===============================================================================

PURPOSE: Generate CreditCard Link
COMMENTS: 

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2016-11-25     Pathra                 Created                                          
===============================================================================
*/

public without sharing class generateCreditCardPaymentUrlController{

    public Apttus_Proposal__Proposal__c oQuote {get;set;}    
    public string AuthorizationNumber ;    
    public string TokenizationNumber;    
    
    public string gatewayURL {get;set;}
    public GenerateCreditCardPaymentUrlController(ApexPages.StandardController oController) {
        try{
            oQuote = (Apttus_Proposal__Proposal__c) oController.getRecord();
            WebServiceSettings__c pgWebServiceSettings = AppUtil.getWebServiceSettings('Payment Credit Card');  
            //oQuote = [select id,Name,APTS_Quote_Value__c,Apttus_Proposal__Account__r.SAPAccountNumber__c,Apttus_Proposal__Account__r.Name,APTS_Sold_To_SAP_Account_Number__c,Apttus_Proposal__Account__r.Account_Number__c,Apttus_Proposal__Amount__c,APTS_One_Time_Ship_To__c ,APTS_Assent_Customer_Name__c,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact_Email__c,APTS_Payment_Option__c,Apttus_Proposal__Account__r.billingcity,Apttus_Proposal__Account__r.billingstreet,Apttus_Proposal__Account__r.billingstate,Apttus_Proposal__Account__r.billingcountry,Apttus_Proposal__Account__r.Phone,Apttus_Proposal__Account__r.billingPostalCode from Apttus_Proposal__Proposal__c where Id =:oQuote.Id];
            oQuote = [Select Id, 
                     Name,
                     recordType.Name,
                     Payment_Status__c,
                     APTS_Proposal_Business_Unit__c, 
                     APTS_Order_Confirmation_Contact__r.email,
                     APTS_Order_Confirmation_Contact__r.Name,
                     APTS_Order_Confirmation_Contact__c,
                     Apttus_QPConfig__ConfigurationFinalizedDate__c,
                     //APTS_Customer_Name__c,
                     //APTS_Customer_Email__c,
                     APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                     APTS_SSD_Sold_To__r.Number_Street__c,
                     APTS_SSD_Sold_To__r.Name,
                     APTS_SSD_Sold_To__r.State__c,
                     APTS_SSD_Sold_To__r.Country__c,
                     APTS_SSD_Sold_To__r.City__c,
                     APTS_SSD_Sold_To__r.LCRM_Phone__c,
                     APTS_SSD_Sold_To__r.Postal_Code__c,
                     APTS_Quote_Value__c,
                     Apttus_Proposal__Account__r.SAPAccountNumber__c,
                     Apttus_Proposal__Account__r.Name,
                     APTS_Sold_To_SAP_Account_Number__c,
                     Apttus_Proposal__Amount__c,
                     APTS_One_Time_Ship_To__c ,
                     APTS_Assent_Customer_Name__c,
                     APTS_Order_Confirmation_Contact_Name__c,
                     APTS_Order_Confirmation_Contact_Email__c,
                     APTS_Payment_Option__c,
                     Apttus_Proposal__Account__r.billingcity,
                     Apttus_Proposal__Account__r.billingstreet,
                     Apttus_Proposal__Account__r.billingstate,
                     Apttus_Proposal__Account__r.billingcountry,
                     LanguageCode__c,
                     Apttus_Proposal__Account__r.Phone,
                     Apttus_Proposal__Account__r.billingPostalCode,
                     CurrencyISOCode
                     from Apttus_Proposal__Proposal__c where Id =:oQuote.Id];
            
            PaymentgatewayUtil encryptData = new PaymentgatewayUtil();
            if (oQuote.Languagecode__c == 'fr_CA' && oQuote.APTS_Proposal_Business_Unit__c == 'Canada') {
                    String urlData1= encryptData.creditcard(oQuote);
                    String urlData = EncodingUtil.urlEncode(urlData1, 'UTF-8');
                    gatewayURL = PGWebServiceSettings.Endpoint__c+'?lan=1&Paydet='+urlData;
                    System.debug('@@CARS'+gatewayURL);
            } else {
                String urlData1= encryptData.creditcard(oQuote);
                String urlData = EncodingUtil.urlEncode(urlData1, 'UTF-8');
                gatewayURL = PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData;
                System.debug('@@@'+gatewayURL);
            }
            
        } catch(Exception e) {
            system.debug('exception...'+e.getMessage()+e.getLineNumber());
        }
    }
}