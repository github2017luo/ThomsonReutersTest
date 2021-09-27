@isTest
public class  APTS_FindLawOrderQueuetoESITest {
    static Order_Submission__c ordersub;
    static DateTime now=DateTime.now();
    
    /*public static testMethod void findLawOrder1() {
    try{
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;    
        
        
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
        
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductB = new Product2(Name='Sreenu Product Test9', ProductCode = '42027610', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_CAT_L5__c=flcodeMap.get('ENGAGEMENT SOLUTIONS')[0],Product_Level_5__c = 'LI TOPSPOT');
      Product2 oProductP = new Product2(Name='Sreenu Product Test9', ProductCode = '42088301', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0],Product_Level_5__c = 'FL TOPSPOT');
      Product2 oProductA = new Product2(Name='Sreenu Product Test9', ProductCode = '30010890', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0]);
    Product2 oProductZ = new Product2(Name='Sreenu Product Test9', ProductCode = '41053157', APTS_Media_Lower_Level_Code__c = '53', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0]);
    Product2 oProductZA = new Product2(Name='Sreenu Product Test9', ProductCode = '42564669', APTS_Media_Lower_Level_Code__c = '53', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('WEBSITES')[0]);
    Product2 oProductE = new Product2(Name='Exp pck', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = '53', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
    Product2 oProductA1 = new Product2(Name='Sreenu Product Test9', ProductCode = '30010890', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0]);
    
      productList.add(oProductB);
      productList.add(oProductP);
      productList.add(oProductA);
    productList.add(oProductZ);
    productList.add(oProductZA);
    productList.add(oProductE);
    productList.add(oProductA1);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
              
        Test.startTest();
        
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id);
      
      Apttus_Proposal__Proposal__c oProposal2 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' , APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Priority Next Day' ,APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Revenue_Channel_Override__c='05',APTS_Ebilling_contact__c=oContact.id,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
      proposalList.add(oProposal1);
      proposalList.add(oProposal2);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      oProposal2.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal2);
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal2.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);                                 
      orderList.add(order);
      orderList.add(order1);
      insert orderList;
      
      Apttus_Config2__AssetLineItem__c assetLineItem=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductP.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
      insert assetLineItem;
      
      // Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
     //  insert task;
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
      Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10);
      Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10); 
      Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Months',APTS_Priced_Number_of_Attorneys__c=10); 
      Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Months',APTS_Priced_Number_of_Attorneys__c=10); 
      Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Months',APTS_Priced_Number_of_Attorneys__c=10); 
      Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Months',APTS_Priced_Number_of_Attorneys__c=10); 
      Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10); 
     Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='7 Months',APTS_Priced_Number_of_Attorneys__c=10); 
     Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductE.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='8 Months',APTS_Priced_Number_of_Attorneys__c=10); 
     Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='9 Months',APTS_Priced_Number_of_Attorneys__c=10); 
     Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10); 
     Apttus_Config2__OrderLineItem__c ordline11 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10);
     Apttus_Config2__OrderLineItem__c ordline15 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem.ID);                                                  
     Apttus_Config2__OrderLineItem__c ordline14 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='N/a',APTS_Priced_Number_of_Attorneys__c=10);                                                
     Apttus_Config2__OrderLineItem__c ordline12 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='N/a',APTS_Priced_Number_of_Attorneys__c=10);
     
    Apttus_Config2__OrderLineItem__c ordline16 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline17 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline18 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline19 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline20 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);
  Apttus_Config2__OrderLineItem__c ordline21 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductZ.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);  
  Apttus_Config2__OrderLineItem__c ordline22 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductZA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline212 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductE.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductE.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
    Apttus_Config2__OrderLineItem__c ordline222 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline232 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);                        
  Apttus_Config2__OrderLineItem__c ordline242 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline252 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline262 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='9 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline272 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline282 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='N/a',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline292 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline302 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='8 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline312 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline322 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
  Apttus_Config2__OrderLineItem__c ordline322a =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);
    Apttus_Config2__OrderLineItem__c ordline212b =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductE.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductE.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);                                               
   Apttus_Config2__OrderLineItem__c ordline32b =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductA1.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA1.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10, APTS_FL_Qty__c=1);                                                   
       oliList.add(ordline1);     
      oliList.add(ordline2);
      oliList.add(ordline3);      
      oliList.add(ordline4);
      oliList.add(ordline5);
      oliList.add(ordline6);
      oliList.add(ordline7);
      oliList.add(ordline8);
      oliList.add(ordline9);
      oliList.add(ordline10);
      oliList.add(ordline11); 
        oliList.add(ordline12);
        oliList.add(ordline13);
      oliList.add(ordline14);
      oliList.add(ordline15);
      oliList.add(ordline16);
      oliList.add(ordline17);
      oliList.add(ordline18);
      oliList.add(ordline19);
      oliList.add(ordline20);
      oliList.add(ordline21);    
      oliList.add(ordline22); 
      oliList.add(ordline212);
    oliList.add(ordline222);
    oliList.add(ordline232);
    oliList.add(ordline242);
    oliList.add(ordline252);
    oliList.add(ordline262);
    oliList.add(ordline272);
    oliList.add(ordline282);
    oliList.add(ordline292);
    oliList.add(ordline302);
    oliList.add(ordline312);
    oliList.add(ordline322);
    oliList.add(ordline322a);
    oliList.add(ordline212b);
    oliList.add(ordline32b);
      insert oliList;
      
      /*List<Apttus_Config2__OrderProductAttributeValue__c> productAttributeValueList=new List<Apttus_Config2__OrderProductAttributeValue__c>();
          Apttus_Config2__OrderProductAttributeValue__c productAttributeValue1=new Apttus_Config2__OrderProductAttributeValue__c(Apttus_Config2__LineItemId__c=ordline12.id,APTS_Priced_Number_of_Attorneys__c=10);
          insert productAttributeValue1;
      ordline13.Apttus_Config2__AttributeValueId__c=productAttributeValue1.id;
        update ordline13;
       
       //Test.startTest();
            
               Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
       orderrecords.put(order1.Id,'FindLaw');
      APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
        APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order1.Id);
        Test.stopTest();
      }catch(Exception ex){}
    
    }
    public static testMethod void findLawOrder2() {
        try{
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
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
        
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductB = new Product2(Name='Sreenu Product Test9', ProductCode = '42027610', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_CAT_L5__c=flcodeMap.get('ENGAGEMENT SOLUTIONS')[0],Product_Level_5__c = 'LI TOPSPOT');
      Product2 oProductP = new Product2(Name='Sreenu Product Test9', ProductCode = '40588593', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('VISIBILITY')[0]);
      Product2 oProductA = new Product2(Name='Sreenu Product Test9', ProductCode = '30010890', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0]);
    Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductB);
      productList.add(oProductP);
      productList.add(oProductA);
    productList.add(oProductC);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
       
        Test.startTest();
        
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      Apttus_Proposal__Proposal__c oProposal2 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Revenue_Channel_Override__c='05',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      Apttus_Proposal__Proposal__c oProposal3 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Bill to Account' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Revenue_Channel_Override__c='05',APTS_Ebilling_contact__c=oContact.id, APTS_Wet_Signature__c = true,APTS_Align_Contract_End_Dates__c=true);
      
      
      proposalList.add(oProposal1);
      proposalList.add(oProposal2);
    proposalList.add(oProposal3);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      oProposal2.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal2);
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal2.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
    Apttus_Config2__Order__c order2 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal3.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      orderList.add(order1);
    orderList.add(order2);
      insert orderList;
      
    //   Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
     //  insert task;
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

Apttus_Config2__OrderLineItem__c ordline21 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='7 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline22 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='8 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline23 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='9 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline24 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                 
    Apttus_Config2__OrderLineItem__c ordline25 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__PriceType__c = 'Recurring',Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline26 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='N/a',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline27 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Months',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10);          
    Apttus_Config2__OrderLineItem__c ordline28 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,APTS_Deal_Number__c=5,Apttus_Config2__EndDate__c=System.today(),Apttus_Config2__NetPrice__c=80.000,
                                                  Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10); 
   Apttus_Config2__OrderLineItem__c ordline29 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',APTS_Priced_Number_of_Attorneys__c=10);
     
    Apttus_Config2__OrderLineItem__c ordline30 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline31 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline32 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline33 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline34 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',APTS_Priced_Number_of_Attorneys__c=10);
 Apttus_Config2__OrderLineItem__c ordline35 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Months',APTS_Priced_Number_of_Attorneys__c=10);
     
    Apttus_Config2__OrderLineItem__c ordline36 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline37 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline38 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline39 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline40 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',APTS_Priced_Number_of_Attorneys__c=10);
Apttus_Config2__OrderLineItem__c ordline41 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__PriceType__c = 'Recurring');  
  Apttus_Config2__OrderLineItem__c ordline42 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10);
   Apttus_Config2__OrderLineItem__c ordline43 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10);                           
  Apttus_Config2__OrderLineItem__c ordline44 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10);                           
  Apttus_Config2__OrderLineItem__c ordline45 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline46 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline47 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline48 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline49 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='9 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline50 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline51 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10);
  Apttus_Config2__OrderLineItem__c ordline52 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Months',APTS_Priced_Number_of_Attorneys__c=10);
  Apttus_Config2__OrderLineItem__c ordline53 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='N/a',APTS_Priced_Number_of_Attorneys__c=10);
  Apttus_Config2__OrderLineItem__c ordline54 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='N/a',APTS_Priced_Number_of_Attorneys__c=10);                        
                                                   
        oliList.add(ordline21);
      oliList.add(ordline22);
      oliList.add(ordline23);
      oliList.add(ordline24);
      oliList.add(ordline25);
      oliList.add(ordline26);
      oliList.add(ordline27);
      oliList.add(ordline28);
      oliList.add(ordline29);
      oliList.add(ordline30);
      oliList.add(ordline31);
      oliList.add(ordline32);
      oliList.add(ordline33);
       oliList.add(ordline34);
       oliList.add(ordline35);
      oliList.add(ordline36);
      oliList.add(ordline37);
      oliList.add(ordline38);
       oliList.add(ordline39);
        oliList.add(ordline40);
        oliList.add(ordline41);   
     oliList.add(ordline42); 
      oliList.add(ordline43);
    oliList.add(ordline44);
    oliList.add(ordline45);
    oliList.add(ordline46);
    oliList.add(ordline47);
    oliList.add(ordline48);
    oliList.add(ordline49);
      oliList.add(ordline50);
    oliList.add(ordline51);
    oliList.add(ordline52);
    oliList.add(ordline53);
    oliList.add(ordline54);
         insert oliList;
         

            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
       orderrecords.put(order1.Id,'FindLaw');
       orderrecords.put(order2.Id,'FindLaw');
       APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
       APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order1.Id);
        APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order2.Id);
        Test.stopTest();
        }catch(Exception ex){}
    }   
    */
  /* public static testMethod void findLawOrder3() {
try{
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
        
        
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
       
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductB = new Product2(Name='Sreenu Product Test9',  APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_CAT_L5__c=flcodeMap.get('ENGAGEMENT SOLUTIONS')[0],Product_Level_5__c = 'LI TOPSPOT',productcode='42027610');
      Product2 oProductP = new Product2(Name='Sreenu Product Test9', ProductCode = '40588593', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('VISIBILITY')[0]);
      Product2 oProductA = new Product2(Name='Sreenu Product Test9', ProductCode = '30010890', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0]);
    Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductB);
      productList.add(oProductP);
      productList.add(oProductA);
    productList.add(oProductC);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
        
        Test.startTest();
        
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      Apttus_Proposal__Proposal__c oProposal2 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Revenue_Channel_Override__c='05',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      Apttus_Proposal__Proposal__c oProposal3 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Bill to Account' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Revenue_Channel_Override__c='05',APTS_Ebilling_contact__c=oContact.id, APTS_Wet_Signature__c = true,APTS_Align_Contract_End_Dates__c=true);
      
      
      proposalList.add(oProposal1);
      proposalList.add(oProposal2);
    proposalList.add(oProposal3);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      oProposal2.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal2);
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal2.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
    Apttus_Config2__Order__c order2 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal3.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      orderList.add(order1);
    orderList.add(order2);
      insert orderList;
    
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordline55 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductA.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='7 Months',APTS_Priced_Number_of_Attorneys__c=10);
    
    oliList.add(ordline55);
    insert oliList;

            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
       orderrecords.put(order1.Id,'FindLaw');
       orderrecords.put(order2.Id,'FindLaw');
        APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
        APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order1.Id);
        APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order2.Id);
        Test.stopTest();
        }catch(Exception ex){}
    }   
    */
    public static testMethod void findLawOrder4() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
        
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
         
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',Product_Level_5__c = 'FL NATIONAL AD PACKAGES',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0]);
      productList.add(oProductC);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
        
        Test.startTest();
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordline55 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='7 Months',APTS_Priced_Number_of_Attorneys__c=10);
    
     oliList.add(ordline55);
    
    insert oliList;
      
      // Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
      
      // APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
  
    public static testMethod void findLawOrder5() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
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
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='PPC Product', ProductCode = '30010890', APTS_Media_Lower_Level_Code__c = '11', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0],Product_Level_5__c = 'PPC ADVERTISING');
      productList.add(oProductC);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
         
        Test.startTest();
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordline56 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='7 Months',APTS_Priced_Number_of_Attorneys__c=10);
    
    Apttus_Config2__OrderLineItem__c ordline57 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='8 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__PriceType__c = 'Recurring');
    
     oliList.add(ordline56);
    oliList.add(ordline57);
    
    insert oliList;
      
      // Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
 
   //    APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
  
    public static testMethod void findLawOrder6() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
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
       
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='PPC Product', ProductCode = '30010890', APTS_Media_Lower_Level_Code__c = '11', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0],Product_Level_5__c = 'PPC ADVERTISING');
      productList.add(oProductC);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
         
        Test.startTest();
        
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

    Apttus_Config2__OrderLineItem__c ordlinecancel =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='7 Months',APTS_Priced_Number_of_Attorneys__c=10);
    
    
    
    oliList.add(ordlinecancel);
    
    insert oliList;
      
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
       
     //  APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
  
    public static testMethod void findLawOrder7() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
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
       
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '42027610', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',Family='ENGAGEMENT SOLUTIONS',Product_Level_5__c = 'LI TOPSPOT');
      productList.add(oProductC);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
         
        Test.startTest();
        
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

    Apttus_Config2__OrderLineItem__c ordline8mon =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='8 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline9mon =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='9 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline10mon =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Months',APTS_Priced_Number_of_Attorneys__c=10);
    Apttus_Config2__OrderLineItem__c ordline11mon =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10);
    
    oliList.add(ordline8mon);
    oliList.add(ordline9mon);
    oliList.add(ordline10mon);
    oliList.add(ordline11mon);
    insert oliList;
      
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
  
     //  APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
  public static testMethod void findLawOrder8() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
        
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
         
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
       
       Test.startTest();
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
      
   //   Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
     // insert task;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

    Apttus_Config2__OrderLineItem__c ordline55 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='7 Months',APTS_Priced_Number_of_Attorneys__c=10);
    
     oliList.add(ordline55);
    
    insert oliList;
     
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
      
     //  APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
  public static testMethod void findLawOrder9() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
        
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
        
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
       
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='Demo Product', ProductCode = '25252525', APTS_Media_Lower_Level_Code__c = '11', Apttus_Config2__Uom__c = 'Each',Product_Level_5__c = 'LI TOPSPOT',APTS_CAT_L5__c=flcodeMap.get('WEBSITES')[0]);
      productList.add(oProductC);
      
      Product2 oProductC1 = new Product2(Name='Demo Product', ProductCode = '40485592', APTS_Media_Lower_Level_Code__c = '11', Apttus_Config2__Uom__c = 'Each',Product_Level_5__c = 'LI TOPSPOT',APTS_CAT_L5__c=flcodeMap.get('WEBSITES')[0]);
      productList.add(oProductC1);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
       
       Test.startTest();
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=True);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='IMC');
      listLineItems.add(li2);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

      Apttus_Config2__OrderLineItem__c ordline56 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10);
      
    
    oliList.add(ordline56);
    insert oliList;
      
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
     
     //  APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
    
    public static testMethod void findLawOrder10() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
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
        
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC);
       Product2 oProductC1 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC1);
       Product2 oProductC2 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC2);
       Product2 oProductC3 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC3);
       Product2 oProductC4 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC4);
       Product2 oProductC5 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC5);
       Product2 oProductC6 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC6);
      Product2 oProductC7 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC7);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
       
       Test.startTest();
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li3);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

     Apttus_Config2__OrderLineItem__c ordline55 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Months',APTS_Priced_Number_of_Attorneys__c=10);
     Apttus_Config2__OrderLineItem__c ordline56 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC1.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC1.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                   
     Apttus_Config2__OrderLineItem__c ordline58 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC2.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC2.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Months',APTS_Priced_Number_of_Attorneys__c=10);  
     Apttus_Config2__OrderLineItem__c ordline59 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC3.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC3.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Months',APTS_Priced_Number_of_Attorneys__c=10); 
     Apttus_Config2__OrderLineItem__c ordline60 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC4.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC4.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                         
     Apttus_Config2__OrderLineItem__c ordline61 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC5.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC5.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                                                                        
     Apttus_Config2__OrderLineItem__c ordline62 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC6.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC6.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                                                                            
     Apttus_Config2__OrderLineItem__c ordline63 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC7.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC7.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                                                                                                                          
     Apttus_Config2__OrderLineItem__c ordline64 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC7.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC7.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                                                                                                                                                                             
     oliList.add(ordline55);
     oliList.add(ordline56);
     oliList.add(ordline58);
     oliList.add(ordline59);
     oliList.add(ordline60);
    oliList.add(ordline61);
    oliList.add(ordline62);
    oliList.add(ordline63);
    oliList.add(ordline64);
    insert oliList;
      
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
    
      // APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
    
    public static testMethod void findLawOrder11() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
        
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
       APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      Product2 oProductP = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      
      productList.add(oProductC);
      productList.add(oProductP);

      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
       
       Test.startTest();
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      Apttus_Config2__AssetLineItem__c assetLineItem=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductC.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
      insert assetLineItem;

      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
      
   //   Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
     // insert task;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

     Apttus_Config2__OrderLineItem__c ordline55 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem.ID);
    
    
     
     oliList.add(ordline55);
    insert oliList;
     
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
     
      // APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
    
    public static testMethod void findLawOrder12() {

  Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
  Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
  insert shippingMethod;
  
  List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
  new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
  new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
  insert keyvaluestore;

  WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
  insert webSettings;
  
  List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
     new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
     new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
     new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
     new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
  insert webserviceList; 
  
  User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
  EmailEncodingKey='UTF-8',
  Firstname='Bruce',
  Lastname='Wayne',
  LanguageLocaleKey='en_US',
  LocaleSidKey='en_US',
  TimeZoneSidKey='America/Chicago', 
  profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
  insert u;
  //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];

  Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
  insert ordersub;
  
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
 
  APTS_TestDataFactory.createFLTrephCodes();
  Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
  List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
  for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
      String flvalue= pb.value__c;               
      flcodeMap.put(pb.name,pb.value__c.split(','));
  }
  Account acc =APTS_TestDataFactory.createAccount('Test');
    acc.Customer_Group__c='FEDERAL GOVERNMENT';
    acc.CurrencyIsoCode='USD';
    acc.Sales_Org__c='WEST';
    acc.Customer_Type__c = 'Individual';
    acc.BU_Marketing_Segment__c='West-International Account';
    Insert acc;
     
  //Inserting SourceSystemDetail
  Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
  Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                    LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                    LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                    City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
insert accountSSD;

Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
oContact.firstname='TestFirst';
oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
insert oContact;

List<Product2> productList=new List<Product2>();
Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
Product2 oProductP = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
Product2 oProductP1 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
Product2 oProductB = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
Product2 oProductB1 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656702', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0]);

productList.add(oProductC);
productList.add(oProductP);
productList.add(oProductP1);
productList.add(oProductB);
productList.add(oProductB1);
insert productList;    
 
 Date todaysDate = system.today();
 Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
 Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
 insert o;
 
 Test.startTest();
        
 Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
 List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Align_Contract_End_Dates__c=true);

proposalList.add(oProposal1);
insert proposalList;
proposalList.clear();
oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
proposalList.add(oProposal1);
update proposalList;
System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');

list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
listLineItems.add(li1);            
Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1', Apttus_QPConfig__NetPrice__c=100);
listLineItems.add(li2);
insert listLineItems;


 Apttus_Config2__AssetLineItem__c assetLineItem1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductP1.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
insert assetLineItem1;


List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                 Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
              
orderList.add(order);
insert orderList;

//   Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
// insert task;

List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();


Apttus_Config2__OrderLineItem__c ordline56 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductP1.id,Apttus_Config2__NetPrice__c=80.000,
                                             Apttus_Config2__ProductId__c=oProductP1.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);
                                                                                                
Apttus_Config2__OrderLineItem__c ordline57 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductP1.id,Apttus_Config2__NetPrice__c=80.000,
                                             Apttus_Config2__ProductId__c=oProductP1.id,APTS_FL_Qty__c=10,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);                                             
                                             
Apttus_Config2__OrderLineItem__c ordline58 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductP1.id,Apttus_Config2__NetPrice__c=80.000,
                                             Apttus_Config2__ProductId__c=oProductP1.id,APTS_FL_Qty__c=10,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);                                                                                                

Apttus_Config2__OrderLineItem__c ordline59 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductP1.id,Apttus_Config2__NetPrice__c=80.000,
                                             Apttus_Config2__ProductId__c=oProductP1.id,APTS_FL_Qty__c=10,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);                                             
                                             
Apttus_Config2__OrderLineItem__c ordline60 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductP1.id,Apttus_Config2__NetPrice__c=80.000,
                                             Apttus_Config2__ProductId__c=oProductP1.id,APTS_FL_Qty__c=10,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id); 
                                             
Apttus_Config2__OrderLineItem__c ordline61 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductP1.id,Apttus_Config2__NetPrice__c=80.000,
                                             Apttus_Config2__ProductId__c=oProductP1.id,APTS_FL_Qty__c=10,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='9 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);                                                                                                                                                                                                       

Apttus_Config2__OrderLineItem__c ordline62 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                             Apttus_Config2__ProductId__c=oProductB.id,APTS_FL_Qty__c=10,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='9 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);                                                                                                                                                                                                       

Apttus_Config2__OrderLineItem__c ordline63 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB1.id,Apttus_Config2__NetPrice__c=80.000,
                                             Apttus_Config2__ProductId__c=oProductB1.id,APTS_FL_Qty__c=10,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='9 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);                                                                                                                                                                                                       
oliList.add(ordline63);
oliList.add(ordline62);
oliList.add(ordline56);
oliList.add(ordline57);
oliList.add(ordline58);
oliList.add(ordline59);
oliList.add(ordline60);
oliList.add(ordline61);
insert oliList;

 //Test.startTest();
      /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
      Database.executeBatch(new Aptts_BatchOrderSubmission());*/
      Map<Id,String> orderrecords = new Map<Id,String>();
 orderrecords.put(order.Id,'FindLaw');
   APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
 
/// APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
  Test.stopTest();
}
  
  public static testMethod void findLawOrder13() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False'),
        new KeyValueListStore__c(Name='APTS_OldOrderProcess',TextValue__c='False')};
        insert keyvaluestore;
        
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
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
        
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC);
       Product2 oProductC1 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC1);
       Product2 oProductC2 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC2);
       Product2 oProductC3 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC3);
       Product2 oProductC4 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC4);
       Product2 oProductC5 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC5);
       Product2 oProductC6 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC6);
      Product2 oProductC7 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      productList.add(oProductC7);
      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
       
       Test.startTest();
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      proposalList.clear();
      oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
      proposalList.add(oProposal1);
      update proposalList;
      System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li3);
      insert listLineItems;
      
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                    
      orderList.add(order);
      insert orderList;
   
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

     Apttus_Config2__OrderLineItem__c ordline55 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Months',APTS_Priced_Number_of_Attorneys__c=10);
     Apttus_Config2__OrderLineItem__c ordline56 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC1.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC1.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                   
     Apttus_Config2__OrderLineItem__c ordline58 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC2.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC2.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Months',APTS_Priced_Number_of_Attorneys__c=10);  
     Apttus_Config2__OrderLineItem__c ordline59 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC3.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC3.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Months',APTS_Priced_Number_of_Attorneys__c=10); 
     Apttus_Config2__OrderLineItem__c ordline60 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC4.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC4.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                         
     Apttus_Config2__OrderLineItem__c ordline61 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC5.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC5.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                                                                        
     Apttus_Config2__OrderLineItem__c ordline62 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC6.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC6.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                                                                            
     Apttus_Config2__OrderLineItem__c ordline63 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC7.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC7.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='6 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                                                                                                                          
     Apttus_Config2__OrderLineItem__c ordline64 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC7.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductC7.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Months',APTS_Priced_Number_of_Attorneys__c=10);                                                                                                                                                                                                                                                             
     oliList.add(ordline55);
     oliList.add(ordline56);
     oliList.add(ordline58);
     oliList.add(ordline59);
     oliList.add(ordline60);
    oliList.add(ordline61);
    oliList.add(ordline62);
    oliList.add(ordline63);
    oliList.add(ordline64);
    insert oliList;
      
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());*/
            Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'FindLaw');
         APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
    
      // APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
        Test.stopTest();
    }
    
    
    public static testMethod void findLawOrderBN() {

    Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
    Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
    insert shippingMethod;
    
    List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
    new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
    new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
    insert keyvaluestore;

    WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
    insert webSettings;
    
    List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
    insert webserviceList; 
    
    User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
    EmailEncodingKey='UTF-8',
    Firstname='Bruce',
    Lastname='Wayne',
    LanguageLocaleKey='en_US',
    LocaleSidKey='en_US',
    TimeZoneSidKey='America/Chicago', 
    profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
    insert u;
    //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];

    Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
    insert ordersub;
    
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
    APTS_TestDataFactory.createFLTrephCodes();
    Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
    List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
    for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
        String flvalue= pb.value__c;               
        flcodeMap.put(pb.name,pb.value__c.split(','));
    }
    
    Account acc =APTS_TestDataFactory.createAccount('Test');
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='WEST';
      acc.Customer_Type__c = 'Individual';
      acc.BU_Marketing_Segment__c='West-International Account';
      Insert acc;
       
    //Inserting SourceSystemDetail
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                      LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                      LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                      City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
  insert accountSSD;
  
  Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
  oContact.firstname='TestFirst';
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productList=new List<Product2>();
  Product2 oProductC = new Product2(Name='PPC Product', ProductCode = '40475630', APTS_Media_Lower_Level_Code__c = '11', Apttus_Config2__Uom__c = 'Each'/*,APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0],Product_Level_5__c = 'PPC ADVERTISING'*/);
  productList.add(oProductC);
  insert productList;    
   
   Date todaysDate = system.today();
   Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
   Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
   insert o;
     
    Test.startTest();
   Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
  Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
  APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
  
  proposalList.add(oProposal1);
  insert proposalList;
  proposalList.clear();
  oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
  proposalList.add(oProposal1);
  update proposalList;
  System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');
  
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
  listLineItems.add(li1);            
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
  listLineItems.add(li2);
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                   Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
                
  orderList.add(order);
  insert orderList;

  List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();

Apttus_Config2__OrderLineItem__c ordline56 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',
Apttus_Config2__OrderId__c=order.id,
Apttus_Config2__Quantity__c=1.000,
Apttus_Config2__LineNumber__c=1,
APTS_Contract_Line_Number__c=1,
Apttus_Config2__OptionId__c=oProductC.id,
Apttus_Config2__NetPrice__c=80.000,
Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='7 Months',APTS_Priced_Number_of_Attorneys__c=10);

Apttus_Config2__OrderLineItem__c ordline57 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductC.id,Apttus_Config2__NetPrice__c=80.000,
                                               Apttus_Config2__ProductId__c=oProductC.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='8 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__PriceType__c = 'Recurring');

 oliList.add(ordline56);
oliList.add(ordline57);

insert oliList;
  
  // Test.startTest();
        /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Database.executeBatch(new Aptts_BatchOrderSubmission());*/
        Map<Id,String> orderrecords = new Map<Id,String>();
   orderrecords.put(order.Id,'FindLaw');
     APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);

//    APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
    Test.stopTest();
}
    
public static testMethod void findLawOrder12BN() {

  Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
  Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
  insert shippingMethod;
  
  List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
  new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
  new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
  insert keyvaluestore;

  WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
  insert webSettings;
  
  List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
     new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
     new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
     new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
     new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
  insert webserviceList; 
  
  User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
  EmailEncodingKey='UTF-8',
  Firstname='Bruce',
  Lastname='Wayne',
  LanguageLocaleKey='en_US',
  LocaleSidKey='en_US',
  TimeZoneSidKey='America/Chicago', 
  profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
  insert u;
  //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];

  Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
  insert ordersub;
  
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
 
  APTS_TestDataFactory.createFLTrephCodes();
  Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
  List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
  for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
      String flvalue= pb.value__c;               
      flcodeMap.put(pb.name,pb.value__c.split(','));
  }
  Account acc =APTS_TestDataFactory.createAccount('Test');
    acc.Customer_Group__c='FEDERAL GOVERNMENT';
    acc.CurrencyIsoCode='USD';
    acc.Sales_Org__c='WEST';
    acc.Customer_Type__c = 'Individual';
    acc.BU_Marketing_Segment__c='West-International Account';
    Insert acc;
     
  //Inserting SourceSystemDetail
  Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
  Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                    LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                    LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                    City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
insert accountSSD;

Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
oContact.firstname='TestFirst';
oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
insert oContact;

List<Product2> productList=new List<Product2>();
Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
Product2 oProductP = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
Product2 oProductP1 = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('FL DIRECTORY')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
Product2 oProductB = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0],Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
productList.add(oProductC);
productList.add(oProductP);
productList.add(oProductP1);
productList.add(oProductB);
insert productList;    
 
 Date todaysDate = system.today();
 Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
 Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
 insert o;
 
 Test.startTest();
        
 Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
 List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Align_Contract_End_Dates__c=true);

proposalList.add(oProposal1);
insert proposalList;
proposalList.clear();
oProposal1.APTS_Proposal_Business_Unit__c= 'FindLaw';
proposalList.add(oProposal1);
update proposalList;
System.assertEquals(oProposal1.APTS_Proposal_Business_Unit__c,'FindLaw');

list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
listLineItems.add(li1);            
Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1', Apttus_QPConfig__NetPrice__c=100);
listLineItems.add(li2);
Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1', Apttus_QPConfig__NetPrice__c=100);
listLineItems.add(li3);
insert listLineItems;


 Apttus_Config2__AssetLineItem__c assetLineItem1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductP1.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
insert assetLineItem1;


List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                 Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
              
orderList.add(order);
insert orderList;

//   Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
// insert task;

List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();


Apttus_Config2__OrderLineItem__c ordline56 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',
Apttus_Config2__OrderId__c=order.id,
Apttus_Config2__Quantity__c=1.000,
Apttus_Config2__LineNumber__c=1,
APTS_Contract_Line_Number__c=1,
Apttus_Config2__OptionId__c=oProductC.id,
Apttus_Config2__NetPrice__c=80.000,
Apttus_Config2__ProductId__c=oProductC.id,
APTS_Group__c='Bundle A',
APTS_Bridge__c='1 Month',
Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);


Apttus_Config2__OrderLineItem__c ordline57 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',
Apttus_Config2__OrderId__c=order.id,
Apttus_Config2__Quantity__c=1.000,
Apttus_Config2__LineNumber__c=1,
APTS_Contract_Line_Number__c=1,
Apttus_Config2__OptionId__c=oProductC.id,
Apttus_Config2__NetPrice__c=80.000,
Apttus_Config2__ProductId__c=oProductC.id,
APTS_Group__c='Bundle A',
APTS_Bridge__c='1 Month',
Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);
  
Apttus_Config2__OrderLineItem__c ordline58 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',
Apttus_Config2__OrderId__c=order.id,
Apttus_Config2__Quantity__c=1.000,
Apttus_Config2__LineNumber__c=1,
APTS_Contract_Line_Number__c=1,
Apttus_Config2__OptionId__c=oProductB.id,
Apttus_Config2__NetPrice__c=80.000,
Apttus_Config2__ProductId__c=oProductB.id,
APTS_Group__c='Bundle A',
APTS_Bridge__c='1 Month',
Apttus_Config2__LineType__c = 'Option',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__AssetLineItemId__c=assetLineItem1.ID,Apttus_QPConfig__ProposalLineItemId__c=li2.Id);

oliList.add(ordline56);
oliList.add(ordline57);
oliList.add(ordline58);
insert oliList;

 //Test.startTest();
      /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
      Database.executeBatch(new Aptts_BatchOrderSubmission());*/
      Map<Id,String> orderrecords = new Map<Id,String>();
 orderrecords.put(order.Id,'FindLaw');
   APTS_FindLawOrderQueuetoESI.florderSubmissionToESI(order.Id);
 
/// APTS_OrderTriggerHelper1.invokeintegrationclass2(orderrecords);
  Test.stopTest();
}
 
 }