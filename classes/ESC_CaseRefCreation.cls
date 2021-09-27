public without sharing class ESC_CaseRefCreation{
    
    /*
This method will be invoked by SNOW Flow for Case Ref Creation
ESC_REF__c
*/
    
    @InvocableMethod(label='Create Ref on Case' description='Create Ref')
    public static void caseRefCreation(List<id> cs){
        
        
        if(cs == null)
            return;
        List<ESC_Case_Collaborator__c> reflst= new List<ESC_Case_Collaborator__c>();     
        Map<id,String> mapCase= new Map<id,String>();
       Map<id,List<ESC_Case_Collaborator__c>> mapCSIdList= new  Map<id,List<ESC_Case_Collaborator__c>>();
       ESC_SN_AssignmentGroup__c sngroup= ESC_SN_AssignmentGroup__c.getInstance(UserInfo.getUserId());
       
       for(Case objcs: [Select id,Subject,Description,BU_Segment__c from Case where id IN:cs]){
                mapCase.put(objcs.id,objcs.Description );       
               }
         
        if((Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isQueryable())){
        reflst = [Select id,Owner.Name,ESC_Case__c,ESC_Role__c,ESC_End_Date__c,ESC_Case__r.ESC_REF__c,ESC_Case__r.description,ESC_Case__r.CaseNumber  from ESC_Case_Collaborator__c where ESC_Case__c IN :cs and Owner.Name=:sngroup.ESC_Assignment_Group__c];
        }
        for(ESC_Case_Collaborator__c ref:reflst){
            List<ESC_Case_Collaborator__c> listCsCollaborator= new List<ESC_Case_Collaborator__c>();
            if(ref.ESC_Role__c == 'Accountable Resolver' && ref.Owner.Name== sngroup.ESC_Assignment_Group__c ){
                mapCase.put(ref.esc_case__c,ref.ESC_Case__r.description);
               if(mapCSIdList.containsKey(ref.ESC_Case__c)){
                    listCsCollaborator = mapCSIdList.get(ref.ESC_Case__c);
                }
                listCsCollaborator.add(ref);
                mapCSIdList.put(ref.ESC_Case__c,listCsCollaborator);
                
                }
            
        }  
          
        
        
        ESC_Case_Collaborator__c referralRecord;
        Id refRecordTypeId=Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Service Cloud Referral').getRecordTypeId();
        system.debug('sngroup.ESC_Assignment_Group__c****'+sngroup.ESC_Assignment_Group__c);
        Id queueid= [select Id from Group where Name =:sngroup.ESC_Assignment_Group__c  and Type = 'Queue'].Id;
        List<ESC_Case_Collaborator__c> listRef= new List<ESC_Case_Collaborator__c>();
        List<ESC_Case_Collaborator__c> listexisting= new List<ESC_Case_Collaborator__c>();
        
        
        
       for(Id csId: mapCase.keySet()){
            
            referralRecord= new ESC_Case_Collaborator__c();
            if(mapCSIdList.size()==0 || mapCSIdList.get(csId)==null){
                referralRecord.RecordTypeId = refRecordTypeId;
                referralRecord.ESC_Case__c=csId;
                referralRecord.ESC_Role__c='Accountable Resolver';
                referralRecord.ESC_Referral_Status__c='New';
                referralRecord.ESC_Case_Description__c=mapCase.get(csId);
                referralRecord.OwnerID=queueid;
                listRef.add(referralRecord);
            }
            else{
                for(ESC_Case_Collaborator__c ecc:  mapCSIdList.get(csId)){
                if(ecc.ESC_End_Date__c!= null){
                   ecc.ESC_End_Date__c = null;
                   ecc.ESC_Referral_Status__c = 'Accepted';
                }
                listexisting.add(ecc);
                }
            }
        }
        if(listRef.size()>0 && (Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable())){
            insert listRef;
        }
        
        
        if(!listexisting.IsEmpty() && (Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isUpdateable())){
            ESC_ReferalTriggerHelperClass.EndDatingOldReferral(listexisting);
            Update listexisting;
            listRef.addall(listexisting);
        }
       
        list<ESC_Case_Collaborator__c> insertrefList = new list<ESC_Case_Collaborator__c>();
        Set<id> refIdSet = new Set<Id>();
        
        
        List<ESC_ServiceNow_Staging__c> snStagingListtoInsrt= new  List<ESC_ServiceNow_Staging__c>();
       for(ESC_Case_Collaborator__c ecc:listRef){
          refIdSet.add(ecc.id);
       }
       
       List<ESC_ServiceNow_Staging__c> servicenowStaginglist =[Select id,ESC_Description__c,ESC_ID__c,ESC_Transmit_Status__c,ESC_Staging_Status__c from ESC_ServiceNow_Staging__c where ESC_ID__c IN:refIdSet];
       
      
         
         insertrefList=[Select Id,ESC_Case__c,ESC_CaseNumber__c,ESC_Case__r.Description,ESC_Case__r.ESC_SLA__c,ESC_Case__r.ESC_SLA_Justification__c,ESC_Case__r.BU_Segment__c,ESC_Case__r.LCRM_Sub_BU__c,ESC_Case__r.ESC_Severity__c,ESC_Case__r.ESC_External_Task_Reference_Number__c,ESC_Case__r.ESC_External_Ticket_Number__c from ESC_Case_Collaborator__c where Id in :refIdSet];
        
        if(servicenowStaginglist.size()== 0 && insertrefList.size()>0){
           snStagingListtoInsrt = StagingUpdater(insertrefList,'Create','');
        }
        else if(servicenowStaginglist.size()>0 && insertrefList.size()>0){
         snStagingListtoInsrt = StagingUpdater(insertrefList,'Update','');
        }
        if(snStagingListtoInsrt.size()>0 &&(Schema.sObjectType.ESC_ServiceNow_Staging__c.isAccessible() || Schema.sObjectType.ESC_ServiceNow_Staging__c.isCreateable())){
            system.debug('snStagingListtoInsrt***'+ snStagingListtoInsrt);
            insert snStagingListtoInsrt;
        }
    }
    
    
            
    public static List<ESC_ServiceNow_Staging__c> StagingUpdater(List<ESC_Case_Collaborator__c> RefList, String Action, String Type) {
        String IntegrationSetting = 'SNOW';
        List<ESC_ServiceNow_Staging__c> SNowUpdateList = new List<ESC_ServiceNow_Staging__c>();
        Map<Id,String> ProfileNameMap = new Map<Id,String>();
        Map<string,ESC_ServiceNow_Routing__c> SNRoutingMap = new Map<string,ESC_ServiceNow_Routing__c>();
        Map<Id,Id> Case_RefMap = new Map<Id,Id>();
        ESC_ServiceNow_Scheduler_Settings__c SNSettings = ESC_ServiceNow_Scheduler_Settings__c.getInstance('ServiceNowSettings');
        Integer NoOfRetries = Integer.valueOf(SNSettings.ESC_No_Of_Retries__c);
        
          for(ESC_ServiceNow_Routing__c SNR:[Select ESC_SOURCE__c,ESC_Sub_BU__c,ESC_ASSIGNMENT_GROUP__c,ESC_SegmentRegion__c from ESC_ServiceNow_Routing__c]){
            SNRoutingMap.put(SNR.ESC_SegmentRegion__c,SNR);
        }  
        
        List<User> u = [Select id,name,Rep_Employee_Number__c,FederationIdentifier from User Where id =: UserInfo.getUserId()];
        for(ESC_Case_Collaborator__c Ref:RefList){
            system.debug(ref);
            ESC_ServiceNow_Staging__c Staging = new ESC_ServiceNow_Staging__c();
            Staging.ESC_ID__c = Ref.id;
            Staging.ESC_Staging_Status__c ='Pending';
            String RegionSegment;
           if(LotusUser.getLotusUser() == true){
                RegionSegment =Ref.ESC_Case__r.BU_Segment__c + Ref.ESC_Case__r.LCRM_Sub_BU__c;
           }
           else{
                RegionSegment =Ref.ESC_Case__r.LCRM_Sub_BU__c;
           }
            system.debug('RegionSegment****'+RegionSegment);
            system.debug('SNRoutingMap****'+SNRoutingMap);
            if(SNRoutingMap.get(RegionSegment) !=null){
            Staging.ESC_BusinessArea__c = SNRoutingMap.get(RegionSegment).ESC_Sub_BU__c;
            Staging.ESC_Source__c = SNRoutingMap.get(RegionSegment).ESC_SOURCE__c;
            Staging.ESC_AssignmentGroup__c = SNRoutingMap.get(RegionSegment).ESC_ASSIGNMENT_GROUP__c;
           }
            Staging.ESC_Description__c =Ref.ESC_Case__r.Description;
            if(Action=='Create'){
            Staging.ESC_RequestType__c = Label.ESC_SN_ReqTypeCreate;/*****check******/
            }
            staging.ESC_Case_Status__c = 'Open';
            if(Action=='Update'){
            Staging.ESC_RequestType__c = 'Update';
            staging.ESC_External_Task_Reference_Number__c = Ref.ESC_Case__r.ESC_External_Task_Reference_Number__c;
            staging.ESC_SNOW_ID__c = Ref.ESC_Case__r.ESC_External_Ticket_Number__c;
            if(Type=='CloseComplete'){
            staging.ESC_Case_Status__c = 'CloseComplete';  
            }
            if(Type=='FeedComment'){
            staging.ESC_Feed_Comment__c = ''; 
            }
            }
            if(Ref.ESC_Case__r.ESC_Severity__c != null && Ref.ESC_Case__r.ESC_Severity__c != 'Null'){
            Staging.ESC_SLA__c= Ref.ESC_Case__r.ESC_Severity__c;
            }
            Else{
            Staging.ESC_SLA__c= 'N/A';
            }
            Staging.ESC_CaseNumber__c = Ref.ESC_CaseNumber__c;
            staging.ESC_Case_Id__c = Ref.ESC_Case__c; //(18 digits case id)
            staging.ESC_Employee_Number__c = u[0].FederationIdentifier;
            //staging.ESC_External_Task_Reference_Number__c = '';  
            Staging.ESC_SourceLink__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+Ref.ESC_Case__c; //for attachment           
            
            SNowUpdateList.add(staging);
            }
     
        return SNowUpdateList;   
    }   
}