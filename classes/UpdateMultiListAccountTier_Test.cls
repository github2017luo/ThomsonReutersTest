@isTest
public Class UpdateMultiListAccountTier_Test {
  /**
* @description AutoPaymentUpdateTrigger
*/
    public static testMethod void autoPaymentUpdateTrigger() {
    
        Account oAccount = new Account(Name='Pathra Test', SAPAccountNumber__c ='11334455', billingStreet='saint pauls',BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount;       
        Contact oContact = new Contact(FirstName='S',LastName='Pathra',Account=oAccount);
        insert oContact;
        ////Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        //insert priceList;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls','not equal');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id);
        insert cont;
        system.debug(LoggingLevel.WARN,'contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
         Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
         Source_System_Detail__c accountSSD= new Source_System_Detail__c();
         accountSSD.RecordtypeId=ssdRecorType;
         accountSSD.Name='ABC';
         accountSSD.Source_System_Name__c='ABC';
         accountSSD.Account_Name__c=acc.ID;
         accountSSD.Source_System_Account_Number__c='12312312';
         accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
         accountSSD.Account_Inactive__c=false;
         //accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
         //accountSSD.LCRM_Industry__c='TAX';
         
          insert accountSSD;
      List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
        
        };
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
         Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
      opp.RecordtypeId=opptyRecorType;
      opp.source_system_detail__c= accountSSD.id;
      opp.key_contact__c= cont.id;
      insert opp;
      Test.startTest();
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Opportunity__c=opp.id,Apttus_Proposal__Proposal_Name__c ='Pathra Proposal Test', APTS_PaymentGateway_URL__c='',Apttus_Proposal__Account__c = oAccount.Id,APTS_Payment_Option__c = 'Credit Card',APTS_Order_Confirmation_Contact__r=oContact,Digital_Quote_Type__c='Manual');
        insert oProposal; 
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=oProposal.Id);
        insert order;
        oProposal = [SELECT APTS_Order_Confirmation_Contact_Name__c FROM Apttus_Proposal__Proposal__c where id=:oProposal.Id];
        oproposal.APTS_Payment_Option__c = 'Auto EFT/Auto Charge';
        update oProposal;  
     Test.stopTest();
    }
  /**
* @description autoPaymentUpdateTriggerTester
*/
    public static testMethod void autoPaymentUpdateTriggerTester() {
      /*  Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(LastName = 'testcoverage',
                           FirstName='coverage123',
                           Alias = 'jliv',
                           Email = 'testcoverage123@asdf.com',
                           Username = 'testcoverage123@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
           insert usr; */
           List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls','not equal');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id);
        insert cont;
        system.debug(LoggingLevel.WARN,'contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
         Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
         Source_System_Detail__c accountSSD= new Source_System_Detail__c();
         accountSSD.RecordtypeId=ssdRecorType;
         accountSSD.Name='ABC';
         accountSSD.Source_System_Name__c='ABC';
         accountSSD.Account_Name__c=acc.ID;
         accountSSD.Source_System_Account_Number__c='12312312';
         accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
         accountSSD.Account_Inactive__c=false;
         //accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
         //accountSSD.LCRM_Industry__c='TAX';
         
          insert accountSSD;
                            
      List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)
        
        };
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
      Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
      Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
      opp.RecordtypeId=opptyRecorType;
      opp.source_system_detail__c= accountSSD.id;
      opp.key_contact__c= cont.id;
      insert opp;
      
      //  accountSSD.Source_System_Account_Number__c='7777777';
      //  update accountSSD;
       Test.startTest();
        Apttus_Proposal__Proposal__c prop = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Opportunity__c=opp.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Proposal__Proposal_Name__c =' Proposal Test', APTS_PaymentGateway_URL__c='www',Apttus_Proposal__Account__c = acc.Id,APTS_Payment_Option__c = 'Payment Express Auto EFT/Auto Charge',APTS_Order_Confirmation_Contact__c = cont.Id,Digital_Quote_Type__c='Manual'
                                                                                );
        insert prop; 
         //Inserting product configuration
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(prop.Id);
        insert prodConfig;
         List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c plItem2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          APTS_Media_High_Level__c='Online',
          APTS_Online_Contacts_Validation__c=FALSE,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
            IP_Address_Check__c=false,
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          Apttus_Proposal__Proposal__c=prop.id);
        lineItemList1.add(plItem2);
        insert lineItemList1;
        //prop.APTS_Order_Confirmation_Contact__c = cont.Id;
        //update prop;
        //System.assertEquals(prop.Apttus_Proposal__Account__r.billingstreet,'2225 Saint pauls');
        system.debug(LoggingLevel.WARN,'prop...'+ prop);
        system.debug(LoggingLevel.WARN,'prop...'+ prop.owner.name);
        //system.debug('prop.APTS_Order_Confirmation_Contact__c..'+prop.APTS_Order_Confirmation_Contact__c);
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www');
        insert order;
       /* Apttus_Config2__Order__c order2 = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www.google.com');
        insert order;
        
        order.PaymentUrl__c = 'www.google.com';
        update order;*/
        accountSSD.Source_System_Account_Number__c='7777777';
        update accountSSD;
        
        PaymentgatewayUtil pg = new PaymentgatewayUtil();
    pg.creditcard(prop);
    Test.stopTest();
     
    }   
        
/**
* @description testforupdatedelete
*/
    public static testMethod void testforupdatedelete() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(LastName = 'User',FirstName='Informatica',Alias = 'jliv',Email = 'Informatica.User@asdf.com',Username = 'Informatica.User@asdf.com',ProfileId = profileId.id,TimeZoneSidKey = 'GMT',LanguageLocaleKey = 'en_US',EmailEncodingKey = 'UTF-8',LocaleSidKey = 'en_US',Segment__c = 'Professional Legal');
        insert usr;
        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert webserviceList; 
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id)};
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls','not equal');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id);
        insert cont;
        System.debug(LoggingLevel.WARN,'contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        Test.startTest();
        System.runAs(usr){
            Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.RecordtypeId=ssdRecorType;
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=acc.ID;
            accountSSD.Source_System_Account_Number__c='12312312';
            accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
            accountSSD.Account_Inactive__c=false;
            insert accountSSD;
            delete accountSSD;
        }                  
        Test.stopTest();
    }
}