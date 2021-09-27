@isTest(seeAllData = false)
public class ODTDG_OrderStatusUpdateTest{
    @isTest private static void testMethod1(){
        
        Static_Values__c staVal1 = new Static_Values__c();
        staVal1.Name = 'Plan to Plan';
        staVal1.Value__c = 'Plan to Plan';
        insert staVal1;
        
        Static_Values__c staVal2 = new Static_Values__c();
        staVal2.Name = 'Order Submitted';
        staVal2.Value__c = 'Order Submitted';
        insert staVal2;
        
        Static_Values__c staVal3 = new Static_Values__c();
        staVal3.Name = 'TFMS Api';
        staVal3.Value__c = 'TFMS Api';
        insert staVal3;
        
        Static_Values__c staVal4 = new Static_Values__c();
        staVal4.Name = 'TRIAL_CONVERTION';
        staVal4.Value__c = 'TRIAL_CONVERTION';
        insert staVal4;
        
        Static_Values__c staVal5 = new Static_Values__c();
        staVal5.Name = 'LeadSupportEmail';
        staVal5.Value__c = 'sam@abc.com';
        insert staVal5;
        
        Static_Values__c staVal6 = new Static_Values__c();
        staVal6.Name = 'ODTDG_Tfms_Auth';
        staVal6.Value__c = 'callout:ODTDG_Tfms_Auth';
        insert staVal6;
        
        Account acc = new Account();
        acc.Name = 'test Account';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Industry = 'NOT APPLICABLE';
        acc.Industry_Code_1__c = 'NOT APPLICABLE';
        acc.Sales_Org__c='GLI';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'Contact';
        insert con;
        
        WebServiceSettings__c webser = new WebServiceSettings__c();
        webser.Name = 'TFMS Api';
        webser.Endpoint__c = 'https://boomi-dev.thomsonreuters.com/ws/rest/dep/product/sndr/v1/PendoMetadataAPI';
        webser.Password__c = 'FITDJMvpcG6hd6TKP2SWG47ulL9RDmdm3gc7Jjgq';
        webser.Username__c = 'd28db05f-9350-451b-8687-eaea8ebbec4e';
        webser.Service_Unavailable_Message__c = 'Service is unavailable';
        insert webser;
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        insert keyvaluestore;
        
        Source_System_Detail__c accSSD1 = new Source_System_Detail__c();
        accSSD1.Name = 'Test Account SSD1';
        accSSD1.Source_System_Name__c = 'Test System1';
        accSSD1.Source_System_Account_Number__c = '1734689302';
        accSSD1.Account_Name__c = acc.id;
        accSSD1.Trial_Status__c = '';
        accSSD1.LCRM_Market_Segment__c = 'SLF 4-6';
        insert accSSD1;

        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        pbook.IsActive = true;
        insert pbook;
        
        List<RecordtypeIds__c> recTypeLst = new List<RecordtypeIds__c>();

        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recTypeLst.add(recordtype);
        recTypeLst.add(recordtype1);
        insert recTypeLst;
        
        Id opptyRecorType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.RecordtypeId = opptyRecorType;
        opp.StageName = 'Prospect';
        opp.CloseDate = System.today()+5;
        opp.AccountId = acc.Id;
        opp.ContactId = con.Id;
        opp.Source_System_Detail__c = accSSD1.Id;
        opp.Sales_Org__c = 'West';
        insert opp;
        
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today()+7;
        trl.External_Account_Number__c = '4332938';
        trl.Opportunity__c = opp.Id;
        insert trl;
        
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlCon.Last_Name__c = 'NET_NEW';
        trlcon.Name= 'Test Name';
        trlcon.One_Pass_ID__c = 'onepassIdgdskjadkadsgaDGKGGSYHs';
        insert trlCon;

        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trl.id;
        trprd.Name= 'Test Name';
        trprd.Product_Offerings__c = 'Westlaw';
        trprd.Relationship_Type__c = 'Plan to Plan';
        insert trprd;    
        
        Trial_Product_Contact__c trialPrdCont= new Trial_Product_Contact__c();
        trialPrdCont.Trial_Contact__c = trlCon.id;
        trialPrdCont.Trial_Product__c = trprd.Id;
        trialPrdCont.Trials__c = trl.Id;
        insert trialPrdCont;
        
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Pending';
        order.APTS_SAP_Status__c = 'Pending';
        order.Apttus_Config2__RelatedOpportunityId__c = opp.Id;
        order.Apttus_Config2__OrderDate__c = System.today();
        insert order;
        System.assert(order.APTS_SAP_Status__c != null, 'Pending');

        order.APTS_SAP_Status__c = 'Order Submitted';
        update order;
        Test.setMock(HttpCalloutMock.class, new MockcalloutTest());
        
    }
    
    /**@description : used for mock callout */
    public class MockcalloutTest implements HttpCalloutMock
    {
        /**@description : used for mock callout
        @param req : Used to store JSON request structure
        @return HTTPResponse : Use to return response  */
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            string json= '[{\"producType\": \"WESTLAW EDGE\",\"trialId\":\"trialid12345678\"}]';        
            res.setBody(json);
            res.setStatusCode(400);
            return res;
       }  
	}
    
}