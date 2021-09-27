/*APTS_ProposalLineItemTriggerTest

 Modified by:Surya, APTTUS on-27/2/2018-  Rewritten APTS_ProposalLineItemTriggerTestClass as a part of GLI OC

*/
@isTest
private class APTS_ProposalLineItemTriggerTest {
    
    private static final string USL_RECORDTPYE='USL_Source_Systems';
    @testSetUp static void testupdateValidationFlag() { 
    LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
      //Inserting pricelist      
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
      //Creating Webservicesettings
        WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
      //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=  System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
      //Inserting recordtype
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
      //Inserting account
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.Fiscal_Year_End__c = '01-Jan';
        a.FrozenMarketSegment__c = valueMarket;
        Account a1 = APTS_TestDataFactory.createAccount('Test Account');
        a1.Fiscal_Year_End__c = '11-Nov';
        Account a2 = APTS_TestDataFactory.createAccount('Test Account');
        List<Account> accList = new List<Account>{a,a1,a2};
        insert accList;
        
      //Dynamic Retrieval of USL Source System recordType and Creating ssd object
         Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.LCRM_Sales_Org__c='WEST';
        
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Name__c = 'Test1';
        
        Source_System_Detail__c accountSSD1 =APTS_TestDataFactory.createSourceSystem(a);
        accountSSD1.RecordtypeId=ssdRecorType;
        accountSSD1.LCRM_Sales_Org__c='S100';
        accountSSD1.Source_System_Name__c = 'Test2';
        accountSSD1.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD1.Account_Inactive__c=false;
      //  accountSSD1.APTS_Is_Customer__c = false;
        accountSSD1.Source_System_Account_Number__c ='2000000584';
    //    accountSSD1.Card_Number__c = 'XXXX-XXXX-XXXX-0004';
    //    accountSSD1.Card_Type__c = 'VISA';
    //    accountSSD1.Expiry_Date__c = System.today();
        accountSSD1.Tax_Payment_Option__c = 'Payment Express Auto EFT/Auto Charge';
        List<Source_System_Detail__c> ssdlist = new List<Source_System_Detail__c>{accountSSD,accountSSD1};
        insert ssdlist;
      //Inserting oppty 
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        system.debug('opportunity**********'+oppty);
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c ='Corp OneOTC US';
        proposal.APTS_Payment_Option__c = 'Bill to Account';
        proposal.APTS_Fiscal_Filer__c = true;
        Apttus_Proposal__Proposal__c proposal1 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal1.Apttus_Proposal__Account__c = a1.Id;
        proposal1.APTS_Payment_Option__c = 'Bill to Account';
        Apttus_Proposal__Proposal__c proposal2 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal2.Apttus_Proposal__Account__c = a2.Id;
        proposal2.APTS_Proposal_Business_Unit__c ='FindLaw';
        proposal2.APTS_Payment_Option__c = 'Bill to Account';
        Apttus_Proposal__Proposal__c proposal3 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD1.Id);
        proposal3.Apttus_Proposal__Account__c = a2.Id;
        proposal3.APTS_Proposal_Business_Unit__c ='Tax Professional';
        proposal3.APTS_Payment_Option__c = 'Bill to Account';
        proposal3.Apttus_Proposal__Proposal_Name__c = 'tax';
        Apttus_Proposal__Proposal__c proposal4 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal4.Apttus_Proposal__Account__c = a2.Id;
        proposal4.APTS_Proposal_Business_Unit__c ='Canada';
        proposal4.APTS_Payment_Option__c = 'Bill to Account';
        proposal4.Apttus_Proposal__Proposal_Name__c = 'canada';
        List<Apttus_Proposal__Proposal__c> proplist = new List<Apttus_Proposal__Proposal__c>{proposal,proposal1,proposal2,proposal3,proposal4};
        insert proplist; 
        //Inserting quote_agreement_location 
        List<APTS_Quote_Agreement_Locations__c> alList = new List<APTS_Quote_Agreement_Locations__c>();
        APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = proposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location_SSD__c = accountSSD.Id);
        alList.add(al);
        al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test1', APTS_Quote_Proposal__c = proposal.Id, APTS_Status__c = 'Existing', APTS_Subscriber_Location_SSD__c = accountSSD.Id);
        alList.add(al);
        insert alList;
        //Inserting product configuration
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposal.Id,Apttus_Config2__FinalizedDate__c = System.Today());
        Apttus_Config2__ProductConfiguration__c prodConfig1 = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposal2.Id,Apttus_Config2__FinalizedDate__c = System.Today());
        Apttus_Config2__ProductConfiguration__c prodConfig2 = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposal3.Id,Apttus_Config2__FinalizedDate__c = System.Today());
        Apttus_Config2__ProductConfiguration__c prodConfig3 = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposal4.Id,Apttus_Config2__FinalizedDate__c = System.Today());
        List<Apttus_Config2__ProductConfiguration__c> prodconfiglist = new List<Apttus_Config2__ProductConfiguration__c>{prodConfig,prodConfig1,prodConfig2,prodConfig3};
        insert prodconfiglist;
        
        Product2 prod1=new Product2(Name ='1SRC NRA Banner Interface',ProductCode = '41318361',APTS_Availability_Date__c = System.Today() + 7);
        Product2 prod2=new Product2(Name ='1SRC NRA Data Navigator Interface',ProductCode = '41318364',APTS_Availability_Date__c = System.Today() - 7);
        Product2 prod3=new Product2(Name ='Test CPW Product',ProductCode = '41318124',APTS_Availability_Date__c = System.Today() - 7,APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family);
        Product2 prod4=new Product2(Name ='Test CPW Product',ProductCode = '41318124',APTS_Availability_Date__c = System.Today() - 7,APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family);
        Product2 prod5=new Product2(Name ='Test',ProductCode = '41318124',APTS_Availability_Date__c = System.Today() - 7,Family = System.Label.Caseline_Product_Family);
        List<Product2> productList=new List<Product2>{prod1,prod2,prod3,prod4,prod5};
        insert productList;
        
        Map<String,String> testMap=new Map<String,String>();
        List<String> testLbl = System.Label.OCPerSeatLowerLevelCodes.split(',');
        
        //List<Apttus_Config2__ProductAttributeValue__c> ListofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
        List<Apttus_Config2__LineItem__c> listOfLineItems = New List<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=1,  
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=1); 
        listOfLineItems.add(linObj);
  
        linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=1 ); 
        listOfLineItems.add(linObj);

        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig1.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=1,
            Apttus_Config2__ProductId__c = prod3.Id ); 
        listOfLineItems.add(linObj3);
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig3.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=1,
            Apttus_Config2__ProductId__c = prod3.Id ); 
        listOfLineItems.add(linObj4);
        
        insert listOfLineItems;
        
        Fiscal_Year_End__c fiscal1 = new Fiscal_Year_End__c(Name='01-Jan',Fiscal_Year__c='01-Jan',Month__c='1');
        Fiscal_Year_End__c fiscal2 = new Fiscal_Year_End__c(Name='05-May',Fiscal_Year__c='05-May',Month__c='5');
        Fiscal_Year_End__c fiscal3 = new Fiscal_Year_End__c(Name='10-Nov',Fiscal_Year__c='11-Nov',Month__c='11');
        List<Fiscal_Year_End__c> fiscallist = new List<Fiscal_Year_End__c>{fiscal1,fiscal2,fiscal3};
        insert fiscallist;
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c plItem2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Media_High_Level__c='Online',
          APTS_Online_Contacts_Validation__c=FALSE,
          //Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          IP_Address_Check__c=false,
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=proposal.id);
        lineItemList1.add(plItem2);
        
        Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Media_Lower_Level_Code__c='WO',
          APTS_Online_Contacts_Validation__c=FALSE,
          APTS_Master_Contacts_Validation__c=FALSE,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=proposal.id);
        lineItemList1.add(plItem3);
        
        Apttus_Proposal__Proposal_Line_Item__c plItem4 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Media_High_Level_Code__c ='06',
          APTS_Media_Lower_Level_Code__c = 'I9',
          APTS_Online_Contacts_Validation__c=FALSE,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=proposal.id);
        lineItemList1.add(plItem4);
        
        Apttus_Proposal__Proposal_Line_Item__c plItem5 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1, 
          APTS_Media_High_Level_Code__c = '13',
          APTS_Media_Lower_Level_Code__c = 'I9',
          APTS_Online_Contacts_Validation__c=FALSE,
          Apttus_QPConfig__ConfigurationId__c = prodConfig1.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
           Apttus_QPConfig__PriceType__c='One Time',
            Apttus_QPConfig__ChargeType__c = 'Standard Price',
            Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=proposal2.id);
        lineItemList1.add(plItem5);
        
        Apttus_Proposal__Proposal_Line_Item__c plItem6 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__LineStatus__c='Amended',
          APTS_Media_High_Level_Code__c = '21',
          APTS_Media_Lower_Level_Code__c = 'I9',
          APTS_Online_Contacts_Validation__c=FALSE,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=proposal.id);
        lineItemList1.add(plItem6);
        
        Apttus_Proposal__Proposal_Line_Item__c plItem7 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Media_High_Level_Code__c='06',
          APTS_Media_Lower_Level_Code__c='65',
          APTS_Cat_L5__c='L5_L1445_FP',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=proposal.id);
         lineItemList1.add(plItem7);
        
         Apttus_Proposal__Proposal_Line_Item__c plItem8 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
            IP_Address_Check__c=false,
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
              Apttus_QPConfig__PriceType__c='One Time',
            Apttus_QPConfig__ChargeType__c = 'Standard Price',
            Apttus_QPConfig__LineStatus__c = 'New',
          Apttus_Proposal__Proposal__c=proposal.id);
          lineItemList1.add(plItem8);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem9 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() + 7,
          Apttus_Proposal__Proposal__c=proposal.id);
         lineItemList1.add(plItem9);
         
          Apttus_Proposal__Proposal_Line_Item__c plItem10 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() - 7,
          Apttus_Proposal__Proposal__c=proposal.id);
          lineItemList1.add(plItem10);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem11 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig1.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() - 7,
          Apttus_Proposal__Proposal__c=proposal2.id);
          lineItemList1.add(plItem11);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem12 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig1.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() + 7,
          Apttus_Proposal__Proposal__c=proposal2.id);
          lineItemList1.add(plItem12);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem13 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig1.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() + 7,
          Apttus_Proposal__Product__c = prod3.Id,
          Apttus_Proposal__Proposal__c=proposal2.id,
          APTS_Online_Contacts_Validation__c=false);
          lineItemList1.add(plItem13);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem14 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Tax Professional',
          Apttus_QPConfig__ConfigurationId__c = prodConfig2.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() + 7,
          Apttus_Proposal__Product__c = prod3.Id,
          Apttus_Proposal__Proposal__c=proposal3.id,
          APTS_Online_Contacts_Validation__c=false);
          lineItemList1.add(plItem14);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem15 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Tax Professional',
          Apttus_QPConfig__ConfigurationId__c = prodConfig2.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() + 7,
          Apttus_Proposal__Product__c = prod2.Id,
          Apttus_Proposal__Proposal__c=proposal3.id,
          APTS_Online_Contacts_Validation__c=false);
          lineItemList1.add(plItem15);
        
          Apttus_Proposal__Proposal_Line_Item__c plItem16 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
      Apttus_QPConfig__LineStatus__c='Amended',
          APTS_Proposal_Business_Unit__c='Canada',
          Apttus_QPConfig__ConfigurationId__c = prodConfig3.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() + 7,
          Apttus_Proposal__Product__c = prod2.Id,
          Apttus_Proposal__Proposal__c=proposal4.id,
          APTS_Online_Contacts_Validation__c=false);
          lineItemList1.add(plItem16);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem17 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() - 7,
          Apttus_Proposal__Proposal__c=proposal.id,APTS_Online_Contacts_Validation__c=false,Apttus_Proposal__Product__c = prod4.Id,APTS_Master_Contacts_Validation__c=false,APTS_Media_High_Level_Code__c ='05',APTS_Media_Lower_Level_Code__c='E9');
          lineItemList1.add(plItem17);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem18 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() - 7,
          Apttus_Proposal__Proposal__c=proposal.id,APTS_Online_Contacts_Validation__c=false,Apttus_Proposal__Product__c = prod4.Id,APTS_Master_Contacts_Validation__c=false,APTS_Media_High_Level_Code__c ='13',APTS_Media_Lower_Level_Code__c='NX');
          lineItemList1.add(plItem18);
          
          Apttus_Proposal__Proposal_Line_Item__c plItem19 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() - 7,
          Apttus_Proposal__Proposal__c=proposal.id,APTS_Online_Contacts_Validation__c=false,Apttus_Proposal__Product__c = prod4.Id,APTS_Master_Contacts_Validation__c=false,APTS_Program_ID__c ='CPRO',APTS_Media_High_Level_Code__c ='06',APTS_Media_Lower_Level_Code__c='65',Apttus_QPConfig__LineStatus__c='New');
          lineItemList1.add(plItem19);
        
          Apttus_Proposal__Proposal_Line_Item__c plItem20 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() - 7,
          APTS_Cat_L2__c = System.Label.APTS_HighQ_Product_Family,
          Apttus_Proposal__Proposal__c=proposal.id,APTS_Online_Contacts_Validation__c=false,Apttus_Proposal__Product__c = prod4.Id,APTS_Master_Contacts_Validation__c=false,APTS_Program_ID__c ='CPRO',APTS_Media_High_Level_Code__c ='06',APTS_Media_Lower_Level_Code__c='65',Apttus_QPConfig__LineStatus__c='New');
          lineItemList1.add(plItem20);

          Apttus_Proposal__Proposal_Line_Item__c plItem21 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Proposal_Business_Unit__c='Corp OneOTC US',
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Availability_Date__c = System.Today() - 7,
          Apttus_Proposal__Proposal__c=proposal.id,APTS_Online_Contacts_Validation__c=false,Apttus_Proposal__Product__c = prod5.Id,APTS_Master_Contacts_Validation__c=false,APTS_Program_ID__c ='CPRO',APTS_Media_High_Level_Code__c ='06',APTS_Media_Lower_Level_Code__c='65',Apttus_QPConfig__LineStatus__c='New');
          lineItemList1.add(plItem21);
       
          insert lineItemList1;
          Apttus_Proposal__Proposal_Line_Item__c propline = [SELECT APTS_Finalized_Date__c,APTS_Fiscal_Year_End__c,APTS_Fiscal_Filer__c 
                                                from Apttus_Proposal__Proposal_Line_Item__c 
                                                  where Id =: plItem9.Id];
        APTS_ProposalLineItemTriggerHelper.mapProductLanguageValues('xcy','getg');
      }

      @isTest static void testSignatureBlock1() {
      
      //Fetching Account      
      Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
      //Fetching  opportunity 
      Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc' LIMIT 1];
      //Fetching Proposal
      Apttus_Proposal__Proposal__c proposal=[SELECT id,APTS_Contact_Validation_Flag__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal__c.Apttus_Proposal__Opportunity__r.name='abc' LIMIT 1];
        
      Apttus_Config2__ProductConfiguration__c prodConfig=[SELECT id,name from Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:proposal.id];      
       
      //changed old soldto to new soldto ssd
      List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                   Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                   FROM Apttus_Config2__LineItem__c 
                                   WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
                                   
      System.assert(lineItemsList!= null && lineItemsList.size()>0);      

      Test.startTest();     
      prodConfig.Apttus_Config2__Status__c = 'Finalized';
      update prodConfig;

      //Inserting proposal_line_item  
      Apttus_Proposal__Proposal_Line_Item__c pl1  = APTS_TestDataFactory.proposallineitem(prodConfig.id,proposal.id);
      insert pl1;           
      
      pl1.APTS_Media_High_Level__c = 'Online';
      pl1.Apttus_QPConfig__LineStatus__c = 'New';
      pl1.APTS_Online_Contacts_Validation__c = true;
      pl1.APTS_Master_Contacts_Validation__c = true;
      //pl1.Apttus_QPConfig__BillToAccountId__c = a.Id;
      update pl1;
      
      If (proposal != null) {
          System.assert(proposal.APTS_Contact_Validation_Flag__c=true);
      }     
      Test.stopTest();      
    }
  
  @isTest static void testSignatureBlock2() {
       //Fetching Account      
      Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
      //Fetching  opportunity 
      Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc' LIMIT 1];
      //Fetching Proposal
      Apttus_Proposal__Proposal__c proposal=[SELECT id,APTS_Contact_Validation_Flag__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal__c.Apttus_Proposal__Opportunity__r.name='abc' LIMIT 1];
        
      Apttus_Config2__ProductConfiguration__c prodConfig=[SELECT id,name from Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:proposal.id];
              
      //changed old soldto to new soldto ssd
      List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                   Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                   FROM Apttus_Config2__LineItem__c 
                                   WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
                                   
      System.assert(lineItemsList!= null && lineItemsList.size()>0);      

      Test.startTest();
      prodConfig.Apttus_Config2__Status__c = 'Finalized';
      update prodConfig;

      //Inserting proposal_line_item  
      Apttus_Proposal__Proposal_Line_Item__c pl1  = APTS_TestDataFactory.proposallineitem(prodConfig.id,proposal.id);
      insert pl1;             

      LIST<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList = [SELECT id, name FROM Apttus_Proposal__Proposal_Line_Item__c 
                                                    WHERE Apttus_QPConfig__ConfigurationId__c = :prodConfig.id];
      System.assert(proposalLineItemList!= null); 
      System.assert(proposalLineItemList.size()>0); 
           
      If (proposal.APTS_Contact_Validation_Flag__c != null) {
          System.assert(proposal.APTS_Contact_Validation_Flag__c=true);
      }
      
      pl1.APTS_Media_High_Level__c = '06';
      pl1.APTS_Media_Lower_Level_Code__c = 'I9';
      pl1.APTS_Online_Contacts_Validation__c = true;
      //pl1.Apttus_QPConfig__BillToAccountId__c = a.Id;
      update pl1;
     
      If (proposal.APTS_Contact_Validation_Flag__c != null) {
          System.assert(proposal.APTS_Contact_Validation_Flag__c=true);
      }            
      Test.stopTest();      
    }
  
  @isTest static void testSignatureBlock3() {
       //Fetching Account      
      Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
      //Fetching  opportunity 
      Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc' LIMIT 1];
      //Fetching Proposal
      Apttus_Proposal__Proposal__c proposal=[SELECT id,APTS_Contact_Validation_Flag__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal__c.Apttus_Proposal__Opportunity__r.name='abc' LIMIT 1];
        
      Apttus_Config2__ProductConfiguration__c prodConfig=[SELECT id,name from Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:proposal.id];
              
      //changed old soldto to new soldto ssd
      List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                   Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                   FROM Apttus_Config2__LineItem__c 
                                   WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
                                   
      System.assert(lineItemsList!= null && lineItemsList.size()>0);      

      Test.startTest();          
      prodConfig.Apttus_Config2__Status__c = 'Finalized';
      update prodConfig;

      Apttus_Proposal__Proposal_Line_Item__c pl1  = APTS_TestDataFactory.proposallineitem(prodConfig.id,proposal.id);
      insert pl1;
           
      pl1.APTS_Media_High_Level__c = '';
      pl1.APTS_Media_Lower_Level_Code__c = '2P';
      pl1.APTS_Online_Contacts_Validation__c = true;
      //pl1.Apttus_QPConfig__BillToAccountId__c = a.Id;
      update pl1;
    
      If (proposal.APTS_Contact_Validation_Flag__c !=null) {
          System.assert(proposal.APTS_Contact_Validation_Flag__c=true);            
      }  
      Test.stopTest();      
    }
    
 //Tax Prof Code coverage
     public static testmethod void testMethodTax1(){
     
            List<Apttus_Proposal__Proposal_Line_Item__c> propLi = [select id,APTS_Online_Contacts_Validation__c  from Apttus_Proposal__Proposal_Line_Item__c where APTS_Proposal_Business_Unit__c ='Tax Professional' limit 2];
            Apttus_Proposal__Proposal__c proposal=[SELECT id,APTS_Contact_Validation_Flag__c,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c ='tax' LIMIT 1];
            Apttus_Config2__ProductConfiguration__c prodConfig=[SELECT id,name from Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:proposal.id];
            
            Latam_AssetItemAutoNumber__c autoNumberObject = new Latam_AssetItemAutoNumber__c();
            autoNumberObject.Auto_Format__c ='-';
            //autoNumberObject.Latam_Latest_Number__c=0;
            autoNumberObject.Starting_Number__c = 0;
            insert autoNumberObject;
            System.assertequals(0,autoNumberObject.Starting_Number__c,'Success');
            
             test.startTest(); 
            propLi[0].APTS_Online_Contacts_Validation__c =true;
            update propLi[0];
            
            propLi[1].APTS_Online_Contacts_Validation__c =true;
            update propLi[1];
            
            delete propLi[0];
            delete propLi[1];
            
            Apttus_Proposal__Proposal_Line_Item__c plItem14 = new Apttus_Proposal__Proposal_Line_Item__c(   
            Apttus_QPConfig__LineStatus__c = 'New',       
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Tax Professional',
            Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false);
            insert plItem14;
            
            Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(Asset_Auto_Number__c= 'ALI-10',
            Apttus_QPConfig__ProposalId__c = proposal.id,APTS_Proposal_Business_Unit__c= 'Tax Professional');
            insert ali;
            
            Apttus_Proposal__Proposal_Line_Item__c plItem15 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'Renewed',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Tax Professional',
            Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Online_Contacts_Validation__c=false);
            insert plItem15;
            
            
            
            test.stopTest();
  //    }
    }
        
       /*Code Ends Here DOC-7682(Product Variant)*/
       
       @isTest static void testpopulateproductvariantmenthod() 
        {
      
      List<Apttus_Proposal__Proposal_Line_Item__c> listProposal= new List<Apttus_Proposal__Proposal_Line_Item__c>();
      listProposal=[select id,Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.name from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.name=:'abc'];
      System.assertequals('abc',listProposal[0].Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.name,'Success');

          test.startTest(); 
          if(listProposal!=null)
          {
                APTS_ProposalLineItemTriggerHelper.populateProductVariant(listProposal);
          }
           test.stopTest();
        } 
      
             /*Code Ends Here DOC-7682(Product Variant)*/
  // Added by Chintan - Class was throwing error in MERGE. so increased coverage
    public static testmethod void testMethodHighQ(){
            List<Apttus_Proposal__Proposal_Line_Item__c> propLi = [select id,APTS_Online_Contacts_Validation__c  from Apttus_Proposal__Proposal_Line_Item__c where APTS_Proposal_Business_Unit__c ='Canada' limit 1];
            Apttus_Proposal__Proposal__c proposal=[SELECT id,APTS_Contact_Validation_Flag__c,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c ='canada' LIMIT 1];
            Apttus_Config2__ProductConfiguration__c prodConfig=[SELECT id,name from Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:proposal.id];
            
            Latam_AssetItemAutoNumber__c autoNumberObject = new Latam_AssetItemAutoNumber__c();
            autoNumberObject.Auto_Format__c ='-';
            //autoNumberObject.Latam_Latest_Number__c=0;
            autoNumberObject.Starting_Number__c = 0;
            insert autoNumberObject;
            System.assertequals(0,autoNumberObject.Starting_Number__c,'Success');
            
             test.startTest(); 
            propLi[0].APTS_Online_Contacts_Validation__c =true;
            update propLi[0];
             
            Online_Contacts__c objOC = new Online_Contacts__c();
          objOC.Material__c = 'TestM';
          objOC.QuoteId__c = proposal.Id;
          insert objOC;
          
          Customer_Master_Contacts__c objCustM = new Customer_Master_Contacts__c();
          objCustM.Material__c = 'TestM';
          objCustM.Quote__c= proposal.Id;
          insert objCustM;
          
            
            Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(Asset_Auto_Number__c= 'ALI-10',
            Apttus_QPConfig__ProposalId__c = proposal.id,APTS_Proposal_Business_Unit__c= 'Tax Professional',
      Apttus_Config2__DeltaQuantity__c=5);
            insert ali;
            
            
            List<Apttus_Proposal__Proposal_Line_Item__c> lst = new LIst<Apttus_Proposal__Proposal_Line_Item__c >();
            Apttus_Proposal__Proposal_Line_Item__c plItem15 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'Renewed',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Tax Professional',
            Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Online_Contacts_Validation__c=false);
            insert plItem15;
        
            Apttus_Proposal__Proposal_Line_Item__c plItemBN = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'Renewed',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Tax Professional',
            Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Availability_Date__c = System.Today() - 4,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Online_Contacts_Validation__c=false);
            insert plItemBN;
        
            lst .add(plItem15);
            
            
            APTS_ProposalLineItemTriggerHelper.validateOnlineMasterFlags(lst );
        
            test.stopTest();
    }
    
    public static testmethod void testPopulateContractTerm(){
            Account a=[SELECT id,name from Account WHERE name='Test Account' LIMIT 1];
      //Fetching  opportunity 
      Opportunity oppty=[SELECT id,name from   Opportunity WHERE name='abc' LIMIT 1];
      //Fetching Proposal
      Apttus_Proposal__Proposal__c proposal=[SELECT id,APTS_Contact_Validation_Flag__c from Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal__c.Apttus_Proposal__Opportunity__r.name='abc' LIMIT 1];
        
      Apttus_Config2__ProductConfiguration__c prodConfig=[SELECT id,name from Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:proposal.id];
           
            Latam_AssetItemAutoNumber__c autoNumberObject = new Latam_AssetItemAutoNumber__c();
            autoNumberObject.Auto_Format__c ='-';
            //autoNumberObject.Latam_Latest_Number__c=0;
            autoNumberObject.Starting_Number__c = 0;
            insert autoNumberObject;
            System.assertequals(0,autoNumberObject.Starting_Number__c,'Success');
            
            List<Product2> lstProduct2 = new List<Product2>();
            Product2 ProdSubScription1=new Product2(Name ='Test CPW Product',
            ProductCode = '41318124',
            APTS_Availability_Date__c = System.Today() - 7,
            APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family,
            APTS_Product_Pricing_Model__c = 'Proview OTC');
            lstProduct2.add(ProdSubScription1);
            
            Product2 ProdSubScription2=new Product2(Name ='Test CPW Product',
            ProductCode = '41318124',
            APTS_Availability_Date__c = System.Today() - 7,
            APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family,
            APTS_Product_Pricing_Model__c = 'Print Finished');
            lstProduct2.add(ProdSubScription2);
            
            Product2 ProdSubScription3=new Product2(Name ='Test CPW Product',
            ProductCode = '41318124',
            APTS_Availability_Date__c = System.Today() - 7,
            APTS_Cat_L5__c= Label.APTS_GSCPW_RP_Product_Family,
            APTS_Product_Pricing_Model__c = 'Print Finished No Service');
            lstProduct2.add(ProdSubScription3);
        
            Product2 ProdSubScription4=new Product2(Name ='Test CPW Product',
            ProductCode = '41318124',
            APTS_Availability_Date__c = System.Today() - 7,
            Family= System.Label.Caseline_Product_Family,
            APTS_Product_Pricing_Model__c = 'Print Finished No Service');
            lstProduct2.add(ProdSubScription4);
            
            
            List<Apttus_Proposal__Proposal_Line_Item__c> lst = new LIst<Apttus_Proposal__Proposal_Line_Item__c >();
        
            Apttus_Proposal__Proposal_Line_Item__c plItemBN = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '06',
            APTS_Media_Lower_Level_Code__c ='65',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription4.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Item_Category_Group__c = 'ZVAM',
            APTS_Online_Contacts_Validation__c=false
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst .add(plItemBN);

            Apttus_Proposal__Proposal_Line_Item__c plItemBN1 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '06',
            APTS_Media_Lower_Level_Code__c ='65',
            APTS_Availability_Date__c = System.Today() + 7,
            APTS_Cat_L2__c = System.Label.APTS_HighQ_Product_Family,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Item_Category_Group__c = 'ZVAM',
            APTS_Online_Contacts_Validation__c=false
           //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst .add(plItemBN1);
        
            Apttus_Proposal__Proposal_Line_Item__c plItemBN2 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Item_Category_Group__c = 'ZVAM',
            APTS_Online_Contacts_Validation__c=false
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst .add(plItemBN2);
        
            Apttus_Proposal__Proposal_Line_Item__c plItemBN3 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Item_Category_Group__c = 'ZVAM',
            APTS_Product_Pricing_Model__c = 'Print Finished',
            APTS_Online_Contacts_Validation__c=false
           //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst .add(plItemBN3);
        
            Apttus_Proposal__Proposal_Line_Item__c plItem15 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Item_Category_Group__c = 'ZVAM',
            APTS_Online_Contacts_Validation__c=false,
            Purchase_Option_Bundle_Print__c = 'Ship & Entitle Sub'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            //insert plItem15;
            lst .add(plItem15);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem1 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '02',
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Item_Category_Group__c = 'ZVAM',
            APTS_Online_Contacts_Validation__c=false
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst .add(plItem1);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem2 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '08',
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
           // Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c = 'Print Finished',
            APTS_Online_Contacts_Validation__c=false,
            Purchase_Option_Bundle_Print__c = 'Ship & Entitle Only'
           // ,Apttus_QPConfig__BillToAccountId__c = a.Id
           );
            lst.add(plItem2);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '21',
            APTS_Media_Lower_Level_Code__c = 'CQ',
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Item_Category_Group__c = 'ZVAM',
            APTS_Online_Contacts_Validation__c=false,Purchase_Option_Bundle_Print__c = 'Sub Only'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            //insert plItem1;
            lst.add(plItem3);
            
            
            Apttus_Proposal__Proposal_Line_Item__c plItem4 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='SCS',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            //Apttus_Proposal__Product__c = prod3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Product_Pricing_Model__c = 'Print Finished',
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem4);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem5 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='SCS',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            //APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription1.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Product_Pricing_Model__c = 'Print Finished No Service',
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem5);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem6 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            //APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription2.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem6);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem7 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            //APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            //Apttus_QPConfig__AttributeValueId__c = objPAV2.Id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem7);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem8 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            //Apttus_QPConfig__AssetLineItemId__c = ali.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem8);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem9 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem9);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem10 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem10);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem11 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem11);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem12 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem12);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem13 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem13);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem14 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem14);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem16 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem16);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem17 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem17);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem18 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='SCS',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '09',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem18);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem19 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='SCS',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '09',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false
            //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem19);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem20 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='SCS',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '09',
            APTS_Product_Pricing_Model__c = 'Proview OTC',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            APTS_Online_Contacts_Validation__c=false 
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem20);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem21 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='SCS',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '09',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee'
                //,Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem21);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem22 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='SCS',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '09',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem22);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem23 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='SCS',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '09',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem23);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem24 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            //Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '02',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee',Purchase_Option_Bundle_Print__c = 'Ship & Entitle Sub'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem24);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem25 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '07',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee',Purchase_Option_Bundle_Print__c = 'Ship & Entitle Sub',
            APTS_Item_Category_Group__c = 'ZVAM',
            APTS_Product_Pricing_Model__c = 'Print Finished No Service'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem25);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem26 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '08',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem26);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem27 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '21',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee',
            APTS_Media_Lower_Level_Code__c = 'CQ'
           // Apttus_QPConfig__BillToAccountId__c = a.Id
           );
            lst.add(plItem27);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem28 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '21',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee',
            APTS_Product_Pricing_Model__c = 'Proview OTC'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem28);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem29 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '21',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem29);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem30 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '21',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem30);
            
            Apttus_Proposal__Proposal_Line_Item__c plItem31 = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_QPConfig__LineStatus__c = 'New',          
            Apttus_Proposal__Quantity__c=1,
            APTS_Proposal_Business_Unit__c='Canada',
            Apttus_QPConfig__LineType__c = 'Product/Service',
            Apttus_QPConfig__LineNumber__c = 1, 
            Apttus_QPConfig__ItemSequence__c = 1,
            Apttus_QPConfig__NetPrice__c=1,
            APTS_Media_High_Level_Code__c = '21',
            APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Proposal__Product__c = ProdSubScription3.Id,
            Apttus_Proposal__Proposal__c=proposal.id,
            Apttus_QPConfig__ChargeType__c='Subscription Fee'
            //Apttus_QPConfig__BillToAccountId__c = a.Id
            );
            lst.add(plItem31);
            
            test.startTest(); 
            
            insert lst;
            
            List<Apttus_QPConfig__ProposalProductAttributeValue__c> PLIAttributeValue = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem8.Id,
            SCS_Print_Purchase_Options__c = 'Ship & Enter Sub APP'
            );
            PLIAttributeValue.add(objPAV);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV1 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem16.Id,
            SCS_Print_Purchase_Options__c = 'Ship & Enter Sub'
            );
            PLIAttributeValue.add(objPAV1);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV2 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem9.Id,
            SCS_Print_Purchase_Options__c = 'Fill-Up & Enter Sub APP'
            );
            PLIAttributeValue.add(objPAV2);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV3 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem10.Id,
            SCS_Print_Purchase_Options__c = 'Sub Only'
            );
            PLIAttributeValue.add(objPAV3);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV4 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem11.Id,
            SCS_Print_Purchase_Options__c = 'Sub Only APP'
            );
            PLIAttributeValue.add(objPAV4);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV5 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem12.Id,
            SCS_Print_Purchase_Options__c = 'Ship Only'
            );
            PLIAttributeValue.add(objPAV5);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV6 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem13.Id,
            SCS_Print_Purchase_Options__c = 'Fill-Up & Enter Sub'
            );
            PLIAttributeValue.add(objPAV6);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV7 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem14.Id,
            SCS_Print_Purchase_Options__c = 'Fill-Up'
            );
            PLIAttributeValue.add(objPAV7);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV8 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem17.Id,
            eBook_Purchase_Options__c= 'App'
            );
            PLIAttributeValue.add(objPAV8);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV9 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem19.Id,
            eBook_Purchase_Options__c= 'Entitle and Charge'
            );
            PLIAttributeValue.add(objPAV9);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV10 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem21.Id,
            SCS_Print_Purchase_Options__c= 'Entitle & Enter Subscription'
            );
            PLIAttributeValue.add(objPAV10);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV11 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem23.Id,
            SCS_Print_Purchase_Options__c= 'Fill-Up & Enter Sub APP'
            );
            PLIAttributeValue.add(objPAV11);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV12 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem24.Id,
            SCS_Print_Purchase_Options__c= 'Fill-Up'
            );
            PLIAttributeValue.add(objPAV12);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV13 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem29.Id,
            eBook_Purchase_Options__c = 'APP'
            );
            PLIAttributeValue.add(objPAV13);
            
            Apttus_QPConfig__ProposalProductAttributeValue__c objPAV14 = new Apttus_QPConfig__ProposalProductAttributeValue__c(
            Apttus_QPConfig__LineItemId__c = plItem30.Id,
            eBook_Purchase_Options__c = 'Entitle and Charge'
            );
            PLIAttributeValue.add(objPAV14);
            
            insert PLIAttributeValue;
            
            List<Apttus_Proposal__Proposal_Line_Item__c> lsttoUpdate = new List<Apttus_Proposal__Proposal_Line_Item__c >();
            plItem1.Apttus_QPConfig__ItemSequence__c  = 2;
            plItem2.Apttus_QPConfig__ItemSequence__c  = 2;
            plItem3.Apttus_QPConfig__ItemSequence__c  = 2;
            plItem4.Apttus_QPConfig__ItemSequence__c  = 2;
            plItem5.Apttus_QPConfig__ItemSequence__c  = 2;
            plItem6.Apttus_QPConfig__ItemSequence__c  = 2;
            plItem7.Apttus_QPConfig__ItemSequence__c  = 2;
            plItem8.Apttus_QPConfig__ItemSequence__c = 2;
            plItem9.Apttus_QPConfig__ItemSequence__c = 2;
            plItem10.Apttus_QPConfig__ItemSequence__c = 2;
            plItem11.Apttus_QPConfig__ItemSequence__c = 2;
            plItem12.Apttus_QPConfig__ItemSequence__c = 2;
            plItem13.Apttus_QPConfig__ItemSequence__c = 2;
            plItem14.Apttus_QPConfig__ItemSequence__c = 2;
            plItem15.Apttus_QPConfig__ItemSequence__c = 2;
            plItem16.Apttus_QPConfig__ItemSequence__c = 2;
            plItem17.Apttus_QPConfig__ItemSequence__c = 2;
            plItem18.Apttus_QPConfig__ItemSequence__c = 2;
            plItem19.Apttus_QPConfig__ItemSequence__c = 2;
            plItem20.Apttus_QPConfig__ItemSequence__c = 2;
            plItem21.Apttus_QPConfig__ItemSequence__c = 2;
            plItem22.Apttus_QPConfig__ItemSequence__c = 2;
            plItem23.Apttus_QPConfig__ItemSequence__c = 2;
            plItem24.Apttus_QPConfig__ItemSequence__c = 2;
            plItem25.Apttus_QPConfig__ItemSequence__c = 2;
            plItem26.Apttus_QPConfig__ItemSequence__c = 2;
            plItem27.Apttus_QPConfig__ItemSequence__c = 2;
            plItem28.Apttus_QPConfig__ItemSequence__c = 2;
            plItem29.Apttus_QPConfig__ItemSequence__c = 2;
            plItem30.Apttus_QPConfig__ItemSequence__c = 2;
            plItem31.Apttus_QPConfig__ItemSequence__c = 2;
            lsttoUpdate.add(plItem31);
            lsttoUpdate.add(plItem30);
            lsttoUpdate.add(plItem29);
            lsttoUpdate.add(plItem28);
            lsttoUpdate.add(plItem27);
            lsttoUpdate.add(plItem26);
            lsttoUpdate.add(plItem25);
            lsttoUpdate.add(plItem24);
            lsttoUpdate.add(plItem23);
            lsttoUpdate.add(plItem22);
            lsttoUpdate.add(plItem21);
            lsttoUpdate.add(plItem20);
            lsttoUpdate.add(plItem19);
            lsttoUpdate.add(plItem18);
            lsttoUpdate.add(plItem17);
            lsttoUpdate.add(plItem16);
            lsttoUpdate.add(plItem14);
            lsttoUpdate.add(plItem13);
            lsttoUpdate.add(plItem12);
            lsttoUpdate.add(plItem11);
            lsttoUpdate.add(plItem10);
            lsttoUpdate.add(plItem9);
            lsttoUpdate.add(plItem8);
            lsttoUpdate.add(plItem7);
            lsttoUpdate.add(plItem6);
            lsttoUpdate.add(plItem5);
            lsttoUpdate.add(plItem4);
            lsttoUpdate.add(plItem3);
            lsttoUpdate.add(plItem2);
            update lsttoUpdate;
            
            APTS_ProposalLineItemTriggerHelper.populateContractTermSubscription(lsttoUpdate);
        
            test.stopTest();
    }
    
public static testmethod void testMethodBN(){

    WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
    insert oWebServiceSettings ;

    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    
    Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
    insert priceList;        
    
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
    String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();


    Account accBN = new Account(RecordTypeId=accRecordTypeId,FrozenMarketSegment__c = valueMarket,name='test-sg',sales_org__c='WEST',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
    accBN.APTS_Customer_Category__c = '';
    accBN.Is_GLI__c = True;
    insert accBN;   

    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.RecordtypeId=ssdRecorType;
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=accBN.ID;
    accountSSD.APTS_Customer_Category__c='1';
    accountSSD.LCRM_Customer_Group__c='Academic';
    accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
    accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='WEST';
    accountSSD.APTS_Has_Online_Assets__c=true;
    ssdList.add(accountSSD);

    insert ssdList;

    Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
    
    User u = new User(Alias = 'sattudt', Email='sattu@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='chan', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = prof.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='sattu@testorg.com', Sub_Bu__c = 'LMS');
    insert u; 
    
    //Inserting KeyValueStore
    List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
    KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
    keyvaluestore.Name='ANZUsersProfileId';
    keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
    keyvaluestoreList.add(keyvaluestore); 
    KeyValueListStore__c keyval = new KeyValueListStore__c();
    keyval.Name='ReasonWithCompetitor';
    keyval.TextValue__c='Price';
    keyvaluestoreList.add(keyval);
    insert keyvaluestoreList;
    
    //Inserting recordLists
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
            
    Date todaysDate = system.today();
    Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
    Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=accBN.id,Source_System_Detail__c=accountSSD.id);
    insert o;
    
    Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
    List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c >();
    
    Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_Proposal_Business_Unit__c ='SCS');
    p.APTS_LMS_Catalog__c =  True;
    proposalList.add(p);

    insert proposalList;

    List<Apttus_Config2__ProductConfiguration__c> pconfigList = new List<Apttus_Config2__ProductConfiguration__c >();
    Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
    pconfigList.add(prodConf);

    insert pconfigList;
    
    Product2 prod1=new Product2(Name ='Test',ProductCode = '41972767',APTS_Availability_Date__c = System.Today() - 7,Family = System.Label.Caseline_Product_Family);
    Product2 prod2=new Product2(Name ='Test1',ProductCode = '41318125',APTS_Media_High_Level_Code__c ='13',APTS_Media_Lower_Level_Code__c ='PQ',APTS_Availability_Date__c = System.Today() - 7,Family = System.Label.Caseline_Product_Family);
    Product2 prod3=new Product2(Name ='Test2',ProductCode = '41318126',APTS_Media_High_Level_Code__c ='13',APTS_Media_Lower_Level_Code__c ='PQ',Family = System.Label.Caseline_Product_Family);

    List<Product2> productList=new List<Product2>{prod1,prod2,prod3};
    insert productList;
    
    test.startTest();
  
    List<Apttus_Config2__AssetLineItem__c> lstAli = new List<Apttus_Config2__AssetLineItem__c>();
    Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(
    Asset_Auto_Number__c= 'ALI-10',
    Apttus_QPConfig__ProposalId__c = p.id,
    APTS_Proposal_Business_Unit__c= 'SCS',
    Apttus_Config2__DeltaQuantity__c=5,
    APTS_Info_RenewalDate__c = System.Today(),
    Apttus_Config2__BillToAccountId__c = accBN.Id,
    APTS_SSD_Sold_To__c = accountSSD.Id,
    Apttus_Config2__ProductId__c = prod2.Id,
    APTS_SAP_MLA_Agreement_Number__c ='0000106651'
    );
    lstAli.add(ali);

    Apttus_Config2__AssetLineItem__c ali1 = new Apttus_Config2__AssetLineItem__c(
    Asset_Auto_Number__c= 'ALI-10',
    Apttus_QPConfig__ProposalId__c = p.id,
    APTS_Proposal_Business_Unit__c= 'SCS',
    Apttus_Config2__DeltaQuantity__c=5,
    APTS_Info_RenewalDate__c = System.Today(),
    Apttus_Config2__BillToAccountId__c = accBN.Id,
    APTS_SSD_Sold_To__c = accountSSD.Id,
    APTS_SAP_MLA_Agreement_Number__c ='0000106651',
    Apttus_Config2__ProductId__c = prod1.Id
    );
    
    Apttus_Config2__AssetLineItem__c ali3 = new Apttus_Config2__AssetLineItem__c(
    Asset_Auto_Number__c= 'ALI-10',
    Apttus_QPConfig__ProposalId__c = p.id,
    APTS_Proposal_Business_Unit__c= 'SCS',
    Apttus_Config2__DeltaQuantity__c=5,
    APTS_Info_RenewalDate__c = System.Today(),
    Apttus_Config2__BillToAccountId__c = accBN.Id,
    APTS_SSD_Bill_To__c = accountSSD.Id,
    APTS_SAP_MLA_Agreement_Number__c ='0000106652',
    Apttus_Config2__ProductId__c = prod3.Id
    );
    System.debug('AssetLineItemBN************'+ali1);
    lstAli.add(ali1);
    lstAli.add(ali3);
    System.debug('AssetLineItemBN2************'+lstAli);
    insert lstAli;
    
    
    List<Apttus_Proposal__Proposal_Line_Item__c> lst = new LIst<Apttus_Proposal__Proposal_Line_Item__c >();
    Apttus_Proposal__Proposal_Line_Item__c plItem15 = new Apttus_Proposal__Proposal_Line_Item__c(
    Apttus_QPConfig__LineStatus__c = 'Renewed',          
    Apttus_Proposal__Quantity__c=1,
    APTS_Proposal_Business_Unit__c='Tax Professional',
    Apttus_QPConfig__ConfigurationId__c = prodConf.id, 
    Apttus_QPConfig__LineType__c = 'Product/Service',
    Apttus_QPConfig__LineNumber__c = 1, 
    Apttus_QPConfig__ItemSequence__c = 1,
    Apttus_QPConfig__NetPrice__c=1,
    APTS_Availability_Date__c = System.Today() + 7,
    Apttus_Proposal__Product__c = prod2.Id,
    Apttus_Proposal__Proposal__c=p.id,
    Apttus_QPConfig__AssetLineItemId__c = ali.id,
    APTS_Online_Contacts_Validation__c=false,
    Apttus_QPConfig__BillToAccountId__c =accBN.Id);
    lst.add(plItem15);

    Apttus_Proposal__Proposal_Line_Item__c plItemBN = new Apttus_Proposal__Proposal_Line_Item__c(
    Apttus_QPConfig__LineStatus__c = 'Renewed',          
    Apttus_Proposal__Quantity__c=1,
    APTS_Proposal_Business_Unit__c='Tax Professional',
    Apttus_QPConfig__ConfigurationId__c = prodConf.id, 
    Apttus_QPConfig__LineType__c = 'Product/Service',
    Apttus_QPConfig__LineNumber__c = 1, 
    Apttus_QPConfig__ItemSequence__c = 1,
    Apttus_QPConfig__NetPrice__c=1,
    APTS_Availability_Date__c = System.Today() + 7,
    Apttus_Proposal__Product__c = prod1.Id,
    Apttus_Proposal__Proposal__c=p.Id,
    Apttus_QPConfig__AssetLineItemId__c = ali1.Id,
    APTS_Online_Contacts_Validation__c=false,
    Apttus_QPConfig__BillToAccountId__c =accBN.Id
    );
    lst.add(plItemBN);
    
    Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(
    Apttus_QPConfig__LineStatus__c = 'Renewed',          
    Apttus_Proposal__Quantity__c=1,
    APTS_Proposal_Business_Unit__c='Tax Professional',
    Apttus_QPConfig__ConfigurationId__c = prodConf.id, 
    Apttus_QPConfig__LineType__c = 'Product/Service',
    Apttus_QPConfig__LineNumber__c = 1, 
    Apttus_QPConfig__ItemSequence__c = 1,
    Apttus_QPConfig__NetPrice__c=1,
    APTS_Availability_Date__c = System.Today() + 7,
    Apttus_Proposal__Product__c = prod3.Id,
    Apttus_Proposal__Proposal__c=p.Id,
    Apttus_QPConfig__AssetLineItemId__c = ali3.Id,
    APTS_Online_Contacts_Validation__c=false,
    Apttus_QPConfig__BillToAccountId__c =accBN.Id
    );
    lst.add(plItem3);
    
    insert lst;
    List<Apttus_Proposal__Proposal_Line_Item__c> lsyPLIToUpdate = new List<Apttus_Proposal__Proposal_Line_Item__c>();
    plItemBN.APTS_Online_Contacts_Validation__c=false;
    plItem15.APTS_Online_Contacts_Validation__c=false;
    lsyPLIToUpdate.add(plItemBN);
    lsyPLIToUpdate.add(plItem15);
    lsyPLIToUpdate.add(plItem3);
    update lsyPLIToUpdate;
    
    APTS_ProposalLineItemTriggerHelper.updateLapseDate(lsyPLIToUpdate);

    test.stopTest();
}
    
public static testmethod void testMethodBNN(){

    WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
    Active__c = true,
    Name = 'Payment AutoCharge',
    Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
    Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
    insert oWebServiceSettings ;

    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    
    Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
    insert priceList;        
    
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
    String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();


    Account accBN = new Account(RecordTypeId=accRecordTypeId,FrozenMarketSegment__c = valueMarket,name='test-sg',sales_org__c='WEST',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
    accBN.APTS_Customer_Category__c = '';
    accBN.Is_GLI__c = True;
    insert accBN;   

    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
    List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
    accountSSD.RecordtypeId=ssdRecorType;
    accountSSD.Name='ABC';
    accountSSD.Source_System_Name__c='ABC';
    accountSSD.Account_Name__c=accBN.ID;
    accountSSD.APTS_Customer_Category__c='1';
    accountSSD.LCRM_Customer_Group__c='Academic';
    accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
    accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='WEST';
    accountSSD.APTS_Has_Online_Assets__c=true;
    ssdList.add(accountSSD);

    insert ssdList;

    Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
    
    User u = new User(Alias = 'sattudt', Email='sattu@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='chan', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = prof.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='sattu@testorg.com', Sub_Bu__c = 'LMS');
    insert u; 
    
    //Inserting KeyValueStore
    List<KeyValueListStore__c> keyvaluestoreList = new List<KeyValueListStore__c>();
    KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
    keyvaluestore.Name='ANZUsersProfileId';
    keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
    keyvaluestoreList.add(keyvaluestore); 
    KeyValueListStore__c keyval = new KeyValueListStore__c();
    keyval.Name='ReasonWithCompetitor';
    keyval.TextValue__c='Price';
    keyvaluestoreList.add(keyval);
    insert keyvaluestoreList;
    
    //Inserting recordLists
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
            
    Date todaysDate = system.today();
    Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
    Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='pipeline',accountId=accBN.id,Source_System_Detail__c=accountSSD.id);
    insert o;
    
    Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
    List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c >();
    
    Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_Proposal_Business_Unit__c ='SCS');
    p.APTS_LMS_Catalog__c =  True;
    proposalList.add(p);

    insert proposalList;

    List<Apttus_Config2__ProductConfiguration__c> pconfigList = new List<Apttus_Config2__ProductConfiguration__c >();
    Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
    pconfigList.add(prodConf);

    insert pconfigList;
    
    Product2 prod1=new Product2(Name ='Test',ProductCode = '41972767',APTS_Availability_Date__c = System.Today() - 7,Family = System.Label.Caseline_Product_Family);
    Product2 prod2=new Product2(Name ='Test1',ProductCode = '41318125',APTS_Media_High_Level_Code__c ='13',APTS_Media_Lower_Level_Code__c ='PQ',APTS_Availability_Date__c = System.Today() - 7,Family = System.Label.Caseline_Product_Family);
    Product2 prod3=new Product2(Name ='Test2',ProductCode = '41318126',APTS_Media_High_Level_Code__c ='13',APTS_Media_Lower_Level_Code__c ='PQ',Family = System.Label.Caseline_Product_Family);

    List<Product2> productList=new List<Product2>{prod1,prod2,prod3};
    insert productList;
    
    test.startTest();
  
    List<Apttus_Config2__AssetLineItem__c> lstAli = new List<Apttus_Config2__AssetLineItem__c>();
    Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(
    Asset_Auto_Number__c= 'ALI-10',
    Apttus_QPConfig__ProposalId__c = p.id,
    APTS_Proposal_Business_Unit__c= 'SCS',
    Apttus_Config2__DeltaQuantity__c=5,
    APTS_Info_RenewalDate__c = System.Today(),
    Apttus_Config2__BillToAccountId__c = accBN.Id,
    APTS_SSD_Sold_To__c = accountSSD.Id,
    Apttus_Config2__ProductId__c = prod2.Id,
    APTS_SAP_MLA_Agreement_Number__c ='0000106651',
    Apttus_Config2__AssetStatus__c='Activated'
    );
    lstAli.add(ali);

    Apttus_Config2__AssetLineItem__c ali1 = new Apttus_Config2__AssetLineItem__c(
    Asset_Auto_Number__c= 'ALI-10',
    Apttus_QPConfig__ProposalId__c = p.id,
    APTS_Proposal_Business_Unit__c= 'SCS',
    Apttus_Config2__DeltaQuantity__c=5,
    APTS_Info_RenewalDate__c = System.Today(),
    Apttus_Config2__BillToAccountId__c = accBN.Id,
    APTS_SSD_Sold_To__c = accountSSD.Id,
    APTS_SAP_MLA_Agreement_Number__c ='0000106651',
    Apttus_Config2__ProductId__c = prod1.Id,
    Apttus_Config2__AssetStatus__c='Activated'
    );
    
    Apttus_Config2__AssetLineItem__c ali3 = new Apttus_Config2__AssetLineItem__c(
    Asset_Auto_Number__c= 'ALI-10',
    Apttus_QPConfig__ProposalId__c = p.id,
    APTS_Proposal_Business_Unit__c= 'SCS',
    Apttus_Config2__DeltaQuantity__c=5,
    APTS_Info_RenewalDate__c = System.Today(),
    Apttus_Config2__BillToAccountId__c = accBN.Id,
    APTS_SSD_Bill_To__c = accountSSD.Id,
    APTS_SAP_MLA_Agreement_Number__c ='0000106652',
    Apttus_Config2__ProductId__c = prod3.Id,
    Apttus_Config2__AssetStatus__c='Activated'
    );
    System.debug('AssetLineItemBN************'+ali1);
    lstAli.add(ali1);
    lstAli.add(ali3);
    System.debug('AssetLineItemBN2************'+lstAli);
    insert lstAli;
    
    
    List<Apttus_Proposal__Proposal_Line_Item__c> lst = new LIst<Apttus_Proposal__Proposal_Line_Item__c >();
    Apttus_Proposal__Proposal_Line_Item__c plItem15 = new Apttus_Proposal__Proposal_Line_Item__c(
    Apttus_QPConfig__LineStatus__c = 'Cancelled',          
    Apttus_Proposal__Quantity__c=1,
    APTS_Proposal_Business_Unit__c='Tax Professional',
    Apttus_QPConfig__ConfigurationId__c = prodConf.id, 
    Apttus_QPConfig__LineType__c = 'Product/Service',
    Apttus_QPConfig__LineNumber__c = 1, 
    Apttus_QPConfig__ItemSequence__c = 1,
    Apttus_QPConfig__NetPrice__c=1,
    APTS_Availability_Date__c = System.Today() + 7,
    Apttus_Proposal__Product__c = prod2.Id,
    Apttus_Proposal__Proposal__c=p.id,
    Apttus_QPConfig__AssetLineItemId__c = ali.id,
    APTS_Online_Contacts_Validation__c=false,
    Apttus_QPConfig__BillToAccountId__c =accBN.Id);
    lst.add(plItem15);

    Apttus_Proposal__Proposal_Line_Item__c plItemBN = new Apttus_Proposal__Proposal_Line_Item__c(
    Apttus_QPConfig__LineStatus__c = 'Cancelled',          
    Apttus_Proposal__Quantity__c=1,
    APTS_Proposal_Business_Unit__c='Tax Professional',
    Apttus_QPConfig__ConfigurationId__c = prodConf.id, 
    Apttus_QPConfig__LineType__c = 'Product/Service',
    Apttus_QPConfig__LineNumber__c = 1, 
    Apttus_QPConfig__ItemSequence__c = 1,
    Apttus_QPConfig__NetPrice__c=1,
    APTS_Availability_Date__c = System.Today() + 7,
    Apttus_Proposal__Product__c = prod1.Id,
    Apttus_Proposal__Proposal__c=p.Id,
    Apttus_QPConfig__AssetLineItemId__c = ali1.Id,
    APTS_Online_Contacts_Validation__c=false,
    Apttus_QPConfig__BillToAccountId__c =accBN.Id
    );
    lst.add(plItemBN);
    
    Apttus_Proposal__Proposal_Line_Item__c plItem3 = new Apttus_Proposal__Proposal_Line_Item__c(
    Apttus_QPConfig__LineStatus__c = 'Cancelled',          
    Apttus_Proposal__Quantity__c=1,
    APTS_Proposal_Business_Unit__c='Tax Professional',
    Apttus_QPConfig__ConfigurationId__c = prodConf.id, 
    Apttus_QPConfig__LineType__c = 'Product/Service',
    Apttus_QPConfig__LineNumber__c = 1, 
    Apttus_QPConfig__ItemSequence__c = 1,
    Apttus_QPConfig__NetPrice__c=1,
    APTS_Availability_Date__c = System.Today() + 7,
    Apttus_Proposal__Product__c = prod3.Id,
    Apttus_Proposal__Proposal__c=p.Id,
    Apttus_QPConfig__AssetLineItemId__c = ali3.Id,
    APTS_Online_Contacts_Validation__c=false,
    Apttus_QPConfig__BillToAccountId__c =accBN.Id
    );
    lst.add(plItem3);
    
    insert lst;
    List<Apttus_Proposal__Proposal_Line_Item__c> lsyPLIToUpdate = new List<Apttus_Proposal__Proposal_Line_Item__c>();
    plItemBN.APTS_Online_Contacts_Validation__c=false;
    plItem15.APTS_Online_Contacts_Validation__c=false;
    lsyPLIToUpdate.add(plItemBN);
    lsyPLIToUpdate.add(plItem15);
    lsyPLIToUpdate.add(plItem3);
    update lsyPLIToUpdate;
    
    APTS_ProposalLineItemTriggerHelper.updateLapseDate(lsyPLIToUpdate);

    test.stopTest();
}

}