public without sharing class ESC_SubscriptionIntegration {
 public static List < Case > caseLst;
 public static List < Case > casel;
 public static List < Apttus_Config2__AssetLineItem__c > AppAssetLineItm;
  
 public static void createSubsctiptionRequest(Set <Id> CaseID) {
 
  try {

   if (Schema.sObjectType.Case.isAccessible()) {
    casel = [SELECT Id,Casenumber,BU_Segment__c,LCRM_Sub_BU__c,ESC_EnquiryType__c, ESC_Sub_Type__c,ESC_Subscription_Start_Date__c,Ownerid FROM Case Where id in: CaseId];
    
    if(casel[0].ESC_EnquiryType__c =='Cancellation'){
    caseLst = [SELECT Id,Casenumber,BU_Segment__c,LCRM_Sub_BU__c,ESC_EnquiryType__c, ESC_Sub_Type__c,ESC_Subscription_Start_Date__c,USL_SAP_Account_Number__c,Ownerid,ESC_Case_Sub_Type__c,ESC_Resolution_Comment__c,Subject,ESC_Product_Segment_Brand__c,ESC_Product_Title__c,(SELECT ESC_Asset_Number__c, APTS_Contract_End_Date__c,ESC_Net_Price__c,ESC_Contract_Number__c,ESC_TAX_APTS_PO_Number__c from Case_Asset_Line_Items__r where ESC_Asset_Status__c ='Activated' or ESC_Asset_Status__c ='Suspended') FROM Case Where id in: CaseId];
    }
    else if(casel[0].ESC_EnquiryType__c =='Suspend'){
    caseLst = [SELECT Id,Casenumber,BU_Segment__c,LCRM_Sub_BU__c,ESC_EnquiryType__c, ESC_Sub_Type__c,ESC_Subscription_Start_Date__c,USL_SAP_Account_Number__c,Ownerid,ESC_Case_Sub_Type__c,ESC_Resolution_Comment__c,Subject,ESC_Product_Segment_Brand__c,ESC_Product_Title__c,(SELECT ESC_Asset_Number__c, APTS_Contract_End_Date__c,ESC_Net_Price__c,ESC_Contract_Number__c,ESC_TAX_APTS_PO_Number__c from Case_Asset_Line_Items__r where ESC_Asset_Status__c ='Activated') FROM Case Where id in: CaseId];
    }
    else if(casel[0].ESC_EnquiryType__c =='Unsuspend'){
    caseLst = [SELECT Id,Casenumber,BU_Segment__c,LCRM_Sub_BU__c,ESC_EnquiryType__c, ESC_Sub_Type__c,ESC_Subscription_Start_Date__c,USL_SAP_Account_Number__c,Ownerid,ESC_Case_Sub_Type__c,ESC_Resolution_Comment__c,Subject,ESC_Product_Segment_Brand__c,ESC_Product_Title__c,(SELECT ESC_Asset_Number__c, APTS_Contract_End_Date__c,ESC_Net_Price__c,ESC_Contract_Number__c,ESC_TAX_APTS_PO_Number__c from Case_Asset_Line_Items__r where  ESC_Asset_Status__c = 'Pending Cancellation' or ESC_Asset_Status__c ='Suspended') FROM Case Where id in: CaseId];
    }
    else if(casel[0].ESC_EnquiryType__c =='Modify Subscription' && casel[0].ESC_Sub_Type__c=='Non-Revenue Modification'){
    caseLst = [SELECT Id,Casenumber,BU_Segment__c,LCRM_Sub_BU__c,ESC_EnquiryType__c, ESC_Sub_Type__c,ESC_Subscription_Start_Date__c,USL_SAP_Account_Number__c,Ownerid,ESC_Case_Sub_Type__c,ESC_Resolution_Comment__c,Subject,ESC_Product_Segment_Brand__c,ESC_Product_Title__c,(SELECT ESC_Asset_Number__c, APTS_Contract_End_Date__c,ESC_Net_Price__c,ESC_Contract_Number__c,ESC_TAX_APTS_PO_Number__c from Case_Asset_Line_Items__r where ESC_Asset_Status__c = 'Pending Cancellation' or ESC_Asset_Status__c ='Activated') FROM Case Where id in: CaseId];
    }
    
   }


   if (caseLst != null && caseLst.size() > 0) {
   String RequestType;
   if(caseLst[0].ESC_EnquiryType__c != null){
    RequestType = caseLst[0].ESC_EnquiryType__c;
   }
    
    
    
    ESC_AssetSubscriptionWrapper req = new ESC_AssetSubscriptionWrapper();
    USL_Integration_defaults__c intval = USLARHelper.getIntegrationDefaults(caseLst[0].BU_Segment__c,caseLst[0].LCRM_Sub_BU__c);
      
      

    ESC_AssetSubscriptionWrapper.cls_BOOMIHeader boomiHead = new ESC_AssetSubscriptionWrapper.cls_BOOMIHeader();
    boomiHead.applicationId = intval.Applicationid__c;
    boomiHead.companyId = intval.Companyid__c;
    req.bOOMIHeader = boomiHead;
    
    
    req.casedetail = new List<ESC_AssetSubscriptionWrapper.cls_case>();
    ESC_AssetSubscriptionWrapper.cls_case cs = new ESC_AssetSubscriptionWrapper.cls_case();
    cs.referenceNumber=caseLst[0].Casenumber;
    cs.referenceid=caseLst[0].Id;
    cs.accountNumber=caseLst[0].USL_SAP_Account_Number__c;
    ESC_AssetSubscriptionWrapper.cls_requestorInfo objrequest = new ESC_AssetSubscriptionWrapper.cls_requestorInfo();
    objrequest.requestorNumber=caseLst[0].Ownerid;
    cs.requestorInfo =objrequest;
    
    cs.item= new List<ESC_AssetSubscriptionWrapper.cls_item>();
    
    for (ESC_Case_Asset_Line_Item__c csLineItem: caseLst[0].Case_Asset_Line_Items__r) {
             ESC_AssetSubscriptionWrapper.cls_item clslineItem = new ESC_AssetSubscriptionWrapper.cls_item();
             clslineItem.actionCode = caseLst[0].ESC_EnquiryType__c;
             clslineItem.reasonCode = caseLst[0].ESC_Sub_Type__c;
             if(caseLst[0].ESC_Subscription_Start_Date__c < Date.Today()){
                 clslineItem.effectiveDate = string.valueOf(Date.Today());
                 clslineItem.endDate = string.valueOf(Date.Today());
             }else{
                 clslineItem.effectiveDate = string.valueOf(caseLst[0].ESC_Subscription_Start_Date__c);
                 clslineItem.endDate = string.valueOf(caseLst[0].ESC_Subscription_Start_Date__c);
             }
             if(caseLst[0].ESC_Subscription_Start_Date__c <= Date.Today())
             clslineItem.dateIdentifierFlag='Y';
             else
             clslineItem.dateIdentifierFlag='N';
             clslineItem.assetId = string.valueOf(csLineItem.ESC_Asset_Number__c);
             clslineItem.poNumber = string.valueOf(csLineItem.ESC_TAX_APTS_PO_Number__c);
             if(clslineItem.poNumber != null){
             clslineItem.actionCode = caseLst[0].ESC_EnquiryType__c;
             }
             clslineItem.amount = string.valueOf(csLineItem.ESC_Net_Price__c);
             clslineItem.contractNumber = string.valueOf(csLineItem.ESC_Contract_Number__c);
             cs.item.add(clslineItem); 
         }
        
    req.casedetail.add(cs);
      
    system.debug('req************************'+req);
    
    httpResponse resp;
    
     if (RequestType == 'Cancellation')
     resp = ESC_DellBoomiCalloutUtil.sendS4RequestAsset(req, 'ESCAssetCancelEntitlement');
     Else if (RequestType == 'Unsuspend')
     resp = ESC_DellBoomiCalloutUtil.sendS4RequestAsset(req, 'ESCAssetUnsuspendEntitlement');
     Else if (RequestType == 'Suspend')
     resp = ESC_DellBoomiCalloutUtil.sendS4RequestAsset(req, 'ESCAssetSuspendEntitlement');
     Else if (RequestType == 'Modify Subscription')
     resp = ESC_DellBoomiCalloutUtil.sendS4RequestAsset(req, 'ESCAssetNonRevenueModification');
      createSubsctiptionResponse(resp);
     
    }}
    catch (Exception ex) {
     System.debug('Something went wrong' + ex.getMessage() + ex.getLineNumber());

 }}
    public static void createSubsctiptionResponse(HttpResponse resp) {
    String strRes = resp.getBody();
    if (strRes != null) {
     try {
      // JSON De-serialize the Response : JSONParser parser = JSON.createParser(strRes);
      system.debug('strRes*********'+strRes);
      Case caseobj = caseLst[0];
      if (caseobj!= null && (caseobj.ESC_EnquiryType__c == 'Cancellation' || caseobj.ESC_EnquiryType__c == 'Unsuspend' || caseobj.ESC_EnquiryType__c == 'Suspend') && resp.getStatusCode() == 200) {
      /*if (Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isUpdateable()) {
         if(caseobj.ESC_EnquiryType__c == 'Cancellation'){
             StatusAssetSubscriptionChanges(caseobj,'Pending Cancellation');
             ClosetheParentCase(caseobj);
          }
          else if(caseobj.ESC_EnquiryType__c == 'Unsuspend'){
             StatusAssetSubscriptionChanges(caseobj,'Pending Activation'); 
          }
          else if(caseobj.ESC_EnquiryType__c == 'Suspend'){
             StatusAssetSubscriptionChanges(caseobj,'Pending Suspension'); 
          }
     }*/
     }
     else if(caseobj!= null && (caseobj.ESC_EnquiryType__c == 'Cancellation' || caseobj.ESC_EnquiryType__c == 'Unsuspend' || caseobj.ESC_EnquiryType__c == 'Suspend') && resp.getStatusCode() != 200){
       //Capture the Dellboomi Error
         UpdateErrorOnCsAssetlineItem(caseobj,resp.getStatusCode());    
     }
     
     else if (caseobj!= null && (caseobj.ESC_EnquiryType__c == 'Modify Subscription') && resp.getStatusCode() == 200){
          // JSON De-serialize the Response  
          ESC_SubscriptionResponseWrapper res = ESC_SubscriptionResponseWrapper.parse(strRes);
           List<String> assetIdList = new List<String>(); 
            Map<String,String> assetIdMessage= new Map<String,String>();
            Map<String,String> assetIdStatus = new Map<String,String>();
          for (ESC_SubscriptionResponseWrapper.cls_StatusDetails sDetail: res.StatusDetails) {
              if (sDetail.status == 'Contract Modified' && sDetail.assetId != null) {
                 assetIdList.add(sDetail.assetId);
              }
              if (sDetail.status != '' && sDetail.status != null) {
                 assetIdStatus.put(sDetail.assetId,sDetail.status);
               }
               if (sDetail.statusMessage != '' && sDetail.statusMessage != null) {
                 assetIdMessage.put(sDetail.assetId,sDetail.statusMessage);
               }
               
          }
           
             If(!assetIdList.IsEmpty())
             UpdatethePONumberonAssetlineItem(caseobj,assetIdList);
             if(!assetIdStatus.IsEmpty() || !assetIdMessage.IsEmpty()) 
             UpdatetheStatusOnCsAssetlineItem(caseobj,assetIdStatus,assetIdMessage);
             
      }
      else if(caseobj!= null && (caseobj.ESC_EnquiryType__c == 'Modify Subscription') && resp.getStatusCode() != 200){
         //Capture the Dellboomi Error
         UpdateErrorOnCsAssetlineItem(caseobj,resp.getStatusCode());         
      }       

     }
   // }
   
 catch (Exception ex) {
        System.debug('Something went wrong' + ex.getMessage() + ex.getLineNumber());
        ApplicationLogUtility.logException('TXP','ESC_IntegrationUtil','createDellBoomiRequest',ex);

 }

}

}


    
    public static void UpdatethePONumberonAssetlineItem(Case CaseId,List<String> poNumAssetIdList){
           //Query the Case Asset lineItem related to the Case
       //Set<Id> setAsetId = new Set<Id>();
       List<Id> listAsetId = new List<Id>();
       Map<id,List<id>> MapAssetidBundleAssetId = new  Map<id,List<id>>();
       
      for(Apttus_Config2__AssetLineItem__c  apptuslineitm: [ SELECT id,TAX_APTS_PO_Number__c ,Apttus_Config2__BundleAssetId__c From Apttus_Config2__AssetLineItem__c where Asset_Auto_Number__c IN:poNumAssetIdList]){
      listAsetId.add(apptuslineitm.id);
     } 
         for(Apttus_Config2__AssetLineItem__c assetid : [SELECT id,TAX_APTS_PO_Number__c ,Apttus_Config2__BundleAssetId__c From Apttus_Config2__AssetLineItem__c where Apttus_Config2__BundleAssetId__c IN: listAsetId]){
             if(MapAssetidBundleAssetId.containsKey(assetid.Apttus_Config2__BundleAssetId__c)) {
                 List<Id> assetIdlist = MapAssetidBundleAssetId.get(assetid.Apttus_Config2__BundleAssetId__c);
                 assetIdlist.add(assetId.Id);
                MapAssetidBundleAssetId.put(assetid.Apttus_Config2__BundleAssetId__c, assetIdlist);
             } else {
                MapAssetidBundleAssetId.put(assetid.Apttus_Config2__BundleAssetId__c, new List<Id> { assetid.Id });
           }
           
         }  
          
           List<Apttus_Config2__AssetLineItem__c> lineItem= new List<Apttus_Config2__AssetLineItem__c>();
        //Query the Assets line item using Case Line items
          for(ESC_Case_Asset_Line_Item__c applineitm: [ Select id,ESC_TAX_APTS_PO_Number__c,ESC_Asset_Line_Item__c,ESC_Asset_Number__c,ESC_Asset_Line_Item__r.id from ESC_Case_Asset_Line_Item__c where ESC_Case__c =:CaseId.id and ESC_Asset_Number__c IN:poNumAssetIdList]){
           Apttus_Config2__AssetLineItem__c obj= new Apttus_Config2__AssetLineItem__c();
            //obj.id=applineitm.ESC_Asset_Line_Item__r.id;
               obj.id=applineitm.ESC_Asset_Line_Item__c;
               obj.TAX_APTS_PO_Number__c = applineitm.ESC_TAX_APTS_PO_Number__c;
               lineItem.add(obj); 
               system.debug('123'+obj);
            if(MapAssetidBundleAssetId.keyset().size() > 0 && MapAssetidBundleAssetId.containsKey(applineitm.ESC_Asset_Line_Item__c))
               {
                 for(id id: MapAssetidBundleAssetId.get(applineitm.ESC_Asset_Line_Item__c)){
                   Apttus_Config2__AssetLineItem__c obj1= new Apttus_Config2__AssetLineItem__c();
                   obj1.id=id;
                   obj1.TAX_APTS_PO_Number__c = applineitm.ESC_TAX_APTS_PO_Number__c;
                   lineItem.add(obj1); 
                 }  
               }         
               
          }      
          system.debug('lineItem**********'+lineItem); 
               
           If(lineItem.size()>0){
            Update lineItem;
           }           
    }
    
     
     public static void UpdatetheStatusOnCsAssetlineItem(Case CaseId, Map<String,String> assetIdStatus, Map<String,String> assetIdStatusMessage){
           List<ESC_Case_Asset_Line_Item__c> cslineItem= new List<ESC_Case_Asset_Line_Item__c>();
            //Query the Case Assets line item using Case 
          
          for(ESC_Case_Asset_Line_Item__c lineitm: [SELECT id,ESC_Asset_Number__c, APTS_Contract_End_Date__c,ESC_TAX_APTS_PO_Number__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c From ESC_Case_Asset_Line_Item__c Where ESC_Case__c =: CaseId.id and ESC_Asset_Number__c in: assetIdStatus.keyset()]){
              lineitm.ESC_SAP_Status_Message__c=assetIdStatusMessage.get(lineitm.ESC_Asset_Number__c);
              lineitm.ESC_SAP_Status__c=assetIdStatus.get(lineitm.ESC_Asset_Number__c);
              cslineItem.add(lineitm);
              
              
              
           }
           
           //Update the line item
           If(cslineItem.size()>0){
            Update cslineItem;
           }           
    }
    
     public static void UpdateErrorOnCsAssetlineItem(Case CaseId,Integer Statuscode){
           List<ESC_Case_Asset_Line_Item__c> cslineItem= new List<ESC_Case_Asset_Line_Item__c>();
            //Query the Case Assets line item using Case 
          
          for(ESC_Case_Asset_Line_Item__c lineitm: [SELECT id,ESC_Asset_Number__c, APTS_Contract_End_Date__c,ESC_TAX_APTS_PO_Number__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c From ESC_Case_Asset_Line_Item__c Where ESC_Case__c =: CaseId.id]){
              lineitm.ESC_SAP_Status_Message__c='Service Unavailable';
              lineitm.ESC_SAP_Status__c=String.Valueof(Statuscode);
              cslineItem.add(lineitm);
           }
           
           //Update the line item
           If(cslineItem.size()>0){
            Update cslineItem;
           }           
    }
    
    
    
    

}