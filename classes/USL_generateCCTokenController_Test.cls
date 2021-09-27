@isTest
private class USL_generateCCTokenController_Test {
    static testmethod void method_test1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testcasemanager@bcinsourcing.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testcasemanager@bcinsourcing.com');
        
        System.debug('UserName: ' + u.Name);
        system.RunAs(u){     
        //insert accounts data 
       Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
       insert testAccount;
       
       //insert contact data
       Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','john','test@tr.com');
       insert testContact;
       
       Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
       testcase.ESC_Impact__c = '1-Whole Site';
       testcase.subject='tst';
       testcase.ESC_Customer_Symptom__c='Content Addition';
       testcase.ESC_Diagnosis_Summary__c='Content Explanation';
       testcase.ESC_Severity__c='1 - High';
      
       testcase.description = 'test';
       testcase.ESC_Apply_Milestone_Closure_Flag__c = true;
       
       testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
       insert testcase;
          testcase.USL_Payment_Details__c='testing';
        update  testcase;
        
        GenerateForm__c CSSform =new GenerateForm__c();
            CSSForm.Name='Prepayment Form';
         insert CSSForm;
       ESC_Case_Form_Extension__c  formext = new ESC_Case_Form_Extension__c();
        formext.ESC_Case__c=testcase.id;
        formext.Credit_Card_Token__c='2345';
       formext.ESC_Form__c=CSSForm.id;        
        insert formext;
        
         USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        int1.ESC_SecureSite_JSON__C = '{"HMACKey" : "ESCHTR","APIKey" : "TRPMNTTOKEN_API","ProductID" : "ESCH","OriginURL" : "","CustomerRefnumber" : "","DynamicContent1" : "color:blue","DynamicContent2" : "Enter Credit Card Number"}';
        int1.ESC_Securesite_HAMCKey__c ='ABWJSUTYDN';
        insert int1;
        
        case case1=[Select USL_Payment_Details__c,accountid,contactid,USL_SAP_Account_Number__c from case where id=:testcase.id];
        if(case1.USL_Payment_Details__c!=null){
         ESC_Case_Form_Extension__c  formext1=[Select USL_Card_Holder_Name__c,ESC_Amount_of_Prepayment__c,ESC_Credit_Card_Type__c,
                   USL_Credit_Card_Expiration_Date__c,Credit_Card_Token__c,ESC_Instructions__c,
                   ESC_Product_Description__c from ESC_Case_Form_Extension__c 
                   where ESC_Case__c =:case1.id and Credit_Card_Token__c!=null ];
        }
       
        
    group g=[Select Id,Name,DeveloperName  from Group where DeveloperName =:'EBO_USL_Credit_Card'];                        
            List<ESC_Case_Collaborator__c> newRef1 = new List<ESC_Case_Collaborator__c>();
           
            ESC_Case_Collaborator__c newRef = new ESC_Case_Collaborator__c();
            newRef.ESC_Role__c='Accountable Resolver';
            newRef.ESC_Referral_Status__c='New';
            newRef.OwnerId=g.Id;
            newRef.ESC_Case__c= case1.id;
            newRef.RecordTypeId = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Service Cloud Referral').getRecordTypeId();
            
            insert newRef;  
        
            WebServiceSettings__c ccrec = new WebServiceSettings__c();            
            ccrec.Name = 'USL CC Tokeniser';
            ccrec.Endpoint__c = 'https://securepayment.thomsonreuters.com/TRPaymentGateway/API/Session/GetSession/';
            ccrec.Service_Unavailable_Message__c='Service Unavailable';
            ccrec.Timeout__c=120;
            insert ccrec;
      Test.startTest();    
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorcc()); 
       //String response = Apexpages.currentpage().getparameters().get('postresponse');
       //string cacheOpn = apexpages.CurrentPage().getParameters().get('scontrolCaching');
       PageReference pageRef = Page.USL_Prepayment;       
        test.setCurrentPageReference(pageRef);
        //pageRef.getParameters().put('caseid', testcase.id);
        //pageRef.getParameters().put('formid', gf.id);
        ApexPages.currentPage().getParameters().put('caseid',testcase.id);
        ApexPages.currentPage().getParameters().put('formid',CSSForm.id);
       USL_generateCCTokenController cctok = new USL_generateCCTokenController();
       cctok.isfeedview=true;
       cctok.getCaseNumber();
       cctok.getmyPage();
       cctok.getendpointURL();
       string response='{"Hash":"v+jvCpn00iKLHogfetbtvRU8i/CdUaJvB+2w7kYJzrg=","Payload":{"Brand":"visa","ClientIP":"10.25.16.148","Success":true,"Error":"","Token":"-E803-4448-8N01000000000Q","SesssionID":"RLQUKZEH21D2NUJLZH6EAWSA1ITPB4QB","CustomerRefNumber":null}}';
        string response1 =response.replace('&quot;','"');
        Apexpages.currentpage().getparameters().put('postresponse',response1);
       cctok.processResponse();
      cctok.saveOnCase('test','case');
       cctok.expdate = '';      
       //cctok.expdate = '04/2019';
       cctok.name = 'test';       
       cctok.dynamicmonthlist();
       cctok.getdynamicyearlist();
       cctok.selectedyear = String.valueof(System.Today().year());
       cctok.dynamicmonthlist();
        cctok.selectedMonth = 'MM';
        cctok.validateData();
       
       

       Test.stopTest();
    }
    }
    

    public static testMethod void testController(){
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
       insert testAccount;
       
       //insert contact data
       Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','john','test@tr.com');
       insert testContact;
       
       Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
       testcase.ESC_Impact__c = '1-Whole Site';
       testcase.subject='tst';
       testcase.ESC_Customer_Symptom__c='Content Addition';
       testcase.ESC_Diagnosis_Summary__c='Content Explanation';
       testcase.ESC_Severity__c='1 - High';
      
       testcase.description = 'test';
       testcase.ESC_Apply_Milestone_Closure_Flag__c = true;
       
       testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
       insert testcase;
          testcase.USL_Payment_Details__c='testing';
        update  testcase;
        
       GenerateForm__c CSSform =new GenerateForm__c();
            CSSForm.Name='Prepayment Form';
         insert CSSForm;
       ESC_Case_Form_Extension__c  formext = new ESC_Case_Form_Extension__c();
        formext.ESC_Case__c=testcase.id;
        formext.Credit_Card_Token__c='2345';
       formext.ESC_Form__c=CSSForm.id;        
        insert formext;
        
        
        case case1=[Select USL_Payment_Details__c,accountid,contactid,USL_SAP_Account_Number__c from case where id=:testcase.id];
        if(case1.USL_Payment_Details__c!=null){
         ESC_Case_Form_Extension__c  formext1=[Select USL_Card_Holder_Name__c,ESC_Amount_of_Prepayment__c,ESC_Credit_Card_Type__c,
                   USL_Credit_Card_Expiration_Date__c,Credit_Card_Token__c,ESC_Instructions__c,
                   ESC_Product_Description__c from ESC_Case_Form_Extension__c 
                   where ESC_Case__c =:case1.id and Credit_Card_Token__c!=null ];
        }
        
   Group g=[Select Id,Name,DeveloperName  from Group where DeveloperName =:'EBO_USL_Credit_Card'];                        
          
        List<ESC_Case_Collaborator__c> newRef1 = new List<ESC_Case_Collaborator__c>();
            ESC_Case_Collaborator__c newRef = new ESC_Case_Collaborator__c();
            newRef.ESC_Role__c='Accountable Resolver';
            newRef.ESC_Referral_Status__c='New';           
            newRef.ESC_Case__c= case1.id;
            newRef.RecordTypeId = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Service Cloud Referral').getRecordTypeId();
            insert newRef;  
         newRef.OwnerId=g.Id;
        update newRef;
        
            WebServiceSettings__c ccrec = new WebServiceSettings__c();            
            ccrec.Name = 'USL CC Tokeniser';
            ccrec.Endpoint__c = 'https://securepayment.thomsonreuters.com/TRPaymentGateway/API/Session/GetSession/';
            ccrec.Service_Unavailable_Message__c='Service Unavailable';
            ccrec.Timeout__c=120;
            insert ccrec;
            
             String formId = CSSform.id;
             string formName = 'CreditDebitPayment';
                
            Test.startTest();
         
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorcc());
         PageReference pageRef = Page.USL_Prepayment;       
        test.setCurrentPageReference(pageRef);
        //pageRef.getParameters().put('caseid', testcase.id);
        //pageRef.getParameters().put('formid', gf.id);
        ApexPages.currentPage().getParameters().put('caseid',testcase.id);
        ApexPages.currentPage().getParameters().put('formid',CSSForm.id);
       USL_generateCCTokenController cctok = new USL_generateCCTokenController();
        boolean x = cctok.isFeedView;
        cctok.getendpointURL();
         //cctok.processResponse();
         
         Test.stopTest();
        
   }
}