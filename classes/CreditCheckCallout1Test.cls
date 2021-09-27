@isTest
public class CreditCheckCallout1Test {
      static testMethod void checkcallout() {
         
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        insert a;
        KeyValueListStore__c key1 = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1');
        KeyValueListStore__c key2 = new KeyValueListStore__c(Name='BOOMIProductId',TextValue__c='SF12');
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{key1,key2};        
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
        insert recordlist;
         
        Id ssdRecordTypeId = Schema.SObjectType.Source_system_detail__c .getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_system_detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordTypeId=ssdRecordTypeId;
        accountSSD.APTS_Customer_Category__c='1';
        accountSSd.Name='Test';
        accountSSd.LCRM_Email__c='xyz@tcs.com';
        accountSSd.County__c='RIVERSIDE';
        accountSSd.LCRM_Building__c='test';
        accountSSd.LCRM_VAT__c='test';
        accountSSd.LCRM_Tax_Number__c='test';
        accountSSd.CurrencyIsoCode='USD';
        accountSSD.LCRM_Customer_Group__c='Academic';
        //accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        //accountSSD.Source_System_Account_Number__c='123456';
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
        accountSSD.LCRM_SAP_Account_Number__c='1234567';
        insert accountSSD;  
        
       Product2 oProduct=new Product2(Name ='1SRC NRA Banner Interface',
                                  ProductCode = '41318361',
                                  WLEC_Product_Category__c='SS',
                                  APTS_Product_Pricing_Model__c = 'INCOME TAX');     
       insert oProduct;
       
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        opp.RecordtypeId=opptyRecorType;
        opp.Source_System_Detail__c=accountSSD.id;
        opp.Account=a;
        insert opp; 
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'CreditCheck',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings1 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings2 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'EnterpriseWSDL',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings3 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'StatusPostbackLocation',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wsList = new List<WebServiceSettings__c>{oWebServiceSettings, o1WebServiceSettings, 
                        o1WebServiceSettings1, o1WebServiceSettings2, o1WebServiceSettings3};
        insert wsList ;
         
       Id propRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get('Proposal').getRecordTypeId();  
       Apttus_Proposal__Proposal__c proposal= new Apttus_Proposal__Proposal__c();
       proposal.RecordTypeId=propRecordTypeId;
       proposal.Apttus_Proposal__Account__c=a.id;
       proposal.APTS_SSD_ship_to__c=accountSSD.Id;
       proposal.APTS_SSD_bill_to__c=accountSSD.Id;
       proposal.APTS_SSD_Sold_To__c=accountSSD.Id;
       proposal.APTS_Payer__c=accountSSD.Id;
       proposal.Apttus_Proposal__Opportunity__c = opp.id;
       proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';
       proposal.Apttus_Proposal__Approval_Stage__c ='Accepted';
       proposal.APTS_Send_NACI_Form__c = true;
       proposal.Credit_Check_Flag__c = true;
       insert proposal; 
        Test.startTest();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
        order.Apttus_QPConfig__ProposalId__c = proposal.id;
        order.Apttus_Config2__ActivatedDate__c=null;       
        order.IDOC__c=null; 
        order.Apttus_Config2__Status__c = 'Pending';
        insert order; 
        Test.setMock(HttpCalloutMock.class, new CreditCheckMockHttpResponseGenerator());
        CreditCheckCallout1.creditchekcallout(order.Id);
        accountSSD.Source_System_Account_Number__c='123456';
        update accountSSD;
        
        CreditCheckSerializeandDeserializeRes.SetCCBySAPAccountResponse testcov1 = new CreditCheckSerializeandDeserializeRes.SetCCBySAPAccountResponse(); 
        testcov1.BOOMIHeader = new CreditCheckSerializeandDeserializeRes.BOOMIHeader();
        testcov1.BOOMIHeader.applicationId ='SF12';
        testcov1.BOOMIHeader.transactionId ='test';
        testcov1.BOOMIHeader.messageId ='test';
        testcov1.BOOMIHeader.messageHistory ='test';
        testcov1.BOOMIHeader.tracingId ='test';
        testcov1.BOOMIHeader.timeStamp ='test';
        testcov1.BOOMIHeader.instanceId ='test';
        testcov1.BOOMIHeader.companyId ='test';
        testcov1.BOOMIHeader.configGroup ='test';
        testcov1.BOOMIHeader.payloadVersion ='test';
        testcov1.BOOMIHeader.postBackURL ='test';
        testcov1.BOOMIHeader.profileId ='test';
        
        testcov1.CreditCheckResponse = new CreditCheckSerializeandDeserializeRes.CreditCheckResponse();
        testcov1.CreditCheckResponse.segment ='test';
        testcov1.CreditCheckResponse.accountBlocked ='test';
        testcov1.CreditCheckResponse.requireAttention ='test';
        testcov1.CreditCheckResponse.endDate ='test';
        
        CreditCheckSerializeandDeserializeReq testcov2 = new CreditCheckSerializeandDeserializeReq();
        testcov2.BOOMIHeader = new CreditCheckSerializeandDeserializeReq.BOOMIHeader();
        testcov2.BOOMIHeader.applicationId ='SF12';
        testcov2.BOOMIHeader.transactionId ='test';
        testcov2.BOOMIHeader.messageId ='test';
        testcov2.BOOMIHeader.messageHistory ='test';
        testcov2.BOOMIHeader.tracingId ='test';
        testcov2.BOOMIHeader.timeStamp ='test';
        testcov2.BOOMIHeader.instanceId ='test';
        testcov2.BOOMIHeader.companyId ='test';
        testcov2.BOOMIHeader.configGroup ='test';
        testcov2.BOOMIHeader.payloadVersion ='test';
        testcov2.BOOMIHeader.postBackURL ='test';
        testcov2.BOOMIHeader.profileId ='test';
        
        List<CreditCheckSerializeandDeserializeReq.CreditCheckRequest> testcov3= new List<CreditCheckSerializeandDeserializeReq.CreditCheckRequest>();
        CreditCheckSerializeandDeserializeReq.CreditCheckRequest testcov4=new CreditCheckSerializeandDeserializeReq.CreditCheckRequest();
        List<CreditCheckSerializeandDeserializeReq.CheckingSchedule> testcov6= new List<CreditCheckSerializeandDeserializeReq.CheckingSchedule>();
        CreditCheckSerializeandDeserializeReq.CheckingSchedule testcov5 = new CreditCheckSerializeandDeserializeReq.CheckingSchedule();
        testcov5.valuationDate = 'test';
        testcov5.segment = 'test';
        testcov5.currencyCode = 'test';
        testcov5.amount = 'test';
        List<CreditCheckSerializeandDeserializeReq.DocumentInfo> testcov7= new List<CreditCheckSerializeandDeserializeReq.DocumentInfo>();
        CreditCheckSerializeandDeserializeReq.DocumentInfo testcov8 = new CreditCheckSerializeandDeserializeReq.DocumentInfo();
        testcov8.documentNumber  = 'test';
        List<CreditCheckSerializeandDeserializeReq.DocItems> testcov9= new List<CreditCheckSerializeandDeserializeReq.DocItems>();
        CreditCheckSerializeandDeserializeReq.DocItems testcov10 = new CreditCheckSerializeandDeserializeReq.DocItems();
        testcov10.itemNumber = 'test';
        
       //Test.startTest();
       Apttus_Config2__Order__c order3 = [select id,Apttus_Config2__ActivatedDate__c,APTS_SAP_Status__c from Apttus_Config2__Order__c  where Id=:order.Id];
       List<Id> orderIds = new List<Id>();
       orderIds.add(order.Id);
       CreditCheckCallout1.creditchekcallout(order.Id);
       List<Apttus_Proposal__Proposal__c> prop = new List<Apttus_Proposal__Proposal__c>();
       Apttus_Proposal__Proposal__c proposal1= new Apttus_Proposal__Proposal__c();
       proposal1.RecordTypeId=propRecordTypeId;
       proposal1.Apttus_Proposal__Account__c=a.id;
       proposal1.APTS_SSD_ship_to__c=accountSSD.Id;
       proposal1.APTS_SSD_bill_to__c=accountSSD.Id;
       proposal1.APTS_SSD_Sold_To__c=accountSSD.Id;
       proposal1.APTS_Payer__c=accountSSD.Id;
       proposal1.Apttus_Proposal__Opportunity__c = opp.id;
       proposal1.APTS_Proposal_Business_Unit__c = 'Tax Professional';
       proposal1.Apttus_Proposal__Approval_Stage__c ='Accepted';
       proposal1.APTS_Send_NACI_Form__c = true;
       proposal1.Credit_Check_Flag__c = true;
       proposal1.SAP_Credit_Check_Status__c ='Pass';
       prop.add(proposal1); 
          
       Apttus_Proposal__Proposal__c proposal2= new Apttus_Proposal__Proposal__c();
       proposal2.RecordTypeId=propRecordTypeId;
       proposal2.Apttus_Proposal__Account__c=a.id;
       proposal2.APTS_SSD_ship_to__c=accountSSD.Id;
       proposal2.APTS_SSD_bill_to__c=accountSSD.Id;
       proposal2.APTS_SSD_Sold_To__c=accountSSD.Id;
       proposal2.APTS_Payer__c=accountSSD.Id;
       proposal2.Apttus_Proposal__Opportunity__c = opp.id;
       proposal2.APTS_Proposal_Business_Unit__c = 'Tax Professional';
       proposal2.Apttus_Proposal__Approval_Stage__c ='Accepted';
       proposal2.APTS_Send_NACI_Form__c = true;
       proposal2.Credit_Check_Flag__c = true;
       proposal2.SAP_Credit_Check_Status__c='Pending';
       prop.add(proposal2);
       insert prop; 
       Apttus_Proposal__Proposal__c proptest = [Select Id,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Approval_Stage__c,APTS_Send_NACI_Form__c,Credit_Check_Flag__c,SAP_Credit_Check_Status__c from Apttus_Proposal__Proposal__c where Id =: proposal1.Id];
          
       List<Apttus_Config2__Order__c> ord = new List<Apttus_Config2__Order__c>();
        Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
        order1.Apttus_QPConfig__ProposalId__c = proposal1.id;
        order1.Apttus_Config2__ActivatedDate__c=null;       
        order1.IDOC__c=null; 
        ord.add(order1); 
          
        Apttus_Config2__Order__c order2 = new Apttus_Config2__Order__c(Apttus_Config2__RelatedOpportunityId__c=opp.id);
        order2.Apttus_QPConfig__ProposalId__c = proposal1.id;
        order2.Apttus_Config2__ActivatedDate__c=null;       
        order2.IDOC__c=null; 
        ord.add(order2); 
        insert ord;
        Delete key2;
        CreditCheckCallout1.creditchekcallout(order.Id);
        KeyValueListStore__c key3 = new KeyValueListStore__c(Name='BOOMIProductId',TextValue__c='SF12');
        insert key3;
        Test.stopTest();
      }
}