/* APTS_ApprovalGenerateControllerTest
 * A test class for APTS_GenerateController
 
 * History:
 
 * 06/03/2018,  Tejasree Tadi,  ReDesigned APTS_GenerateControllerTest Class as a part of GLI OC
 */

@isTest
private class APTS_GenerateControllerTest {
    @testSetUp static void allTheDataForThisClass(){
       //Inserting pricelist
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        //Creating Webservicesettings
        List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c >();
        WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
        WebServiceSettings__c oWebServiceSettings1 = APTS_TestDataFactory.createWebServiceSetting('CredentialInfoServices');
        webServiceList.add(oWebServiceSettings);
        webServiceList.add(oWebServiceSettings1);
        insert webServiceList;
       
        //inserting Keyvaluestore
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        insert keyvaluestore;
        
       
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype); 
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;       
        
        IXOSCodeMap__c codeMap=new IXOSCodeMap__c(name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='WEST');
        insert codeMap;
        
        //Inserting Account
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = valueMarket;
        
        Account a1 = APTS_TestDataFactory.createAccount('Test Account1');
        a1.FrozenMarketSegment__c = valueMarket;
        
        List<Account> acclist = new List<Account>{a,a1};
        insert acclist;
        
        //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.APTS_Is_Customer__c = true;
        accountSSD.Source_System_Account_Number__c ='2000000584';
        accountSSD.Card_Number__c = 'XXXX-XXXX-XXXX-0004';
        accountSSD.Card_Type__c = 'VISA';
        accountSSD.Expiry_Date__c = System.today();
        accountSSD.Default_Payment_Method__c = 'Auto EFT/Auto Charge';
        
        Source_System_Detail__c accountSSD1=APTS_TestDataFactory.createSourceSystem(a1);
        accountSSD1.RecordtypeId=ssdRecorType;
        accountSSD1.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD1.Account_Inactive__c=false;
        accountSSD1.LCRM_Sales_Org__c='S100';
        accountSSD1.APTS_Is_Customer__c = true;
        accountSSD1.Source_System_Account_Number__c ='2000000584';
        accountSSD1.Card_Number__c = 'XXXX-XXXX-XXXX-0004';
        accountSSD1.Card_Type__c = 'VISA';
        accountSSD1.Expiry_Date__c = System.today();
        accountSSD1.Default_Payment_Method__c = 'Auto EFT/Auto Charge';
        
        List<Source_System_Detail__c> ssdlist = new List<Source_System_Detail__c>{accountSSD,accountSSD1};
        insert ssdlist;

        Contact c=APTS_TestDataFactory.createContact('bcca',a.id);
        
        Contact c1=APTS_TestDataFactory.createContact('bcca1',a1.id);
        
        //Inserting Opportunity
         Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
         Opportunity oppty = new Opportunity(Name ='abc', AccountId = a.id, stageName = 'Needs Analysis', CloseDate = Date.Today(),key_contact__c=c.Id);
         oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        
        Opportunity oppty1 = new Opportunity(Name ='abc1', AccountId = a1.id, stageName = 'Needs Analysis', CloseDate = Date.Today(),key_contact__c=c1.Id);
         oppty1.RecordtypeId=opptyRecorType;
        oppty1.Source_System_Detail__c=accountSSD1.id;
        oppty1.Account=a;
        
        List<Opportunity> optylist = new List<Opportunity>{oppty,oppty1};
        insert optylist;
        
       //Inserting Proposal Objects
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Assent_Customer_Name__c='test assert';
        proposalList.add(proposal);

        Apttus_Proposal__Proposal__c proposal1 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal1.APTS_Proposal_Business_Unit__c='SCS';
        proposalList.add(proposal1);
        
        Apttus_Proposal__Proposal__c proposal2 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal2.APTS_Proposal_Business_Unit__c='FindLaw';
        proposalList.add(proposal2);
        
        Apttus_Proposal__Proposal__c proposal3 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal3.APTS_Assent_Customer_Name__c=null;
        proposalList.add(proposal3);
       
        Apttus_Proposal__Proposal__c proposal4 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal4.APTS_Proposal_Business_Unit__c='FindLaw';
        proposal4.APTS_FL_Product_Language__c='PI-LL-Rep-Adv';
        proposalList.add(proposal4);
        
        Apttus_Proposal__Proposal__c proposal5 = APTS_TestDataFactory.createProposal(oppty1.id, accountSSD1.Id);
        proposal5.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        proposal5.Tax_Payment_Option__c = 'Auto EFT/Auto Charge';
        proposal5.APTS_Credit_Card_Token__c =  accountSSD.Card_Number__c;
        proposal5.APTS_Card_Type__c = accountSSD.Card_Type__c;
        proposal5.APTS_Card_Expiration_Date__c = accountSSD.Expiry_Date__c;                                         
        proposal5.APTS_Payment_Option__c = accountSSD.Default_Payment_Method__c;
 
        proposalList.add(proposal5);
        Test.starttest();
        
        insert proposalList;
        
        proposal2.APTS_Proposal_Business_Unit__c='FindLaw';
        proposal4.APTS_Proposal_Business_Unit__c='FindLaw';
        List<Apttus_Proposal__Proposal__c> updateproposalList=new List<Apttus_Proposal__Proposal__c>{proposal2,proposal4};
        update updateproposalList;
        
        APTS_Attribute_Value_Combination__c testCombination=new APTS_Attribute_Value_Combination__c(name='Test Combination',APTS_Inventory_Available__c=0);
        insert testCombination;
        
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList=new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Quantity__c=1,
          APTS_Combination_Key__c=testCombination.id,
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          Apttus_QPConfig__LineStatus__c='New',
          Apttus_Proposal__Proposal__c=proposal2.id,
          APTS_Product_Family__c = 'CLEAR');
          proposalLineItemList.add(proposalLineItem);
          Apttus_Proposal__Proposal_Line_Item__c proposalLineItem1=new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Quantity__c=1,
          APTS_Combination_Key__c=testCombination.id,
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          Apttus_QPConfig__LineStatus__c='New',
          Apttus_Proposal__Proposal__c=proposal1.id,
          APTS_Product_Family__c = 'CLEAR');
                    proposalLineItemList.add(proposalLineItem1);

          insert proposalLineItemList;
        
         //Inserting productConfiguration
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        insert prodConfig;
        //Inserting ConfigurationApprovalsettings
        APTS_ConfigApprovalSettings__c cfgApprovalSettings = new APTS_ConfigApprovalSettings__c();
        cfgApprovalSettings.Name = 'SignoffRequiredAmount0';
        cfgApprovalSettings.Threshold_Amount__c = 1000;
        insert cfgApprovalSettings;    
         
        //Inserting LineItems
        List<Apttus_Config2__LineItem__c> ListOfLineItems = New List<Apttus_Config2__LineItem__c>();
     
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

        Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO3.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO3;   
        
        
       //Inserting Products
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_High_Level_Code__c = '05';
        prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
        insert prodObj;  

        Product2 prod2Obj = new Product2();
        prod2Obj.Name = 'Network Services 2.0';
        prod2Obj.APTS_Media_High_Level_Code__c = '21';
        insert prod2Obj;    
        
        //Inserting LineItems
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
            Apttus_Config2__PriceListItemId__c = pliSO.id); 
        ListOfLineItems.add(linObj);

        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.Id,
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = null,
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        ListOfLineItems.add(linObj2);

        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = null,
            Apttus_Config2__PriceListItemId__c = pliSO3.id); 
        ListOfLineItems.add(linObj3);
        
        insert ListOfLineItems;
        
        Test.stoptest();
        
      
    }
    
    @isTest static void test_SignatureBlockNotRequired() {
        //Fetching Account,opportunity and Proposal Objects
        Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc'];
        //Source_System_Detail__c ssd=[select id,Source_System_Account_Number__c,LCRM_Sales_Org__c from Source_System_Detail__c where Account_Name__c =: a.id];
        Test.startTest();
        Apttus_Proposal__Proposal__c p=[SELECT id,APTS_Assent_Customer_Name__c,APTS_Signature_Block_Required__c from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' AND  Apttus_Proposal__Proposal__c.APTS_Assent_Customer_Name__c!=null LIMIT 1 ];

       system.assertNotEquals(null,p.APTS_Assent_Customer_Name__c);
   

        PageReference pageRef = Page.APTS_Generate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', p.ID);
       
        APTS_GenerateController generateCtrl = new APTS_GenerateController();
        PageReference pg = generateCtrl.generate();
        Test.stopTest();
        
         system.assertEquals(false,p.APTS_Signature_Block_Required__c);

      }
      
      @isTest static void test_SignatureBlockNotRequired1(){
        //Fetching Account,opportunity and Proposal Objects
        Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc'];
        Test.startTest();
        Apttus_Proposal__Proposal__c p=[SELECT id,APTS_Assent_Customer_Name__c,APTS_Signature_Block_Required__c from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' AND Apttus_Proposal__Proposal__c.APTS_Assent_Customer_Name__c=null and APTS_People_Map__c=0 LIMIT 1];  
        PageReference pageRef = Page.APTS_Generate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', p.ID);
        APTS_GenerateController generateCtrl = new APTS_GenerateController();
       
        PageReference pg = generateCtrl.generate();
        Test.stopTest();

       }
      
      @isTest static void test_generateAVC(){
        //Fetching Account,opportunity and Proposal Objects
        Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc'];
        Test.startTest();
        IXOSCodeMap__c testCodeMap=[select id,name,Company_Code__c,Dist_Chan_Code__c,Division_Code__c,Sales_Org_Code__c from IXOSCodeMap__c where Sales_Org_Code__c='WEST'];
        WebServiceSettings__c credentialInfoServices=[select name,Active__c,Endpoint__c,Max_GLI_Count__c,Max_Non_GLI_Count__c,Password__c,Service_Unavailable_Message__c,Timeout__c,Username__c from WebServiceSettings__c where name='CredentialInfoServices'];
        Source_System_Detail__c ssd=[select id,Source_System_Account_Number__c,LCRM_Sales_Org__c from Source_System_Detail__c where Account_Name__c =: a.id];
        Apttus_Proposal__Proposal__c p=[SELECT id,APTS_Assent_Customer_Name__c,APTS_Signature_Block_Required__c,APTS_People_Map__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' AND Apttus_Proposal__Proposal__c.APTS_Assent_Customer_Name__c=null and APTS_SSD_Sold_To__c=:ssd.id and APTS_Proposal_Business_Unit__c='SCS' LIMIT 1];  
        //Apttus_Proposal__Proposal_Line_Item__c pli=[select id,APTS_Product_Family__c,APTS_People_Map__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c=:p.id];
        PageReference pageRef = Page.APTS_Generate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', p.ID);
        APTS_GenerateController generateCtrl = new APTS_GenerateController();
       
        PageReference pg = generateCtrl.generate();
        Test.stopTest();
       
      

       }
       
        
       @isTest static void test_WithoutProposalInsertionMethod(){
        //Fetching Account,opportunity and Proposal Objects
        Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc'];
        Test.startTest();
        Apttus_Proposal__Proposal__c p=[SELECT id,APTS_Assent_Customer_Name__c,APTS_Signature_Block_Required__c from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' AND Apttus_Proposal__Proposal__c.APTS_Assent_Customer_Name__c=null LIMIT 1];  
        PageReference pageRef = Page.APTS_Generate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', p.ID);
        system.assertEquals(null,p.APTS_Assent_Customer_Name__c);
        APTS_GenerateController generateCtrl = new APTS_GenerateController();
        generateCtrl.proposal=new  Apttus_Proposal__Proposal__c();
        PageReference pg = generateCtrl.generate();
        Test.stopTest();
      
      

       }

        @isTest static void test_validateProposalForInventory(){

         Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc'];
        //Test.startTest();
        Apttus_Proposal__Proposal__c p=[SELECT id,APTS_Assent_Customer_Name__c,APTS_Signature_Block_Required__c,APTS_Proposal_Business_Unit__c,APTS_FL_Product_Language__c from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' AND APTS_Proposal_Business_Unit__c='FindLaw' and APTS_FL_Product_Language__c!='PI-LL-Rep-Adv' LIMIT 1];  
        APTS_Attribute_Value_Combination__c attributeCombination=[select id,APTS_Inventory_Available__c from APTS_Attribute_Value_Combination__c where name='Test Combination'];
        Apttus_Proposal__Proposal_Line_Item__c pli=[select id,APTS_Combination_key__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c=:p.id and APTS_Combination_key__c=:attributeCombination.id];
        Test.startTest();
        PageReference pageRef = Page.APTS_Generate;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', p.ID);
        APTS_GenerateController generateCtrl = new APTS_GenerateController();
        system.debug('proposal--'+generateCtrl.proposal);
        generateCtrl.proposal=p;
                system.debug('proposal--'+generateCtrl.proposal);

        PageReference pg = generateCtrl.generate();
        pageReference pg1=generateCtrl.doSubmit();
        Test.stopTest();

        }

         @isTest static void test_generateExposurePackAttachment(){

         Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc'];  
        Test.startTest();
        Source_System_Detail__c ssd=[select id,Source_System_Account_Number__c,LCRM_Sales_Org__c from Source_System_Detail__c where Account_Name__c =: a.id];
        Apttus_Proposal__Proposal__c p=[SELECT id,APTS_Assent_Customer_Name__c,APTS_Signature_Block_Required__c,APTS_People_Map__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c,APTS_FL_Product_Language__c from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' AND APTS_FL_Product_Language__c !='PI-LL-Rep-Adv' and APTS_Proposal_Business_Unit__c='FindLaw' LIMIT 1];  
        PageReference pageRef = Page.APTS_Generate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', p.ID);
        APTS_GenerateController generateCtrl = new APTS_GenerateController();
       
        PageReference pg = generateCtrl.generate();
        Test.stopTest();
        }

        @isTest static void test_generatetemplatefieldupdate(){

         Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc'];      
        Test.startTest();
        Source_System_Detail__c ssd=[select id,Source_System_Account_Number__c,LCRM_Sales_Org__c from Source_System_Detail__c where Account_Name__c =: a.id];
        Apttus_Proposal__Proposal__c p=[SELECT id,APTS_Assent_Customer_Name__c,APTS_Signature_Block_Required__c,APTS_People_Map__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c,APTS_FL_Product_Language__c from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc' AND APTS_FL_Product_Language__c !='PI-LL-Rep-Adv' and APTS_Proposal_Business_Unit__c='FindLaw' LIMIT 1];  
        PageReference pageRef = Page.APTS_Generate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', p.ID);
        APTS_GenerateController generateCtrl = new APTS_GenerateController();
       
        PageReference pg = generateCtrl.generate();
        Test.stopTest();
        }
        
        @isTest static void test_generatetemplateTax(){

         Account a=[SELECT id,name from Account WHERE name='Test Account1' LIMIT 1];
        Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc1'];
        Test.startTest();        
        Source_System_Detail__c ssd=[select id,Source_System_Account_Number__c,LCRM_Sales_Org__c from Source_System_Detail__c where Account_Name__c =: a.id];
        Apttus_Proposal__Proposal__c p=[SELECT id,APTS_Assent_Customer_Name__c,APTS_Signature_Block_Required__c,APTS_People_Map__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c,APTS_FL_Product_Language__c from  Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__r.name='abc1' and APTS_Proposal_Business_Unit__c='Tax Professional' LIMIT 1];  
        PageReference pageRef = Page.APTS_Generate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', p.ID);
        Id jobID1 = System.enqueueJob(new APTS_TaxTemplateQueueable(p.Id));
        APTS_GenerateController generateCtrl = new APTS_GenerateController();
        generateCtrl.jobID = jobID1;
        PageReference pg;
        pg = generateCtrl.generate();
        pg = generateCtrl.checkstatus();
        Test.stopTest();
        }


       
   }