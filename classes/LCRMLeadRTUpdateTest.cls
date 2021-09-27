/**
* Test Class for LCRMLeadRTUpdate batch class
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-04-27   TCS                     Created     
* =============================================================================
*/
@isTest
private class LCRMLeadRTUpdateTest {

    private static testMethod void testLeadRecordTypeUpdate1() {
        
        Id rtId;
        Id rtEliteId;
        rtId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
        rtEliteId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite').getRecordTypeId();
        
        Lead oLead = UnitTest.getLeadInstance();
        oLead.LastName='TestLastName#123';
        oLead.Company = 'UTLeadAccount';
        oLead.Billing_City__c = 'test';
        oLead.Billing_Street__c = 'test';
        oLead.Billing_State__c = 'CA';
        oLead.Billing_Country__c = 'US';
        oLead.email = 'abc@gmail.com';
        oLead.recordTypeid = rtEliteId;
        insert oLead;
        
        Lead oLeadRetrieved = [select id, recordTypeid from Lead where id = :oLead.Id ];
        
        system.assertEquals(rtEliteId, oLeadRetrieved.RecordTypeId);
        
        Test.startTest();  
                LCRMLeadRTUpdate  obj1 = new LCRMLeadRTUpdate ();
                Database.executeBatch(obj1);
                obj1.createExceptionLog('Test Error','#111');
                system.assert(true);
        Test.stopTest();
        
        oLeadRetrieved = [select id, recordTypeid from Lead where id = :oLead.Id ];
        system.assertEquals(rtId, oLeadRetrieved.RecordTypeId);
    }

}