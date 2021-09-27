/*************************************************************
@Name:           LATAM_LATAM_BatchToCreateindicatorTest
@Author:         Harshpreet Singh
@CreateDate:     12/1/2019
@Test Class For: LATAM_BatchToCreateindicator
************************************************************/
@istest
private class LATAM_LATAM_BatchToCreateindicatorTest {
    
    static testmethod void testMethod_Canada(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        
        WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
                };      
                    insert keyValueList;
        
        Shipping_Method__c cs = new Shipping_Method__c();
        cs.Name='Fed Ex Next Day';
        cs.Value__c = 'F1';
        insert cs;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        
        Account testAcc = APTS_TestDataFactory.createAccount('Testing Account');
        testAcc.Country__c= 'Canada';
        insert testAcc;
        
        Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Source_System_Account_Number__c= '1458741';
        accountSSD.RecordTypeId = accRecordTypeIdSSD;
        insert accountSSD;
        
        Contact cont=APTS_TestDataFactory.createContact('LastName',testAcc.id);
        cont.FirstName='FirstName';
        cont.Email='abc@gmail.com';
        cont.Phone='1234567890';
        insert cont;
        
        PriceBook2 pb_Canada=new PriceBook2(Name ='TR Pricebook');
        insert pb_Canada;       
        
        Date todaysDate = system.today(); 
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = '06', Apttus_Config2__Uom__c = 'Attorneys');
        insert oProductB;     
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty = new Opportunity();
        oppty.AccountId = testAcc.Id;
        oppty.Name = 'Renew_Canada_Oppty';
        oppty.CloseDate = System.Today() + 5;
        oppty.StageName = 'Prospect';       
        oppty.Sales_Org__c='LLEY';
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Category__c='SUSCRIPCION';
        oppty.Pricebook2Id =pb_Canada.Id;
        oppty.RecordtypeId=oppRecordTypeId;
        insert oppty;
        
        System.debug('Canada Price Book '+pb_Canada.Id);
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert pl;
        
        List<Product2> productList =new List<Product2>();        
        Product2 product= APTS_TestDataFactory.createProduct('Test Product1', null);
        productList.add(product);
        Product2 product1= APTS_TestDataFactory.createProduct('Test Product2', null);
        productList.add(product1);
        insert productList;
        
        List<Apttus_Config2__PriceListItem__c> ListPli= new  List<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=product.id;
        pli.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli);
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=product.id;
        pli1.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli1);
        
        insert ListPli;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('void Renewal Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();        
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Canada';
        proposal.RecordtypeId = propRecorType; 
        proposal.APTS_Order_Confirmation_Contact__c =cont.Id;
        proposal.Apttus_Proposal__Primary_Contact__c=cont.Id;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.APTS_SSD_bill_to__c=accountSSD.Id;
        proposal.CurrencyIsoCode='CAD';
        proposal.Auto_Renewal_Quote__c=true; 
        proposal.Apttus_Proposal__ExpectedStartDate__c= System.today()-100;
        proposal.APTS_SSD_Ship_to__c=accountSSD.Id;        
        proposal.Apttus_QPConfig__IsSystemGenerated__c =True;
        proposal.Apttus_Proposal__Proposal_Name__c='Renew_Canada';       
        proposal.APTS_Temp_Order_Confirmation_Contact__c=cont.Id;
        proposal.Apttus_Proposal__Payment_Term__c = 'P030 - Brazil Net 30 days';
        proposal.APTS_Ground_Shipping__c = 'Ground Shipping - U.S. Only';
        proposal.Apttus_QPConfig__PONumber__c='a001';
        proposal.OwnerId = UserInfo.getUserId();
        
        Test.startTest();
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c pcon=new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c =proposal.id);
        pcon.Apttus_Config2__FinalizedDate__c = System.Today();
        pcon.Apttus_Config2__Status__c='Finalized';
        insert pcon;
        
        List<Apttus_Config2__LineItem__c> ListOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,  
            Apttus_Config2__ConfigurationId__c = pcon.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=1); 
        ListOfLineItems.add(linObj);
        
        linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = pcon.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=1 ); 
        ListOfLineItems.add(linObj);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = pcon.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=1,
            Apttus_Config2__ProductId__c = product.Id ); 
        ListOfLineItems.add(linObj3);
        
        insert ListOfLineItems;        
        
        List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c> ();
        propList.add(proposal);
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__ConfigurationId__c = pcon.id, 
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=12,
            Apttus_QPConfig__LineStatus__c ='Renewed',          
            Apttus_Proposal__Proposal__c=proposal.id);        
        lineItemList.add(pl1);
        
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__ConfigurationId__c = pcon.id, 
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 2, 
            Apttus_QPConfig__ItemSequence__c = 2,
            Apttus_QPConfig__NetPrice__c=10,
            Apttus_QPConfig__LineStatus__c ='Renewed',           
            Apttus_Proposal__Proposal__c=proposal.id);
        lineItemList.add(pl2);
        insert lineItemList;
        
        List<Apttus_Config2__AssetLineItem__c> listOfAssetLineItems = new List<Apttus_Config2__AssetLineItem__c>();
        
        Apttus_Config2__AssetLineItem__c asli1 = new Apttus_Config2__AssetLineItem__c();
        asli1.Apttus_Config2__AllowedActions__c='Renew';
        asli1.Apttus_Config2__AssetStatus__c='Activated';
        asli1.Renewal_quote_created__c=False;
        asli1.Name='Test_Asset1'; 
        asli1.APTS_Proposal_Business_Unit__c='Canada';       
        asli1.Apttus_QPConfig__ProposalId__c=proposal.id;
        asli1.APTS_SSD_Bill_To__c=accountSSD.Id;       
        asli1.APTS_SSD_Ship_to__c=accountSSD.Id;
        asli1.APTS_SSD_Sold_To__c=accountSSD.Id;  
        asli1.Apttus_QPConfig__ProposalLineItemId__c = pl1.ID;
        listOfAssetLineItems.add(asli1);        
        
        Apttus_Config2__AssetLineItem__c asli2 = new Apttus_Config2__AssetLineItem__c(); 
        asli2 .Name='Test_Asset2';
        asli2.Apttus_Config2__AllowedActions__c='Renew';
        asli2.Apttus_Config2__AssetStatus__c='Activated';
        asli2.APTS_Proposal_Business_Unit__c='Canada' ;
        asli2.Renewal_quote_created__c=False;             
        asli2.Apttus_QPConfig__ProposalId__c=proposal.id;
        asli2.APTS_SSD_Bill_To__c=accountSSD.Id;       
        asli2.APTS_SSD_Ship_to__c=accountSSD.Id;
        asli2.APTS_SSD_Sold_To__c=accountSSD.Id;  
        asli1.Apttus_QPConfig__ProposalLineItemId__c = pl2.ID;
        listOfAssetLineItems.add(asli2);        
        insert listOfAssetLineItems;
        
        System.debug('List of Proposal line item:'+lineItemList);
        String st = String.valueOf(system.today());
        List<Apttus_Proposal__Proposal__c> listOfProposalWithLI = new List<Apttus_Proposal__Proposal__c>();
        listOfProposalWithLI = [SELECT Id,Name,Apttus_Proposal__Proposal_Name__c,OwnerId,Auto_Renewal_Quote__c,Apttus_Proposal__Opportunity__r.Source_System_Detail__c,
                                APTS_SSD_bill_to__c, CurrencyIsoCode,APTS_SSD_Ship_to__c,APTS_SSD_Sold_To__c,APTS_Payer__c,                
                                APTS_Order_Confirmation_Contact__c,Apttus_Proposal__Primary_Contact__c,APTS_Approval_Segment__c,                
                                (select id, Related_Quote_Proposal__c ,APTS_Proposal_Business_Unit__c , Apttus_QPConfig__AssetLineItemId__r.Renewal_quote_created__c, 
                                 Apttus_QPConfig__NetPrice__c, Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__c, 
                                 Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Bill_To__c,Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Ship_to__c,APTS_SSD_ship_to__c,
                                 Apttus_QPConfig__AssetLineItemId__r.APTS_Proposal_Business_Unit__c,Apttus_QPConfig__AssetLineItemId__r.APTS_SSD_Sold_To__c,
                                 Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c , 
                                 Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Primary_Contact__c, 
                                 Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__r.CurrencyIsoCode 
                                 from Apttus_Proposal__R00N70000001yUfBEAU__r) 
                                from Apttus_Proposal__Proposal__c where Apttus_Proposal__Approval_Stage__c='Draft' and Apttus_QPConfig__IsSystemGenerated__c =true and Apttus_Proposal__Proposal_Name__c Like '%Renew%' ];
        
        System.debug('listOfProposalWithLI '+listOfProposalWithLI);
        LATAM_BatchToCreateindicator obj = new LATAM_BatchToCreateindicator();
        DataBase.executeBatch(obj);
        Database.QueryLocator ql = obj.start(null);
        obj.execute(null,listOfProposalWithLI);
        obj.Finish(null);
        
        Test.stopTest();
    }       
}