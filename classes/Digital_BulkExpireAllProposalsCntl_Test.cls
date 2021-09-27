/**
 * Test class for testing the Digital_BulkExpireAllProposalsController class.  That class is a button on the 
 * Opportunity list view which 'expires' all Quote/Proposals from the selected opportunities
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-02-06   Brenda Shields          Created
 * 2018-06-21   Poonam Garg             modified to increase coverage and create TestData using
                                        DCTestData Class.  
 * =============================================================================
 */
@isTest
private class Digital_BulkExpireAllProposalsCntl_Test {

    @testSetup static void init(){
        User u3 = [SELECT Id FROM User WHERE Name='Molly Bentz']; 
        System.runas(u3){
            DCTestData.createData();
            Test.startTest();
            DCTestData.createQuote();
            Test.StopTest();
        	Apttus_Proposal__Proposal__c prop=[Select id from Apttus_Proposal__Proposal__c LIMIT 1];
         	// create envelope record
        	Apttus_DocuApi__DocuSignEnvelope__c newEnv = DCTestdata.createDocuSignEnvelope('sent',prop.Id);
        	insert newEnv;  
        }  
    }
    
/*  
There is a continue response needed to complete the process - the complete test is already done below  
     @isTest static void testExpireQuote() {
        User u3 = [SELECT Id FROM User WHERE Name='Molly Bentz'];
        System.runAs(u3) {
                Test.startTest();
                List<Opportunity> oppList=[Select id,name,AccountId,stagename,CloseDate,isDigitalSpearHead__c from opportunity ];
                System.debug('*******opplist'+oppList);
            
                PageReference pageRef = Page.DigitalBulkExpireAllProposals;
                Test.setCurrentPage(pageRef);
                ApexPages.StandardSetController con = new ApexPages.StandardSetController(oppList);
                con.setSelected(oppList);
                Digital_BulkExpireAllProposalsController conBulk = new Digital_BulkExpireAllProposalsController(con);
                
                
                PageReference pg = conBulk.BulkExpireProposals();
                //PageReference pg1 = conBulk.BulkExpireProposals();        
                
                Opportunity oppRec=[Select id,Unmarked_Digital_Channel__c,isDigitalSpearHead__c from Opportunity where id =:oppList];
                System.debug('&&&opp'+oppRec);
                System.AssertEquals(True,oppRec.Unmarked_Digital_Channel__c,'Unmarked');
                System.AssertEquals(False,oppRec.isDigitalSpearHead__c,'Digital Channel');
                PageReference pg3 = conBulk.ReturnToOpp();
                Test.stopTest();
        }
    }
*/
    
	@isTest static void testNoDigitalProposal() {
        User u3 = [SELECT Id FROM User WHERE Name='Molly Bentz'];
        System.runAs(u3) {
            Test.startTest();
            List<Opportunity> oppList=[Select id,name,AccountId,stagename,CloseDate,isDigitalSpearHead__c from opportunity LIMIT 1];
            Apttus_Proposal__Proposal__c newQuote =[Select Apttus_Proposal__Opportunity__c,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Primary__c,Apttus_Proposal__Account__c,APTS_Order_Confirmation_Contact__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in :oppList][0];
            
            newQuote.Apttus_Proposal__Approval_Stage__c = 'Accepted';
            update newQuote;
            PageReference pageRef = Page.DigitalBulkExpireAllProposals;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardSetController con = new ApexPages.StandardSetController(oppList);
            con.setSelected(oppList);
            Digital_BulkExpireAllProposalsController conBulk = new Digital_BulkExpireAllProposalsController(con);           
            
            PageReference pg = conBulk.BulkExpireProposals();
            PageReference pg1 = conBulk.BulkExpireProposals();
            Opportunity oppRec=[Select id,Unmarked_Digital_Channel__c,isDigitalSpearHead__c from Opportunity where id =:opplist];
            System.AssertEquals(false,oppRec.Unmarked_Digital_Channel__c,'Unmarked');
            System.AssertEquals(true,oppRec.isDigitalSpearHead__c,'Digital Channel');
            Test.stopTest();
        }
    }   
       
    @isTest static void testInvalidUser() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name='ANZ Users']; 
        DCTestData.createUser();
        User newUser=[Select id from User where username='Test.User@testorg.com' LIMIT 1];
        // Opportunity Owner
    	Test.startTest();        
        List<Opportunity> oppList=[Select id,name,AccountId,stagename,CloseDate,isDigitalSpearHead__c from opportunity where name ='Test Class Opp' LIMIT 1];       
        System.runAs(newUser) {
            PageReference pageRef = Page.DigitalBulkExpireAllProposals;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardSetController con = new ApexPages.StandardSetController(oppList);
            con.setSelected(oppList);
            Digital_BulkExpireAllProposalsController conBulk = new Digital_BulkExpireAllProposalsController(con);
            try {
            	PageReference pg = conBulk.BulkExpireProposals();
            } catch(Exception e) {
                System.assertEquals(e.getmessage(),'You are not authorized to Expire Proposals in bulk using this function. Please contact an authorized user to Expire Digital Quote/Proposals via the Opportunity List View.');
            }
            Test.stopTest();
        }
    }
    
    @isTest static void testContinueQuotes() {
        User u3 = [SELECT Id FROM User WHERE Name='Molly Bentz'];
        System.runAs(u3) {        
            Test.startTest();       
            List<Opportunity> oppList=[Select id,name,AccountId,stagename,CloseDate,isDigitalSpearHead__c from opportunity LIMIT 1]; 
            // Set mock callout class for Envelope response
            Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
            PageReference pageRef = Page.DigitalBulkExpireAllProposals;
            Test.setCurrentPage(pageRef);        
            ApexPages.StandardSetController con = new ApexPages.StandardSetController(oppList);
            con.setSelected(oppList);
            Digital_BulkExpireAllProposalsController conBulk = new Digital_BulkExpireAllProposalsController(con); 
            System.assertEquals(1, conBulk.getMySelectedSize()); 
            conBulk.isContinue = true;
            PageReference pg = conBulk.ContinueExpire();
            Opportunity oppRec=[Select id,Unmarked_Digital_Channel__c,isDigitalSpearHead__c from Opportunity where id =:opplist];
            System.AssertEquals(True,oppRec.Unmarked_Digital_Channel__c,'Unmarked');
            System.AssertEquals(False,oppRec.isDigitalSpearHead__c,'Digital Channel');
            Test.stopTest();
        } 
    }
           
    @isTest static void testNonDigitalOpportunity() {
        //create required custom setting
        User u3 = [SELECT Id FROM User WHERE Name='Molly Bentz'];
        System.runAs(u3) {
            Test.startTest();       
            List<Opportunity> oppList = [Select id,name,AccountId,stagename,CloseDate,isDigitalSpearHead__c from opportunity LIMIT 1];
            List<Account> accList=[Select id from Account LIMIT 1];
            Source_System_Detail__c accountSSD=[Select id from Source_System_Detail__c LIMIT 1][0];
            Contact newContact=[Select id from Contact][0];
            Account newAcc=[Select id from Account][0];
            Opportunity newOpp1 = DCTestData.createOpportunityRec('Test Class Opp', accList[0].Id, 'Contacting', system.today(),accountSSD.id);
            newOpp1.Name = 'Test Class Opp';
            newOpp1.isDigitalSpearHead__c = false;          
            insert newOpp1;
            oppList.add(newOpp1);        
            // create Proposal for Non Digital Opportunity
            Apttus_Proposal__Proposal__c newQuote1 = DCTestdata.createProposalRec(newOpp1.Id,accountSSD.id,newAcc.id,newContact.Id,'test0987@tr.com');
            //newQuote.name = 'Test Class Quote';
            newQuote1.Apttus_Proposal__Approval_Stage__c = 'Accepted';
            newQuote1.Apttus_Proposal__Primary__c = true;
            insert newQuote1;
            PageReference pageRef = Page.DigitalBulkExpireAllProposals;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardSetController con = new ApexPages.StandardSetController(oppList);
            con.setSelected(oppList);
            Digital_BulkExpireAllProposalsController conBulk = new Digital_BulkExpireAllProposalsController(con); 
            List<Apttus_Proposal__Proposal__c> newQuoteList =[Select Apttus_Proposal__Opportunity__c,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Primary__c,Apttus_Proposal__Account__c,APTS_Order_Confirmation_Contact__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Approval_Stage__c ='Expired'];
            System.assertEquals(newQuoteList.size(),0);           
            PageReference pg = conBulk.BulkExpireProposals();
            Test.stopTest();
        }      
    }
    
    @isTest static void noOpportunitySelected() {   
        //Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        User u3 = [SELECT Id FROM User WHERE Name='Molly Bentz'];
        System.runAs(u3) {
            Test.startTest();       
            List<Opportunity> oppList=[Select id,name,AccountId,stagename,CloseDate,isDigitalSpearHead__c from opportunity  LIMIT 1];
        
            System.debug('*******opplist'+oppList);
            PageReference pageRef = Page.DigitalBulkExpireAllProposals;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardSetController con = new ApexPages.StandardSetController(oppList);
            //con.setSelected(oppList);
            Digital_BulkExpireAllProposalsController conBulk = new Digital_BulkExpireAllProposalsController(con);  
            try {
            	PageReference pg = conBulk.BulkExpireProposals();
            } catch(Exception e) {
                System.assertEquals(e.getMessage(),'Please select at least one Opportunity.');          
            }
            Test.stopTest();
        }
    }   
}