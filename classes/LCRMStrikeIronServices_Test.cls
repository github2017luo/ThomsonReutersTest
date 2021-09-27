/*
===============================================================================
LCRMStrikeIronServices_Test
===============================================================================

PURPOSE: test class for LCRMStrikeIronServices

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-06-20      Rajesh                  Created 
===============================================================================
*/
@IsTest
public class LCRMStrikeIronServices_Test{
    @testSetup static void testDataSetUp() {
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Name = 'LCRM_StrikeIron_Email_Service';
        oWebServiceSettings.Endpoint__c = 'https:\\test.thomsonreuters.com';
        oWebServiceSettings.Timeout__c = 2000;
        oWebServiceSettings.Username__c = '';
        oWebServiceSettings.Password__c = '';
        oWebServiceSettings.Active__c = true;
        oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        
        WebServiceSettings__c oWebServiceSettings1 = new WebServiceSettings__c();
        oWebServiceSettings1.Name = 'LCRM_StrikeIron_Phone_Service';
        oWebServiceSettings1.Endpoint__c = 'https:\\test.thomsonreuters.com';
        oWebServiceSettings1.Timeout__c = 2000;
        oWebServiceSettings1.Username__c = '';
        oWebServiceSettings1.Password__c = '';
        oWebServiceSettings1.Active__c = true;
        oWebServiceSettings1.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert new List<WebServiceSettings__c>{oWebServiceSettings, oWebServiceSettings1};     
    }
    
    public static testMethod void callEmailValidation(){
        Test.StartTest();
            LCRMStrikeIronServices serObj = new LCRMStrikeIronServices();
            serObj.callEmailValidation('test@test.com');
        Test.stopTest();
    }
    
    public static testMethod void callPhoneValidation(){
        Test.StartTest();
            LCRMStrikeIronServices serObj = new LCRMStrikeIronServices();
            serObj.callPhoneValidation('+911234567899,+910987654321');
        Test.stopTest();
    }
}