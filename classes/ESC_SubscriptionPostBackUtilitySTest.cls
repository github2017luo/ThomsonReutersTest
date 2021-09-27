@isTest
public class ESC_SubscriptionPostBackUtilitySTest{

  @isTest
    public static  void testUpdateAssestLineItem(){
        String assestStatus = 'Pending Suspension';
        String TFMS_Status = 'SUCCESS';
        String SAP_Status = 'Cancelled';
        //String caseSub_Type = 'Suspend Subscription';
        String caseSub_Type = 'Suspend';
        //Create a Account and Insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         //Create a Contact and Insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         //Create a Case and Insert as a dummy data
         case ca = createCase(testAccount,testContact,caseSub_Type);

        //Create a Asset Line Item and Insert as a dummy data
         Apttus_Config2__AssetLineItem__c testAppasset = createAssestLineItem(testAccount,assestStatus);
         //Create a Case Asset Line Items and Insert as a dummy data
         ESC_Case_Asset_Line_Item__c testCAsset= createCaseAssestLineItem(ca,testAppasset,TFMS_Status,SAP_Status);
      
                   //update testCAsset;
         case caseRecord = [Select id,CaseNumber,ESC_Sub_Type__c from case where case.id =:ca.Id ];
         system.debug('CASE----->'+caseRecord);
         ESC_Case_Asset_Line_Item__c csAstLineItmRec = [Select id,name,
                          ESC_Asset_Number__c,
                          ESC_TFMS_Status__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c,ESC_TFMS_Status_Message__c,
                          ESC_Asset_Line_Item__c  from ESC_Case_Asset_Line_Item__c where ESC_Case_Asset_Line_Item__c.id =:testCAsset.Id ];
        system.debug('CsAstLineItmRec----->'+csAstLineItmRec);
        String json = getRequest(caseRecord.CaseNumber,caseRecord.ESC_Sub_Type__c,csAstLineItmRec.ESC_Asset_Number__c,TFMS_Status,SAP_Status);
        RestRequest request = new RestRequest();
        //request.requestUri ='https://cs13.salesforce.com/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(json);
        RestContext.request = request;
         Test.startTest();
        
         ESC_SubscriptionPostBackUtilityService.updateAssetLineItems();

         Test.stopTest();
        
    }
    
   
    
    @isTest
    public static  void testUpdateAssestLineItem2(){
        String assestStatus = 'Pending Cancellation';
        String TFMS_Status = 'SUCCESS';
        String SAP_Status = 'Sent For Cancellation';
        String CaseSub_Type = 'Cancellation';
        //Create a Account and Insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         //Create a Contact and Insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         //Create a Case and Insert as a dummy data
         case ca = createCase(testAccount,testContact,CaseSub_Type);
        
        //Create a Asset Line Item and Insert as a dummy data
         Apttus_Config2__AssetLineItem__c testAppasset = createAssestLineItem(testAccount,assestStatus);
         //Create a Case Asset Line Items and Insert as a dummy data
         ESC_Case_Asset_Line_Item__c testCAsset= createCaseAssestLineItem(ca,testAppasset,TFMS_Status,SAP_Status);
      
                   //update testCAsset;
         case caseRecord = [Select id,CaseNumber,ESC_Sub_Type__c from case where case.id =:ca.Id ];
         system.debug('CASE----->'+caseRecord);
         ESC_Case_Asset_Line_Item__c csAstLineItmRec = [Select id,name,
                          ESC_Asset_Number__c,
                          ESC_TFMS_Status__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c,ESC_TFMS_Status_Message__c,
                          ESC_Asset_Line_Item__c  from ESC_Case_Asset_Line_Item__c where ESC_Case_Asset_Line_Item__c.id =:testCAsset.Id ];
        system.debug('CsAstLineItmRec----->'+csAstLineItmRec);
        String json = getRequest(caseRecord.CaseNumber,caseRecord.ESC_Sub_Type__c,csAstLineItmRec.ESC_Asset_Number__c,TFMS_Status,SAP_Status);
        RestRequest request = new RestRequest();
        //request.requestUri ='https://cs13.salesforce.com/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(json);
        RestContext.request = request;
         Test.startTest();
        
         ESC_SubscriptionPostBackUtilityService.updateAssetLineItems();
         Test.stopTest();
        
    }
    
   
    @isTest
    public static  void testUpdateAssestLineItem3(){
        String assestStatus = 'Pending Activation';
        String TFMS_Status = 'Sent to SAP';
        String SAP_Status = 'Sent to SAP';
        String CaseSub_Type = 'Unsuspend';
        //Create a Account and Insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         //Create a Contact and Insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         //Create a Case and Insert as a dummy data
         case ca = createCase(testAccount,testContact,CaseSub_Type);

        //Create a Asset Line Item and Insert as a dummy data
         Apttus_Config2__AssetLineItem__c testAppasset = createAssestLineItem(testAccount,assestStatus);
         //Create a Case Asset Line Items and Insert as a dummy data
         ESC_Case_Asset_Line_Item__c testCAsset= createCaseAssestLineItem(ca,testAppasset,TFMS_Status,SAP_Status);
      
                   //update testCAsset;
         case caseRecord = [Select id,CaseNumber,ESC_Sub_Type__c from case where case.id =:ca.Id ];
         system.debug('CASE----->'+caseRecord);
         ESC_Case_Asset_Line_Item__c csAstLineItmRec = [Select id,name,
                          ESC_Asset_Number__c,
                          ESC_TFMS_Status__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c,ESC_TFMS_Status_Message__c,
                          ESC_Asset_Line_Item__c  from ESC_Case_Asset_Line_Item__c where ESC_Case_Asset_Line_Item__c.id =:testCAsset.Id ];
        system.debug('CsAstLineItmRec----->'+csAstLineItmRec);
        String json = getRequest(caseRecord.CaseNumber,caseRecord.ESC_Sub_Type__c,csAstLineItmRec.ESC_Asset_Number__c,TFMS_Status,SAP_Status);
        RestRequest request = new RestRequest();
        //request.requestUri ='https://cs13.salesforce.com/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(json);
        RestContext.request = request;
         Test.startTest();
        
         ESC_SubscriptionPostBackUtilityService.updateAssetLineItems();

         Test.stopTest();
        
    }
      
     @isTest
    public static  void testUpdateAssestLineItem4(){
        String assestStatus = 'Pending Suspension';
        String TFMS_Status = 'Sent to TFMS';
        String SAP_Status = 'Sent to SAP';
        String CaseSub_Type = 'Suspend';
        //Create a Account and Insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         //Create a Contact and Insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         //Create a Case and Insert as a dummy data
         case ca = createCase(testAccount,testContact,CaseSub_Type);

        //Create a Asset Line Item and Insert as a dummy data
         Apttus_Config2__AssetLineItem__c testAppasset = createAssestLineItem(testAccount,assestStatus);
         //Create a Case Asset Line Items and Insert as a dummy data
         ESC_Case_Asset_Line_Item__c testCAsset= createCaseAssestLineItem(ca,testAppasset,TFMS_Status,SAP_Status);
      
                   //update testCAsset;
         case caseRecord = [Select id,CaseNumber,ESC_Sub_Type__c from case where case.id =:ca.Id ];
         system.debug('CASE----->'+caseRecord);
         ESC_Case_Asset_Line_Item__c csAstLineItmRec = [Select id,name,
                          ESC_Asset_Number__c,
                          ESC_TFMS_Status__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c,ESC_TFMS_Status_Message__c,
                          ESC_Asset_Line_Item__c  from ESC_Case_Asset_Line_Item__c where ESC_Case_Asset_Line_Item__c.id =:testCAsset.Id ];
        system.debug('CsAstLineItmRec----->'+csAstLineItmRec);
        String json = getRequest(caseRecord.CaseNumber,caseRecord.ESC_Sub_Type__c,csAstLineItmRec.ESC_Asset_Number__c,TFMS_Status,SAP_Status);
        RestRequest request = new RestRequest();
        //request.requestUri ='https://cs13.salesforce.com/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(json);
        RestContext.request = request;
         Test.startTest();
        
         ESC_SubscriptionPostBackUtilityService.updateAssetLineItems();

         Test.stopTest();
        
    }
   
     @isTest
    public static  void testUpdateAssestLineItem5(){
        String assestStatus = 'Pending Cancellation';
        String TFMS_Status = 'SUCCESS';
        String SAP_Status = 'Suspended';
        String CaseSub_Type = 'Cancellation';
        //Create a Account and Insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         //Create a Contact and Insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         //Create a Case and Insert as a dummy data
         case ca = createCase(testAccount,testContact,CaseSub_Type);

        //Create a Asset Line Item and Insert as a dummy data
         Apttus_Config2__AssetLineItem__c testAppasset = createAssestLineItem(testAccount,assestStatus);
         //Create a Case Asset Line Items and Insert as a dummy data
         ESC_Case_Asset_Line_Item__c testCAsset= createCaseAssestLineItem(ca,testAppasset,TFMS_Status,SAP_Status);
      
                   //update testCAsset;
         case caseRecord = [Select id,CaseNumber,ESC_Sub_Type__c from case where case.id =:ca.Id ];
         system.debug('CASE----->'+caseRecord);
         ESC_Case_Asset_Line_Item__c csAstLineItmRec = [Select id,name,
                          ESC_Asset_Number__c,
                          ESC_TFMS_Status__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c,ESC_TFMS_Status_Message__c,
                          ESC_Asset_Line_Item__c  from ESC_Case_Asset_Line_Item__c where ESC_Case_Asset_Line_Item__c.id =:testCAsset.Id ];
        system.debug('CsAstLineItmRec----->'+csAstLineItmRec);
        String json = getRequest(caseRecord.CaseNumber,caseRecord.ESC_Sub_Type__c,csAstLineItmRec.ESC_Asset_Number__c,TFMS_Status,SAP_Status);
        RestRequest request = new RestRequest();
        //request.requestUri ='https://cs13.salesforce.com/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(json);
        RestContext.request = request;
         Test.startTest();
        
         ESC_SubscriptionPostBackUtilityService.updateAssetLineItems();

         Test.stopTest();
        
    }
    
     @isTest
    public static  void testUpdateAssestLineItem6(){
        String assestStatus = 'Pending Activation';
        String TFMS_Status = 'SUCCESS';
        String SAP_Status = 'Unsuspended';
        String CaseSub_Type = 'Unsuspend';
        //Create a Account and Insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         //Create a Contact and Insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         //Create a Case and Insert as a dummy data
         case ca = createCase(testAccount,testContact,CaseSub_Type);

        //Create a Asset Line Item and Insert as a dummy data
         Apttus_Config2__AssetLineItem__c testAppasset = createAssestLineItem(testAccount,assestStatus);
         ESC_Case_Asset_Line_Item__c testCAsset= createCaseAssestLineItem(ca,testAppasset,TFMS_Status,SAP_Status);
        
      
         //update testCAsset;
         case caseRecord = [Select id,CaseNumber,ESC_Sub_Type__c from case where case.id =:ca.Id ];
         system.debug('CASE----->'+caseRecord);
         ESC_Case_Asset_Line_Item__c csAstLineItmRec = [Select id,name,
                          ESC_Asset_Number__c,
                          ESC_TFMS_Status__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c,ESC_TFMS_Status_Message__c,
                          ESC_Asset_Line_Item__c  from ESC_Case_Asset_Line_Item__c where ESC_Case_Asset_Line_Item__c.id =:testCAsset.Id ];
        system.debug('CsAstLineItmRec----->'+csAstLineItmRec);
        
        String json = getRequest(caseRecord.CaseNumber,caseRecord.ESC_Sub_Type__c,csAstLineItmRec.ESC_Asset_Number__c,TFMS_Status,SAP_Status);
        RestRequest request = new RestRequest();
        //request.requestUri ='https://cs13.salesforce.com/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(json);
        RestContext.request = request;
        
        
        list<id> Ali=New list<id>();
        Ali.add(csAstLineItmRec.id);
        //insert Ali;
         Test.startTest();
        
         ESC_SubscriptionPostBackUtilityService.updateAssetLineItems();
        
         ESC_SubscriptionPostBackUtilityService.cloneRecord(caseRecord.id,Ali);
         Test.stopTest();
        
    }
   
    /* ------------------Test Data for creating test methods --------------------  */
    
    public static case createCase(Account acc,Contact con,String caseSub_Type){
        
        Case ca= new Case();
         ca = ESC_GenericTestutility.TestCaseUtil(con.id,acc.id,'New');
         Insert ca;  //Insert Case 1
         
         ca.BU_Segment__c='Professional Legal';
         ca.LCRM_Sub_BU__c='Canada';
         ca.ESC_Sub_Type__c= caseSub_Type;
         //ca.TXP_Sub_Type_Reason_Code__c='Credit';
         ca.TFMS_Reference_Number__c='7634374637';
         ca.ESC_Subscription_Start_Date__c=System.today().adddays(10);
         
         update ca;
         return ca;
        
    }
    public static ESC_Case_Asset_Line_Item__c createCaseAssestLineItem(Case cas,Apttus_Config2__AssetLineItem__c testAppasset,String TFMS_Status,String SAP_Status) {
        
         ESC_Case_Asset_Line_Item__c testCAsset= new ESC_Case_Asset_Line_Item__c();
          testCAsset.ESC_Case__c=cas.id;
          testCAsset.ESC_Asset_Line_Item__c=testAppasset.id;
          testCAsset.ESC_TFMS_Status__c =TFMS_Status;
          testCAsset.ESC_SAP_Status__c=SAP_Status;
          Insert testCAsset;

        return testCAsset;
        
    }
        
        
    public static Apttus_Config2__AssetLineItem__c createAssestLineItem(Account acc,String assestStatus) {
        
        Apttus_Config2__AssetLineItem__c testAppasset=new Apttus_Config2__AssetLineItem__c();
          testAppasset.Name='TestApptusasset';
          testAppasset.Apttus_Config2__AssetStatus__c=assestStatus;
          testAppasset.Apttus_Config2__AccountId__c=acc.id;
          testAppasset.Apttus_Config2__LineType__c='Product/Service';
          testAppasset.Apttus_Config2__NetPrice__c=700.00000;
          testAppasset.Asset_Auto_Number__c='ALI-009000';
         //testAppasset.Apttus_Config2__BundleAssetId__c=
          Insert testAppasset;
          
          Apttus_Config2__AssetLineItem__c BundleAsset =new Apttus_Config2__AssetLineItem__c();
          BundleAsset.Apttus_Config2__BundleAssetId__c = testAppasset.id;
          BundleAsset.Name='TestApptusasset';
          BundleAsset.Apttus_Config2__AssetStatus__c=assestStatus;
          BundleAsset.Apttus_Config2__AccountId__c=acc.id;
          BundleAsset.Apttus_Config2__LineType__c='Product/Service';
          BundleAsset.Apttus_Config2__NetPrice__c=700.00000;
          BundleAsset.Asset_Auto_Number__c='ALI-009000';
          Insert BundleAsset;
        
        return testAppasset;
        
    }
    
    public static String  getRequest(String casenumber,String caseSubType,String assestNumber,String TFMS_Status,String SAP_Status){
        
        String json=        '  {'+
        '                "BOOMIHeader": {'+
        '                                "applicationId": "ESCH",'+
        '                                "companyId": "S100"'+
        '                },'+
        '                "caseResponse": ['+
        '                                {'+
        '                                                "referenceNumber": "'+casenumber+'",'+
        '                                                "accountNumber": "20000167812",'+
        '                                                '+
        '                                                '+
        '                                                "item": ['+
        '                                                                {'+
        '                                                                                "actionCode":"'+caseSubType+'",'+
        '                                                                                "assetId": "'+assestNumber+'",'+
        '                                                                                "effectiveDate":"2022-11-30",'+
        '                                                                                "contractNumber": "",'+
        '                                                                                "entitlementStatus": "'+TFMS_Status+'",'+
        '                                                                                "entitlementStatusMessage": "",'+
        '                                                                                "billingStatus": "'+SAP_Status+'",'+
        '                                                                                "billingStatusMessage": "",'+
        '                                                                                "entitlementCompletionDate":""'+
        '                                                                                '+
        '                                                                }'+
        '                                                ]'+
        '                                }'+
        '                ]'+
        '}'+
        '';
        return json;
    }
}