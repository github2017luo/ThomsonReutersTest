@isTest
private class APTS_MultiLocationsControllerTest {
    
    @isTest static void testMethodOne() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
         
        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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

        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        
    /*    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        //accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        insert accountSSD;*/
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.id);
        insert proposal;
        
        Business_Partner_Function__c bpf = new Business_Partner_Function__c(Related_Account__c=a.id,Sold_To_Account__c=a.id,Related_Account_GLI__c = accountSSD.Id, Sold_To_Account_GLI__c = accountSSD.Id,Relationship_Type__c = 'WESTLAW Reporting');
        insert bpf;
        
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.Apttus_Config2__AccountId__c = a.Id;
        insert prodConfig;


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

    Product2 prodObj = new Product2();
      prodObj.Name = 'Network Services 1.0';
      prodObj.APTS_Media_High_Level_Code__c = '05';
      prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
      insert prodObj;  

      Product2 prod2Obj = new Product2();
      prod2Obj.Name = 'Network Services 2.0';
      prod2Obj.APTS_Media_High_Level_Code__c = '21';
      insert prod2Obj;    

      Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.APTS_SSD_Sold_To__c = accountSSD.Id;
      insert ali;

      APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
       proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;

    Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;

     Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__AssetLineItemId__c = ali.Id,
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
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
  
      Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;

        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.Id, 
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__PriceListItemId__c = pliSO3.id,
            APTS_Keep_Terms__c = true); 
        
        ListOfLineItems.add(linObj3);
          Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__PriceListItemId__c = pliSO3.id,
            APTS_Keep_Terms__c = false); 
        ListOfLineItems.add(linObj4);
     
        insert ListOfLineItems;
        
        //PMD fix for security - Added by Sakshi
        List<Apttus_Config2__ProductAttributeValue__c> pavList= new List<Apttus_Config2__ProductAttributeValue__c>();
        Apttus_Config2__ProductAttributeValue__c pavObj; 
        for (Apttus_Config2__LineItem__c lineItem : ListOfLineItems ) {
          pavObj = new Apttus_Config2__ProductAttributeValue__c(
            eBook_Purchase_Options__c = 'App',
            APTS_FillUp_Start_Date__c = date.today(),//.valueOf('1999-01-01'),
            Apttus_Config2__LineItemId__c = lineItem.id
          );
          //insert pavObj;
          pavList.add(pavObj);
        }
        insert pavList;
         

        string jsonData = '{"SourceSystemDetails": [{"ssd": {"Id": "'+accountSSD.id+'"}, "isSelected":true, "status":"New" }], "assetLineItems":[{"assetLineItem":{"Id":"'+ali.Id+'", "APTS_SSD_Sold_To__c ": "'+accountSSD.Id+'"}, "isSelected":true  }] }';
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('groupId', proposalGroup.Id);
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        APTS_MultiLocationsController multiController = new APTS_MultiLocationsController(new ApexPages.StandardController(prodConfig));
        
        
        multiController.doinit();
        multiController.saveData();
        Test.stopTest();

}
    @isTest static void testMethodOneTK() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
         
        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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

        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        
    /*    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        //accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        insert accountSSD;*/
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.id);
        insert proposal;
        
        Business_Partner_Function__c bpf = new Business_Partner_Function__c(Related_Account__c=a.id,Sold_To_Account__c=a.id,Related_Account_GLI__c = accountSSD.Id, Sold_To_Account_GLI__c = accountSSD.Id,Relationship_Type__c = 'WESTLAW Reporting');
        insert bpf;
        
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.Apttus_Config2__AccountId__c = a.Id;
        insert prodConfig;


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

    Product2 prodObj = new Product2();
      prodObj.Name = 'Network Services 1.0';
      prodObj.APTS_Media_High_Level_Code__c = '05';
      prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
      insert prodObj;  

      Product2 prod2Obj = new Product2();
      prod2Obj.Name = 'Network Services 2.0';
      prod2Obj.APTS_Media_High_Level_Code__c = '21';
      insert prod2Obj;    

      Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = '';
        ali.Apttus_Config2__AssetStatus__c = 'New';
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.APTS_SSD_Sold_To__c = accountSSD.Id;
      insert ali;

      APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Online/Software Bundle A';
       proposalGroup.APTS_Group_Name__c ='Online/Software Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;

    Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;

     Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__AssetLineItemId__c = ali.Id,
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Keep_Terms__c = false,
          Apttus_Config2__PriceListItemId__c = pliSO.id); 
      ListOfLineItems.add(linObj);
  
      Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;

        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.Id, 
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__PriceListItemId__c = pliSO3.id,
            APTS_Keep_Terms__c = true); 
        
        ListOfLineItems.add(linObj3);
          Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
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
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AssetLineItemId__c = ali.Id,
            Apttus_Config2__PriceListItemId__c = pliSO3.id,
            APTS_Keep_Terms__c = false); 
        ListOfLineItems.add(linObj4);
     
        insert ListOfLineItems;
        
        //PMD fix for security - Added by Sakshi
        List<Apttus_Config2__ProductAttributeValue__c> pavList= new List<Apttus_Config2__ProductAttributeValue__c>();
        Apttus_Config2__ProductAttributeValue__c pavObj; 
        for (Apttus_Config2__LineItem__c lineItem : ListOfLineItems ) {
          pavObj = new Apttus_Config2__ProductAttributeValue__c(
            eBook_Purchase_Options__c = 'App',
            APTS_FillUp_Start_Date__c = date.today(),//.valueOf('1999-01-01'),
            Apttus_Config2__LineItemId__c = lineItem.id
          );
          //insert pavObj;
          pavList.add(pavObj);
        }
        insert pavList;
         

        string jsonData = '{"SourceSystemDetails": [{"ssd": {"Id": "'+accountSSD.id+'"}, "isSelected":true, "status":"New" }], "assetLineItems":[{"assetLineItem":{"Id":"'+ali.Id+'", "APTS_SSD_Sold_To__c ": "'+accountSSD.Id+'"}, "isSelected":true  }] }';
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', prodConfig.id);
        ApexPages.currentPage().getParameters().put('groupId', proposalGroup.Id);
        ApexPages.currentPage().getParameters().put('JSONData', jsonData);
        APTS_MultiLocationsController multiController = new APTS_MultiLocationsController(new ApexPages.StandardController(prodConfig));
        
        
        multiController.doinit();
        multiController.saveData();
        multiController.openCartPage();
        
        Test.stopTest();

}
     @isTest static void test_method_two() {
         List<Id> accountIds = new List<Id>();
        APTS_MultiLocationsController.getAccountAssets(accountIds);
         
    }
    
    
}