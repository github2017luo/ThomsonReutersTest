/**
 * Test class for testing the Digital_Display_In_CXD_Controller class.  That class is a button on the 
 * Proposal that will allow Reps to include a manual proposal on a Digital offer  
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-04-27   Brenda Shields          DLT-19727 - Created
 * 2020-08-20   Brenda Shields          DLT-20592 - Test coverage for OCC Inactive functionality
 * 2020-10-12   Brenda Shields          DLT-20935/DLT-20947 - updated for test coverage for new features
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c 
 * =============================================================================
 */
 /**
    @description Test class for Digital_Display_In_CXD_Controller class
  */
@isTest
private class Digital_Display_In_CXD_Cntl_Test {

    public static String oppId;
    public static String quoteId;
    
    @testSetup static void init() {
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Test.StopTest();  
        
        // update renewal date on Opp
        Opportunity oOpp = new Opportunity();
        oOpp.id = DCTestData.oppId;
        oOpp.StageName = 'Contacting';
        oOpp.isDigitalSpearhead__c = true;
        oOpp.Unmarked_Digital_Channel__c = false;
        oOpp.DRS_Status_Digital__c = '';
        oOpp.Renewal_Date__c = system.today()+30;
        update oOpp; 
        
        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = [Select id  from Apttus_Proposal__Proposal__c limit 1];
        //oQuote.id = DCTestData.bQuoteId;
        oQuote.Apttus_Proposal__Approval_Stage__c = 'Draft';
        oQuote.Apttus_Proposal__Primary__c = true;
        oQuote.Digital_Quote_Type__c = 'Manual';
        oQuote.Digital_Envelope_Created__c = false;     
        oQuote.Apttus_Proposal__Opportunity__c = oOpp.id;  
        oQuote.Display_in_CXD_Renewals__c = false; 
        oQuote.Latam_APTS_Win_Loss__c = 'Won';
        oQuote.Latam_APTS_Reason__c = 'Digital';
        update oQuote;
        
        oppId = oOpp.id;
        quoteId = oQuote.id;
    
        Apttus_Proposal__Proposal__c prop=[Select id from Apttus_Proposal__Proposal__c LIMIT 1];
        // create envelope record
        Apttus_DocuApi__DocuSignEnvelope__c newEnv = DCTestdata.createDocuSignEnvelope('sent',prop.Id);
        insert newEnv;   
     }
     
    @isTest static void testCreateOrder()
    {
        //List<Opportunity> listOpp = [Select id from Opportunity LIMIT 1];
        Apttus_Proposal__Proposal__c oQuote = [Select id from Apttus_Proposal__Proposal__c LIMIT 1];
        PageReference pageRef = Page.Digital_Display_In_CXD;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oQuote.id);
        ApexPages.currentPage().getParameters().put('create', 'true');
       
        Test.startTest();
        Digital_Display_In_CXD_Controller generateCtrl = new Digital_Display_In_CXD_Controller();
        PageReference pg = generateCtrl.createOrderForm();
        system.debug(LoggingLevel.INFO, 'pg: ' + pg);
        PageReference pg1 = generateCtrl.continueProcess();
        
        List<Apttus_Proposal__Proposal__c > prop = [Select Apttus_Proposal__Approval_Stage__c, Display_in_CXD_Renewals__c  from Apttus_Proposal__Proposal__c where id = : oQuote.id];
        system.debug(LoggingLevel.INFO, 'test1 quote stage: ' + prop[0].Apttus_Proposal__Approval_Stage__c);
        // we don't actually create the attachment during test runs
        system.assertEquals(prop[0].Display_in_CXD_Renewals__c, false, 'Renew Flag should be set');
        pg1 = generateCtrl.ReturnToQuote();
        Test.stopTest();
        
    }
  
    @isTest static void testRemoveFromOffer()
    {
        //List<Opportunity> listOpp = [Select id from Opportunity LIMIT 1];
        Apttus_Proposal__Proposal__c oQuote = [Select id from Apttus_Proposal__Proposal__c LIMIT 1];
        PageReference pageRef = Page.Digital_Display_In_CXD;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oQuote.id);
        ApexPages.currentPage().getParameters().put('create', 'false');
       
        Test.startTest();
        Digital_Display_In_CXD_Controller generateCtrl = new Digital_Display_In_CXD_Controller();
        PageReference pg = generateCtrl.createOrderForm();
        system.debug(LoggingLevel.INFO, 'pg: ' + pg);
        PageReference pg1 = generateCtrl.continueProcess();
        
        List<Apttus_Proposal__Proposal__c > prop=[Select Apttus_Proposal__Approval_Stage__c  from Apttus_Proposal__Proposal__c where id = : oQuote.id];
        system.debug(LoggingLevel.INFO, 'test1 quote stage: ' + prop[0].Apttus_Proposal__Approval_Stage__c);
        system.assertEquals(prop[0].Apttus_Proposal__Approval_Stage__c, 'Draft', 'Reset Stage back to Draft');
        pg1=generateCtrl.ReturnToQuote();
        Test.stopTest();
        
    }
    
    @isTest static void testValidationErrors()
    {
        // Validation errors include the no OCC contact error
        //List<Opportunity> listOpp = [Select id from Opportunity LIMIT 1];
        
        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = [Select id  from Apttus_Proposal__Proposal__c limit 1];
        oQuote.Latam_APTS_Win_Loss__c = null;
        oQuote.Latam_APTS_Reason__c = null;
        oQuote.APTS_Order_Confirmation_Contact__c = null;
        update oQuote;
        
        PageReference pageRef = Page.Digital_Display_In_CXD;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oQuote.id);
        ApexPages.currentPage().getParameters().put('create', 'true');
       
        Test.startTest();
        Digital_Display_In_CXD_Controller generateCtrl = new Digital_Display_In_CXD_Controller();
        PageReference pg = generateCtrl.createOrderForm();
        system.debug(LoggingLevel.INFO, 'pg: ' + pg);
        PageReference pg1 = generateCtrl.continueProcess();
        
        List<Apttus_Proposal__Proposal__c > prop=[Select Apttus_Proposal__Approval_Stage__c, Display_in_CXD_Renewals__c  from Apttus_Proposal__Proposal__c where id = : oQuote.id];
        system.debug(LoggingLevel.INFO, 'test1 quote stage: ' + prop[0].Apttus_Proposal__Approval_Stage__c);
        // we don't update the quote
        system.assertEquals(prop[0].Apttus_Proposal__Approval_Stage__c, 'Draft', 'Stage should remain as Draft');
        pg1 = generateCtrl.ReturnToQuote();
        Test.stopTest();
        
    }
      
    @isTest static void testValidationOppNotDigital()
    {
        // update opp to not be digital
        Opportunity oOpp = [Select id from Opportunity LIMIT 1];
        oOpp.isDigitalSpearhead__c = false;
        update oOpp;
        // get quote id
        Apttus_Proposal__Proposal__c oQuote = [Select id  from Apttus_Proposal__Proposal__c limit 1];
        oQuote.APTS_Approval_Segment__c = 'Small Law';
        oQuote.APTS_Proposal_Business_Unit__c = 'FindLaw';
        update oQuote;
        
        PageReference pageRef = Page.Digital_Display_In_CXD;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oQuote.id);
        ApexPages.currentPage().getParameters().put('create', 'true');
       
        Test.startTest();
        Digital_Display_In_CXD_Controller generateCtrl = new Digital_Display_In_CXD_Controller();
        PageReference pg = generateCtrl.createOrderForm();
        system.debug(LoggingLevel.INFO, 'pg: ' + pg);
        PageReference pg1 = generateCtrl.continueProcess();
        
        List<Apttus_Proposal__Proposal__c > prop = [Select Apttus_Proposal__Approval_Stage__c, Display_in_CXD_Renewals__c  from Apttus_Proposal__Proposal__c where id = : oQuote.id];
        system.debug(LoggingLevel.INFO, 'test1 quote stage: ' + prop[0].Apttus_Proposal__Approval_Stage__c);
        // we don't update the quote
        system.assertEquals(prop[0].Apttus_Proposal__Approval_Stage__c, 'Draft', 'Stage should remain as Draft');
        pg1 = generateCtrl.ReturnToQuote();
        Test.stopTest();
    }  
    
      
    @isTest static void testValidationExpiredRenewal()    
    {
        // update opp to not be digital
        Opportunity oOpp = [Select id,Renewal_Date__c from Opportunity LIMIT 1][0];
        oOpp.Renewal_Date__c = system.today()-30;
        update oOpp;
        // get quote id
        Apttus_Proposal__Proposal__c oQuote = [Select id  from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c=:oOpp.Id limit 1][0];
        
        PageReference pageRef = Page.Digital_Display_In_CXD;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oQuote.id);
        ApexPages.currentPage().getParameters().put('create', 'true');
       
        Test.startTest();
        Digital_Display_In_CXD_Controller generateCtrl = new Digital_Display_In_CXD_Controller();
        PageReference pg = generateCtrl.createOrderForm();
        system.debug(LoggingLevel.INFO, 'pg: ' + pg);
        PageReference pg1 = generateCtrl.continueProcess();
        
        List<Apttus_Proposal__Proposal__c > prop = [Select Apttus_Proposal__Approval_Stage__c, Display_in_CXD_Renewals__c  from Apttus_Proposal__Proposal__c where id = : oQuote.id];
        system.debug(LoggingLevel.INFO, 'test1 quote stage: ' + prop[0].Apttus_Proposal__Approval_Stage__c);
        // we don't update the quote
        system.assertEquals(prop[0].Apttus_Proposal__Approval_Stage__c, 'Draft', 'Stage should remain as Draft');
        pg1 = generateCtrl.ReturnToQuote();
        Test.stopTest();
    } 
    
    @isTest static void testValidationNoCart()    
    {
        // update opp to not be digital
        //Opportunity oOpp = [Select id from Opportunity LIMIT 1];

        // get quote id
        Apttus_Proposal__Proposal__c oQuote = [Select id from Apttus_Proposal__Proposal__c limit 1];
        
        Apttus_Config2__ProductConfiguration__c oCart = [select id, Apttus_Config2__Status__c
                        From Apttus_Config2__ProductConfiguration__c
                        where Apttus_QPConfig__Proposald__c = : oQuote.id limit 1];
        oCart.Apttus_Config2__Status__c = 'Pending';
        update oCart;                       
                        
        PageReference pageRef = Page.Digital_Display_In_CXD;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oQuote.id);
        ApexPages.currentPage().getParameters().put('create', 'true');
       
        Test.startTest();
        Digital_Display_In_CXD_Controller generateCtrl = new Digital_Display_In_CXD_Controller();
        PageReference pg = generateCtrl.createOrderForm();
        system.debug(LoggingLevel.INFO, 'pg: ' + pg);
        PageReference pg1 = generateCtrl.continueProcess();
        
        List<Apttus_Proposal__Proposal__c > prop = [Select Apttus_Proposal__Approval_Stage__c, Display_in_CXD_Renewals__c  from Apttus_Proposal__Proposal__c where id = : oQuote.id];
        system.debug(LoggingLevel.INFO, 'test1 quote stage: ' + prop[0].Apttus_Proposal__Approval_Stage__c);
        // we don't update the quote
        system.assertEquals(prop[0].Apttus_Proposal__Approval_Stage__c, 'Draft', 'Stage should remain as Draft');
        pg1 = generateCtrl.ReturnToQuote();
        Test.stopTest();
    } 
   
   
     @isTest static void testInactiveContactErrors()
    {
        // Validation errors include the no OCC contact error
        //List<Opportunity> listOpp = [Select id from Opportunity LIMIT 1];
        
        // get quote id
        Apttus_Proposal__Proposal__c oQuote = [Select id from Apttus_Proposal__Proposal__c limit 1];
        
        // update Contact
        Contact oContact = [Select id, Contact_Inactive__c, EmailBouncedReason from Contact limit 1];
        oContact.Contact_Inactive__c = true;
        oContact.EmailBouncedReason = 'Testing email bounced';
        update oContact;
        
        PageReference pageRef = Page.Digital_Display_In_CXD;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oQuote.id);
        ApexPages.currentPage().getParameters().put('create', 'true');
       
        Test.startTest();
        Digital_Display_In_CXD_Controller generateCtrl = new Digital_Display_In_CXD_Controller();
        PageReference pg = generateCtrl.createOrderForm();
        system.debug(LoggingLevel.INFO, 'pg: ' + pg);
        PageReference pg1 = generateCtrl.continueProcess();
        
        List<Apttus_Proposal__Proposal__c > prop=[Select Apttus_Proposal__Approval_Stage__c, Display_in_CXD_Renewals__c  from Apttus_Proposal__Proposal__c where id = : oQuote.id];
        system.debug(LoggingLevel.INFO, 'test1 quote stage: ' + prop[0].Apttus_Proposal__Approval_Stage__c);
        // we don't update the quote
        system.assertEquals(prop[0].Apttus_Proposal__Approval_Stage__c, 'Draft', 'Stage should remain as Draft');
        pg1 = generateCtrl.ReturnToQuote();
        Test.stopTest();
        
    }
 
 
    @isTest static void testNoSSDDigitalFirm()
    {
        // create web services
        DCTestData.createPaymentAutoCharge();
        DCTestData.createPaymentCreditWebService();
        
        // Validation errors include the no OCC contact error
        //List<Opportunity> listOpp = [Select id from Opportunity LIMIT 1];
        
        // get quote id
        Apttus_Proposal__Proposal__c oQuote = [Select id, APTS_SSD_Sold_To__c
            from Apttus_Proposal__Proposal__c limit 1];
           
        // update SSD
        Source_System_Detail__c oSSD = [Select id, BU_Segment_Level_2__c
            from Source_System_Detail__c where id = : oQuote.APTS_SSD_Sold_To__c limit 1];
        oSSD.BU_Segment_Level_2__c = null;
        
        Test.startTest();
        update oSSD;
        
        PageReference pageRef = Page.Digital_Display_In_CXD;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oQuote.id);
        ApexPages.currentPage().getParameters().put('create', 'true');
       

        Digital_Display_In_CXD_Controller generateCtrl = new Digital_Display_In_CXD_Controller();
        PageReference pg = generateCtrl.createOrderForm();
        system.debug(LoggingLevel.INFO, 'pg: ' + pg);
        PageReference pg1 = generateCtrl.continueProcess();
        
        List<Apttus_Proposal__Proposal__c > prop=[Select Apttus_Proposal__Approval_Stage__c, Display_in_CXD_Renewals__c  from Apttus_Proposal__Proposal__c where id = : oQuote.id];
        system.debug(LoggingLevel.INFO, 'test1 quote stage: ' + prop[0].Apttus_Proposal__Approval_Stage__c);
        // we don't update the quote
        system.assertEquals(prop[0].Apttus_Proposal__Approval_Stage__c, 'Draft', 'Stage should remain as Draft');
        pg1 = generateCtrl.ReturnToQuote();
        Test.stopTest();
        
    }
           
}