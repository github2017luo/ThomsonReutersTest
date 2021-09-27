/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2021-02-08   Ameeta Antonio          Created
   2021-02-25   Brenda Shields			DLT-21454 - [SFDC][SLF, CORP, GOVT, MLF][REN] Send Rep Renewal Email data to Eloqua
 * =============================================================================
 */
 /**
 * @description : Test class for testing the Digital_Create_Email_TemplateController class which sends personalized 
 * emails to reps on click of button in opportunity 
 */
@isTest
public class Digital_Create_Email_TemplateTest {

    @testSetup static void init(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Test.StopTest(); 
        
        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = [Select id  from Apttus_Proposal__Proposal__c limit 1];
        oQuote.Apttus_Proposal__Approval_Stage__c = 'Presented';
        oQuote.Apttus_Proposal__Primary__c = true;
        oQuote.Digital_Quote_Type__c = 'Manual';
        oQuote.Digital_Envelope_Created__c = false;      
        oQuote.Display_in_CXD_Renewals__c = false; 
        oQuote.Latam_APTS_Win_Loss__c = 'Won';
        oQuote.Latam_APTS_Reason__c = 'Digital';
        update oQuote;
        
        // create web service setting for Eloqua service
        WebServiceSettings__c web1Service = new WebServiceSettings__c();
        web1Service.Endpoint__c = 'test.endpoint';
        web1Service.Name = 'DigitalRepDrivenEloquaService';
        web1Service.Username__c = 'test.user';
        web1Service.Password__c = 'test:123';
        web1Service.Service_Unavailable_Message__c = 'testservice';
        insert web1Service;
           
     }
    
    @isTest
    static void testCreateEmail(){
        List<Opportunity> listOpp = [Select id from Opportunity LIMIT 1];
        
        PageReference pageRef = Page.Digital_Create_Email_Template;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', listOpp[0].id);
        
        Test.startTest();
        Digital_Create_Email_TemplateController ctrl = new Digital_Create_Email_TemplateController();
        ctrl.inputMsg = 'Test message';
        PageReference pg = ctrl.sendEmail();
        System.assert(pg != null, 'message sent successfully');
        PageReference pg1 = ctrl.returnToOpp();
        System.assert(pg1 != null, 'Return to oppty');
        Test.stopTest();
    }
}