@IsTest

public class TaxProfOrderStatusPostback_Test{
     public static testMethod void handleTaxPostbackTestmethod(){     
         LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
       TaxProfOrderStatusPostback.status status1= new TaxProfOrderStatusPostback.status();            
         
        WebServiceSettings__c webSettings1=new WebServiceSettings__c(Name='CreditCheck',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        insert webSettings1;
           
         Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
         Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
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
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Account';
        recordtype2.recTypeId__c='01250000001MA4c';
        recordlist.add(recordtype2);
        insert recordlist;
        
       /* LatAm_GLI_Settings__c gLISetting = new LatAm_GLI_Settings__c();
        gLISetting.SetupOwnerId=UserInfo.getOrganizationId();
        gLISetting.SubBU__c='LatAm';
        gLISetting.GLI_Partner_Profiles_List__c='Partner Portal User';
        Insert gLISetting;*/
        
        Tax_Proff_GLI_Setting__c gLISetting_tax = new Tax_Proff_GLI_Setting__c();         
        gLISetting_tax.SetupOwnerId=UserInfo.getOrganizationId();
        gLISetting_tax.SubBU__c='US';
        Insert gLISetting_tax;

        
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
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c ='S100';
        accountSSD.recordtypeid =Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        insert accountSSD;
       
       Date todaysDate = system.today();      
         
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity();
        o.AccountId = testAcc.Id;
        o.recordTypeid = oppRecordTypeId;
        o.Name = 'Unit Test Opportuntiy';
        o.CloseDate = System.Today() + 5;
        o.StageName = 'Qualifying';
        //o.LATAM_Business_Unit__c = 'LLEY';
        o.Source_System_Detail__c=accountSSD.id;
        o.Is_GLI__c=true;
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
        proposal1.Apttus_Proposal__Opportunity__c = o.id;
        proposal1.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal1.Apttus_Proposal__Primary__c = true;
        insert proposal1;

       test.startTest();
       Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=o.id);
       order.Apttus_QPConfig__ProposalId__c=proposal1.id; 
         order.Apttus_Config2__Status__c ='Activated';
        insert order;
       
        system.debug('yes it reached line no : 69');
        Apttus_Config2__Order__c order1 = [Select Name, Apttus_Config2__Status__c,APTS_SAP_Status__c,Apttus_QPConfig__ProposalId__r.Name,Apttus_Config2__OrderReferenceNumber__c,Apttus_Config2__OrderDate__c from Apttus_Config2__Order__c where Id = :order.Id];         //Test Data for BoomiResponse
        system.debug('Order number ' + order1.Name);
        
        List<Apttus_Config2__AssetLineItem__c> aslList = new List<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c assetline =  new Apttus_Config2__AssetLineItem__c(Apttus_QPConfig__ProposalId__c=proposal1.id);
        aslList.add(Assetline);
        Apttus_Config2__AssetLineItem__c assetline2 =  new Apttus_Config2__AssetLineItem__c(Apttus_QPConfig__ProposalId__c=proposal1.id);
        aslList.add(Assetline2);
         Apttus_Config2__AssetLineItem__c assetline3 =  new Apttus_Config2__AssetLineItem__c(Apttus_QPConfig__ProposalId__c=proposal1.id);
        aslList.add(Assetline3);
        Apttus_Config2__AssetLineItem__c assetline4 =  new Apttus_Config2__AssetLineItem__c(Apttus_QPConfig__ProposalId__c=proposal1.id);
        aslList.add(Assetline4);
        
        insert aslList;
        Set<Id> aliSet = new Set<Id>{Assetline.Id, Assetline2.Id, Assetline3.Id, Assetline4.Id};
        List<Apttus_Config2__AssetLineItem__c> aliListUpdt = [select id, Asset_Auto_Number__c, Tax_Asset_Auto_Number__c from Apttus_Config2__AssetLineItem__c where id in :aliSet];
        for(Apttus_Config2__AssetLineItem__c ali : aliListUpdt){
            ali.Asset_Auto_Number__c = ali.Tax_Asset_Auto_Number__c;
            ali.APTS_Platform_Name__c = 'CUAS';
            ali.APTS_Platform_Account_ID__c = '453gts';            
        }
        update aliListUpdt;
        
        List<Apttus_Config2__OrderLineItem__c> oliList = new List<Apttus_Config2__OrderLineItem__c>();
        Apttus_Config2__OrderLineItem__c Orderline =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__Status__c='Activated');
        Orderline.Apttus_Config2__AssetLineItemId__c = Assetline.Id;
        oliList.add(Orderline);
        Apttus_Config2__OrderLineItem__c Orderline2 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='Cancelled',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__Status__c='Activated');
        Orderline2.Apttus_Config2__AssetLineItemId__c = Assetline2.Id;
        oliList.add(Orderline2);
        Apttus_Config2__OrderLineItem__c Orderline3 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__Status__c='Activated');
        Orderline3.Apttus_Config2__ProductId__c = objproduct.id;
        Orderline3.Apttus_Config2__OptionId__c = objproduct1.id;
        Orderline3.Apttus_Config2__AssetLineItemId__c  = Assetline3.Id;
        oliList.add(Orderline3); 
        Apttus_Config2__OrderLineItem__c Orderline4 =  new Apttus_Config2__OrderLineItem__c(Apttus_Config2__LineStatus__c='New',Apttus_Config2__OrderId__c=order1.id,Apttus_Config2__Quantity__c=1.000,Apttus_Config2__LineNumber__c=1,APTS_Contract_Line_Number__c=1,Apttus_Config2__NetPrice__c=80.000,Apttus_Config2__Status__c='Activated');
        Orderline4.Apttus_Config2__ProductId__c = objproduct.id;
        Orderline4.Apttus_Config2__OptionId__c = objproduct1.id;
        Orderline4.Apttus_Config2__AssetLineItemId__c  = Assetline4.Id;
        oliList.add(Orderline4);        
        insert oliList ;
        
        
        List<Apttus_Config2__OrderLineItem__c> Ordline1 = [Select id, Name,Tax_Asset_Auto_Number__c  from Apttus_Config2__OrderLineItem__c where Id in :oliList];   
        system.debug('Ordline1 : '+Ordline1);
        Map<Id, Apttus_Config2__OrderLineItem__c> oliMap = new Map<Id, Apttus_Config2__OrderLineItem__c>([Select id, Name,Tax_Asset_Auto_Number__c  from Apttus_Config2__OrderLineItem__c where Id in :oliList]);
        
        
        
        
        /*oliList[0].Apttus_Config2__AssetLineItemId__c = Assetline.Id;
        oliList[1].Apttus_Config2__AssetLineItemId__c = Assetline2.Id;
        oliList[2].Apttus_Config2__AssetLineItemId__c  = Assetline3.Id;*/
        update oliList;
        
        Apttus_Proposal__Proposal__c  prop = [select Name from Apttus_Proposal__Proposal__c  where id = :proposal1.id];    
        
        Order_Status__c oc1 = new Order_Status__c();
        oc1.Name = 'ORDER_COMPLETED';
        oc1.SFDC_Order_Status__c = 'Order Completed';
        insert oc1;    
        
        //Testing for positive case  
        
        //Entitlement Testing 
         TaxProfOrderStatusPostback.DellBoomiResponse orderResponse = new  TaxProfOrderStatusPostback.DellBoomiResponse(); 
             orderResponse.orderResponseData = new TaxProfOrderStatusPostback.orderResponseData();
                
             orderResponse.orderResponseData.orderPostBackHeader = new TaxProfOrderStatusPostback.orderPostBackHeader();        
                orderResponse.orderResponseData.orderPostBackHeader.sourceOrTargetOrderID = order1.Name;
                orderResponse.orderResponseData.orderPostBackHeader.originatingSystem = 'String';
                orderResponse.orderResponseData.orderPostBackHeader.externalQuoteId = prop.Name;
                orderResponse.orderResponseData.orderPostBackHeader.statusDetail = new TaxProfOrderStatusPostback.statusDetail();
                orderResponse.orderResponseData.orderPostBackHeader.statusDetail.statusCode = 'order_completed';                 
                   
         
            orderResponse.BOOMIHeader= new TaxProfOrderStatusPostback.BOOMIHeader();
                orderResponse.BOOMIHeader.applicationId = 'SF12';
                orderResponse.BOOMIHeader.timeStamp = 'string'; 
              
            orderResponse.orderResponseData.orderPostBackLineItem  = new List<TaxProfOrderStatusPostback.orderPostBackLineItem>();
                TaxProfOrderStatusPostback.orderPostBackLineItem rc1 = new TaxProfOrderStatusPostback.orderPostBackLineItem();             
                rc1.lineReferenceNumber = Ordline1[0].Name;  
                rc1.accessStartDate = '2018-01-20T00:00:00';        
                rc1.status = 'ENT_COMPLETE';
                rc1.assetId = oliMap.get(Orderline.Id).Tax_Asset_Auto_Number__c  ;//'AL-01';
                orderResponse.orderResponseData.orderPostBackLineItem.add(rc1);
       
       status1= TaxProfOrderStatusPostback.doPost(orderResponse);
       
     
        //Testing for negative case
       TaxProfOrderStatusPostback.DellBoomiResponse orderResponse2 = new  TaxProfOrderStatusPostback.DellBoomiResponse();
       orderResponse2.BOOMIHeader= new TaxProfOrderStatusPostback.BOOMIHeader();
       orderResponse2.BOOMIHeader.applicationId = null;        
       orderResponse2.orderResponseData = new TaxProfOrderStatusPostback.orderResponseData();
       orderResponse2.orderResponseData.orderPostBackHeader = new TaxProfOrderStatusPostback.orderPostBackHeader(); 
       orderResponse2.orderResponseData.orderPostBackHeader.statusDetail = new TaxProfOrderStatusPostback.statusDetail();
       orderResponse2.orderResponseData.orderPostBackHeader.statusDetail.statusCode = 'Pending';     
       status1= TaxProfOrderStatusPostback.doPost(orderResponse2);
       
       //SAP Postback Testing
       TaxProfOrderStatusPostback.DellBoomiResponse orderResponse3 = new  TaxProfOrderStatusPostback.DellBoomiResponse(); 
             orderResponse3.orderResponseData = new TaxProfOrderStatusPostback.orderResponseData();
                
             orderResponse3.orderResponseData.orderPostBackHeader = new TaxProfOrderStatusPostback.orderPostBackHeader();        
                orderResponse3.orderResponseData.orderPostBackHeader.sourceOrTargetOrderID = order1.Name;
                orderResponse3.orderResponseData.orderPostBackHeader.originatingSystem = 'String';
                orderResponse3.orderResponseData.orderPostBackHeader.externalQuoteId = prop.Name;
                orderResponse3.orderResponseData.orderPostBackHeader.iDocNum = 'D-876';
                orderResponse3.orderResponseData.orderPostBackHeader.statusDetail = new TaxProfOrderStatusPostback.statusDetail();
                orderResponse3.orderResponseData.orderPostBackHeader.statusDetail.statusCode = 'order_failed';  
                orderResponse3.orderResponseData.orderPostBackHeader.orderID = '1234';  
                orderResponse3.orderResponseData.orderPostBackHeader.entitlementID= 'TFMS-1234';             
                   
         
            orderResponse3.BOOMIHeader= new TaxProfOrderStatusPostback.BOOMIHeader();
                orderResponse3.BOOMIHeader.applicationId = 'SF12';
                orderResponse3.BOOMIHeader.timeStamp = 'string'; 
             
              orderResponse3.orderResponseData.orderPostBackLineItem  = new List<TaxProfOrderStatusPostback.orderPostBackLineItem>();
                TaxProfOrderStatusPostback.orderPostBackLineItem rc2 = new TaxProfOrderStatusPostback.orderPostBackLineItem();             
                rc2.lineReferenceNumber = Ordline1[0].Name;  
                rc2.contractNumber= '123735';   
                rc2.assetId = oliMap.get(Orderline.Id).Tax_Asset_Auto_Number__c  ;//'AL-01
                rc2.platformAccountIds = new List<TaxProfOrderStatusPostback.platformAccountIds>();
                TaxProfOrderStatusPostback.platformAccountIds pf = new TaxProfOrderStatusPostback.platformAccountIds();
                pf.platform  = 'CUAS';
                pf.accountId = 'uhjuuho';
                rc2.platformAccountIds.add(pf);
                orderResponse3.orderResponseData.orderPostBackLineItem.add(rc2);
           
       status1= TaxProfOrderStatusPostback.doPost(orderResponse3);
       
       test.stopTest();
       //system.debug([Select Id, Request_Message__c, Exception_Message__c, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Order__c =:order.Id and Service_Name__c = 'Order Postback']);
   
 }
}