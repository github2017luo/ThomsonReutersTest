/*
===============================================================================
QuoteTriggerHandler_Test
===============================================================================

PURPOSE:     Contains all the testMethods for QuoteTriggerHandler.cls

FUNCTIONALITY:

COMMENTS:
CHANGE HISTORY
===============================================================================
DATE         NAME       DESC
2016-03-22   Cirrius    Created
2017-03-31   Karthi     Optimized the coverage as per JIRA STORY: PS0-1
===============================================================================
*/

@istest (seeAllData=false)
public class QuoteTriggerHandler_Test {
  
   public static testmethod void UpdateQuoteFieldsFromOppotunity_Test(){
        UnitTest.createTestData();
        Account TestAccount = UnitTest.getAccountInstance();
        TestAccount.RecordTypeId=[Select Id From RecordType Where SobjectType = 'Account' and Name = 'Customer'].Id;
        Insert TestAccount;

        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        opp1.Child_Amount_Subtotal_Variance__c =20.0;
        opp1.Quote_Payment_Method_Terms_Updated__c=true;


        insert opp1;

        Quote Q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = 'Quote Rejected';
        Q1.Primary_Quote__c = true;
        Insert Q1;

        Test.StartTest();
            checkRecursive.isRenewalQuote = false;
            checkRecursive.isRenewalOpp = false;
            
            Quote Q2 = New Quote ();
            Q2.OpportunityId = opp1.id;
            Q2.Name = 'Test Quote';
            Q2.Approval_Status__c = 'Quote Rejected';
            Q2.Primary_Quote__c = false;
            Insert Q2;

            Quote QConfirm = [Select Id, Opportunity_Notes__c From Quote Where Id = :Q2.Id];
            System.assertEquals(opp1.Description, QConfirm.Opportunity_Notes__c);

            opp1.Description = 'Test 2';
            update opp1;

            QConfirm = [Select Id, Opportunity_Notes__c From Quote Where Id = :Q2.Id];
            System.assertNotEquals(opp1.Description, QConfirm.Opportunity_Notes__c);

            Q2.Primary_Quote__c = true;
            Update Q2;
            QConfirm = [Select Id, Opportunity_Notes__c From Quote Where Id = :Q2.Id];
            //System.assertEquals(opp1.Description, QConfirm.Opportunity_Notes__c);

        TestAccount.RecordTypeId=[Select Id From RecordType Where SobjectType = 'Account' and Name = 'Prospect'].Id;
        update TestAccount;
         Q2.Name = 'Test Quote1';
         update q2;
         
         
         
        Test.StopTest();

      }
      
      public static testmethod void UpdateQuoteFieldsFromOppotunity_Test1(){
        UnitTest.createTestData();
        List<Account> lstAcc = new List<Account>();
        List<Quote> qList = new List<Quote>();
        Account TestAccount = UnitTest.getAccountInstance();
        lstAcc.add(TestAccount);
        
        Account TestAccount1 = UnitTest.getAccountInstance();
        lstAcc.add(TestAccount1);
        Insert lstAcc;
        
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
        opp1.Sales_Org__c='LatAm';
        opp1.Renewal_Flag__c = true; //Karthi
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        opp1.Quote_Payment_Method_Terms_Updated__c=true;
       
        INSERT opp1;
       // lstOpp.add(opp1);
        
        Opportunity opp2 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp2.StageName = '50%';
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Competitor_Name__c = 'BloomBerg';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test1';
        opp2.Master_Opportunity__c = opp1.id;
        opp2.Oppty_Mgmt_Type__c = 'Split Billing';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        opp2.Child_Amount_Subtotal_Variance__c =20.0;
          opp2.Quote_Payment_Method_Terms_Updated__c=true;
          opp2.Amount=0;
        //lstOpp.add(opp2);
        System.assertEquals(opp2.Name__c, 'Test1');
        //INSERT lstOpp;
        INSERT opp2;
        
        contact con1=new contact(firstname='test',lastname='test',email='etst@te.com',accountId=TestAccount.id);
       // insert con1;
         contact con2=new contact(firstname='test',lastname='test',email='etst2@te.com',accountId=TestAccount.id);
       // insert con2;
        
        List<contact> conList = new List<contact>{con1,con2};
        insert conList;
        
        Product2 objProd1=UnitTest.getProductInstance();
             objProd1.IsActive = true;
             objProd1.Entitlement_Oneshot__c = true;
             INSERT objProd1;
        
        //Preparing PricebookEntry data
            PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd1.id,unitprice=20);
            INSERT testEntry1;
            
        
       // List<Quote> lstQuote = new List<Quote>();
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
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Bank_Account_Num__c = '123456789';
        Q1.Invoice_Notes__c = 'abc';
        Q1.Shipping_Notes__c = 'abc';
        Q1.Revenue_Type__c = 'New';
        Q1.Renewal_Options__c = 'Opt-In - Negotiable Renewal';
        Q1.Gross_Income_Tax_Number__c = 'Inscripto en Convenio Multilateral';
        Q1.Payment_Terms__c = ' BR18 - Brazil 18 installments';
        q1.SAP_IDOC_Number__c='12312312';
        q1.E_Billing_Contact__c=con1.id;
        Q1.Opportunity_Notes__c = 'abc';
        q1.LATAM_Renewal_Division__c='ewadase';
        q1.Bill_To_Contact__c=con1.Id;
        q1.Billing_Type__c='Quarterly';
        q1.OP_Owner__c=null;
        Insert Q1;
        //lstQuote.add(Q1);
        
        Test.startTest();
           
            QuoteLineItem Qli1 = new QuoteLineItem(QuoteId = Q1.Id,PricebookEntryId = testEntry1.Id,Status__c='Active',Discount=7.00,Revenue_Type__c ='Renewal',Quantity = 1,UnitPrice=20,Item_Activity_Type__c='New');
           // Insert Qli1;
            QuoteLineItem Qli2 = new QuoteLineItem(QuoteId = Q1.Id,PricebookEntryId = testEntry1.Id,Status__c='Active',Discount=7.00,Revenue_Type__c ='Renewal',Quantity = 1,UnitPrice=20,Item_Activity_Type__c='New');
            List<QuoteLineItem> QliList = new List<QuoteLineItem>{Qli1,Qli2};
            
            Insert QliList;
            OpportunityLineItem ol1= new OpportunityLineItem(OpportunityId=opp1.Id,PricebookEntryId = testEntry1.Id,Quantity=1,UnitPrice=20,Activity_Type__c='New');
           
        
         
         OpportunityContactRole OppContactRoleList1 =new OpportunityContactRole(role='E-Billing Contact',OpportunityId=opp1.id,ContactId=con1.id);
         insert OppContactRoleList1;
            Quote Q2 = New Quote ();
            Q2.OpportunityId = opp2.id;
            Q2.Name = 'Test Quote';
            Q2.Approval_Status__c = 'Quote Rejected';
            Q2.Primary_Quote__c = true;
            Q2.Master_Quote__c = Q1.id;
            //lstQuote.add(Q2);
            //INSERT lstQuote;
            Insert Q2;
        //Test.StopTest();
        
       // Test.StartTest();
            // Insert Qli2;
             insert ol1;
                    
            
            Q1.Approval_Status__c = 'Quote Approved';
            Q1.Payment_Method__c = 'Cash';
            Q1.Status = 'OP Rejected';
            Q1.Ship_To_Customer_Name__c = TestAccount1.id;
            Q1.Order_Source__c = '02 Fax';
            Q1.Purchase_Order_Date__c = System.today().adddays(1);
            Q1.Revenue_Channel__c = '04 Bookstore';
            Q1.Payer_Customer_Name__c = TestAccount1.id;
            Q1.Bill_To_Customer_Name__c = TestAccount1.id;
            Q1.Bank__c = 'BANCO B. I. CREDITANSTALT S.A.';
            Q1.Bank_Account_Num__c = '1234567890';
            Q1.Invoice_Notes__c = 'abcd';
            Q1.Shipping_Notes__c = 'abcd';
          
            Q1.Revenue_Type__c = 'Renewal';
            Q1.Renewal_Options__c = 'Evergreen - Automatic Renewal no notification';
            //Q1.Primary_Quote__c = false;
            Q1.Gross_Income_Tax_Number__c = 'Inscripto en Jurisdicción local';
            Q1.Payment_Terms__c = ' BR24 - Brazil 24 installments';
            
            Q1.TID_Number__c = '11112222333344445555';
            q1.Was_There_a_Competitor__c = 'No';
            //q1.Competitor_Name__c = 'BloomBerg';
            q1.Reason__c = 'Brand';
            q1.Additional_E_Billing_contact_emails__c =  'test@test.com';
            q1.Sold_To_Contact__c = con2.Id; 
            //q1.OP_Owner__c = 
            q1.Name = 'test';
            q1.Billing_Type__c = 'Annual';
            q1.Bill_To_Contact__c = con2.id;
            
            Update Q1;
            /*
            Q1.Payment_Terms__c = null;
            Q1.Payment_Method__c =null;
            Update Q1;
            
            Q1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c;
            Q1.Approval_Status__c = 'Pending Cancellation Approval';
            Update Q1;
            Q1.Approval_Status__c = 'Cancellation Approved';
            Update Q1;
            Q1.Approval_Status__c = 'Pending Cancellation Approval';
            Update Q1;
            Q1.Approval_Status__c = 'Cancellation Rejected';
            Update Q1;
            q1.Short_Term_Sub__c=False;
            Update Q1;
            q1.Primary_Quote__c=True;
            Q1.Short_Term_Sub__c=true;
            Update Q1;
            q1.Billing_Type__c='Annual';
           // Q1.Bill_To_Contact__c=con2.Id;
            update q1;
            Q1.Name = 'Test Quote12';
            update q1;
            Q1.Primary_Quote__c = False;
            update q1;
            Q1.OP_Owner__c=userinfo.getUserId();
            update q1;
            */
            q2.name='qwe';
            update q2;
            qList.add(q1);
            qList.add(q2);
            QuoteTriggerHandler.ValidateCreateToken(qList);
            
        Test.StopTest();

      }
      
      public static testmethod void RenewalQuoteSync_Test(){
        UnitTest.createTestData();
        //List<Account> lstAcc = new List<Account>();
        Account TestAccount = UnitTest.getAccountInstance();
     //   TestAccount.Name = 'Tester1233243423'+Math.random();
        INSERT TestAccount;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Renewal_Flag__c = TRUE;
        opp1.Account_Contact_Change_Indicator__c=false;
        opp1.Quote_Creation_Complete__c = true;
        // opp1.SyncedQuoteId
       // opp1.Is_Master_Opportunity__c = true;
        //opp1.Oppty_Mgmt_Type__c = 'Split Billing';
        opp1.Child_Amount_Subtotal_Variance__c =20.0;
        opp1.Expiration_Date__c = System.today().adddays(1);
        //opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        opp1.Quote_Payment_Method_Terms_Updated__c=true;
       
        INSERT opp1;
        
        List<Quote> qList=new List<Quote>();
        Quote Q1 = New Quote();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = TRUE;
        Q1.Competitor_Name__c = 'AccessData';
        Q1.Opportunity_Notes__c = 'abc';
        Q1.Payment_Terms__c = 'Cash';
        Q1.Payment_Method__c = '1 Installment';
         q1.Account_Contact_Change_Indicator__c=false;
       // Q1.Projected_Renewal_Price__c = 10;
        Q1.Reason__c = 'Brand';
        Q1.Was_There_A_Competitor__c = 'Yes';
        Q1.Win_Loss__c = 'Won';
        Q1.status='Sales Admin Pending Review';
        Q1.Primary_Quote__c=true;
        //Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        qList.add(Q1);
        
        opp1.SyncedQuoteId= q1.Id;
        update opp1;
         
        Quote Q2 = New Quote();
        Q2.OpportunityId = opp1.id;
        Q2.Name = 'Test Quote';
        Q2.Primary_Quote__c = TRUE;
        Q2.Competitor_Name__c = 'AccessData';
        Q2.Opportunity_Notes__c = 'abc';
        Q2.Payment_Terms__c = 'Cash';
        Q2.Payment_Method__c = '1 Installment';
       // Q1.Projected_Renewal_Price__c = 10;
        Q2.Reason__c = 'Brand';
        Q2.Was_There_A_Competitor__c = 'Yes';
        Q2.Win_Loss__c = 'Won';
        Q2.status='Submitted for Processing';
        //Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        Q2.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        qList.add(Q2);
        
        Quote Q3 = New Quote();
        Q3.OpportunityId = opp1.id;
        Q3.Name = 'Test Quote';
        Q3.Primary_Quote__c = TRUE;
        Q3.Competitor_Name__c = 'AccessData';
        Q3.Opportunity_Notes__c = 'abc';
        Q3.Payment_Terms__c = 'Cash';
        Q3.Payment_Method__c = '1 Installment';
       // Q1.Projected_Renewal_Price__c = 10;
        Q3.Reason__c = 'Brand';
        Q3.Was_There_A_Competitor__c = 'Yes';
        Q3.Win_Loss__c = 'Won';
        Q3.status='OP Rejected';
        //Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        Q3.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        qList.add(Q3);
        
        insert qList;
        
        List<LatamGeneral__c> lgList=new List<LatamGeneral__c>();
        
         LatamGeneral__c LG1= new LatamGeneral__c();
        LG1.Name='Submitted for Processing';
        LG1.Value__c = 'Submitted for Processing';
        lgList.add(LG1);
        
        LatamGeneral__c LG2= new LatamGeneral__c();
        LG2.Name='Sales Admin Pending Review';
        LG2.Value__c = 'Sales Admin Pending Review';
         lgList.add(LG2);
        
        LatamGeneral__c LG3= new LatamGeneral__c();
        LG3.Name='OP Rejected';
        LG3.Value__c = 'OP Rejected';
         lgList.add(LG3);
        
         LatamGeneral__c LG4= new LatamGeneral__c();
        LG4.Name='Opp Stage 95';
        LG4.Value__c = '95%';
         lgList.add(LG4);
        
        LatamGeneral__c LG5= new LatamGeneral__c();
        LG5.Name='Opp Stage 90';
        LG5.Value__c = '90%';
         lgList.add(LG5);
        
        LatamGeneral__c LG6= new LatamGeneral__c();
        LG6.Name='Opp Stage 0';
        LG6.Value__c = '0%';
         lgList.add(LG6);
        
       insert lgList;
         contact con1=new contact(firstname='test',lastname='test',email='etst@te.com',accountId=TestAccount.id);
        insert con1;
         OpportunityContactRole OppContactRoleList1 =new OpportunityContactRole(role='E-Billing Contact',OpportunityId=opp1.id,ContactId=con1.id);
         insert OppContactRoleList1;  
        Test.StartTest();
        //checkRecursive.isRenewalQuote = true;
        Q1.Competitor_Name__c = 'Abacus Law';
        Q1.Opportunity_Notes__c = 'abcd';
        Q1.Payment_Terms__c = 'CCI';
        Q1.Payment_Method__c = '2 Installments';
      //  Q1.Projected_Renewal_Price__c = 100;
        Q1.Reason__c = 'Budget Cut';
        Q1.Was_There_A_Competitor__c = 'Yes';
        Q1.Win_Loss__c = 'Lost';
        UPDATE Q1;
        
       
        map<Id,Id> map1 = new map<Id,Id>();
        map1.put(opp1.id,Q1.id);
       
        Set<String> set1 = new set<String>();
        set1.add(q1.Id);
        set1.add(Q2.Id);
        set1.add(Q3.Id);
      
      
        QuoteTriggerHandler.strProfileName = 'LatAm User';
        QuoteTriggerHandler.updateOppStageForLatAm(set1);
       
        q2.status='Prevalidate for Final Approval';
        update q2;
        q1.Account_Contact_Change_Indicator__c=true;
        update q1;
        Q1.Was_There_A_Competitor__c = 'No';
        Q1.Competitor_Name__c = null;
        update q1;
        QuoteTriggerHandler.updateOppStageForLatAm(set1);
        delete q2;
        delete q3;
        QuoteTriggerHandler.updateSynCQuoteList_Renewals(map1);
        QuoteTriggerHandler.updateSynCQuoteList(map1, false);
        Test.StopTest();
        
      }
        
      
     
    /********************************************************************************************
    MethodName: testLogicForCreateCaseOnMgrAppr
    Description: Test method to test the logic of 'createCaseOnManagerAcceptance' method from 'QuoteTriggerHandler' class
    CreatedBy: Anshu Thakur 
    CreatedDate: 04-Aug-2016
    LastModifiedBy: Anshu Thakur 
    LastModifiedDate: 04-Aug-2016
    Reason for Change:
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
     static testmethod void testLogicForCreateCaseOnMgrAppr()
    {
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
    /*    
        OpportunityProductDetail__c opd = new OpportunityProductDetail__c();
        
        opd.Opportunity__r.id = objOpp.Id;
        
        insert opd;
*/
        //Preparing Quote data
        Quote objQty = new Quote();
        objQty.Name = 'Test Quote';
        objQty.Status = 'Draft';
        objQty.OpportunityId = objOpp.id;
        objQty.Pricebook2Id = Test.getStandardPricebookId();
        objQty.Approval_Status__c = 'Cancellation Approved';
        objqty.Primary_Quote__c = true;
        objqty.Short_Term_Sub__c =false;
        objQty.Reservation_Manager__c=userinfo.getUserId();
        objqty.Manager_of_Reservation_Manager__c=userinfo.getUserId();
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId(); 
        objqty.Win_Loss__c='Won';
        // objqty.Was_There_A_Competitor__c= 'No';
        INSERT objQty;

        //Preparing QuoteLineItem data
        QuoteLineItem objQLI = new QuoteLineItem();
        objQLI.QuoteId = objQty.Id;
        objQLI.PricebookEntryId = testEntry.Id;
        objQLI.Quantity = 1;
        objQLI.UnitPrice = 200;
        objQLI.Revenue_Type__c ='Renewal';
        objQLI.Discount=7.00;   
        
        contact con1=new contact(firstname='test',lastname='test',email='etst@te.com',accountId=objacc.id);
        insert con1;
         OpportunityContactRole OppContactRoleList1 =new OpportunityContactRole(role='E-Billing Contact',OpportunityId=objopp.id,ContactId=con1.id);
         insert OppContactRoleList1;
        
        //Executing test
        Test.startTest();  
                   
        INSERT objQLI;
        System.assertEquals(objQLI.Revenue_Type__c , 'Renewal');  
        
        Map<Id, Quote> mapq1= new Map<Id, Quote>();
        mapq1.put(objQty.id,ObjQty);
        List<Id> listid= new List<Id>();
        listid.add(objopp.id);
        objQty.Approval_Status__c ='Pending Cancellation Approval';
        objqty.Short_Term_Sub__c =true;
        objqty.Primary_Quote__c = true;
        objqty.Win_Loss__c='Lost';
        objqty.Reason__c='Budget Cut';
        objqty.Was_There_A_Competitor__c='Yes';
        objQty.Competitor_Name__c='Aderant';
        Update objqty;
        Map<Id, Quote> mapq2= new Map<Id, Quote>();
        mapq2.put(objQty.id,ObjQty);
        QuoteTriggerHandler.createCaseOnManagerAcceptance(mapq1,mapq2);
        QuoteTriggerHandler.QuoteOpptySync(mapq1,mapq2);
        //QuoteTriggerHandler.updateReservationMngAndHisMng_Future(listid);
        
        
        Test.stopTest();   
    }  
     
      
      public static testmethod void QuoteSync_Test(){
        UnitTest.createTestData();
        //Preparing Account data
        Account objAcc = UnitTest.getAccountInstance();
        INSERT objAcc;
        
        //Preparing Product data
        Product2 objProd=UnitTest.getProductInstance();
        objProd.IsActive = true;
        INSERT objProd;
        
        //Preparing PricebookEntry data
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=objProd.id,unitprice=200);
        INSERT testEntry;

        //Preparing Opportunity data
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
     //   objOpp.Renewal_Flag__c = true;
        objOpp.Pricebook2Id = Test.getStandardPricebookId();
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
        objqty.Primary_Quote__c = true;
        objqty.Short_Term_Sub__c =true;
        INSERT objQty;

        Test.startTest();  
   
        
        Map<Id, Quote> mapq1= new Map<Id, Quote>();
        mapq1.put(objQty.id,ObjQty);
  
        Quote objQty1 = new Quote();
        objQty1.Name = 'Test Quote1';
        objQty1.Status = 'Draft';
        objQty1.OpportunityId = objOpp.id;
        objQty1.Pricebook2Id = Test.getStandardPricebookId();
        objqty1.Short_Term_Sub__c =false;
        INSERT objQty1;

        
        Map<Id, Quote> mapq2= new Map<Id, Quote>();
        mapq2.put(objQty.id,objQty1);
        
  
        QuoteTriggerHandler.QuoteOpptySync(mapq2,mapq1);
        
        Test.stopTest();
  
      }   
   
   static testmethod void testLogicForCreateCaseOnMgrAppr1()
    {
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
        objQty.Approval_Status__c ='Pending Cancellation Approval';
        objqty.Primary_Quote__c = true;
        objqty.Short_Term_Sub__c =false;
        objQty.Reservation_Manager__c=userinfo.getUserId();
        objqty.Manager_of_Reservation_Manager__c=userinfo.getUserId();
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId(); 
        objqty.Win_Loss__c='Won';
        // objqty.Was_There_A_Competitor__c= 'No';
        INSERT objQty;

        //Preparing QuoteLineItem data
        QuoteLineItem objQLI = new QuoteLineItem();
        objQLI.QuoteId = objQty.Id;
        objQLI.PricebookEntryId = testEntry.Id;
        objQLI.Quantity = 1;
        objQLI.UnitPrice = 200;
        objQLI.Revenue_Type__c ='Renewal';
        objQLI.Discount=7.00;   
        
        contact con1=new contact(firstname='test',lastname='test',email='etst@te.com',accountId=objacc.id);
        insert con1;
         OpportunityContactRole OppContactRoleList1 =new OpportunityContactRole(role='E-Billing Contact',OpportunityId=objopp.id,ContactId=con1.id);
         insert OppContactRoleList1;
        
        INSERT objQLI;
        System.assertEquals(objQLI.Revenue_Type__c , 'Renewal');  
        
        Map<Id, Quote> mapq1= new Map<Id, Quote>();
        mapq1.put(objQty.id,ObjQty);
        List<Id> listid= new List<Id>();
        listid.add(objopp.id);
        
        //Executing test
        Test.startTest(); 
        
        objQty.Approval_Status__c ='Pending Cancellation Approval';
        objqty.Short_Term_Sub__c =true;
        objqty.Primary_Quote__c = true;
        objqty.Win_Loss__c='Lost';
        objqty.Reason__c='Budget Cut';
        objqty.Was_There_A_Competitor__c='Yes';
        objQty.Competitor_Name__c='Aderant';
        objqty.Approval_Status__c = 'Cancellation Approved';
        objqty.Master_Quote__c = null;
        Update objqty;
        
        
        Map<Id, Quote> mapq2= new Map<Id, Quote>();
        mapq2.put(objQty.id,ObjQty);
        QuoteTriggerHandler.createCaseOnManagerAcceptance(mapq1,mapq2);
        QuoteTriggerHandler.QuoteOpptySync(mapq1,mapq2);
        //Commenting this method as part of DPS-17684
        //QuoteTriggerHandler.updateReservationMngAndHisMng_Future(listid);
        
        
        Test.stopTest();   
    }  
    
    static testmethod void testLogicForCreateCaseOnMgrAppr2()
    {
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
        objQty.Approval_Status__c ='Pending Cancellation Approval';
        objqty.Primary_Quote__c = true;
        objqty.Short_Term_Sub__c =false;
        objQty.Reservation_Manager__c=userinfo.getUserId();
        objqty.Manager_of_Reservation_Manager__c=userinfo.getUserId();
        objQty.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId(); 
        objqty.Win_Loss__c='Won';
        // objqty.Was_There_A_Competitor__c= 'No';
        INSERT objQty;

        //Preparing QuoteLineItem data
        QuoteLineItem objQLI = new QuoteLineItem();
        objQLI.QuoteId = objQty.Id;
        objQLI.PricebookEntryId = testEntry.Id;
        objQLI.Quantity = 1;
        objQLI.UnitPrice = 200;
        objQLI.Revenue_Type__c ='Renewal';
        objQLI.Discount=7.00;   
        
        contact con1=new contact(firstname='test',lastname='test',email='etst@te.com',accountId=objacc.id);
        insert con1;
         OpportunityContactRole OppContactRoleList1 =new OpportunityContactRole(role='E-Billing Contact',OpportunityId=objopp.id,ContactId=con1.id);
         insert OppContactRoleList1;
        
        INSERT objQLI;
        System.assertEquals(objQLI.Revenue_Type__c , 'Renewal');  
        
        Map<Id, Quote> mapq1= new Map<Id, Quote>();
        mapq1.put(objQty.id,ObjQty);
        List<Id> listid= new List<Id>();
        listid.add(objopp.id);
        
        //Executing test
        Test.startTest(); 
        
        objQty.Approval_Status__c ='Pending Cancellation Approval';
        objqty.Short_Term_Sub__c =true;
        objqty.Primary_Quote__c = true;
        objqty.Win_Loss__c='Lost';
        objqty.Reason__c='Budget Cut';
        objqty.Was_There_A_Competitor__c='Yes';
        objQty.Competitor_Name__c='Aderant';
        objqty.Approval_Status__c = 'Cancellation Rejected';
        objqty.Master_Quote__c = null;
        Update objqty;
        
        
        Map<Id, Quote> mapq2= new Map<Id, Quote>();
        mapq2.put(objQty.id,ObjQty);
        QuoteTriggerHandler.createCaseOnManagerAcceptance(mapq1,mapq2);
        QuoteTriggerHandler.QuoteOpptySync(mapq1,mapq2);
        //QuoteTriggerHandler.updateReservationMngAndHisMng_Future(listid);
        
        
        Test.stopTest();   
    }  
    
    static testmethod void testSendRequest1()
    {
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        //assConSize acs = new assConSize();        
        Account testAcc1 = new Account();
        testAcc1 = UnitTest.getAccountInstance();
        //testAcc.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
        testAcc1.SAPAccountNumber__c = '1004879124';       
        insert testAcc1;
        Contact testcontact1= UnitTest.getContactInstance(testAcc1.Id);
        testcontact1.LastName = 'testContact';
        testcontact1.FirstName = 'testContact';
        testcontact1.AccountId = testAcc1.Id;
        testcontact1.email = 'testfirst.testlast@thomson.com';
        testcontact1.SAP_Contact_ID__c = null;
        insert testcontact1;
        Opportunity testOpp11 = new Opportunity();
        testOpp11 = UnitTest.getOpportunityInstance(testAcc1.Id);
        testOpp11.StageName = '75%';
        //testOpp1.RecordTypeId = orecordType1;
        insert testOpp11;
        List<Opportunitylineitem> lstOppLineItem = new List<Opportunitylineitem>();
        Product2 testProd1 =UnitTest.getProductInstance();
        testProd1.ProductCode = '456789';
        testProd1.Entitlement_Oneshot__c = true;
        insert testProd1;
        
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;
        OpportunityProductDetail__c opd1 = new OpportunityProductDetail__c(Opportunity__c=testOpp11.id, Product__c=testProd1.id);
        insert opd1;
        OpportunityProductDetail__c opd11 = new OpportunityProductDetail__c(Opportunity__c=testOpp11.id, Product__c=testProd1.id);
        insert opd11;
        Opportunity_Product_Detail_Contact__c opdc111 = new Opportunity_Product_Detail_Contact__c(Product_Detail__c = opd1.id, Email__c = testcontact1.email);
        insert opdc111;
        Opportunity_Product_Detail_Contact__c opdc11 = new Opportunity_Product_Detail_Contact__c(Product_Detail__c = opd1.id, Email__c = testcontact1.email);
        insert opdc11;
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        OpportunityLineItem testLineItem3 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        lstOppLineItem.add(testLineItem1); 
        lstOppLineItem.add(testLineItem2); 
        lstOppLineItem.add(testLineItem3);
        insert lstOppLineItem;
        
        Quote Q2 = New Quote();
        Q2.OpportunityId = Testopp11.id;
        Q2.Pricebook2Id = Test.getStandardPricebookId();
        Q2.Name = 'Test Quote';
        Q2.Primary_Quote__c = true;
        Q2.Entitlement_Path__c = 'Post Order';
        Q2.Status = 'Order Completed';
        Q2.Sold_To_Contact__c = testcontact1.id;
        Q2.Create_Token_for_Unused_Product_Quantity__c = 'Single Use Token';
        insert Q2;
        
    }
    
    private static testMethod void OpportunityTriggerMethod() {

        UnitTest.createTestData();
        KeyValueListStore__c kv1 = new KeyValueListStore__c ();
        kv1.Name = 'ReasonWithCompetitor';
        kv1.TextValue__c ='TR Corp Partner Community User';
        Insert kv1;
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        insert oOpportunity;
        
        Account oAccount1 = UnitTest.getAccountInstance();
        insert oAccount1;
        
        Opportunity oOpportunity1 = UnitTest.getOpportunityInstance(oAccount1.Id);
       // oOpportunity1.RecordTypeId= [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'LATAM_Renewal_Opportunity' LIMIT 1].Id;
       oOpportunity1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        oOpportunity1.Renewal_Flag__c = true;
        oOpportunity1.CloseDate = System.today();
        insert oOpportunity1;


    } 
    
 }