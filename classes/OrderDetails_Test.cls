@istest (seealldata=false)
public with sharing class OrderDetails_Test { 
    public static testMethod void testOrderDetails(){
        WebServiceSettings__c oKeyValue = new WebServiceSettings__c();
        oKeyValue.name = 'OrderServices';       
        oKeyValue.Active__c = true;
        oKeyValue.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue.Password__c = '$aleForce';
        oKeyValue.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue.Timeout__c = 120;
        oKeyValue.Username__c = 'Salesforce';
        INSERT oKeyValue;
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SapAccountNumber__c = '12589';
        insert testAcc1;
        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
        Test.setCurrentPageReference(Page.OrderDetailPage);
        OrderDetails controller = new OrderDetails(sc);
    }
}