/**********************************
Class Name: GLIGenericUtilityHelper
Purpose:Helper class to have all the generic methods of ESC UKI deployment
Author: Karthi G
Date Created:23/06/2017
Date Updated:Version0
***********************************/
public without sharing class GLIGenericUtilityHelper {
    public static boolean GLIServiceUserCheck(){
        boolean GLIServiceUser =false;
        List<UKI_Static_Values__mdt> UKISV =[SELECT MasterLabel,UKI_Value__c from UKI_Static_Values__mdt];
        Set<String> GLIProfileSet = new Set<String>();
        string profileID = UserInfo.getProfileID();
        String ProfileName = [SELECT Name from Profile Where Id =:profileID].Name;
        if(UKISV.size()>0){
            for(UKI_Static_Values__mdt val: UKISV){
                if(val.MasterLabel == 'Profiles'){
                    for(String temp:val.UKI_Value__c.split(';')){
                            GLIProfileSet.add(temp);
                        }
                }
             }
        }
        
        if(GLIProfileSet.contains(profileName)){
            GLIServiceUser =true;
        }
        return GLIServiceUser;
    }
    
    
    @InvocableMethod(label = 'ReopenCaseShareSurveyToOwner' description='GLI Survey')
    public static void ReopenCaseShareSurveyToOwner(List<Id> CaseidList){
         List<ESC_Survey__c> surveyList= new List<ESC_Survey__c>();
         surveyList= [Select id,ESC_Case__r.Ownerid,ESC_Case__r.Manager__r.Id,OwnerId from ESC_Survey__c where ESC_Case__c in:CaseidList];
         List<ID> UserIdList = new List<Id>();
         for(ESC_Survey__c sur:surveyList){
           if(string.valueOf(sur.OwnerId).startsWith('00G')){
               UserIdList.add(sur.ESC_Case__r.Ownerid);
               UserIdList.add(sur.ESC_Case__r.Manager__r.Id);
           }
           else{
              UserIdList.add(sur.ESC_Case__r.Ownerid);
           }
             GLIGenericUtilityHelper.ShareRecords(sur.Id,UserIdList);
          }
     }
     
     public static void ShareRecords(Id recID,List<ID> UserIdList1){
      List<ESC_Survey__Share> surveyShareList= new List<ESC_Survey__Share>();
      for(ID userid:UserIdList1){
      ESC_Survey__Share surveyshrObj= new ESC_Survey__Share();
      surveyshrObj.ParentId = recID;   
      surveyshrObj.UserOrGroupId = UserId;
      surveyshrObj.AccessLevel = 'Read';
      surveyShareList.add(surveyshrObj);
      }
      insert surveyShareList;
     }
     
     
    /**********************************
    Method called from MasterCaseTrigger to set the 'Send Survey' checkbox in GLI Service cases on Insert/update.
    Author: Karthi G
    ***********************************
    public static void UpdateSendSurvey(Map<Id,Case> NewMap,Map<Id,Case> OldMap){
        Boolean ExcludedDomain = false;
        List<Case> GLICases = new List<Case>();
        List<Case> CaseList = new List<Case>();
        List<Id> OwnerIdList = new List<Id>();
        Map<Id,User> ownerMap = new Map<Id,User>();
        Set<String> SurveyExcludedValues = new Set<String>();
        List<Id> ContactIdList = new List<Id>();
        Map<Id,Contact> ConMap = new Map<Id,Contact>();
        Set<String> DomainList = New Set<String>();
        String ExcludedRecordType = System.Label.GLI_Survey_Exclude_Recordtype;
        String ExcludedUserDivision = System.Label.GLI_Survey_Exclude_Division;
        String ExcludedCasestatus = System.Label.GLI_Survey_Exclude_Status;
        Set<String> RecordTypeSet = new Set<String>();
        Set<String> UserDivSet = new Set<String>();
        
        System.debug('Survey method start');
        System.debug('Survey method start New Map' +NewMap);
        System.debug('Survey method start OLD MAP ' +Oldmap);
        
        for(Case Ca: NewMap.values()){
            if(ca.Is_GLI__c && !ca.ESC_Survey_Sent__c && ca.Is_ESC_Case__c  && ExcludedCasestatus.contains(Ca.Status) && ca.status !=  Oldmap.get(ca.id).status){
                
                CaseList.add(ca);
                if(((String)(ca.ownerId)).startsWith('005')){
                OwnerIdList.add(ca.ownerId);
                }
                System.debug('CaseList' +CaseList);
            }
        }
        if(CaseList.size()>0){
            
            System.debug('ExcludedUserDivision' +ExcludedUserDivision);
            System.debug('ExcludedRecordType' +ExcludedRecordType);
            if(OwnerIdList.size()>0){
             for(User u:[Select id,Division from User where id in: OwnerIdList]){
                 Ownermap.put(u.id,u);
             }
            }
           // List<Case> CaseList= [Select id,ContactId,ownerid,ESC_Case_Type__c from Case where id in:CaseIdList];
            for(Case ca1: CaseList){
                if((Ownermap.size()>0 && OwnerMap.get(Ca1.OwnerId).Division !='' && OwnerMap.get(Ca1.OwnerId).Division !=null  && ExcludedUserDivision.contains(OwnerMap.get(Ca1.OwnerId).Division)) || ExcludedRecordType.contains(Ca1.ESC_Case_Type__c)){
               // else if(ExcludedRecordType.contains(Ca1.ESC_Case_Type__c)){
                    System.debug('Feedback/Cash Apps');
                    NewMap.get(ca1.Id).ESC_Send_Survey__c = false;
                }
               else {
               // if(!ExcludedRecordType.contains(Ca1.ESC_Case_Type__c)){
                    GLICases.add(ca1);
                    System.debug('GLICases' +GLICases);
                    if(ca1.contactId!=null){
                     ContactIdList.add(ca1.contactId);
                    }
                }
            }
                
        }
        
        if(GLICases.size()>0){
            List<UKI_Static_Values__mdt> UKISV =[SELECT MasterLabel,UKI_Value__c from UKI_Static_Values__mdt];
             if(UKISV.size()>0){
                for(UKI_Static_Values__mdt val: UKISV){
                    if(val.MasterLabel == 'SurveyExcludedValue'||val.MasterLabel == 'RFASurveyIncludedValue'){
                                SurveyExcludedValues.add(val.UKI_Value__c);
                        }
                    }
                 }
            
         if(ContactIdList.size()>0){
            List<Contact> ConList = [Select Id,AccountId,GLI_Unsubscribe_from_survey__c,Account.GLI_Survey_Exclusion_Start_Date__c,Account.GLI_Survey_Exclusion_End_Date__c,Email from Contact where id in : ContactIdList];
            
            for(Contact con:ConList){
                ConMap.put(Con.ID,con);
            }
            List<GLI_DomainSelectorList__c> Domainselectorlist = [Select Id,DomainName__c from GLI_DomainSelectorList__c];
            for(GLI_DomainSelectorList__c tempdomain : Domainselectorlist){
                if(tempdomain.DomainName__c!=null){
                    DomainList.add(tempdomain.DomainName__c);
                }
            }
        }
        for(Case c : GLICases){
            if(NewMap.get(c.Id).ContactId != null){
                String Checkemail =ConMap.get(NewMap.get(c.Id).ContactId).Email;
                        for(String dom : DomainList){
                            ExcludedDomain = Checkemail.contains(dom);
                                if(ExcludedDomain){
                                     System.debug('Excluded Domain true');
                                    break;
                                }
                        }
            if(ConMap.get(NewMap.get(c.Id).ContactId).GLI_Unsubscribe_from_survey__c || ExcludedDomain){
                 System.debug('GLI_Unsubscribe_from_survey__c true');
                 NewMap.get(c.Id).ESC_Send_Survey__c = false;
                 continue;
             }
            if(ConMap.get(NewMap.get(c.Id).ContactId).AccountId != null){
                if(ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_Start_Date__c != null && ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_End_Date__c != null ){
                     System.debug('ACC Change 2');
                     if(ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_Start_Date__c <= System.now() && ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_End_Date__c >= System.now() ){
                         NewMap.get(c.Id).ESC_Send_Survey__c = false;
                         continue;
                    }
                }
                else if(ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_Start_Date__c != null && ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_End_Date__c == null ){
                    if(ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_Start_Date__c <= System.now()){
                        NewMap.get(c.Id).ESC_Send_Survey__c = false;
                        continue;
                    }
                }
                else if(ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_Start_Date__c == null && ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_End_Date__c != null ){
                    if(ConMap.get(NewMap.get(c.Id).ContactId).Account.GLI_Survey_Exclusion_End_Date__c >= System.now()){
                        NewMap.get(c.Id).ESC_Send_Survey__c = false;
                        continue;
                    }
                }
            
            }
            }
            if(NewMap.get(c.Id).ESC_Proactive_Type__c != null){
                 System.debug('Proactive type enter');
                if(SurveyExcludedValues.contains(NewMap.get(c.Id).ESC_Proactive_Type__c)){
                     NewMap.get(c.Id).ESC_Send_Survey__c = false;
                     continue;
                }
            }
               
            if(NewMap.get(c.Id).ESC_Case_Type__c == 'Request for Action' || NewMap.get(c.Id).ESC_Case_Type__c == 'Request for Action (Read Only)'){
                 System.debug('Case type enter');
                if(NewMap.get(c.Id).ESC_EnquiryType__c !=null || NewMap.get(c.Id).ESC_EnquiryType__c !=''){
                if(!SurveyExcludedValues.contains(NewMap.get(c.Id).ESC_EnquiryType__c)){
                     NewMap.get(c.Id).ESC_Send_Survey__c = false;
                     continue;
                }
                 }
            }
            
         } 
         }
    }
    
    /********Update Case Owner to a User, Status automatic change to WIP***
    public static void onOwnerUpdate(Map<id,Case> oldMAp,Map<id,Case> newMap){
      for(id csid: newMap.keySet()){
        if((newMap.get(csid).Ownerid != oldMap.get(csid).Ownerid) && ((String)(oldMap.get(csid).Ownerid)).startsWith('00G') && ((String)(newMap.get(csid).Ownerid)).startsWith('005') && newMap.get(csid).Status == 'New'){
           newMap.get(csid).Status='Work In Progress';
           newMap.get(csid).GGO_First_Response_Time_Flag__c =True;
        }
        else if((newMap.get(csid).ESC_Diagnosis_Summary__c != oldMap.get(csid).ESC_Diagnosis_Summary__c) && newMap.get(csid).Is_GLI__c!=true){
         newMap.get(csid).ESC_Next_Response_Time_Flag__c =false;
      }
      }
    
    }*/
    
    /*************CreateCasefromcontactcontoller calls GLI Flag***********Mousumi Panda*/
    public static Case setGLI(Case oCase){
       User us= [select Id, username,Sub_Bu__c,Sales_Org__c from User where Id = :UserInfo.getUserId() limit 1];
       //Removing Hardcoding DSS-6256 changes
       ESC_segment_Region_Lotus__c srl = ESC_segment_Region_Lotus__c.getOrgDefaults();
       String region=srl.RegionUSLegal__c;
       
       if(us.Sales_Org__c == 'GLI' && us.Sub_Bu__c=='UKI'){
            oCase.Priority=Label.GLI_Default_Priority;
            oCase.GGO_First_Response_Time_Flag__c=True;
            oCase.Is_GLI__c=True;
            oCase.Sales_Org__c=us.Sales_Org__c;
            oCase.LCRM_Sub_BU__c=us.Sub_Bu__c;
       }
       else if(us.Sales_Org__c == 'GLI' && (us.Sub_Bu__c == 'USL'||us.Sub_Bu__c == region)){
     //else if(us.Sales_Org__c == 'GLI' && us.Sub_Bu__c == 'USL'){
           oCase.Is_GLI__c=True;
           oCase.Sales_Org__c=us.Sales_Org__c;
           oCase.LCRM_Sub_BU__c=us.Sub_Bu__c;
       }
       else if(us.Sales_Org__c == 'GLI' &&  us.Sub_bu__c == 'FindLaw'){
           oCase.Is_GLI__c=True;
           oCase.Sales_Org__c=us.Sales_Org__c;
           oCase.LCRM_Sub_BU__c=region;
         //oCase.LCRM_Sub_BU__c='USL';
       }
       return oCase;  
    }
    
    
    /******************************************************************* 
    Purpose: Update the asset status to Suspended when Suspend asset is set to true on case
    Parameters: case - newmap
                case - oldMap
                
    Returns: None
    ********************************************************************/
    /*public static void updateAssetStatusToSuspend(Map<id,case> newCaseMap,Map<id,case> oldCaseMap){
    
        Map<Id,case> caseAssetsToUpdateMap = new Map<id,case>();
        List<ESC_Case_Asset_Line_Item__c> caseAssetLst = new List<ESC_Case_Asset_Line_Item__c>();
        Map<Id,Apttus_Config2__AssetLineItem__c> apttusAssetMap = new Map<Id,Apttus_Config2__AssetLineItem__c>();
        Map<Id,Id> caseAssetMap = new Map<Id,Id>();
        Set<Id> apttusAssetUpdIds = new Set<Id>();
        //get the map of case where Suspend Asset field is set to true
        
        try{
        
            if(!newCaseMap.isEmpty() && !oldCaseMap.isEmpty()){
                for(Id caseId:newCaseMap.keyset()){
                    if(newCaseMap.get(caseId)!=null && oldCaseMap.get(caseId)!=null && newCaseMap.get(caseId).ESC_Suspend_Asset__c && newCaseMap.get(caseId).ESC_Suspend_Asset__c!=oldCaseMap.get(caseId).ESC_Suspend_Asset__c){
                        caseAssetsToUpdateMap.put(caseId,newCaseMap.get(caseId));
                    }
                }
        
            }
            
            if(!caseAssetsToUpdateMap.isEmpty()) {
               
               caseAssetLst =[SELECT id,ESC_Asset_Line_Item__c,ESC_Case__c,ESC_Asset_Status__c from ESC_Case_Asset_Line_Item__c WHERE  ESC_Case__c in:caseAssetsToUpdateMap.keyset()];
               
                if(caseAssetLst!=null && caseAssetLst.size() >0){
            
                    for(ESC_Case_Asset_Line_Item__c caseAssetId:caseAssetLst){
                    if(caseAssetId.ESC_Asset_Status__c  <> 'Suspended' && caseAssetId.ESC_Asset_Line_Item__c!=null)
                    {
                        apttusAssetMap.put(caseAssetId.ESC_Asset_Line_Item__c,new Apttus_Config2__AssetLineItem__c (Id = caseAssetId.ESC_Asset_Line_Item__c,Apttus_Config2__AssetStatus__c ='Suspended'));
                        caseAssetMap.put(caseAssetId.ESC_Asset_Line_Item__c,caseAssetId.ESC_Case__c);
                     }
                    }
                }
                
                if(!apttusAssetMap.isEmpty()){
                    Database.SaveResult[] srList = Database.update(apttusAssetMap.values(),false);
                    
                    for(Database.SaveResult sr:srList){
                        
                        if(sr.isSuccess()){
                            apttusAssetUpdIds.add(sr.getId());
                            
                        }else{
                            
                            for(Database.Error err: sr.getErrors()){
                                system.debug('The following error has occured.');
                                system.debug(err.getMessage());
                            }
                        
                        }
                    }
                }
                
                if(!caseAssetMap.isEmpty() && apttusAssetUpdIds!=null){
                    List<case> casesToUpdate = new List<case>();
                    for(Id csId:apttusAssetUpdIds){
                        if(caseAssetMap.get(csId)!=null){
                            Case c = new Case(Id = caseAssetMap.get(csId),ESC_Suspend_Asset__c = false);
                            casesToUpdate.add(c);
                        }
                        
                    }
                    
                    update casesToUpdate;
                }
                
               /* List<case> caseLst = [SELECT id,ESC_Suspend_Asset__c from case WHERE id in:caseIdsToUpdate];
                
                if(caseLst!=null && caseLst.size() >0){
                    for(Case csId:caseLst){
                        csId.ESC_Suspend_Asset__c =false;
                        casesToUpdate.add(csId);
                    }
                    
                }*/
          /*  } 
        }catch(Exception ex){
            system.debug('Inside catch: '+ ex.getmessage());
        } 
        
    }*/
	
	 public static void AssetSubscriptionLapseorReinstate(Map<Id,Case> newMap,Map<Id,Case> oldMap){
        
        Set<Id> caseSetIds = new Set<Id>();
       if(!newMap.isEmpty() && !oldMap.isEmpty()){
        
            for(Id caseID:newMap.keyset()){
                if(newMap.get(caseID)!=null && oldMap.get(caseID)!=null){
                    system.debug('newMap.get(caseID).ESC_Suspend_Asset__c : ' + newMap.get(caseID).ESC_Suspend_Asset__c);
                    if(newMap.get(caseID).ESC_Suspend_Asset__c != oldMap.get(caseID).ESC_Suspend_Asset__c && newMap.get(caseID).ESC_Suspend_Asset__c == true && newMap.get(caseID).ESC_Case_Type__c=='Request for Action' && newMap.get(caseID).ESC_Case_Sub_Type__c =='Orders, Pricing & Subscriptions' && ((newMap.get(caseID).ESC_EnquiryType__c =='Modify Subscription' && newMap.get(caseID).ESC_Sub_Type__c == 'Non-Revenue Modification') || newMap.get(caseID).ESC_EnquiryType__c == 'Cancellation' || newMap.get(caseID).ESC_EnquiryType__c == 'Unsuspend'|| newMap.get(caseID).ESC_EnquiryType__c == 'Suspend' )){
                         caseSetIds.add(caseID);
                         system.debug('@@ caseSetIds : ' + caseSetIds);
                    }
                }
            }
            
           if(caseSetIds!=null && caseSetIds.size() > 0 ){
                callForAssetSubscriptionChanges(caseSetIds);
            }
        }
        
       
    }

 @future(callout=true)
    public static void callForAssetSubscriptionChanges(Set<Id> CaseId){
    ESC_SubscriptionIntegration.createSubsctiptionRequest(CaseId);       
    }
    
	
	
}