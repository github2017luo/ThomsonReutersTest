/**
 * Test class to improve code coverage on account of quote issue on production #10074520 
 *
 * @author  Srikanth kuruva
 * @version  2014-01-21
 *
 * CHANGE HISTORY
 * =================================================================================================================================================
 * Date         Name                    Description
 * 2014-01-21   Srikanth Kuruva            Created         
 * =================================================================================================================================================
**/

@isTest(SeeAlldata=true)

public class improveCodeCoverage_Test{

     public static testMethod void testimproveCodeCoverage(){
     
        //----------code coverage for other classes generated from wsdl
        ecomTocServicesThomsonCom10Core oCore = new ecomTocServicesThomsonCom10Core();
        ecomTocServicesThomsonCom10Core.CoreSystemError oCoreSystemError = new ecomTocServicesThomsonCom10Core.CoreSystemError();
        ecomTocServicesThomsonCom10Core.CoreServiceError oCoreServiceError = new ecomTocServicesThomsonCom10Core.CoreServiceError();
        ecomTocServicesThomsonCom10Core.Message oMessage = new ecomTocServicesThomsonCom10Core.Message();
        ecomTocServicesThomsonCom10Core.CoreValidationError oCoreValidationError = new ecomTocServicesThomsonCom10Core.CoreValidationError();
        ecomTocServicesThomsonCom10Core.Response oResponse = new ecomTocServicesThomsonCom10Core.Response();
        ecomTocServicesThomsonCom10Core.Account oAccount2 = new ecomTocServicesThomsonCom10Core.Account();
        ecomTocServicesThomsonCom10Core.RequestContext oRequestContext = new ecomTocServicesThomsonCom10Core.RequestContext();
        ecomTocServicesThomsonCom10Core.Request oRequest = new ecomTocServicesThomsonCom10Core.Request();
        ecomTocServicesThomsonCom10Core.CoreError oCoreError = new ecomTocServicesThomsonCom10Core.CoreError();
        ecomTocServicesThomsonCom10Core.Property oProperty = new ecomTocServicesThomsonCom10Core.Property();
        ecomTocServicesThomsonCom10Core.ExtensibleObject oExtensibleObject = new ecomTocServicesThomsonCom10Core.ExtensibleObject();
        
        ecomTocServicesThomsonCom20Orders oOrders = new ecomTocServicesThomsonCom20Orders();
        ecomTocServicesThomsonCom20Orders.context_element ocontext_element = new ecomTocServicesThomsonCom20Orders.context_element();
        ecomTocServicesThomsonCom20Orders.OrdersServiceException_element oOrdersServiceException_element = new ecomTocServicesThomsonCom20Orders.OrdersServiceException_element();
        ecomTocServicesThomsonCom20Orders.SapOrderMessage oSapOrderMessage = new ecomTocServicesThomsonCom20Orders.SapOrderMessage();
        ecomTocServicesThomsonCom20Orders.OrderAddress oOrderAddress = new ecomTocServicesThomsonCom20Orders.OrderAddress();
        ecomTocServicesThomsonCom20Orders.CreateQuoteRequest_element oCreateQuoteRequest_element = new ecomTocServicesThomsonCom20Orders.CreateQuoteRequest_element();
        ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element oCreateQuoteResponse_element = new ecomTocServicesThomsonCom20Orders.CreateQuoteResponse_element();
        
        tocSchemasThomsonComHeaders200602 oHeaders = new tocSchemasThomsonComHeaders200602();
        tocSchemasThomsonComHeaders200602.TocHeader_element oTocHeader_element = new tocSchemasThomsonComHeaders200602.TocHeader_element();
        tocSchemasThomsonComHeaders200602.Message_element oMessage_element = new tocSchemasThomsonComHeaders200602.Message_element();
        tocSchemasThomsonComHeaders200602.X_element oX_element = new tocSchemasThomsonComHeaders200602.X_element();
        tocSchemasThomsonComHeaders200602.Id_element oId_element = new tocSchemasThomsonComHeaders200602.Id_element();
        
        ecomOrdersServiceV02 oecomOrdersServiceV02 = new ecomOrdersServiceV02();
        ecomOrdersServiceV02.OrdersServiceV02 oTestService = new ecomOrdersServiceV02.OrdersServiceV02();
        
         Test.Starttest();
        ORDERSTATUSPostback oORDERSTATUSPostback = new ORDERSTATUSPostback();
        ORDERSTATUSPostback.OrderStatusPostbackResponse oOrderStatusPostbackResponse  = new ORDERSTATUSPostback.OrderStatusPostbackResponse ();
        List<ORDERSTATUSPostback.OrderConfirmation> oOrdersList = new List<ORDERSTATUSPostback.OrderConfirmation>(); 
    
        //Account oAccount = UnitTest2.getAccountInstance();
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        insert oAccount;
        
        //Opportunity oOpportunity = UnitTest2.getOpportunityInstance(oAccount.Id);
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = 'Prospect';
        insert oOpportunity;
        
        List<Quote> quoteList = new List<Quote>();
        
        Quote oQuote1 = new Quote(Name = 'Test Quote1', OpportunityId = oOpportunity.Id, SAP_IDOC_Number__c = '12345');   
        quoteList.add(oQuote1); 
        
        Quote oQuote2 = new Quote(Name = 'Test Quote2', OpportunityId = oOpportunity.Id, SAP_IDOC_Number__c = '12347');   
        quoteList.add(oQuote2);
        
        insert quoteList;
                    
        
        for (Quote oQuote : [select Name, OpportunityId, SAP_IDOC_Number__c, QuoteNumber from Quote where Id in :quoteList order by Name]){
          if (oQuote.Name == 'Test Quote1')
            oQuote1 = oQuote;
          else if (oQuote.Name == 'Test Quote2')
            oQuote2 = oQuote;
        }
        
        Order__c oTestOrder = new Order__c();
        oTestOrder.Quote__c = oQuote1.Id;
        oTestOrder.Order_Number__c = '12345';
        oTestOrder.Order_Status__c = 'Order Saved Pending Subs';
        insert oTestOrder;
        
        //when quoteid is null
        ORDERSTATUSPostback.OrderConfirmation oOrder = new ORDERSTATUSPostback.OrderConfirmation();
        oOrder.idocNumber= '456789' ;
        oOrder.externalQuoteId= null ;
        oOrder.status= null;
        oOrder.orderID= null;
        oOrder.originatingOrderNumber ='123';
        oOrder.timestamp = '201304301406445730000';
        oOrderStatusPostbackResponse  = ORDERSTATUSPostback.handleOrderStatusPostback(oOrder);
        test.stopTest();
     }
}