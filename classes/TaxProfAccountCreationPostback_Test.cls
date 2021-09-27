@IsTest

public class TaxProfAccountCreationPostback_Test{
     public static testMethod void AccountCreationPostback(){   
         LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;  
       TaxProfAccountCreationPostback.status status1= new TaxProfAccountCreationPostback.status();            
        WebServiceSettings__c webSettings1=new WebServiceSettings__c(Name='PaymentCreditIncrease',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        WebServiceSettings__c webSettings2=new WebServiceSettings__c(Name='CreditCheck',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        WebServiceSettings__c webSettings3=new WebServiceSettings__c(Name='Payment AutoCharge',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        List<WebServiceSettings__c> weblist = new List<WebServiceSettings__c>{webSettings1,webSettings2,webSettings3};
        insert weblist;
        
           
         Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
         Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='S100',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
         insert a;
         List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
         new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')        
         };        
        insert keyValueList;
         List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        
      /*  RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Account LatAm';
        recordtype2.recTypeId__c='01250000001MA4c';
        recordlist.add(recordtype2); */
        insert recordlist;
        
     /*   LatAm_GLI_Settings__c gLISetting = new LatAm_GLI_Settings__c();
        gLISetting.SetupOwnerId=UserInfo.getOrganizationId();
        gLISetting.SubBU__c='LatAm';
        gLISetting.GLI_Partner_Profiles_List__c='Partner Portal User';
        Insert gLISetting;
  */
        
        Account testAcc = APTS_TestDataFactory.createAccount('Testing Account');
        testAcc.Is_GLI__c = true;
        insert testAcc;
        
        Contact cont =new Contact();
        cont.lastname='Kaur';
        cont.accountid=testAcc.id;
        cont.FirstName='Navpreet';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
         insert cont;
        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
       // accountSSD.id='a9d3D000000Ci9B';
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        insert accountSSD;
       
       Date todaysDate = system.today();      
         
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity();
        o.AccountId = testAcc.Id;
        o.Name = 'Unit Test Opportuntiy';
        o.CloseDate = System.Today() + 5;
        o.StageName = 'Prospect';
       // o.LATAM_Business_Unit__c = 'LLEY';
        o.Source_System_Detail__c=accountSSD.id;
        insert o; 
        
        List<Product2> productList = new List<Product2>();
        Product2 objproduct= APTS_TestDataFactory.createProduct('Test Product1', null);
        objproduct.ProductCode= '';
        productList.add(objproduct);
        
        Product2 objproduct1= APTS_TestDataFactory.createProduct('Test Product2', null);
        objproduct1.LCRM_Product_Type__c = 'Services';
        objproduct1.ProductCode= '14456';
        productList.add(objproduct1);
        
        insert productList;
       
       Apttus_Proposal__Proposal__c proposal1 = APTS_TestDataFactory.createProposal(o.id, testAcc.Id);
        proposal1.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal1.APTS_Proposal_Business_Unit__c='Tax Professional';
       // proposal1.Business_Unit_LatAm__c = 'LLEY';
       // proposal1.LATAM_APTS_Payment_Method__c='Bank Transfer';
        proposal1.Apttus_Proposal__Opportunity__c = o.id;
        proposal1.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal1.Apttus_Proposal__Primary__c = true;
      //  proposal1.APTS_Agreement_Language__c = 'English';
        insert proposal1;
        
        List<Integration_Logger__c> LoggerLst =  new List<Integration_Logger__c>();
         Integration_Logger__c Logger1=new Integration_Logger__c();
            Logger1.Exception_Message__c='error';
            Logger1.Object_Id__c = '';
            Logger1.Object_Name__c = 'Quote/Proposal';
            Logger1.Request_Message__c = '';         
            Logger1.Request_Type__c = 'Outbound';
            Logger1.Service_Name__c = 'ZPND Postback';
            Logger1.Source_System_Detail__c= accountSSD.Id;
            Logger1.Success__c = true;
            
             LoggerLst.add(Logger1);
             
             Integration_Logger__c Logger2=new Integration_Logger__c();
            Logger2.Exception_Message__c='';
            Logger2.Object_Id__c = '';
            Logger2.Object_Name__c = 'Quote/Proposal';
            Logger2.Request_Message__c = 'ZPND Handshake';         
            Logger2.Request_Type__c = 'Inbound';
            Logger2.Service_Name__c = 'Create Tax Account SSD';
            Logger2.Source_System_Detail__c= accountSSD.Id;
            Logger2.Success__c = true;
            
             LoggerLst.add(Logger2);
            
            insert LoggerLst;

       test.startTest();
        //Testing for positive case         
        
            TaxProfAccountCreationPostback.DellBoomiResponse orderResponse = new  TaxProfAccountCreationPostback.DellBoomiResponse(); 
                         
            orderResponse.customerNumber = '58652525'; 
            orderResponse.externalAccountId= accountSSD.id;
            orderResponse.prevAcct='4224253';        
                              
            orderResponse.BOOMIHeader= new TaxProfAccountCreationPostback.BOOMIHeader();
               orderResponse.BOOMIHeader.applicationId= 'SF12';
               orderResponse.BOOMIHeader.timeStamp= 'string'; 
                
               orderResponse.confirmations = new List<TaxProfAccountCreationPostback.confirmations>();
               TaxProfAccountCreationPostback.confirmations rc2 = new TaxProfAccountCreationPostback.confirmations(); 
               rc2.serviceNoteNumber='55353';
               rc2.trackingID='242424';
               rc2.serviceNoteMessage='test';
               rc2.messageSeverity='test'; 
               orderResponse.confirmations.add(rc2);
              
            orderResponse.PartnerFunction= new List<TaxProfAccountCreationPostback.PartnerFunction>();
               TaxProfAccountCreationPostback.PartnerFunction rc1 = new TaxProfAccountCreationPostback.PartnerFunction(); 
                rc1.salesOrg= 'S100';  
                rc1.distChannel= '00'; 
                rc1.division= '00';
                rc1.counter='test';
                rc1.businessPartner='test';
                rc1.vendorCreditorNumber='tst';
                rc1.personnalNumber='5353525425';
                rc1.businessPartner='test';                
                rc1.description='test';
                rc1.defaultPartner='test';
                orderResponse.PartnerFunction.add(rc1);
                Business_Partner_Function__c  oBusinessPartnerFunction=new Business_Partner_Function__c ();
                oBusinessPartnerFunction.Related_Account_GLI__c = accountSSD.id;
                oBusinessPartnerFunction.Sold_To_Account_GLI__c = accountSSD.id;
                oBusinessPartnerFunction.CurrencyIsoCode='USD';
                oBusinessPartnerFunction.Related_Account__c=testAcc.id;
                oBusinessPartnerFunction.Relationship_Type__c ='Sold To';
                oBusinessPartnerFunction.Sales_Org__c='S100';    
                
                 List<Business_Partner_Function__c> listBusinessPartnerFunctions = new List<Business_Partner_Function__c>();  
                 listBusinessPartnerFunctions.add(oBusinessPartnerFunction);
                 insert oBusinessPartnerFunction;      
                 
                 
        BigRuleGenericSettings__c bigRule = new BigRuleGenericSettings__c(Name = 'PF:'+rc1.functionId);
        insert bigRule;   
       
      /* orderResponse.partnerFunction = new TaxProfAccountCreationPostback.partnerFunction();
        orderResponse.partnerFunction.salesOrg= 'S100'; 
         orderResponse.partnerFunction.distChannel= '00'; 
          orderResponse.partnerFunction.division= '00';
           orderResponse.partnerFunction.counter='test';
            orderResponse.partnerFunction.businessPartner='test';
             orderResponse.partnerFunction.vendorCreditorNumber='tst';
              orderResponse.partnerFunction.personnalNumber='5353525425';
               orderResponse.partnerFunction.businessPartner='test';
                orderResponse.partnerFunction.description='test';
                 orderResponse.partnerFunction.defaultPartner='test';
       */
       accountSSD.LCRM_External_Trail_Acount_ID__c=orderResponse.prevAcct;               
       update accountSSD;
       
       status1= TaxProfAccountCreationPostback.doPost(orderResponse);
       
     
       //Testing for negative case
       TaxProfAccountCreationPostback.DellBoomiResponse orderResponse2 = new  TaxProfAccountCreationPostback.DellBoomiResponse();
       orderResponse2.BOOMIHeader= new TaxProfAccountCreationPostback.BOOMIHeader();
       orderResponse2.BOOMIHeader.applicationId = null;        
       orderResponse2.customerNumber = null;
       orderResponse2.prevAcct='5453323'; 
       orderResponse2.externalAccountId=accountSSD.id;
          
       status1= TaxProfAccountCreationPostback.doPost(orderResponse2);
       
       //SAP Postback Testing
       /*
       TaxProfAccountCreationPostback.DellBoomiResponse orderResponse3 = new  TaxProfAccountCreationPostback.DellBoomiResponse(); 
             orderResponse3.orderResponseData = new TaxProfAccountCreationPostback.orderResponseData();
                
             orderResponse3.orderResponseData.orderPostBackHeader = new TaxProfAccountCreationPostback.orderPostBackHeader();        
                orderResponse3.orderResponseData.orderPostBackHeader.sourceOrTargetOrderID = order1.Name;
                orderResponse3.orderResponseData.orderPostBackHeader.originatingSystem = 'String';
                orderResponse3.orderResponseData.orderPostBackHeader.externalQuoteId = prop.Name;
                orderResponse3.orderResponseData.orderPostBackHeader.iDocNum = 'D-876';
                orderResponse3.orderResponseData.orderPostBackHeader.statusDetail = new TaxProfAccountCreationPostback.statusDetail();
                orderResponse3.orderResponseData.orderPostBackHeader.statusDetail.statusCode = 'order_completed';                 
                   
         
            orderResponse3.BOOMIHeader= new TaxProfAccountCreationPostback.BOOMIHeader();
                orderResponse3.BOOMIHeader.applicationId = 'SF12';
                orderResponse3.BOOMIHeader.timeStamp = 'string'; 
              
           
       status1= TaxProfAccountCreationPostback.doPost(orderResponse3); */
       
        //Testing for Handshake case
       TaxProfAccountCreationPostback.DellBoomiResponse orderResponse4 = new  TaxProfAccountCreationPostback.DellBoomiResponse();
       orderResponse4.BOOMIHeader= new TaxProfAccountCreationPostback.BOOMIHeader();
       orderResponse4.BOOMIHeader.applicationId = 'SF12-ZPND_Handshake';        
       orderResponse4.customerNumber = '58652525';
       orderResponse4.prevAcct='5453323'; 
       orderResponse4.externalAccountId=accountSSD.id;
      /* orderResponse4.serviceName = 'Create Tax Account SSD';
       orderResponse4.exceptionMsg = 'Handshake Rejected.';
       orderResponse4.requestMsg = 'ZPND Handshake.\n';*/
          
       status1= TaxProfAccountCreationPostback.doPost(orderResponse4);
       
       test.stopTest();
     
   
 }
}