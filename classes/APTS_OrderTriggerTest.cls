@SuppressWarnings('PMD.NcssMethodCount')
@isTest(seeAllData = false)
private class APTS_OrderTriggerTest {
     static testMethod void validateOpptyStageForActivatedProposals() {
     
     LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
         
     Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        
        System.assertequals('test-sg',a.Name,'Success');
        
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        
        KeyValueListStore__c keyval1 = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        keyvaluestoreList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
         List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
         
        //Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
        
       Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                                  ProductCode = '41318361',
                                  WLEC_Product_Category__c='SS',
                                  APTS_Product_Pricing_Model__c = 'INCOME TAX');     
       insert oProduct;
       
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        opp.RecordtypeId=opptyRecorType;
        opp.Source_System_Detail__c=accountSSD.id;
        opp.Account=a;
        insert opp; 
         
       Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
       proposal.Apttus_Proposal__Account__c=a.id;
       proposal.APTS_SSD_Sold_To__c=accountSSD.id;
       proposal.Apttus_Proposal__Opportunity__c = opp.id;
       proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
       proposal.APTS_Existing_Database__c=true;
       proposal.APTS_Client_Database_Code__c='12345';
       insert proposal;
        
        
        Map<id,Apttus_Config2__Order__c> ordersMap = new Map<id,Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
        order.Apttus_QPConfig__ProposalId__c = proposal.id;
        order.Apttus_Config2__ActivatedDate__c=null;       
        order.IDOC__c=null; 
        insert order;  
        System.debug(LoggingLevel.DEBUG,'Order @ 1'+ order.Id + order.Apttus_QPConfig__ProposalId__c + order.Apttus_Config2__Status__c + order.IDOC__c + order.APTS_SAP_Status__c);
         ordersMap.put(order.id,order);
         Apttus_Config2__Order__c order1 = [Select Name,IDOC__c,Apttus_Config2__Status__c,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__c,
        Apttus_QPConfig__ProposalId__r.Name,Apttus_Config2__OrderDate__c 
        from Apttus_Config2__Order__c where Id = :order.Id ];
        System.debug(LoggingLevel.DEBUG,'Order @ 2'+ order1.Id + order1.Apttus_QPConfig__ProposalId__c +  order1.Apttus_Config2__Status__c + order1.IDOC__c + order1.APTS_SAP_Status__c);
        Apttus_Config2__AssetLineItem__c asl = new Apttus_Config2__AssetLineItem__c (name='test', Apttus_Config2__AssetStatus__c= 'New');
         
        insert asl;
         
        CORPPRODFAMILY__c family = new CORPPRODFAMILY__c(Name = 'INCOME TAX', Product_Pricing_Model__c = 'INCOME TAX');
        insert family;
         

        Apttus_Config2__OrderLineItem__c oli = new Apttus_Config2__OrderLineItem__c (Apttus_Config2__LineStatus__c ='New',
                                                                                     Apttus_Config2__OrderId__c=order1.id,
                                                                                     Apttus_Config2__ProductId__c = oProduct.Id,
                                                                                      Apttus_QPConfig__ProposalId__c=proposal.Id,
                                                                                    Apttus_Config2__AssetLineItemId__c=asl.id,
                                                                                    APTS_Proposal_Business_Unit__c='Corp OneOTC US');
    
        insert oli;
       
         
        Test.startTest();
        List<Apttus_Config2__Order__c> listOfOrders = new List<Apttus_Config2__Order__c>();
        order.Apttus_Config2__Status__c='Activated';
        order.APTS_SAP_Status__c = 'Order Completed';
        order.IDOC__c='123455';
        update order;
        listOfOrders.add(order);
        System.debug(LoggingLevel.DEBUG,'Order @ 3'+ order.Id + order.Apttus_QPConfig__ProposalId__c + order.Apttus_Config2__Status__c + order.IDOC__c + order.APTS_SAP_Status__c);
        //APTS_OrderTriggerHelper.updateOpportunity(listOfOrders);
        //APTS_OrderTriggerHelper.databaseEntitlement(listOfOrders,ordersMap);
        Test.stopTest();  
       }   
    static testMethod void testmethod1() {
    
    LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
         
     Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        
        System.assertequals('test-sg',a.Name,'Success');
        
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        
        KeyValueListStore__c keyval1 = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        keyvaluestoreList.add(keyval1);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        
         List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
         
     // Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
       Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                                  ProductCode = '41318361',
                                  WLEC_Product_Category__c='SS',
                                  APTS_Product_Pricing_Model__c = 'INCOME TAX');  
         Product2 oProduct1=new Product2(Name ='1SRC NRA Banner Interface',
                                  ProductCode = '41318361',
                                  WLEC_Product_Category__c='SS',
                                  APTS_Product_Pricing_Model__c = 'INCOME TAX');    
       insert oProduct1;
       
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        opp.RecordtypeId=opptyRecorType;
        opp.Source_System_Detail__c=accountSSD.id;
        opp.Account=a;
        insert opp; 
         
       Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
       proposal.Apttus_Proposal__Account__c=a.id;
       proposal.APTS_SSD_Sold_To__c=accountSSD.id;
       proposal.Apttus_Proposal__Opportunity__c = opp.id;
       proposal.APTS_Proposal_Business_Unit__c = 'SCS';
       proposal.APTS_Existing_Database__c=true;
       proposal.APTS_Client_Database_Code__c='12345';
       insert proposal;

        Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
        order1.Apttus_QPConfig__ProposalId__c = proposal.id;
          
        insert order1;
        System.debug(LoggingLevel.DEBUG,'Order @ 4'+ order1.Id + order1.Apttus_QPConfig__ProposalId__c + order1.Apttus_Config2__Status__c + order1.IDOC__c + order1.APTS_SAP_Status__c);       
         Apttus_Config2__Order__c order2 = [Select Name,IDOC__c,Apttus_Config2__Status__c,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__c,
        Apttus_QPConfig__ProposalId__r.Name,Apttus_Config2__OrderDate__c 
        from Apttus_Config2__Order__c where Id = :order1.Id ];  
        System.debug(LoggingLevel.DEBUG,'Order @ 5'+ order2.Id + order2.Apttus_QPConfig__ProposalId__c + order2.Apttus_Config2__Status__c + order2.IDOC__c + order2.APTS_SAP_Status__c); 
        Apttus_Config2__AssetLineItem__c asl = new Apttus_Config2__AssetLineItem__c (name='test', Apttus_Config2__AssetStatus__c='New');
        insert asl;
         
        CORPPRODFAMILY__c family = new CORPPRODFAMILY__c(Name = 'INCOME TAX', Product_Pricing_Model__c = 'INCOME TAX');
        insert family;
         
                   list<Apttus_Config2__OrderLineItem__c> olilist =new list<Apttus_Config2__OrderLineItem__c>();
        Apttus_Config2__OrderLineItem__c oli = new Apttus_Config2__OrderLineItem__c (Apttus_Config2__LineStatus__c ='New',
                                                                                     Apttus_Config2__OrderId__c=order2.id,
                                                                                     Apttus_Config2__ProductId__c = oProduct.Id,
                                                                                      Apttus_QPConfig__ProposalId__c=proposal.Id,
                                                                                    Apttus_Config2__AssetLineItemId__c=asl.id,
                                                                                    APTS_Proposal_Business_Unit__c='SCS');
    olilist.add(oli);
          Apttus_Config2__OrderLineItem__c oli1 = new Apttus_Config2__OrderLineItem__c (Apttus_Config2__LineStatus__c ='New',
                                                                                     Apttus_Config2__OrderId__c=order2.id,
                                                                                     Apttus_Config2__ProductId__c = oProduct1.Id,
                                                                                      Apttus_QPConfig__ProposalId__c=proposal.Id,
                                                                                    Apttus_Config2__AssetLineItemId__c=asl.id,
                                                                                    APTS_Proposal_Business_Unit__c='SCS');
         olilist.add(oli1);   
        insert olilist;
        
         
        Test.startTest();
        order1.Apttus_Config2__Status__c='Activated';
        order1.APTS_SAP_Status__c = 'Order Cancelled';
        update order1; 
        List<Apttus_Config2__Order__c> listOfOrders = new List<Apttus_Config2__Order__c>();
            listOfOrders.add(order1);
        System.debug(LoggingLevel.DEBUG,'Order @ 6'+ order1.Id + order1.Apttus_QPConfig__ProposalId__c + order1.Apttus_Config2__Status__c + order1.IDOC__c + order1.APTS_SAP_Status__c);             
            
        //APTS_OrderTriggerHelper.activateOrder(listOfOrders);  
        Test.stopTest();  
       }
        static testMethod void taxprofdatescalculation() {
         
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        
        System.assertequals('test-sg',a.Name,'Success');
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
        
        };        
        insert keyValueList;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
         
        //Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                                  ProductCode = '41318361',
                                  WLEC_Product_Category__c='SS',
                                  APTS_Product_Pricing_Model__c = 'INCOME TAX');  
        Product2 oProduct1=new Product2(Name ='1SRC NRA Banner Interface',
                                  ProductCode = '41318361',
                                  WLEC_Product_Category__c='SS',
                                  APTS_Product_Pricing_Model__c = 'INCOME TAX');    
        insert oProduct1;
       
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        opp.RecordtypeId=opptyRecorType;
        opp.Source_System_Detail__c=accountSSD.id;
        opp.Account=a;
        insert opp; 
         
        Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.Apttus_Proposal__Opportunity__c = opp.id;
        proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        proposal.APTS_Existing_Database__c=true;
        proposal.APTS_Client_Database_Code__c='12345';
        insert proposal;

        Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
        order1.Apttus_QPConfig__ProposalId__c = proposal.id;
        order1.APTS_SAP_Status__c  = 'Pending';
        insert order1;
        
        Apttus_Config2__Order__c order2 = [Select Name,IDOC__c,Apttus_Config2__Status__c,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__c,Apttus_QPConfig__ProposalId__r.Name,Apttus_Config2__OrderDate__c,APTS_Proposal_Business_Unit__c from Apttus_Config2__Order__c where Id = :order1.Id ];  
         
        CORPPRODFAMILY__c family = new CORPPRODFAMILY__c(Name = 'INCOME TAX', Product_Pricing_Model__c = 'INCOME TAX');
        insert family;
        
        List<Apttus_Config2__AssetLineItem__c> alilist = new List<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali1 = new Apttus_Config2__AssetLineItem__c();
        ali1.Name = 'test1';
        ali1.Apttus_Config2__AssetStatus__c = 'New';
        alilist.add(ali1);
        
        Apttus_Config2__AssetLineItem__c ali2 = new Apttus_Config2__AssetLineItem__c();
        ali2.Name = 'test2';
        ali2.Apttus_Config2__AssetStatus__c = 'New';
        alilist.add(ali2);
        
        Apttus_Config2__AssetLineItem__c ali3 = new Apttus_Config2__AssetLineItem__c();
        ali3.Name = 'test3';
        ali3.Apttus_Config2__AssetStatus__c = 'New';
        alilist.add(ali3);
        
        Apttus_Config2__AssetLineItem__c ali4 = new Apttus_Config2__AssetLineItem__c();
        ali4.Name = 'test4';
        ali4.Apttus_Config2__AssetStatus__c = 'New';
        alilist.add(ali4);
        
        Apttus_Config2__AssetLineItem__c ali5 = new Apttus_Config2__AssetLineItem__c();
        ali5.Name = 'test5';
        ali5.Apttus_Config2__AssetStatus__c = 'New';
        alilist.add(ali5);
        
        Apttus_Config2__AssetLineItem__c ali6 = new Apttus_Config2__AssetLineItem__c();
        ali6.Name = 'test6';
        ali6.Apttus_Config2__AssetStatus__c = 'New';
        alilist.add(ali6);
        
        Apttus_Config2__AssetLineItem__c ali7 = new Apttus_Config2__AssetLineItem__c();
        ali6.Name = 'test7';
        ali6.Apttus_Config2__AssetStatus__c = 'New';
        alilist.add(ali7);
        
        insert alilist;
         
        List<Apttus_Config2__OrderLineItem__c> olilist =new List<Apttus_Config2__OrderLineItem__c>();
        Apttus_Config2__OrderLineItem__c oli1 = new Apttus_Config2__OrderLineItem__c();
        oli1.Apttus_Config2__LineStatus__c = 'New';
        oli1.Apttus_Config2__OrderId__c = order2.id;
        oli1.Apttus_Config2__ProductId__c = oProduct.Id;
        oli1.Apttus_QPConfig__ProposalId__c = proposal.Id;
        oli1.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        oli1.APTS_Bridge__c = '1 Month';
        oli1.APTS_Contract_Term__c = '1 Year';
        oli1.APTS_Term_Type__c  = 'Future Start Date';
        oli1.Apttus_Config2__StartDate__c = System.Date.today();
        oli1.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli1.Apttus_Config2__AssetLineItemId__c = ali1.Id;
        olilist.add(oli1);
        
        Apttus_Config2__OrderLineItem__c oli2 = new Apttus_Config2__OrderLineItem__c();
        oli2.Apttus_Config2__LineStatus__c = 'New';
        oli2.Apttus_Config2__OrderId__c = order2.id;
        oli2.Apttus_Config2__ProductId__c = oProduct.Id;
        oli2.Apttus_QPConfig__ProposalId__c = proposal.Id;
        oli2.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        oli2.APTS_Bridge__c = '10 Months';
        oli2.APTS_Contract_Term__c = '2 Years';
        oli2.APTS_Term_Type__c  = NULL;
        oli2.Apttus_Config2__StartDate__c = System.Date.today();
        oli2.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli2.Apttus_Config2__AssetLineItemId__c = ali2.Id;
        olilist.add(oli2);
        
        Apttus_Config2__OrderLineItem__c oli3 = new Apttus_Config2__OrderLineItem__c();
        oli3.Apttus_Config2__LineStatus__c = 'New';
        oli3.Apttus_Config2__OrderId__c = order2.id;
        oli3.Apttus_Config2__ProductId__c = oProduct.Id;
        oli3.Apttus_QPConfig__ProposalId__c = proposal.Id;
        oli3.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        oli3.APTS_Contract_Term__c = '3 Years';
        oli3.APTS_Term_Type__c  = NULL;
        oli3.Apttus_Config2__StartDate__c = System.Date.today();
        oli3.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli3.Apttus_Config2__AssetLineItemId__c = ali3.Id;
        olilist.add(oli3);
        
        Apttus_Config2__OrderLineItem__c oli4 = new Apttus_Config2__OrderLineItem__c();
        oli4.Apttus_Config2__LineStatus__c = 'New';
        oli4.Apttus_Config2__OrderId__c = order2.id;
        oli4.Apttus_Config2__ProductId__c = oProduct.Id;
        oli4.Apttus_QPConfig__ProposalId__c = proposal.Id;
        oli4.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        oli4.APTS_Contract_Term__c = '4 Years';
        oli4.APTS_Term_Type__c  = 'Future Start Date';
        oli4.Apttus_Config2__StartDate__c = System.Date.today();
        oli4.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli4.Apttus_Config2__AssetLineItemId__c = ali4.Id;
        olilist.add(oli4);
        
        Apttus_Config2__OrderLineItem__c oli5 = new Apttus_Config2__OrderLineItem__c();
        oli5.Apttus_Config2__LineStatus__c = 'New';
        oli5.Apttus_Config2__OrderId__c = order2.id;
        oli5.Apttus_Config2__ProductId__c = oProduct.Id;
        oli5.Apttus_QPConfig__ProposalId__c = proposal.Id;
        oli5.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        oli5.APTS_Contract_Term__c = '5 Years';
        oli5.APTS_Term_Type__c  = 'Co-term';
        oli5.Apttus_Config2__StartDate__c = System.Date.today();
        oli5.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli5.Apttus_Config2__AssetLineItemId__c = ali5.Id;
        olilist.add(oli5);
        
        Apttus_Config2__OrderLineItem__c oli6 = new Apttus_Config2__OrderLineItem__c();
        oli6.Apttus_Config2__LineStatus__c = 'New';
        oli6.Apttus_Config2__OrderId__c = order2.id;
        oli6.Apttus_Config2__ProductId__c = oProduct.Id;
        oli6.Apttus_QPConfig__ProposalId__c = proposal.Id;
        oli6.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        oli6.APTS_Contract_Term__c = '5 Years';
        oli6.APTS_Term_Type__c  = 'Future Start Date and Co-term';
        oli6.Apttus_Config2__StartDate__c = System.Date.today();
        oli6.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli6.Apttus_Config2__AssetLineItemId__c = ali6.Id;
        olilist.add(oli6);
        
        Apttus_Config2__OrderLineItem__c oli7 = new Apttus_Config2__OrderLineItem__c();
        oli7.Apttus_Config2__LineStatus__c = 'New';
        oli7.Apttus_Config2__OrderId__c = order2.id;
        oli7.Apttus_Config2__ProductId__c = oProduct.Id;
        oli7.Apttus_QPConfig__ProposalId__c = proposal.Id;
        oli7.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        oli7.APTS_Bridge__c = '10 Months';
        oli7.APTS_Contract_Term__c = '5 Years';
        oli7.APTS_Term_Type__c  = 'Future Start Date and Co-term';
        oli7.Apttus_Config2__StartDate__c = System.Date.today();
        oli7.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli7.Apttus_Config2__AssetLineItemId__c = ali7.Id;
        olilist.add(oli7);
        
        insert olilist;
         
        Test.startTest();
        order1.Apttus_Config2__Status__c = 'Activated';
        order1.APTS_SAP_Status__c = 'Order Submitted';
        update order1; 
        
        List<Apttus_Config2__Order__c> listOfOrders = new List<Apttus_Config2__Order__c>();
        listOfOrders.add(order1);
       
        Test.stopTest();  
       }
        static testMethod void testhelper2()
       {
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist; 
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        
        KeyValueListStore__c lCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        lCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        lCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(lCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'CreditCheck',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings1 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings2 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'EnterpriseWSDL',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings3 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'StatusPostbackLocation',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wsList = new List<WebServiceSettings__c>{oWebServiceSettings, o1WebServiceSettings, 
                        o1WebServiceSettings1, o1WebServiceSettings2, o1WebServiceSettings3};
        insert wsList ;
        
        Account acc1 =APTS_TestDataFactory.createAccount('Test');
        acc1.FrozenMarketSegment__c = valueMarket;
        acc1.Customer_Group__c='FEDERAL GOVERNMENT';
        acc1.CurrencyIsoCode='USD';
        acc1.Sales_Org__c='LLEY';
        acc1.Customer_Type__c = 'Individual';
        acc1.Industry = 'TAX';
        acc1.BillingStreet = '275 BATTERY ST STE 1500';
        acc1.BillingCity = 'SAN FRANCISCO';
        acc1.BillingState = 'CA';
        acc1.BillingPostalCode = '94111-3334';
        acc1.BillingCountry = 'US';
        acc1.Is_Customer_Review_Complete__c=true;        
        insert acc1;

        System.assertequals('Test',acc1.name,'Success');
        
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD.name ='test source system';
        accountSSD.city__c='CA';
        accountSSD.Account_Name__c=acc1.Id;
        accountSSD.Source_System_Name__c='Test SSD';
        accountSSD.country__c ='US';
        accountSSD.LCRM_Industry__c='TAX';
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD.State__c='CA';
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Source_System_Account_Number__c='12345678';
        accountSSD.CurrencyIsoCode='USD';
               
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='LLEY';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        
        List<Source_System_Detail__c> ssdlist = new List<Source_System_Detail__c>{accountSSD,accountSSD1};
        insert ssdlist;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        
        Opportunity oppty1=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty1.RecordtypeId=opptyRecorType;
        oppty1.Source_System_Detail__c=accountSSD1.id;
        
        List<Opportunity> opptylist = new List<Opportunity>{oppty,oppty1};
        insert opptylist;
                
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_SSD_ship_to__c=accountSSD.id;
        oProposal.APTS_SSD_bill_to__c=accountSSD.id;
        oProposal.APTS_SSD_Sold_To__c =accountSSD.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='SCS';
        
        Apttus_Proposal__Proposal__c oProposal1=APTS_TestDataFactory.createProposal(oppty1.id,accountSSD1.Id);
        oProposal1.RecordtypeId=propRecorType;
        oProposal1.Apttus_Proposal__Account__c=acc1.id;
        oProposal1.APTS_SSD_ship_to__c=accountSSD1.id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD1.id;
        oProposal1.APTS_SSD_Sold_To__c =accountSSD1.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.APTS_Proposal_Business_Unit__c='Argentina-LLEY';
        oProposal1.APTS_Case_Brand_Value__c = 'ACRITAS';
        List<Apttus_Proposal__Proposal__c> proplist = new List<Apttus_Proposal__Proposal__c>{oProposal,oProposal1};
        insert proplist;
      
        oProposal.APTS_Case_Brand_Value__c = 'ACRITAS';
        update oProposal1;
        
        Product2 prod1=new Product2(Name ='1SRC NRA Banner Interface',ProductCode = '41318361',APTS_Availability_Date__c = System.Today() + 7,Product_Level_2__c = 'ACRITAS');
        insert prod1;
        
        Test.startTest();
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = oProposal.Id,Apttus_Config2__FinalizedDate__c = System.Today());
        
        Apttus_Config2__ProductConfiguration__c prodConfig1 = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = oProposal1.Id,Apttus_Config2__FinalizedDate__c = System.Today());
        
        List<Apttus_Config2__ProductConfiguration__c> configlist = new List<Apttus_Config2__ProductConfiguration__c>{prodConfig,prodConfig1};       
        insert configlist;
            Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c= oProposal1.id);
           insert pl1;
        Apttus_QPConfig__ProposalProductAttributeValue__c propattr = new Apttus_QPConfig__ProposalProductAttributeValue__c();
        propattr.Apttus_QPConfig__LineItemId__c = pl1.Id;
        propattr.APTS_Total_Number_of_Points__c  = 10; 
           insert propattr;
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=1,
            Apttus_Config2__ProductId__c = prod1.Id ); 
            
            Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig1.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=1,
            Apttus_Config2__ProductId__c = prod1.Id ); 
            
            List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>{linObj3,linObj4};
        insert lineitemlist;
        
        Apttus_Proposal__Proposal_Line_Item__c plItem2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Media_High_Level__c='Online',
          APTS_Online_Contacts_Validation__c=FALSE,
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineNumber__c = 1, 
          IP_Address_Check__c=false,
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=oProposal.id);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Media_High_Level__c='Online',
          APTS_Online_Contacts_Validation__c=FALSE,
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__ConfigurationId__c = prodConfig1.id, 
          Apttus_QPConfig__LineNumber__c = 1, 
          IP_Address_Check__c=false,
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=oProposal1.id);
          
          List<Apttus_Proposal__Proposal_Line_Item__c> plilist = new List<Apttus_Proposal__Proposal_Line_Item__c>{plItem2,plItem3};
          
        insert plilist;
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        
        order1.APTS_SSD_Sold_To__c = accountSSD.Id;
        order1.APTS_SSD_Ship_To__c = accountSSD.Id;
        order1.APTS_SSD_bill_to__c = accountSSD.Id;
        order1.APTS_Payer__c = accountSSD.Id; 
      
        Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order2.Apttus_QPConfig__ProposalId__c=oProposal1.id;
        
        order2.APTS_SSD_Sold_To__c = accountSSD1.Id;
        order2.APTS_SSD_Ship_To__c = accountSSD1.Id;
        order2.APTS_SSD_bill_to__c = accountSSD1.Id;
        order2.APTS_Payer__c = accountSSD1.Id; 
       
        List<Apttus_Config2__Order__c> orderlist = new List<Apttus_Config2__Order__c>{order1,order2};
        insert orderlist;
        
        Apttus_Config2__AssetLineItem__c ali1 = new Apttus_Config2__AssetLineItem__c();
        ali1.Name = 'test1';
        ali1.Apttus_Config2__AssetStatus__c = 'New';
        insert ali1;
        
        Apttus_Config2__OrderLineItem__c oli1 = new Apttus_Config2__OrderLineItem__c();
        oli1.Apttus_Config2__LineStatus__c = 'New';
        oli1.Apttus_Config2__OrderId__c = order1.id;
        oli1.Apttus_Config2__ProductId__c = prod1.Id;
        oli1.Apttus_QPConfig__ProposalId__c = oProposal.Id; 
        oli1.APTS_Bridge__c = '1 Month';
        oli1.APTS_Contract_Term__c = '1 Year';
        oli1.APTS_Term_Type__c  = 'Future Start Date';
        oli1.Apttus_Config2__StartDate__c = System.Date.today();
        oli1.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli1.Apttus_Config2__AssetLineItemId__c = ali1.Id;
        
        Apttus_Config2__OrderLineItem__c oli2 = new Apttus_Config2__OrderLineItem__c();
        oli2.Apttus_Config2__LineStatus__c = 'New';
        oli2.Apttus_Config2__OrderId__c = order2.id;
        oli2.Apttus_Config2__ProductId__c = prod1.Id;
        oli2.Apttus_QPConfig__ProposalId__c = oProposal1.Id; 
        oli2.APTS_Bridge__c = '1 Month';
        oli2.APTS_Contract_Term__c = '1 Year';
        oli2.APTS_Term_Type__c  = 'Future Start Date';
        oli2.Apttus_Config2__StartDate__c = System.Date.today();
        oli2.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
        oli2.Apttus_Config2__AssetLineItemId__c = ali1.Id;
        
        List<Apttus_Config2__OrderLineItem__c> olilist = new List<Apttus_Config2__OrderLineItem__c>{oli1,oli2};
           
        insert olilist;
            order1.APTS_Platform_Event_Triggered__c = false;
            order2.APTS_SAP_Status__c = 'Pending';
            List<Apttus_Config2__Order__c> orderupdatelist = new List<Apttus_Config2__Order__c>{order1,order2};
                List<Apttus_Config2__Order__c> orderl = new List<Apttus_Config2__Order__c>{order1};
                  APTS_OrderTriggerHelper3.integrationloggerNotSAP(orderl);
            update orderupdatelist;
          
        Test.StopTest();  
       }
    static testMethod void helper2()
       {
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account acc1 =APTS_TestDataFactory.createAccount('Test');
        acc1.FrozenMarketSegment__c = valueMarket;
        acc1.Customer_Group__c='FEDERAL GOVERNMENT';
        acc1.CurrencyIsoCode='USD';
        acc1.Sales_Org__c='WEST';
        acc1.Customer_Type__c = 'Individual';
        acc1.Industry = 'TAX';
        acc1.BillingStreet = '275 BATTERY ST STE 1500';
        acc1.BillingCity = 'SAN FRANCISCO';
        acc1.BillingState = 'CA';
        acc1.BillingPostalCode = '94111-3334';
        acc1.BillingCountry = 'US';
        acc1.Is_Customer_Review_Complete__c=true;
        
        //Insert acc1;
       // System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        //insert con;
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='S100';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.Country__c='US';
        accountSSD1.LCRM_Phone__c='8765435677';
        accountSSD1.Postal_Code__c='94111-3334';
        //insert accountSSD1;
        
        String uslRECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(uslRECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
       // insert oppty;
        
        Test.startTest();
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_SSD_ship_to__c=accountSSD1.id;
        oProposal.APTS_SSD_bill_to__c=accountSSD1.id;
        oProposal.APTS_SSD_Sold_To__c =accountSSD1.id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD1.id;
        oProposal.APTS_Payment_Option__c='Bill to Account';
       // insert oProposal;
        
        
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
      //  insert oProductB;
      //  insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
     //   insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
       
     //   insert order1;
        
         Map<String, String> stringMap = new Map<String, String>();
         stringMap.put('billingcase','billingcase');  
         stringMap.put('entcase','entcase');  
       Boolean b1 = APTS_OrderTriggerHelper2.createCreditCheckCase(order1,stringMap);
       System.assertEquals(false,b1,'equal');
        APTS_OrderTriggerHelper2.createCreditCheckCaseIntLogger(order1, new List<ID>{order1.ID}, new Map<String, String>{'billingcase'=>'billingcase', 'entcase'=>'entcase'});
        Test.StopTest();
    }
    
    
    static testmethod void helper2b(){
        
    Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
    insert ordersub;
    
    
    String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL),
            new KeyValueListStore__c(Name='BigRuleProductId',TextValue__c='SF03'),
            new KeyValueListStore__c(Name='BigRuleCconfigGroup',TextValue__c='TRX'),
            new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='https://na68.salesforce.com/services/apexrest/customerpostback'),
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
            new KeyValueListStore__c(Name='ESIProductId',TextValue__c='SF03'),
            new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='TRX'),
            new KeyValueListStore__c(Name='BOOMIProductId',TextValue__c='SF12'),
            new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
            };
                
                insert keyValueList;
    
    List<IXOSCodeMap__c> codemapList=new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='S100',Dist_Chan_Code__c='00',Division_Code__c='00',Company_Code__c='1078',Sales_Org_Code__c='S100')};
        
        insert codemapList;
    
    List<BigRuleGenericSettings__c> bigrulesettingList=new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='CG:FEDERAL GOVERNMENT',Value__c='03'),new BigRuleGenericSettings__c(Name='IND:TAX',Value__c='TAX')};
        
        insert bigrulesettingList;

        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        System.assertequals('Pipeline Opportunities',recordtype1.Name,'Success');    
    
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
    String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
    
    Account acc1 =APTS_TestDataFactory.createAccount('Test');
    acc1.FrozenMarketSegment__c = valueMarket;
    acc1.Customer_Group__c='FEDERAL GOVERNMENT';
    acc1.CurrencyIsoCode='USD';
    acc1.Sales_Org__c='LLEY';
    acc1.Customer_Type__c = 'Individual';
    acc1.Industry = 'TAX';
    acc1.BillingStreet = '275 BATTERY ST STE 1500';
    acc1.BillingCity = 'SAN FRANCISCO';
    acc1.BillingState = 'CA';
    acc1.BillingPostalCode = '94111-3334';
    acc1.BillingCountry = 'US';
      
    Insert acc1;

    System.assertequals('Test',acc1.name,'Success');
           
    Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
    accountSSD1.name ='test source system';
    accountSSD1.city__c='CA';
    accountSSD1.Account_Name__c=acc1.Id;
    accountSSD1.Source_System_Name__c='Test SSD';
    accountSSD1.country__c ='US';
    accountSSD1.LCRM_Industry__c='TAX';
    accountSSD1.LCRM_Sales_Org__c='LLEY';
    accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
    accountSSD1.State__c='CA';
    accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
    accountSSD1.Source_System_Account_Number__c='12345678';
    accountSSD1.CurrencyIsoCode='USD';
 //  insert accountSSD1;
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=accountSSD1.id;
  //  insert oppty;
            
    Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
    oProposal.RecordtypeId=propRecorType;
    oProposal.Apttus_Proposal__Account__c=acc1.id;
    oProposal.APTS_SSD_ship_to__c=accountSSD1.id;
    oProposal.APTS_SSD_bill_to__c=accountSSD1.id;
    oProposal.APTS_SSD_Sold_To__c =accountSSD1.id;
    oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
    oProposal.APTS_Proposal_Business_Unit__c='Argentina-LLEY';
  //  insert oProposal;
    system.debug(logginglevel.DEBUG,'KS--> Proposal Business Unit '+oProposal.APTS_Proposal_Business_Unit__c);
    
    oProposal.APTS_Case_Brand_Value__c = 'ACRITAS';
   // update oProposal;
    
    Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
  
    order1.APTS_SSD_Sold_To__c = accountSSD1.Id;
    order1.APTS_SSD_Ship_To__c = accountSSD1.Id;
    order1.APTS_SSD_bill_to__c = accountSSD1.Id;
    order1.APTS_Payer__c = accountSSD1.Id; 
  //  insert order1;
    
    Test.startTest();
    APTS_OrderTriggerHelper2.callcasecreation(order1);
   
    Test.StopTest();
   }
    static testMethod void helper1method() 
    {
         
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
    insert a;
    
    System.assertequals('test-sg',a.Name,'Success');
    
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
    
    };        
    insert keyValueList;
    
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    insert recordlist;
     
    //Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=a.ID;
    accountSSD.LCRM_Customer_Group__c='Academic';
    accountSSD.LCRM_Sales_Org__c='WEST';
    insert accountSSD;
    
    Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                              ProductCode = '41318361',
                              WLEC_Product_Category__c='SS',
                              APTS_Product_Pricing_Model__c = 'INCOME TAX');  
    Product2 oProduct1=new Product2(Name ='1SRC NRA Banner Interface',
                              ProductCode = '41318361',
                              WLEC_Product_Category__c='SS',
                              APTS_Product_Pricing_Model__c = 'INCOME TAX');    
    insert oProduct1;
   
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
    opp.RecordtypeId=opptyRecorType;
    opp.Source_System_Detail__c=accountSSD.id;
    opp.Account=a;
    insert opp; 
     
    Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
    proposal.Apttus_Proposal__Account__c=a.id;
    proposal.APTS_SSD_Sold_To__c=accountSSD.id;
    proposal.Apttus_Proposal__Opportunity__c = opp.id;
    proposal.APTS_Proposal_Business_Unit__c = 'SCS';
    proposal.APTS_Existing_Database__c=true;
    proposal.APTS_Client_Database_Code__c='12345';
    insert proposal;

    Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
    order1.Apttus_QPConfig__ProposalId__c = proposal.id;
    order1.APTS_SAP_Status__c  = 'Pending';
    order1.APTS_Platform_Event_Triggered__c = false;    
    order1.APTS_SSD_Sold_To__c = accountSSD.id;
    insert order1;
    
  
     
    CORPPRODFAMILY__c family = new CORPPRODFAMILY__c(Name = 'INCOME TAX', Product_Pricing_Model__c = 'INCOME TAX');
    insert family;
    
    List<Apttus_Config2__AssetLineItem__c> alilist = new List<Apttus_Config2__AssetLineItem__c>();
    Apttus_Config2__AssetLineItem__c ali1 = new Apttus_Config2__AssetLineItem__c();
    ali1.Name = 'test1';
    ali1.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali1);
    
    Apttus_Config2__AssetLineItem__c ali2 = new Apttus_Config2__AssetLineItem__c();
    ali2.Name = 'test2';
    ali2.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali2);
    
    Apttus_Config2__AssetLineItem__c ali3 = new Apttus_Config2__AssetLineItem__c();
    ali3.Name = 'test3';
    ali3.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali3);
    
    Apttus_Config2__AssetLineItem__c ali4 = new Apttus_Config2__AssetLineItem__c();
    ali4.Name = 'test4';
    ali4.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali4);
    
    Apttus_Config2__AssetLineItem__c ali5 = new Apttus_Config2__AssetLineItem__c();
    ali5.Name = 'test5';
    ali5.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali5);
    
    Apttus_Config2__AssetLineItem__c ali6 = new Apttus_Config2__AssetLineItem__c();
    ali6.Name = 'test6';
    ali6.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali6);
    
    Apttus_Config2__AssetLineItem__c ali7 = new Apttus_Config2__AssetLineItem__c();
    ali6.Name = 'test7';
    ali6.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali7);
    
    insert alilist;
     
    List<Apttus_Config2__OrderLineItem__c> olilist =new List<Apttus_Config2__OrderLineItem__c>();
    Apttus_Config2__OrderLineItem__c oli1 = new Apttus_Config2__OrderLineItem__c();
    oli1.Apttus_Config2__LineStatus__c = 'New';
    oli1.Apttus_Config2__OrderId__c = order1.id;
    oli1.Apttus_Config2__ProductId__c = oProduct.Id;
    oli1.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli1.APTS_Proposal_Business_Unit__c = 'SCS';
  
    oli1.APTS_Bridge__c = '1 Month';
    oli1.APTS_Contract_Term__c = '1 Year';
    oli1.APTS_Term_Type__c  = 'Future Start Date';
    oli1.Apttus_Config2__StartDate__c = System.Date.today();
    oli1.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli1.Apttus_Config2__AssetLineItemId__c = ali1.Id;
    olilist.add(oli1);
    
    Apttus_Config2__OrderLineItem__c oli2 = new Apttus_Config2__OrderLineItem__c();
    oli2.Apttus_Config2__LineStatus__c = 'New';
    oli2.Apttus_Config2__OrderId__c = order1.id;
    oli2.Apttus_Config2__ProductId__c = oProduct.Id;
    oli2.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli2.APTS_Proposal_Business_Unit__c = 'SCS';
  
    oli2.APTS_Bridge__c = '10 Months';
    oli2.APTS_Contract_Term__c = '2 Years';
    oli2.APTS_Term_Type__c  = NULL;
    oli2.Apttus_Config2__StartDate__c = System.Date.today();
    oli2.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli2.Apttus_Config2__AssetLineItemId__c = ali2.Id;
    olilist.add(oli2);
    
    Apttus_Config2__OrderLineItem__c oli3 = new Apttus_Config2__OrderLineItem__c();
    oli3.Apttus_Config2__LineStatus__c = 'New';
    oli3.Apttus_Config2__OrderId__c = order1.id;
    oli3.Apttus_Config2__ProductId__c = oProduct.Id;
    oli3.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli3.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
    oli3.APTS_Contract_Term__c = '3 Years';

    oli3.APTS_Term_Type__c  = NULL;
    oli3.Apttus_Config2__StartDate__c = System.Date.today();
    oli3.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli3.Apttus_Config2__AssetLineItemId__c = ali3.Id;
    olilist.add(oli3);
    
    Apttus_Config2__OrderLineItem__c oli4 = new Apttus_Config2__OrderLineItem__c();
    oli4.Apttus_Config2__LineStatus__c = 'New';
    oli4.Apttus_Config2__OrderId__c = order1.id;
    oli4.Apttus_Config2__ProductId__c = oProduct.Id;
    oli4.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli4.APTS_Proposal_Business_Unit__c = 'Canada';
 
    oli4.APTS_Contract_Term__c = '4 Years';
    oli4.APTS_Term_Type__c  = 'Future Start Date';
    oli4.Apttus_Config2__StartDate__c = System.Date.today();
    oli4.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli4.Apttus_Config2__AssetLineItemId__c = ali4.Id;
    olilist.add(oli4);
    
    Apttus_Config2__OrderLineItem__c oli5 = new Apttus_Config2__OrderLineItem__c();
    oli5.Apttus_Config2__LineStatus__c = 'New';
    oli5.Apttus_Config2__OrderId__c = order1.id;
    oli5.Apttus_Config2__ProductId__c = oProduct.Id;
    oli5.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli5.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US' ;
    oli5.APTS_Contract_Term__c = '5 Years';
   
    oli5.APTS_Term_Type__c  = 'Co-term';
    oli5.Apttus_Config2__StartDate__c = System.Date.today();
    oli5.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli5.Apttus_Config2__AssetLineItemId__c = ali5.Id;
    olilist.add(oli5);
    
    Apttus_Config2__OrderLineItem__c oli6 = new Apttus_Config2__OrderLineItem__c();
    oli6.Apttus_Config2__LineStatus__c = 'New';
    oli6.Apttus_Config2__OrderId__c = order1.id;
    oli6.Apttus_Config2__ProductId__c = oProduct.Id;
    oli6.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli6.APTS_Proposal_Business_Unit__c =  'FindLaw';
    oli6.APTS_Contract_Term__c = '5 Years';
    oli6.APTS_Term_Type__c  = 'Future Start Date and Co-term';

    oli6.Apttus_Config2__StartDate__c = System.Date.today();
    oli6.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli6.Apttus_Config2__AssetLineItemId__c = ali6.Id;
    olilist.add(oli6);
    
    Apttus_Config2__OrderLineItem__c oli7 = new Apttus_Config2__OrderLineItem__c();
    oli7.Apttus_Config2__LineStatus__c = 'New';
    oli7.Apttus_Config2__OrderId__c = order1.id;
    oli7.Apttus_Config2__ProductId__c = oProduct.Id;
    oli7.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli7.APTS_Proposal_Business_Unit__c ='Corp OneOTC UK';
    oli7.APTS_Bridge__c = '10 Months';
    oli7.APTS_Contract_Term__c = '5 Years';
    oli7.APTS_Term_Type__c  = 'Future Start Date and Co-term';

    oli7.Apttus_Config2__StartDate__c = System.Date.today();
    oli7.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli7.Apttus_Config2__AssetLineItemId__c = ali7.Id;
    olilist.add(oli7);
    
    insert olilist;
     
    Test.startTest();
    order1.Apttus_Config2__Status__c = 'Activated';
    order1.APTS_SAP_Status__c = 'Order Submitted';
    update order1; 
    
    List<Apttus_Config2__Order__c> listOfOrders = new List<Apttus_Config2__Order__c>();
    listOfOrders.add(order1);
   
    Test.stopTest();  
   }
static testMethod void testhelper1r()
{
 Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
 String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
 
 List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
 RecordtypeIds__c recordtype=new RecordtypeIds__c();
 recordtype.Name='Pre-Pipeline Opportunities';
 recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
 recordlist.add(recordtype);
 
 RecordtypeIds__c recordtype1=new RecordtypeIds__c();
 recordtype1.Name='Pipeline Opportunities';
 recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
 recordlist.add(recordtype1);
 insert recordlist; 
 List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
 KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
 keyvaluestore.Name='ANZUsersProfileId';
 keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
 
 KeyValueListStore__c lCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
 lCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
 lCRMStrikeIronFlagINS1.TextValue__c='True';
 keyvaluestoreList.add(lCRMStrikeIronFlagINS1 );
 keyvaluestoreList.add(keyvaluestore);
 
 KeyValueListStore__c keyval = new KeyValueListStore__c();
 keyval.Name='ReasonWithCompetitor';
 keyval.TextValue__c='Price';
 keyvaluestoreList.add(keyval);
 insert keyvaluestoreList;
 
 WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
 Active__c = true,
 Name = 'CreditCheck',
 Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
 Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
 
 WebServiceSettings__c o1WebServiceSettings1 = new WebServiceSettings__c(
 Active__c = true,
 Name = 'Payment AutoCharge',
 Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
 Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
 
 WebServiceSettings__c o1WebServiceSettings2 = new WebServiceSettings__c(
 Active__c = true,
 Name = 'EnterpriseWSDL',
 Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
 Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
 
 WebServiceSettings__c o1WebServiceSettings3 = new WebServiceSettings__c(
 Active__c = true,
 Name = 'StatusPostbackLocation',
 Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
 Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
 
 WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
 oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
 oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
 oWebServiceSettings.Timeout__c = 120; 
 oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
 oWebServiceSettings.Active__c = true;
 
 List<WebServiceSettings__c> wsList = new List<WebServiceSettings__c>{oWebServiceSettings, o1WebServiceSettings, 
                 o1WebServiceSettings1, o1WebServiceSettings2, o1WebServiceSettings3};
 insert wsList ;
 
 Account acc1 =APTS_TestDataFactory.createAccount('Test');
 acc1.FrozenMarketSegment__c = valueMarket;
 acc1.Customer_Group__c='FEDERAL GOVERNMENT';
 acc1.CurrencyIsoCode='USD';
 acc1.Sales_Org__c='LLEY';
 acc1.Customer_Type__c = 'Individual';
 acc1.Industry = 'TAX';
 acc1.BillingStreet = '275 BATTERY ST STE 1500';
 acc1.BillingCity = 'SAN FRANCISCO';
 acc1.BillingState = 'CA';
 acc1.BillingPostalCode = '94111-3334';
 acc1.BillingCountry = 'US';
 acc1.Is_Customer_Review_Complete__c=true;        
 insert acc1;

 System.assertequals('Test',acc1.name,'Success');
 
 Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(acc1);
 accountSSD.name ='test source system';
 accountSSD.city__c='CA';
 accountSSD.Account_Name__c=acc1.Id;
 accountSSD.Source_System_Name__c='Test SSD';
 accountSSD.country__c ='US';
 accountSSD.LCRM_Industry__c='TAX';
 accountSSD.LCRM_Sales_Org__c='WEST';
 accountSSD.Number_Street__c='275 BATTERY ST STE 1500';
 accountSSD.State__c='CA';
 accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
 accountSSD.Source_System_Account_Number__c='12345678';
 accountSSD.CurrencyIsoCode='USD';
        
 Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
 accountSSD1.name ='test source system';
 accountSSD1.city__c='CA';
 accountSSD1.Account_Name__c=acc1.Id;
 accountSSD1.Source_System_Name__c='Test SSD';
 accountSSD1.country__c ='US';
 accountSSD1.LCRM_Industry__c='TAX';
 accountSSD1.LCRM_Sales_Org__c='LLEY';
 accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
 accountSSD1.State__c='CA';
 accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
 accountSSD1.Source_System_Account_Number__c='12345678';
 accountSSD1.CurrencyIsoCode='USD';
 
 List<Source_System_Detail__c> ssdlist = new List<Source_System_Detail__c>{accountSSD,accountSSD1};
 insert ssdlist;
 
 Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
 Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
 oppty.RecordtypeId=opptyRecorType;
 oppty.Source_System_Detail__c=accountSSD.id;
 
 Opportunity oppty1=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
 oppty1.RecordtypeId=opptyRecorType;
 oppty1.Source_System_Detail__c=accountSSD1.id;
 
 List<Opportunity> opptylist = new List<Opportunity>{oppty,oppty1};
 insert opptylist;
         
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
 Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD.Id);
 oProposal.RecordtypeId=propRecorType;
 oProposal.Apttus_Proposal__Account__c=acc1.id;
 oProposal.APTS_SSD_ship_to__c=accountSSD.id;
 oProposal.APTS_SSD_bill_to__c=accountSSD.id;
 oProposal.APTS_SSD_Sold_To__c =accountSSD.id;
 oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
 oProposal.APTS_Proposal_Business_Unit__c='Canada';
 
 Apttus_Proposal__Proposal__c oProposal1=APTS_TestDataFactory.createProposal(oppty1.id,accountSSD1.Id);
 oProposal1.RecordtypeId=propRecorType;
 oProposal1.Apttus_Proposal__Account__c=acc1.id;
 oProposal1.APTS_SSD_ship_to__c=accountSSD1.id;
 oProposal1.APTS_SSD_bill_to__c=accountSSD1.id;
 oProposal1.APTS_SSD_Sold_To__c =accountSSD1.id;
 oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
 oProposal1.APTS_Proposal_Business_Unit__c='FindLaw';
 oProposal1.APTS_Case_Brand_Value__c = 'ACRITAS';
 List<Apttus_Proposal__Proposal__c> proplist = new List<Apttus_Proposal__Proposal__c>{oProposal,oProposal1};
 insert proplist;
 
 oProposal.APTS_Case_Brand_Value__c = 'ACRITAS';
 update oProposal1;
 
 Product2 prod1=new Product2(Name ='1SRC NRA Banner Interface',ProductCode = '41318361',APTS_Availability_Date__c = System.Today() + 7,Product_Level_2__c = 'ACRITAS');
 insert prod1;
 
 Test.startTest();
 
 Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = oProposal.Id,Apttus_Config2__FinalizedDate__c = System.Today());
 
 Apttus_Config2__ProductConfiguration__c prodConfig1 = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = oProposal1.Id,Apttus_Config2__FinalizedDate__c = System.Today());
 
 List<Apttus_Config2__ProductConfiguration__c> configlist = new List<Apttus_Config2__ProductConfiguration__c>{prodConfig,prodConfig1};       
 insert configlist;
 
 Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
     Apttus_Config2__Quantity__c=1,
     Apttus_Config2__ConfigurationId__c = prodConfig.id, 
     Apttus_Config2__LineType__c = 'Product/Service',
     Apttus_Config2__LineNumber__c = 1, 
     Apttus_Config2__ItemSequence__c = 2,
     Apttus_Config2__NetPrice__c=1,
     Apttus_Config2__ProductId__c = prod1.Id ); 
     
     Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
     Apttus_Config2__Quantity__c=1,
     Apttus_Config2__ConfigurationId__c = prodConfig1.id, 
     Apttus_Config2__LineType__c = 'Product/Service',
     Apttus_Config2__LineNumber__c = 1, 
     Apttus_Config2__ItemSequence__c = 2,
     Apttus_Config2__NetPrice__c=1,
     Apttus_Config2__ProductId__c = prod1.Id ); 
     
     List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>{linObj3,linObj4};
 insert lineitemlist;
 
 Apttus_Proposal__Proposal_Line_Item__c plItem2 = new Apttus_Proposal__Proposal_Line_Item__c(          
   Apttus_Proposal__Quantity__c=1,
   APTS_Media_High_Level__c='Online',
   APTS_Online_Contacts_Validation__c=FALSE,
   Apttus_QPConfig__LineType__c = 'Product/Service',
   Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
   Apttus_QPConfig__LineNumber__c = 1, 
   IP_Address_Check__c=false,
   Apttus_QPConfig__ItemSequence__c = 1,
   Apttus_QPConfig__NetPrice__c=1,
   Apttus_Proposal__Proposal__c=oProposal.id);
   
   Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(          
   Apttus_Proposal__Quantity__c=1,
   APTS_Media_High_Level__c='Online',
   APTS_Online_Contacts_Validation__c=FALSE,
   Apttus_QPConfig__LineType__c = 'Product/Service',
   Apttus_QPConfig__ConfigurationId__c = prodConfig1.id, 
   Apttus_QPConfig__LineNumber__c = 1, 
   IP_Address_Check__c=false,
   Apttus_QPConfig__ItemSequence__c = 1,
   Apttus_QPConfig__NetPrice__c=1,
   Apttus_Proposal__Proposal__c=oProposal1.id);
   
   List<Apttus_Proposal__Proposal_Line_Item__c> plilist = new List<Apttus_Proposal__Proposal_Line_Item__c>{plItem2,plItem3};
   
 insert plilist;
 
 Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD.Id);
 order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
 
 order1.APTS_SSD_Sold_To__c = accountSSD.Id;
 order1.APTS_SSD_Ship_To__c = accountSSD.Id;
 order1.APTS_SSD_bill_to__c = accountSSD.Id;
 order1.APTS_Payer__c = accountSSD.Id; 
 
 Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
 order2.Apttus_QPConfig__ProposalId__c=oProposal1.id;
 
 order2.APTS_SSD_Sold_To__c = accountSSD1.Id; 
 order2.APTS_SSD_Ship_To__c = accountSSD1.Id;
 order2.APTS_SSD_bill_to__c = accountSSD1.Id;
 order2.APTS_Payer__c = accountSSD1.Id; 
 
 List<Apttus_Config2__Order__c> orderlist = new List<Apttus_Config2__Order__c>{order1,order2};
 insert orderlist;
 
 Apttus_Config2__AssetLineItem__c ali1 = new Apttus_Config2__AssetLineItem__c();
 ali1.Name = 'test1';
 ali1.Apttus_Config2__AssetStatus__c = 'New';
 insert ali1;
 
 Apttus_Config2__OrderLineItem__c oli1 = new Apttus_Config2__OrderLineItem__c();
 oli1.Apttus_Config2__LineStatus__c = 'New';
 oli1.Apttus_Config2__OrderId__c = order1.id;
 oli1.Apttus_Config2__ProductId__c = prod1.Id;
 oli1.Apttus_QPConfig__ProposalId__c = oProposal.Id; 
 oli1.APTS_Bridge__c = '1 Month';
 oli1.APTS_Contract_Term__c = '1 Year';
 oli1.APTS_Term_Type__c  = 'Future Start Date';
 oli1.Apttus_Config2__StartDate__c = System.Date.today();
 oli1.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
 oli1.Apttus_Config2__AssetLineItemId__c = ali1.Id;
 
 Apttus_Config2__OrderLineItem__c oli2 = new Apttus_Config2__OrderLineItem__c();
 oli2.Apttus_Config2__LineStatus__c = 'New';
 oli2.Apttus_Config2__OrderId__c = order2.id;
 oli2.Apttus_Config2__ProductId__c = prod1.Id;
 oli2.Apttus_QPConfig__ProposalId__c = oProposal1.Id; 
 oli2.APTS_Bridge__c = '1 Month';
 oli2.APTS_Contract_Term__c = '1 Year';
 oli2.APTS_Term_Type__c  = 'Future Start Date';
 oli2.Apttus_Config2__StartDate__c = System.Date.today();
 oli2.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
 oli2.Apttus_Config2__AssetLineItemId__c = ali1.Id;
 
 List<Apttus_Config2__OrderLineItem__c> olilist = new List<Apttus_Config2__OrderLineItem__c>{oli1,oli2};
 insert olilist;
     order1.APTS_Platform_Event_Triggered__c = false;
     order2.APTS_SAP_Status__c = 'Pending';
     List<Apttus_Config2__Order__c> orderupdatelist = new List<Apttus_Config2__Order__c>{order1,order2};
     update orderupdatelist;
 Test.StopTest();  
}
  

    static testMethod void helpermethodRY2() 
    {
         
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
    insert a;
    
    System.assertequals('test-sg',a.Name,'Success');
    
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
    
    };        
    insert keyValueList;
    
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    insert recordlist;
     
    //Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=a.ID;
    accountSSD.LCRM_Customer_Group__c='Academic';
    accountSSD.LCRM_Sales_Org__c='WEST';
    insert accountSSD;
    
    Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                              ProductCode = '41318361',
                              WLEC_Product_Category__c='SS',
                              APTS_Product_Pricing_Model__c = 'INCOME TAX');  
    Product2 oProduct1=new Product2(Name ='1SRC NRA Banner Interface',
                              ProductCode = '41318361',
                              WLEC_Product_Category__c='SS',
                              APTS_Product_Pricing_Model__c = 'INCOME TAX');    
    insert oProduct1;
   
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
    opp.RecordtypeId=opptyRecorType;
    opp.Source_System_Detail__c=accountSSD.id;
    opp.Account=a;
    insert opp; 
     
    Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
    proposal.Apttus_Proposal__Account__c=a.id;
    proposal.APTS_SSD_Sold_To__c=accountSSD.id;
    proposal.Apttus_Proposal__Opportunity__c = opp.id;
    proposal.APTS_Proposal_Business_Unit__c = 'SCS';
    proposal.APTS_Existing_Database__c=true;
    proposal.APTS_Client_Database_Code__c='12345';
    proposal.APTS_Payment_Option__c = 'Credit Card';
    insert proposal;

    Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
    order1.Apttus_QPConfig__ProposalId__c = proposal.id;
    order1.APTS_SAP_Status__c  = 'Pending';
    order1.APTS_Platform_Event_Triggered__c = false;    
    order1.APTS_SSD_Sold_To__c = accountSSD.id;
    insert order1;
    
  
     
    CORPPRODFAMILY__c family = new CORPPRODFAMILY__c(Name = 'INCOME TAX', Product_Pricing_Model__c = 'INCOME TAX');
    insert family;
    
    List<Apttus_Config2__AssetLineItem__c> alilist = new List<Apttus_Config2__AssetLineItem__c>();
    Apttus_Config2__AssetLineItem__c ali1 = new Apttus_Config2__AssetLineItem__c();
    ali1.Name = 'test1';
    ali1.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali1);
    
    Apttus_Config2__AssetLineItem__c ali2 = new Apttus_Config2__AssetLineItem__c();
    ali2.Name = 'test2';
    ali2.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali2);
    
    Apttus_Config2__AssetLineItem__c ali3 = new Apttus_Config2__AssetLineItem__c();
    ali3.Name = 'test3';
    ali3.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali3);
    
    Apttus_Config2__AssetLineItem__c ali4 = new Apttus_Config2__AssetLineItem__c();
    ali4.Name = 'test4';
    ali4.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali4);
    
    Apttus_Config2__AssetLineItem__c ali5 = new Apttus_Config2__AssetLineItem__c();
    ali5.Name = 'test5';
    ali5.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali5);
    
    Apttus_Config2__AssetLineItem__c ali6 = new Apttus_Config2__AssetLineItem__c();
    ali6.Name = 'test6';
    ali6.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali6);
    
    Apttus_Config2__AssetLineItem__c ali7 = new Apttus_Config2__AssetLineItem__c();
    ali6.Name = 'test7';
    ali6.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali7);
    
    insert alilist;
     
    List<Apttus_Config2__OrderLineItem__c> olilist =new List<Apttus_Config2__OrderLineItem__c>();
    Apttus_Config2__OrderLineItem__c oli1 = new Apttus_Config2__OrderLineItem__c();
    oli1.Apttus_Config2__LineStatus__c = 'New';
    oli1.Apttus_Config2__OrderId__c = order1.id;
    oli1.Apttus_Config2__ProductId__c = oProduct.Id;
    oli1.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli1.APTS_Proposal_Business_Unit__c = 'SCS';
  
    oli1.APTS_Bridge__c = '1 Month';
    oli1.APTS_Contract_Term__c = '1 Year';
    oli1.APTS_Term_Type__c  = 'Future Start Date';
    oli1.Apttus_Config2__StartDate__c = System.Date.today();
    oli1.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli1.Apttus_Config2__AssetLineItemId__c = ali1.Id;
    olilist.add(oli1);
    
    Apttus_Config2__OrderLineItem__c oli2 = new Apttus_Config2__OrderLineItem__c();
    oli2.Apttus_Config2__LineStatus__c = 'New';
    oli2.Apttus_Config2__OrderId__c = order1.id;
    oli2.Apttus_Config2__ProductId__c = oProduct.Id;
    oli2.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli2.APTS_Proposal_Business_Unit__c = 'SCS';
  
    oli2.APTS_Bridge__c = '10 Months';
    oli2.APTS_Contract_Term__c = '2 Years';
    oli2.APTS_Term_Type__c  = NULL;
    oli2.Apttus_Config2__StartDate__c = System.Date.today();
    oli2.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli2.Apttus_Config2__AssetLineItemId__c = ali2.Id;
    olilist.add(oli2);
    
    Apttus_Config2__OrderLineItem__c oli3 = new Apttus_Config2__OrderLineItem__c();
    oli3.Apttus_Config2__LineStatus__c = 'New';
    oli3.Apttus_Config2__OrderId__c = order1.id;
    oli3.Apttus_Config2__ProductId__c = oProduct.Id;
    oli3.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli3.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
    oli3.APTS_Contract_Term__c = '3 Years';

    oli3.APTS_Term_Type__c  = NULL;
    oli3.Apttus_Config2__StartDate__c = System.Date.today();
    oli3.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli3.Apttus_Config2__AssetLineItemId__c = ali3.Id;
    olilist.add(oli3);
    
    Apttus_Config2__OrderLineItem__c oli4 = new Apttus_Config2__OrderLineItem__c();
    oli4.Apttus_Config2__LineStatus__c = 'New';
    oli4.Apttus_Config2__OrderId__c = order1.id;
    oli4.Apttus_Config2__ProductId__c = oProduct.Id;
    oli4.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli4.APTS_Proposal_Business_Unit__c = 'Canada';
 
    oli4.APTS_Contract_Term__c = '4 Years';
    oli4.APTS_Term_Type__c  = 'Future Start Date';
    oli4.Apttus_Config2__StartDate__c = System.Date.today();
    oli4.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli4.Apttus_Config2__AssetLineItemId__c = ali4.Id;
    olilist.add(oli4);
    
    Apttus_Config2__OrderLineItem__c oli5 = new Apttus_Config2__OrderLineItem__c();
    oli5.Apttus_Config2__LineStatus__c = 'New';
    oli5.Apttus_Config2__OrderId__c = order1.id;
    oli5.Apttus_Config2__ProductId__c = oProduct.Id;
    oli5.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli5.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US' ;
    oli5.APTS_Contract_Term__c = '5 Years';
   
    oli5.APTS_Term_Type__c  = 'Co-term';
    oli5.Apttus_Config2__StartDate__c = System.Date.today();
    oli5.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli5.Apttus_Config2__AssetLineItemId__c = ali5.Id;
    olilist.add(oli5);
    
    Apttus_Config2__OrderLineItem__c oli6 = new Apttus_Config2__OrderLineItem__c();
    oli6.Apttus_Config2__LineStatus__c = 'New';
    oli6.Apttus_Config2__OrderId__c = order1.id;
    oli6.Apttus_Config2__ProductId__c = oProduct.Id;
    oli6.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli6.APTS_Proposal_Business_Unit__c =  'FindLaw';
    oli6.APTS_Contract_Term__c = '5 Years';
    oli6.APTS_Term_Type__c  = 'Future Start Date and Co-term';

    oli6.Apttus_Config2__StartDate__c = System.Date.today();
    oli6.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli6.Apttus_Config2__AssetLineItemId__c = ali6.Id;
    olilist.add(oli6);
    
    Apttus_Config2__OrderLineItem__c oli7 = new Apttus_Config2__OrderLineItem__c();
    oli7.Apttus_Config2__LineStatus__c = 'New';
    oli7.Apttus_Config2__OrderId__c = order1.id;
    oli7.Apttus_Config2__ProductId__c = oProduct.Id;
    oli7.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli7.APTS_Proposal_Business_Unit__c ='Corp OneOTC UK';
    oli7.APTS_Bridge__c = '10 Months';
    oli7.APTS_Contract_Term__c = '5 Years';
    oli7.APTS_Term_Type__c  = 'Future Start Date and Co-term';

    oli7.Apttus_Config2__StartDate__c = System.Date.today();
    oli7.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli7.Apttus_Config2__AssetLineItemId__c = ali7.Id;
    olilist.add(oli7);
    
    insert olilist;
     
    Test.startTest();
    order1.Apttus_Config2__Status__c = 'Activated';
    order1.APTS_SAP_Status__c = 'Order Submitted';
    update order1; 
    
    List<Apttus_Config2__Order__c> listOfOrders = new List<Apttus_Config2__Order__c>();
    listOfOrders.add(order1);
   
    Test.stopTest();  
   }
   
   static testMethod void testHelper2startCaseCreation() 
    {
         
    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
    insert a;
    
    System.assertequals('test-sg',a.Name,'Success');
    
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
    
    };        
    insert keyValueList;
    
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    insert recordlist;
     
    //Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=a.ID;
    accountSSD.LCRM_Customer_Group__c='Academic';
    accountSSD.LCRM_Sales_Org__c='WEST';
    insert accountSSD;
    
    Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                              ProductCode = '41318361',
                              WLEC_Product_Category__c='SS',
                              APTS_Product_Pricing_Model__c = 'INCOME TAX');  
    Product2 oProduct1=new Product2(Name ='1SRC NRA Banner Interface',
                              ProductCode = '41318361',
                              WLEC_Product_Category__c='SS',
                              APTS_Product_Pricing_Model__c = 'INCOME TAX');    
    insert oProduct1;
   
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
    opp.RecordtypeId=opptyRecorType;
    opp.Source_System_Detail__c=accountSSD.id;
    opp.Account=a;
    insert opp; 
     
    Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
    proposal.Apttus_Proposal__Account__c=a.id;
    proposal.APTS_SSD_Sold_To__c=accountSSD.id;
    proposal.Apttus_Proposal__Opportunity__c = opp.id;
    proposal.APTS_Proposal_Business_Unit__c = 'SCS';
    proposal.APTS_Existing_Database__c=true;
    proposal.APTS_Client_Database_Code__c='12345';
    proposal.APTS_Payment_Option__c = 'Credit Card';
    insert proposal;

    Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
    order1.Apttus_QPConfig__ProposalId__c = proposal.id;
    order1.APTS_SAP_Status__c  = 'Pending';
    order1.APTS_Platform_Event_Triggered__c = false;    
    order1.APTS_SSD_Sold_To__c = accountSSD.id;
    insert order1;
    List<Apttus_Config2__Order__c> liOrder = new List<Apttus_Config2__Order__c>();
    liOrder.add(order1);
  
     
    CORPPRODFAMILY__c family = new CORPPRODFAMILY__c(Name = 'INCOME TAX', Product_Pricing_Model__c = 'INCOME TAX');
    insert family;
    
    List<Apttus_Config2__AssetLineItem__c> alilist = new List<Apttus_Config2__AssetLineItem__c>();
    Apttus_Config2__AssetLineItem__c ali1 = new Apttus_Config2__AssetLineItem__c();
    ali1.Name = 'test1';
    ali1.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali1);
    
    Apttus_Config2__AssetLineItem__c ali2 = new Apttus_Config2__AssetLineItem__c();
    ali2.Name = 'test2';
    ali2.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali2);
    
    Apttus_Config2__AssetLineItem__c ali3 = new Apttus_Config2__AssetLineItem__c();
    ali3.Name = 'test3';
    ali3.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali3);
    
    Apttus_Config2__AssetLineItem__c ali4 = new Apttus_Config2__AssetLineItem__c();
    ali4.Name = 'test4';
    ali4.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali4);
    
    Apttus_Config2__AssetLineItem__c ali5 = new Apttus_Config2__AssetLineItem__c();
    ali5.Name = 'test5';
    ali5.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali5);
    
    Apttus_Config2__AssetLineItem__c ali6 = new Apttus_Config2__AssetLineItem__c();
    ali6.Name = 'test6';
    ali6.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali6);
    
    Apttus_Config2__AssetLineItem__c ali7 = new Apttus_Config2__AssetLineItem__c();
    ali6.Name = 'test7';
    ali6.Apttus_Config2__AssetStatus__c = 'New';
    alilist.add(ali7);
    
    insert alilist;
     
    List<Apttus_Config2__OrderLineItem__c> olilist =new List<Apttus_Config2__OrderLineItem__c>();
    Apttus_Config2__OrderLineItem__c oli1 = new Apttus_Config2__OrderLineItem__c();
    oli1.Apttus_Config2__LineStatus__c = 'New';
    oli1.Apttus_Config2__OrderId__c = order1.id;
    oli1.Apttus_Config2__ProductId__c = oProduct.Id;
    oli1.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli1.APTS_Proposal_Business_Unit__c = 'SCS';
  
    oli1.APTS_Bridge__c = '1 Month';
    oli1.APTS_Contract_Term__c = '1 Year';
    oli1.APTS_Term_Type__c  = 'Future Start Date';
    oli1.Apttus_Config2__StartDate__c = System.Date.today();
    oli1.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli1.Apttus_Config2__AssetLineItemId__c = ali1.Id;
    olilist.add(oli1);
    
    Apttus_Config2__OrderLineItem__c oli2 = new Apttus_Config2__OrderLineItem__c();
    oli2.Apttus_Config2__LineStatus__c = 'New';
    oli2.Apttus_Config2__OrderId__c = order1.id;
    oli2.Apttus_Config2__ProductId__c = oProduct.Id;
    oli2.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli2.APTS_Proposal_Business_Unit__c = 'SCS';
  
    oli2.APTS_Bridge__c = '10 Months';
    oli2.APTS_Contract_Term__c = '2 Years';
    oli2.APTS_Term_Type__c  = NULL;
    oli2.Apttus_Config2__StartDate__c = System.Date.today();
    oli2.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli2.Apttus_Config2__AssetLineItemId__c = ali2.Id;
    olilist.add(oli2);
    
    Apttus_Config2__OrderLineItem__c oli3 = new Apttus_Config2__OrderLineItem__c();
    oli3.Apttus_Config2__LineStatus__c = 'New';
    oli3.Apttus_Config2__OrderId__c = order1.id;
    oli3.Apttus_Config2__ProductId__c = oProduct.Id;
    oli3.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli3.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
    oli3.APTS_Contract_Term__c = '3 Years';

    oli3.APTS_Term_Type__c  = NULL;
    oli3.Apttus_Config2__StartDate__c = System.Date.today();
    oli3.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli3.Apttus_Config2__AssetLineItemId__c = ali3.Id;
    olilist.add(oli3);
    
    Apttus_Config2__OrderLineItem__c oli4 = new Apttus_Config2__OrderLineItem__c();
    oli4.Apttus_Config2__LineStatus__c = 'New';
    oli4.Apttus_Config2__OrderId__c = order1.id;
    oli4.Apttus_Config2__ProductId__c = oProduct.Id;
    oli4.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli4.APTS_Proposal_Business_Unit__c = 'Canada';
 
    oli4.APTS_Contract_Term__c = '4 Years';
    oli4.APTS_Term_Type__c  = 'Future Start Date';
    oli4.Apttus_Config2__StartDate__c = System.Date.today();
    oli4.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli4.Apttus_Config2__AssetLineItemId__c = ali4.Id;
    olilist.add(oli4);
    
    Apttus_Config2__OrderLineItem__c oli5 = new Apttus_Config2__OrderLineItem__c();
    oli5.Apttus_Config2__LineStatus__c = 'New';
    oli5.Apttus_Config2__OrderId__c = order1.id;
    oli5.Apttus_Config2__ProductId__c = oProduct.Id;
    oli5.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli5.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US' ;
    oli5.APTS_Contract_Term__c = '5 Years';
   
    oli5.APTS_Term_Type__c  = 'Co-term';
    oli5.Apttus_Config2__StartDate__c = System.Date.today();
    oli5.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli5.Apttus_Config2__AssetLineItemId__c = ali5.Id;
    olilist.add(oli5);
    
    Apttus_Config2__OrderLineItem__c oli6 = new Apttus_Config2__OrderLineItem__c();
    oli6.Apttus_Config2__LineStatus__c = 'New';
    oli6.Apttus_Config2__OrderId__c = order1.id;
    oli6.Apttus_Config2__ProductId__c = oProduct.Id;
    oli6.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli6.APTS_Proposal_Business_Unit__c =  'FindLaw';
    oli6.APTS_Contract_Term__c = '5 Years';
    oli6.APTS_Term_Type__c  = 'Future Start Date and Co-term';

    oli6.Apttus_Config2__StartDate__c = System.Date.today();
    oli6.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli6.Apttus_Config2__AssetLineItemId__c = ali6.Id;
    olilist.add(oli6);
    
    Apttus_Config2__OrderLineItem__c oli7 = new Apttus_Config2__OrderLineItem__c();
    oli7.Apttus_Config2__LineStatus__c = 'New';
    oli7.Apttus_Config2__OrderId__c = order1.id;
    oli7.Apttus_Config2__ProductId__c = oProduct.Id;
    oli7.Apttus_QPConfig__ProposalId__c = proposal.Id;
    oli7.APTS_Proposal_Business_Unit__c ='Corp OneOTC UK';
    oli7.APTS_Bridge__c = '10 Months';
    oli7.APTS_Contract_Term__c = '5 Years';
    oli7.APTS_Term_Type__c  = 'Future Start Date and Co-term';

    oli7.Apttus_Config2__StartDate__c = System.Date.today();
    oli7.Apttus_Config2__EndDate__c = System.Date.today().addMonths(12);
    oli7.Apttus_Config2__AssetLineItemId__c = ali7.Id;
    olilist.add(oli7);
    
    insert olilist;
     
    Test.startTest();
    try{
    APTS_OrderTriggerHelper2.startCaseCreation(liOrder);        
       }catch(Exception ex){
           System.debug(LoggingLevel.DEBUG,ex);
       }
   
    Test.stopTest();  
   }
}