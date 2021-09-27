@isTest
public class PersonWidgetIntegrationHelperTest{

    public static testMethod void testGetPersonMainScreenData(){
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Name = PersonWidgetIntegrationHelper.PersonWidgetMainScreenDataService;
        oWebServiceSettings.Endpoint__c = 'https:\\test.thomsonreuters.com';
        oWebServiceSettings.Timeout__c = 5;
        oWebServiceSettings.Username__c = '';
        oWebServiceSettings.Password__c = '';
        oWebServiceSettings.Active__c = true;
        oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oWebServiceSettings;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PersonWidgetMockHttpResponse()); 
        PersonWidgetIntegrationHelper oController = new PersonWidgetIntegrationHelper();
        PersonWidgetIntegrationHelper.PersonWidgetWrapper pwObj = oController.getPersonMainScreenData('12345');
        System.assert(pwObj.output_PersonID == '123456');
        
        Test.stopTest();
    }
}