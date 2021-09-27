/**
 * Test class for Digital_PostAcceptAttachment
 * Test process that creates a new attachment once a proposal is moved to accepted and has a digital signed date
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-10-25   Brenda Shields          Created for CX Digital DLT-4381  
 * 2018-06-06   Poonam Garg             DLT-9756 Replace Account Object with Source System Detail Object.
 * 2018-06-12   Poonam Garg             Changed Methods for KeyValueListStore__c,RecordtypeIds__c,
 *                                      Source System Detail , Opportunity, Contact, Proposal, Proposal Line Item and create product
 * 2020-08-10   Brenda Shields          DLT-20475 - updated for code coverage for new funcionality                                        
 * 2021-03-04   Brenda Shields          DLT-17212 - [ALL] Update class to create document as a file and not an attachment                                      
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 * 2021-05-12   Brenda Shields          DLT-21777 - Update for DocuSign changes - Update Proposal and Envelope and create Signed Order Form
 * 2021-07-13   Brenda Shields          DLT-22040 - (DLT-21846 was Development jira) - [SFDC][INC4022734][Monitoring][NSE] - Backend systems to exclude synthetic test NSE order for order processing
 * =============================================================================
 */
/** 
* @description : test class for Digital_PostAcceptAttachment class
*/ 
@isTest
public class Digital_PostAcceptAttachment_Test {
    
    @testSetup static void init() {
        // user needed to set opp/prpoosal owner
        User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,FirstName='test',LastName = 'user',Email = 'test.user@mailinator.com',Username = 'test.userrdxr@mailinator.cxd1.com',CompanyName = 'TEST',
            Title = 'title',Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
        // needed to so creating content document will not get exception
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User  System Administrator');
        insert test2;
        
        list<WebServiceSettings__c> webServiceList = new list<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webServiceList;
        
        System.runAs(u) {
            DCTestData.createData();
            Test.startTest();
            DCTestData.createQuote();
            
            // select Proposal to create envelope
            Apttus_Proposal__Proposal__c prop = [Select id from Apttus_Proposal__Proposal__c LIMIT 1];
            // create envelope record
            Apttus_DocuApi__DocuSignEnvelope__c newEnv = DCTestdata.createDocuSignEnvelope('sent', prop.Id);
            insert newEnv;          
            
            // creation of new records is causing too many SOQL errors, removing as much creation of records as possible      

            // create order form
            Blob beforeblob = Blob.valueOf('Unit Test Attachment Body');
            // create content version
            ContentVersion cv = new ContentVersion();
            cv.ContentLocation = 'S';
            cv.PathOnClient ='testDemo.pdf'; 
            cv.Title = 'Test Order Form.pdf';
            cv.VersionData = beforeblob;          
            insert cv; 
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = prop.id;
            cdl.ContentDocumentId = conDoc;
            cdl.shareType = 'v';
            cdl.Visibility = 'AllUsers';
            insert cdl;
            
            Test.StopTest();

        }
    }
    
    
    // test for main functionality
    @isTest static void testPostAttach() { 
        User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,FirstName='test',LastName = 'user',Email = 'test.user@mailinator.com',Username = 'test.userrdxr@mailinator.cxd2.com',CompanyName = 'TEST',
            Title = 'title',Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
        System.runAs(u) {
        
            // list of proposal ids for running test    
            list<id> propid = new list<id>();
            list<Apttus_Proposal__Proposal__c> lstProposals = new list<Apttus_Proposal__Proposal__c>();
            Apttus_Proposal__Proposal__c newQuote = [Select id,is_Digital_Channel__c,Is_Digital_New_Sales__c,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Account__c,Digitally_Signed_Date__c,APTS_Order_Confirmation_Contact__c,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Opportunity__r.stageName   
                                                    from Apttus_Proposal__Proposal__c  LIMIT 1];
            system.debug(LoggingLevel.ERROR, 'test*******' + newQuote);
            
            Test.startTest(); 

            // set approval date and signed date to trigger creation of new attachment  
            Opportunity opp = [Select Id,Owner.Email,Name, isDigitalSpearHead__c,Is_Digital_New_Sales__c from Opportunity where Id =:newQuote.Apttus_Proposal__Opportunity__c];
            system.debug(LoggingLevel.ERROR ,'opp test > ' + opp);
            // We will be setting the approval stage for accepted
            Apttus_Proposal__Proposal__c newProposal = new Apttus_Proposal__Proposal__c(Id = newQuote.Id);
            //newProposal.Apttus_Proposal__Approval_Stage__c = 'Accepted';
            newProposal.Apttus_Proposal__Primary__c = true;
            newProposal.Digitally_Signed_Date__c = system.now();
            newProposal.Digital_Batch_Processed__c = true; 
            system.debug(LoggingLevel.INFO, 'c' + newProposal);
            lstProposals.add(newProposal);
            // update both proposals
            update lstProposals;
            
            //assert before
            Integer expectedLimits = 1;
            Integer actualLimits = Limits.getEmailInvocations();
            System.assertEquals(expectedLimits, actualLimits, 'wrong limits before');
            propid.add(newProposal.id);
            
            // Process test
            Digital_PostAcceptAttachment.postAttachment(propid); 
    
            //assert after
            expectedLimits = 2;
            actualLimits = Limits.getEmailInvocations();
            System.assertEquals(expectedLimits, actualLimits, 'wrong limits after');
            Test.stopTest();
        }   
    }
    
  
    @isTest static void testPostAttach2() {
        User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,FirstName='test',LastName = 'user',Email = 'test.user@mailinator.com',Username = 'test.userrdxr@mailinator.cxd4.com',CompanyName = 'TEST',
            Title = 'title',Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
        System.runAs(u) {

            Apttus_Proposal__Proposal__c newQuote = [Select id from Apttus_Proposal__Proposal__c  LIMIT 1];
    
            Apttus_Proposal__Proposal_Line_Item__c lineItem = [Select id from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =:newQuote.id LIMIT 1 ];
            lineItem.Apttus_QPConfig__IsOptionRollupLine__c =  false;
            lineItem.Apttus_QPConfig__LineStatus__c = 'Cancelled';   
            lineItem.APTS_Yearly_Total__c = 100;
            update lineItem; 
            // set apprval date and signed date to trigger creation of new attachment       
            Test.startTest(); 
            list<Apttus_Proposal__Proposal__c>  lisQuotes = new List<Apttus_Proposal__Proposal__c >();
            //newQuote.Apttus_Proposal__Approval_Stage__c = 'Accepted';
            newQuote.Apttus_Proposal__Primary__c = true;
            newQuote.Digitally_Signed_Date__c = system.now();
            newQuote.Digital_Batch_Processed__c = true;
            lisQuotes.add(newQuote);
            
            update lisQuotes;
            //assert before
            Integer expectedLimits = 0; // no emails
            Integer actualLimits = Limits.getEmailInvocations();
            System.assertEquals(expectedLimits, actualLimits, 'wrong limits before');
            Test.stopTest();
        } 
    }
    
/*   
    // test for NSE emails
    @isTest static void testPostAttachNewSalesEmail() {
        User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,FirstName='test',LastName = 'user',Email = 'test.user@mailinator.com',Username = 'test.userrdxr@mailinator.cxd5.com',CompanyName = 'TEST',
            Title = 'title',Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
        System.runAs(u) {
            
        Test.startTest();
        // set Opportunity to New Sales
        list<Opportunity> oppList = [Select id from Opportunity LIMIT 1 ];
        oppList[0].Is_Digital_New_Sales__c = true;
        update oppList;
        
        // list of proposal ids for running test    
        list<id> propid = new list<id>();
        list<Apttus_Proposal__Proposal__c> lstProposals = new list<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c newQuote = [Select id,is_Digital_Channel__c,Is_Digital_New_Sales__c,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Account__c,Digitally_Signed_Date__c,APTS_Order_Confirmation_Contact__c,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Opportunity__r.stageName   
                                                from Apttus_Proposal__Proposal__c  LIMIT 1];
        system.debug(LoggingLevel.ERROR, 'test*******' + newQuote);
        
        Apttus_Proposal__Proposal_Line_Item__c lineItem = [Select id from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =:newQuote.id LIMIT 1 ];
        lineItem.Apttus_QPConfig__LineStatus__c ='New';
        update lineItem;  

        // We will be setting the approval stage for accepted
        Apttus_Proposal__Proposal__c newProposal = new Apttus_Proposal__Proposal__c(Id = newQuote.Id);
        //newProposal.Apttus_Proposal__Approval_Stage__c = 'Accepted';
        newProposal.Apttus_Proposal__Primary__c = true;
        newProposal.Digitally_Signed_Date__c = system.now();
        newProposal.Digital_Batch_Processed__c = true; 
        system.debug(LoggingLevel.INFO, 'Test lisQuotes > ' + newProposal);
        lstProposals.add(newProposal);
        // update both proposals
        update lstProposals;
        
        //assert before
        Integer expectedLimits = 1;
        Integer actualLimits = Limits.getEmailInvocations();
        System.assertEquals(expectedLimits, actualLimits, 'wrong limits before');
        propid.add(newProposal.id);
        // process test
        Digital_PostAcceptAttachment.postAttachment(propid); 
        //Digital_PostAcceptAttachment.sendEmailNewOrder(newContact.id,newQuote.id);
        //assert after
        expectedLimits = 2;
        actualLimits = Limits.getEmailInvocations();
        System.assertEquals(expectedLimits, actualLimits, 'wrong limits after');
        Test.stopTest();        }
    }
*/    
    
    
    // test for invalid Renewal order confirmation contact
    @isTest static void testInactiveContact() { 
        
        User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,FirstName='test',LastName = 'user',Email = 'test.user@mailinator.com',Username = 'test.userrdxr@mailinator.cxd5.com',CompanyName = 'TEST',
            Title = 'title',Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
        System.runAs(u) {
                
            // list of proposal ids for running test    
            list<id> propid = new list<id>();
            
            list<Opportunity> oppList = [Select id from Opportunity LIMIT 1];
            oppList[0].isDigitalSpearHead__c = true;
            update oppList;
            
            Contact newContact = [Select id, Contact_Inactive__c, EmailBouncedReason from Contact limit 1];
            newContact.Contact_Inactive__c  = true;
            newContact.EmailBouncedReason = 'Bounced Email Test'; 
            update newContact;
            
            list<Apttus_Proposal__Proposal__c> newQuote = [Select id from Apttus_Proposal__Proposal__c  LIMIT 1];       
                
            // set apprval date and signed date to trigger creation of new attachment       
            Test.startTest(); 
    
            //newQuote[0].Apttus_Proposal__Approval_Stage__c = 'Accepted';
            newQuote[0].Apttus_Proposal__Primary__c = true;
            newQuote[0].Digitally_Signed_Date__c = system.now();
            newQuote[0].Digital_Batch_Processed__c = true;
            newQuote[0].APTS_Order_Confirmation_Contact__c = newContact.Id;
            update newQuote;
            propid.add(newQuote[0].Id);
            
            // Process test
            Digital_PostAcceptAttachment.postAttachment(propid); 
                    
            Integer expectedLimits = 2;
            Integer actualLimits = Limits.getEmailInvocations();
            System.assertEquals(expectedLimits, actualLimits, 'wrong limits before');   
            
            Test.stopTest();
        }
    }
    
    
    // test for NSE emails
    @isTest static void testPostAttachEmail() {
        
        User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,FirstName='test',LastName = 'user',Email = 'test.user@mailinator.com',Username = 'test.userrdxr@mailinator.cxd5.com',CompanyName = 'TEST',
            Title = 'title',Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
        System.runAs(u) {  
            
        Test.startTest();  
        // select proposals for create NSE Emails 
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = [Select Apttus_Proposal__Proposal__c,
                Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.Apttus_Proposal__Proposal_Name__c,
                Apttus_Proposal__Proposal__r.Digitally_Signed_Date__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact_Name__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact_Email__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__r.Contact_Inactive__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__r.IsEmailBounced,
                Apttus_Proposal__Proposal__r.Owner.Email, Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.name,
                Apttus_Proposal__Proposal__r.APTS_Sold_To_SAP_Account_Number__c, Apttus_Proposal__Product__r.name,
                Apttus_Proposal__Proposal__r.APTS_Incremental__c, Apttus_Proposal__Proposal__r.APTS_Renewal__c,
                Apttus_QPConfig__LineStatus__c, APTS_Contract_Term__c, Apttus_Proposal__Product__r.Subscription_Number__c,
                Apttus_Proposal__Proposal__r.Is_Digital_New_Sales__c,
                Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Owner.Email,
                Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c,
                Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c               
                from Apttus_Proposal__Proposal_Line_Item__c where Apttus_QPConfig__LineStatus__c != 'Cancelled' limit 1];
        
        //assert before
        Integer expectedLimits = 0;
        Integer actualLimits = Limits.getEmailInvocations();
        System.assertEquals(expectedLimits, actualLimits, 'wrong limits before');
        //propid.add(newProposal.id);
        
        // process test
        Digital_PostAcceptAttachment.createNSEEmail(proposalLineItem);
        
        //assert after
        expectedLimits = 0;
        actualLimits = Limits.getEmailInvocations();
        System.assertEquals(expectedLimits, actualLimits, 'wrong limits after');
        Test.stopTest();        
        }
    }
            
            
    // test for exception processing
    @isTest static void testExceptions() {

        Test.startTest();  
        // create exception records
        list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
        Digital_Exception_Log__c deLog1 = new Digital_Exception_Log__c();
        deLog1.Exception_Message__c = 'Error Message';
        deLog1.Exception_Type__c = 'Record Update Error: Id - Test';
        deLog1.Additional_Information__c = 'Additional Error Text';            
        deLog1.User_Message__c = 'User Message';
        deLog1.Class_Reference__c = 'Test Class';
        Digital_Exception_Log__c deLog2 = new Digital_Exception_Log__c();
        deLog2.Exception_Message__c = '2 Error Message';
        deLog2.Exception_Type__c = '2 Record Update Error: Id - Test';
        deLog2.Additional_Information__c = '2 Additional Error Text';            
        deLog2.User_Message__c = '2 User Message';
        deLog2.Class_Reference__c = 'Test Class';
        exList.add(deLog2); 
        
        //assert before
        Integer expectedLimits = 0;
        Integer actualLimits = Limits.getEmailInvocations();
        System.assertEquals(expectedLimits, actualLimits, 'wrong limits before');

        // process test creation request
        Digital_PostAcceptAttachment.insertExceptionLogs(exList);
        
        //assert after
        expectedLimits = 0;
        actualLimits = Limits.getEmailInvocations();
        System.assertEquals(expectedLimits, actualLimits, 'wrong limits after');
        Test.stopTest();        
    }
    
}