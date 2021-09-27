@IsTest
public  class ESC_SubscriptionIntegration_Test {
      public static testmethod void methodCreateSubsctiptionRequest(){
          String caseEnquiryType = 'Cancellation';
          String assestStatus = 'Suspended';
         //Create a Account and Insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         //Create a Contact and Insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         //Create a Case and Insert as a dummy data
          case ca = createCase(testAccount,testContact,caseEnquiryType);
        
          //Create a Asset Line Item and Insert as a dummy data
         Apttus_Config2__AssetLineItem__c testAppasset = createAssestLineItem(testAccount,assestStatus);
         
         //Create a Case Asset Line Items and Insert as a dummy data
         ESC_Case_Asset_Line_Item__c testCAsset= createCaseAssestLineItem(ca,testAppasset);
          
         integrationDefault();
          
         Set<Id> setCasesIDs=new Set<Id>();
         setCasesIDs.add(ca.id);
         List<WebServiceSettings__c> listWebServiceSettings  = new List<WebServiceSettings__c>();
        WebServiceSettings__c websrv1 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCAssetCancelEntitlement',Username__c='test',Password__c='test',Endpoint__c='https://api-uat.thomsonreuters.com/dep/entitlementmanagement/qa/v1/assetcancellation');
        listWebServiceSettings.add(websrv1);
         WebServiceSettings__c websrv2 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCAssetSuspendEntitlement',Username__c='test',Password__c='test',Endpoint__c='https://api-uat.thomsonreuters.com/dep/entitlementmanagement/qa/v1/suspendentitlement');
        listWebServiceSettings.add(websrv2);
         WebServiceSettings__c websrv3 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCAssetUnsuspendEntitlement',Username__c='test',Password__c='test',Endpoint__c='https://api-uat.thomsonreuters.com/dep/entitlementmanagement/qa/v1/unsuspendentitlement');
        listWebServiceSettings.add(websrv3);
         WebServiceSettings__c websrv4 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCAssetNonRevenueModification',Username__c='test',Password__c='test',Endpoint__c='https://api-uat.thomsonreuters.com/dep/ordermanagement/qa/v1/nonrevenuemodification');
        listWebServiceSettings.add(websrv4);
        
        insert listWebServiceSettings;
        
         //ESC_SubscriptionResponseWrapper sub =   getRsponse();
         //System.debug('ESC_SubscriptionResponseWrapper'+sub);  
        Test.startTest();

            //Test.setMock(HttpCalloutMock.class, new ESC_SubscriptionMockResponse());
            ESC_SubscriptionIntegration.createSubsctiptionRequest(setCasesIDs);
         Test.stopTest();
        }
    
    
        public static testmethod void methodCreateSubsctiptionRequest2(){
          String caseEnquiryType = 'Modify Subscription';
           String assestStatus = 'Activated';
         //Create a Account and Insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         //Create a Contact and Insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         //Create a Case and Insert as a dummy data
          case ca = createCase(testAccount,testContact,caseEnquiryType);
        
          //Create a Asset Line Item and Insert as a dummy data
          List<string> assetIdList = new List<string>();
         Apttus_Config2__AssetLineItem__c testAppasset = createAssestLineItem(testAccount,assestStatus);
         Apttus_Config2__AssetLineItem__c testAppasset1 = createAssestLineItem(testAccount,assestStatus);
         testAppasset1.Apttus_Config2__BundleAssetId__c = testAppasset.id;
         update testAppasset1;
         assetIdList.add(testAppasset.Asset_Auto_Number__c);
         assetIdList.add(testAppasset1.Asset_Auto_Number__c);
         //Create a Case Asset Line Items and Insert as a dummy data
         ESC_Case_Asset_Line_Item__c testCAsset= createCaseAssestLineItem(ca,testAppasset);
         integrationDefault();
         Set<Id> setCasesIDs=new Set<Id>();
         setCasesIDs.add(ca.id);
          
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(getRsponse());
        res.setStatusCode(200);  
           
         /* ESC_SubscriptionResponseWrapper sub =   getRsponse();
          System.debug('ESC_SubscriptionResponseWrapper'+sub);  
            */
            
        List<WebServiceSettings__c> listWebServiceSettings  = new List<WebServiceSettings__c>();
        WebServiceSettings__c websrv1 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCAssetCancelEntitlement',Username__c='test',Password__c='test',Endpoint__c='https://api-uat.thomsonreuters.com/dep/entitlementmanagement/qa/v1/assetcancellation');
        listWebServiceSettings.add(websrv1);
         WebServiceSettings__c websrv2 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCAssetSuspendEntitlement',Username__c='test',Password__c='test',Endpoint__c='https://api-uat.thomsonreuters.com/dep/entitlementmanagement/qa/v1/suspendentitlement');
        listWebServiceSettings.add(websrv2);
         WebServiceSettings__c websrv3 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCAssetUnsuspendEntitlement',Username__c='test',Password__c='test',Endpoint__c='https://api-uat.thomsonreuters.com/dep/entitlementmanagement/qa/v1/unsuspendentitlement');
        listWebServiceSettings.add(websrv3);
         WebServiceSettings__c websrv4 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCAssetNonRevenueModification',Username__c='test',Password__c='test',Endpoint__c='https://api-uat.thomsonreuters.com/dep/ordermanagement/qa/v1/nonrevenuemodification');
        listWebServiceSettings.add(websrv4);
        
        insert listWebServiceSettings;
        
         Test.startTest();
            
            //Test.setMock(HttpCalloutMock.class, new ESC_SubscriptionMockResponse());
            ESC_SubscriptionIntegration.createSubsctiptionRequest(setCasesIDs);
            ESC_SubscriptionIntegration.createSubsctiptionResponse(res);
            ESC_SubscriptionIntegration.UpdatethePONumberonAssetlineItem(ca,assetIdList);
         Test.stopTest();
        }


     /* ------------------Test Data for creating test methods --------------------  */
    
    
    public static void integrationDefault(){
          USL_Integration_defaults__c uSL1= new USL_Integration_defaults__c();
          uSL1.Region__c='Canada';
          uSL1.Segment__c='Professional Legal';
          uSL1.Name='CanDefaults2';
          uSL1.Companyid__c='CAN7676';
          insert uSL1;
        
    }
     
    
     public static ESC_Case_Asset_Line_Item__c createCaseAssestLineItem(Case cas,Apttus_Config2__AssetLineItem__c testAppasset) {
        
         ESC_Case_Asset_Line_Item__c testCAsset= new ESC_Case_Asset_Line_Item__c();
          testCAsset.ESC_Case__c=cas.id;
          testCAsset.ESC_Asset_Line_Item__c=testAppasset.id;
          testCAsset.ESC_TAX_APTS_PO_Number__c='12345';
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
          
         // testAppasset.Apttus_Config2__BundleAssetId__c=
          Insert testAppasset;
        
        return testAppasset;
        
    }    
     public static case createCase(Account acc,Contact con,String caseEnquiryType){
        
        Case ca= new Case();
         ca = ESC_GenericTestutility.TestCaseUtil(con.id,acc.id,'New');
         Insert ca;  //Insert Case 1
         
         ca.BU_Segment__c='Professional Legal';
         ca.LCRM_Sub_BU__c='Canada';
         ca.ESC_Sub_Type__c= 'Non-Revenue Modification';
         ca.ESC_EnquiryType__c=caseEnquiryType;
         //ca.TXP_Sub_Type_Reason_Code__c='Credit';
         ca.TFMS_Reference_Number__c='7634374637';
         ca.ESC_Subscription_Start_Date__c=System.today().adddays(10);
         
         update ca;
         return ca;
        
    }
    public static string getRsponse(){
         String json=        '{'+
        '  "StatusDetails" : ['+
        '    {'+
        '      "statusMessage" : "Not Modified",'+
        '      "contractNumber" : "14773",'+
        '      "assetId" : "ABCtest-2211"'+
        '    },'+
        '    {'+
        '      "statusMessage" : "Not Modified",'+
        '      "contractNumber" : "14774",'+
        '      "assetId" : "ABCtest-2212"'+
        '    }'+
        '  ]'+
        '} ';
        //ESC_SubscriptionResponseWrapper Subswrap = (ESC_SubscriptionResponseWrapper) System.JSON.deserialize(json, ESC_SubscriptionResponseWrapper.class);
       return json; 
    }
   
}