/**
 * Test class 
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData
 * 2021-01-20   Brenda Shields          DLT-21352 [SFDC][ALL SEGMENTS][NSE]- Lead Primary Campaign Source - update for PMD violations                    
 * 2021-02-12   Kavya S                 DLT-21389 [SFDC][ALL SEGMENTS][NSE]- Desiginate Pure Digital Opportunities	       
 * =============================================================================
 */
 /** 
 * @description : Test class for Ecom_Account and Ecom_Opportunity
 */
@isTest
public class Ecom_Account_Test {
    
    @testSetup 
    static void setup() {
        Apttus_Config2__PriceList__c priceList = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Pricebook2 pbook = new Pricebook2();
        pbook.name =  'GLI Price Book - US Legal/LMS';
        insert pbook;
        
        KeyValueListStore__c testKeyValueSetting = new KeyValueListStore__c();
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
            new WebServiceSettings__c(Name='EnterpriseWSDL', Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation', Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation', Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge', Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount', Service_Unavailable_Message__c='Service not Available')
        };
                    
        insert webserviceList;
        
        Product2 p2 = DCTestData.createProduct('WestLaw Product', '42009581', '42009634', 'Arizona');
        system.debug(logginglevel.INFO, 'Product insert: ' + p2);
        
        APTSECOM_Store__c store = DCTestData.createStore('Small Law', null, priceList.Id);
        insert store;
        
        APTSECOM_Store__c corporate = DCTestData.createStore('CORPORATE', null, priceList.Id);
        corporate.APTSECOM_Customer_Pricing_Segment__c = 'CORPORATION';
        insert corporate;
             
        Apttus_Config2__Order__c od = DCTestData.createOrder(priceList.id, store.id);
        insert od;
        
        //DateTime myDateTime = DateTime.now();
        Account acc1 = DCTestData.createAccount('Test Account');
        acc1.SAPAccountNumber__c = null;  // String.valueOf( myDateTime.getTime() );
        insert acc1;
        
        Contact con = DCTestData.createContactRec('Test name', acc1.id);
        insert con;
    }

    @isTest
    static void smallLawAccountTest(){
        
        //Apttus_Config2__PriceList__c priceList = [SELECT Id FROM Apttus_Config2__PriceList__c limit 1];
        Account acc = [SELECT id, SAPAccountNumber__c FROM Account limit 1];
        Product2 p1 = [SELECT Id FROM Product2 limit 1];
        Contact con = [SELECT Id FROM Contact limit 1];
        
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);

        Opportunity opty = DCTestData.createOpportunityRec( 'TestOpty', acc.Id,  'Order Complete',  System.Today() + 30, String.valueOf(ssd.Id));
        insert opty;
        
        APTSECOM_Store__c store =  [SELECT Id, name, APTSECOM_Price_List__c, APTSECOM_Adjustment_Amount__c, APTSECOM_Adjustment_Type__c,APTSECOM_Customer_Pricing_Segment__c,APTSECOM_Default_Contract_Term__c,
                                               (SELECT Id,name,APTSECOM_Category_Hierarchy__c,APTSECOM_Adjustment_Type__c,APTSECOM_Adjustment_Amount__c 
                                                FROM Store_Price_Adjustments__r ), 
                                               (SELECT id,name,Adjustment_Amount__c,Adjustment_Type__c,Related_Category_Hierarchy__c,YoY_1__c, YoY_2__c, Contract_Term__c 
                                                FROM New_Sales_Contract_Term_Settings__r ),
                                                (SELECT id, APTSECOM_Adjustment_Amount__c,APTSECOM_Adjustment_Type__c,APTSECOM_Promo_Code__c 
                                                 FROM Store_Promotions__r )
                                           FROM APTSECOM_Store__c 
                                           WHERE name = 'Small Law' Limit 1];
        Ecom_OrderRequest.cls_storeOrder storeOrder = Ecom_OrderService_test.getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        
        Test.startTest();
        try{
         Source_System_Detail__c accSSD = Ecom_Account.createAccountSSD(acc.Id, opty.Id, storeOrder.customerDetails, store, 1); 
        
        Account accout = Ecom_Account.updateConvertedAccount(acc.Id, store, storeOrder); 
       
        Ecom_Contact.updateConvertedContact(con.Id, accSSD);
        Ecom_Contact.createContactSSD(accSSD, con.Id, storeOrder.customerDetails);
        system.assertNotEquals(accout, null, 'Account should not be null');
        }Catch(Exception ex){
        	system.debug(LoggingLevel.ERROR, 'Exception > '+ex);
        }
        Test.stopTest();
    }
    
    @isTest
    static void corporateAccountTest(){
        
        //Apttus_Config2__PriceList__c priceList = [SELECT Id FROM Apttus_Config2__PriceList__c limit 1];
        Account acc = [SELECT id,SAPAccountNumber__c FROM Account limit 1];
        Product2 p1 = [SELECT Id FROM Product2 limit 1];
 
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        
        Opportunity opty = DCTestData.createOpportunityRec( 'TestOpty', acc.Id,  'Order Complete',  System.Today() + 30, String.valueOf(ssd.Id));
        insert opty;
        
        APTSECOM_Store__c store =  [SELECT Id,name,APTSECOM_Price_List__c,APTSECOM_Adjustment_Amount__c,APTSECOM_Adjustment_Type__c,APTSECOM_Customer_Pricing_Segment__c,APTSECOM_Default_Contract_Term__c
                                           FROM APTSECOM_Store__c 
                                           WHERE name = 'CORPORATE' Limit 1];

        Ecom_OrderRequest.cls_storeOrder storeOrder = Ecom_OrderService_test.getRequest(p1.Id, 'CORPORATE', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        
        Test.startTest();
        try{
        	//Source_System_Detail__c accSSD= Ecom_Account.createAccountSSD(acc.Id, opty.Id, storeOrder.customerDetails, store, 1);
        	Account accout = Ecom_Account.updateConvertedAccount(acc.Id, store, storeOrder); 
        	system.assertNotEquals(accout, null, 'Account should not be null');
        }Catch(Exception ex){
        	system.debug(LoggingLevel.ERROR, 'Exception > ' + ex);
        }
        Test.stopTest();
    }
    
    
    @isTest
    public static void opportunityTest() {
        product2 p1 = [SELECT id FROM product2 limit 1];
        list<APTSECOM_Store__c> store = [SELECT Id,name,APTSECOM_Price_List__c,APTSECOM_Adjustment_Amount__c,APTSECOM_Adjustment_Type__c,APTSECOM_Customer_Pricing_Segment__c,APTSECOM_Default_Contract_Term__c,
                                       (SELECT Id,name,APTSECOM_Category_Hierarchy__c,APTSECOM_Adjustment_Type__c,APTSECOM_Adjustment_Amount__c 
                                        FROM Store_Price_Adjustments__r ), 
                                       (SELECT id,name,Adjustment_Amount__c,Adjustment_Type__c,Related_Category_Hierarchy__c,YoY_1__c, YoY_2__c, Contract_Term__c 
                                        FROM New_Sales_Contract_Term_Settings__r )
                                   FROM APTSECOM_Store__c  limit 1];
        Ecom_OrderRequest.cls_storeOrder storeOrder = Ecom_OrderService_test.getRequest(p1.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        
        //Apttus_Config2__PriceList__c priceList = [SELECT id FROM Apttus_Config2__PriceList__c limit 1];
        Account acc = [SELECT id,SAPAccountNumber__c FROM Account limit 1];
        
        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Contact con = [SELECT id,SAP_Contact_ID__c,SAP_Role__c,Email  FROM Contact limit 1]; 
    
        Date closeDate = System.Today() + 30;
        String optyName= 'TestOpty';
        Opportunity opty = DCTestData.createOpportunityRec(optyName, acc.Id, 'Order Complete', closeDate, String.valueOf(ssd.Id));
        insert opty;
        LCRM_Contact_SSD__c conSSD = DCTestData.createContactSSD(con, ssd);
        system.debug(logginglevel.INFO, 'Contact SSD: ' + conSSD);
        
        Test.startTest();
        
        Campaign c1=new Campaign();
      	c1.Name='test Campaign';
      	c1.RecordType=[select Id from RecordType where Name = 'GLI' and SobjectType = 'Campaign'];
      	c1.CurrencyIsoCode='USD';
      	Insert c1;
      	Id campid=c1.Id;
      	
      	// setup info to create lead history
      	APTSECOM_Store__c storess = [SELECT id FROM APTSECOM_Store__c LIMIT 1];
      	Apttus_Config2__PriceList__c priceList = [SELECT id FROM Apttus_Config2__PriceList__c LIMIT 1];
      	Apttus_Config2__Order__c order = DCTestData.createOrder(priceList.id, storess.id );
        insert order;

        Lead oLead = createLead(storeOrder, order.id);
        insert oLead;

        Ecom_Opportunity.updateConvertedOpportunity(opty.Id, con, ssd, UserInfo.getUserId(), storeOrder, 'leadDescription','leadtrackingcode',campid);
        Ecom_Opportunity.updateOpportunityForOrganizationchange(opty.Id, storeOrder.customerDetails);
        Ecom_Opportunity.createLeadHistory(acc.id, con.Id, opty.Id, UserInfo.getUserId(), oLead);
                
        LCRM_Contact_SSD__c contactSSD = [
            SELECT Id,LCRM_Contact__c,LCRM_Email__c, Name,LCRM_Account_SSD__c,LCRM_Account_SSD__r.Account_Name__c, LCRM_Account_SSD__r.LCRM_Customer_Group__c  
            FROM LCRM_Contact_SSD__c 
            WHERE LCRM_Contact__c =: con.Id
        ] ;
        
        List<Apttus_Proposal__Proposal__c> proposals = Ecom_ProposalService.proposalCreation(opty.Id, UserInfo.getUserId(), contactSSD, store[0],'Premium');   
        
        Apttus_Proposal__Proposal__c propRec = [
            SELECT Id,Name, DC_Contract_Not_In_Sync__c, Apttus_Proposal__Proposal_Name__c, APTS_Order_Confirmation_Contact_Email__c, Apttus_Proposal__Account__r.SAPAccountNumber__c,APTS_Quote_Value__c,
                Apttus_Proposal__Account__r.Name,APTS_Order_Confirmation_Contact_Name__c,Apttus_Proposal__Account__r.billingstreet,
                Apttus_Proposal__Account__r.billingcity,Apttus_Proposal__Account__r.billingstate,Apttus_Proposal__Account__r.billingcountry,
                Apttus_Proposal__Account__r.phone,Apttus_Proposal__Account__r.billingPostalCode ,APTS_Payment_Option__c 
            FROM Apttus_Proposal__Proposal__c 
            WHERE Id =: proposals[0].Id
        ];
        Ecom_ProposalService.encryption(propRec);
        system.assertNotEquals(propRec, null, 'Proposal should not be null');
        try {
            Ecom_OrderRequest.cls_References ref = new Ecom_OrderRequest.cls_References();
            ref.proposalId = propRec.Id;
            Ecom_ProposalService.updateProposalOnPlaceOrder(ref, storeOrder);
            
            Ecom_ProposalService.reprice(propRec.Id);    
        } catch(Exception ex) {
            system.debug(LoggingLevel.ERROR, 'Exception > ' + ex);
        }
        Test.stopTest();
    }
    
    
    @isTest
    public static void updateOpportunityWithCampaignCodeTest() {
        Test.startTest();
        String optyName = 'TestOpty';
        String stageName = 'Order Complete'; 
        Date closeDate = System.Today() + 30;
        String accountName = 'TestAccount';

		product2 oProduct = [SELECT id FROM product2 limit 1];

        Account acc = DCTestData.createAccount(accountName);
        insert acc;

        Source_System_Detail__c ssd = DCTestData.createSourceSystemDetail(acc);
        Opportunity opty = DCTestData.createOpportunityRec( optyName, acc.Id,  stageName,  closeDate, String.valueOf(ssd.Id));
        insert opty;

        //Ecom_Opportunity  ecomOpportunity = new Ecom_Opportunity();
        Ecom_OrderRequest.cls_References ref = new Ecom_OrderRequest.cls_references();
        ref.accountid = String.valueOf(acc.Id);
        ref.opportunityid = String.valueOf(opty.Id);
        
        System.assert(ref != null,'ref is null');
        Ecom_OrderRequest.cls_storeOrder storeOrder = Ecom_OrderService_test.getRequest(oProduct.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        
        try {
            Ecom_Opportunity.updateOpportunityWithCampaignCode(ref, storeOrder);
        } catch (Exception ex) {
            system.debug(logginglevel.ERROR, 'Exception: ' + ex);
        }
        Test.stopTest();
    }
    
   
    @isTest
    public static void getCorporateCampaignIdTest() {
        String campId;
        Test.startTest();
        Product2 prod = [SELECT id, Family FROM Product2 LIMIT 1];
        prod.Family = 'WESTLAW';
        update prod;
        campId = Ecom_Opportunity.getCorporateCampaignId(prod.id);
        prod.Family = 'PRACTICAL';
        update prod;
        campId = Ecom_Opportunity.getCorporateCampaignId(prod.id);
        System.assert(campId != null, 'Campaign ID is null');
        Test.stopTest();
    }
        
   
    /** 
     * @description : createLead() method
     * @param storeOrder : Store Order
     * @param orderId : Order id
     * @return : Lead   
     */      
    private static Lead createLead(Ecom_OrderRequest.cls_storeOrder storeOrder, String orderId) {
        Ecom_OrderRequest.cls_customerDetails leadInfo = storeOrder.customerDetails;
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();

        Lead lead = new Lead();
        lead.RecordTypeId = recordTypeId;
        lead.firstname = leadInfo.firstName;
        lead.lastname = leadInfo.lastName;
        lead.company = leadInfo.organizationName;
        lead.Email = leadInfo.businessEmail;
        lead.Phone = leadInfo.phoneNumber;
        lead.APTSECOM_Order__c = orderId;
        lead.street = leadInfo.address.addressLine1;
        lead.city = leadInfo.address.city;
        lead.state = leadInfo.address.state;
        lead.country = leadInfo.address.country;
        lead.postalcode = leadInfo.address.zipCode;
        return lead;
    }
    
}