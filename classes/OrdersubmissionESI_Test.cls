@istest
public class OrdersubmissionESI_Test{
    @testSetup private static void setUp(){
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
        insert shippingMethod;
        List<MLAMediaLevelCode__c> mlaMedLevelCode=new List<MLAMediaLevelCode__c>{
        new MLAMediaLevelCode__c(Name='Code1',MLA_Media_High_Level_Code__c='06',MLA_Media_Lower_Level_Code__c='P7'),
        new MLAMediaLevelCode__c(Name='Code2',MLA_Media_High_Level_Code__c='13',MLA_Media_Lower_Level_Code__c='I9'),
        new MLAMediaLevelCode__c(Name='Code3',MLA_Media_High_Level_Code__c='06',MLA_Media_Lower_Level_Code__c='I9'),
        new MLAMediaLevelCode__c(Name='Code4',MLA_Media_High_Level_Code__c='07',MLA_Media_Lower_Level_Code__c='F4')
        };     
        insert mlaMedLevelCode;
        WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
    }
    
    static testmethod void ordersubmissionESI15(){
        APTS_OrderQueuetoESIUtility objOrderESIUtility = new APTS_OrderQueuetoESIUtility();
        APTS_OrderQueuetoESIUtility.switchToMonthlyAmount('Yearly',50);
      //  APTS_OrderQueuetoESIUtility.queryoftrialslist(NULL);        
    }
    
    static testmethod void ordersubmissionESI()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; 
        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');  
        //11th Nov
        Product2 oProductProf = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG');
        productlist.add(oProductC);
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(oProductProf);
        insert productlist;        
        
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        oProposal.Apttus_Proposal__Account__c=acc.id; 
        oProposal.APTS_SA_ID__c = 'AL MSA-WEST C6027018 (ALM1)';
        insert oProposal;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Test.startTest();
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        
        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order.id;
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A'; 
        ordline.APTS_Program_ID__c = 'WCMP';
        ordline.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline);        
        
        Apttus_Config2__OrderLineItem__c ordline22 =  new Apttus_Config2__OrderLineItem__c();
        ordline22.Apttus_Config2__OrderId__c=order.id;
        ordline22.Apttus_Config2__Quantity__c=1.000;
        ordline22.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordlineList.add(ordline22);   
        
        Apttus_Config2__OrderLineItem__c ordline23 =  new Apttus_Config2__OrderLineItem__c();
        ordline23.Apttus_Config2__OrderId__c=order.id;
        ordline23.Apttus_Config2__Quantity__c=1.000; 
        ordline23.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordlineList.add(ordline23);
        
        Apttus_Config2__OrderLineItem__c ordline111 =  new Apttus_Config2__OrderLineItem__c();
        ordline111.Apttus_Config2__Uom__c='Each';
        ordline111.APTS_New_Bridge_Discount__c=1;
        ordline111.APTS_Contract_Term__c='2 Years';  
        ordline111.Apttus_Config2__Quantity__c=1.000;
        ordline111.Apttus_Config2__ProductId__c=oProductP.id;
        ordline111.Apttus_Config2__OrderId__c=order.id;
        ordlineList.add(ordline111);  
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
        ordline5.APTS_Contract_Term__c='10 Years';
        ordline5.Apttus_Config2__Quantity__c=1.000;
        ordline5.Apttus_Config2__OrderId__c=order.id;
        //ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline5.Apttus_Config2__PriceType__c = 'Recurring';
        ordline5.Apttus_Config2__BillingFrequency__c ='Yearly';
        ordline5.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordline5);   
        
        Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c();
        ordline13.Apttus_Config2__OrderId__c=order.id;
        ordline13.Apttus_Config2__Quantity__c=1.000; 
        ordline13.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordlineList.add(ordline13);  
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
        ordline4.APTS_Contract_Term__c='5 Years';
        ordline4.Apttus_Config2__Quantity__c=1.000;
        ordline4.Apttus_Config2__OrderId__c=order.id;
        ordline4.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline4.Apttus_Config2__LineType__c = 'Option';
        ordline4.Apttus_Config2__PriceType__c = 'One Time';
        ordline4.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordline4);
        
        //adding orderline
        Apttus_Config2__OrderLineItem__c ordline24 =  new Apttus_Config2__OrderLineItem__c();
        ordline24.APTS_Contract_Term__c='3 Years';
        ordline24.Apttus_Config2__Quantity__c=1.000;
        ordline24.Apttus_Config2__ProductId__c=oProductB.id;
        ordline24.Apttus_Config2__OrderId__c=order.id;
        ordline24.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline24.Apttus_Config2__LineType__c = 'Product/Service';
        ordline24.Apttus_Config2__PriceType__c = 'One Time';
        ordlineList.add(ordline24);
        
        Apttus_Config2__OrderLineItem__c ordline25 =  new Apttus_Config2__OrderLineItem__c();
        ordline25.APTS_Contract_Term__c='4 Years';
        ordline25.Apttus_Config2__Quantity__c=1.000;
        ordline25.Apttus_Config2__ProductId__c=oProductB.id;
        ordline25.Apttus_Config2__OrderId__c=order.id;
        ordlineList.add(ordline25);
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline14 =  new Apttus_Config2__OrderLineItem__c();
        ordline14.APTS_Contract_Term__c='5 Years';
        ordline14.Apttus_Config2__Quantity__c=1.000;
        ordline14.Apttus_Config2__OrderId__c=order.id;
        //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline14.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline14.Apttus_Config2__LineType__c = 'Product/Service';
        ordline14.Apttus_Config2__PriceType__c = 'One Time';
        ordlineList.add(ordline14);
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='3 Years';
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id;
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordlineList.add(ordline2);
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='4 Years';
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__OrderId__c=order.id;
        ordlineList.add(ordline3);
        
        Apttus_Config2__OrderLineItem__c ordline26 =  new Apttus_Config2__OrderLineItem__c();
        ordline26.Apttus_Config2__OrderId__c=order.id;
        ordline26.Apttus_Config2__Quantity__c=1.000; 
        ordline26.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordlineList.add(ordline26);
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline53 =  new Apttus_Config2__OrderLineItem__c();
        ordline53.APTS_Contract_Term__c='10 Years';
        ordline53.Apttus_Config2__Quantity__c=1.000;
        ordline53.Apttus_Config2__OrderId__c=order.id;
        //ordline53.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline53.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline53.Apttus_Config2__PriceType__c = 'Recurring';
        ordlineList.add(ordline53);  
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline43 =  new Apttus_Config2__OrderLineItem__c();
        ordline43.APTS_Contract_Term__c='5 Years';
        ordline43.Apttus_Config2__Quantity__c=1.000;
        ordline43.Apttus_Config2__OrderId__c=order.id;
        ordline43.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline43.Apttus_Config2__LineType__c = 'Option';
        ordline43.Apttus_Config2__PriceType__c = 'One Time';
        ordlineList.add(ordline43);
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline143 =  new Apttus_Config2__OrderLineItem__c();
        ordline143.APTS_Contract_Term__c='5 Years';
        ordline143.Apttus_Config2__Quantity__c=1.000;
        ordline143.Apttus_Config2__OrderId__c=order.id;
        //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline143.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline143.Apttus_Config2__LineType__c = 'Product/Service';
        ordline143.Apttus_Config2__PriceType__c = 'One Time';
        insert ordline143; 
        
        //added product
        Apttus_Config2__OrderLineItem__c ordline15 =  new Apttus_Config2__OrderLineItem__c();
        ordline15.APTS_Contract_Term__c='5 Years';
        ordline15.Apttus_Config2__Quantity__c=1.000;
        ordline15.Apttus_Config2__OrderId__c=order.id;
        ordline15.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline15.Apttus_Config2__PriceType__c = 'One Time';
        ordline15.Apttus_Config2__ProductId__c = oProductC.Id;
        ordline15.Apttus_Config2__NetPrice__c = 1728;
        ordline15.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordline15);  
        
        
        //added fill up
        Apttus_Config2__OrderLineItem__c ordlineF =  new Apttus_Config2__OrderLineItem__c();
        ordlineF.APTS_Contract_Term__c='5 Years';
        ordlineF.Apttus_Config2__Quantity__c=1.000;
        ordlineF.Apttus_Config2__OrderId__c=order.id;
        ordlineF.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineF.Apttus_Config2__PriceType__c = 'One Time';
        ordlineF.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineF.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineF.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordlineF);  
        
        Apttus_Config2__OrderLineItem__c ordlineF1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineF1.APTS_Contract_Term__c='5 Years';
        ordlineF1.Apttus_Config2__Quantity__c=1.000;
        ordlineF1.Apttus_Config2__OrderId__c=order.id;
        ordlineF1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineF1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineF1.Apttus_Config2__LineType__c = 'Option';
        ordlineF1.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineF.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordlineF1); 
        
        Apttus_Config2__OrderLineItem__c ordlineShip =  new Apttus_Config2__OrderLineItem__c();
        ordlineShip.APTS_Contract_Term__c='5 Years';
        ordlineShip.Apttus_Config2__Quantity__c=1.000;
        ordlineShip.Apttus_Config2__OrderId__c=order.id;
        ordlineShip.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineShip.Apttus_Config2__PriceType__c = 'One Time';
        ordlineShip.Apttus_Config2__LineType__c = 'Option';
        ordlineShip.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineShip.Apttus_Config2__NetPrice__c = 1728;
        ordlineShip.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordlineShip);
        
        Apttus_Config2__OrderLineItem__c ordlineSub =  new Apttus_Config2__OrderLineItem__c();
        ordlineSub.APTS_Contract_Term__c='5 Years';
        ordlineSub.Apttus_Config2__Quantity__c=1.000;
        ordlineSub.Apttus_Config2__OrderId__c=order.id;
        ordlineSub.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineSub.Apttus_Config2__PriceType__c = 'One Time';
        ordlineSub.Apttus_Config2__LineType__c = 'Option';
        ordlineSub.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineSub.Apttus_Config2__NetPrice__c = 1728;
        ordlineSub.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordlineSub);
        
        Apttus_Config2__OrderLineItem__c ordlineSubApp =  new Apttus_Config2__OrderLineItem__c();
        ordlineSubApp.APTS_Contract_Term__c='5 Years';
        ordlineSubApp.Apttus_Config2__Quantity__c=1.000;
        ordlineSubApp.Apttus_Config2__OrderId__c=order.id;
        ordlineSubApp.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineSubApp.Apttus_Config2__PriceType__c = 'One Time';
        ordlineSubApp.Apttus_Config2__LineType__c = 'Option';
        ordlineSubApp.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineSubApp.Apttus_Config2__NetPrice__c = 1728;
        ordlineSubApp.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordlineSubApp);
        
        Apttus_Config2__OrderLineItem__c ordlineSoa =  new Apttus_Config2__OrderLineItem__c();
        ordlineSoa.APTS_Contract_Term__c='5 Years';
        ordlineSoa.Apttus_Config2__Quantity__c=1.000;
        ordlineSoa.Apttus_Config2__OrderId__c=order.id;
        ordlineSoa.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineSoa.Apttus_Config2__PriceType__c = 'One Time';
        ordlineSoa.Apttus_Config2__LineType__c = 'Option';
        ordlineSoa.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineSoa.Apttus_Config2__NetPrice__c = 1728;
        ordlineSoa.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordlineSoa);
        
        Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='5 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = oProductProf.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = true;
        ordlineProf.apts_mla__c = true;
        ordlineProf.APTS_Deal_Number__c = 12345;
        ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineList.add(ordlineProf);
        
        Apttus_Config2__OrderLineItem__c ordlineProf2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf2.APTS_Contract_Term__c='5 Years';
        ordlineProf2.Apttus_Config2__Quantity__c=1.000;
        ordlineProf2.Apttus_Config2__OrderId__c=order.id;
        ordlineProf2.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf2.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf2.Apttus_Config2__LineType__c = 'Option';
        ordlineProf2.Apttus_Config2__ProductId__c = oProductProf.Id;
        ordlineProf2.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf2.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf2.APTS_Program_ID__c = 'WCMP';
        ordlineProf2.APTS_Keep_Terms__c = false;
        ordlineProf2.apts_mla__c = true;
        ordlineProf2.APTS_Deal_Number__c = 12345;
        ordlineList.add(ordlineProf2);
        
        Apttus_Config2__OrderLineItem__c ordlineProf3 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf3.APTS_Contract_Term__c='5 Years';
        ordlineProf3.Apttus_Config2__Quantity__c=1.000;
        ordlineProf3.Apttus_Config2__OrderId__c=order.id;
        ordlineProf3.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf3.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf3.Apttus_Config2__LineType__c = 'Option';
        ordlineProf3.Apttus_Config2__ProductId__c = oProductProf.Id;
        ordlineProf3.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf3.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf3.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf3.APTS_Program_ID__c = 'WCMP';
        ordlineProf3.apts_mla__c = true;
        ordlineProf3.APTS_Keep_Terms__c = false;
        //ordlineProf3.APTS_Deal_Number__c = 12345;
        ordlineList.add(ordlineProf3);
        
        Apttus_Config2__OrderLineItem__c ordlineProf4 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf4.APTS_Contract_Term__c='5 Years';
        ordlineProf4.Apttus_Config2__Quantity__c=1.000;
        ordlineProf4.Apttus_Config2__OrderId__c=order.id;
        ordlineProf4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordlineProf4.Apttus_Config2__PriceType__c = 'Recurring';
        ordlineProf4.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineProf4.Apttus_Config2__ProductId__c = oProductP.Id;
        ordlineProf4.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf4.Apttus_Config2__BillingFrequency__c = 'Yearly';
        //ordlineProf4.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf4.APTS_Program_ID__c = 'CPRO';
        //ordlineProf4.APTS_Keep_Terms__c = false;
        ordlineProf4.APTS_Is_Multi_Tiered_Pricing__c = true;
        ordlineProf4.apts_mla__c = true;
        //ordlineProf3.APTS_Deal_Number__c = 12345;
        ordlineList.add(ordlineProf4);
        
        Apttus_Config2__OrderLineItem__c ordlineN1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineN1.APTS_Contract_Term__c='5 Years';
        ordlineN1.Apttus_Config2__Quantity__c=1.000;
        ordlineN1.Apttus_Config2__OrderId__c=order.id;
        ordlineN1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineN1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineN1.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineN1.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineN1.Apttus_Config2__NetPrice__c = 1728;
        ordlineN1.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineN1.Apttus_Config2__AdjustmentType__c = '% Markup';
        ordlineList.add(ordlineN1);
        
        Apttus_Config2__OrderLineItem__c ordlineN2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineN2.APTS_Contract_Term__c='5 Years';
        ordlineN2.Apttus_Config2__Quantity__c=1.000;
        ordlineN2.Apttus_Config2__OrderId__c=order.id;
        ordlineN2.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineN2.Apttus_Config2__PriceType__c = 'One Time';
        ordlineN2.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineN2.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineN2.Apttus_Config2__NetPrice__c = 1728;
        ordlineN2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineN2.Apttus_Config2__AdjustmentType__c = '% Discount';
        ordlineList.add(ordlineN2);
        
        insert ordlineList;
        
        List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
        
        Apttus_Config2__OrderProductAttributeValue__c attributeSub = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeSub.SCS_Print_Purchase_Options__c='Sub Only';
        attributeSub.eBook_Purchase_Options__c = 'App';
        attributeSub.Apttus_Config2__LineItemId__c=ordlineSub.id;
        orderProd.add(attributeSub);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeShip = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeShip.SCS_Print_Purchase_Options__c='Ship & Enter Sub';
        attributeShip.eBook_Purchase_Options__c = 'Entitle and Charge';
        attributeShip.Apttus_Config2__LineItemId__c=ordlineShip.id;
        orderProd.add(attributeShip);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeSubApp = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeSubApp.SCS_Print_Purchase_Options__c='Ship & Enter Sub App';
        attributeSubApp.Apttus_Config2__LineItemId__c=ordlineSubApp.id;
        orderProd.add(attributeSubApp);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute.Apttus_Config2__LineItemId__c=ordline5.id;
        orderProd.add(attribute);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeF = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeF.SCS_Print_Purchase_Options__c='Fill-Up';
        attributeF.Apttus_Config2__LineItemId__c=ordlineF.id;
        orderProd.add(attributeF);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute1.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute1.Apttus_Config2__LineItemId__c=ordline4.id;
        orderProd.add(attribute1);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute2.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute2.Apttus_Config2__LineItemId__c=ordline14.id;
        orderProd.add(attribute2);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute24 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute24.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute24.Apttus_Config2__LineItemId__c=ordline14.id;
        orderProd.add(attribute24);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute15 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute15.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute15.Apttus_Config2__LineItemId__c=ordline15.id;
        orderProd.add(attribute15);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute33 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute33.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute33.Apttus_Config2__LineItemId__c=ordline5.id;
        orderProd.add(attribute33);
        
        
        Apttus_Config2__OrderProductAttributeValue__c attribute13 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute13.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute13.Apttus_Config2__LineItemId__c=ordline43.id;
        orderProd.add(attribute13);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute23 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute23.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute23.Apttus_Config2__LineItemId__c=ordline14.id;
        orderProd.add(attribute23);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute3.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute3.Apttus_Config2__LineItemId__c=ordline15.id;
        orderProd.add(attribute3);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeSoa = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeSoa.SCS_Print_Purchase_Options__c='Sub Only App';
        attributeSoa.Apttus_Config2__LineItemId__c=ordlineSoa.id;
        orderProd.add(attributeSoa);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeN1 = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeN1.SCS_Print_Purchase_Options__c='Sub Only';
        attributeN1.eBook_Purchase_Options__c = 'App';
        attributeN1.Apttus_Config2__LineItemId__c=ordlineN1.id;
        orderProd.add(attributeN1);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeN2 = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeN2.SCS_Print_Purchase_Options__c='Sub Only';
        attributeN2.eBook_Purchase_Options__c = 'App';
        attributeN2.Apttus_Config2__LineItemId__c=ordlineN2.id;
        orderProd.add(attributeN2);
        
        insert orderProd;
        
        List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
                
        ordlineSubApp.Apttus_Config2__AttributeValueId__c=attributeSubApp.id;
        updateOrderList.add(ordlineSubApp);
        
        ordlineSoa.Apttus_Config2__AttributeValueId__c=attributeSoa.id;
        updateOrderList.add(ordlineSoa);
        
        ordlineSub.Apttus_Config2__AttributeValueId__c=attributeSub.id;
        updateOrderList.add(ordlineSub);
        
        ordlineShip.Apttus_Config2__AttributeValueId__c=attributeShip.id;
        updateOrderList.add(ordlineShip);
        
        ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
        updateOrderList.add(ordline5);
        
        ordlineF.Apttus_Config2__AttributeValueId__c=attributeF.id;
        updateOrderList.add(ordlineF);
        
        ordlineF1.Apttus_Config2__AttributeValueId__c=attributeF.id;
        updateOrderList.add(ordlineF1);
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute1.id;
        updateOrderList.add(ordline4);
        
        ordline14.Apttus_Config2__AttributeValueId__c=attribute2.id;
        updateOrderList.add(ordline14);
        
        ordline53.Apttus_Config2__AttributeValueId__c=attribute33.id;
        updateOrderList.add(ordline53);
        
        ordline43.Apttus_Config2__AttributeValueId__c=attribute13.id;
        updateOrderList.add(ordline43);
        
        ordline24.Apttus_Config2__AttributeValueId__c=attribute24.id;
        updateOrderList.add(ordline24);
        
        ordline15.Apttus_Config2__AttributeValueId__c=attribute15.id;
        updateOrderList.add(ordline15);
        
        ordline143.Apttus_Config2__AttributeValueId__c=attribute23.id;
        updateOrderList.add(ordline143);
        
        ordlineN1.Apttus_Config2__AttributeValueId__c=attributeN1.id;
        updateOrderList.add(ordlineN1);
        
        ordlineN2.Apttus_Config2__AttributeValueId__c=attributeN2.id;
        updateOrderList.add(ordlineN2);
                
        update updateOrderList;
        
        List<APTS_Dynamic_Bundle__c> dynamicList=new List<APTS_Dynamic_Bundle__c>();
        
        APTS_Dynamic_Bundle__c dynamicbundle = new APTS_Dynamic_Bundle__c();
        dynamicbundle.APTS_Bundle_Primary_Material__c='1111';
        //dynamicbundle.APTS_Quantity__c=1.00;
        dynamicbundle.APTS_Group__c='Bundle A';
        dynamicbundle.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle.APTS_Contract_Terms__c='3 Years';
        dynamicbundle.APTS_YoY_2_Plus__c='1';
        dynamicbundle.APTS_isBLINotCreated__c= true;
        dynamicList.add(dynamicbundle);
        
        APTS_Dynamic_Bundle__c dynamicbundle2 = new APTS_Dynamic_Bundle__c();
        dynamicbundle2.APTS_Bundle_Primary_Material__c='1111';
        //dynamicbundle.APTS_Quantity__c=1.00;
        dynamicbundle2.APTS_Group__c='Bundle C';
        dynamicbundle2.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle2.APTS_Contract_Terms__c='5 Years';
        dynamicbundle2.APTS_YoY_2_Plus__c='1';
        dynamicbundle2.APTS_isBLINotCreated__c= true;
        dynamicList.add(dynamicbundle2);
        
        APTS_Dynamic_Bundle__c dynamicbundle3 = new APTS_Dynamic_Bundle__c();
        dynamicbundle3.APTS_Bundle_Primary_Material__c='1111';
        //dynamicbundle.APTS_Quantity__c=1.00;
        dynamicbundle3.APTS_Group__c='Bundle D';
        dynamicbundle3.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle3.APTS_Contract_Terms__c='4 Years';
        dynamicbundle3.APTS_YoY_2_Plus__c='1';
        dynamicbundle3.APTS_isBLINotCreated__c= true;
        dynamicList.add(dynamicbundle3);
        
        insert dynamicList;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc5);
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc6);
        
        insert onlineContactList;
        
        List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
        masterContactList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
        masterContactList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
        masterContactList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc5);
        Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc6);
        insert masterContactList;
        //Test.startTest();
                        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();        
    }
    
    static testmethod void ordersubmissionESINB()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;             
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty; 
        
        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductX = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_High_Level_Code__c = '21', APTS_Media_Lower_Level_Code__c = 'CQ', Apttus_Config2__Uom__c = 'Seats');
        insert oProductB;
        insert oProductP;
        insert oProductX;
        
        Test.startTest();        
        // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert oProposal;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductX.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li3);
        insert listLineItems;
        
        List<Apttus_Config2__Order__c> ordList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order3 = new Apttus_Config2__Order__c();
        order3.Apttus_Config2__Type__c='New';
        order3.Apttus_Config2__Status__c='Pending';
        order3.APTS_SSD_Sold_To__c=accountSSD.id;
        order3.APTS_SSD_bill_to__c=accountSSD.id;
        order3.APTS_SSD_Ship_To__c=accountSSD.id;
        order3.Apttus_QPConfig__ProposalId__c=oProposal.id;
        ordList.add(order3);
        
        insert ordList;
        
        list<Apttus_Config2__OrderLineItem__c> ordlineitem =  new list<Apttus_Config2__OrderLineItem__c>();
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order3.id;
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A';  
        ordline.APTS_Bridge__c='1 Month';
        ordlineitem.add(ordline);
        
        
        Apttus_Config2__OrderLineItem__c ordline22 =  new Apttus_Config2__OrderLineItem__c();
        ordline22.Apttus_Config2__OrderId__c=order3.id;
        ordline22.Apttus_Config2__Quantity__c=1.000; 
        ordline22.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordlineitem.add(ordline22);  
        
        Apttus_Config2__OrderLineItem__c ordline23 =  new Apttus_Config2__OrderLineItem__c();
        ordline23.Apttus_Config2__OrderId__c=order3.id;
        ordline23.Apttus_Config2__Quantity__c=1.000; 
        ordline23.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordlineitem.add(ordline23); 
        
        Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
        ordline1.Apttus_Config2__Uom__c='Each';
        ordline1.APTS_New_Bridge_Discount__c=1;
        ordline1.APTS_Contract_Term__c='2 Years';  
        ordline1.Apttus_Config2__Quantity__c=1.000;
        ordline1.Apttus_Config2__ProductId__c=oProductP.id;
        ordline1.Apttus_Config2__OrderId__c=order3.id;
        ordline1.Apttus_Config2__AdjustmentType__c='% Discount';
        ordlineitem.add(ordline1);
        
        Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
        ordline5.APTS_Contract_Term__c='10 Years';
        ordline5.Apttus_Config2__Quantity__c=1.000;
        ordline5.Apttus_Config2__OrderId__c=order3.id;
        //ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline5.Apttus_Config2__PriceType__c = 'Recurring';
        ordlineitem.add(ordline5); 
        
        Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c();
        ordline13.Apttus_Config2__OrderId__c=order3.id;
        ordline13.Apttus_Config2__Quantity__c=1.000; 
        ordline13.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordlineitem.add(ordline13);
        
        Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
        ordline4.APTS_Contract_Term__c='5 Years';
        ordline4.Apttus_Config2__Quantity__c=1.000;
        ordline4.Apttus_Config2__OrderId__c=order3.id;
        ordline4.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline4.Apttus_Config2__LineType__c = 'Option';
        ordline4.Apttus_Config2__PriceType__c = 'One Time';
        ordlineitem.add(ordline4);
        
        Apttus_Config2__OrderLineItem__c ordline24 =  new Apttus_Config2__OrderLineItem__c();
        ordline24.APTS_Contract_Term__c='3 Years';
        ordline24.Apttus_Config2__Quantity__c=1.000;
        ordline24.Apttus_Config2__ProductId__c=oProductB.id;
        ordline24.Apttus_Config2__OrderId__c=order3.id;
        ordlineitem.add(ordline24);
        
        Apttus_Config2__OrderLineItem__c ordline25 =  new Apttus_Config2__OrderLineItem__c();
        ordline25.APTS_Contract_Term__c='4 Years';
        ordline25.Apttus_Config2__Quantity__c=1.000;
        ordline25.Apttus_Config2__ProductId__c=oProductB.id;
        ordline25.Apttus_Config2__OrderId__c=order3.id;
        ordlineitem.add(ordline25);
        
        
        Apttus_Config2__OrderLineItem__c ordline14 =  new Apttus_Config2__OrderLineItem__c();
        ordline14.APTS_Contract_Term__c='5 Years';
        ordline14.Apttus_Config2__Quantity__c=1.000;
        ordline14.Apttus_Config2__OrderId__c=order3.id;
        //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline14.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline14.Apttus_Config2__LineType__c = 'Product/Service';
        ordline14.Apttus_Config2__PriceType__c = 'One Time';
        ordlineitem.add(ordline14);
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='3 Years';
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id;
        ordline2.Apttus_Config2__OrderId__c=order3.id;
        ordlineitem.add(ordline2);
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='4 Years';
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__OrderId__c=order3.id;
        ordlineitem.add(ordline3);
        
        Apttus_Config2__OrderLineItem__c ordline26 =  new Apttus_Config2__OrderLineItem__c();
        ordline26.Apttus_Config2__OrderId__c=order3.id;
        ordline26.Apttus_Config2__Quantity__c=1.000; 
        ordline26.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordlineitem.add(ordline26);
        
        Apttus_Config2__OrderLineItem__c ordline53 =  new Apttus_Config2__OrderLineItem__c();
        ordline53.APTS_Contract_Term__c='10 Years';
        ordline53.Apttus_Config2__Quantity__c=1.000;
        ordline53.Apttus_Config2__OrderId__c=order3.id;
        //ordline53.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline53.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline53.Apttus_Config2__PriceType__c = 'Recurring';
        ordlineitem.add(ordline53);
        
        Apttus_Config2__OrderLineItem__c ordline43 =  new Apttus_Config2__OrderLineItem__c();
        ordline43.APTS_Contract_Term__c='5 Years';
        ordline43.Apttus_Config2__Quantity__c=1.000;
        ordline43.Apttus_Config2__OrderId__c=order3.id;
        ordline43.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline43.Apttus_Config2__LineType__c = 'Option';
        ordline43.Apttus_Config2__PriceType__c = 'One Time';
        ordlineitem.add(ordline43);
        
        Apttus_Config2__OrderLineItem__c ordline143 =  new Apttus_Config2__OrderLineItem__c();
        ordline143.APTS_Contract_Term__c='5 Years';
        ordline143.Apttus_Config2__Quantity__c=1.000;
        ordline143.Apttus_Config2__OrderId__c=order3.id;
        //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline143.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline143.Apttus_Config2__LineType__c = 'Product/Service';
        ordline143.Apttus_Config2__PriceType__c = 'One Time';
        ordlineitem.add(ordline143); 
        
        Apttus_Config2__OrderLineItem__c ordline15 =  new Apttus_Config2__OrderLineItem__c();
        ordline15.APTS_Contract_Term__c='5 Years';
        ordline15.Apttus_Config2__Quantity__c=1.000;
        ordline15.Apttus_Config2__OrderId__c=order3.id;
        ordline15.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline15.Apttus_Config2__PriceType__c = 'One Time';
        ordlineitem.add(ordline15);
        
        Apttus_Config2__OrderLineItem__c ordline16 =  new Apttus_Config2__OrderLineItem__c();
        ordline16.APTS_Contract_Term__c='5 Years';
        ordline16.Apttus_Config2__Quantity__c=1.000;
        ordline16.Apttus_Config2__OrderId__c=order3.id;
        ordline16.Apttus_Config2__ProductId__c=oProductX.id;
        ordline16.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline16.Apttus_Config2__PriceType__c = 'One Time';
        ordlineitem.add(ordline16);
        
        insert ordlineitem;        
        
        List<Apttus_Config2__OrderProductAttributeValue__c> ordPrAttList=new List<Apttus_Config2__OrderProductAttributeValue__c>();
        
        Apttus_Config2__OrderProductAttributeValue__c attribute = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute.Apttus_Config2__LineItemId__c=ordline5.id;
        ordPrAttList.add(attribute);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute1.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute1.Apttus_Config2__LineItemId__c=ordline4.id;
        ordPrAttList.add(attribute1);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute2.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute2.Apttus_Config2__LineItemId__c=ordline14.id;
        ordPrAttList.add(attribute2);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute33 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute33.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute33.Apttus_Config2__LineItemId__c=ordline5.id;
        ordPrAttList.add(attribute33);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute13 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute13.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute13.Apttus_Config2__LineItemId__c=ordline43.id;
        ordPrAttList.add(attribute13);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute23 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute23.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute23.Apttus_Config2__LineItemId__c=ordline14.id;
        ordPrAttList.add(attribute23);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute3.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute3.Apttus_Config2__LineItemId__c=ordline15.id;
        ordPrAttList.add(attribute3);
        
        insert ordPrAttList;
        
        List<Apttus_Config2__OrderLineItem__c>  updateOrderLineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
        updateOrderLineList.add(ordline5);
        
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute1.id;
        updateOrderLineList.add(ordline4);
        
        ordline53.Apttus_Config2__AttributeValueId__c=attribute33.id;
        updateOrderLineList.add(ordline53);
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute13.id;
        updateOrderLineList.add(ordline43);
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute23.id;
        updateOrderLineList.add(ordline143);
        
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute3.id;
        updateOrderLineList.add(ordline15);        
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute2.id;
        updateOrderLineList.add(ordline14);
        
        update updateOrderLineList;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc5);
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc6);
        
        Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductX.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc7);
        
        insert onlineContactList;
        
        List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc5);
        Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc6);
        Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc7);
        Customer_Master_Contacts__c mc8 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',To_IP_Address__c = '111.111.111.111', From_IP_Address__c = '101.111.111.111',From_IP_Address1__c = '111.111.111.111', To_IP_Address1__c = '111.111.111.111',From_IP_Address2__c = '111.111.111.111',To_IP_Address2__c = '111.111.111.111');
        masterContactList.add(mc8);
        
        Customer_Master_Contacts__c mc14 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id,Contact__c = oContact.Id, Customer_Type_Description__c = 'ADMINISTRATOR', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc14);
        Customer_Master_Contacts__c mc15 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id,Contact__c = oContact.Id, Customer_Type_Description__c = 'SRR MEDIA CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc15);
        Customer_Master_Contacts__c mc9 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id,Contact__c = oContact.Id, Customer_Type_Description__c = 'PT INTER MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc9);
        Customer_Master_Contacts__c mc10 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id,Contact__c = oContact.Id, Customer_Type_Description__c = 'PT INTRA MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc10);
        Customer_Master_Contacts__c mc11 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id,Contact__c = oContact.Id, Customer_Type_Description__c = 'PT SENTRY MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc11);
        Customer_Master_Contacts__c mc12 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id,Contact__c = oContact.Id, Customer_Type_Description__c = 'COMPLIANCE LEARNING', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc12);
        Customer_Master_Contacts__c mc13 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id,Contact__c = oContact.Id, Customer_Type_Description__c = 'Filing Contact', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc13);
        Customer_Master_Contacts__c mc20 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id,Contact__c = oContact.Id, Customer_Type_Description__c = 'AUTO PAYMENT PROCESS', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc20);
        insert masterContactList;
        
        Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order3.id];
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);
        System.assertEquals(1,ordList.size());
        Test.stopTest();        
    }   
    
    static testmethod void ordersubmissionESINB1()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty; 
        
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName='Prabhu';
        con.FirstName='Issac';
        insert con;
        
        List<Product2> prodList=new List<Product2>();
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'OA',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductB1 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06',APTS_Media_Lower_Level_Code__c = 'I9', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP1 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='07',APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductB2 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP2 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
        prodList.add(oProductB);
        prodList.add(oProductP);
        prodList.add(oProductB1);
        prodList.add(oProductP1);
        prodList.add(oProductB2);
        prodList.add(oProductP2);
        insert prodList;
        
        Test.startTest();   
        // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Proposal_Business_Unit__c='FindLaw',APTS_Approval_Segment__c='Corporate',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert oProposal;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li3);
        Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li4);
        Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li5);
        Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li6);
        
        insert listLineItems;
        
        List<Apttus_Config2__Order__c> ordLists=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Ready for Activation';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_ship_to__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        insert order;
        ordLists.add(order);
        
        List<Apttus_Config2__OrderLineItem__c> orderlineitemList = new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order.id;
        ordline.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A';  
        ordline.APTS_Bridge__c='1 Month';
        ordline.APTS_SAP_MLA_Agreement_Number__c = '12345';
        ordline.APTS_Service_Number__c = '40757482';
        ordline.APTS_Program_ID__c = 'CPRO';
        ordline.Apttus_Config2__LineType__c = 'Product/Service';
        orderlineitemList.add(ordline);
        
        Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
        ordline1.APTS_Contract_Term__c='1 Year';
        ordline1.Apttus_Config2__OrderId__c=order.id;
        ordline1.Apttus_Config2__LineStatus__c='Amended';
        ordline1.APTS_Service_Number__c = '41841757'; 
        ordline1.Apttus_Config2__Quantity__c=1.000;
        ordline1.Apttus_Config2__ProductId__c=oProductB.id;
        ordline1.APTS_Group__c='Bundle A';  
        ordline1.APTS_Bridge__c='1 Month';
        ordline1.Apttus_Config2__AdjustmentType__c='% Discount';
        orderlineitemList.add(ordline1);
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='1 Year';
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.Apttus_Config2__LineStatus__c='Renewed'; 
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id; 
        ordline2.APTS_Bridge__c='1 Month';
        orderlineitemList.add(ordline2);
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='1 Year';
        ordline3.Apttus_Config2__OrderId__c=order.id;
        ordline3.Apttus_Config2__LineStatus__c='Renewed'; 
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__ProductId__c=oProductP.id; 
        ordline3.APTS_Bridge__c='1 Month';
        orderlineitemList.add(ordline3);
        insert orderlineitemList; 
        
        Apttus_Approval__Approval_Request__c ar = new Apttus_Approval__Approval_Request__c(                   
            Apttus_Approval__Approval_Status__c = 'Approved',
            Apttus_QPApprov__ProposalId__c =  oProposal.id               
        );
        insert ar;  
        
        order.Apttus_Config2__Status__c='Pending';
        update order;
        
        Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order.id];
        //OrdersubmissionESI.invokeOrdertoESI(ordername); Commented as part of CRM-9456
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id); //Added as part of CRM-9456
        System.assertEquals(1,ordLists.size());
        Test.stopTest();
        
    }
    
    static testmethod void ordersubmissionESINB2()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.Name='ABC2';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=acc.ID;
        accountSSD2.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='WEST';
        insert accountSSD2;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty; 
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='Prabhu';
        con.FirstName='Issac';
        insert con;
        
        List<Product2> prodlist = new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'P7',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',Apttus_Filter_Brand_Code__c = '064'); //DOC-12198 added FilterCode
        Product2 oProductB1 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06',APTS_Media_Lower_Level_Code__c = 'I9', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP1 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='07',APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductB2 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP2 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
        Product2 prodObj = new Product2();
        prodObj.Name = 'West Proflex';
        prodObj.ProductCode= '40757482';
        prodObj.APTS_Media_High_Level_Code__c = '06';
        prodObj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObj.IsActive=true;
        prodObj.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObj.Service_Number__c='0';
        prodlist.add(prodObj);    
        prodlist.add(oProductB);
        prodlist.add(oProductP);
        prodlist.add(oProductB1);
        prodlist.add(oProductP1);
        prodlist.add(oProductB2);
        prodlist.add(oProductP2);
        insert prodlist;
        
        Test.startTest();     
        // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Proposal_Business_Unit__c='FindLaw',APTS_Approval_Segment__c='FindLaw',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert oProposal;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li3);
        Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li4);
        Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li5);
        Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li6);
        
        insert listLineItems;
        
        List<Apttus_Config2__Order__c> ordLists = new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        //order.Apttus_Config2__Status__c='Ready for Activation';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        insert order;
        ordLists.add(order);
        List<Apttus_Config2__OrderLineItem__c> orderLineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order.id;
        ordline.Apttus_Config2__LineStatus__c='Renewed'; 
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A';  
        ordline.APTS_Bridge__c='1 Month';
        ordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline.APTS_SAP_MLA_Agreement_Number__c = '123456'; 
        orderLineList.add(ordline);         
        
        Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
        ordline1.APTS_Contract_Term__c='1 Year';
        ordline1.Apttus_Config2__OrderId__c=order.id;
        ordline1.Apttus_Config2__LineStatus__c='Existing'; 
        ordline1.Apttus_Config2__Quantity__c=1.000;
        ordline1.Apttus_Config2__ProductId__c=oProductB.id;
        ordline1.APTS_Group__c='Bundle A';  
        ordline1.APTS_Bridge__c='1 Month';
        ordline1.APTS_SAP_MLA_Agreement_Number__c = '123456'; 
        orderLineList.add(ordline1); 
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='1 Year';
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id;
        ordline2.APTS_Group__c='Bundle A';  
        ordline2.APTS_Bridge__c='1 Month';
        ordline2.APTS_SAP_MLA_Agreement_Number__c = '123456'; 
        orderLineList.add(ordline2);
        Apttus_Config2__OrderLineItem__c ordlineprx =  new Apttus_Config2__OrderLineItem__c();
        ordlineprx.APTS_Contract_Term__c='3 Years';
        ordlineprx.Apttus_Config2__OrderId__c=order.id;
        ordlineprx.Apttus_Config2__LineStatus__c='New'; 
        ordlineprx.Apttus_Config2__Quantity__c=1.000;
        ordlineprx.Apttus_Config2__ProductId__c=prodobj.id;
        ordlineprx.APTS_Group__c='Bundle A';  
        ordlineprx.APTS_Bridge__c='1 Month';
        ordlineprx.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineprx.APTS_SAP_MLA_Agreement_Number__c = '';
        ordlineprx.APTS_Keep_terms__c=true;
        ordlineprx.APTS_MLA__c = true;
        ordlineprx.APTS_Bridge_Discount__c = '100';
        ordlineprx.APTS_Decentralized__c = true;
        orderLineList.add(ordlineprx);
        Apttus_Config2__OrderLineItem__c ordlineprx2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineprx2.APTS_Contract_Term__c='3 Years';
        ordlineprx2.Apttus_Config2__OrderId__c=order.id;
        ordlineprx2.Apttus_Config2__LineStatus__c='New'; 
        ordlineprx2.Apttus_Config2__Quantity__c=1.000;
        ordlineprx2.Apttus_Config2__ProductId__c=prodobj.id;
        ordlineprx2.APTS_Group__c='Bundle AB';  
        ordlineprx2.APTS_Bridge__c='1 Month';
        ordlineprx2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineprx2.APTS_SAP_MLA_Agreement_Number__c = '123456';
        ordlineprx2.APTS_Keep_terms__c=true;
        ordlineprx2.APTS_MLA__c = true;
        ordlineprx2.APTS_Bridge_Discount__c = '100';
        ordlineprx2.APTS_Decentralized__c = true;
        ordlineprx2.APTS_New_Bridge_Discount__c=50;
        orderLineList.add(ordlineprx2); 
        insert orderLineList;
        
        List<Attachment> attList=new List<Attachment>();
        
        Attachment att = new Attachment();
        att.Name='signed';
        att.ParentId=oProposal.id;
        att.body=blob.valueof('test');
        attList.add(att);
        
        Attachment att1 = new Attachment();
        att1.Name='Order Form';
        att1.body=blob.valueof('test2');
        att1.ParentId=oProposal.id;
        attList.add(att1);
        
        Attachment att2 = new Attachment();
        att2.Name='CVMS Offer Sheet';
        att2.body=blob.valueof('test2');
        att2.ParentId=oProposal.id;
        attList.add(att2);
        
        insert attList;
        
        List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;
        
        List<APTS_Dynamic_Bundle__c> dymBundle=new List<APTS_Dynamic_Bundle__c>();
        
        APTS_Dynamic_Bundle__c dynamicbundle11 = new APTS_Dynamic_Bundle__c();
        dynamicbundle11.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundle11.APTS_Group__c='Bundle A';
        dynamicbundle11.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle11.APTS_Contract_Terms__c='3 Years';
        dynamicbundle11.APTS_YoY_2_Plus__c='1';
        dynamicbundle11.APTS_Keep_Terms__c=true;
        dynamicbundle11.APTS_MLA_Agreement_Number__c='';
        dynamicbundle11.APTS_Bridge_Discount__c = '100';
        dynamicbundle11.APTS_Decentralized__c = true;
        dynamicbundle11.APTS_isBLINotCreated__c= true;
        dynamicbundle11.APTS_Billing_Frequency__c='Yearly';
        dymBundle.add(dynamicbundle11);
        
        APTS_Dynamic_Bundle__c dynamicbundle12 = new APTS_Dynamic_Bundle__c();
        dynamicbundle12.APTS_Bundle_Primary_Material__c='1111';        
        dynamicbundle12.APTS_Group__c='Bundle A';
        dynamicbundle12.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle12.APTS_Contract_Terms__c='3 Years';
        dynamicbundle12.APTS_YoY_2_Plus__c='1';
        dynamicbundle12.APTS_Keep_Terms__c=false;
        dynamicbundle12.APTS_MLA__c = true;
        dynamicbundle12.APTS_MLA_Agreement_Number__c=''; 
        dynamicbundle12.APTS_isBLINotCreated__c= true;
        dymBundle.add(dynamicbundle12); 
        
        APTS_Dynamic_Bundle__c dynamicbundleNEW = new APTS_Dynamic_Bundle__c();
        dynamicbundleNEW.APTS_Bundle_Primary_Material__c='1111';        
        dynamicbundleNEW.APTS_Group__c='Bundle AB';
        dynamicbundleNEW.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundleNEW.APTS_Contract_Terms__c='3 Years';
        dynamicbundleNEW.APTS_YoY_2_Plus__c='1';
        dynamicbundleNEW.APTS_Keep_Terms__c=true;
        dynamicbundleNEW.APTS_MLA__c = true;        
        dynamicbundleNEW.APTS_MLA_Agreement_Number__c='123456'; 
        dynamicbundleNEW.APTS_Decentralized__c = true;
        dynamicbundleNEW.APTS_isBLINotCreated__c= true;
        dymBundle.add(dynamicbundleNEW); 
        
        //Added newly
        APTS_Dynamic_Bundle__c dynamicbundleMTP = new APTS_Dynamic_Bundle__c();
        dynamicbundleMTP.APTS_Bundle_Primary_Material__c='1111';        
        dynamicbundleMTP.APTS_Group__c='Bundle AB';
        dynamicbundleMTP.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundleMTP.APTS_Contract_Terms__c='3 Years';
        dynamicbundleMTP.APTS_YoY_2_Plus__c='1';
        dynamicbundleMTP.APTS_Keep_Terms__c=true;
        dynamicbundleMTP.APTS_MLA__c = false;        
        dynamicbundleMTP.APTS_MLA_Agreement_Number__c='123456'; 
        dynamicbundleMTP.APTS_Decentralized__c = true;
        dynamicbundleMTP.APTS_isBLINotCreated__c= true;
        dymBundle.add(dynamicbundleMTP);
        
        insert dymBundle;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c , First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc.APTS_Subscriber_Location__c,Type__c= 'Admin');    //DOC-12198 added Type = Admin
        oc1.APTS_Source_System_Detail__c = accountSSD.ID;
        oc1.Is_Banded_Product__c = true;
        onlineContactList.add(oc1);
        
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD2.id);
        oc2.APTS_Source_System_Detail__c = accountSSD.ID;
        oc2.Is_Banded_Product__c = true;
        onlineContactList.add(oc2);
        
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu1', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD2.id);
        oc3.APTS_Source_System_Detail__c = accountSSD.ID;
        oc3.Is_Banded_Product__c = true;
        onlineContactList.add(oc3); 
        
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc4.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc4);   
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True,Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc5.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc5);  
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc6.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc6);
        
        //Added DOC-12198
        Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc7.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc7);
        
        Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc8.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc8);
        
        Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc9.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc9);
        
        Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc10.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc10);
        
        Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc11.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc11);
        
        Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc12.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc12);
        
        Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc13.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc13);
        
        Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc14.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc14);
        
        Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc15.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc15);
        
        Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc16.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc16);
        
        Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc17.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc17);
        
        Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc18.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc18);
     
       Online_Contacts__c oc19 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Proview Ent IP',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc19.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc19);
        
        insert onlineContactList;
        
        APTS_Additional_Subscription_Actions__c addsub = new APTS_Additional_Subscription_Actions__c();
        addsub.APTS_Line_Status__c='Cancelled';
        addsub.APTS_Subscription_Number__c='787847';
        addsub.APTS_Quote_Proposal__c=oProposal.id;
        insert addsub; 
        
        order.Apttus_Config2__Status__c='Pending';        
        update order;
        
        Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order.id];
        List<String> ordername = new List<String>();
        ordername.add(order2.Id); 
        
        Map<string, string> materialBrandCodeMap = new Map<string, string>();
        materialBrandCodeMap.put(ordlineprx.Apttus_Config2__ProductId__r.ProductCode, ordlineprx.Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c);
        
        APTS_OrderQueuetoESI.orderSubmissionToESI(ordername[0]);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc1,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc2,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc3,multiacc,materialBrandCodeMap);
        //Added
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc7,multiacc,materialBrandCodeMap);  
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc8,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc9,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc10,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc11,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc12,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc13,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc14,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc15,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc16,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc17,multiacc,materialBrandCodeMap);
        APTS_OrderSubmissionUtilityExt2.onlineContactAssign(oc18,multiacc,materialBrandCodeMap);
              
        System.assertEquals(1,ordLists.size());
        Test.stopTest();
        
    }
    
    //SOC-5358 and 3962
    static testMethod void orderQueuetoESIWCMP(){
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='testWCMP';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;  
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='WCMP';
        con.FirstName='Bundle';
        insert con;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Primary Product', ProductCode = '1234568978965', APTS_Corporate_Select__c = 'Primary');
        Product2 oProductP = new Product2(Name='Option Product', ProductCode = '1234568978966', APTS_Corporate_Select__c = 'Module');
        Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9');
        //Product2 oProduct6 = new Product2(Name='Standard Product6', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='05',APTS_Media_Lower_Level_Code__c='E2');
        Product2 oProductProf = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG');
        Product2 ProductN = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG',APTS_Corporate_Select__c = 'Primary');
        Product2 ProductNN = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG',APTS_Corporate_Select__c = 'Module');
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(oProductS);
        productlist.add(oProductProf);
        productlist.add(ProductN);
        productlist.add(ProductNN);
        insert productlist;
        
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test',
            APTS_Proposal_Business_Unit__c='SCS',
            APTS_Approval_Segment__c='Corporate Emerging',
            APTS_Order_Confirmation_Contact__c=con.id,
            APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
            Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,
            APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
            APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
        //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)');
        insert oProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
        insert prodConfig;
        List<Apttus_Config2__Order__c> ordLists =new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Ready for Activation';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order.Apttus_Config2__Status__c='Pending';
        order.Retry_Count__c = 2;
        insert order;        
        ordLists.add(order);
        
        List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItemP =  new Apttus_Config2__LineItem__c();
        lineItemP.APTS_Group_Primary_Material__c= '40666420';
        lineItemP.Apttus_Config2__LineStatus__c = 'New';  
        lineItemP.APTS_Group__c = 'Bundle A';
        lineItemP.APTS_Contract_Number__c = 123456;
        lineItemP.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemP.Apttus_Config2__ItemSequence__c = 1;
        lineItemP.Apttus_Config2__LineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductId__c = oProductB.Id;   
        lineItemP.APTS_is_Primary_in_Bundle__c = true;     
        lineItemP.Apttus_Config2__AddedBy__c = 'User';
        lineItemP.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemP.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemP.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemP.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemP.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemP.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemP.Apttus_Config2__AllowProration__c = FALSE;
        lineItemP.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemP.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemP.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemP.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemP.Apttus_Config2__BasePrice__c = 100;
        lineItemP.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemP.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemP.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemP.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemP.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemP.Apttus_Config2__Customizable__c = FALSE;
        lineItemP.Apttus_Config2__DeltaPrice__c = 50;
        lineItemP.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemP.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemP.Apttus_Config2__ExtendedCost__c = 0;
        lineItemP.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemP.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemP.Apttus_Config2__Guidance__c = 'Red';
        lineItemP.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemP.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemP.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemP.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemP.Apttus_Config2__HasOptions__c = FALSE;
        lineItemP.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemP.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemP.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemP.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemP.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemP.Apttus_Config2__IsHidden__c = FALSE;
        lineItemP.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemP.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemP.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemP.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemP.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemP.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemP.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemP.Apttus_Config2__LineSequence__c = 1;
        lineItemP.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemP.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemP.Apttus_Config2__ListPrice__c = 100;
        lineItemP.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemP.Apttus_Config2__NetPrice__c = 50;
        lineItemP.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemP.Apttus_Config2__OptionSequence__c = 0;
        lineItemP.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemP.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemP.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemP.Apttus_Config2__PriceUom__c = 'Each';
        lineItemP.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemP.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductVersion__c = 1;
        lineItemP.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemP.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemP.Apttus_Config2__SellingTerm__c = 1;
        lineItemP.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemP.Apttus_Config2__Taxable__c = FALSE;
        lineItemP.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemP.Apttus_Config2__Term__c = 1;
        lineItemP.Apttus_Config2__TotalQuantity__c = 1;
        lineItemP.Apttus_Config2__Uom__c = 'Each';
        lineItemP.CurrencyIsoCode = 'USD';
        lineItemP.APTS_Product_Family__c = 'WESTLAW';
        lineItemP.APTS_Contract_Term__c = '2 Years';
        lineItemP.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemP.APTS_Product_Delivery__c = 'Online/Internet';  
        liList.add(lineItemP);
        
        Apttus_Config2__LineItem__c lineItemo =  new Apttus_Config2__LineItem__c();
        lineItemo.APTS_Group_Primary_Material__c= '40666420';
        lineItemo.Apttus_Config2__LineStatus__c = 'New';  
        lineItemo.APTS_Group__c = 'Bundle A';
        lineItemo.APTS_Contract_Number__c = 123456;
        lineItemo.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemo.Apttus_Config2__ItemSequence__c = 1;
        lineItemo.Apttus_Config2__LineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductId__c = oProductP.Id;    
        lineItemo.APTS_is_Primary_in_Bundle__c = true;    
        lineItemo.Apttus_Config2__AddedBy__c = 'User';
        lineItemo.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemo.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemo.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemo.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemo.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowProration__c = FALSE;
        lineItemo.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemo.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemo.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemo.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__BasePrice__c = 100;
        lineItemo.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemo.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemo.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemo.Apttus_Config2__Customizable__c = FALSE;
        lineItemo.Apttus_Config2__DeltaPrice__c = 50;
        lineItemo.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemo.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemo.Apttus_Config2__ExtendedCost__c = 0;
        lineItemo.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemo.Apttus_Config2__Guidance__c = 'Red';
        lineItemo.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemo.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemo.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemo.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemo.Apttus_Config2__HasOptions__c = FALSE;
        lineItemo.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemo.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemo.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemo.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsHidden__c = FALSE;
        lineItemo.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemo.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemo.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemo.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemo.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemo.Apttus_Config2__LineSequence__c = 1;
        lineItemo.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemo.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemo.Apttus_Config2__ListPrice__c = 100;
        lineItemo.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemo.Apttus_Config2__NetPrice__c = 50;
        lineItemo.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemo.Apttus_Config2__OptionSequence__c = 0;
        lineItemo.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemo.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemo.Apttus_Config2__PriceUom__c = 'Each';
        lineItemo.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemo.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductVersion__c = 1;
        lineItemo.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemo.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__SellingTerm__c = 1;
        lineItemo.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemo.Apttus_Config2__Taxable__c = FALSE;
        lineItemo.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemo.Apttus_Config2__Term__c = 1;
        lineItemo.Apttus_Config2__TotalQuantity__c = 1;
        lineItemo.Apttus_Config2__Uom__c = 'Each';
        lineItemo.CurrencyIsoCode = 'USD';
        lineItemo.APTS_Product_Family__c = 'WESTLAW';
        lineItemo.APTS_Contract_Term__c = '2 Years';
        lineItemo.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemo.APTS_Product_Delivery__c = 'Online/Internet';
  
        liList.add(lineItemo);
        
        Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
        lineItemS.APTS_Group_Primary_Material__c= '40666420';
        lineItemS.Apttus_Config2__LineStatus__c = 'New';  
        lineItemS.APTS_Group__c = 'Bundle A';
        lineItemS.APTS_Contract_Number__c = 123456;
        lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemS.Apttus_Config2__ItemSequence__c = 1;
        lineItemS.Apttus_Config2__LineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductId__c = oProductS.Id;   
        lineItemS.APTS_is_Primary_in_Bundle__c = true;
        lineItemS.Apttus_Config2__AddedBy__c = 'User';
        lineItemS.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemS.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemS.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemS.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemS.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowProration__c = FALSE;
        lineItemS.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemS.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemS.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemS.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__BasePrice__c = 100;
        lineItemS.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemS.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemS.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemS.Apttus_Config2__Customizable__c = FALSE;
        lineItemS.Apttus_Config2__DeltaPrice__c = 50;
        lineItemS.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemS.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemS.Apttus_Config2__ExtendedCost__c = 0;
        lineItemS.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemS.Apttus_Config2__Guidance__c = 'Red';
        lineItemS.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemS.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemS.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemS.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemS.Apttus_Config2__HasOptions__c = FALSE;
        lineItemS.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemS.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemS.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemS.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsHidden__c = FALSE;
        lineItemS.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemS.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemS.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemS.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemS.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemS.Apttus_Config2__LineSequence__c = 1;
        lineItemS.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemS.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemS.Apttus_Config2__ListPrice__c = 100;
        lineItemS.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemS.Apttus_Config2__NetPrice__c = 50;
        lineItemS.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemS.Apttus_Config2__OptionSequence__c = 0;
        lineItemS.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemS.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemS.Apttus_Config2__PriceUom__c = 'Each';
        lineItemS.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemS.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductVersion__c = 1;
        lineItemS.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemS.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__SellingTerm__c = 1;
        lineItemS.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemS.Apttus_Config2__Taxable__c = FALSE;
        lineItemS.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemS.Apttus_Config2__Term__c = 1;
        lineItemS.Apttus_Config2__TotalQuantity__c = 1;
        lineItemS.Apttus_Config2__Uom__c = 'Each';
        lineItemS.CurrencyIsoCode = 'USD';
        lineItemS.APTS_Product_Family__c = 'WESTLAW';
        lineItemS.APTS_Contract_Term__c = '2 Years';
        lineItemS.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemS.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItemS);
        
        Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle A';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.APTS_Deal_Type__c = 'WCMPS';
        lineItem.APTS_is_Primary_in_Bundle__c = true;
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';

        liList.add(lineItem);
        
        Apttus_Config2__LineItem__c lineItem2 =  new Apttus_Config2__LineItem__c();
        lineItem2.APTS_Group_Primary_Material__c= '40666420';
        lineItem2.Apttus_Config2__LineStatus__c = 'Amended';  
        lineItem2.APTS_Group__c = 'Bundle A';
        lineItem2.APTS_Contract_Number__c = 1234564;
        lineItem2.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem2.Apttus_Config2__ItemSequence__c = 1;
        lineItem2.Apttus_Config2__LineNumber__c = 2;
        lineItem2.APTS_Deal_Type__c ='WCMP';
        lineItem2.APTS_is_Primary_in_Bundle__c = true;
        lineItem2.Apttus_Config2__AddedBy__c = 'User';
        lineItem2.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem2.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowProration__c = FALSE;
        lineItem2.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem2.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem2.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem2.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__BasePrice__c = 100;
        lineItem2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem2.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem2.Apttus_Config2__Customizable__c = FALSE;
        lineItem2.Apttus_Config2__DeltaPrice__c = 50;
        lineItem2.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem2.Apttus_Config2__ExtendedCost__c = 0;
        lineItem2.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem2.Apttus_Config2__Guidance__c = 'Red';
        lineItem2.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem2.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem2.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem2.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem2.Apttus_Config2__HasOptions__c = FALSE;
        lineItem2.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem2.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem2.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsHidden__c = FALSE;
        lineItem2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem2.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem2.Apttus_Config2__LineSequence__c = 1;
        lineItem2.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem2.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem2.Apttus_Config2__ListPrice__c = 100;
        lineItem2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem2.Apttus_Config2__NetPrice__c = 50;
        lineItem2.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem2.Apttus_Config2__OptionSequence__c = 0;
        lineItem2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem2.Apttus_Config2__PriceUom__c = 'Each';
        lineItem2.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem2.Apttus_Config2__ProductVersion__c = 1;
        lineItem2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__SellingTerm__c = 1;
        lineItem2.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem2.Apttus_Config2__Taxable__c = FALSE;
        lineItem2.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem2.Apttus_Config2__Term__c = 1;
        lineItem2.Apttus_Config2__TotalQuantity__c = 1;
        lineItem2.Apttus_Config2__Uom__c = 'Each';
        lineItem2.CurrencyIsoCode = 'USD';
        lineItem2.APTS_Product_Family__c = 'WESTLAW';
        lineItem2.APTS_Contract_Term__c = '2 Years';
        lineItem2.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem2.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem2);
        
        Apttus_Config2__LineItem__c lineItem3 =  new Apttus_Config2__LineItem__c();
        lineItem3.APTS_Group_Primary_Material__c= '40666420';
        lineItem3.Apttus_Config2__LineStatus__c = 'New';  
        lineItem3.APTS_Group__c = 'Bundle A';
        lineItem3.APTS_Contract_Number__c = 1234564;
        lineItem3.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem3.Apttus_Config2__ItemSequence__c = 1;
        lineItem3.Apttus_Config2__LineNumber__c = 3;
        lineItem3.APTS_is_Primary_in_Bundle__c = true;
        lineItem3.Apttus_Config2__AddedBy__c = 'User';
        lineItem3.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem3.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem3.Apttus_Config2__AllowProration__c = FALSE;
        lineItem3.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem3.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem3.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem3.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem3.Apttus_Config2__BasePrice__c = 100;
        lineItem3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem3.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem3.Apttus_Config2__Customizable__c = FALSE;
        lineItem3.Apttus_Config2__DeltaPrice__c = 50;
        lineItem3.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem3.Apttus_Config2__ExtendedCost__c = 0;
        lineItem3.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem3.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem3.Apttus_Config2__Guidance__c = 'Red';
        lineItem3.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem3.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem3.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem3.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem3.Apttus_Config2__HasOptions__c = FALSE;
        lineItem3.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem3.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem3.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem3.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem3.Apttus_Config2__IsHidden__c = FALSE;
        lineItem3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem3.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem3.Apttus_Config2__LineSequence__c = 1;
        lineItem3.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem3.Apttus_Config2__ListPrice__c = 100;
        lineItem3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem3.Apttus_Config2__NetPrice__c = 50;
        lineItem3.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem3.Apttus_Config2__OptionSequence__c = 0;
        lineItem3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem3.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem3.Apttus_Config2__PriceUom__c = 'Each';
        lineItem3.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem3.Apttus_Config2__ProductVersion__c = 1;
        lineItem3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem3.Apttus_Config2__SellingTerm__c = 1;
        lineItem3.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem3.Apttus_Config2__Taxable__c = FALSE;
        lineItem3.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem3.Apttus_Config2__Term__c = 1;
        lineItem3.Apttus_Config2__TotalQuantity__c = 1;
        lineItem3.Apttus_Config2__Uom__c = 'Each';
        lineItem3.CurrencyIsoCode = 'USD';
        lineItem3.APTS_Product_Family__c = 'WESTLAW';
        lineItem3.APTS_Contract_Term__c = '2 Years';
        lineItem3.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem3.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem3);
        
        Apttus_Config2__LineItem__c lineItem4 =  new Apttus_Config2__LineItem__c();
        lineItem4.Apttus_Config2__LineStatus__c = 'New';  
        lineItem4.APTS_Group__c = 'Bundle A';
        lineItem4.APTS_Contract_Number__c = 1234564;
        lineItem4.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem4.Apttus_Config2__ItemSequence__c = 1;
        lineItem4.Apttus_Config2__LineNumber__c = 4;  
        lineItem4.APTS_is_Primary_in_Bundle__c = true;  
        lineItem4.Apttus_Config2__AddedBy__c = 'User';
        lineItem4.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem4.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem4.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem4.Apttus_Config2__AllowProration__c = FALSE;
        lineItem4.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem4.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem4.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem4.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem4.Apttus_Config2__BasePrice__c = 100;
        lineItem4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem4.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem4.Apttus_Config2__Customizable__c = FALSE;
        lineItem4.Apttus_Config2__DeltaPrice__c = 50;
        lineItem4.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem4.Apttus_Config2__ExtendedCost__c = 0;
        lineItem4.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem4.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem4.Apttus_Config2__Guidance__c = 'Red';
        lineItem4.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem4.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem4.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem4.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem4.Apttus_Config2__HasOptions__c = FALSE;
        lineItem4.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem4.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem4.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem4.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem4.Apttus_Config2__IsHidden__c = FALSE;
        lineItem4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem4.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem4.Apttus_Config2__LineSequence__c = 1;
        lineItem4.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem4.Apttus_Config2__ListPrice__c = 100;
        lineItem4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem4.Apttus_Config2__NetPrice__c = 50;
        lineItem4.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem4.Apttus_Config2__OptionSequence__c = 0;
        lineItem4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem4.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem4.Apttus_Config2__PriceUom__c = 'Each';
        lineItem4.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem4.Apttus_Config2__ProductVersion__c = 1;
        lineItem4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem4.Apttus_Config2__SellingTerm__c = 1;
        lineItem4.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem4.Apttus_Config2__Taxable__c = FALSE;
        lineItem4.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem4.Apttus_Config2__Term__c = 1;
        lineItem4.Apttus_Config2__TotalQuantity__c = 1;
        lineItem4.Apttus_Config2__Uom__c = 'Each';
        lineItem4.CurrencyIsoCode = 'USD';
        lineItem4.APTS_Product_Family__c = 'WESTLAW';
        lineItem4.APTS_Contract_Term__c = '2 Years';
        lineItem4.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem4.APTS_Product_Delivery__c = 'Online/Internet';    
        liList.add(lineItem4);
        
        Apttus_Config2__LineItem__c lineItem5 =  new Apttus_Config2__LineItem__c();
        lineItem5.APTS_Group_Primary_Material__c= '40666420';
        lineItem5.Apttus_Config2__LineStatus__c = 'New';  
        //lineItem4.APTS_Group__c = 'Bundle A';
        lineItem5.APTS_Contract_Number__c = 1234564;
        lineItem5.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem5.Apttus_Config2__ItemSequence__c = 1;
        lineItem5.Apttus_Config2__LineNumber__c = 5;
        lineItem5.APTS_is_Primary_in_Bundle__c = true;
        lineItem5.Apttus_Config2__AddedBy__c = 'User';
        lineItem5.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem5.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem5.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowProration__c = FALSE;
        lineItem5.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem5.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem5.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem5.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__BasePrice__c = 100;
        lineItem5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem5.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem5.Apttus_Config2__Customizable__c = FALSE;
        lineItem5.Apttus_Config2__DeltaPrice__c = 50;
        lineItem5.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem5.Apttus_Config2__ExtendedCost__c = 0;
        lineItem5.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem5.Apttus_Config2__Guidance__c = 'Red';
        lineItem5.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem5.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem5.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem5.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem5.Apttus_Config2__HasOptions__c = FALSE;
        lineItem5.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem5.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem5.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsHidden__c = FALSE;
        lineItem5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem5.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem5.Apttus_Config2__LineSequence__c = 1;
        lineItem5.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem5.Apttus_Config2__ListPrice__c = 100;
        lineItem5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem5.Apttus_Config2__NetPrice__c = 50;
        lineItem5.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem5.Apttus_Config2__OptionSequence__c = 0;
        lineItem5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem5.Apttus_Config2__PriceUom__c = 'Each';
        lineItem5.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem5.Apttus_Config2__ProductVersion__c = 1;
        lineItem5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__SellingTerm__c = 1;
        lineItem5.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem5.Apttus_Config2__Taxable__c = FALSE;
        lineItem5.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem5.Apttus_Config2__Term__c = 1;
        lineItem5.Apttus_Config2__TotalQuantity__c = 1;
        lineItem5.Apttus_Config2__Uom__c = 'Each';
        lineItem5.CurrencyIsoCode = 'USD';
        lineItem5.APTS_Product_Family__c = 'WESTLAW';
        lineItem5.APTS_Contract_Term__c = '2 Years';
        lineItem5.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem5.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem5);
        
        Apttus_Config2__LineItem__c lineItemN =  new Apttus_Config2__LineItem__c();
        lineItemN.APTS_Group_Primary_Material__c= '40666420';
        lineItemN.Apttus_Config2__LineStatus__c = 'New';  
        lineItemN.APTS_Group__c = 'Bundle A';
        lineItemN.APTS_Contract_Number__c = 1234564;
        lineItemN.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemN.Apttus_Config2__ItemSequence__c = 1;
        lineItemN.Apttus_Config2__LineNumber__c = 6;
        lineItemN.Apttus_Config2__ProductId__c = productN.Id;
        lineItemN.APTS_is_Primary_in_Bundle__c = true;
        lineItemN.Apttus_Config2__AddedBy__c = 'User';
        lineItemN.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemN.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemN.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemN.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemN.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemN.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemN.Apttus_Config2__AllowProration__c = FALSE;
        lineItemN.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemN.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemN.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemN.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemN.Apttus_Config2__BasePrice__c = 100;
        lineItemN.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemN.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemN.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemN.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemN.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemN.Apttus_Config2__Customizable__c = FALSE;
        lineItemN.Apttus_Config2__DeltaPrice__c = 50;
        lineItemN.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemN.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemN.Apttus_Config2__ExtendedCost__c = 0;
        lineItemN.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemN.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemN.Apttus_Config2__Guidance__c = 'Red';
        lineItemN.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemN.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemN.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemN.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemN.Apttus_Config2__HasOptions__c = FALSE;
        lineItemN.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemN.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemN.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemN.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemN.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemN.Apttus_Config2__IsHidden__c = FALSE;
        lineItemN.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemN.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemN.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemN.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemN.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemN.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemN.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemN.Apttus_Config2__LineSequence__c = 1;
        lineItemN.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemN.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemN.Apttus_Config2__ListPrice__c = 100;
        lineItemN.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemN.Apttus_Config2__NetPrice__c = 50;
        lineItemN.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemN.Apttus_Config2__OptionSequence__c = 0;
        lineItemN.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemN.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemN.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemN.Apttus_Config2__PriceUom__c = 'Each';
        lineItemN.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemN.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemN.Apttus_Config2__ProductVersion__c = 1;
        lineItemN.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemN.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemN.Apttus_Config2__SellingTerm__c = 1;
        lineItemN.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemN.Apttus_Config2__Taxable__c = FALSE;
        lineItemN.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemN.Apttus_Config2__Term__c = 1;
        lineItemN.Apttus_Config2__TotalQuantity__c = 1;
        lineItemN.Apttus_Config2__Uom__c = 'Each';
        lineItemN.CurrencyIsoCode = 'USD';
        lineItemN.APTS_Product_Family__c = 'WESTLAW';
        lineItemN.APTS_Contract_Term__c = '2 Years';
        lineItemN.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemN.APTS_Product_Delivery__c = 'Online/Internet';

        liList.add(lineItemN);

        Apttus_Config2__LineItem__c lineItemNN =  new Apttus_Config2__LineItem__c();
        lineItemNN.APTS_Group_Primary_Material__c= '40666420';
        lineItemNN.Apttus_Config2__LineStatus__c = 'New';  
        lineItemNN.APTS_Group__c = 'Bundle A';
        lineItemNN.APTS_Contract_Number__c = 1234564;
        lineItemNN.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemNN.Apttus_Config2__ItemSequence__c = 1;
        lineItemNN.Apttus_Config2__LineNumber__c = 6;
        lineItemNN.Apttus_Config2__ProductId__c = productNN.Id;
        lineItemNN.APTS_is_Primary_in_Bundle__c = true;
        lineItemNN.Apttus_Config2__AddedBy__c = 'User';
        lineItemNN.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemNN.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemNN.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemNN.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemNN.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemNN.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemNN.Apttus_Config2__AllowProration__c = FALSE;
        lineItemNN.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemNN.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemNN.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemNN.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemNN.Apttus_Config2__BasePrice__c = 100;
        lineItemNN.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemNN.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemNN.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemNN.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemNN.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemNN.Apttus_Config2__Customizable__c = FALSE;
        lineItemNN.Apttus_Config2__DeltaPrice__c = 50;
        lineItemNN.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemNN.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemNN.Apttus_Config2__ExtendedCost__c = 0;
        lineItemNN.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemNN.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemNN.Apttus_Config2__Guidance__c = 'Red';
        lineItemNN.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemNN.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemNN.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemNN.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemNN.Apttus_Config2__HasOptions__c = FALSE;
        lineItemNN.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemNN.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemNN.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemNN.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemNN.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemNN.Apttus_Config2__IsHidden__c = FALSE;
        lineItemNN.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemNN.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemNN.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemNN.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemNN.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemNN.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemNN.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemNN.Apttus_Config2__LineSequence__c = 1;
        lineItemNN.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemNN.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemNN.Apttus_Config2__ListPrice__c = 100;
        lineItemNN.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemNN.Apttus_Config2__NetPrice__c = 50;
        lineItemNN.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemNN.Apttus_Config2__OptionSequence__c = 0;
        lineItemNN.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemNN.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemNN.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemNN.Apttus_Config2__PriceUom__c = 'Each';
        lineItemNN.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemNN.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemNN.Apttus_Config2__ProductVersion__c = 1;
        lineItemNN.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemNN.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemNN.Apttus_Config2__SellingTerm__c = 1;
        lineItemNN.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemNN.Apttus_Config2__Taxable__c = FALSE;
        lineItemNN.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemNN.Apttus_Config2__Term__c = 1;
        lineItemNN.Apttus_Config2__TotalQuantity__c = 1;
        lineItemNN.Apttus_Config2__Uom__c = 'Each';
        lineItemNN.CurrencyIsoCode = 'USD';
        lineItemNN.APTS_Product_Family__c = 'WESTLAW';
        lineItemNN.APTS_Contract_Term__c = '2 Years';
        lineItemNN.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemNN.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItemNN);
            
        //Added newly 11th Nov
        
        APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
        dynamicbundlewm.APTS_Group__c='Bundle A';
        dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm.APTS_Keep_Terms__c=true;
        dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewm.APTS_Deal_Number__c = 623589;
        dynamicbundlewm.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm.APTS_Bridge_Length__c = 2;
        dynamicbundlewm.APTS_Bridge__c = '28 Days';
        dynamicbundlewm.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewm;
        
        APTS_Dynamic_Bundle__c dynamicbundlewm2 = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm2.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm2.APTS_Program_ID__c= 'WCMP';  
        dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewm2.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm2.APTS_Keep_Terms__c=false;
        dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewm.APTS_Deal_Number__c = 623589;
        dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm2.APTS_Bridge_Length__c = 2;
        dynamicbundlewm2.APTS_Bridge__c = '14 Days';
        dynamicbundlewm2.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewm2;  
        
        APTS_Dynamic_Bundle__c dynamicbundlewmK = new APTS_Dynamic_Bundle__c();
        dynamicbundlewmK.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewmK.APTS_Program_ID__c= 'WCMP';  
        //dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewmK.APTS_Quote_Proposal__c=oProposal.id;
        //dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        //dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewmK.APTS_Keep_Terms__c=false;
        //dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        //dynamicbundlewmK.APTS_Deal_Number__c = 623589;
        //dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewmK.APTS_Bridge_Length__c = 2;
        dynamicbundlewmK.APTS_Bridge__c = '14 Days';
        dynamicbundlewmk.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewmK;
        
        APTS_Dynamic_Bundle__c dynamicbundlewmF = new APTS_Dynamic_Bundle__c();
        dynamicbundlewmF.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewmF.APTS_Program_ID__c= 'WCMP';  
        //dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewmF.APTS_Quote_Proposal__c=oProposal.id;
        //dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        //dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewmF.APTS_Keep_Terms__c=false;
        //dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewmF.APTS_Deal_Number__c = 623589;
        //dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewmF.APTS_Bridge_Length__c = 2;
        dynamicbundlewmF.APTS_Bridge__c = '14 Days';
        dynamicbundlewmF.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewmF;
        
        Test.startTest(); 
        insert liList;
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);
        System.assertEquals(1,ordLists.size());
        
        Test.stopTest();
        
    } 
    
    //SOC-4845
    static testMethod void orderQueuetoESI4845(){ 
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        APTS_LineItemTriggerHandler.afterUpdate = true;
        APTS_LineItemTriggerHandler.afterInsert = true;
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true; 
        
        APTS_ProposalTriggerHandler.beforeUpdate = true;
        APTS_ProposalTriggerHandler.beforeInsert = true;
        APTS_ProposalTriggerHandler.beforeDelete = true;
        APTS_ProposalTriggerHandler.afterUpdate = true;
        APTS_ProposalTriggerHandler.afterInsert = true;
        APTS_ProposalTriggerHandler.afterDelete = true;
        
        Account acc = new Account();
        acc.Name='testWCMP2';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc; 
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='WCMP2';
        con.FirstName='Bundle2';
        insert con;
        
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test2',
            APTS_Proposal_Business_Unit__c='SCS',
            APTS_Approval_Segment__c='Corporate Emerging',
            APTS_Order_Confirmation_Contact__c=con.id,
            APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
            Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,
            APTS_Payment_Option__c='Credit Card' ,
            APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
        //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)');
        insert oProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
        insert prodConfig;
       
        
        List<Apttus_Config2__Order__c> ordLists =new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        //order.Apttus_Config2__Status__c='Ready for Activation';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order.Apttus_Config2__Status__c='Pending';
        order.Retry_Count__c = 2;
        insert order;
        ordLists.add(order);
       //  Test.startTest();
        Product2 oProductB = new Product2(Name='WCMP Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'P7',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c = 'ZPMT');
        insert oProductB;
        
        Product2 oProductProf = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG');
        insert oProductProf;
        system.debug('Product... '+oProductB);
        
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order.id;
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A'; 
        ordline.APTS_Program_ID__c = 'WCMP';
        ordline.APTS_Bridge__c='11 Months';
        ordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline.Apttus_Config2__NetPrice__c = 1728;
        insert ordline;
        system.debug('Orderline item... '+ordline); 
         Test.startTest();
        Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute3.SCS_Print_Purchase_Options__c='Ship & Enter Sub';
        attribute3.Apttus_Config2__LineItemId__c=ordline.id;
        Insert attribute3;
        
        ordline.Apttus_Config2__AttributeValueId__c=attribute3.id;
        Update ordline;
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='1 Year';
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id;
        ordline2.APTS_Group__c='Bundle A'; 
        ordline2.APTS_Program_ID__c = 'WCMP';
        ordline2.APTS_Bridge__c='2 Months';
        ordline2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline2.Apttus_Config2__NetPrice__c = 1728;
        insert ordline2;
        
        Apttus_Config2__OrderProductAttributeValue__c attribute4 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute4.SCS_Print_Purchase_Options__c='Sub Only';
        attribute4.Apttus_Config2__LineItemId__c=ordline2.id;
        Insert attribute4;
        
        ordline2.Apttus_Config2__AttributeValueId__c=attribute4.id;
        Update ordline2;
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='1 Year';
        ordline3.Apttus_Config2__OrderId__c=order.id;
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__ProductId__c=oProductB.id;
        ordline3.APTS_Group__c='Bundle A'; 
        ordline3.APTS_Program_ID__c = 'WCMP';
        ordline3.APTS_Bridge__c='3 Months';
        ordline3.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline3.Apttus_Config2__NetPrice__c = 1728;
        ordline3.Apttus_Config2__AdjustmentType__c = '% Markup';
        insert ordline3;
        
        Apttus_Config2__OrderProductAttributeValue__c attribute5 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute5.SCS_Print_Purchase_Options__c='Ship & Enter Sub APP';
        attribute5.Apttus_Config2__LineItemId__c=ordline3.id;
        attribute5.eBook_Purchase_Options__c = 'APP';
        Insert attribute5;
        
        ordline3.Apttus_Config2__AttributeValueId__c=attribute5.id;
        Update ordline3;
        
        Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
        ordline4.APTS_Contract_Term__c='1 Year';
        ordline4.Apttus_Config2__OrderId__c=order.id;
        ordline4.Apttus_Config2__Quantity__c=1.000;
        ordline4.Apttus_Config2__ProductId__c=oProductB.id;
        ordline4.APTS_Group__c='Bundle A'; 
        ordline4.APTS_Program_ID__c = 'WCMP';
        ordline4.APTS_Bridge__c='4 Months';
        ordline4.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline4.Apttus_Config2__NetPrice__c = 1728;  
        insert ordline4;
        
        Apttus_Config2__OrderProductAttributeValue__c attribute6 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute6.SCS_Print_Purchase_Options__c='Sub Only APP';
        attribute6.Apttus_Config2__LineItemId__c=ordline4.id;
        attribute6.eBook_Purchase_Options__c = 'Entitle and Charge';
        Insert attribute6;
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute6.id;
        Update ordline4;
        
        Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
        ordline5.APTS_Contract_Term__c='1 Year';
        ordline5.Apttus_Config2__OrderId__c=order.id;
        ordline5.Apttus_Config2__Quantity__c=1.000;
        ordline5.Apttus_Config2__ProductId__c=oProductB.id;
        ordline5.APTS_Group__c='Bundle A'; 
        ordline5.APTS_Program_ID__c = 'WCMP';
        ordline5.APTS_Bridge__c='5 Months';
        ordline5.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline5.Apttus_Config2__NetPrice__c = 1728;
        ordline5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline5.Apttus_Config2__PriceType__c = 'One Time';
        insert ordline5;
        
        Apttus_Config2__OrderProductAttributeValue__c attribute7 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute7.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute7.Apttus_Config2__LineItemId__c=ordline5.id;
        attribute7.eBook_Purchase_Options__c = 'Entitle and Charge';
        Insert attribute7;
        
        ordline5.Apttus_Config2__AttributeValueId__c=attribute7.id;
        Update ordline5;
        
        Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c();
        ordline6.APTS_Contract_Term__c='1 Year';
        ordline6.Apttus_Config2__OrderId__c=order.id;
        ordline6.Apttus_Config2__Quantity__c=1.000;
        ordline6.Apttus_Config2__ProductId__c=oProductB.id;
        ordline6.APTS_Group__c='Bundle A'; 
        ordline6.APTS_Program_ID__c = 'WCMP';
        ordline6.APTS_Bridge__c='6 Months';
        ordline6.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline6.Apttus_Config2__NetPrice__c = 1728;
        ordline6.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline6.Apttus_Config2__PriceType__c = 'One Time';
        ordline6.Apttus_Config2__AttributeValueId__c = attribute7.id;
        ordline6.Apttus_Config2__LineType__c = 'Product/Service';
        insert ordline6;
        
        Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c();
        ordline7.APTS_Contract_Term__c='1 Year';
        ordline7.Apttus_Config2__OrderId__c=order.id;
        ordline7.Apttus_Config2__Quantity__c=1.000;
        ordline7.Apttus_Config2__ProductId__c=oProductB.id;
        ordline7.APTS_Group__c='Bundle A'; 
        ordline7.APTS_Program_ID__c = 'WCMP';
        ordline7.APTS_Bridge__c='7 Months';
        ordline7.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline7.Apttus_Config2__NetPrice__c = 1728;
        ordline7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline7.Apttus_Config2__PriceType__c = 'Recurring';
        insert ordline7;
        
        Apttus_Config2__OrderProductAttributeValue__c attribute9 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute9.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute9.Apttus_Config2__LineItemId__c=ordline7.id;
        attribute9.eBook_Purchase_Options__c = 'Entitle and Charge';
        Insert attribute9;
        
        ordline7.Apttus_Config2__AttributeValueId__c=attribute9.id;
        Update ordline7;  
        
        Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c();
        ordline8.APTS_Contract_Term__c='1 Year';
        ordline8.Apttus_Config2__OrderId__c=order.id;
        ordline8.Apttus_Config2__Quantity__c=1.000;
        ordline8.Apttus_Config2__ProductId__c=oProductB.id;
        ordline8.APTS_Group__c='Bundle A'; 
        ordline8.APTS_Program_ID__c = 'WCMP';
        ordline8.APTS_Bridge__c='8 Months';
        ordline8.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline8.Apttus_Config2__NetPrice__c = 1728;
        ordline8.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline8.Apttus_Config2__PriceType__c = 'One Time';
        ordline8.Apttus_Config2__AttributeValueId__c = attribute9.id;
        ordline8.Apttus_Config2__LineType__c = 'Product/Service';
        insert ordline8;
        
        Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c();
        ordline9.APTS_Contract_Term__c='1 Year';
        ordline9.Apttus_Config2__OrderId__c=order.id;
        ordline9.Apttus_Config2__Quantity__c=1.000;
        ordline9.Apttus_Config2__ProductId__c=oProductB.id;
        ordline9.APTS_Group__c='Bundle A'; 
        ordline9.APTS_Program_ID__c = 'WCMP';
        ordline9.APTS_Bridge__c='9 Months';
        ordline9.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline9.Apttus_Config2__NetPrice__c = 1728;
        ordline9.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline9.Apttus_Config2__PriceType__c = 'One Time';
        ordline9.Apttus_Config2__AttributeValueId__c = attribute9.id;
        ordline9.Apttus_Config2__LineType__c = 'Option';
        insert ordline9;
        
        Apttus_Config2__OrderProductAttributeValue__c attribute11 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute11.SCS_Print_Purchase_Options__c='Fill-Up';
        attribute11.Apttus_Config2__LineItemId__c=ordline9.id;
        attribute11.eBook_Purchase_Options__c = 'Entitle and Charge';
        Insert attribute11;
        
        ordline9.Apttus_Config2__AttributeValueId__c=attribute11.id;
        Update ordline9;
        
        Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c();
        ordline10.APTS_Contract_Term__c='1 Year';
        ordline10.Apttus_Config2__OrderId__c=order.id;
        ordline10.Apttus_Config2__Quantity__c=1.000;
        ordline10.Apttus_Config2__ProductId__c=oProductB.id;
        ordline10.APTS_Group__c='Bundle A'; 
        ordline10.APTS_Program_ID__c = 'WCMP';
        ordline10.APTS_Bridge__c='10 Months';
        ordline10.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline10.Apttus_Config2__NetPrice__c = 1728;
        ordline10.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline10.Apttus_Config2__PriceType__c = 'One Time';
        ordline10.Apttus_Config2__LineType__c = 'Product/Service';
        insert ordline10;
        
        Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='5 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = oProductProf.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = true;
        ordlineProf.APTS_Deal_Number__c = 12345;
        ordlineProf.apts_mla__c = true;
        insert ordlineProf;
        
        Apttus_Config2__OrderProductAttributeValue__c attribute10 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute10.SCS_Print_Purchase_Options__c='Fill-Up';
        attribute10.Apttus_Config2__LineItemId__c=ordline10.id;
        attribute10.eBook_Purchase_Options__c = 'Entitle and Charge';
        Insert attribute10;
        
        ordline10.Apttus_Config2__AttributeValueId__c=attribute10.id;
        Update ordline10;
        
        ordline9.Apttus_Config2__AttributeValueId__c=attribute10.id;
        Update ordline9;
        attribute10.Apttus_Config2__LineItemId__c=ordline9.id;
        update attribute10;
        
        List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle A';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.APTS_Deal_Type__c = 'WCMP';
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem.Apttus_Config2__Quantity__c = 1;
        liList.add(lineItem);
        
        Apttus_Config2__LineItem__c lineItem2 =  new Apttus_Config2__LineItem__c();
        lineItem2.APTS_Group_Primary_Material__c= '40666420';
        lineItem2.Apttus_Config2__LineStatus__c = 'Amended';  
        lineItem2.APTS_Group__c = 'Bundle A';
        lineItem2.APTS_Contract_Number__c = 1234564;
        lineItem2.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem2.Apttus_Config2__ItemSequence__c = 1;
        lineItem2.Apttus_Config2__LineNumber__c = 2;
        lineItem2.APTS_Deal_Type__c ='WCMP';   
        lineItem2.Apttus_Config2__AddedBy__c = 'User';
        lineItem2.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem2.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowProration__c = FALSE;
        lineItem2.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem2.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem2.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem2.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__BasePrice__c = 100;
        lineItem2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem2.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem2.Apttus_Config2__Customizable__c = FALSE;
        lineItem2.Apttus_Config2__DeltaPrice__c = 50;
        lineItem2.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem2.Apttus_Config2__ExtendedCost__c = 0;
        lineItem2.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem2.Apttus_Config2__Guidance__c = 'Red';
        lineItem2.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem2.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem2.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem2.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem2.Apttus_Config2__HasOptions__c = FALSE;
        lineItem2.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem2.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem2.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsHidden__c = FALSE;
        lineItem2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem2.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem2.Apttus_Config2__LineSequence__c = 1;
        lineItem2.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem2.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem2.Apttus_Config2__ListPrice__c = 100;
        lineItem2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem2.Apttus_Config2__NetPrice__c = 50;
        lineItem2.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem2.Apttus_Config2__OptionSequence__c = 0;
        lineItem2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem2.Apttus_Config2__PriceUom__c = 'Each';
        lineItem2.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem2.Apttus_Config2__ProductVersion__c = 1;
        lineItem2.Apttus_Config2__Quantity__c = 1;
        lineItem2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__SellingTerm__c = 1;
        lineItem2.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem2.Apttus_Config2__Taxable__c = FALSE;
        lineItem2.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem2.Apttus_Config2__Term__c = 1;
        lineItem2.Apttus_Config2__TotalQuantity__c = 1;
        lineItem2.Apttus_Config2__Uom__c = 'Each';
        lineItem2.CurrencyIsoCode = 'USD';
        lineItem2.APTS_Product_Family__c = 'WESTLAW';
        lineItem2.APTS_Contract_Term__c = '2 Years';
        lineItem2.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem2.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem2.Apttus_Config2__Quantity__c = 1;       
        liList.add(lineItem2);
        
        Apttus_Config2__LineItem__c lineItem5 =  new Apttus_Config2__LineItem__c();
        lineItem5.APTS_Group_Primary_Material__c= '40666420';
        lineItem5.Apttus_Config2__LineStatus__c = 'New';  
        lineItem5.APTS_Group__c = 'Bundle B';
        lineItem5.APTS_Contract_Number__c = 1234564;
        lineItem5.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem5.Apttus_Config2__ItemSequence__c = 1;
        lineItem5.Apttus_Config2__LineNumber__c = 5;
        lineItem5.Apttus_Config2__AddedBy__c = 'User';
        lineItem5.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem5.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem5.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowProration__c = FALSE;
        lineItem5.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem5.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem5.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem5.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__BasePrice__c = 100;
        lineItem5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem5.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem5.Apttus_Config2__Customizable__c = FALSE;
        lineItem5.Apttus_Config2__DeltaPrice__c = 50;
        lineItem5.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem5.Apttus_Config2__ExtendedCost__c = 0;
        lineItem5.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem5.Apttus_Config2__Guidance__c = 'Red';
        lineItem5.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem5.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem5.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem5.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem5.Apttus_Config2__HasOptions__c = FALSE;
        lineItem5.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem5.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem5.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsHidden__c = FALSE;
        lineItem5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem5.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem5.Apttus_Config2__LineSequence__c = 1;
        lineItem5.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem5.Apttus_Config2__ListPrice__c = 100;
        lineItem5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem5.Apttus_Config2__NetPrice__c = 50;
        lineItem5.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem5.Apttus_Config2__OptionSequence__c = 0;
        lineItem5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem5.Apttus_Config2__PriceUom__c = 'Each';
        lineItem5.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem5.Apttus_Config2__ProductVersion__c = 1;
        lineItem5.Apttus_Config2__Quantity__c = 1;
        lineItem5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__SellingTerm__c = 1;
        lineItem5.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem5.Apttus_Config2__Taxable__c = FALSE;
        lineItem5.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem5.Apttus_Config2__Term__c = 1;
        lineItem5.Apttus_Config2__TotalQuantity__c = 1;
        lineItem5.Apttus_Config2__Uom__c = 'Each';
        lineItem5.CurrencyIsoCode = 'USD';
        lineItem5.APTS_Product_Family__c = 'WESTLAW';
        lineItem5.APTS_Contract_Term__c = '2 Years';
        lineItem5.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem5.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem5.Apttus_Config2__Quantity__c = 1;

        liList.add(lineItem5);
        
        Apttus_Config2__LineItem__c lineItem6 =  new Apttus_Config2__LineItem__c();        
        lineItem6.Apttus_Config2__LineStatus__c = 'New';    
        lineItem6.APTS_Contract_Number__c = 1234564;
        lineItem6.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem6.Apttus_Config2__ItemSequence__c = 1;
        lineItem6.Apttus_Config2__LineNumber__c = 5;
        lineItem6.Apttus_Config2__AddedBy__c = 'User';
        lineItem6.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem6.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem6.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem6.Apttus_Config2__AllowProration__c = FALSE;
        lineItem6.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem6.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem6.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem6.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem6.Apttus_Config2__BasePrice__c = 100;
        lineItem6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem6.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem6.Apttus_Config2__Customizable__c = FALSE;
        lineItem6.Apttus_Config2__DeltaPrice__c = 50;
        lineItem6.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem6.Apttus_Config2__ExtendedCost__c = 0;
        lineItem6.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem6.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem6.Apttus_Config2__Guidance__c = 'Red';
        lineItem6.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem6.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem6.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem6.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem6.Apttus_Config2__HasOptions__c = FALSE;
        lineItem6.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem6.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem6.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem6.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem6.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem6.Apttus_Config2__IsHidden__c = FALSE;
        lineItem6.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem6.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem6.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem6.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem6.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem6.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem6.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem6.Apttus_Config2__LineSequence__c = 1;
        lineItem6.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem6.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem6.Apttus_Config2__ListPrice__c = 100;
        lineItem6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem6.Apttus_Config2__NetPrice__c = 50;
        lineItem6.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem6.Apttus_Config2__OptionSequence__c = 0;
        lineItem6.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem6.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem6.Apttus_Config2__PriceUom__c = 'Each';
        lineItem6.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem6.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem6.Apttus_Config2__ProductVersion__c = 1;
        lineItem6.Apttus_Config2__Quantity__c = 1;
        lineItem6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem6.Apttus_Config2__SellingTerm__c = 1;
        lineItem6.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem6.Apttus_Config2__Taxable__c = FALSE;
        lineItem6.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem6.Apttus_Config2__Term__c = 1;
        lineItem6.Apttus_Config2__TotalQuantity__c = 1;
        lineItem6.Apttus_Config2__Uom__c = 'Each';
        lineItem6.CurrencyIsoCode = 'USD';
        lineItem6.APTS_Product_Family__c = 'WESTLAW';
        lineItem6.APTS_Contract_Term__c = '2 Years';
        lineItem6.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem6.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem6.Apttus_Config2__Quantity__c = 1;

        liList.add(lineItem6);
        
        APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
        dynamicbundlewm.APTS_Group__c='Bundle A';
        dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm.APTS_Keep_Terms__c=false;
        dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewm.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm.APTS_Bridge_Length__c = 2;
        dynamicbundlewm.APTS_Bundle_Adjustment_Type__c = '% Discount';
        dynamicbundlewm.APTS_Bridge__c = '7 Days'; 
        //dynamicbundlewm.APTS_isBLINotCreated__c= true; 
        insert dynamicbundlewm;  
                
        insert liList;
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);  
        System.assertEquals(1,ordLists.size());
        Test.stopTest();
    } 
    
    @isTest static void onlineBundlestest(){
        Account acc = new Account();
        acc.Name='testWCMP';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Source_System_Account_Number__c = '123456';
        insert accountSSD;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
        
        APTS_LineItemTriggerHandler.afterUpdate = true;
        APTS_LineItemTriggerHandler.afterInsert = true;
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true; 
        
        APTS_ProposalTriggerHandler.beforeUpdate = true;
        APTS_ProposalTriggerHandler.beforeInsert = true;
        APTS_ProposalTriggerHandler.beforeDelete = true;
        APTS_ProposalTriggerHandler.afterUpdate = true;
        APTS_ProposalTriggerHandler.afterInsert = true;
        APTS_ProposalTriggerHandler.afterDelete = true; 
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Oppty Online',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;  
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='WCMP';
        con.FirstName='Bundle';
        insert con;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Primary Product', ProductCode = '1234568978965', APTS_Corporate_Select__c = 'Primary');
        Product2 oProductP = new Product2(Name='Option Product', ProductCode = '1234568978966', APTS_Corporate_Select__c = 'Module');
        Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9');
        Product2 oProductStd = new Product2(Name='Standard ProductMLA', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='2P');
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(oProductS);
        productlist.add(oProductStd);
        insert productlist;
        
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test',
            APTS_Proposal_Business_Unit__c='SCS',
            APTS_Approval_Segment__c='Corporate Emerging',
            APTS_Order_Confirmation_Contact__c=con.id,
            APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
            Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,
            //APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
            APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
        //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)');
        insert oProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
        insert prodConfig;
        
        List<Apttus_Config2__Order__c> ordLists =new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Ready for Activation';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order.Apttus_Config2__Status__c='Pending';
        order.Retry_Count__c = 2;
        order.APTS_Payer__c = accountSSD.id;
        insert order;
        ordLists.add(order);
        
        Apttus_Config2__LineItem__c lineItemP =  new Apttus_Config2__LineItem__c();
        lineItemP.APTS_Group_Primary_Material__c= '40666420';
        lineItemP.Apttus_Config2__LineStatus__c = 'New';  
        //lineItemP.APTS_Group__c = 'Bundle A';
        lineItemP.APTS_Contract_Number__c = 123456;
        lineItemP.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemP.Apttus_Config2__ItemSequence__c = 1;
        lineItemP.Apttus_Config2__LineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductId__c = oProductB.Id;  
        insert lineItemP;
        
        Apttus_Config2__LineItem__c lineItemM =  new Apttus_Config2__LineItem__c();
        lineItemM.APTS_Group_Primary_Material__c= '40666420';
        lineItemM.Apttus_Config2__LineStatus__c = 'New';  
        //lineItemP.APTS_Group__c = 'Bundle A';
        lineItemM.APTS_Contract_Number__c = 123456;
        lineItemM.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemM.Apttus_Config2__ItemSequence__c = 1;
        lineItemM.Apttus_Config2__LineNumber__c = 1;
        lineItemM.Apttus_Config2__OptionId__c= oProductP.Id;  
        insert lineItemM;
        
        Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
        lineItemS.APTS_Group_Primary_Material__c= '40666420';
        lineItemS.Apttus_Config2__LineStatus__c = 'New';  
        //lineItemP.APTS_Group__c = 'Bundle A';
        lineItemS.APTS_Contract_Number__c = 123456;
        lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemS.Apttus_Config2__ItemSequence__c = 1;
        lineItemS.Apttus_Config2__LineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductId__c= oProductS.Id;
        insert lineItemS;
        
        Apttus_Config2__LineItem__c lineItemStd =  new Apttus_Config2__LineItem__c();
        lineItemStd.APTS_Group_Primary_Material__c= '40666420';
        lineItemStd.Apttus_Config2__LineStatus__c = 'New';  
        //lineItemP.APTS_Group__c = 'Bundle A';
        lineItemStd.APTS_Contract_Number__c = 123456;
        lineItemStd.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemStd.Apttus_Config2__ItemSequence__c = 1;
        lineItemStd.Apttus_Config2__LineNumber__c = 1;
        lineItemStd.Apttus_Config2__ProductId__c= oProductStd.Id;
        insert lineItemStd;
        
        Apttus_Config2__OrderLineItem__c ordlineS =  new Apttus_Config2__OrderLineItem__c();  
        ordlineS.Apttus_Config2__OrderId__c=order.id;  
        ordlineS.Apttus_Config2__ProductId__c=oProductS.id;  
        ordlineS.Apttus_Config2__LineStatus__c = 'New';
        insert ordlineS;
        
        Apttus_Config2__OrderLineItem__c ordlineStd =  new Apttus_Config2__OrderLineItem__c();  
        ordlineStd.Apttus_Config2__OrderId__c=order.id;  
        ordlineStd.Apttus_Config2__ProductId__c=oProductStd.id;  
        ordlineStd.Apttus_Config2__LineStatus__c = 'New';
        insert ordlineStd;
        
        APTS_Dynamic_Bundle__c dynamicbundle7D = new APTS_Dynamic_Bundle__c();
        //dynamicbundlewm.APTS_Bundle_Primary_Material__c='1111';
        //dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
        //dynamicbundlewm.APTS_Group__c='Bundle A';
        dynamicbundle7D.APTS_Quote_Proposal__c=oProposal.id;
        //dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
        //dynamicbundlewm.APTS_YoY_2_Plus__c='1';
        //dynamicbundlewm.APTS_Keep_Terms__c=false;
        //dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
        //dynamicbundlewm.APTS_Deal_Number__c = 623589;
        //dynamicbundlewm.APTS_Bridge_Discount__c = '10';
        //dynamicbundlewm.APTS_Bridge_Length__c = 2;
        //dynamicbundlewm.APTS_Bundle_Adjustment_Type__c = '% Discount';
        dynamicbundle7D.APTS_Bridge__c = '7 Days';  
        dynamicbundle7D.APTS_isBLINotCreated__c= true;
        insert dynamicbundle7D;
        
        APTS_Dynamic_Bundle__c dynamicbundle14D = new APTS_Dynamic_Bundle__c();  
        dynamicbundle14D.APTS_Quote_Proposal__c=oProposal.id;  
        dynamicbundle14D.APTS_Bridge__c = '14 Days';
        dynamicbundle14D.APTS_isBLINotCreated__c= true;  
        insert dynamicbundle14D;
        
        APTS_Dynamic_Bundle__c dynamicbundle28D = new APTS_Dynamic_Bundle__c();  
        dynamicbundle28D.APTS_Quote_Proposal__c=oProposal.id;  
        dynamicbundle28D.APTS_Bridge__c = '28 Days';  
        dynamicbundle28D.APTS_isBLINotCreated__c= true;
        insert dynamicbundle28D;
        
        Test.startTest();
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);  
        System.assertEquals(1,ordLists.size());
        Test.stopTest();   
    }  
    
    static testMethod void orderQueuetoESIWCMPNegativeScenario(){
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='testWCMPNegative';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='WCMPNegativeTest';
        con.FirstName='Bundle';
        insert con;
        
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test Negative Scenario',
            APTS_Proposal_Business_Unit__c='SCS',
            APTS_Approval_Segment__c='Corporate Emerging',
            APTS_Order_Confirmation_Contact__c=con.id,
            APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
            Apttus_Proposal__Account__c = acc.Id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
            APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
        //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)');
        insert oProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
        insert prodConfig;
        List<Apttus_Config2__Order__c> ordLists =new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        //order.Apttus_Config2__Status__c='Ready for Activation';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order.Apttus_Config2__Status__c='Pending';
        insert order;
        ordLists.add(order);

        
        Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle B';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.APTS_Deal_Type__c = 'WCMP';
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';
        insert lineItem; 
        
        APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
        dynamicbundlewm.APTS_Group__c='Bundle B';
        dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm.APTS_Keep_Terms__c=false;
        dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
        // dynamicbundlewm.APTS_Deal_Number__c = 623589;
        dynamicbundlewm.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm.APTS_Bridge_Length__c = 2;
        dynamicbundlewm.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewm;   
        
        //5990
        APTS_Dynamic_Bundle__c dynamicbundlekp = new APTS_Dynamic_Bundle__c();
        //dynamicbundlekp.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlekp.APTS_Program_ID__c= 'WCMP';
        dynamicbundlekp.APTS_Group__c='Bundle C';  
        dynamicbundlekp.APTS_Quote_Proposal__c=oProposal.id;  
        dynamicbundlekp.APTS_Keep_Terms__c=false;
        dynamicbundlekp.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlekp.APTS_Deal_Number__c = 623589;  
        dynamicbundlekp.APTS_isBLINotCreated__c= true;
        insert dynamicbundlekp;   
        
        Test.startTest();
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);  
        System.assertEquals(1,ordLists.size());
        Test.stopTest();   
    } 
    
    static testMethod void prgmItemifo(){
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        //Test.startTest();
        Account acc = new Account();
        acc.Name='Test Program Id';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='SEAT';
        con.FirstName='CPRO';
        insert con;
        
        Product2 oProductB = new Product2(Name='Standard Bundle ', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c = 'ZPMT' ,APTS_Corporate_Select__c='Primary');
        insert oProductB;
        Product2 oProductC = new Product2(Name='Corp Select ', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'E2',APTS_Media_High_Level_Code__c='05', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c = 'ZPMT' ,APTS_Corporate_Select__c='Primary',APTS_Standard_Bundle__c=True);
        insert oProductC;
        
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test2',
            APTS_Proposal_Business_Unit__c='SCS',
            APTS_Approval_Segment__c='Corporate Emerging',
            APTS_Order_Confirmation_Contact__c=con.id,
            APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
            Apttus_Proposal__Account__c = acc.Id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Payment_Option__c='Credit Card' ,
            APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
        //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)');
        insert oProposal;
        
        Test.startTest();
        List<Apttus_Config2__Order__c> ordLists =new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order.Apttus_Config2__Status__c='Pending';
        insert order;
        ordLists.add(order);

        
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order.id;
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A'; 
        ordline.APTS_Program_ID__c = 'CPRO';
        ordline.APTS_Bridge__c='11 Months';
        ordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline.Apttus_Config2__NetPrice__c = 1728;
        insert ordline;
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='1 Year';
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductC.id;
        ordline2.APTS_Group__c=''; 
        ordline2.APTS_Program_ID__c = 'CPRO';
        ordline2.APTS_Bridge__c='11 Months';
        ordline2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline2.Apttus_Config2__NetPrice__c = 1728;
        insert ordline2;
        
                //Added newly
        Apttus_Config2__OrderLineItem__c ordlineMTP =  new Apttus_Config2__OrderLineItem__c();
        ordlineMTP.APTS_Contract_Term__c='3 Year';
        ordlineMTP.Apttus_Config2__OrderId__c=order.id;
        ordlineMTP.Apttus_Config2__Quantity__c=1.000;
        ordlineMTP.Apttus_Config2__ProductId__c=oProductC.id;
        ordlineMTP.APTS_Group__c=''; 
        ordlineMTP.APTS_Program_ID__c = 'CPRO';
        ordlineMTP.APTS_Bridge__c='11 Months';
        ordlineMTP.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineMTP.Apttus_Config2__NetPrice__c = 1728;
        ordlineMTP.Apttus_Config2__LineStatus__c= 'Renewed';
        ordlineMTP.APTS_Is_Multi_Tiered_Pricing__c= True;
        insert ordlineMTP;
        
        Apttus_Config2__OrderLineItem__c ordlineMTP0 =  new Apttus_Config2__OrderLineItem__c();
        ordlineMTP0.APTS_Contract_Term__c='3 Year';
        ordlineMTP0.Apttus_Config2__OrderId__c=order.id;
        ordlineMTP0.Apttus_Config2__Quantity__c=1.000;
        ordlineMTP0.Apttus_Config2__ProductId__c=oProductC.id;
        ordlineMTP0.APTS_Group__c=''; 
        ordlineMTP0.APTS_Program_ID__c = 'CPRO';
        ordlineMTP0.APTS_Bridge__c='11 Months';
        ordlineMTP0.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineMTP0.Apttus_Config2__NetPrice__c = 1728;
        ordlineMTP0.Apttus_Config2__LineStatus__c= 'Renewed';
        ordlineMTP0.APTS_Is_Multi_Tiered_Pricing__c= False;
        insert ordlineMTP0;
        
        //Test.startTest();
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);  
        System.assertEquals(1,ordLists.size());
        Test.stopTest();
        
    } 
    
    static testmethod void ordersubmissionESI4()
    {
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; 
        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test Patron', ProductCode = '40284616', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '41055954', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');  
        Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '40987270', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9',APTS_Item_Category_Group__c='ZPAL');
        productlist.add(oProductC);
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(oProductS);
        insert productlist;
        
        
        // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        oProposal.Apttus_Proposal__Account__c=acc.id;
        //oProposal.APTS_SA_ID__c = 'AL MSA-WEST(ALMS)';
        insert oProposal;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
                Test.startTest();
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        
        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order.id;
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A'; 
        ordline.APTS_Program_ID__c = 'WCMP';
        ordline.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline);
        
        
        Apttus_Config2__OrderLineItem__c ordline22 =  new Apttus_Config2__OrderLineItem__c();
        ordline22.Apttus_Config2__OrderId__c=order.id;
        ordline22.Apttus_Config2__Quantity__c=1.000;
        //ordline22.Apttus_Config2__ProductId__c=oProductB.id; 
        ordline22.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordline22.APTS_Bridge__c='2 Months';
        ordlineList.add(ordline22);   
        
        Apttus_Config2__OrderLineItem__c ordline23 =  new Apttus_Config2__OrderLineItem__c();
        ordline23.Apttus_Config2__OrderId__c=order.id;
        ordline23.Apttus_Config2__Quantity__c=1.000; 
        ordline23.Apttus_Config2__LineStatus__c='Cancelled';
        ordline23.APTS_Bridge__c='3 Months';
        ordlineList.add(ordline23);
        
        Apttus_Config2__OrderLineItem__c ordline111 =  new Apttus_Config2__OrderLineItem__c();
        ordline111.Apttus_Config2__Uom__c='Each';
        ordline111.APTS_New_Bridge_Discount__c=1;
        ordline111.APTS_Contract_Term__c='2 Years';  
        ordline111.Apttus_Config2__Quantity__c=1.000;
        ordline111.Apttus_Config2__ProductId__c=oProductS.id;
        ordline111.Apttus_Config2__OrderId__c=order.id;
        ordline111.Apttus_Config2__LineStatus__c='New';
        ordline111.Apttus_Config2__ListPrice__c = 1000;
        ordline111.APTS_Bridge__c='4 Months';
        ordlineList.add(ordline111);  
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
        ordline5.APTS_Contract_Term__c='10 Years';
        ordline5.Apttus_Config2__Quantity__c=1.000;
        ordline5.Apttus_Config2__OrderId__c=order.id;
        //ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline5.Apttus_Config2__PriceType__c = 'Recurring';
        ordline5.Apttus_Config2__BillingFrequency__c ='Yearly';
        ordline5.Apttus_Config2__NetPrice__c = 1728;
        ordline5.APTS_Bridge__c='5 Months';
        ordlineList.add(ordline5);   
        
        Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c();
        ordline13.Apttus_Config2__OrderId__c=order.id;
        ordline13.Apttus_Config2__Quantity__c=1.000; 
        ordline13.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordline13.APTS_Bridge__c='6 Months';
        ordlineList.add(ordline13);  
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
        ordline4.APTS_Contract_Term__c='5 Years';
        ordline4.Apttus_Config2__Quantity__c=1.000;
        ordline4.Apttus_Config2__OrderId__c=order.id;
        ordline4.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline4.Apttus_Config2__LineType__c = 'Option';
        ordline4.Apttus_Config2__PriceType__c = 'One Time';
        ordline4.Apttus_Config2__NetPrice__c = 1728;
        ordline4.APTS_Bridge__c='7 Months';
        ordlineList.add(ordline4);
        
        //adding orderline
        Apttus_Config2__OrderLineItem__c ordline24 =  new Apttus_Config2__OrderLineItem__c();
        ordline24.APTS_Contract_Term__c='3 Years';
        ordline24.Apttus_Config2__Quantity__c=1.000;
        ordline24.Apttus_Config2__ProductId__c=oProductB.id;
        ordline24.Apttus_Config2__OrderId__c=order.id;
        ordline24.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline24.Apttus_Config2__LineType__c = 'Product/Service';
        ordline24.Apttus_Config2__PriceType__c = 'One Time';
        ordline24.APTS_Bridge__c='8 Months';
        ordlineList.add(ordline24);
        
        Apttus_Config2__OrderLineItem__c ordline25 =  new Apttus_Config2__OrderLineItem__c();
        ordline25.APTS_Contract_Term__c='4 Years';
        ordline25.Apttus_Config2__Quantity__c=1.000;
        ordline25.Apttus_Config2__ProductId__c=oProductB.id;
        ordline25.Apttus_Config2__OrderId__c=order.id;
        ordline25.APTS_Bridge__c='8 Months';
        ordlineList.add(ordline25);
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline14 =  new Apttus_Config2__OrderLineItem__c();
        ordline14.APTS_Contract_Term__c='5 Years';
        ordline14.Apttus_Config2__Quantity__c=1.000;
        ordline14.Apttus_Config2__OrderId__c=order.id;
        //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline14.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline14.Apttus_Config2__LineType__c = 'Product/Service';
        ordline14.Apttus_Config2__PriceType__c = 'One Time';
        ordline14.APTS_Bridge__c='9 Months';
        ordlineList.add(ordline14);
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='3 Years';
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id;
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.APTS_Bridge__c='10 Months';
        ordlineList.add(ordline2);
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='4 Years';
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__OrderId__c=order.id;
        ordline3.APTS_Bridge__c='11 Months';
        ordlineList.add(ordline3);
        
        Apttus_Config2__OrderLineItem__c ordline26 =  new Apttus_Config2__OrderLineItem__c();
        ordline26.Apttus_Config2__OrderId__c=order.id;
        ordline26.Apttus_Config2__Quantity__c=1.000; 
        ordline26.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordline26.APTS_Bridge__c='7 Days';
        ordlineList.add(ordline26);
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline53 =  new Apttus_Config2__OrderLineItem__c();
        ordline53.APTS_Contract_Term__c='10 Years';
        ordline53.Apttus_Config2__Quantity__c=1.000;
        ordline53.Apttus_Config2__OrderId__c=order.id;
        //ordline53.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline53.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline53.Apttus_Config2__PriceType__c = 'Recurring';
        ordline53.APTS_Bridge__c='14 Days';
        ordlineList.add(ordline53);  
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline43 =  new Apttus_Config2__OrderLineItem__c();
        ordline43.APTS_Contract_Term__c='5 Years';
        ordline43.Apttus_Config2__Quantity__c=1.000;
        ordline43.Apttus_Config2__OrderId__c=order.id;
        ordline43.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline43.Apttus_Config2__LineType__c = 'Option';
        ordline43.Apttus_Config2__PriceType__c = 'One Time';
        ordlineList.add(ordline43);
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline143 =  new Apttus_Config2__OrderLineItem__c();
        ordline143.APTS_Contract_Term__c='5 Years';
        ordline143.Apttus_Config2__Quantity__c=1.000;
        ordline143.Apttus_Config2__OrderId__c=order.id;
        //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
        ordline143.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline143.Apttus_Config2__LineType__c = 'Product/Service';
        ordline143.Apttus_Config2__PriceType__c = 'One Time';
        insert ordline143; 
        
        //added product
        Apttus_Config2__OrderLineItem__c ordline15 =  new Apttus_Config2__OrderLineItem__c();
        ordline15.APTS_Contract_Term__c='5 Years';
        ordline15.Apttus_Config2__Quantity__c=1.000;
        ordline15.Apttus_Config2__OrderId__c=order.id;
        ordline15.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordline15.Apttus_Config2__PriceType__c = 'One Time';
        ordline15.Apttus_Config2__ProductId__c = oProductC.Id;
        ordline15.Apttus_Config2__NetPrice__c = 1728;
        ordline15.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordline15);  
        
        
        //added fill up
        Apttus_Config2__OrderLineItem__c ordlineF =  new Apttus_Config2__OrderLineItem__c();
        ordlineF.APTS_Contract_Term__c='5 Years';
        ordlineF.Apttus_Config2__Quantity__c=1.000;
        ordlineF.Apttus_Config2__OrderId__c=order.id;
        ordlineF.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineF.Apttus_Config2__PriceType__c = 'One Time';
        ordlineF.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineF.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineF.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordlineF);  
        
        Apttus_Config2__OrderLineItem__c ordlineF1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineF1.APTS_Contract_Term__c='5 Years';
        ordlineF1.Apttus_Config2__Quantity__c=1.000;
        ordlineF1.Apttus_Config2__OrderId__c=order.id;
        ordlineF1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineF1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineF1.Apttus_Config2__LineType__c = 'Option';
        ordlineF1.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineF.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordlineF1); 
        
        Apttus_Config2__OrderLineItem__c ordlineShip =  new Apttus_Config2__OrderLineItem__c();
        ordlineShip.APTS_Contract_Term__c='5 Years';
        ordlineShip.Apttus_Config2__Quantity__c=1.000;
        ordlineShip.Apttus_Config2__OrderId__c=order.id;
        ordlineShip.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineShip.Apttus_Config2__PriceType__c = 'One Time';
        ordlineShip.Apttus_Config2__LineType__c = 'Option';
        ordlineShip.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineShip.Apttus_Config2__NetPrice__c = 1728;
        ordlineShip.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordlineShip);
        
        Apttus_Config2__OrderLineItem__c ordlineSub =  new Apttus_Config2__OrderLineItem__c();
        ordlineSub.APTS_Contract_Term__c='5 Years';
        ordlineSub.Apttus_Config2__Quantity__c=1.000;
        ordlineSub.Apttus_Config2__OrderId__c=order.id;
        ordlineSub.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineSub.Apttus_Config2__PriceType__c = 'One Time';
        ordlineSub.Apttus_Config2__LineType__c = 'Option';
        ordlineSub.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineSub.Apttus_Config2__NetPrice__c = 1728;
        ordlineSub.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordlineSub);
        
        Apttus_Config2__OrderLineItem__c ordlineSubApp =  new Apttus_Config2__OrderLineItem__c();
        ordlineSubApp.APTS_Contract_Term__c='5 Years';
        ordlineSubApp.Apttus_Config2__Quantity__c=1.000;
        ordlineSubApp.Apttus_Config2__OrderId__c=order.id;
        ordlineSubApp.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineSubApp.Apttus_Config2__PriceType__c = 'One Time';
        ordlineSubApp.Apttus_Config2__LineType__c = 'Option';
        ordlineSubApp.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineSubApp.Apttus_Config2__NetPrice__c = 1728;
        ordlineSubApp.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineSubApp.Apttus_Config2__LineStatus__c = 'Existing';
        ordlineList.add(ordlineSubApp);
        
        Apttus_Config2__OrderLineItem__c ordlineSoa =  new Apttus_Config2__OrderLineItem__c();
        ordlineSoa.APTS_Contract_Term__c='5 Years';
        ordlineSoa.Apttus_Config2__Quantity__c=1.000;
        ordlineSoa.Apttus_Config2__OrderId__c=order.id;
        ordlineSoa.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ordlineSoa.Apttus_Config2__PriceType__c = 'One Time';
        ordlineSoa.Apttus_Config2__LineType__c = 'Option';
        ordlineSoa.Apttus_Config2__ProductId__c = oProductC.Id;
        ordlineSoa.Apttus_Config2__NetPrice__c = 1728;
        ordlineSoa.Apttus_Config2__ListPrice__c = 1000;
        ordlineSoa.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineList.add(ordlineSoa);
        
        insert ordlineList;
        
        List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
        
        Apttus_Config2__OrderProductAttributeValue__c attributeSub = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeSub.SCS_Print_Purchase_Options__c='Sub Only';
        attributeSub.eBook_Purchase_Options__c = 'App';
        attributeSub.Apttus_Config2__LineItemId__c=ordlineSub.id;
        orderProd.add(attributeSub);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeShip = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeShip.SCS_Print_Purchase_Options__c='Ship & Enter Sub';
        attributeShip.eBook_Purchase_Options__c = 'Entitle and Charge';
        attributeShip.Apttus_Config2__LineItemId__c=ordlineShip.id;
        orderProd.add(attributeShip);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeSubApp = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeSubApp.SCS_Print_Purchase_Options__c='Ship & Enter Sub App';
        attributeSubApp.Apttus_Config2__LineItemId__c=ordlineSubApp.id;
        orderProd.add(attributeSubApp);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute.Apttus_Config2__LineItemId__c=ordline5.id;
        orderProd.add(attribute);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeF = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeF.SCS_Print_Purchase_Options__c='Fill-Up';
        attributeF.Apttus_Config2__LineItemId__c=ordlineF.id;
        orderProd.add(attributeF);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute1.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute1.Apttus_Config2__LineItemId__c=ordline4.id;
        orderProd.add(attribute1);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute2.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute2.Apttus_Config2__LineItemId__c=ordline14.id;
        orderProd.add(attribute2);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute24 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute24.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute24.Apttus_Config2__LineItemId__c=ordline14.id;
        orderProd.add(attribute24);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute15 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute15.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
        attribute15.Apttus_Config2__LineItemId__c=ordline15.id;
        orderProd.add(attribute15);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute33 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute33.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute33.Apttus_Config2__LineItemId__c=ordline5.id;
        orderProd.add(attribute33);
        
        
        Apttus_Config2__OrderProductAttributeValue__c attribute13 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute13.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute13.Apttus_Config2__LineItemId__c=ordline43.id;
        orderProd.add(attribute13);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute23 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute23.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute23.Apttus_Config2__LineItemId__c=ordline14.id;
        orderProd.add(attribute23);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute3.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
        attribute3.Apttus_Config2__LineItemId__c=ordline15.id;
        orderProd.add(attribute3);
        
        Apttus_Config2__OrderProductAttributeValue__c attributeSoa = new Apttus_Config2__OrderProductAttributeValue__c();
        attributeSoa.SCS_Print_Purchase_Options__c='Sub Only App';
        attributeSoa.Apttus_Config2__LineItemId__c=ordlineSoa.id;
        orderProd.add(attributeSoa);
        
        insert orderProd;
        
        List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
        
        ordlineSubApp.Apttus_Config2__AttributeValueId__c=attributeSubApp.id;
        updateOrderList.add(ordlineSubApp);
        
        ordlineSoa.Apttus_Config2__AttributeValueId__c=attributeSoa.id;
        updateOrderList.add(ordlineSoa);
        
        ordlineSub.Apttus_Config2__AttributeValueId__c=attributeSub.id;
        updateOrderList.add(ordlineSub);
        
        ordlineShip.Apttus_Config2__AttributeValueId__c=attributeShip.id;
        updateOrderList.add(ordlineShip);
        
        ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
        updateOrderList.add(ordline5);
        
        ordlineF.Apttus_Config2__AttributeValueId__c=attributeF.id;
        updateOrderList.add(ordlineF);
        
        ordlineF1.Apttus_Config2__AttributeValueId__c=attributeF.id;
        updateOrderList.add(ordlineF1);
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute1.id;
        updateOrderList.add(ordline4);
        
        ordline14.Apttus_Config2__AttributeValueId__c=attribute2.id;
        updateOrderList.add(ordline14);
        
        ordline53.Apttus_Config2__AttributeValueId__c=attribute33.id;
        updateOrderList.add(ordline53);
        
        ordline43.Apttus_Config2__AttributeValueId__c=attribute13.id;
        updateOrderList.add(ordline43);
        
        ordline24.Apttus_Config2__AttributeValueId__c=attribute24.id;
        updateOrderList.add(ordline24);
        
        ordline15.Apttus_Config2__AttributeValueId__c=attribute15.id;
        updateOrderList.add(ordline15);
        
        ordline143.Apttus_Config2__AttributeValueId__c=attribute23.id;
        updateOrderList.add(ordline143);
               
        update updateOrderList;
        
        List<APTS_Dynamic_Bundle__c> dynamicList=new List<APTS_Dynamic_Bundle__c>();
        
        APTS_Dynamic_Bundle__c dynamicbundle = new APTS_Dynamic_Bundle__c();
        dynamicbundle.APTS_Bundle_Primary_Material__c='1111';
        //dynamicbundle.APTS_Quantity__c=1.00;
        dynamicbundle.APTS_Group__c='Bundle A';
        dynamicbundle.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle.APTS_Contract_Terms__c='3 Years';
        dynamicbundle.APTS_YoY_2_Plus__c='1';
        dynamicbundle.APTS_isBLINotCreated__c= true;
        dynamicList.add(dynamicbundle);
        
        APTS_Dynamic_Bundle__c dynamicbundle2 = new APTS_Dynamic_Bundle__c();
        dynamicbundle2.APTS_Bundle_Primary_Material__c='1111';
        //dynamicbundle.APTS_Quantity__c=1.00;
        dynamicbundle2.APTS_Group__c='Bundle C';
        dynamicbundle2.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle2.APTS_Contract_Terms__c='5 Years';
        dynamicbundle2.APTS_YoY_2_Plus__c='1';
        dynamicbundle2.APTS_isBLINotCreated__c= true;
        dynamicList.add(dynamicbundle2);
        
        APTS_Dynamic_Bundle__c dynamicbundle3 = new APTS_Dynamic_Bundle__c();
        dynamicbundle3.APTS_Bundle_Primary_Material__c='1111';
        //dynamicbundle.APTS_Quantity__c=1.00;
        dynamicbundle3.APTS_Group__c='Bundle D';
        dynamicbundle3.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle3.APTS_Contract_Terms__c='4 Years';
        dynamicbundle3.APTS_YoY_2_Plus__c='1';
        dynamicbundle3.APTS_isBLINotCreated__c= true;
        dynamicList.add(dynamicbundle3);
        
        insert dynamicList;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc5);
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc6);
        
        insert onlineContactList;
        
        List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
        masterContactList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
        masterContactList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
        masterContactList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc5);
        Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc6);
        Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc7);
        insert masterContactList;
        
        //Test.startTest();        
        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();
        
    }
    
    static testmethod void ordersubmissionESIHighQ()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.LCRM_eOutput_Eligibility__c = 'TP';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;         
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName='Prabhu';
        con.FirstName='Issac';
        insert con;
        
        List<Product2> prodList=new List<Product2>();
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'OA',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys', APTS_Cat_L2__c=Label.APTS_HighQ_Product_Family, APTS_Product_Pricing_Model__c='HighQ SubPrice Quantity');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductB1 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06',APTS_Media_Lower_Level_Code__c = 'I9', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP1 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='07',APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductB2 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP2 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
        prodList.add(oProductB);
        prodList.add(oProductP);
        prodList.add(oProductB1);
        prodList.add(oProductP1);
        prodList.add(oProductB2);
        prodList.add(oProductP2);
        insert prodList;
        
        Test.startTest();   
        // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Proposal_Business_Unit__c='FindLaw',APTS_Approval_Segment__c='Corporate',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        oProposal.APTS_SA_ID__c = 'MN MSA 139431 (MNMS)';
        oProposal.APTS_Revenue_Channel_Override__c = '05';
        oProposal.APTS_Ebilling_contact__c = con.id;
        insert oProposal;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,APTS_Cat_L2__c = 'L2_L070_FP');
        listLineItems.add(li2);
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,APTS_Cat_L2__c = 'L2_L070_FP');
        listLineItems.add(li3);
        Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li4);
        Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li5);
        Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li6);
        
        insert listLineItems;
        List<Apttus_Config2__Order__c > orderLists=new List<Apttus_Config2__Order__c >();
        
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Ready for Activation';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_ship_to__c=accountSSD.id;
        order.APTS_Payer__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        insert order;
        orderLists.add(order);
        
        Apttus_Config2__AssetLineItem__c asli =new Apttus_Config2__AssetLineItem__c();
        asli.APTS_Info_RenewalDate__c=system.today();
        asli.APTS_Info_PlanType__c = 'S00';
        insert asli;
        
        List<Apttus_Config2__OrderLineItem__c> orderlineitemList = new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order.id;
        ordline.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A';  
        ordline.APTS_Bridge__c='1 Month';
        ordline.APTS_SAP_MLA_Agreement_Number__c = '12345';
        ordline.APTS_Service_Number__c = '40757482';
        ordline.APTS_Program_ID__c = 'CPRO';
        ordline.Apttus_Config2__AssetLineItemId__c=asli.id;
        ordline.Apttus_Config2__LineType__c = 'Product/Service';
        orderlineitemList.add(ordline);
        
        Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
        ordline1.APTS_Contract_Term__c='1 Year';
        ordline1.Apttus_Config2__OrderId__c=order.id;
        ordline1.Apttus_Config2__LineStatus__c='Amended';
        ordline1.APTS_Service_Number__c = '41841757'; 
        ordline1.Apttus_Config2__Quantity__c=1.000;
        ordline1.Apttus_Config2__ProductId__c=oProductB.id;
        ordline1.APTS_Group__c='Bundle A';  
        ordline1.APTS_Bridge__c='1 Month';
        ordline1.Apttus_Config2__AdjustmentType__c='% Discount';
        ordline1.Apttus_Config2__PriceType__c = 'One Time';
        orderlineitemList.add(ordline1);
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='1 Year';
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.Apttus_Config2__LineStatus__c='Renewed'; 
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id; 
        ordline2.APTS_Bridge__c='1 Month';
        ordline2.Apttus_Config2__PriceType__c = 'One Time';
        orderlineitemList.add(ordline2); 
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='1 Year';
        ordline3.Apttus_Config2__OrderId__c=order.id;
        ordline3.Apttus_Config2__LineStatus__c='Renewed'; 
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__ProductId__c=oProductP.id; 
        ordline3.APTS_Bridge__c='1 Month';
        ordline3.Apttus_Config2__PriceType__c = 'One Time';
        orderlineitemList.add(ordline3);

        Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
        ordline4.APTS_Contract_Term__c='1 Year';
        ordline4.Apttus_Config2__OrderId__c=order.id;
        ordline4.Apttus_Config2__LineStatus__c='New'; 
        ordline4.Apttus_Config2__Quantity__c=1.000;
        ordline4.Apttus_Config2__ProductId__c=oProductP.id; 
        ordline4.APTS_Bridge__c='7 Days';
        ordline4.Apttus_Config2__PriceType__c = 'Recurring';
        ordline4.Apttus_Config2__BillingFrequency__c = 'Yearly';
        orderlineitemList.add(ordline4);
        
        Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
        ordline5.APTS_Contract_Term__c='1 Year';
        ordline5.Apttus_Config2__OrderId__c=order.id;
        ordline5.Apttus_Config2__LineStatus__c='New'; 
        ordline5.Apttus_Config2__Quantity__c=1.000;
        ordline5.Apttus_Config2__ProductId__c=oProductP.id; 
        ordline5.APTS_Bridge__c='14 Days';
        ordline5.Apttus_Config2__PriceType__c = 'Recurring';
        ordline5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        orderlineitemList.add(ordline5);
        
        Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c();
        ordline6.APTS_Contract_Term__c='1 Year';
        ordline6.Apttus_Config2__OrderId__c=order.id;
        ordline6.Apttus_Config2__LineStatus__c='New'; 
        ordline6.Apttus_Config2__Quantity__c=1.000;
        ordline6.Apttus_Config2__ProductId__c=oProductP.id; 
        ordline6.APTS_Bridge__c='28 Days';
        ordline6.Apttus_Config2__PriceType__c = 'Recurring';
        orderlineitemList.add(ordline6);
        
        insert orderlineitemList; 
        
        Apttus_Approval__Approval_Request__c ar = new Apttus_Approval__Approval_Request__c(                   
            Apttus_Approval__Approval_Status__c = 'Approved',
            Apttus_QPApprov__ProposalId__c =  oProposal.id               
        );
        insert ar;  
        
        order.Apttus_Config2__Status__c='Pending';
        update order;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc1.NAIC_Name__c = 'Test123';
        oc1.NAIC_Number__c = '12345';
        onlineContactList.add(oc1);
        
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc2.NAIC_Name__c = 'Test123';
        oc2.NAIC_Number__c = '12345';
        onlineContactList.add(oc2);
        
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc3.NAIC_Name__c = 'Test123';
        oc3.NAIC_Number__c = '12345';
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc4.NAIC_Name__c = 'Test123';
        oc4.NAIC_Number__c = '12345';
        onlineContactList.add(oc4);
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc5.NAIC_Name__c = 'Test123';
        oc5.NAIC_Number__c = '12345';
        onlineContactList.add(oc5);
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc6.NAIC_Name__c = 'Test123';
        oc6.NAIC_Number__c = '12345';
        onlineContactList.add(oc6);
        
        Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc7.NAIC_Name__c = 'Test123';
        oc7.NAIC_Number__c = '12345';       
        onlineContactList.add(oc7);
        
        Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc8.NAIC_Name__c = 'Test123';
        oc8.NAIC_Number__c = '12345';
        onlineContactList.add(oc8);
        
        Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc9.NAIC_Name__c = 'Test123';
        oc9.NAIC_Number__c = '12345';
        onlineContactList.add(oc9);
        
        Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc10.NAIC_Name__c = 'Test123';
        oc10.NAIC_Number__c = '12345';
        onlineContactList.add(oc10);
        
        insert onlineContactList;        
        Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order.id];        
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id); //Added as part of CRM-9456
        System.assertEquals(1,orderLists.size());
        Test.stopTest();
        
    }
    
    static testMethod void orderQueueToESIHighQProflex(){
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='Test Program Id';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='SEAT';
        con.FirstName='CPRO';
        insert con;
        
        Product2 oProductB = new Product2(Name='Standard Bundle ', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'PQ',APTS_Media_High_Level_Code__c='13', APTS_Cat_L2__c=Label.APTS_HighQ_Product_Family ,APTS_Corporate_Select__c='Primary');
        insert oProductB;
        Product2 oProductC = new Product2(Name='Corp Select ', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'PQ',APTS_Media_High_Level_Code__c='13',  APTS_Cat_L2__c=Label.APTS_HighQ_Product_Family,APTS_Corporate_Select__c='Primary');
        insert oProductC;
        
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c ='Test Proposal KS_11650',
            APTS_Proposal_Business_Unit__c='SCS',
            APTS_Approval_Segment__c='Corporate Emerging',
            APTS_Order_Confirmation_Contact__c=con.id,
            APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
            Apttus_Proposal__Account__c = acc.Id,
            APTS_SSD_Sold_To__c = accountSSD.Id,
            APTS_Payment_Option__c='Credit Card' ,
            APTS_Card_Expiration_Date__c=date.ValueOf('2021-03-08'));        
        insert oProposal;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, Apttus_Proposal__Proposal__c = oProposal.Id);
        li1.APTS_Product_Family__c = 'HighQ';
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, Apttus_Proposal__Proposal__c = oProposal.Id);
        li2.APTS_Product_Family__c = 'HighQ';
        listLineItems.add(li2);
        
        insert listLineItems;
        system.debug('KS--> Proposal.APTS_Is_HighQ_Quote__c '+oProposal.APTS_Is_HighQ_Quote__c);
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
        insert prodConfig;
        
        List<Apttus_Config2__Order__c > orderLists=new List<Apttus_Config2__Order__c >();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';        
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order.Apttus_Config2__Status__c='Pending';
        orderLists.add(order);
        insert order;
        
        APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm.APTS_Group__c='Bundle B';
        dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm.APTS_Keep_Terms__c=false;
        dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';        
        dynamicbundlewm.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm.APTS_Bridge_Length__c = 2;
        dynamicbundlewm.APTS_Billing_Frequency__c='Yearly';
        dynamicbundlewm.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewm;   
        
        APTS_Dynamic_Bundle__c dynamicbundle2 = new APTS_Dynamic_Bundle__c();
        dynamicbundle2.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundle2.APTS_Group__c='Bundle B';
        dynamicbundle2.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle2.APTS_Contract_Terms__c='3 Years';
        dynamicbundle2.APTS_YoY_2_Plus__c='1';
        dynamicbundle2.APTS_Keep_Terms__c=false;
        dynamicbundle2.APTS_MLA_Agreement_Number__c='7378768';        
        dynamicbundle2.APTS_Bridge_Discount__c = '10';
        dynamicbundle2.APTS_Bridge_Length__c = 2;
        dynamicbundle2.APTS_Billing_Frequency__c='Monthly';
        dynamicbundle2.APTS_isBLINotCreated__c= true;
        insert dynamicbundle2;
        
        Test.startTest();
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);  
        System.assertEquals(1,orderLists.size());
        Test.stopTest();   
    } 
    
    static testmethod void ordersubmissionESIGLP()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
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
        
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Source_System_Account_Number__c = '34654746';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; 
        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '40666420',APTS_Media_High_Level_Code__c = '21', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Attorneys', APTS_Item_Category_Group__c='ZPR2');
        productlist.add(oProductB);
        insert productlist;        
        
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        oProposal.Apttus_Proposal__Account__c=acc.id;
        oProposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;
        oProposal.APTS_Proposal_Business_Unit__c = 'SCS';
        oProposal.APTS_SA_ID__c = 'AL MSA-WEST C6027018 (ALM1)';
        insert oProposal;
    Test.startTest();
    Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
    insert prodConfig;
    
    List<Apttus_Config2__LineItem__c> lstLI = new List<Apttus_Config2__LineItem__c>();
    Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
    lineItemS.APTS_Group_Primary_Material__c= '40666420';
    lineItemS.Apttus_Config2__LineStatus__c = 'New';  
    lineItemS.APTS_Group__c = 'Bundle A';
    lineItemS.APTS_Contract_Number__c = 123456;
    lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
    lineItemS.Apttus_Config2__ItemSequence__c = 1;
    lineItemS.Apttus_Config2__LineNumber__c = 1;
    lineItemS.Apttus_Config2__ProductId__c = oProductB.Id;   
    lineItemS.Apttus_Config2__AddedBy__c = 'User';
    lineItemS.Apttus_Config2__AdjustedPrice__c = 50;
    lineItemS.Apttus_Config2__AdjustmentAmount__c = 50;
    lineItemS.Apttus_Config2__AdjustmentType__c = '% Discount';
    lineItemS.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
    lineItemS.Apttus_Config2__AllowableAction__c = 'Unrestricted';
    lineItemS.Apttus_Config2__AllowManualAdjustment__c = TRUE;
    lineItemS.Apttus_Config2__AllowProration__c = FALSE;
    lineItemS.Apttus_Config2__AllowRemoval__c = TRUE;
    lineItemS.Apttus_Config2__AutoRenew__c = FALSE;
    lineItemS.Apttus_Config2__BaseExtendedCost__c = 0;
    lineItemS.Apttus_Config2__BaseExtendedPrice__c = 100;
    lineItemS.Apttus_Config2__BasePrice__c = 100;
    lineItemS.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
    lineItemS.Apttus_Config2__BillingFrequency__c = 'Monthly';
    lineItemS.Apttus_Config2__ChargeType__c = 'Subscription Fee';
    lineItemS.Apttus_Config2__ConfigStatus__c = 'Complete';
    lineItemS.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
    lineItemS.Apttus_Config2__Customizable__c = FALSE;
    lineItemS.Apttus_Config2__DeltaPrice__c = 50;
    lineItemS.Apttus_Config2__DeltaQuantity__c = 1;
    lineItemS.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
    lineItemS.Apttus_Config2__ExtendedCost__c = 0;
    lineItemS.Apttus_Config2__ExtendedPrice__c = 100;
    lineItemS.Apttus_Config2__Frequency__c = 'Monthly';
    lineItemS.Apttus_Config2__Guidance__c = 'Red';
    lineItemS.Apttus_Config2__HasAttributes__c = FALSE;
    lineItemS.Apttus_Config2__HasBaseProduct__c = FALSE;
    lineItemS.Apttus_Config2__HasDefaults__c = FALSE;
    lineItemS.Apttus_Config2__HasIncentives__c = FALSE;
    lineItemS.Apttus_Config2__HasOptions__c = FALSE;
    lineItemS.Apttus_Config2__HasTieredPrice__c = FALSE;
    lineItemS.Apttus_Config2__HideCopyAction__c = FALSE;
    lineItemS.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
    lineItemS.Apttus_Config2__IsAssetPricing__c = FALSE;
    lineItemS.Apttus_Config2__IsCustomPricing__c = FALSE;
    lineItemS.Apttus_Config2__IsHidden__c = FALSE;
    lineItemS.Apttus_Config2__IsOptionRollupLine__c = FALSE;
    lineItemS.Apttus_Config2__IsPrimaryLine__c = TRUE;
    lineItemS.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
    lineItemS.Apttus_Config2__IsQuantityModifiable__c = FALSE;
    lineItemS.Apttus_Config2__IsReadOnly__c = FALSE;
    lineItemS.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
    lineItemS.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
    lineItemS.Apttus_Config2__LineSequence__c = 1;
    lineItemS.APTS_Yr_1_Renewal_Adjustment__c ='1';
    lineItemS.Apttus_Config2__LineType__c = 'Product/Service';
    lineItemS.Apttus_Config2__ListPrice__c = 100;
    lineItemS.Apttus_Config2__NetAdjustmentPercent__c = -50;
    lineItemS.Apttus_Config2__NetPrice__c = 50;
    lineItemS.Apttus_Config2__NetUnitPrice__c = 50;
    lineItemS.Apttus_Config2__OptionSequence__c = 0;
    lineItemS.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
    lineItemS.Apttus_Config2__PriceMethod__c = 'Per Unit';
    lineItemS.Apttus_Config2__PriceType__c = 'Recurring';
    lineItemS.Apttus_Config2__PriceUom__c = 'Each';
    lineItemS.Apttus_Config2__PricingStatus__c = 'Complete';
    lineItemS.Apttus_Config2__PrimaryLineNumber__c = 1;
    lineItemS.Apttus_Config2__ProductVersion__c = 1;
    lineItemS.Apttus_Config2__RollupPriceToBundle__c = TRUE;
    lineItemS.Apttus_Config2__SellingFrequency__c = 'Monthly';
    lineItemS.Apttus_Config2__SellingTerm__c = 1;
    lineItemS.Apttus_Config2__SyncStatus__c = 'Pending';
    lineItemS.Apttus_Config2__Taxable__c = FALSE;
    lineItemS.Apttus_Config2__TaxInclusive__c = FALSE;
    lineItemS.Apttus_Config2__Term__c = 1;
    lineItemS.Apttus_Config2__TotalQuantity__c = 1;
    lineItemS.Apttus_Config2__Uom__c = 'Each';
    lineItemS.CurrencyIsoCode = 'USD';
    lineItemS.APTS_Product_Family__c = 'WESTLAW';
    lineItemS.APTS_Contract_Term__c = '2 Years';
    lineItemS.APTS_Years_2_Plus_Adjustment__c = '4';
    lineItemS.APTS_Product_Delivery__c = 'Online/Internet';
    lineItemS.APTS_is_Primary_in_Bundle__c= TRUE;
    lstLI.add(lineItemS);
    
    insert lstLI ;
    
    List<Apttus_Config2__ProductAttributeValue__c > LIProd=new List<Apttus_Config2__ProductAttributeValue__c >();
        
        Apttus_Config2__ProductAttributeValue__c attribute11 = new Apttus_Config2__ProductAttributeValue__c ();
        attribute11.Purchase_Option_Bundle_Print__c ='Ship & Entitle - APP';
        attribute11.Apttus_Config2__LineItemId__c=lineItemS.id;
        LIProd.add(attribute11);
        
        insert LIProd;
        
        List<Apttus_Config2__LineItem__c > udpateLILIst=new List<Apttus_Config2__LineItem__c >();
        
        lineItemS.Apttus_Config2__AttributeValueId__c=attribute11.id;
        udpateLILIst.add(lineItemS);
        
        //update udpateLILIst;
        
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        
        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
        ordline1.APTS_Contract_Term__c='1 Year';
        ordline1.Apttus_Config2__OrderId__c=order.id;
        ordline1.Apttus_Config2__Quantity__c=1.000;
        ordline1.Apttus_Config2__ProductId__c=oProductB.id;
        ordline1.APTS_Group__c='Bundle A'; 
        ordline1.APTS_Program_ID__c = 'WCMP';
        ordline1.Apttus_Config2__BillingFrequency__c  = 'Monthly';
        ordline1.APTS_Bridge__c='1 Month';
        
        ordlineList.add(ordline1);        
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='1 Year';
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id;
        ordline2.APTS_Group__c='Bundle A'; 
        ordline2.APTS_Program_ID__c = 'WCMP';
        ordline2.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline2);
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='1 Year';
        ordline3.Apttus_Config2__OrderId__c=order.id;
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__ProductId__c=oProductB.id;
        ordline3.APTS_Group__c='Bundle A'; 
        ordline3.APTS_Program_ID__c = 'WCMP';
        ordline3.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline3);
        
        Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
        ordline4.APTS_Contract_Term__c='1 Year';
        ordline4.Apttus_Config2__OrderId__c=order.id;
        ordline4.Apttus_Config2__Quantity__c=1.000;
        ordline4.Apttus_Config2__ProductId__c=oProductB.id;
        ordline4.Apttus_Config2__BillingFrequency__c  = 'Monthly';
        ordline4.APTS_Group__c='Bundle A'; 
        ordline4.APTS_Program_ID__c = 'WCMP';
        ordline4.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline4);
        
        Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
        ordline5.APTS_Contract_Term__c='1 Year';
        ordline5.Apttus_Config2__OrderId__c=order.id;
        ordline5.Apttus_Config2__Quantity__c=1.000;
        ordline5.Apttus_Config2__ProductId__c=oProductB.id;
        ordline5.APTS_Group__c='Bundle A'; 
        ordline5.APTS_Program_ID__c = 'WCMP';
        ordline5.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline5);   
        
        Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c();
        ordline6.APTS_Contract_Term__c='1 Year';
        ordline6.Apttus_Config2__OrderId__c=order.id;
        ordline6.Apttus_Config2__Quantity__c=1.000;
        ordline6.Apttus_Config2__ProductId__c=oProductB.id;
        ordline6.APTS_Group__c='Bundle A'; 
        ordline6.APTS_Program_ID__c = 'WCMP';
        ordline6.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline6);
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c();
        ordline7.APTS_Contract_Term__c='5 Years';
        ordline7.Apttus_Config2__Quantity__c=1.000;
        ordline7.Apttus_Config2__OrderId__c=order.id;
        ordline7.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline7.Apttus_Config2__LineType__c = 'Option';
        ordline7.Apttus_Config2__PriceType__c = 'One Time';
        ordline7.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordline7);
        
        Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c();
        ordline8.APTS_Contract_Term__c='5 Years';
        ordline8.Apttus_Config2__Quantity__c=1.000;
        ordline8.Apttus_Config2__OrderId__c=order.id;
        ordline8.APTS_Group__c='null'; 
        ordline8.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline8.Apttus_Config2__LineType__c = 'Product/Service';
        ordline8.Apttus_Config2__PriceType__c = 'One Time';
        ordline8.Apttus_Config2__NetPrice__c = 1728;
        ordline8.Apttus_Config2__AdjustmentType__c = '% Discount';
        ordlineList.add(ordline8);
       
        insert ordlineList;
        
        //Test.startTest();
        
        List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
        
        Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute1.Purchase_Option_Bundle_Print__c ='Ship & Entitle - APP';
        attribute1.Apttus_Config2__LineItemId__c=ordline1.id;
        orderProd.add(attribute1);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute2.Purchase_Option_Bundle_Print__c ='Ship & Entitle - APP';
        attribute2.Apttus_Config2__LineItemId__c=ordline2.id;
        orderProd.add(attribute2);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute3.Purchase_Option_Bundle_Print__c ='Ship & Entitle Sub';
        attribute3.Apttus_Config2__LineItemId__c=ordline3.id;
        orderProd.add(attribute3);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute4 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute4.Purchase_Option_Bundle_Print__c ='Sub Only APP';
        attribute4.Apttus_Config2__LineItemId__c=ordline4.id;
        orderProd.add(attribute4);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute5 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute5.Purchase_Option_Bundle_Print__c ='Sub Only APP';
        attribute5.Apttus_Config2__LineItemId__c=ordline5.id;
        orderProd.add(attribute5);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute6 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute6.Purchase_Option_Bundle_Print__c ='Sub Only';
        attribute6.Apttus_Config2__LineItemId__c=ordline6.id;
        orderProd.add(attribute6);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute7 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute7.Purchase_Option_Bundle_Print__c ='Ship & Entitle Only';
        attribute7.Apttus_Config2__LineItemId__c=ordline7.id;
        orderProd.add(attribute7);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute8 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute8.SCS_Print_Purchase_Options__c ='test';
        attribute8.Apttus_Config2__LineItemId__c=ordline8.id;
        orderProd.add(attribute8);
        
        insert orderProd;
        
        List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
        
        ordline1.Apttus_Config2__AttributeValueId__c=attribute1.id;
        updateOrderList.add(ordline1);
        
        ordline2.Apttus_Config2__AttributeValueId__c=attribute2.id;
        updateOrderList.add(ordline2);
        
        ordline3.Apttus_Config2__AttributeValueId__c=attribute3.id;
        updateOrderList.add(ordline3);
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute4.id;
        updateOrderList.add(ordline4);
        
        ordline5.Apttus_Config2__AttributeValueId__c=attribute5.id;
        updateOrderList.add(ordline5);
        
        ordline6.Apttus_Config2__AttributeValueId__c=attribute6.id;
        updateOrderList.add(ordline6);
        
        ordline7.Apttus_Config2__AttributeValueId__c=attribute7.id;
        updateOrderList.add(ordline7);
        
        ordline8.Apttus_Config2__AttributeValueId__c=attribute8.id;
        updateOrderList.add(ordline8);
                
        update updateOrderList;
       
        //Test.startTest();
                        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();        
    }
    
     static testmethod void ordersubmissionESIGLP1()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; 
        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965',APTS_Media_High_Level_Code__c = '21', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Attorneys', APTS_Item_Category_Group__c='ZPR2');
        productlist.add(oProductB);
        insert productlist;        
        
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        oProposal.Apttus_Proposal__Account__c=acc.id;        
        insert oProposal;
    
 
        
        Test.startTest();
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        
        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
        ordline1.APTS_Contract_Term__c='1 Year';
        ordline1.Apttus_Config2__OrderId__c=order.id;
        ordline1.Apttus_Config2__Quantity__c=1.000;
        ordline1.Apttus_Config2__ProductId__c=oProductB.id;
        ordline1.APTS_Group__c='Bundle A'; 
        ordline1.APTS_Program_ID__c = 'WCMP';
        ordline1.Apttus_Config2__BillingFrequency__c  = 'Monthly';
        ordline1.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline1);        
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='1 Year';
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id;
        ordline2.APTS_Group__c='Bundle A'; 
        ordline2.APTS_Program_ID__c = 'WCMP';
        ordline2.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline2);
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='1 Year';
        ordline3.Apttus_Config2__OrderId__c=order.id;
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__ProductId__c=oProductB.id;
        ordline3.APTS_Group__c='Bundle A'; 
        ordline3.APTS_Program_ID__c = 'WCMP';
        ordline3.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline3);
        
        Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
        ordline4.APTS_Contract_Term__c='1 Year';
        ordline4.Apttus_Config2__OrderId__c=order.id;
        ordline4.Apttus_Config2__Quantity__c=1.000;
        ordline4.Apttus_Config2__ProductId__c=oProductB.id;
        ordline4.Apttus_Config2__BillingFrequency__c  = 'Monthly';
        ordline4.APTS_Group__c='Bundle A'; 
        ordline4.APTS_Program_ID__c = 'WCMP';
        ordline4.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline4);
        
        Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
        ordline5.APTS_Contract_Term__c='1 Year';
        ordline5.Apttus_Config2__OrderId__c=order.id;
        ordline5.Apttus_Config2__Quantity__c=1.000;
        ordline5.Apttus_Config2__ProductId__c=oProductB.id;
        ordline5.APTS_Group__c='Bundle A'; 
        ordline5.APTS_Program_ID__c = 'WCMP';
        ordline5.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline5);   
        
        Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c();
        ordline6.APTS_Contract_Term__c='1 Year';
        ordline6.Apttus_Config2__OrderId__c=order.id;
        ordline6.Apttus_Config2__Quantity__c=1.000;
        ordline6.Apttus_Config2__ProductId__c=oProductB.id;
        ordline6.APTS_Group__c='Bundle A'; 
        ordline6.APTS_Program_ID__c = 'WCMP';
        ordline6.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline6);
        
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c();
        ordline7.APTS_Contract_Term__c='5 Years';
        ordline7.Apttus_Config2__Quantity__c=1.000;
        ordline7.Apttus_Config2__OrderId__c=order.id;
        ordline7.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline7.Apttus_Config2__LineType__c = 'Option';
        ordline7.Apttus_Config2__PriceType__c = 'One Time';
        ordline7.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordline7);
       
        insert ordlineList;
        
        //Test.startTest();
        
        List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
        
        Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute1.Purchase_Option_Bundle_Print__c ='Ship & Entitle - APP';
        attribute1.Apttus_Config2__LineItemId__c=ordline1.id;
        orderProd.add(attribute1);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute2.Purchase_Option_Bundle_Print__c ='Ship & Entitle - APP';
        attribute2.Apttus_Config2__LineItemId__c=ordline2.id;
        orderProd.add(attribute2);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute3.Purchase_Option_Bundle_Print__c ='Ship & Entitle Sub';
        attribute3.Apttus_Config2__LineItemId__c=ordline3.id;
        orderProd.add(attribute3);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute4 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute4.Purchase_Option_Bundle_Print__c ='Sub Only APP';
        attribute4.Apttus_Config2__LineItemId__c=ordline4.id;
        orderProd.add(attribute4);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute5 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute5.Purchase_Option_Bundle_Print__c ='Sub Only APP';
        attribute5.Apttus_Config2__LineItemId__c=ordline5.id;
        orderProd.add(attribute5);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute6 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute6.Purchase_Option_Bundle_Print__c ='Sub Only';
        attribute6.Apttus_Config2__LineItemId__c=ordline6.id;
        orderProd.add(attribute6);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute7 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute7.Purchase_Option_Bundle_Print__c ='Ship & Entitle Only';
        attribute7.Apttus_Config2__LineItemId__c=ordline7.id;
        orderProd.add(attribute7);
        
        insert orderProd;
        
        List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
        
        //ordline1.Apttus_Config2__AttributeValueId__c=attribute1.id;
        updateOrderList.add(ordline1);
        
        ordline3.Apttus_Config2__AttributeValueId__c=attribute2.id;
        updateOrderList.add(ordline2);
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute3.id;
        updateOrderList.add(ordline3);
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute4.id;
        updateOrderList.add(ordline4);
        
        ordline5.Apttus_Config2__AttributeValueId__c=attribute5.id;
        updateOrderList.add(ordline5);
        
        ordline6.Apttus_Config2__AttributeValueId__c=attribute6.id;
        updateOrderList.add(ordline6);
        
        ordline7.Apttus_Config2__AttributeValueId__c=attribute7.id;
        updateOrderList.add(ordline7);
                
        update updateOrderList;
       
        //Test.startTest();
                        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();        
    }
     static testMethod void orderQueuetoESIWCMPBundle(){
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='testWCMP';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;  
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='WCMP';
        con.FirstName='Bundle';
        insert con;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Primary Product', ProductCode = '1234568978965', APTS_Corporate_Select__c = 'Primary');
        Product2 oProductP = new Product2(Name='Option Product', ProductCode = '1234568978966', APTS_Corporate_Select__c = 'Module');
        Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9');
        //Product2 oProduct6 = new Product2(Name='Standard Product6', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='05',APTS_Media_Lower_Level_Code__c='E2');
        Product2 oProductProf = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG');
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(oProductS);
        productlist.add(oProductProf);
        insert productlist;
        
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test',
            APTS_Proposal_Business_Unit__c='SCS',
            APTS_Approval_Segment__c='Corporate Emerging',
            APTS_Order_Confirmation_Contact__c=con.id,
            APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
            Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,
            APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
            APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
        //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)');
        insert oProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
        insert prodConfig;
        List<Apttus_Config2__Order__c> ordLists =new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Ready for Activation';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order.Apttus_Config2__Status__c='Pending';
        order.Retry_Count__c = 2;
        insert order;        
        ordLists.add(order);
        
        List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItemP =  new Apttus_Config2__LineItem__c();
        lineItemP.APTS_Group_Primary_Material__c= '40666420';
        lineItemP.Apttus_Config2__LineStatus__c = 'New';  
        lineItemP.APTS_Group__c = 'Bundle A';
        lineItemP.APTS_Contract_Number__c = 123456;
        lineItemP.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemP.Apttus_Config2__ItemSequence__c = 1;
        lineItemP.Apttus_Config2__LineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductId__c = oProductB.Id; 
        lineItemP.APTS_Deal_Type__c= 'WCMP'; 
        lineItemP.Apttus_Config2__Quantity__c=1;
        lineItemP.Apttus_Config2__AddedBy__c = 'User';
        lineItemP.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemP.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemP.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemP.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemP.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemP.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemP.Apttus_Config2__AllowProration__c = FALSE;
        lineItemP.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemP.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemP.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemP.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemP.Apttus_Config2__BasePrice__c = 100;
        lineItemP.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemP.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemP.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemP.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemP.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemP.Apttus_Config2__Customizable__c = FALSE;
        lineItemP.Apttus_Config2__DeltaPrice__c = 50;
        lineItemP.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemP.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemP.Apttus_Config2__ExtendedCost__c = 0;
        lineItemP.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemP.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemP.Apttus_Config2__Guidance__c = 'Red';
        lineItemP.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemP.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemP.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemP.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemP.Apttus_Config2__HasOptions__c = FALSE;
        lineItemP.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemP.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemP.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemP.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemP.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemP.Apttus_Config2__IsHidden__c = FALSE;
        lineItemP.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemP.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemP.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemP.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemP.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemP.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemP.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemP.Apttus_Config2__LineSequence__c = 1;
        lineItemP.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemP.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemP.Apttus_Config2__ListPrice__c = 100;
        lineItemP.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemP.Apttus_Config2__NetPrice__c = 50;
        lineItemP.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemP.Apttus_Config2__OptionSequence__c = 0;
        lineItemP.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemP.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemP.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemP.Apttus_Config2__PriceUom__c = 'Each';
        lineItemP.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemP.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductVersion__c = 1;
        lineItemP.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemP.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemP.Apttus_Config2__SellingTerm__c = 1;
        lineItemP.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemP.Apttus_Config2__Taxable__c = FALSE;
        lineItemP.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemP.Apttus_Config2__Term__c = 1;
        lineItemP.Apttus_Config2__TotalQuantity__c = 1;
        lineItemP.Apttus_Config2__Uom__c = 'Each';
        lineItemP.CurrencyIsoCode = 'USD';
        lineItemP.APTS_Product_Family__c = 'WESTLAW';
        lineItemP.APTS_Contract_Term__c = '2 Years';
        lineItemP.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemP.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItemP);
        
        Apttus_Config2__LineItem__c lineItemo =  new Apttus_Config2__LineItem__c();
        lineItemo.APTS_Group_Primary_Material__c= '40666420';
        lineItemo.Apttus_Config2__LineStatus__c = 'Amended';  
        lineItemo.APTS_Group__c = 'Bundle A';
        lineItemo.APTS_Contract_Number__c = 123456;
        lineItemo.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemo.Apttus_Config2__ItemSequence__c = 1;
        lineItemo.Apttus_Config2__LineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductId__c = oProductP.Id;   
        lineItemo.APTS_Deal_Type__c= 'WCMP';   
        lineItemo.Apttus_Config2__Quantity__c=1;   
        lineItemo.Apttus_Config2__AddedBy__c = 'User';
        lineItemo.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemo.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemo.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemo.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemo.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowProration__c = FALSE;
        lineItemo.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemo.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemo.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemo.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__BasePrice__c = 100;
        lineItemo.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemo.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemo.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemo.Apttus_Config2__Customizable__c = FALSE;
        lineItemo.Apttus_Config2__DeltaPrice__c = 50;
        lineItemo.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemo.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemo.Apttus_Config2__ExtendedCost__c = 0;
        lineItemo.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemo.Apttus_Config2__Guidance__c = 'Red';
        lineItemo.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemo.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemo.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemo.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemo.Apttus_Config2__HasOptions__c = FALSE;
        lineItemo.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemo.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemo.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemo.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsHidden__c = FALSE;
        lineItemo.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemo.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemo.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemo.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemo.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemo.Apttus_Config2__LineSequence__c = 1;
        lineItemo.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemo.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemo.Apttus_Config2__ListPrice__c = 100;
        lineItemo.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemo.Apttus_Config2__NetPrice__c = 50;
        lineItemo.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemo.Apttus_Config2__OptionSequence__c = 0;
        lineItemo.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemo.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemo.Apttus_Config2__PriceUom__c = 'Each';
        lineItemo.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemo.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductVersion__c = 1;
        lineItemo.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemo.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__SellingTerm__c = 1;
        lineItemo.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemo.Apttus_Config2__Taxable__c = FALSE;
        lineItemo.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemo.Apttus_Config2__Term__c = 1;
        lineItemo.Apttus_Config2__TotalQuantity__c = 1;
        lineItemo.Apttus_Config2__Uom__c = 'Each';
        lineItemo.CurrencyIsoCode = 'USD';
        lineItemo.APTS_Product_Family__c = 'WESTLAW';
        lineItemo.APTS_Contract_Term__c = '2 Years';
        lineItemo.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemo.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItemo);
        
        Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
        lineItemS.APTS_Group_Primary_Material__c= '40666420';
        lineItemS.Apttus_Config2__LineStatus__c = 'New';  
        lineItemS.APTS_Group__c = 'Bundle A';
        lineItemS.APTS_Contract_Number__c = 123456;
        lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemS.Apttus_Config2__ItemSequence__c = 1;
        lineItemS.Apttus_Config2__LineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductId__c = oProductS.Id;  
        lineItemS.Apttus_Config2__Quantity__c=1;
        lineItemS.Apttus_Config2__AddedBy__c = 'User';
        lineItemS.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemS.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemS.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemS.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemS.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowProration__c = FALSE;
        lineItemS.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemS.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemS.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemS.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__BasePrice__c = 100;
        lineItemS.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemS.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemS.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemS.Apttus_Config2__Customizable__c = FALSE;
        lineItemS.Apttus_Config2__DeltaPrice__c = 50;
        lineItemS.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemS.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemS.Apttus_Config2__ExtendedCost__c = 0;
        lineItemS.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemS.Apttus_Config2__Guidance__c = 'Red';
        lineItemS.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemS.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemS.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemS.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemS.Apttus_Config2__HasOptions__c = FALSE;
        lineItemS.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemS.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemS.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemS.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsHidden__c = FALSE;
        lineItemS.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemS.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemS.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemS.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemS.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemS.Apttus_Config2__LineSequence__c = 1;
        lineItemS.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemS.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemS.Apttus_Config2__ListPrice__c = 100;
        lineItemS.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemS.Apttus_Config2__NetPrice__c = 50;
        lineItemS.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemS.Apttus_Config2__OptionSequence__c = 0;
        lineItemS.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemS.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemS.Apttus_Config2__PriceUom__c = 'Each';
        lineItemS.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemS.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductVersion__c = 1;
        lineItemS.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemS.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__SellingTerm__c = 1;
        lineItemS.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemS.Apttus_Config2__Taxable__c = FALSE;
        lineItemS.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemS.Apttus_Config2__Term__c = 1;
        lineItemS.Apttus_Config2__TotalQuantity__c = 1;
        lineItemS.Apttus_Config2__Uom__c = 'Each';
        lineItemS.CurrencyIsoCode = 'USD';
        lineItemS.APTS_Product_Family__c = 'WESTLAW';
        lineItemS.APTS_Contract_Term__c = '2 Years';
        lineItemS.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemS.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItemS);
        
        Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle A';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__Quantity__c=1;
        lineItem.APTS_Deal_Type__c = 'WCMPS';
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem);
        
        Apttus_Config2__LineItem__c lineItem2 =  new Apttus_Config2__LineItem__c();
        lineItem2.APTS_Group_Primary_Material__c= '40666420';
        lineItem2.Apttus_Config2__LineStatus__c = 'Amended';  
        lineItem2.APTS_Group__c = 'Bundle A';
        lineItem2.APTS_Contract_Number__c = 1234564;
        lineItem2.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem2.Apttus_Config2__ItemSequence__c = 1;
        lineItem2.Apttus_Config2__LineNumber__c = 2;
        lineItem2.Apttus_Config2__Quantity__c=1;
        lineItem2.APTS_Deal_Type__c ='WCMP';
        lineItem2.Apttus_Config2__AddedBy__c = 'User';
        lineItem2.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem2.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowProration__c = FALSE;
        lineItem2.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem2.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem2.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem2.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__BasePrice__c = 100;
        lineItem2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem2.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem2.Apttus_Config2__Customizable__c = FALSE;
        lineItem2.Apttus_Config2__DeltaPrice__c = 50;
        lineItem2.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem2.Apttus_Config2__ExtendedCost__c = 0;
        lineItem2.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem2.Apttus_Config2__Guidance__c = 'Red';
        lineItem2.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem2.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem2.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem2.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem2.Apttus_Config2__HasOptions__c = FALSE;
        lineItem2.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem2.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem2.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsHidden__c = FALSE;
        lineItem2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem2.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem2.Apttus_Config2__LineSequence__c = 1;
        lineItem2.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem2.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem2.Apttus_Config2__ListPrice__c = 100;
        lineItem2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem2.Apttus_Config2__NetPrice__c = 50;
        lineItem2.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem2.Apttus_Config2__OptionSequence__c = 0;
        lineItem2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem2.Apttus_Config2__PriceUom__c = 'Each';
        lineItem2.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem2.Apttus_Config2__ProductVersion__c = 1;
        lineItem2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__SellingTerm__c = 1;
        lineItem2.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem2.Apttus_Config2__Taxable__c = FALSE;
        lineItem2.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem2.Apttus_Config2__Term__c = 1;
        lineItem2.Apttus_Config2__TotalQuantity__c = 1;
        lineItem2.Apttus_Config2__Uom__c = 'Each';
        lineItem2.CurrencyIsoCode = 'USD';
        lineItem2.APTS_Product_Family__c = 'WESTLAW';
        lineItem2.APTS_Contract_Term__c = '2 Years';
        lineItem2.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem2.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem2);
        
        Apttus_Config2__LineItem__c lineItem3 =  new Apttus_Config2__LineItem__c();
        lineItem3.APTS_Group_Primary_Material__c= '40666420';
        lineItem3.Apttus_Config2__LineStatus__c = 'New';  
        lineItem3.APTS_Group__c = 'Bundle A';
        lineItem3.APTS_Contract_Number__c = 1234564;
        lineItem3.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem3.Apttus_Config2__ItemSequence__c = 1;
        lineItem3.Apttus_Config2__LineNumber__c = 3;
        lineItem3.Apttus_Config2__Quantity__c=1;
        lineItem3.Apttus_Config2__AddedBy__c = 'User';
        lineItem3.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem3.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem3.Apttus_Config2__AllowProration__c = FALSE;
        lineItem3.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem3.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem3.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem3.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem3.Apttus_Config2__BasePrice__c = 100;
        lineItem3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem3.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem3.Apttus_Config2__Customizable__c = FALSE;
        lineItem3.Apttus_Config2__DeltaPrice__c = 50;
        lineItem3.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem3.Apttus_Config2__ExtendedCost__c = 0;
        lineItem3.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem3.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem3.Apttus_Config2__Guidance__c = 'Red';
        lineItem3.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem3.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem3.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem3.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem3.Apttus_Config2__HasOptions__c = FALSE;
        lineItem3.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem3.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem3.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem3.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem3.Apttus_Config2__IsHidden__c = FALSE;
        lineItem3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem3.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem3.Apttus_Config2__LineSequence__c = 1;
        lineItem3.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem3.Apttus_Config2__ListPrice__c = 100;
        lineItem3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem3.Apttus_Config2__NetPrice__c = 50;
        lineItem3.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem3.Apttus_Config2__OptionSequence__c = 0;
        lineItem3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem3.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem3.Apttus_Config2__PriceUom__c = 'Each';
        lineItem3.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem3.Apttus_Config2__ProductVersion__c = 1;
        lineItem3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem3.Apttus_Config2__SellingTerm__c = 1;
        lineItem3.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem3.Apttus_Config2__Taxable__c = FALSE;
        lineItem3.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem3.Apttus_Config2__Term__c = 1;
        lineItem3.Apttus_Config2__TotalQuantity__c = 1;
        lineItem3.Apttus_Config2__Uom__c = 'Each';
        lineItem3.CurrencyIsoCode = 'USD';
        lineItem3.APTS_Product_Family__c = 'WESTLAW';
        lineItem3.APTS_Contract_Term__c = '2 Years';
        lineItem3.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem3.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem3);
        
        Apttus_Config2__LineItem__c lineItem4 =  new Apttus_Config2__LineItem__c();
        lineItem4.Apttus_Config2__LineStatus__c = 'New';  
        lineItem4.APTS_Group__c = 'Bundle A';
        lineItem4.APTS_Contract_Number__c = 1234564;
        lineItem4.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem4.Apttus_Config2__ItemSequence__c = 1;
        lineItem4.Apttus_Config2__LineNumber__c = 4;  
        lineItem4.Apttus_Config2__Quantity__c=1;   
        lineItem4.Apttus_Config2__AddedBy__c = 'User';
        lineItem4.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem4.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem4.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem4.Apttus_Config2__AllowProration__c = FALSE;
        lineItem4.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem4.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem4.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem4.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem4.Apttus_Config2__BasePrice__c = 100;
        lineItem4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem4.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem4.Apttus_Config2__Customizable__c = FALSE;
        lineItem4.Apttus_Config2__DeltaPrice__c = 50;
        lineItem4.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem4.Apttus_Config2__ExtendedCost__c = 0;
        lineItem4.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem4.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem4.Apttus_Config2__Guidance__c = 'Red';
        lineItem4.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem4.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem4.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem4.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem4.Apttus_Config2__HasOptions__c = FALSE;
        lineItem4.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem4.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem4.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem4.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem4.Apttus_Config2__IsHidden__c = FALSE;
        lineItem4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem4.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem4.Apttus_Config2__LineSequence__c = 1;
        lineItem4.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem4.Apttus_Config2__ListPrice__c = 100;
        lineItem4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem4.Apttus_Config2__NetPrice__c = 50;
        lineItem4.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem4.Apttus_Config2__OptionSequence__c = 0;
        lineItem4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem4.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem4.Apttus_Config2__PriceUom__c = 'Each';
        lineItem4.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem4.Apttus_Config2__ProductVersion__c = 1;
        lineItem4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem4.Apttus_Config2__SellingTerm__c = 1;
        lineItem4.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem4.Apttus_Config2__Taxable__c = FALSE;
        lineItem4.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem4.Apttus_Config2__Term__c = 1;
        lineItem4.Apttus_Config2__TotalQuantity__c = 1;
        lineItem4.Apttus_Config2__Uom__c = 'Each';
        lineItem4.CurrencyIsoCode = 'USD';
        lineItem4.APTS_Product_Family__c = 'WESTLAW';
        lineItem4.APTS_Contract_Term__c = '2 Years';
        lineItem4.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem4.APTS_Product_Delivery__c = 'Online/Internet';   
        liList.add(lineItem4);
        
        Apttus_Config2__LineItem__c lineItem5 =  new Apttus_Config2__LineItem__c();
        lineItem5.APTS_Group_Primary_Material__c= '40666420';
        lineItem5.Apttus_Config2__LineStatus__c = 'New';  
        //lineItem4.APTS_Group__c = 'Bundle A';
        lineItem5.APTS_Contract_Number__c = 1234564;
        lineItem5.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem5.Apttus_Config2__ItemSequence__c = 1;
        lineItem5.Apttus_Config2__LineNumber__c = 5;
        lineItem5.Apttus_Config2__Quantity__c=1;
        lineItem5.Apttus_Config2__AddedBy__c = 'User';
        lineItem5.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem5.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem5.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowProration__c = FALSE;
        lineItem5.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem5.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem5.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem5.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__BasePrice__c = 100;
        lineItem5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem5.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem5.Apttus_Config2__Customizable__c = FALSE;
        lineItem5.Apttus_Config2__DeltaPrice__c = 50;
        lineItem5.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem5.Apttus_Config2__ExtendedCost__c = 0;
        lineItem5.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem5.Apttus_Config2__Guidance__c = 'Red';
        lineItem5.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem5.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem5.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem5.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem5.Apttus_Config2__HasOptions__c = FALSE;
        lineItem5.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem5.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem5.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsHidden__c = FALSE;
        lineItem5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem5.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem5.Apttus_Config2__LineSequence__c = 1;
        lineItem5.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem5.Apttus_Config2__ListPrice__c = 100;
        lineItem5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem5.Apttus_Config2__NetPrice__c = 50;
        lineItem5.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem5.Apttus_Config2__OptionSequence__c = 0;
        lineItem5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem5.Apttus_Config2__PriceUom__c = 'Each';
        lineItem5.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem5.Apttus_Config2__ProductVersion__c = 1;
        lineItem5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__SellingTerm__c = 1;
        lineItem5.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem5.Apttus_Config2__Taxable__c = FALSE;
        lineItem5.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem5.Apttus_Config2__Term__c = 1;
        lineItem5.Apttus_Config2__TotalQuantity__c = 1;
        lineItem5.Apttus_Config2__Uom__c = 'Each';
        lineItem5.CurrencyIsoCode = 'USD';
        lineItem5.APTS_Product_Family__c = 'WESTLAW';
        lineItem5.APTS_Contract_Term__c = '2 Years';
        lineItem5.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem5.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem5);   
            
        //Added newly 11th Nov
        
        APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
        dynamicbundlewm.APTS_Group__c='Bundle A';
        dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm.APTS_Keep_Terms__c=true;
        dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewm.APTS_Deal_Number__c = 623589;
        dynamicbundlewm.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm.APTS_Bridge_Length__c = 2;
        dynamicbundlewm.APTS_Bridge__c = '28 Days';
        dynamicbundlewm.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewm;
        
        APTS_Dynamic_Bundle__c dynamicbundlewm2 = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm2.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm2.APTS_Program_ID__c= 'WCMP';  
        dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewm2.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm2.APTS_Keep_Terms__c=false;
        dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewm.APTS_Deal_Number__c = 623589;
        dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm2.APTS_Bridge_Length__c = 2;
        dynamicbundlewm2.APTS_Bridge__c = '14 Days';
        dynamicbundlewm2.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewm2;  
        
        APTS_Dynamic_Bundle__c dynamicbundlewmK = new APTS_Dynamic_Bundle__c();
        dynamicbundlewmK.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewmK.APTS_Program_ID__c= 'WCMP';  
        //dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewmK.APTS_Quote_Proposal__c=oProposal.id;
        //dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        //dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewmK.APTS_Keep_Terms__c=false;
        //dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        //dynamicbundlewmK.APTS_Deal_Number__c = 623589;
        //dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewmK.APTS_Bridge_Length__c = 2;
        dynamicbundlewmK.APTS_Bridge__c = '7 Days';
        dynamicbundlewmk.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewmK;
        
        APTS_Dynamic_Bundle__c dynamicbundlewmF = new APTS_Dynamic_Bundle__c();
        dynamicbundlewmF.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewmF.APTS_Program_ID__c= 'WCMP';  
        //dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewmF.APTS_Quote_Proposal__c=oProposal.id;
        //dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        //dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewmF.APTS_Keep_Terms__c=false;
        //dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewmF.APTS_Deal_Number__c = 623589;
        //dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewmF.APTS_Bridge_Length__c = 2;
        dynamicbundlewmF.APTS_Bridge__c = '14 Days';
        dynamicbundlewmF.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewmF;
        
        Test.startTest(); 
        insert liList;
        oProposal.apts_has_dynamic_bundle__c=false;
        update oProposal;
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);
        System.assertEquals(1,ordLists.size());
        
        Test.stopTest();
        
    }
    
    //Added by TK
  
    
    //Added by TK
    @isTest
    static void ContentVersion_OrderForm_TK()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;

        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; 

        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');  
        //11th Nov

        Product2 prodobj = new Product2();

        prodobj.Name='Sreenu Product Test';
        prodobj.ProductCode = '41972767';
        prodobj.APTS_Media_High_Level_Code__c = '06';
        prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodobj.IsActive = true;
        prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
        prodobj.Service_Number__c ='0';

        productlist.add(oProductC);
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(prodobj);

        insert productlist;        
        
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        
        oProposal.Apttus_Proposal__Account__c=acc.id;
        oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
        oProposal.APTS_Proposal_Business_Unit__c='Canada';
        oProposal.APTS_Approval_Segment__c='Canada';
        //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
        oProposal.Apttus_Proposal__Account__c = acc.Id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
        oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
        oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;

        insert oProposal;

        List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Test.startTest();
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

        
     
     ContentVersion cv4 = new ContentVersion();
           cv4.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv4.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv4.Title = 'Order Form Demo.pdf'; // Display name of the files
           cv4.VersionData = beforeblob; // converting your binary string to Blog
           insert cv4;
                        
           Id conDoc4 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv4.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe4 = new ContentDocumentLink();
           cDe4.ContentDocumentId = conDoc4;
           cDe4.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe4.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe4;
     
     
     
        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='1 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'Recurring';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = true;
        ordlineProf.apts_mla__c = false;
        ordlineProf.APTS_Deal_Number__c = 12345;
        //ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf.Apttus_Config2__LineStatus__c = 'Amended';


        ordlineList.add(ordlineProf);
        
        Apttus_Config2__OrderLineItem__c ordlineProf1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf1.APTS_Contract_Term__c='5 Years';
        ordlineProf1.Apttus_Config2__Quantity__c=1.000;
        ordlineProf1.Apttus_Config2__OrderId__c=order.id;
        ordlineProf1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf1.Apttus_Config2__SellingFrequency__c = 'One Time';
        ordlineProf1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        ordlineProf1.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineProf1.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf1.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf1.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf1.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf1.APTS_Program_ID__c = 'WCMP';
        ordlineProf1.APTS_Keep_Terms__c = false;
        ordlineProf1.apts_mla__c = false;
        ordlineProf1.APTS_Deal_Number__c = 12345;
        //ordlineProf1.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf1.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf1);
        
        Apttus_Config2__OrderLineItem__c ordlineProf2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf2.APTS_Contract_Term__c='5 Years';
        ordlineProf2.Apttus_Config2__Quantity__c=1.000;
        ordlineProf2.Apttus_Config2__OrderId__c=order.id;
        ordlineProf2.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf2.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf2.Apttus_Config2__SellingFrequency__c = 'One Time';
        ordlineProf2.Apttus_Config2__PriceMethod__c = 'Flat Price';
        ordlineProf2.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineProf2.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf2.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf2.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf2.APTS_Program_ID__c = 'WCMP';
        ordlineProf2.APTS_Keep_Terms__c = false;
        ordlineProf2.apts_mla__c = false;
        ordlineProf2.APTS_Deal_Number__c = NULL;
        //ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf2.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf2);
        Apttus_Config2__OrderLineItem__c ordlineProf3 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf3.APTS_Contract_Term__c='5 Years';
        ordlineProf3.Apttus_Config2__Quantity__c=1.000;
        ordlineProf3.Apttus_Config2__OrderId__c=order.id;
        ordlineProf3.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf3.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf3.Apttus_Config2__SellingFrequency__c = 'One Time';
        ordlineProf3.Apttus_Config2__PriceMethod__c = 'Flat Price';
        ordlineProf3.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineProf3.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf3.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf3.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf3.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf3.APTS_Program_ID__c = 'WCMP';
        ordlineProf3.APTS_Keep_Terms__c = true;
        ordlineProf3.apts_mla__c = false;
        ordlineProf3.APTS_Deal_Number__c = 12346;
        //ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf3.Apttus_Config2__LineStatus__c = 'Renewed';

        ordlineList.add(ordlineProf3);   
     
        insert ordlineList;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc5);
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc6);
     
       Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc7); 
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc8); 
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc9); 
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc10); 
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc11); 
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc12); 
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc13); 
   Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc14); 
   Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc15);
   Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc16);
   Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Tax Professional',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc17);
   Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c);
   onlineContactList.add(oc18);
        
        insert onlineContactList;
        
        List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
        masterContactList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
        masterContactList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
        masterContactList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc5);
        Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc6);
        Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc7);
        insert masterContactList;
        //Test.startTest();
                        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();        
    }
   @isTest 
    static void ordersubESI_TK1()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;

        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; 

        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');  
        //11th Nov

        Product2 prodobj = new Product2();

        prodobj.Name='Sreenu Product Test';
        prodobj.ProductCode = '41972767';
        prodobj.APTS_Media_High_Level_Code__c = '06';
        prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodobj.IsActive = true;
        prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
        prodobj.Service_Number__c ='0';

        productlist.add(oProductC);
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(prodobj);

        insert productlist;        
        
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        
        oProposal.Apttus_Proposal__Account__c=acc.id;
        oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
        oProposal.APTS_Proposal_Business_Unit__c='Canada';
        oProposal.APTS_Approval_Segment__c='Canada';
        //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
        oProposal.Apttus_Proposal__Account__c = acc.Id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
        oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
        oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;

        insert oProposal;

        List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Test.startTest();
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        
        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='5 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = false;
        ordlineProf.apts_mla__c = true;
        ordlineProf.APTS_Deal_Number__c = 12345;
        ordlineProf.APTS_SAP_MLA_Agreement_Number__c = null ;
        ordlineProf.Apttus_Config2__LineStatus__c = 'New';


        ordlineList.add(ordlineProf);
        
        insert ordlineList;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc5);
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc6);
        
        insert onlineContactList;
        
        List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
        masterContactList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
        masterContactList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
        masterContactList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc5);
        Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc6);
        Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc7);
        insert masterContactList;
        //Test.startTest();
                        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();
    } 
     static testmethod void ordersubmissionESIGLP2()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
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
        
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Source_System_Account_Number__c = '34654746';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; 
        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '40666420',APTS_Media_High_Level_Code__c = '21', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Attorneys', APTS_Item_Category_Group__c='ZPR2');
        productlist.add(oProductB);
        insert productlist;        
        
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        oProposal.Apttus_Proposal__Account__c=acc.id;
        oProposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;
        oProposal.APTS_Proposal_Business_Unit__c = 'SCS';
        oProposal.APTS_SA_ID__c = 'AL MSA-WEST C6027018 (ALM1)';
        insert oProposal;
        Test.startTest();
    
    Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
    insert prodConfig;
    
    List<Apttus_Config2__LineItem__c> lstLI = new List<Apttus_Config2__LineItem__c>();
    Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
    lineItemS.APTS_Group_Primary_Material__c= '40666420';
    lineItemS.Apttus_Config2__LineStatus__c = 'New';  
    lineItemS.APTS_Group__c = 'Bundle A';
    lineItemS.APTS_Contract_Number__c = 123456;
    lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
    lineItemS.Apttus_Config2__ItemSequence__c = 1;
    lineItemS.Apttus_Config2__LineNumber__c = 1;
    lineItemS.Apttus_Config2__ProductId__c = oProductB.Id;   
    lineItemS.Apttus_Config2__AddedBy__c = 'User';
    lineItemS.Apttus_Config2__AdjustedPrice__c = 50;
    lineItemS.Apttus_Config2__AdjustmentAmount__c = 50;
    lineItemS.Apttus_Config2__AdjustmentType__c = '% Discount';
    lineItemS.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
    lineItemS.Apttus_Config2__AllowableAction__c = 'Unrestricted';
    lineItemS.Apttus_Config2__AllowManualAdjustment__c = TRUE;
    lineItemS.Apttus_Config2__AllowProration__c = FALSE;
    lineItemS.Apttus_Config2__AllowRemoval__c = TRUE;
    lineItemS.Apttus_Config2__AutoRenew__c = FALSE;
    lineItemS.Apttus_Config2__BaseExtendedCost__c = 0;
    lineItemS.Apttus_Config2__BaseExtendedPrice__c = 100;
    lineItemS.Apttus_Config2__BasePrice__c = 100;
    lineItemS.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
    lineItemS.Apttus_Config2__BillingFrequency__c = 'Monthly';
    lineItemS.Apttus_Config2__ChargeType__c = 'Subscription Fee';
    lineItemS.Apttus_Config2__ConfigStatus__c = 'Complete';
    lineItemS.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
    lineItemS.Apttus_Config2__Customizable__c = FALSE;
    lineItemS.Apttus_Config2__DeltaPrice__c = 50;
    lineItemS.Apttus_Config2__DeltaQuantity__c = 1;
    lineItemS.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
    lineItemS.Apttus_Config2__ExtendedCost__c = 0;
    lineItemS.Apttus_Config2__ExtendedPrice__c = 100;
    lineItemS.Apttus_Config2__Frequency__c = 'Monthly';
    lineItemS.Apttus_Config2__Guidance__c = 'Red';
    lineItemS.Apttus_Config2__HasAttributes__c = FALSE;
    lineItemS.Apttus_Config2__HasBaseProduct__c = FALSE;
    lineItemS.Apttus_Config2__HasDefaults__c = FALSE;
    lineItemS.Apttus_Config2__HasIncentives__c = FALSE;
    lineItemS.Apttus_Config2__HasOptions__c = FALSE;
    lineItemS.Apttus_Config2__HasTieredPrice__c = FALSE;
    lineItemS.Apttus_Config2__HideCopyAction__c = FALSE;
    lineItemS.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
    lineItemS.Apttus_Config2__IsAssetPricing__c = FALSE;
    lineItemS.Apttus_Config2__IsCustomPricing__c = FALSE;
    lineItemS.Apttus_Config2__IsHidden__c = FALSE;
    lineItemS.Apttus_Config2__IsOptionRollupLine__c = FALSE;
    lineItemS.Apttus_Config2__IsPrimaryLine__c = TRUE;
    lineItemS.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
    lineItemS.Apttus_Config2__IsQuantityModifiable__c = FALSE;
    lineItemS.Apttus_Config2__IsReadOnly__c = FALSE;
    lineItemS.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
    lineItemS.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
    lineItemS.Apttus_Config2__LineSequence__c = 1;
    lineItemS.APTS_Yr_1_Renewal_Adjustment__c ='1';
    lineItemS.Apttus_Config2__LineType__c = 'Product/Service';
    lineItemS.Apttus_Config2__ListPrice__c = 100;
    lineItemS.Apttus_Config2__NetAdjustmentPercent__c = -50;
    lineItemS.Apttus_Config2__NetPrice__c = 50;
    lineItemS.Apttus_Config2__NetUnitPrice__c = 50;
    lineItemS.Apttus_Config2__OptionSequence__c = 0;
    lineItemS.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
    lineItemS.Apttus_Config2__PriceMethod__c = 'Per Unit';
    lineItemS.Apttus_Config2__PriceType__c = 'Recurring';
    lineItemS.Apttus_Config2__PriceUom__c = 'Each';
    lineItemS.Apttus_Config2__PricingStatus__c = 'Complete';
    lineItemS.Apttus_Config2__PrimaryLineNumber__c = 1;
    lineItemS.Apttus_Config2__ProductVersion__c = 1;
    lineItemS.Apttus_Config2__RollupPriceToBundle__c = TRUE;
    lineItemS.Apttus_Config2__SellingFrequency__c = 'Monthly';
    lineItemS.Apttus_Config2__SellingTerm__c = 1;
    lineItemS.Apttus_Config2__SyncStatus__c = 'Pending';
    lineItemS.Apttus_Config2__Taxable__c = FALSE;
    lineItemS.Apttus_Config2__TaxInclusive__c = FALSE;
    lineItemS.Apttus_Config2__Term__c = 1;
    lineItemS.Apttus_Config2__TotalQuantity__c = 1;
    lineItemS.Apttus_Config2__Uom__c = 'Each';
    lineItemS.CurrencyIsoCode = 'USD';
    lineItemS.APTS_Product_Family__c = 'WESTLAW';
    lineItemS.APTS_Contract_Term__c = '2 Years';
    lineItemS.APTS_Years_2_Plus_Adjustment__c = '4';
    lineItemS.APTS_Product_Delivery__c = 'Online/Internet';
    lineItemS.APTS_is_Primary_in_Bundle__c=true;
    lstLI.add(lineItemS);
    
    //Apttus_Config2__LineItem__c lineItemS1 =  new Apttus_Config2__LineItem__c();
    //lineItemS1.APTS_Group_Primary_Material__c= '40666420';
    //lineItemS1.Apttus_Config2__LineStatus__c = 'New';  
    //lineItemS1.APTS_Group__c = 'Bundle A';
    //lineItemS1.APTS_Contract_Number__c = 123456;
    //lineItemS1.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
    //lineItemS1.Apttus_Config2__ItemSequence__c = 1;
    //lineItemS1.Apttus_Config2__LineNumber__c = 1;
    //lineItemS1.Apttus_Config2__ProductId__c = oProductB.Id;  
    //lineItemS1.APTS_Deal_Type__c = 'WCMPS';
    // lstLI .add(lineItemS1);

    insert lstLI ;
    
    List<Apttus_Config2__ProductAttributeValue__c > LIProd=new List<Apttus_Config2__ProductAttributeValue__c >();
        
        Apttus_Config2__ProductAttributeValue__c attribute11 = new Apttus_Config2__ProductAttributeValue__c ();
        attribute11.Purchase_Option_Bundle_Print__c ='Ship & Entitle Sub';
        attribute11.Apttus_Config2__LineItemId__c=lineItemS.id;
        LIProd.add(attribute11);
        
        insert LIProd;
        
        List<Apttus_Config2__LineItem__c > udpateLILIst=new List<Apttus_Config2__LineItem__c >();
        
        lineItemS.Apttus_Config2__AttributeValueId__c=attribute11.id;
        udpateLILIst.add(lineItemS);
        
        //update udpateLILIst;
       // Test.startTest();
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        
        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
        ordline1.APTS_Contract_Term__c='1 Year';
        ordline1.Apttus_Config2__OrderId__c=order.id;
        ordline1.Apttus_Config2__Quantity__c=1.000;
        ordline1.Apttus_Config2__ProductId__c=oProductB.id;
        ordline1.APTS_Group__c='Bundle A'; 
        ordline1.APTS_Program_ID__c = 'WCMP';
        ordline1.Apttus_Config2__BillingFrequency__c  = 'Monthly';
        ordline1.APTS_Bridge__c='1 Month';
        
        ordlineList.add(ordline1);        
        
        Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
        ordline2.APTS_Contract_Term__c='1 Year';
        ordline2.Apttus_Config2__OrderId__c=order.id;
        ordline2.Apttus_Config2__Quantity__c=1.000;
        ordline2.Apttus_Config2__ProductId__c=oProductB.id;
        ordline2.APTS_Group__c='Bundle A'; 
        ordline2.APTS_Program_ID__c = 'WCMP';
        ordline2.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline2);
        
        Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
        ordline3.APTS_Contract_Term__c='1 Year';
        ordline3.Apttus_Config2__OrderId__c=order.id;
        ordline3.Apttus_Config2__Quantity__c=1.000;
        ordline3.Apttus_Config2__ProductId__c=oProductB.id;
        ordline3.APTS_Group__c='Bundle A'; 
        ordline3.APTS_Program_ID__c = 'WCMP';
        ordline3.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline3);
        
        Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
        ordline4.APTS_Contract_Term__c='1 Year';
        ordline4.Apttus_Config2__OrderId__c=order.id;
        ordline4.Apttus_Config2__Quantity__c=1.000;
        ordline4.Apttus_Config2__ProductId__c=oProductB.id;
        ordline4.Apttus_Config2__BillingFrequency__c  = 'Monthly';
        ordline4.APTS_Group__c='Bundle A'; 
        ordline4.APTS_Program_ID__c = 'WCMP';
        ordline4.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline4);
        
        Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
        ordline5.APTS_Contract_Term__c='1 Year';
        ordline5.Apttus_Config2__OrderId__c=order.id;
        ordline5.Apttus_Config2__Quantity__c=1.000;
        ordline5.Apttus_Config2__ProductId__c=oProductB.id;
        ordline5.APTS_Group__c='Bundle A'; 
        ordline5.APTS_Program_ID__c = 'WCMP';
        ordline5.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline5);   
        
        Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c();
        ordline6.APTS_Contract_Term__c='1 Year';
        ordline6.Apttus_Config2__OrderId__c=order.id;
        ordline6.Apttus_Config2__Quantity__c=1.000;
        ordline6.Apttus_Config2__ProductId__c=oProductB.id;
        ordline6.APTS_Group__c='Bundle A'; 
        ordline6.APTS_Program_ID__c = 'WCMP';
        ordline6.APTS_Bridge__c='1 Month';
        ordlineList.add(ordline6);
     
     
        //changed order1 to order
        Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c();
        ordline7.APTS_Contract_Term__c='5 Years';
        ordline7.Apttus_Config2__Quantity__c=1.000;
        ordline7.Apttus_Config2__OrderId__c=order.id;
        ordline7.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline7.Apttus_Config2__LineType__c = 'Option';
        ordline7.Apttus_Config2__PriceType__c = 'One Time';
        ordline7.Apttus_Config2__NetPrice__c = 1728;
        ordlineList.add(ordline7);
        
        Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c();
        ordline8.APTS_Contract_Term__c='5 Years';
        ordline8.Apttus_Config2__Quantity__c=1.000;
        ordline8.Apttus_Config2__OrderId__c=order.id;
        ordline8.APTS_Group__c='null'; 
        ordline8.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordline8.Apttus_Config2__LineType__c = 'Product/Service';
        ordline8.Apttus_Config2__PriceType__c = 'One Time';
        ordline8.Apttus_Config2__NetPrice__c = 1728;
        ordline8.Apttus_Config2__AdjustmentType__c = '% Discount';
        ordlineList.add(ordline8);
       
        insert ordlineList;
        
        //Test.startTest();
        
        List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
        
        Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute1.Purchase_Option_Bundle_Print__c ='Ship & Entitle Sub';
        attribute1.Apttus_Config2__LineItemId__c=ordline1.id;
        orderProd.add(attribute1);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute2.Purchase_Option_Bundle_Print__c ='Ship & Entitle - APP';
        attribute2.Apttus_Config2__LineItemId__c=ordline2.id;
        orderProd.add(attribute2);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute3.Purchase_Option_Bundle_Print__c ='Ship & Entitle Sub';
        attribute3.Apttus_Config2__LineItemId__c=ordline3.id;
        orderProd.add(attribute3);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute4 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute4.Purchase_Option_Bundle_Print__c ='Sub Only APP';
        attribute4.Apttus_Config2__LineItemId__c=ordline4.id;
        orderProd.add(attribute4);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute5 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute5.Purchase_Option_Bundle_Print__c ='Sub Only APP';
        attribute5.Apttus_Config2__LineItemId__c=ordline5.id;
        orderProd.add(attribute5);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute6 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute6.Purchase_Option_Bundle_Print__c ='Sub Only';
        attribute6.Apttus_Config2__LineItemId__c=ordline6.id;
        orderProd.add(attribute6);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute7 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute7.Purchase_Option_Bundle_Print__c ='Ship & Entitle Only';
        attribute7.Apttus_Config2__LineItemId__c=ordline7.id;
        orderProd.add(attribute7);
        
        Apttus_Config2__OrderProductAttributeValue__c attribute8 = new Apttus_Config2__OrderProductAttributeValue__c();
        attribute8.SCS_Print_Purchase_Options__c ='test';
        attribute8.Apttus_Config2__LineItemId__c=ordline8.id;
        orderProd.add(attribute8);
        
        insert orderProd;
        
        List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
        
        ordline1.Apttus_Config2__AttributeValueId__c=attribute1.id;
        updateOrderList.add(ordline1);
        
        ordline2.Apttus_Config2__AttributeValueId__c=attribute2.id;
        updateOrderList.add(ordline2);
        
        ordline3.Apttus_Config2__AttributeValueId__c=attribute3.id;
        updateOrderList.add(ordline3);
        
        ordline4.Apttus_Config2__AttributeValueId__c=attribute4.id;
        updateOrderList.add(ordline4);
        
        ordline5.Apttus_Config2__AttributeValueId__c=attribute5.id;
        updateOrderList.add(ordline5);
        
        ordline6.Apttus_Config2__AttributeValueId__c=attribute6.id;
        updateOrderList.add(ordline6);
        
        ordline7.Apttus_Config2__AttributeValueId__c=attribute7.id;
        updateOrderList.add(ordline7);
        
        ordline8.Apttus_Config2__AttributeValueId__c=attribute8.id;
        updateOrderList.add(ordline8);
                
        update updateOrderList;
       
        //Test.startTest();
                        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();        
    }
       @isTest
    static void method_RY1()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;

        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; 

        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');  
        //11th Nov

        Product2 prodobj = new Product2();

        prodobj.Name='Sreenu Product Test';
        prodobj.ProductCode = '41972767';
        prodobj.APTS_Media_High_Level_Code__c = '06';
        prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodobj.IsActive = true;
        prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
        prodobj.Service_Number__c ='0';

        productlist.add(oProductC);
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(prodobj);

        insert productlist;        
        
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        
        oProposal.Apttus_Proposal__Account__c=acc.id;
        oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
        oProposal.APTS_Proposal_Business_Unit__c='Canada';
        oProposal.APTS_Approval_Segment__c='Canada';
        //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
        oProposal.Apttus_Proposal__Account__c = acc.Id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
        oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
        oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;

        insert oProposal;

        List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Test.startTest();
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        
        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='5 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = true;
        ordlineProf.apts_mla__c = true;
    ordlineProf.APTS_Bridge__c='7 Days';
        ordlineProf.APTS_Deal_Number__c = 12345;
        ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf.Apttus_Config2__LineStatus__c = 'New';
 

        ordlineList.add(ordlineProf);
         Apttus_Config2__OrderLineItem__c ordlineProf2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf2.APTS_Contract_Term__c='5 Years';
        ordlineProf2.Apttus_Config2__Quantity__c=1.000;
        ordlineProf2.Apttus_Config2__OrderId__c=order.id;
        ordlineProf2.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf2.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf2.Apttus_Config2__LineType__c = 'Option';
        ordlineProf2.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf2.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf2.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf2.APTS_Program_ID__c = 'WCMP';
        ordlineProf2.APTS_Keep_Terms__c = true;
        ordlineProf2.apts_mla__c = true;
    ordlineProf2.APTS_Bridge__c='14 Days';
        ordlineProf2.APTS_Deal_Number__c = 12345;
        ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234';
        ordlineProf2.Apttus_Config2__LineStatus__c = 'New';
 

        ordlineList.add(ordlineProf2);
         Apttus_Config2__OrderLineItem__c ordlineProf3 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf3.APTS_Contract_Term__c='5 Years';
        ordlineProf3.Apttus_Config2__Quantity__c=1.000;
        ordlineProf3.Apttus_Config2__OrderId__c=order.id;
        ordlineProf3.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf3.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf3.Apttus_Config2__LineType__c = 'Option';
        ordlineProf3.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf3.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf3.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf3.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf3.APTS_Program_ID__c = 'WCMP';
        ordlineProf3.APTS_Keep_Terms__c = true;
        ordlineProf3.apts_mla__c = true;
    ordlineProf3.APTS_Bridge__c='28 Days';
        ordlineProf3.APTS_Deal_Number__c = 12345;
        ordlineProf3.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf3.Apttus_Config2__LineStatus__c = 'New';
 

        ordlineList.add(ordlineProf3);
        
        insert ordlineList;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc5);
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc6);
        
        insert onlineContactList;
        
        List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
        masterContactList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
        masterContactList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
        masterContactList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc5);
        Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc6);
        Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc7);
        insert masterContactList;
        //Test.startTest();
                        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();
    } 
    
static testmethod void ordersubmissionESINBN1()
{   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
    
    KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
    LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
    LCRMStrikeIronFlagINS1.TextValue__c='True';
    keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
    keyvaluestoreList.add(keyvaluestore);
    
    KeyValueListStore__c keyval = new KeyValueListStore__c();
    keyval.Name='ReasonWithCompetitor';
    keyval.TextValue__c='Price';
    keyvaluestoreList.add(keyval);
    insert keyvaluestoreList;
    Account acc = new Account();
    acc.Name='test';
    acc.Customer_Group__c='FEDERAL GOVERNMENT';
    acc.CurrencyIsoCode='USD';
    acc.Sales_Org__c='WEST';
    Insert acc;
    
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=acc.ID;
    accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
    accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='WEST';
    insert accountSSD;
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=accountSSD.id;
    oppty.Account=acc;
    insert oppty; 
    
    
    Contact con = new Contact();
    con.AccountId = acc.Id;
    con.LastName='Prabhu';
    con.FirstName='Issac';
    insert con;
    
    List<Product2> prodList=new List<Product2>();
    
    Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '41841759', APTS_Media_Lower_Level_Code__c = 'PQ',APTS_Media_High_Level_Code__c='13',Family= System.Label.Caseline_Product_Family);
    Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978967', APTS_Media_Lower_Level_Code__c = 'PQ', APTS_Media_High_Level_Code__c='13',Family= System.Label.Caseline_Product_Family);
    Product2 oProductB1 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06',APTS_Media_Lower_Level_Code__c = 'I9', Apttus_Config2__Uom__c = 'Attorneys');
    Product2 oProductP1 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='07',APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Seats');
    Product2 oProductB2 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06', Apttus_Config2__Uom__c = 'Attorneys');
    Product2 oProductP2 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
    prodList.add(oProductB);
    prodList.add(oProductP);
    prodList.add(oProductB1);
    prodList.add(oProductP1);
    prodList.add(oProductB2);
    prodList.add(oProductP2);
    insert prodList;
    
    Test.startTest();   
    // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Proposal_Business_Unit__c='FindLaw',APTS_Approval_Segment__c='Corporate',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
    insert oProposal;
    
    list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
    Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
    listLineItems.add(li1);
    
    Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
    listLineItems.add(li2);
    Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
    listLineItems.add(li3);
    Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
    listLineItems.add(li4);
    Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
    listLineItems.add(li5);
    Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
    listLineItems.add(li6);
    
    insert listLineItems;
    
    List<Apttus_Config2__Order__c> ordLists=new List<Apttus_Config2__Order__c>();
    Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
    order.Apttus_Config2__Type__c='New';
    order.Apttus_Config2__Status__c='Ready for Activation';
    order.APTS_SSD_Sold_To__c=accountSSD.id;
    order.APTS_SSD_bill_to__c=accountSSD.id;
    order.APTS_SSD_ship_to__c=accountSSD.id;
    order.Apttus_QPConfig__ProposalId__c=oProposal.id;
    insert order;
    ordLists.add(order);


    List<Apttus_Config2__AssetLineItem__c> asstlineitemList = new List<Apttus_Config2__AssetLineItem__c>();

    Apttus_Config2__AssetLineItem__c asli =new Apttus_Config2__AssetLineItem__c();
    asli.APTS_Info_RenewalDate__c=system.today();
    asli.APTS_Info_PlanType__c = 'S00';
    asli.APTS_SAP_MLA_Agreement_Number__c ='12345';
    asli.Apttus_Config2__BillToAccountId__c=acc.id;
    asli.APTS_SSD_Sold_To__c = accountSSD.id;
    asli.Apttus_Config2__ProductId__c= oProductB.id;
    asstlineitemList.add(asli);

    Apttus_Config2__AssetLineItem__c asli1=new Apttus_Config2__AssetLineItem__c();
    asli1.APTS_Info_RenewalDate__c=system.today();
    asli1.APTS_Info_PlanType__c = 'S00';
    asli1.APTS_SAP_MLA_Agreement_Number__c ='102030';
    asli1.Apttus_Config2__BillToAccountId__c=acc.id;
    asli1.APTS_SSD_Sold_To__c = accountSSD.id;
    asli1.Apttus_Config2__ProductId__c= oProductP.id;
    asstlineitemList.add(asli1);

    insert asstlineitemList;
    
    
    Map<Id, String> mapAssetToMLANumber = new Map<Id, String>();
    APTS_OrderSubmissionUtilityExt4.returnMLAPLIs(asli1, mapAssetToMLANumber );
    
    Map<String, Date> mapAssetIdToRenewalDate = new Map<String, Date>();
    APTS_OrderSubmissionUtilityExt3.returnMapAssetIdToRenewalDate(asli1,'102030',mapAssetIdToRenewalDate);
    
    APTS_OrderSubmissionUtilityExt4.returnCLAssets(asli1);
    APTS_OrderSubmissionUtilityExt4.returnMLAPLIs(asli1, new Map<Id, String> () );
    
    
    List<Apttus_Config2__OrderLineItem__c> orderlineitemList = new List<Apttus_Config2__OrderLineItem__c>();
    
    Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
    ordline.Apttus_Config2__AssetLineItemId__c = asli.id;
    ordline.APTS_Contract_Term__c='1 Year';
    ordline.Apttus_Config2__OrderId__c=order.id;
    ordline.Apttus_Config2__LineStatus__c='Cancelled'; 
    ordline.Apttus_Config2__Quantity__c=1.000;
    ordline.Apttus_Config2__ProductId__c=oProductB.id;
    ordline.Apttus_Config2__BillToAccountId__c = acc.id;
    ordline.APTS_Group__c='Bundle A';  
    ordline.APTS_Bridge__c='1 Month';
    //ordline.APTS_SAP_MLA_Agreement_Number__c = '12345';
    ordline.APTS_Service_Number__c = '40757482';
    ordline.APTS_Program_ID__c = 'CPRO';
    ordline.Apttus_Config2__LineType__c = 'Product/Service';
    orderlineitemList.add(ordline);
    
    Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
    ordline1.Apttus_Config2__AssetLineItemId__c = asli1.id;
    ordline1.APTS_Contract_Term__c='1 Year';
    ordline1.Apttus_Config2__OrderId__c=order.id;
    ordline1.Apttus_Config2__LineStatus__c='Cancelled'; 
    ordline1.Apttus_Config2__Quantity__c=1.000;
    ordline1.Apttus_Config2__ProductId__c=oProductP.id;
    ordline1.Apttus_Config2__BillToAccountId__c = acc.id;
    ordline1.APTS_Group__c='Bundle A';  
    ordline1.APTS_Bridge__c='1 Month';
    //ordline.APTS_SAP_MLA_Agreement_Number__c = '12345';
    ordline1.APTS_Service_Number__c = '40757482';
    ordline1.APTS_Program_ID__c = 'CPRO';
    ordline1.Apttus_Config2__LineType__c = 'Product/Service';
    orderlineitemList.add(ordline1);
    
    Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
    ordline2.APTS_Contract_Term__c='1 Year';
    ordline2.Apttus_Config2__OrderId__c=order.id;
    ordline2.Apttus_Config2__LineStatus__c='Renewed'; 
    ordline2.Apttus_Config2__Quantity__c=1.000;
    ordline2.Apttus_Config2__ProductId__c=oProductB.id; 
    ordline2.APTS_Bridge__c='1 Month';
    orderlineitemList.add(ordline2);
    
    Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
    //ordline.Apttus_Config2__AssetLineItemId__c = asli1.id;
    ordline3.APTS_Contract_Term__c='1 Year';
    ordline3.Apttus_Config2__OrderId__c=order.id;
    ordline3.Apttus_Config2__LineStatus__c='Renewed'; 
    ordline3.Apttus_Config2__Quantity__c=1.000;
    ordline3.Apttus_Config2__ProductId__c=oProductP.id; 
    ordline3.APTS_Bridge__c='1 Month';
    orderlineitemList.add(ordline3);
    insert orderlineitemList; 
    
    Map<Id, String> mapAssetToMLANumber1 = new Map<Id, String>();
    Map<String, Date> mapAssetIdToRenewalDate1 = new Map<String, Date>();
    //Apttus_Config2__OrderLineItem__c objOLI, Map<Id, String> mapAssetToMLANumber, Map<String, Date> mapAssetIdToRenewalDate
    APTS_OrderSubmissionUtilityExt3.setDate(ordline3,mapAssetToMLANumber1,mapAssetIdToRenewalDate1 );
    
    
    APTS_OrderSubmissionUtilityExt4.returnProfCheck(ordline3, new Map<Id, String> (), new Map<String, Date> () );
    APTS_OrderSubmissionUtilityExt4.returnCslnStandCheck(ordline3, new Map<String, Date> ());
    APTS_OrderSubmissionUtilityExt4.returnIsObjCheck(ordline3); 
    
    Apttus_Approval__Approval_Request__c ar = new Apttus_Approval__Approval_Request__c(                   
        Apttus_Approval__Approval_Status__c = 'Approved',
        Apttus_QPApprov__ProposalId__c =  oProposal.id               
    );
    insert ar;  
    
    order.Apttus_Config2__Status__c='Pending';
    update order;

    
    Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order.id];
    //OrdersubmissionESI.invokeOrdertoESI(ordername); Commented as part of CRM-9456
    APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id); //Added as part of CRM-9456
    System.assertEquals(1,ordLists.size());
    Test.stopTest();
    
}
    
 static testmethod  void trials_testing()
{   
  
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
    
    KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
    LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
    LCRMStrikeIronFlagINS1.TextValue__c='True';
    keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
    keyvaluestoreList.add(keyvaluestore);
    
    KeyValueListStore__c keyval = new KeyValueListStore__c();
    keyval.Name='ReasonWithCompetitor';
    keyval.TextValue__c='Price';
    keyvaluestoreList.add(keyval);
    insert keyvaluestoreList;

    Account acc = new Account();
    acc.Name='test';
    acc.Customer_Group__c='FEDERAL GOVERNMENT';
    acc.CurrencyIsoCode='USD';
    acc.Sales_Org__c='WEST';
    Insert acc;
    
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=acc.ID;
    accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
    accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='WEST';
    accountSSD.OLC_Account_Number__c='1234';
    insert accountSSD;
    
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=accountSSD.id;
    oppty.Is_GLI__c =true;
    oppty.Account=acc;
    oppty.Active_Trial__c=true;
    //oppty.hasActiveTrial__c=true;
    oppty.Trial_Opportunity__c=true;
    insert oppty; 
    Ent_Trial__c E1 = new  Ent_Trial__c();
    E1.Convert_to_Sale__c =true;
    E1.Trial_Status__c = 'Active';
    E1.Opportunity__c = oppty.id;
    insert E1;
    Contact oContact = UnitTest.getContactInstance(acc.Id);
    oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
    insert oContact;
    
    List<Product2> productlist=new List<Product2>();
    Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
    Product2 oProductP = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
    Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');  
    //11th Nov

    Product2 prodobj = new Product2();

    prodobj.Name='Sreenu Product Test';
    prodobj.ProductCode = '41972767';
    prodobj.APTS_Media_High_Level_Code__c = '06';
    prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
    prodobj.IsActive = true;
    prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
    prodobj.Service_Number__c ='0';

    productlist.add(oProductC);
    productlist.add(oProductB);
    productlist.add(oProductP);
    productlist.add(prodobj);

    insert productlist;        
    
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
    
    oProposal.Apttus_Proposal__Account__c=acc.id;
    oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
    oProposal.APTS_Proposal_Business_Unit__c='Canada';
    oProposal.APTS_Approval_Segment__c='Canada';
    //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
    oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
    oProposal.Apttus_Proposal__Account__c = acc.Id;
    oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
    oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
    oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;

    insert oProposal;

    List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
    
    APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
    multiacc.APTS_Agreement_Number__c='8923238';  
    multiacc.APTS_Quote_Proposal__c=oProposal .id;
    multiacc.APTS_Status__c='New';
    multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
    quoteAgrLocList.add(multiacc);
    
    APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
    multiacc1.APTS_Agreement_Number__c='8923238';  
    multiacc1.APTS_Quote_Proposal__c=oProposal .id;
    multiacc1.APTS_Status__c='Cancelled';
    //changed to new Subscriber ssd reference instead of old subscriber field
    multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
    quoteAgrLocList.add(multiacc1);
    
    insert quoteAgrLocList;
    
    list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
    Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
    listLineItems.add(li1);
    
    Test.startTest();
    Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
    listLineItems.add(li2);
    insert listLineItems;
    
    
    List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
    Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
    order.Apttus_Config2__Type__c='New';
    order.Apttus_Config2__Status__c='Pending';
    order.APTS_SSD_Sold_To__c=accountSSD.id;
    order.APTS_SSD_bill_to__c=accountSSD.id;
    order.APTS_SSD_Ship_To__c=accountSSD.id;
    order.Apttus_QPConfig__ProposalId__c=oProposal.id;
    orderList.add(order);
    
    insert orderList; 
    List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
    
    Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
    ordlineProf.APTS_Contract_Term__c='5 Years';
    ordlineProf.Apttus_Config2__Quantity__c=1.000;
    ordlineProf.Apttus_Config2__OrderId__c=order.id;
    ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
    ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
    ordlineProf.Apttus_Config2__LineType__c = 'Option';
    ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
    ordlineProf.Apttus_Config2__NetPrice__c = 1728;
    ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
    ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
    ordlineProf.APTS_Program_ID__c = 'WCMP';
    ordlineProf.APTS_Keep_Terms__c = true;
    ordlineProf.apts_mla__c = true;
ordlineProf.APTS_Bridge__c='7 Days';
    ordlineProf.APTS_Deal_Number__c = 12345;
    ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
    ordlineProf.Apttus_Config2__LineStatus__c = 'New';


    ordlineList.add(ordlineProf);
     Apttus_Config2__OrderLineItem__c ordlineProf2 =  new Apttus_Config2__OrderLineItem__c();
    ordlineProf2.APTS_Contract_Term__c='5 Years';
    ordlineProf2.Apttus_Config2__Quantity__c=1.000;
    ordlineProf2.Apttus_Config2__OrderId__c=order.id;
    ordlineProf2.Apttus_Config2__ChargeType__c = 'Standard Price';
    ordlineProf2.Apttus_Config2__PriceType__c = 'One Time';
    ordlineProf2.Apttus_Config2__LineType__c = 'Option';
    ordlineProf2.Apttus_Config2__ProductId__c = prodobj.Id;
    ordlineProf2.Apttus_Config2__NetPrice__c = 1728;
    ordlineProf2.Apttus_Config2__BillingFrequency__c = 'Yearly';
    ordlineProf2.APTS_New_Bridge_Discount__c = 5.00;
    ordlineProf2.APTS_Program_ID__c = 'WCMP';
    ordlineProf2.APTS_Keep_Terms__c = true;
    ordlineProf2.apts_mla__c = true;
ordlineProf2.APTS_Bridge__c='14 Days';
    ordlineProf2.APTS_Deal_Number__c = 12345;
    ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234';
    ordlineProf2.Apttus_Config2__LineStatus__c = 'New';


    ordlineList.add(ordlineProf2);
     Apttus_Config2__OrderLineItem__c ordlineProf3 =  new Apttus_Config2__OrderLineItem__c();
    ordlineProf3.APTS_Contract_Term__c='5 Years';
    ordlineProf3.Apttus_Config2__Quantity__c=1.000;
    ordlineProf3.Apttus_Config2__OrderId__c=order.id;
    ordlineProf3.Apttus_Config2__ChargeType__c = 'Standard Price';
    ordlineProf3.Apttus_Config2__PriceType__c = 'One Time';
    ordlineProf3.Apttus_Config2__LineType__c = 'Option';
    ordlineProf3.Apttus_Config2__ProductId__c = prodobj.Id;
    ordlineProf3.Apttus_Config2__NetPrice__c = 1728;
    ordlineProf3.Apttus_Config2__BillingFrequency__c = 'Yearly';
    ordlineProf3.APTS_New_Bridge_Discount__c = 5.00;
    ordlineProf3.APTS_Program_ID__c = 'WCMP';
    ordlineProf3.APTS_Keep_Terms__c = true;
    ordlineProf3.apts_mla__c = true;
ordlineProf3.APTS_Bridge__c='28 Days';
    ordlineProf3.APTS_Deal_Number__c = 12345;
    ordlineProf3.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
    ordlineProf3.Apttus_Config2__LineStatus__c = 'New';


    ordlineList.add(ordlineProf3);
    
    insert ordlineList;
    
    List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
    Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
    onlineContactList.add(oc1);
    Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
    onlineContactList.add(oc2);
    Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
    onlineContactList.add(oc3); 
    Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
    onlineContactList.add(oc4);
    
    Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
    onlineContactList.add(oc5);
    
    Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
    onlineContactList.add(oc6);
    
    insert onlineContactList;
    
    List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
    Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
    masterContactList.add(mc1);
    Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
    masterContactList.add(mc2);
    Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc3); 
    Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc4);
    Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc5);
    Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc6);
    Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc7);
    insert masterContactList;
    //Test.startTest();
    Decimal D1 = APTS_OrderQueuetoESIUtility.switchToMonthlyAmount('Yearly',1200.0);
    APTS_OrderQueuetoESIUtility.queryoftrialslist(oppty.id);
    System.assertEquals(100.0,D1);       
    Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
    system.debug('order2$$ '+order2);   
    APTS_OrderQueuetoESI.orderSubmissionToESI(order2.id);//Added as part of CRM-9456
    System.assertEquals(1,orderList.size());
    Test.stopTest();
} 
   @isTest
    static void ordersubmissionESI_TK()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;

        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        oppty.Trial_Opportunity__c = true;
        insert oppty; 

        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');  
        //11th Nov

        Product2 prodobj = new Product2();

        prodobj.Name='Sreenu Product Test';
        prodobj.ProductCode = '41972767';
        prodobj.APTS_Media_High_Level_Code__c = '06';
        prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodobj.IsActive = true;
        prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
        prodobj.Service_Number__c ='0';

        productlist.add(oProductC);
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(prodobj);
       
        insert productlist;        
        
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
        
        oProposal.Apttus_Proposal__Account__c=acc.id;
        oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
        oProposal.APTS_Proposal_Business_Unit__c='Canada';
        oProposal.APTS_Approval_Segment__c='Canada';
        //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
        oProposal.Apttus_Proposal__Account__c = acc.Id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
        oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
        oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;

        insert oProposal;

        List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;
         Test.startTest();
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
     
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
    
        ContentVersion cv = new ContentVersion();
           cv.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv.Title = 'signed Demo.pdf'; // Display name of the files
           cv.VersionData = beforeblob; // converting your binary string to Blog
           insert cv;
                        
           Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe = new ContentDocumentLink();
           cDe.ContentDocumentId = conDoc;
           cDe.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe;     
       

        ContentVersion cv1 = new ContentVersion();
           cv1.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv1.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv1.Title = 'CVMS Offer Sheet Demo.pdf'; // Display name of the files
           cv1.VersionData = beforeblob; // converting your binary string to Blog
           insert cv1;
                        
           Id conDoc1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv1.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe1 = new ContentDocumentLink();
           cDe1.ContentDocumentId = conDoc1;
           cDe1.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe1.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe1;
     
     ContentVersion cv2 = new ContentVersion();
           cv2.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv2.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv2.Title = 'Product User Detail Demo.pdf'; // Display name of the files
           cv2.VersionData = beforeblob; // converting your binary string to Blog
           insert cv2;
                        
           Id conDoc2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv2.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe2 = new ContentDocumentLink();
           cDe2.ContentDocumentId = conDoc2;
           cDe2.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe2.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe2;
     
     ContentVersion cv3 = new ContentVersion();
           cv3.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv3.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv3.Title = 'Digital Signature Detail.pdf'; // Display name of the files
           cv3.VersionData = beforeblob; // converting your binary string to Blog
           insert cv3;
                        
           Id conDoc3 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv3.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
      /*     ContentDocumentLink cDe3 = new ContentDocumentLink();
           cDe3.ContentDocumentId = conDoc3;
           cDe3.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe3.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe3;
     
     ContentVersion cv4 = new ContentVersion();
           cv4.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv4.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv4.Title = 'Order Form Demo.pdf'; // Display name of the files
           cv4.VersionData = beforeblob; // converting your binary string to Blog
           insert cv4;
                        
           Id conDoc4 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv4.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe4 = new ContentDocumentLink();
           cDe4.ContentDocumentId = conDoc4;
           cDe4.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe4.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe4;*/
     
     

        List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderList.add(order);
        
        insert orderList; 
        List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='1 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'Recurring';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = true;
        ordlineProf.apts_mla__c = false;
        ordlineProf.APTS_Deal_Number__c = 12345;
        //ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf.Apttus_Config2__LineStatus__c = 'Amended';


        ordlineList.add(ordlineProf);
        
        Apttus_Config2__OrderLineItem__c ordlineProf1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf1.APTS_Contract_Term__c='5 Years';
        ordlineProf1.Apttus_Config2__Quantity__c=1.000;
        ordlineProf1.Apttus_Config2__OrderId__c=order.id;
        ordlineProf1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf1.Apttus_Config2__SellingFrequency__c = 'One Time';
        ordlineProf1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        ordlineProf1.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineProf1.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf1.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf1.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf1.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf1.APTS_Program_ID__c = 'WCMP';
        ordlineProf1.APTS_Keep_Terms__c = false;
        ordlineProf1.apts_mla__c = false;
        ordlineProf1.APTS_Deal_Number__c = 12345;
        //ordlineProf1.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf1.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf1);
        
        Apttus_Config2__OrderLineItem__c ordlineProf2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf2.APTS_Contract_Term__c='5 Years';
        ordlineProf2.Apttus_Config2__Quantity__c=1.000;
        ordlineProf2.Apttus_Config2__OrderId__c=order.id;
        ordlineProf2.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf2.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf2.Apttus_Config2__SellingFrequency__c = 'One Time';
        ordlineProf2.Apttus_Config2__PriceMethod__c = 'Flat Price';
        ordlineProf2.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineProf2.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf2.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf2.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf2.APTS_Program_ID__c = 'WCMP';
        ordlineProf2.APTS_Keep_Terms__c = false;
        ordlineProf2.apts_mla__c = false;
        ordlineProf2.APTS_Deal_Number__c = NULL;
        //ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf2.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf2);
        Apttus_Config2__OrderLineItem__c ordlineProf3 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf3.APTS_Contract_Term__c='5 Years';
        ordlineProf3.Apttus_Config2__Quantity__c=1.000;
        ordlineProf3.Apttus_Config2__OrderId__c=order.id;
        ordlineProf3.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf3.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf3.Apttus_Config2__SellingFrequency__c = 'One Time';
        ordlineProf3.Apttus_Config2__PriceMethod__c = 'Flat Price';
        ordlineProf3.Apttus_Config2__LineType__c = 'Product/Service';
        ordlineProf3.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf3.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf3.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf3.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf3.APTS_Program_ID__c = 'WCMP';
        ordlineProf3.APTS_Keep_Terms__c = true;
        ordlineProf3.apts_mla__c = false;
        ordlineProf3.APTS_Deal_Number__c = 12346;
        //ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf3.Apttus_Config2__LineStatus__c = 'Renewed';

        ordlineList.add(ordlineProf3);   
     
        insert ordlineList;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc5);
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc6);
     
       Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc7); 
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc8); 
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc9); 
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc10); 
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc11); 
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc12); 
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc13); 
   Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc14); 
   Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc15);
   Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc16);
   Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Tax Professional',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc17);
   Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c);
   onlineContactList.add(oc18);
        
        insert onlineContactList;
        
        List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
        masterContactList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
        masterContactList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
        masterContactList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc5);
        Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc6);
        Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        masterContactList.add(mc7);
        insert masterContactList;
        //Test.startTest();
                        
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
        system.debug('order2$$ '+order2);   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);//Added as part of CRM-9456
        System.assertEquals(1,orderList.size());
        Test.stopTest();        
    }
    
    /**static testmethod void digitalPaymentTerm()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='testWCMP';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;  
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='WCMP';
        con.FirstName='Bundle';
        insert con;
        
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = new Product2(Name='Primary Product', ProductCode = '1234568978965', APTS_Corporate_Select__c = 'Primary');
        Product2 oProductP = new Product2(Name='Option Product', ProductCode = '1234568978966', APTS_Corporate_Select__c = 'Module');
        Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9');
        //Product2 oProduct6 = new Product2(Name='Standard Product6', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='05',APTS_Media_Lower_Level_Code__c='E2');
        Product2 oProductProf = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG');
        Product2 ProductN = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG',APTS_Corporate_Select__c = 'Primary');
        Product2 ProductNN = new Product2(Name='Sreenu Product Test', ProductCode = '40666420', APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Each',APTS_Item_Category_Group__c='ZPKG',APTS_Corporate_Select__c = 'Module');
        productlist.add(oProductB);
        productlist.add(oProductP);
        productlist.add(oProductS);
        productlist.add(oProductProf);
        productlist.add(ProductN);
        productlist.add(ProductNN);
        insert productlist;
        
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test',
            APTS_Proposal_Business_Unit__c='SCS',
            APTS_Approval_Segment__c='Corporate Emerging',
            APTS_Order_Confirmation_Contact__c=con.id,
            APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
            Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,
            APTS_Payment_Option__c='Autopay', 
            Apttus_Proposal__Payment_Term__c = 'D030',
            APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
        //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)');
        insert oProposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
        insert prodConfig;
        List<Apttus_Config2__Order__c> ordLists =new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Ready for Activation';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order.Apttus_Config2__Status__c='Pending';
        order.Retry_Count__c = 2;
        insert order;        
        ordLists.add(order);
        
        List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItemP =  new Apttus_Config2__LineItem__c();
        lineItemP.APTS_Group_Primary_Material__c= '40666420';
        lineItemP.Apttus_Config2__LineStatus__c = 'New';  
        lineItemP.APTS_Group__c = 'Bundle A';
        lineItemP.APTS_Contract_Number__c = 123456;
        lineItemP.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemP.Apttus_Config2__ItemSequence__c = 1;
        lineItemP.Apttus_Config2__LineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductId__c = oProductB.Id;   
        lineItemP.APTS_is_Primary_in_Bundle__c = true;     
        lineItemP.Apttus_Config2__AddedBy__c = 'User';
        lineItemP.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemP.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemP.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemP.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemP.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemP.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemP.Apttus_Config2__AllowProration__c = FALSE;
        lineItemP.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemP.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemP.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemP.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemP.Apttus_Config2__BasePrice__c = 100;
        lineItemP.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemP.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemP.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemP.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemP.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemP.Apttus_Config2__Customizable__c = FALSE;
        lineItemP.Apttus_Config2__DeltaPrice__c = 50;
        lineItemP.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemP.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemP.Apttus_Config2__ExtendedCost__c = 0;
        lineItemP.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemP.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemP.Apttus_Config2__Guidance__c = 'Red';
        lineItemP.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemP.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemP.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemP.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemP.Apttus_Config2__HasOptions__c = FALSE;
        lineItemP.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemP.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemP.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemP.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemP.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemP.Apttus_Config2__IsHidden__c = FALSE;
        lineItemP.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemP.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemP.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemP.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemP.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemP.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemP.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemP.Apttus_Config2__LineSequence__c = 1;
        lineItemP.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemP.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemP.Apttus_Config2__ListPrice__c = 100;
        lineItemP.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemP.Apttus_Config2__NetPrice__c = 50;
        lineItemP.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemP.Apttus_Config2__OptionSequence__c = 0;
        lineItemP.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemP.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemP.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemP.Apttus_Config2__PriceUom__c = 'Each';
        lineItemP.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemP.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductVersion__c = 1;
        lineItemP.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemP.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemP.Apttus_Config2__SellingTerm__c = 1;
        lineItemP.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemP.Apttus_Config2__Taxable__c = FALSE;
        lineItemP.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemP.Apttus_Config2__Term__c = 1;
        lineItemP.Apttus_Config2__TotalQuantity__c = 1;
        lineItemP.Apttus_Config2__Uom__c = 'Each';
        lineItemP.CurrencyIsoCode = 'USD';
        lineItemP.APTS_Product_Family__c = 'WESTLAW';
        lineItemP.APTS_Contract_Term__c = '2 Years';
        lineItemP.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemP.APTS_Product_Delivery__c = 'Online/Internet';  
        liList.add(lineItemP);
        
        Apttus_Config2__LineItem__c lineItemo =  new Apttus_Config2__LineItem__c();
        lineItemo.APTS_Group_Primary_Material__c= '40666420';
        lineItemo.Apttus_Config2__LineStatus__c = 'New';  
        lineItemo.APTS_Group__c = 'Bundle A';
        lineItemo.APTS_Contract_Number__c = 123456;
        lineItemo.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemo.Apttus_Config2__ItemSequence__c = 1;
        lineItemo.Apttus_Config2__LineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductId__c = oProductP.Id;    
        lineItemo.APTS_is_Primary_in_Bundle__c = true;    
        lineItemo.Apttus_Config2__AddedBy__c = 'User';
        lineItemo.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemo.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemo.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemo.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemo.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowProration__c = FALSE;
        lineItemo.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemo.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemo.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemo.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__BasePrice__c = 100;
        lineItemo.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemo.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemo.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemo.Apttus_Config2__Customizable__c = FALSE;
        lineItemo.Apttus_Config2__DeltaPrice__c = 50;
        lineItemo.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemo.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemo.Apttus_Config2__ExtendedCost__c = 0;
        lineItemo.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemo.Apttus_Config2__Guidance__c = 'Red';
        lineItemo.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemo.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemo.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemo.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemo.Apttus_Config2__HasOptions__c = FALSE;
        lineItemo.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemo.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemo.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemo.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsHidden__c = FALSE;
        lineItemo.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemo.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemo.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemo.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemo.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemo.Apttus_Config2__LineSequence__c = 1;
        lineItemo.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemo.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemo.Apttus_Config2__ListPrice__c = 100;
        lineItemo.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemo.Apttus_Config2__NetPrice__c = 50;
        lineItemo.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemo.Apttus_Config2__OptionSequence__c = 0;
        lineItemo.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemo.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemo.Apttus_Config2__PriceUom__c = 'Each';
        lineItemo.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemo.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductVersion__c = 1;
        lineItemo.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemo.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__SellingTerm__c = 1;
        lineItemo.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemo.Apttus_Config2__Taxable__c = FALSE;
        lineItemo.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemo.Apttus_Config2__Term__c = 1;
        lineItemo.Apttus_Config2__TotalQuantity__c = 1;
        lineItemo.Apttus_Config2__Uom__c = 'Each';
        lineItemo.CurrencyIsoCode = 'USD';
        lineItemo.APTS_Product_Family__c = 'WESTLAW';
        lineItemo.APTS_Contract_Term__c = '2 Years';
        lineItemo.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemo.APTS_Product_Delivery__c = 'Online/Internet';
  
        liList.add(lineItemo);
        
        Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
        lineItemS.APTS_Group_Primary_Material__c= '40666420';
        lineItemS.Apttus_Config2__LineStatus__c = 'New';  
        lineItemS.APTS_Group__c = 'Bundle A';
        lineItemS.APTS_Contract_Number__c = 123456;
        lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemS.Apttus_Config2__ItemSequence__c = 1;
        lineItemS.Apttus_Config2__LineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductId__c = oProductS.Id;   
        lineItemS.APTS_is_Primary_in_Bundle__c = true;
        lineItemS.Apttus_Config2__AddedBy__c = 'User';
        lineItemS.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemS.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemS.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemS.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemS.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowProration__c = FALSE;
        lineItemS.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemS.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemS.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemS.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__BasePrice__c = 100;
        lineItemS.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemS.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemS.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemS.Apttus_Config2__Customizable__c = FALSE;
        lineItemS.Apttus_Config2__DeltaPrice__c = 50;
        lineItemS.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemS.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemS.Apttus_Config2__ExtendedCost__c = 0;
        lineItemS.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemS.Apttus_Config2__Guidance__c = 'Red';
        lineItemS.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemS.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemS.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemS.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemS.Apttus_Config2__HasOptions__c = FALSE;
        lineItemS.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemS.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemS.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemS.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsHidden__c = FALSE;
        lineItemS.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemS.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemS.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemS.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemS.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemS.Apttus_Config2__LineSequence__c = 1;
        lineItemS.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemS.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemS.Apttus_Config2__ListPrice__c = 100;
        lineItemS.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemS.Apttus_Config2__NetPrice__c = 50;
        lineItemS.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemS.Apttus_Config2__OptionSequence__c = 0;
        lineItemS.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemS.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemS.Apttus_Config2__PriceUom__c = 'Each';
        lineItemS.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemS.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductVersion__c = 1;
        lineItemS.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemS.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__SellingTerm__c = 1;
        lineItemS.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemS.Apttus_Config2__Taxable__c = FALSE;
        lineItemS.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemS.Apttus_Config2__Term__c = 1;
        lineItemS.Apttus_Config2__TotalQuantity__c = 1;
        lineItemS.Apttus_Config2__Uom__c = 'Each';
        lineItemS.CurrencyIsoCode = 'USD';
        lineItemS.APTS_Product_Family__c = 'WESTLAW';
        lineItemS.APTS_Contract_Term__c = '2 Years';
        lineItemS.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemS.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItemS);
        
        Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle A';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.APTS_Deal_Type__c = 'WCMPS';
        lineItem.APTS_is_Primary_in_Bundle__c = true;
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';

        liList.add(lineItem);
        
        Apttus_Config2__LineItem__c lineItem2 =  new Apttus_Config2__LineItem__c();
        lineItem2.APTS_Group_Primary_Material__c= '40666420';
        lineItem2.Apttus_Config2__LineStatus__c = 'Amended';  
        lineItem2.APTS_Group__c = 'Bundle A';
        lineItem2.APTS_Contract_Number__c = 1234564;
        lineItem2.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem2.Apttus_Config2__ItemSequence__c = 1;
        lineItem2.Apttus_Config2__LineNumber__c = 2;
        lineItem2.APTS_Deal_Type__c ='WCMP';
        lineItem2.APTS_is_Primary_in_Bundle__c = true;
        lineItem2.Apttus_Config2__AddedBy__c = 'User';
        lineItem2.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem2.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowProration__c = FALSE;
        lineItem2.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem2.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem2.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem2.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__BasePrice__c = 100;
        lineItem2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem2.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem2.Apttus_Config2__Customizable__c = FALSE;
        lineItem2.Apttus_Config2__DeltaPrice__c = 50;
        lineItem2.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem2.Apttus_Config2__ExtendedCost__c = 0;
        lineItem2.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem2.Apttus_Config2__Guidance__c = 'Red';
        lineItem2.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem2.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem2.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem2.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem2.Apttus_Config2__HasOptions__c = FALSE;
        lineItem2.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem2.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem2.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsHidden__c = FALSE;
        lineItem2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem2.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem2.Apttus_Config2__LineSequence__c = 1;
        lineItem2.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem2.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem2.Apttus_Config2__ListPrice__c = 100;
        lineItem2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem2.Apttus_Config2__NetPrice__c = 50;
        lineItem2.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem2.Apttus_Config2__OptionSequence__c = 0;
        lineItem2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem2.Apttus_Config2__PriceUom__c = 'Each';
        lineItem2.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem2.Apttus_Config2__ProductVersion__c = 1;
        lineItem2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__SellingTerm__c = 1;
        lineItem2.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem2.Apttus_Config2__Taxable__c = FALSE;
        lineItem2.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem2.Apttus_Config2__Term__c = 1;
        lineItem2.Apttus_Config2__TotalQuantity__c = 1;
        lineItem2.Apttus_Config2__Uom__c = 'Each';
        lineItem2.CurrencyIsoCode = 'USD';
        lineItem2.APTS_Product_Family__c = 'WESTLAW';
        lineItem2.APTS_Contract_Term__c = '2 Years';
        lineItem2.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem2.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem2);
        
        Apttus_Config2__LineItem__c lineItem3 =  new Apttus_Config2__LineItem__c();
        lineItem3.APTS_Group_Primary_Material__c= '40666420';
        lineItem3.Apttus_Config2__LineStatus__c = 'New';  
        lineItem3.APTS_Group__c = 'Bundle A';
        lineItem3.APTS_Contract_Number__c = 1234564;
        lineItem3.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem3.Apttus_Config2__ItemSequence__c = 1;
        lineItem3.Apttus_Config2__LineNumber__c = 3;
        lineItem3.APTS_is_Primary_in_Bundle__c = true;
        lineItem3.Apttus_Config2__AddedBy__c = 'User';
        lineItem3.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem3.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem3.Apttus_Config2__AllowProration__c = FALSE;
        lineItem3.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem3.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem3.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem3.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem3.Apttus_Config2__BasePrice__c = 100;
        lineItem3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem3.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem3.Apttus_Config2__Customizable__c = FALSE;
        lineItem3.Apttus_Config2__DeltaPrice__c = 50;
        lineItem3.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem3.Apttus_Config2__ExtendedCost__c = 0;
        lineItem3.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem3.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem3.Apttus_Config2__Guidance__c = 'Red';
        lineItem3.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem3.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem3.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem3.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem3.Apttus_Config2__HasOptions__c = FALSE;
        lineItem3.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem3.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem3.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem3.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem3.Apttus_Config2__IsHidden__c = FALSE;
        lineItem3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem3.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem3.Apttus_Config2__LineSequence__c = 1;
        lineItem3.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem3.Apttus_Config2__ListPrice__c = 100;
        lineItem3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem3.Apttus_Config2__NetPrice__c = 50;
        lineItem3.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem3.Apttus_Config2__OptionSequence__c = 0;
        lineItem3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem3.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem3.Apttus_Config2__PriceUom__c = 'Each';
        lineItem3.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem3.Apttus_Config2__ProductVersion__c = 1;
        lineItem3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem3.Apttus_Config2__SellingTerm__c = 1;
        lineItem3.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem3.Apttus_Config2__Taxable__c = FALSE;
        lineItem3.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem3.Apttus_Config2__Term__c = 1;
        lineItem3.Apttus_Config2__TotalQuantity__c = 1;
        lineItem3.Apttus_Config2__Uom__c = 'Each';
        lineItem3.CurrencyIsoCode = 'USD';
        lineItem3.APTS_Product_Family__c = 'WESTLAW';
        lineItem3.APTS_Contract_Term__c = '2 Years';
        lineItem3.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem3.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem3);
        
        Apttus_Config2__LineItem__c lineItem4 =  new Apttus_Config2__LineItem__c();
        lineItem4.Apttus_Config2__LineStatus__c = 'New';  
        lineItem4.APTS_Group__c = 'Bundle A';
        lineItem4.APTS_Contract_Number__c = 1234564;
        lineItem4.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem4.Apttus_Config2__ItemSequence__c = 1;
        lineItem4.Apttus_Config2__LineNumber__c = 4;  
        lineItem4.APTS_is_Primary_in_Bundle__c = true;  
        lineItem4.Apttus_Config2__AddedBy__c = 'User';
        lineItem4.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem4.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem4.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem4.Apttus_Config2__AllowProration__c = FALSE;
        lineItem4.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem4.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem4.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem4.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem4.Apttus_Config2__BasePrice__c = 100;
        lineItem4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem4.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem4.Apttus_Config2__Customizable__c = FALSE;
        lineItem4.Apttus_Config2__DeltaPrice__c = 50;
        lineItem4.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem4.Apttus_Config2__ExtendedCost__c = 0;
        lineItem4.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem4.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem4.Apttus_Config2__Guidance__c = 'Red';
        lineItem4.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem4.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem4.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem4.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem4.Apttus_Config2__HasOptions__c = FALSE;
        lineItem4.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem4.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem4.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem4.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem4.Apttus_Config2__IsHidden__c = FALSE;
        lineItem4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem4.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem4.Apttus_Config2__LineSequence__c = 1;
        lineItem4.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem4.Apttus_Config2__ListPrice__c = 100;
        lineItem4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem4.Apttus_Config2__NetPrice__c = 50;
        lineItem4.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem4.Apttus_Config2__OptionSequence__c = 0;
        lineItem4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem4.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem4.Apttus_Config2__PriceUom__c = 'Each';
        lineItem4.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem4.Apttus_Config2__ProductVersion__c = 1;
        lineItem4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem4.Apttus_Config2__SellingTerm__c = 1;
        lineItem4.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem4.Apttus_Config2__Taxable__c = FALSE;
        lineItem4.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem4.Apttus_Config2__Term__c = 1;
        lineItem4.Apttus_Config2__TotalQuantity__c = 1;
        lineItem4.Apttus_Config2__Uom__c = 'Each';
        lineItem4.CurrencyIsoCode = 'USD';
        lineItem4.APTS_Product_Family__c = 'WESTLAW';
        lineItem4.APTS_Contract_Term__c = '2 Years';
        lineItem4.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem4.APTS_Product_Delivery__c = 'Online/Internet';    
        liList.add(lineItem4);
        
        Apttus_Config2__LineItem__c lineItem5 =  new Apttus_Config2__LineItem__c();
        lineItem5.APTS_Group_Primary_Material__c= '40666420';
        lineItem5.Apttus_Config2__LineStatus__c = 'New';  
        //lineItem4.APTS_Group__c = 'Bundle A';
        lineItem5.APTS_Contract_Number__c = 1234564;
        lineItem5.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem5.Apttus_Config2__ItemSequence__c = 1;
        lineItem5.Apttus_Config2__LineNumber__c = 5;
        lineItem5.APTS_is_Primary_in_Bundle__c = true;
        lineItem5.Apttus_Config2__AddedBy__c = 'User';
        lineItem5.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem5.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem5.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowProration__c = FALSE;
        lineItem5.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem5.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem5.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem5.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__BasePrice__c = 100;
        lineItem5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem5.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem5.Apttus_Config2__Customizable__c = FALSE;
        lineItem5.Apttus_Config2__DeltaPrice__c = 50;
        lineItem5.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem5.Apttus_Config2__ExtendedCost__c = 0;
        lineItem5.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem5.Apttus_Config2__Guidance__c = 'Red';
        lineItem5.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem5.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem5.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem5.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem5.Apttus_Config2__HasOptions__c = FALSE;
        lineItem5.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem5.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem5.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsHidden__c = FALSE;
        lineItem5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem5.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem5.Apttus_Config2__LineSequence__c = 1;
        lineItem5.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem5.Apttus_Config2__ListPrice__c = 100;
        lineItem5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem5.Apttus_Config2__NetPrice__c = 50;
        lineItem5.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem5.Apttus_Config2__OptionSequence__c = 0;
        lineItem5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem5.Apttus_Config2__PriceUom__c = 'Each';
        lineItem5.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem5.Apttus_Config2__ProductVersion__c = 1;
        lineItem5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__SellingTerm__c = 1;
        lineItem5.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem5.Apttus_Config2__Taxable__c = FALSE;
        lineItem5.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem5.Apttus_Config2__Term__c = 1;
        lineItem5.Apttus_Config2__TotalQuantity__c = 1;
        lineItem5.Apttus_Config2__Uom__c = 'Each';
        lineItem5.CurrencyIsoCode = 'USD';
        lineItem5.APTS_Product_Family__c = 'WESTLAW';
        lineItem5.APTS_Contract_Term__c = '2 Years';
        lineItem5.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem5.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItem5);
        
        Apttus_Config2__LineItem__c lineItemN =  new Apttus_Config2__LineItem__c();
        lineItemN.APTS_Group_Primary_Material__c= '40666420';
        lineItemN.Apttus_Config2__LineStatus__c = 'New';  
        lineItemN.APTS_Group__c = 'Bundle A';
        lineItemN.APTS_Contract_Number__c = 1234564;
        lineItemN.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemN.Apttus_Config2__ItemSequence__c = 1;
        lineItemN.Apttus_Config2__LineNumber__c = 6;
        lineItemN.Apttus_Config2__ProductId__c = productN.Id;
        lineItemN.APTS_is_Primary_in_Bundle__c = true;
        lineItemN.Apttus_Config2__AddedBy__c = 'User';
        lineItemN.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemN.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemN.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemN.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemN.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemN.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemN.Apttus_Config2__AllowProration__c = FALSE;
        lineItemN.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemN.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemN.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemN.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemN.Apttus_Config2__BasePrice__c = 100;
        lineItemN.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemN.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemN.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemN.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemN.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemN.Apttus_Config2__Customizable__c = FALSE;
        lineItemN.Apttus_Config2__DeltaPrice__c = 50;
        lineItemN.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemN.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemN.Apttus_Config2__ExtendedCost__c = 0;
        lineItemN.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemN.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemN.Apttus_Config2__Guidance__c = 'Red';
        lineItemN.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemN.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemN.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemN.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemN.Apttus_Config2__HasOptions__c = FALSE;
        lineItemN.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemN.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemN.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemN.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemN.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemN.Apttus_Config2__IsHidden__c = FALSE;
        lineItemN.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemN.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemN.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemN.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemN.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemN.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemN.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemN.Apttus_Config2__LineSequence__c = 1;
        lineItemN.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemN.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemN.Apttus_Config2__ListPrice__c = 100;
        lineItemN.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemN.Apttus_Config2__NetPrice__c = 50;
        lineItemN.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemN.Apttus_Config2__OptionSequence__c = 0;
        lineItemN.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemN.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemN.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemN.Apttus_Config2__PriceUom__c = 'Each';
        lineItemN.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemN.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemN.Apttus_Config2__ProductVersion__c = 1;
        lineItemN.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemN.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemN.Apttus_Config2__SellingTerm__c = 1;
        lineItemN.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemN.Apttus_Config2__Taxable__c = FALSE;
        lineItemN.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemN.Apttus_Config2__Term__c = 1;
        lineItemN.Apttus_Config2__TotalQuantity__c = 1;
        lineItemN.Apttus_Config2__Uom__c = 'Each';
        lineItemN.CurrencyIsoCode = 'USD';
        lineItemN.APTS_Product_Family__c = 'WESTLAW';
        lineItemN.APTS_Contract_Term__c = '2 Years';
        lineItemN.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemN.APTS_Product_Delivery__c = 'Online/Internet';

        liList.add(lineItemN);

        Apttus_Config2__LineItem__c lineItemNN =  new Apttus_Config2__LineItem__c();
        lineItemNN.APTS_Group_Primary_Material__c= '40666420';
        lineItemNN.Apttus_Config2__LineStatus__c = 'New';  
        lineItemNN.APTS_Group__c = 'Bundle A';
        lineItemNN.APTS_Contract_Number__c = 1234564;
        lineItemNN.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemNN.Apttus_Config2__ItemSequence__c = 1;
        lineItemNN.Apttus_Config2__LineNumber__c = 6;
        lineItemNN.Apttus_Config2__ProductId__c = productNN.Id;
        lineItemNN.APTS_is_Primary_in_Bundle__c = true;
        lineItemNN.Apttus_Config2__AddedBy__c = 'User';
        lineItemNN.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemNN.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemNN.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemNN.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemNN.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemNN.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemNN.Apttus_Config2__AllowProration__c = FALSE;
        lineItemNN.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemNN.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemNN.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemNN.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemNN.Apttus_Config2__BasePrice__c = 100;
        lineItemNN.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemNN.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemNN.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemNN.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemNN.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemNN.Apttus_Config2__Customizable__c = FALSE;
        lineItemNN.Apttus_Config2__DeltaPrice__c = 50;
        lineItemNN.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemNN.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemNN.Apttus_Config2__ExtendedCost__c = 0;
        lineItemNN.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemNN.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemNN.Apttus_Config2__Guidance__c = 'Red';
        lineItemNN.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemNN.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemNN.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemNN.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemNN.Apttus_Config2__HasOptions__c = FALSE;
        lineItemNN.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemNN.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemNN.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemNN.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemNN.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemNN.Apttus_Config2__IsHidden__c = FALSE;
        lineItemNN.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemNN.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemNN.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemNN.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemNN.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemNN.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemNN.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemNN.Apttus_Config2__LineSequence__c = 1;
        lineItemNN.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemNN.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemNN.Apttus_Config2__ListPrice__c = 100;
        lineItemNN.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemNN.Apttus_Config2__NetPrice__c = 50;
        lineItemNN.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemNN.Apttus_Config2__OptionSequence__c = 0;
        lineItemNN.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemNN.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemNN.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemNN.Apttus_Config2__PriceUom__c = 'Each';
        lineItemNN.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemNN.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemNN.Apttus_Config2__ProductVersion__c = 1;
        lineItemNN.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemNN.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemNN.Apttus_Config2__SellingTerm__c = 1;
        lineItemNN.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemNN.Apttus_Config2__Taxable__c = FALSE;
        lineItemNN.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemNN.Apttus_Config2__Term__c = 1;
        lineItemNN.Apttus_Config2__TotalQuantity__c = 1;
        lineItemNN.Apttus_Config2__Uom__c = 'Each';
        lineItemNN.CurrencyIsoCode = 'USD';
        lineItemNN.APTS_Product_Family__c = 'WESTLAW';
        lineItemNN.APTS_Contract_Term__c = '2 Years';
        lineItemNN.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemNN.APTS_Product_Delivery__c = 'Online/Internet';
        liList.add(lineItemNN);
            
        //Added newly 11th Nov
        
        APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
        dynamicbundlewm.APTS_Group__c='Bundle A';
        dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm.APTS_Keep_Terms__c=true;
        dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewm.APTS_Deal_Number__c = 623589;
        dynamicbundlewm.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm.APTS_Bridge_Length__c = 2;
        dynamicbundlewm.APTS_Bridge__c = '28 Days';
        dynamicbundlewm.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewm;
        
        APTS_Dynamic_Bundle__c dynamicbundlewm2 = new APTS_Dynamic_Bundle__c();
        dynamicbundlewm2.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewm2.APTS_Program_ID__c= 'WCMP';  
        dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewm2.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewm2.APTS_Keep_Terms__c=false;
        dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewm.APTS_Deal_Number__c = 623589;
        dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewm2.APTS_Bridge_Length__c = 2;
        dynamicbundlewm2.APTS_Bridge__c = '14 Days';
        dynamicbundlewm2.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewm2;  
        
        APTS_Dynamic_Bundle__c dynamicbundlewmK = new APTS_Dynamic_Bundle__c();
        dynamicbundlewmK.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewmK.APTS_Program_ID__c= 'WCMP';  
        //dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewmK.APTS_Quote_Proposal__c=oProposal.id;
        //dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        //dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewmK.APTS_Keep_Terms__c=false;
        //dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        //dynamicbundlewmK.APTS_Deal_Number__c = 623589;
        //dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewmK.APTS_Bridge_Length__c = 2;
        dynamicbundlewmK.APTS_Bridge__c = '14 Days';
        dynamicbundlewmk.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewmK;
        
        APTS_Dynamic_Bundle__c dynamicbundlewmF = new APTS_Dynamic_Bundle__c();
        dynamicbundlewmF.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundlewmF.APTS_Program_ID__c= 'WCMP';  
        //dynamicbundlewm2.APTS_Group__c='Bundle B';
        dynamicbundlewmF.APTS_Quote_Proposal__c=oProposal.id;
        //dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
        //dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
        dynamicbundlewmF.APTS_Keep_Terms__c=false;
        //dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
        dynamicbundlewmF.APTS_Deal_Number__c = 623589;
        //dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
        dynamicbundlewmF.APTS_Bridge_Length__c = 2;
        dynamicbundlewmF.APTS_Bridge__c = '14 Days';
        dynamicbundlewmF.APTS_isBLINotCreated__c= true;
        insert dynamicbundlewmF;
        
        Test.startTest(); 
        insert liList;
        Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
        APTS_OrderQueuetoESI.orderSubmissionToESI(order2.Id);
        System.assertEquals(1,ordLists.size());
        
        Test.stopTest();
        
    }*/
    static testmethod void ordersubmissionESI_TAN()
    {   List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
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
        
        KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(LCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.Name='ABC2';
        accountSSD2.Source_System_Name__c='ABC';
        accountSSD2.Account_Name__c=acc.ID;
        accountSSD2.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='WEST';
        insert accountSSD2;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty; 
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='Prabhu';
        con.FirstName='Issac';
        insert con;
        
        List<Product2> prodlist = new List<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test Patron', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'P7',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',Apttus_Filter_Brand_Code__c = '064'); //DOC-12198 added FilterCode
        Product2 oProductB1 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06',APTS_Media_Lower_Level_Code__c = 'I9', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP1 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='07',APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductB2 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP2 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
        Product2 prodObj = new Product2();
        prodObj.Name = 'West Proflex';
        prodObj.ProductCode= '40757482';
        prodObj.APTS_Media_High_Level_Code__c = '06';
        prodObj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObj.IsActive=true;
        prodObj.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObj.Service_Number__c='0';
        prodlist.add(prodObj);    
        prodlist.add(oProductB);
        prodlist.add(oProductP);
        prodlist.add(oProductB1);
        prodlist.add(oProductP1);
        prodlist.add(oProductB2);
        prodlist.add(oProductP2);
        insert prodlist;
        
        Test.startTest();     
        // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Proposal_Business_Unit__c='FindLaw',APTS_Approval_Segment__c='FindLaw',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert oProposal;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li3);
        Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li4);
        Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li5);
        Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li6);
        
        insert listLineItems;
        
        List<Apttus_Config2__Order__c> ordLists = new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        //order.Apttus_Config2__Status__c='Ready for Activation';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SSD_Sold_To__c=accountSSD.id;
        order.APTS_SSD_bill_to__c=accountSSD.id;
        order.APTS_SSD_Ship_To__c=accountSSD.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        insert order;
        ordLists.add(order);
        List<Apttus_Config2__OrderLineItem__c> orderLineList=new List<Apttus_Config2__OrderLineItem__c>();
        
        Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
        ordline.APTS_Contract_Term__c='1 Year';
        ordline.Apttus_Config2__OrderId__c=order.id;
        ordline.Apttus_Config2__LineStatus__c='Cancelled'; 
        ordline.Apttus_Config2__Quantity__c=1.000;
        ordline.Apttus_Config2__ProductId__c=oProductB.id;
        ordline.APTS_Group__c='Bundle A';  
        ordline.APTS_Bridge__c='1 Month';
        ordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordline.APTS_SAP_MLA_Agreement_Number__c = '123456'; 
        ordline.APTS_Service_Number__c = '40757482';
        orderLineList.add(ordline);         
        
        insert orderLineList;
        
        List<Attachment> attList=new List<Attachment>();
        
        Attachment att = new Attachment();
        att.Name='signed';
        att.ParentId=oProposal.id;
        att.body=blob.valueof('test');
        attList.add(att);
        
        Attachment att1 = new Attachment();
        att1.Name='Order Form';
        att1.body=blob.valueof('test2');
        att1.ParentId=oProposal.id;
        attList.add(att1);
        
        Attachment att2 = new Attachment();
        att2.Name='CVMS Offer Sheet';
        att2.body=blob.valueof('test2');
        att2.ParentId=oProposal.id;
        attList.add(att2);
        
        insert attList;
        
        List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;
        
        List<APTS_Dynamic_Bundle__c> dymBundle=new List<APTS_Dynamic_Bundle__c>();
        
        APTS_Dynamic_Bundle__c dynamicbundle11 = new APTS_Dynamic_Bundle__c();
        dynamicbundle11.APTS_Bundle_Primary_Material__c='1111';
        dynamicbundle11.APTS_Group__c='Bundle A';
        dynamicbundle11.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle11.APTS_Contract_Terms__c='3 Years';
        dynamicbundle11.APTS_YoY_2_Plus__c='1';
        dynamicbundle11.APTS_Keep_Terms__c=true;
        dynamicbundle11.APTS_MLA_Agreement_Number__c='';
        dynamicbundle11.APTS_Bridge_Discount__c = '100';
        dynamicbundle11.APTS_Decentralized__c = true;
        dynamicbundle11.APTS_isBLINotCreated__c= true;
        dynamicbundle11.APTS_Billing_Frequency__c='Yearly';
        dymBundle.add(dynamicbundle11);
        
        APTS_Dynamic_Bundle__c dynamicbundle12 = new APTS_Dynamic_Bundle__c();
        dynamicbundle12.APTS_Bundle_Primary_Material__c='1111';        
        dynamicbundle12.APTS_Group__c='Bundle A';
        dynamicbundle12.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundle12.APTS_Contract_Terms__c='3 Years';
        dynamicbundle12.APTS_YoY_2_Plus__c='1';
        dynamicbundle12.APTS_Keep_Terms__c=false;
        dynamicbundle12.APTS_MLA__c = true;
        dynamicbundle12.APTS_MLA_Agreement_Number__c=''; 
        dynamicbundle12.APTS_isBLINotCreated__c= true;
        dymBundle.add(dynamicbundle12); 
        
        APTS_Dynamic_Bundle__c dynamicbundleNEW = new APTS_Dynamic_Bundle__c();
        dynamicbundleNEW.APTS_Bundle_Primary_Material__c='1111';        
        dynamicbundleNEW.APTS_Group__c='Bundle AB';
        dynamicbundleNEW.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundleNEW.APTS_Contract_Terms__c='3 Years';
        dynamicbundleNEW.APTS_YoY_2_Plus__c='1';
        dynamicbundleNEW.APTS_Keep_Terms__c=true;
        dynamicbundleNEW.APTS_MLA__c = true;        
        dynamicbundleNEW.APTS_MLA_Agreement_Number__c='123456'; 
        dynamicbundleNEW.APTS_Decentralized__c = true;
        dynamicbundleNEW.APTS_isBLINotCreated__c= true;
        dymBundle.add(dynamicbundleNEW); 
        
        //Added newly
        APTS_Dynamic_Bundle__c dynamicbundleMTP = new APTS_Dynamic_Bundle__c();
        dynamicbundleMTP.APTS_Bundle_Primary_Material__c='1111';        
        dynamicbundleMTP.APTS_Group__c='Bundle AB';
        dynamicbundleMTP.APTS_Quote_Proposal__c=oProposal.id;
        dynamicbundleMTP.APTS_Contract_Terms__c='3 Years';
        dynamicbundleMTP.APTS_YoY_2_Plus__c='1';
        dynamicbundleMTP.APTS_Keep_Terms__c=true;
        dynamicbundleMTP.APTS_MLA__c = false;        
        dynamicbundleMTP.APTS_MLA_Agreement_Number__c='123456'; 
        dynamicbundleMTP.APTS_Decentralized__c = true;
        dynamicbundleMTP.APTS_isBLINotCreated__c= true;
        dymBundle.add(dynamicbundleMTP);
        
        insert dymBundle;
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c , First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc.APTS_Subscriber_Location__c,Type__c= 'Admin');    //DOC-12198 added Type = Admin
        oc1.APTS_Source_System_Detail__c = accountSSD.ID;
        oc1.Is_Banded_Product__c = true;
        onlineContactList.add(oc1);
        
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD2.id);
        oc2.APTS_Source_System_Detail__c = accountSSD.ID;
        oc2.Is_Banded_Product__c = true;
        onlineContactList.add(oc2);
        
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu1', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD2.id);
        oc3.APTS_Source_System_Detail__c = accountSSD.ID;
        oc3.Is_Banded_Product__c = true;
        onlineContactList.add(oc3); 
        
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc4.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc4);   
        
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True,Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc5.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc5);  
        
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc6.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc6);
        
        //Added DOC-12198
        Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc7.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc7);
        
        Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc8.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc8);
        
        Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc9.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc9);
        
        Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc10.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc10);
        
        Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc11.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc11);
        
        Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc12.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc12);
        
        Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc13.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc13);
        
        Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc14.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc14);
        
        Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc15.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc15);
        
        Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc16.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc16);
        
        Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc17.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc17);
        
        Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc18.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc18);
     
       Online_Contacts__c oc19 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Proview Ent IP',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        oc19.APTS_Source_System_Detail__c = accountSSD.ID;
        onlineContactList.add(oc19);
        
        insert onlineContactList;
        
        APTS_Additional_Subscription_Actions__c addsub = new APTS_Additional_Subscription_Actions__c();
        addsub.APTS_Line_Status__c='Cancelled';
        addsub.APTS_Subscription_Number__c='787847';
        addsub.APTS_Quote_Proposal__c=oProposal.id;
        insert addsub; 
        
        order.Apttus_Config2__Status__c='Pending';        
        update order;
        
        Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order.id];
        List<String> ordername = new List<String>();
        ordername.add(order2.Id); 
        
        
        APTS_OrderQueuetoESI.orderSubmissionToESI(ordername[0]);
        
              
        System.assertEquals(1,ordLists.size());
        Test.stopTest();
        
    }

}