@isTest
public class APTS_OrderPostCallbackEventTest {
  @isTest public static void data() {
    List < KeyValueListStore__c > keyvaluestore = new List < KeyValueListStore__c > {
      new KeyValueListStore__c(Name = 'ANZUsersProfileId', TextValue__c = System.Label.APTS_OC_Test_Id),
      new KeyValueListStore__c(Name = 'ReasonWithCompetitor', TextValue__c = 'Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')
    };
    //Test.startTest();
    insert keyvaluestore;
      List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
    List < Order_Status__c > orderStatusList = new List < Order_Status__c > ();
    Order_Status__c orderStatus1 = new Order_Status__c(name = 'ORDER_COMPLETED', Sorting_Order__c = 4, SFDC_Order_Status__c = 'Order Completed');
    Order_Status__c orderStatus2 = new Order_Status__c(name = 'Inventory Rejected', SFDC_Order_Status__c = 'No Inventory Available');
    Order_Status__c orderStatus3 = new Order_Status__c(name = 'IDOC_CREATED', SFDC_Order_Status__c = 'Order Created');
    orderStatusList.add(orderStatus1);
    orderStatusList.add(orderStatus2);
    orderStatusList.add(orderStatus3);
    insert orderStatusList;

    List < RecordtypeIds__c > recordlist = new List < RecordtypeIds__c > ();
    RecordtypeIds__c recordtype = new RecordtypeIds__c();
    recordtype.Name = 'Pre-Pipeline Opportunities';
    recordtype.recTypeId__c = System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);

    RecordtypeIds__c recordtype1 = new RecordtypeIds__c();
    recordtype1.Name = 'Pipeline Opportunities';
    recordtype1.recTypeId__c = System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    insert recordlist;

    Account acc = new Account();
    acc.Name = 'test';
    acc.CurrencyIsoCode = 'USD';
    acc.Sales_Org__c = 'WEST';
    Insert acc;

    System.assertequals('test', acc.Name, 'Success');

    Id ssdRecorType = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
    Source_System_Detail__c accountSSD = new Source_System_Detail__c();
    accountSSD.RecordtypeId = ssdRecorType;
    accountSSD.Name = 'ABC';
    accountSSD.Source_System_Name__c = 'ABC';
    accountSSD.Account_Name__c = acc.ID;
    accountSSD.Account_Inactive__c = false;
    accountSSD.LCRM_Sales_Org__c = 'WEST';
    insert accountSSD;
   
    Id opptyRecorType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty = APTS_TestDataFactory.createOpportunity('abc', acc.id, 'Needs Analysis', Date.Today());
    oppty.RecordtypeId = opptyRecorType;
    oppty.Source_System_Detail__c = accountSSD.id;
    oppty.Account = acc;
    insert oppty;

    Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
    proposal.APTS_Proposal_Business_Unit__c = 'SCS';
    proposal.APTS_Case_Brand_Value__c = 'ACRITAS';
    proposal.Apttus_Proposal__Account__c=acc.id; 
    insert proposal;

    //update proposal;

  

    Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
    order.Apttus_Config2__Type__c = 'New';
    order.Apttus_Config2__Status__c = 'Pending';
    order.APTS_SSD_Sold_To__c = accountSSD.id;
    order.APTS_SSD_bill_to__c = accountSSD.id;
    order.APTS_SSD_Ship_To__c = accountSSD.id;
    order.Apttus_QPConfig__ProposalId__c = proposal.id;
    order.APTS_SAP_Status__c = 'Pending';
    //order.Name='O-43726783';
    insert order;

    //Test.stopTest();
        
  }
  @isTest
  static void orderPostbackActivationSuccess() {
      data();
    Apttus_Proposal__Proposal__c proposal = [SELECT Id, Name from Apttus_Proposal__Proposal__c LIMIT 1];
    Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    User corpUser=new User(username='testOrderPostCallbackEvent@tr.com',
    lastname='testuser',
    Alias='testuser',
    Email='testuser@tcs.com',
    Sub_Bu__c='US',
    TimeZoneSidKey = 'GMT',
    ProfileId = profileId.id,
    LanguageLocaleKey = 'en_US',
    EmailEncodingKey = 'UTF-8',
    LocaleSidKey = 'en_US',
    Default_Catalog__c ='USL');
    insert corpUser;
    
    Test.startTest();
    //System.runAs(CorpUser) {
        ApttusORDERSTATUSPostback.StatusUpdate status1 = new ApttusORDERSTATUSPostback.StatusUpdate();
        
        status1.originatingOrderNumber = [select Name from Apttus_Proposal__Proposal__c where id =: proposal.id limit 1].Name;
        status1.idocNumber = 'testidoc';
        status1.soldToAccount = 'testacc';
        status1.orderID = 'testid';
        status1.productId = 'prodid';
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
        
        APTS_OrderPostCallbackEventHelper.orderStatusPostback ospostback = new APTS_OrderPostCallbackEventHelper.orderStatusPostback();
        ospostback.statusUpdate = status1;
    
        APTS_Order_Postback__e event = new APTS_Order_Postback__e();
        event.OrderNo__c = proposal.Name;
        event.PostbackJSON__c = JSON.serialize(ospostback);
        EventBus.publish(event);
    
    //}
    APTS_OrderPostCallbackEventHelper2 helper2 = new APTS_OrderPostCallbackEventHelper2();
    helper2.listofprop.add(proposal.Id);
    helper2.failurereason.put(proposal.Id,'ACRITAS');
    helper2.performDMLS();
    
    Test.stopTest();
    System.assertEquals([SELECT ID,Apttus_Config2__Status__c from Apttus_Config2__Order__c LIMIT 1].Apttus_Config2__Status__c, 'Pending','Status Updated Successfully');
  }
  @isTest
  static void orderPostbackIDOCSuccess() {
      data();
    Apttus_Proposal__Proposal__c proposal = [SELECT Id, Name from Apttus_Proposal__Proposal__c LIMIT 1];
    Test.startTest();

    ApttusORDERSTATUSPostback.StatusUpdate status2 = new ApttusORDERSTATUSPostback.StatusUpdate();

    status2.originatingOrderNumber = [select Name from Apttus_Proposal__Proposal__c where id =: proposal.id limit 1].Name;
    status2.idocNumber = 'testidoc';
    status2.soldToAccount = 'testacc';
    status2.orderID = 'testid';
    status2.productId = 'prodid';
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
    
    APTS_OrderPostCallbackEventHelper.orderStatusPostback ospostback = new APTS_OrderPostCallbackEventHelper.orderStatusPostback();
    ospostback.statusUpdate = status2;

    APTS_Order_Postback__e event = new APTS_Order_Postback__e();
    event.OrderNo__c = proposal.Name;
    event.PostbackJSON__c = JSON.serialize(ospostback);
    EventBus.publish(event);
    

    Test.stopTest();
   System.assertEquals([SELECT ID,IDOC__c from Apttus_Config2__Order__c LIMIT 1].IDOC__c,'testidoc','Status Updated Successfully');
  }
  @isTest
  static void orderPostbackInventoryCompletedSuccess() {
      data();
    Apttus_Proposal__Proposal__c proposal = [SELECT Id, Name from Apttus_Proposal__Proposal__c LIMIT 1];
    Test.startTest();

    ApttusORDERSTATUSPostback.StatusUpdate status3 = new ApttusORDERSTATUSPostback.StatusUpdate();

    status3.originatingOrderNumber = [select Name from Apttus_Proposal__Proposal__c where id =: proposal.id limit 1].Name;
    status3.idocNumber = 'testidoc';
    status3.soldToAccount = 'testacc';
    status3.orderID = 'testid';
    status3.productId = 'prodid';
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
    
    APTS_OrderPostCallbackEventHelper.orderStatusPostback ospostback = new APTS_OrderPostCallbackEventHelper.orderStatusPostback();
    ospostback.statusUpdate = status3;

    APTS_Order_Postback__e event = new APTS_Order_Postback__e();
    event.OrderNo__c = proposal.Name;
    event.PostbackJSON__c = JSON.serialize(ospostback);
    EventBus.publish(event);
    

    Test.stopTest();
    System.assertEquals([SELECT ID,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c LIMIT 1].Apttus_Proposal__Approval_Stage__c, 'Draft','Status Updated Successfully');
  }
  @isTest
  static void orderSubmissionSuccess() {
      data();
    Apttus_Proposal__Proposal__c proposal = [SELECT Id, Name from Apttus_Proposal__Proposal__c LIMIT 1];
    Test.startTest();

    APTS_Order_Postback__e event = new APTS_Order_Postback__e();
    event.OrderNo__c = proposal.Name;
    event.OrderSubStatus__c = '{"CreateOrderResponse":{"Status" : { "Code" : "200", "Description" : "test" }}}';
    EventBus.publish(event);
    

    Test.stopTest();
   System.assertEquals([SELECT ID,APTS_SAP_Status__c from Apttus_Config2__Order__c LIMIT 1].APTS_SAP_Status__c, 'Pending','Status Updated Successfully');
  }
     @isTest
  static void orderSubmissionSuccess2() {
      data();
    Apttus_Proposal__Proposal__c proposal = [SELECT Id, Name from Apttus_Proposal__Proposal__c LIMIT 1];
    Test.startTest();

    APTS_Order_Postback__e event = new APTS_Order_Postback__e();
    event.OrderNo__c = proposal.Name;
    event.OrderSubStatus__c = '{"orderResponse":{"statusDetail" : { "statusCode" : "200", "Description" : "test" }}}';
    EventBus.publish(event);
    
    Test.stopTest();
    System.assertEquals([SELECT ID,APTS_SAP_Status__c from Apttus_Config2__Order__c LIMIT 1].APTS_SAP_Status__c, 'Pending','Status Updated Successfully');
  }
}