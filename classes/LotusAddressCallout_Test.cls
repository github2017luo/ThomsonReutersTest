@isTest
public with sharing class LotusAddressCallout_Test {

@isTest    
static void addressCalloutTest(){

        List<sobject> leadList = new List<sobject>();
        KeyValueListStore__c profilename = new KeyValueListStore__c();        
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;

        
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;

        Lead objLead = new Lead();
        objLead.FirstName = 'Unit';
        objLead.LastName = 'Tester1';
        objLead.Company = 'Tester1';
        objLead.Status = 'Contacting';         
        objLead.LCRM_Sub_BU__c='US';
        objLead.BU_Segment__c='Corporate';
        objLead.Is_GLI__c = true;        
        objLead.Billing_Street__c = 'Test';
        objLead.Billing_City__c = 'Test';
        objLead.Billing_Country__c = 'Test';
        objLead.Billing_State__c = 'Test';
        objLead.Billing_Zip__c = 'Test';
        objLead.County__c = 'Test';
        objLead.PO_Box__c = 'Test';
        objLead.Street = '171 Lbs marg';
        objLead.PostalCode = '400085';
        objLead.City = 'Mumbai';
        objLead.State = 'MH';
        objLead.StateCode = 'MH';
        objLead.Country = 'IN';
        objLead.CountryCode = 'IN';
        objLead.PO_Box__c = '400085'; 
        objLead.recordtypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('GLI').getRecordTypeId(); 
        insert objLead;
        leadList.add(objLead);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LotusAddressMockCallout());
        LotusAddressCallout.validateAddress(leadList);
        Test.stopTest();

}

}