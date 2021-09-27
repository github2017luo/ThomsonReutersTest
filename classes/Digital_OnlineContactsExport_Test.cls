/**
 * Test class for Digital_OnlineContactsController.onlineContactsExcel()
 * Test process that creates a new attachment for Product User Details
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2019-07-18   Brenda Shields          DLT-18088 - update to testdata    
   2021-01-15   Kavya S                 DLT-21271 - update to testdata                              
 * =============================================================================
 */
@isTest
public class Digital_OnlineContactsExport_Test {
    
    @testSetup static void init(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Test.StopTest();
    }
    
    static testMethod void processController() {
        
        Opportunity oOpp = [select id, isDigitalSpearHead__c from Opportunity limit 1];
     List<Apttus_Proposal__Proposal__c> oQuote = [Select id, Name,Digital_Ready_Online_Export__c 
            from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c = : oOpp.Id];
        for(Apttus_Proposal__Proposal__c proposal:oQuote)
        {
            proposal.Digital_Ready_Online_Export__c=TRUE;
         }
        
        update oQuote;
     //DLT-21271- Update to reteirve the records
     
        Test.startTest();
        Digital_OnlineContactsExport obj = new Digital_OnlineContactsExport();
        try {
            DataBase.executeBatch(obj);
        } catch(Exception ex) {
        }

        Test.stopTest();
        // check to see if the attachment has been created
        List<Attachment> lstAttach = [SELECT Id, Name 
                    FROM Attachment WHERE ParentId = : oQuote[0].id];
        // system.assert((lstAttach.isEmpty()), 'Attachment not created');
    }
    
        
    static testMethod void testAttachmentCreated() {

        Opportunity oOpp = [select id, isDigitalSpearHead__c from Opportunity limit 1];
        oOpp.isDigitalSpearHead__c = true;
        update oOpp;
        
        Apttus_Proposal__Proposal__c oQuote = [Select id, Name 
            from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c = : oOpp.Id limit 1];
        oQuote.Digital_Batch_Processed__c = true;
        oQuote.Digital_Quote_Type__c = 'Best Value';
        oQuote.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
        oQuote.Digital_Ready_Online_Export__c = true;
        update oQuote;
                    
                    
        Test.startTest();
        Digital_OnlineContactsController oCon = new Digital_OnlineContactsController();
        Digital_OnlineContactsController.onlineContactsExcel(oQuote.id, oQuote.name);

        Test.stopTest();
        // check to see if the attachment has been created
        List<Attachment> lstAtt = [SELECT Id, Name 
                    FROM Attachment WHERE ParentId = : oQuote.id];
        system.assert(!(lstAtt.isEmpty()), 'Attachment failed to be created');
        
    }
    

    static testMethod void testAttachmentUpdated() {

        Opportunity oOpp = [select id, isDigitalSpearHead__c from Opportunity limit 1];
        oOpp.isDigitalSpearHead__c = true;
        update oOpp;
        
        Apttus_Proposal__Proposal__c oQuote = [Select id, Name 
            from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c = : oOpp.Id limit 1];
        oQuote.Digital_Batch_Processed__c = true;
        oQuote.Digital_Quote_Type__c = 'Best Value';
        oQuote.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
        oQuote.Digital_Ready_Online_Export__c = true;
        update oQuote;
                    
        // create attachment for the quote
        //DCTestData.createAttachment(oQuote.id);
        //DCTestData.createFileAttachment(oQuote.id);  
        // build a Content Version record which will also create a Content Document record
        Attachment oNewAttach = new Attachment();
        oNewAttach.ContentType = 'application/pdf'; 
        oNewAttach.Name = oQuote.Name + ' ' + System.Label.OCFileName; 
        oNewAttach.Body = Blob.ValueOf('123');
        oNewAttach.ParentId = oQuote.id;
        insert oNewAttach;
        
        Test.startTest();
        Digital_OnlineContactsController oCon = new Digital_OnlineContactsController();
        Digital_OnlineContactsController.onlineContactsExcel(oQuote.id, oQuote.name);

        Test.stopTest();
        // check to see if the attachment has been updated
        List<Attachment> lstAttach = [SELECT Id, Name 
                    FROM Attachment WHERE ParentId = : oQuote.id];
        system.assert(!(lstAttach.isEmpty()), 'Attachment not created'); 
        
    }
}