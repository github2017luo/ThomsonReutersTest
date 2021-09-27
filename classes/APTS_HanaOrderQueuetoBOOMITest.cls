@isTest
public class APTS_HanaOrderQueuetoBOOMITest {
    private static final String USERNAME= System.now().getTime() + 'test2@test.com';
    private static final String LASTNAME ='testcoverage';
    private static final String SHIPPINGNAME= 'Ground Shipping - U.S. Only';
    private static final String SHIPPINGVALUE='01';
    private static final String WEBSERVICE1= 'OrderSubmissionDellBoomi';
    private static final String ACCRECORDTYPENAME='Customer';
    private static final String ACCNAME='Test';
    private static final String CONRECORDTYPENAME='GLI Contact';
    private static final String CONLASTNAME='Test';
    private static final String CONNAME='Test1';
    private static final String PRICELISTNAME='Thomson Reuters Master - US Legal';
    private static final String OPPTYRECORDTYPENAME='Pipeline Opportunity';
    private static final String OPPTYNAME='Test Opportunity';
    private static final String STAGENAME='New';
    private static final String SSDRECORDTYPENAME='LOTUS Source Systems';
    private static final String PROPRECORDTYPENAME='Proposal';
    private static final String STATUS='pending';
    private static final String PROPNAME='Test';
    private static final String VALUE=System.Label.APTS_OC_Test_Id;
    private static final String CUSTOMFIELDNAME='ANZUsersProfileId';
    private static final String VALUE1='True';
    private static final String CUSTOMFIELDNAME1='LCRMDisableStrikeIronServices';
    private static final String JURIS='Indiana';
    private static final String FNAME= 'Test';
    private static final String MNAME= 'Test';
    private static final String LNAME='Test';
    private static final String EADDRESS= 'sreenu.d@tcs.com';
    private static final String POSITION= 'Attorney';
    private static final String PNAME='Test';
    private static final String PFAMILY='Test';
    
    static Order_Submission__c ordersub;
    static DateTime now=DateTime.now();
   
    @testSetup public static void setUp(){

        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        APTS_TestDataFactory.createCustomSetting(customFieldName,value),
        APTS_TestDataFactory.createCustomSetting(customFieldName1,value1)
        };                  
        KeyValueListStore__c keyvaluestoretax =new  KeyValueListStore__c();
        keyvaluestoretax.Name='LCRMOpptyTerritoryStageValues';
        keyvaluestoretax.TextValue__c='Contract Signed,Order Complete,Closed Lost'; 
        keyValueList.add(keyvaluestoretax);    
        insert keyValueList;
        
        KeyValueListStore__c keyvaluestore1 =new  KeyValueListStore__c();
        keyvaluestore1.Name='ReasonWithCompetitor';
        keyvaluestore1.TextValue__c='Price'; 
        insert keyvaluestore1;
    
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
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        List<WebServiceSettings__c> webserv = new List<WebServiceSettings__c>();
          
        WebServiceSettings__c  webSettings = APTS_TestDataFactory.createWebServiceSetting(webservice1);  
        webSettings.Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST';
        webSettings.Password__c='s2esandboxESI12c';
        webSettings.Username__c='esisfdcs2euser';
        webserv.add(webSettings);      
        

        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'CreditCheck',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        webserv.add(o1WebServiceSettings);
        
        WebServiceSettings__c o2WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        webserv.add( o2WebServiceSettings );
        
        WebServiceSettings__c o2Web = new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available');
        webserv.add( o2Web );
        //insert WebserviceList;  
        
        insert webserv ;
           
        User u = APTS_TestDataFactory.createUser(username,lastname);
        u.Email='user@mydomain.com';
        u.Alias = 'User_3';
        u.Firstname='Test';        
        u.TimeZoneSidKey='America/Chicago'; 
        u.Sub_Bu__c='US';
        u.Sales_Force_Description__c='Office';
        u.Rep_Employee_Number__c='X12345678';
        insert u;
        
        Shipping_Method__c shippingMethod = APTS_TestDataFactory.createShippingMethod(shippingName,shippingValue);
        insert shippingMethod;
   
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=1,Period__c=2);
        insert ordersub;
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
           
        Id accRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get(accRecordTypeName).getRecordTypeId();
        Account acc= APTS_TestDataFactory.createAccount(accName);
        acc.RecordTypeId=accRecordTypeId1;
        acc.FrozenMarketSegment__c = valueMarket;
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
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        accountSSD.Source_System_Account_Number__c='123456';
        accountSSD.LCRM_Name_2__c='DEF';
        accountSSD.LCRM_Name_3__c='XYZ';
        accountSSD.CurrencyIsoCode = 'USD';
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
        accountSSD.APTS_Is_Customer__c = false;
        insert accountSSD;     
              
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(conRecordTypeName).getRecordTypeId();
        Contact oContact = APTS_TestDataFactory.createContact(conLastName,acc.id);
        oContact.RecordTypeId=conRecordTypeId;
        oContact.FirstName='Test';
        oContact.Email = 'con@thomsonreuters.com';
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
        oProductB.APTS_Pricing_Qty__c =true;
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
        insert productlist;
       
        PriceBook2 pb = new PriceBook2(name='Standard Price Book', isActive=true);
        insert pb;
    
        /*Id opptyRecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(opptyRecordTypeName).getRecordTypeId();
        Date todaysDate = system.today();    
        Opportunity o = APTS_TestDataFactory.createOpportunity(opptyName,acc.id,stageName,todaysDate);
        o.RecordTypeId=opptyRecordTypeId;
        o.forecastcategoryname='pipeline';
        o.Source_System_Detail__c=accountSSD.id;
        o.pricebook2id=pb.id;
        insert o ;*/
        Id opptyRecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity o=APTS_TestDataFactory.createOpportunity('abc-Ship To',acc.id,'Needs Analysis',Date.Today());
        o.RecordtypeId=opptyRecordTypeId;
        o.pricebook2id=pb.id;
        o.Source_System_Detail__c=accountSSD.id;
        o.Email__c='abc@tcs.com';
        o.Sales_Org__c = 'S100';
        o.Win_Loss__c= 'Won';
        o.Was_There_a_Competitor__c='No';
        o.CurrencyIsoCode = 'USD';
        o.Account=acc;
        o.Competitor_Name__c = 'BloomBerg';
        o.Reason__c = 'Price';
        o.StageName = 'Prospect';
        o.Key_Contact__c = oContact.Id;
        insert o;
    }
 
    @isTest static void taxUSOrderTest(){   
   
        Account acc = [Select id from Account where Name='Test'];
        Contact oContact = [select id from Contact limit 1];
        Opportunity o = [select id from Opportunity limit 1];
        Source_system_detail__c accountSSD=[Select id from Source_system_detail__c where Account_Name__r.Name='Test'];
        User u = [select id,Username  from user where Email = 'user@mydomain.com'];
        u.Sales_Force_Description__c='Home Office';
        update u;
        Product2 oProductB=[select id,ProductCode from Product2 where ProductCode = '40475630' ];
        Product2 oProductP=[select id,ProductCode  from Product2 where ProductCode = '40588593' ];
        Product2 oProductA=[select id,ProductCode  from Product2 where ProductCode = '30010890' ];

        List<Contact> listGLIContacts = new List<Contact>();   
        Contact gliContact1 = new Contact();
        gliContact1.FirstName='Julian';
        gliContact1.LastName='Rogers';
        gliContact1.Accountid= acc.id;
        gliContact1.Person_ID__c = '64828390';
        listGLIContacts.add(gliContact1);

        Contact gliContact2 = new Contact();
        gliContact2.FirstName='Julian';
        gliContact2.LastName='Rogers';
        gliContact2.Accountid= acc.id;
        gliContact2.Person_ID__c = '64828391';
        listGLIContacts.add(gliContact2);

        Contact gliContact3 = new Contact();
        gliContact3.FirstName='Julian';
        gliContact3.LastName='Rogers';
        gliContact3.Accountid= acc.id;
        gliContact3.Person_ID__c = '64828392';
        listGLIContacts.add(gliContact3);
        insert listGLIContacts;

        oProductB.APTS_FL_Renewal_Only_Clone__c='Yes';
        update oProductB;

        Test.startTest();
           
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
            oProposal1.APTS_GLI_Bill_To_Contact__c = gliContact1.id;
            oProposal1.APTS_GLI_Sold_To_Contact__c = gliContact2.id;
            oProposal1.APTS_GLI_Ship_To_Contact__c = gliContact3.id;
            oProposal1.APTS_Order_Confirmation_Contact__c = oContact.Id;
            oProposal1.APTS_Proposal_Business_Unit__c = 'Tax Professional';
            oProposal1.APTS_SSD_ship_to__c=accountSSD.Id;
            oProposal1.APTS_SSD_bill_to__c=accountSSD.Id;
            oProposal1.APTS_SSD_Sold_To__c =accountSSD.Id;
            oProposal1.APTS_Payer__c = accountSSD.Id;
            oProposal1.Apttus_Proposal__Approval_Stage__c='Accepted';
            oProposal1.Apttus_Proposal__Proposal_Category__c='Quote';
            oProposal1.Apttus_Proposal__ReadyToGenerate__c = true;
            oProposal1.Apttus_Proposal__ReadyToPresent__c= true;
            oProposal1.ownerid=u.id;
            oProposal1.APTS_Send_NACI_Form__c = false;
            oProposal1.Credit_Check_Flag__c = false;
            oProposal1.Payment_Status__c  = 'Completed';
            oProposal1.APTS_Ebilling_exempt__c= true;
            oProposal1.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
            oProposal1.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
            oProposal1.APTS_Ebilling_contact__c=oContact.id;
            //Commented by Kruti Shah
            //oProposal1.APTS_ZPEND_Check__c = false;
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
            oProposal2.APTS_Proposal_Business_Unit__c = 'Tax Professional';
            oProposal2.APTS_SSD_ship_to__c=accountSSD.Id;
            oProposal2.APTS_SSD_bill_to__c=accountSSD.Id;
            oProposal2.APTS_SSD_Sold_To__c =accountSSD.Id;
            oProposal2.APTS_Payer__c = accountSSD.Id;
            oProposal2.APTS_Ebilling_exempt__c=False;
            oProposal2.APTS_Send_NACI_Form__c =false;
            oProposal2.Credit_Check_Flag__c = false;
            oProposal2.APTS_GLI_Bill_To_Contact__c = gliContact1.id;
            oProposal2.APTS_GLI_Sold_To_Contact__c = gliContact2.id;
            oProposal2.APTS_GLI_Ship_To_Contact__c = gliContact3.id;
            oProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
            oProposal2.Apttus_Proposal__Proposal_Category__c='Quote';
            oProposal2.Apttus_Proposal__ReadyToGenerate__c = true;
            oProposal2.Apttus_Proposal__ReadyToPresent__c= true;
            oProposal2.ownerid=u.id;
            oProposal2.APTS_Revenue_Channel_Override__c='05';
            oProposal2.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
            oProposal2.APTS_SA_ID__c='FEDERAL NO FEE(FEEO)';
            oProposal2.APTS_Ebilling_contact__c=oContact.id;
            oProposal2.Payment_Status__c  = 'Completed';
            //Commented by Kruti Shah
            //oProposal2.APTS_ZPEND_Check__c = false;
            proposalList.add(oProposal2);

            insert proposalList;
            system.assert(proposalList!=null);
            Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(oProposal1.Id);
            CreateS4HANAOrderRequest.Address test1 = new CreateS4HANAOrderRequest.Address();
            test1.firstName ='test';
            test1.lastName = 'test';
            test1.middleName = 'test';
            test1.title= 'test';
            test1.floor= 'test';
            test1.room= 'test';
            test1.building= 'test';
            test1.alternateEmailAddress= 'test';
            test1.poBox= 'test';
            test1.phone = 'test';
            test1.emailAddress = 'test';
            test1.extension= 'test';
            test1.fax= 'test';
            test1.street1 = 'test';
            test1.street2 = 'test';
            test1.street3= 'test';
            test1.street4 = 'test';
            test1.city = 'test';
            test1.district= 'test';
            test1.region = 'test';
            test1.county = 'test';
            test1.postalcode = 'test';
            test1.country = 'test';
            test1.poBox='test'; 
            test1.alternateEmailAddress='test';
            test1.building='test';
            test1.floor='test'; 
            test1.room='test'; 
            test1.externalContactId='test';

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

            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
            Online_Contacts__c oc1 = APTS_TestDataFactory.createOnlineContact(oProductP.ProductCode, oProposal1.Id,False,acc.Id,fName, mName,lName,eAddress,position,True,juris);
            oc1.ContactID__c = '0012409071'; 
            oc1.Latam_Action__c = 'Add';
            oc1.Email__c='xyz@tcs.com';
            oc1.QuoteLineItem__c=li2.id;
            oc1.Tax_Type__c = 'Admin;User';
            onlineContactList.add(oc1);

            Online_Contacts__c oc2 =  APTS_TestDataFactory.createOnlineContact(oProductB.ProductCode, oProposal1.Id,True,acc.Id,fName, mName,lName,eAddress,position,True,juris);
            oc2.ContactID__c = '0012409071'; 
            oc2.Position__c = 'Clerk';
            oc2.Latam_Action__c = 'Add';
            oc2.Email__c='xyz@tcs.com';
            oc2.QuoteLineItem__c=li2.id;
            oc2.Tax_Type__c = 'Admin;User';
            onlineContactList.add(oc2);

            insert onlineContactList;
            
            List<Apttus_Config2__AssetLineItem__c> aslList = new List<Apttus_Config2__AssetLineItem__c>();
            Apttus_Config2__AssetLineItem__c assetline =  new Apttus_Config2__AssetLineItem__c(Apttus_QPConfig__ProposalId__c=oProposal1 .id);
            assetline.Apttus_QPConfig__ProposalLineItemId__c = li2.id;
            aslList.add(Assetline);
            insert aslList;
            Set<Id> aliSet = new Set<Id>{Assetline.Id};
            List<Apttus_Config2__AssetLineItem__c> aliListUpdt = [select id, Asset_Auto_Number__c, Tax_Asset_Auto_Number__c from Apttus_Config2__AssetLineItem__c where id in :aliSet];
            for(Apttus_Config2__AssetLineItem__c ali : aliListUpdt){
                ali.Asset_Auto_Number__c = ali.Tax_Asset_Auto_Number__c; 
            }
            update aliListUpdt;
            
            //Test.startTest();
            List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();

            Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal1.id,Apttus_Config2__OrderDate__c=system.today()+1,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id,APTS_SAP_Status__c = 'Pending');
            Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__Type__c='New',APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_SSD_Ship_To__c=accountSSD.id,
                                       Apttus_QPConfig__ProposalId__c=oProposal2.id,Apttus_Config2__OrderDate__c=system.today()-2,Apttus_Config2__Status__c='Pending',APTS_Payer__c=accountSSD.id,CreatedDate=now.addDays(-1),ownerid=u.id,APTS_SAP_Status__c = 'Pending');                                 
            orderList.add(order);
            orderList.add(order1);
            insert orderList;
            Task task=new Task(Subject = 'Quote/Proposal eSigned by  Test User @2018-09-12T11:04:59 GMT',whatid = order.Apttus_QPConfig__ProposalId__c);
            insert task;

            //oProposal1.APTS_Wet_Signature__c=true;
            //update oProposal1;

            List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();    
            Apttus_Config2__OrderLineItem__c ordline1 =  APTS_TestDataFactory.orderLineItem(order.id);
            ordline1.Apttus_Config2__LineStatus__c='New';
            ordline1.Apttus_Config2__Quantity__c=1.000;
            ordline1.Apttus_Config2__LineNumber__c=1;
            ordline1.APTS_Contract_Line_Number__c=1;
            ordline1.Apttus_Config2__Description__c='test';
            ordline1.Apttus_Config2__Status__c='Pending';
            ordline1.Apttus_Config2__OptionId__c=oProductB.id;
            ordline1.Apttus_Config2__NetPrice__c=80.000;
            ordline1.Apttus_Config2__ListPrice__c=200.00;
            ordline1.Apttus_Config2__NetUnitPrice__c=200.00;
            //ordline1.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
            ordline1.Apttus_Config2__ProductId__c=oProductB.id;
            ordline1.APTS_Group__c='Bundle A';
            ordline1.Apttus_Config2__ChargeType__c='Subscription Fee';
            ordline1.Apttus_Config2__PriceType__c='One Time';
            ordline1.Apttus_Config2__LineType__c = 'Product/Service';
            ordline1.APTS_Program_ID__c = 'FIRMSITE';
            ordline1.Apttus_Config2__AdjustmentType__c ='% Discount';
            ordline1.Apttus_Config2__AdjustmentAmount__c = 10;
            ordline1.APTS_Contract_Term__c = '1 Year';
            ordline1.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
            ordline1.APTS_Priced_Number_of_Attorneys__c=10;
            ordline1.APTS_Renewal_Type__c='Evergreen';
            ordline1.Apttus_Config2__BaseExtendedPrice__c=10.0;
            ordline1.Apttus_Config2__AdjustedPrice__c=100.0;
            ordline1.APTS_WLEC_Product_Category__c='PS';
            ordline1.APTS_Start_Date__c=system.today()+1;
            ordline1.APTS_Term_Type__c = 'Co-Term';
            ordline1.APTS_Calculated_Year_1__c=100.0;
            ordline1.APTS_Bridge__c = '';
            ordline1.Apttus_Config2__StartDate__c= System.Today();
            ordline1.Apttus_Config2__EndDate__c= System.Today();
            ordline1.Apttus_Config2__SellingFrequency__c = 'Yearly';
            ordline1.Apttus_Config2__AssetLineItemId__c = Assetline.Id;
            oliList.add(ordline1); 

            Apttus_Config2__OrderLineItem__c ordline2 =  APTS_TestDataFactory.orderLineItem(order.id);
            ordline2.Apttus_Config2__LineStatus__c='New';
            ordline2.Apttus_Config2__Quantity__c=1.000;   
            ordline2.Apttus_Config2__LineNumber__c=2;
            ordline2.APTS_Contract_Line_Number__c=2;
            ordline2.Apttus_Config2__Description__c='12345678901234567890123456789012345678901234567890';
            ordline2.Apttus_Config2__Status__c='Pending';
            ordline2.Apttus_Config2__OptionId__c=oProductB.id;
            ordline2.Apttus_Config2__NetPrice__c=80.000;
            ordline2.Apttus_Config2__ListPrice__c=200.00;
            ordline2.Apttus_Config2__NetUnitPrice__c=200.00;
            //ordline2.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
            ordline2.Apttus_Config2__ProductId__c=oProductB.id;
            ordline2.APTS_Group__c='Bundle A';
            ordline2.Apttus_Config2__ChargeType__c='Subscription Fee';
            ordline2.Apttus_Config2__PriceType__c='One Time';
            ordline2.Apttus_Config2__LineType__c = 'Product/Service';
            ordline2.APTS_Program_ID__c = 'FIRMSITE';
            ordline2.Apttus_Config2__AdjustmentType__c ='% Markup';
            ordline2.Apttus_Config2__AdjustmentAmount__c = 10;
            ordline2.APTS_Contract_Term__c='5 Years';
            ordline2.APTS_Calculated_Year_1__c=100.0;
            ordline2.APTS_Calculated_Year_2__c=100.0;
            ordline2.APTS_Calculated_Year_3__c=100.0;
            ordline2.APTS_Calculated_Year_4__c=100.0;
            ordline2.APTS_Calculated_Year_5__c=100.0;
            ordline2.APTS_Years_2_Plus_Adjustment__c = '1';
            ordline2.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
            ordline2.APTS_Priced_Number_of_Attorneys__c=10;
            ordline2.APTS_Renewal_Type__c = 'Term Commitment';
            ordline2.Apttus_Config2__BaseExtendedPrice__c=10.0;
            ordline2.Apttus_Config2__AdjustedPrice__c=100.0;
            ordline2.APTS_WLEC_Product_Category__c='PS';
            ordline2.APTS_Start_Date__c=system.today()+1;
            ordline2.APTS_Bridge__c = '1 Month';
            ordline2.APTS_New_Bridge_Discount__c = 1;
            ordline2.APTS_Term_Type__c = 'Future Start Date';
            ordline2.Apttus_Config2__StartDate__c= System.Today();
            ordline2.Apttus_Config2__EndDate__c= System.Today();
            ordline2.Apttus_Config2__SellingFrequency__c = 'Monthly';
            ordline2.Apttus_Config2__PriceUom__c = 'Concurrent';
            ordline2.APTS_Product_Delivery__c = 'Online/Web';
            ordline2.APTS_Product_Variant_ID__c = 'test';
            ordline2.Apttus_Config2__HasOptions__c = true;
            oliList.add(ordline2); 
            
            Apttus_Config2__OrderLineItem__c ordline3 =  APTS_TestDataFactory.orderLineItem(order.id);
            ordline3.Apttus_Config2__LineStatus__c='Renewed';
            ordline3.Apttus_Config2__Quantity__c=1.000;   
            ordline3.Apttus_Config2__LineNumber__c=1;
            ordline3.APTS_Contract_Line_Number__c=1;
            ordline3.Apttus_Config2__Description__c='test';
            ordline3.Apttus_Config2__Status__c='Pending';
            ordline3.Apttus_Config2__OptionId__c=oProductB.id;
            ordline3.Apttus_Config2__NetPrice__c=80.000;
            ordline3.Apttus_Config2__ListPrice__c=200.00;
            //ordline3.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
            ordline3.Apttus_Config2__ProductId__c=oProductB.id;
            ordline3.APTS_Group__c='Bundle A';
            ordline3.Apttus_Config2__ChargeType__c='Subscription Fee';
            ordline3.Apttus_Config2__PriceType__c='One Time';
            ordline3.Apttus_Config2__LineType__c = 'Product/Service';
            ordline3.APTS_Program_ID__c = 'FIRMSITE';
            ordline3.Apttus_Config2__AdjustmentType__c ='% Discount';
            ordline3.APTS_Contract_Term__c='3 Years';
            ordline3.APTS_Calculated_Year_1__c=100.0;
            ordline3.APTS_Calculated_Year_2__c=100.0;
            ordline3.APTS_Calculated_Year_3__c=100.0;
            ordline3.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
            ordline3.APTS_Priced_Number_of_Attorneys__c=10;
            ordline3.APTS_Renewal_Type__c='Auto Renew';
            ordline3.Apttus_Config2__BaseExtendedPrice__c=10.0;
            ordline3.Apttus_Config2__AdjustedPrice__c=100.0;
            ordline3.APTS_WLEC_Product_Category__c='PS';
            ordline3.APTS_Start_Date__c=system.today()+1;
            ordline3.APTS_Bridge__c = '10 Months';
            ordline3.APTS_Term_Type__c='Future Start Date and Co-term';
            ordline3.Apttus_Config2__StartDate__c =  System.Date.today();
            ordline3.Apttus_Config2__EndDate__c= System.Today();
            oliList.add(ordline3);
            
            Apttus_Config2__OrderLineItem__c ordline4 =  APTS_TestDataFactory.orderLineItem(order.id);
            ordline4.Apttus_Config2__LineStatus__c='Renewed';
            ordline4.Apttus_Config2__Quantity__c=1.000;   
            ordline4.Apttus_Config2__LineNumber__c=1;
            ordline4.APTS_Contract_Line_Number__c=1;
            ordline4.Apttus_Config2__Description__c='test';
            ordline4.Apttus_Config2__Status__c='Pending';
            ordline4.Apttus_Config2__OptionId__c=oProductB.id;
            ordline4.Apttus_Config2__NetPrice__c=80.000;
            ordline4.Apttus_Config2__ListPrice__c=200.00;
            //ordline4.Apttus_Config2__AttributeValueId__c='a6P1B0000004NvNUAU';
            ordline4.Apttus_Config2__ProductId__c=oProductB.id;
            ordline4.APTS_Group__c='Bundle A';
            ordline4.Apttus_Config2__ChargeType__c='Subscription Fee';
            ordline4.Apttus_Config2__PriceType__c='One Time';
            ordline4.Apttus_Config2__LineType__c = 'Option';
            ordline4.APTS_Program_ID__c = 'FIRMSITE';
            ordline4.Apttus_Config2__AdjustmentType__c ='% Discount';
            ordline4.APTS_Contract_Term__c='2 Years';
            ordline4.APTS_Calculated_Year_1__c=100.0;
            ordline4.APTS_Calculated_Year_2__c=100.0;
            ordline4.Apttus_QPConfig__ProposalLineItemId__c=li2.id;
            ordline4.APTS_Priced_Number_of_Attorneys__c=10;
            ordline4.APTS_Renewal_Type__c='Auto Renew';
            ordline4.Apttus_Config2__BaseExtendedPrice__c=10.0;
            ordline4.Apttus_Config2__AdjustedPrice__c=100.0;
            ordline4.APTS_WLEC_Product_Category__c='PS';
            ordline4.APTS_Start_Date__c=system.today()+1;
            ordline4.APTS_Bridge__c = '10 Months';
            ordline4.APTS_Term_Type__c='Future Start Date and Co-term';
            ordline4.Apttus_Config2__StartDate__c =  System.Date.today();
            ordline4.Apttus_Config2__EndDate__c= System.Today();
            oliList.add(ordline4);

            insert oliList;
            //order.APTS_SSD_Sold_To__c=accountSSD.Id;
            //update order;
            List<Apttus_Config2__OrderLineItem__c> olirecord = [Select Id,Apttus_Config2__OrderId__r.id from Apttus_Config2__OrderLineItem__c 
                  where Apttus_Config2__OrderId__r.id=: order.id];

            CreateS4HANAOrderRequest oReq = new CreateS4HANAOrderRequest();        

            CreateS4HANAOrderRequest.onlineContacts onlineContact = new CreateS4HANAOrderRequest.onlineContacts();
            Attachment attach1=new Attachment();     
            attach1.Name='Contract_Signed.txt';
            Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
            attach1.body=bodyBlob1;
            attach1.parentId=oProposal1.id;
            insert attach1;

            Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout()); 
            Database.executeBatch(new Aptts_BatchOrderSubmission());
            HTTPResponse response = new HTTPResponse();
            DellBoomiOrderSubmissionCalloutUtil.sendS4Request(oReq,'Quote/Proposal BOOMI call SFDC Error', 'Quote/Proposal','OrderSubmissionDellBoomi','application/json', 'POST',order.id,1);
            DellBoomiOrderSubmissionCalloutUtil.sendEmailtoQuoteOwner('test',response,oProposal1.id,'xyz@tcs.com','Order Not got processed Sucessfully for the order:', 'Order Failed', 'Quote/Proposal BOOMI Call Failed', 'Quote/Proposal', order.id,1);
            DellBoomiOrderSubmissionCalloutUtil.logException('request', 'callOut Exception', 'Quote/Proposal', false, order.id,1);
        Test.stopTest();
    }
}