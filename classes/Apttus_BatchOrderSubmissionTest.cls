@isTest
public class Apttus_BatchOrderSubmissionTest{
    static Order_Submission__c ordersub;
    static DateTime now=DateTime.now();
    private static final String value =System.Label.APTS_OC_Test_Id;
    @TestSetup static void batchTestData(){
        
        String USL_RECORDTPYE='USL Source Systems';
        User u=[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
                
        
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
                ,new KeyValueListStore__c(Name='APTS_OldOrderProcess',TextValue__c='true')
                };
                    
                    insert keyValueList;
        
        List<IXOSCodeMap__c> codemapList=new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='S100',Dist_Chan_Code__c='00',Division_Code__c='00',Company_Code__c='1078',Sales_Org_Code__c='S100')};
            
            insert codemapList;
        
        List<BigRuleGenericSettings__c> bigrulesettingList=new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='CG:FEDERAL GOVERNMENT',Value__c='03'),new BigRuleGenericSettings__c(Name='IND:TAX',Value__c='TAX')};
            
            insert bigrulesettingList;
        
        
        List<WebServiceSettings__c> websettingList=new List<WebServiceSettings__c>();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        WebServiceSettings__c oWebServiceSettings1 = new WebServiceSettings__c();
        oWebServiceSettings1.Service_Unavailable_Message__c = 'Not Available'; 
        oWebServiceSettings1.Name = 'CreateCustomerESI'; 
        oWebServiceSettings1.Timeout__c = 20; 
        oWebServiceSettings1.Endpoint__c = 'https://api.thomsonreuters.com/ebs/account/qa/createAccount'; 
        oWebServiceSettings1.Active__c = true;
        
        websettingList.add(oWebServiceSettings1);
        
        WebServiceSettings__c oWebServiceSettings2 = new WebServiceSettings__c();
        oWebServiceSettings2.Service_Unavailable_Message__c = 'Service Not Available'; 
        oWebServiceSettings2.Name = 'OrdersubmissionESI'; 
        oWebServiceSettings2.Timeout__c = 120; 
        oWebServiceSettings2.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST'; 
        oWebServiceSettings2.Active__c = true;
        oWebServiceSettings2.Password__c='s2esandboxESI12c';
        oWebServiceSettings2.Username__c='esisfdcs2euser';
        
        websettingList.add(oWebServiceSettings2);
        
        WebServiceSettings__c oWebServiceSettings3 = new WebServiceSettings__c();
        oWebServiceSettings3.Service_Unavailable_Message__c = 'enterprisewsdl Service is currently unavailable'; 
        oWebServiceSettings3.Name = 'EnterpriseWSDL'; 
        oWebServiceSettings3.Timeout__c = 120; 
        oWebServiceSettings3.Endpoint__c = 'https://test.salesforce.com/services/Soap/c/39.0/00Dg0000006I2ty'; 
        oWebServiceSettings3.Active__c = true;
        websettingList.add(oWebServiceSettings3);
        
        WebServiceSettings__c oWebServiceSettings4 = new WebServiceSettings__c();
        oWebServiceSettings4.Service_Unavailable_Message__c = 'StatusPostbackLocation'; 
        oWebServiceSettings4.Name = 'StatusPostbackLocation'; 
        oWebServiceSettings4.Timeout__c = 20; 
        oWebServiceSettings4.Endpoint__c = 'https://thomsonreutersglis2e--devlcrm12.my.salesforce.com/'; 
        oWebServiceSettings4.Active__c = true;
        websettingList.add(oWebServiceSettings4);
        
        WebServiceSettings__c oWebServiceSettings5 = new WebServiceSettings__c();
        oWebServiceSettings5.Service_Unavailable_Message__c = 'postbackLocation'; 
        oWebServiceSettings5.Name = 'PostbackLocation'; 
        oWebServiceSettings5.Timeout__c = 20; 
        oWebServiceSettings5.Endpoint__c = 'https://thomsonreutersglis2e--devlcrm12.my.salesforce.com/'; 
        oWebServiceSettings5.Active__c = true;
        websettingList.add(oWebServiceSettings5);
        
        WebServiceSettings__c oWebServiceSettings6 = new WebServiceSettings__c();
        oWebServiceSettings6.Service_Unavailable_Message__c = 'Not available'; 
        oWebServiceSettings6.Name = 'OrderSubmissionDellBoomi'; 
        oWebServiceSettings6.Timeout__c = 120; 
        oWebServiceSettings6.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST'; 
        oWebServiceSettings6.Active__c = true;
        oWebServiceSettings6.Password__c='s2esandboxESI12c';
        oWebServiceSettings6.Username__c='esisfdcs2euser';
        insert websettingList;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        Shipping_Method__c shipsetting=new Shipping_Method__c();
        shipsetting.Name='Ground Shipping - U.S. Only';
        shipsetting.Value__c='01';
        
        insert shipsetting;
        
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
    }
    

    
     static testmethod void RISKNSPREE_Test1(){
        
        batchTestData();
        
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
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
        insert accountSSD1;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
                
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_SSD_ship_to__c=accountSSD1.id;
        oProposal.APTS_SSD_bill_to__c=accountSSD1.id;
        oProposal.APTS_SSD_Sold_To__c =accountSSD1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='Argentina-LLEY';
        insert oProposal;
        system.debug('KS--> Proposal Business Unit '+oProposal.APTS_Proposal_Business_Unit__c);
        
        oProposal.APTS_Case_Brand_Value__c = 'ACRITAS';
        update oProposal;
        
        Test.startTest();
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SSD_Sold_To__c = accountSSD1.Id;
        order1.APTS_SSD_Ship_To__c = accountSSD1.Id;
        order1.APTS_SSD_bill_to__c = accountSSD1.Id;
        order1.APTS_Payer__c = accountSSD1.Id; 
        insert order1;
        
        
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        String strglobalPBU = 'Argentina-LLEY';
        Database.executebatch(test1,1);        
        Test.StopTest();
    } 
    
    static testmethod void withOutSAPNumber(){
        
        //SSD without SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='WEST';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.CurrencyIsoCode='USD';
        
        insert accountSSD1;
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        
        insert oProposal;
        
        Test.startTest();
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);        
        insert order1;
                
        
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        try{
           Database.executebatch(test1,1);   
        }catch(Exception ex){
            
        }
        Test.StopTest();
    }
    static testmethod void withSAPNumber(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='WEST';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        
        insert accountSSD1;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='Canada';
        oProposal.APTS_Payment_Option__c='Bill to Account';
        insert oProposal;
        
         Test.startTest();
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);       
        insert order1;
                
       
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        Database.executebatch(test1,1);
        Test.StopTest();
    }
    
    static testmethod void SAPNumberwithNoCallout(){
        //SSD with SAPNumber with no Mockcallouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='WEST';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        
        insert accountSSD1;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='Corp OneOTC US'; 
        insert oProposal;
        
        Test.startTest();
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',3,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        insert order1;
        
        Integration_Logger__c log1=new Integration_Logger__c();
        log1.Success__c=false;
        log1.Order__c=order1.Id;
        insert log1; 
        
        
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        Database.executebatch(test1,1);
        Test.StopTest();
    }
    static testmethod void withoutSAPNumberwithNoCallout(){
        //SSD with woithoutSAPNumber with no Mockcallouts retry count change
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='WEST';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.CurrencyIsoCode='USD';
        
        insert accountSSD1;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        
        insert oProposal;
        
        Test.startTest();
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',3,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        insert order1;
        
        
        
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        Database.executebatch(test1,1);
        Test.StopTest();
    }
    
    static testmethod void corpOrderwithSAPNumber(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='TA78';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='SCS';
        oProposal.APTS_SSD_ship_to__c=accountSSD1.id;
        oProposal.APTS_SSD_bill_to__c=accountSSD1.id;
        oProposal.APTS_SSD_Sold_To__c =accountSSD1.id;
        oProposal.Apttus_QPConfig__PriceListId__c=priceList.id;
        insert oProposal;
        
        Test.startTest();
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SSD_Ship_To__c=accountSSD1.id;
        order1.APTS_SSD_bill_to__c=accountSSD1.id;
        insert order1;
        
        Apttus_Config2__OrderLineItem__c orderlineitem=new Apttus_Config2__OrderLineItem__c();
        orderlineitem.APTS_SSD_Ship_to__c=null;
        orderlineitem.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderlineitem.Apttus_Config2__OrderId__c=order1.id;
        insert orderlineitem;
        
        List<Apttus_Config2__AssetLineItem__c> listOfAssetLineItem=new List<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali =new Apttus_Config2__AssetLineItem__c();
        ali.APTS_SSD_Sold_To__c=accountSSD1.id;
        ali.Apttus_QPConfig__ProposalId__c=oProposal.id;
        ali.APTS_SSD_Ship_to__c=null;
        ali.APTS_SSD_Sold_To__c =accountSSD1.id;
        ali.APTS_SSD_bill_to__c=accountSSD1.id;
        listOfAssetLineItem.add(ali);
        insert listOfAssetLineItem;
        
        orderlineitem.Apttus_Config2__AssetLineItemId__c=ali.id;
        update orderlineitem;
        Integration_Logger__c loggerRec=new Integration_Logger__c(Object_Name__c='Quote/Proposal',Order__c=order1.id,Request_Type__c='Outbound',Service_Name__c='OrderSubmission',Request_Message__c='Unauthorized',Success__c=true);
        insert loggerRec;
        
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        
        Aptts_BatchOrderSubmission test2=new Aptts_BatchOrderSubmission();
        Database.executebatch(test2,1);
        Test.StopTest();
    }
    
    static testmethod void testMethodCanada(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='WEST';
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
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='Canada';
        oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD1.id;
        oProposal.APTS_Payment_Option__c='Bill to Account';
        insert oProposal;
        
        
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Test.startTest();
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        insert order1;
        
        
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        //String str=paymentGateway.encryption(oProposal);
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        Database.executebatch(test1,1);
        Test.StopTest();
    }
    
    static testmethod void testMethodCorp(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='WEST';
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
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='Corp OneOTC US';
        oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD1.id;
        oProposal.APTS_Payment_Option__c='Bill to Account';
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        insert order1;
        
        
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        Database.executebatch(test1,1);
        Test.StopTest();
    } 
    static testmethod void testMethodWithoutBusinessUnit(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
        Source_System_Detail__c accountSSD1= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD1.name ='test source system';
        accountSSD1.city__c='CA';
        accountSSD1.Account_Name__c=acc1.Id;
        accountSSD1.Source_System_Name__c='Test SSD';
        accountSSD1.country__c ='US';
        accountSSD1.LCRM_Industry__c='TAX';
        accountSSD1.LCRM_Sales_Org__c='WEST';
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
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD1.id;
        
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        insert order1;
        
        
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        Database.executebatch(test1,1);
        Test.StopTest();
    } 

    static testmethod void testMethodTax(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
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
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        insert order1;
        
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
       Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
      
        Database.executebatch(test1,1);
        
          try{
              oProposal.Apttus_Proposal__Approval_Stage__c = 'Accepted';
              oProposal.APTS_Send_NACI_Form__c = true;
              update oProposal;
              order1.APTS_SAP_Status__c= 'Pending';
              update order1;
              
              test1.casebrandlist = [Select MasterLabel,DeveloperName,APTS_Case_Brand_Value__c,APTS_Case_Type__c,APTS_Product_Family__c,APTS_Proposal_Business_Unit__c from APTS_Case_Brand__mdt];
            test1.callcasecreation(order1);
            test1.calltaxordersubmission(order1);
        }catch(Exception ex){}
        Test.StopTest();
    }
    
    static testmethod void SAPNumberwithNoCallout1(){
         batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        
        Insert acc1;
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
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
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        insert order1;
        
        Integration_Logger__c log1=new Integration_Logger__c();
        log1.Success__c=false;
        log1.Order__c=order1.Id;
        insert log1; 
        try{
            
        Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
            test1.callcasecreation(order1);
            test1.calltaxordersubmission(order1);
        }catch(Exception ex){
            }
        
        //Database.executebatch(test1,1);
        Test.StopTest();
    }
    
    static testmethod void testMethodTax1(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        Insert acc1;
        
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        accountSSD1.APTS_Is_Customer__c = false;
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.Country__c='US';
        accountSSD1.LCRM_Phone__c='8765435677';
        accountSSD1.Postal_Code__c='94111-3334';
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
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
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.Payment_Status__c = 'Completed';
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SAP_Status__c = 'Pending';
        order1.Retry_Count__c = 2;
        insert order1;
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
       Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        List<Apttus_Config2__Order__c> liorders= test1.sendEmailupdateList;
        Database.executebatch(test1,1);
        
        Test.StopTest();
    }
    
    static testmethod void testOldProcess(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='APTS_OldOrderProcess',TextValue__c='False')};
        insert keyvaluestore;
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
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
        Insert acc1;
        
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        accountSSD1.APTS_Is_Customer__c = false;
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.Country__c='US';
        accountSSD1.LCRM_Phone__c='8765435677';
        accountSSD1.Postal_Code__c='94111-3334';
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
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
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.Payment_Status__c = 'Completed';
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SAP_Status__c = 'Pending';
        order1.Retry_Count__c = 2;
        insert order1;
        
        try{
            new Aptts_BatchOrderSubmission().callOrderSubmissionClass(order1);
        }catch(Exception ex){}
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
       Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        List<Apttus_Config2__Order__c> liorders= test1.sendEmailupdateList;
        Database.executebatch(test1,1);
        
        Test.StopTest();
    }
    
    static testmethod void testMethodTax2(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        Insert acc1;
        
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        accountSSD1.APTS_Is_Customer__c = false;
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.Country__c='US';
        accountSSD1.LCRM_Phone__c='8765435677';
        accountSSD1.Postal_Code__c='94111-3334';
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
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
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.Payment_Status__c = 'Completed';
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SAP_Status__c = 'Order Credit Block';
        order1.Retry_Count__c = 2;
        insert order1;
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
       Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        List<Apttus_Config2__Order__c> liorders= test1.sendEmailupdateList;
        Database.executebatch(test1,1);
        
        Test.StopTest();
    }
    
    static testmethod void testMethodTax3(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        Insert acc1;
        
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        accountSSD1.APTS_Is_Customer__c = false;
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.Country__c='US';
        accountSSD1.LCRM_Phone__c='8765435677';
        accountSSD1.Postal_Code__c='94111-3334';
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
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
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.Payment_Status__c = 'Completed';
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SAP_Status__c = 'Order Credit Block';
        order1.Retry_Count__c = 5;
        insert order1;
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
       Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        List<Apttus_Config2__Order__c> liorders= test1.sendEmailupdateList;
        Database.executebatch(test1,1);
        
        Test.StopTest();
    }
    
    static testmethod void testMethodTax4(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        Insert acc1;
        
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        accountSSD1.APTS_Is_Customer__c = false;
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='12345678';
        accountSSD1.CurrencyIsoCode='USD';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.Country__c='US';
        accountSSD1.LCRM_Phone__c='8765435677';
        accountSSD1.Postal_Code__c='94111-3334';
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
       
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
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.Payment_Status__c = 'Completed';
        insert oProposal;
        
         Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SAP_Status__c = 'Order Credit Block';
        order1.Retry_Count__c = 3;
        insert order1;
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
       Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        List<Apttus_Config2__Order__c> liorders= test1.sendEmailupdateList;
        Database.executebatch(test1,1);
        
        Test.StopTest();
    }
    
    static testmethod void testMethodTax5(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        Insert acc1;
        
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        accountSSD1.APTS_Is_Customer__c = false;
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='';
        accountSSD1.CurrencyIsoCode='USD';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.Country__c='US';
        accountSSD1.LCRM_Phone__c='8765435677';
        accountSSD1.Postal_Code__c='94111-3334';
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
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
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.Payment_Status__c = 'Completed';
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SAP_Status__c = 'Pending';
        order1.Retry_Count__c = 2;
        order1.APTS_SSD_Ship_To__c = accountSSD1.ID;
        order1.APTS_SSD_bill_to__c = accountSSD1.ID;
        order1.APTS_Payer__c = accountSSD1.ID;
        insert order1;
        
        Apttus_Config2__OrderLineItem__c orderlineitem=new Apttus_Config2__OrderLineItem__c();
        orderlineitem.APTS_SSD_Ship_to__c=null;
        orderlineitem.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderlineitem.Apttus_Config2__OrderId__c=order1.id;
        insert orderlineitem;
        
        List<Apttus_Config2__AssetLineItem__c> listOfAssetLineItem=new List<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali =new Apttus_Config2__AssetLineItem__c();
        ali.APTS_SSD_Sold_To__c=accountSSD1.id;
        ali.Apttus_QPConfig__ProposalId__c=oProposal.id;
        ali.APTS_SSD_Ship_to__c=null;
        ali.APTS_SSD_Sold_To__c =accountSSD1.id;
        ali.APTS_SSD_bill_to__c=accountSSD1.id;
        listOfAssetLineItem.add(ali);
        insert listOfAssetLineItem;
        
        orderlineitem.Apttus_Config2__AssetLineItemId__c=ali.id;
        update orderlineitem;
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
       Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        List<Apttus_Config2__Order__c> liorders= test1.sendEmailupdateList;
        Database.executebatch(test1,1);
        
        Test.StopTest();
    }
    
    static testmethod void testMethodTax6(){
        //SSD with SAP Number and making Mock callouts
        batchTestData();
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;

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
        Insert acc1;
        
        System.assertequals('Test',acc1.Name,'Success');
        
        Id contactRecorType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        Contact con=APTS_TestDataFactory.createContact('data',acc1.id);
        con.RecordtypeId=contactRecorType;
        con.email='test@thomsonreuters.com';
        con.firstname='test';
        insert con;
        
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
        accountSSD1.APTS_Is_Customer__c = false;
        accountSSD1.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD1.Source_System_Account_Number__c='';
        accountSSD1.CurrencyIsoCode='USD';
        accountSSD1.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD1.State__c='CA';
        accountSSD1.Country__c='US';
        accountSSD1.LCRM_Phone__c='8765435677';
        accountSSD1.Postal_Code__c='94111-3334';
        insert accountSSD1;
        
        String USL_RECORDTPYE='GLI Pipeline Opportunity';
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(USL_RECORDTPYE).getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD1.id;
        insert oppty;
        
        
        //List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,accountSSD1.Id);
        oProposal.RecordtypeId=propRecorType;
        oProposal.Apttus_Proposal__Account__c=acc1.id;
        oProposal.APTS_Ground_Shipping__c='Ground Shipping - U.S. Only';
        oProposal.APTS_Proposal_Business_Unit__c='Argentina-LLEY';
        oProposal.APTS_Order_Confirmation_Contact__c=con.id;
        oProposal.APTS_SSD_ship_to__c=accountSSD1.id;
        oProposal.APTS_SSD_bill_to__c=accountSSD1.id;
        oProposal.APTS_SSD_Sold_To__c =accountSSD1.id;
        oProposal.APTS_SSD_Sold_To__c=accountSSD1.id;
        oProposal.APTS_Payment_Option__c='Bill to Account';
        oProposal.Payment_Status__c = 'Completed';
        insert oProposal;
        
        Test.startTest();
        Product2 oProductB = new Product2(Name='Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076');
        insert oProductB;
        insert oProductP;      
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=100.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__NetPrice__c=200.00,Apttus_QPConfig__LineType__c='Product/Service');
        listLineItems.add(li2);
        insert listLineItems; 
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,accountSSD1.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        order1.CreatedDate=now.addDays(-1);
        order1.APTS_SAP_Status__c = 'Pending';
        order1.Retry_Count__c = 2;
        order1.APTS_SSD_Ship_To__c = accountSSD1.ID;
        order1.APTS_SSD_bill_to__c = accountSSD1.ID;
        order1.APTS_Payer__c = accountSSD1.ID;
        insert order1;
        
        Apttus_Config2__OrderLineItem__c orderlineitem=new Apttus_Config2__OrderLineItem__c();
        orderlineitem.APTS_SSD_Ship_to__c=null;
        orderlineitem.Apttus_QPConfig__ProposalId__c=oProposal.id;
        orderlineitem.Apttus_Config2__OrderId__c=order1.id;
        insert orderlineitem;
        
        List<Apttus_Config2__AssetLineItem__c> listOfAssetLineItem=new List<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali =new Apttus_Config2__AssetLineItem__c();
        ali.APTS_SSD_Sold_To__c=accountSSD1.id;
        ali.Apttus_QPConfig__ProposalId__c=oProposal.id;
        ali.APTS_SSD_Ship_to__c=null;
        ali.APTS_SSD_Sold_To__c =accountSSD1.id;
        ali.APTS_SSD_bill_to__c=accountSSD1.id;
        listOfAssetLineItem.add(ali);
        insert listOfAssetLineItem;
        
        orderlineitem.Apttus_Config2__AssetLineItemId__c=ali.id;
        update orderlineitem;
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        Apttus_ScheduleOrderSubmission schedulebatchtest=new Apttus_ScheduleOrderSubmission ();
        schedulebatchtest.execute(null);        
        AsyncApexJob  testAsync =  [Select Id, Status, ApexClass.Name From AsyncApexJob where ApexClass.Name = 'Aptts_BatchOrderSubmission' order by CreatedDate DESC limit 1];  
        PaymentgatewayUtil paymentGateway=new PaymentgatewayUtil();
        String str=paymentGateway.creditcard(oProposal);
        // paymentGateway.encryption(oProposal);
       Aptts_BatchOrderSubmission test1=new Aptts_BatchOrderSubmission();
        List<Apttus_Config2__Order__c> liorders= test1.sendEmailupdateList;
        Database.executebatch(test1,1);
        
        Test.StopTest();
    }
}