/**
 * Validates the functionality provided by the EmailQuoteAttachments class.
 *
 * @author  Sujana Vechalapu
 * @version  2016-04-19
 */

 @IsTest(seealldata=true)
 public class EmailQuoteAttachmentsTest{
 
     public static testmethod void SendAttachments(){
         
     RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Customer' Limit 1];
     RecordType rt2 = [select id,Name from RecordType where SobjectType='Opportunity' and Name='Pipeline Opportunity' Limit 1];
     
     Account acc= UnitTest.getAccountInstance();
     acc.RecordTypeId= rt.Id;
     acc.Sales_Org__c = 'WEST';
     acc.Customer_Group__c = 'ACADEMIC';
     acc.Customer_Class_c__c = 'None';    
     acc.Customer_Type__c = 'Organization';
     acc.BillingCountry = 'US';
     acc.BillingCity = 'EAGAN';
     insert acc;
     
     Opportunity opp1 = UnitTest.getOpportunityInstance(acc.Id);
     insert opp1;
     opp1.StageName = '75%';
     opp1.Business_Unit__c= 'Mastersaf';
     opp1.Sales_Org__c = 'TSL';
     opp1.RecordTypeId = rt2.Id;
     update opp1;
        
        
     Quote Q1 = New Quote ();
     Q1.OpportunityId = opp1.id;
     Q1.Name = 'Test Quote';    
     Q1.Status = 'In Review';
     Q1.Primary_Quote__c = true;
     Q1.Pricing_Approval_Required__c = true;
     Insert Q1;
     
     
     Attachment att = new Attachment();
     att.ParentId = Q1.id;
     att.Name = 'Test Tarifador';
     Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body');
     att.body = bodyBlob1;
     insert att;
     
     List<Attachment> attachments=[select id, name from Attachment where parent.id=:Q1.id]; 
     attachments.add(att);
     
     EmailQuoteAttachments eq = new EmailQuoteAttachments();
     eq.fetchAttachment();     
     System.assertEquals('Test Tarifador', attachments[0].Name);   
     
     eq.getatId();
     eq.getAttName();
     String atId = '09432';
     eq.setatId(atId);
     String name = 'styh';
     eq.setAttName(name);     
    }
 
 }