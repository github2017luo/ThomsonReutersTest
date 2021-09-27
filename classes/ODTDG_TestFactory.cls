@istest(seeAllData=false)
public with sharing class ODTDG_TestFactory {
    private static final String ACCRECORDTYPENAME='GLI Account';
    private static final String ACCNAME='Test';
    private static final String SSDRECORDTYPENAME='LOTUS Source Systems';

/********************************************************************************************************
*  @description createAccount: this is the method to create test data for account creation 
*  @return Account : Return the account details 
*********************************************************************************************************/
    public static Account createAccount(){

        Id accRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCRECORDTYPENAME).getRecordTypeId();
        Account acc= APTS_TestDataFactory.createAccount(accName);
        acc.RecordTypeId=accRecordTypeId1;
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        acc.Customer_Type__c = 'Individual';
        acc.Fiscal_Year_End__c='05-May';
        acc.BU_Marketing_Segment__c='West-International Account';
        
        return acc;
    }

/********************************************************************************************************
*  @description createAccountSSD : this is the method to create test Account SSD record
*  @param acc : Taking account as input as MD relationsship 
*  @return Source_system_detail__c : Return SSD object 
*********************************************************************************************************/
    public static Source_system_detail__c createAccountSSD(Account acc){

        Id ssdRecordTypeId = Schema.SObjectType.Source_system_detail__c .getRecordTypeInfosByName().get(ssdRecordTypeName).getRecordTypeId();
        Source_system_detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(acc);
        accountSSD.RecordTypeId=ssdRecordTypeId;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        accountSSD.Source_System_Account_Number__c='123456';
        accountSSD.LCRM_Name_2__c='DEF';
        accountSSD.LCRM_Name_3__c='XYZ';
        accountSSD.Number_Street__c='Street5';
        accountSSD.LCRM_Street_2__c='Street2';
        accountSSD.LCRM_Street3__c='Street3';
        accountSSD.LCRM_Street4__c='Street4';
        accountSSD.City__c='TestCity';
        accountSSD.State__c='TestState';
        accountSSD.Country__c='testCountry';
        accountSSD.Postal_Code__c='12345';
        accountSSD.LCRM_Phone__c='9876547777';
        accountSSD.LCRM_Fax__c='8765432109';
        accountSSD.LCRM_PO_Box__c='PO-156';
        //insert accountSSD; 
        return accountSSD;

    }

/********************************************************************************************************
*  @description createDigitalBlacklisted : this is the method to create test Blacklisted record
*  @return Digital_Blacklist_or_CompetitorList__c : Return blacklisted object 
*********************************************************************************************************/
    public static Digital_Blacklist_or_CompetitorList__c createDigitalBlacklisted(){

        Digital_Blacklist_or_CompetitorList__c dbl = new Digital_Blacklist_or_CompetitorList__c();
        dbl.Email__c = 'abctestapr142021@blacklistedmail.com';
                        
        dbl.Email_Domains__c = 'blacklist';
        dbl.Status__c   = 'Blocked';    
        dbl.Type__c ='Blacklist';
        dbl.Reason__c ='Trial Abuser';

        return dbl;
    }
/********************************************************************************************************
*  @description createErrorCodes: this is the method to create test data for error codes 
*  @param ercode : This will accept the error code and create error code record 
*  @return Error_Codes__c : return the error code  
*********************************************************************************************************/
  /*  public static Error_Codes__c createErrorCodes(string ercode){
        Error_Codes__c err = new Error_Codes__c();
        err.Error_Status_Code__c = ercode;
        err.Error_Desc__c = 'Test Desc';
        err.Error_Type__c = 'Error';
        err.Name = 'ErrData'+erCode;
        return err;
    }
*/
/********************************************************************************************************
*  @description createErrorCodes: this is the method to create test data for error codes 
*  @param ercode : This will accept the error code and create error code record 
*  @return Error_Code__mdt : return the error code  
*********************************************************************************************************/
public static Error_Code__mdt createErrorCodesMetadata(string ercode){
    Error_Code__mdt err = new Error_Code__mdt();
    err.Error_Status_Code__c = ercode;
    err.Error_Description__c = 'Test Desc';
    err.Error_Type__c = 'Error';
    err.DeveloperName = erCode;

    return err;
}
    

/********************************************************************************************************
*  @description webservicesSettingData : this is the method to create webservices settings  
*  @param wsName : This will accept the ws name
*  @param wsendpoint : This will accept the end point  
*  @return WebServiceSettings__c : return the ws code  
*********************************************************************************************************/
    public static WebServiceSettings__c webservicesSettingData(string wsName, string wsendpoint){


        WebServiceSettings__c ws = new WebServiceSettings__c ();
       // ws.Name = 'PaymentCreditIncrease';
        ws.Name = wsName;
        ws.Endpoint__c = wsendpoint;
       // ws.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
        ws.Timeout__c  = 120;
        ws.Service_Unavailable_Message__c = 'Service Unavailable';

        return ws;
    }

/********************************************************************************************************
*  @description staticCustomSetting : this is the method to create static values custom settings  
*  @param name : This will accept the ws name
*  @param value : This will accept the end point  
*  @return Static_Values__c : return the ws code  
*********************************************************************************************************/

    public static Static_Values__c staticCustomSetting(string name, string value){
        Static_Values__c sv = new Static_Values__c();
        sv.Name = name;
        sv.value__c = value;

        return sv;
    }


}