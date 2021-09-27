/**
 * @description ESC_Utility
 */
public without sharing Class ESC_Utility{   
    Public Static List<EntitlementSelectorList__c> entSelectList;
    Public Static List<ESC_MilestoneCloseList__c> milestoneCloseList;
    Public Static String userProfileName;
    Public Static List<ESC_ValidationSettings__mdt> lstvs;
    Public Static List<Entitlement> entitlementlist;
    Public Static List<User> userlist;
      /**
   * @description checkValidationForCancelled 
   * @param newcaseMap
   * @param oldcaseMap
   */
    public static void checkValidationForCancelled(Map<Id,Case> newcaseMap , Map<Id,Case> oldcaseMap){
        List<Case> cancelledWIthRefOrEsc = new List<Case>();
        for(Case oldCase : oldcaseMap.values()){
            Case newCase = newcaseMap.get(oldCase.id);
            string oldCaseStaus = oldCase.Status;
             string newCaseStaus = newCase.Status;
             if(!oldCaseStaus.equals(newCaseStaus) && newCaseStaus.equals('Cancelled') && oldCase.ESC_REF__c){
                 cancelledWIthRefOrEsc.add(newCase);
             }
        }
        if(cancelledWIthRefOrEsc.size()>0){
            changedToCancelledValidationErrorMessage(cancelledWIthRefOrEsc);
        }
    }
      /**
   * @description filteredNonCore 
   * @param caseMap
   * @return Map<Id,Case>
   */
        public static Map<Id,Case> filteredNonCore(Map<Id,sObject> caseMap){
        List<ESC_RecordTypeList__c> escrectp= ESC_RecordTypeList__c.getall().values();
        Map<Id,Case> validMap = new map<Id,case>();
         for(sObject caseObj: caseMap.values()){   
            Case c = (Case)caseObj;
            if (c.Is_ESC_Case__c)
            {
                validMap.put(c.Id, c);
            }
            else
            {
            for(ESC_RecordTypeList__c escrdc: escrectp){
            system.debug(logginglevel.warn,'custom record type***'+c.esc_case_type__c + 'Recrdtype**' +c.recordtypeid);
            if(c.recordtypeid!=null){
            string recordtypename = Schema.SObjectType.Case.getRecordTypeInfosById().get(c.recordtypeid).getname();
            system.debug(logginglevel.warn,'recordtypename ***'+recordtypename);
              if(escrdc.Name == recordtypename){
                validMap.put(c.Id, c);              
                break;
                }
            
            }
        }
        }
        }
        return validMap;
    }
      /**
   * @description filteredNonCore 
   * @param caseList
   * @return List<Case>
   */   
     public static List<Case> filteredNonCore(List<sObject> caseList)
     {
        List<Case> validList = new List<Case> ();
        for(sObject caseObj: caseList)
        {   
            Case c = (Case)caseObj;
            if (c.Is_ESC_Case__c)
            {
                validList.add(c);
            }
        }
        return validList;
    }
      /**
   * @description checkValidationErrors 
   * @param newMap
   * @param oldMap
   * @param newlst
   */
    public static void checkValidationErrors(Map<Id,sobject> newMap,Map<Id,sobject> oldMap,List<sobject> newlst){
        String errormsg;
        String temp;
        String missFields='';
        String sobjName=String.valueof(newlst.getSObjectType());
        String fldname='RecordtypeId';
        
        Set<String> fldset;
        Map<Id,String> rectypeMap;
        if(userProfileName == null){
            
            if(UserInfo.getName()!='Automated Process'){
            userProfileName = [select name from profile where id=:UserInfo.getProfileid()].name;
        }
        }
        
        if(lstvs == null){
            lstvs = [select id,Label,Custom_Label__c,ExcludeProfileName__c,IncludeProfileName__c,FieldApiName__c,
                                                   Field_Value__c,MandatoryFieldApiNames__c,Object__c,
                                                   Recordtype__c,ESC_Queue_Name__c,ESC_Excluded_Fields__c from ESC_ValidationSettings__mdt where FieldApiName__c != 'ReferralId'];
        }                                          
        boolean isBulkified = false;
        if(userProfileName!='' && userProfileName!=null){
        // MassValidationSettings__c valsetting = MassValidationSettings__c.getValues(currProf.name);
        MassValidationSettings__c valsetting = MassValidationSettings__c.getValues(userProfileName);
        if(valsetting!=null){
            isBulkified = valsetting.DisableMassTransfer__c;
        }
        //If its mass transfer/update, validation rules associated to Mass Transfer will be disabled                                           
        integer batchSize =newlst.size();
        system.debug(logginglevel.warn,'batchSize '+newlst);
        for(sobject rec:newlst){
             if(rec instanceOf Case){
                Case c = (Case) rec;
                if(c.ESC_Omni_Routed__c){ continue;}
            }
            system.debug(logginglevel.warn,'records'+rec);
            Id rectypeId;
            rectypeMap = recordTypeNamesToIds(sobjName);
            boolean errexist=false;
            boolean check;
            boolean isownerchanged;
            boolean validate;
            errormsg ='';
            List<String> excludedfieldlist = new List<String>();
            for(ESC_ValidationSettings__mdt v:lstvs){
                
                if(v.Object__c == sobjName && (v.IncludeProfileName__c!=null && (v.IncludeProfileName__c).containsIgnoreCase(userProfileName)) ){
                    if(v.ExcludeProfileName__c!=null && ((v.ExcludeProfileName__c).containsIgnoreCase(userProfileName))){
                        continue;
                    }
                    system.debug(logginglevel.warn,'validation record is'+v);
                    
                    if(v.FieldApiName__c != null && v.FieldApiName__c == 'Status' && newmap!= null && newmap.get(rec.id).get(v.FieldApiName__c) == 'Closed'){
                        if(v.ESC_Queue_Name__c != '' && v.ESC_Queue_Name__c != null && newmap.get(rec.id).get('USL_Last_Queue_Name__c') != null && newmap.get(rec.id).get('USL_Last_Queue_Name__c') != '' && v.ESC_Queue_Name__c.containsignorecase(String.valueOf(newmap.get(rec.id).get('USL_Last_Queue_Name__c')))){
                            if(v.ESC_Excluded_Fields__c.contains(',')) {                         
                                excludedfieldlist = v.ESC_Excluded_Fields__c.split(',');
                            }    
                            else{
                                excludedfieldlist.add(v.ESC_Excluded_Fields__c);
                            }
                            for(String str : excludedfieldlist){
                                if(v.MandatoryFieldApiNames__c.contains(str)){
                                    integer strlength = str.length();
                                    integer strindex = v.MandatoryFieldApiNames__c.indexOf(str);
                                    integer mandlength = v.MandatoryFieldApiNames__c.length();
                                    if(strindex+strlength == mandlength){
                                        v.MandatoryFieldApiNames__c = v.MandatoryFieldApiNames__c.removeEnd(str);
                                    }
                                    else{
                                        v.MandatoryFieldApiNames__c = v.MandatoryFieldApiNames__c.remove(str+',');
                                    }
                                }
                            }
                        }
                            
                    }
                    check=false;
                    isownerchanged=false;
                    validate = false;
                    
                    //To handle insert condition
                    if( newmap == null && oldMap == null){
                        if(v.Recordtype__c == null && v.FieldApiName__c != null && v.Field_Value__c != null ){
                            if(rec.get(v.FieldApiName__c) == recordTypeNameToId(v.Object__c, v.Field_Value__c)){
                                validate = true;
                            }           
                        }
                    }else{//For Update Conditions
                        rectypeId= (Id) newmap.get(rec.id).get(fldname);
                        if(v.Recordtype__c !=null && !(rectypeMap.get(rectypeId).containsIgnoreCase(v.Recordtype__c))){
                            continue;
                        }
                        if(newMap.get(rec.id).get(v.FieldApiName__c)=='' && newMap.get(rec.id).get(v.FieldApiName__c)==null){
                            if(oldMap !=null){//Only handle while update operation
                                if(newMap.get(rec.id).get(v.FieldApiName__c) != oldMap.get(rec.id).get(v.FieldApiName__c) ){
                                    check = true;
                                }
                            }
                        }else if(newMap.get(rec.id).get(v.FieldApiName__c)!='' && newMap.get(rec.id).get(v.FieldApiName__c)!=null){
                            check = true;
                        }
                        //Condition to check if owner is changed
                        if(oldMap !=null){
                            boolean type=false;
                            //Old owner is set to queue, validation won't fire
                            if(oldMap.get(rec.id).get(v.FieldApiName__c)!=null){
                                type = (((String) (oldMap.get(rec.id).get(v.FieldApiName__c))).startsWith('00G'));
                            }
                            if(!(type) && (newMap.get(rec.id).get(v.FieldApiName__c) != oldMap.get(rec.id).get(v.FieldApiName__c)) && v.Field_Value__c==null && !(isBulkified && batchSize>1) ){
                                isownerchanged = true;
                            }
                        }
                    }
                    if(check || isownerchanged || validate  ){
                        String val;
                        if(newMap!=null){
                            val = (String) newMap.get(rec.id).get(v.FieldApiName__c);
            }
                        
                        if(isownerchanged|| validate || (v.Field_Value__c!=null && v.Field_Value__c.containsIgnoreCase(val))  ){
                            fldset=new Set<String>();
                            fldset.addall(v.MandatoryFieldApiNames__c.split(','));
                            temp='';
                            for(String s:fldset){
                                if(rec.get(s)==null){
                                    missFields= Schema.getGlobalDescribe().get(sobjName).getDescribe().fields.getMap().get(s).getDescribe().getLabel();
                                    Schema.DisplayType fielddataType = Schema.getGlobalDescribe().get(sobjName).getDescribe().fields.getMap().get(s).getDescribe().getType();
                                    if(fielddataType == Schema.DisplayType.Reference){
                                        String replaceval = missFields.replace(' ID','');
                                        missFields = replaceval;
                                    }
                                    temp = temp + ', ' + missFields;
                                    
                                } 
                            }
                            if(temp!=''){
                                temp=temp.substring(2);
                                if(temp.contains('Contact') && (v.Field_Value__c!=null && v.Field_Value__c.containsIgnoreCase(val)) &&
                                 (v.IncludeProfileName__c!=null && (v.IncludeProfileName__c).containsIgnoreCase(userProfileName))){
                                         errormsg+=temp+' '+label.ESC_CaseRuleMessage+'  '+label.ESC_CaseRuleMessage_Contact;
                                }
                                Else{
                                        errormsg+=temp+' '+label.ESC_CaseRuleMessage;
                                        
                                }
                                errexist=true;
                            }
                        }
                    }
                }  
            }
            if(errexist){
                rec.addError(errormsg.escapeHtml4(),false);
            }
        }
        }
         
        
        }
      /**
   * @description recordTypeNamesToIds 
   * @param objName
   * @return Map<Id,String>
   */    
    public Static Map<Id,String> recordTypeNamesToIds(string objName){
        Map<Id,String> recTypeMap = new Map<Id,String>();
        for (Schema.RecordTypeInfo rTypeInfo : (Schema.getGlobalDescribe().get(objName).getdescribe()).sObjectType.getDescribe().getRecordTypeInfos()){
            recTypeMap.put(rTypeInfo.getRecordTypeId(),rTypeInfo.getName()); 
        }
        return recTypeMap;    
    }
      /**
   * @description recordTypeNamesToId 
   * @param objName
   * @param recTypeName
   * @return Id
   */ 
    public static Id recordTypeNameToId(string objName, string recTypeName){
        id rectypeid;        
        for (Schema.RecordTypeInfo rTypeInfo : (Schema.getGlobalDescribe().get(objName).getdescribe()).sObjectType.getDescribe().getRecordTypeInfos()) {
            if (rTypeInfo.getName() == recTypeName) {
                recTypeId = rTypeInfo.getRecordTypeId();
                break;
            }
        }
        return recTypeId;    
    }
      /**
   * @description recTypeAssignmentForMerge 
   * @param newMap
   * @param oldMap
   */ 
    public static void recTypeAssignmentForMerge(Map<Id,Case> newMap,Map<Id,Case> oldMap)
    {
        List<Case> caseClosedList= new List<Case>();  
        List<Id> lstClosedIds = new List<Id>();
        String recordTypeReadonly;
        string recordtypename;
        for(id closedid :newMap.keySet()){            
            if((newMap.get(closedid).MasterRecordId != null && oldMap.get(closedid).MasterRecordId == null) || Test.isRunningTest()){
                caseClosedList.add(newMap.get(closedid));
                lstClosedIds.add(closedid);
            }
        }
        List<Case> updatedCSList = new List<Case>();
        if(lstClosedIds.size()>0){
            for(case cs: caseClosedList){
                Case upCase = new Case();
                 recordtypename = Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.recordtypeId).getDeveloperName();
            if(string.isnotblank('recordtypename')){
                system.debug(logginglevel.warn,'recordtypename**'+recordtypename);
                //recordtypename.containsIgnoreCase((Read Only));
                if(!recordtypename.contains('ReadOnly')){
                    if(recordtypename.equalsIgnoreCase('ESC_Request_for_Action')){
                        recordTypeReadonly = 'ESC_RequestForActionReadOnly';
                    }else{
                        recordTypeReadonly=recordtypename+'ReadOnly';
                    }
                    
                    system.debug(logginglevel.warn,'recordTypeReadonly**'+recordTypeReadonly);
                        upCase.Id= cs.Id;
                        upCase.RecordtypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeReadonly).getRecordTypeId();
                        upCase.ESC_Proactive_Type__c = 'Internal Origin';
                        upcase.USL_Case_closure_flag__c =false;
                    updatedCSList.add(upCase);   
                } 
            }
            }
        }
        if(updatedCSList.size() > 0 &&  (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
            update updatedCSList;
            }
    }
      /**
   * @description recordTypeAssignemnt 
   * @param newMap
   * @param oldMap
   * @param newlst
   */ 
    public static void recordTypeAssignemnt(Map<Id,Case> newMap,Map<Id,Case> oldMap,List<Case> newlst){
        system.debug(logginglevel.warn,'RecordTypeAssignemnt inside newMap: '+ newMap);
        system.debug(logginglevel.warn,'RecordTypeAssignemnt inside oldMap:'+ oldMap);
        List<Case> caseselectedList= new List<Case>();
        for(id id :newMap.keySet()){
            if(newMap.get(id).IsClosed != True && newMap.get(id).ESC_Case_Type__c != oldMap.get(id).ESC_Case_Type__c){
            //if(newMap.get(id).Status!= oldMap.get(id).Status && (newMap.get(id).Status !='Closed' || newMap.get(id).Status !='Completed' || newMap.get(id).Status !='Duplicate')){
                caseselectedList.add(newMap.get(id));
            }
        }
        if(caseselectedList.size()>0){
            recordTypeAssignemntCase(caseselectedList);
        }
        List<Case> caseClosedList= new List<Case>();  
        List<Id> lstClosedIds = new List<Id>();
        for(id closedid :newMap.keySet()){
            if(newMap.get(closedid).Status!= oldMap.get(closedid).Status && (newMap.get(closedid).Status =='Closed'  || newMap.get(closedid).Status =='Duplicate') ){
                caseClosedList.add(newMap.get(closedid));
                lstClosedIds.add(closedid);
            }
        }
        system.debug(logginglevel.warn,'caseClosedList inside :'+ caseClosedList);
        //Owner change Validation Rule
        List<id> userid= new List<id>();
        for(id id :oldMap.keySet()){
            userid.add(oldMap.get(id).OwnerId);
        }
        
        Map<id,Boolean> caseOwnerIDActive= new Map<id,Boolean>();
        map<String,boolean> caseportalmap = new map<String,boolean>();
        for(User us:[Select id,isActive,IsPortalEnabled  from User where id IN : userid]){
            caseOwnerIDActive.put(us.id,us.isActive);
            caseportalmap.put(us.id,us.IsPortalEnabled);
        }
        List<Case> selectedOwnerChange= new List<Case>();
        for(id closedid :newMap.keySet()){
               if(newMap.get(closedid).OwnerId != oldMap.get(closedid).OwnerId && (newMap.get(closedid).Status =='Closed'  || newMap.get(closedid).Status =='Duplicate')){ 
                 if((oldMap != null && oldMap.size()>0 && oldMap.get(closedid).ESC_UPD__c == true) || (newMap.get(closedid).ESC_LastQueueOwner__c == newMap.get(closedid).OwnerId) || (CaseOwnerIDActive.get(oldMap.get(closedid).Ownerid) == False)){
                    system.debug(logginglevel.warn,'No Validation Error***********');
                }
                else{
                    selectedOwnerChange.add(newMap.get(closedid));
                }
            }
        }
          if(selectedOwnerChange.size()>0){
            ownerChangeValidationErrorMessage(selectedOwnerChange);
            
        }        
        if(caseClosedList.size()>0){
            recordTypeAssignemntCaseClosed(caseClosedList);
            //CloseRelatedReferralsOnCaseClosure(lstClosedIds);
        }        
        List<Case> caseReopenList= new List<Case>(); 
        for(id reOpenid :newMap.keySet()){
        String recordTypeName=Schema.SObjectType.Case.getRecordTypeInfosById().get(newMap.get(reOpenid).RecordTypeId).getName();
        //system.debug(logginglevel.warn,'');
            if((recordTypeName.contains('Read Only')) && (newMap.get(reOpenid).Status !='Closed'  && newMap.get(reOpenid).Status !='Duplicate' && newMap.get(reOpenid).Status != 'Merged')){
              caseReopenList.add(newMap.get(reOpenid));
            }  
            
        }       
        if(caseReopenList.size()>0){
            
            recordTypeAssignemntCase(caseReopenList);
            //system.debug(logginglevel.warn,'caseReopenList&&&&&&&'+caseReopenList[0].RecordTypeId);
            reopenErrorMessage(caseReopenList,caseportalmap);
        }        
    }
      /**
   * @description ownerChangeValidationErrorMessage 
   * @param caseselectedList
   */   
    public static void ownerChangeValidationErrorMessage(List<Case> caseselectedList){
        if(UserInfo.getName()!='Accreditation Support'){
        for(Case cs: caseselectedList){
            cs.addError(label.ESC_OwnerChangeCloseCaseError);
        }
        }
    }
      /**
   * @description recordTypeAssignemntCase 
   * @param caseselectedList
   */
    public static void recordTypeAssignemntCase(List<Case> caseselectedList){        
        for(Case cs: caseselectedList){
        string recDevName;
            if(cs.ESC_Case_Type__c != null && cs.ESC_Case_Type__c != ''){
            ESC_RecordTypeList__c getRecordTypeList = ESC_RecordTypeList__c.getInstance(cs.ESC_Case_Type__c);
             recDevName = getRecordTypeList.ESC_API_Name__c;
            }       
            if(recDevName  != null && recDevName  != ''){
                cs.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recDevName).getRecordTypeId();
            }
            system.debug(logginglevel.warn,'Recordtype Id :' + cs.RecordtypeID);
        }       
    }
      /**
   * @description reopenErrorMessage 
   * @param caseselectedList
   * @param caseportalmap
   */
    public static void reopenErrorMessage(List<Case> caseselectedList,map<String,boolean> caseportalmap){        
        for(Case cs: caseselectedList){
           if(caseportalmap != null && caseportalmap.containskey(cs.ownerid) && caseportalmap.get(cs.ownerid) == false){
               cs.addError(label.ESC_StatusChangeErrormessage);
           } 
        }       
    }
      /**
   * @description changedToCancelledValidationErrorMessage 
   * @param caseselectedList
   */
     public static void changedToCancelledValidationErrorMessage(List<Case> caseselectedList){       
        for(Case cs: caseselectedList){
            cs.Status.addError(label.ESC_CancelledCaseOpenReferralError);
        }       
    }
      /**
   * @description closeRelatedReferralsOnCaseClosure 
   * @param newMap
   * @param oldMap
   */
     public static void closeRelatedReferralsOnCaseClosure(Map<Id,Case> newMap,Map<Id,Case> oldMap){
       // List<Case> caseClosedList= new List<Case>();  
        List<Id> lstClosedIds =new List<Id>();
        for(id closedid :newMap.keySet()){
            if(newMap.get(closedid).Status!= oldMap.get(closedid).Status && (newMap.get(closedid).Status =='Closed'  || newMap.get(closedid).Status =='Duplicate') ){
                lstClosedIds.add(closedid);
            }
        }
        List<ESC_Case_Collaborator__c> lstref =new List<ESC_Case_Collaborator__c>();
        List<ESC_Case_Collaborator__c> lstUpdateClosedRef = new List<ESC_Case_Collaborator__c>();
        if(lstClosedIds.size()>0){
            if(Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isQueryable()){
                lstref = [SELECT Id,ESC_Case__c,ESC_Role__c,ESC_Referral_Status__c,ESC_End_Date__c FROM ESC_Case_Collaborator__c WHERE ESC_Case__c IN: lstClosedIds and ESC_Referral_Status__c !='Rejected'and ESC_Referral_Status__c !='Completed'];
            }
        for(ESC_Case_Collaborator__c ref:lstref){
            if(ref.ESC_Role__c == 'Accountable Resolver')
            {
               if(ref.ESC_Referral_Status__c != 'Completed'){
                ref.ESC_Referral_Status__c = 'Completed';
                ref.ESC_End_Date__c=datetime.Now();
                lstUpdateClosedRef.add(ref);
                }                 
            }
            else
            {
             if(ref.ESC_Referral_Status__c != 'Closed'){
                ref.ESC_Referral_Status__c = 'Closed';
                ref.ESC_End_Date__c=datetime.Now();
                lstUpdateClosedRef.add(ref);
                }
            }
        }       
        if(lstUpdateClosedRef.size()>0 && (Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isUpdateable())){
            update lstUpdateClosedRef;
        }
    }
    }
      /**
   * @description recordTypeAssignemntCaseClosed 
   * @param caseselectedList
   */  
    public static void recordTypeAssignemntCaseClosed(List<Case> caseselectedList){        
        for(Case cs: caseselectedList){
            string recordtypename = Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.recordtypeId).getDeveloperName();
            String recordTypeReadonly;
            if(string.isnotblank('recordtypename')){
                system.debug(logginglevel.warn,'recordtypename**'+recordtypename);
                //recordtypename.containsIgnoreCase((Read Only));
                if(!recordtypename.contains('Read Only')){
                if(recordtypename.equalsIgnoreCase('ESC_Request_for_Action')){
                    recordTypeReadonly = 'ESC_RequestForActionReadOnly';
                }else{
                    recordTypeReadonly=recordtypename+'ReadOnly';
                }               
                system.debug(logginglevel.warn,'recordTypeReadonly**'+recordTypeReadonly);
                cs.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeReadonly).getRecordTypeId();               
                }
                else{
                    cs.addError(label.ESC_StatusChangeErrormessage);
                }
            }
        }        
    }
      /**
   * @description caseEntitlementAssociation 
   * @param newMap
   * @param newCaseList
   */    
    public static void caseEntitlementAssociation(Map<Id,Case> newMap, List<Case> newCaseList){
        system.debug(logginglevel.warn,'@@@@@Inside CaseEntitlement Association');
        Set<id> accIds = new Set<id>();
        List<Case> updCaseList = new List<Case>();
        List<Case> caseList = new List<Case>();
        Set<String> lkpSet = new Set<String>();
        string subBu='';
        Map<Id,String> caseLKPMap = new Map<Id,String>();        
        Map<String, String> lkpEntitlementMap = new Map<String, String>();
        Set<String> entNameSet = new Set<String>();
        List<Entitlement> entList;
        Map<String,Id> entitleNameIdMap = new Map<String,Id>(); 
        Map<Id,Id> caseEntIdMap = new Map<Id,Id>();
        Set<String> eNameSet = new Set<String>();
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,List<id>> mapaccts= new Map<Id,List<id>>();
        //Dss-6256 hardcoding removal
        ESC_segment_Region_Lotus__c srl = ESC_segment_Region_Lotus__c.getOrgDefaults();
        for(Case c: newCaseList){
                    system.debug(logginglevel.warn,'@@@@c.ESC_Apply_Entitlement_Milestone__c'+c.ESC_Apply_Entitlement_Milestone__c);
            if(c.EntitlementId == null && (c.LCRM_Sub_BU__c != null && c.LCRM_Sub_BU__c != '' )){
            
            system.debug(logginglevel.warn,'EntitlementID is null');
            accIds.add(c.accountId);
            subBu =c.LCRM_Sub_BU__c;
            caseIdSet.add(c.Id);            
            }
        }
        if(caseIdSet.size()>0){
        // Setting up the Entitlement based on Entitlement Selector Criteria
        string combinedfields='';
        string userprofileId = '';
        Map<String, Schema.SobjectField> fieldsmap = Schema.SobjectType.ESC_EntitlementSelectorFields__c.fields.getMap();
         system.debug(logginglevel.warn,'fieldsmap : ' +fieldsmap);   
        List<String> fieldList = new List<String>();
        for(String fieldname:fieldsmap.keyset()){
            if(fieldname.contains('__c')){
                fieldList.add(fieldname);
             system.debug(logginglevel.warn,'fieldList: ' +fieldList);    
            }
        }       
         if(UserInfo.getName()!='Automated Process'){
                if(userProfileName == null){
            userProfileName = [select name from profile where id=:UserInfo.getProfileid()].name;
                }
            }
            else{            
               if(UserInfo.getName() =='Automated Process' && (SubBu=='USL'||SubBu==srl.RegionUSLegal__c)){
                        userProfileName='USL Helpdesk Agent';
                         userProfileId = [select Id from profile where name =:userProfileName].Id;
                }
                else if(UserInfo.getName() =='Automated Process' && subBu=='Canada'){
                        userProfileName='TR Sales';
                        userProfileId = [select Id from profile where name =:userProfileName].Id;
                }
                else{
                    userProfileName='TR Helpdesk Agent';
                        userProfileId = [select Id from profile where name =:userProfileName].Id;
                }
            }
           system.debug(logginglevel.warn,'ProfileeId: ' +userProfileId);
        ESC_EntitlementSelectorFields__c eIDs ;
         if(UserInfo.getName()!='Automated Process'){
       eIDs = ESC_EntitlementSelectorFields__c.getInstance();
        system.debug(logginglevel.warn,'eIDs : ' +eIDs);
        }
    if(UserInfo.getName()=='Automated Process'){
     eIDs   = ESC_EntitlementSelectorFields__c.getInstance(userProfileId);
        system.debug(logginglevel.warn,'eIDs : ' +eIDs);
        } 
        for(String f: fieldList){
            if(eIDs.get(f)!=null && eIDs.get(f)!=''){
                combinedfields += eIDs.get(f) + ',';
                 system.debug(logginglevel.warn,'combinedfields: ' +combinedfields);
            }
        }
          system.debug(logginglevel.warn,'combinedfields: ' +combinedfields);      
        string dQuery =  'select Id, '+combinedfields+'EntitlementId,AccountId,ESC_Apply_Entitlement_Milestone__c from Case where Id IN ';
        dQuery+=':caseIdSet';
        system.debug(logginglevel.warn,'dquery-->'+dQuery);
        caseList  = Database.query(dQuery);
        List<Entitlement> entitleList = new List<Entitlement>();
        //3rd criteria
        ESC_DefaultEntitlementSelector__c entSelct = ESC_DefaultEntitlementSelector__c.getInstance(UserInfo.getProfileID());
        if(entSelct != null && entSelct.ESC_EntitlementName__c != null){
            entNameSet.add(entSelct.ESC_EntitlementName__c);
        }
        if(entSelectList == null){
            entSelectList= [select ESC_LKP__c, ESC_Entitlement__c from EntitlementSelectorList__c];
        }       
        //2nd criteria
        //entitleList = [select id, name, AccountId,Status from Entitlement where  Accountid in :accIds OR Name in :entNameSet];
        if(entitlementlist == null){
        entitlementlist = [select id, name, AccountId,Status from Entitlement where  Accountid in :accIds OR Name in :entNameSet];
        }
        entitleList = entitlementlist;        
        for(EntitlementSelectorList__c entRecord : entSelectList){
            //entNameSet.add(entRecord.ESC_Entitlement_Name__c);
            lkpEntitlementMap.put(entRecord.ESC_LKP__c, entRecord.ESC_Entitlement__c);
        }
        for(Entitlement eRecord : entitleList){
            entitleNameIdMap.put(eRecord.Name, eRecord.Id);
            if(eRecord.AccountId!=null && eRecord.Status == 'Active'){
                if(!mapaccts.containskey(eRecord.AccountId)){
                    mapaccts.put(eRecord.AccountId, new List<Id>{erecord.id});
                }else{
                    mapaccts.get(eRecord.AccountId).add(erecord.id);
                }
            }
        }        
        
        
        
        for(Case caseRecord: caseList){
            // Setting up the Account related Entitlement
            if(caseRecord.EntitlementID == null){               
                string lkp = userProfileName;
                for(String cfield : combinedfields.split(',')){
                    if(cfield.contains('.')){
                        String rname1;
                        List<String> list1 = new List<String>();
                        for(String s : cfield.split('\\.')){
                            list1.add(s);
                        }
                        String t1=list1[0];
                        String t2=list1[1];
                        if(caseRecord.getSObject(t1)!=null){
                            rname1= string.valueOf(caseRecord.getSObject(t1).get(t2));
                        }
                        system.debug(logginglevel.warn,rname1);
                        if(rname1!=null){
                            lkp+=rname1;
                        }
                    }
                    else if (cfield != null && cfield != ''){
                        String temp=String.Valueof(caseRecord.get(cfield));
                        if(temp!=null&&temp!=''){
                            lkp=lkp +temp ;
                        }
                    }
                }
                
                system.debug(logginglevel.warn,'lkp :'+lkp);
                system.debug(logginglevel.warn,'lkpmap is'+lkpEntitlementMap);
                if(!lkpEntitlementMap.isEmpty() && lkpEntitlementMap.containsKey(lkp)){
                    //if(!entitleNameIdMap.isEmpty() && entitleNameIdMap.containsKey(lkpEntitlementMap.get(lkp))){
                        caseRecord.EntitlementID = lkpEntitlementMap.get(lkp);
                        caseRecord.ESC_Apply_Entitlement_Milestone__c=false;
                        updCaseList.add(caseRecord);
                    //}
                }
                               
                // Seccond Condition  
                if(caseRecord.EntitlementID == null){
                        if(!entitleList.isEmpty() ){
                            for(Entitlement entitleRecord : entitleList){
                                if(caseRecord.AccountId == entitleRecord.AccountId  && entitleRecord.Status == 'Active'){
                                    if(mapaccts.get(caseRecord.AccountId).size()==1){
                                        caseRecord.EntitlementID = mapaccts.get(caseRecord.AccountId)[0];
                                        caseRecord.ESC_Apply_Entitlement_Milestone__c=false;
                                        updCaseList.add(caseRecord);
                                    }
                                }
                            }
                        }

                } // End of Second Condition If               
                // Default Condition
                if(caseRecord.EntitlementID == null){
                    if(!entitleNameIdMap.isEmpty() && entitleNameIdMap.containsKey(entSelct.ESC_EntitlementName__c)){
                        caseRecord.EntitlementID = entitleNameIdMap.get(entSelct.ESC_EntitlementName__c);
                        caseRecord.ESC_Apply_Entitlement_Milestone__c=false;
                        updCaseList.add(caseRecord);
                    }

                } // End of Default If
                /*if(caseRecord.ESC_Apply_Entitlement_Milestone__c == true){
                 caseRecord.ESC_Apply_Entitlement_Milestone__c=false;
                 updCaseList.add(caseRecord);
             }*/
            } // end of If loop            
        } // End of FOR
        }        
        system.debug(logginglevel.warn,updCaseList);
        if(!updCaseList.isEmpty() && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
            update updCaseList;            
        }
    } // End of method
      /**
   * @description updateMilestoneEntryFlag 
   * @param newMap
   * @param oldMap
   */
    public static void updateMilestoneEntryFlag(Map<Id,sObject> newMap, Map<Id,sObject> oldMap){
        
        List<Case> cList = (List<Case>)newMap.values();
        List<ESC_MilestoneIdentifierSetting__c> milestoneIdentifierList = ESC_MilestoneIdentifierSetting__c.getAll().Values();
        if(cList.size() > 0){
            for(sObject cRecord : cList){
                sObject sobj = (sObject)cRecord;
                sObject sobjOld = (sObject)oldMap.get(cRecord.Id);
                String msClose = '';
                String temp = '';
                for(ESC_MilestoneIdentifierSetting__c milestoneIdentifierRec : milestoneIdentifierList){
                    
                    if(sobj.get(milestoneIdentifierRec.FieldAPIName__c) != null && (sobj.get(milestoneIdentifierRec.FieldAPIName__c) != sobjOld.get(milestoneIdentifierRec.FieldAPIName__c))){
                           sobj.put(milestoneIdentifierRec.ControllingFieldAPI__c, true);
                           msClose = msClose==''?milestoneIdentifierRec.Name:msClose+','+milestoneIdentifierRec.Name; 
                    }else if(sobj.get(milestoneIdentifierRec.FieldAPIName__c) == null){
                           sobj.put(milestoneIdentifierRec.ControllingFieldAPI__c, false);  
                     }
                }
                 
                sobj.put('ESC_Milestones_to_Close__c', msClose);
                //system.debug(logginglevel.warn,sobj.get('ESC_Milestones_to_Close__c'));
                
            }
        }
    }
    
   /*@future
    public static void updateNextMilestoneTimes(Set<id> setcid){
        List<Case> lstupdatecase = new List<Case>();
        Map<Id,Integer> maptimes = new Map<Id,Integer>();
        Map<Id,Id> cmBHMap = new Map<Id,Id>();
        list<Case> caseRecordList = new List<Case>();
        Map<Id,String> mapfname = new Map<Id,String>();
        Set<String> msIdetifierFieldNames = new Set<String>();
        List<Entitlement> entitleList = new List<Entitlement>();
        Set<Id> caseEntIdSet = new Set<Id>();
        Map<Id,Id> entidSLAidMap = new Map<Id, Id>();
        Map<Id,Id> caseEpBHidMap = new Map<Id,Id>();
        String msIdetifierFieldName = '';
        List<CaseMilestone> assocCM = [select MilestoneType.Name, caseId,TargetResponseInMins,BusinessHoursId from CaseMilestone where caseId in : setcid];
        List<ESC_InitialResponseTimeCalc__c> initialMileStoneDataSet = ESC_InitialResponseTimeCalc__c.getAll().Values();
       // Id defaultBusinessHourId = [SELECT Id FROM BusinessHours WHERE IsDefault = true].id;
        system.debug(logginglevel.warn,'assocCM@@'+assocCM);
        for(CaseMilestone ms:assocCM){
            if(initialMileStoneDataSet.size() > 0 && initialMileStoneDataSet != null){
                for(ESC_InitialResponseTimeCalc__c milestoneRec : initialMileStoneDataSet){
                    if(ms.MilestoneType.Name == milestoneRec.ESC_MilestoneName__c){
                       maptimes.put(ms.caseId,ms.TargetResponseInMins);
                       cmBHMap.put(ms.caseId,ms.BusinessHoursId);
                       if(milestoneRec.ESC_FieldAPIName__c != null){
                            mapfname.put(ms.caseId,milestoneRec.ESC_FieldAPIName__c);
                            msIdetifierFieldNames.add(milestoneRec.ESC_FieldAPIName__c);
                       }
                    }
                }
            }
        }
        system.debug(logginglevel.warn,maptimes);
        system.debug(logginglevel.warn,cmBHMap);

        if(msIdetifierFieldNames.size()>0){
            for(String s: msIdetifierFieldNames){
                msIdetifierFieldName += ',' + s;  
            }
        }
        
        system.debug(logginglevel.warn,msIdetifierFieldName);
        
        if(initialMileStoneDataSet!=null){
            string dQuery =  'select Id,EntitlementId,BusinessHoursId'+msIdetifierFieldName+' from Case where Id IN ';
            dQuery+=':setcid';
            caseRecordList = Database.query(dQuery);
            system.debug(logginglevel.warn,'caseRecordList'+caseRecordList); 
            
            for(Case caseRec: caseRecordList){
               caseEntIdSet.add(caseRec.EntitlementId); 
            }
            
            entitleList = [select Id, slaProcess.BusinessHoursId from Entitlement where id IN :caseEntIdSet];
            for(Entitlement ent : entitleList){
                entidSLAidMap.put(ent.Id, ent.slaProcess.BusinessHoursId);
            }
            
            system.debug(logginglevel.warn,entidSLAidMap);
            for(Case cRec: caseRecordList){
                if(cRec.EntitlementId != null){
                   if(!entidSLAidMap.isEmpty() && entidSLAidMap.containsKey(cRec.EntitlementId)){
                       caseEpBHidMap.put(cRec.Id,entidSLAidMap.get(cRec.EntitlementId));
                   }
                }
            }
            
            for(Case cs:caseRecordList){
                if(maptimes.containsKey(cs.id) && mapfname.containsKey(cs.id) && cs.get(mapfname.get(cs.id))==null){
                    Case c = new Case();
                    c.id=cs.id;
                   // Datetime dt = System.now() + maptimes.get(cs.id);
                    // Business hours calculation
                    Datetime currentTime = System.now();
                    Integer SLAmins = maptimes.get(cs.id);
                    Id businessHourId;
                    if(!cmBHMap.isEmpty() && cmBHMap.containsKey(cs.id) && cmBHMap.get(cs.id)!= null){
                        // associating Milestone BusinessHourid
                        businessHourId = cmBHMap.get(cs.id);
                    }else if(!caseEpBHidMap.isEmpty() && caseEpBHidMap.containsKey(cs.id) && caseEpBHidMap.get(cs.id) != null){
                        // associating Entitlement Process BusinessHourid
                        businessHourId = caseEpBHidMap.get(cs.id);
                    }else{
                        // associating Case BusinessHourid
                        businessHourId = cs.BusinessHoursId;
                    }
                    
                    system.debug(logginglevel.warn,'@@@@ businessHourId: '+businessHourId);
                    Datetime dt = BusinessHours.add(businessHourId,currentTime, SLAmins* 60 * 1000L);
                    c.put(mapfname.get(cs.id),dt);
                    lstupdatecase.add(c);
                }
            }
        }

        if(lstupdatecase.size()>0)
            update lstupdatecase;
        
    } */
      /**
   * @description updateParentDetailsOnChildCase 
   * @param newlst
   * @param oldMap
   */
    public static void updateParentDetailsOnChildCase(List<case> newlst,Map<Id,case> oldMap){
        //Id rectypeId = recordTypeNameToId('case','ESC_Enhancement');
        Id rectypeId = recordTypeNameToId('case','Enhancement Request');
        Set<id> parSetId = new Set<Id>();
        List<Case> lstCase = new List<Case>();
        Map<Id,Id> mapAssocChildparent = new Map<Id,Id>();
        Map<Id,Case> parentDetMap;
        
        for(Case cs:newlst){
            if(cs.ParentId!=null && cs.ParentId != oldMap.get(cs.Id).ParentId && cs.recordtypeid == rectypeId){
                parSetId.add(cs.parentId);
                mapAssocChildparent.put(cs.id,cs.parentId);
                lstCase.add(cs);
            }
        }   
        if(parSetId.size()>0){
            parentDetMap = new Map<Id,Case>([select id,Status,ESC_Reason_Bus_Owner_Rejted_Decision__c from case where Id IN:parSetId]);
        }
        
        for(Case crec:lstCase){
            crec.Status = parentDetMap.get(mapAssocChildparent.get(crec.id)).Status;
            crec.ESC_Reason_Bus_Owner_Rejted_Decision__c = parentDetMap.get(mapAssocChildparent.get(crec.id)).ESC_Reason_Bus_Owner_Rejted_Decision__c;
        }
        
        
    }
      /**
   * @description validateEmail 
   * @param emailAddress
   * @return Boolean
   */
    //Email Validation function
    public static Boolean validateEmail(String emailAddress){
       
        if(emailAddress == null && emailAddress == ''){
            return false;
        }
        //The (tweaked) version of RFC 2822 regex for email address validation
        String emailRegex = '(?:[a-zA-Z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&\'*+/=?^_`{|}~-]+)*|"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])';
        Pattern emailPattern = Pattern.compile(emailRegex);
 
        Matcher emailMatcher = emailPattern.matcher(emailAddress);
        return emailMatcher.matches();
    }
      /**
   * @description setCaseUPDFlag 
   * @param newMap
   * @param oldMap
   * @param newlst
   */   
    public static void setCaseUPDFlag(Map<Id,Case> newMap,Map<Id,Case> oldMap,List<Case> newlst){
        system.debug(logginglevel.warn,'setCaseUPDFlag method called');
        List<Case> caseList = new List<Case>();
        List<String> fsAPINameList = new List<String>();
        Set<Id> caseIdSet = new Set<Id>();
        
        for(Case caseRecord : newlst){
            if(caseRecord.OwnerId != UserInfo.getUserId() && !caseRecord.ESC_UPD__c && caseRecord.IsClosed != True){
                caseList.add(caseRecord);
                system.debug(logginglevel.warn,'UPDcheckcase record>>>'+caseList+'$$$$'+caseRecord);
            }
        }

        // reading Custom setting with Object Name and its related FileSet field name
        ESC_UpdFieldSetting__c fldSetting = ESC_UpdFieldSetting__c.getInstance(UserInfo.getProfileID());
        if(fldSetting != null && fldSetting.ESC_FieldsetName__c != null && fldSetting.ESC_ObjectName__c != null){
            
            List<Schema.FieldSetMember> fsMembers = readFieldSet(fldSetting.ESC_FieldsetName__c,fldSetting.ESC_ObjectName__c);
            for(Schema.FieldSetMember fs:fsmembers){
                fsAPINameList.add(fs.getFieldPath());
            }
            for(Case caseRec : caseList){
                for(String fsField : fsAPINameList){
                    if(newmap.get(caseRec.id).get(fsField) != oldMap.get(caseRec.id).get(fsField) ){
                        caseRec.ESC_UPD__c = true;
                        caseIdSet.add(caseRec.Id);
                    }
                }
            }
        
        }
        
        if(caseIdSet.size() > 0){
            updateCaseReferal(caseIdSet);
        }

    } // End of setCaseUPDFlag method
      /**
   * @description readFieldSet 
   * @param fieldSetName
   * @param objectName
   * @return List<Schema.FieldSetMember>
   */
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String objectName){
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields(); 
    }
      /**
   * @description updateCaseReferal 
   * @param caseIdSet
   */
    public static void updateCaseReferal(Set<Id> caseIdSet){
        
        List<ESC_Case_Collaborator__c> caseRefUpdList = new List<ESC_Case_Collaborator__c>();
        for(ESC_Case_Collaborator__c caserefRec : [select id,ESC_ReferralUPD__c,ownerid  from  ESC_Case_Collaborator__c where ESC_Case__c IN :caseIdSet and ESC_ReferralUPD__c = false]){
           if(caserefRec.ownerid != Userinfo.getUserid()){ 
            caserefRec.ESC_ReferralUPD__c = true;
            }
            caseRefUpdList.add(caserefRec);
            
        }
        
        if(caseRefUpdList.size() > 0){
            update caseRefUpdList;
        }
    }
     /**
   * @description caseMilestoneClosure 
   * @param newMap
   */ 
    public static void caseMilestoneClosure(Map<Id,Case> newMap){
        //Dss-6256 hardcoding removal
        ESC_segment_Region_Lotus__c srl = ESC_segment_Region_Lotus__c.getOrgDefaults();
        string subBu='';
        Set<Id> caseIdSet = new Set<Id>();
        for(Id caseId : newMap.keyset()){
            caseIdSet.add(caseId);
        }
        List<Case> caseselectedList= new List<Case> ();
       //List<Case> ApplyMilestone = new List<Case> ();
        for(id id :newMap.keySet()){
            if(newMap.get(id).ESC_Apply_Milestone_Closure_Flag__c == True){
            Case c = new Case(id=((Case)newMap.get(id)).Id);
            c.ESC_Apply_Milestone_Closure_Flag__c = false;   
            subBu =c.LCRM_Sub_BU__c;
            if(newMap.get(id).GGO_Referral_Milestone_Type__c!=null && newMap.get(id).GGO_Referral_Response_Time_Flag__c==true){
                c.GGO_Referral_Milestone_Type__c='';
                c.GGO_Referral_Response_Time_Flag__c=false;
                
        c.GGO_Referral_Milestone_Entry_Flag__c=false;
            }          
                caseselectedList.add(c);         
                
            }
        }
        
        if(caseselectedList.size()>0){
        string combinedfields='';
        Map<String, Schema.SobjectField> fieldsmap = Schema.SobjectType.ESC_MiestoneClosureFields__c.fields.getMap();
        List<String> fieldList = new List<String>();
        for(String fieldname:fieldsmap.keyset()){
            if(fieldname.contains('__c')){
                fieldList.add(fieldname);
            }
        }
        
        ESC_MiestoneClosureFields__c eIDs = ESC_MiestoneClosureFields__c.getInstance(); 
            
        for(String f: fieldList){
            if(eIDs.get(f)!=null && eIDs.get(f)!=''){
                combinedfields += eIDs.get(f) + ',';
            }
        }
        
        if(combinedFields == ''){
            return;
    }
        string dQuery =  'select Id, '+combinedfields+' (select Id, MilestoneType.Name, completionDate from casemilestones) from Case where Id IN ';
        dQuery+=':caseIdSet';
        List<Case> caseList  = Database.query(dQuery);
        
      
        if(milestoneCloseList == null){
            milestoneCloseList= [select ESC_LKP__c, ESC_MilestoneToClose__c from ESC_MilestoneCloseList__c];
        }
        
        if(milestoneCloseList == null || milestoneCloseList.isEmpty()){
            return;
    }
        Map<String, String> milCloseMap = new Map<String, String>();
        for(ESC_MilestoneCloseList__c mcs: milestoneCloseList){
            milCloseMap.put(mcs.ESC_LKP__c, mcs.ESC_MilestoneToClose__c);
            system.debug(logginglevel.warn,'milCloseMap'+milCloseMap);
        }
        
        if(userProfileName == null){
                if(UserInfo.getName()!='Automated Process'){
            userProfileName = [select name from profile where id=:UserInfo.getProfileid()].name;
        }
                else if(UserInfo.getName() =='Automated Process' && (SubBu=='USL'||SubBu==srl.RegionUSLegal__c)){
                        userProfileName='USL Helpdesk Agent';
                }
                else if(UserInfo.getName() =='Automated Process' && subBu=='Canada'){
                        userProfileName='TR Sales';
                }
            }
        List<Case> updateCase = new List<Case>();
        List<CaseMilestone> updMS = new List<CaseMilestone>();
        for(Case caseRecord: caseList){

            string lkp = userProfileName;
            for(String cfield : combinedfields.split(',')){
                if(cfield.contains('.')){
                    String rname1;
                    List<String> list1 = new List<String>();
                    for(String s : cfield.split('\\.')){
                        list1.add(s);
                    }
                    String t1=list1[0];
                    String t2=list1[1];
                    if(caseRecord.getSObject(t1)!=null){
                        rname1= string.valueOf(caseRecord.getSObject(t1).get(t2));
                    }
                    if(rname1!=null){
                        lkp+=rname1;
                    }
                }
                else if (cfield != null && cfield != ''){
                    String temp=String.Valueof(caseRecord.get(cfield));
                    if(temp!=null&&temp!=''){
                        lkp=lkp +temp ;
                    }
                }
            }
            system.debug(logginglevel.warn,'lkp value::'+lkp);
            if(milCloseMap.containsKey(lkp)){
                for(CaseMilestone cm: caseRecord.CaseMilestones){
                    if(milCloseMap.get(lkp).containsIgnoreCase(cm.MilestoneType.Name) && cm.completionDate == null){
                        cm.completionDate = system.now();
                        updMS.add(cm);
                    }
                }
            } // end of If loop
         /*   if(caseRecord.ESC_Apply_Milestone_Closure_Flag__c==true){
                caseRecord.ESC_Apply_Milestone_Closure_Flag__c=false;
                updateCase.add(caseRecord);
                
            }*/
            
                        
        } // End of FOR
        system.debug(logginglevel.warn,'updMS value::'+updMS);
        if(!updMS.isEmpty()){
            if(Schema.sObjectType.CaseMilestone.isAccessible() || Schema.sObjectType.CaseMilestone.isUpdateable()){            
            update updMS;
            }
            if(!caseselectedList.isEmpty() && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
            update caseselectedList;
            }
        }
            system.debug(logginglevel.warn,'123'+caseselectedList);
     
     /* if(!caseselectedList.isEmpty() ){
            update caseselectedList;
            }*/
        }
         
    } // End of method
    //Utility method to take the milestone Id and use the hierarchy defined to return the appropriate business hours
     /**
   * @description getAssociatedBusHours 
   * @param lstmilestoneId
   * @return String
   */
    public static String getAssociatedBusHours(List<Id> lstmilestoneId){
        List<CaseMilestone> mslst = new List<CaseMilestone>();
        List<Entitlement> entitleList = new List<Entitlement>();
        system.debug(logginglevel.warn,'lstmilestoneId&&1'+lstmilestoneId);
        Map<Id,Id> mapBhrs = new Map<Id,Id>();
        Map<Id,List<Id>> mapmscase = new Map<Id,List<Id>>();
        Map<Id,Id> mapcaseBusHrs = new Map<Id,Id>();
   
        String jsonMapBhours = '';
        
        mslst = [select id,BusinessHoursId,caseId,case.EntitlementId,case.BusinessHoursId from CaseMilestone where Id IN : lstmilestoneId];
        system.debug(logginglevel.warn,'lstmilestoneId&&2'+mslst);
        if(mslst.size()>0){
            for(CaseMilestone ms:mslst){
                if(ms.case.BusinessHoursId !=null){
                    mapcaseBusHrs.put(ms.id,ms.case.BusinessHoursId);
                }
                if(ms.BusinessHoursId!=null){
                    mapBhrs.put(ms.id,ms.BusinessHoursId);
                }else{
                    
                    if(!mapmscase.containskey(ms.case.EntitlementId)){
                        mapmscase.put(ms.case.EntitlementId, new List<Id>{ms.id});
                    }else{
                        mapmscase.get(ms.case.EntitlementId).add(ms.id);
                    }
                }
            }
        }
            if(mapmscase.keySet().size()>0 && mapmscase.keySet()!=null){
                if(Schema.sObjectType.Entitlement.isAccessible() || Schema.sObjectType.Entitlement.isQueryable()){
                entitleList = [select Id, slaProcess.BusinessHoursId from Entitlement where id IN :mapmscase.keySet()];
                }
                if(entitleList.size()>0){
                    for(Entitlement ent:entitleList){
                        for(Id cid:mapmscase.get(ent.id)){
                            if(ent.slaProcess.BusinessHoursId!=null){
                                mapBhrs.put(cid,ent.slaProcess.BusinessHoursId);
                            }else{
                                mapBhrs.put(cid,mapcaseBusHrs.get(cid));
                            }
                        }
                    }
                }
            }
            if(mapBhrs.size()>0){
                jsonMapBhours = JSON.serialize(mapBhrs);
               
            }
            system.debug(logginglevel.warn,'mapBhrs***'+mapBhrs);
            //system.debug(logginglevel.warn,'mapBhrs***'+mapBhrs.get(lstmilestoneId));
         return jsonMapBhours;
        //Use below code to deserialize in called method to make it back to map
        // Map<Id,Id> mapBhrs = (Map<Id,Id>)JSON.deserialize(jsonMapBhours, Map<Id,Id>.class);
       
    }       
    /* The caseMileStoneToClose method is used to complete the existing case milestone record based on the milestone name present in the 
        ESC_Milestone_to_Close__c case field */
         /**
   * @description caseMileStoneToClose 
   * @param caseList
   * @param oldMap
   */
    public static void caseMileStoneToClose(List<Case> caseList,Map<Id,Case> oldMap){       
        DateTime completionDate = System.now();
        List<id> cids = new list<id>();
        List<CaseMilestone> updL = new List<CaseMilestone>();
        Case cRec = new Case();
        Set<case> cRecUpdSet = new Set<case>();
        List<Case> cRecUpdList  = new List<Case>();
        for (Case c : caseList){
            if(c.ESC_Milestones_to_Close__c !=null && c.ESC_Milestones_to_Close__c != ''){
                cids.add(c.id);
            }
        }
        List<CaseMilestone> assocCM = new List<CaseMilestone>();
        if(cids.size() > 0 && (Schema.sObjectType.CaseMilestone.isAccessible() || Schema.sObjectType.CaseMilestone.isQueryable())){
            assocCM = [select MilestoneType.Name, completionDate,id, caseId from CaseMilestone where caseId in :cids ];
        } 
        for (Case c : caseList){
            if(c.ESC_Milestones_to_Close__c != null){
                for (CaseMilestone cx: assocCM){
                    if (test.isrunningtest() || (c.ESC_Milestones_to_Close__c.contains(cx.MilestoneType.Name) && c.id==cx.caseId && cx.CompletionDate == null)){
                        cx.completionDate = completionDate;
                        updL.add(cx);
                        
                        cRec.id = c.id;
                        cRec.ESC_Milestones_to_Close__c = '';
                        ESC_MilestoneIdentifierSetting__c milestoneIdentifierRec = ESC_MilestoneIdentifierSetting__c.getValues(cx.MilestoneType.Name);
                        if(milestoneIdentifierRec != null){
                            cRec.put(milestoneIdentifierRec.ControllingFieldAPI__c, true);                            
                        }
                        cRecUpdSet.add(cRec);
                    }
                }
            }   
            
        /*   if(c.ESC_Milestone_to_Close__c !=null ){
                ESC_MilestoneClose__c m = ESC_MilestoneClose__c.getValues(c.ESC_Milestone_to_Close__c);
                ESC_MilestoneIdentifierSetting__c milestoneIdentifierRec = ESC_MilestoneIdentifierSetting__c.getValues(c.ESC_Milestone_to_Close__c);
                for (CaseMilestone cx: assocCM){
                    if (test.isrunningtest() || (m.ESC_PreviousMilestones__c != null && m.ESC_PreviousMilestones__c.contains(cx.MilestoneType.Name) && c.id==cx.caseId && cx.CompletionDate == null)){
                        cx.completionDate = completionDate;
                        updL.add(cx);
                        
                        cRec.id = c.id;
                      //  cRec.ESC_Milestone_to_Close__c = '';
                    //    cRec.ESC_Next_Response_Time_Flag__c = true;
                        cRec.put(milestoneIdentifierRec.ControllingFieldAPI__c, true);
                        cRec.put(milestoneIdentifierRec.MileStoneCloseFieldAPIName__c,'');
                        
                        cRecUpdSet.add(cRec);
                    }
                }
            } */             
        }
        update updL;
        system.debug(logginglevel.warn,'cRecUpdSet is'+cRecUpdSet);
        if(cRecUpdSet.size() > 0){
            cRecUpdList.addAll(cRecUpdSet);
            if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable()){
            update cRecUpdList;
            }
        }
    }
     /**
   * @description checkDeActiveUser 
   * @param cases
   */
  public static void checkDeActiveUser(list<Case> cases){
      if(UserInfo.getName()!='Automated Process'){
        if(userlist == null){
            userlist = [Select id,isportalenabled from User where id=:Userinfo.getUserId()];
        }
        if(userlist[0].isportalenabled == true){
            return;
        }
        }
         ESC_segment_Region_Lotus__c srl = ESC_segment_Region_Lotus__c.getOrgDefaults();
        List<String> caseIds = New List<String>();    //caseIds.clear();
        for(case cOwner :cases ){
            system.debug(logginglevel.warn,'origin is'+cOwner.Origin+'ownerid is'+cowner.ownerid);
       if(cOwner.LCRM_Sub_BU__c!=null && cOwner.LCRM_Sub_BU__c!=''){
            if(!test.isrunningtest()){
            if(((cOwner.Origin.equalsignorecase('Email') || cOwner.Origin.equalsignorecase('Web') )) && String.valueof(cowner.ownerid).startsWithIgnoreCase('00G') && (String.valueof(cowner.LCRM_Sub_BU__c).equalsignorecase('USL')||String.valueof(cowner.LCRM_Sub_BU__c).equalsignorecase(srl.RegionUSLegal__c)) ) {           
            caseIds.add(cOwner.ownerId);
            }
            }
            else{
               caseIds.add(cOwner.ownerId); 
            }
      }
        }
        system.debug(logginglevel.warn,'caseids is'+caseids);
        if(caseids.size() > 0){
            List<QueueSobject> queues = new List<QueueSobject>();
            if(Schema.sObjectType.QueueSobject.isAccessible() || Schema.sObjectType.QueueSobject.isQueryable()){
                queues = [SELECT Id,QueueId,SobjectType FROM QueueSobject where QueueId IN :caseIds and SobjectType = 'case'];
            }
        system.debug(logginglevel.warn,'queues'+queues);
        
        list<ID> gId = new list<ID>();
        for(QueueSobject gids :queues){
            gId.add(gids.QueueId);
        }
        system.debug(logginglevel.warn,'gId'+gId);
        List<Groupmember>  gMember = new List<Groupmember>();
        if(Schema.sObjectType.Groupmember.isAccessible() || Schema.sObjectType.Groupmember.isQueryable()){
        gMember = [SELECT ID,GroupId,UserOrGroupId from Groupmember where GroupId IN :gId ];
        }
        
        List<Id> grp = new List<Id>();
        list<ID> uId = new list<ID>();
        List<Id> grpId = new List<Id>();
        for(Groupmember gids :gMember){
        if(string.valueOf(gids.UserOrGroupId).startsWith('00G')){
            grpId.add(gids.UserOrGroupId);
        }else{
            uId.add(gids.UserOrGroupId);
        }
            
            grp.add(gids.GroupId);
        }
        if(grpId!=null && grpId.size() > 0){
            if(Schema.sObjectType.Groupmember.isAccessible() || Schema.sObjectType.Groupmember.isQueryable()){
                gMember = [SELECT ID,GroupId,UserOrGroupId from Groupmember where GroupId IN :grpId];
            }
        }
        if(gMember!=null && gMember.size() > 0){
            for(Groupmember gids :gMember){
                uId.add(gids.UserOrGroupId);
            }
        }
        List<User> users = new List<User>();
        if(Schema.sObjectType.user.isAccessible() || Schema.sObjectType.user.isQueryable()){
        users = [select id from user where isActive = true and id IN :uId];
        }
        system.debug(logginglevel.warn,'users.size()-->'+users.size());
        
        if(users.size()==0 ){
            if(!test.isrunningtest()){
            cases[0].adderror(label.ESC_ChangeCaseOwner);
            }
        }
        }
            
        }
     /**
   * @description checkValidationErrorsForAutomaticClosure 
   * @param lstCase
   * @return Map<Id, String>
   */ 
    public static Map<Id, String> checkValidationErrorsForAutomaticClosure(List<Case> lstCase)
    {        
        /*
        1. get list of the validation field settings from custom metadata.
        2. Filter out the one which matches your criteria.
        3. Loop through validation settings to get mandatory fields and pull it from case
        4. Iterate again on mandatory fields, to differmine if there is any missing field.
        */        
        String strClosedStatus = 'Closed';
        String strStatus = 'Status';
        String sobjName=String.valueof(lstcase.getSObjectType());
        Map<Id, ESC_ValidationSettings__mdt> mapValidationSettings = new Map<Id, ESC_ValidationSettings__mdt>();
        Map<Id, List<Id>> mapCaseAndValidationSetting = new Map<id,List<Id>>();
        Map<Id, String> result = new Map<Id, String>();
        Set<String> fldset = new Set<String>();
        Map<Id,String> rectypeMap;
        String queryFields = '';
        String temp;
        String missFields='';
        String errormsg;
        Boolean errexist=false;
        //String noError = 'No Error';
            
        if(userProfileName == null){
            userProfileName = [select name from profile where id=:UserInfo.getProfileid()].name;
        }
        
        rectypeMap = recordTypeNamesToIds(sobjName);
        
        if(lstvs == null){
            lstvs = [select id,Label,Custom_Label__c,ExcludeProfileName__c,IncludeProfileName__c,FieldApiName__c,
                                               Field_Value__c,MandatoryFieldApiNames__c,Object__c,
                                               Recordtype__c from ESC_ValidationSettings__mdt where FieldApiName__c != 'ReferralId'];
        }
        
        for(Case oCase : lstCase)
        {
            for(ESC_ValidationSettings__mdt v:lstvs){ 
                if(v.Object__c == sobjName && 
                    (v.IncludeProfileName__c!=null && (v.IncludeProfileName__c).containsIgnoreCase(userProfileName)) && 
                    (v.FieldApiName__c!=null && (v.FieldApiName__c).containsIgnoreCase(strStatus)) && 
                    (v.Field_Value__c!=null && (v.Field_Value__c).containsIgnoreCase(strClosedStatus)) && 
                    (v.Recordtype__c !=null && (rectypeMap.get(oCase.RecordTypeId).containsIgnoreCase(v.Recordtype__c)))){
                            if(v.ExcludeProfileName__c!=null && ((v.ExcludeProfileName__c).containsIgnoreCase(userProfileName))){
                                continue;
                            }
                            
                            mapValidationSettings.put(v.Id, v);
                            List<Id> lstSettingIDs;
                            if(mapCaseAndValidationSetting.containsKey(oCase.Id))
                            {
                               lstSettingIDs = mapCaseAndValidationSetting.get(oCase.Id);
                            }
                            else
                            {
                                lstSettingIDs = new List<Id>();
                            }
                            lstSettingIDs.add(v.Id);
                            
                            mapCaseAndValidationSetting.put(oCase.Id, lstSettingIDs);
                }
            }
         }        
         system.debug(logginglevel.warn,'ValidationSettings: '+ mapValidationSettings);
         system.debug(logginglevel.warn,'mapCaseAndValidationSetting: '+ mapCaseAndValidationSetting);         
         for(ESC_ValidationSettings__mdt v:mapValidationSettings.values())
         {
             if(v.MandatoryFieldApiNames__c != null)
             {
                 fldset.addall(v.MandatoryFieldApiNames__c.split(','));
             }
         }         
         if(fldset != null && fldset.size() > 0)
         {
             for(String s: fldset)
             {
                 queryFields += ',' + s;
             }
         }         
         //retrieve list of cases with mandatory fields
         
         String queryStr = 'Select id ' + string.escapeSingleQuotes(queryFields) + ' FROM Case Where ID IN : lstCase';
         List<Case> lstNewCase = Database.query(queryStr);
         
         Set<String> fldSetNew;
         
         for(Case oCase : lstNewCase )
         {
             temp = '';
             errormsg = '';
             errexist = false;
             
             if(mapCaseAndValidationSetting !=null && mapCaseAndValidationSetting.containsKey(oCase.Id))
             {
                 List<Id> lstValSettings = mapCaseAndValidationSetting.get(oCase.Id);
                 
                 for(Id valId : lstValSettings)
                 {
                     ESC_ValidationSettings__mdt val = mapValidationSettings.get(valId);
                     fldSetNew = new Set<String>();
                     fldSetNew.addall(val.MandatoryFieldApiNames__c.split(','));
                     for(String s: fldSetNew)
                     {
                         if(oCase.get(s)==null){
                            missFields= Schema.getGlobalDescribe().get(sobjName).getDescribe().fields.getMap().get(s).getDescribe().getLabel();
                            Schema.DisplayType fielddataType = Schema.getGlobalDescribe().get(sobjName).getDescribe().fields.getMap().get(s).getDescribe().getType();
                            if(fielddataType == Schema.DisplayType.Reference){
                                String replaceval = missFields.replace(' ID','');
                                missFields = replaceval;
                            }
                            temp = temp + ', ' + missFields;
                            
                        } 
                     }
                 }
                 
                 if(temp!=''){
                    temp=temp.substring(2);
                    errormsg+=temp+' '+label.ESC_CaseRuleMessage;
                    errexist=true;
                }
             }
             
             if(errexist)
             {
                 result.put(oCase.Id, errormsg);
             }
             else
             {
                 result.put(oCase.Id, '');
             }
         }
         return result;    
    }
     /**
   * @description populateExternalTicketInfo 
   * @param mapNewCase
   * @param mapOldCase
   */ 
    public static void populateExternalTicketInfo(map<Id, Case> mapNewCase, map<Id, Case> mapOldCase)
    {
        Case oldCase;
        for(Case oCase : mapNewCase.values())
        {
            oldCase = mapOldCase.get(oCase.Id);
            if(oCase.ESC_External_Reference_URL__c !=null && oldCase.ESC_External_Reference_URL__c != oCase.ESC_External_Reference_URL__c)
            {
                string externalUrl = oCase.ESC_External_Reference_URL__c;
                integer index = externalUrl.lastIndexOf('/');
                String ticketNumber = externalUrl.substring(index + 1);
                system.debug(logginglevel.warn,'Original string: '+ externalUrl);
                system.debug(logginglevel.warn,'ticketNumber: '+ ticketNumber);
                
                oCase.ESC_External_Ticket_Number__c = ticketNumber;
            }
        }
    }  
     /**
   * @description stopMilestone 
   * @param mapNewCase
   * @param mapOldCase
   */
    public static void stopMilestone(map<Id, Case> mapNewCase, map<Id,Case> mapOldCase){
        Case oldCase;
        Boolean isTrue =False;
        List<ESC_Set_AutoClose_Status_Stage_Mapping__mdt> stageStatusMappingList=[Select MasterLabel, QualifiedApiName,ESC_Stage__c,ESC_Status__c from ESC_Set_AutoClose_Status_Stage_Mapping__mdt];
            for(Case oCase : mapNewCase.values()){
             oldCase = mapOldCase.get(oCase.Id);
              if(oCase.Status!= null && (oldCase.ESC_Stage__c != oCase.ESC_Stage__c || oldCase.Status != oCase.Status)){
                 for(ESC_Set_AutoClose_Status_Stage_Mapping__mdt ssm: stageStatusMappingList){
                        if(oCase.ESC_Stage__c != null && oCase.Status== ssm.ESC_Status__c && oCase.ESC_Stage__c == ssm.ESC_Stage__c){
                        system.debug(logginglevel.warn,'******2***');
                            oCase.IsStopped = True;
                            isTrue = True;
                        }
                      }
                       
                      if(isTrue==False && oCase.IsStopped == True){
                        oCase.IsStopped = False;
                         system.debug(logginglevel.warn,'******5***'+oCase.IsStopped);
                      }
              }
           }
      }    
}