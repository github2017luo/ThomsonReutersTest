@isTest
public class ODTWestLawAccTrialDetailsTest {
    
    @testsetup
    static void testdata(){
        
        // create Account
		List<Account> AccountList = new List<Account>();
        Account acct = new Account();
        acct.Name='test';
        acct.Phone = '123456';
        acct.Website = 'test.website@email.xxx';
		AccountList.add(acct);
        
        
        Account acct2 = new Account();
        acct2.Name='test';
        acct2.Phone = '123456';
        acct2.Website = 'test.website@email.xxx';
        AccountList.add(acct2);
		
		insert AccountList;
        
         List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
           new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
        insert WebserviceList;  
        
		 Lead l = new Lead();
        l.FirstName='test';
        l.LastName='testtt';
        l.Company='TCS';
        l.External_Trial_Account_ID__c='123123123';
        l.Operating_Unit__c='SLF';    
        insert l;
        
        
        List<Source_System_Detail__c> ssdtList = new List<Source_System_Detail__c>();
        Source_System_Detail__c ssdacc =new Source_System_Detail__c();
        ssdacc.Account_Name__c=acct.id;
        ssdacc.Source_System_Account_Number__c='1004284494';
        ssdacc.name='test';
        ssdacc.Source_System_Name__c='test';
        ssdacc.BU_Segment_Level_2__c='SLF 11-20';
		ssdtList.add(ssdacc);
      //  insert ssdacc;
        
        Source_System_Detail__c ssdacc2 =new Source_System_Detail__c();
        ssdacc2.Account_Name__c=acct2.id;
        ssdacc2.Source_System_Account_Number__c='1004284493';
        ssdacc2.name='test';
        ssdacc2.Source_System_Name__c='test';
        ssdacc2.BU_Segment_Level_2__c='Corp Investigative';
        ssdtList.add(ssdacc2);
        
        Source_System_Detail__c ssdacc3 =new Source_System_Detail__c();
        ssdacc3.Account_Name__c=acct2.id;
        ssdacc3.Source_System_Account_Number__c='1004284499';
        ssdacc3.name='test';
        ssdacc3.Source_System_Name__c='test';
        //ssdacc3.BU_Segment_Level_2__c='Corp Investigative';
        ssdtList.add(ssdacc3);
        
        Source_System_Detail__c ssdacc4 =new Source_System_Detail__c();
        ssdacc4.Account_Name__c=acct2.id;
        ssdacc4.Source_System_Account_Number__c='1004284469';
        ssdacc4.name='test';
        ssdacc4.Source_System_Name__c='test';
        ssdacc4.BU_Segment_Level_2__c=null;
        ssdtList.add(ssdacc4);
		insert ssdtList;
        
		List<Trial__c> trailList = new List<Trial__c>();
        //create Trial Record
        Trial__c t=new Trial__c();
        t.Trial_Status__c='Timed-out';        
        t.Trial_Id__c='76656';
        t.Trial_End_Date__c=System.today();
        t.Source_System_Detail__c=ssdacc.id;    
        trailList.add(t);  
             
           //create Trial Record
        Trial__c t4=new Trial__c();
        t4.Trial_Status__c='Expired';
        t4.Trial_Id__c='76656';
        t4.Source_System_Detail__c=ssdacc2.id; 
        t4.Trial_start_Date__c=System.today();
        t4.Trial_End_Date__c=System.today()-180;
        trailList.add(t4);
        
        Trial__c t2=new Trial__c();
        t2.Trial_Status__c='Expired';
        t2.Trial_Id__c='76656';
        t2.Contact_LeadId__c=l.Id;
        t2.Trial_start_Date__c=System.today();
        t2.Trial_End_Date__c=System.today()-380;
        trailList.add(t2);
        
        Trial__c t3=new Trial__c();
        t3.Trial_Status__c='Invited';
        t3.Trial_Id__c='76656';
        t3.Contact_LeadId__c=l.Id;
        t3.Trial_start_Date__c=System.today()-200;
        t3.Trial_End_Date__c=System.today()-190;
        
        trailList.add(t3);
        
         Trial__c t5=new Trial__c();
        t5.Trial_Status__c='Accepted';
        t5.Trial_Id__c='76656';
        t5.Contact_LeadId__c=l.Id;        
        t5.Trial_start_Date__c=System.today();
        t5.Trial_End_Date__c=System.today()-180;
        trailList.add(t5);
        
        Trial__c t6=new Trial__c();
        t6.Trial_Status__c='Bounceback';
        t6.Trial_Id__c='76656';
        //t6.Contact_LeadId__c=l.Id;
        t6.Trial_start_Date__c=System.today();
        t6.Trial_End_Date__c=System.today()-180;
        t6.Source_System_Detail__c=ssdacc3.id;
        trailList.add(t6);
        
         Trial__c t7=new Trial__c();
        t7.Trial_Status__c='Ended';
        t7.Trial_Id__c='76656';
        //t6.Contact_LeadId__c=l.Id;
        t7.Trial_start_Date__c=System.today();
        t7.Trial_End_Date__c=System.today()-220;
        t7.Source_System_Detail__c=ssdacc4.id;
        trailList.add(t7);
        
         Trial__c t8=new Trial__c();
        t8.Trial_Status__c='Accepted';
        t8.Trial_Id__c='76656';
        t8.Source_System_Detail__c=ssdacc3.id;       
        t8.Trial_start_Date__c=System.today();
        t8.Trial_End_Date__c=System.today()-180;
        trailList.add(t8);
        
        Trial__c t9=new Trial__c();
        t9.Trial_Status__c='Ended';
        t9.Trial_Id__c='76656';
        t9.Contact_LeadId__c=l.Id;
        t9.Trial_start_Date__c=System.today();
        t9.Trial_End_Date__c=System.today()-380;
        //t9.Source_System_Detail__c=ssdacc4.id;
        trailList.add(t9);
		
		insert trailList;
        
    }
    
    static testMethod void marketSegmentfromSSD()
    {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '1004284493');
        RestContext.request = request;
        ODTWestLawAccTrialDetails.doGet(); 
        Test.stopTest();
    }
    
     static testMethod void marketSegmentfromSSDExpired()
    {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '1004284494');
        RestContext.request = request;
        ODTWestLawAccTrialDetails.doGet(); 
        Test.stopTest();
    }
    static testMethod void marketSegmentfromLead()
    {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '123123123');
        RestContext.request = request;
        ODTWestLawAccTrialDetails.doGet(); 
        Test.stopTest();
    }
    
     static testMethod void marketSegmentfornull()
    {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '');
        RestContext.request = request;
        ODTWestLawAccTrialDetails.doGet();        
        Test.stopTest();
    }
    
	static testMethod void marketSegmentfornullBusinessType()
    {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '1004284499');
        RestContext.request = request;
        ODTWestLawAccTrialDetails.doGet();        
        Test.stopTest();
    }    
    
    static testMethod void marketSegmentforSSDEnded()
    {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '1004284469');
        RestContext.request = request;
        ODTWestLawAccTrialDetails.doGet();        
        Test.stopTest();
    }
    
    static testMethod void marketSegmentforSSDEndedForLead()
    {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.params.put('sapAccountNum', '123123124');
        RestContext.request = request;
        ODTWestLawAccTrialDetails.doGet();        
        Test.stopTest();
    }
    
    static testMethod void testMarketSegment()
    {
        Test.startTest();
    	ODTWestLawAccTrialDetails west = new ODTWestLawAccTrialDetails();
        west.test1();
		west.test2();
        west.test3();
        west.test4();
        west.test5();
		Test.stopTest();
    }
}