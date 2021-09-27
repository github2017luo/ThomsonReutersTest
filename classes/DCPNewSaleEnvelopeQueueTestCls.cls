@isTest
public class DCPNewSaleEnvelopeQueueTestCls {
    /**
     *  @description testData to run the data
     */
    public static testMethod void testData(){
        DCPTestDataFactory.disableApplicationAutomation();
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
           new Static_Values__c(name='OrderProcessSupportEmail', value__c='abc.abc@abc.com'),
            new Static_Values__c(name='DocusignDelayTimer', value__c='3')
            };
        insert staticCSList;
        System.assert(staticCSList != null, 'Inserted staticCSList');
        LTS_Disable_Application_Automation__c lts = new LTS_Disable_Application_Automation__c(LTS_Disable_Process_Builders__c=true, LTS_Disable_Validation_Rules__c=true);
         insert lts;
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
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
    DCPNewSaleCompleteEnvQueue sh1 = new DCPNewSaleCompleteEnvQueue(propObj.Id);
    DCPDocusignBatchController sh2 = new DCPDocusignBatchController(propObj.Id);
    String sch = '0 0 23 * * ?'; 
        system.schedule('Test CreateEnv Check', sch, sh1); 
        system.schedule('Test CompleteEnv Check', sch, sh2); 
        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'abc','webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'false'};
        DCPNewSaleCompleteEnvQueue.logExceptions(errorHandlerMap);
        DCPDocusignBatchController.logExceptions(errorHandlerMap);
        system.enqueueJob(new DCPDocusignDelayProcess(propObj.Id,'completeEnv'));
        
        //DCPNewSaleCompleteEnvQueue sh3 = new DCPNewSaleCompleteEnvQueue(null);
        //system.schedule('Test CreateEnv Check123', sch, sh3); 
        
        
        
        
        Test.stopTest(); 
    }
    
    private static testmethod void negativeTestCase(){
        DCPTestDataFactory.disableApplicationAutomation();
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
           new Static_Values__c(name='OrderProcessSupportEmail', value__c='abc.abc@abc.com'),
            new Static_Values__c(name='DocusignDelayTimer', value__c='3')
            };
        insert staticCSList;
        System.assert(staticCSList != null, 'Inserted staticCSList');
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        system.enqueueJob(new DCPDocusignDelayProcess(null,'sendDoc'));
        Test.StopTest();
    }
    
    private static testmethod void negativeTestCase1(){
        DCPTestDataFactory.disableApplicationAutomation();
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
           new Static_Values__c(name='OrderProcessSupportEmail', value__c='abc.abc@abc.com'),
            new Static_Values__c(name='DocusignDelayTimer', value__c='3')
            };
        insert staticCSList;
        System.assert(staticCSList != null, 'Inserted staticCSList');
        Test.StartTest();
        Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'abc','webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'false'};
        DCPNewSaleCreateEnvQueue.logExceptions(errorHandlerMap);
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        system.enqueueJob(new DCPDocusignDelayProcess(null,'createEnv'));
        Test.StopTest();
    }
        
}