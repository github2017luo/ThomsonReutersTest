@isTest
public class DCP_NonTrailTest {
    
    @testSetup static void setup() {
        Apttus_Config2__PriceList__c priceList1 = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList1;
        
        Pricebook2 pbook = new Pricebook2();
        pbook.name = 'GLI Price Book - US Legal/LMS';
        insert pbook;
        
        KeyValueListStore__c testKeyValueSetting= new KeyValueListStore__c();
        testKeyValueSetting.name = 'ANZUsersProfileId';
        testKeyValueSetting.TextValue__c = System.Label.Digital_ANZ_User_Profile_Id;    
        insert testKeyValueSetting;
        
        List<RecordtypeIds__c> rectype = new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtypeIds = new RecordtypeIds__c();
        recordtypeIds.name = 'Pre-Pipeline Opportunities';
        recordtypeIds.recTypeId__c = System.Label.Digital_ANZ_User_Profile_Id;    
        rectype.add(recordtypeIds);
        
        RecordtypeIds__c recordtypeIds1 = new RecordtypeIds__c();
        recordtypeIds1.name = 'Pipeline Opportunities';
        recordtypeIds1.recTypeId__c = System.Label.Digital_ANZ_User_Profile_Id;    
        rectype.add(recordtypeIds1);
        insert rectype;
        
        
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{
              new WebServiceSettings__c(
                    Name='EnterpriseWSDL',
                    Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                    Service_Unavailable_Message__c='Service not Available'),
                new WebServiceSettings__c(
                    Name='StatusPostbackLocation', 
                    Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                    Service_Unavailable_Message__c='Service not Available'),
                new WebServiceSettings__c(
                    Name='PostbackLocation', 
                    Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                    Service_Unavailable_Message__c='Service not Available'),
                new WebServiceSettings__c(
                    Name='Payment AutoCharge', 
                    Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',
                    Service_Unavailable_Message__c='Service not Available')
        };
        insert webserviceList;
        
        APTSECOM_Store__c store1 = DCTestData.createStore('Small Law', null, priceList1.Id);
        //store1.Non_TrailPassword_Promotion_Number__c = '1016';
        store1.APTSECOM_Customer_Pricing_Segment__c = 'Law Firm';
        insert store1;
        
        DateTime myDateTime = DateTime.now();
        System.debug(LoggingLevel.INFO,'myDateTime.millisecond() ? ' + myDateTime.getTime());
        Account acc1 = DCTestData.createAccount('Test Account');
        acc1.SAPAccountNumber__c = null; //String.valueOf( myDateTime.getTime() );
        insert acc1;
    }
    
    @isTest static void test(){
        String optyName = 'TestOpty';
        String stageName = 'Order Complete'; 
        Date closeDate = System.Today() + 30;
        String accountName = 'TestAccount';
        Account acc = DCTestData.createAccount(accountName);
        insert acc;
        
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Opportunity opty = DCTestData.createOpportunityRec(optyName, acc.Id,  stageName,  closeDate, String.valueOf(ssd.Id) );
        insert opty;
        
        Contact con = DCTestData.createContactRec('Test name',acc.id);
        insert con; 
        
        LCRM_Contact_SSD__c conSSD = DCTestData.createContactSSD(con, ssd);
        System.debug(LoggingLevel.INFO,' *< conSSD > ' + conSSD);
        
        Product2 prodObj = new Product2();
      prodObj.Name = 'SL California Analytical (Westlaw PRO™)';
        insert prodObj;
        
        Apttus_Proposal__Proposal__c proposal = DCTestData.createQuote(acc.id, 'New Sales');
        proposal.Apttus_Proposal__Opportunity__c = opty.id;
        proposal.APTS_Customer_Pricing_Segment__c = 'Law Firm';
        proposal.TR_Store_Source__c = 'TR Store US Print';
        insert proposal;
        
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal2 = DCTestData.createQuote(acc.id, 'Manual');
        proposal2.Apttus_Proposal__Opportunity__c = opty.id;
        proposal2.APTS_Customer_Pricing_Segment__c = 'Law Firm';
        proposal2.TR_Store_Source__c = 'TR Store US Print';
        insert proposal2;
        
        Apttus_Proposal__Proposal_Line_Item__c li = DCTestData.createProposalLineItem('2333545',prodObj.id, proposal2.id);
        insert li;

        //Test.startTest();
        WebServiceSettings__c settings = new WebServiceSettings__c(
            Service_Unavailable_Message__c='Incentive passwords not available',
            Name='Incentive Passwords',
            Timeout__c=120.0, 
            Endpoint__c='https://api-uat.thomsonreuters.com/boomi/registrationservice/uat/v1',
            Username__c='SFDCTEST', 
            Password__c='sfdcte$t', 
            Active__c=true
        );
        insert settings;
        
        IncentivePromoTypes__c oIncentivePromoTypes = new IncentivePromoTypes__c();
        oIncentivePromoTypes.Name = 'WestlawNext';
        oIncentivePromoTypes.DomainName__c = 'test';
        oIncentivePromoTypes.CompanyCode__c = 'test';
        oIncentivePromoTypes.Type__c = 'test';
        insert oIncentivePromoTypes;
        List<Id> propoId = new List<Id>();
        propoId.add(proposal.Id);
        DCP_NonTrail.getqid(propoId);
        system.assertEquals(proposal.Apttus_Proposal__Opportunity__c,opty.id,'');
        
        DCP_NonTrail.promotionCall(proposal2.Id);
        Test.stopTest();
    }
    
    
}