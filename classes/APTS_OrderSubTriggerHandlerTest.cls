/**
 * @description APTS_OrderSubTriggerHandlerTest test class for APTS_OrderSubTriggerHandler
 */
@isTest
public with sharing class APTS_OrderSubTriggerHandlerTest {
    static testMethod void testMethod1() {
        Integration_Logger__c objIntegrationLogger = new Integration_Logger__c();
        objIntegrationLogger.Service_Name__c = 'OrderSubmission';
        insert objIntegrationLogger;

        List<APTS_Order_Submission__e> listoforderplatform = new  List<APTS_Order_Submission__e>();
        APTS_Order_Submission__e orderplatform = new APTS_Order_Submission__e();
        orderplatform.ApplicationID__c = 'TestAppID';
        orderplatform.CompanyID__c = 'TestCoID';
        orderplatform.JSONRecordID__c = objIntegrationLogger.ID;
        orderplatform.OrderNo__c = 'TestONumber';
        listoforderplatform.add(orderplatform);
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(listoforderplatform);
        System.assert(results.size() >0 , true);
        Test.stopTest();
    }
}