/**
 * @description ESC_ApprovalProcessLWCController
 */
public without sharing class ESC_ApprovalProcessLWCController {
    
    public static String jsonMapRec;
    public static List<Id> lstrecid = new List<id>();
    /**
 * @description getApprovals
 * @ return List<DataTableWrapper> 
 */
    @AuraEnabled(cacheable=true)
    public static List<DataTableWrapper> getApprovals() {
        //List<Id> lstrecid = new List<id>();
        Map<Id,String> appMap = new Map<Id,String>();
        integer limitOfRecords = 500;
        String jsonMapRecs =gettargetobjectlst();
         system.debug(LoggingLevel.WARN,'jsonMapRecs***'+jsonMapRecs);
        if(jsonMapRecs!=''){
            Map<Id,List<Id>> jsonMapRec = (Map<Id,List<Id>>)JSON.deserialize(jsonMapRecs, Map<Id,List<Id>>.class);
            for(Id recid:jsonMapRec.keyset()){
                lstrecid.add(recid);
                for(Id appid:jsonMapRec.get(recid)){
                    appMap.put(recid,appid);
                }
            }
        }
         system.debug(LoggingLevel.WARN,'jsonMapRec***'+jsonMapRec);
         system.debug(LoggingLevel.WARN,'appMap***'+appMap);
        List<ESC_Case_Form_Extension__c> lstappfrmrec;
        List<Case> lstappcaserec;
        List<knowledge__kav> lstartrec;
        if(Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible() || Schema.sObjectType.Case.isAccessible()){
                                                lstappfrmrec = [select Id,
                                                                USL_Total_Amount__c,
                                                                Type_of_Currency__c,
                                                                ESC_Case__c,
                                                                ESC_Case__r.LCRM_Sub_BU__c,
                                                                ESC_Case__r.BU_Segment__c,
                                                                ESC_Case__r.CaseNumber,
                                                                ESC_Case__r.AccountId,
                                                                ESC_Case__r.Account.Name,
                                                                ESC_Case__r.USL_SAP_Account_Number__c,
                                                                ESC_Case__r.OwnerId,
                                                                ESC_Case__r.Owner.Name,
                                                                ESC_Case__r.createddate,
                                                                Name,
                                                                ESC_Form__r.Name,
                                                                CreatedDate 
                                                                from ESC_Case_Form_Extension__c 
                                                                where Id in: lstrecid 
                                                                order by Id asc 
                                                                limit:limitOfRecords];
                            lstappcaserec = [select id,
                                        CaseNumber,
                                        Status,
                                        USL_SAP_Account_Number__c,
                                        LCRM_Sub_BU__c,
                                        BU_Segment__c,
                                        OwnerId,
                                        Owner.Name,
                                        createddate,
                                        AccountId,
                                        Account.Name,
                                        ESC_Total_Net_Price1__c
                                         from Case 
                                          where id in: lstrecid 
                                          order by id asc 
                                          limit:limitOfRecords];
                                          
                            lstArtrec = [select Id,
                                            title,
                                            articlenumber,
                                            publishstatus,
                      Article_Classification__c,

                                            createddate 
                                                from knowledge__kav 
                                                    where id in: lstrecid 
                                                    order by id asc 
                                                    limit:limitOfRecords];
        }
        
         system.debug(LoggingLevel.WARN,'lstapprec'+lstappfrmrec);
        
         system.debug(LoggingLevel.WARN,'lstappcaserec'+lstappcaserec);
        List<DataTableWrapper> response = new List<DataTableWrapper>();
        for(Case rec : lstappcaserec){
            DataTableWrapper obj = new DataTableWrapper();
            obj.id = rec.Id;
            obj.name = '-';
            obj.nameUrl = '-';
            obj.caseNumber = rec.CaseNumber;
            obj.caseUrl = '/'+rec.Id;
            if(rec.Account.Name!=null){
                obj.accountName = rec.Account.Name;
                obj.accountNameUrl = '/'+rec.AccountId;
            }else{
                obj.accountName = '';
                obj.accountNameUrl = '';
            }
            obj.accountNumber = rec.USL_SAP_Account_Number__c;
            obj.ownerName = rec.Owner.Name;
            obj.ownerNameUrl = '/'+rec.OwnerId;
            obj.createdDate = Date.valueof(rec.createddate);
            obj.appLink = 'View';
            obj.appLinkUrl = '/lightning/r/ProcessInstanceWorkitem/'+appMap.get(rec.Id)+'/view';
            obj.totalAmount = '-';
            obj.formName = '-';
            obj.formUrl = '-';
            obj.type='Case';
            obj.totNetPrice = 'USD '+String.valueof(rec.ESC_Total_Net_Price1__c);
            obj.frmCreatedDate = NULL;
            obj.title = '-';
            obj.articlenumber = '-';
            obj.totCount = lstrecid.size();
            obj.segmentregion =rec.LCRM_Sub_BU__c + '-' + rec.BU_Segment__c;
      obj.articleClass ='-';

            response.add(obj);
        }

    
        for(ESC_Case_Form_Extension__c rec : lstappfrmrec){
            DataTableWrapper obj = new DataTableWrapper();
            obj.Id = rec.Id;
            obj.name = rec.Name;
            obj.nameUrl = '/'+rec.Id;
            obj.totalAmount = String.valueof(rec.USL_Total_Amount__c);
            obj.formName = rec.ESC_Form__r.Name;
            obj.formUrl = '/'+rec.ESC_Form__c;
            obj.caseNumber = rec.ESC_Case__r.CaseNumber;
            obj.caseUrl = '/'+rec.ESC_Case__c;
            obj.accountName = rec.ESC_Case__r.Account.Name;
            obj.accountNameUrl = '/'+rec.ESC_Case__r.AccountId;
            obj.accountNumber = rec.ESC_Case__r.USL_SAP_Account_Number__c;
            obj.ownerName = rec.ESC_Case__r.Owner.Name;
            obj.ownerNameUrl = '/'+rec.ESC_Case__r.OwnerId;
            obj.createdDate = Date.valueof(rec.ESC_Case__r.createddate);
            obj.appLink = 'View';
            obj.appLinkUrl = '/lightning/r/ProcessInstanceWorkitem/'+appMap.get(rec.Id)+'/view';
            obj.type='Form';
            obj.totNetPrice ='-';
            obj.frmCreatedDate = Date.valueof(rec.CreatedDate);
            obj.title = '-';
            obj.articlenumber = '-';
            obj.segmentregion =rec.ESC_Case__r.LCRM_Sub_BU__c + '-' + rec.ESC_Case__r.BU_Segment__c;
      obj.articleClass ='-';
      obj.totCount = lstrecid.size();
            response.add(obj);
        }
        for(knowledge__kav rec : lstartrec){
            DataTableWrapper obj = new DataTableWrapper();
            obj.id = rec.Id;
            obj.name = '-';
            obj.nameUrl = '-';
            obj.caseNumber = '-';
            obj.caseUrl = '-';
            obj.accountName = '-';
            obj.accountNameUrl = '-';
            obj.ownerName = '-';
            obj.ownerNameUrl = '-';
            obj.createdDate = NULL;
            obj.appLink = 'View';
            obj.appLinkUrl = '/lightning/r/ProcessInstanceWorkitem/'+appMap.get(rec.Id)+'/view';
            obj.totalAmount = '-';
            obj.formName = '-';
            obj.formUrl = '-';
            obj.type='Knowledge Article';
            obj.totNetPrice = '-';
            obj.frmCreatedDate = NULL;
            obj.title = rec.title;
            obj.articlenumber = rec.articlenumber;
            obj.articlenumberUrl = '/'+rec.Id;
            obj.totCount = lstrecid.size();
            obj.segmentregion ='-' ;
      obj.articleClass =rec.Article_Classification__c;
            response.add(obj);
        }
        if(lstappfrmrec.size()>0 || lstappcaserec.size()>0 || lstartrec.size()>0){
             system.debug(LoggingLevel.WARN,'response$$'+response);
            return response;
        }
        else{
            return null;
        }
        
    }
 /**
 * @description DatatableWrapper
 */   
     private class DataTableWrapper {
        @AuraEnabled
        public Id Id {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String nameUrl {get;set;}
        @AuraEnabled
        public String totalAmount {get;set;}
        @AuraEnabled
        public String formName {get;set;}
        @AuraEnabled
        public String formUrl {get;set;}
        @AuraEnabled
        public String caseNumber {get;set;}
        @AuraEnabled
        public String caseUrl {get;set;}
        @AuraEnabled
        public Date  createdDate {get;set;}
        @AuraEnabled
        public String accountName {get;set;}
        @AuraEnabled
        public String accountNameUrl {get;set;}
        @AuraEnabled
        public String accountNumber {get;set;}
        @AuraEnabled
        public String ownerName {get;set;}
        @AuraEnabled
        public String ownerNameUrl {get;set;}
         @AuraEnabled
        public String appLink {get;set;}
        @AuraEnabled
        public String appLinkUrl {get;set;}
        @AuraEnabled
        public String type{get;set;}
        @AuraEnabled
        public String totNetPrice{get;set;}
        @AuraEnabled
        public Date frmCreatedDate{get;set;}
        @AuraEnabled
        public integer totCount{get;set;}
        @AuraEnabled
        public String title {get;set;}
        @AuraEnabled
        public String articlenumber {get;set;}
        @AuraEnabled
        public String articlenumberUrl {get;set;}
        @AuraEnabled
        public string segmentregion {get;set;} 
    @AuraEnabled
    public String articleClass {get;set;}
        
    }
    /**
 * @description gettargetobjectlst
 * @ return String
 */
     public static String gettargetobjectlst(){
        List<ProcessInstance> lstpinst = new List<ProcessInstance>();
        List<ProcessInstanceWorkitem> lstpwitem = new List<ProcessInstanceWorkitem>();
        Set<String> setpInstance = new Set<String>();
        Set<String> setacct = new Set<String>();
        Map<Id,List<Id>> mapRecs = new Map<Id,List<Id>>();
        jsonMapRec = '';
        List<string> setOfOwners = new List<string>();
        for( GroupMember gm:[Select Group.ID from GroupMember where UserOrGroupId = :UserInfo.getUserId() and Group.Type = 'Queue']){
            setOfOwners.add(gm.Group.ID);
        }
        setOfOwners.add(userinfo.getUserId());
        
       if(Schema.sObjectType.ProcessInstanceWorkitem.Fields.ActorId.isAccessible()){
            lstpwitem =[SELECT Id,
                                ActorId,
                                OriginalActorId,
                                CreatedDate,
                                ProcessInstanceId,
                                CreatedById 
                                    FROM ProcessInstanceWorkitem 
                                        where ActorId in :setOfOwners];
        }
       if(lstpwitem.size()>0 || test.isRunningTest()){
            for(ProcessInstanceWorkitem item:lstpwitem){
                setpInstance.add(item.ProcessInstanceId);
            }
           
            if(setpInstance.size()>0){
                   if(Schema.sObjectType.ProcessInstance.isAccessible() ){ 
                   
                         lstpinst= [select id,
                                            targetobjectid,
                                            status,
                                            (SELECT Id FROM workitems)
                                             from ProcessInstance 
                                                where id IN :setpInstance];                    
                   }
               
                
                for(ProcessInstance pi:lstpinst){
                    if( String.valueof(pi.targetobjectid).left(3) == 'aCF' || String.valueof(pi.targetobjectid).left(3) == '500' || String.valueof(pi.targetobjectid).left(3) == 'kaG' ){
                        for(ProcessInstanceWorkitem pwitems:pi.workitems){
                            if(!mapRecs.containskey(pi.targetobjectid)){
                                mapRecs.put(pi.targetobjectid, new List<Id>{pwitems.id});
                            }else{
                                mapRecs.get(pi.targetobjectid).add(pwitems.id);
                            }
                        }
                        
                    }
                }
            }
            if(mapRecs.size()>0){
                jsonMapRec = JSON.serialize(mapRecs);
            }
        }
        
        return jsonMapRec;
        
    }
    
}