/*
Process Builder Test Class - LatAm_Update_Manager_Of_Reservation_Manager
===============================================================================
*/

@istest 
public class LatAmUpdateMngrOfReservationMngr_Test{
    
    public static testMethod void test1(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        User u1 = new User(alias = 'newUser', email='user@mydomain.com',
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random());
        insert u1;
        
        User u2 = new User(alias = 'newUser', email='user2@mydomain.com',ManagerId =u1.id,
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                           localesidkey='en_US', profileid = p.Id, employeenumber='014224020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random());
        insert u2;
        
        UnitTest.createTestData();
        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
        INSERT objAcc;
        
        //Preparing Product data
        Product2 objProd=UnitTest.getProductInstance();
        objProd.IsActive = true;
        objProd.Entitlement_Oneshot__c = true;
        INSERT objProd;
        
        //Preparing PricebookEntry data
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd.id,unitprice=200);
        INSERT testEntry;

        //Preparing Opportunity data
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        objOpp.Renewal_Flag__c = true;
        objOpp.Pricebook2Id = Test.getStandardPricebookId();
        objOpp.Quote_Payment_Method_Terms_Updated__c=true;
        INSERT objOpp;
        
        //Preparing OpportunityLineItem data
        OpportunityLineItem objOLI = new OpportunityLineItem(opportunityId=objOpp.id,PricebookEntryId=testEntry.id,unitprice=200,Quantity=1, Revenue_Type__c ='Renewal');
        objOLI.OpportunityId = objOpp.Id;                
        INSERT objOLI;
        
        //Preparing Quote data
        Quote objQty = new Quote();
        objQty.Name = 'Test Quote';
        objQty.Status = 'Draft';
        objQty.OpportunityId = objOpp.id;
        objQty.Pricebook2Id = Test.getStandardPricebookId();
        objQty.Approval_Status__c = 'Cancellation Approved';
        objqty.Primary_Quote__c = true;
        objqty.Short_Term_Sub__c =false;
        objQty.Reservation_Manager__c=u2.Id;
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId(); 
        objqty.Win_Loss__c='Won';
        INSERT objQty;
        
        System.assertEquals(true, objQty.Id!= null);
    }
    public static testmethod void test(){
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        User u1 = new User(alias = 'newUser', email='user@mydomain.com',
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random());
        insert u1;
        
        User u2 = new User(alias = 'newUser', email='user2@mydomain.com',ManagerId =u1.id,
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                           localesidkey='en_US', profileid = p.Id, employeenumber='014224020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random());
        insert u2;
        
        UnitTest.createTestData();
        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
        INSERT objAcc;
        
        //Preparing Product data
        Product2 objProd=UnitTest.getProductInstance();
        objProd.IsActive = true;
        objProd.Entitlement_Oneshot__c = true;
        INSERT objProd;
        
        //Preparing PricebookEntry data
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd.id,unitprice=200);
        INSERT testEntry;

        //Preparing Opportunity data
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        objOpp.Renewal_Flag__c = true;
        objOpp.Pricebook2Id = Test.getStandardPricebookId();
        objOpp.Quote_Payment_Method_Terms_Updated__c=true;
        INSERT objOpp;
        
        //Preparing OpportunityLineItem data
        OpportunityLineItem objOLI = new OpportunityLineItem(opportunityId=objOpp.id,PricebookEntryId=testEntry.id,unitprice=200,Quantity=1, Revenue_Type__c ='Renewal');
        objOLI.OpportunityId = objOpp.Id;                
        INSERT objOLI;
        
        //Preparing Quote data
        Quote objQty = new Quote();
        objQty.Name = 'Test Quote';
        objQty.Status = 'Draft';
        objQty.OpportunityId = objOpp.id;
        objQty.Pricebook2Id = Test.getStandardPricebookId();
        objQty.Approval_Status__c = 'Cancellation Approved';
        objqty.Primary_Quote__c = true;
        objqty.Short_Term_Sub__c =false;
        objQty.Reservation_Manager__c=u2.Id;
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId(); 
        objqty.Win_Loss__c='Won';
        INSERT objQty;
        
        System.assertEquals(true, objQty.Id!= null);
    }
}