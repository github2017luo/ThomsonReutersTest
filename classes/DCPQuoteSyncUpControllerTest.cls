@isTest(seeAllData=false)
public class DCPQuoteSyncUpControllerTest {
    /**
     *  @description testData to run the data
     */
    public static testMethod void testData(){
        
        // insert static value
        
        DCPTestDataFactory.disableApplicationAutomation();
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePELeadConvertCode', value__c='LeadConvert'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='TRStorePEOrderConfirmationCode', value__c='OrderConfirmation'),
            new Static_Values__c(name='LeadSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='OrderProcessSupportEmail', value__c='kanishk.singhvi@thomsonreuters.com'),
            new Static_Values__c(name='DocusignDelayTimer', value__c='3')
        
            };
        insert staticCSList;
        
        LTS_Disable_Application_Automation__c lts = new LTS_Disable_Application_Automation__c(LTS_Disable_Process_Builders__c=true, LTS_Disable_Validation_Rules__c=true);
         insert lts;
           
        Profile p = [SELECT Id FROM Profile WHERE Name = 'ANZ Users' LIMIT 1];
        User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'AND Profile.id =:p.id limit 1];
        LIST<KeyValueListStore__c> keyValueList = new LIST<KeyValueListStore__c>();
        KeyValueListStore__c kv = new KeyValueListStore__c(TextValue__c=p.id, name='ANZUsersProfileId' );
         KeyValueListStore__c kv1 = new KeyValueListStore__c(TextValue__c='Content,Functionality', name='ReasonWithCompetitor');
        keyValueList.add(kv);
        keyValueList.add(kv1);
        insert keyValueList;
        
        string rtId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        string rtId2 = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        LIST<RecordtypeIds__c> rtIds = new LIST<RecordtypeIds__c >();
        
        RecordtypeIds__c rt = new RecordtypeIds__c(name='Pre-Pipeline Opportunities', recTypeId__c =rtId); 
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name='Pipeline Opportunities', recTypeId__c =rtId2); 
        rtIds.add(rt);
        rtIds.add(rt2);        
        insert rtIds;
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                
                insert WebserviceList;
        
        Pricebook2 pbook = new Pricebook2();
        pbook.name =  'GLI Price Book - US Legal/LMS';        
        pbook.IsActive = true;
        insert pbook;
        
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
        prodConfigObj.Apttus_QPConfig__Proposald__c = propObj.ID;
        prodConfigObj.Apttus_Config2__BusinessObjectRefId__c =propObj.ID;
        prodConfigObj.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        insert prodConfigObj;
        
        // insert acc
        Account acc =APTS_TestDataFactory.createAccount('Test');
        Insert acc;
        
        /*//Create AccountSSD record
        Source_System_Detail__c accSSD = new Source_System_Detail__c();
        accSSD.Name = 'Test Account SSD';
        accSSD.Source_System_Name__c = 'Test System';
        accSSD.Source_System_Account_Number__c = '173468930';
        accSSD.Account_Name__c = acc.id;
        //accSSD.Trial_Status__c = '';
        //accSSD.LCRM_Market_Segment__c = 'SLF 4-6';
        insert accSSD;*/
        
        // insert ssd
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();        
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                                                        LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                                                        LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                                                        City__c='TestCity',State__c='ON',Country__c='CA',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');  
        insert accountSSD;
        
        Source_System_Detail__c accountSSD1= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABCD',Source_System_Name__c='ABCD',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                                                        LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                                                        LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                                                        City__c='TestCity',State__c='ON',Country__c='CA',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');  
        insert accountSSD1;
        
        // insert contact
        contact con = APTS_TestDataFactory.createContact('test',acc.id);
        con.FirstName='Amy';
        insert con ;
        
        //create opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.closeDate = System.Today() + 5;
        opp.recordTypeId = rt.recTypeId__c;
        opp.Owner = u;
        opp.StageName='Prospect';
        opp.AccountId = acc.Id;
        opp.Pricebook2id = pbook.id ;
        opp.Source_System_Detail__c = accountSSD.Id;
        opp.ShipTo_Source_System_Detail__c = accountSSD1.id;
        opp.Is_Digital_New_Sales__c = true;
        opp.Renewal_Date__c = Date.Today().addDays(100);
        insert opp;
        
        Apttus__APTS_Template__c newTemplate1 = new Apttus__APTS_Template__c();
        newTemplate1.Name = System.Label.Digital_OF;
        newTemplate1.Apttus__IsActive__c = TRUE;
        newTemplate1.Apttus__Type__c = 'Proposal';
        newTemplate1.Apttus__ReferenceId__c = '0db18264-424c-a7fa-5058-680a594f5189';
        newTemplate1.Apttus__Agreement_Types__c = 'Default;Proposal;RFP';
        newTemplate1.Apttus__FrameworkFormat__c = 'FX2';
        Insert newTemplate1;
        
        // insert lead
        lead ld = new lead();
        ld.FirstName='Amy';
        ld.Lead_region__c='TR Store Canada Print';
        ld.LastName='anto';
        ld.Email='testfirst.testfirst@test.com';        
        ld.IsConverted=true;
        ld.Company='TCS';
        ld.Product_Configuration__c=prodConfigObj.Id;
        ld.ConvertedAccountId =acc.id;
        ld.ConvertedContactId=con.id;
        ld.ConvertedOpportunityId=opp.id;
        insert ld;
        
         // insert lead
        lead ld2 = new lead();
        ld2.FirstName='Test';
        ld2.LastName='Lead';
        ld2.Email='testfirst.testlast@test.com';        
        ld2.IsConverted=true;
        ld2.Company='TCS';
        ld2.Product_Configuration__c=prodConfigObj.Id;   
        ld2.Billing_Street__c = 'Banito Blanco 822';
        ld2.Billing_City__c = 'New Yark';
        ld2.Billing_State__c = 'New yark';
        ld2.Billing_Country__c ='United States';
        ld2.Billing_Zip__c = '51123';
        ld2.TRstore_Billadd_differenceto_shipping__c = true;
        ld2.Street = 'Banito Blanco 823';
        ld2.City = 'Toronto';
        ld2.State = 'ON';
        ld2.Country ='CA';
        ld2.PostalCode = '12345';
        ld2.SAPAccountNumber__c = '';
        ld2.Is_GLI__c=true;
        ld2.ConvertedAccountId =acc.id;
        ld2.ConvertedContactId=con.id;
        ld2.ConvertedOpportunityId=opp.id;
        insert ld2;
        
        Ent_Trial__c trl= new  Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Opportunity__c = opp.id;
        trl.lead__c = ld.id;
        //trl.Contact__c = con.id;
        trl.Trial_Status__c = 'Active';
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        insert trl; 
        
         Online_Contacts__c onlineContact = new Online_Contacts__c();
                        
                        onlineContact.First_Name__c = 'pFirstName';
                        onlineContact.Last_Name__c = 'pLastName';
                        onlineContact.Email__c = 'pEmail@mailinator.com';
                        onlineContact.WLEc_Juris__c = 'jurisdiction';
                        onlineContact.Position__c = 'pTitle';                        
                        onlineContact.Type__c = 'pType';

                        onlineContact.Lead__c = ld.Id;
                        onlineContact.Product_Configuration__c = prodConfigObj.id; 
           
           insert       onlineContact;        
        
        Customer_Master_Contacts__c  msd = new Customer_Master_Contacts__c();
        msd.First_Name__c = 'FirstName';
                        msd.Last_Name__c = 'pLastName';
                        msd.Email_Address__c = 'pEmail@mailinator.com';
                        msd.Lead__c = ld.Id;
                        msd.Material__c = '25478';
                        
                        
                        insert msd;
        
        
        ContentVersion contentVer = new ContentVersion();
        contentVer.ContentLocation = 'S';
        contentVer.Title = String.valueOf('Order Form Test Content Version');
        contentVer.PathOnClient = String.valueOf('Test PathOnClient');
        contentVer.versiondata = EncodingUtil.base64Decode('Test versionData');
        contentVer.Legacy_ParentId__c = propObj.id; // use this field to tie the content version to the proposal
        insert contentVer;
        contentVer = [SELECT id, ContentDocumentId FROM ContentVersion WHERE Title = 'Order Form Test Content Version' LIMIT 1];

        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = contentVer.ContentDocumentId;
        contentDocLink.LinkedEntityId  = propObj.id;
        insert contentDocLink;

        // default DocuSign user record        
        Apttus_DocuApi__DocuSignUser__c oDocuSign = new Apttus_DocuApi__DocuSignUser__c();
        oDocuSign.Apttus_DocuApi__DocuSignAccountId__c = '1970775';
        oDocuSign.Apttus_DocuApi__Default__c = TRUE;
        insert oDocuSign;
        
        // create web service setting for DocuSign Connection
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'Digital DocuSign Connection';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        insert web;
       
        Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
        envelope.Apttus_DocuApi__ParentId__c = propObj.id;
        envelope.Apttus_QPDSign__QuoteProposal__c = propObj.id;
        envelope.Apttus_DocuApi__EnvelopeId__c = 'someid';
        insert envelope;
        

        DCPConvertLeadHelperTwo.ProcessTRStoreWrapperDetails ptwd = new DCPConvertLeadHelperTwo.ProcessTRStoreWrapperDetails();
        ptwd.quoteId = propObj.Id;
        ptwd.cartId = prodConfigObj.Id;
        ptwd.leadId = ld.Id;
        ptwd.trialId = trl.Id;

        
        Test.startTest();
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        DCPQuoteSyncUpController.processTRStoreOrder(ptwd);
        DCPProcessDocusignController.generateDoc(propObj.Id);
        DCPProcessDocusignController.createEnv(propObj.Id);
        DCPNewSaleCompleteDocusignEnvelope.completeEnvelope('someid',propObj.Id);
        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'abc','webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'false'};
        DCPProcessDocusignController.logExceptions(errorHandlerMap);
        DCPQuoteSyncUpHelper.logExceptions(errorHandlerMap);

        Test.stopTest();
        DCPQuoteSyncUpHelper.mapMasterContact(ld.Id, propObj.Id);
        system.assert(ld.isConverted, 'inserted');
    }    
             
}