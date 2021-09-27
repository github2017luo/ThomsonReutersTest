@istest
public class generateCreditCardUrlController_test {
    public static testMethod void testController(){
        Test.startTest();
        
        WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
    Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
   insert shippingMethod;
   List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment Credit Card',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
         new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert WebserviceList;        
  Account acc = new Account();
  acc.Name='test';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
   accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='CARS';
    accountSSD.Source_System_Account_Number__c ='9476937';
  insert accountSSD;
  
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
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
 
        Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
       Contact oContact = UnitTest.getContactInstance(acc.Id);
       oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
        
        Apttus_Proposal__Proposal__c testQuote= New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Pathra Proposal Test', Apttus_Proposal__Account__c = acc.Id,Apttus_Proposal__Opportunity__c = oppty.Id);
        //testQuote.LATAM_APTS_Payment_Method__c='Credit Card AMEX';
        testQuote.APTS_Order_Confirmation_Contact__c = oContact.id;
        insert testQuote;

        Apttus_Proposal__Proposal__c testprop=[select APTS_SSD_Sold_To__c,Languagecode__c  from Apttus_Proposal__Proposal__c where id=: testQuote.id];
        Test.setCurrentPage(Page.generateCreditCardPaymentUrl);
        generateCreditCardPaymentUrlController con = new generateCreditCardPaymentUrlController (new ApexPages.StandardController(testQuote));
        //ApexPages.standardController sc = new ApexPages.standardController(testQuote.id);
        //generateCreditCardPaymentUrlController con = new generateCreditCardPaymentUrlController(sc);
        con.gatewayURL='text';
        system.assertEquals(testprop.Languagecode__c ,'en_us');
        
        Test.stopTest();
    }   
            
    public static testMethod void testController2(){
        Test.startTest();
        
          WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
           List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
         new WebServiceSettings__c(Name='Payment Credit Card',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
         new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert WebserviceList;        
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
       accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
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
 
        Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
       Contact oContact = UnitTest.getContactInstance(acc.Id);
       oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        oContact.ESC_tocLanguage__c = 'French-Canadian ';
      insert oContact;
  
      
        Apttus_Proposal__Proposal__c testQuotefr = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Pathra Proposal Test', Apttus_Proposal__Account__c = acc.Id,Apttus_Proposal__Opportunity__c = oppty.Id,APTS_Payment_Option__c = 'Credit Card');
        //testQuotefr.LATAM_APTS_Payment_Method__c='Credit Card AMEX';
        testQuotefr.APTS_Order_Confirmation_Contact__c = oContact.id;
        insert testQuotefr;
 
        Apttus_Proposal__Proposal__c testQuote2=new Apttus_Proposal__Proposal__c();
        testQuote2.id=testQuotefr.id;
        //testQuote2.LATAM_APTS_Payment_Method__c='Credit Card Diners';
        testQuote2.APTS_Order_Confirmation_Contact__c = oContact.id;
        testQuote2.APTS_Proposal_Business_Unit__c='Canada';
        Update testQuote2;
                                system.debug('Business unit'+testQuote2.APTS_Proposal_Business_Unit__c);
        System.debug('test data'+testQuote2);
        Apttus_Proposal__Proposal__c testprop1 =[select APTS_SSD_Sold_To__c,Languagecode__c  from Apttus_Proposal__Proposal__c where id=: testQuotefr.id];
       
        ApexPages.standardController sc1 = new ApexPages.standardController(testQuotefr);
        generateCreditCardPaymentUrlController con1 = new generateCreditCardPaymentUrlController(sc1);
        con1.gatewayURL='text';
        system.assertEquals(testprop1 .Languagecode__c ,'fr_CA');
        Test.stopTest();
    }      
}