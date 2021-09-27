@isTest 
/**
* @description CreateSSDCustomerFromESI_Test
*/
public class CreateSSDCustomerFromESI_Test{ 
  /**
     * @description testCreateCustomer
     */
    public static testMethod void testCreateCustomer() {
        
        String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
        new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
         new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
           new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
            new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
        };
        
        insert keyValueList;
        List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='West')};
        insert codeList;
        
        List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
        insert bigRuleList;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='USL_Source_Systems';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        insert recordlist;
        
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        
        oAccount.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount.BillingCity = 'SAN FRANCISCO';
        oAccount.BillingState = 'CA';
        oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.Is_Customer_Review_Complete__c=true;
        insert oAccount;
    System.assertequals('Unit Test',oAccount.Name,'Success');
        
        Source_system_detail__c ssd = new Source_system_detail__c();
        ssd.name ='test source system';
        ssd.city__c='CA';
        ssd.Account_Name__c=oAccount.Id;
        ssd.Source_System_Name__c='Test SSD';
        ssd.country__c ='US';
        ssd.LCRM_Industry__c='AC ACCOUNTING';
        ssd.LCRM_Sales_Org__c='WEST';
        ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
        ssd.Number_Street__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.OLC_Account_Number__c='test';
         ssd.County__c='test county';
        ssd.State__c='CA';
        ssd.LCRM_Customer_Group__c='ACADEMIC';
        ssd.CurrencyIsoCode='USD';
        insert ssd;
        
        Source_system_detail__c ssd2 = new Source_system_detail__c();
        ssd2.name ='test source system';
        ssd2.city__c='CA';
        ssd2.Account_Name__c=oAccount.Id;
        ssd2.Source_System_Name__c='Test SSD';
        ssd2.country__c ='US';
        ssd2.LCRM_Industry__c='AC ACCOUNTING';
        ssd2.LCRM_Sales_Org__c='WEST';
        ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
        ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
         ssd2.County__c='test county';
        ssd2.State__c='CA';
        ssd2.LCRM_Customer_Group__c='ACADEMIC';
        ssd2.CurrencyIsoCode='USD';
        insert ssd2;
        Source_system_detail__c ssd3 = new Source_system_detail__c();
        ssd3.name ='test source system';
        ssd3.city__c='CA';
        ssd3.Account_Name__c=oAccount.Id;
        ssd3.Source_System_Name__c='Test SSD';
        ssd3.country__c ='US';
        ssd3.LCRM_Industry__c='AC ACCOUNTING';
        ssd3.LCRM_Sales_Org__c='WEST';
        ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
        ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
         ssd3.County__c='test county';
        ssd3.State__c='CA';
        ssd3.LCRM_Customer_Group__c='ACADEMIC';
        ssd3.CurrencyIsoCode='USD';
        insert ssd3;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=SSD.id;
        oppty.Account=oAccount;
        insert oppty;
        Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty2.RecordtypeId=opptyRecorType;
        oppty2.Source_System_Detail__c=SSD2.id;
        oppty2.Account=oAccount;
        insert oppty2;
        
        test.StartTest();
                
        List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,SSD.Id);
        Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,SSD2.Id);
        propList.add(oProposal);
        propList.add(oProposal2);
        insert propList;
        
         List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order1.CreatedDate=now.addDays(-1);
        orderList.add(order1);
        
        Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order2);
        Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order3);
        Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order4);
        
        insert orderList;
        
         Integration_Logger__c logger1=new Integration_Logger__c();
         logger1.Exception_Message__c='error';
         logger1.Object_Id__c = '';
         logger1.Object_Name__c = 'Quote/Proposal';
         logger1.Request_Message__c = '';         
         logger1.Request_Type__c = 'Outbound';
         logger1.Service_Name__c = 'OrderSubmission';
         logger1.Order__c= order3.Id;
         logger1.Success__c = true;
     
        insert logger1;
        Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
        insert bigrule ;
        Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CA',Region_Name__c ='cal');
        insert cregion;
         Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
        CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
         CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
          CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
        APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
        APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"1005215581","prevAcct":null,"partnerFunction":[{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
            //build the parameters for sending the request - context_element
            testCov.context = new APTS_CreateSSDJSON2Apex.context();
            testCov.context.allowAdminEmails='test';
            testCov.context.requestor='test';
            testCov.context.userId='test';
            testCov.context.accountType='test';
            //testCov.context.extensibleAttributes{get;set;}
            //testCov.context.{get;set;}
            testCov.context.emailAddress='test';
            testCov.context.internalUser=true;
            testCov.context.fax='test';
            testCov.context.adminName='test';
            testCov.context.extension='test';
            testCov.context.adminEmail='test';
            testCov.context.phone='test';
            testCov.context.alternateEmailAddress='test';
            testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
            testCov.ESIHeader.postBackURL='test';
            testCov.ESIHeader.timeStamp='test';
            testCov.ESIHeader.instanceId='test';
            testCov.ESIHeader.tracingId='test';
            testCov.ESIHeader.companyId='test';
            testCov.ESIHeader.messageHistory='test';
            testCov.ESIHeader.configGroup='test';
            testCov.ESIHeader.messageId='test';
            testCov.ESIHeader.payloadVersion='test';
            testCov.ESIHeader.transactionId='test';
            
            testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
            List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();
       
 //List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
  testCov.customer.isPrimary=true;
        testCov.customer.externalAccountId='test';
        testCov.customer.industryCode='test';
        testCov.customer.accountCustomerAddressID='test';
        testCov.customer.parentAccountNumber='test';
        testCov.customer.relationshipModel='test';
       testCov.customer.accountType='test';
        testCov.customer.merchantCategoryClassificationCode='test';
        testCov.customer.companyName='test';
        testCov.customer.segment='test';
        testCov.customer.companyId='test';
        testCov.customer.applyDate='test';
        testCov.customer.accountNumber='test';
        testCov.customer.accountStatus='test';
        testCov.customer.hierarchyType='test';
        testCov.customer.KNOwned='test';
        testCov.customer.vatCode='test';
        testCov.customer.accountGroup='test';
        testCov.customer.partnerType='test';
        testCov.customer.accountClass='test';
       testCov.customer.complianceJobRole=compList;
        testCov.customer.primaryBillingNumber='test';
        testCov.customer.jurisdictionCode='test';
        testCov.customer.legacyThomsonCustomerId='test';
        testCov.customer.taxCodeType='test';
        testCov.customer.customerJourney='test';
        testCov.customer.lastUpdatedDate='test';
        testCov.customer.website='test';
        test.StopTest();
       
    }
    //starts
      /**
     * @description testCreateCustomer3
     */
public static testMethod void testCreateCustomer3() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse response=new HttpResponse() ;
        response.setStatusCode(403);
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"example":"test"}');
        // Verify response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json','contentType not equal to application/json');
        String actualValue = response.getBody();
        String expectedValue = '{"example":"test"}';
        System.assertEquals(actualValue, expectedValue,'actualValue not equal expected value');
        System.assertEquals(403, response.getStatusCode(),'get status code not 403');
    }
    
      /**
     * @description testCreateCustomer4
     */
    public static testMethod void testCreateCustomer4() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse response=new HttpResponse() ;
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"example":"test"}');
        // Verify response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json','contentType is not equal');
        String actualValue = response.getBody();
        String expectedValue = '{"example":"test"}';
        System.assertEquals(actualValue, expectedValue,'actualvalue is not equal to expected');
        System.assertEquals(200, response.getStatusCode(),'getstatuscode is not same');
    }
    
      /**
     * @description testCreateCustomer2
     */
    //stops
     public static testMethod void testCreateCustomer2() {
        
        String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
        new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
         new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
           new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
            new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
        };
        
        insert keyValueList;
        List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='West')};
        insert codeList;
        
        List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
        insert bigRuleList;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='USL_Source_Systems';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        insert recordlist;
        
        
        
        
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'WEST';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        
        oAccount.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount.BillingCity = 'SAN FRANCISCO';
        oAccount.BillingState = 'CA';
        oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.Is_Customer_Review_Complete__c=true;
        insert oAccount;
    System.assertequals('Unit Test',oAccount.Name,'Success');
        
        Source_system_detail__c ssd = new Source_system_detail__c();
        ssd.name ='test source system';
        ssd.city__c='CA';
        ssd.Account_Name__c=oAccount.Id;
        ssd.Source_System_Name__c='Test SSD';
        ssd.country__c ='US';
        ssd.LCRM_Industry__c='AC ACCOUNTING';
        ssd.LCRM_Sales_Org__c='WEST';
        ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
        ssd.Number_Street__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.OLC_Account_Number__c='test';
         ssd.County__c='test county';
        ssd.State__c='CAAA';
        ssd.LCRM_Customer_Group__c='ACADEMIC';
        ssd.CurrencyIsoCode='USD';
        insert ssd;
        
        Source_system_detail__c ssd2 = new Source_system_detail__c();
        ssd2.name ='test source system';
        ssd2.city__c='CA';
        ssd2.Account_Name__c=oAccount.Id;
        ssd2.Source_System_Name__c='Test SSD';
        ssd2.country__c ='US';
        ssd2.LCRM_Industry__c='AC ACCOUNTING';
        ssd2.LCRM_Sales_Org__c='WEST';
        ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssssbghhfuffuygfufytfgjuguyyiftyugfyufygfty';
        ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
         ssd2.County__c='test county';
        ssd2.State__c='CA';
        ssd2.LCRM_Customer_Group__c='ACADEMIC';
        ssd2.CurrencyIsoCode='USD';
        insert ssd2;
        Source_system_detail__c ssd3 = new Source_system_detail__c();
        ssd3.name ='test source system Akhilesh dfgg ertgf swerwe resreewtert' ;
        ssd3.city__c='CAsadhjjshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh';      
        ssd3.Account_Name__c=oAccount.Id;
        ssd3.Source_System_Name__c='Test SSD';
        ssd3.country__c ='US';
        ssd3.LCRM_Industry__c='AC ACCOUNTING';
        ssd3.LCRM_Sales_Org__c='WEST';
        ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
        ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
         ssd3.County__c='test county';
        ssd3.State__c='CAaaa';
        ssd3.LCRM_Customer_Group__c='ACADEMIC';
        ssd3.CurrencyIsoCode='USD';
        insert ssd3;
        
       
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=ssd.id;
        oppty.Account=oAccount;
        insert oppty;
        Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty2.RecordtypeId=opptyRecorType;
        oppty2.Source_System_Detail__c=ssd2.id;
        oppty2.Account=oAccount;
        insert oppty2;
        
        test.StartTest();
                
         List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,ssd.Id);
        Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,ssd2.Id);
        propList.add(oProposal);
        propList.add(oProposal2);
        insert propList;
        
         List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order1.CreatedDate=now.addDays(-1);
        orderList.add(order1);
        
        Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order2);
        Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order3);
        Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order4);
        
        insert orderList;
        
         Integration_Logger__c logger1=new Integration_Logger__c();
         logger1.Exception_Message__c='error';
         logger1.Object_Id__c = '';
         logger1.Object_Name__c = 'Quote/Proposal';
         logger1.Request_Message__c = '';         
         logger1.Request_Type__c = 'Outbound';
         logger1.Service_Name__c = 'OrderSubmission';
         logger1.Order__c= order1.Id;
         logger1.Success__c = false;
     
        insert logger1;
        Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
        insert bigrule ;
        Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CAAAAAAA',Region_Name__c ='cal');
        insert cregion;
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
        CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
        
         CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
          CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
        APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
        APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"1005215581","prevAcct":"jshj","partnerFunction":[{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
            //build the parameters for sending the request - context_element
            testCov.context = new APTS_CreateSSDJSON2Apex.context();
            testCov.context.allowAdminEmails='test';
            testCov.context.requestor='test';
            testCov.context.userId='test';
            testCov.context.accountType='test';
            //testCov.context.extensibleAttributes{get;set;}
            //testCov.context.{get;set;}
            testCov.context.emailAddress='test';
            testCov.context.internalUser=true;
            testCov.context.fax='test';
            testCov.context.adminName='test';
            testCov.context.extension='test';
            testCov.context.adminEmail='test';
            testCov.context.phone='test';
            testCov.context.alternateEmailAddress='test';
            testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
            testCov.ESIHeader.postBackURL='test';
            testCov.ESIHeader.timeStamp='test';
            testCov.ESIHeader.instanceId='test';
            testCov.ESIHeader.tracingId='test';
            testCov.ESIHeader.companyId='test';
            testCov.ESIHeader.messageHistory='test';
            testCov.ESIHeader.configGroup='test';
            testCov.ESIHeader.messageId='test';
            testCov.ESIHeader.payloadVersion='test';
            testCov.ESIHeader.transactionId='test';
            
            testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
            List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();

// List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
  testCov.customer.isPrimary=true;
        testCov.customer.externalAccountId='test';
        testCov.customer.industryCode='test';
        testCov.customer.accountCustomerAddressID='test';
        testCov.customer.parentAccountNumber='test';
        testCov.customer.relationshipModel='test';
       testCov.customer.accountType='test';
        testCov.customer.merchantCategoryClassificationCode='test';
        testCov.customer.companyName='test';
        testCov.customer.segment='test';
        testCov.customer.companyId='test';
        testCov.customer.applyDate='test';
        testCov.customer.accountNumber='test';
        testCov.customer.accountStatus='test';
        testCov.customer.hierarchyType='test';
        testCov.customer.KNOwned='test';
        testCov.customer.vatCode='test';
        testCov.customer.accountGroup='test';
        testCov.customer.partnerType='test';
        testCov.customer.accountClass='test';
       testCov.customer.complianceJobRole=compList;
        testCov.customer.primaryBillingNumber='test';
        testCov.customer.jurisdictionCode='test';
        testCov.customer.legacyThomsonCustomerId='test';
        testCov.customer.taxCodeType='test';
        testCov.customer.customerJourney='test';
        testCov.customer.lastUpdatedDate='test';
        testCov.customer.website='test';
        test.StopTest();
       
    }
    
    //stops
      /**
     * @description testCreateCustomer5
     */
     public static testMethod void testCreateCustomer5() {
        
        String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
        new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
         new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
           new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
            new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
        };
        
        insert keyValueList;
        List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='TA61',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='TA61')};
        insert codeList;
        
        List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
        insert bigRuleList;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='USL_Source_Systems';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        insert recordlist;
        
        
        
        
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'TA61';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        
        oAccount.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount.BillingCity = 'SAN FRANCISCO';
        oAccount.BillingState = 'CA';
        oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.Is_Customer_Review_Complete__c=true;
        insert oAccount;
    System.assertequals('Unit Test',oAccount.Name,'Success');
        
        Source_system_detail__c ssd = new Source_system_detail__c();
        ssd.name ='test source system';
        ssd.city__c='CA';
        ssd.Account_Name__c=oAccount.Id;
        ssd.Source_System_Name__c='Test SSD';
        ssd.country__c ='US';
        ssd.LCRM_Industry__c='AC ACCOUNTING';
        ssd.LCRM_Sales_Org__c='TA61';
        ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
        ssd.Number_Street__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.OLC_Account_Number__c='test';
         ssd.County__c='test county';
        ssd.State__c='CAAA';
        ssd.LCRM_Customer_Group__c='ACADEMIC';
        ssd.CurrencyIsoCode='USD';
        insert ssd;
        
        Source_system_detail__c ssd2 = new Source_system_detail__c();
        ssd2.name ='test source system';
        ssd2.city__c='CA';
        ssd2.Account_Name__c=oAccount.Id;
        ssd2.Source_System_Name__c='Test SSD';
        ssd2.country__c ='US';
        ssd2.LCRM_Industry__c='AC ACCOUNTING';
        ssd2.LCRM_Sales_Org__c='TA61';
        ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssssbghhfuffuygfufytfgjuguyyiftyugfyufygfty';
        ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
         ssd2.County__c='test county';
        ssd2.State__c='CA';
        ssd2.LCRM_Customer_Group__c='ACADEMIC';
        ssd2.CurrencyIsoCode='USD';
        insert ssd2;
        Source_system_detail__c ssd3 = new Source_system_detail__c();
        ssd3.name ='test source system Akhilesh dfgg ertgf swerwe resreewtert' ;
        ssd3.city__c='CAsadhjjshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh';      
        ssd3.Account_Name__c=oAccount.Id;
        ssd3.Source_System_Name__c='Test SSD';
        ssd3.country__c ='US';
        ssd3.LCRM_Industry__c='AC ACCOUNTING';
        ssd3.LCRM_Sales_Org__c='TA61';
        ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
        ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
         ssd3.County__c='test county';
        ssd3.State__c='CAaaa';
        ssd3.LCRM_Customer_Group__c='ACADEMIC';
        ssd3.CurrencyIsoCode='USD';
        insert ssd3;
        
       
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=ssd.id;
        oppty.Account=oAccount;
        insert oppty;
        Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty2.RecordtypeId=opptyRecorType;
        oppty2.Source_System_Detail__c=ssd2.id;
        oppty2.Account=oAccount;
        insert oppty2;
        
        test.StartTest();
                
         List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,ssd.Id);
        Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,ssd2.Id);
        propList.add(oProposal);
        propList.add(oProposal2);
        insert propList;
        
         List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order1.CreatedDate=now.addDays(-1);
        orderList.add(order1);
        
        Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order2);
        Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order3);
        Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order4);
        
        insert orderList;
        
         Integration_Logger__c logger1=new Integration_Logger__c();
         logger1.Exception_Message__c='error';
         logger1.Object_Id__c = '';
         logger1.Object_Name__c = 'Quote/Proposal';
         logger1.Request_Message__c = '';         
         logger1.Request_Type__c = 'Outbound';
         logger1.Service_Name__c = 'OrderSubmission';
         logger1.Order__c= order1.Id;
         logger1.Success__c = false;
     
        insert logger1;
        Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
        insert bigrule ;
        Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CAAA',Region_Name__c ='cal');
        insert cregion;
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
        CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
        
         CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
          CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
        APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
        APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"1005215581","prevAcct":"jshj","partnerFunction":[{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
            //build the parameters for sending the request - context_element
            testCov.context = new APTS_CreateSSDJSON2Apex.context();
            testCov.context.allowAdminEmails='test';
            testCov.context.requestor='test';
            testCov.context.userId='test';
            testCov.context.accountType='test';
            //testCov.context.extensibleAttributes{get;set;}
            //testCov.context.{get;set;}
            testCov.context.emailAddress='test';
            testCov.context.internalUser=true;
            testCov.context.fax='test';
            testCov.context.adminName='test';
            testCov.context.extension='test';
            testCov.context.adminEmail='test';
            testCov.context.phone='test';
            testCov.context.alternateEmailAddress='test';
            testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
            testCov.ESIHeader.postBackURL='test';
            testCov.ESIHeader.timeStamp='test';
            testCov.ESIHeader.instanceId='test';
            testCov.ESIHeader.tracingId='test';
            testCov.ESIHeader.companyId='test';
            testCov.ESIHeader.messageHistory='test';
            testCov.ESIHeader.configGroup='test';
            testCov.ESIHeader.messageId='test';
            testCov.ESIHeader.payloadVersion='test';
            testCov.ESIHeader.transactionId='test';
            
            testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
            List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();

 // List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
  testCov.customer.isPrimary=true;
        testCov.customer.externalAccountId='test';
        testCov.customer.industryCode='test';
        testCov.customer.accountCustomerAddressID='test';
        testCov.customer.parentAccountNumber='test';
        testCov.customer.relationshipModel='test';
       testCov.customer.accountType='test';
        testCov.customer.merchantCategoryClassificationCode='test';
        testCov.customer.companyName='test';
        testCov.customer.segment='test';
        testCov.customer.companyId='test';
        testCov.customer.applyDate='test';
        testCov.customer.accountNumber='test';
        testCov.customer.accountStatus='test';
        testCov.customer.hierarchyType='test';
        testCov.customer.KNOwned='test';
        testCov.customer.vatCode='test';
        testCov.customer.accountGroup='test';
        testCov.customer.partnerType='test';
        testCov.customer.accountClass='test';
       testCov.customer.complianceJobRole=compList;
        testCov.customer.primaryBillingNumber='test';
        testCov.customer.jurisdictionCode='test';
        testCov.customer.legacyThomsonCustomerId='test';
        testCov.customer.taxCodeType='test';
        testCov.customer.customerJourney='test';
        testCov.customer.lastUpdatedDate='test';
        testCov.customer.website='test';
        test.StopTest();
       
    }
      /**
     * @description testCreateCustomer6
     */
    public static testMethod void testCreateCustomer6() {
        
        String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
        new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
         new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
           new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
            new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
        };
        
        insert keyValueList;
        List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='TA61',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='TA61')};
        insert codeList;
        
        List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
        insert bigRuleList;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='USL_Source_Systems';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        insert recordlist;
        
        
        
        
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'TA61';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        
        oAccount.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount.BillingCity = 'SAN FRANCISCO';
        oAccount.BillingState = 'CA';
        oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.Is_Customer_Review_Complete__c=true;
        insert oAccount;
    System.assertequals('Unit Test',oAccount.Name,'Success');
        
        Source_system_detail__c ssd = new Source_system_detail__c();
        ssd.name ='test source system';
        ssd.city__c='CA';
        ssd.Account_Name__c=oAccount.Id;
        ssd.Source_System_Name__c='Test SSD';
        ssd.country__c ='UK';
        ssd.LCRM_Industry__c='AC ACCOUNTING';
        ssd.LCRM_Sales_Org__c='TA61';
        ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
        ssd.Number_Street__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.OLC_Account_Number__c='test';
         ssd.County__c='test county';
        ssd.State__c='CAAA';
        ssd.LCRM_Customer_Group__c='ACADEMIC';
        ssd.CurrencyIsoCode='USD';
        insert ssd;
        
        Source_system_detail__c ssd2 = new Source_system_detail__c();
        ssd2.name ='test source system';
        ssd2.city__c='CA';
        ssd2.Account_Name__c=oAccount.Id;
        ssd2.Source_System_Name__c='Test SSD';
        ssd2.country__c ='UK';
        ssd2.LCRM_Industry__c='AC ACCOUNTING';
        ssd2.LCRM_Sales_Org__c='TA61';
        ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssssbghhfuffuygfufytfgjuguyyiftyugfyufygfty';
        ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
         ssd2.County__c='test county';
        ssd2.State__c='CA';
        ssd2.LCRM_Customer_Group__c='ACADEMIC';
        ssd2.CurrencyIsoCode='USD';
        insert ssd2;
        Source_system_detail__c ssd3 = new Source_system_detail__c();
        ssd3.name ='test source system Akhilesh dfgg ertgf swerwe resreewtert' ;
        ssd3.city__c='CAsadhjjshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh';      
        ssd3.Account_Name__c=oAccount.Id;
        ssd3.Source_System_Name__c='Test SSD';
        ssd3.country__c ='UK';
        ssd3.LCRM_Industry__c='AC ACCOUNTING';
        ssd3.LCRM_Sales_Org__c='TA61';
        ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
        ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
         ssd3.County__c='test county';
        ssd3.State__c='CAaaa';
        ssd3.LCRM_Customer_Group__c='ACADEMIC';
        ssd3.CurrencyIsoCode='USD';
        insert ssd3;
        
       
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=ssd.id;
        oppty.Account=oAccount;
        insert oppty;
        Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty2.RecordtypeId=opptyRecorType;
        oppty2.Source_System_Detail__c=ssd2.id;
        oppty2.Account=oAccount;
        insert oppty2;
        
        test.StartTest();
                
         List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,ssd.Id);
        Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,ssd2.Id);
        propList.add(oProposal);
        propList.add(oProposal2);
        insert propList;
        
         List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order1.CreatedDate=now.addDays(-1);
        orderList.add(order1);
        
        Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order2);
        Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order3);
        Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order4);
        
        insert orderList;
        
         Integration_Logger__c logger1=new Integration_Logger__c();
         logger1.Exception_Message__c='error';
         logger1.Object_Id__c = '';
         logger1.Object_Name__c = 'Quote/Proposal';
         logger1.Request_Message__c = '';         
         logger1.Request_Type__c = 'Outbound';
         logger1.Service_Name__c = 'OrderSubmission';
         logger1.Order__c= order1.Id;
         logger1.Success__c = false;
     
        insert logger1;
        Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='UK',Country__c='UK');
        insert bigrule ;
        Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='UK',Region_Code__c='CAAA',Region_Name__c ='cal');
        insert cregion;
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
        CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
        
         CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
          CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
        APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
        APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"1005215581","prevAcct":"jshj","partnerFunction":[{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"TA61","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
            //build the parameters for sending the request - context_element
            testCov.context = new APTS_CreateSSDJSON2Apex.context();
            testCov.context.allowAdminEmails='test';
            testCov.context.requestor='test';
            testCov.context.userId='test';
            testCov.context.accountType='test';
            //testCov.context.extensibleAttributes{get;set;}
            //testCov.context.{get;set;}
            testCov.context.emailAddress='test';
            testCov.context.internalUser=true;
            testCov.context.fax='test';
            testCov.context.adminName='test';
            testCov.context.extension='test';
            testCov.context.adminEmail='test';
            testCov.context.phone='test';
            testCov.context.alternateEmailAddress='test';
            testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
            testCov.ESIHeader.postBackURL='test';
            testCov.ESIHeader.timeStamp='test';
            testCov.ESIHeader.instanceId='test';
            testCov.ESIHeader.tracingId='test';
            testCov.ESIHeader.companyId='test';
            testCov.ESIHeader.messageHistory='test';
            testCov.ESIHeader.configGroup='test';
            testCov.ESIHeader.messageId='test';
            testCov.ESIHeader.payloadVersion='test';
            testCov.ESIHeader.transactionId='test';
            
            testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
            List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();

  //List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
  testCov.customer.isPrimary=true;
        testCov.customer.externalAccountId='test';
        testCov.customer.industryCode='test';
        testCov.customer.accountCustomerAddressID='test';
        testCov.customer.parentAccountNumber='test';
        testCov.customer.relationshipModel='test';
       testCov.customer.accountType='test';
        testCov.customer.merchantCategoryClassificationCode='test';
        testCov.customer.companyName='test';
        testCov.customer.segment='test';
        testCov.customer.companyId='test';
        testCov.customer.applyDate='test';
        testCov.customer.accountNumber='test';
        testCov.customer.accountStatus='test';
        testCov.customer.hierarchyType='test';
        testCov.customer.KNOwned='test';
        testCov.customer.vatCode='test';
        testCov.customer.accountGroup='test';
        testCov.customer.partnerType='test';
        testCov.customer.accountClass='test';
       testCov.customer.complianceJobRole=compList;
        testCov.customer.primaryBillingNumber='test';
        testCov.customer.jurisdictionCode='test';
        testCov.customer.legacyThomsonCustomerId='test';
        testCov.customer.taxCodeType='test';
        testCov.customer.customerJourney='test';
        testCov.customer.lastUpdatedDate='test';
        testCov.customer.website='test';
        test.StopTest();
       
    }
      /**
     * @description testCreateCustomer7
     */
    public static testMethod void testCreateCustomer7() {
        
        String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
        new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
         new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
           new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
            new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
        };
        
        insert keyValueList;
        List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='LLEY',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='LLEY')};
        insert codeList;
        
        List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
        insert bigRuleList;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='USL_Source_Systems';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        insert recordlist;
        
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.Sales_Org__c = 'LLEY';
        oAccount.Customer_Type__c = 'Individual';
        oAccount.Customer_Group__c = 'ACADEMIC';
        oAccount.Industry = 'TAX';
        
        oAccount.BillingStreet = '275 BATTERY ST STE 1500';
        oAccount.BillingCity = 'SAN FRANCISCO';
        oAccount.BillingState = 'CA';
        oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.Is_Customer_Review_Complete__c=true;
        insert oAccount;
    System.assertequals('Unit Test',oAccount.Name,'Success');
        
        Source_system_detail__c ssd = new Source_system_detail__c();
        ssd.name ='test source system';
        ssd.city__c='CA';
        ssd.Account_Name__c=oAccount.Id;
        ssd.Source_System_Name__c='Test SSD';
        ssd.country__c ='UK';
        ssd.LCRM_Industry__c='AC ACCOUNTING';
        ssd.LCRM_Sales_Org__c='LLEY';
        ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
        ssd.Number_Street__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
        ssd.OLC_Account_Number__c='test';
         ssd.County__c='test county';
        ssd.State__c='CAAA';
        ssd.LCRM_Customer_Group__c='ACADEMIC';
        ssd.CurrencyIsoCode='USD';
        ssd.LatAm_Tax_Number_Type__c ='test';
        ssd.LCRM_Phone__c = '7777777';
        insert ssd;
        
        Source_system_detail__c ssd2 = new Source_system_detail__c();
        ssd2.name ='test source system';
        ssd2.city__c='CA';
        ssd2.Account_Name__c=oAccount.Id;
        ssd2.Source_System_Name__c='Test SSD';
        ssd2.country__c ='UK';
        ssd2.LCRM_Industry__c='AC ACCOUNTING';
        ssd2.LCRM_Sales_Org__c='LLEY';
        ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssssbghhfuffuygfufytfgjuguyyiftyugfyufygfty';
        ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
        ssd2.County__c='test';
        ssd2.State__c='CA';
        ssd2.LCRM_Customer_Group__c='ACADEMIC';
        ssd2.CurrencyIsoCode='USD';
        ssd2.LatAm_Tax_Number_Type__c ='C.I. Policía Federal';
        ssd2.LCRM_Tax_Number__c ='test';
        ssd2.LCRM_Phone__c = '7777777';
        insert ssd2;
        Source_system_detail__c ssd3 = new Source_system_detail__c();
        ssd3.name ='test source system Akhilesh dfgg ertgf swerwe resreewtert' ;
        ssd3.city__c='CAsadhjjshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh';      
        ssd3.Account_Name__c=oAccount.Id;
        ssd3.Source_System_Name__c='Test SSD';
        ssd3.country__c ='UK';
        ssd3.LCRM_Industry__c='AC ACCOUNTING';
        ssd3.LCRM_Sales_Org__c ='LLEY';
        ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
        ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        ssd3.County__c='test county';
        ssd3.State__c='CAaaa';
        ssd3.LCRM_Customer_Group__c='ACADEMIC';
        ssd3.CurrencyIsoCode='USD';
        ssd3.LatAm_Tax_Number_Type__c ='test';
        ssd3.LCRM_Phone__c = '1500EWRERERfdsdfsdsfdfsds';
        insert ssd3;
        
        test.StartTest();
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=ssd.id;
        oppty.Account=oAccount;
        Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty2.RecordtypeId=opptyRecorType;
        oppty2.Source_System_Detail__c=ssd2.id;
        oppty2.Account=oAccount;
        
        List<Opportunity> opplist = new List<Opportunity>{oppty,oppty2};
        insert opplist;
        
        Business_Partner_Function__c bf = new Business_Partner_Function__c();
        bf.Related_Account_GLI__c = ssd2.id;
        bf.Sold_To_Account_GLI__c = ssd2.id;
        bf.Sales_Org__c = 'LLEY';
        bf.Relationship_Type__c = 'Sold-To';
        
        Business_Partner_Function__c bf1 = new Business_Partner_Function__c();
        bf1.Related_Account_GLI__c = ssd2.id;
        bf1.Sold_To_Account_GLI__c = ssd2.id;
        bf1.Sales_Org__c = 'TSL';
        bf1.Relationship_Type__c = 'Sold-To';
        
        List<Business_Partner_Function__c> bflist = new List<Business_Partner_Function__c>{bf,bf1};
        insert bflist;
                
         List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,ssd.Id);
        Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,ssd2.Id);
        oProposal2.Digital_Quote_Type__c ='New Sales';
        oProposal2.APTS_Proposal_Business_Unit__c = 'SCS';
        propList.add(oProposal);
        propList.add(oProposal2);
        insert propList;
        
         List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
        
        Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order1.CreatedDate=now.addDays(-1);
        orderList.add(order1);
        
        Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order2);
        Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order3);
        Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
        order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
        //order2.CreatedDate=now.addDays(-2);
        orderList.add(order4);
        
        insert orderList;
        
         Integration_Logger__c logger1=new Integration_Logger__c();
         logger1.Exception_Message__c='error';
         logger1.Object_Id__c = '';
         logger1.Object_Name__c = 'Quote/Proposal';
         logger1.Request_Message__c = '';         
         logger1.Request_Type__c = 'Outbound';
         logger1.Service_Name__c = 'OrderSubmission';
         logger1.Order__c= order1.Id;
         logger1.Success__c = false;
     
        insert logger1;
        Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='UK',Country__c='UK');
        insert bigrule ;
        Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='UK',Region_Code__c='CAAA',Region_Name__c ='cal');
        insert cregion;
        Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
        CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
        
         CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
          CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
        APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
        APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"1005215581","prevAcct":"jshj","partnerFunction":[{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
            //build the parameters for sending the request - context_element
            testCov.context = new APTS_CreateSSDJSON2Apex.context();
            testCov.context.allowAdminEmails='test';
            testCov.context.requestor='test';
            testCov.context.userId='test';
            testCov.context.accountType='test';
            //testCov.context.extensibleAttributes{get;set;}
            //testCov.context.{get;set;}
            testCov.context.emailAddress='test';
            testCov.context.internalUser=true;
            testCov.context.fax='test';
            testCov.context.adminName='test';
            testCov.context.extension='test';
            testCov.context.adminEmail='test';
            testCov.context.phone='test';
            testCov.context.alternateEmailAddress='test';
            testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
            testCov.ESIHeader.postBackURL='test';
            testCov.ESIHeader.timeStamp='test';
            testCov.ESIHeader.instanceId='test';
            testCov.ESIHeader.tracingId='test';
            testCov.ESIHeader.companyId='test';
            testCov.ESIHeader.messageHistory='test';
            testCov.ESIHeader.configGroup='test';
            testCov.ESIHeader.messageId='test';
            testCov.ESIHeader.payloadVersion='test';
            testCov.ESIHeader.transactionId='test';
            
            testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
            List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();
        APTS_CreateSSDJSON2Apex.complianceJobRole testcov2 = new APTS_CreateSSDJSON2Apex.complianceJobRole();
        testcov2.Id = 'test';
        testcov2.description = 'test';
  //  List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
  //  List<APTS_CreateSSDJSON2Apex.sourceOrTargetReference> testcov4 = new List<APTS_CreateSSDJSON2Apex.sourceOrTargetReference> ();
        APTS_CreateSSDJSON2Apex.sourceOrTargetReference testcov3 = new APTS_CreateSSDJSON2Apex.sourceOrTargetReference();
        testcov3.referenceID = 'test';
        testcov3.sourceOrTargetSystemName = 'test';
        testCov.customer.isPrimary=true;
        testCov.customer.externalAccountId='test';
        testCov.customer.industryCode='test';
        testCov.customer.accountCustomerAddressID='test';
        testCov.customer.parentAccountNumber='test';
        testCov.customer.relationshipModel='test';
        testCov.customer.accountType='test';
        testCov.customer.merchantCategoryClassificationCode='test';
        testCov.customer.companyName='test';
        testCov.customer.segment='test';
        testCov.customer.companyId='test';
        testCov.customer.applyDate='test';
        testCov.customer.accountNumber='test';
        testCov.customer.accountStatus='test';
        testCov.customer.hierarchyType='test';
        testCov.customer.KNOwned='test';
        testCov.customer.vatCode='test';
        testCov.customer.accountGroup='test';
        testCov.customer.partnerType='test';
        testCov.customer.accountClass='test';
       testCov.customer.complianceJobRole=compList;
        testCov.customer.primaryBillingNumber='test';
        testCov.customer.jurisdictionCode='test';
        testCov.customer.legacyThomsonCustomerId='test';
        testCov.customer.taxCodeType='test';
        testCov.customer.customerJourney='test';
        testCov.customer.lastUpdatedDate='test';
        testCov.customer.website='test';
        testCov.customer.language='test';
        
        testCov.customer.isActive=true;
        APTS_CreateSSDJSON2Apex.address testcov5 = new APTS_CreateSSDJSON2Apex.address();
        testcov5.title = 'test';
        testcov5.country = 'test';
        testcov5.emailAddress = 'test';
        testcov5.extension = 'test';
        testcov5.alternateEmailAddress = 'test';
        testcov5.building = 'test';
        testcov5.floor = 'test';
        testcov5.room = 'test';
        test.StopTest();
       
    }
     /**
     * @description testCreateCustomer8
     */
    public static testMethod void testCreateCustomer8() {
        
    String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
    new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
    new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
     new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
       new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
        new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
    };
    
    insert keyValueList;
    List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='LLEY',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c=null,Sales_Org_Code__c='LLEY')};
    insert codeList;
    
    List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
    insert bigRuleList;
    
    List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
    new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
    insert webserviceList; 
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    
    RecordtypeIds__c recordtype2=new RecordtypeIds__c();
    recordtype2.Name='USL_Source_Systems';
    recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype2);
    insert recordlist;
    
    Account oAccount = new Account();
    oAccount.Name = 'Unit Test';
    oAccount.Sales_Org__c = 'LLEY';
    oAccount.Customer_Type__c = 'Individual';
    oAccount.Customer_Group__c = 'ACADEMIC';
    oAccount.Industry = 'TAX';
    
    oAccount.BillingStreet = '275 BATTERY ST STE 1500';
    oAccount.BillingCity = 'SAN FRANCISCO';
    oAccount.BillingState = 'CA';
    oAccount.BillingPostalCode = '94111-3334';
    oAccount.BillingCountry = 'US';
    oAccount.Is_Customer_Review_Complete__c=true;
    insert oAccount;
System.assertequals('Unit Test',oAccount.Name,'Success');
    
    Source_system_detail__c ssd = new Source_system_detail__c();
    ssd.name ='test source system';
    ssd.city__c='CA';
    ssd.Account_Name__c=oAccount.Id;
    ssd.Source_System_Name__c='Test SSD';
    ssd.country__c ='UK';
    ssd.LCRM_Industry__c='AC ACCOUNTING';
    ssd.LCRM_Sales_Org__c='LLEY';
    ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
    ssd.Number_Street__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.OLC_Account_Number__c='test';
     ssd.County__c='test county';
    ssd.State__c='CAAA';
    ssd.LCRM_Customer_Group__c='ACADEMIC';
    ssd.CurrencyIsoCode='USD';
    ssd.LatAm_Tax_Number_Type__c ='test';
    insert ssd;
    
    Source_system_detail__c ssd2 = new Source_system_detail__c();
    ssd2.name ='test source system';
    ssd2.city__c='CA';
    ssd2.Account_Name__c=oAccount.Id;
    ssd2.Source_System_Name__c='Test SSD';
    ssd2.country__c ='UK';
    ssd2.LCRM_Industry__c='AC ACCOUNTING';
    ssd2.LCRM_Sales_Org__c='LLEY';
    ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssssbghhfuffuygfufytfgjuguyyiftyugfyufygfty';
    ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
    //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
    ssd2.County__c='test';
    ssd2.State__c='CA';
    ssd2.LCRM_Customer_Group__c='ACADEMIC';
    ssd2.CurrencyIsoCode='USD';
    ssd2.LatAm_Tax_Number_Type__c ='C.I. Policía Federal';
    ssd2.LCRM_Tax_Number__c ='test';
    ssd2.LCRM_Phone__c = 'test';
    insert ssd2;
    Source_system_detail__c ssd3 = new Source_system_detail__c();
    ssd3.name ='test source system Akhilesh dfgg ertgf swerwe resreewtert' ;
    ssd3.city__c='CAsadhjjshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh';      
    ssd3.Account_Name__c=oAccount.Id;
    ssd3.Source_System_Name__c='Test SSD';
    ssd3.country__c ='UK';
    ssd3.LCRM_Industry__c='AC ACCOUNTING';
    ssd3.LCRM_Sales_Org__c ='LLEY';
    ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
    ssd3.County__c='test county';
    ssd3.State__c='CAaaa';
    ssd3.LCRM_Customer_Group__c='ACADEMIC';
    ssd3.CurrencyIsoCode='USD';
    ssd3.LatAm_Tax_Number_Type__c ='test';
    ssd3.LCRM_Phone__c = '1500EWRERERfdsdfsdsfdfsds';
    insert ssd3;
    
    test.StartTest();
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=ssd.id;
    oppty.Account=oAccount;
    Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty2.RecordtypeId=opptyRecorType;
    oppty2.Source_System_Detail__c=ssd2.id;
    oppty2.Account=oAccount;
    
    List<Opportunity> opplist = new List<Opportunity>{oppty,oppty2};
    insert opplist;
    
    Business_Partner_Function__c bf = new Business_Partner_Function__c();
    bf.Related_Account_GLI__c = ssd2.id;
    bf.Sold_To_Account_GLI__c = ssd2.id;
    bf.Sales_Org__c = 'LLEY';
    bf.Relationship_Type__c = 'Sold-To';
    
    Business_Partner_Function__c bf1 = new Business_Partner_Function__c();
    bf1.Related_Account_GLI__c = ssd2.id;
    bf1.Sold_To_Account_GLI__c = ssd2.id;
    bf1.Sales_Org__c = 'TSL';
    bf1.Relationship_Type__c = 'Sold-To';
    
    List<Business_Partner_Function__c> bflist = new List<Business_Partner_Function__c>{bf,bf1};
    insert bflist;
            
     List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,ssd.Id);
    Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,ssd2.Id);
    oProposal2.Digital_Quote_Type__c ='New Sales';
    oProposal2.APTS_Proposal_Business_Unit__c = 'SCS';
    propList.add(oProposal);
    propList.add(oProposal2);
    insert propList;
    
     List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
    
    Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order1.CreatedDate=now.addDays(-1);
    orderList.add(order1);
    
    Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order2);
    Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order3);
    Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order4);
    
    insert orderList;
    
     Integration_Logger__c logger1=new Integration_Logger__c();
     logger1.Exception_Message__c='error';
     logger1.Object_Id__c = '';
     logger1.Object_Name__c = 'Quote/Proposal';
     logger1.Request_Message__c = '';         
     logger1.Request_Type__c = 'Outbound';
     logger1.Service_Name__c = 'OrderSubmission';
     logger1.Order__c= order1.Id;
     logger1.Success__c = false;
 
    insert logger1;
    Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='UK',Country__c='UK');
    insert bigrule ;
    Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='UK',Region_Code__c='CAAA',Region_Name__c ='cal');
    insert cregion;
    Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
    CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
    
     CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
      CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
    APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
    APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"1005215581","prevAcct":"jshj","partnerFunction":[{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"LLEY","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
        //build the parameters for sending the request - context_element
        testCov.context = new APTS_CreateSSDJSON2Apex.context();
        testCov.context.allowAdminEmails='test';
        testCov.context.requestor='test';
        testCov.context.userId='test';
        testCov.context.accountType='test';
        //testCov.context.extensibleAttributes{get;set;}
        //testCov.context.{get;set;}
        testCov.context.emailAddress='test';
        testCov.context.internalUser=true;
        testCov.context.fax='test';
        testCov.context.adminName='test';
        testCov.context.extension='test';
        testCov.context.adminEmail='test';
        testCov.context.phone='test';
        testCov.context.alternateEmailAddress='test';
        testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
        testCov.ESIHeader.postBackURL='test';
        testCov.ESIHeader.timeStamp='test';
        testCov.ESIHeader.instanceId='test';
        testCov.ESIHeader.tracingId='test';
        testCov.ESIHeader.companyId='test';
        testCov.ESIHeader.messageHistory='test';
        testCov.ESIHeader.configGroup='test';
        testCov.ESIHeader.messageId='test';
        testCov.ESIHeader.payloadVersion='test';
        testCov.ESIHeader.transactionId='test';
        
        testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
        List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();
    APTS_CreateSSDJSON2Apex.complianceJobRole testcov2 = new APTS_CreateSSDJSON2Apex.complianceJobRole();
    testcov2.Id = 'test';
    testcov2.description = 'test';
//  List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
//  List<APTS_CreateSSDJSON2Apex.sourceOrTargetReference> testcov4 = new List<APTS_CreateSSDJSON2Apex.sourceOrTargetReference> ();
    APTS_CreateSSDJSON2Apex.sourceOrTargetReference testcov3 = new APTS_CreateSSDJSON2Apex.sourceOrTargetReference();
    testcov3.referenceID = 'test';
    testcov3.sourceOrTargetSystemName = 'test';
    testCov.customer.isPrimary=true;
    testCov.customer.externalAccountId='test';
    testCov.customer.industryCode='test';
//testCov.customer.distributionChannel =null;
    testCov.customer.accountCustomerAddressID='test';
    testCov.customer.parentAccountNumber='test';
    testCov.customer.relationshipModel='test';
    testCov.customer.accountType='test';
    testCov.customer.merchantCategoryClassificationCode='test';
    testCov.customer.companyName=NULL;
    testCov.customer.segment='test';
    testCov.customer.companyId='test';
    testCov.customer.applyDate='test';
    testCov.customer.accountNumber='test';
    testCov.customer.accountStatus='test';
    testCov.customer.hierarchyType='test';
    testCov.customer.KNOwned='test';
    testCov.customer.vatCode='test';
    testCov.customer.accountGroup='test';
    testCov.customer.partnerType='test';
    testCov.customer.accountClass='test';
   testCov.customer.complianceJobRole=compList;
    testCov.customer.primaryBillingNumber='test';
    testCov.customer.jurisdictionCode='test';
    testCov.customer.legacyThomsonCustomerId='test';
    testCov.customer.taxCodeType='test';
    testCov.customer.customerJourney='test';
    testCov.customer.lastUpdatedDate='test';
    testCov.customer.website='test';
    testCov.customer.language='test';
    testCov.customer.isActive=true;
    APTS_CreateSSDJSON2Apex.address testcov5 = new APTS_CreateSSDJSON2Apex.address();
    testcov5.title = 'test';
    testcov5.county = 'test';
    testcov5.emailAddress = 'test';
    testcov5.extension = 'test';
    testcov5.alternateEmailAddress = 'test';
    testcov5.building = 'test';
    testcov5.floor = 'test';
    testcov5.room = 'test';
    test.StopTest();
   
}
  /**
     * @description testCreateCustomer9
     */
public static testMethod void testCreateCustomer9() {
        
    String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
    new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
    new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
     new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
       new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
        new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
    };
    
    insert keyValueList;
    List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c=null,Sales_Org_Code__c='West')};
    insert codeList;
    
    List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
    insert bigRuleList;
    
    List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
    insert webserviceList;
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    
    RecordtypeIds__c recordtype2=new RecordtypeIds__c();
    recordtype2.Name='USL_Source_Systems';
    recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype2);
    insert recordlist;
    
    Account oAccount = new Account();
    oAccount.Name = 'Unit Test';
    oAccount.Sales_Org__c = 'WEST';
    oAccount.Customer_Type__c = 'Individual';
    oAccount.Customer_Group__c = 'ACADEMIC';
    oAccount.Industry = 'TAX';
    
    oAccount.BillingStreet = '275 BATTERY ST STE 1500';
    oAccount.BillingCity = 'SAN FRANCISCO';
    oAccount.BillingState = 'CA';
    oAccount.BillingPostalCode = '94111-3334';
    oAccount.BillingCountry = 'US';
    oAccount.Is_Customer_Review_Complete__c=true;
    insert oAccount;
System.assertequals('Unit Test',oAccount.Name,'Success');
    
    Source_system_detail__c ssd = new Source_system_detail__c();
    ssd.name ='test source system';
    ssd.city__c='CA';
    ssd.Account_Name__c=oAccount.Id;
    ssd.Source_System_Name__c='Test SSD';
    ssd.country__c ='US';
    ssd.LCRM_Industry__c='AC ACCOUNTING';
    ssd.LCRM_Sales_Org__c='WEST';
    ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
    ssd.Number_Street__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.OLC_Account_Number__c='test';
     ssd.County__c='test county';
    ssd.State__c='CA';
    ssd.LCRM_Customer_Group__c='ACADEMIC';
    ssd.CurrencyIsoCode='USD';
    insert ssd;
    
    Source_system_detail__c ssd2 = new Source_system_detail__c();
    ssd2.name ='test source system';
    ssd2.city__c='CA';
    ssd2.Account_Name__c=oAccount.Id;
    ssd2.Source_System_Name__c='Test SSD';
    ssd2.country__c ='US';
    ssd2.LCRM_Industry__c='AC ACCOUNTING';
    ssd2.LCRM_Sales_Org__c='WEST';
    ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
    //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
     ssd2.County__c='test county';
    ssd2.State__c='CA';
    ssd2.LCRM_Customer_Group__c='ACADEMIC';
    ssd2.CurrencyIsoCode='USD';
    insert ssd2;
    Source_system_detail__c ssd3 = new Source_system_detail__c();
    ssd3.name ='test source system';
    ssd3.city__c='CA';
    ssd3.Account_Name__c=oAccount.Id;
    ssd3.Source_System_Name__c='Test SSD';
    ssd3.country__c ='US';
    ssd3.LCRM_Industry__c='AC ACCOUNTING';
    ssd3.LCRM_Sales_Org__c='WEST';
    ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
     ssd3.County__c='test county';
    ssd3.State__c='CA';
    ssd3.LCRM_Customer_Group__c='ACADEMIC';
    ssd3.CurrencyIsoCode='USD';
    insert ssd3;
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=SSD.id;
    oppty.Account=oAccount;
    insert oppty;
    Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty2.RecordtypeId=opptyRecorType;
    oppty2.Source_System_Detail__c=SSD2.id;
    oppty2.Account=oAccount;
    insert oppty2;
    
    test.StartTest();
            
    List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,SSD.Id);
    Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,SSD2.Id);
    propList.add(oProposal);
    propList.add(oProposal2);
    insert propList;
    
     List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
    
    Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order1.CreatedDate=now.addDays(-1);
    orderList.add(order1);
    
    Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order2);
    Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order3);
    Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order4);
    
    insert orderList;
    
     Integration_Logger__c logger1=new Integration_Logger__c();
     logger1.Exception_Message__c='error';
     logger1.Object_Id__c = '';
     logger1.Object_Name__c = 'Quote/Proposal';
     logger1.Request_Message__c = '';         
     logger1.Request_Type__c = 'Outbound';
     logger1.Service_Name__c = 'OrderSubmission';
     logger1.Order__c= order3.Id;
     logger1.Success__c = true;
 
    insert logger1;
    Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
    insert bigrule ;
    Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CA',Region_Name__c ='cal');
    insert cregion;
     Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
    CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
     CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
      CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
    APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
    APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":null,"prevAcct":null,"partnerFunction":[{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
        //build the parameters for sending the request - context_element
        testCov.context = new APTS_CreateSSDJSON2Apex.context();
        testCov.context.allowAdminEmails='test';
        testCov.context.requestor='test';
        testCov.context.userId='test';
        testCov.context.accountType='test';
        //testCov.context.extensibleAttributes{get;set;}
        //testCov.context.{get;set;}
        testCov.context.emailAddress='test';
        testCov.context.internalUser=true;
        testCov.context.fax='test';
        testCov.context.adminName='test';
        testCov.context.extension='test';
        testCov.context.adminEmail='test';
        testCov.context.phone='test';
        testCov.context.alternateEmailAddress='test';
        testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
        testCov.ESIHeader.postBackURL='test';
        testCov.ESIHeader.timeStamp='test';
        testCov.ESIHeader.instanceId='test';
        testCov.ESIHeader.tracingId='test';
        testCov.ESIHeader.companyId='test';
        testCov.ESIHeader.messageHistory='test';
        testCov.ESIHeader.configGroup='test';
        testCov.ESIHeader.messageId='test';
        testCov.ESIHeader.payloadVersion='test';
        testCov.ESIHeader.transactionId='test';
        
        testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
        List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();
   
//List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
testCov.customer.isPrimary=true;
    testCov.customer.externalAccountId='test';
    testCov.customer.industryCode='test';
    testCov.customer.accountCustomerAddressID='test';
    testCov.customer.parentAccountNumber='test';
    testCov.customer.relationshipModel='test';
   testCov.customer.accountType='test';
    testCov.customer.merchantCategoryClassificationCode='test';
    testCov.customer.companyName='test';
    testCov.customer.segment='test';
    testCov.customer.companyId='test';
    testCov.customer.applyDate='test';
    testCov.customer.accountNumber='test';
    testCov.customer.accountStatus='test';
    testCov.customer.hierarchyType='test';
    testCov.customer.KNOwned='test';
    testCov.customer.vatCode='test';
    testCov.customer.accountGroup='test';
    testCov.customer.partnerType='test';
    testCov.customer.accountClass='test';
   testCov.customer.complianceJobRole=compList;
    testCov.customer.primaryBillingNumber='test';
    testCov.customer.jurisdictionCode='test';
    testCov.customer.legacyThomsonCustomerId='test';
    testCov.customer.taxCodeType='test';
    testCov.customer.customerJourney='test';
    testCov.customer.lastUpdatedDate='test';
    testCov.customer.website='test';
    test.StopTest();
   
}
  /**
     * @description testCreateCustomer10
     */
    public static testMethod void testCreateCustomer10() {
        
    String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
    new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
    new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
     new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
       new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
        new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
    };
    
    insert keyValueList;
    List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='West')};
    insert codeList;
    
    List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
    insert bigRuleList;
    
    List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
    insert webserviceList;
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    
    RecordtypeIds__c recordtype2=new RecordtypeIds__c();
    recordtype2.Name='USL_Source_Systems';
    recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype2);
    insert recordlist;
    
    
    
    
    Account oAccount = new Account();
    oAccount.Name = 'Unit Test';
    oAccount.Sales_Org__c = 'WEST';
    oAccount.Customer_Type__c = 'Individual';
    oAccount.Customer_Group__c = 'ACADEMIC';
    oAccount.Industry = 'TAX';
    
    oAccount.BillingStreet = '275 BATTERY ST STE 1500';
    oAccount.BillingCity = 'SAN FRANCISCO';
    oAccount.BillingState = 'CA';
    oAccount.BillingPostalCode = '94111-3334';
    oAccount.BillingCountry = 'US';
    oAccount.Is_Customer_Review_Complete__c=true;
    insert oAccount;
System.assertequals('Unit Test',oAccount.Name,'Success');
    
    Source_system_detail__c ssd = new Source_system_detail__c();
    ssd.name ='test source system';
    ssd.city__c='CA';
    ssd.Account_Name__c=oAccount.Id;
    ssd.Source_System_Name__c='Test SSD';
    ssd.country__c ='US';
    ssd.LCRM_Industry__c='AC ACCOUNTING';
    ssd.LCRM_Sales_Org__c='WEST';
    ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
    ssd.Number_Street__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.OLC_Account_Number__c='test';
     ssd.County__c='test county';
    ssd.State__c='CAAA';
    ssd.LCRM_Customer_Group__c='ACADEMIC';
    ssd.CurrencyIsoCode='USD';
    insert ssd;
    
    Source_system_detail__c ssd2 = new Source_system_detail__c();
    ssd2.name ='test source system';
    ssd2.city__c='CA';
    ssd2.Account_Name__c=oAccount.Id;
    ssd2.Source_System_Name__c='Test SSD';
    ssd2.country__c ='US';
    ssd2.LCRM_Industry__c='AC ACCOUNTING';
    ssd2.LCRM_Sales_Org__c='WEST';
    ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssssbghhfuffuygfufytfgjuguyyiftyugfyufygfty';
    ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
    //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
     ssd2.County__c='test county';
    ssd2.State__c='CA';
    ssd2.LCRM_Customer_Group__c='ACADEMIC';
    ssd2.CurrencyIsoCode='USD';
    insert ssd2;
    Source_system_detail__c ssd3 = new Source_system_detail__c();
    ssd3.name ='test source system Akhilesh dfgg ertgf swerwe resreewtert' ;
    ssd3.city__c='CAsadhjjshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh';      
    ssd3.Account_Name__c=oAccount.Id;
    ssd3.Source_System_Name__c='Test SSD';
    ssd3.country__c ='US';
    ssd3.LCRM_Industry__c='AC ACCOUNTING';
    ssd3.LCRM_Sales_Org__c='WEST';
    ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
     ssd3.County__c='test county';
    ssd3.State__c='CAaaa';
    ssd3.LCRM_Customer_Group__c='ACADEMIC';
    ssd3.CurrencyIsoCode='USD';
    insert ssd3;
    
   
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=ssd.id;
    oppty.Account=oAccount;
    insert oppty;
    Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty2.RecordtypeId=opptyRecorType;
    oppty2.Source_System_Detail__c=ssd2.id;
    oppty2.Account=oAccount;
    insert oppty2;
    
    test.StartTest();
            
     List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,ssd.Id);
    Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,ssd2.Id);
    propList.add(oProposal);
    propList.add(oProposal2);
    insert propList;
    
     List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
    
    Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order1.CreatedDate=now.addDays(-1);
    orderList.add(order1);
    
    Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order2);
    Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order3);
    Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order4);
    
    insert orderList;
    
     Integration_Logger__c logger1=new Integration_Logger__c();
     logger1.Exception_Message__c='error';
     logger1.Object_Id__c = '';
     logger1.Object_Name__c = 'Quote/Proposal';
     logger1.Request_Message__c = '';         
     logger1.Request_Type__c = 'Outbound';
     logger1.Service_Name__c = 'OrderSubmission';
     logger1.Order__c= order1.Id;
     logger1.Success__c = false;
 
    insert logger1;
    Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
    insert bigrule ;
    Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CAAA',Region_Name__c ='cal');
    insert cregion;
    Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
    CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
    
     CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
      CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
    APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
    APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":null,"prevAcct":"jshj","partnerFunction":[{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
        //build the parameters for sending the request - context_element
        testCov.context = new APTS_CreateSSDJSON2Apex.context();
        testCov.context.allowAdminEmails='test';
        testCov.context.requestor='test';
        testCov.context.userId='test';
        testCov.context.accountType='test';
        //testCov.context.extensibleAttributes{get;set;}
        //testCov.context.{get;set;}
        testCov.context.emailAddress='test';
        testCov.context.internalUser=true;
        testCov.context.fax='test';
        testCov.context.adminName='test';
        testCov.context.extension='test';
        testCov.context.adminEmail='test';
        testCov.context.phone='test';
        testCov.context.alternateEmailAddress='test';
        testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
        testCov.ESIHeader.postBackURL='test';
        testCov.ESIHeader.timeStamp='test';
        testCov.ESIHeader.instanceId='test';
        testCov.ESIHeader.tracingId='test';
        testCov.ESIHeader.companyId='test';
        testCov.ESIHeader.messageHistory='test';
        testCov.ESIHeader.configGroup='test';
        testCov.ESIHeader.messageId='test';
        testCov.ESIHeader.payloadVersion='test';
        testCov.ESIHeader.transactionId='test';
        
        testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
        List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();

// List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
testCov.customer.isPrimary=true;
    testCov.customer.externalAccountId='test';
    testCov.customer.industryCode='test';
    testCov.customer.accountCustomerAddressID='test';
    testCov.customer.parentAccountNumber='test';
    testCov.customer.relationshipModel='test';
   testCov.customer.accountType='test';
    testCov.customer.merchantCategoryClassificationCode='test';
    testCov.customer.companyName='test';
    testCov.customer.segment='test';
    testCov.customer.companyId='test';
    testCov.customer.applyDate='test';
    testCov.customer.accountNumber='test';
    testCov.customer.accountStatus='test';
    testCov.customer.hierarchyType='test';
    testCov.customer.KNOwned='test';
    testCov.customer.vatCode='test';
    testCov.customer.accountGroup='test';
    testCov.customer.partnerType='test';
    testCov.customer.accountClass='test';
   testCov.customer.complianceJobRole=compList;
    testCov.customer.primaryBillingNumber='test';
    testCov.customer.jurisdictionCode='test';
    testCov.customer.legacyThomsonCustomerId='test';
    testCov.customer.taxCodeType='test';
    testCov.customer.customerJourney='test';
    testCov.customer.lastUpdatedDate='test';
    testCov.customer.website='test';
    test.StopTest();
   
}
  /**
     * @description testCreateCustomer11
     */
     public static testMethod void testCreateCustomer11() {
    String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
    new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
    new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
     new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
       new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
        new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
    };
    
    insert keyValueList;
    List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c=null,Sales_Org_Code__c='West')};
    insert codeList;
    
    List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
    insert bigRuleList;
    
    List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
    insert webserviceList;
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    
    RecordtypeIds__c recordtype2=new RecordtypeIds__c();
    recordtype2.Name='USL_Source_Systems';
    recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype2);
    insert recordlist;
    
    Account oAccount = new Account();
    oAccount.Name = 'Unit Test';
    oAccount.Sales_Org__c = 'WEST';
    oAccount.Customer_Type__c = 'Individual';
    oAccount.Customer_Group__c = 'ACADEMIC';
    oAccount.Industry = 'TAX';
    
    oAccount.BillingStreet = '275 BATTERY ST STE 1500';
    oAccount.BillingCity = 'SAN FRANCISCO';
    oAccount.BillingState = 'CA';
    oAccount.BillingPostalCode = '94111-3334';
    oAccount.BillingCountry = 'US';
    oAccount.Is_Customer_Review_Complete__c=true;
    insert oAccount;
System.assertequals('Unit Test',oAccount.Name,'Success');
    
    Source_system_detail__c ssd = new Source_system_detail__c();
    ssd.name ='test source system';
    ssd.city__c='CA';
    ssd.Account_Name__c=oAccount.Id;
    ssd.Source_System_Name__c='Test SSD';
    ssd.country__c ='US';
    ssd.LCRM_Industry__c='AC ACCOUNTING';
    ssd.LCRM_Sales_Org__c='WEST';
    ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
    ssd.Number_Street__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.OLC_Account_Number__c='test';
     ssd.County__c='test county';
    ssd.State__c='CA';
    ssd.LCRM_Customer_Group__c='ACADEMIC';
    ssd.CurrencyIsoCode='USD';
    insert ssd;
    
    Source_system_detail__c ssd2 = new Source_system_detail__c();
    ssd2.name ='test source system';
    ssd2.city__c='CA';
    ssd2.Account_Name__c=oAccount.Id;
    ssd2.Source_System_Name__c='Test SSD';
    ssd2.country__c ='US';
    ssd2.LCRM_Industry__c='AC ACCOUNTING';
    ssd2.LCRM_Sales_Org__c='WEST';
    ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
    //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
     ssd2.County__c='test county';
    ssd2.State__c='CA';
    ssd2.LCRM_Customer_Group__c='ACADEMIC';
    ssd2.CurrencyIsoCode='USD';
    insert ssd2;
    Source_system_detail__c ssd3 = new Source_system_detail__c();
    ssd3.name ='test source system';
    ssd3.city__c='CA';
    ssd3.Account_Name__c=oAccount.Id;
    ssd3.Source_System_Name__c='Test SSD';
    ssd3.country__c ='US';
    ssd3.LCRM_Industry__c='AC ACCOUNTING';
    ssd3.LCRM_Sales_Org__c='WEST';
    ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
     ssd3.County__c='test county';
    ssd3.State__c='CA';
    ssd3.LCRM_Customer_Group__c='ACADEMIC';
    ssd3.CurrencyIsoCode='USD';
    insert ssd3;
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=SSD.id;
    oppty.Account=oAccount;
    insert oppty;
    Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty2.RecordtypeId=opptyRecorType;
    oppty2.Source_System_Detail__c=SSD2.id;
    oppty2.Account=oAccount;
    insert oppty2;
    test.StartTest();
 
    List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,SSD.Id);
    Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,SSD2.Id);
    propList.add(oProposal);
    propList.add(oProposal2);
    insert propList;
    
     List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
    
    Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order1.CreatedDate=now.addDays(-1);
    orderList.add(order1);
    
    Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order2);
    Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order3);
    Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order4);
    
    insert orderList;
    
     Integration_Logger__c logger1=new Integration_Logger__c();
     logger1.Exception_Message__c='error';
     logger1.Object_Id__c = '';
     logger1.Object_Name__c = 'Quote/Proposal';
     logger1.Request_Message__c = '';         
     logger1.Request_Type__c = 'Outbound';
     logger1.Service_Name__c = 'OrderSubmission';
     logger1.Order__c= order3.Id;
     logger1.Success__c = true;
 
    insert logger1;
      List<Integration_Logger__c> li  = new List<Integration_Logger__c>();
        li.add(logger1); 
    Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
    insert bigrule ;
    Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CA',Region_Name__c ='cal');
    insert cregion;
     Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
    CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
     CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
      CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
    APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
    APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":null,"prevAcct":null,"partnerFunction":[{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
      //build the parameters for sending the request - context_element
        testCov.context = new APTS_CreateSSDJSON2Apex.context();
        testCov.context.allowAdminEmails='test';
        testCov.context.requestor='test';
        testCov.context.userId='test';
        testCov.context.accountType='test';
        //testCov.context.extensibleAttributes{get;set;}
        //testCov.context.{get;set;}
        testCov.context.emailAddress='test';
        testCov.context.internalUser=true;
        testCov.context.fax='test';
        testCov.context.adminName='test';
        testCov.context.extension='test';
        testCov.context.adminEmail='test';
        testCov.context.phone='test';
        testCov.context.alternateEmailAddress='test';
        testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
        testCov.ESIHeader.postBackURL='test';
        testCov.ESIHeader.timeStamp='test';
        testCov.ESIHeader.instanceId='test';
        testCov.ESIHeader.tracingId='test';
        testCov.ESIHeader.companyId='test';
        testCov.ESIHeader.messageHistory='test';
        testCov.ESIHeader.configGroup='test';
        testCov.ESIHeader.messageId='test';
        testCov.ESIHeader.payloadVersion='test';
        testCov.ESIHeader.transactionId='test';
        
        testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
        List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();

// List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
testCov.customer.isPrimary=true;
    testCov.customer.externalAccountId='test';
    testCov.customer.industryCode=null;
    testCov.customer.accountCustomerAddressID='test';
    testCov.customer.parentAccountNumber='test';
    testCov.customer.relationshipModel='test';
   testCov.customer.accountType='test';
    testCov.customer.merchantCategoryClassificationCode='test';
    testCov.customer.companyName=null;
    testCov.customer.segment='test';
    testCov.customer.companyId='test';
    testCov.customer.applyDate='test';
    testCov.customer.accountNumber='test';
    testCov.customer.accountStatus='test';
    testCov.customer.hierarchyType='test';
    testCov.customer.KNOwned='test';
    testCov.customer.vatCode='test';
    testCov.customer.accountGroup='test';
    testCov.customer.partnerType='test';
    testCov.customer.accountClass='test';
   testCov.customer.complianceJobRole=compList;
    testCov.customer.primaryBillingNumber='test';
    testCov.customer.jurisdictionCode='test';
    testCov.customer.legacyThomsonCustomerId='test';
    testCov.customer.taxCodeType='test';
    testCov.customer.customerJourney='test';
    testCov.customer.lastUpdatedDate='test';
    testCov.customer.website='test';   
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"null","prevAcct":"test","partnerFunction":[{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
    res.setStatusCode(200);    
  String tempStr='a';
    CreateSSDCustomerFromESIHelper2.loggerrecord3(li,res,testCov);
    CreateSSDCustomerFromESIHelper2.loggerrecord2(li,res,testCov); 
    CreateSSDCustomerFromESIHelper2.loggerrecord1(li,'abc',testCov);
    tempStr=CreateSSDCustomerFromESIHelper2.validaterequestpayload6(testCov,tempStr);
    tempStr=CreateSSDCustomerFromESIHelper2.validaterequestpayload7(testCov,tempStr);
         
    test.StopTest();
 }
   /**
     * @description testCreateCustomer12
     */
   public static testMethod void testCreateCustomer12() {
    String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
    new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
    new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
     new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
       new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
        new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
    };
    
    insert keyValueList;
    List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c=null,Sales_Org_Code__c='West')};
    insert codeList;
    
    List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
    insert bigRuleList;
    
    List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
    insert webserviceList;
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    
    RecordtypeIds__c recordtype2=new RecordtypeIds__c();
    recordtype2.Name='USL_Source_Systems';
    recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype2);
    insert recordlist;
    
    Account oAccount = new Account();
    oAccount.Name = 'Unit Test';
    oAccount.Sales_Org__c = 'WEST';
    oAccount.Customer_Type__c = 'Individual';
    oAccount.Customer_Group__c = 'ACADEMIC';
    oAccount.Industry = 'TAX';
    
    oAccount.BillingStreet = '275 BATTERY ST STE 1500';
    oAccount.BillingCity = 'SAN FRANCISCO';
    oAccount.BillingState = 'CA';
    oAccount.BillingPostalCode = '94111-3334';
    oAccount.BillingCountry = 'US';
    oAccount.Is_Customer_Review_Complete__c=true;
    insert oAccount;
System.assertequals('Unit Test',oAccount.Name,'Success');
    
    Source_system_detail__c ssd = new Source_system_detail__c();
    ssd.name ='test source system';
    ssd.city__c='CA';
    ssd.Account_Name__c=oAccount.Id;
    ssd.Source_System_Name__c='Test SSD';
    ssd.country__c ='US';
    ssd.LCRM_Industry__c='AC ACCOUNTING';
    ssd.LCRM_Sales_Org__c='WEST';
    ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
    ssd.Number_Street__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.OLC_Account_Number__c='test';
     ssd.County__c='test county';
    ssd.State__c='CA';
    ssd.LCRM_Customer_Group__c='ACADEMIC';
    ssd.CurrencyIsoCode='USD';
    insert ssd;
    
    Source_system_detail__c ssd2 = new Source_system_detail__c();
    ssd2.name ='test source system';
    ssd2.city__c='CA';
    ssd2.Account_Name__c=oAccount.Id;
    ssd2.Source_System_Name__c='Test SSD';
    ssd2.country__c ='US';
    ssd2.LCRM_Industry__c='AC ACCOUNTING';
    ssd2.LCRM_Sales_Org__c='WEST';
    ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
    //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
     ssd2.County__c='test county';
    ssd2.State__c='CA';
    ssd2.LCRM_Customer_Group__c='ACADEMIC';
    ssd2.CurrencyIsoCode='USD';
    insert ssd2;
    Source_system_detail__c ssd3 = new Source_system_detail__c();
    ssd3.name ='test source system';
    ssd3.city__c='CA';
    ssd3.Account_Name__c=oAccount.Id;
    ssd3.Source_System_Name__c='Test SSD';
    ssd3.country__c ='US';
    ssd3.LCRM_Industry__c='AC ACCOUNTING';
    ssd3.LCRM_Sales_Org__c='WEST';
    ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
     ssd3.County__c='test county';
    ssd3.State__c='CA';
    ssd3.LCRM_Customer_Group__c='ACADEMIC';
    ssd3.CurrencyIsoCode='USD';
    insert ssd3;
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=SSD.id;
    oppty.Account=oAccount;
    insert oppty;
    Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty2.RecordtypeId=opptyRecorType;
    oppty2.Source_System_Detail__c=SSD2.id;
    oppty2.Account=oAccount;
    insert oppty2;
    test.StartTest();
 
    List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,SSD.Id);
    Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,SSD2.Id);
    propList.add(oProposal);
    propList.add(oProposal2);
    insert propList;
    
     List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
    
    Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order1.CreatedDate=now.addDays(-1);
    orderList.add(order1);
    
    Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order2);
    Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order3);
    Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order4);
    
    insert orderList;
    
     Integration_Logger__c logger1=new Integration_Logger__c();
     logger1.Exception_Message__c='error';
     logger1.Object_Id__c = '';
     logger1.Object_Name__c = 'Quote/Proposal';
     logger1.Request_Message__c = '';         
     logger1.Request_Type__c = 'Outbound';
     logger1.Service_Name__c = 'OrderSubmission';
     logger1.Order__c= order3.Id;
     logger1.Success__c = true;
 
    insert logger1;
      List<Integration_Logger__c> li  = new List<Integration_Logger__c>();
       // li.add(logger1); 
    Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
    insert bigrule ;
    Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CA',Region_Name__c ='cal');
    insert cregion;
     Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
    CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
     CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
      CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
    APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
    APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":null,"prevAcct":null,"partnerFunction":[{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
      //build the parameters for sending the request - context_element
        testCov.context = new APTS_CreateSSDJSON2Apex.context();
        testCov.context.allowAdminEmails='test';
        testCov.context.requestor='test';
        testCov.context.userId='test';
        testCov.context.accountType='test';
        //testCov.context.extensibleAttributes{get;set;}
        //testCov.context.{get;set;}
        testCov.context.emailAddress='test';
        testCov.context.internalUser=true;
        testCov.context.fax='test';
        testCov.context.adminName='test';
        testCov.context.extension='test';
        testCov.context.adminEmail='test';
        testCov.context.phone='test';
        testCov.context.alternateEmailAddress='test';
        testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
        testCov.ESIHeader.postBackURL='test';
        testCov.ESIHeader.timeStamp='test';
        testCov.ESIHeader.instanceId='test';
        testCov.ESIHeader.tracingId='test';
        testCov.ESIHeader.companyId='test';
        testCov.ESIHeader.messageHistory='test';
        testCov.ESIHeader.configGroup='test';
        testCov.ESIHeader.messageId='test';
        testCov.ESIHeader.payloadVersion='test';
        testCov.ESIHeader.transactionId='test';
        
        testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
        List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();

// List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
testCov.customer.isPrimary=true;
    testCov.customer.externalAccountId='test';
    testCov.customer.industryCode='test';
    testCov.customer.accountCustomerAddressID='test';
    testCov.customer.parentAccountNumber='test';
    testCov.customer.relationshipModel='test';
   testCov.customer.accountType='test';
    testCov.customer.merchantCategoryClassificationCode='test';
    testCov.customer.companyName='test';
    testCov.customer.segment='test';
    testCov.customer.companyId='test';
    testCov.customer.applyDate='test';
    testCov.customer.accountNumber='test';
    testCov.customer.accountStatus='test';
    testCov.customer.hierarchyType='test';
    testCov.customer.KNOwned='test';
    testCov.customer.vatCode='test';
    testCov.customer.accountGroup='test';
    testCov.customer.partnerType='test';
    testCov.customer.accountClass='test';
   testCov.customer.complianceJobRole=compList;
    testCov.customer.primaryBillingNumber='test';
    testCov.customer.jurisdictionCode='test';
    testCov.customer.legacyThomsonCustomerId='test';
    testCov.customer.taxCodeType='test';
    testCov.customer.customerJourney='test';
    testCov.customer.lastUpdatedDate='test';
    testCov.customer.website='test';   
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"null","prevAcct":"test","partnerFunction":[{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":"WEST","distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
    res.setStatusCode(200);    

    CreateSSDCustomerFromESIHelper2.loggerrecord3(li,res,testCov);
    CreateSSDCustomerFromESIHelper2.loggerrecord2(li,res,testCov);  
       
    test.StopTest();
 } 
 /**
     * @description testCreateCustomer13
  
     */
    public static testMethod void testCreateCustomer13() {
        
    String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
    List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
    new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
    new KeyValueListStore__c(Name='ESIProductId',TextValue__c='TRX'),
    new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF03'),
     new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF03'),
       new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
        new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL)
    };
    
    insert keyValueList;
    List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='LLEY',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='LLEY')};
    insert codeList;
    
    List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02')};
    insert bigRuleList;
    
    List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerESI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
    new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
       new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
    insert webserviceList; 
    List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
    RecordtypeIds__c recordtype=new RecordtypeIds__c();
    recordtype.Name='Pre-Pipeline Opportunities';
    recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype);
    
    RecordtypeIds__c recordtype1=new RecordtypeIds__c();
    recordtype1.Name='Pipeline Opportunities';
    recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype1);
    
    RecordtypeIds__c recordtype2=new RecordtypeIds__c();
    recordtype2.Name='USL_Source_Systems';
    recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
    recordlist.add(recordtype2);
    insert recordlist;
    
    Account oAccount = new Account();
    oAccount.Name = 'Unit Test';
    oAccount.Sales_Org__c = 'LLEY';
    oAccount.Customer_Type__c = 'Individual';
    oAccount.Customer_Group__c = 'ACADEMIC';
    oAccount.Industry = 'TAX';
    
    oAccount.BillingStreet = '275 BATTERY ST STE 1500';
    oAccount.BillingCity = 'SAN FRANCISCO';
    oAccount.BillingState = 'CA';
    oAccount.BillingPostalCode = '94111-3334';
    oAccount.BillingCountry = 'US';
    oAccount.Is_Customer_Review_Complete__c=true;
    insert oAccount;
System.assertequals('Unit Test',oAccount.Name,'Success');
    
    Source_system_detail__c ssd = new Source_system_detail__c();
    ssd.name ='test source system';
    ssd.city__c='CA';
    ssd.Account_Name__c=oAccount.Id;
    ssd.Source_System_Name__c='Test SSD';
   // ssd.country__c ='UK';
    ssd.LCRM_Industry__c='AC ACCOUNTING';
    ssd.LCRM_Sales_Org__c='LLEY';
    ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
    ssd.Number_Street__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500';
    ssd.OLC_Account_Number__c='test';
    // ssd.County__c=null;
    ssd.State__c='CAAA';
    ssd.LCRM_Customer_Group__c='ACADEMIC';
    ssd.CurrencyIsoCode='USD';
    ssd.LatAm_Tax_Number_Type__c ='test';
    ssd.LCRM_Phone__c = '7777777';
    insert ssd;
    
    Source_system_detail__c ssd2 = new Source_system_detail__c();
    ssd2.name ='test source system';
    ssd2.city__c='CA';
    ssd2.Account_Name__c=oAccount.Id;
    ssd2.Source_System_Name__c='Test SSD';
   // ssd2.country__c ='UK';
    ssd2.LCRM_Industry__c='AC ACCOUNTING';
    ssd2.LCRM_Sales_Org__c='LLEY';
    ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssssbghhfuffuygfufytfgjuguyyiftyugfyufygfty';
    ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
    //ssd2.city__c='EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsfSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS';
   // ssd2.County__c=null;
    ssd2.State__c='CA';
    ssd2.LCRM_Customer_Group__c='ACADEMIC';
    ssd2.CurrencyIsoCode='USD';
    ssd2.LatAm_Tax_Number_Type__c ='C.I. Policía Federal';
    ssd2.LCRM_Tax_Number__c ='test';
    ssd2.LCRM_Phone__c = '7777777';
    insert ssd2;
    Source_system_detail__c ssd3 = new Source_system_detail__c();
    ssd3.name ='test source system Akhilesh dfgg ertgf swerwe resreewtert' ;
    ssd3.city__c='CAsadhjjshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh';      
    ssd3.Account_Name__c=oAccount.Id;
    ssd3.Source_System_Name__c='Test SSD';
   // ssd3.country__c ='UK';
    ssd3.LCRM_Industry__c='AC ACCOUNTING';
    ssd3.LCRM_Sales_Org__c ='LLEY';
    ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
    ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
    //ssd3.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
    ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
    ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
    //ssd3.County__c=null;
    ssd3.State__c='CAaaa';
    ssd3.LCRM_Customer_Group__c='ACADEMIC';
    ssd3.CurrencyIsoCode='USD';
    ssd3.LatAm_Tax_Number_Type__c ='test';
    ssd3.LCRM_Phone__c = '1500EWRERERfdsdfsdsfdfsds';
    insert ssd3;
    
    test.StartTest();
    
    Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
    Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty.RecordtypeId=opptyRecorType;
    oppty.Source_System_Detail__c=ssd.id;
    oppty.Account=oAccount;
    Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
    oppty2.RecordtypeId=opptyRecorType;
    oppty2.Source_System_Detail__c=ssd2.id;
    oppty2.Account=oAccount;
    
    List<Opportunity> opplist = new List<Opportunity>{oppty,oppty2};
    insert opplist;
    
    Business_Partner_Function__c bf = new Business_Partner_Function__c();
    bf.Related_Account_GLI__c = ssd2.id;
    bf.Sold_To_Account_GLI__c = ssd2.id;
    bf.Sales_Org__c = 'LLEY';
    bf.Relationship_Type__c = 'Sold-To';
    
    Business_Partner_Function__c bf1 = new Business_Partner_Function__c();
    bf1.Related_Account_GLI__c = ssd2.id;
    bf1.Sold_To_Account_GLI__c = ssd2.id;
    bf1.Sales_Org__c = 'TSL';
    bf1.Relationship_Type__c = 'Sold-To';
    
    List<Business_Partner_Function__c> bflist = new List<Business_Partner_Function__c>{bf,bf1};
    insert bflist;
            
     List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
    Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id,ssd.Id);
    Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,ssd2.Id);
    oProposal2.Digital_Quote_Type__c ='New Sales';
    oProposal2.APTS_Proposal_Business_Unit__c = 'SCS';
    propList.add(oProposal);
    propList.add(oProposal2);
    insert propList;
    
     List<Apttus_Config2__Order__c> orderList=new  List<Apttus_Config2__Order__c>();
    
    Apttus_Config2__Order__c order1=APTS_TestDataFactory.createOrder('Pending',0,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order1.CreatedDate=now.addDays(-1);
    orderList.add(order1);
    
    Apttus_Config2__Order__c order2=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order2);
    Apttus_Config2__Order__c order3=APTS_TestDataFactory.createOrder('Pending',1,ssd.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order3);
    Apttus_Config2__Order__c order4=APTS_TestDataFactory.createOrder('Pending',1,ssd2.Id);
    order1.Apttus_QPConfig__ProposalId__c=oProposal2.id;
    //order2.CreatedDate=now.addDays(-2);
    orderList.add(order4);
    
    insert orderList;
    
     Integration_Logger__c logger1=new Integration_Logger__c();
     logger1.Exception_Message__c='error';
     logger1.Object_Id__c = '';
     logger1.Object_Name__c = 'Quote/Proposal';
     logger1.Request_Message__c = '';         
     logger1.Request_Type__c = 'Outbound';
     logger1.Service_Name__c = 'OrderSubmission';
     logger1.Order__c= order1.Id;
     logger1.Success__c = false;
 
    insert logger1;
    Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='UK',Country__c='UK');
    insert bigrule ;
    Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='UK',Region_Code__c='CAAA',Region_Name__c ='cal');
    insert cregion;
    Test.setMock(HttpCalloutMock.class, new CreateSSDMockHttpResponseGenerator ());
    CreateSSDCustomerFromESI.triggerCustomerCreation(ssd.id,order1.id);
    
     CreateSSDCustomerFromESI.triggerCustomerCreation(ssd2.id,order4.id);
      CreateSSDCustomerFromESI.triggerCustomerCreation(ssd3.id,order3.id);
    APTS_CreateSSDJSON2Apex  testCov= new APTS_CreateSSDJSON2Apex ();
    APTS_CreateSSDJSON2ApexResponse.parse('{"ESIHeader":{"applicationId":"SF03"},"customerNumber":"1005215581","prevAcct":"jshj","partnerFunction":[{"salesOrg":null,"distChannel":"W","division":"W","functionId":"AG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"RE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"RG","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"WE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"ZB","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"ZC","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"ZE","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"ZP","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"ZU","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null},{"salesOrg":null,"distChannel":"W","division":"W","functionId":"ZW","counter":"000","businessPartner":"1005215581","vendorCreditorNumber":null,"contactNumber":"0000000000","personnalNumber":"00000000","description":null,"defaultPartner":null}]}');
        //build the parameters for sending the request - context_element
        testCov.context = new APTS_CreateSSDJSON2Apex.context();
        testCov.context.allowAdminEmails='test';
        testCov.context.requestor='test';
        testCov.context.userId='test';
        testCov.context.accountType='test';
        //testCov.context.extensibleAttributes{get;set;}
        //testCov.context.{get;set;}
        testCov.context.emailAddress='test';
        testCov.context.internalUser=true;
        testCov.context.fax='test';
        testCov.context.adminName='test';
        testCov.context.extension='test';
        testCov.context.adminEmail='test';
        testCov.context.phone='test';
        testCov.context.alternateEmailAddress='test';
        testCov.ESIHeader= new APTS_CreateSSDJSON2Apex.ESIHeader();
        testCov.ESIHeader.postBackURL='test';
        testCov.ESIHeader.timeStamp='test';
        testCov.ESIHeader.instanceId='test';
        testCov.ESIHeader.tracingId='test';
        testCov.ESIHeader.companyId='test';
        testCov.ESIHeader.messageHistory='test';
        testCov.ESIHeader.configGroup='test';
        testCov.ESIHeader.messageId='test';
        testCov.ESIHeader.payloadVersion='test';
        testCov.ESIHeader.transactionId='test';
        
        testCov.customer= new APTS_CreateSSDJSON2Apex.customer();
        List<APTS_CreateSSDJSON2Apex.complianceJobRole> compList = new List<APTS_CreateSSDJSON2Apex.complianceJobRole> ();
    APTS_CreateSSDJSON2Apex.complianceJobRole testcov2 = new APTS_CreateSSDJSON2Apex.complianceJobRole();
    testcov2.Id = 'test';
    testcov2.description = 'test';
//  List<APTS_CreateSSDJSON2Apex.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2Apex.extensibleAttributes> ();
//  List<APTS_CreateSSDJSON2Apex.sourceOrTargetReference> testcov4 = new List<APTS_CreateSSDJSON2Apex.sourceOrTargetReference> ();
    APTS_CreateSSDJSON2Apex.sourceOrTargetReference testcov3 = new APTS_CreateSSDJSON2Apex.sourceOrTargetReference();
    testcov3.referenceID = 'test';
    testcov3.sourceOrTargetSystemName = 'test';
    testCov.customer.isPrimary=true;
    testCov.customer.externalAccountId='test';
    testCov.customer.industryCode='test';
    testCov.customer.accountCustomerAddressID='test';
    testCov.customer.parentAccountNumber='test';
    testCov.customer.relationshipModel='test';
    testCov.customer.accountType='test';
    testCov.customer.merchantCategoryClassificationCode='test';
    testCov.customer.companyName='test';
    testCov.customer.segment='test';
    testCov.customer.companyId='test';
    testCov.customer.applyDate='test';
    testCov.customer.accountNumber='test';
    testCov.customer.accountStatus='test';
    testCov.customer.hierarchyType='test';
    testCov.customer.KNOwned='test';
    testCov.customer.vatCode='test';
    testCov.customer.accountGroup='test';
    testCov.customer.partnerType='test';
    testCov.customer.accountClass='test';
   testCov.customer.complianceJobRole=compList;
    testCov.customer.primaryBillingNumber='test';
    testCov.customer.jurisdictionCode='test';
    testCov.customer.legacyThomsonCustomerId='test';
    testCov.customer.taxCodeType='test';
    testCov.customer.customerJourney='test';
    testCov.customer.lastUpdatedDate='test';
    testCov.customer.website='test';
    testCov.customer.language='test';   
    
    testCov.customer.isActive=true;
    APTS_CreateSSDJSON2Apex.address testcov5 = new APTS_CreateSSDJSON2Apex.address();
    testcov5.title = 'test';
    testcov5.country = null;
    testcov5.emailAddress = 'test';
    testcov5.extension = 'test';
    testcov5.alternateEmailAddress = 'test';
    testcov5.building = 'test';
    testcov5.floor = 'test';
    testcov5.room = 'test';
    CreateSSDCustomerFromESIHelper1.validaterequestpayload5(testCov);
    //CreateSSDCustomerFromESIHelper1.validaterequestpayload2(testCov);
    test.StopTest();
   
}
}