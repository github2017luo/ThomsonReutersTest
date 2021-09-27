/*
======================================================================================================================
TEST CLASS NAME: Contact_Count_Quote_controller_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the Contact_Count_Quote_controller class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@isTest
public class Contact_Count_Quote_controller_Test{
    static testmethod void testLogicForEBillingContactCount(){
        UnitTest.createTestData();
       
        //Preparing String Label
        String strLabel = 'abcdefghxyz';
        
        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
        INSERT objAcc;
        
        //Preparing Opportunity data 
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        INSERT objOpp;
        
        //Preparing Quote data
        Quote objQty = new Quote();
        objQty.Name = 'Test Quote';
        objQty.Status = 'Draft';
        objQty.OpportunityId = objOpp.Id;
        // objQty.AccountId = objAcc.Id;
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();   
        INSERT objQty;
        
        //Preparing Contact data
        Contact objCon = UnitTest.getContactInstance(objAcc.Id);
        objCon.AccountId = objAcc.Id;
        objCon.Role_s__c = 'SAP_Z6_E-Bill Email Contact';
        INSERT objCon;
        
        
        AggregateResult[] lstCont = [SELECT AccountId, Count(Id) count1
                                     FROM Contact
                                     WHERE AccountId =: objQty.AccountId 
                                     AND Role_s__c =: 'SAP_Z6_E-Bill Email Contact' 
                                     GROUP BY AccountId]; 
        
        Test.startTest(); 
        
        PageReference pageRef = Page.EBillingContactCount;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',objQty.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(objQty);
        Contact_Count_Quote_controller objccQc = new Contact_Count_Quote_controller(controller);
        objccQc.Contact_Count();
        Contact objCon1 = UnitTest.getContactInstance(objAcc.Id);
        objCon1.AccountId = objAcc.Id;
        objCon1.Role_s__c = 'SAP_Z6_E-Bill Email Contact';
        INSERT objCon1;
        objccQc.Contact_Count();
        delete objcon1;
        delete objcon;
         objccQc.Contact_Count();
        Test.stopTest();
    }
}