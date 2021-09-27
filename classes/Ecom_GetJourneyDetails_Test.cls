@isTest
public class Ecom_GetJourneyDetails_Test {

    @testSetup 
    static void setup(){
        
        
        Apttus_Config2__PriceList__c priceList1 = DCTestData.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList1;
        
        Pricebook2 pbook = new Pricebook2();
        pbook.name =  'GLI Price Book - US Legal/LMS';
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
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;
        
        Product2 p2 = DCTestData.createProduct('WestLaw Product', '42009581','42009634','Arizona');
        
        APTSECOM_Store__c store1 = DCTestData.createStore('Small Law', null,priceList1.Id);
        insert store1;
             
        // create category hierarchy
        Apttus_Config2__ClassificationName__c mainCategory = new Apttus_Config2__ClassificationName__c();
        mainCategory.Apttus_Config2__HierarchyLabel__c = 'Ecom-Small Law';
        mainCategory.Name = 'Ecom-Small Law';
        insert mainCategory;
    
        Apttus_Config2__ClassificationHierarchy__c hierMain = new Apttus_Config2__ClassificationHierarchy__c();
        hierMain.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierMain.Name = 'Ecom-Small Law';
        hierMain.Apttus_Config2__Label__c = 'Ecom-Small Law';
        hierMain.Apttus_Config2__Level__c = 0;
        insert hierMain;
    
        List<Apttus_Config2__ClassificationHierarchy__c> level1HierList = new List<Apttus_Config2__ClassificationHierarchy__c>();
        Apttus_Config2__ClassificationHierarchy__c hierPL = new Apttus_Config2__ClassificationHierarchy__c();
        hierPL.Apttus_Config2__Level__c = 1;
        hierPL.Apttus_Config2__AncestorId__c = hierMain.Id;
        hierPL.Apttus_Config2__HierarchyId__c = mainCategory.Id;
        hierPL.Apttus_Config2__PrimordialId__c = hierMain.Id;
        hierPL.Name = 'Premium';
        hierPL.Apttus_Config2__Label__c = 'Premium';
        hierPL.DC_Sequence_No__c = 1;
        level1HierList.add(hierPL);
        insert level1HierList;

        Ecom_OrderRequest.cls_storeOrder sreq = Ecom_OrderService_Test.getRequest(p2.Id, 'Small Law', 2, 'Jessica', 'Tr-Test', '1234567879', 'Premium');
        sreq.planId = hierPL.id;
        Ecom_OrderRequest.cls_selectedProducts sp2 = new Ecom_OrderRequest.cls_selectedProducts();
        sp2.contractTerm = '3 Years';
        sp2.isRecommendedProduct = 'true';
        sp2.quantity = 1;
        sp2.productId = p2.Id;
        sreq.selectedProducts.add(sp2);
        
        Apttus_Config2__Order__c od = DCTestData.createOrder(priceList1.id,store1.id );
        od.APTSECOM_Customer_Details__c = Json.serialize(sreq);
        insert od;
        
        Lead l = Ecom_OrderService_Test.createLead(sreq , od.Id);
        insert l;     
        //categoryId = hierPL.Id;
        New_Sales_Contract_Term_Setting__c cts = new New_Sales_Contract_Term_Setting__c();
        cts.Name = '3 Year - Essentials';
        cts.Related_Store__c = store1.id;
        cts.Related_Category_Hierarchy__c = hierPL.id;
        cts.Adjustment_Amount__c = 10.0;
        cts.Adjustment_Type__c = '% Discount';
        cts.Contract_Term__c = '3 Years';
        cts.YoY_1__c = 5.0;
        cts.YoY_2__c = 5.0;
        insert cts;

        APTSECOM_Store_Price_Adjustment__c storeAdjustment = new APTSECOM_Store_Price_Adjustment__c();
        storeAdjustment.APTSECOM_Adjustment_Amount__c = 1;
        storeAdjustment.APTSECOM_Adjustment_Type__c = '% Discount';
        storeAdjustment.APTSECOM_Category_Hierarchy__c = hierPL.id;
        storeAdjustment.APTSECOM_Store__c = store1.id;
        insert storeAdjustment;
        
    }
    
    @isTest
    public static void initialTest(){
        Lead lead = [Select Id From Lead limit 1];
        System.assert(lead != null,'No lead found');
        Ecom_GetJourneyDetails.getJourneyDetails(lead.Id);
    }
    
    @isTest
    public static void exceptionTest(){
        
        Test.startTest();
        try{
            Ecom_GetJourneyDetails.getJourneyDetails('lead.Id');    
        }catch(Exception ex){
            System.assert(ex != null,'No exception occurred');
        }
        
        Test.stopTest();
    }
}