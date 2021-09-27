@isTest
private class APTS_CORP_LineItemTriggerHelperTest {
    private static testmethod void testmethod1(){
        list<Decimal> dollarValues = new List<Decimal>(); 
        
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
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
       
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
   
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty; 
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c='Corp OneOTC US';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        insert proposal;
        
        Product2 prodObj = new Product2();
          prodObj.Name = '1SRC ITC Essentials';
          prodObj.IsActive= true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.APTS_Price_call__c=true;
          prodObj.ProductCode='42533744';
          insert prodObj; 
        
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
       
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        //prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        //prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;
        
           List<Apttus_Config2__LineItem__c> ListOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
              Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='New';
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
           // linObj1.APTS_Calculated_Year_1__c=10.0;
            linObj1.APTS_Contract_Term__c ='Short Term Trial';
            linobj1.APTS_Bridge__c='11 Months';
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO.id; 
             linobj1.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj1);
           
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__Quantity__c=1;
            linObj2.Apttus_Config2__ProductId__c=prodObj.id;
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj2.Apttus_Config2__LineType__c = 'Product/Service';
            linObj2.Apttus_Config2__LineNumber__c = 1;
            linObj2.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj2.Apttus_Config2__ItemSequence__c = 3;
            linObj2.Apttus_Config2__NetPrice__c=10.0;            
            linObj2.Apttus_Config2__OptionPrice__c = 15.0;
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'Recurring';
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.Apttus_Config2__LineStatus__c='Renewed';
            linObj2.Apttus_Config2__AdjustmentType__c=null;
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.APTS_Contract_Term__c ='2 Years';
            linObj2.APTS_Yr_2_Amount__c=10.0;
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj2.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj2);
        
         Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__Quantity__c=1;
            linObj3.Apttus_Config2__ProductId__c=prodObj.id;
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj3.Apttus_Config2__LineType__c = 'Product/Service';
            linObj3.Apttus_Config2__LineNumber__c = 1;
            linObj3.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj3.Apttus_Config2__ItemSequence__c = 3;
            linObj3.Apttus_Config2__NetPrice__c=10.0;            
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__Frequency__c = 'Monthly';
            linObj3.Apttus_Config2__PriceType__c = 'Recurring';
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.Apttus_Config2__LineStatus__c='Renewed';
            linObj3.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c ='3 Years';
            linObj3.APTS_Yr_2_Amount__c=10.0;
            linObj3.APTS_Yr_3_Amount__c=20.0;   //Changed from 0 to 20
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj3.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c();
            linObj4.Apttus_Config2__Quantity__c=1;
            linObj4.Apttus_Config2__ProductId__c=prodObj.id;
            linObj4.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj4.Apttus_Config2__LineType__c = 'Product/Service';
            linObj4.Apttus_Config2__LineNumber__c = 1;
            linObj4.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj4.Apttus_Config2__ItemSequence__c = 3;
            linObj4.Apttus_Config2__NetPrice__c=10.0;            
            linObj4.Apttus_Config2__OptionPrice__c = 15.0;
            linObj4.Apttus_Config2__Frequency__c = 'Monthly';
            linObj4.Apttus_Config2__PriceType__c = 'Recurring';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.Apttus_Config2__LineStatus__c='Renewed';
            linObj4.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c ='4 Years';
            linObj4.APTS_Yr_2_Amount__c=10.0;
            linObj4.APTS_Yr_3_Amount__c=15.0;
            linObj4.APTS_Yr_4_Amount__c=20.0;
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj4.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj4);
        
        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c();
            linObj5.Apttus_Config2__Quantity__c=1;
            linObj5.Apttus_Config2__ProductId__c=prodObj.id;
            linObj5.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj5.Apttus_Config2__LineType__c = 'Product/Service';
            linObj5.Apttus_Config2__LineNumber__c = 1;
            linObj5.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj5.Apttus_Config2__ItemSequence__c = 3;
            linObj5.Apttus_Config2__NetPrice__c=10.0;            
            linObj5.Apttus_Config2__OptionPrice__c = 15.0;
            linObj5.Apttus_Config2__Frequency__c = 'Monthly';
            linObj5.Apttus_Config2__PriceType__c = 'Recurring';
            linObj5.Apttus_Config2__PriceAdjustment__c=0;
            linObj5.Apttus_Config2__LineStatus__c='Renewed';
            linObj5.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj5.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj5.APTS_Contract_Term__c ='5 Years';
            linObj5.APTS_Yr_2_Amount__c=10.0;
            linObj5.APTS_Yr_3_Amount__c=15.0;
            linObj5.APTS_Yr_4_Amount__c=20.0;
            linObj5.APTS_Yr_5_Amount__c=25.0;
            linObj5.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj5.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj5);
           
           Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c();
            linObj6.Apttus_Config2__Quantity__c=1;
            linObj6.Apttus_Config2__ProductId__c=prodObj.id;
            linObj6.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj6.Apttus_Config2__LineType__c = 'Product/Service';
            linObj6.Apttus_Config2__LineNumber__c = 1;
            linObj6.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj6.Apttus_Config2__ItemSequence__c = 3;
            linObj6.Apttus_Config2__NetPrice__c=10.0;            
            linObj6.Apttus_Config2__OptionPrice__c = 15.0;
            linObj6.Apttus_Config2__Frequency__c = 'Monthly';
            linObj6.Apttus_Config2__PriceType__c = 'Recurring';
            linObj6.Apttus_Config2__PriceAdjustment__c=0;
            linObj6.Apttus_Config2__LineStatus__c='New';
            linObj6.APTS_Price_Cap_Adjustment_Percentage__c = 1;
           // linObj6.APTS_Calculated_Year_1__c=10.0;
            linObj6.APTS_Contract_Term__c ='1 Year';
            //linobj6.APTS_Bridge__c='11 Months';
            linObj6.Apttus_Config2__PriceListItemId__c = pliSO.id; 
             linobj6.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj6);
           
           
           Test.startTest();
             insert ListOfLineItems1;    
           Test.stopTest();
        
    }
    private static testmethod void testmethod2(){      
        list<Decimal> dollarValues = new List<Decimal>(); 
        

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
        
         List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
       
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
   
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty; 
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c='Corp OneOTC US';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        insert proposal;
        
        Product2 prodObj = new Product2();
          prodObj.Name = '1SRC ITC Essentials';
          prodObj.IsActive= true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.APTS_Price_call__c=true;
          prodObj.ProductCode='42533744';
          insert prodObj; 
        
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
       
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        //prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        //prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;
        
           List<Apttus_Config2__LineItem__c> ListOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
        
          

          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c();
            linObj.Apttus_Config2__Quantity__c=1;
            linObj.Apttus_Config2__ProductId__c=prodObj.id;
            linObj.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj.Apttus_Config2__LineType__c = 'Product/Service';
            linObj.Apttus_Config2__LineNumber__c = 1;
            linObj.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj.Apttus_Config2__ItemSequence__c = 3;
            linObj.Apttus_Config2__NetPrice__c=10.0;            
            linObj.Apttus_Config2__OptionPrice__c = 15.0;
            linObj.Apttus_Config2__Frequency__c = 'Monthly';
            linObj.Apttus_Config2__PriceType__c = 'Recurring';
            linObj.Apttus_Config2__PriceAdjustment__c=0;
            linObj.Apttus_Config2__LineStatus__c='Renewed';
            linObj.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj.APTS_Contract_Term__c ='2 Years';
            linObj.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj);
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='Renewed';
            linObj1.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj1.APTS_Contract_Term__c ='3 Years';
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj1.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj1);
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__Quantity__c=1;
            linObj2.Apttus_Config2__ProductId__c=prodObj.id;
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj2.Apttus_Config2__LineType__c = 'Product/Service';
            linObj2.Apttus_Config2__LineNumber__c = 1;
            linObj2.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj2.Apttus_Config2__ItemSequence__c = 3;
            linObj2.Apttus_Config2__NetPrice__c=10.0;            
            linObj2.Apttus_Config2__OptionPrice__c = 15.0;
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'Recurring';
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.Apttus_Config2__LineStatus__c='Renewed';
            linObj2.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.APTS_Contract_Term__c ='4 Years';
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj2.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj2);
            
         Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__Quantity__c=1;
            linObj3.Apttus_Config2__ProductId__c=prodObj.id;
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj3.Apttus_Config2__LineType__c = 'Product/Service';
            linObj3.Apttus_Config2__LineNumber__c = 1;
            linObj3.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj3.Apttus_Config2__ItemSequence__c = 3;
            linObj3.Apttus_Config2__NetPrice__c=10.0;            
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__Frequency__c = 'Monthly';
            linObj3.Apttus_Config2__PriceType__c = 'Recurring';
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.Apttus_Config2__LineStatus__c='Renewed';
            linObj3.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c ='5 Years';
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj3.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj3);

           Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c();
            linObj4.Apttus_Config2__Quantity__c=1;
            linObj4.Apttus_Config2__ProductId__c=prodObj.id;
            linObj4.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj4.Apttus_Config2__LineType__c = 'Product/Service';
            linObj4.Apttus_Config2__LineNumber__c = 1;
            linObj4.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj4.Apttus_Config2__ItemSequence__c = 3;
            linObj4.Apttus_Config2__NetPrice__c=10.0;            
            linObj4.Apttus_Config2__OptionPrice__c = 15.0;
            linObj4.Apttus_Config2__Frequency__c = 'Monthly';
            linObj4.Apttus_Config2__PriceType__c = 'Recurring';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.Apttus_Config2__LineStatus__c='Renewed';
            linObj4.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c ='5 Years';
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj4.APTS_Years_2_Plus_Adjustment__c='0';
            linobj4.APTS_Term_Type__c='Co-Term';
            linobj4.APTS_Start_Date__c=System.Today();
            linobj4.APTS_End_Date__c=System.Today()+30;
           ListOfLineItems1.add(linObj4);
           
           Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c();
            linObj5.Apttus_Config2__Quantity__c=1;
            linObj5.Apttus_Config2__ProductId__c=prodObj.id;
            linObj5.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj5.Apttus_Config2__LineType__c = 'Product/Service';
            linObj5.Apttus_Config2__LineNumber__c = 1;
            linObj5.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj5.Apttus_Config2__ItemSequence__c = 3;
            linObj5.Apttus_Config2__NetPrice__c=10.0;            
            linObj5.Apttus_Config2__OptionPrice__c = 15.0;
            linObj5.Apttus_Config2__Frequency__c = 'Monthly';
            linObj5.Apttus_Config2__PriceType__c = 'Recurring';
            linObj5.Apttus_Config2__PriceAdjustment__c=0;
            linObj5.Apttus_Config2__LineStatus__c='Renewed';
            linObj5.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj5.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj5.APTS_Contract_Term__c ='5 Years';
            linObj5.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj5.APTS_Years_2_Plus_Adjustment__c='0';
            linobj5.APTS_Term_Type__c='Co-Term';
           ListOfLineItems1.add(linObj5);

           Test.startTest();
        insert ListOfLineItems1;      
        Test.stopTest();
        
    }
    private static testmethod void testmethod3(){      
        list<Decimal> dollarValues = new List<Decimal>(); 
        

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
        
         List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='TA78';
        insert accountSSD;
       
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
   
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty; 
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c='Corp OneOTC US';
        proposal.Apttus_Proposal__Account__c=a.id;
        proposal.Apttus_Proposal__Opportunity__c=oppty.id;
        insert proposal;
        
        Product2 prodObj = new Product2();
          prodObj.Name = '1SRC ITC Essentials';
          prodObj.IsActive= true;
          prodObj.CurrencyIsoCode = 'USD';
          prodObj.APTS_Price_call__c=true;
          prodObj.ProductCode='42533744';
          insert prodObj; 
        
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
        
       
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BusinessObjectId__c = proposal.Id;
        prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        //prodConfig.Apttus_Config2__BillToAccountId__c = a.Id;
        prodConfig.APTS_SSD_bill_to__c= accountSSD.id;
        prodConfig.APTS_SSD_ship_to__c= accountSSD.id; 
        //prodConfig.Apttus_Config2__ShipToAccountId__c = a.Id;
        prodConfig.Apttus_Config2__AccountId__c = a.Id;
        prodConfig.Apttus_Config2__PriceListId__c = plSO.Id;
        prodConfig.Apttus_Config2__Status__c = 'New';
        insert prodConfig;
        
           List<Apttus_Config2__LineItem__c> ListOfLineItems1 = New List<Apttus_Config2__LineItem__c>();
           List<Apttus_Config2__LineItem__c> ListOfLineItems2 = New List<Apttus_Config2__LineItem__c>();
          

          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c();
            linObj.Apttus_Config2__Quantity__c=1;
            linObj.Apttus_Config2__ProductId__c=prodObj.id;
            linObj.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj.Apttus_Config2__LineType__c = 'Product/Service';
            linObj.Apttus_Config2__LineNumber__c = 1;
            linObj.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj.Apttus_Config2__ItemSequence__c = 3;
            linObj.Apttus_Config2__NetPrice__c=10.0;            
            linObj.Apttus_Config2__OptionPrice__c = 15.0;
            linObj.Apttus_Config2__Frequency__c = 'Monthly';
            linObj.Apttus_Config2__PriceType__c = 'Recurring';
            linObj.Apttus_Config2__PriceAdjustment__c=0;
            linObj.Apttus_Config2__LineStatus__c='Renewed';
            linObj.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj.APTS_Contract_Term__c ='5 Years';
            linObj.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj);
        
        Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c();
            linObj1.Apttus_Config2__Quantity__c=1;
            linObj1.Apttus_Config2__ProductId__c=prodObj.id;
            linObj1.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj1.Apttus_Config2__LineType__c = 'Product/Service';
            linObj1.Apttus_Config2__LineNumber__c = 1;
            linObj1.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj1.Apttus_Config2__ItemSequence__c = 3;
            linObj1.Apttus_Config2__NetPrice__c=10.0;            
            linObj1.Apttus_Config2__OptionPrice__c = 15.0;
            linObj1.Apttus_Config2__Frequency__c = 'Monthly';
            linObj1.Apttus_Config2__PriceType__c = 'Recurring';
            linObj1.Apttus_Config2__PriceAdjustment__c=0;
            linObj1.Apttus_Config2__LineStatus__c='Renewed';
            linObj1.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj1.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj1.APTS_Contract_Term__c ='5 Years';
            linObj1.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj1.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj1);
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__Quantity__c=1;
            linObj2.Apttus_Config2__ProductId__c=prodObj.id;
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj2.Apttus_Config2__LineType__c = 'Product/Service';
            linObj2.Apttus_Config2__LineNumber__c = 1;
            linObj2.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj2.Apttus_Config2__ItemSequence__c = 3;
            linObj2.Apttus_Config2__NetPrice__c=10.0;            
            linObj2.Apttus_Config2__OptionPrice__c = 15.0;
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'Recurring';
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.Apttus_Config2__LineStatus__c='Renewed';
            linObj2.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.APTS_Contract_Term__c ='5 Years';
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj2.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj2);
            
         Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__Quantity__c=1;
            linObj3.Apttus_Config2__ProductId__c=prodObj.id;
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj3.Apttus_Config2__LineType__c = 'Product/Service';
            linObj3.Apttus_Config2__LineNumber__c = 1;
            linObj3.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj3.Apttus_Config2__ItemSequence__c = 3;
            linObj3.Apttus_Config2__NetPrice__c=10.0;            
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__Frequency__c = 'Monthly';
            linObj3.Apttus_Config2__PriceType__c = 'Recurring';
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.Apttus_Config2__LineStatus__c='Renewed';
            linObj3.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c ='5 Years';
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj3.APTS_Years_2_Plus_Adjustment__c='0';
           ListOfLineItems1.add(linObj3);

           Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c();
            linObj4.Apttus_Config2__Quantity__c=1;
            linObj4.Apttus_Config2__ProductId__c=prodObj.id;
            linObj4.Apttus_Config2__ConfigurationId__c = prodConfig.id;
            linObj4.Apttus_Config2__LineType__c = 'Product/Service';
            linObj4.Apttus_Config2__LineNumber__c = 1;
            linObj4.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj4.Apttus_Config2__ItemSequence__c = 3;
            linObj4.Apttus_Config2__NetPrice__c=10.0;            
            linObj4.Apttus_Config2__OptionPrice__c = 15.0;
            linObj4.Apttus_Config2__Frequency__c = 'Monthly';
            linObj4.Apttus_Config2__PriceType__c = 'Recurring';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.Apttus_Config2__LineStatus__c='Renewed';
            linObj4.Apttus_Config2__AdjustmentType__c='Price Override';
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c ='5 Years';
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO.id; 
            linobj4.APTS_Years_2_Plus_Adjustment__c='0';
            linobj4.APTS_Term_Type__c='Co-Term';
            linobj4.APTS_Start_Date__c=System.Today();
            linobj4.APTS_End_Date__c=System.Today()+30;
           ListOfLineItems1.add(linObj4);

           insert ListOfLineItems1;
           Test.startTest();
           linObj.APTS_Contract_Term__c ='1 Year';
           linObj1.APTS_Contract_Term__c ='2 Years';
           linObj2.APTS_Contract_Term__c ='3 Years';
           linObj3.APTS_Contract_Term__c ='4 Years';
           ListOfLineItems2.add(linObj);
           ListOfLineItems2.add(linObj1);
           ListOfLineItems2.add(linObj2);
           ListOfLineItems2.add(linObj3);
           update ListOfLineItems2;
        Test.stopTest();
        
    }
     
}