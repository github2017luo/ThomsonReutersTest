@isTest
public Class AutoPayment_Update_Trigger_Test {
    public static final string USL_RECORDTPYE='USL_Source_Systems';   
    public static testMethod void AutoPayment_Update_Trigger() {
        Account oAccount = new Account(Name='Pathra Test', SAPAccountNumber__c ='11334455', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount;       
        Contact oContact = new Contact(FirstName='S',LastName='Pathra',Account=oAccount);
        insert oContact;
        //Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        //insert priceList;
        List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert WebserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456',billingstreet='2225 Saint pauls',Billingcity='Phoenix', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;
        System.assertEquals(acc.billingstreet,'2225 Saint pauls');       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id);
        insert cont;
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
         Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
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
        
        };insert keyValueList;
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
      Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(opp.id, accountSSD.Id);
        oProposal.Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        oProposal.Apttus_Proposal__Account__c=oAccount.Id;
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.APTS_Order_Confirmation_Contact__c=oContact.id;
        oProposal.Digital_Quote_Type__c='Manual';
        oProposal.APTS_PaymentGateway_URL__c='www';
        insert oProposal;
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=oProposal.Id);
        insert order;
        oProposal = [SELECT APTS_Order_Confirmation_Contact_Name__c FROM Apttus_Proposal__Proposal__c where id=:oProposal.Id];
        //oproposal.APTS_Payment_Option__c = 'Payment Express Auto EFT/Auto Charge';
        //update oProposal;  
    }

    /*public static testMethod void AutoPayment_Update_TriggerTester() {
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
            List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert WebserviceList;  
        Account acc = new Account(Name='Mansi Test', SAPAccountNumber__c ='11334456', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;       
        Contact cont = new Contact(FirstName='Mansi',LastName='N',AccountId=acc.Id);
        insert cont;
        system.debug('contact '+cont);
        Apttus_Config2__PriceList__c priceList  = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        Apttus_Proposal__Proposal__c prop = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c =' Proposal Test', APTS_PaymentGateway_URL__c='www',Apttus_Proposal__Account__c = acc.Id,APTS_Payment_Option__c = 'Payment Express Auto EFT/Auto Charge',APTS_Order_Confirmation_Contact__c = cont.Id,
                                                                                OwnerId = usr.id );
        insert prop; 
        //prop.APTS_Order_Confirmation_Contact__c = cont.Id;
        //update prop;
        system.debug('prop...'+ prop);
        system.debug('prop...'+ prop.owner.name);
        //system.debug('prop.APTS_Order_Confirmation_Contact__c..'+prop.APTS_Order_Confirmation_Contact__c);
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www');
        insert order;*/
        /*Apttus_Config2__Order__c order2 = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=prop.Id,PaymentUrl__c='www.google.com');
        insert order;*/
        
       /* order.PaymentUrl__c = 'www.google.com';
        update order;

     
     } */  
        
        
    }