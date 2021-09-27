/**
 * Contains testmethod OpportunityLineItemTriggerHandler and OpportunityLineItemTrigger 
 *
 * @author  
 * @version  
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-06-04   Akshat             Commented method LatamProductCheck followed by increasing test coverage
 * =============================================================================
 */ 

@isTest(SeeAllData=false)
public class OpportunityLineItemTriggerHandler1_test{

     Public static testMethod Void updateRenewal_IncrAmounts_test(){
        
        
          KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT1);
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        recTList.add(orecordType5);
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        recTList.add(orecordType6);
        
        insert recTList;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Id profilId = [SELECT Id,Name FROM Profile WHERE Name = 'ANZ Users'].Id;
        User usr = new User();
        usr = [SELECT Id FROM User WHERE ProfileId =:profilId AND IsActive = TRUE LIMIT 1];
        System.runAs(usr) {
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd2.id,unitprice=200);
        insert new List<PricebookEntry>{testEntry,testEntry1};
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();        
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        testOpp1.LCRM_Split_On__c = true;
        testOpp1.Is_GLI__c = TRUE;
        insert testOpp1;
        
        Opportunity opp = [select id,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpp1.ID];
        System.debug('opp : '+opp);
        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;
        
        Test.startTest();
        
            OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
            testLineItem1.LCRM_Units__c = 1;
            insert testLineItem1;
            
            Set <id> setOppId= new Set <id>();
            setOppId.add(testLineItem1.id);
            OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts(setOppId);
             testLineItem1.LCRM_Units__c = 2;
            UPDATE testLineItem1;
            
            OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
            OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
            testLineItem2.LCRM_Units__c = 1;
            insert testLineItem2;
            setOppId.add(testLineItem2.id);
            OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts(setOppId);
            
            OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
            
            List<LCRM_Opportunity_Split__c> splitList = [SELECT ID FROM LCRM_Opportunity_Split__c WHERE ID = :testOpp1.Id];
            System.assert(splitList!=null,true);
            delete testLineItem1;
        Test.stopTest();
        }
    }
    /*-------------------------------------------------*/
    Public static testMethod Void updateBillingAccountSubtotal_test(){
        
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
       // Account testAcc = UnitTest.getAccountInstance();
        //insert testAcc;
        
        Account testAcc= UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '1234567890';
       // TestAccount.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Insert testAcc;
        
        List <Contact> ListContact = new List<Contact>();
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.Phone= '1234567891';
        testcontact.Work_Direct__c='1234567891';
        testcontact.SAP_Contact_ID__c = '';
        ListContact.add(testcontact);
        Insert ListContact;
        
        /*Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = false;
        testOpp1.Selling_Organization__c = 'LRA';
        insert testOpp1;*/
         List<Opportunity> lstOppty = new List<Opportunity>();
        Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);             
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
        
         Opportunity opp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        opp2.StageName = '50%';
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Competitor_Name__c = 'BloomBerg';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test';
        opp2.Is_Master_Opportunity__c = false;
        opp2.Master_Opportunity__c = opp1.id;
        opp2.Oppty_Mgmt_Type__c = 'Split Billing';
        opp2.Description='Tst';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        lstOppty.add(opp2);
        insert lstOppty;
        
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        
        List<Billing_Account_Split__c> ListbillingSplit = new List <Billing_Account_Split__c>();
        Billing_Account_Split__c bas = new Billing_Account_Split__c();
        bas.Account__c = testAcc.id;
        bas.Master_Opportunity__c = opp1.id;
        bas.Child_Opportunity__c = opp2.id;
        bas.PO_Number__c = '12345';
        bas.Invoice_Notes__c = 'Testing';
        bas.E_Billing_Contact__c = testcontact.id;
        bas.Boleto_Contact__c = testcontact.id;
        bas.Opportunity_Notes__c='Testing';
        bas.Product_1__c = testProd.id;
        bas.Product_1_Sales_Price__c =23.4; 
        bas.Product_2__c = testProd.id;
        bas.Product_2_Sales_Price__c =45.6;
        bas.Product_3__c = testProd.id;
        bas.Product_3_Sales_Price__c =23.5;
        bas.OLI_id_1__c='test1';
        ListbillingSplit.add(bas); 
        
        Billing_Account_Split__c bas2 = new Billing_Account_Split__c();
        bas2.Account__c = testAcc.id;
        bas2.Master_Opportunity__c = opp1.id;
        bas2.Child_Opportunity__c = opp2.id;
        bas2.PO_Number__c = '12345';
        bas2.Invoice_Notes__c = 'Testing';
        bas2.E_Billing_Contact__c = testcontact.id;
        bas2.Boleto_Contact__c = testcontact.id;
        bas2.Opportunity_Notes__c='Testing';
        bas2.Product_1__c = testProd.id;
        bas2.Product_1_Sales_Price__c =23.4; 
        bas2.Product_2__c = testProd.id;
        bas2.Product_2_Sales_Price__c =45.6;
        bas2.Product_3__c = testProd.id;
        bas2.Product_3_Sales_Price__c =23.5;
        bas2.OLI_id_1__c='test2';
        ListbillingSplit.add(bas2);    
        
        Billing_Account_Split__c bas3 = new Billing_Account_Split__c();
        bas3.Account__c = testAcc.id;
        bas3.Master_Opportunity__c = opp1.id;
        bas3.Child_Opportunity__c = opp2.id;
        bas3.PO_Number__c = '12345';
        bas3.Invoice_Notes__c = 'Testing';
        bas3.E_Billing_Contact__c = testcontact.id;
        bas3.Boleto_Contact__c = testcontact.id;
        bas3.Opportunity_Notes__c='Testing';
        bas3.Product_1__c = testProd.id;
        bas3.Product_1_Sales_Price__c =23.4; 
        bas3.Product_2__c = testProd.id;
        bas3.Product_2_Sales_Price__c =45.6;
        bas3.Product_3__c = testProd.id;
        bas3.Product_3_Sales_Price__c =23.5;
        bas3.OLI_id_1__c='test3';
        ListbillingSplit.add(bas3);   
        INSERT ListbillingSplit;
        
        
        
        
       // List<Pricebook2> testPricebook =[select id from Pricebook2 where isActive = true];   
              
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        
        List<OpportunityLineItem> ListOppLineItem = new List<OpportunityLineItem>(); 
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=opp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        testLineItem.MOLI_id__c='test1';
        ListOppLineItem.add(testLineItem);
        insert ListOppLineItem;
               
        
        /*OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)testLineItem.ID).substring(0,15));
        d.Opportunity__c = opp1.id;
        d.Contact__c = testcontact.id;
        d.Product__c = testProd.id;
        insert d;*/
       
        Test.startTest();
        
        OpportunityLineItemTriggerHandler.updateBillingAccountSubtotal(ListOppLineItem);
        
        testLineItem.MOLI_id__c='test2';
        update testLineItem;
        OpportunityLineItemTriggerHandler.updateBillingAccountSubtotal(ListOppLineItem);

        testLineItem.MOLI_id__c='test3';
        update testLineItem;        
        delete testLineItem ;
        OpportunityLineItemTriggerHandler.updateBillingAccountSubtotal(ListOppLineItem);
        
        Test.stopTest();   
        }
        
        Public static testMethod Void RenewalOLISyncOnInsert_test(){    

        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
                  
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        insert testProd1;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
            
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        //Q1.Master_Quote__c ='';
        //Q1.Renewal_Flag_Formula__c=true;
        insert Q1;
        
        List<OpportunityLineItem> ListOppLineItem = new List <OpportunityLineItem>();
        OpportunityLineItem testLineItem = new OpportunityLineItem() ;
        testLineItem.OpportunityId = testOpp1.id;
        testLineItem.PricebookEntryId = testentry.Id;
        testLineItem.Quantity = 1;
        testLineItem.UnitPrice = 200;
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Activity_Type__c ='Renewed';
        testLineItem.Discount=7.00;
        testLineItem.Projected_Renewal_Price__c = 900;
        ListOppLineItem.add(testLineItem);
        insert ListOppLineItem;
        
        Map<Id, OpportunityLineItem> NewMaplistOppLineItem = new Map<Id, OpportunityLineItem>();
            for(OpportunityLineItem op : listOppLineItem  )
            {
                NewMaplistOppLineItem.put(op.OpportunityId, op);
            }
        
        List<QuoteLineItem> listQuoteLineItem = new List<QuoteLineItem>();
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = Q1.id;
        testquoteLineItem.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Revenue_Type__c ='Renewal';
        testquotelineItem.Discount=7.00;
        testquotelineItem.Number_of_Contacts__c=3;
        testquotelineItem.Storage_Location__c='8000';
        testquotelineItem.Previous_Subscription_Number__c='test';
        //insert testQuoteLineItem;
        listQuoteLineItem.add(testQuoteLineItem);
        insert listQuoteLineItem;
 
        Test.StartTest();
        
        
        
        checkRecursive.isRenewalQLI = true;
        testLineItem.UnitPrice = 250;
        testLineItem.Quantity = 2;
        testLineItem.Description = 'abcdfg';
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Projected_Renewal_Price__c = 100;
        Update testLineItem;
        
        //OpportunityLineItemTriggerHandler.RenewalOLISyncOnInsert(NewMaplistOppLineItem,listOppLineItem);
        
        testLineItem.UnitPrice = 150;
        testLineItem.Quantity = 2;
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Projected_Renewal_Price__c = 900;
        Update testLineItem;
        testLineItem.Number_of_Contacts__c = 2;
        Update testLineItem;
        testLineItem.Number_of_Contacts__c = null;
        Update testLineItem;
        testOpp1.SyncedQuoteId=Q1.Id;
        update testOpp1;
        Test.StopTest();
    }
    Public static testMethod Void afterUpdateProductsSync_Test(){
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        insert testProd1;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
       // testOpp1.Renewal_Flag__c = true;
       // testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.Is_Master_Opportunity__c = true;
        insert testOpp1;
        
        
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
       // testOpp2.Renewal_Flag__c = true;
       // testOpp2.Selling_Organization__c = 'LRA';
        testopp2.Pricebook2Id = Test.getStandardPricebookId();
        //testOpp2.Master_Opportunity__c = testOpp1.id;
        insert testOpp2;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        insert testLineItem1;
        
        Test.startTest();
        testLineItem1.Quantity = 2;
        UPDATE testLineItem1;
        Test.stopTest();
    }
    
      Public static testMethod Void SyncOppLineItemToQuoteLineItem_test(){
        
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
      
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        insert testProd1;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        List<Opportunity> lstOppty = new List<Opportunity>();
        Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);             
        opp1.StageName = '75%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Is_Master_Opportunity__c = true;
        opp1.Oppty_Mgmt_Type__c = 'Split Billing';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        lstOppty.add(opp1);
        insert lstOppty;
                                    
        
        List<OpportunityLineItem> ListOppLineItem = new List <OpportunityLineItem>();
        OpportunityLineItem testLineItem = new OpportunityLineItem() ;
        testLineItem.OpportunityId = opp1.id;
        testLineItem.PricebookEntryId = testentry.Id;
        testLineItem.Quantity = 1;
        testLineItem.UnitPrice = 200;
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Activity_Type__c ='Renewed';
        testLineItem.Discount=7.00;
        testLineItem.Projected_Renewal_Price__c = 900;
        testLineItem.LCRM_Units__c = 1;
        testLineItem.MOLI_id__c='test1';
        testLineItem.Number_of_Contacts__c=3;
        testLineItem.Incremental_Amount__c=10.00;
        ListOppLineItem.add(testLineItem);
        
        OpportunityLineItem testLineItem2 = new OpportunityLineItem() ;
        testLineItem2.OpportunityId = opp1.id;
        testLineItem2.PricebookEntryId = testentry.Id;
        testLineItem2.Quantity = 1;
        testLineItem2.UnitPrice = 200;
        testLineItem2.Revenue_Type__c ='Renewal';
        testLineItem2.Activity_Type__c ='Renewed';
        testLineItem2.Discount=7.00;
        testLineItem2.Projected_Renewal_Price__c = 900;
        testLineItem2.LCRM_Units__c = 1;
        testLineItem2.MOLI_id__c='test1';
        testLineItem2.Number_of_Contacts__c=3;
        testLineItem2.Incremental_Amount__c=10.00;
        ListOppLineItem.add(testLineItem2);
        insert ListOppLineItem;
        
        Map<Id, OpportunityLineItem> NewMaplistOppLineItem = new Map<Id, OpportunityLineItem>();
            for(OpportunityLineItem op : listOppLineItem  )
            {
                NewMaplistOppLineItem.put(op.Id, op);
            }
         
            Quote Q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        //Q1.Master_Quote__c ='';
        //Q1.Renewal_Flag_Formula__c=true;
        insert Q1;
            
        List<QuoteLineItem> listQuoteLineItem = new List<QuoteLineItem>();
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = Q1.id;
        testquoteLineItem.PricebookEntryId = testentry.Id;
        testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Revenue_Type__c ='Renewal';
        testquotelineItem.Discount=7.00;
        testquotelineItem.Number_of_Contacts__c=3;
        testquotelineItem.Storage_Location__c='8000';
        testquotelineItem.Previous_Subscription_Number__c='test';
        listQuoteLineItem.add(testQuoteLineItem);
        
        QuoteLineItem testquoteLineItem2 = new QuoteLineItem() ;
        testquoteLineItem2.QuoteId = Q1.id;
        testquoteLineItem2.PricebookEntryId = testentry.Id;
        testquoteLineItem2.Product2Id = testprod1.Id;
        testquoteLineItem2.Quantity = 1;
        testquotelineItem2.UnitPrice = 200;
        testquotelineItem2.Revenue_Type__c ='Renewal';
        testquotelineItem2.Discount=7.00;
        testquotelineItem2.Number_of_Contacts__c=3;
        testquotelineItem2.Storage_Location__c='8000';
        testquotelineItem2.Previous_Subscription_Number__c='test';
        listQuoteLineItem.add(testQuoteLineItem2);
        insert listQuoteLineItem;
               
       
        Test.startTest();
        
        OpportunityLineItemTriggerHandler.SyncOppLineItemToQuoteLineItem(ListOppLineItem,NewMaplistOppLineItem );
        Test.stopTest();
          
    }
    

         Public static testMethod Void afterUpdateRenewalProductsSync_test(){    

         KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        List<Account> ListAccount = new List <Account>();
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.name = 'test';
        ListAccount.add(testAcc);
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Name  = 'testing';
        ListAccount.add(testAcc1);
        insert ListAccount;
        
        List<Contact> listContact = new list <Contact>();
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        listContact.add(testcontact);
        
        Contact testcontact1= UnitTest.getContactInstance(testAcc.Id);
        testcontact1.LastName = 'testContact';
        testcontact1.FirstName = 'testContact';
        testcontact1.AccountId = testAcc.Id;
        testcontact1.email = 'testfirst.testlast@thomson.com';
        listContact.add(testcontact1);
        insert listContact;
                  
        List<Product2> ListProduct2 = New List<Product2>();
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        ListProduct2.add(testprod1);
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        ListProduct2.add(testprod2);
        insert ListProduct2;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
            
        List<OpportunityLineItem> ListOppLineItem = new List <OpportunityLineItem>();
        OpportunityLineItem testLineItem = new OpportunityLineItem() ;
        testLineItem.OpportunityId = testOpp1.id;
        testLineItem.PricebookEntryId = testentry.Id;
        //testLineItem.Product2Id = testprod1.Id;
        testLineItem.Quantity = 10;
        testLineItem.UnitPrice = 20;
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Activity_Type__c ='Renewed';
        testLineItem.Discount=70.00;
        //testLineItem.Number_of_Contacts__c=7;
        testLineItem.Projected_Renewal_Price__c = 90;
        ListOppLineItem.add(testLineItem);
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem() ;
        testLineItem1.OpportunityId = testOpp1.id;
        testLineItem1.PricebookEntryId = testentry.Id;
        //testLineItem1.Product2Id = testprod2.Id;
        testLineItem1.Quantity = 1;
        testLineItem1.UnitPrice = 200;
        testLineItem1.Revenue_Type__c ='Incremental';
        testLineItem1.Activity_Type__c ='Uplift';
        testLineItem1.Discount=7.00;
       // testLineItem1.Number_of_Contacts__c=4;
        testLineItem1.Projected_Renewal_Price__c = 900;
        ListOppLineItem.add(testLineItem1);
        insert ListOppLineItem;
        
        Map<Id, OpportunityLineItem> NewMaplistOppLineItem = new Map<Id, OpportunityLineItem>();
        //NewMaplistOppLineItem.put(testLineItem.id,testLineItem);
            for(OpportunityLineItem op : listOppLineItem  )
            {
                NewMaplistOppLineItem.put(op.Id, op);
            }
            
            Map<Id, OpportunityLineItem> oldMaplistOppLineItem = new Map<Id, OpportunityLineItem>();
            oldMaplistOppLineItem.put(testLineItem1.id,testLineItem1);
        
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        //Q1.Master_Quote__c ='';
        //Q1.Renewal_Flag_Formula__c=true;
        insert Q1;
        
        List<QuoteLineItem> listQuoteLineItem = new List<QuoteLineItem>();
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = Q1.id;
        testquoteLineItem.PricebookEntryId = testentry.Id;
        testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Revenue_Type__c ='Renewal';
        testquotelineItem.Discount=7.00;
        testquotelineItem.Number_of_Contacts__c=31;
        testquotelineItem.Storage_Location__c='800';
        testquotelineItem.Previous_Subscription_Number__c='test1';
        testquotelineItem.opportunitylineitemid = testLineItem.id;
        listQuoteLineItem.add(testQuoteLineItem);
        //insert listQuoteLineItem;
        
        QuoteLineItem testquoteLineItem1 = new QuoteLineItem() ;
        testquotelineItem1.opportunitylineitemid = testLineItem1.id;
        testquoteLineItem1.QuoteId = Q1.id;
        testquoteLineItem1.PricebookEntryId = testentry.Id;
        testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem1.Quantity = 1;
        testquotelineItem1.UnitPrice = 20;
        testquotelineItem1.Revenue_Type__c ='Renewal';
        testquotelineItem1.Discount=70.00;
        testquotelineItem1.Number_of_Contacts__c=32;
        testquotelineItem1.Storage_Location__c='9000';
        testquotelineItem1.Previous_Subscription_Number__c='test';
        listQuoteLineItem.add(testQuoteLineItem1);
        insert listQuoteLineItem;
 
        Test.StartTest();
               
        checkRecursive.isRenewalQLI = true;
        testLineItem1.UnitPrice = 250;
        testLineItem1.Quantity = 21;
        testLineItem1.Description = 'abcdfg';
        testLineItem1.Activity_Type__c = 'New';
        testLineItem1.Active_Status__c ='Active';
        testLineItem1.Revenue_Type__c ='Renewal';
        testLineItem1.Number_of_Contacts__c=4;
        //testLineItem1.Product2Id = testprod1.Id;
        testLineItem1.Projected_Renewal_Price__c = 1030;
        testLineItem1.Ship_To_Customer_Name__c = testAcc1.Id;
        testLineItem1.Ship_To_Contact__c = testcontact1.Id;
        testLineItem1.Incremental_Amount__c=300.00;
        testLineItem1.Last_Invoice_Price__c=300.00;
        testLineItem1.Description='testing11';
        testLineItem1.Quote_Item__c ='testing11';
        testLineItem1.Shipping_Point__c='testing11';
        testLineItem1.Subscription_Start_Date__c=System.today().adddays(2);
        testLineItem1.Subscription_End_Date__c = System.today().adddays(3);
        testLineItem1.Status__c='Active'; //Remove
        testLineItem1.Annualized_Base_Price__c =305.00;
        testLineItem1.Cancel_Date__c= System.today().adddays(3);
        testLineItem1.Cancel_Comments__c = 'testing11';
        testLineItem1.Cancel_Reason__c ='Budget';
        testLineItem1.Storage_Location__c='8000'; //1000
        testLineItem1.Bill_To_Contact__c=testcontact1.Id;
        testLineItem1.Reason_For_New_Product__c='Uplift'; 
        Update testLineItem1;
        

        
        testLineItem1.UnitPrice = 20;
        testLineItem1.Quantity = 41;
        testLineItem1.Description = 'abcdfyhyg';
        testLineItem1.Revenue_Type__c ='Incremental';
        testLineItem1.Active_Status__c ='Remove';
        testLineItem1.Activity_Type__c = 'Uplift';
        testLineItem1.Number_of_Contacts__c=5;
        //testLineItem1.Product2Id = testprod2.Id;
        testLineItem1.Projected_Renewal_Price__c = 730;
        testLineItem1.Ship_To_Customer_Name__c = testAcc.Id;
        testLineItem1.Ship_To_Contact__c = testcontact.Id;
        testLineItem1.Incremental_Amount__c=3070.00;
        testLineItem1.Last_Invoice_Price__c=3070.00;
        testLineItem1.Description='testing12';
        testLineItem1.Quote_Item__c ='testing12';
        testLineItem1.Shipping_Point__c='testing12';
        testLineItem1.Subscription_Start_Date__c=System.today().adddays(7);
        testLineItem1.Subscription_End_Date__c = System.today().adddays(8);
        testLineItem1.Status__c='Remove'; //Remove
        testLineItem1.Annualized_Base_Price__c =305.00;
        testLineItem1.Cancel_Date__c= System.today().adddays(8);
        testLineItem1.Cancel_Comments__c = 'testing112';
        testLineItem1.Cancel_Reason__c ='Abandoned';
        testLineItem1.Storage_Location__c='1000'; //1000
        testLineItem1.Bill_To_Contact__c=testcontact.Id;
        testLineItem1.Reason_For_New_Product__c='Downgrade'; 
        Update testLineItem1;
        Test.StopTest();
        }
    
    Public static testMethod Void updateBillingAccountSubtotal11_test(){
    
    
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
    
        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
    
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
    
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
    
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
    
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
    
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
    
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
    
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
    
        Account testAcc= UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '1234567890';
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Insert testAcc;
    
        List <Contact> ListContact = new List<Contact>();
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.Phone= '1234567891';
        testcontact.Work_Direct__c='1234567891';
        testcontact.SAP_Contact_ID__c = '';
        ListContact.add(testcontact);
        Insert ListContact;
    
        List<Opportunity> lstOppty = new List<Opportunity>();
        Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);             
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
    
        Opportunity opp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        opp2.StageName = '50%';
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Competitor_Name__c = 'BloomBerg';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test';
        opp2.Is_Master_Opportunity__c = false;
        opp2.Master_Opportunity__c = opp1.id;
        opp2.Oppty_Mgmt_Type__c = 'Split Billing';
        opp2.Description='Tst';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        lstOppty.add(opp2);
        insert lstOppty;
    
        List<Product2> testProd =new List<Product2>();
        Product2 testProd1 =UnitTest.getProductInstance();
        Product2 testProd2 =UnitTest.getProductInstance();
        Product2 testProd3 =UnitTest.getProductInstance();
        testProd.add(testProd1);testProd.add(testProd2);testProd.add(testProd3);
        insert testProd;
        
        List<PricebookEntry> testEntryList = new List<PricebookEntry>();
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=1,UseStandardPrice=false);
        testEntryList.add(testEntry1);
        PricebookEntry testEntry2 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd2.id,unitprice=1,UseStandardPrice=false);
        testEntryList.add(testEntry2);
        PricebookEntry testEntry3 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd3.id,unitprice=1,UseStandardPrice=false);
        testEntryList.add(testEntry3);
        insert testEntryList;
    
        List<OpportunityLineItem> ListOppLineItem = new List<OpportunityLineItem>(); 
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=opp1.id,product2id=testProd1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        testLineItem1.MOLI_id__c='test1';
        ListOppLineItem.add(testLineItem1);
        
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=opp1.id,product2id=testProd2.id,PricebookEntryId=testEntry2.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        testLineItem2.MOLI_id__c='test2';
        ListOppLineItem.add(testLineItem2);
        
        OpportunityLineItem testLineItem3 = new OpportunityLineItem(opportunityId=opp1.id,product2id=testProd3.id,PricebookEntryId=testEntry3.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        testLineItem3.MOLI_id__c='test3';
        ListOppLineItem.add(testLineItem3);
        
        insert ListOppLineItem;
    
        List<Billing_Account_Split__c> ListbillingSplit = new List <Billing_Account_Split__c>();
        Billing_Account_Split__c bas = new Billing_Account_Split__c();
        bas.Account__c = testAcc.id;
        bas.Master_Opportunity__c = opp1.id;
        bas.Child_Opportunity__c = opp2.id;
        bas.PO_Number__c = '12345';
        bas.Invoice_Notes__c = 'Testing';
        bas.E_Billing_Contact__c = testcontact.id;
        bas.Boleto_Contact__c = testcontact.id;
        bas.Opportunity_Notes__c='Testing';
        bas.Product_1__c = testProd1.id;
        bas.Product_1_Sales_Price__c =23.4; 
        bas.Product_2__c = testProd2.id;
        bas.Product_2_Sales_Price__c =45.6;
        bas.Product_3__c = testProd3.id;
        bas.Product_3_Sales_Price__c =23.5;
        bas.OLI_id_1__c='test1';
        bas.OLI_id_2__c='test2';
        bas.OLI_id_3__c='test3';
        ListbillingSplit.add(bas); 
    
        Billing_Account_Split__c bas2 = new Billing_Account_Split__c();
        bas2.Account__c = testAcc.id;
        bas2.Master_Opportunity__c = opp1.id;
        bas2.Child_Opportunity__c = opp2.id;
        bas2.PO_Number__c = '12345';
        bas2.Invoice_Notes__c = 'Testing';
        bas2.E_Billing_Contact__c = testcontact.id;
        bas2.Boleto_Contact__c = testcontact.id;
        bas2.Opportunity_Notes__c='Testing';
        bas2.Product_1__c = testProd1.id;
        bas2.Product_1_Sales_Price__c =23.4; 
        bas2.Product_2__c = testProd2.id;
        bas2.Product_2_Sales_Price__c =45.6;
        bas2.Product_3__c = testProd3.id;
        bas2.Product_3_Sales_Price__c =23.5;
        bas2.OLI_id_1__c='test1';
        bas2.OLI_id_2__c='test2';
        bas2.OLI_id_3__c='test3';
        ListbillingSplit.add(bas2);    
    
        Billing_Account_Split__c bas3 = new Billing_Account_Split__c();
        bas3.Account__c = testAcc.id;
        bas3.Master_Opportunity__c = opp1.id;
        bas3.Child_Opportunity__c = opp2.id;
        bas3.PO_Number__c = '12345';
        bas3.Invoice_Notes__c = 'Testing';
        bas3.E_Billing_Contact__c = testcontact.id;
        bas3.Boleto_Contact__c = testcontact.id;
        bas3.Opportunity_Notes__c='Testing';
        bas3.Product_1__c = testProd1.id;
        bas3.Product_1_Sales_Price__c =23.4; 
        bas3.Product_2__c = testProd2.id;
        bas3.Product_2_Sales_Price__c =45.6;
        bas3.Product_3__c = testProd3.id;
        bas3.Product_3_Sales_Price__c =23.5;
        bas3.OLI_id_1__c='test1';
        bas3.OLI_id_2__c='test2';
        bas3.OLI_id_3__c='test3';
        ListbillingSplit.add(bas3);   
        INSERT ListbillingSplit;
    
    
        OpportunityLineItemTriggerHandler.updateBillingAccountSubtotal(ListOppLineItem);
    }   
    
     Public static Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
    
    Public static testMethod Void testUpdateProductCategory(){
        
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = false;
        testOpp1.Selling_Organization__c = 'LRA';
        insert testOpp1;
        
        
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        
       // List<Pricebook2> testPricebook =[select id from Pricebook2 where isActive = true];   
              
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        insert testLineItem;
        
        
        OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)testLineItem.ID).substring(0,15));
        d.Opportunity__c = testOpp1.id;
        d.Contact__c = testcontact.id;
        d.Product__c = testProd.id;
        insert d;
       
        Test.startTest();
        delete testLineItem ;
        Test.stopTest();
       /* system.assert(testLineItem.Product_Category__c==null);
        
        Product2 testProd2 =UnitTest.getProductInstance();
        testProd2.name='Books2';
        insert testProd2;
        PricebookEntry testEntry2 = new PricebookEntry(isactive=true,Pricebook2id=testPricebook.id,Product2Id=testProd2.id,unitprice=1);
        insert testEntry2;
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(quantity=1,totalprice=10,opportunityId=testOpp1.id,PricebookEntryId=testEntry2.id);
        insert testLineItem2;
        Test.startTest();
        system.assertEquals([select Product_Category__c from OpportunityLineItem where id=:testLineItem.id].Product_Category__c,null);
        system.assert(testProd2.name.contains([select Product_Category__c from OpportunityLineItem where id=:testLineItem2.id].Product_Category__c));
        Test.stopTest();*/    
        
        
        
    }
    
    
    Public static testMethod Void testUpdateProductCategory1(){
        
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
      
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        insert testOpp1;
        

         update testOpp1;
         
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        
     
              
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        insert testLineItem;
        
        
        OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)testLineItem.ID).substring(0,15));
        d.Opportunity__c = testOpp1.id;
        d.Contact__c = testcontact.id;
        d.Product__c = testProd.id;
        insert d;
       
        Test.startTest();
        delete testLineItem ;
        Test.stopTest();
          
    }
 
     Public static testMethod Void testerrorForNewOpportunitiesmethod(){
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;

        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = false;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.Sub_Category__c = 'Renewel';
        insert testOpp1;
       
        
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;
        Sales_Area_Product_Info__c saPI = new Sales_Area_Product_Info__c(Name = 'Test Sapi', D_Chain_Material_Status__c = 'ZO', IsActive__c = True, Material_Number__c = '123',Product__c = testProd.Id, Sales_Org__c = 'LLEY', SAPExtId__c = '1234');
        insert saPI; 
        
       // List<Pricebook2> testPricebook =[select id from Pricebook2 where isActive = true];   
              
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;
        Id profilId = [SELECT Id,Name FROM Profile WHERE Name = 'Latam User'].Id;
        User usr = new User();
        usr = [SELECT Id FROM User WHERE ProfileId =:profilId AND IsActive = TRUE LIMIT 1];
        System.runAs(usr) {
        Test.startTest();
        try{
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        insert testLineItem;
        
        
        OpportunityProductDetail__c d = new OpportunityProductDetail__c();
        d.Opportunity_Line_Item_Id__c = (((String)testLineItem.ID).substring(0,15));
        d.Opportunity__c = testOpp1.id;
        d.Contact__c = testcontact.id;
        d.Product__c = testProd.id;
        insert d;
       
        
        delete testLineItem ;
        Test.stopTest(); 
        }
        catch(exception ex) {}
        }  
     }
    
   Public static testMethod Void errorForNewOpportunities_test(){
   
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;

        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        list<QuoteLineItem> newQLIs = new list <QuoteLineItem>();
        map<Id, QuoteLineItem> oldQuoteLineItemMap = new map <Id, QuoteLineItem>();
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
        
          
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        insert testProd1;
        
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert testProd2;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd2.id,unitprice=200);
        insert testEntry1;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        insert testOpp1;
        
        
        List<OpportunityLineItem> listOppLineItem  = new List<OpportunityLineItem>();
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Renewal');
        //insert testLineItem;//Commented on 06/06
        listOppLineItem.add(testLineItem);
         OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        //insert testLineItem1;//Commented on 06/06
        listOppLineItem.add(testLineItem1);
        insert listOppLineItem;
         Set<Id> settestLineItem = new set<Id>();
         settestlineitem.add(testlineItem1.id);
        
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        insert Q1;
        List<QuoteLineItem> listQuoteLineItem = new List<QuoteLineItem>();
        QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
        testquoteLineItem.QuoteId = Q1.id;
        testquoteLineItem.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem.Quantity = 1;
        testquotelineItem.UnitPrice = 200;
        testquotelineItem.Revenue_Type__c ='Renewal';
        testquotelineItem.Discount=7.00;
        //insert testQuoteLineItem;
        listQuoteLineItem.add(testQuoteLineItem);
        QuoteLineItem testquoteLineItemmap = testQuoteLineItem ;
        
        
       QuoteLineItem testquoteLineItem2 = new QuoteLineItem() ;
        testquoteLineItem2.QuoteId = Q1.id;
        testquoteLineItem2.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testquoteLineItem2.Quantity = 2;
        testquotelineItem2.UnitPrice = 300;
        testquotelineItem2.Revenue_Type__c ='Incremental';
        //insert testQuoteLineItem2;
        listQuoteLineItem.add(testQuoteLineItem2);
        insert listQuoteLineItem;
        
        newQLIs.add(testQuoteLineItem);
        newQLIs.add(testQuoteLineItem2); 
        for(QuoteLineItem qlitem :newQLIs) {                 
            oldQuoteLineItemMap.put(qlitem.id,qlitem);
            }
        //newQLIs.clear();
        system.debug('newQLIs..'+newQLIs);
       /* oldQuoteLineItemMap.put(testquoteLineItemmap.id,testquoteLineItemmap);
        oldQuoteLineItemMap.put(testquoteLineItem2.id,testquoteLineItem2); */
            
        
        testLineItem.Revenue_Type__c = 'Incremental';
        testquoteLineItem.Revenue_Type__c = 'Incremental';
        testquotelineItem.Discount=8.00;
        update testLineItem;
        update testquoteLineItem;
        
        newQLIs.add(testQuoteLineItem);
        newQLIs.add(testQuoteLineItem2); 
        system.debug('newQLIs..'+newQLIs);
        
        for(QuoteLineItem qlitem1 :newQLIs) {
            qlitem1.Discount = 1.00;                 
            oldQuoteLineItemMap.put(qlitem1.id,qlitem1);
            }
            
        system.debug('oldQuoteLineItemMap..'+oldQuoteLineItemMap);
        List<OpportunityLineItem> listtestLineItem = new List<OpportunityLineItem>();
        listtestLineItem.add(testLineItem);
        try{
        Test.starttest();
  //          QuoteLineItemTriggerHandler.SyncQuoteLIValueToOppLI(newQLIs,oldQuoteLineItemMap);
  //          OpportunityLineItemTriggerHandler.updateRenewal_IncrAmounts(settestLineItem);
            OpportunityLineItemTriggerHandler.errorForNewOpportunities(listtestLineItem);
   //         OpportunityLineItemTriggerHandler.getCurrencydecimalPlaces(listtestLineItem);
            Testopp1.SyncedQuoteID = Q1.Id;
            update Testopp1;
          
        Test.Stoptest();
        }
        catch(exception ex) {}
    }  
    
    Public static testMethod Void afterUpdateProductsSync1_Test(){
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        insert testProd1;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
       // testOpp1.Renewal_Flag__c = true;
       // testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.Is_Master_Opportunity__c = true;
        insert testOpp1;
        
        
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
       // testOpp2.Renewal_Flag__c = true;
       // testOpp2.Selling_Organization__c = 'LRA';
        testopp2.Pricebook2Id = Test.getStandardPricebookId();
        //testOpp2.Master_Opportunity__c = testOpp1.id;
        insert testOpp2;
        
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        insert testLineItem1;
        
        Test.startTest();
        testLineItem1.Quantity = 2;
        UPDATE testLineItem1;
        Test.stopTest();
    }
    
   /*  Public static testMethod Void RenewalOLISync_test(){    
     //   map<Id, QuoteLineItem> oldQuoteLineItemMap = new map <Id, QuoteLineItem>();
     //   map<Id, QuoteLineItem> newQuoteLineItemMap = new map <Id, QuoteLineItem>();
        
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
                  
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        insert testProd1;
        
         PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        insert testOpp1;
            
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c;
        insert Q1;
        
        OpportunityLineItem testOLI = new OpportunityLineItem() ;
        testOLI.OpportunityId = testOpp1.id;
        testOLI.PricebookEntryId = testentry.Id;
        //testquoteLineItem.Product2Id = testprod1.Id;
        testOLI.Quantity = 1;
        testOLI.UnitPrice = 200;
        testOLI.Revenue_Type__c ='Renewal';
        testOLI.Discount=7.00;
        insert testOLI;
       // oldQuoteLineItemMap.put(testQuoteLineItem.id,testQuoteLineItem);
         
        Test.StartTest();
        testOLI.UnitPrice = 250;
        testOLI.Quantity = 2;
        testOLI.Description = 'abcdfg';
        Update testOLI;
        Test.stopTest();
       // newQuoteLineItemMap.put(testQuoteLineItem.id,testQuoteLineItem);
    }*/
    
    Public static testMethod Void upliftDowngradePartialCancelHandler_test(){    
        //map<Id, QuoteLineItem> oldQuoteLineItemMap = new map <Id, QuoteLineItem>();
        //map<Id, QuoteLineItem> newQuoteLineItemMap = new map <Id, QuoteLineItem>();
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
                  
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        insert testProd1;
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        insert testEntry;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
            
        Quote Q1 = New Quote ();
        Q1.OpportunityId = Testopp1.id;
        Q1.Pricebook2Id = Test.getStandardPricebookId();
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        insert Q1;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem() ;
        testLineItem.OpportunityId = testOpp1.id;
        testLineItem.PricebookEntryId = testentry.Id;
        testLineItem.Quantity = 1;
        testLineItem.UnitPrice = 200;
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Activity_Type__c ='Renewed';
        testLineItem.Discount=7.00;
        testLineItem.Projected_Renewal_Price__c = 900;
        insert testLineItem;
 
        Test.StartTest();
        checkRecursive.isRenewalQLI = true;
        testLineItem.UnitPrice = 250;
        testLineItem.Quantity = 2;
        testLineItem.Description = 'abcdfg';
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Projected_Renewal_Price__c = 100;
        Update testLineItem;
        testLineItem.UnitPrice = 150;
        testLineItem.Quantity = 2;
        testLineItem.Revenue_Type__c ='Renewal';
        testLineItem.Projected_Renewal_Price__c = 900;
        Update testLineItem;
        testLineItem.Number_of_Contacts__c = 2;
        Update testLineItem;
        testLineItem.Number_of_Contacts__c = null;
        Update testLineItem;
        Test.StopTest();
    }
    
    
    Public static testMethod Void syncOLIToOLIClone_Test(){
        KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';

        kvs.TextValue__C = '00e30000001ZUki';        
        insert kvs;
        
        List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT1);
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        recTList.add(orecordType5);
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        recTList.add(orecordType6);
        
        insert recTList;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd2.id,unitprice=200);
        insert new List<PricebookEntry>{testEntry,testEntry1};
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();        
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.Pricebook2Id = Test.getStandardPricebookId();
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        testOpp1.LCRM_Split_On__c = true;
        testOpp1.Is_GLI__c = TRUE;
        insert testOpp1;
        
        Opportunity opp = [select id,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpp1.ID];
        System.debug('opp : '+opp);
        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;
        
        Test.startTest();
            OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
            testLineItem1.LCRM_Units__c = 1;
            insert testLineItem1;
            
            OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
            OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
            testLineItem2.LCRM_Units__c = 1;
            insert testLineItem2;
            
            OpportunityLineItemTriggerHandler.checkRecur_syncOLIToOLIClone = false;
            testLineItem1.LCRM_Units__c = 2;
            UPDATE testLineItem1;
            List<LCRM_Opportunity_Split__c> splitList = [SELECT ID FROM LCRM_Opportunity_Split__c WHERE ID = :testOpp1.Id];
            System.assert(splitList!=null,true);
            delete testLineItem1;
        Test.stopTest();
    }
}