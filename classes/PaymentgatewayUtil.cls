/*
===============================================================================
* Contains methods for  all Payment Trigger and  generate credit card token class
* Generate the encrypted customfield for Paymentgateway Url
===============================================================================

PURPOSE: Generate the encrypted customfield for Paymentgateway Url 

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2016-11-30     Pathra                  Created                                          
===============================================================================
*/

public class PaymentgatewayUtil {
    
    public String encryption(Apttus_Proposal__Proposal__c proposals){
        String urlData;
        //Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');
        //String key = EncodingUtil.base64Encode(cryptoKey );
        WebServiceSettings__c enterprisewsdl = AppUtil.getWebServiceSettings('EnterpriseWSDL');
        WebServiceSettings__c statusPostback = AppUtil.getWebServiceSettings('StatusPostbackLocation');
        Blob cryptoKey = EncodingUtil.base64Decode('5r7owaVHWQnc9P0ZWALBbQ==');
        Apttus_Proposal__Proposal__c proposal = checknull(proposals);
        //system.debug('/.,.,'+cryptokey);
        //string detail = 'CustomerName='+proposal.APTS_Assent_Customer_Name__c+'|'+'CustomerAccount='+proposal.APTS_Order_Confirmation_Contact_Name__c+'|'+'CustomerEmail='+proposal.APTS_Order_Confirmation_Contact_Email__c;
        //String detail = 'QuoteNumber=' + proposal.Name + '|' + 'PaymentCurrency=USD' + '|' + 'AccountNumber=' + proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c+ '|' + 'EmailAddress=' + proposal.APTS_Order_Confirmation_Contact__r.email+ '|' + 'PaymentAmount=' + proposal.APTS_Quote_Value__c.setScale(2) + '|' + 'CustomerName=' + proposal.APTS_SSD_Sold_To__r.Name + '|' + 'ContactName=' + proposal.APTS_Order_Confirmation_Contact__r.name+ '|' + 'TRPaymentCompanyId=WEST'+'|' + 'CustomerAddress=' + proposal.APTS_SSD_Sold_To__r.Number_Street__c+ '|' + 'City=' + proposal.APTS_SSD_Sold_To__r.Number_Street__c + '|' + 'State=' + proposal.APTS_SSD_Sold_To__r.State__c+ '|' + 'Country=' + proposal.APTS_SSD_Sold_To__r.Country__c+ '|' + 'Telephone=' + proposal.APTS_SSD_Sold_To__r.LCRM_Phone__c+ '|' + 'PostalCode=' + proposal.APTS_SSD_Sold_To__r.Postal_Code__c + '|BusinessUnitCode=SF04'+'|Id='+proposal.Id+'|TermsAndConditions='+proposal.APTS_Payment_Option__c+'|EnterpriseWsdlLocation='+enterprisewsdl.Endpoint__c+'|StatusPostBackWsdlLocation='+statusPostback.Endpoint__c;
        String detail = 'QuoteNumber=' + proposal.Name + '|' + 'AccountNumber=' + proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c+ '|' + 'EmailAddress=' + proposal.APTS_Order_Confirmation_Contact__r.email+ '|' + 'PaymentAmount=' + proposal.APTS_Quote_Value__c.setScale(2) + '|' + 'CustomerName=' + proposal.APTS_SSD_Sold_To__r.Name + '|' + 'ContactName=' + proposal.APTS_Order_Confirmation_Contact__r.name+ '|' + 'CustomerAddress=' + proposal.APTS_SSD_Sold_To__r.Number_Street__c+ '|' + 'City=' + proposal.APTS_SSD_Sold_To__r.City__c + '|' + 'State=' + proposal.APTS_SSD_Sold_To__r.State__c+ '|' + 'Country=' + proposal.APTS_SSD_Sold_To__r.Country__c+ '|' + 'Telephone=' + proposal.APTS_SSD_Sold_To__r.LCRM_Phone__c+ '|' + 'PostalCode=' + proposal.APTS_SSD_Sold_To__r.Postal_Code__c +'|Id='+proposal.Id+'|TermsAndConditions='+proposal.APTS_Payment_Option__c+'|EnterpriseWsdlLocation='+enterprisewsdl.Endpoint__c+'|StatusPostBackWsdlLocation='+statusPostback.Endpoint__c;
        System.debug('DETAIL:'+detail);
        if(proposal.APTS_Proposal_Business_Unit__c == 'Canada'){
            detail = detail + '|'+ 'PaymentCurrency=CAD' + '|' + 'TRPaymentCompanyId=CARS'+ '|BusinessUnitCode=SF09';
        }else if(proposal.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US'){
            detail = detail + '|'+ 'PaymentCurrency=USD' + '|' + 'TRPaymentCompanyId=TA78'+ '|BusinessUnitCode=SF10';
        } 
        // Start: Doc-4243     
        else if (proposal.APTS_Proposal_Business_Unit__c == Label.PBUCorpOneOTCUK) {        
            detail = detail + '|'+ 'PaymentCurrency='+String.valueOf(proposal.CurrencyIsoCode) + '|' +      
                    'TRPaymentCompanyId='+Label.SALESORGONEOTCUK + '|BusinessUnitCode='+Label.APTS_BusinessUnitCode_UK;     
            system.debug('###### detail UK'+detail );       
        }
        //End DOC-4243
        //DOC-5545-Added for Tax
        else if(proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
            detail = detail + '|'+ 'PaymentCurrency=USD' + '|' + 'TRPaymentCompanyId=S100'+ '|BusinessUnitCode=SF12'+ '|ContactFirstName=' + proposal.APTS_Order_Confirmation_Contact__r.FirstName+ '|ContactLastName=' + proposal.APTS_Order_Confirmation_Contact__r.LastName;         
        }       
        //DOC-5545-Added for Tax
        else{
            detail = detail + '|'+ 'PaymentCurrency=USD' + '|' + 'TRPaymentCompanyId=WEST' + '|BusinessUnitCode=SF04';
        }
        System.debug('DETAIL:'+detail);        
        Blob data = Blob.valueOf(detail);
        blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
        String b64Data = EncodingUtil.base64Encode(encryptedData);
        return b64Data;
    }
    
    public String creditcard(Apttus_Proposal__Proposal__c proposals){
        String urlData;
        WebServiceSettings__c enterprisewsdl = AppUtil.getWebServiceSettings('EnterpriseWSDL');
        WebServiceSettings__c postback = AppUtil.getWebServiceSettings('PostbackLocation');
        WebServiceSettings__c statusPostback = AppUtil.getWebServiceSettings('StatusPostbackLocation');
        Blob cryptoKey = EncodingUtil.base64Decode('5r7owaVHWQnc9P0ZWALBbQ==');
        Apttus_Proposal__Proposal__c proposal = checknull(proposals);
        Decimal Amount;
        if(proposal.APTS_Quote_Value__c!=null){
            Amount = proposal.APTS_Quote_Value__c.setScale(2);
            Amount=Amount+(Amount*15/100);}
        else
            Amount=0;
        system.debug('@@@'+Amount);
        //system.debug('/.,.,'+cryptokey);
        //string detail = 'CustomerName='+proposal.APTS_Assent_Customer_Name__c+'|'+'CustomerAccount='+proposal.APTS_Order_Confirmation_Contact_Name__c+'|'+'CustomerEmail='+proposal.APTS_Order_Confirmation_Contact_Email__c;
        //String detail = 'QuoteNumber=' + proposal.Name + '|' + 'PaymentCurrency=USD' + '|' + 'AccountNumber=' + proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c+ '|' + 'EmailAddress=' + proposal.APTS_Order_Confirmation_Contact__r.email+ '|' + 'PaymentAmount=' + Amount.setScale(2) + '|' + 'CustomerName=' + proposal.Apttus_Proposal__Account__r.Name + '|' + 'ContactName=' + proposal.APTS_Order_Confirmation_Contact__r.name+ '|' + 'TRPaymentCompanyId=WEST'+'|' + 'CustomerAddress=' + proposal.Apttus_Proposal__Account__r.billingstreet+ '|' + 'City=' + proposal.Apttus_Proposal__Account__r.billingcity + '|' + 'State=' + proposal.Apttus_Proposal__Account__r.billingstate+ '|' + 'Country=' + proposal.Apttus_Proposal__Account__r.billingcountry+ '|' + 'Telephone=' + proposal.Apttus_Proposal__Account__r.phone+ '|' + 'PostalCode=' + proposal.Apttus_Proposal__Account__r.billingPostalCode + '|BusinessUnitCode=SF04'+'|Id='+proposal.Id+'|TermsAndConditions='+proposal.APTS_Payment_Option__c+'|EnterpriseWsdlLocation='+enterprisewsdl.Endpoint__c+'|CCTokenPostBackWsdlLocation='+postback.Endpoint__c;
        String detail = 'QuoteNumber=' + proposal.Name + '|' + 'AccountNumber=' + proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c+ '|' + 'EmailAddress=' + proposal.APTS_Order_Confirmation_Contact__r.email+ '|' + 'PaymentAmount=' + Amount.setScale(2) + '|' + 'CustomerName=' + proposal.Apttus_Proposal__Account__r.Name + '|' + 'ContactName=' + proposal.APTS_Order_Confirmation_Contact__r.name+ '|' + 'CustomerAddress=' + proposal.Apttus_Proposal__Account__r.billingstreet+ '|' + 'City=' + proposal.Apttus_Proposal__Account__r.billingcity + '|' + 'State=' + proposal.Apttus_Proposal__Account__r.billingstate+ '|' + 'Country=' + proposal.Apttus_Proposal__Account__r.billingcountry+ '|' + 'Telephone=' + proposal.Apttus_Proposal__Account__r.phone+ '|' + 'PostalCode=' + proposal.Apttus_Proposal__Account__r.billingPostalCode +'|Id='+proposal.Id+'|TermsAndConditions='+proposal.APTS_Payment_Option__c+'|EnterpriseWsdlLocation='+enterprisewsdl.Endpoint__c+'|CCTokenPostBackWsdlLocation='+postback.Endpoint__c+'|StatusPostBackWsdlLocation='+statusPostback.Endpoint__c;
        System.debug('DETAIL:'+detail);
        if(proposal.APTS_Proposal_Business_Unit__c == 'Canada'){
            detail = detail+ '|' + 'PaymentCurrency=CAD' + '|' + 'TRPaymentCompanyId=CARS'+ '|BusinessUnitCode=SF09';
        }else if(proposal.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US'){
            System.debug('#################'+proposal.APTS_Proposal_Business_Unit__c);
            detail = detail+ '|' + 'PaymentCurrency=USD' + '|' + 'TRPaymentCompanyId=TA78'+ '|BusinessUnitCode=SF10';
        }
        // Start: Doc-4243     
        else if (proposal.APTS_Proposal_Business_Unit__c == Label.PBUCorpOneOTCUK) {        
            detail = detail + '|'+ 'PaymentCurrency='+String.valueOf(proposal.CurrencyIsoCode) + '|' +      
                    'TRPaymentCompanyId='+Label.SALESORGONEOTCUK + '|BusinessUnitCode='+Label.APTS_BusinessUnitCode_UK;     
            system.debug('###### detail UK'+detail );       
        }       
        //End DOC-4243
        //DOC-5545-Added for Tax
        else if(proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
            detail = detail + '|'+ 'PaymentCurrency=USD' + '|' + 'TRPaymentCompanyId=S100'+ '|BusinessUnitCode=SF12';
        }
        //DOC-5545-Added for Tax
        else{
            detail = detail+ '|' + 'PaymentCurrency=USD' + '|' + 'TRPaymentCompanyId=WEST' + '|BusinessUnitCode=SF04';
        }
        System.debug('DETAIL:'+detail);
        Blob data = Blob.valueOf(detail);
        blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
        String b64Data = EncodingUtil.base64Encode(encryptedData);
        return b64Data;
    }
    
    //DOC-5624 Added by Nandha
    public String directdebit(Apttus_Proposal__Proposal__c proposals){
        String urlData;
        WebServiceSettings__c enterprisewsdl = AppUtil.getWebServiceSettings('EnterpriseWSDL');
        WebServiceSettings__c postback = AppUtil.getWebServiceSettings('DirectDebitPostbackLocation');
        WebServiceSettings__c statusPostback = AppUtil.getWebServiceSettings('StatusPostbackLocation');
        Blob cryptoKey = EncodingUtil.base64Decode('5r7owaVHWQnc9P0ZWALBbQ==');
        Apttus_Proposal__Proposal__c proposal = checknull(proposals);
        Decimal Amount;
        if(proposal.APTS_Quote_Value__c!=null){
            Amount = proposal.APTS_Quote_Value__c.setScale(2);
            Amount=Amount+(Amount*15/100);}
        else
            Amount=0;
        system.debug('@@@'+Amount);
        String detail = 'QuoteNumber=' + proposal.Name + '|' + 'AccountNumber=' + proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c+ '|' + 'EmailAddress=' + proposal.APTS_Order_Confirmation_Contact__r.email+ '|' + 'PaymentAmount=' + Amount.setScale(2) + '|' + 'CustomerName=' + proposal.Apttus_Proposal__Account__r.Name + '|' + 'ContactName=' + proposal.APTS_Order_Confirmation_Contact__r.name+ '|' + 'CustomerAddress=' + proposal.Apttus_Proposal__Account__r.billingstreet+ '|' + 'City=' + proposal.Apttus_Proposal__Account__r.billingcity + '|' + 'State=' + proposal.Apttus_Proposal__Account__r.billingstate+ '|' + 'Country=' + proposal.Apttus_Proposal__Account__r.billingcountry+ '|' + 'Telephone=' + proposal.Apttus_Proposal__Account__r.phone+ '|' + 'PostalCode=' + proposal.Apttus_Proposal__Account__r.billingPostalCode +'|Id='+proposal.Id+'|TermsAndConditions='+proposal.APTS_Payment_Option__c+ '|'+ 'PaymentCurrency=USD' + '|' + 'TRPaymentCompanyId=S100'+ '|BusinessUnitCode=SF12'+'|EnterpriseWsdlLocation='+enterprisewsdl.Endpoint__c+'|CCTokenPostBackWsdlLocation='+postback.Endpoint__c+'|StatusPostBackWsdlLocation='+statusPostback.Endpoint__c;
        System.debug('DETAIL:'+detail);
        Blob data = Blob.valueOf(detail);
        blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
        String b64Data = EncodingUtil.base64Encode(encryptedData);
        return b64Data;
    }
    
    public String creditIncreaseEncryption(Apttus_Proposal__Proposal__c proposals){
        String urlData;
        Blob cryptoKey = EncodingUtil.base64Decode('5r7owaVHWQnc9P0ZWALBbQ==');
        Apttus_Proposal__Proposal__c proposal = checknull(proposals);
        //system.debug('/.,.,'+cryptokey);
        String detail = 'QuoteNumber=' + proposal.Name + '|'+ 'SAPAccountNumber=' + proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c+ '|' + 'StreetAddress=' + proposal.Apttus_Proposal__Account__r.billingstreet+ '|' + 'City=' + proposal.Apttus_Proposal__Account__r.billingcity + '|' + 'State=' + proposal.Apttus_Proposal__Account__r.billingstate+ '|' + 'Country=' + proposal.Apttus_Proposal__Account__r.billingcountry+ '|' + 'Telephone=' + proposal.Apttus_Proposal__Account__r.phone+ '|' + 'Zip=' + proposal.Apttus_Proposal__Account__r.billingPostalCode + '|' + 'FullLegalName=' + proposal.Apttus_Proposal__Account__r.Name;
        //Start Doc:6332 Jinal Bhatt
    if(proposal.APTS_Proposal_Business_Unit__c == 'Canada'){
            detail = detail + '|'+ 'TRPaymentCompanyId=CARS'+ '|BusinessUnitCode=SF09';
    }  
        else if (proposal.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US') {
            detail = detail+ '|' + 'TRPaymentCompanyId=TA78'+ '|BusinessUnitCode='+Label.APTS_BusinessUnitCode_UK;
        } else if (proposal.APTS_Proposal_Business_Unit__c == Label.PBUCorpOneOTCUK) {
            detail =  detail + '|'+ 'TRPaymentCompanyId='+Label.SALESORGONEOTCUK + '|BusinessUnitCode='+Label.APTS_BusinessUnitCode_UK;
        } 
        else if (proposal.APTS_Proposal_Business_Unit__c == 'SCS' || proposal.APTS_Proposal_Business_Unit__c == 'Findlaw') {
            detail = detail+ '|' + 'TRPaymentCompanyId=WEST' + '|BusinessUnitCode=SF04';
        } 
        //End 6332
     else if (proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional') {
            detail =  detail + '|'+ 'ApplicantCurrency='+ String.valueOf(proposal.CurrencyIsoCode) +'|TransactionCurrency=' + String.valueOf(proposal.CurrencyIsoCode) +'|ChannelType=Apttus' +'|Amount=' + proposal.APTS_Quote_Value__c.setScale(2) + '|BusinessUnitCode=SF12' +'|TRPaymentCompanyId=S100';
        }   
    //End DOC-10089
        System.debug(LoggingLevel.INFO,'DETAIL:'+detail);
        Blob data = Blob.valueOf(detail);
        blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
        String b64Data = EncodingUtil.base64Encode(encryptedData);
        return b64Data;
    }
    
    //to check null values and make it empty
    public Apttus_Proposal__Proposal__c checknull(Apttus_Proposal__Proposal__c proposal){
        
        if(proposal.APTS_Assent_Customer_Name__c==null)
            proposal.APTS_Assent_Customer_Name__c='';
        
        //if(proposal.APTS_Order_Confirmation_Contact_Email__c==null)
        //proposal.APTS_Order_Confirmation_Contact_Email__c ='';
        
        //if(proposal.Apttus_Proposal__Account__r.billingstreet==null)
        //proposal.Apttus_Proposal__Account__r.billingstreet='';
        
        //if(proposal.Apttus_Proposal__Account__r.billingcity==null)
        //proposal.Apttus_Proposal__Account__r.billingcity='';
        
        //if(proposal.Apttus_Proposal__Account__r.billingstate==null)
        //proposal.Apttus_Proposal__Account__r.billingstate='';
        
        //if(proposal.Apttus_Proposal__Account__r.billingpostalcode==null)
        //proposal.Apttus_Proposal__Account__r.billingpostalcode='';
        
        //if(proposal.Apttus_Proposal__Account__r.billingCountry==null)
        //proposal.Apttus_Proposal__Account__r.billingCountry='';
        
        //if(proposal.Apttus_Proposal__Account__r.phone==null)
        //proposal.Apttus_Proposal__Account__r.phone='';
        
        if(proposal.APTS_Payment_Option__c==null)
            proposal.APTS_Payment_Option__c='';
        
        return proposal;
    }
    
}