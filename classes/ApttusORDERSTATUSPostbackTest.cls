@isTest
global class ApttusORDERSTATUSPostbackTest implements HttpCalloutMock{
   
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }

   static testMethod void apttusORDERSTATUSPostbackTestMethod()
  {   

     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
      req.requestURI = '/apttusorderpostback/'; 
      
       
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
         List<Order_Status__c> orderStatusList = new List<Order_Status__c>();
         Order_Status__c orderStatus1 = new Order_Status__c(name='ORDER_COMPLETED',Sorting_Order__c=4,SFDC_Order_Status__c='Order Completed');
         Order_Status__c orderStatus2 = new Order_Status__c(name='Inventory Rejected',SFDC_Order_Status__c='No Inventory Available');
         Order_Status__c orderStatus3 = new Order_Status__c(name='IDOC_CREATED',SFDC_Order_Status__c='Order Created');    
         orderStatusList.add(orderStatus1);
         orderStatusList.add(orderStatus2);
         orderStatusList.add(orderStatus3);
         insert orderStatusList;
         
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
        
      Account acc = new Account();
      acc.Name='test';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='WEST';
      Insert acc;
      
      System.assertequals('test',acc.Name,'Success');

      Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS';
        insert proposal;
        
        proposal.APTS_Case_Brand_Value__c = 'ACRITAS';
        update proposal;
        
      Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
      order.Apttus_Config2__Type__c='New';
      order.Apttus_Config2__Status__c='Pending';
      order.APTS_SSD_Sold_To__c=accountSSD.id;
      order.APTS_SSD_bill_to__c=accountSSD.id;
      order.APTS_SSD_Ship_To__c=accountSSD.id;
      order.Apttus_QPConfig__ProposalId__c=proposal.id;
      //order.Name='O-43726783';
      insert order;
    
    
    ApttusORDERSTATUSPostback.StatusUpdate status1 = new ApttusORDERSTATUSPostback.StatusUpdate();
     ApttusORDERSTATUSPostback.StatusUpdate status2 = new ApttusORDERSTATUSPostback.StatusUpdate();
      ApttusORDERSTATUSPostback.StatusUpdate status3 = new ApttusORDERSTATUSPostback.StatusUpdate();
        //status1.originatingOrderNumber =[select Name from Apttus_Config2__Order__c where Apttus_Config2__Status__c = 'Pending' and Apttus_Config2__SoldToAccountId__c=:acc.id limit 1].Name;
        status1.originatingOrderNumber =[select Name from Apttus_Proposal__Proposal__c where id=:proposal.id limit 1].Name;
        status1.idocNumber = 'testidoc';
        status1.soldToAccount = 'testacc';
        status1.orderID = 'testid';
        status1.productId ='prodid';
        status1.orderCancelled = 'no';
        status1.docStatus = Order_Status__c.getInstance('ORDER_COMPLETED').Name;
        status1.docId = 'doc123';
        status1.contractNum = 'num123';
        status1.contractLine = 'lin123';
        status1.deliveryDoc = 'del123';
        status1.deliveryDate = '123';
        status1.shipMethod = 'ship123';
        status1.shipCarrier = 'carrier';
        status1.trackingNum = '123';
        status1.externalUserId = 'ext123';
        status1.timestamp = '11';
        status1.orderProcessedBy = 'abc';
        status1.QuoteId = 'quote123';
        
        status3.originatingOrderNumber =[select Name from Apttus_Proposal__Proposal__c where id=:proposal.id limit 1].Name;
        status3.idocNumber = 'testidoc';
        status3.soldToAccount = 'testacc';
        status3.orderID = 'testid';
        status3.productId ='prodid';
        status3.orderCancelled = 'no';
        status3.docStatus = Order_Status__c.getInstance('Inventory Rejected').Name;
        status3.docId = 'doc123';
        status3.contractNum = 'num123';
        status3.contractLine = 'lin123';
        status3.deliveryDoc = 'del123';
        status3.deliveryDate = '123';
        status3.shipMethod = 'ship123';
        status3.shipCarrier = 'carrier';
        status3.trackingNum = '123';
        status3.externalUserId = 'ext123';
        status3.timestamp = '11';
        status3.orderProcessedBy = 'abc';
        status3.QuoteId = 'quote123';
        
        status2.originatingOrderNumber =[select Name from Apttus_Proposal__Proposal__c where id=:proposal.id limit 1].Name;
        status2.idocNumber = 'testidoc';
        status2.soldToAccount = 'testacc';
        status2.orderID = 'testid';
        status2.productId ='prodid';
        status2.orderCancelled = 'no';
        status2.docStatus = Order_Status__c.getInstance('IDOC_CREATED').Name;
        status2.docId = 'doc123';
        status2.contractNum = 'num123';
        status2.contractLine = 'lin123';
        status2.deliveryDoc = 'del123';
        status2.deliveryDate = '123';
        status2.shipMethod = 'ship123';
        status2.shipCarrier = 'carrier';
        status2.trackingNum = '123';
        status2.externalUserId = 'ext123';
        status2.timestamp = '11';
        status2.orderProcessedBy = 'abc';
        status2.QuoteId = 'quote123';
     
       

    ApttusORDERSTATUSPostback.status stat1 = new ApttusORDERSTATUSPostback.status();
    ApttusORDERSTATUSPostback.status stat2 = new ApttusORDERSTATUSPostback.status();
    ApttusORDERSTATUSPostback.status stat3 = new ApttusORDERSTATUSPostback.status();
    ApttusORDERSTATUSPostback pstbck = new ApttusORDERSTATUSPostback();
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new ApttusORDERSTATUSPostbackTest());
    stat1 = ApttusORDERSTATUSPostback.handleOrderStatusPostback(status1);
    stat2 = ApttusORDERSTATUSPostback.handleOrderStatusPostback(status2);
    stat3 = ApttusORDERSTATUSPostback.handleOrderStatusPostback(status3);
    Apttus_Config2__Order__c app = new Apttus_Config2__Order__c();
    
    app.Apttus_Config2__Status__c = 'yes';
    app.Apttus_Config2__OrderReferenceNumber__c = '123';
    app.Apttus_Config2__OrderDate__c = datetime.newInstance(2014, 9, 15, 12, 30, 0);
    insert app;
    Test.stopTest();
}
}