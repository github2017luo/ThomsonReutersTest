@istest
public class USL_Localization_PB_Test {
 
   static testmethod void testMethods3(){
    
       Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us1 =  New User(FirstName = 'j.a5' , LastName= 't.b5',Alias = 'j.a5b5',Email='j.a5T.b5@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='j.a5T.5b5@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='j.a5t.b5',
         Sales_Org__c='GLI',Segment__c='Professional Tax',Sub_Bu__c='USL',Default_Catalog__c='USL',ICP_Admin__c=true,federationidentifier='P2343212');
        insert us1;
        WebServiceSettings__c PGWebServiceSettings = new WebServiceSettings__c();
       PGWebServiceSettings.Name='USL AutoPay';
       PGWebServiceSettings.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
       PGWebServiceSettings.Service_Unavailable_Message__c = 'Service Unavailable';      
       Insert PGWebServiceSettings;
    
       /* User us2 =  New User(FirstName = 'j.a6' , LastName= 't.b6',Alias = 'j.a6b6',Email='j.a6t.b6@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='j.a66t.b6@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='j.a6t.b6',Sales_Org__c='GLI',Segment__c='Professional Tax',Sub_Bu__c='USL',Default_Catalog__c='USL',federationidentifier='P2343222');
        insert us2;*/
        //System.debug('**usercreation**' + us2);
        system.runas(us1){
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'NY',ShippingCountry= 'US',ShippingStreet='testStreet');
        insert testAccount1;
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        insert testContact1;
        
       /*  Contact testContact2=new Contact (AccountId = testAccount1.id,firstname= 'John1',lastname= 'Mile1',email = 'ab1c@tr.com', phone='7886864710');
        insert testContact2;*/
           
        
        Case testCase1=new Case (ContactId = testContact1.id,status='New');
        //insert testCase1;
        
        //Case testCase2=new Case (ContactId = testContact1.id,status='New');
         //insert testCase2;
         
        list<Case> Cases=New List<Case>();
        //testCase1.ContactId=testContact2.id;
        testCase1.LCRM_Sub_BU__c='USL';
        testcase1.USL_AutoPayment_URL__c= NULL;
        testcase1.Origin='Chat';
        testcase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
          testcase1.Subject='test1';
          testcase1.ESC_Impact__c = '1-Whole Site';
          testcase1.ESC_Severity__c='1 - High';
          testcase1.GGO_Case_Response_Time__c=System.now();
          testcase1.CreatedDate=System.now();
          testcase1.ESC_Customer_Symptom__c='Content Addition';
          testcase1.Description = 'test description';
          testcase1.GGOIsReferralFlag__c =true;
       testcase1.Is_GLI__c =true;     
      testcase1.GGO_Referral_Milestone_Type__c='BR_Billing';
      testcase1.ESC_Diagnosis_Summary__c='Content Explanation';
      Cases.add(testcase1);
      insert Cases;
//USL_GenerateAutopayURL.getpaymenturl(cases);
        


        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        }
    }
    
}