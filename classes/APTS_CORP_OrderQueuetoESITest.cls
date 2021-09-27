@isTest
public class APTS_CORP_OrderQueuetoESITest {
private static final String USERNAME = System.now().getTime() + 'test2@test.com';
private static final String LASTNAME ='testcoverage';
private static final String SHIPPINGNAME= 'Ground Shipping - U.S. Only';
private static final String SHIPPINGVALUE ='01';
private static final String WEBSERVICE1 = 'OrderSubmissionESICorporate';
private static final String ACCRECORDTYPENAME='Customer';
private static final String ACCNAME='Test';
private static final String CONRECORDTYPENAME='GLI Contact';
private static final String CONLASTNAME='Test';
private static final String CONNAME='Test1';
private static final String PRICELISTNAME='Thomson Reuters Master - US Legal';
private static final String OPPTYRECORDTYPENAME='Pipeline Opportunity';
private static final String OPPTYNAME='Test Opportunity';
private static final String STAGENAME='New';
private static final String SSDRECORDTYPENAME='UKI Source Systems';
private static final String PROPRECORDTYPENAME='Proposal';
private static final String STATUS='pending';
private static final String PROPNAME='Test';
private static final String VALUE=System.Label.APTS_OC_Test_Id;
private static final String CUSTOMFIELDNAME='ANZUsersProfileId';
private static final String VALUE1='True';
private static final String CUSTOMFIELDNAME1='LCRMDisableStrikeIronServices';
private static final String JURIS ='Indiana';
private static final String FNAME = 'Test';
private static final String MNAME= 'Test';
private static final String LNAME ='Test';
private static final String EADDRESS = 'sreenu.d@tcs.com';
private static final String POSITION = 'Attorney';
private static final String PNAME='Test';
private static final String PFAMILY='Test';
private static final String RECORDTYPEID=System.Label.APTS_OC_Test_Id;
static Order_Submission__c ordersub;
static DateTime now=DateTime.now();
   
@testSetup public static void setUp(){


      List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;     
         
       List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();       
      
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=recordtypeId;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=recordtypeId;
        recordlist.add(recordtype1);
        insert recordlist; 
   
        WebServiceSettings__c  webSettings = APTS_TestDataFactory.createWebServiceSetting(webservice1);  
        webSettings.Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST';
        webSettings.Password__c='s2esandboxESI12c';
        webSettings.Username__c='esisfdcs2euser';
        insert webSettings;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
           
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            String flvalue= pb.value__c;               
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        User u = APTS_TestDataFactory.createUser(username,lastname);
        u.Email='user@mydomain.com';
        u.Alias = 'User_3';
        u.Firstname='Test';        
        u.TimeZoneSidKey='America/Chicago'; 
        u.Sub_Bu__c='Corp';
        u.Sales_Force_Description__c='Office';
        u.Rep_Employee_Number__c='X12345678';
        insert u;
        
        Shipping_Method__c shippingMethod = APTS_TestDataFactory.createShippingMethod(shippingName,shippingValue);
        insert shippingMethod;
   
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
          
        Id accRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get(accRecordTypeName).getRecordTypeId();
        Account acc= APTS_TestDataFactory.createAccount(accName);
        acc.RecordTypeId=accRecordTypeId1;
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        acc.Customer_Type__c = 'Individual';
        acc.Fiscal_Year_End__c='05-May';
        acc.BU_Marketing_Segment__c='West-International Account';
        insert acc;
        
        Id ssdRecordTypeId = Schema.SObjectType.Source_system_detail__c .getRecordTypeInfosByName().get(ssdRecordTypeName).getRecordTypeId();
        Source_system_detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(acc);
        accountSSD.RecordTypeId=ssdRecordTypeId;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        accountSSD.Source_System_Account_Number__c='123456';
        accountSSD.LCRM_Name_2__c='DEF';
        accountSSD.LCRM_Name_3__c='XYZ';
        accountSSD.Number_Street__c='Street5';
        accountSSD.LCRM_Street_2__c='Street2';
        accountSSD.LCRM_Street3__c='Street3';
        accountSSD.LCRM_Street4__c='Street4';
        accountSSD.City__c='TestCity';
        accountSSD.State__c='TestState';
        accountSSD.Country__c='testCountry';
        accountSSD.Postal_Code__c='12345';
        accountSSD.LCRM_Phone__c='9876547777';
        accountSSD.LCRM_Fax__c='8765432109';
        accountSSD.LCRM_PO_Box__c='PO-156';
        insert accountSSD;     
              
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(conRecordTypeName).getRecordTypeId();
        Contact oContact = APTS_TestDataFactory.createContact(conLastName,acc.id);
        oContact.RecordTypeId=conRecordTypeId;
        oContact.FirstName='Test';
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
     
        List<Product2> productlist=new List<Product2>();
        Product2 oProductB = APTS_TestDataFactory.createProduct(pName,pFamily);
        oProductB.ProductCode = '40475630';
        oProductB.APTS_Media_Lower_Level_Code__c = 'WA';
        oProductB.Apttus_Config2__Uom__c = 'Attorneys';
        oProductB.APTS_CAT_L5__c=flcodeMap.get('ENGAGEMENT SOLUTIONS')[0];
        oProductB.Product_Level_5__c = 'LI TOPSPOT';
        oProductB.APTS_Availability_Date__c=system.today();
        oProductB.APTS_SwapAndVersion__c ='41382513';
        productlist.add(oProductB);
  
        Product2 oProductP = APTS_TestDataFactory.createProduct(pName,pFamily);
        oProductP.ProductCode = '40588593';
        oProductP.APTS_Media_Lower_Level_Code__c = 'LO';
        oProductP.Apttus_Config2__Uom__c = 'Seats';
        oProductP.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
        productlist.add(oProductP);
  
        Product2 oProductA = APTS_TestDataFactory.createProduct(pName,pFamily);
        oProductA.ProductCode = '30010890';
        oProductA.APTS_Media_Lower_Level_Code__c = 'TT';
        oProductA.Apttus_Config2__Uom__c = 'Seats';
        oProductA.APTS_Media_High_Level_Code__c ='55';
        oProductA.APTS_CAT_L5__c=flcodeMap.get('PPC MANAGEMENT')[0];
        productlist.add(oProductA); 
        
        
        Product2 oProductcpw = APTS_TestDataFactory.createProduct(pName,pFamily);
        oProductcpw.ProductCode = '30573759';
        oProductcpw.APTS_Media_Lower_Level_Code__c = 'TX';
        oProductcpw.Apttus_Config2__Uom__c = 'Each';
        oProductcpw.APTS_Media_High_Level_Code__c ='06';
        oProductcpw.Family='GSCPW_RP';
        oProductcpw.APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family;
        oProductcpw.APTS_Cat_L4__c='L4_T77035_FP';
        productlist.add(oProductcpw); 
        
        insert productlist;
     
        Id opptyRecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(opptyRecordTypeName).getRecordTypeId();
        Date todaysDate = system.today();    
        Opportunity o = APTS_TestDataFactory.createOpportunity(opptyName,acc.id,stageName,todaysDate);
        o.RecordTypeId=opptyRecordTypeId;
        o.forecastcategoryname='Omitted';
        o.Source_System_Detail__c=accountSSD.id;
        insert o ;
        
        
     
        
 }
   @isTest static void corpUSOrderTest(){   
   try{
       Account acc = [Select id from Account where Name='Test'];
       Contact oContact = [select id from Contact limit 1];
       Opportunity o = [select id from Opportunity limit 1];
       Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
       User u = [select id,Username  from user where Email = 'user@mydomain.com'];
       u.Sales_Force_Description__c='Home Office';
       update u;
       Product2 oProductB=[select id from Product2 where ProductCode = '40475630' ];
       Product2 oProductP=[select id from Product2 where ProductCode = '40588593' ];
       Product2 oProductA=[select id from Product2 where ProductCode = '30010890' ];
       oProductA.APTS_Item_Category_Group__c='ZRRB';
       oProductA.APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family;
       oProductA.APTS_Pricing_Qty_Type__c='abc';
       update oProductA;
       Product2 oProductcpw =[select id from Product2 where ProductCode = '30573759' ];
       oProductcpw.APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family;
       update oProductcpw;

     
 
       
        Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get(propRecordTypeName).getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal1 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal1.RecordTypeId=propRecordTypeId;
        oProposal1.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal1.Apttus_Proposal__Account__c = acc.Id;
        oProposal1.APTS_Payment_Option__c ='Credit Card';          
        oProposal1.CurrencyIsoCode = 'USD';
        oProposal1.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal1.APTS_Card_Expiration_Date__c= System.Today();
        oProposal1.APTS_amount__c = 30;
        oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal1.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal1.ownerid=u.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal1.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal1);

        Apttus_Proposal__Proposal__c oProposal2 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal2.RecordTypeId=propRecordTypeId;
        oProposal2.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal2.Apttus_Proposal__Account__c = acc.Id;
        oProposal2.APTS_Payment_Option__c ='Credit Card';          
        oProposal2.CurrencyIsoCode = 'USD';
        oProposal2.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal2.APTS_Card_Expiration_Date__c= System.Today();
        oProposal2.APTS_amount__c = 30;
        oProposal2.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal2.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal2.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal2.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal2.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal2.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal2.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal2.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal2.ownerid=u.id;
        oProposal2.APTS_Revenue_Channel_Override__c='05';
        oProposal2.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal2.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal2.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal2);
        insert proposalList;
             Test.startTest(); 
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = APTS_TestDataFactory.proposallineitem( prodConfig.Id,oProposal1.id);
      li1.Apttus_Proposal__Product__c = oProductB.Id;
      li1.APTS_Number_of_Attorneys__c = 5;
      listLineItems.add(li1);       
           
      Apttus_Proposal__Proposal_Line_Item__c li2 =  APTS_TestDataFactory.proposallineitem(prodConfig.Id,oProposal2.id);
      li2.Apttus_Proposal__Product__c = oProductP.Id;
      li2.APTS_Number_of_Attorneys__c = 5;
      li2.APTS_Category_Name__c='FS 1';
      listLineItems.add(li2);
      insert listLineItems;
       
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__OrderDate__c=system.today()+1,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__OrderDate__c=system.today()-2,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);                                 
      orderList.add(order);
      orderList.add(order1);
      insert orderList;
       Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
       insert task;
        
     List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();    
    Apttus_Config2__OrderLineItem__c ordline1 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline1.Apttus_Config2__LineStatus__c='New';
     ordline1.Apttus_Config2__Quantity__c=1.000;
     ordline1.Apttus_Config2__LineNumber__c=1;
     ordline1.APTS_Contract_Line_Number__c=1;
     ordline1.Apttus_Config2__OptionId__c=oProductcpw.id;
     ordline1.Apttus_Config2__NetPrice__c=80.000;
     ordline1.Apttus_Config2__ListPrice__c=200.00;     
     ordline1.Apttus_Config2__ProductId__c=oProductcpw.id;
     ordline1.APTS_Group__c='Bundle A';
     ordline1.APTS_Bridge__c='28 Days';
     ordline1.Apttus_Config2__ChargeType__c='';
     ordline1.Apttus_Config2__PriceType__c='';
     ordline1.Apttus_Config2__LineType__c = 'Product/Service';
     ordline1.APTS_Program_ID__c = '';
     ordline1.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline1.APTS_Contract_Term__c='Short Term Trial';
     ordline1.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline1.APTS_Priced_Number_of_Attorneys__c=10;
     ordline1.APTS_Renewal_Type__c='';
     ordline1.APTS_New_Bridge_Discount__c =10.00;     
     ordline1.APTS_Start_Date__c=system.today()+1;
     oliList.add(ordline1);   
     
     Apttus_Config2__OrderLineItem__c ordline2 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline2.Apttus_Config2__LineStatus__c='New';
     ordline2.Apttus_Config2__Quantity__c=1.000;
     ordline2.Apttus_Config2__LineNumber__c=1;
     ordline2.APTS_Contract_Line_Number__c=1;
     ordline2.Apttus_Config2__NetPrice__c=80.000;
     ordline2.Apttus_Config2__ProductId__c=oProductA.id;
     ordline2.APTS_Group__c='Bundle A';
    //ordline2.APTS_Bridge__c='2 Years';
     ordline2.Apttus_Config2__LineType__c = 'Product/Service';
     ordline2.APTS_Program_ID__c = 'FIRMSITE';
     ordline2.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline2.APTS_Contract_Term__c='2 Years';
     ordline2.APTS_Priced_Number_of_Attorneys__c=10;
     ordline2.APTS_Renewal_Type__c='Term Commitment';
     ordline2.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline2.Apttus_Config2__PriceType__c='One Time';
     ordline2.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline2.Apttus_Config2__AdjustedPrice__c=10.0;
          ordline2.APTS_Bridge__c='2 Months';

     oliList.add(ordline2);   
     
     Apttus_Config2__OrderLineItem__c ordline3 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline3.Apttus_Config2__LineStatus__c='Cancelled';
     ordline3.Apttus_Config2__Quantity__c=1.000;
     ordline3.Apttus_Config2__LineNumber__c=1;
     ordline3.APTS_Contract_Line_Number__c=1;
     ordline3.Apttus_Config2__NetPrice__c=80.000;
     ordline3.Apttus_Config2__ProductId__c=oProductP.id;
     ordline3.APTS_Group__c='Bundle A';
     ordline3.APTS_Bridge__c='1 Year';
     ordline3.Apttus_Config2__LineType__c = 'Product/Service';
     ordline3.APTS_Program_ID__c = 'FIRMSITE';
     ordline3.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline3.APTS_Contract_Term__c='11 Months';
     ordline3.APTS_Priced_Number_of_Attorneys__c=10;
     ordline3.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline3.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline3);   
     
     Apttus_Config2__OrderLineItem__c ordline4 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline4.Apttus_Config2__LineStatus__c='Renewed';
     ordline4.Apttus_Config2__Quantity__c=1.000;
     ordline4.Apttus_Config2__LineNumber__c=1;
     ordline4.APTS_Contract_Line_Number__c=1;
     ordline4.Apttus_Config2__NetPrice__c=80.000;
     ordline4.Apttus_Config2__OptionId__c=oProductB.id;
     ordline4.Apttus_Config2__ProductId__c=oProductB.id;
     ordline4.APTS_Group__c='Bundle A';
     ordline4.APTS_Bridge__c='2 Years';
     ordline4.Apttus_Config2__LineType__c = 'Product/Service';
     ordline4.APTS_Program_ID__c = 'FIRMSITE';
     ordline4.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline4.APTS_Contract_Term__c='1 Year';
     ordline4.APTS_Priced_Number_of_Attorneys__c=10;
     ordline4.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline4.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline4);

     Apttus_Config2__OrderLineItem__c ordline5 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline5.Apttus_Config2__LineStatus__c='Renewed';
     ordline5.Apttus_Config2__Quantity__c=1.000;
     ordline5.Apttus_Config2__LineNumber__c=1;
     ordline5.APTS_Contract_Line_Number__c=1;
     ordline5.Apttus_Config2__NetPrice__c=80.000;
     ordline5.Apttus_Config2__OptionId__c=oProductB.id;
     ordline5.Apttus_Config2__ProductId__c=oProductB.id;
     ordline5.APTS_Group__c='Bundle A';
     ordline5.APTS_Bridge__c='3 Years';
     ordline5.Apttus_Config2__LineType__c = 'Product/Service';
     ordline5.APTS_Program_ID__c = 'FIRMSITE';
     ordline5.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline5.APTS_Contract_Term__c='2 Years';
     ordline5.APTS_Priced_Number_of_Attorneys__c=10;
     ordline5.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline5.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline5);
     
     Apttus_Config2__OrderLineItem__c ordline6 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline6.Apttus_Config2__LineStatus__c='Renewed';
     ordline6.Apttus_Config2__Quantity__c=1.000;
     ordline6.Apttus_Config2__LineNumber__c=1;
     ordline6.APTS_Contract_Line_Number__c=1;
     ordline6.Apttus_Config2__NetPrice__c=80.000;
     ordline6.Apttus_Config2__OptionId__c=oProductB.id;
     ordline6.Apttus_Config2__ProductId__c=oProductB.id;
     ordline6.APTS_Group__c='Bundle A';
     ordline6.APTS_Bridge__c='4 Years';
     ordline6.Apttus_Config2__LineType__c = 'Product/Service';
     ordline6.APTS_Program_ID__c = 'FIRMSITE';
     ordline6.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline6.APTS_Contract_Term__c='3 Years';
     ordline6.APTS_Priced_Number_of_Attorneys__c=10;
     ordline6.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline6.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline6);
     
     Apttus_Config2__OrderLineItem__c ordline7 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline7.Apttus_Config2__LineStatus__c='Renewed';
     ordline7.Apttus_Config2__Quantity__c=1.000;
     ordline7.Apttus_Config2__LineNumber__c=1;
     ordline7.APTS_Contract_Line_Number__c=1;
     ordline7.Apttus_Config2__NetPrice__c=80.000;
     ordline7.Apttus_Config2__OptionId__c=oProductB.id;
     ordline7.Apttus_Config2__ProductId__c=oProductB.id;
     ordline7.APTS_Group__c='Bundle A';
     ordline7.APTS_Bridge__c='5 Years';
     ordline7.Apttus_Config2__LineType__c = 'Product/Service';
     ordline7.APTS_Program_ID__c = 'FIRMSITE';
     ordline7.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline7.APTS_Contract_Term__c='4 Years';
     ordline7.APTS_Priced_Number_of_Attorneys__c=10;
     ordline7.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline7.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline7);
     
     Apttus_Config2__OrderLineItem__c ordline8 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline8.Apttus_Config2__LineStatus__c='Renewed';
     ordline8.Apttus_Config2__Quantity__c=1.000;
     ordline8.Apttus_Config2__LineNumber__c=1;
     ordline8.APTS_Contract_Line_Number__c=1;
     ordline8.Apttus_Config2__NetPrice__c=80.000;
     ordline8.Apttus_Config2__OptionId__c=oProductB.id;
     ordline8.Apttus_Config2__ProductId__c=oProductB.id;
     ordline8.APTS_Group__c='Bundle A';
     ordline8.APTS_Bridge__c='10 Years';
     ordline8.Apttus_Config2__LineType__c = 'Product/Service';
     ordline8.APTS_Program_ID__c = 'FIRMSITE';
     ordline8.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline8.APTS_Contract_Term__c='5 Years';
     ordline8.APTS_Priced_Number_of_Attorneys__c=10;
     ordline8.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline8.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline8);
     
         Apttus_Config2__OrderLineItem__c ordline9 =  APTS_TestDataFactory.orderLineItem(order.id);
         ordline9.Apttus_Config2__LineStatus__c='New';
         ordline9.Apttus_Config2__Quantity__c=1.000;
         ordline9.Apttus_Config2__LineNumber__c=1;
         ordline9.APTS_Contract_Line_Number__c=1;
         ordline9.Apttus_Config2__NetPrice__c=80.000;
         ordline9.Apttus_Config2__OptionId__c=oProductB.id;
         ordline9.Apttus_Config2__ProductId__c=oProductB.id;
         ordline9.APTS_Group__c='Bundle A';
         ordline9.APTS_Bridge__c='1 Month';
         ordline9.Apttus_Config2__LineType__c = 'Product/Service';
         ordline9.APTS_Program_ID__c = 'FIRMSITE';
         ordline9.Apttus_Config2__AdjustmentType__c ='% Discount';
         ordline9.APTS_Contract_Term__c='10 Years';
         ordline9.APTS_Priced_Number_of_Attorneys__c=10;
         ordline9.Apttus_Config2__BaseExtendedPrice__c=100.0;
         ordline9.Apttus_Config2__AdjustedPrice__c=10.0;
         ordline9.APTS_Term_Type__c = 'Delivery Date';
         ordline9.APTS_Start_Date__c=system.today()+2;
         oliList.add(ordline9);
        
         Apttus_Config2__OrderLineItem__c ordline10 =  APTS_TestDataFactory.orderLineItem(order.id);
         ordline10.Apttus_Config2__LineStatus__c='New';
         ordline10.Apttus_Config2__Quantity__c=1.000;
         ordline10.Apttus_Config2__LineNumber__c=1;
         ordline10.APTS_Contract_Line_Number__c=1;
         ordline10.Apttus_Config2__NetPrice__c=80.000;
         ordline10.Apttus_Config2__OptionId__c=oProductB.id;
         ordline10.Apttus_Config2__ProductId__c=oProductB.id;
         ordline10.APTS_Group__c='Bundle A';
         ordline10.APTS_Bridge__c='1 Month';
         ordline10.Apttus_Config2__LineType__c = 'Product/Service';
         ordline10.APTS_Program_ID__c = 'FIRMSITE';
         ordline10.Apttus_Config2__AdjustmentType__c ='% Markup';
         ordline10.APTS_Contract_Term__c='3 Years';
         ordline10.APTS_Priced_Number_of_Attorneys__c=10;
         ordline10.Apttus_Config2__BaseExtendedPrice__c=10.0;
         ordline10.Apttus_Config2__AdjustedPrice__c=100.0;    
         ordline10.APTS_Term_Type__c='Co-Term and ProRate';
         ordline10.Apttus_Config2__AdjustmentAmount__c=100.01;
         oliList.add(ordline10);
                                             
        Apttus_Config2__OrderLineItem__c ordline11 = APTS_TestDataFactory.orderLineItem(order.id);
        ordline11.Apttus_Config2__LineStatus__c='Cancelled';
        ordline11.Apttus_Config2__Quantity__c=1.000;
        ordline11.Apttus_Config2__LineNumber__c=1;
        ordline11.APTS_Contract_Line_Number__c=1;
        ordline11.APTS_Deal_Number__c=5;
        ordline11.Apttus_Config2__EndDate__c=System.today();
        ordline11.Apttus_Config2__NetPrice__c=80.000;
        ordline11.Apttus_Config2__ProductId__c=oProductP.id;
        ordline11.APTS_Group__c='Bundle A';
        ordline11.APTS_Bridge__c='1 Month';
        ordline11.Apttus_Config2__LineType__c = 'Product/Service';
        ordline11.APTS_Program_ID__c = 'FIRMSITE';
        ordline11.Apttus_Config2__AdjustmentType__c ='% Discount';
        ordline11.APTS_Contract_Term__c='1 Month';
        ordline11.APTS_Priced_Number_of_Attorneys__c=10;
        ordline11.Apttus_Config2__BaseExtendedPrice__c=100.0;
        ordline11.Apttus_Config2__AdjustedPrice__c=10.0; 
        oliList.add(ordline11);

        Apttus_Config2__OrderLineItem__c ordline12 = APTS_TestDataFactory.orderLineItem(order.id);
        ordline12.Apttus_Config2__LineStatus__c='New';
        ordline12.APTS_Term_Type__c='ProRate';
        ordline12.Apttus_Config2__Quantity__c=1.000;
        ordline12.Apttus_Config2__LineNumber__c=1;
        ordline12.APTS_Contract_Line_Number__c=1;
        ordline12.Apttus_Config2__OptionId__c=oProductA.id;
        ordline12.Apttus_Config2__NetPrice__c=80.000;
        ordline12.Apttus_Config2__ProductId__c=oProductB.id;
        ordline12.APTS_Group__c='Bundle A';
        ordline12.APTS_Bridge__c='1 Month';
        ordline12.Apttus_Config2__LineType__c = 'Product/Service';
        ordline12.APTS_Program_ID__c = 'FIRMSITE';
        ordline12.Apttus_Config2__AdjustmentType__c ='% Discount';
        ordline12.APTS_Contract_Term__c='4 Years';
        ordline12.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
        ordline12.APTS_Priced_Number_of_Attorneys__c=10;
        ordline12.Apttus_Config2__BaseExtendedPrice__c=100.0;
        ordline12.Apttus_Config2__AdjustedPrice__c=10.0;
        oliList.add(ordline12);

        Apttus_Config2__OrderLineItem__c ordline13 =  APTS_TestDataFactory.orderLineItem(order.id); 
        ordline13.Apttus_Config2__LineStatus__c='New';
        ordline13.APTS_Term_Type__c='ProRate';
        ordline13.Apttus_Config2__Quantity__c=1.000;
        ordline13.Apttus_Config2__LineNumber__c=1;
        ordline13.APTS_Contract_Line_Number__c=1;
        ordline13.Apttus_Config2__OptionId__c=oProductB.id;
        ordline13.Apttus_Config2__NetPrice__c=80.000;
        ordline13.Apttus_Config2__ProductId__c=oProductB.id;
        ordline13.APTS_Group__c='Bundle A';
        ordline13.APTS_Bridge__c='1 Month';
        ordline13.Apttus_Config2__LineType__c = 'Product/Service';
        ordline13.APTS_Program_ID__c = 'FIRMSITE';
        ordline13.Apttus_Config2__AdjustmentType__c ='% Discount';
        ordline13.APTS_Contract_Term__c='5 Years';
        ordline13.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
        ordline13.APTS_Priced_Number_of_Attorneys__c=10;
        ordline13.Apttus_Config2__BaseExtendedPrice__c=100.0;
        ordline13.Apttus_Config2__AdjustedPrice__c=10.0;
        ordline13.APTS_End_Date__c=System.Today()+7; 
        oliList.add(ordline13);

   
       Apttus_Config2__OrderLineItem__c ordline14 = APTS_TestDataFactory.orderLineItem(order.id); 
       ordline14.Apttus_Config2__LineStatus__c='New';
       ordline14.Apttus_Config2__Quantity__c=1.000;
       ordline14.Apttus_Config2__LineNumber__c=1;
       ordline14.APTS_Contract_Line_Number__c=1;
       ordline14.Apttus_Config2__OptionId__c=oProductB.id;
       ordline14.Apttus_Config2__NetPrice__c=80.000;
       ordline14.Apttus_Config2__ProductId__c=oProductB.id;
       ordline14.APTS_Group__c='Bundle A';
       ordline14.APTS_Bridge__c='1 Month';
       ordline14.Apttus_Config2__LineType__c = 'Product/Service';
       ordline14.APTS_Program_ID__c = 'FIRMSITE';
       ordline14.APTS_Contract_Term__c='4 Years';
       ordline14.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
       ordline14.APTS_Priced_Number_of_Attorneys__c=10;
       ordline14.Apttus_Config2__BaseExtendedPrice__c=100.0;
       ordline14.Apttus_Config2__AdjustedPrice__c=10.0;
       ordline14.APTS_Term_Type__c = 'Co-Term';
       ordline14.Apttus_Config2__NetPrice__c=100.00;
       ordline14.APTS_End_Date__c=System.Today()+7; 
       oliList.add(ordline14);
    
       Apttus_Config2__OrderLineItem__c ordline15 =  APTS_TestDataFactory.orderLineItem(order.id);
       ordline15.Apttus_Config2__LineStatus__c='New';
       ordline15.Apttus_Config2__Quantity__c=1.000;
       ordline15.Apttus_Config2__LineNumber__c=1;
       ordline15.APTS_Contract_Line_Number__c=1;
       ordline15.Apttus_Config2__OptionId__c=oProductB.id;
       ordline15.Apttus_Config2__NetPrice__c=80.000;
       ordline15.Apttus_Config2__ProductId__c=oProductB.id;
       ordline15.APTS_Group__c='Bundle A';
       ordline15.APTS_Bridge__c='1 Month';
       ordline15.Apttus_Config2__LineType__c = 'Product/Service';
       ordline15.APTS_Program_ID__c = 'FIRMSITE';
       ordline15.APTS_Contract_Term__c='3 Years';
       ordline15.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
       ordline15.APTS_Priced_Number_of_Attorneys__c=10;
       ordline15.Apttus_Config2__BaseExtendedPrice__c=100.0;
       ordline15.Apttus_Config2__AdjustedPrice__c=10.0;
       ordline15.APTS_Term_Type__c = 'ProRate';
       ordline15.APTS_End_Date__c=System.Today()+7;
       oliList.add(ordline15);
 
       Apttus_Config2__OrderLineItem__c ordline16 =  APTS_TestDataFactory.orderLineItem(order.id);
       ordline16.Apttus_Config2__LineStatus__c='New';
       ordline16.Apttus_Config2__Quantity__c=1.000;
       ordline16.Apttus_Config2__LineNumber__c=1;
       ordline16.APTS_Contract_Line_Number__c=1;
       ordline16.Apttus_Config2__OptionId__c=oProductB.id;
       ordline16.Apttus_Config2__NetPrice__c=80.000;
       ordline16.Apttus_Config2__ProductId__c=oProductB.id;
       ordline16.APTS_Group__c='Bundle A';
       ordline16.APTS_Bridge__c='1 Month';
       ordline16.Apttus_Config2__LineType__c = 'Product/Service';
       ordline16.APTS_Program_ID__c = 'FIRMSITE';
       ordline16.APTS_Contract_Term__c='2 Years';
       ordline16.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
       ordline16.APTS_Priced_Number_of_Attorneys__c=10;
       ordline16.Apttus_Config2__BaseExtendedPrice__c=100.0;
       ordline16.Apttus_Config2__AdjustedPrice__c=10.0;
       ordline16.APTS_Term_Type__c = 'Co-Term and ProRate';
       ordline16.APTS_End_Date__c=System.Today()+7; 
       oliList.add(ordline16);
    
       Apttus_Config2__OrderLineItem__c ordline17 =  APTS_TestDataFactory.orderLineItem(order.id);
       ordline17.Apttus_Config2__LineStatus__c='New';
       ordline17.Apttus_Config2__Quantity__c=1.000;
       ordline17.Apttus_Config2__LineNumber__c=1;
       ordline17.APTS_Contract_Line_Number__c=1;
       ordline17.Apttus_Config2__OptionId__c=oProductB.id;
       ordline17.Apttus_Config2__NetPrice__c=80.000;
       ordline17.Apttus_Config2__ProductId__c=oProductB.id;
       ordline17.APTS_Group__c='Bundle A';
       ordline17.APTS_Bridge__c='1 Month';
       ordline17.Apttus_Config2__LineType__c = 'Product/Service';
       ordline17.APTS_Program_ID__c = 'FIRMSITE';
       ordline17.Apttus_Config2__AdjustedPrice__c=90.00;
       ordline17.Apttus_Config2__AdjustmentType__c='% Markup';
       ordline17.APTS_Contract_Term__c='1 Year';
       ordline17.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
       ordline17.APTS_Priced_Number_of_Attorneys__c=10;
       ordline17.Apttus_Config2__BaseExtendedPrice__c=100.0;
       ordline17.APTS_Term_Type__c = 'Co-Term and ProRate';
       ordline17.APTS_End_Date__c=System.Today()+7;
       oliList.add(ordline17);
       
        Apttus_Config2__OrderLineItem__c ordline18 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline18.Apttus_Config2__LineStatus__c='New';
     ordline18.Apttus_Config2__Quantity__c=1.000;
     ordline18.Apttus_Config2__LineNumber__c=1;
     ordline18.APTS_Contract_Line_Number__c=1;
     ordline18.Apttus_Config2__OptionId__c=oProductB.id;
     ordline18.Apttus_Config2__NetPrice__c=80.000;
     ordline18.Apttus_Config2__ListPrice__c=200.00;
     ordline18.Apttus_Config2__ProductId__c=oProductB.id;
     ordline18.APTS_Group__c='Bundle A';
     ordline18.APTS_Bridge__c='2 Years';
     ordline18.Apttus_Config2__LineType__c = 'Product/Service';
     ordline18.APTS_Program_ID__c = 'FIRMSITE';
     ordline18.Apttus_Config2__AdjustmentType__c ='Discount Amount';
     ordline18.APTS_Contract_Term__c='1 Year';
     ordline18.Apttus_QPConfig__ProposalLineItemId__c=li1.id;
     ordline18.APTS_Priced_Number_of_Attorneys__c=10;
     ordline18.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline18.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline18.APTS_Term_Type__c='Co-Term and ProRate';
     oliList.add(ordline18);   
       insert oliList;
                 
     
       Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob1;
       attach1.parentId=oProposal1.id;
       insert attach1;
       System.assertEquals(2,proposalList.size());
       /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
       Database.executeBatch(new Aptts_BatchOrderSubmission());
       CorpOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,1);*/
       Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'Corp OneOTC US');
       orderrecords.put(order1.Id,'Corp OneOTC US');
        APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order.Id);
   APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order1.Id);
       Test.stopTest();
      
    }catch(Exception ex){
    }
    }
    
 @isTest static void corpUKOrderTest(){      
     try{
       Account acc = [Select id from Account where name='Test'];
       Contact oContact = [select id from Contact limit 1];
       Opportunity o = [select id from Opportunity limit 1];
       Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
       User u = [select id,Username  from user where Email = 'user@mydomain.com'];
       Product2 oProductB=[select id,ProductCode from Product2 where ProductCode = '40475630' ];
       Product2 oProductP=[select id,ProductCode from Product2 where ProductCode = '40588593' ];
       Product2 oProductA=[select id,ProductCode from Product2 where ProductCode = '30010890' ];

            
         oProductB.APTS_FL_Renewal_Only_Clone__c='Yes';
         update oProductB;
        Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get(propRecordTypeName).getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal1 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal1.RecordTypeId=propRecordTypeId;
        oProposal1.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal1.Apttus_Proposal__Account__c = acc.Id;
        oProposal1.APTS_Payment_Option__c ='Credit Card';          
        oProposal1.CurrencyIsoCode = 'USD';
        oProposal1.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal1.APTS_Card_Expiration_Date__c= System.Today();
        oProposal1.APTS_amount__c = 30;
        oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal1.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal1.ownerid=u.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal1.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal1);

        Apttus_Proposal__Proposal__c oProposal2 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal2.RecordTypeId=propRecordTypeId;
        oProposal2.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal2.Apttus_Proposal__Account__c = acc.Id;
        oProposal2.APTS_Payment_Option__c ='Credit Card';          
        oProposal2.CurrencyIsoCode = 'USD';
        oProposal2.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal2.APTS_Card_Expiration_Date__c= System.Today();
        oProposal2.APTS_amount__c = 30;
        oProposal2.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal2.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal2.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal2.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal2.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal2.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal2.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal2.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal2.ownerid=u.id;
        oProposal2.APTS_Revenue_Channel_Override__c='05';
        oProposal2.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal2.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal2.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal2);
        insert proposalList;
      
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);
          Test.startTest(); 
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = APTS_TestDataFactory.proposallineitem( prodConfig.Id,oProposal1.id);
      li1.Apttus_Proposal__Product__c = oProductB.Id;
      li1.APTS_Number_of_Attorneys__c = 5;
      listLineItems.add(li1);       
           
      Apttus_Proposal__Proposal_Line_Item__c li2 =  APTS_TestDataFactory.proposallineitem(prodConfig.Id,oProposal2.id);
      li2.Apttus_Proposal__Product__c = oProductP.Id;
      li2.APTS_Number_of_Attorneys__c = 5;
      li2.APTS_Category_Name__c='FS 1';
      listLineItems.add(li2);
      insert listLineItems;
      
  
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()+1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()-1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);                                 
      orderList.add(order);
      orderList.add(order1);
      insert orderList;
      
      Apttus_Config2__AssetLineItem__c assetLineItem=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductB.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
      insert assetLineItem;
      
       Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
       insert task;
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
      Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,APTS_Term_Type__c='Delivery Date',Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
     Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,APTS_Term_Type__c='Co-Term',
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Months',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);                                                  
     Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);  
     Apttus_Config2__OrderLineItem__c ordline5=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='3 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='4 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='10 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='3 Years',APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0);                                                  
    Apttus_Config2__OrderLineItem__c ordline11 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,APTS_Deal_Number__c=5,Apttus_Config2__EndDate__c=System.today(),Apttus_Config2__NetPrice__c=80.000,
                                                  Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                  APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
    Apttus_Config2__OrderLineItem__c ordline12 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='4 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline14=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Evergreen');
    Apttus_Config2__OrderLineItem__c ordline15=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline16=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline17=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline18=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline19=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    
     Apttus_Config2__OrderLineItem__c ordline20=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline21=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline22=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline23=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline24=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline25=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline26=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline27=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                    Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
 
    Apttus_Config2__OrderLineItem__c ordline28 = new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ListPrice__c=200.00,Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__ChargeType__c='Subscription Fee',Apttus_Config2__PriceType__c='One Time',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,APTS_Renewal_Type__c='ProRate',Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0,
                                                   APTS_WLEC_Product_Category__c='PS',APTS_Term_Type__c='ProRate',APTS_Start_Date__c=system.today()-1);
    Apttus_Config2__OrderLineItem__c ordline29 = new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ListPrice__c=200.00,Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__ChargeType__c='Subscription Fee',Apttus_Config2__PriceType__c='One Time',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='1 Year',APTS_Priced_Number_of_Attorneys__c=10,APTS_Renewal_Type__c='Co-Term and ProRate',Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0,
                                                   APTS_WLEC_Product_Category__c='PS',APTS_Term_Type__c='ProRate',APTS_Start_Date__c=system.today()+2);
         
         
    Apttus_Config2__OrderLineItem__c ordline30=  new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',APTS_Contract_Term__c='2 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Term_Type__c = 'Co-Term and ProRate',APTS_End_Date__c=System.Today()+7); 
       oliList.add(ordline30); 
       oliList.add(ordline29);     
       oliList.add(ordline28);     
       oliList.add(ordline13);
       oliList.add(ordline1);       
       oliList.add(ordline12); 
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
       oliList.add(ordline14);  
       oliList.add(ordline15);
       oliList.add(ordline16);
       oliList.add(ordline17);
       oliList.add(ordline18);
       oliList.add(ordline19);
       oliList.add(ordline20); 
       oliList.add(ordline21);
       oliList.add(ordline22);
       oliList.add(ordline23);
       oliList.add(ordline24);
       oliList.add(ordline25);
       oliList.add(ordline26);     
       oliList.add(ordline27);  
       insert oliList;
       
       
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductA.ProductCode,QuoteId__c = oProposal1.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal1.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
         insert onlineContactList;
       
      Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob1;
       attach1.parentId=oProposal1.id;
       insert attach1;
       Integration_Logger__c loggerRec=new Integration_Logger__c(Object_Name__c='Quote/Proposal',Order__c=order.id,Request_Type__c='Outbound',Service_Name__c='OrderSubmission',Request_Message__c='Unauthorized',Success__c=false);
       insert loggerRec;
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());
            CorpOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,2);*/
            Map<Id,String> orderrecords = new Map<Id,String>();
            orderrecords.put(order.Id,'Corp OneOTC US');
            orderrecords.put(order1.Id,'Corp OneOTC US');
             APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order.Id);
           APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order1.Id);
            System.assertEquals(2,proposalList.size());
     Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

        /*ContentVersion cv = new ContentVersion();
           cv.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv.Title = 'signed Demo.pdf'; // Display name of the files
           cv.VersionData = beforeblob; // converting your binary string to Blog
           insert cv;
                        
           Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe = new ContentDocumentLink();
           cDe.ContentDocumentId = conDoc;
           cDe.LinkedEntityId = oProposal1.Id; // you can use objectId,GroupId etc
           cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe;*/
       

        
       
        Test.stopTest();
      }catch(Exception ex){
    }
    
    }
    
    
    @isTest static void digitalSignatureTest(){      
     try{
       Account acc = [Select id from Account where name='Test'];
       Contact oContact = [select id from Contact limit 1];
       Opportunity o = [select id from Opportunity limit 1];
       Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
       User u = [select id,Username  from user where Email = 'user@mydomain.com'];
       Product2 oProductB=[select id,ProductCode from Product2 where ProductCode = '40475630' ];
       Product2 oProductP=[select id,ProductCode from Product2 where ProductCode = '40588593' ];
       Product2 oProductA=[select id,ProductCode from Product2 where ProductCode = '30010890' ];

         
         oProductB.APTS_FL_Renewal_Only_Clone__c='Yes';
         update oProductB;
        Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get(propRecordTypeName).getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal1 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal1.RecordTypeId=propRecordTypeId;
        oProposal1.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal1.Apttus_Proposal__Account__c = acc.Id;
        oProposal1.APTS_Payment_Option__c ='Credit Card';          
        oProposal1.CurrencyIsoCode = 'USD';
        oProposal1.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal1.APTS_Card_Expiration_Date__c= System.Today();
        oProposal1.APTS_amount__c = 30;
        oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal1.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal1.ownerid=u.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal1.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal1);

        Apttus_Proposal__Proposal__c oProposal2 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal2.RecordTypeId=propRecordTypeId;
        oProposal2.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal2.Apttus_Proposal__Account__c = acc.Id;
        oProposal2.APTS_Payment_Option__c ='Credit Card';          
        oProposal2.CurrencyIsoCode = 'USD';
        oProposal2.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal2.APTS_Card_Expiration_Date__c= System.Today();
        oProposal2.APTS_amount__c = 30;
        oProposal2.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal2.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal2.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal2.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal2.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal2.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal2.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal2.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal2.ownerid=u.id;
        oProposal2.APTS_Revenue_Channel_Override__c='05';
        oProposal2.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal2.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal2.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal2);
        insert proposalList;
         Test.startTest();   
  
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);

      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = APTS_TestDataFactory.proposallineitem( prodConfig.Id,oProposal1.id);
      li1.Apttus_Proposal__Product__c = oProductB.Id;
      li1.APTS_Number_of_Attorneys__c = 5;
      listLineItems.add(li1);       
           
      Apttus_Proposal__Proposal_Line_Item__c li2 =  APTS_TestDataFactory.proposallineitem(prodConfig.Id,oProposal2.id);
      li2.Apttus_Proposal__Product__c = oProductP.Id;
      li2.APTS_Number_of_Attorneys__c = 5;
      li2.APTS_Category_Name__c='FS 1';
      listLineItems.add(li2);
      insert listLineItems;
     
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()+1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()-1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);                                 
      orderList.add(order);
      orderList.add(order1);
      insert orderList;
      
      Apttus_Config2__AssetLineItem__c assetLineItem=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductB.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
      insert assetLineItem;
      
       Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
       insert task;
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
      Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,APTS_Term_Type__c='Delivery Date',Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
     Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,APTS_Term_Type__c='Co-Term',
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Months',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);                                                  
     Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);  
     Apttus_Config2__OrderLineItem__c ordline5=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='3 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='4 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='10 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='3 Years',APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0);                                                  
    Apttus_Config2__OrderLineItem__c ordline11 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,APTS_Deal_Number__c=5,Apttus_Config2__EndDate__c=System.today(),Apttus_Config2__NetPrice__c=80.000,
                                                  Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                  APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
    Apttus_Config2__OrderLineItem__c ordline12 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='4 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline14=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Evergreen');
    Apttus_Config2__OrderLineItem__c ordline15=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline16=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline17=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline18=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline19=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    
     Apttus_Config2__OrderLineItem__c ordline20=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline21=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline22=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline23=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline24=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline25=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline26=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline27=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                    Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
 
    Apttus_Config2__OrderLineItem__c ordline28 = new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ListPrice__c=200.00,Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__ChargeType__c='Subscription Fee',Apttus_Config2__PriceType__c='One Time',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,APTS_Renewal_Type__c='ProRate',Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0,
                                                   APTS_WLEC_Product_Category__c='PS',APTS_Term_Type__c='ProRate',APTS_Start_Date__c=system.today()-1);
    Apttus_Config2__OrderLineItem__c ordline29 = new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ListPrice__c=200.00,Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__ChargeType__c='Subscription Fee',Apttus_Config2__PriceType__c='One Time',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='1 Year',APTS_Priced_Number_of_Attorneys__c=10,APTS_Renewal_Type__c='Co-Term and ProRate',Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0,
                                                   APTS_WLEC_Product_Category__c='PS',APTS_Term_Type__c='ProRate',APTS_Start_Date__c=system.today()+2);
         
         
    Apttus_Config2__OrderLineItem__c ordline30=  new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',APTS_Contract_Term__c='2 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Term_Type__c = 'Co-Term and ProRate',APTS_End_Date__c=System.Today()+7); 
       oliList.add(ordline30); 
       oliList.add(ordline29);     
       oliList.add(ordline28);     
       oliList.add(ordline13);
       oliList.add(ordline1);       
       oliList.add(ordline12); 
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
       oliList.add(ordline14);  
       oliList.add(ordline15);
       oliList.add(ordline16);
       oliList.add(ordline17);
       oliList.add(ordline18);
       oliList.add(ordline19);
       oliList.add(ordline20); 
       oliList.add(ordline21);
       oliList.add(ordline22);
       oliList.add(ordline23);
       oliList.add(ordline24);
       oliList.add(ordline25);
       oliList.add(ordline26);     
       oliList.add(ordline27);  
       insert oliList;
       
       
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductA.ProductCode,QuoteId__c = oProposal1.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal1.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
         insert onlineContactList;
       
      Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob1;
       attach1.parentId=oProposal1.id;
       insert attach1;
       Integration_Logger__c loggerRec=new Integration_Logger__c(Object_Name__c='Quote/Proposal',Order__c=order.id,Request_Type__c='Outbound',Service_Name__c='OrderSubmission',Request_Message__c='Unauthorized',Success__c=false);
       insert loggerRec;
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());
            CorpOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,2);*/
            Map<Id,String> orderrecords = new Map<Id,String>();
            orderrecords.put(order.Id,'Corp OneOTC US');
            orderrecords.put(order1.Id,'Corp OneOTC US');
             APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order.Id);
      // APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order1.Id);
            System.assertEquals(2,proposalList.size());
     Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

        ContentVersion cv3 = new ContentVersion();
           cv3.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv3.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv3.Title = 'Digital Signature Detail.pdf'; // Display name of the files
           cv3.VersionData = beforeblob; // converting your binary string to Blog
           insert cv3;
                        
           Id conDoc3 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv3.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe3 = new ContentDocumentLink();
           cDe3.ContentDocumentId = conDoc3;
           cDe3.LinkedEntityId = oProposal1.Id; // you can use objectId,GroupId etc
           cDe3.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe3;    
       

        
       
        Test.stopTest();
      }catch(Exception ex){
    }
    
    }
    
    @isTest static void cvmsOfferSheetTest(){      
     try{
       Account acc = [Select id from Account where name='Test'];
       Contact oContact = [select id from Contact limit 1];
       Opportunity o = [select id from Opportunity limit 1];
       Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
       User u = [select id,Username  from user where Email = 'user@mydomain.com'];
       Product2 oProductB=[select id,ProductCode from Product2 where ProductCode = '40475630' ];
       Product2 oProductP=[select id,ProductCode from Product2 where ProductCode = '40588593' ];
       Product2 oProductA=[select id,ProductCode from Product2 where ProductCode = '30010890' ];

         
         oProductB.APTS_FL_Renewal_Only_Clone__c='Yes';
         update oProductB;
        Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get(propRecordTypeName).getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal1 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal1.RecordTypeId=propRecordTypeId;
        oProposal1.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal1.Apttus_Proposal__Account__c = acc.Id;
        oProposal1.APTS_Payment_Option__c ='Credit Card';          
        oProposal1.CurrencyIsoCode = 'USD';
        oProposal1.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal1.APTS_Card_Expiration_Date__c= System.Today();
        oProposal1.APTS_amount__c = 30;
        oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal1.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal1.ownerid=u.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal1.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal1);

        Apttus_Proposal__Proposal__c oProposal2 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal2.RecordTypeId=propRecordTypeId;
        oProposal2.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal2.Apttus_Proposal__Account__c = acc.Id;
        oProposal2.APTS_Payment_Option__c ='Credit Card';          
        oProposal2.CurrencyIsoCode = 'USD';
        oProposal2.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal2.APTS_Card_Expiration_Date__c= System.Today();
        oProposal2.APTS_amount__c = 30;
        oProposal2.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal2.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal2.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal2.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal2.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal2.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal2.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal2.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal2.ownerid=u.id;
        oProposal2.APTS_Revenue_Channel_Override__c='05';
        oProposal2.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal2.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal2.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal2);
        insert proposalList;
         Test.startTest();  
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);

      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = APTS_TestDataFactory.proposallineitem( prodConfig.Id,oProposal1.id);
      li1.Apttus_Proposal__Product__c = oProductB.Id;
      li1.APTS_Number_of_Attorneys__c = 5;
      listLineItems.add(li1);       
           
      Apttus_Proposal__Proposal_Line_Item__c li2 =  APTS_TestDataFactory.proposallineitem(prodConfig.Id,oProposal2.id);
      li2.Apttus_Proposal__Product__c = oProductP.Id;
      li2.APTS_Number_of_Attorneys__c = 5;
      li2.APTS_Category_Name__c='FS 1';
      listLineItems.add(li2);
      insert listLineItems;
      
  
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()+1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()-1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);                                 
      orderList.add(order);
      orderList.add(order1);
      insert orderList;
      
      Apttus_Config2__AssetLineItem__c assetLineItem=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductB.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
      insert assetLineItem;
      
       Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
       insert task;
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
      Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,APTS_Term_Type__c='Delivery Date',Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
     Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,APTS_Term_Type__c='Co-Term',
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Months',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);                                                  
     Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);  
     Apttus_Config2__OrderLineItem__c ordline5=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='3 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='4 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='10 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='3 Years',APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0);                                                  
    Apttus_Config2__OrderLineItem__c ordline11 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,APTS_Deal_Number__c=5,Apttus_Config2__EndDate__c=System.today(),Apttus_Config2__NetPrice__c=80.000,
                                                  Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                  APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
    Apttus_Config2__OrderLineItem__c ordline12 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='4 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline14=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Evergreen');
    Apttus_Config2__OrderLineItem__c ordline15=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline16=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline17=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline18=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline19=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    
     Apttus_Config2__OrderLineItem__c ordline20=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline21=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline22=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline23=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline24=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline25=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline26=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline27=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                    Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
 
    Apttus_Config2__OrderLineItem__c ordline28 = new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ListPrice__c=200.00,Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__ChargeType__c='Subscription Fee',Apttus_Config2__PriceType__c='One Time',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,APTS_Renewal_Type__c='ProRate',Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0,
                                                   APTS_WLEC_Product_Category__c='PS',APTS_Term_Type__c='ProRate',APTS_Start_Date__c=system.today()-1);
    Apttus_Config2__OrderLineItem__c ordline29 = new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ListPrice__c=200.00,Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__ChargeType__c='Subscription Fee',Apttus_Config2__PriceType__c='One Time',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='1 Year',APTS_Priced_Number_of_Attorneys__c=10,APTS_Renewal_Type__c='Co-Term and ProRate',Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0,
                                                   APTS_WLEC_Product_Category__c='PS',APTS_Term_Type__c='ProRate',APTS_Start_Date__c=system.today()+2);
         
         
    Apttus_Config2__OrderLineItem__c ordline30=  new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',APTS_Contract_Term__c='2 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Term_Type__c = 'Co-Term and ProRate',APTS_End_Date__c=System.Today()+7); 
       oliList.add(ordline30); 
       oliList.add(ordline29);     
       oliList.add(ordline28);     
       oliList.add(ordline13);
       oliList.add(ordline1);       
       oliList.add(ordline12); 
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
       oliList.add(ordline14);  
       oliList.add(ordline15);
       oliList.add(ordline16);
       oliList.add(ordline17);
       oliList.add(ordline18);
       oliList.add(ordline19);
       oliList.add(ordline20); 
       oliList.add(ordline21);
       oliList.add(ordline22);
       oliList.add(ordline23);
       oliList.add(ordline24);
       oliList.add(ordline25);
       oliList.add(ordline26);     
       oliList.add(ordline27);  
       insert oliList;
       
       
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductA.ProductCode,QuoteId__c = oProposal1.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal1.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
         insert onlineContactList;
       
      Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob1;
       attach1.parentId=oProposal1.id;
       insert attach1;
       Integration_Logger__c loggerRec=new Integration_Logger__c(Object_Name__c='Quote/Proposal',Order__c=order.id,Request_Type__c='Outbound',Service_Name__c='OrderSubmission',Request_Message__c='Unauthorized',Success__c=false);
       insert loggerRec;
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());
            CorpOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,2);*/
            Map<Id,String> orderrecords = new Map<Id,String>();
            orderrecords.put(order.Id,'Corp OneOTC US');
            orderrecords.put(order1.Id,'Corp OneOTC US');
             APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order.Id);
          APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order1.Id);
            System.assertEquals(2,proposalList.size());
     Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

        /*ContentVersion cv1 = new ContentVersion();
           cv1.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv1.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv1.Title = 'CVMS Offer Sheet Demo.pdf'; // Display name of the files
           cv1.VersionData = beforeblob; // converting your binary string to Blog
           insert cv1;
                        
           Id conDoc1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv1.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe1 = new ContentDocumentLink();
           cDe1.ContentDocumentId = conDoc1;
           cDe1.LinkedEntityId = oProposal1.Id; // you can use objectId,GroupId etc
           cDe1.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe1;*/
       

        
       
        Test.stopTest();
      }catch(Exception ex){
    }
    
    }
    @isTest static void orderTestOneContact() {

   try{
       Account acc = [Select id from Account where name='Test'];
       Contact oContact = [select id from Contact limit 1];
       Opportunity o = [select id from Opportunity limit 1];
       Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
       User u = [select id,Username  from user where Email = 'user@mydomain.com'];
       Product2 oProductB=[select id from Product2 where ProductCode = '40475630' ];
       Product2 oProductP=[select id from Product2 where ProductCode = '40588593' ];
       Product2 oProductA=[select id from Product2 where ProductCode = '30010890' ];

      LCRM_Contact_SSD__c contactSSD1 = new  LCRM_Contact_SSD__c();
      contactSSD1.LCRM_Email__c= 'test10923@gmail.com';
      contactSSD1.LCRM_Account_SSD__c = accountSSD.id;
      contactSSD1.LCRM_Contact__c = oContact.id;
      insert contactSSD1;
      
      LCRM_Contact_SSD__c contactSSD2 = new  LCRM_Contact_SSD__c();
      contactSSD2.LCRM_Email__c= 'test67123@gmail.com';
      contactSSD2.LCRM_Account_SSD__c = accountSSD.id;
      contactSSD2.LCRM_Contact__c = oContact.id;
      insert contactSSD2;
      
      LCRM_Contact_SSD__c contactSSD3 = new  LCRM_Contact_SSD__c();
      contactSSD3.LCRM_Email__c= 'test19823@gmail.com';
      contactSSD3.LCRM_Account_SSD__c = accountSSD.id;
      contactSSD3.LCRM_Contact__c = oContact.id;
      insert contactSSD3;
         
      
          
        Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get(propRecordTypeName).getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal1 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal1.RecordTypeId=propRecordTypeId;
        oProposal1.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal1.Apttus_Proposal__Account__c = acc.Id;
        oProposal1.APTS_Payment_Option__c ='Credit Card';          
        oProposal1.CurrencyIsoCode = 'USD';
        oProposal1.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal1.APTS_Card_Expiration_Date__c= System.Today();
        oProposal1.APTS_amount__c = 30;
        oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal1.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal1.ownerid=u.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal1.APTS_Ebilling_contact__c=oContact.id;
        oProposal1.APTS_Wet_Signature__c=False;
 
        proposalList.add(oProposal1);

        Apttus_Proposal__Proposal__c oProposal2 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal2.RecordTypeId=propRecordTypeId;
        oProposal2.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal2.Apttus_Proposal__Account__c = acc.Id;
        oProposal2.APTS_Payment_Option__c ='Credit Card';          
        oProposal2.CurrencyIsoCode = 'USD';
        oProposal2.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal2.APTS_Card_Expiration_Date__c= System.Today();
        oProposal2.APTS_amount__c = 30;
        oProposal2.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal2.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal2.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal2.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal2.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal2.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal2.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal2.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal2.ownerid=u.id;
        oProposal2.APTS_Revenue_Channel_Override__c='05';
        oProposal2.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal2.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal2.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal2);
        insert proposalList;
         Test.startTest(); 
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);

      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = APTS_TestDataFactory.proposallineitem( prodConfig.Id,oProposal1.id);
      li1.Apttus_Proposal__Product__c = oProductB.Id;
      li1.APTS_Number_of_Attorneys__c = 5;
      listLineItems.add(li1);       
           
      Apttus_Proposal__Proposal_Line_Item__c li2 =  APTS_TestDataFactory.proposallineitem(prodConfig.Id,oProposal2.id);
      li2.Apttus_Proposal__Product__c = oProductP.Id;
      li2.APTS_Number_of_Attorneys__c = 5;
      li2.APTS_Category_Name__c='FS 1';
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
      
       Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
       insert task;
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
     Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
     Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);                                                  
     Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);  
     Apttus_Config2__OrderLineItem__c ordline5=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='3 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='4 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='10 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='3 Years',APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0);                                                  
    Apttus_Config2__OrderLineItem__c ordline11 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,APTS_Deal_Number__c=5,Apttus_Config2__EndDate__c=System.today(),Apttus_Config2__NetPrice__c=80.000,
                                                  Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                  APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
    Apttus_Config2__OrderLineItem__c ordline12 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='4 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
    Apttus_Config2__OrderLineItem__c ordline14 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                  APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Term_Type__c = 'Co-Term',APTS_End_Date__c=System.Today()+7); 
     
   Apttus_Config2__OrderLineItem__c ordline15 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Term_Type__c = 'ProRate',APTS_End_Date__c=System.Today()+7 );
     
 Apttus_Config2__OrderLineItem__c ordline16 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                 APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Term_Type__c = 'Co-Term and ProRate',APTS_End_Date__c=System.Today()+7); 
         //insert ordline13;    
    //insert ordline13;
       oliList.add(ordline13);
       oliList.add(ordline1);       
       oliList.add(ordline12); 
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
        oliList.add(ordline14);
       oliList.add(ordline15);
       oliList.add(ordline16);     
       insert oliList;
      
      Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob1;
       attach1.parentId=oProposal1.id;
       insert attach1;
       
            oProposal1.APTS_Bill_To_Contact__c = contactSSD1.id;
            oProposal1.APTS_Sold_To_Contact__c = contactSSD2.id;
            oProposal1.APTS_Ship_To_Contact__c = contactSSD3.id;
            update oProposal1;
            System.assertEquals(2,proposalList.size());
       
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());
            CorpOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,1);*/
            Map<Id,String> orderrecords = new Map<Id,String>();
            orderrecords.put(order.Id,'Corp OneOTC US');
            orderrecords.put(order1.Id,'Corp OneOTC US');
             APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order.Id);
            // APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order1.Id);
        Test.stopTest();
      
    }catch(Exception ex){
    }
    }
    
    @isTest static void newMethod(){   
   try{
       Account acc = [Select id from Account where Name='Test'];
          
       Contact oContact = [select id from Contact limit 1];
        
          
       Opportunity o = [select id from Opportunity limit 1];
       Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
       User u = [select id,Username  from user where Email = 'user@mydomain.com'];
       u.Sales_Force_Description__c='Home Office';
       update u;
          
           Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
          
          Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
       Product2 oProductB=[select id , ProductCode from Product2 where ProductCode = '40475630' ];
       Product2 oProductP=[select id,ProductCode from Product2 where ProductCode = '40588593' ];
       Product2 oProductA=[select id,ProductCode from Product2 where ProductCode = '30010890' ];
  
          
         acc.Fiscal_Year_End__c='01-Jan';
         acc.VAT_Number__c='12311';
          update acc;
          
         oContact.SAP_Contact_ID__c='1234';
         update oContact;
          
       oProductA.APTS_Item_Category_Group__c='ZRRB';
       oProductA.APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family;
       oProductA.APTS_Pricing_Qty_Type__c='abc';
       update oProductA;
       
         oProductB.APTS_FL_Renewal_Only_Clone__c='Yes';
         update oProductB;
        Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get(propRecordTypeName).getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal1 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal1.RecordTypeId=propRecordTypeId;
        oProposal1.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal1.Apttus_Proposal__Account__c = acc.Id;
        oProposal1.APTS_Payment_Option__c ='Credit Card';          
        oProposal1.CurrencyIsoCode = 'USD';
        oProposal1.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal1.APTS_Card_Expiration_Date__c= System.Today();
        oProposal1.APTS_amount__c = 30;
        oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal1.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal1.APTS_Fiscal_Filer__c=true;
        oProposal1.ownerid=u.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.Apttus_QPConfig__PONumber__c = '123456798123456789';
        oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal1.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal1);

        Apttus_Proposal__Proposal__c oProposal2 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal2.RecordTypeId=propRecordTypeId;
        oProposal2.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal2.Apttus_Proposal__Account__c = acc.Id;
        oProposal2.APTS_Payment_Option__c ='Credit Card';          
        oProposal2.CurrencyIsoCode = 'USD';
        oProposal2.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal2.APTS_Card_Expiration_Date__c= System.Today();
        oProposal2.APTS_amount__c = 30;
        oProposal2.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal2.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal2.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal2.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal2.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal2.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal2.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal2.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal2.ownerid=u.id;
        oProposal2.APTS_Notes__c='ABCxyz';
        oProposal2.APTS_Fiscal_Filer__c=true; 
        oProposal2.APTS_Revenue_Channel_Override__c='05';
        oProposal2.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal2.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal2.APTS_Ebilling_contact__c=oContact.id;
         oProposal2.Digital_Quote_Type__c='Manual';
        proposalList.add(oProposal2);
        insert proposalList;
             Test.startTest(); 
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
       Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal2.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
       onlineContactList.add(oc1);
       Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal2.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
       onlineContactList.add(oc2);
       Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal2.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
       onlineContactList.add(oc3); 
       Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal2.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
       onlineContactList.add(oc4);     
       Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal2.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
       onlineContactList.add(oc5);     
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal2.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
       onlineContactList.add(oc6);  
           Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal2.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Tax Professional',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
       onlineContactList.add(oc7);  
       insert onlineContactList;
       
           Apttus_Config2__AssetLineItem__c asli =new Apttus_Config2__AssetLineItem__c();
      asli.APTS_Info_RenewalDate__c=system.today();
          insert asli;
          
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);
          insert prodConfig;

          
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = APTS_TestDataFactory.proposallineitem( prodConfig.Id,oProposal1.id);
      li1.Apttus_Proposal__Product__c = oProductB.Id;
      li1.APTS_Number_of_Attorneys__c = 0;
      listLineItems.add(li1);
          
      Apttus_Proposal__Proposal_Line_Item__c li2 =  APTS_TestDataFactory.proposallineitem(prodConfig.Id,oProposal2.id);
      li2.Apttus_Proposal__Product__c = oProductP.Id;
      li2.APTS_Number_of_Attorneys__c = 0;
      li2.APTS_Category_Name__c='FS 1';
      listLineItems.add(li2);
      insert listLineItems;
      
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__OrderDate__c=system.today()+2,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__OrderDate__c=system.today()-2,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);                                 
      orderList.add(order);
      orderList.add(order1);
      insert orderList;
       Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order1.id,Description='this is task');
       insert task;
          
     List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();    
     Apttus_Config2__OrderLineItem__c ordline1 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline1.Apttus_Config2__LineStatus__c='New';
     ordline1.Apttus_Config2__Quantity__c=1.000;
     ordline1.Apttus_Config2__LineNumber__c=1;
     ordline1.APTS_Contract_Line_Number__c=1;
     ordline1.Apttus_Config2__OptionId__c=oProductB.id;
     ordline1.Apttus_Config2__NetPrice__c=80.000;
     ordline1.Apttus_Config2__ListPrice__c=200.00;
     //ordline1.Apttus_Config2__AttributeValueId__c=orderPattr.id;
     ordline1.Apttus_Config2__ProductId__c=oProductA.id;
     ordline1.APTS_Group__c='Bundle A';
     ordline1.APTS_Bridge__c='N/a';
     ordline1.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline1.Apttus_Config2__PriceType__c='One Time';
     ordline1.Apttus_Config2__LineType__c = 'Product/Service';
     ordline1.APTS_Program_ID__c = 'FIRMSITE';
     ordline1.Apttus_Config2__AdjustmentType__c ='% Markup';
     ordline1.APTS_Contract_Term__c='1 Year';
     ordline1.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline1.APTS_Renewal_Type__c='Term Commitment';
     ordline1.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline1.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline1.APTS_WLEC_Product_Category__c='PS';
     ordline1.APTS_Term_Type__c='';
     ordline1.APTS_Subscription_Number__c='1223345';
     ordline1.APTS_Start_Date__c=system.today();
     ordline1.Apttus_Config2__AssetLineItemId__c=asli.id;
    ordline1.APTS_Term_Type__c='Co-Term and ProRate';
     ordline1.APTS_End_Date__c =system.today()+10;
     oliList.add(ordline1);
          
           Apttus_Config2__OrderLineItem__c ordline =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline.Apttus_Config2__LineStatus__c='New';
     ordline.Apttus_Config2__Quantity__c=1.000;
     ordline.Apttus_Config2__LineNumber__c=1;
     ordline.APTS_Contract_Line_Number__c=1;
     ordline.Apttus_Config2__OptionId__c=oProductB.id;
     ordline.Apttus_Config2__NetPrice__c=80.000;
     ordline.Apttus_Config2__ListPrice__c=200.00;
     //ordline1.Apttus_Config2__AttributeValueId__c=orderPattr.id;
     ordline.Apttus_Config2__ProductId__c=oProductA.id;
     ordline.APTS_Group__c='Bundle A';
     ordline.APTS_Bridge__c='N/a';
     ordline.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline.Apttus_Config2__PriceType__c='One Time';
     ordline.Apttus_Config2__LineType__c = 'Product/Service';
     ordline.APTS_Program_ID__c = 'FIRMSITE';
     ordline.Apttus_Config2__AdjustmentType__c ='% Markup';
     ordline.APTS_Contract_Term__c='Short Term Trial';
     ordline.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     //Ordlie1.APTS_Priced_Number_of_Attorneys__c=10;
     ordline.APTS_Renewal_Type__c='Term Commitment';
     ordline.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline.APTS_WLEC_Product_Category__c='PS';
     ordline.APTS_Term_Type__c='';
     ordline.APTS_Subscription_Number__c='1223345';
     ordline.APTS_Start_Date__c=system.today();
     ordline.Apttus_Config2__AssetLineItemId__c=asli.id;
    ordline.APTS_Term_Type__c='Co-Term and ProRate';
    ordline.APTS_Is_Multi_Tiered_Pricing__c=true;
     ordline.APTS_End_Date__c =system.today()+10;
     oliList.add(ordline);   
     
     Apttus_Config2__OrderLineItem__c ordline31 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline31.Apttus_Config2__LineStatus__c='New';
     ordline31.Apttus_Config2__Quantity__c=1.000;
     ordline31.Apttus_Config2__LineNumber__c=1;
     ordline31.APTS_Contract_Line_Number__c=1;
     ordline31.Apttus_Config2__OptionId__c=oProductB.id;
     ordline31.Apttus_Config2__NetPrice__c=80.000;
     ordline31.Apttus_Config2__ListPrice__c=200.00;
     //ordline31.Apttus_Config2__AttributeValueId__c=orderPattr.id;
     ordline31.Apttus_Config2__ProductId__c=oProductA.id;
     ordline31.APTS_Group__c='Bundle A';
     ordline31.APTS_Is_Multi_Tiered_Pricing__c=true;     
     ordline31.APTS_Bridge__c='1 Month';
     ordline31.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline31.Apttus_Config2__PriceType__c='One Time';
     ordline31.Apttus_Config2__LineType__c = 'Product/Service';
     ordline31.APTS_Program_ID__c = 'FIRMSITE';
     ordline31.Apttus_Config2__AdjustmentType__c ='% Markup';
     ordline31.APTS_Contract_Term__c='Short Term Trial';
     ordline31.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     //ordline31.APTS_Priced_Number_of_Attorneys__c=10;
     ordline31.APTS_Renewal_Type__c='Evergreen';
     ordline31.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline31.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline31.APTS_WLEC_Product_Category__c='PS';
     ordline31.APTS_Term_Type__c='';
     ordline31.APTS_Start_Date__c=system.today();
     ordline31.Apttus_Config2__AssetLineItemId__c=asli.id;
    ordline31.APTS_Term_Type__c='Co-Term and ProRate';
     ordline31.APTS_End_Date__c =system.today()+10;
     oliList.add(ordline31);   
     
     Apttus_Config2__OrderLineItem__c ordline30 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline30.Apttus_Config2__LineStatus__c='Pending';
     ordline30.Apttus_Config2__Quantity__c=1.000;
     ordline30.Apttus_Config2__LineNumber__c=1;
     ordline30.APTS_Contract_Line_Number__c=1;
     ordline30.Apttus_Config2__OptionId__c=oProductB.id;
     ordline30.Apttus_Config2__NetPrice__c=80.000;
     ordline30.Apttus_Config2__ListPrice__c=200.00;
     //ordline30.Apttus_Config2__AttributeValueId__c=orderPattr.id;
     ordline30.Apttus_Config2__ProductId__c=oProductA.id;
     ordline30.APTS_Group__c='Bundle A';
     ordline30.APTS_Bridge__c='2 Months';
     ordline30.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline30.Apttus_Config2__PriceType__c='One Time';
     ordline30.Apttus_Config2__LineType__c = 'Product/Service';
     ordline30.APTS_Program_ID__c = 'FIRMSITE';
     ordline30.Apttus_Config2__AdjustmentType__c ='% Markup';
     ordline30.APTS_Contract_Term__c='Short Term Trial';
     ordline30.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     //ordline30.APTS_Priced_Number_of_Attorneys__c=10;
     ordline30.APTS_Renewal_Type__c='Term Commitment';
     ordline30.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline30.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline30.APTS_WLEC_Product_Category__c='PS';
     ordline30.APTS_Term_Type__c='';
     ordline30.APTS_Start_Date__c=system.today();
     ordline30.Apttus_Config2__AssetLineItemId__c=asli.id;
    ordline30.APTS_Term_Type__c='Co-Term and ProRate';
     ordline30.APTS_Is_Multi_Tiered_Pricing__c=true;
     ordline30.APTS_End_Date__c =system.today()+10;
     oliList.add(ordline30);   
     
     Apttus_Config2__OrderLineItem__c ordline19 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline19.Apttus_Config2__LineStatus__c='Existing';
     ordline19.Apttus_Config2__Quantity__c=1.000;
     ordline19.Apttus_Config2__LineNumber__c=1;
     ordline19.APTS_Contract_Line_Number__c=1;
     ordline19.Apttus_Config2__OptionId__c=oProductB.id;
     ordline19.Apttus_Config2__NetPrice__c=80.000;
     ordline19.Apttus_Config2__ListPrice__c=200.00;
    //ordline19.Apttus_Config2__AttributeValueId__c=orderPattr.id;
     ordline19.Apttus_Config2__ProductId__c=oProductB.id;
     ordline19.APTS_Group__c='Bundle A';
     ordline19.APTS_Bridge__c='3 Months';
     ordline19.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline19.Apttus_Config2__PriceType__c='One Time';
     ordline19.Apttus_Config2__LineType__c = 'Product/Service';
     ordline19.APTS_Program_ID__c = 'FIRMSITE';
     ordline19.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline19.APTS_Contract_Term__c='1 Year';
     ordline19.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline19.APTS_Priced_Number_of_Attorneys__c=10;
     ordline19.APTS_Renewal_Type__c='Evergreen';
     ordline19.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline19.Apttus_Config2__AdjustedPrice__c=100.0;
     //ordline19.APTS_WLEC_Product_Category__c='PS';
     ordline19.APTS_Term_Type__c='ProRate';
     ordline19.APTS_Start_Date__c=system.today();
     ordline19.APTS_End_Date__c =system.today()+20;    
    ordline19.APTS_Term_Type__c='Co-Term and ProRate';  
     oliList.add(ordline19);   
     
     Apttus_Config2__OrderLineItem__c ordline20 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline20.Apttus_Config2__LineStatus__c='Cancelled';
     ordline20.Apttus_Config2__Quantity__c=1.000;
     ordline20.Apttus_Config2__LineNumber__c=1;
     ordline20.APTS_Contract_Line_Number__c=1;
     ordline20.Apttus_Config2__OptionId__c=oProductB.id;
     ordline20.Apttus_Config2__NetPrice__c=80.000;
     ordline20.Apttus_Config2__ListPrice__c=200.00;
   //  ordline20.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
     ordline20.Apttus_Config2__ProductId__c=oProductB.id;
     ordline20.APTS_Group__c='Bundle A';
     ordline20.APTS_Bridge__c='4 Months';
     ordline20.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline20.Apttus_Config2__PriceType__c='One Time';
     ordline20.Apttus_Config2__LineType__c = 'Product/Service';
     ordline20.APTS_Program_ID__c = 'FIRMSITE';
     ordline20.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline20.APTS_Contract_Term__c='1 Year';
     ordline20.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline20.APTS_Priced_Number_of_Attorneys__c=10;
     ordline20.APTS_Renewal_Type__c='Evergreen';
     ordline20.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline20.Apttus_Config2__AdjustedPrice__c=100.0;
     //ordline20.APTS_WLEC_Product_Category__c='PS';
     ordline20.APTS_Term_Type__c='ProRate';
     oliList.add(ordline20);   
     
     Apttus_Config2__OrderLineItem__c ordline2 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline2.Apttus_Config2__LineStatus__c='New';
     ordline2.Apttus_Config2__Quantity__c=1.000;
     ordline2.Apttus_Config2__LineNumber__c=1;
     ordline2.APTS_Contract_Line_Number__c=1;
     ordline2.Apttus_Config2__NetPrice__c=80.000;    
     ordline2.Apttus_Config2__ProductId__c=oProductA.id;
     ordline2.APTS_Group__c='Bundle A';
     ordline2.APTS_Bridge__c='14 Day';
     ordline2.Apttus_Config2__LineType__c = 'Product/Service';
     ordline2.APTS_Program_ID__c = 'FIRMSITE';
     ordline2.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline2.APTS_Contract_Term__c='2 Years';
     ordline2.APTS_Priced_Number_of_Attorneys__c=10;
     ordline2.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline2.Apttus_Config2__AdjustedPrice__c=10.0;
     ordline2.APTS_Term_Type__c='Delivery Date';
     ordline2.APTS_Renewal_Type__c=null;
     oliList.add(ordline2);   
     
     Apttus_Config2__OrderLineItem__c ordline3 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline3.Apttus_Config2__LineStatus__c='Renewed';
     ordline3.Apttus_Config2__Quantity__c=1.000;
     ordline3.Apttus_Config2__LineNumber__c=1;
     ordline3.APTS_Contract_Line_Number__c=1;
     ordline3.Apttus_Config2__NetPrice__c=80.000; 
     ordline3.APTS_Years_2_Plus_Adjustment__c='2';   
     ordline3.Apttus_Config2__ProductId__c=oProductP.id;
     ordline3.APTS_Group__c='Bundle A';
     ordline3.APTS_Bridge__c='4 Months';
     ordline3.Apttus_Config2__LineType__c = 'Product/Service';
     ordline3.APTS_Program_ID__c = 'FIRMSITE';
     ordline3.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline3.APTS_Contract_Term__c='11 Months';
     ordline3.APTS_Priced_Number_of_Attorneys__c=10;
     ordline3.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline3.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline3);   
     
     Apttus_Config2__OrderLineItem__c ordline4 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline4.Apttus_Config2__LineStatus__c='Renewed';
     ordline4.Apttus_Config2__Quantity__c=1.000;
     ordline4.Apttus_Config2__LineNumber__c=1;
     ordline4.APTS_Contract_Line_Number__c=1;
     ordline4.Apttus_Config2__NetPrice__c=80.000;
     ordline4.Apttus_Config2__OptionId__c=oProductB.id;
     ordline4.Apttus_Config2__ProductId__c=oProductB.id;
     ordline4.APTS_Group__c='Bundle A';
     ordline4.APTS_Bridge__c='5 Months';
     ordline4.Apttus_Config2__LineType__c = 'Product/Service';
     ordline4.APTS_Program_ID__c = 'FIRMSITE';
     ordline4.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline4.APTS_Contract_Term__c='1 Year';
     ordline4.APTS_Priced_Number_of_Attorneys__c=10;
     ordline4.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline4.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline4);

     Apttus_Config2__OrderLineItem__c ordline5 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline5.Apttus_Config2__LineStatus__c='Renewed';
     ordline5.Apttus_Config2__Quantity__c=1.000;
     ordline5.Apttus_Config2__LineNumber__c=1;
     ordline5.APTS_Contract_Line_Number__c=1;
     ordline5.Apttus_Config2__NetPrice__c=80.000;
     ordline5.Apttus_Config2__OptionId__c=oProductB.id;
     ordline5.Apttus_Config2__ProductId__c=oProductB.id;
     ordline5.APTS_Group__c='Bundle A';
     ordline5.APTS_Bridge__c='6 Months';
     ordline5.Apttus_Config2__LineType__c = 'Product/Service';
     ordline5.APTS_Program_ID__c = 'FIRMSITE';
     ordline5.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline5.APTS_Contract_Term__c='2 Years';
     ordline5.APTS_Priced_Number_of_Attorneys__c=10;
     ordline5.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline5.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline5);
     
     Apttus_Config2__OrderLineItem__c ordline6 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline6.Apttus_Config2__LineStatus__c='Renewed';
     ordline6.Apttus_Config2__Quantity__c=1.000;
     ordline6.Apttus_Config2__LineNumber__c=1;
     ordline6.APTS_Contract_Line_Number__c=1;
     ordline6.Apttus_Config2__NetPrice__c=80.000;
     ordline6.Apttus_Config2__OptionId__c=oProductB.id;
     ordline6.Apttus_Config2__ProductId__c=oProductB.id;
     ordline6.APTS_Group__c='Bundle A';
     ordline6.APTS_Bridge__c='4 Years';
     ordline6.Apttus_Config2__LineType__c = 'Product/Service';
     ordline6.APTS_Program_ID__c = 'FIRMSITE';
     ordline6.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline6.APTS_Contract_Term__c='3 Years';
     ordline6.APTS_Priced_Number_of_Attorneys__c=10;
     ordline6.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline6.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline6);
     
     Apttus_Config2__OrderLineItem__c ordline7 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline7.Apttus_Config2__LineStatus__c='Renewed';
     ordline7.Apttus_Config2__Quantity__c=1.000;
     ordline7.Apttus_Config2__LineNumber__c=1;
     ordline7.APTS_Contract_Line_Number__c=1;
     ordline7.Apttus_Config2__NetPrice__c=80.000;
     ordline7.Apttus_Config2__OptionId__c=oProductB.id;
     ordline7.Apttus_Config2__ProductId__c=oProductB.id;
     ordline7.APTS_Group__c='Bundle A';
     ordline7.APTS_Bridge__c='5 Years';
     ordline7.Apttus_Config2__LineType__c = 'Product/Service';
     ordline7.APTS_Program_ID__c = 'FIRMSITE';
     ordline7.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline7.APTS_Contract_Term__c='Short Term Trial';
     ordline7.APTS_Priced_Number_of_Attorneys__c=10;
     ordline7.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline7.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline7);
     
     Apttus_Config2__OrderLineItem__c ordline8 =  APTS_TestDataFactory.orderLineItem(order.id);
     ordline8.Apttus_Config2__LineStatus__c='Renewed';
     ordline8.Apttus_Config2__Quantity__c=1.000;
     ordline8.Apttus_Config2__LineNumber__c=1;
     ordline8.APTS_Contract_Line_Number__c=1;
     ordline8.Apttus_Config2__NetPrice__c=80.000;
     ordline8.Apttus_Config2__OptionId__c=oProductB.id;
     ordline8.Apttus_Config2__ProductId__c=oProductB.id;
     ordline8.APTS_Group__c='Bundle A';
     ordline8.APTS_Bridge__c='10 Years';
     ordline8.Apttus_Config2__LineType__c = 'Product/Service';
     ordline8.APTS_Program_ID__c = 'FIRMSITE';
     ordline8.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline8.APTS_Contract_Term__c='5 Years';
     ordline8.APTS_Priced_Number_of_Attorneys__c=10;
     ordline8.Apttus_Config2__BaseExtendedPrice__c=100.0;
     ordline8.Apttus_Config2__AdjustedPrice__c=10.0;
     oliList.add(ordline8);
     
         Apttus_Config2__OrderLineItem__c ordline9 =  APTS_TestDataFactory.orderLineItem(order.id);
         ordline9.Apttus_Config2__LineStatus__c='New';
         ordline9.Apttus_Config2__Quantity__c=1.000;
         ordline9.Apttus_Config2__LineNumber__c=1;
         ordline9.APTS_Contract_Line_Number__c=1;
         ordline9.Apttus_Config2__NetPrice__c=80.000;
         ordline9.Apttus_Config2__OptionId__c=oProductB.id;
         ordline9.Apttus_Config2__ProductId__c=oProductB.id;
         ordline9.APTS_Group__c='Bundle A';
         ordline9.APTS_Bridge__c='1 Month';
         ordline9.Apttus_Config2__LineType__c = 'Product/Service';
         ordline9.APTS_Program_ID__c = 'FIRMSITE';
         ordline9.Apttus_Config2__AdjustmentType__c ='% Discount';
         ordline9.APTS_Contract_Term__c='10 Years';
         ordline9.APTS_Priced_Number_of_Attorneys__c=10;
         ordline9.Apttus_Config2__BaseExtendedPrice__c=100.0;
         ordline9.Apttus_Config2__AdjustedPrice__c=10.0;
         ordline9.APTS_Term_Type__c = 'Delivery Date';
         ordline9.APTS_Start_Date__c=system.today()+2;
         oliList.add(ordline9);
     
         Apttus_Config2__OrderLineItem__c ordline10 =  APTS_TestDataFactory.orderLineItem(order.id);
         ordline10.Apttus_Config2__LineStatus__c='New';
         ordline10.Apttus_Config2__Quantity__c=1.000;
         ordline10.Apttus_Config2__LineNumber__c=1;
         ordline10.APTS_Contract_Line_Number__c=1;
         ordline10.Apttus_Config2__NetPrice__c=80.000;
         ordline10.Apttus_Config2__OptionId__c=oProductB.id;
         ordline10.Apttus_Config2__ProductId__c=oProductB.id;
         ordline10.APTS_Group__c='Bundle A';
         ordline10.APTS_Bridge__c='1 Month';
         ordline10.Apttus_Config2__LineType__c = 'Product/Service';
         ordline10.APTS_Program_ID__c = 'FIRMSITE';
         ordline10.Apttus_Config2__AdjustmentType__c ='% Markup';
         ordline10.APTS_Contract_Term__c='3 Years';
         ordline10.APTS_Priced_Number_of_Attorneys__c=10;
         ordline10.Apttus_Config2__BaseExtendedPrice__c=10.0;
         ordline10.Apttus_Config2__AdjustedPrice__c=100.0;    
         ordline10.APTS_Term_Type__c='Co-Term and ProRate';
         ordline10.Apttus_Config2__AdjustmentAmount__c=100.01;
         oliList.add(ordline10);
                                                  
        Apttus_Config2__OrderLineItem__c ordline11 = APTS_TestDataFactory.orderLineItem(order.id);
        ordline11.Apttus_Config2__LineStatus__c='Cancelled';
        ordline11.Apttus_Config2__Quantity__c=1.000;
        ordline11.Apttus_Config2__LineNumber__c=1;
        ordline11.APTS_Contract_Line_Number__c=1;
        ordline11.APTS_Deal_Number__c=5;
        ordline11.Apttus_Config2__EndDate__c=System.today();
        ordline11.Apttus_Config2__NetPrice__c=80.000;
        ordline11.Apttus_Config2__ProductId__c=oProductP.id;
        ordline11.APTS_Group__c='Bundle A';
        ordline11.APTS_Bridge__c='1 Month';
        ordline11.Apttus_Config2__LineType__c = 'Product/Service';
        ordline11.APTS_Program_ID__c = 'FIRMSITE';
        ordline11.Apttus_Config2__AdjustmentType__c ='% Discount';
        ordline11.APTS_Contract_Term__c='1 Month';
        ordline11.APTS_Priced_Number_of_Attorneys__c=10;
        ordline11.Apttus_Config2__BaseExtendedPrice__c=100.0;
        ordline11.Apttus_Config2__AdjustedPrice__c=10.0; 
        oliList.add(ordline11);

        Apttus_Config2__OrderLineItem__c ordline12 = APTS_TestDataFactory.orderLineItem(order.id);
        ordline12.Apttus_Config2__LineStatus__c='New';
        ordline12.APTS_Term_Type__c='ProRate';
        ordline12.Apttus_Config2__Quantity__c=1.000;
        ordline12.Apttus_Config2__LineNumber__c=1;
        ordline12.APTS_Contract_Line_Number__c=1;
        ordline12.Apttus_Config2__OptionId__c=oProductA.id;
        ordline12.Apttus_Config2__NetPrice__c=80.000;
        ordline12.Apttus_Config2__ProductId__c=oProductB.id;
        ordline12.APTS_Group__c='Bundle A';
        ordline12.APTS_Bridge__c='1 Month';
        ordline12.Apttus_Config2__LineType__c = 'Product/Service';
        ordline12.APTS_Program_ID__c = 'FIRMSITE';
        ordline12.Apttus_Config2__AdjustmentType__c ='% Discount';
        ordline12.APTS_Contract_Term__c='4 Years';
        ordline12.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
        ordline12.APTS_Priced_Number_of_Attorneys__c=10;
        ordline12.Apttus_Config2__BaseExtendedPrice__c=100.0;
        ordline12.Apttus_Config2__AdjustedPrice__c=10.0;
        oliList.add(ordline12);

        Apttus_Config2__OrderLineItem__c ordline13 =  APTS_TestDataFactory.orderLineItem(order.id); 
        ordline13.Apttus_Config2__LineStatus__c='New';
        ordline13.APTS_Term_Type__c='ProRate';
        ordline13.Apttus_Config2__Quantity__c=1.000;
        ordline13.Apttus_Config2__LineNumber__c=1;
        ordline13.APTS_Contract_Line_Number__c=1;
        ordline13.Apttus_Config2__OptionId__c=oProductB.id;
        ordline13.Apttus_Config2__NetPrice__c=80.000;
        ordline13.Apttus_Config2__ProductId__c=oProductB.id;
        ordline13.APTS_Group__c='Bundle A';
        ordline13.APTS_Bridge__c='1 Month';
        ordline13.Apttus_Config2__LineType__c = 'Product/Service';
        ordline13.APTS_Program_ID__c = 'FIRMSITE';
        ordline13.Apttus_Config2__AdjustmentType__c ='% Discount';
        ordline13.APTS_Contract_Term__c='5 Years';
        ordline13.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
        ordline13.APTS_Priced_Number_of_Attorneys__c=10;
        ordline13.Apttus_Config2__BaseExtendedPrice__c=100.0;
        ordline13.Apttus_Config2__AdjustedPrice__c=10.0;
        ordline13.APTS_End_Date__c=System.Today()+7; 
        oliList.add(ordline13);

   
       Apttus_Config2__OrderLineItem__c ordline14 = APTS_TestDataFactory.orderLineItem(order.id); 
       ordline14.Apttus_Config2__LineStatus__c='New';
       ordline14.Apttus_Config2__Quantity__c=1.000;
       ordline14.Apttus_Config2__LineNumber__c=1;
       ordline14.APTS_Contract_Line_Number__c=1;
       ordline14.Apttus_Config2__OptionId__c=oProductB.id;
       ordline14.Apttus_Config2__NetPrice__c=80.000;
       ordline14.Apttus_Config2__ProductId__c=oProductB.id;
       ordline14.APTS_Group__c='Bundle A';
       ordline14.APTS_Bridge__c='1 Month';
       ordline14.Apttus_Config2__LineType__c = 'Product/Service';
       ordline14.APTS_Program_ID__c = 'FIRMSITE';
       ordline14.APTS_Contract_Term__c='4 Years';
       ordline14.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
       ordline14.APTS_Priced_Number_of_Attorneys__c=10;
       ordline14.Apttus_Config2__BaseExtendedPrice__c=100.0;
       ordline14.Apttus_Config2__AdjustedPrice__c=10.0;
       ordline14.APTS_Term_Type__c = 'Co-Term';
       ordline14.Apttus_Config2__NetPrice__c=100.00;
       ordline14.APTS_End_Date__c=System.Today()+7; 
       oliList.add(ordline14);
    
       Apttus_Config2__OrderLineItem__c ordline15 =  APTS_TestDataFactory.orderLineItem(order.id);
       ordline15.Apttus_Config2__LineStatus__c='New';
       ordline15.Apttus_Config2__Quantity__c=1.000;
       ordline15.Apttus_Config2__LineNumber__c=1;
       ordline15.APTS_Contract_Line_Number__c=1;
       ordline15.Apttus_Config2__OptionId__c=oProductB.id;
       ordline15.Apttus_Config2__NetPrice__c=80.000;
       ordline15.Apttus_Config2__ProductId__c=oProductB.id;
       ordline15.APTS_Group__c='Bundle A';
       ordline15.APTS_Bridge__c='1 Month';
       ordline15.Apttus_Config2__LineType__c = 'Product/Service';
       ordline15.APTS_Program_ID__c = 'FIRMSITE';
       ordline15.APTS_Contract_Term__c='3 Years';
       ordline15.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
       ordline15.APTS_Priced_Number_of_Attorneys__c=10;
       ordline15.Apttus_Config2__BaseExtendedPrice__c=100.0;
       ordline15.Apttus_Config2__AdjustedPrice__c=10.0;
       ordline15.APTS_Term_Type__c = 'ProRate';
       ordline15.APTS_End_Date__c=System.Today()+7;
       oliList.add(ordline15);

       Apttus_Config2__OrderLineItem__c ordline16 =  APTS_TestDataFactory.orderLineItem(order.id);
       ordline16.Apttus_Config2__LineStatus__c='New';
       ordline16.Apttus_Config2__Quantity__c=1.000;
       ordline16.Apttus_Config2__LineNumber__c=1;
       ordline16.APTS_Contract_Line_Number__c=1;
       ordline16.Apttus_Config2__OptionId__c=oProductB.id;
       ordline16.Apttus_Config2__NetPrice__c=80.000;
       ordline16.Apttus_Config2__ProductId__c=oProductB.id;
       ordline16.APTS_Group__c='Bundle A';
       ordline16.APTS_Bridge__c='1 Month';
       ordline16.Apttus_Config2__LineType__c = 'Product/Service';
       ordline16.APTS_Program_ID__c = 'FIRMSITE';
       ordline16.APTS_Contract_Term__c='2 Years';
       ordline16.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
       ordline16.APTS_Priced_Number_of_Attorneys__c=10;
       ordline16.Apttus_Config2__BaseExtendedPrice__c=100.0;
       ordline16.Apttus_Config2__AdjustedPrice__c=10.0;
       ordline16.APTS_Term_Type__c = 'Co-Term and ProRate';
       ordline16.APTS_End_Date__c=System.Today()+7; 
       oliList.add(ordline16);
    
       Apttus_Config2__OrderLineItem__c ordline17 =  APTS_TestDataFactory.orderLineItem(order.id);
       ordline17.Apttus_Config2__LineStatus__c='New';
       ordline17.Apttus_Config2__Quantity__c=1.000;
       ordline17.Apttus_Config2__LineNumber__c=1;
       ordline17.APTS_Contract_Line_Number__c=1;
       ordline17.Apttus_Config2__OptionId__c=oProductB.id;
       ordline17.Apttus_Config2__NetPrice__c=80.000;
       ordline17.Apttus_Config2__ProductId__c=oProductB.id;
       ordline17.APTS_Group__c='Bundle A';
       ordline17.APTS_Bridge__c='1 Month';
       ordline17.Apttus_Config2__LineType__c = 'Product/Service';
       ordline17.APTS_Program_ID__c = 'FIRMSITE';
       ordline17.Apttus_Config2__AdjustedPrice__c=90.00;
       ordline17.Apttus_Config2__AdjustmentType__c='% Markup';
       ordline17.APTS_Contract_Term__c='1 Year';
       ordline17.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
       ordline17.APTS_Priced_Number_of_Attorneys__c=10;
       ordline17.Apttus_Config2__BaseExtendedPrice__c=100.0;
       ordline17.APTS_Term_Type__c = 'Co-Term and ProRate';
       ordline17.APTS_End_Date__c=System.Today()+7;
       oliList.add(ordline17);
       
        Apttus_Config2__OrderLineItem__c ordline18 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline18.Apttus_Config2__LineStatus__c='New';
     ordline18.Apttus_Config2__Quantity__c=1.000;
     ordline18.Apttus_Config2__LineNumber__c=1;
     ordline18.APTS_Contract_Line_Number__c=1;
     ordline18.Apttus_Config2__OptionId__c=oProductB.id;
     ordline18.Apttus_Config2__NetPrice__c=80.000;
     ordline18.Apttus_Config2__ListPrice__c=200.00;
     ordline18.Apttus_Config2__ProductId__c=oProductB.id;
     ordline18.APTS_Group__c='Bundle A';
     ordline18.APTS_Bridge__c='2 Years';
     ordline18.Apttus_Config2__LineType__c = 'Product/Service';
     ordline18.APTS_Program_ID__c = 'FIRMSITE';
     ordline18.Apttus_Config2__AdjustmentType__c ='Discount Amount';
     ordline18.APTS_Contract_Term__c='1 Year';
     ordline18.Apttus_QPConfig__ProposalLineItemId__c=li1.id;
     ordline18.APTS_Priced_Number_of_Attorneys__c=10;
     ordline18.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline18.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline18.APTS_Term_Type__c='Co-Term and ProRate';
     oliList.add(ordline18); 
     
      Apttus_Config2__OrderLineItem__c ordline22 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline22.Apttus_Config2__LineStatus__c='New';
     ordline22.Apttus_Config2__Quantity__c=1.000;
     ordline22.Apttus_Config2__LineNumber__c=1;
     ordline22.APTS_Contract_Line_Number__c=1;
     ordline22.Apttus_Config2__OptionId__c=oProductB.id;
     ordline22.Apttus_Config2__NetPrice__c=80.000;
     ordline22.Apttus_Config2__ListPrice__c=200.00;
    // ordline22.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
     ordline22.Apttus_Config2__ProductId__c=oProductB.id;
     ordline22.APTS_Group__c='Bundle A';
     ordline22.APTS_Bridge__c='N/a';
     ordline22.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline22.Apttus_Config2__PriceType__c='One Time';
     ordline22.Apttus_Config2__LineType__c = 'Product/Service';
     ordline22.APTS_Program_ID__c = 'FIRMSITE';
     ordline22.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline22.APTS_Contract_Term__c='2 Years';
     ordline22.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline22.APTS_Priced_Number_of_Attorneys__c=10;
     ordline22.APTS_Renewal_Type__c='Term Commitment';
     ordline22.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline22.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline22.APTS_WLEC_Product_Category__c='PS';
     ordline22.APTS_Term_Type__c='ProRate';
     ordline22.APTS_Start_Date__c=system.today()+1;
     oliList.add(ordline22);   
    
     Apttus_Config2__OrderLineItem__c ordline23 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline23.Apttus_Config2__LineStatus__c='New';
     ordline23.Apttus_Config2__Quantity__c=1.000;
     ordline23.Apttus_Config2__LineNumber__c=1;
     ordline23.APTS_Contract_Line_Number__c=1;
     ordline23.Apttus_Config2__OptionId__c=oProductB.id;
     ordline23.Apttus_Config2__NetPrice__c=80.000;
     ordline23.Apttus_Config2__ListPrice__c=200.00;
    // ordline23.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
     ordline23.Apttus_Config2__ProductId__c=oProductB.id;
     ordline23.APTS_Group__c='Bundle A';
     ordline23.APTS_Bridge__c='N/a';
     ordline23.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline23.Apttus_Config2__PriceType__c='One Time';
     ordline23.Apttus_Config2__LineType__c = 'Product/Service';
     ordline23.APTS_Program_ID__c = 'FIRMSITE';
     ordline23.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline23.APTS_Contract_Term__c='3 Years';
     ordline23.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline23.APTS_Priced_Number_of_Attorneys__c=10;
     ordline23.APTS_Renewal_Type__c='Term Commitment';
     ordline23.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline23.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline23.APTS_WLEC_Product_Category__c='PS';
     ordline23.APTS_Term_Type__c='ProRate';
     ordline23.APTS_Start_Date__c=system.today()+1;
     oliList.add(ordline23);   
     
      Apttus_Config2__OrderLineItem__c ordline24 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline24.Apttus_Config2__LineStatus__c='New';
     ordline24.Apttus_Config2__Quantity__c=1.000;
     ordline24.Apttus_Config2__LineNumber__c=1;
     ordline24.APTS_Contract_Line_Number__c=1;
     ordline24.Apttus_Config2__OptionId__c=oProductB.id;
     ordline24.Apttus_Config2__NetPrice__c=80.000;
     ordline24.Apttus_Config2__ListPrice__c=200.00;
    // ordline24.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
     ordline24.Apttus_Config2__ProductId__c=oProductB.id;
     ordline24.APTS_Group__c='Bundle A';
     ordline24.APTS_Bridge__c='N/a';
     ordline24.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline24.Apttus_Config2__PriceType__c='One Time';
     ordline24.Apttus_Config2__LineType__c = 'Product/Service';
     ordline24.APTS_Program_ID__c = 'FIRMSITE';
     ordline24.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline24.APTS_Contract_Term__c='4 Years';
     ordline24.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline24.APTS_Priced_Number_of_Attorneys__c=10;
     ordline24.APTS_Renewal_Type__c='Term Commitment';
     ordline24.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline24.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline24.APTS_WLEC_Product_Category__c='PS';
     ordline24.APTS_Term_Type__c='ProRate';
     ordline24.APTS_Start_Date__c=system.today()+1;
     oliList.add(ordline24);   
     
     Apttus_Config2__OrderLineItem__c ordline25 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline25.Apttus_Config2__LineStatus__c='New';
     ordline25.Apttus_Config2__Quantity__c=1.000;
     ordline25.Apttus_Config2__LineNumber__c=1;
     ordline25.APTS_Contract_Line_Number__c=1;
     ordline25.Apttus_Config2__OptionId__c=oProductB.id;
     ordline25.Apttus_Config2__NetPrice__c=80.000;
     ordline25.Apttus_Config2__ListPrice__c=200.00;
    // ordline25.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
     ordline25.Apttus_Config2__ProductId__c=oProductB.id;
     ordline25.APTS_Group__c='Bundle A';
     ordline25.APTS_Bridge__c='N/a';
     ordline25.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline25.Apttus_Config2__PriceType__c='One Time';
     ordline25.Apttus_Config2__LineType__c = 'Product/Service';
     ordline25.APTS_Program_ID__c = 'FIRMSITE';
     ordline25.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline25.APTS_Contract_Term__c='5 Years';
     ordline25.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline25.APTS_Priced_Number_of_Attorneys__c=10;
     ordline25.APTS_Renewal_Type__c='Term Commitment';
     ordline25.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline25.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline25.APTS_WLEC_Product_Category__c='PS';
     ordline25.APTS_Term_Type__c='ProRate';
     ordline25.APTS_Start_Date__c=system.today()+1;
     oliList.add(ordline25);   
     
       Apttus_Config2__OrderLineItem__c ordline26 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline26.Apttus_Config2__LineStatus__c='New';
     ordline26.Apttus_Config2__Quantity__c=1.000;
     ordline26.Apttus_Config2__LineNumber__c=1;
     ordline26.APTS_Contract_Line_Number__c=1;
     ordline26.Apttus_Config2__OptionId__c=oProductB.id;
     ordline26.Apttus_Config2__NetPrice__c=80.000;
     ordline26.Apttus_Config2__ListPrice__c=200.00;
     //ordline26.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
     ordline26.Apttus_Config2__ProductId__c=oProductB.id;
     ordline26.APTS_Group__c='Bundle A';
     ordline26.APTS_Bridge__c='N/a';
     ordline26.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline26.Apttus_Config2__PriceType__c='One Time';
     ordline26.Apttus_Config2__LineType__c = 'Product/Service';
     ordline26.APTS_Program_ID__c = 'FIRMSITE';
     ordline26.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline26.APTS_Contract_Term__c='10 Years';
     ordline26.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline26.APTS_Priced_Number_of_Attorneys__c=10;
     ordline26.APTS_Renewal_Type__c='Term Commitment';
     ordline26.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline26.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline26.APTS_WLEC_Product_Category__c='PS';
     ordline26.APTS_Term_Type__c='ProRate';
     ordline26.APTS_Start_Date__c=system.today()+1;
     oliList.add(ordline26);   

     
     Apttus_Config2__OrderLineItem__c ordline27 =  APTS_TestDataFactory.orderLineItem(order1.id);
     ordline27.Apttus_Config2__LineStatus__c='New';
     ordline27.Apttus_Config2__Quantity__c=1.000;
     ordline27.Apttus_Config2__LineNumber__c=1;
     ordline27.APTS_Contract_Line_Number__c=1;
     ordline27.Apttus_Config2__OptionId__c=oProductB.id;
     ordline27.Apttus_Config2__NetPrice__c=80.000;
     ordline27.Apttus_Config2__ListPrice__c=200.00;
    // ordline27.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
     ordline27.Apttus_Config2__ProductId__c=oProductB.id;
     ordline27.APTS_Group__c='Bundle A';
     ordline27.APTS_Bridge__c='N/a';
     ordline27.Apttus_Config2__ChargeType__c='Subscription Fee';
     ordline27.Apttus_Config2__PriceType__c='One Time';
     ordline27.Apttus_Config2__LineType__c = 'Product/Service';
     ordline27.APTS_Program_ID__c = 'FIRMSITE';
     ordline27.Apttus_Config2__AdjustmentType__c ='% Discount';
     ordline27.APTS_Contract_Term__c='5 Years';
     ordline27.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
     ordline27.APTS_Priced_Number_of_Attorneys__c=10;
     ordline27.APTS_Renewal_Type__c='Term Commitment';
     ordline27.Apttus_Config2__BaseExtendedPrice__c=10.0;
     ordline27.Apttus_Config2__AdjustedPrice__c=100.0;
     ordline27.APTS_WLEC_Product_Category__c='PS';
     ordline27.APTS_Term_Type__c='Co-Term';
     ordline27.APTS_Start_Date__c=system.today()-1;
     oliList.add(ordline27); 
       insert oliList;
                 
                 
                 
      
       Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob1;
       attach1.parentId=oProposal1.id;
       insert attach1;
       System.assertEquals(2,proposalList.size());
       
       /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
       Database.executeBatch(new Aptts_BatchOrderSubmission());
       CorpOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,1);*/
       Map<Id,String> orderrecords = new Map<Id,String>();
       orderrecords.put(order.Id,'Corp OneOTC US');
       orderrecords.put(order1.Id,'Corp OneOTC US');
        
       APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order.Id);
      // APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order1.Id);
       Test.stopTest();
      }catch(Exception ex){
    }
    
    }
     @isTest static void ebillingcontactnull(){      
     try{
       Account acc = [Select id from Account where name='Test'];
       Contact oContact = [select id from Contact limit 1];
       Opportunity o = [select id from Opportunity limit 1];
       Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
       User u = [select id,Username  from user where Email = 'user@mydomain.com'];
       Product2 oProductB=[select id,ProductCode from Product2 where ProductCode = '40475630' ];
       Product2 oProductP=[select id,ProductCode from Product2 where ProductCode = '40588593' ];
       Product2 oProductA=[select id,ProductCode from Product2 where ProductCode = '30010890' ];

             
         oProductB.APTS_FL_Renewal_Only_Clone__c='Yes';
         update oProductB;
        Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get(propRecordTypeName).getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal1 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal1.RecordTypeId=propRecordTypeId;
        oProposal1.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal1.Apttus_Proposal__Account__c = acc.Id;
        oProposal1.APTS_Payment_Option__c ='Credit Card';          
        oProposal1.CurrencyIsoCode = 'USD';
        oProposal1.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal1.APTS_Card_Expiration_Date__c= System.Today();
        oProposal1.APTS_amount__c = 30;
        oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal1.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal1.ownerid=u.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal1.APTS_Ebilling_contact__c=null;
        proposalList.add(oProposal1);

        Apttus_Proposal__Proposal__c oProposal2 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal2.RecordTypeId=propRecordTypeId;
        oProposal2.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal2.Apttus_Proposal__Account__c = acc.Id;
        oProposal2.APTS_Payment_Option__c ='Credit Card';          
        oProposal2.CurrencyIsoCode = 'USD';
        oProposal2.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal2.APTS_Card_Expiration_Date__c= System.Today();
        oProposal2.APTS_amount__c = 30;
        oProposal2.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal2.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal2.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal2.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal2.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal2.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal2.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal2.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal2.ownerid=u.id;
        oProposal2.APTS_Revenue_Channel_Override__c='05';
        oProposal2.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal2.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal2.APTS_Ebilling_contact__c=null;
        proposalList.add(oProposal2);
        insert proposalList;
      
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);

      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = APTS_TestDataFactory.proposallineitem( prodConfig.Id,oProposal1.id);
      li1.Apttus_Proposal__Product__c = oProductB.Id;
      li1.APTS_Number_of_Attorneys__c = 5;
      listLineItems.add(li1);       
       Test.startTest();     
      Apttus_Proposal__Proposal_Line_Item__c li2 =  APTS_TestDataFactory.proposallineitem(prodConfig.Id,oProposal2.id);
      li2.Apttus_Proposal__Product__c = oProductP.Id;
      li2.APTS_Number_of_Attorneys__c = 5;
      li2.APTS_Category_Name__c='FS 1';
      listLineItems.add(li2);
      insert listLineItems;
      
  
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()+1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
      Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()-1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);                                 
      orderList.add(order);
      orderList.add(order1);
      insert orderList;
      
      Apttus_Config2__AssetLineItem__c assetLineItem=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductB.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
      insert assetLineItem;
      
       Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
       insert task;
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
      Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,APTS_Term_Type__c='Delivery Date',Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
     Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,APTS_Term_Type__c='Co-Term',
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Months',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Year',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='11 Months',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);                                                  
     Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);  
     Apttus_Config2__OrderLineItem__c ordline5=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='3 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='4 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='10 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='3 Years',APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0);                                                  
    Apttus_Config2__OrderLineItem__c ordline11 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,APTS_Deal_Number__c=5,Apttus_Config2__EndDate__c=System.today(),Apttus_Config2__NetPrice__c=80.000,
                                                  Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                  APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
    Apttus_Config2__OrderLineItem__c ordline12 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='4 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline14=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Evergreen');
    Apttus_Config2__OrderLineItem__c ordline15=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline16=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline17=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline18=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline19=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    
     Apttus_Config2__OrderLineItem__c ordline20=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline21=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline22=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline23=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline24=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline25=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline26=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline27=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                    Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
 
    Apttus_Config2__OrderLineItem__c ordline28 = new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ListPrice__c=200.00,Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__ChargeType__c='Subscription Fee',Apttus_Config2__PriceType__c='One Time',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,APTS_Renewal_Type__c='ProRate',Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0,
                                                   APTS_WLEC_Product_Category__c='PS',APTS_Term_Type__c='ProRate',APTS_Start_Date__c=system.today()-1);
    Apttus_Config2__OrderLineItem__c ordline29 = new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ListPrice__c=200.00,Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__ChargeType__c='Subscription Fee',Apttus_Config2__PriceType__c='One Time',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='1 Year',APTS_Priced_Number_of_Attorneys__c=10,APTS_Renewal_Type__c='Co-Term and ProRate',Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0,
                                                   APTS_WLEC_Product_Category__c='PS',APTS_Term_Type__c='ProRate',APTS_Start_Date__c=system.today()+2);
         
         
    Apttus_Config2__OrderLineItem__c ordline30=  new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',APTS_Contract_Term__c='2 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Term_Type__c = 'Co-Term and ProRate',APTS_End_Date__c=System.Today()+7); 
       oliList.add(ordline30); 
       oliList.add(ordline29);     
       oliList.add(ordline28);     
       oliList.add(ordline13);
       oliList.add(ordline1);       
       oliList.add(ordline12); 
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
       oliList.add(ordline14);  
       oliList.add(ordline15);
       oliList.add(ordline16);
       oliList.add(ordline17);
       oliList.add(ordline18);
       oliList.add(ordline19);
       oliList.add(ordline20); 
       oliList.add(ordline21);
       oliList.add(ordline22);
       oliList.add(ordline23);
       oliList.add(ordline24);
       oliList.add(ordline25);
       oliList.add(ordline26);     
       oliList.add(ordline27);  
       insert oliList;
       
       
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductA.ProductCode,QuoteId__c = oProposal1.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal1.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
         insert onlineContactList;
       
      Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob1;
       attach1.parentId=oProposal1.id;
       insert attach1;
       Integration_Logger__c loggerRec=new Integration_Logger__c(Object_Name__c='Quote/Proposal',Order__c=order.id,Request_Type__c='Outbound',Service_Name__c='OrderSubmission',Request_Message__c='Unauthorized',Success__c=false);
       insert loggerRec;
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());
            CorpOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,2);*/
            Map<Id,String> orderrecords = new Map<Id,String>();
            orderrecords.put(order.Id,'Corp OneOTC US');
            orderrecords.put(order1.Id,'Corp OneOTC US');
             APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order.Id);
      // APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order1.Id);
            System.assertEquals(2,proposalList.size());
     Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

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
           cDe2.LinkedEntityId = oProposal1.Id; // you can use objectId,GroupId etc
           cDe2.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe2;   
       

        
       
        Test.stopTest();
      }catch(Exception ex){
    }
    
    } 
 @isTest static void newrymethod(){      
     try{
       Account acc = [Select id from Account where name='Test'];
       Contact oContact = [select id from Contact limit 1];
       Opportunity o = [select id from Opportunity limit 1];
       Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
       User u = [select id,Username  from user where Email = 'user@mydomain.com'];
       Product2 oProductB=[select id,ProductCode from Product2 where ProductCode = '40475630' ];
       Product2 oProductP=[select id,ProductCode from Product2 where ProductCode = '40588593' ];
       Product2 oProductA=[select id,ProductCode from Product2 where ProductCode = '30010890' ];

            
         oProductB.APTS_FL_Renewal_Only_Clone__c='Yes';
         update oProductB;
        Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get(propRecordTypeName).getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal1 = APTS_TestDataFactory.createProposal(o.id,accountSSD.id);
        oProposal1.RecordTypeId=propRecordTypeId;
        oProposal1.Apttus_Proposal__Proposal_Name__c =propName;
        oProposal1.Apttus_Proposal__Account__c = acc.Id;
        oProposal1.APTS_Payment_Option__c ='Credit Card';          
        oProposal1.CurrencyIsoCode = 'USD';
        oProposal1.APTS_Assent_DateTime__c=date.ValueOf('2015-03-08');
        oProposal1.APTS_Card_Expiration_Date__c= System.Today();
        oProposal1.APTS_amount__c = 30;
        oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
        oProposal1.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
        oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
        oProposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
        oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
        oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
        oProposal1.ownerid=u.id;
        oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
        oProposal1.APTS_Ebilling_contact__c=oContact.id;
        proposalList.add(oProposal1);
        insert proposalList;
      
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);
          Test.startTest(); 
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = APTS_TestDataFactory.proposallineitem( prodConfig.Id,oProposal1.id);
      li1.Apttus_Proposal__Product__c = oProductB.Id;
      li1.APTS_Number_of_Attorneys__c = 5;
      listLineItems.add(li1);       
           
      Apttus_Proposal__Proposal_Line_Item__c li2 =  APTS_TestDataFactory.proposallineitem(prodConfig.Id,oProposal1.id);
      li2.Apttus_Proposal__Product__c = oProductP.Id;
      li2.APTS_Number_of_Attorneys__c = 5;
      li2.APTS_Category_Name__c='FS 1';
      listLineItems.add(li2);
      insert listLineItems;
      
  
      List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__Status__c='Pending',Apttus_Config2__OrderDate__c=system.today()+1,APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id);
    
      orderList.add(order);
    
      insert orderList;
      
      Apttus_Config2__AssetLineItem__c assetLineItem=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductB.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
      insert assetLineItem;
      
       Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
       insert task;
      List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
     
     Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,APTS_Term_Type__c='Co-Term',
                                                   Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Months',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='2 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
                                              
     Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='2 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);  
     Apttus_Config2__OrderLineItem__c ordline5=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='3 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='4 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='10 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='5 Years',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__AdjustmentAmount__c=100.01,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='3 Years',APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=10.0,Apttus_Config2__AdjustedPrice__c=100.0);                                                  
    Apttus_Config2__OrderLineItem__c ordline11 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,APTS_Deal_Number__c=5,Apttus_Config2__EndDate__c=System.today(),Apttus_Config2__NetPrice__c=80.000,
                                                  Apttus_Config2__ProductId__c=oProductP.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                  APTS_Contract_Term__c='1 Month',APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
    Apttus_Config2__OrderLineItem__c ordline12 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',
                                                   APTS_Contract_Term__c='4 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0);
    Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',
                                                   Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0); 
     Apttus_Config2__OrderLineItem__c ordline14=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Evergreen');
    Apttus_Config2__OrderLineItem__c ordline15=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline16=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline17=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Markup',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline18=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline19=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Renewed',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='N/a',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    
     Apttus_Config2__OrderLineItem__c ordline20=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='Short Term Trial',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline21=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='5 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline22=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='2 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline23=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='3 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline24=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline25=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='1 Year',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline26=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='4 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
    Apttus_Config2__OrderLineItem__c ordline27=  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                    Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='5 Years',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',Apttus_Config2__AdjustmentType__c ='% Discount',APTS_Contract_Term__c='10 Years',
                                                   APTS_Priced_Number_of_Attorneys__c=10,Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Renewal_Type__c='Term Commitment');
 
   
         
    Apttus_Config2__OrderLineItem__c ordline30=  new Apttus_Config2__OrderLineItem__c ( Apttus_Config2__OrderId__c=order.id,Apttus_Config2__LineStatus__c='New',Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__OptionId__c=oProductB.id,Apttus_Config2__NetPrice__c=80.000,
                                                   Apttus_Config2__ProductId__c=oProductB.id,APTS_Group__c='Bundle A',APTS_Bridge__c='1 Month',Apttus_Config2__LineType__c = 'Product/Service',APTS_Program_ID__c = 'FIRMSITE',APTS_Contract_Term__c='2 Years',Apttus_QPConfig__ProposalLineItemId__c=li2.id,APTS_Priced_Number_of_Attorneys__c=10,
                                                   Apttus_Config2__BaseExtendedPrice__c=100.0,Apttus_Config2__AdjustedPrice__c=10.0,APTS_Term_Type__c = 'Co-Term and ProRate',APTS_End_Date__c=System.Today()+7); 
       oliList.add(ordline30); 
       
       oliList.add(ordline13);
       
       oliList.add(ordline12); 
       oliList.add(ordline2);
         
       oliList.add(ordline4);
       oliList.add(ordline5);
       oliList.add(ordline6);
       oliList.add(ordline7);
       oliList.add(ordline8);
       oliList.add(ordline9);
       oliList.add(ordline10);
       oliList.add(ordline11);
       oliList.add(ordline14);  
       oliList.add(ordline15);
       oliList.add(ordline16);
       oliList.add(ordline17);
       oliList.add(ordline18);
       oliList.add(ordline19);
       oliList.add(ordline20); 
       oliList.add(ordline21);
       oliList.add(ordline22);
       oliList.add(ordline23);
       oliList.add(ordline24);
       oliList.add(ordline25);
       oliList.add(ordline26);     
       oliList.add(ordline27);  
       insert oliList;
       
       
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductA.ProductCode,QuoteId__c = oProposal1.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal1.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
         insert onlineContactList;
       
      Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob1;
       attach1.parentId=oProposal1.id;
       insert attach1;
       Integration_Logger__c loggerRec=new Integration_Logger__c(Object_Name__c='Quote/Proposal',Order__c=order.id,Request_Type__c='Outbound',Service_Name__c='OrderSubmission',Request_Message__c='Unauthorized',Success__c=false);
       insert loggerRec;
       //Test.startTest();
            /*Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
            Database.executeBatch(new Aptts_BatchOrderSubmission());
            CorpOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,2);*/
          
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
           cDe.LinkedEntityId = oProposal1.Id; // you can use objectId,GroupId etc
           cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe;
         Map<Id,String> orderrecords = new Map<Id,String>();
            orderrecords.put(order.Id,'Corp OneOTC US');
        
             APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(order.Id);
           
            System.assertEquals(1,proposalList.size());

        
       
        Test.stopTest();
      }catch(Exception ex){
    }
}   
}