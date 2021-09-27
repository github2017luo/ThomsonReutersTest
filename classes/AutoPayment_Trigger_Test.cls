@isTest
public Class AutoPayment_Trigger_Test {
    public static testMethod void AutoPayment_Update_Trigger() {
        
        Account oAccount = new Account(Name='Pathra Test', SAPAccountNumber__c ='11334455', billingStreet='saint pauls',BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount;       
        Contact oContact = new Contact(FirstName='S',LastName='Pathra',Account=oAccount);
        insert oContact;
        ////Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        //insert priceList;
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                insert WebserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id);
        insert cont;
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
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
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
                
                };
                    KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
        opp.RecordtypeId=opptyRecorType;
        opp.source_system_detail__c= accountSSD.id;
        opp.key_contact__c= cont.id;
        insert opp;
        Test.startTest();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        oProposal.Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        oProposal.Apttus_Proposal__Account__c=oAccount .Id;
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.APTS_Order_Confirmation_Contact__r=oContact;
        oProposal.Digital_Quote_Type__c='Manual';
        oProposal.APTS_Assent_Customer_Name__c='TEst';
        oProposal.APTS_Proposal_Business_Unit__c ='CANADA';
        oProposal.APTS_SSD_Sold_To__c= accountSSD.Id;
        insert oProposal; 
        
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=oProposal.Id);
        insert order;
        oProposal = [SELECT Name,APTS_Order_Confirmation_Contact_Name__c,APTS_Assent_Customer_Name__c,APTS_Payment_Option__c,
                     APTS_Order_Confirmation_Contact__c,APTS_SSD_Sold_To__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                     APTS_Order_Confirmation_Contact__r.Email,APTS_SSD_Sold_To__r.Name,APTS_Quote_Value__c,
                     APTS_SSD_Sold_To__r.Postal_Code__c,APTS_SSD_Sold_To__r.LCRM_Phone__c,APTS_SSD_Sold_To__r.Country__c,
                     APTS_SSD_Sold_To__r.State__c,APTS_SSD_Sold_To__r.Number_Street__c,APTS_SSD_Sold_To__r.City__c,APTS_Order_Confirmation_Contact__r.name,APTS_Proposal_Business_Unit__c
                     FROM Apttus_Proposal__Proposal__c where id=:oProposal.Id];
        
        PaymentgatewayUtil pg = new PaymentgatewayUtil();
        pg.encryption(oProposal);
        Test.stopTest();
    }
    
    public static testMethod void AutoPayment_Update_TriggerTester() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
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
        insert usr;
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                insert WebserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id);
        insert cont;
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.Source_System_Account_Number__c='12312312';
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
        accountSSD.Account_Inactive__c=false;
        accountSSD.City__c='california';
        //accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        //accountSSD.LCRM_Industry__c='TAX';
        
        insert accountSSD;
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
                
                };
                    KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
        opp.RecordtypeId=opptyRecorType;
        opp.source_system_detail__c= accountSSD.id;
        opp.key_contact__c= cont.id;
        insert opp;
        test.startTest();
        Apttus_Proposal__Proposal__c prop =APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        prop .Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        prop .Apttus_Proposal__Account__c=acc.Id;
        prop .APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge';
        prop .APTS_Order_Confirmation_Contact__c=cont.id;
        prop .Digital_Quote_Type__c='Manual';
        prop .APTS_PaymentGateway_URL__c='www';
        prop.ownerid=usr.id;
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
        system.debug('prop...'+ prop);
        system.debug('prop...'+ prop.owner.name);
        //system.debug('prop.APTS_Order_Confirmation_Contact__c..'+prop.APTS_Order_Confirmation_Contact__c);
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www');
        insert order;
        /*Apttus_Config2__Order__c order2 = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www.google.com');
insert order;*/
        
        order.PaymentUrl__c = 'www.google.com';
        update order;
        test.stoptest();
        
        PaymentgatewayUtil pg = new PaymentgatewayUtil();
        pg.creditcard(prop);
    }   
    
    public static testMethod void AutoPayment_Update_TriggerTesterCanada() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(LastName = 'testcoverage',
                            FirstName='coverage123',
                            Alias = 'jliv',
                            Email = 'testcoverage123@asdf.com',
                            Username = 'testcoverage123@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            Sub_Bu__c=label.SALESORGCAN
                           );
        insert usr;
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                insert WebserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id,ESC_tocLanguage__c = 'French-Canadian');
        insert cont;
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = label.canadaPriceList);
        insert priceList;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.Source_System_Account_Number__c='12312312';
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
        accountSSD.Account_Inactive__c=false;
        accountSSD.City__c='california';
        
        insert accountSSD;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
                
                };
                    KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
        opp.RecordtypeId=opptyRecorType;
        opp.source_system_detail__c= accountSSD.id;
        opp.key_contact__c= cont.id;
        insert opp;
        Test.starttest();
        Apttus_Proposal__Proposal__c prop =APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        prop.Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        prop.Apttus_Proposal__Account__c=acc.Id;
        prop .APTS_Payment_Option__c='Credit Card';
        prop.APTS_Order_Confirmation_Contact__c=cont.id;
        prop.Digital_Quote_Type__c='Manual';
        prop.APTS_PaymentGateway_URL__c='www';
        prop.ownerid=usr.id;
        prop.apts_proposal_business_unit__c=Label.SalesorgCan;
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
        
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www');
        insert order;
        prop .APTS_Payment_Option__c = 'Auto Charge';
        update prop ; 
        accountSSD.Source_System_Account_Number__c='7777777';
        update accountSSD;
        test.stoptest();
        PaymentgatewayUtil pg = new PaymentgatewayUtil();
        pg.creditcard(prop);
        pg.creditIncreaseEncryption(prop);
    }
    
    public static testMethod void AutoPayment_Update_TriggerTesterCorpUS() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(LastName = 'testcoverage',
                            FirstName='coverage123',
                            Alias = 'jliv',
                            Email = 'testcoverage123@asdf.com',
                            Username = 'testcoverage123@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            Sub_Bu__c=label.SALESORGCAN
                           );
        insert usr;
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                insert WebserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id,ESC_tocLanguage__c = 'French-Canadian');
        insert cont;
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = label.canadaPriceList);
        insert priceList;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.Source_System_Account_Number__c='12312312';
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
        accountSSD.Account_Inactive__c=false;
        accountSSD.City__c='california';
        
        insert accountSSD;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
                
                };
                    KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
        opp.RecordtypeId=opptyRecorType;
        opp.source_system_detail__c= accountSSD.id;
        opp.key_contact__c= cont.id;
        insert opp;
        
        Apttus_Proposal__Proposal__c prop =APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        prop.Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        prop.Apttus_Proposal__Account__c=acc.Id;
        prop .APTS_Payment_Option__c='Credit Card';
        prop.APTS_Order_Confirmation_Contact__c=cont.id;
        prop.Digital_Quote_Type__c='Manual';
        prop.APTS_PaymentGateway_URL__c='www';
        prop.ownerid=usr.id;
        prop.apts_proposal_business_unit__c='Corp OneOTC US';
        insert prop; 
        
        //Inserting product configuration
        /*Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(prop.Id);
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
        insert lineItemList1;*/
        test.startTest();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www');
        insert order;
        prop .APTS_Payment_Option__c = 'Auto Charge';
        update prop ; 
        accountSSD.Source_System_Account_Number__c='7777777';
        update accountSSD;
        PaymentgatewayUtil pg = new PaymentgatewayUtil();
        pg.creditcard(prop);
        pg.creditIncreaseEncryption(prop);
        test.stoptest();
    }
    
    public static testMethod void AutoPayment_Update_TriggerTesterTax() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(LastName = 'testcoverage',
                            FirstName='coverage123',
                            Alias = 'jliv',
                            Email = 'testcoverage123@asdf.com',
                            Username = 'testcoverage123@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            Sub_Bu__c='S100'
                           );
        insert usr;
        
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='DirectDebitPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment OneTimeEFT',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert WebserviceList;
        
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id,ESC_tocLanguage__c = 'French-Canadian');
        insert cont;
        
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = label.canadaPriceList);
        insert priceList;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.Source_System_Account_Number__c='12312312';
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
        accountSSD.Account_Inactive__c=false;
        accountSSD.City__c='california';        
        insert accountSSD;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
                };
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
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
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
        opp.RecordtypeId=opptyRecorType;
        opp.source_system_detail__c= accountSSD.id;
        opp.key_contact__c= cont.id;
        insert opp;
        
        
        Apttus_Proposal__Proposal__c prop =APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        prop.Apttus_Proposal__Proposal_Name__c ='Tax Prof Proposal Test';
        prop.Apttus_Proposal__Account__c=acc.Id;
        prop.APTS_Payment_Option__c='One Time EFT';
        prop.APTS_Order_Confirmation_Contact__c=cont.id;
        prop.Digital_Quote_Type__c='Manual';
        prop.APTS_PaymentGateway_URL__c='www';
        prop.ownerid=usr.id;
        prop.apts_proposal_business_unit__c='Tax Professional';
        insert prop; 
        
        //Inserting product configuration
        /*Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(prop.Id);
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
        insert lineItemList1;*/
        
        prop.APTS_Payment_Option__c='One Time EFT';
        update prop;
        test.startTest();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www');
        insert order;
        accountSSD.Source_System_Account_Number__c='7777777';
        update accountSSD;
        PaymentgatewayUtil pg = new PaymentgatewayUtil();
        pg.directdebit(prop);
        test.stoptest();
    }
    
    
    public static testMethod void AutoPayment_Update_TriggerTesterTax2() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(LastName = 'testcoverage',
                            FirstName='coverage123',
                            Alias = 'jliv',
                            Email = 'testcoverage123@asdf.com',
                            Username = 'testcoverage123@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            Sub_Bu__c='S100'
                           );
        insert usr;
        insert new GLI_OC_Bulk_Load__c(SetupOwnerId=Userinfo.getUserId(),APTS_Disable_Triggers__c=TRUE);
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='DirectDebitPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment OneTimeEFT',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert WebserviceList;
        
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id,ESC_tocLanguage__c = 'French-Canadian');
        insert cont;
        
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = label.canadaPriceList);
        insert priceList;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.Source_System_Account_Number__c='12312312';
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
        accountSSD.Account_Inactive__c=false;
        accountSSD.City__c='california';        
        insert accountSSD;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
                };
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
        
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
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
        opp.RecordtypeId=opptyRecorType;
        opp.source_system_detail__c= accountSSD.id;
        opp.key_contact__c= cont.id;
        insert opp;
        
        
        Apttus_Proposal__Proposal__c prop =APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        prop.Apttus_Proposal__Proposal_Name__c ='Tax Prof Proposal Test';
        prop.Apttus_Proposal__Account__c=acc.Id;
        prop.APTS_Payment_Option__c='One Time EFT';
        prop.APTS_Order_Confirmation_Contact__c=cont.id;
        prop.Digital_Quote_Type__c='Manual';
        prop.APTS_PaymentGateway_URL__c='www';
        prop.ownerid=usr.id;
        prop.apts_proposal_business_unit__c='Tax Professional';
        insert prop; 
        
        //Inserting product configuration
        /*Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(prop.Id);
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
        insert lineItemList1;*/
        
        prop.APTS_Payment_Option__c='One Time EFT';
        update prop;
        test.startTest();
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www');
        insert order;
        accountSSD.Source_System_Account_Number__c='7777777';
        update accountSSD;
        PaymentgatewayUtil pg = new PaymentgatewayUtil();
        pg.directdebit(prop);
        test.stoptest();
    }
    
   public static testMethod void AutoPayment_Update_TriggerTester_RY() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
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
        insert usr;
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='LatamStatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='latamPostback',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                insert WebserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id);
        insert cont;
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=acc.ID;
        accountSSD.Source_System_Account_Number__c='12312312';
        accountSSD.LCRM_Frozen_Market_Segment__c = 'Federal Government';
        accountSSD.Account_Inactive__c=false;
        accountSSD.City__c='california';
        //accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        //accountSSD.LCRM_Industry__c='TAX';
        
        insert accountSSD;
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
            new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='0122a0000008UO1')
                
                };
                    KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
        insert keyValueList;
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
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(acc.id);
        opp.RecordtypeId=opptyRecorType;
        opp.source_system_detail__c= accountSSD.id;
        opp.key_contact__c= cont.id;
        insert opp;
        test.startTest();
        Apttus_Proposal__Proposal__c prop =APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        prop .Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        prop .Apttus_Proposal__Account__c=acc.Id;
        prop .APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge';
        prop .APTS_Order_Confirmation_Contact__c=cont.id;
        prop .Digital_Quote_Type__c='Manual';
        prop .APTS_PaymentGateway_URL__c='www';
        prop.ownerid=usr.id;
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
        system.debug('prop...'+ prop);
        system.debug('prop...'+ prop.owner.name);
        //system.debug('prop.APTS_Order_Confirmation_Contact__c..'+prop.APTS_Order_Confirmation_Contact__c);
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www');
        //insert order;
        /*Apttus_Config2__Order__c order2 = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www.google.com');
insert order;*/
        List<Apttus_Config2__Order__c> newOrderList  = new List<Apttus_Config2__Order__c>();
        newOrderList.add(order);
        AutoPayment_TriggerHandler.doAfterInsert(newOrderList);
        //order.PaymentUrl__c = 'www.google.com';
       //update order;
        test.stoptest();
        
        AutoPayment_TriggerHandler.checkAutoPayment();
        
      
    }   
}