/*============================================================================================
Name                : OmniCallToOLCFetchOnlineContactsTest
Description         :   
Created Date        : 11/May/2021 
Author              : TCS team
Modification History: 
==============================================================================================*/
/**
* @description OmniCallToOLCFetchOnlineContactsTest
*/
@isTest
public class OmniCallToOLCFetchOnlineContactsTest {
    /**
* @description testMethod1
*/
    @isTest
    public static void testMethod1(){
        WebServiceSettings__c  wb = new WebServiceSettings__c ();
        wb.Name = 'OmniGenericEntitlementService';
        wb.CurrencyIsoCode = 'USD';
        wb.Active__c = true;
        wb.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/entitlement/uat/getEntitlements' ;
        wb.Password__c = 's2esandboxESI12c';
        wb.Service_Unavailable_Message__c ='ODTGenericEntitlement Service used to fetch online contacts from OLC';
        wb.Timeout__c = 120 ; 
        wb.Username__c = 'esisfdcs2euser';
        insert wb;
        Test.setMock(HttpCalloutMock.class, new OmniMockHttpResponseGeneratorMock());
        test.startTest();
        LIST < TrialContactWrapper> res    = OmniCallToOLCFetchOnlineContacts.showOnlineContacts('1004635821');
        OmniEsiResponseWrapper.omniTestMethod();
        system.assertEquals(false, res.size()>0,'success');
        test.stopTest();
    }
 
}