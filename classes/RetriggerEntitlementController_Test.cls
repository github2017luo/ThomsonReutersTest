/********************************************************************************************
    ClassName: RetriggerEntitlementController_Test
    Description: Class test the code of class "RetriggerEntitlementController".
    CreatedBy:  
    CreatedDate:
    LastModifiedBy: 
    LastModifiedDate: 
    Reason for Change:
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
@isTest
private class RetriggerEntitlementController_Test{
        static testMethod void testRetriggerEntitlement(){
        
         /*User u = new User();
         u.Name='ABC';
         Insert u;*/    
        
        //Creating referrence for VF page
        PageReference pageRef = Page.RetriggerEntitlementPage; 
        Test.setCurrentPage(pageRef);
        
        //Create User Group 
        Group testGroup = new Group();
        testGroup.DeveloperName = 'Proview';
        testGroup.Name= 'ABC';
        INSERT testGroup;
      
        
        UnitTest.createTestData();
        List<Account> lstAcc = new List<Account>();
        Account TestAccount = UnitTest.getAccountInstance();
        lstAcc.add(TestAccount);
        
        Account TestAccount1 = UnitTest.getAccountInstance();
        lstAcc.add(TestAccount1);
        Insert lstAcc;
        
        //Create Opportunity Data
        // List<Opportunity> lstOpp = new List<Opportunity>();
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Is_Master_Opportunity__c = true;
        opp1.Oppty_Mgmt_Type__c = 'Split Billing';
        opp1.Child_Amount_Subtotal_Variance__c =20.0;
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        //opp1.Entitlement_Path__c='Pre Order';
        //opp1.Entitlement_Ready__c=true;
        INSERT opp1;
        
        
        //Create Quote Data
        Quote Q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = 'Quote Rejected';
        Q1.Primary_Quote__c = true;
        Q1.Is_Master_Quote__c = true;
        Q1.Order_Source__c = '01 Phone';
        Q1.Purchase_Order_Date__c = System.today();
        Q1.Revenue_Channel__c = '01 Sales Rep';
        Q1.Payer_Customer_Name__c = TestAccount.id;
        Q1.Bill_To_Customer_Name__c = TestAccount.id;
        Q1.Bank__c = 'BANCO BICE';
        Q1.Bank_Account_Num__c = '123456789';
        Q1.Invoice_Notes__c = 'abc';
        Q1.Shipping_Notes__c = 'abc';
        Q1.Revenue_Type__c = 'New';      
        Q1.Entitlement_Status__c='FAILURE';
        Q1.Entitlement_Complete__c=false;
        Q1.Entitlement_Generated__c=true;
        Q1.Entitlement_Path__c='Pre Order';
        Insert Q1;
  
        Test.StartTest();
        //ApexPages.currentPage().getParameters().get('id');
        //RetriggerEntitlementController rec= new RetriggerEntitlementController();
        //rec.setProviewEntitlementCallOut();
        ApexPages.StandardController sc = new ApexPages.StandardController(Q1);
        RetriggerEntitlementController rec = new RetriggerEntitlementController(sc);
        rec.setProviewEntitlementCallOut();
        rec.showQuoteDetail();        
        
        Test.StopTest();
     }
}