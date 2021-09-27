@isTest
public class CreateSSDCustomerFromBOOMI_Test{ 
    
    @isTest
    public static void testCreateCustomerTax() {
        test.StartTest();
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        String integrationMsgId;
        String accessToken ='DtOdJzb5sjdWBpqcvWyGTmGdRYTR';
        String grantType = 'client_credentials';
        String contentType= 'application/x-www-form-urlencoded';
        String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
                new KeyValueListStore__c(Name='BOOMIProductId',TextValue__c='SF12'),
                //new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF12'),
                new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF12'),
                new KeyValueListStore__c(Name='RG',TextValue__c='79'),
                new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
                new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL),
                new KeyValueListStore__c(Name='LatAmServiceNowSync',TextValue__c='USL_Source_Systems'),
                new KeyValueListStore__c(Name='LatAmSSDRecordTypeName',TextValue__c='USL_Source_Systems')
                };
                    insert keyValueList;
        
        profile_list__c plist = new profile_list__c(name = 'System Administrator',Profile_Name__c='System Administrator',ProfileId__c = System.Label.APTS_OC_Test_Id);
        insert plist;
        
        /*LatAmCountrySalesOrgMapping__c salesOrg = new LatAmCountrySalesOrgMapping__c();
salesOrg.Name = 'US';
salesOrg.Primary_sales_org__c = 'WEST';
insert salesOrg;*/
        
        List<IXOSCodeMap__c> ixocodeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='S100',Company_Code__c='1078',Dist_Chan_Code__c='00',Division_Code__c='00',Sales_Org_Code__c='S100')};
            insert ixocodeList;
        
        List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02'),new BigRuleGenericSettings__c(Name='PF:AG',Value__c='02')};
            insert bigRuleList;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerBOOMI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://test.salesforce.com/services/Soap/c/38.0/',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://na68.salesforce.com/services/Soap/class/ProposalPaymentStatusPostBack',Service_Unavailable_Message__c='Service not Available')
            //new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://cs64.salesforce.com/services/Soap/class/ProposalPaymentStatusPostBack',Service_Unavailable_Message__c='Service not Available'),
            //new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://cs64.salesforce.com/services/Soap/class/ProposalCCTokenPostBack',Service_Unavailable_Message__c='Service not Available')
            };
                WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        webserviceList.add(oWebServiceSettings);
        
        /*  WebServiceSettings__c ws= new WebServiceSettings__c();
ws.Name='Dellboomi SFDC Legal';
ws.Username__c='Username';
ws.Password__c='Password';
ws.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
ws.Service_Unavailable_Message__c='Service_Unavailable'; 
WebserviceList.add(ws); */
        // insert ws;
        
        insert WebserviceList;
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
        
        RecordtypeIds__c recordtype3=new RecordtypeIds__c();
        recordtype3.Name='Latam_source_systems';
        recordtype3.recTypeId__c=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        recordlist.add(recordtype3);
        
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c=System.Label.APTS_OC_Test_Id);
        recordlist.add(rt2);
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c=System.Label.APTS_OC_Test_Id);
        recordlist.add(rt3);
        
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
        oAccount.ECM_Party_ID__c = '32656489';
        oAccount.ECM_Address_Row_Id__c = '32656489';
        oAccount.Bu_Segment__c = 'Professional Tax';
        oAccount.ECC_Segment_Level_2__c = 'Other - Tax Professionals';
        oAccount.ECC_Segment_Level_3__c = 'Tax - Other - Tax Professionals';
        insert oAccount;
        
        GLI_Segment_L1__c l1 = new GLI_Segment_L1__c(Name = 'Professional Tax',Text_Value__c = '04');
        insert l1;
        
        GLI_Segment_L2__c l2 = new GLI_Segment_L2__c(Name = 'Other - Tax Professionals',Text_Value__c = 'T004');
        insert l2;
        
        GLI_Segment_L3__c l3 = new GLI_Segment_L3__c(Name = 'Tax - Other - Tax Professionals',Text_Value__c = '04');
        insert l3;
        
        List<Source_system_detail__c> ssdList = new List<Source_system_detail__c>();
        Source_system_detail__c ssd = new Source_system_detail__c();
        ssd.name ='test source system';
        ssd.city__c='CABATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd.Account_Name__c=oAccount.Id;
        ssd.Source_System_Name__c='Test SSD';
        ssd.country__c ='US';
        ssd.LCRM_Industry__c='AC ACCOUNTING';
        ssd.LCRM_Sales_Org__c='S100';
        ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
        ssd.Number_Street__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500sdvdvdzvzdvdvbdfvvbczbb';
        ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500cbzcbzbzfbfzbfxbnfxgb';
        ssd.OLC_Account_Number__c='test';
        ssd.County__c='test countydgdggg';
        ssd.LCRM_External_Trail_Acount_ID__c='test';
        ssd.State__c='CAfd';
        ssd.LCRM_Customer_Group__c='ACADEMIC';
        ssd.CurrencyIsoCode='USD';
        ssdList.add(ssd);
        
        Source_system_detail__c ssd2 = new Source_system_detail__c();
        ssd2.name ='test source system';
        ssd2.city__c='CABATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd2.Account_Name__c=oAccount.Id;
        ssd2.Source_System_Name__c='Test SSD';
        ssd2.country__c ='US';
        ssd2.LCRM_Industry__c='AC ACCOUNTING';
        ssd2.LCRM_External_Trail_Acount_ID__c='test';
        ssd2.LCRM_Sales_Org__c='S100';
        ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
        ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        ssd2.County__c='test countyBATTERY ST ST';
        ssd2.State__c='CAju';
        ssd2.LCRM_Customer_Group__c='ACADEMIC';
        ssd2.CurrencyIsoCode='USD';
        ssd2.RecordtypeId = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId(); 
        ssdList.add(ssd2);
        
        Source_system_detail__c ssd3 = new Source_system_detail__c();
        ssd3.name ='test source system' ;
        ssd3.city__c='CABATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd3.Account_Name__c=oAccount.Id;
        ssd3.Source_System_Name__c='Test SSD';
        ssd3.country__c ='US';
        ssd3.LCRM_Industry__c='AC ACCOUNTING';
        ssd3.LCRM_External_Trail_Acount_ID__c='test';
        ssd3.LCRM_Sales_Org__c='S100';
        ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        ssd3.County__c='test countyhjhjyj';
        ssd3.State__c='CAgj';
        ssd3.LCRM_Customer_Group__c='ACADEMIC';
        ssd3.CurrencyIsoCode='USD';
        ssdList.add(ssd3);
        
        Source_system_detail__c ssd4 = new Source_system_detail__c();
        ssd4.name ='test source systemoploploplkjhgfdsaqwerty';
        ssd4.Account_Name__c=oAccount.Id;
        ssd4.Source_System_Name__c='Test SSD';
        ssd4.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd4.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
        ssd4.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
        ssd4.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
        ssd4.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
        ssd4.County__c='test countyhjghjh';
        ssd4.LCRM_Customer_Group__c='ACADEMIC';
        ssd4.LCRM_External_Trail_Acount_ID__c='test';
        ssd4.CurrencyIsoCode='USD';
        ssd4.LatAm_Tax_Number_Type__c='RG';
        ssd4.RecordtypeId = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId(); 
        ssdList.add(ssd4);
        
        insert ssdList;
        System.assertEquals(4,ssdList.size());
        List<SAP_Originating_System_Mapping__mdt> sapMapQuery = new   List<SAP_Originating_System_Mapping__mdt> ();
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty1=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty1.RecordtypeId=opptyRecorType;
        oppty1.Source_System_Detail__c=SSD.id;
        oppty1.Account=oAccount;
        insert oppty1;
        Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty2.RecordtypeId=opptyRecorType;
        oppty2.Source_System_Detail__c=SSD2.id;
        oppty2.Account=oAccount;
        insert oppty2;
        
        List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty1.id,SSD.Id);
        Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,SSD2.Id);
        oProposal.APTS_SSD_bill_to__c = ssd.Id;
        oProposal2.APTS_SSD_bill_to__c = ssd2.Id;
        propList.add(oProposal);
        propList.add(oProposal2);
        insert propList;
        
        Integration_Logger__c logger1=new Integration_Logger__c();
        logger1.Exception_Message__c='error';
        logger1.Object_Id__c = '';
        logger1.Object_Name__c = 'Quote/Proposal';
        logger1.Request_Message__c = '';         
        logger1.Request_Type__c = 'Outbound';
        logger1.Service_Name__c = 'OrderSubmission';
        logger1.Source_System_Detail__c= ssd.Id;
        logger1.Success__c = true;
        
        
        
        insert logger1;
        Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
        insert bigrule ;
        Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CAgd',Region_Name__c ='cal');
        insert cregion;
        DellBoomiTokenGeneration ab=new  DellBoomiTokenGeneration();
        try{
            String accessToken3=DellBoomiTokenGeneration.getAuthToken();
        }Catch(Exception e){
            System.debug(e.getMessage());
        }           
        // System.assertEquals(accessToken3,'6f6VEGEmDHn98wKBlX3FWlOfBpB4');
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        
        //start :call to test webservice failure scenario
        CreateSSDCustomerFromDellBoomi.oppId = oppty1.Id;
        CreateSSDCustomerFromDellBoomi.QuoteID = oProposal.Id;
        TaxCreateSSDMockHttpResponseGenerator.statusCode = 201;
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        delete [Select Id, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Source_System_Detail__c=:ssd.Id];
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        //end :call to test webservice failure scenario
        
        //start :call to test webservice success scenario where it return SAP Number as null
        TaxCreateSSDMockHttpResponseGenerator.statusCode = 200;
        TaxCreateSSDMockHttpResponseGenerator.respBody =  '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"access_token": "DtOdJzb5sjdWBpqcvWyGTmGdRYTR","expires_in": "3599","token_type": "Bearer" ,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        //TaxCreateSSDMockHttpResponseGenerator.respBody = '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":null,"prevAcct":null,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        delete [Select Id, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Source_System_Detail__c=:ssd.Id];
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        //end :call to test webservice success scenario where it return SAP Number as null
        
        //start :call to test webservice success scenario where it return valid SAP Number 
        TaxCreateSSDMockHttpResponseGenerator.respBody = '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"access_token": "DtOdJzb5sjdWBpqcvWyGTmGdRYTR","expires_in": "3599","token_type": "Bearer" ,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        //TaxCreateSSDMockHttpResponseGenerator.respBody = '{"BoomiHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        
        
        //TaxSAPCustomerQuoteCreateServiceHandler oTestEmailHandler = new TaxSAPCustomerQuoteCreateServiceHandler ();
        
        
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd2.id, oProposal2.id);
        //end :call to test webservice success scenario where it return valid SAP Number 
        
        
        
        //CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd3.id,null);
        
        //start :call to test where SSD is missing required info 
        CreateSSDCustomerFromDellBoomi.QuoteID = null;
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd4.id, null);
        APTS_CreateSSDJSON2ApexBOOMI  testCov= new APTS_CreateSSDJSON2ApexBOOMI ();
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreationFuture(ssd4.id, null, null);
        //start :call to test where SSD is missing required info 
        
        //start :call to test exception block 
        CreateSSDCustomerFromDellBoomi.oppId = null;
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreationFuture(ssd4.id, null, oProposal2.id);
        delete [Select Id, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Source_System_Detail__c=:ssd2.Id];
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreationFuture(ssd4.id, null, null);
        //end :call to test exception block 
        
        TaxCreateSSDMockHttpResponseGenerator.respBody = '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"access_token": "DtOdJzb5sjdWBpqcvWyGTmGdRYTR","expires_in": "3599","token_type": "Bearer" ,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        //APTS_CreateSSDJSON2ApexResponseBOOMI.parse('{"BoomiHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":"asdd","StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}');
        testCov.context = new APTS_CreateSSDJSON2ApexBOOMI.context();
        testCov.context.allowAdminEmails='test';
        testCov.context.requestor='test';
        testCov.context.userId='test';
        testCov.context.accountType='test';
        testCov.context.emailAddress='test';
        testCov.context.internalUser=true;
        testCov.context.fax='test';
        testCov.context.adminName='test';
        testCov.context.extension='test';
        testCov.context.adminEmail='test';
        testCov.context.phone='test';
        testCov.context.alternateEmailAddress='test';
        testCov.context.middleName='test';
        testCov.context.lastName='test';
        testCov.context.firstName='test';
        testCov.context.name='test';
        testCov.context.internalUserId='test';
        testCov.context.mobilePhone='test';
        
        
        
        testCov.BOOMIHeader= new APTS_CreateSSDJSON2ApexBOOMI.BOOMIHeader();
        testCov.BOOMIHeader.postBackURL='test';
        testCov.BOOMIHeader.timeStamp='test';
        testCov.BOOMIHeader.instanceId='test';
        testCov.BOOMIHeader.tracingId='test';
        testCov.BOOMIHeader.companyId='test';
        testCov.BOOMIHeader.messageHistory='test';
        testCov.BOOMIHeader.configGroup='test';
        testCov.BOOMIHeader.messageId='test';
        testCov.BOOMIHeader.payloadVersion='test';
        testCov.BOOMIHeader.transactionId='test';
        testCov.BOOMIHeader.profileId='test';
        
        testCov.customer= new APTS_CreateSSDJSON2ApexBOOMI.customer();
        List<APTS_CreateSSDJSON2ApexBOOMI.complianceJobRole> compList = new List<APTS_CreateSSDJSON2ApexBOOMI.complianceJobRole> ();
        
        APTS_CreateSSDJSON2ApexBOOMI.complianceJobRole cmjob = new APTS_CreateSSDJSON2ApexBOOMI.complianceJobRole();
        cmjob.Id ='test';
        cmjob.description='test';
        
        List<APTS_CreateSSDJSON2ApexResponseBOOMI.StatusDetails> stdt = new List<APTS_CreateSSDJSON2ApexResponseBOOMI.StatusDetails>();
        APTS_CreateSSDJSON2ApexResponseBOOMI.StatusDetails std= new APTS_CreateSSDJSON2ApexResponseBOOMI.StatusDetails();
        std.statusCode='test';
        std.statusDescription='test';
        std.statusMessage='test';
        
        List<APTS_CreateSSDJSON2ApexBOOMI.billingAllocation> billList = new List<APTS_CreateSSDJSON2ApexBOOMI.billingAllocation> ();
        APTS_CreateSSDJSON2ApexBOOMI.billingAllocation billalloc = new APTS_CreateSSDJSON2ApexBOOMI.billingAllocation();
        billalloc.orderLineNumber='test';
        billalloc.allocationPercentage='test';
        billalloc.allocationAmount='test';
        billalloc.purchOrderNumber='test';         
        
        
        List<APTS_CreateSSDJSON2ApexBOOMI.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2ApexBOOMI.extensibleAttributes> ();
        APTS_CreateSSDJSON2ApexBOOMI.extensibleAttributes extattr = new APTS_CreateSSDJSON2ApexBOOMI.extensibleAttributes();
        extattr.key='test';
        extattr.value='test';
        extattr.systemIdentifier='test';
        extattr.description='test';
        
        testCov.customer.isPrimary=true;
        testCov.customer.externalAccountId='test';
        testCov.customer.industryCode='test';
        testCov.customer.accountCustomerAddressID='test';
        testCov.customer.parentAccountNumber='test';
        testCov.customer.relationshipModel='test';
        testCov.customer.accountType='test';
        testCov.customer.merchantCategoryClassificationCode='test';
        testCov.customer.companyName='00';
        testCov.customer.segment='test';
        testCov.customer.companyId='1078';
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
        testCov.customer.action='test';
        testCov.customer.companySize='test';
        testCov.customer.digitalFirm='test';
        testCov.customer.locationAccountNumber='test';
        testCov.customer.accountSSDId='test';
        testCov.customer.accountSSDName='test';
        testCov.customer.accountSSDNumber='test';
        testCov.customer.currency_x='test'; 
        testCov.customer.language='test';
        testCov.customer.legalStatus='test';
        testCov.customer.altKN='test';
        //testCov.customer.salesOrg='test';
        testCov.customer.sourceOrTargetReferenceNumber='test';
        testCov.customer.distributionChannel='test';
        testCov.customer.isActive=true;
        testCov.customer.division='00';
        testCov.customer.TerritoryNumber='test';
        testCov.customer.creditRiskCategory='test';
        testCov.customer.trAccountClass='test';
        testCov.customer.preferredLanguage='test';
        testCov.customer.accountDirectorID='test';
        testCov.customer.accountDirectorName='test';
        testCov.customer.ownerId='test';
        testCov.customer.ownerName='test';
        testCov.customer.locationCountry='test';
        testCov.customer.ultimateParentAccountNumber='test';
        testCov.customer.accountClassification='test';
        testCov.customer.tenancyName='test';
        testCov.customer.companyCode='test';
        testCov.customer.accountName='test';
        testCov.customer.campaignId='test';
        testCov.customer.reasonToEndJourney='test';
        testCov.customer.isRecordFound='test';
        testCov.customer.accountId='test';
        testCov.customer.businessUnit='test';
        testCov.customer.businessChannel='test';
        testCov.customer.taxCode2='test';
        testCov.customer.taxCode1 ='test';
        testCov.customer.licenseId='test';
        testCov.customer.isUnderMaintenance=true;
        testCov.customer.curency='test'; 
        
        testCov.customer.Companyname='test';  
        testCov.customer= new APTS_CreateSSDJSON2ApexBOOMI.customer();             
        
        List<APTS_CreateSSDJSON2ApexBOOMI.address> addressList = new List<APTS_CreateSSDJSON2ApexBOOMI.address>();
        APTS_CreateSSDJSON2ApexBOOMI.address addressObject = new APTS_CreateSSDJSON2ApexBOOMI.address();
        addressObject.region='test';
        addressObject.street1='test';
        addressObject.street2 ='test';
        addressObject.street3 ='test';
        addressObject.city ='test';
        addressObject.country ='test';
        addressObject.firstName=null;
        addressObject.postalCode ='test';
        addressObject.poBox ='test';
        addressObject.district='test';
        addressObject.street4='test'; 
        addressObject.billingAddress='test'; 
        addressObject.title='test'; 
        addressObject.county='test';
        addressObject.emailAddress='test';
        addressObject.isPhysicalAddress='test';
        addressObject.mobilePhone='test';
        addressObject.extension='test';
        addressObject.alternateEmailAddress='test';
        addressObject.building='test';
        addressObject.name='test';
        addressObject.floor='test';
        addressObject.room='test';
        addressObject.externalContactId='test';
                
        Test.stopTest();
    }
    
    @isTest
    public static void testCreateCustomerTax1() {
        test.StartTest();
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        String integrationMsgId;
        String accessToken ='DtOdJzb5sjdWBpqcvWyGTmGdRYTR';
        String grantType = 'client_credentials';
        String contentType= 'application/x-www-form-urlencoded';
        String recordUSL=Schema.SObjectType.Source_system_detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
                new KeyValueListStore__c(Name='BOOMIProductId',TextValue__c='SF12'),
                //new KeyValueListStore__c(Name='ESIconfigGroup',TextValue__c='SF12'),
                new KeyValueListStore__c(Name='CustomerReviewPostbackURL',TextValue__c='SF12'),
                new KeyValueListStore__c(Name='RG',TextValue__c='79'),
                new KeyValueListStore__c(Name='ESICustomerAuthorization',TextValue__c='SFSFDFFDFFD'),
                new KeyValueListStore__c(Name='CustomerSSDRecordTypeId',TextValue__c=recordUSL),
                new KeyValueListStore__c(Name='LatAmServiceNowSync',TextValue__c='USL_Source_Systems'),
                new KeyValueListStore__c(Name='LatAmSSDRecordTypeName',TextValue__c='USL_Source_Systems')
                };
                    insert keyValueList;
        
        profile_list__c plist = new profile_list__c(name = 'System Administrator',Profile_Name__c='System Administrator',ProfileId__c = System.Label.APTS_OC_Test_Id);
        insert plist;
        
        /*LatAmCountrySalesOrgMapping__c salesOrg = new LatAmCountrySalesOrgMapping__c();
salesOrg.Name = 'US';
salesOrg.Primary_sales_org__c = 'WEST';
insert salesOrg;*/
        
        List<IXOSCodeMap__c> ixocodeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='S100',Company_Code__c='1078',Dist_Chan_Code__c='00',Division_Code__c='00',Sales_Org_Code__c='S100')};
            insert ixocodeList;
        
        List<BigRuleGenericSettings__c> bigRuleList = new List<BigRuleGenericSettings__c>{new BigRuleGenericSettings__c(Name='IND:AC ACCOUNTING',Value__c='AU01'),new BigRuleGenericSettings__c(Name='CG:ACADEMIC',Value__c='02'),new BigRuleGenericSettings__c(Name='PF:AG',Value__c='02')};
            insert bigRuleList;
        
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerBOOMI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://test.salesforce.com/services/Soap/c/38.0/',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://na68.salesforce.com/services/Soap/class/ProposalPaymentStatusPostBack',Service_Unavailable_Message__c='Service not Available')
            //new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://cs64.salesforce.com/services/Soap/class/ProposalPaymentStatusPostBack',Service_Unavailable_Message__c='Service not Available'),
            //new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://cs64.salesforce.com/services/Soap/class/ProposalCCTokenPostBack',Service_Unavailable_Message__c='Service not Available')
            };
                WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        webserviceList.add(oWebServiceSettings);
        
        /*  WebServiceSettings__c ws= new WebServiceSettings__c();
ws.Name='Dellboomi SFDC Legal';
ws.Username__c='Username';
ws.Password__c='Password';
ws.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
ws.Service_Unavailable_Message__c='Service_Unavailable'; 
WebserviceList.add(ws); */
        // insert ws;
        
        insert WebserviceList;
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
        
        RecordtypeIds__c recordtype3=new RecordtypeIds__c();
        recordtype3.Name='Latam_source_systems';
        recordtype3.recTypeId__c=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        recordlist.add(recordtype3);
        
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c=System.Label.APTS_OC_Test_Id);
        recordlist.add(rt2);
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c=System.Label.APTS_OC_Test_Id);
        recordlist.add(rt3);
        
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
        //oAccount.BillingPostalCode = '94111-3334';
        oAccount.BillingCountry = 'US';
        oAccount.Is_Customer_Review_Complete__c=true;
        insert oAccount;
        
        List<Source_system_detail__c> ssdList = new List<Source_system_detail__c>();
        Source_system_detail__c ssd = new Source_system_detail__c();
        //ssd.name ='test source system';
        //ssd.city__c='CABATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd.Account_Name__c=oAccount.Id;
        ssd.Source_System_Name__c='Test SSD';
        //ssd.country__c ='US';
        //ssd.LCRM_Industry__c='AC ACCOUNTING';
        // ssd.LCRM_Sales_Org__c='S100';
        //ssd.LCRM_Street_2__c='275 BATTERY ST STE 1500';
        //ssd.LCRM_Street3__c='275 BATTERY ST STE 1500';
        //ssd.Number_Street__c='275 BATTERY ST STE 1500';
        //ssd.LCRM_Name_2__c='275 BATTERY ST STE 1500';
        //ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500sdvdvdzvzdvdvbdfvvbczbb';
        // ssd.LCRM_Name_3__c='275 BATTERY ST STE 1500cbzcbzbzfbfzbfxbnfxgb';
        //ssd.OLC_Account_Number__c='test';
        //ssd.County__c='test countydgdggg';
        //ssd.LCRM_External_Trail_Acount_ID__c='test';
        // ssd.State__c='CAfd';
        //ssd.LCRM_Customer_Group__c='ACADEMIC';
        //ssd.CurrencyIsoCode='USD';
        ssdList.add(ssd);
        
        Source_system_detail__c ssd2 = new Source_system_detail__c();
        // ssd2.name ='test source system';
        //ssd2.city__c='CABATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd2.Account_Name__c=oAccount.Id;
        ssd2.Source_System_Name__c='Test SSD';
        //ssd2.LCRM_Sales_Org__c='S100';
        //ssd2.country__c ='US';
        /*ssd2.LCRM_Industry__c='AC ACCOUNTING';
ssd2.LCRM_External_Trail_Acount_ID__c='test';
ssd2.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
ssd2.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
ssd2.Number_Street__c='275 BATTERY ST STE 1500sdfsssssssssssssssssssss';
ssd2.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
ssd2.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
ssd2.County__c='test countyBATTERY ST ST';
ssd2.State__c='CAju';
ssd2.LCRM_Customer_Group__c='ACADEMIC';
ssd2.CurrencyIsoCode='USD';*/
        ssd2.RecordtypeId = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId(); 
        ssdList.add(ssd2);
        
        Source_system_detail__c ssd3 = new Source_system_detail__c();
        //ssd3.name ='test source system' ;
        //ssd3.city__c='CABATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
        ssd3.Account_Name__c=oAccount.Id;
        ssd3.Source_System_Name__c='Test SSD';
        //ssd3.LCRM_Sales_Org__c='S100';
        /* ssd3.country__c ='US';
ssd3.LCRM_Industry__c='AC ACCOUNTING';
ssd3.LCRM_External_Trail_Acount_ID__c='test';
ssd3.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
ssd3.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
ssd3.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
ssd3.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
ssd3.County__c='test countyhjhjyj';
ssd3.State__c='CAgj';
ssd3.LCRM_Customer_Group__c='ACADEMIC';
ssd3.CurrencyIsoCode='USD*/
        ssdList.add(ssd3);
        
        Source_system_detail__c ssd4 = new Source_system_detail__c();
        ssd4.name ='test source systemoploploplkjhgfdsaqwerty';
        ssd4.Account_Name__c=oAccount.Id;
        ssd4.Source_System_Name__c='Test SSD';
        /*ssd4.LCRM_Street_2__c='275 BATTERY ST STE 1500sdfssssssssssssssdfsfsfdsfsdfsssssss';
ssd4.LCRM_Street3__c='275 BATTERY ST STE 1500sdffffffffffffffffffffffffffff';
ssd4.LCRM_Name_2__c='275 BATTERY ST STE 1500sdfsfsfdfsfsfsfssssssssssssssssss';
ssd4.LCRM_Name_3__c='275 BATTERY ST STE 1500sdfsfsdfsdfsfdsfsfdsfdfsdfsfdsfdsf';
ssd4.LCRM_Name_3__c='275 BATTERY ST STE 1500EWRERERfdsdfsdsfdfsdsffssdfsdfsdfsfdsdfsfdsfdsf';
ssd4.County__c='test countyhjghjh';
ssd4.LCRM_Customer_Group__c='ACADEMIC';
ssd4.LCRM_External_Trail_Acount_ID__c='test';
ssd4.CurrencyIsoCode='USD';
ssd4.LatAm_Tax_Number_Type__c='RG';*/
        ssd4.RecordtypeId = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId(); 
        ssdList.add(ssd4);
        
        insert ssdList;
        System.assertEquals(4,ssdList.size());
        List<SAP_Originating_System_Mapping__mdt> sapMapQuery = new   List<SAP_Originating_System_Mapping__mdt> ();
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty1=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty1.RecordtypeId=opptyRecorType;
        oppty1.Source_System_Detail__c=SSD.id;
        oppty1.Account=oAccount;
        insert oppty1;
        Opportunity oppty2=APTS_TestDataFactory.createOpportunity('abc',oAccount.id,'Needs Analysis',Date.Today());
        oppty2.RecordtypeId=opptyRecorType;
        oppty2.Source_System_Detail__c=SSD2.id;
        oppty2.Account=oAccount;
        insert oppty2;
        
        List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty1.id,SSD.Id);
        Apttus_Proposal__Proposal__c oProposal2=APTS_TestDataFactory.createProposal(oppty2.id,SSD2.Id);
        oProposal.APTS_SSD_bill_to__c = ssd.Id;
        oProposal2.APTS_SSD_bill_to__c = ssd2.Id;
        propList.add(oProposal);
        propList.add(oProposal2);
        insert propList;
        
        Integration_Logger__c logger1=new Integration_Logger__c();
        logger1.Exception_Message__c='error';
        logger1.Object_Id__c = '';
        logger1.Object_Name__c = 'Quote/Proposal';
        logger1.Request_Message__c = '';         
        logger1.Request_Type__c = 'Outbound';
        logger1.Service_Name__c = 'OrderSubmission';
        logger1.Source_System_Detail__c= ssd.Id;
        logger1.Success__c = true;
        
        insert logger1;
        Country_BigRule_Exception__c bigrule = new Country_BigRule_Exception__c(Name='US',Country__c='US');
        insert bigrule ;
        Country__c bigrule1 = new Country__c(Name='UNITED STATES',Country_Code__c='US',IsActive__c=true);
        insert bigrule1 ;
        Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CAgd',Region_Name__c ='cal');
        insert cregion;
        DellBoomiTokenGeneration ab=new  DellBoomiTokenGeneration();
        try{
            String accessToken3=DellBoomiTokenGeneration.getAuthToken();
        }Catch(Exception e){
            System.debug(e.getMessage());
        }           
        // System.assertEquals(accessToken3,'6f6VEGEmDHn98wKBlX3FWlOfBpB4');
        
        Test.setMock(HttpCalloutMock.class, new TaxCreateSSDMockHttpResponseGenerator());
        
        //start :call to test webservice failure scenario
        CreateSSDCustomerFromDellBoomi.oppId = oppty1.Id;
        CreateSSDCustomerFromDellBoomi.QuoteID = oProposal.Id;
        TaxCreateSSDMockHttpResponseGenerator.statusCode = 201;
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        delete [Select Id, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Source_System_Detail__c=:ssd.Id];
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        //end :call to test webservice failure scenario
        
        //start :call to test webservice success scenario where it return SAP Number as null
        TaxCreateSSDMockHttpResponseGenerator.statusCode = 200;
        TaxCreateSSDMockHttpResponseGenerator.respBody =  '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"access_token": "DtOdJzb5sjdWBpqcvWyGTmGdRYTR","expires_in": "3599","token_type": "Bearer" ,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        //TaxCreateSSDMockHttpResponseGenerator.respBody = '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":null,"prevAcct":null,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        delete [Select Id, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Source_System_Detail__c=:ssd.Id];
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        //end :call to test webservice success scenario where it return SAP Number as null
        
        //start :call to test webservice success scenario where it return valid SAP Number 
        TaxCreateSSDMockHttpResponseGenerator.respBody = '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"access_token": "DtOdJzb5sjdWBpqcvWyGTmGdRYTR","expires_in": "3599","token_type": "Bearer" ,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        //TaxCreateSSDMockHttpResponseGenerator.respBody = '{"BoomiHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        
        
        //TaxSAPCustomerQuoteCreateServiceHandler oTestEmailHandler = new TaxSAPCustomerQuoteCreateServiceHandler ();
        
        
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd.id, oProposal.id);
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd2.id, oProposal2.id);
        //end :call to test webservice success scenario where it return valid SAP Number 
        
        
        
        //CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd3.id,null);
        
        //start :call to test where SSD is missing required info 
        CreateSSDCustomerFromDellBoomi.QuoteID = null;
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssd4.id, null);
        APTS_CreateSSDJSON2ApexBOOMI  testCov= new APTS_CreateSSDJSON2ApexBOOMI ();
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreationFuture(ssd4.id, null, null);
        //start :call to test where SSD is missing required info 
        
        //start :call to test exception block 
        CreateSSDCustomerFromDellBoomi.oppId = null;
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreationFuture(ssd4.id, null, oProposal2.id);
        delete [Select Id, Source_System_Detail__r.Account_Name__c from Integration_Logger__c where Source_System_Detail__c=:ssd2.Id];
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreationFuture(ssd4.id, null, null);
        //end :call to test exception block 
        
        TaxCreateSSDMockHttpResponseGenerator.respBody = '{"BOOMIHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":null,"access_token": "DtOdJzb5sjdWBpqcvWyGTmGdRYTR","expires_in": "3599","token_type": "Bearer" ,"StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}';
        //APTS_CreateSSDJSON2ApexResponseBOOMI.parse('{"BoomiHeader":{"applicationId":"SF12"},"customerNumber":"1005215581","prevAcct":"asdd","StatusDetails ":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}');
        testCov.context = new APTS_CreateSSDJSON2ApexBOOMI.context();
        testCov.context.allowAdminEmails='test';
        testCov.context.requestor='test';
        testCov.context.userId='test';
        testCov.context.accountType='test';
        testCov.context.emailAddress='test';
        testCov.context.internalUser=true;
        testCov.context.fax='test';
        testCov.context.adminName='test';
        testCov.context.extension='test';
        testCov.context.adminEmail='test';
        testCov.context.phone='test';
        testCov.context.alternateEmailAddress='test';
        testCov.context.middleName='test';
        testCov.context.lastName='test';
        testCov.context.firstName='test';
        testCov.context.name='test';
        testCov.context.internalUserId='test';
        testCov.context.mobilePhone='test';
        
        
        
        testCov.BOOMIHeader= new APTS_CreateSSDJSON2ApexBOOMI.BOOMIHeader();
        testCov.BOOMIHeader.postBackURL='test';
        testCov.BOOMIHeader.timeStamp='test';
        testCov.BOOMIHeader.instanceId='test';
        testCov.BOOMIHeader.tracingId='test';
        testCov.BOOMIHeader.companyId='test';
        testCov.BOOMIHeader.messageHistory='test';
        testCov.BOOMIHeader.configGroup='test';
        testCov.BOOMIHeader.messageId='test';
        testCov.BOOMIHeader.payloadVersion='test';
        testCov.BOOMIHeader.transactionId='test';
        testCov.BOOMIHeader.profileId='test';
        
        testCov.customer= new APTS_CreateSSDJSON2ApexBOOMI.customer();
        List<APTS_CreateSSDJSON2ApexBOOMI.complianceJobRole> compList = new List<APTS_CreateSSDJSON2ApexBOOMI.complianceJobRole> ();
        
        APTS_CreateSSDJSON2ApexBOOMI.complianceJobRole cmjob = new APTS_CreateSSDJSON2ApexBOOMI.complianceJobRole();
        cmjob.Id ='test';
        cmjob.description='test';
        
        List<APTS_CreateSSDJSON2ApexResponseBOOMI.StatusDetails> stdt = new List<APTS_CreateSSDJSON2ApexResponseBOOMI.StatusDetails>();
        APTS_CreateSSDJSON2ApexResponseBOOMI.StatusDetails std= new APTS_CreateSSDJSON2ApexResponseBOOMI.StatusDetails();
        std.statusCode='test';
        std.statusDescription='test';
        std.statusMessage='test';
        
        List<APTS_CreateSSDJSON2ApexBOOMI.billingAllocation> billList = new List<APTS_CreateSSDJSON2ApexBOOMI.billingAllocation> ();
        APTS_CreateSSDJSON2ApexBOOMI.billingAllocation billalloc = new APTS_CreateSSDJSON2ApexBOOMI.billingAllocation();
        billalloc.orderLineNumber='test';
        billalloc.allocationPercentage='test';
        billalloc.allocationAmount='test';
        billalloc.purchOrderNumber='test';         
        
        
        List<APTS_CreateSSDJSON2ApexBOOMI.extensibleAttributes> extList = new List<APTS_CreateSSDJSON2ApexBOOMI.extensibleAttributes> ();
        APTS_CreateSSDJSON2ApexBOOMI.extensibleAttributes extattr = new APTS_CreateSSDJSON2ApexBOOMI.extensibleAttributes();
        extattr.key='test';
        extattr.value='test';
        extattr.systemIdentifier='test';
        extattr.description='test';
        
        testCov.customer.isPrimary=true;
        testCov.customer.externalAccountId='test';
        //testCov.customer.industryCode='test';
        testCov.customer.accountCustomerAddressID='test';
        testCov.customer.parentAccountNumber='test';
        testCov.customer.relationshipModel='test';
        testCov.customer.accountType='test';
        testCov.customer.merchantCategoryClassificationCode='test';
        //testCov.customer.companyName='00';
        testCov.customer.segment='test';
        testCov.customer.companyId='1078';
        testCov.customer.applyDate='test';
        testCov.customer.accountNumber='test';
        testCov.customer.accountStatus='test';
        testCov.customer.hierarchyType='test';
        testCov.customer.KNOwned='test';
        //testCov.customer.vatCode='test';
        testCov.customer.accountGroup='test';
        testCov.customer.partnerType='test';
        testCov.customer.accountClass='test';
        testCov.customer.complianceJobRole=compList;
        testCov.customer.primaryBillingNumber='test';
        //testCov.customer.jurisdictionCode='test';
        testCov.customer.legacyThomsonCustomerId='test';
        //testCov.customer.taxCodeType='test';
        testCov.customer.customerJourney='test';
        testCov.customer.lastUpdatedDate='test';
        testCov.customer.website='test';
        testCov.customer.action='test';
        testCov.customer.companySize='test';
        testCov.customer.digitalFirm='test';
        testCov.customer.locationAccountNumber='test';
        testCov.customer.accountSSDId='test';
        testCov.customer.accountSSDName='test';
        testCov.customer.accountSSDNumber='test';
        testCov.customer.currency_x='test'; 
        testCov.customer.language='test';
        testCov.customer.legalStatus='test';
        testCov.customer.altKN='test';
        //testCov.customer.salesOrg='test';
        testCov.customer.sourceOrTargetReferenceNumber='test';
        //testCov.customer.distributionChannel='test';
        testCov.customer.isActive=true;
        //testCov.customer.division='00';
        testCov.customer.TerritoryNumber='test';
        testCov.customer.creditRiskCategory='test';
        testCov.customer.trAccountClass='test';
        testCov.customer.preferredLanguage='test';
        testCov.customer.accountDirectorID='test';
        testCov.customer.accountDirectorName='test';
        testCov.customer.ownerId='test';
        testCov.customer.ownerName='test';
        testCov.customer.locationCountry='test';
        testCov.customer.ultimateParentAccountNumber='test';
        testCov.customer.accountClassification='test';
        testCov.customer.tenancyName='test';
        //testCov.customer.companyCode='test';
        testCov.customer.accountName='test';
        testCov.customer.campaignId='test';
        testCov.customer.reasonToEndJourney='test';
        testCov.customer.isRecordFound='test';
        testCov.customer.accountId='test';
        testCov.customer.businessUnit='test';
        testCov.customer.businessChannel='test';
        //testCov.customer.taxCode2='test';
        //testCov.customer.taxCode1 ='test';
        testCov.customer.licenseId='test';
        testCov.customer.isUnderMaintenance=true;
        testCov.customer.curency='test'; 
        
        testCov.customer.Companyname='test';  
        testCov.customer= new APTS_CreateSSDJSON2ApexBOOMI.customer();             
        
        List<APTS_CreateSSDJSON2ApexBOOMI.address> addressList = new List<APTS_CreateSSDJSON2ApexBOOMI.address>();
        APTS_CreateSSDJSON2ApexBOOMI.address addressObject = new APTS_CreateSSDJSON2ApexBOOMI.address();
        addressObject.region='test';
        //addressObject.street1='test';
        //addressObject.street2 ='test';
        // addressObject.street3 ='test';
        //addressObject.city ='test';
        //addressObject.country ='test';
        // addressObject.firstName=null;
        // addressObject.postalCode ='test';
        addressObject.poBox ='test';
        //addressObject.district='test';
        addressObject.street4='test'; 
        addressObject.billingAddress='test'; 
        addressObject.title='test'; 
        //addressObject.county='test';
        addressObject.emailAddress='test';
        addressObject.isPhysicalAddress='test';
        addressObject.mobilePhone='test';
        addressObject.extension='test';
        addressObject.alternateEmailAddress='test';
        addressObject.building='test';
        //addressObject.name='test';
        addressObject.floor='test';
        addressObject.room='test';
        addressObject.externalContactId='test';
        
        // Create a new email and envelope object
        /* Messaging.InboundEmail email = new Messaging.InboundEmail();
Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

// Create the email body
email.plainTextBody = 'This should become a note';
email.fromAddress ='test@test.com';
email.ccAddresses = new String[] {'taxsapcustomerquotecreationservice@1ljcwny3fx45xse6od26ny473k07xdehs8y4lhxp1pli9x2v43.2f-8efoeaq.cs34.apex.sandbox.salesforce.com'};
// email.subject = 'CreateSoldToTaxCustomer:>'+oProposal.Id+':'+SSD.Id;
TaxSAPCustomerQuoteCreateServiceHandler oTestEmailHandler = new TaxSAPCustomerQuoteCreateServiceHandler ();
Messaging.InboundEmailResult oTestResult = new Messaging.InboundEmailresult();
//oTestResult = oTestEmailHandler.handleInboundEmail(email, env);


CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(SSD.Id,oProposal.Id);*/
        Test.stopTest();
    }    
    
    public static testMethod void testCreateCustomerTax2() {
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        
        KeyValueListStore__c keyvaluestore2=new  KeyValueListStore__c();
        keyvaluestore2.Name='BOOMIProductId';
        keyvaluestore2.TextValue__c='SF12';
        
        List<KeyValueListStore__c> keyvaluelist = new List<KeyValueListStore__c>{keyvaluestore,keyvaluestore1,keyvaluestore2};
        insert keyvaluelist;
        
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
        recordtype2.Name='GLI Pipeline Opportunity';
        recordtype2.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype2);
        
        insert recordlist;
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = System.Label.APTS_OC_Test_Id);
        insert plist;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='CreateCustomerBOOMI',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://test.salesforce.com/services/Soap/c/38.0/',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://na68.salesforce.com/services/Soap/class/ProposalPaymentStatusPostBack',Service_Unavailable_Message__c='Service not Available'),new WebServiceSettings__c(Name='OrderSubmission',Endpoint__c='https://na68.salesforce.com/services/Soap/class/ProposalPaymentStatusPostBack',Service_Unavailable_Message__c='Service not Available'),new WebServiceSettings__c(Name='Create Tax Account SSD',Endpoint__c='https://na68.salesforce.com/services/Soap/class/ProposalPaymentStatusPostBack',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='CustomerReviewPostbackURL',Endpoint__c='https://cs64.salesforce.com/services/Soap/class/ProposalPaymentStatusPostBack',Service_Unavailable_Message__c='Service not Available')
            //new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://cs64.salesforce.com/services/Soap/class/ProposalCCTokenPostBack',Service_Unavailable_Message__c='Service not Available')
            };
            
        insert webserviceList;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
        cont.FirstName='Navpreet';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        List<IXOSCodeMap__c> ixocodeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='S100',Company_Code__c='1078',Dist_Chan_Code__c='00',Division_Code__c='00',Sales_Org_Code__c='S100')};
        insert ixocodeList;
        
        Country_Region__c cregion = new Country_Region__c (name='Test',Country_Code__c='US',Region_Code__c='CAgd',Region_Name__c ='cal');
        insert cregion;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        accountSSD.Source_System_Account_Number__c='123647';
        accountSSD.Number_Street__c = 'test';
        accountSSD.City__c = 'test';
        accountSSD.Country__c = 'IN';
        accountSSD.Postal_Code__c = '4563';
        accountSSD.LCRM_Sales_Org__c = 'S100';
        insert accountSSD;
        System.assertEquals(true,accountSSD!=null);
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.CurrencyIsoCode = 'ARS';
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        insert proposal;    
        
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf2', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=proposal.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
        insert prodConf2;
        
        
        Product2 prod = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',APTS_Cat_L2__c=label.APTS_Clear_Product_Family);
        prod.APTS_Approval_Always_Required__c = true;
        insert prod;
        
        Apttus_Config2__ConfigSystemProperties__c configSetting=new Apttus_Config2__ConfigSystemProperties__c(Name='System Properties',Apttus_Config2__DisableConstraintRules__c=true);
        insert configSetting;
        
        List<Apttus_Config2__LineItem__c> listOfLineItems = new List<Apttus_Config2__LineItem__c>();        
        
        Apttus_Config2__LineItem__c li6 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li6.Apttus_Config2__AddedBy__c = 'User';
        li6.Apttus_Config2__AdjustedPrice__c = 50;
        li6.Apttus_Config2__AdjustmentAmount__c = 50;
        li6.Apttus_Config2__AdjustmentType__c = '% Discount';
        li6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li6.Apttus_Config2__AllowProration__c = FALSE;
        li6.Apttus_Config2__AllowRemoval__c = TRUE;
        li6.Apttus_Config2__AutoRenew__c = FALSE;
        li6.Apttus_Config2__BaseExtendedCost__c = 0;
        li6.Apttus_Config2__BaseExtendedPrice__c = 100;
        li6.Apttus_Config2__BasePrice__c = 100;
        li6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li6.Apttus_Config2__ConfigStatus__c = 'Complete';
        li6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li6.Apttus_Config2__Customizable__c = FALSE;
        li6.Apttus_Config2__DeltaPrice__c = 50;
        li6.Apttus_Config2__DeltaQuantity__c = 1;
        li6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li6.Apttus_Config2__ExtendedCost__c = 0;
        li6.Apttus_Config2__ExtendedPrice__c = 100;
        li6.Apttus_Config2__Frequency__c = 'Monthly';
        li6.Apttus_Config2__Guidance__c = 'Red';       
        li6.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li6.Apttus_Config2__ItemSequence__c = 1;
        li6.Apttus_Config2__LineNumber__c = 1;
        li6.Apttus_Config2__LineSequence__c = 1;
        li6.Apttus_Config2__LineStatus__c = 'New';
        li6.APTS_Yr_1_Renewal_Adjustment__c='1';
        li6.Apttus_Config2__LineType__c = 'Product/Service';
        li6.Apttus_Config2__ListPrice__c = 100;
        li6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li6.Apttus_Config2__NetPrice__c = 50;
        li6.Apttus_Config2__NetUnitPrice__c = 50;
        li6.Apttus_Config2__OptionSequence__c = 0;        
        li6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li6.Apttus_Config2__PriceType__c = 'Recurring';
        li6.Apttus_Config2__PriceUom__c = 'Attorneys';
        li6.Apttus_Config2__PricingStatus__c = 'Complete';       
        li6.Apttus_Config2__Quantity__c = 1;
        li6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li6.Apttus_Config2__SellingTerm__c = 1;        
        li6.Apttus_Config2__Taxable__c = FALSE;
        li6.Apttus_Config2__TaxInclusive__c = FALSE;
        li6.Apttus_Config2__Term__c = 1;
        li6.Apttus_Config2__TotalQuantity__c = 1;
        li6.Apttus_Config2__Uom__c = 'Each';        
        li6.CurrencyIsoCode = 'CAD';
        li6.APTS_Contract_Term__c = '2 Years';
        li6.APTS_Years_2_Plus_Adjustment__c = '5';
        li6.Apttus_Config2__IncentiveCode__c = '13843012,13843012';
        li6.APTS_Bridge__c='1 Month';                  
        listOfLineItems.add(li6);
        
        Apttus_Config2__LineItem__c li7 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf2.id , Apttus_Config2__ProductId__c=prod.id);
        li7.Apttus_Config2__AddedBy__c = 'User';        
        li7.Apttus_Config2__BasePrice__c = 100;
        li7.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li7.Apttus_Config2__ConfigStatus__c = 'Complete';        
        li7.Apttus_Config2__Frequency__c = 'Monthly';        
        li7.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        li7.Apttus_Config2__ItemSequence__c = 1;
        li7.Apttus_Config2__LineNumber__c = 1;
        li7.Apttus_Config2__LineSequence__c = 1;
        li7.Apttus_Config2__LineStatus__c = 'New';
        li7.APTS_Yr_1_Renewal_Adjustment__c='1';
        li7.Apttus_Config2__LineType__c = 'Product/Service';
        li7.Apttus_Config2__ListPrice__c = 100;        
        li7.Apttus_Config2__NetPrice__c = 50;
        li7.Apttus_Config2__NetUnitPrice__c = 50;        
        li7.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li7.Apttus_Config2__PriceType__c = 'Recurring';
        li7.Apttus_Config2__PriceUom__c = 'Each';
        li7.Apttus_Config2__PricingStatus__c = 'Complete';
        li7.Apttus_Config2__PrimaryLineNumber__c = 1;
        li7.Apttus_Config2__ProductVersion__c = 1;        
        li7.Apttus_Config2__Quantity__c = 1;
        li7.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li7.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li7.Apttus_Config2__SellingTerm__c = 1;                               
        li7.Apttus_Config2__TotalQuantity__c = 1;
        li7.Apttus_Config2__Uom__c = 'Each';
        li7.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li7.CurrencyIsoCode = 'USD';
        li7.APTS_Contract_Term__c = '1 Year';
        li7.APTS_Years_2_Plus_Adjustment__c = '5';
        li7.APTS_Bridge__c = '2 Months';
        listOfLineItems.add(li7);
        
        insert listOfLineItems;
        
        prodConf2.Apttus_Config2__Status__c = 'Finalized';
        update prodConf2;
        
        Test.startTest();
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Create the email body
        /*email.plainTextBody = 'This should become a note';
email.fromAddress ='test@test.com';
email.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
email.subject = 'SalesTaxIntegration:>'+prodConf2.Id;
TaxSAPCustomerQuoteCreateServiceHandler oTestEmailHandler = new TaxSAPCustomerQuoteCreateServiceHandler ();
Messaging.InboundEmailResult oTestResult = new Messaging.InboundEmailresult();
oTestResult = oTestEmailHandler.handleInboundEmail(email, env);


Tax_SalesTaxFromDellBoomi.triggerSalesTax(prodConf2.Id);*/
        
        // Create the email body
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        email.ccAddresses = new String[] {'sapquotecreation@m-27qvut4jdjntz8djm7d9jbgfbw2qd3hmp2rgyhfdy46ucrmste.q-5ncfma2.q.apex.sandbox.salesforce.com'};   
            //email.ccAddresses = new String[] {'taxsapcustomerquotecreationservice@1ljcwny3fx45xse6od26ny473k07xdehs8y4lhxp1pli9x2v43.2f-8efoeaq.cs34.apex.sandbox.salesforce.com'};
            //email.subject = 'CreateSoldToTaxCustomer:>'+prodConf2.Id;
            //email.subject = 'CreateSoldToTaxCustomer:>'+prodConf2.Apttus_QPConfig__Proposald__c+':'+prodConf2.APTS_SSD_Sold_To__c;
            //TaxSAPCustomerQuoteCreateServiceHandler oTestEmailHandler1 = new TaxSAPCustomerQuoteCreateServiceHandler ();
            Messaging.InboundEmailResult oTestResult = new Messaging.InboundEmailresult();
        //oTestResult = oTestEmailHandler1.handleInboundEmail(email, env);
        
        
        CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(accountSSD.Id,proposal.Id);
        Test.stopTest();
        
    }
    
    
    @isTest
    public static void  testResponse(){    
        String s= '{"APTS_CreateSSDJSON2ApexResponseBOOMI ":{"customerNumber":"1005215582","prevAcct":null,"BOOMIHeader": {"applicationId":"SF22"},"StatusDetails":[{"statusCode":"200","statusDescription":"Success","statusMessage":"string"}]}}';
        APTS_CreateSSDJSON2ApexResponseBOOMI obj = APTS_CreateSSDJSON2ApexResponseBOOMI.parse(s);
        System.assertEquals(String.isBlank(s),false);
    }
    
    
}