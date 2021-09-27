/*
===============================================================================
BillingAccountSplitTriggerHandler_Test 
===============================================================================

PURPOSE:      Contains all the testMethods for BillingAccountSplitTriggerHandler.cls

FUNCTIONALITY:

COMMENTS:
CHANGE HISTORY
===============================================================================
DATE         NAME           DESC
2016-06-02   TCS Offshore      Created 
===============================================================================
*/

@istest(seeAllData = true)
public class BillingAccountSplitTriggerHandler_Test {

     public static testmethod void afterUpdate_Test(){
        /*RecordtypeIds__c orecordType4 = new RecordtypeIds__c ();
        orecordType4.name ='Customer';
        orecordType4.recTypeId__c = '01230000001MA4a';
        insert orecordType4; */
             
        Account TestAccount = UnitTest.getAccountInstance();
        TestAccount.SAPAccountNumber__c = '1234567890';
       // TestAccount.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
        TestAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Insert TestAccount;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testProd1.name='Books2';
        insert testProd1;
       
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=1);
        insert testEntry1;
        
   /*     Product2 testProd2 =UnitTest.getProductInstance();
        testProd2.name='Books2';
        insert testProd2;
       
        PricebookEntry testEntry2 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd2.id,unitprice=1);
        insert testEntry2;
        
        Product2 testProd3 =UnitTest.getProductInstance();
        testProd3.name='Books2';
        insert testProd3;
       
        PricebookEntry testEntry3 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd3.id,unitprice=1);
        insert testEntry3; */
        
       
        List<Opportunity> lstOppty = new List<Opportunity>();
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);             
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Is_Master_Opportunity__c = true;
        opp1.Oppty_Mgmt_Type__c = 'Split Billing';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        lstOppty.add(opp1);
        //insert opp1;
         
     /*   OpportunityLineItem testLineItem2 = new OpportunityLineItem(quantity=1,totalprice=10,opportunityId=opp1.id,PricebookEntryId=testEntry2.id);
        insert testLineItem2; 
        OpportunityLineItem testLineItem3 = new OpportunityLineItem(quantity=1,totalprice=10,opportunityId=opp1.id,PricebookEntryId=testEntry3.id);
        insert testLineItem3;  */
       
        Opportunity opp2 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp2.StageName = '50%';
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Competitor_Name__c = 'BloomBerg';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test';
        opp2.Is_Master_Opportunity__c = false;
        //opp2.Master_Opportunity__c = opp1.id;
        opp2.Oppty_Mgmt_Type__c = 'Split Billing';
        opp2.Description='Tst';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        lstOppty.add(opp2);
        insert lstOppty;
        //insert opp2;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(quantity=1,totalprice=10,opportunityId=opp1.id,PricebookEntryId=testEntry1.id);
        insert testLineItem1;
        
        opp2.Master_Opportunity__c = opp1.id;
        update opp2;
        
      /*  OpportunityLineItem testLineItem = new OpportunityLineItem(quantity=1,totalprice=10,opportunityId=opp2.id,PricebookEntryId=testEntry2.id);
        insert testLineItem;*/
        
        List<Contact> lstCont = new list<Contact>(); 
        Contact testCon = new Contact();
        testCon = UnitTest.getContactInstance(TestAccount.id);
        testCon.SAP_Contact_ID__c = '';
        testCon.Work_Direct__c = '1234567890';
        testCon.Email = 'abc@kmail.com';
        lstCont.add(testCon);
        
        Contact testCon1 = new Contact();
        testCon1 = UnitTest.getContactInstance(TestAccount.id);
        testCon1.SAP_Contact_ID__c = '';
        testCon1.Work_Direct__c = '9876543210';
        testCon1.Email = 'xyz@kmail.com';
        lstCont.add(testCon1);
        
        INSERT lstCont;
        
             
        Billing_Account_Split__c bas = new Billing_Account_Split__c();
        bas.Account__c = TestAccount.id;
        bas.Master_Opportunity__c = opp1.id;
        bas.Child_Opportunity__c = opp2.id;
        bas.PO_Number__c = '12345';
        bas.Invoice_Notes__c = 'Testing';
        bas.E_Billing_Contact__c = testCon.id;
        bas.Boleto_Contact__c = testCon.id;
        bas.Opportunity_Notes__c='Testing';
        bas.Product_1__c = testProd1.id;
        bas.Product_1_Sales_Price__c =23.4; 
        bas.Product_2__c = testProd1.id;
        bas.Product_2_Sales_Price__c =45.6;
        bas.Product_3__c = testProd1.id;
        bas.Product_3_Sales_Price__c =23.5; 
        
        INSERT bas;
        
        
       System.AssertEquals(bas.PO_Number__c ,'12345');
       System.AssertEquals(bas.Invoice_Notes__c ,'Testing');
       System.AssertEquals(bas.Opportunity_Notes__c,'Testing');
       System.AssertEquals(bas.Boleto_Contact__c ,testCon.id);
       System.AssertEquals(bas.E_Billing_Contact__c,testCon.id);
       System.AssertEquals(bas.Product_1_Sales_Price__c , 23.4);
       System.AssertEquals(bas.Product_2_Sales_Price__c , 45.6);
       System.AssertEquals(bas.Product_3_Sales_Price__c , 23.5);
        
        List<Quote> listQuote = new List<Quote>();
        Quote Q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = 'Quote Rejected';
        Q1.Primary_Quote__c = true;
        Q1.Is_Master_Quote__c = false;
        listQuote.add(Q1);
        //insert Q1;
        
        Quote Q2 = New Quote ();
        Q2.OpportunityId = opp2.id;
        Q2.Name = 'Test Quote';
        Q2.Approval_Status__c = 'Quote Rejected';
        Q2.Primary_Quote__c = true;
        Q2.Is_Master_Quote__c = false;
        //Q2.Master_Quote__c = Q1.id;
        listQuote.add(Q2);
        insert listQuote; 
        
        Q2.Master_Quote__c = Q1.id;
        Q1.Is_Master_Quote__c = true;
        listQuote = new List<Quote>();
        listQuote.add(Q1);
        listQuote.add(Q2);
        update listQuote;
        
        List<OpportunityContactRole> lstOPCR = new list<OpportunityContactRole>();
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp1.id,contactid=testcon.id,IsPrimary=true);
        OpportunityContactRole ocr2 = new OpportunityContactRole(opportunityid=opp1.id,contactid=testcon1.id,IsPrimary=false);
        OpportunityContactRole ocr3 = new OpportunityContactRole(opportunityid=opp2.id,contactid=testcon.id,IsPrimary=true);
        OpportunityContactRole ocr4 = new OpportunityContactRole(opportunityid=opp2.id,contactid=testcon1.id,IsPrimary=false);
        lstOPCR.add(ocr1);
        lstOPCR.add(ocr2);
        lstOPCR.add(ocr3);
        lstOPCR.add(ocr4);
        insert lstOPCR;
        
        Test.StartTest();
        
        bas.PO_Number__c = '123456';
        bas.Invoice_Notes__c ='Testing';
        bas.Opportunity_Notes__c='Testing';
        bas.E_Billing_Contact__c = testCon.id;
        bas.Boleto_Contact__c = testCon.id;
        bas.Product_1_Sales_Price__c = 23.5;
     //   bas.Product_2_Sales_Price__c = 45.6;
     //   bas.Product_1_Sales_Price__c =23.6;
        bas.PO_Number__c = '123456';
        bas.Invoice_Notes__c = 'Testing1';
        bas.E_Billing_Contact__c = testCon.id;
        bas.Boleto_Contact__c = testCon.id;
        bas.Opportunity_Notes__c='Testing';
        //bas.Product_1__c = testProd1.id;
        bas.Product_1_Sales_Price__c =23.6; 
        //bas.Product_2__c = testProd1.id;
        bas.Product_2_Sales_Price__c =45.5;
        //bas.Product_3__c = testProd1.id;
        bas.Product_3_Sales_Price__c =23.4; 
        UPDATE bas;
        
        delete lstOPCR;
        
        bas.PO_Number__c = '123456';
        bas.Invoice_Notes__c = 'Testing1';
        bas.E_Billing_Contact__c = testCon1.id;
        bas.Boleto_Contact__c = testCon1.id;
        bas.Opportunity_Notes__c='Testing1';
        //bas.Product_1__c = testProd1.id;
        bas.Product_1_Sales_Price__c =23.6; 
        //bas.Product_2__c = testProd1.id;
        bas.Product_2_Sales_Price__c =45.5;
        //bas.Product_3__c = testProd1.id;
        bas.Product_3_Sales_Price__c =23.4; 
        UPDATE bas;
        //UPDATE opp2;
        
        Test.StopTest();
    }
    public static testmethod void beforeDelete_Test(){
                    
       Account TestAccount = UnitTest.getAccountInstance();
        TestAccount.SAPAccountNumber__c = '1234567890';
        TestAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Insert TestAccount;
        
        List<Opportunity> listOpportunity = new List<Opportunity>();
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);             
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        //opp1.Is_Master_Opportunity__c = true;
        opp1.Oppty_Mgmt_Type__c = 'Split Billing';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        insert opp1;
        
        /*Opportunity opp2 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp2.StageName = '50%';
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Competitor_Name__c = 'BloomBerg';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test';
        opp2.Is_Master_Opportunity__c = false;
        opp2.Master_Opportunity__c = opp1.id;
        opp2.Oppty_Mgmt_Type__c = 'Split Billing';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        insert opp2;*/
      
        Contact testCon = new Contact();
        testCon = UnitTest.getContactInstance(TestAccount.id);
        testCon.SAP_Contact_ID__c = '';
        testCon.Work_Direct__c = '1234567890';
        testCon.Email = 'abc@gmail.com';
        INSERT testCon;
        
        Contact objBolCon = new Contact();
        objBolCon = UnitTest.getContactInstance(TestAccount.id);
        objBolCon.SAP_Contact_ID__c = '';
        objBolCon.Work_Direct__c = '8234567890';
        objBolCon.Email = 'test1user@tcs.com';
        INSERT objBolCon;
                
        List<Quote> listQuote = new List<Quote>();
        Quote Q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = '';
        Q1.Primary_Quote__c = true;
        Q1.Is_Master_Quote__c = false;
        insert Q1;
        
        /*Quote Q2 = New Quote ();
        Q2.OpportunityId = opp2.id;
        Q2.Name = 'Test Quote';
        Q2.Approval_Status__c = '';
        Q2.Primary_Quote__c = true;
        Q2.Is_Master_Quote__c = false;
        Q2.Master_Quote__c = Q1.id;
        insert Q2;*/
        
        
        Billing_Account_Split__c bas = new Billing_Account_Split__c();
        bas.Account__c = TestAccount.id;
        bas.Master_Opportunity__c = opp1.id;
        //bas.Child_Opportunity__c = opp2.id;
        bas.PO_Number__c = '12345';
        bas.Invoice_Notes__c = 'Testing';
        bas.E_Billing_Contact__c = testCon.id;
        bas.Boleto_Contact__c = objBolCon.Id;
        INSERT bas;
        
        Test.StartTest();
        try {
            DELETE bas;
        } catch (Exception e) {
            system.assertEquals('You can\'t delete this record!', e.getMessage());
        }
        
        
        Test.StopTest();
    }
    
      
}