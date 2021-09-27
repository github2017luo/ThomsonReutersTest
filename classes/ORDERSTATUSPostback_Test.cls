/**
 * Test class to validate the functionality provided by the ORDERSTATUSPostback class 
 *
 * @author  Anshita Sharma
 * @version  2013-03-07
 *
 * CHANGE HISTORY
 * =================================================================================================================================================
 * Date         Name                    Description
 * 2013-03-07   Anshita Sharma            Created         
 * 2013-03-14   Anshita Sharma            Updated as per new order status values and mapping    
 * 2016-01-25   Tadasha Pal               Updated to increase the code coverage                                                      
 * =================================================================================================================================================
**/
@isTest
private class ORDERSTATUSPostback_Test{
    
     @testSetup static void setUpdata()
    {
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        List<RecordtypeIds__c> lisRecord = new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        lisRecord.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        lisRecord.add(recT1);
      
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        lisRecord.add(orecordType5);
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        lisRecord.add(orecordType6);
        
        Insert lisRecord;
        
        List<Order_Status__c> lord = new List<Order_Status__c>();
        
        Order_Status__c lt1 = new Order_Status__c();
        lt1.Name = 'ORDER_COMPLETED';
        lt1.MappingName__c = 'Order Completed';
        lt1.SFDC_Order_Status__c='Order Completed';
        lt1.Sorting_Order__c=4;
        lord.add(lt1);
        
        Order_Status__c lt2 = new Order_Status__c();
        lt2.Name = 'ORDER_OTHERBLK';
        lt2.MappingName__c = 'Order Processed – Review Needed';
        lt2.SFDC_Order_Status__c='Order Other Block';
        lt2.Sorting_Order__c=1;
        lord.add(lt2);
        
        Order_Status__c lt3 = new Order_Status__c();
        lt3.Name = 'ORD_SAVED_PSUBS';
        lt3.MappingName__c = 'Order Completed';
        lt3.SFDC_Order_Status__c='Order Completed';
        lt3.Sorting_Order__c=1;
        lord.add(lt3);
        
        Insert lord;
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(oAccount);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=oAccount.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Opportunity oOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        oOpportunity.Source_System_Detail__c=accountSSD.Id;
        insert oOpportunity;
        
        List<Quote> quoteList = new List<Quote>();
        
        Quote oQuote1 = new Quote(Name = 'Test Quote1', OpportunityId = oOpportunity.Id, SAP_IDOC_Number__c = '12345');   
        quoteList.add(oQuote1); 
        
        Quote oQuote2 = new Quote(Name = 'Test Quote2', OpportunityId = oOpportunity.Id, SAP_IDOC_Number__c = '12347');   
        quoteList.add(oQuote2);
        
        insert quoteList; 
        
        Order__c oTestOrder = new Order__c();
        oTestOrder.Quote__c = oQuote1.Id;
        oTestOrder.Order_Number__c = '003';
        oTestOrder.Order_Status__c = 'Order Completed';
        insert oTestOrder;
        Order__c oTestOrder1 = new Order__c();
        oTestOrder1.Quote__c = oQuote2.Id;
        oTestOrder1.Order_Number__c = '002';
        oTestOrder1.Order_Status__c = 'Order Processed – Review Needed';
        insert oTestOrder1;
    }

    @isTest static void testHandleOrderStatusPostback() {
        
        Test.Starttest();
        
        
        ORDERSTATUSPostback oORDERSTATUSPostback = new ORDERSTATUSPostback();
        ORDERSTATUSPostback.OrderStatusPostbackResponse oOrderStatusPostbackResponse  = new ORDERSTATUSPostback.OrderStatusPostbackResponse ();
        List<ORDERSTATUSPostback.OrderConfirmation> oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>(); 
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
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

        //Account oAccount = UnitTest2.getAccountInstance();
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        insert oAccount;
        
        Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(oAccount);
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=oAccount.ID;
        accountSSD.LCRM_Customer_Group__c='ACADEMIC';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        //Opportunity oOpportunity = UnitTest2.getOpportunityInstance(oAccount.Id);
       Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = 'Prospect';
        oOpportunity.RecordtypeId=opptyRecorType;
        oOpportunity.Source_System_Detail__c=accountSSD.Id;
        oOpportunity.Account=oAccount;
        insert oOpportunity;
        
        List<Quote> quoteList = new List<Quote>();
        
        Quote oQuote1 = new Quote(Name = 'Test Quote1', OpportunityId = oOpportunity.Id, SAP_IDOC_Number__c = '12345');   
        quoteList.add(oQuote1); 
        
        Quote oQuote2 = new Quote(Name = 'Test Quote2', OpportunityId = oOpportunity.Id, SAP_IDOC_Number__c = '12347');   
        quoteList.add(oQuote2);
                   
        for (Quote oQuote : [select Name, OpportunityId, SAP_IDOC_Number__c, QuoteNumber from Quote order by Name]){
            system.debug('oQuote ind:'+oQuote);
            if (oQuote.SAP_IDOC_Number__c == '12345')
                oQuote1 = oQuote;
            else if (oQuote.SAP_IDOC_Number__c == '12347')
                oQuote2 = oQuote;
            }
         //when quoteid is null
        ORDERSTATUSPostback.OrderConfirmation oOrder = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder.idocNumber= '456789' ;
        oOrder.externalQuoteId= null ;
        oOrder.status= null;
        oOrder.orderID= null;
        oOrder.originatingOrderNumber ='123';
        oOrder.timestamp = '201304301406445730000';
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        //when quoteid does not exist in salesforce.
        oOrder.externalQuoteId= '123456879012345' ;
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        //when only quote and updated IDOC number is sent in request
        oOrder.externalQuoteId= oQuote1.QuoteNumber;
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        Quote quote1 = [select id, SAP_IDOC_Number__c from Quote where id =:oQuote1.id];
        List<Order__c> listOrders = [select id from Order__c where id =:oQuote1.id];
        system.debug('listOrderstest:'+listOrders);
        //System.assertEquals(quote1.SAP_IDOC_Number__c,'456789');
       // System.assertEquals(oOrderStatusPostbackResponse.sError,'true');
      //  System.assertEquals(oOrderStatusPostbackResponse.bSuccess,true);
        
        
        //when new orders are sent to be inserted in SFDC
        ORDERSTATUSPostback.OrderConfirmation oOrder1 = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder1.idocNumber= '0000000' ;
        oOrder1.externalQuoteId= oQuote1.QuoteNumber;
        oOrder1.status ='ORDER_COMPLETED';
        oOrder1.orderID ='001';
        oOrder1.originatingOrderNumber ='124';
        oOrder1.timestamp = '201304301406445730001';
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder1);
        
        ORDERSTATUSPostback.OrderConfirmation oOrder2 = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder2.idocNumber= '12346' ;
        oOrder2.externalQuoteId= oQuote1.QuoteNumber;
        oOrder2.status ='ORD_SAVED_PSUBS';
        oOrder2.orderID ='002';
        oOrder2.originatingOrderNumber ='126';
        oOrder2.timestamp = '201304301406445730002';
        //oOrdersList.add(oOrder2);
        
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder2);
       // System.assertEquals(oOrderStatusPostbackResponse.bSuccess,true);  
        
        
        //when existing orders status is update sent along with new orders in request for multiple quotes        
        //oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>();      
        ORDERSTATUSPostback.OrderConfirmation oOrder4 = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder4.idocNumber= '12346' ;
        oOrder4.externalQuoteId= oQuote1.QuoteNumber;
        oOrder4.status ='ORDER_COMPLETED';
        oOrder4.orderID ='002';
        oOrder4.originatingOrderNumber ='126';
        oOrder4.timestamp = '201304301406445730004';
        //oOrdersList.add(oOrder4);
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder4);
   
        ORDERSTATUSPostback.OrderConfirmation oOrder5 = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder5.idocNumber= '12347' ;
        oOrder5.externalQuoteId= oQuote2.QuoteNumber;
        oOrder5.status ='ORDER_COMPLETED';
        oOrder5.orderID ='003';
        oOrder5.originatingOrderNumber ='127';
        oOrder5.timestamp = '201304301406445730005';
        //oOrdersList.add(oOrder5);
        
        
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder5);
        //System.assertEquals(oOrderStatusPostbackResponse.bSuccess,true);        
        Order__c order2 =[Select id,Order_Number__c, Order_Status__c from Order__c where Order_Number__c=:'003'];
        //System.assertEquals(order2.Order_Status__c,'Order Completed');

        Test.Stoptest();    
    }
    @isTest static void testHandleOrderStatusPostbackWhenexistingOrdStatusIsUpdate() {
        Quote oQuote1;
        Quote oQuote2;
        ORDERSTATUSPostback oORDERSTATUSPostback = new ORDERSTATUSPostback();
        ORDERSTATUSPostback.OrderStatusPostbackResponse oOrderStatusPostbackResponse  = new ORDERSTATUSPostback.OrderStatusPostbackResponse ();
        List<ORDERSTATUSPostback.OrderConfirmation> oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>(); 
        
                   
        for (Quote oQuote : [select Name, OpportunityId, SAP_IDOC_Number__c, QuoteNumber from Quote order by Name]){
            system.debug('oQuote ind:'+oQuote);
            if (oQuote.SAP_IDOC_Number__c == '12345')
                oQuote1 = oQuote;
            else if (oQuote.SAP_IDOC_Number__c == '12347')
                oQuote2 = oQuote;
            }
        //when existing orders status is update sent in request        
        //oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>();   
        ORDERSTATUSPostback.OrderConfirmation oOrder3 = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder3.idocNumber= '12346' ;
        oOrder3.externalQuoteId= oQuote1.QuoteNumber;
        oOrder3.status ='ORDER_OTHERBLK';
        oOrder3.orderID ='002';
        oOrder3.originatingOrderNumber ='126';
        oOrder3.timestamp = '201304301406445730006';
        //oOrdersList.add(oOrder3);       
        
        
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder3);
        //System.assertEquals(oOrderStatusPostbackResponse.bSuccess,true);
        Order__c order =[Select id,Order_Number__c, Order_Status__c from Order__c where Order_Number__c=:'002'];
       // System.assertEquals(order.Order_Status__c,'Order Other Block');
    }
    @isTest static void testHandleOrderStatusPostbackMultipleQuotes() {
        Quote oQuote1;
        Quote oQuote2;
        ORDERSTATUSPostback oORDERSTATUSPostback = new ORDERSTATUSPostback();
        ORDERSTATUSPostback.OrderStatusPostbackResponse oOrderStatusPostbackResponse  = new ORDERSTATUSPostback.OrderStatusPostbackResponse ();
        List<ORDERSTATUSPostback.OrderConfirmation> oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>(); 
        
                   
        for (Quote oQuote : [select Name, OpportunityId, SAP_IDOC_Number__c, QuoteNumber from Quote order by Name]){
            system.debug('oQuote ind:'+oQuote);
            if (oQuote.SAP_IDOC_Number__c == '12345')
                oQuote1 = oQuote;
            else if (oQuote.SAP_IDOC_Number__c == '12347')
                oQuote2 = oQuote;
            }
            
        //when existing orders status is update sent along with new orders in request for multiple quotes        
        //oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>();      
        ORDERSTATUSPostback.OrderConfirmation oOrder4 = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder4.idocNumber= '12346' ;
        oOrder4.externalQuoteId= oQuote1.QuoteNumber;
        oOrder4.status ='ORDER_COMPLETED';
        oOrder4.orderID ='002';
        oOrder4.originatingOrderNumber ='126';
        oOrder4.timestamp = '201304301406445730004';
        //oOrdersList.add(oOrder4);
        
        
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder4);
        //System.assertEquals(oOrderStatusPostbackResponse.bSuccess,true);
        Order__c order1 =[Select id,Order_Number__c, Order_Status__c from Order__c where Order_Number__c=:'002'];
        //System.assertEquals(order1.Order_Status__c,'Order Completed');
    } 
    @isTest static void testHandleNewOrderStatusPostback() {
        Quote oQuote1;
        Quote oQuote2;
        ORDERSTATUSPostback oORDERSTATUSPostback = new ORDERSTATUSPostback();
        ORDERSTATUSPostback.OrderStatusPostbackResponse oOrderStatusPostbackResponse  = new ORDERSTATUSPostback.OrderStatusPostbackResponse ();
        List<ORDERSTATUSPostback.OrderConfirmation> oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>(); 
        
                   
        for (Quote oQuote : [select Name, OpportunityId, SAP_IDOC_Number__c, QuoteNumber from Quote order by Name]){
            system.debug('oQuote ind:'+oQuote);
            if (oQuote.SAP_IDOC_Number__c == '12345')
                oQuote1 = oQuote;
            else if (oQuote.SAP_IDOC_Number__c == '12347')
                oQuote2 = oQuote;
            }
        //when new orders are sent to be inserted in SFDC
        ORDERSTATUSPostback.OrderConfirmation oOrder1 = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder1.idocNumber= '0000000' ;
        oOrder1.externalQuoteId= oQuote1.QuoteNumber;
        oOrder1.status ='ORDER_COMPLETED';
        oOrder1.orderID ='001';
        oOrder1.originatingOrderNumber ='124';
        oOrder1.timestamp = '201304301406445730001';
        
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder1);
        
        ORDERSTATUSPostback.OrderConfirmation oOrder2 = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder2.idocNumber= '12346' ;
        oOrder2.externalQuoteId= oQuote1.QuoteNumber;
        oOrder2.status ='ORD_SAVED_PSUBS';
        oOrder2.orderID ='002';
        oOrder2.originatingOrderNumber ='126';
        oOrder2.timestamp = '201304301406445730002';
        oOrder2.orderProcessedBy = 'orderProcessby';
        //oOrdersList.add(oOrder2);
        
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder2);
        //System.assertEquals(oOrderStatusPostbackResponse.bSuccess,true); 
    }
    @isTest static void testHandleOrderStatusPostbackQuoteIdNull() {
        Quote oQuote1;
        Quote oQuote2;
        ORDERSTATUSPostback oORDERSTATUSPostback = new ORDERSTATUSPostback();
        ORDERSTATUSPostback.OrderStatusPostbackResponse oOrderStatusPostbackResponse  = new ORDERSTATUSPostback.OrderStatusPostbackResponse ();
        List<ORDERSTATUSPostback.OrderConfirmation> oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>(); 
        
                   
        for (Quote oQuote : [select Name, OpportunityId, SAP_IDOC_Number__c, QuoteNumber from Quote order by Name]){
            system.debug('oQuote ind:'+oQuote);
            if (oQuote.SAP_IDOC_Number__c == '12345')
                oQuote1 = oQuote;
            else if (oQuote.SAP_IDOC_Number__c == '12347')
                oQuote2 = oQuote;
            }
        //when quoteid is null
        ORDERSTATUSPostback.OrderConfirmation oOrder = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder.idocNumber= '456789' ;
        oOrder.externalQuoteId= null ;
        oOrder.status= null;
        oOrder.orderID= null;
        oOrder.originatingOrderNumber ='123';
        oOrder.timestamp = '201304301406445730000';
        
        
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        //when quoteid does not exist in salesforce.
        oOrder.externalQuoteId= '123456879012345' ;
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        //when only quote and updated IDOC number is sent in request
        oOrder.externalQuoteId= oQuote1.QuoteNumber;
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        
        Quote quote1 = [select id, SAP_IDOC_Number__c from Quote where id =:oQuote1.id];
        system.debug('quote1:'+quote1);
        List<Order__c> listOrders = [select id from Order__c where id =:oQuote1.id];
        system.debug('listOrderstest:'+listOrders);
        //System.assertEquals(quote1.SAP_IDOC_Number__c,'456789');
        //System.assertEquals(oOrderStatusPostbackResponse.bSuccess,true);
    }
    @isTest static void testExceptionOrderStatusPostback() {
        Quote oQuote1;
        Quote oQuote2;
        ORDERSTATUSPostback oORDERSTATUSPostback = new ORDERSTATUSPostback();
        ORDERSTATUSPostback.OrderStatusPostbackResponse oOrderStatusPostbackResponse  = new ORDERSTATUSPostback.OrderStatusPostbackResponse ();
        List<ORDERSTATUSPostback.OrderConfirmation> oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>(); 
        
                   
        for (Quote oQuote : [select Name, OpportunityId, SAP_IDOC_Number__c, QuoteNumber from Quote order by Name]){
            system.debug('oQuote ind:'+oQuote);
            if (oQuote.SAP_IDOC_Number__c == '12345')
                oQuote1 = oQuote;
            else if (oQuote.SAP_IDOC_Number__c == '12347')
                oQuote2 = oQuote;
            }
        //when quoteid is null
        ORDERSTATUSPostback.OrderConfirmation oOrder = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder.idocNumber= '456789' ;
        oOrder.externalQuoteId= null ;
        oOrder.status= 'ORDER_COMPLETED';
        oOrder.orderID= '002';
        oOrder.originatingOrderNumber ='123456789876543321789076543221876';
        oOrder.timestamp = '201304301406445730000';
        
        
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        //when quoteid does not exist in salesforce.
        oOrder.externalQuoteId= '123456879012345' ;
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        //when only quote and updated IDOC number is sent in request
        oOrder.externalQuoteId= oQuote1.QuoteNumber;
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        
        
        Quote quote1 = [select id, SAP_IDOC_Number__c from Quote where id =:oQuote1.id];
        system.debug('quote1:'+quote1);
        List<Order__c> listOrders = [select id from Order__c where id =:oQuote1.id];
        system.debug('listOrderstest:'+listOrders);
        //System.assertEquals(quote1.SAP_IDOC_Number__c,'456789');
      //  System.assertEquals(oOrderStatusPostbackResponse.sError,true);
        system.debug('oOrderStatusPostbackResponse.sError:'+oOrderStatusPostbackResponse.sError);
    }
    
}