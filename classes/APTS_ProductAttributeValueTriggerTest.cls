@isTest
private class APTS_ProductAttributeValueTriggerTest {
    
    private static final string USL_RECORDTPYE='USL_Source_Systems';
    //@testSetUp static void test_updateValidationFlag() 
    public static testmethod void testMethod_PAV()
    { 
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
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        insert keyvaluestore;
      //Inserting recordtype
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
        a.FrozenMarketSegment__c = valueMarket;
        a.Fiscal_Year_End__c = '01-Jan';
        Account a1 = APTS_TestDataFactory.createAccount('Test Account');
        a1.Fiscal_Year_End__c = '11-Nov';
        Account a2 = APTS_TestDataFactory.createAccount('Test Account');
        List<Account> accList = new List<Account>{a,a1,a2};
        insert accList;
        
      //Dynamic Retrieval of USL Source System recordType and Creating ssd object
         Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(Account_Name__c = a.id,Name=a.name,Source_System_Name__c=a.name,
        RecordtypeId=ssdRecorType,
        LCRM_Sales_Org__c='WEST',
        LCRM_Frozen_Market_Segment__c = valueMarket,
        Account_Inactive__c=false);
        Source_System_Detail__c accountSSD1= new Source_System_Detail__c(Account_Name__c = a.id,Name=a.name,Source_System_Name__c=a.name,
        RecordtypeId=ssdRecorType,
        LCRM_Sales_Org__c='S100',
        LCRM_Frozen_Market_Segment__c = valueMarket,
        Account_Inactive__c=false,APTS_Is_Customer__c = true,Source_System_Account_Number__c ='2000000584',Card_Number__c = 'XXXX-XXXX-XXXX-0004',Card_Type__c = 'VISA',Expiry_Date__c = System.today(),Default_Payment_Method__c = 'Payment Express Auto EFT/Auto Charge');
        List<Source_System_Detail__c> accountSSDlist = new List<Source_System_Detail__c>{accountSSD,accountSSD1};
        insert accountSSDlist;
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
        proposal.APTS_Fiscal_Filer__c = true;
        Apttus_Proposal__Proposal__c proposal1 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal1.Apttus_Proposal__Account__c = a1.Id;
        Apttus_Proposal__Proposal__c proposal2 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal2.Apttus_Proposal__Account__c = a2.Id;
        proposal2.APTS_Proposal_Business_Unit__c ='FindLaw';
        Apttus_Proposal__Proposal__c proposal3 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD1.Id);
        proposal3.Apttus_Proposal__Account__c = a2.Id;
        proposal3.APTS_Proposal_Business_Unit__c ='Tax Professional';
        proposal3.Tax_Payment_Option__c = 'Payment Express Auto EFT/Auto Charge';
        proposal3.APTS_Credit_Card_Token__c =  accountSSD1.Card_Number__c;
        proposal3.APTS_Card_Type__c = accountSSD1.Card_Type__c;
        proposal3.APTS_Card_Expiration_Date__c = accountSSD1.Expiry_Date__c;                                         
        proposal3.APTS_Payment_Option__c = accountSSD1.Default_Payment_Method__c;
        List<Apttus_Proposal__Proposal__c> proplist = new List<Apttus_Proposal__Proposal__c>{proposal,proposal1,proposal2,proposal3};
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
        List<Apttus_Config2__ProductConfiguration__c> prodconfiglist = new List<Apttus_Config2__ProductConfiguration__c>{prodConfig,prodConfig1,prodConfig2};
        insert prodconfiglist;
        
        Product2 prod3=new Product2(Name='Product_Test',
       ProductCode='2000',
       Apttus_Config2__ConfigurationType__c='Standalone',
       IsActive=true);
       
       insert prod3;
       
       APTS_Product_Variant__c pv=new APTS_Product_Variant__c(Name='Download_Product_Test',
       APTS_Product_Delivery__c='Download',
       APTS_Product__c=prod3.id,
       APTS_Product_ID__c=prod3.ProductCode,
       APTS_Product_Variant_ID__c='1234',
       CurrencyIsoCode='USD',
       APTS_Active__c=true
       );
       insert pv;
        
       APTS_Product_Variant__c pv1=new APTS_Product_Variant__c(Name='Download_Product_Test',
       APTS_Product_Delivery__c='Print',
       APTS_Product__c=prod3.id,
       APTS_Product_ID__c=prod3.ProductCode,
       APTS_Product_Variant_ID__c='12345',
       CurrencyIsoCode='USD',
       APTS_Active__c=true
       );
       insert pv1;
       
            Apttus_Config2__LineItem__c lItem16 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__LineStatus__c = 'New',          
            Apttus_Config2__Quantity__c=1,
            //APTS_Proposal_Business_Unit__c ='Tax Professional',
            Apttus_Config2__ConfigurationId__c = prodConfig2.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__NetPrice__c=1,
            //APTS_Availability_Date__c = System.Today() + 7,
            Apttus_Config2__ProductId__c = prod3.Id
            /*Apttus_Proposal__Proposal__c=proposal3.id,
            APTS_Online_Contacts_Validation__c=false*/);
            
            insert lItem16;
            List<Apttus_Config2__ProductAttributeValue__c> list_PAV= new List<Apttus_Config2__ProductAttributeValue__c>();
            
            Apttus_Config2__ProductAttributeValue__c Avalue=new Apttus_Config2__ProductAttributeValue__c(
            Apttus_Config2__LineItemId__c= lItem16.id,
            APTS_Product_Delivery__c='Download');
            list_PAV.add(Avalue);
            if(list_PAV!= null){
                insert list_PAV;                
            }
            //insert Avalue;
              
            lItem16.Apttus_Config2__AttributeValueId__c= Avalue.id;
            Avalue.APTS_Product_Delivery__c = 'Print';
            update Avalue;
            list_PAV.add(Avalue);
                              
            //list_Proposal.add(plItem16); 
           

            test.startTest(); 
          if(list_PAV!=null)
          {
                System.debug('Inside test block');
                APTS_ProductAttributeValueTriggerHelper.setLineItemFieldsPA(list_PAV);
          }
           test.stopTest();
    }
}