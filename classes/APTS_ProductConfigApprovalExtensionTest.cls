/*APTS_ProductConfigApprovalExtensionTest

 Modified by:Surya, APTTUS on-15/2/2018-  Rewritten APTS_ProductConfigApprovalExtensionTest Class as a part of GLI OC

*/
@isTest
private with sharing class APTS_ProductConfigApprovalExtensionTest {

     @testSetUp static void testMethodOne(){
     //inserting pricelist
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
     //Creating Webservicesettings
        WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
        
     //Inserting keyvaluestore
        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
                
     //Dynamic retrieval of Pipeline Opportunity RecordType id Using schema
      //Id RecordType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
      
      //Inserting record list 
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

    //Inserting account
        Account a = APTS_TestDataFactory.createAccount('Test Account');
       insert a;
    
     //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
     
     //Inserting oppty   
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

    //Inserting proposal
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert proposal;

    //creating product configuration
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

    //Inserting product
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '07';

          insert prod2Obj;    

    //Inserting  price_list_item
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
       
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   


    //Inserting line_item
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

        insert linObj;
        
        }
       
         @isTest static void testSignatureBlock() {
       //Fetching Account
         Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
      //Fetching  opportunity 
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc' LIMIT 1];
      //Fetching Proposal
        Apttus_Proposal__Proposal__c p=[SELECT id from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal__c.Apttus_Proposal__Opportunity__r.name='abc' LIMIT 1];
      //Fetching Product configuration 
        Apttus_Config2__ProductConfiguration__c p1=[SELECT id from Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:p.Id LIMIT 1];
      //Fetching line_item  
         Apttus_Config2__LineItem__c p2 =[SELECT id from Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :p1.Id LIMIT 1];
        
        Test.startTest();
        Apttus_Approval__Approval_Request__c request = new Apttus_Approval__Approval_Request__c();
        request.Apttus_CQApprov__CartId__c = p1.id;

        Apttus_CQApprov.CartApprovalEmailController controller = new Apttus_CQApprov.CartApprovalEmailController();
        controller.setRequestSO(request);

        APTS_ProductConfigApprovalExtension extenstion = new APTS_ProductConfigApprovalExtension(controller);
        List<Apttus_Config2__LineItem__c> lineItems = extenstion.getLineItems();

        extenstion.getOrgUrl();
        Test.stopTest();

        System.assertEquals(lineItems.size(), 1);
        
        }
    }