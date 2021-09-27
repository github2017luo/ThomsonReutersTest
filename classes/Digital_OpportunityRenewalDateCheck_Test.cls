/**
 * Test class for testing the Digital_OpportunityRenewalDateCheck.  That is a schedulable job that
 * Expires all proposals once the Opportunity renewal date as been reached.  
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-01-11   Brenda Shields          Updated after January release to increase test class code coverage - no functionallity was update
 * 2018-03-19   Brenda Shields          DLT-8184 - Updated code coverage
 * 2018-07-18   Brenda Shields          DLT-10851 - Updated for code coverage and mid-contract proposal expiration
 * 2019-03-21   Navleen Kaur            DLT-15672  [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
 * 2019-06-12   Harika Sai P            DLT-16823  Expire Mid-Contract/UpSell proposals on the offer expiration date
 * 2020-07-20   Brenda Shields          DLT-20383 - Expire Digital Manual quoutes - increase code coverage and fix errors  
 * =============================================================================
 */
@istest(seealldata=false)
Public class Digital_OpportunityRenewalDateCheck_Test{
    public static String digitalOppId;
    public static String oldMidContractOppId;
    public static String automationErrorOppId;

    @testSetup static void init(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();

        // create envelope record
        Apttus_DocuApi__DocuSignEnvelope__c newEnv = DCTestdata.createDocuSignEnvelope('sent', DCTestData.bQuoteId);
        insert newEnv;
        
        list<Opportunity> oppList = new list<Opportunity>();
        // Opp for expired renewal
        Opportunity oOpp1 = new Opportunity();
        oOpp1.Id = DCTestData.oppId;
        oOpp1.Renewal_Date__c = System.Today() - 5;
        //oppList.add(oOpp1);
        update oOpp1;
        digitalOppId = DCTestData.oppId;

        Test.StopTest();
                       
    }
     
     
    @isTest public static void renewalDateCheckTest(){
        // test for successfully processing
        test.starttest();
        Digital_OpportunityRenewalDateCheckSch dorc = new Digital_OpportunityRenewalDateCheckSch();
        dorc.execute(null);
        test.stoptest();
         
        list<Apttus_Proposal__Proposal__c> prop = [Select id, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c];
        System.AssertEquals('Expired', prop[0].Apttus_Proposal__Approval_Stage__c);
    }
     
     
    @isTest public static void oldMidContractTest(){
        // test for expiring quotes with automation errors
        test.starttest();
        
        // Proposal for automation failure
        Opportunity oOpp = [select id from Opportunity limit 1];
        //oOpp2.Key_Contact__c = DCTestData.contactId;
        oOpp.Renewal_Date__c = System.Today() - 370;
        oOpp.Status__c = 'Unworked';
        oOpp.isDigitalSpearHead__c = true;   
        //oppList.add(oOpp2);
        update oOpp;
        
        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = [Select id, Apttus_Proposal__Approval_Stage__c 
                    from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =: oOpp.Id limit 1];
        oQuote.Contract_Type__c = 'Old Mid Contract';
        update oQuote;
        
        Digital_OpportunityRenewalDateCheckSch dorc = new Digital_OpportunityRenewalDateCheckSch();
        dorc.execute(null);
        test.stoptest();
         
        list<Apttus_Proposal__Proposal__c> prop = [Select id, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c];
        System.AssertEquals('Expired', prop[0].Apttus_Proposal__Approval_Stage__c);
    }    
         
     
    @isTest public static void newMidContractTest(){
        // test for expiring quotes with automation errors
        test.starttest();
        
        // Proposal for automation failure
        Opportunity oOpp = [select id from Opportunity limit 1];
        //oOpp2.Key_Contact__c = DCTestData.contactId;
        oOpp.Renewal_Date__c = System.Today()-1;
        oOpp.Status__c = 'Unworked';
        oOpp.isDigitalSpearHead__c = true;   
        //oppList.add(oOpp2);
        update oOpp;
        
        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = [Select id, Apttus_Proposal__Approval_Stage__c 
                    from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =: oOpp.Id limit 1];
        oQuote.Contract_Type__c = 'New Mid Contract';
        update oQuote;
        
        Digital_OpportunityRenewalDateCheckSch dorc = new Digital_OpportunityRenewalDateCheckSch();
        dorc.execute(null);
        test.stoptest();
         
        list<Apttus_Proposal__Proposal__c> prop = [Select id, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c];
        System.AssertEquals('Expired', prop[0].Apttus_Proposal__Approval_Stage__c);
    }
    
          
    @isTest public static void automationErrorTest(){
        // test for expiring quotes with automation errors
        test.starttest();
        
        // Proposal for automation failure
        Opportunity oOpp = [select id from Opportunity limit 1];
        //oOpp2.Key_Contact__c = DCTestData.contactId;
        oOpp.Renewal_Date__c = System.Today() + 120;
        oOpp.Status__c = 'Unworked';
        oOpp.isDigitalSpearHead__c = true;   
        //oppList.add(oOpp2);
        update oOpp;
        
        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = [Select id, Apttus_Proposal__Approval_Stage__c 
                    from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =: oOpp.Id limit 1];
        oQuote.Digital_Quote_Failure_Reason__c = 'Cancelled assets in Account';
        update oQuote;
        
        Digital_OpportunityRenewalDateCheckSch dorc = new Digital_OpportunityRenewalDateCheckSch();
        dorc.execute(null);
        test.stoptest();
         
        list<Apttus_Proposal__Proposal__c> prop = [Select id, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c];
        System.AssertEquals('Expired', prop[0].Apttus_Proposal__Approval_Stage__c);
    }   
                   
}