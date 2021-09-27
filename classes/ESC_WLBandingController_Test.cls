@IsTest
public class ESC_WLBandingController_Test 
{
    
    static testMethod void testcallOutHelper(){ 
        User testUserexp = new User(
            Alias = 'jonMay', 
            Email='jon-meyer@testorg.com',
            EmailEncodingKey='UTF-8', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'West',
            Sub_Bu__c='Usl',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='jon-meyer@thomsonreuters.com',
            LastName='jon-meyer'
        );
        insert testUserexp;
        
        system.runAs(testUserexp)
        {
            Account oAcct=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet',SAPAccountNumber__c ='1004628718');
            insert oAcct;
            
             Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        
        Source_System_Detail__c ssd= new Source_System_Detail__c();
        ssd.RecordtypeId=ssdRecorType;
        ssd.Name='ABC';
        ssd.Source_System_Name__c='ABC';
        ssd.Digital_Billing_City__c='tst';
        ssd.Account_Name__c=oAcct.ID;
        ssd.Source_System_Account_Number__c='1003530021';
        insert ssd;
           LIST<WebServiceSettings__c > webList = new LIST<WebServiceSettings__c>();
            WebServiceSettings__c web2 = new WebServiceSettings__c();
             web2.Endpoint__c = 'test.endpoint';
            web2.Name = 'ODTGenericEntitlementService';
            web2.Username__c = 'test.user';
            web2.Password__c = 'test:123';
            web2.Service_Unavailable_Message__c = 'testservice';
            webList.add(web2);
             insert webList;
             test.startTest();
             list<ESC_WLBandingController.DataTableWrapper1> ds = ESC_WLBandingController.viewrefAttorney(ssd.id);
             test.stopTest();
            }
     }
     testmethod static void Method2(){
        String json = '{'
        + '\"onlineContact\" : ['
        + ' {'
        + ' \"contactNumber\" : \"0006274152\",'
        + ' \"address\" : '
        + ' {'
        + ' \"firstName\" : \"edqw\",\"lastName\" : \"sdasdqw\",'
        + ' \"emailAddress\" : \"sweta.beura@thomsonreuters.com\" '
        + ' }'
        + ' ,\"account\" : '
        + ' {'
        + ' \"accountNumber\" : \"1004628718\",\"companyId\" : \"WEST\" '
        + ' }'
        + ' ,\"sourceId\" : \"SAP\",'
        + ' \"endDate\" : \"9999-12-31T00:00:00.000-06:00\",'
        + ' \"entitlements\" : ['
        + ' {'
        + ' \"status\" : \"ACTIVE\",\"applicationId\" : \"COBALT\",'
        + ' \"appUserGuid\" : \"i0ace196600000162ba10a59fb9203503\",\"accessStartDate\" : \"2018-04-12\",'
        + ' \"accessEndDate\" : \"9999-12-31\",\"statusReason\" : \"SAP\",'
        + ' \"subscriptions\" : ['
        + ' {'
        + ' \"material\" : ['
        + ' {'
        + ' \"materialNumber\" : \"000000000040028757\",\"extensibleAttributes\" : ['
        + ' {'
        + ' \"key\" : \"mediaLowerLevel\",\"value\" : \"49\"'
        + ' }'
        + ' ,' 
        + ' {'
        + ' \"key\" : \"mediaHigherLevel\" '
        + ' }'
        + ' ]'
        + ' }'
        + ' ]'
        + ' }'
        + ' ]'
        + ' }'
        + ' ],\"onlineContactType\" : \"0230\",\"allowContactEmails\" : false'
        + ' }'
        + ' ]}';
        ESC_JSON2ApexWLBandingService obj = ESC_JSON2ApexWLBandingService.parse(json);
        System.assert(obj != null);

    }
}