@isTest
public class ESC_EmailPB_Test{
    private static testmethod void  highqTest(){
        Test.startTest();
        
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Case cs = new Case();        
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='1-High';
        cs.Origin='Email';
        cs.ESC_Origin_Name__c ='';
        cs.SuppliedEmail = 'dummytest@thomsonreuters.com';
        cs.USL_Queue_Name__c = '';
        cs.bu_segment__c = 'Professional Legal';
        insert cs;
        
        EmailMessage newEmail1 = new EmailMessage(ParentId = cs.Id, ToAddress='bookstore@thomsonreuters.com', FromAddress = 'dummytest@thomsonreuters.com',Incoming=true,TextBody='test', Subject='Address Change0');
        insert newEmail1;
        system.assertequals(cs.bu_segment__c,'Professional Legal','Professional Legal');
        Test.stopTest();
    }
     private static testmethod void  corpRiskPBTest(){
        Test.startTest();
        
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Case cs = new Case();        
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='1-High';
        cs.Origin='Email';
       // cs.status='New';
        cs.ESC_Unique_Identifier__c ='CORP - GTM';
        cs.ESC_Severity__c='1 - High';
        cs.ESC_Origin_Name__c ='';
        cs.SuppliedEmail = 'dummytest@thomsonreuters.com';
        cs.USL_Queue_Name__c = '';
        cs.bu_segment__c = 'Corporate';
        insert cs;
       
         cs.id= cs.id;
        cs.ESC_Severity__c='3 - Low';
        update  cs;
        system.assertequals(cs.bu_segment__c,'Corporate','Corporate');
     Case cs1 = new Case();        
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs1.Priority='1-High';
        cs1.Origin='Email';
        cs1.status='New';
        cs1.ESC_Product_Segment_Brand__c='Elite';
        cs1.ESC_Unique_Identifier__c ='Elite';
        cs1.ESC_Severity__c='1 - High';
        cs1.ESC_Origin_Name__c ='';
        cs1.SuppliedEmail = 'dummytest@thomsonreuters.com';
        cs1.USL_Queue_Name__c = '';
        cs1.bu_segment__c = 'Corporate';
        insert cs1;
        
        cs1.id= cs1.id;
        cs1.ESC_Severity__c='3 - Low';
        update  cs1;
        
        Case csa = new Case();        
        csa.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
        csa.Priority='1-High';
        csa.Origin='Email';
       // cs.status='New';
        csa.ESC_Unique_Identifier__c ='CORP - GTM';
        csa.ESC_Severity__c='1 - High';
        csa.ESC_Origin_Name__c ='';
        csa.SuppliedEmail = 'dummytest@thomsonreuters.com';
        csa.USL_Queue_Name__c = '';
        csa.bu_segment__c = 'Corporate';
        insert csa;
        
         csa.id= csa.id;
        csa.ESC_Product_Segment_Brand__c='Risk';
        update  csa;
        
        Test.stopTest();
    }
    
    
}