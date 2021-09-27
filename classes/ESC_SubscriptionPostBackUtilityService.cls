@RestResource(urlMapping='/ESCSubscriptionPostBackUtil/*')
global with sharing class ESC_SubscriptionPostBackUtilityService{
    
    @HttpPost
    global static String updateAssetLineItems() {
        String caseSegment;
        String caseRegion;
        String caseSubtype;
        RestRequest request = RestContext.request;
        system.debug('@@1'+request.requestbody.tostring());
        
        ESC_JSON2ApexSubscriptionPostBack subservice=ESC_JSON2ApexSubscriptionPostBack.parse(request.requestbody.tostring());
        system.debug('subservice----->'+subservice);
       
        
        if(subservice == null ||  subservice.caseResponse == null){
            return 'Invalid Request';
        }
        
        List<Id> lstLineItemId = new List<Id>();
        List<Id> listcslineitemforClone= new List<id>();
       List<Apttus_Config2__AssetLineItem__c> lstUpdate = new List<Apttus_Config2__AssetLineItem__c>();
        List<ESC_Case_Asset_Line_Item__c> lst2updateclitems = new List<ESC_Case_Asset_Line_Item__c>();
        Boolean IsCloneCase= false;
        List<Case> thisCase =new List<Case>();
        
        String caseRefnumber;
        Map<String,ESC_JSON2ApexSubscriptionPostBack.cls_item> mapassetidlineitem= new Map<String,ESC_JSON2ApexSubscriptionPostBack.cls_item>();
        
        if(subservice!=null && subservice.caseResponse !=null){
           for(ESC_JSON2ApexSubscriptionPostBack.cls_caseResponse  csRes:subservice.caseResponse)
           {   
                caseRefnumber=csRes.referenceNumber;
              for(ESC_JSON2ApexSubscriptionPostBack.cls_item  litem:csRes.item){
                        if(!mapassetidlineitem.containsKey(litem.assetId)) {
                             mapassetidlineitem.put(litem.assetId, litem);
                        }
                        
                        //system.debug('&&&123'+mapassetidlineitem);
                        
                        
              }            
                
           }
        }
        if(caseRefnumber ==  null || caseRefnumber ==''){
         return 'Invalid request';
        }
        if(mapassetidlineitem.size()==0){
        return 'Invalid Asset';
        }
       
        if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isAccessible() && Schema.sObjectType.Case.isQueryable() && Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isQueryable()){ 
         thisCase = [SELECT id,
                         casenumber,
                         status,
                         ESC_Subscription_Start_Date__c,LCRM_Sub_BU__c,BU_Segment__c,ESC_Sub_Type__c,ESC_Case_Sub_Type__c,
                         ESC_Resolution_Comment__c,Subject,ESC_Product_Segment_Brand__c,ESC_Product_Title__c,ESC_EnquiryType__c,
                         (select id,
                          name,
                          ESC_Asset_Number__c,
                          ESC_TFMS_Status__c,ESC_SAP_Status__c,ESC_SAP_Status_Message__c,ESC_TFMS_Status_Message__c,
                          ESC_Asset_Line_Item__c,ESC_Asset_Status__c
                          from Case_Asset_Line_Items__r 
                          where ESC_Asset_Number__c IN :mapassetidlineitem.keySet()
                          )
                         FROM Case 
                         WHERE casenumber = :caseRefnumber];
                          system.debug('thisCase----->'+thisCase);
        system.debug('thisCase----->'+thisCase[0].Case_Asset_Line_Items__r); 
       // system.debug('mapassetidlineitem ----->'+mapassetidlineitem);
        }
        if(thisCase.size() == 0){
            return 'Invalid CaseNumber';
        }
        else if(thisCase[0].Case_Asset_Line_Items__r.size()==0){
           return 'Invalid AssetId';
        }
   if(thisCase.size() > 0){
       caseSegment = thisCase[0].BU_Segment__c;
       caseRegion = thisCase[0].LCRM_Sub_BU__c;
       caseSubtype = thisCase[0].ESC_Sub_Type__c;
      for(ESC_Case_Asset_Line_Item__c cali:thisCase[0].Case_Asset_Line_Items__r){
       if(mapassetidlineitem.get(cali.ESC_Asset_Number__c).actionCode.equalsIgnoreCase('Cancellation' )|| mapassetidlineitem.get(cali.ESC_Asset_Number__c).actionCode.equalsIgnoreCase('Unsuspend')
               || mapassetidlineitem.get(cali.ESC_Asset_Number__c).actionCode.equalsIgnoreCase('Suspend' ))           
             { 
                if(cali.ESC_TFMS_Status__c != 'SUCCESS'){
                    if(!mapassetidlineitem.get(cali.ESC_Asset_Number__c).entitlementStatus.equalsIgnoreCase('null' )) 
                   cali.ESC_TFMS_Status__c = mapassetidlineitem.get(cali.ESC_Asset_Number__c).entitlementStatus;
                   
                   if(!mapassetidlineitem.get(cali.ESC_Asset_Number__c).entitlementStatusMessage.equalsIgnoreCase('null' ))
                   cali.ESC_TFMS_Status_Message__c = mapassetidlineitem.get(cali.ESC_Asset_Number__c).entitlementStatusMessage;
               }
               if(cali.ESC_SAP_Status__c != 'Cancelled' && cali.ESC_SAP_Status__c != 'Suspended' && cali.ESC_SAP_Status__c != 'UnSuspended' ){
                 if(!mapassetidlineitem.get(cali.ESC_Asset_Number__c).billingStatus.equalsIgnoreCase('null' ))          
                   cali.ESC_SAP_Status__c = mapassetidlineitem.get(cali.ESC_Asset_Number__c).billingStatus;
                  
                 if(!mapassetidlineitem.get(cali.ESC_Asset_Number__c).billingStatusMessage.equalsIgnoreCase('null' ))
                   cali.ESC_SAP_Status_Message__c = mapassetidlineitem.get(cali.ESC_Asset_Number__c).billingStatusMessage;
               }
                   
                 lst2updateclitems.add(cali);
                 if(cali.ESC_TFMS_Status__c != null && cali.ESC_TFMS_Status__c != '' && cali.ESC_SAP_Status__c == 'Cancelled'){
                    lstLineItemId.add(cali.ESC_Asset_Line_Item__c);
                    listcslineitemforClone.add(cali.id);
                 }
                 if(cali.ESC_TFMS_Status__c =='SUCCESS' && (cali.ESC_SAP_Status__c == 'UnSuspended' || cali.ESC_SAP_Status__c == 'Suspended' )){
                    lstLineItemId.add(cali.ESC_Asset_Line_Item__c);
                  }
                    //Change the status to Pending Status
                    if(mapassetidlineitem.get(cali.ESC_Asset_Number__c).actionCode.equalsIgnoreCase('Cancellation') && cali.ESC_TFMS_Status__c != null && cali.ESC_TFMS_Status__c != '' && cali.ESC_SAP_Status__c == 'Sent For Cancellation' ){
                       StatusAssetSubscriptionChanges(thisCase[0],cali.ESC_Asset_Number__c,'Pending Cancellation');  
                       ClosetheParentCase(thisCase[0]);
                    }
                    else if(mapassetidlineitem.get(cali.ESC_Asset_Number__c).actionCode.equalsIgnoreCase('Unsuspend') && ((cali.ESC_TFMS_Status__c =='Sent to TFMS' && cali.ESC_SAP_Status__c == 'Sent to SAP')|| (cali.ESC_TFMS_Status__c =='SUCCESS' && cali.ESC_SAP_Status__c == 'Sent to SAP' ))){ 
                      StatusAssetSubscriptionChanges(thisCase[0],cali.ESC_Asset_Number__c,'Pending Activation');
                    }
                    else if(mapassetidlineitem.get(cali.ESC_Asset_Number__c).actionCode.equalsIgnoreCase('Suspend') && ((cali.ESC_TFMS_Status__c =='Sent to TFMS' && cali.ESC_SAP_Status__c == 'Sent to SAP') || (cali.ESC_TFMS_Status__c =='SUCCESS' && cali.ESC_SAP_Status__c == 'Sent to SAP' ))) { 
                       StatusAssetSubscriptionChanges(thisCase[0],cali.ESC_Asset_Number__c,'Pending Suspension');
                     }
                
             }
                   
        }
        
        
    }
    
        if(lstLineItemId.size()>0){
        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
        Map<Id,Apttus_Config2__AssetLineItem__c> mapitem = new Map<Id,Apttus_Config2__AssetLineItem__c>([select id,
                                                                                                         Apttus_Config2__AssetStatus__c,
                                                                                                         Asset_Auto_Number__c,Apttus_Config2__CancelledDate__c,
                                                                                                         APTS_Contract_End_Dates__c,
                                                                                                         APTS_MYR_End_Date__c,Apttus_Config2__EndDate__c,
                                                                                                         APTS_Suspend_Start_Date__c,APTS_Suspend_End_Date__c,APTS_Cancellation_Reason_Code__c,APTS_Unlock_Reason_Code__c,
                                                                                                         APTS_Suspend_Lock_Reason_Code__c
                                                                                                         from Apttus_Config2__AssetLineItem__c 
                                                                                                         where id IN :lstLineItemId]);
                                                                                                         
       Map<id,List<Apttus_Config2__AssetLineItem__c>> MapBundleidwithAssetlnItem = getchildofBundle(mapitem.keyset());
        system.debug('Apttusmapitem----->'+mapitem);
        system.debug('MapBundleidwithAssetlnItem----->'+MapBundleidwithAssetlnItem);    
        for(Apttus_Config2__AssetLineItem__c asset:mapitem.values()){
             if( mapassetidlineitem.get(asset.Asset_Auto_Number__c).actionCode == 'Cancellation'){
                    asset.Apttus_Config2__AssetStatus__c = 'Cancelled';
                    List<ESC_Apttus_ReasonCode_Mapping__c>  ESCApttusReasonCodeMapping = getESCApttusReasonCodeMappingInfo(caseSegment,caseRegion,'Cancellation',caseSubtype);
                    if(ESCApttusReasonCodeMapping != null && ESCApttusReasonCodeMapping.size() > 0){
                     asset.APTS_Cancellation_Reason_Code__c =ESCApttusReasonCodeMapping[0].Apttus_Reason_Code__c;
                    }
                    if(mapassetidlineitem.get(asset.Asset_Auto_Number__c).effectiveDate != null && mapassetidlineitem.get(asset.Asset_Auto_Number__c).effectiveDate != ''){
                     datetime myDate =Date.valueOf(mapassetidlineitem.get(asset.Asset_Auto_Number__c).effectiveDate);
                     datetime newDate = mydate.addHours(12);
                     asset.Apttus_Config2__CancelledDate__c=newDate;
                     asset.APTS_MYR_End_Date__c=Date.valueOf(mapassetidlineitem.get(asset.Asset_Auto_Number__c).effectiveDate);
                     asset.APTS_Contract_End_Dates__c=Date.valueOf(mapassetidlineitem.get(asset.Asset_Auto_Number__c).effectiveDate);
                     asset.Apttus_Config2__EndDate__c=Date.valueOf(mapassetidlineitem.get(asset.Asset_Auto_Number__c).effectiveDate);
                    }
                    else{
                    asset.Apttus_Config2__CancelledDate__c=DateTime.Now();
                    asset.APTS_MYR_End_Date__c=Date.Today();
                    asset.APTS_Contract_End_Dates__c=Date.Today();
                    asset.Apttus_Config2__EndDate__c=Date.Today();
                    }
                    lstUpdate.add(asset);
                    If(!MapBundleidwithAssetlnItem.IsEmpty()){
                    for(Apttus_Config2__AssetLineItem__c objassetlineitm : MapBundleidwithAssetlnItem.get(asset.id)){
                          Apttus_Config2__AssetLineItem__c obj= new Apttus_Config2__AssetLineItem__c();
                          obj.id=objassetlineitm.id;
                          obj.Apttus_Config2__AssetStatus__c = 'Cancelled';
                          if(ESCApttusReasonCodeMapping != null && ESCApttusReasonCodeMapping.size() > 0)
                          obj.APTS_Cancellation_Reason_Code__c = asset.APTS_Cancellation_Reason_Code__c;
                          obj.Apttus_Config2__CancelledDate__c = asset.Apttus_Config2__CancelledDate__c;
                          obj.APTS_MYR_End_Date__c=asset.APTS_MYR_End_Date__c;
                          obj.APTS_Contract_End_Dates__c=asset.APTS_Contract_End_Dates__c;
                          obj.Apttus_Config2__EndDate__c=asset.Apttus_Config2__EndDate__c;
                          lstUpdate.add(obj); 
                      }}    
                    
                    IsCloneCase=true;
                    
                }else if( mapassetidlineitem.get(asset.Asset_Auto_Number__c).actionCode == 'Unsuspend'){
                    asset.Apttus_Config2__AssetStatus__c = 'Activated';
                   // asset.APTS_Suspend_End_Date__c= Date.Today();
                    asset.APTS_Suspend_End_Date__c=Date.valueOf(mapassetidlineitem.get(asset.Asset_Auto_Number__c).effectiveDate);
                   List<ESC_Apttus_ReasonCode_Mapping__c>  ESCApttusReasonCodeMapping = getESCApttusReasonCodeMappingInfo(caseSegment,caseRegion,'Unsuspend',caseSubtype);
                    if(ESCApttusReasonCodeMapping != null && ESCApttusReasonCodeMapping.size() > 0){
                     asset.APTS_Unlock_Reason_Code__c =ESCApttusReasonCodeMapping[0].Apttus_Reason_Code__c;
                    }
                    
                    lstUpdate.add(asset);
                    If(!MapBundleidwithAssetlnItem.IsEmpty()){
                    for(Apttus_Config2__AssetLineItem__c objassetlineitm : MapBundleidwithAssetlnItem.get(asset.id)){
                          Apttus_Config2__AssetLineItem__c obj= new Apttus_Config2__AssetLineItem__c();
                          obj.id=objassetlineitm.id;
                          obj.Apttus_Config2__AssetStatus__c = 'Activated';
                          if(ESCApttusReasonCodeMapping != null && ESCApttusReasonCodeMapping.size() > 0)
                          obj.APTS_Unlock_Reason_Code__c =asset.APTS_Unlock_Reason_Code__c;
                          obj.APTS_Suspend_End_Date__c=asset.APTS_Suspend_End_Date__c;
                          lstUpdate.add(obj); 
                    }}  
                }
                else  if( mapassetidlineitem.get(asset.Asset_Auto_Number__c).actionCode == 'Suspend'){
                    asset.Apttus_Config2__AssetStatus__c = 'Suspended';
                    //asset.APTS_Suspend_Start_Date__c = thisCase[0].ESC_Subscription_Start_Date__c;
                    //asset.APTS_Suspend_Start_Date__c = Date.Today();
                    asset.APTS_Suspend_Start_Date__c =Date.valueOf(mapassetidlineitem.get(asset.Asset_Auto_Number__c).effectiveDate);
                    List<ESC_Apttus_ReasonCode_Mapping__c>  ESCApttusReasonCodeMapping = getESCApttusReasonCodeMappingInfo(caseSegment,caseRegion,'Suspend',caseSubtype);
                    if(ESCApttusReasonCodeMapping != null && ESCApttusReasonCodeMapping.size() > 0){
                     asset.APTS_Suspend_Lock_Reason_Code__c =ESCApttusReasonCodeMapping[0].Apttus_Reason_Code__c;
                    }
                   lstUpdate.add(asset);
                   If(!MapBundleidwithAssetlnItem.IsEmpty()){
                   for(Apttus_Config2__AssetLineItem__c objassetlineitm : MapBundleidwithAssetlnItem.get(asset.id)){
                          Apttus_Config2__AssetLineItem__c obj= new Apttus_Config2__AssetLineItem__c();
                          obj.id=objassetlineitm.id;
                          obj.Apttus_Config2__AssetStatus__c = 'Suspended';
                          if(ESCApttusReasonCodeMapping != null && ESCApttusReasonCodeMapping.size() > 0)
                          obj.APTS_Suspend_Lock_Reason_Code__c =asset.APTS_Suspend_Lock_Reason_Code__c;
                          obj.APTS_Suspend_Start_Date__c = asset.APTS_Suspend_Start_Date__c;
                          lstUpdate.add(obj); 
                   }}   
                }
                
            
        }
        }}
  
        try{
            if(lst2updateclitems.size()>0 && Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isUpdateable()){
                update lst2updateclitems;
            }
            
            if(lstUpdate.size()>0 && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isUpdateable()){
                update lstUpdate;
            }
            if(IsCloneCase==true && listcslineitemforClone.size()>0){
               if(thisCase[0].Status != 'Closed'){
                ClosetheParentCase(thisCase[0]);
               }
               cloneRecord(thisCase[0].id,listcslineitemforClone);
            }           
                
        }
        catch(Exception ex){
            system.debug('Exception'+ex.getMessage());
            ApplicationLogUtility.logException('TFMS-SAP Subscription' , 'ESC_SubscriptionPostBackUtilityService' , 'postServices' , ex);
            return 'Error';
        }
        return 'Success';
    }
    
    /******************************************************************* 
    Purpose: Get Subtype Reason Code mapping with in ESC and Apttus from custom setting
    Parameters: 
    Returns: List of custom Seeting record
    ********************************************************************/
    private static List<ESC_Apttus_ReasonCode_Mapping__c> getESCApttusReasonCodeMappingInfo(String setSegment, String setRegion,String CaseType,String CaseSubType)
    {
        List<ESC_Apttus_ReasonCode_Mapping__c> escApttusResonCdMapping = new List<ESC_Apttus_ReasonCode_Mapping__c>();
        if(Schema.sObjectType.ESC_Apttus_ReasonCode_Mapping__c.isAccessible() && Schema.sObjectType.ESC_Apttus_ReasonCode_Mapping__c.isQueryable()){  
            escApttusResonCdMapping = [Select Segment__c, Region__c, Sub_Type__c, Apttus_Reason_Code__c
                                                                         From ESC_Apttus_ReasonCode_Mapping__c
                                                                         where Segment__c =: setSegment AND Region__c =: setRegion AND
                                                                                Type__c = :CaseType AND Sub_Type__c=:CaseSubType];
                                                                                
                                                                                            

        }
        system.debug('@@ escApttusResonCdMapping:' + escApttusResonCdMapping + setSegment + setRegion + CaseType + CaseSubType);
        return escApttusResonCdMapping;    
    }
   
     public static Map<id,List<Apttus_Config2__AssetLineItem__c>> getchildofBundle(Set<id> ParentAssetId){
           //Query the Case Asset lineItem related to the Case
     
       Map<id,List<Apttus_Config2__AssetLineItem__c>> MapAssetidBundleAssetId = new  Map<id,List<Apttus_Config2__AssetLineItem__c>>();
       if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
       for(Apttus_Config2__AssetLineItem__c assetid : [SELECT id,TAX_APTS_PO_Number__c ,Apttus_Config2__BundleAssetId__c,Apttus_Config2__AssetStatus__c,Apttus_Config2__EndDate__c,Asset_Auto_Number__c,APTS_Cancellation_Reason_Code__c,APTS_Unlock_Reason_Code__c,APTS_Suspend_Lock_Reason_Code__c From Apttus_Config2__AssetLineItem__c where Apttus_Config2__BundleAssetId__c IN: ParentAssetId]){
             if(MapAssetidBundleAssetId.containsKey(assetid.Apttus_Config2__BundleAssetId__c)) {
                 List<Apttus_Config2__AssetLineItem__c> assetIdlist = MapAssetidBundleAssetId.get(assetid.Apttus_Config2__BundleAssetId__c);
                 assetIdlist.add(assetId);
                MapAssetidBundleAssetId.put(assetid.Apttus_Config2__BundleAssetId__c, assetIdlist);
             } else {
                MapAssetidBundleAssetId.put(assetid.Apttus_Config2__BundleAssetId__c, new List<Apttus_Config2__AssetLineItem__c> { assetid});
           }
          
         }  }
             
      return MapAssetidBundleAssetId;  
    }
    
   public static void StatusAssetSubscriptionChanges(Case CaseId,String ESCAssetNumber, String Status){
           //Query the Case Asset lineItem related to the Case
         List<ESC_Case_Asset_Line_Item__c> csAssetlnItem =  new List<ESC_Case_Asset_Line_Item__c>();
         if(Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isAccessible() && Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isQueryable()){
         csAssetlnItem = [SELECT ESC_Asset_Number__c, APTS_Contract_End_Date__c,ESC_Asset_Line_Item__c From ESC_Case_Asset_Line_Item__c Where ESC_Case__c =: CaseId.id and ESC_Asset_Number__c=:ESCAssetNumber];
         }
         Set<Id> BundleId= new Set<Id>();
         for(ESC_Case_Asset_Line_Item__c cslineitm : csAssetlnItem){
           BundleId.add(cslineitm.ESC_Asset_Line_Item__c);
         }
        Map<id,List<Apttus_Config2__AssetLineItem__c>> MapBundleidwithAssetlnItemforStatus = getchildofBundle(BundleId);
        List<ESC_Apttus_ReasonCode_Mapping__c>  ESCApttusReasonCodeMapping = getESCApttusReasonCodeMappingInfo(CaseId.BU_Segment__c,CaseId.LCRM_Sub_BU__c,'Cancellation',CaseId.ESC_Sub_Type__c);
         
           //Query the Assets line item using Case Line items
           List<Apttus_Config2__AssetLineItem__c> lineItem= new List<Apttus_Config2__AssetLineItem__c>();
           if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
           for(Apttus_Config2__AssetLineItem__c applineitm : [ select id,Apttus_Config2__AssetStatus__c,Asset_Auto_Number__c,Apttus_Config2__EndDate__c,APTS_Suspend_Start_Date__c,APTS_Suspend_End_Date__c,APTS_Cancellation_Reason_Code__c,APTS_Unlock_Reason_Code__c,APTS_Suspend_Lock_Reason_Code__c,Apttus_Config2__CancelledDate__c from Apttus_Config2__AssetLineItem__c where id=:BundleId]){
                 applineitm.Apttus_Config2__AssetStatus__c=Status;
                 if(status=='Pending Cancellation'){
                 datetime myDate =CaseId.ESC_Subscription_Start_Date__c;
                 datetime newDate = mydate.addHours(12);
                 applineitm.Apttus_Config2__CancelledDate__c=newDate;
                 if(ESCApttusReasonCodeMapping != null && ESCApttusReasonCodeMapping.size() > 0){
                   applineitm.APTS_Cancellation_Reason_Code__c =ESCApttusReasonCodeMapping[0].Apttus_Reason_Code__c;
                 }  
                }       
                 lineItem.add(applineitm);
          
           
           If(!MapBundleidwithAssetlnItemforStatus.IsEmpty()){
              for(Apttus_Config2__AssetLineItem__c objassetlineitm : MapBundleidwithAssetlnItemforStatus.get(applineitm.id)){
                          Apttus_Config2__AssetLineItem__c obj= new Apttus_Config2__AssetLineItem__c();
                          obj.id=objassetlineitm.id;
                          obj.Apttus_Config2__AssetStatus__c = Status;
                          if(status=='Pending Cancellation'){
                             datetime myDate =CaseId.ESC_Subscription_Start_Date__c;
                             datetime newDate = mydate.addHours(12);
                             obj.Apttus_Config2__CancelledDate__c=newDate;
                              if(ESCApttusReasonCodeMapping != null && ESCApttusReasonCodeMapping.size() > 0){
                               obj.APTS_Cancellation_Reason_Code__c =ESCApttusReasonCodeMapping[0].Apttus_Reason_Code__c;
                              }                
                          } 
                          lineItem.add(obj); 
            }}
          }   
        }
           
           //Update the line item
           If(lineItem.size()>0 && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isUpdateable()){
            Update lineItem;
           }           
    }
    
     /******************************************************************* 
    Purpose: Close the case, when we get the success handshake response
    
    ********************************************************************/   
     private static void ClosetheParentCase(Case csObj)
    { 
    try{
         if(csObj != null)
            {
         //Query the Case Asset lineItem related to the Case
         if(Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isAccessible() && Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isQueryable()){
         List<ESC_Case_Asset_Line_Item__c> csAssetlnItem = [SELECT ESC_Asset_Number__c,ESC_Asset_Status__c, APTS_Contract_End_Date__c From ESC_Case_Asset_Line_Item__c Where ESC_Case__c =: csObj.id];
         
         Boolean Lineitemwaiting = false;
         for(ESC_Case_Asset_Line_Item__c cslineitem : csAssetlnItem){
          system.debug('cslineitem.ESC_Asset_Status__c****'+cslineitem.ESC_Asset_Status__c);
         if(cslineitem.ESC_Asset_Status__c != 'Pending Cancellation' && cslineitem.ESC_Asset_Status__c != 'Cancelled'){
         Lineitemwaiting=true;
         break;
         }}
         system.debug('Lineitemwaiting****'+Lineitemwaiting);
         
           if (csAssetlnItem.size()>0 && Lineitemwaiting== false){
                if(csObj.ESC_Case_Sub_Type__c == null)
                   csObj.ESC_Case_Sub_Type__c =csObj.ESC_EnquiryType__c;
                if(csObj.ESC_Resolution_Comment__c == null)
                   csObj.ESC_Resolution_Comment__c = csObj.ESC_EnquiryType__c;
                if(csObj.Subject == null)
                   csObj.Subject = csObj.ESC_EnquiryType__c;
                if(csObj.ESC_Product_Segment_Brand__c == null)
                   csObj.ESC_Product_Segment_Brand__c = csObj.ESC_EnquiryType__c;
                if(csObj.ESC_Product_Title__c == null)
                   csObj.ESC_Product_Title__c = csObj.ESC_EnquiryType__c;
                List<AssignmentRule> arlist = [select Id from AssignmentRule where SobjectType = 'Case' and Name = 'ESC Tax Inactive Case Owner' limit 1];   
                Database.DMLOptions dmo = new Database.DMLOptions();
                if(arlist.size()>0){
                dmo.assignmentRuleHeader.assignmentRuleId = arlist[0].id;
                }
                csObj.status = 'Closed';
               if(Schema.sObjectType.Case.isUpdateable()){
                database.update(csObj,dmo);
                }
            }
           }
           }
     }
     catch(Exception ex)
     {
      ApplicationLogUtility.logException('TXP','ESC_IntegrationUtil','createDellBoomiRequest',ex);     
     }  
     
     
    }
    
    
    /******************************************************************* 
    Purpose: Get Cloned Case for CC
    Parameters: 
    Returns: Cloned Case
    ********************************************************************/  
     @future 
     @TestVisible private static void cloneRecord(id csid,List<id> caslineitemid)
    {   
     /* query Case and then clone it */
     Id CaseId =csid; 
     String soql = CloneUtility.getCreatableFieldsSOQL('Case','id =: CaseId');
     Case cs1 = (Case)Database.query(soql);
     Case csCloneCopy= cs1.clone(false, true);
     //insert cs2;
      Map<Id,User> usrMap;
     List<id> lstusrid = new List<Id>();
     if(cs1.ownerId!=null && ((String) cs1.OwnerId).StartsWith('005')){
        lstusrid.add(cs1.ownerId);
      }
     if(lstusrid.size()>0){
            usrMap = new Map<Id,User>([select id,Division,Department,isActive,Manager.Email,ManagerId from User where id in :lstusrid]);
      }
      List<Group> Queuelist =new  List<Group>();
      if(usrMap.size()>0 && usrMap.get(cs1.OwnerId).Department != null)
      Queuelist=[select Id from Group where Name =:usrMap.get(cs1.OwnerId).Department  and Type = 'Queue'];
      
      if(Queuelist.size()<1)
        Queuelist=[select Id from Group where developerName =: System.Label.ESC_AssetChargeCancellationQueue and Type = 'Queue'];
     
     csCloneCopy.Status='New';
     csCloneCopy.Parentid=csid;
     csCloneCopy.ESC_Unique_Identifier__c ='Manual Credit';
     csCloneCopy.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
     csCloneCopy.ESC_Service_Restored__c=null;
     Database.DMLOptions dmo = new Database.DMLOptions();
     dmo.assignmentRuleHeader.useDefaultRule= false;
    //csCloneCopy.OwnerId = createCaseOwnerId;
    if(Queuelist.size()>0){
     csCloneCopy.Ownerid=Queuelist[0].id;
     }
     csCloneCopy.setOptions(dmo);
     insert csCloneCopy;
     system.debug('Clone***' +csCloneCopy);
     
     
     if(caslineitemid.size()>0){
     List<ESC_Case_Asset_Line_Item__c> listCaselineITem = new List<ESC_Case_Asset_Line_Item__c>();
     for(id id: caslineitemid){
     String soql2 = CloneUtility.getCreatableFieldsSOQL('ESC_Case_Asset_Line_Item__c',' id =: id');
     ESC_Case_Asset_Line_Item__c cslineitem = (ESC_Case_Asset_Line_Item__c)Database.query(soql2);
     ESC_Case_Asset_Line_Item__c  Clonecslineitem = cslineitem.clone(false, true);
     Clonecslineitem.ESC_Case__c=csCloneCopy.id;
     listCaselineITem.add(Clonecslineitem);
     }
     if(listCaselineITem.size()>0){
     insert listCaselineITem;
     system.debug('ClonelistCaselineITem***' +listCaselineITem);
     }
     }
     
    }
    
   
    
}