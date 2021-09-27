public without sharing class CaseWrapperHelper{

    public static Map<String,string> mapAemSalesforceProduct;

    public CaseWrapperHelper(){
       
    }

    public static String getUTCDateTime(DateTime dt){

        //String userTimeZone = UserInfo.getTimeZone().getID();
        String DATETIME_DATABASE_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'';
        String stringDate = dt.format(DATETIME_DATABASE_FORMAT,'GMT');
        return stringDate;

    }

    public static void AssignCaseDetails(id CaseId,Case ObjCase ,CaseWrapper objCaseWrapper){
        
        objCaseWrapper.Id = CaseId;
        objCaseWrapper.CaseNumber = ObjCase.CaseNumber;
        
        if(String.IsNotBlank(ObjCase.Subject)){
            objCaseWrapper.Subject = ObjCase.Subject;
        }
        if(String.IsNotBlank(ObjCase.Product__c)){    
            if(String.IsNotBlank(mapAemSalesforceProduct.get(ObjCase.Product__c))){
               objCaseWrapper.Product = mapAemSalesforceProduct.get(ObjCase.Product__c); 
            }
        }
        if(String.IsNotBlank(ObjCase.ESC_Diagnosis_Summary__c)){
            objCaseWrapper.ESC_Diagnosis_Summary = ObjCase.ESC_Diagnosis_Summary__c;
        }
        if(String.IsNotBlank(ObjCase.Description)){
            objCaseWrapper.Description = ObjCase.Description;
        }
        if(String.IsNotBlank(ObjCase.ESC_Resolution_Comment__c)){
            objCaseWrapper.ESC_Resolution_Comment = ObjCase.ESC_Resolution_Comment__c;
        }
        if(String.IsNotBlank(ObjCase.ESC_Cause__c)){
            objCaseWrapper.ESC_Cause = ObjCase.ESC_Cause__c;
        }
        if(String.IsNotBlank(ObjCase.ESC_Resolution_Code__c)){
            objCaseWrapper.ESC_Resolution_Code = ObjCase.ESC_Resolution_Code__c;
        }
        if(ObjCase.ClosedDate != Null){
            objCaseWrapper.ClosedDate = getUTCDateTime(ObjCase.ClosedDate);
        }
        if(ObjCase.CreatedDate != Null){          
            objCaseWrapper.CreatedDate = getUTCDateTime(ObjCase.CreatedDate);
        }
        if(ObjCase.LastModifiedDate != Null){
            objCaseWrapper.LastModifiedDate =  getUTCDateTime(ObjCase.LastModifiedDate);
        }
        if(String.IsNotBlank(ObjCase.ContactPhone)){
            objCaseWrapper.ContactPhone = ObjCase.ContactPhone;
        }
        if(String.IsNotBlank(ObjCase.ContactEmail)){
            objCaseWrapper.ContactEmail = ObjCase.ContactEmail;
        }
        if(String.IsNotBlank(ObjCase.ContactMobile)){
            objCaseWrapper.ContactMobile = ObjCase.ContactMobile;
        }
        if(String.IsNotBlank(ObjCase.Status)){
            objCaseWrapper.Status = ObjCase.Status;
        }
        if(String.IsNotBlank(ObjCase.MYTR_Query_Type__c)){
            objCaseWrapper.QueryType = ObjCase.MYTR_Query_Type__c;
        }
        if(String.IsNotBlank(ObjCase.MYTR_Category__c   )){
            objCaseWrapper.CategoryType = ObjCase.MYTR_Category__c  ;
        }
        if(String.IsNotBlank(ObjCase.Reason__c)){
            objCaseWrapper.Reason = ObjCase.Reason__c;
        }
        if(String.IsNotBlank(ObjCase.Priority)){
            objCaseWrapper.Priority = ObjCase.Priority;
        }
        if(String.IsNotBlank(ObjCase.ESC_Impact__c)){
            objCaseWrapper.ESC_Impact = ObjCase.ESC_Impact__c;
        }
        if(ObjCase.Follow_Up_Date__c != null){
            objCaseWrapper.Follow_Up_Date = getUTCDateTime(ObjCase.Follow_Up_Date__c);
        }
        if(ObjCase.Due_DateTime__c != null){
            objCaseWrapper.Due_DateTime = getUTCDateTime(ObjCase.Due_DateTime__c);
        }
        if(ObjCase.ESC_Customer_Symptom__c != null){
            objCaseWrapper.ESC_Customer_Symptom = String.valueOf(ObjCase.ESC_Customer_Symptom__c);
        }
         if(ObjCase.ESC_Resolution_Code__c != null){
            objCaseWrapper.ESC_Resolution_Code = String.valueOf(ObjCase.ESC_Resolution_Code__c);
        }
              
    }
    
    /*********************************************************************************
    Last Modified : Herin Acharya || Date : 11/07/2019 || JIRA : MTR-10292
    Change Description : Using SSD Account(Source_System_Detail__c) instead of standard Account
                     Sending 
    *********************************************************************************/
    
    public static void AssignAccountDetails(id CaseId,Case ObjCase ,CaseWrapper objCaseWrapper){
        
        CaseWrapper.Account ObjAccountWrapper = new CaseWrapper.Account();
        ObjAccountWrapper.Name = ObjCase.Account.name;
        ObjAccountWrapper.id = ObjCase.AccountId;
        ObjAccountWrapper.SAPAccountNumber = ObjCase.Account.SAPAccountNumber__C;
        
        objCaseWrapper.Account = ObjAccountWrapper;
        
    }

    public static void AssigntContactDetails(id CaseId,Case ObjCase ,CaseWrapper objCaseWrapper){
        CaseWrapper.CreatedBy ObjContactWrapper = new CaseWrapper.CreatedBy();
        ObjContactWrapper.Name = ObjCase.Contact.name;
        ObjContactWrapper.id = ObjCase.Contactid;
        
        objCaseWrapper.Contact = ObjContactWrapper;
    }
    
    public static void AssignHistories(id CaseId,Case ObjCase ,CaseWrapper objCaseWrapper){
        
        if(ObjCase.Histories!=null && ObjCase.Histories.size() > 0){
            CaseWrapper.CreatedBy ObjCreatedBy;
            CaseWrapper.Histories ObjHistories = new CaseWrapper.Histories();
            CaseWrapper.Records_Z objCaseHistoryRecords;
            List<CaseWrapper.Records_Z> lstCaseHistoryRecords = new List<CaseWrapper.Records_Z>();
            
            for(CaseHistory ObjHistory : ObjCase.Histories){
                objCaseHistoryRecords = new CaseWrapper.Records_Z();
                objCaseHistoryRecords.CaseId = ObjCase.id;
                objCaseHistoryRecords.Id = ObjHistory.id;
                objCaseHistoryRecords.Field = ObjHistory.Field;
                objCaseHistoryRecords.NewValue = String.valueOf(ObjHistory.NewValue);
                objCaseHistoryRecords.OldValue = String.ValueOf(ObjHistory.OldValue) ;
                objCaseHistoryRecords.CreatedDate = getUTCDateTime(ObjHistory.CreatedDate);
                
                ObjCreatedBy = new CaseWrapper.CreatedBy();
                ObjCreatedBy.name = ObjHistory.createdBy.Name;
                
                objCaseHistoryRecords.CreatedBy = ObjCreatedBy;
                lstCaseHistoryRecords.add(objCaseHistoryRecords);
            }
            
            ObjHistories.records = lstCaseHistoryRecords;
            objCaseWrapper.Histories = ObjHistories;
        }
    }

    public static void AssignCaseFeeds(Id CaseId, List<CaseFeed> ListCaseFeed, CaseWrapper objCaseWrapper ,map<Id,Feed_Item_Contact__c> mapFeedIdJunctionObj){
    
    CaseWrapper.Case_Feed objCaseFeed = new CaseWrapper.Case_Feed();
    CaseWrapper.Records_Y objCaseFeedRecords;
    List<CaseWrapper.Records_Y> lstCaseFeedRecords = new List<CaseWrapper.Records_Y>();

    for(CaseFeed ObjCaseFeed1 : ListCaseFeed){

      if(ObjCaseFeed1.body != null && String.isNotblank(ObjCaseFeed1.body)){
        objCaseFeedRecords = new CaseWrapper.Records_Y();
        objCaseFeedRecords.id = ObjCaseFeed1.id;
        objCaseFeedRecords.CaseId = CaseId;
        objCaseFeedRecords.Customer_Feed = ObjCaseFeed1.body.stripHtmlTags();
        objCaseFeedRecords.LastModifiedDate = getUTCDateTime(ObjCaseFeed1.LastModifiedDate);

        if(mapFeedIdJunctionObj.keyset().contains(ObjCaseFeed1.id)){
        objCaseFeedRecords.User_Name =  mapFeedIdJunctionObj.get(ObjCaseFeed1.id).Contact__r.name;
        }else{
        objCaseFeedRecords.Agent_Name = ObjCaseFeed1.CreatedBy.name;
        }

        lstCaseFeedRecords.add(objCaseFeedRecords);
      }
    }

    objCaseFeed.records = lstCaseFeedRecords;
    objCaseFeed.totalSize = lstCaseFeedRecords.size();
    objCaseWrapper.Case_Feed = objCaseFeed;   
  }
  
  public static void AssignAttachmnets(Id CaseId,CaseWrapper objCaseWrapper,list<ContentVersion> ListCv){
  
  CaseWrapper.Attachments objAttachments = new CaseWrapper.Attachments() ;
  CaseWrapper.Records objAttRecords;
  List<CaseWrapper.Records> lstAttRecords = new List<CaseWrapper.Records>();

  system.debug('ListCv---'+ListCv);
  system.debug('ListCvSize---'+ListCv.size());

  for(contentversion ObjCV : ListCv){
    system.debug('ObjCV---'+ObjCV);
    objAttRecords = new CaseWrapper.Records();
    objAttRecords.id = ObjCV.id;
    objAttRecords.ParentId = CaseId;
    objAttRecords.Name = string.valueof(ObjCV.title)+'.'+ string.valueof(ObjCV.FileExtension);
    lstAttRecords.add(objAttRecords);
  }

  objAttachments.records = lstAttRecords;
  objAttachments.totalSize = ListCv.size();

  objCaseWrapper.Attachments = objAttachments;
  
  }
  
  public static List<CaseWrapper> createCaseWrapper(List<case> ListCases){
    
    mapAemSalesforceProduct = new Map<String,string>();  
    List<String> lstSFDCProductValues = new List<String>();
    Map<id,Case> caseMap = new Map<id,Case>();
    List<Id> ListCFId = new list<Id>();
    map<id,Feed_Item_Contact__c> mapFeedIdJunctionObj = new map<id,Feed_Item_Contact__c>();
    List<Id> ListCvId = new List<Id>();
    list<ContentVersion> ListCv = new List<ContentVersion>();

    for(Case ObjCase : ListCases){
      caseMap.put(ObjCase.id, ObjCase);
      if(String.isNotBlank(ObjCase.Product__C)){
        lstSFDCProductValues.add(ObjCase.Product__C);
      }
      
      if(ListCases.size() > 0 && ObjCase.feeds!= null && ObjCase.feeds.size() > 0){
        for(CaseFeed ObjCaseFeed : ObjCase.feeds){
          listCFId.add(ObjCaseFeed.Id);
        }
      }
      
    }

    if(lstSFDCProductValues.size() > 0){
        List<MTR_AEM_SFDC_Product_Mapping__mdt> productMapping = [SELECT AEM_Product_Name__c, 
                              SFDC_Product_Name__c FROM MTR_AEM_SFDC_Product_Mapping__mdt 
                              WHERE SFDC_Product_Name__c in: lstSFDCProductValues];

        if(productMapping.size() > 0){
            for(MTR_AEM_SFDC_Product_Mapping__mdt objMetadate : productMapping){
                mapAemSalesforceProduct.put(objMetadate.SFDC_Product_Name__c,objMetadate.AEM_Product_Name__c);  
            }
        }
    }

    CaseWrapper objCaseWrapper;
    List<CaseWrapper> ListCaseWrapper = new List<CaseWrapper>();
    
    if(listCFId.size() > 0){
    
    List<Feed_Item_Contact__c> lstJunctionObj = new list<Feed_Item_Contact__c>([SELECT Id,Case__c,Contact__c,
            Feed_Item_ID__c,Contact__r.name from Feed_Item_Contact__c where
                        Feed_Item_ID__c in: listCFId]);
            
    List<FeedAttachment> lstFeedAttachment = new list<FeedAttachment>([SELECT Id,recordId from FeedAttachment 
                       where FeedEntityId in: listCFId]);
    if(lstJunctionObj.size() > 0){
      for(Feed_Item_Contact__c ObjJunct : lstJunctionObj){
        mapFeedIdJunctionObj.put(ObjJunct.Feed_Item_ID__c,ObjJunct);
      } 
    }
    
    if(lstFeedAttachment.size() > 0){
      for(FeedAttachment objFeedAttach : lstFeedAttachment){
        ListCvId.add(objFeedAttach.recordId);
      }
    }
    
    if(ListCvId.size() >0){
      ListCv = [SELECT Id,title,FileExtension,VersionData from contentversion where id in: ListCvId
          ORDER BY CreatedDate desc];
    }
    }

    for(Id CaseId : caseMap.keyset()){

      objCaseWrapper = new CaseWrapper();       
      CaseWrapperHelper.AssignCaseDetails(CaseId,caseMap.get(CaseId),objCaseWrapper);
      CaseWrapperHelper.AssignAccountDetails(CaseId,caseMap.get(CaseId),objCaseWrapper);
      CaseWrapperHelper.AssigntContactDetails(CaseId,caseMap.get(CaseId),objCaseWrapper);
      CaseWrapperHelper.AssignHistories(CaseId,caseMap.get(CaseId),objCaseWrapper);
      if(caseMap.size() == 1 && caseMap.get(CaseId).feeds!= null && caseMap.get(CaseId).feeds.size() > 0){
        CaseWrapperHelper.AssignCaseFeeds(CaseId,caseMap.get(CaseId).feeds,objCaseWrapper,mapFeedIdJunctionObj);
      }
    if(caseMap.size() == 1 && caseMap.get(CaseId).feeds!= null && caseMap.get(CaseId).feeds.size() > 0 && ListCv.size()>0){
        CaseWrapperHelper.AssignAttachmnets(CaseId,objCaseWrapper,ListCv);
      }
      ListCaseWrapper.add(objCaseWrapper);
    }

      //CaseFeedWrapper wrap =(CaseFeedWrapper)JSON.deserialize(requestBody.replaceAll('__c','Tempc'),CaseFeedWrapper.class);
      //system.debug('wrap---'+wrap);

    return ListCaseWrapper;
      
  }
}