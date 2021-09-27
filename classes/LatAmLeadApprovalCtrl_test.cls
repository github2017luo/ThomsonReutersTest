/**
 * Test Class for LatAmLeadApprovalCtrl
* Story:        Created as part LatAm Community Project
*               Controller For Vf Page LatAmLeadApproval
* Description: If fields mentioned in user story are present on record then trigger approval process else throw error
**/


@isTest
public class LatAmLeadApprovalCtrl_test {
        
    Public Static testmethod void testCheckRequiredFields(){
        /*Profile p = [SELECT Id FROM Profile WHERE Name='Partner Portal User']; 
        
        Account oaccount = UnitTest.getAccountInstance();
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
        insert ocontact;
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                  LocaleSidKey='en_US', ProfileId = p.Id, contactId = ocontact.Id,
                  TimeZoneSidKey='America/Los_Angeles', UserName='LatAmLeadApprovalCtrl@trpcorelegal.com');
        //Group g = [select id from Group where Type = 'Queue' and developername= 'LatAm_Lead_Generation_Professional'];
        System.runas(u){*/
        Lead lead = new Lead();
        lead.LastName='Patel';
        lead.FirstName='Patel';
        lead.Company = 'UTLeadAccount';
        lead.email='abc@gmail.com';
        lead.Tax_Number__c='123123';
        lead.Tax_Number_Type__c='C.I.';
        lead.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
        //lead.ownerid = g.id;
        insert lead;        
     
        //Execute Test
        Test.startTest();
        PageReference testPageReference = new PageReference('/apex/LatAmLeadApproval');
        testPageReference.getParameters().put('id', lead.Id);
        Test.setCurrentPageReference(testPageReference);
     
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        LatAmLeadApprovalCtrl controller = new LatAmLeadApprovalCtrl(standardController);
        controller.sumbitForApproval();
        //controller.ggoUserFlag = true;
        //check for error case when required fields are not populated
        controller.checkRequiredFields();  
        system.assertEquals(controller.bError==false, false);
        PageReference sumbitForApproval = controller.sumbitForApproval();
        //check for exception scenario
        testPageReference = new PageReference('/apex/LatAmLeadApproval');
        testPageReference.getParameters().put('id', null);
        Test.setCurrentPageReference(testPageReference);
        standardController = new ApexPages.StandardController(lead);
        controller = new LatAmLeadApprovalCtrl(standardController);
        controller.bError=false;
        controller.sumbitForApproval();
        Test.stopTest();
        //}
    }
}