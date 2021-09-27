@isTest
public class DCPCreateDocusignEnvelope_Test {

    @TestSetup
    private static void makeData(){
        createDocusignTestData();
    }

    /**
        @description Method to create the necessary Docusign test data. 
        Called from other test classes that would leverage the same exact data without having to duplciate the code (ie. Rest Service classes)
     */
    public static void createDocusignTestData(){

        DCPTestDataFactory.disableApplicationAutomation();

        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        Account acc = (Account)objectToDataMap.get('Account');
        insert acc;
        Source_System_Detail__c ssd = (Source_System_Detail__c)objectToDataMap.get('Source_System_Detail__c');
        ssd.Account_Name__c = acc.id;
        insert ssd;
        Contact con = (Contact)objectToDataMap.get('Contact');
        con.AccountId = acc.id;
        insert con;
        PriceBook2 pricebook = (PriceBook2)objectToDataMap.get('PriceBook2');
        insert pricebook;
        Apttus_Config2__PriceList__c pricelist = (Apttus_Config2__PriceList__c)objectToDataMap.get('Apttus_Config2__PriceList__c');
        insert pricelist;
        Opportunity opp = (Opportunity)objectToDataMap.get('Opportunity');
        opp.StageName = 'Contacting';
        opp.Renewal_Date__c = system.today().addDays(180);
        opp.Pricebook2id = pricebook.id;
        opp.AccountId = acc.id;
        opp.Source_System_Detail__c = ssd.id;
        opp.Key_Contact__c = con.id;
        insert opp;
        Apttus_Proposal__Proposal__c prop = (Apttus_Proposal__Proposal__c)objectToDataMap.get('Apttus_Proposal__Proposal__c');
        prop.Apttus_Proposal__Primary__c = false;
        prop.Digital_Batch_Processed__c = true;
        prop.Digital_Quote_Automation__c = true;
        prop.Digital_Quote_Type__c = 'Straight Renewal';
        prop.Digital_Envelope_Created__c = false;    
        prop.Apttus_Proposal__Approval_Stage__c = 'Generated';
        prop.Apttus_Proposal__Opportunity__c = opp.id;
        prop.Apttus_Proposal__Account__c = acc.id;
        prop.APTS_SSD_bill_to__c = ssd.id;
        prop.APTS_SSD_ship_to__c = ssd.id;
        prop.Apttus_QPConfig__BillToAccountId__c = acc.id;
        prop.Apttus_QPConfig__ShipToAccountId__c = acc.id;
        prop.APTS_Order_Confirmation_Contact__c = con.id;
        prop.Apttus_QPConfig__PriceListId__c = pricelist.id;
        insert prop;

        ContentVersion contentVer = new ContentVersion();
        contentVer.ContentLocation = 'S';
        contentVer.Title = String.valueOf('Order Form Test Content Version');
        contentVer.PathOnClient = String.valueOf('Test PathOnClient');
        contentVer.versiondata = EncodingUtil.base64Decode('Test versionData');
        contentVer.Legacy_ParentId__c = prop.id; // use this field to tie the content version to the proposal
        insert contentVer;
        contentVer = [SELECT id, ContentDocumentId FROM ContentVersion WHERE Title = 'Order Form Test Content Version' LIMIT 1];

        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = contentVer.ContentDocumentId;
        contentDocLink.LinkedEntityId  = prop.id;
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
    }

    @isTest
    public static void envelopeCreationTest(){
        
        Test.startTest();   
        
        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Approval_Stage__c = 'Generated' LIMIT 1];
        Map<id,String> proposalToEnvelopeIdMap = DCPCreateDocusignEnvelope.createDocusignEnvelope(new List<id>{prop.id});
        system.Assert(proposalToEnvelopeIdMap.containsKey(prop.id) && String.isNotBlank(proposalToEnvelopeIdMap.get(prop.id)), 'Envelope not created');
        
        Test.stopTest();
    }
}