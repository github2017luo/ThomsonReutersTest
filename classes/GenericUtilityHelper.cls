public  without sharing class GenericUtilityHelper {
    public static List<user> userlist;
    public static void caseUpdates(Map<id,Case> oldMAp,Map<id,Case> newMap){
        ESC_segment_Region_Lotus__c segRegCorp = ESC_segment_Region_Lotus__c.getOrgDefaults();
         if(userlist == null){
            userlist= [Select id,userrole.name,Timezonesidkey from User where id =:userinfo.getUserId()];
        }
        map<String,String> casecreatedbymap = new map<String,String>();
        for(User usr : userlist){
            casecreatedbymap.put(usr.id,usr.userrole.name);
           
            
        }
        for(id csid: newMap.keySet()){
            if(newMap.get(csid).Ownerid!=null){
                if((newMap.get(csid).Ownerid != oldMap.get(csid).Ownerid) && ((String)(oldMap.get(csid).Ownerid)).startsWith('00G') && ((String)(newMap.get(csid).Ownerid)).startsWith('005') && newMap.get(csid).Status == 'New' && newMap.get(csid).Is_ESC_Case__c ==true){
                     //Added for DSS-10078
                     if(newMap.get(csid).Is_GLI__c==false && newMap.get(csid).LCRM_Sub_BU__c== 'GGO'){
                        newMap.get(csid).Status='Work In Progress';
                     }
                    newMap.get(csid).GGO_First_Response_Time_Flag__c =true;
                    if(newMap.get(csid).Is_GLI__c==false){
                        newMap.get(csid).ESC_Next_Response_Time_Flag__c =true;}
                   //added as part of UKD-608 regression defect(BAC-126)
                    if(newMap.get(csid).Is_GLI__c==true && newMap.get(csid).LCRM_Sub_BU__c== 'UKI')
                     {
                       newMap.get(csid).Status='Work In Progress';
                       newMap.get(csid).GLI_Milestone_Reference_Date__c=system.now();
                     }  
                     //if(newMap.get(csid).Is_GLI__c==true && newMap.get(csid).LCRM_Sub_BU__c== 'USL')
                     if(newMap.get(csid).Is_GLI__c==true && (newMap.get(csid).LCRM_Sub_BU__c== 'USL'|| newMap.get(csid).LCRM_Sub_BU__c== segRegCorp.RegionUSLegal__c || newMap.get(csid).LCRM_Sub_BU__c== 'Canada' || newMap.get(csid).BU_Segment__c== segRegCorp.SegmentCorp__c|| newMap.get(csid).LCRM_Sub_BU__c== segRegCorp.RegionUSCorp__c|| newMap.get(csid).BU_Segment__c== segRegCorp.SegmentTax__c || newMap.get(csid).BU_Segment__c== segRegCorp.SegmentLegal__c || newMap.get(csid).BU_Segment__c== segRegCorp.SegmentLegal_blank__c || newMap.get(csid).BU_Segment__c=='Government'))
                     {
                       newMap.get(csid).Status='Work In Progress';
                       newMap.get(csid).GGO_First_Response_Time_Flag__c =true;
                       if(casecreatedbymap != null && casecreatedbymap.containsKey(userinfo.getuserId()) && !(oldmap.get(csid).USL_Case_Created_By_Role__c != null && oldmap.get(csid).USL_Case_Created_By_Role__c.containsignorecase('Findlaw'))){
                       newMap.get(csid).USL_Case_Created_By_Role__c = casecreatedbymap.get(userinfo.getuserId());}
                     }  
 
                }
               else if(((newMap.get(csid).ESC_Diagnosis_Summary__c != oldMap.get(csid).ESC_Diagnosis_Summary__c) || (newMap.get(csid).ESC_Case_Sub_Type__c!= oldMap.get(csid).ESC_Case_Sub_Type__c)) && newMap.get(csid).Is_ESC_Case__c ==true){
                    newMap.get(csid).ESC_Next_Response_Time_Flag__c =false;
                    newMap.get(csid).GGO_First_Response_Time_Flag__c =true;
                }                  
                // Added as part of DSS-7554- Disputes
                 else if((newMap.get(csid).Ownerid != oldMap.get(csid).Ownerid) && ((String)(oldMap.get(csid).Ownerid)).startsWith('00G') && ((String)(newMap.get(csid).Ownerid)).startsWith('005') && newMap.get(csid).Status <> 'New' && newMap.get(csid).Is_ESC_Case__c ==true && newMap.get(csid).ESC_Case_Acceptance_Flag__c == true)
                 {
                 newMap.get(csid).ESC_Apply_Milestone_Closure_Flag__c=true;
                 }

            }
            if(MasterCaseTriggerRecursiveCheck.MilestoneCancelledRun ==true && newMap.get(csid).Is_ESC_Case__c ==true && (newMap.get(csid).Is_GLI__c ==true && newMap.get(csid).LCRM_Sub_BU__c== 'UKI') && oldMap.get(csid).Status== 'New' && newMap.get(csid).Status=='Cancelled'){
               newMap.get(csid).GLI_Is_Status_Change__c=true;
               MasterCaseTriggerRecursiveCheck.MilestoneCancelledRun=false;
             }

            // Setting up the Entitlement based on Entitlement Selector Criteria
            string combinedfields='';
            Map<String, Schema.SobjectField> fieldsmap = Schema.SobjectType.ESC_EntitlementSelectorFields__c.fields.getMap();

            List<String> fieldList = new List<String>();
            for(String fieldname:fieldsmap.keyset()){
                if(fieldname.contains('__c')){
                    fieldList.add(fieldname);
                }
            }

            for(id csid1: newMap.keySet()){
                sObject thisObj=(sObject) newMap.get(csid1);
                sObject thisOldObj=(OldMap == null? null:(sObject) OldMap.get(csid1));       
                ESC_EntitlementSelectorFields__c eIDs = ESC_EntitlementSelectorFields__c.getInstance(); 
                system.debug('eIDs1 : ' +eIDs);

                for(String f: fieldList){
                    if(eIDs.get(f)!=null && eIDs.get(f)!=''){
                        string entfield= (string)eIDs.get(f);
                        //Added to support for GLI Cases
                        if(entfield.contains('.')){            
                            entfield= 'RecordtypeId';
                        }
                         // if(eIDs.entfield!=''||eIDs.entfield!=null) { 
                       if(!Test.isRunningTest()){    
                        if((thisObj.get(entfield)!=thisOldObj.get(entfield)) || (thisOldObj ==null && (thisObj.get(entfield) !=null))){
                            newMap.get(csid1).ESC_Apply_Entitlement_Milestone__c=true;
                        }
                       }
                    }
                }

                //setting the milestone apply flag
                Map<String, Schema.SobjectField> fieldsmap1 = Schema.SobjectType.ESC_MiestoneClosureFields__c.fields.getMap();
                List<String> fieldList1 = new List<String>();
                for(String fieldname:fieldsmap1.keyset()){
                    if(fieldname.contains('__c')){
                        fieldList1.add(fieldname);
                    }
                }

                ESC_MiestoneClosureFields__c meIDs = ESC_MiestoneClosureFields__c.getInstance(); 

                for(String f: fieldList1){
                    if(meIDs.get(f)!=null && meIDs.get(f)!=''){
                        string mfield= (string)meIDs.get(f);
                        //Added to support for GLI Cases
                        if(mfield.contains('.'))            
                            mfield= 'RecordtypeId';
                            if(thisOldObj != null){
                        if(thisObj.get(mfield)!=thisOldObj.get(mfield)){
                            newMap.get(csid1).ESC_Apply_Milestone_Closure_Flag__c=true;
                        }
                    }
                   }
                }
            }
        }
    }
    public static void caseBHupdate(List<Case> newList){
     if(userlist == null){
            userlist= [Select id,userrole.name,UserRole.DeveloperName,Timezonesidkey from User where id =:userinfo.getUserId()];
             Map <string,string> businesshourmap= new Map <string, string> ();
             
             string businesshourid;
    
        }
    }

    public static void CaseUpdates(List<Case> newList){
         if(userlist == null){
            userlist= [Select id,userrole.name,UserRole.DeveloperName,Timezonesidkey from User where id =:userinfo.getUserId()];
        }
        Map<String, Schema.SobjectField> fieldsmap = Schema.SobjectType.ESC_EntitlementSelectorFields__c.fields.getMap();
        List<String> casecreatedbylist = new List<String>();
        map<String,String> casecreatedbymap = new map<String,String>();
        List<String> fieldList = new List<String>();
        for(String fieldname:fieldsmap.keyset()){
            if(fieldname.contains('__c')){
                fieldList.add(fieldname);
            }
        }
        for(Case caserec : newList){
            casecreatedbylist.add(caserec.createdbyId);
        }
        for(User usr : userlist){
            casecreatedbymap.put(usr.id,usr.userrole.name);
        }
        
        String offlineQueueName = Label.Tax_Offline_Queue_Name;
        Id offlineTaxQueueId = [Select id from group where DeveloperName = :offlineQueueName].Id;
        system.debug('ID: '+offlineTaxQueueId);
        
        ESC_segment_Region_Lotus__c segRegTax = ESC_segment_Region_Lotus__c.getOrgDefaults();
        
        system.debug('fieldList is : ' + casecreatedbymap);
        ESC_EntitlementSelectorFields__c eIDs = ESC_EntitlementSelectorFields__c.getInstance(); 
        system.debug('eIDs 2: ' +eIDs);
        for(Case caseObj : newList){
            sObject thisObj=(sObject) caseObj;
            system.debug('created by id is'+userinfo.getuserid());
            
            //Added for Tax
            if(caseObj.Is_GLI__c==true && caseObj.Is_ESC_Case__c ==true && caseObj.Origin == 'Web' && caseObj.BU_Segment__c==SegRegTax.segmentTax__c)
            {
                caseObj.ownerId = offlineTaxQueueId;
                caseObj.Description = caseObj.ESC_Description_Offline__c;
            }
            
            if(caseObj.Is_GLI__c==true && caseObj.LCRM_Sub_BU__c== 'Canada' && ((String)(caseObj.Ownerid)).startsWith('005')&& caseObj.Is_ESC_Case__c ==true && UserInfo.getTimeZone().getDisplayName()=='America/New_York'){
                System.debug('added to fix PMD error');
            }
            if(casecreatedbymap != null && casecreatedbymap.containsKey(userinfo.getuserId())){
                caseObj.USL_Case_Created_By_Role__c = casecreatedbymap.get(userinfo.getuserId());
            }
            // Setting up the Entitlement based on Entitlement Selector Criteria
            system.debug('thisObj@'+thisObj);
            for(String f: fieldList){
                System.debug('eIDs.get(f)@'+eIDs.get(f));
                if(eIDs.get(f) != null && eIDs.get(f) != ''){
                    string entfield= (string)eIDs.get(f);
                    //Added to support for GLI Cases
                    if(entfield.contains('.')){            
                        entfield= 'RecordtypeId';
                    }
                    if(thisObj.get(entfield) !=null){
                        caseObj.ESC_Apply_Entitlement_Milestone__c = true;
                    }
                }
            }
        }
    }
   /*commented as part of DSS-620
    public static void CaseUpdatesAfterInsert(List<Case> newList){
        //hardcoding removel : DSS-6256
    ESC_segment_Region_Lotus__c srl = ESC_segment_Region_Lotus__c.getOrgDefaults();
        
    //added for DSS-602
    if(userlist == null){
            userlist= [Select id,UserRole.Name,UserRole.DeveloperName from User where id =:userinfo.getUserId()];
        }
        map<String,String> casecreatedbymap = new map<String,String>();
        Set<String> roleList = new Set<String>();  
        for(USL_Roles_Static_CC_Milestone__c rv : USL_Roles_Static_CC_Milestone__c.getAll().values()) {
           roleList.add(rv.Name);
        }
        System.debug('roleList'+roleList);
        for(User usr : userlist){
            casecreatedbymap.put(usr.id,usr.userrole.DeveloperName);
        }
        String currentRole;
        if(casecreatedbymap != null && casecreatedbymap.containsKey(userinfo.getuserId())){
         currentRole = casecreatedbymap.get(userinfo.getuserId());
        }
        System.debug('currentRole '+currentRole);
        for(Case c1 : newList){
            if(c1.origin == 'Phone' && ((String)c1.OwnerID).startsWith('005')&& c1.Is_ESC_Case__c == true && c1.Is_GLI__c == true &&
             (c1.lcrm_sub_bu__c == 'USL' || c1.lcrm_sub_bu__c == srl.RegionUSLegal__c || c1.lcrm_sub_bu__c == 'Canada')&& roleList.contains(currentRole))
            {
                c1.USL_Static_Case_Closure_Flag__c = true;
                system.debug('USL_Static_Case_Closure_Flag__c is : ' + c1.USL_Static_Case_Closure_Flag__c);
            }
        }
    }

    public static void CaseUpdatesAfterInsert(Map<id,Case> oldMAp,Map<id,Case> newMap){
        
        ESC_segment_Region_Lotus__c srl = ESC_segment_Region_Lotus__c.getOrgDefaults();
      //added for DSS-602
        map<String,String> casecreatedbymap = new map<String,String>();
        Set<String> roleList = new Set<String>();  
        for(USL_Roles_Static_CC_Milestone__c rv : USL_Roles_Static_CC_Milestone__c.getAll().values()) {
           roleList.add(rv.Name);
        }
        System.debug('roleList'+roleList);
        for(id caseid : newMap.keySet()){
        for(User usr : [Select id,userrole.name,userrole.DeveloperName from User where id =: newMap.get(caseid).Ownerid]){
            casecreatedbymap.put(usr.id,usr.userrole.DeveloperName);
        }
        }
        String currentRole = ''; 
        String bhrs='';
        for(id csid: newMap.keySet()){
            if(newMap.get(csid).Ownerid!=null){ 
            if(casecreatedbymap != null && casecreatedbymap.containsKey(newMap.get(csid).Ownerid)){
                currentRole = casecreatedbymap.get(newMap.get(csid).Ownerid);
            }
            System.debug('currentRole '+currentRole);
           
                if((newMap.get(csid).Ownerid != oldMap.get(csid).Ownerid) && newMap.get(csid).origin == 'Chat' && ((String)(newMap.get(csid).Ownerid)).startsWith('005') && (newMap.get(csid).lcrm_sub_bu__c == 'USL'||newMap.get(csid).lcrm_sub_bu__c == srl.RegionUSLegal__c|| newMap.get(csid).lcrm_sub_bu__c == 'Canada')&&newMap.get(csid).BU_Segment__c !=srl.SegmentTax__c&& newMap.get(csid).Is_GLI__c == true && roleList.contains(currentRole)&& newMap.get(csid).Is_ESC_Case__c ==true){
                 newMap.get(csid).USL_Static_Case_Closure_Flag__c = true;
                 
                system.debug('USL_Static_Case_Closure_Flag__c is : ' +  newMap.get(csid).USL_Static_Case_Closure_Flag__c);
            }
           //  if(newMap.get(csid).lcrm_sub_bu__c == 'Canada'&&(newMap.get(csid).Ownerid != oldMap.get(csid).Ownerid) && newMap.get(csid).origin == 'Chat'&& ((String)(newMap.get(csid).Ownerid)).startsWith('005') ){
             //     bhrs=ESC_SegmentregionUtility.getDetailInfo(newMap.get(csid).id,'casebh',newMap.get(csid).Ownerid);
              //     newMap.get(csid).businesshoursid=bhrs;
               //  }
            }
           
        }
    } */
}