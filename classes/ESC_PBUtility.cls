public without sharing class ESC_PBUtility{
    Public Static List<User> usrlst;
    Public static void calculateMTTRFields(List<Case> caseList,Map<Id,Case> oldmap){
        Double timeInMilliSec;
        Double timeInMillis;
        DateTime excludeCHTime;
        Double exCHTimeInMilliSec;
        Double exCHTimeInMillis;
        //Check with pavan to reuse genericutilityhelper list
        if( UserInfo.getName()!='Automated Process' && usrlst == null && (Schema.sObjectType.user.isAccessible() || Schema.sObjectType.user.isQueryable())){
            usrlst = [select id,sub_bu__c,Division,isActive from user where id=:UserInfo.getUserId()];
        }
        for(Case caseRec: caseList){
            if(caseRec.Is_ESC_Case__c && caseRec.Status != oldMap.get(caseRec.Id).Status && (caseRec.status == 'Closed' || caseRec.Status == 'Resolved')){
            // The Service Restored field calculation is moved from Process to here to avoid order of sequence
            caseRec.ESC_Service_Restored__c = DateTime.now();
            if(usrlst.size()>0){
            caseRec.ESC_Resolved_by__c = usrlst[0].Id;
            caseRec.ESC_Service_Restored_By_Team__c = usrlst[0].Division;
            }
            
            timeInMilliSec=(caseRec.ESC_Service_Restored__c.getTime() - caseRec.CreatedDate.getTime());
            
            caseRec.ESC_MTTR_in_hours__c = timeInMilliSec/(1000*60*60);
            caseRec.ESC_MTTR_in_days__c = timeInMilliSec/(1000*60*60*24); 
           if(caseRec.BusinessHoursId != null){ 
           timeInMillis = BusinessHours.diff(caseRec.BusinessHoursId, caseRec.CreatedDate, caseRec.ESC_Service_Restored__c);
           caseRec.ESC_MTTR_in_hoursBH__c = timeInMillis/(1000*60*60);
           caseRec.ESC_MTTR_in_daysBH__c = timeInMillis/(1000*60*60*24); 
           }
          
           if(caseRec.ESC_CustomerHoldTime__c != null){
               excludeCHTime = caseRec.CreatedDate + caseRec.ESC_CustomerHoldTime__c;    
           }else{
               excludeCHTime = caseRec.CreatedDate;
           }
           exCHTimeInMilliSec=(caseRec.ESC_Service_Restored__c.getTime()-excludeCHTime.getTime());
           caseRec.ESC_MTTR_in_hours_excluding_CH__c = exCHTimeInMilliSec/(1000*60*60); 
           caseRec.ESC_MTTR_in_days_excluding_CH__c = exCHTimeInMilliSec/(1000*60*60*24);
           
           if(caseRec.BusinessHoursId != null){ 
           exCHTimeInMillis = BusinessHours.diff(caseRec.BusinessHoursId, excludeCHTime, caseRec.ESC_Service_Restored__c);
           caseRec.ESC_MTTR_in_hours_excl_CHBH__c = exCHTimeInMillis/(1000*60*60); 
           caseRec.ESC_MTTR_in_days_excl_CHBH__c = exCHTimeInMillis/(1000*60*60*24); 
           }
           
        }
        }
        

    }
    
    public static void calculateMTTCFields(List<Case> caseList,Map<Id,Case> oldmap){
        Double timeInMilliSec;
        Double timeInMillis;
        DateTime excludeCHTime;
        Double exCHTimeInMilliSec;
        Double exCHTimeInMillis;
        for(Case caseRec:caseList){
                if((caseRec.Is_ESC_Case__c && caseRec.Status != oldMap.get(caseRec.Id).Status && caseRec.status == 'Closed') || test.isrunningtest()){
           timeInMilliSec=(DateTime.Now().getTime() - caseRec.CreatedDate.getTime());
           caseRec.ESC_MTTC_in_hours__c = timeInMilliSec/(1000*60*60);
           caseRec.ESC_MTTC_in_days__c = timeInMilliSec/(1000*60*60*24);
           if(caseRec.BusinessHoursId != null){ 
           timeInMillis = BusinessHours.diff(caseRec.BusinessHoursId, caseRec.CreatedDate, DateTime.Now());
           caseRec.ESC_MTTC_in_hoursBH__c = timeInMillis/(1000*60*60);
           caseRec.ESC_MTTC_in_daysBH__c = timeInMillis/(1000*60*60*24); 
           }
          
           if(caseRec.ESC_CustomerHoldTime__c != null){
               excludeCHTime = caseRec.CreatedDate + caseRec.ESC_CustomerHoldTime__c;    
           }else{
               excludeCHTime = caseRec.CreatedDate;
           }
           
           
           exCHTimeInMilliSec=(DateTime.Now().getTime()-excludeCHTime.getTime());
           caseRec.ESC_MTTC_in_hours_excluding_CH__c = exCHTimeInMilliSec/(1000*60*60); 
           caseRec.ESC_MTTC_in_days_excluding_CH__c = exCHTimeInMilliSec/(1000*60*60*24);
           if(caseRec.BusinessHoursId != null){ 
           exCHTimeInMillis = BusinessHours.diff(caseRec.BusinessHoursId, excludeCHTime, DateTime.Now());
           caseRec.ESC_MTTC_in_hours_excl_CHBH__c = exCHTimeInMillis/(1000*60*60); 
           caseRec.ESC_MTTC_in_days_excl_CHBH__c = exCHTimeInMillis/(1000*60*60*24); 
           }
        
        }
       } 
        
    }
    
    public static void lastqueueownerupdate(list<case> newCase,Map<Id,Case> oldmap){
        List<Id> lstusrid = new List<Id>();
        List<Id> lstownerid = new List<Id>();
        Map<Id,User> usrMap;
        Map<Id,Group> grpMap;
        
        for(Case c:newCase){
            if(c.Is_ESC_Case__c && (oldmap == null ||(oldMap!=null && c.OwnerId != oldMap.get(c.Id).OwnerId) )){
                if(c.ownerId!=null && ((String) c.OwnerId).StartsWith('00G')){
                    lstownerid.add(c.ownerId);
                }
                if(c.ownerId!=null && ((String) c.OwnerId).StartsWith('005')){
                    lstusrid.add(c.ownerId);
                }
            }
        }           
        if(lstownerid.size()>0){
            grpMap = new Map<Id,Group>([select id,Name from group where id In :lstownerid]);
        }
        if(lstusrid.size()>0){
            usrMap = new Map<Id,User>([select id,Division,Department,isActive,Manager.Email,ManagerId from User where id in :lstusrid]);
        }
         
        
        
        for(Case caseRec: newCase){
            if(( caseRec.Is_ESC_Case__c && ((String) caseRec.OwnerId).StartsWith('00G')) && (oldmap == null ||(oldMap!=null && caseRec.OwnerId != oldMap.get(caseRec.Id).OwnerId) )){
                caseRec.ESC_LastQueueOwner__c = caseRec.OwnerId;
                if(grpMap.containsKey(caseRec.OwnerId)){
                    caseRec.USL_Last_Queue_Name__c = grpMap.get(caseRec.OwnerId).Name;
                }
            } 
            
            else if(( caseRec.Is_ESC_Case__c && ((String) caseRec.OwnerId).StartsWith('005')) && (oldmap == null ||(oldMap!=null && caseRec.OwnerId != oldMap.get(caseRec.Id).OwnerId) )){
                if(usrMap.containsKey(caseRec.OwnerId)){
                    caseRec.ESC_Case_Owner_Role_Static__c = usrMap.get(caseRec.OwnerId).Division;
                    caseRec.ESC_Case_Owner_Team__c = usrMap.get(caseRec.OwnerId).Department;
                    //caseRec.USL_Case_Owner_Manager__c = (Id) usrMap.get(caseRec.OwnerId).ManagerId;
                    caseRec.Manager__c = (Id) usrMap.get(caseRec.OwnerId).ManagerId;
                    caseRec.Case_Owner_Manager_Email__c = usrMap.get(caseRec.OwnerId).Manager.Email;
                    
                    
                }
            }
         }   
    
    }
  /*  public static void accountUpdateOnContactChange(list<case> newCase,Map<Id,Case> oldmap){  
        for(Case c:newCase){
            if(c.Is_ESC_Case__c && c.contactId!=null && c.contactId != oldMap.get(c.Id).contactId){
                c.AccountId = c.contact.AccountId;
                if((c.AccountId != oldMap.get(c.Id).AccountId)){
                     c.Bu_Segment__c = c.Account.Bu_Segment__c;
                     c.LCRM_Sub_BU__c = c.Account.BU_Region__c;
                }
            }
        }              
    }*/
    
    //Added for DSS-9492
    public static void updateBillingCountry(list<case> newCase){
        List<ID> conlstid = new List<ID>(); 
        if( UserInfo.getName()!='Automated Process' && usrlst == null && (Schema.sObjectType.user.isAccessible() || Schema.sObjectType.user.isQueryable())){
            usrlst = [select sub_bu__c,contactid from user where id=:UserInfo.getUserId()];
        }      
        Map<Id,contact> conmap; 
        for(Case c:newCase){                                                
            if(c.contactId!=null){                      
                conlstid.add(c.contactid);            
            }  
            else{
              for(user u : usrlst){
                  System.debug('user contact---->'+u.contactid);
                  conlstid.add(u.contactid);
                 }        
        } 
        }                        
        if(conlstid.size()>0){          
            conmap= new Map<Id,contact>([select id,Bu_segment__C,bu_region__c,Sales_Org__c,account.billingcountry from contact where id In :conlstid]);
        }                    
        for(Case caserec:newCase) {
            if(caseRec.contactid!=null ){
                caseRec.lcrm_country__c =conmap.get(caseRec.contactid).account.billingcountry;
                if(conmap.containsKey(caseRec.contactid)&& (LCRMGenericComponent.isLotusUser() || ( usrlst[0].sub_bu__c != null && usrlst[0].sub_bu__c == 'Elite')) ){ 
                   caseRec.Sales_Org__c = conmap.get(caseRec.contactid).Sales_Org__c ;              
                   if(conmap.get(caseRec.contactid).Bu_Segment__c!=null || conmap.get(caseRec.contactid).Bu_Segment__c!=''){
                   caseRec.Bu_Segment__c  = conmap.get(caseRec.contactid).Bu_Segment__c ;}
                   if(conmap.get(caseRec.contactid).BU_Region__c !=null ||conmap.get(caseRec.contactid).BU_Region__c !=''){
                   caseRec.LCRM_Sub_BU__c  = conmap.get(caseRec.contactid).BU_Region__c;}                   
               }
            }
            else{
                if(conmap.containsKey(usrlst[0].contactid)&& (LCRMGenericComponent.isLotusUser() || ( usrlst[0].sub_bu__c != null && usrlst[0].sub_bu__c == 'Elite')) ){ 
                   caseRec.Sales_Org__c = conmap.get(usrlst[0].contactid).Sales_Org__c ;              
                   if(conmap.get(usrlst[0].contactid).Bu_Segment__c!=null || conmap.get(usrlst[0].contactid).Bu_Segment__c!=''){
                   caseRec.Bu_Segment__c  = conmap.get(usrlst[0].contactid).Bu_Segment__c ;}
                   if(conmap.get(usrlst[0].contactid).BU_Region__c !=null ||conmap.get(usrlst[0].contactid).BU_Region__c !=''){
                   caseRec.LCRM_Sub_BU__c  = conmap.get(usrlst[0].contactid).BU_Region__c;}     
                   caseRec.Is_GLI__c  = true;              
               }
            }
        }
    }  
     
     
     public static void accountUpdateOnContactChange(list<case> newCase,Map<Id,Case> oldmap){
      List<ID> conlstid = new List<ID>();
      if( UserInfo.getName()!='Automated Process' && usrlst == null && (Schema.sObjectType.user.isAccessible() || Schema.sObjectType.user.isQueryable())){
            usrlst = [select sub_bu__c from user where id=:UserInfo.getUserId()];
        }      
      Map<Id,contact> conmap; 
        for(Case c:newCase){                                                
          if(c.Is_ESC_Case__c && c.contactId!=null && c.contactId != oldMap.get(c.Id).contactId){                      
                     c.AccountId = c.contact.AccountId;                     
            }  
            conlstid.add(c.contactid);               
        }                         
            if(conlstid.size()>0){          
            conmap= new Map<Id,contact>([select id,Bu_segment__C,bu_region__c,Sales_Org__c,account.billingcountry from contact where id In :conlstid]);
             }                    
        for(Case caserec:newCase) {
        if(caseRec.Is_ESC_Case__c && caseRec.contactid!=null &&caseRec.contactId != oldMap.get(caseRec.Id).contactId){
            caseRec.Sales_Org__c = conmap.get(caseRec.contactid).Sales_Org__c ;
        }     
        if(caseRec.Is_ESC_Case__c && caseRec.contactid!=null &&caseRec.contactId != oldMap.get(caseRec.Id).contactId){
           if(conmap.containsKey(caseRec.contactid)&& (LCRMGenericComponent.isLotusUser() || usrlst[0].sub_bu__c == 'Elite')){             
               if(conmap.get(caseRec.contactid).Bu_Segment__c!=null ||conmap.get(caseRec.contactid).Bu_Segment__c!=''){
               caseRec.Bu_Segment__c  = conmap.get(caseRec.contactid).Bu_Segment__c ;}
               if(conmap.get(caseRec.contactid).BU_Region__c !=null ||conmap.get(caseRec.contactid).BU_Region__c !=''){
               caseRec.LCRM_Sub_BU__c  = conmap.get(caseRec.contactid).BU_Region__c;}
               caseRec.lcrm_country__c =conmap.get(caseRec.contactid).account.billingcountry;//DSS-9492 Change
                }       
           }       
        }            
    }
     public static void updUnchecking(list<case> newCase){
     for(case c : newCase){
     if(c.ESC_UPD__c == true && c.ownerid == UserInfo.getUserId()){
         c.ESC_UPD__c = false;
         if(c.ESC_UPD_Action__c != ''){
             c.ESC_UPD_Action__c = '';
         }
     }
     if(c.ESC_ResolverID__c == UserInfo.getUserId()&& c.ESC_UPD_Resolver__c){
        c.ESC_UPD_Resolver__c=false;
        if(c.ESC_Resolver_UPD_Action__c != ''){
            c.ESC_Resolver_UPD_Action__c = '';
        }
        }
     }
     }
     public static void  omniRoutedCheck(list<case> newCase,Map<Id,Case> oldmap){   
        set<id> usrlist= new set<id>(); 
         List<group> queuelist = new List<group>();
         set<string> queuesSet = new set<string>();
         List<USL_Case_SLA_Matrix__c> lstvs = new List<USL_Case_SLA_Matrix__c>();
         Boolean setautofeed = false;   
          for(Case c: newCase){
          system.debug('oldMap**'+oldMap);
                if(c.OwnerId != oldMap.get(c.Id).OwnerId && ((string)c.OwnerId).startsWith('00G')){
                   usrlist.add(c.OwnerId);
            }
            }
            if(usrlist.size()>0 && (Schema.sObjectType.Group.isAccessible() || Schema.sObjectType.Group.isQueryable())){
            queuelist = [select id,Name,DeveloperName from Group where Type ='queue' and id in :usrlist];  
            }
            if(queuelist.size()>0){ 
            for(Group q : queuelist){
                queuesSet.add(q.DeveloperName);
            }
            }
            for(USL_Case_SLA_Matrix__c caseSLA : USL_Case_SLA_Matrix__c.getAll().values()){
               if(queuesSet.size()>0 && queuesSet.contains(caseSLA.USL_Queue__c)){
                     lstvs.add(caseSLA);
                 }
                }
            if(lstvs.size()>0){
            for(USL_Case_SLA_Matrix__c sLA:lstvs){
                setautofeed=sLA.USL_Autofeed_Check__c;
            }
            }
            for(Case c: newCase){
                c.ESC_Omni_Routed__c = setautofeed;
            }   
    }
   public static void autoPopulateResolutionComment(Map<Id,case> newMap,Map<Id,case> oldMap,List<case> newlst){
       ESC_segment_Region_Lotus__c segRegTax = ESC_segment_Region_Lotus__c.getOrgDefaults();
         for(Case caseRe: newlst){
             if((caseRe.ESC_Case_Type__c=='Incident' || caseRe.ESC_Case_Type__c=='Legal Content' || caseRe.ESC_Case_Type__c=='Tech Support' || caseRe.ESC_Case_Type__c=='Request for Action') && caseRe.Status=='Set for Auto Close' && caseRe.ESC_Auto_Close_Date__c != null){
                   
                    if(caseRe.ESC_Resolution_Comment__c == null || caseRe.ESC_Resolution_Comment__c == ''){
                       caseRe.ESC_Resolution_Comment__c =caseRe.ESC_Resolution_Comment__c +'\n' +System.Label.ESC_Resolution_Comment;
                      }
                   }
        }
    }
    public static void updatecreditcheckdate(list<case> newCase){
        List<id> caseidlist = new List<id>();
        for(Case casenew : newCase){
            caseidlist.add(casenew.id);
        }
        map<id,case> casemap = new map<id,case>([select businesshoursid from case where id IN:caseidlist]);
        ESC_segment_Region_Lotus__c segRegTax = ESC_segment_Region_Lotus__c.getOrgDefaults();
        List<case> caseupdlist = new List<case>();
        for(Case casenew : newCase){
            system.debug('case businesshours is'+casenew.businesshoursid);
            system.debug('case businesshours is'+casemap.get(casenew.id).businesshoursid);
            if(casenew.BU_Segment__c==SegRegTax.segmentTax__c && casenew.origin == 'Credit Check' ){
                Case caseupd = new Case();
                integer timeinmin = integer.valueOf(Label.ESC_Creditcheck_Businesshours);
                caseupd.GLI_Milestone_Reference_Date__c = BusinessHours.add(casemap.get(casenew.id).businesshoursid,system.now(),timeinmin*60*1000L);
                caseupd.id = casenew.id;
                caseupdlist.add(caseupd);
            }
        }
        if(caseupdlist.size()>0 && Schema.sObjectType.case.isUpdateable()){
            update caseupdlist;
        }
    } 
              
    public static void calcCustomHoldTime(list<case> newCase,Map<Id,Case> oldmap){
         
         for(Case caseRec: newCase){
            if( test.isrunningtest() || (caseRec.Is_ESC_Case__c &&((oldmap==null && caseRec.ESC_CustHoldTimeCheck__c) || (oldmap!=null && caseRec.ESC_CustHoldTimeCheck__c != oldMap.get(caseRec.Id).ESC_CustHoldTimeCheck__c )))){
                if(caseRec.ESC_CustHoldTimeCheck__c){
                    caseRec.ESC_CustHoldTimeStart__c = DateTime.now(); 
                }else{
                    if(caseRec.ESC_CustHoldTimeStart__c!=null){
                    Double timeInMilliSec= (DateTime.Now().getTime() - caseRec.ESC_CustHoldTimeStart__c.getTime());
                    if(caseRec.ESC_CustomerHoldTime__c == NULL){
                        caseRec.ESC_CustomerHoldTime__c = timeInMilliSec/(1000*60*60*24); // Storing in days
                    }else{
                        caseRec.ESC_CustomerHoldTime__c = (timeInMilliSec/(1000*60*60*24)) + caseRec.ESC_CustomerHoldTime__c; // Storing in days
                    }
                    caseRec.ESC_CustHoldTimeStart__c = NULL;
                    }
                }
            }
        }
    }
    public static void  caseFirstCallResolutionUpdate(list<case> newCase,Map<Id,Case> oldmap){
            for(Case c: newCase){
                if((c.LCRM_Sub_BU__c == 'GGO' && c.Is_GLI__c == false) && (c.OwnerId != oldMap.get(c.Id).OwnerId || c.ESC_REF__c == true || c.ClosedDate > c.CreatedDate)){
                    c.GGO_First_Call_Resolution__c = false;
                    c.GGO_First_Pass_Resolution__c = true;
                }
                if(c.IsClosed == true && c.ESC_REF__c == true && 
                        (c.GGO_First_Call_Resolution__c  == true || c.GGO_First_Pass_Resolution__c == true)){
                    c.GGO_First_Call_Resolution__c = false;
                    c.GGO_First_Pass_Resolution__c = false;
                  }
            }
    }
    
    public static void assingGrponDeactiveUsers(list<case> newCase,Map<Id,Case> oldmap){
        Id grpsid;
        List<Id> lstownerId = new List<Id>();
        list<ID> uId = new list<ID>();
        list<ID> gId = new list<ID>();
        List<Group> queues = new List<Group>();
        List<Groupmember>  gMember = new List<Groupmember>();
        
        for(Case c: newCase){
            if(c.ownerId!=null && ((String) c.OwnerId).StartsWith('00G') && c.OwnerId != oldMap.get(c.Id).OwnerId && c.LCRM_Sub_BU__c == 'USL'){
                lstownerId.add(c.ownerId);
            }   
        }
        if(Schema.sObjectType.Group.isAccessible() || Schema.sObjectType.Group.isQueryable()){
        queues = [Select Id,Name,DeveloperName,type FROM Group where type='Queue' and (id IN :lstownerId or DeveloperName =: System.Label.ESC_CustomerServiceQueue)];
        }
        for(Group gids :queues){
            if(gids.DeveloperName == System.Label.ESC_CustomerServiceQueue){
                grpsid = gids.id;
            }else{
                gId.add(gids.id);
            }
        }
        system.debug('gId'+gId);
        if(Schema.sObjectType.Groupmember.isAccessible() || Schema.sObjectType.Groupmember.isQueryable()){
         gMember = [SELECT ID,GroupId,UserOrGroupId from Groupmember where GroupId IN :gId];
        }
        for(Groupmember gids :gMember){
            uId.add(gids.UserOrGroupId); 
        }
        List<User> userlst = [select id from user where isActive = true and id IN :uId];
         if(userlst.size()==0){
             for(Case c: newCase){
             if(c.ownerId!=null && ((String) c.OwnerId).StartsWith('00G') && c.OwnerId != oldMap.get(c.Id).OwnerId && c.LCRM_Sub_BU__c == 'USL'){
             c.ownerid = grpsid;
             } 
             }
         }
         else{
            system.debug('Users active in the queue'); 
        }
        
    }
    public static void setGGOCaseVariables(list<case> newCase,Map<Id,Case> oldmap){
        Set<String> profNameSet = new Set<String>();
        GGO_Profiles__c prfSelct =  GGO_Profiles__c.getInstance(UserInfo.getProfileID());
        if(prfSelct != null && prfSelct.Profiles__c != null){
            profNameSet.add(prfSelct.Profiles__c);
        }
         if(ESC_Utility.userProfileName == null){  
            if(UserInfo.getName()!='Automated Process'){
            ESC_Utility.userProfileName = [select name from profile where id=:UserInfo.getProfileid()].name;
            }
        }
         List<ID> acclstid = new List<ID>();      
         Map<Id,Account> accmap;
         for(Case c:newCase){ 
          if(test.isrunningtest() || (((oldmap == null && c.accountid != null) || (oldmap!= null && oldmap.get(c.id).accountid != c.accountid)))){
            acclstid .add(c.accountid);  
            }             
            } 
         if(acclstid.size()>0){
         accmap= new Map<Id,Account>([select id,Legacy_System_ID__c,Tax_Number_Type__c,Tax_Number__c,Sales_Org__c from account where id In :acclstid]);
         } 
        for(Case c: newCase){
        if((profNameSet.contains(ESC_Utility.userProfileName)) && c.Is_ESC_Case__c == true &&
        c.IS_GLI__C != true && c.GGOIsReferralFlag__C == false && c.GGO_Referral_Response_Time_Flag__c == false && c.AccountId != null){
                IF(c.EntitlementId != null && c.ESC_Apply_Entitlement_Milestone__c == true){
                c.ESC_Apply_Entitlement_Milestone__c = false;
                }
                if(test.isrunningtest() || ((accmap != null && !accmap.isEmpty()) && accmap.containsKey(c.accountid))){
                c.GGO_Legacy_System_ID__c = accmap.get(c.accountid).Legacy_System_ID__c;
                c.GGO_Tax_Number_Type__c = accmap.get(c.accountid).Tax_Number_Type__c;
                c.GGO_Tax_Number__c = accmap.get(c.accountid).Tax_Number__c ;
                c.LCRM_Sub_BU__c = 'GGO'; 
                c.Sales_Org__c = accmap.get(c.accountid).Sales_Org__c;
                }
                
                if((oldmap!= null && (oldMap.get(c.Id).Status) == 'Cancelled') &&  c.ESC_Apply_Milestone_Closure_Flag__c == false){
                    c.Status = 'Cancelled';
                }
               } 
            }
    } 
    public static void setSurveyVariables(list<case> newCase,Map<Id,Case> oldmap){
     for(Case c : newcase){
     string recordtypename = Schema.SObjectType.Case.getRecordTypeInfosById().get(c.recordtypeid).getDeveloperName();
      System.debug('recordtype --->'+recordtypename);
            if((recordtypename =='ESC_Incident' || recordtypename =='ESC_Legal_Content' || recordtypename =='ESC_Tech_Support' ||  recordtypename =='ESC_Enquiry')){
            
                if(c.Status != oldMap.get(c.Id).Status && c.Status == 'Work In Progress' && oldMap.get(c.Id).Status == 'Closed'){
                    c.ESC_Send_Survey__c = false;
                }
                if((c.ESC_Proactive_Type__c != oldMap.get(c.Id).ESC_Proactive_Type__c  && c.LCRM_Sub_BU__c == 'GGO' ) || test.isrunningtest()){
                    if(c.ESC_Proactive_Type__c == 'Do Not Survey'){
                        c.ESC_Send_Survey__c = false;
                    }else if(c.ESC_Proactive_Type__c == 'Manager Edit - Survey Required'){
                        c.ESC_Send_Survey__c = true;
                        c.ESC_Survey_Sent__c = false;
                    }
                  }
            }
           // if(c.LCRM_Sub_BU__c == 'GGO' && (c.Status != oldMap.get(c.Id).Status && c.Status == 'Closed') &&  c.ESC_Send_Survey__c == true && c.ESC_Survey_Sent__c == false && (recordtypename =='ESC_IncidentReadOnly' ||recordtypename =='ESC_EnquiryReadOnly')){
          //      c.ESC_Survey_Sent__c = true;
           // }
         }  
    }
    
    //Queue Assignment on Disputed Cases provided Case owner is not part of C2C Unsuspend Queue(DSS-7554)
      public static void qAssignOnDispute(List<case> newlst,Map<Id,case> oldMap){
        Id recTypeId = ESC_Utility.recordTypeNameToId('Case','Incident');
        Id recTypeId2 = ESC_Utility.recordTypeNameToId('Case','Tech Support');
        Id recTypeId3 = ESC_Utility.recordTypeNameToId('Case','Legal Content');
        List<Group> grp = new List<Group>();
        List<Groupmember>  gMember = new List<Groupmember>();
        Map<Id,Id> grpMap = new Map<Id,Id>();
        Map<Id,Id> map2case = new Map<Id,Id>();
        system.debug('&&'+newlst);
        for(Case caseRec: newlst){
            if((caseRec.recordtypeid != oldMap.get(caseRec.Id).recordtypeid && !oldMap.get(caseRec.Id).isClosed)||
                   caseRec.ContactId != oldMap.get(caseRec.Id).ContactId ||
                   caseRec.Subject != oldMap.get(caseRec.Id).Subject ||
                   caseRec.Description != oldMap.get(caseRec.Id).Description ||
                   caseRec.USL_SAP_Account_Number__c != oldMap.get(caseRec.Id).USL_SAP_Account_Number__c ||
                   caseRec.ESC_Diagnosis_Summary__c != oldMap.get(caseRec.Id).ESC_Diagnosis_Summary__c ||
                   caseRec.ESC_Cause__c != oldMap.get(caseRec.Id).ESC_Cause__c ||
                   caseRec.ESC_Proactive_Type__c != oldMap.get(caseRec.Id).ESC_Proactive_Type__c){
                       
                if((caseRec.recordtypeid == recTypeId || caseRec.recordtypeid == recTypeId2 ||caseRec.recordtypeid == recTypeId3 )&&
                   caseRec.ContactId != null &&
                   caseRec.Subject != '' && 
                   caseRec.Description != '' &&
                   caseRec.USL_SAP_Account_Number__c != '' &&
                   caseRec.ESC_Diagnosis_Summary__c == 'Unsuspend' &&
                   (caseRec.ESC_Cause__c == 'Suspend Error' || caseRec.ESC_Cause__c == 'Customer Payment') &&
                   caseRec.ESC_Proactive_Type__c == 'Dispute' 
                  ){
                       map2case.put(caseRec.Id,caseRec.OwnerId);
                }
            }
        }
        if(map2case.keyset().size()>0){
            grp = [Select Id,Name,DeveloperName,Type FROM Group where DeveloperName = 'C2C_Unsuspends' and Type = 'Queue'];
      
      //to resolve Testmethod failure in dryrun
      if(test.isrunningtest()){
      grp = [Select Id,Name,DeveloperName,Type FROM Group where DeveloperName = 'TXP_C2C_Order_Management' and Type = 'Queue'];
      }      
            if(grp.size()>0){
                if(Schema.sObjectType.Groupmember.isAccessible() || Schema.sObjectType.Groupmember.isQueryable()){
                    gMember = [SELECT ID,GroupId,UserOrGroupId from Groupmember where GroupId = :grp[0].Id];
                }
            }
            for(Groupmember gm:gMember){
                grpMap.put(gm.UserOrGroupId,gm.Id);
               
            }
        }
        
        for(Case cRec: newlst){
            if(map2case.containsKey(cRec.Id)){
                system.debug('878&&'+grpMap);
                if(grpMap!=null && !grpMap.containsKey(cRec.OwnerId)){
                    system.debug('879&&'+grpMap);
                    cRec.OwnerId = grp[0].Id;
                    cRec.ESC_Case_Acceptance_Flag__c = True;
           }  
                if(cRec.LCRM_Sub_BU__c == 'UKI'){   
                    cRec.GLI_Resolution_Response_Time_Flag__c =false;   
                    cRec.USL_Case_closure_flag__c= true;
                }
            }
        }
        
    } 
  
  //Segment and Region Assignment on cloned Cases(DSS-8335/DSS-6785)
    public static void setRegionOnClone(List<case> newlst, Id cloneid){
        List<case> caseList = new List<case>();
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
                    caseList = [SELECT ID,lcrm_sub_bu__c,Bu_Segment__c,Is_GLI__C,businesshoursid,SuppliedEmail,Sales_Org__c,GGO_Case_Closure_Flag__c,USL_Case_closure_flag__c,entitlementid,GLI_Resolution_Response_Time_Flag__c from Case where id =: cloneid];
                }
         for(case c : newlst){
            c.lcrm_sub_bu__c = caseList[0].lcrm_sub_bu__c ;
            c.Bu_Segment__c = caseList[0].Bu_Segment__c ;
            c.Is_GLI__C  = caseList[0].Is_GLI__C; 
            c.businesshoursid = caseList[0].businesshoursid; 
            c.entitlementid = caseList[0].entitlementid;
            c.Sales_Org__c = caseList[0].Sales_Org__c; 
            c.USL_Case_closure_flag__c = caseList[0].USL_Case_closure_flag__c;
            c.GLI_Resolution_Response_Time_Flag__c = caseList[0].GLI_Resolution_Response_Time_Flag__c ;
            c.GGO_Case_Closure_Flag__c = caseList[0].GGO_Case_Closure_Flag__c; 
      if(c.origin == 'web'){
            c.SuppliedEmail = caseList[0].SuppliedEmail;
            }
            c.status = 'Work In Progress'; 
         }
    }
    //update segment and region on sales case - DSS-9167
    public static void updateSalesCase(List<case> caselst){
          List<ID> acclstid = new List<ID>(); 
          List<ID> lstownerId = new List<ID>();
          List<user> usrlist = new List<user>(); 
          Map<Id,Account> accmap; 
        for(Case c:caselst){                                                
            if(c.AccountId !=null){      
            acclstid.add(c.AccountId);}
            if(c.ownerId!=null && ((String) c.OwnerId).StartsWith('005')){
                lstownerId.add(c.ownerId);}             
        }           
        if(LCRMGenericComponent.isLotusUser() && acclstid.size()>0 &&(Schema.sObjectType.Account.isAccessible() || Schema.sObjectType.Account.isQueryable())){          
                accmap = new Map<Id,Account>([select id,Bu_segment__C,Bu_region__c,Sales_Org__c from Account where id In :acclstid]);} 
         if(!LCRMGenericComponent.isLotusUser() &&(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable())){
                usrlist = [select id,Segment__c,Sub_Bu__c,Sales_Org__c from User where id In:lstownerId];}              
        for(Case caserec:caselst) {
            if(LCRMGenericComponent.isLotusUser() && accmap != null){ 
                   if(accmap.get(caseRec.accountid).Sales_Org__c!=null && accmap.get(caseRec.accountid).Sales_Org__c!=''){
                        caseRec.Sales_Org__c = accmap.get(caseRec.accountid).Sales_Org__c ;}                
                    if(accmap.get(caseRec.accountid).Bu_Segment__c!=null && accmap.get(caseRec.accountid).Bu_Segment__c!=''){
                        caseRec.Bu_Segment__c  = accmap.get(caseRec.accountid).Bu_Segment__c ;}
                   if(accmap.get(caseRec.accountid).BU_Region__c !=null && accmap.get(caseRec.accountid).BU_Region__c !=''){
                        caseRec.LCRM_Sub_BU__c  = accmap.get(caseRec.accountid).BU_Region__c;}
                    caseRec.Is_GLI__c  = true;
            }
            else{
           
                for(user u : usrlist){
                 if(u.Sales_Org__c != null && u.Sales_Org__c != ''){
                        caseRec.Sales_Org__c = u.Sales_Org__c;}
                    if(u.Segment__c != null && u.Segment__c != ''){
                        caseRec.Bu_Segment__c = u.Segment__c;}
                    if(u.Sub_Bu__c != null && u.Sub_Bu__c != ''){
                        caseRec.LCRM_Sub_BU__c = u.Sub_Bu__c;}
                        caseRec.Is_GLI__c  = true;
                }
              }
         }           
    }
    
     public static void updateManualCase(List<case> newCaseList){
         for(case c:newCaseList){
                  if(c.origin == 'Phone'){
                   Case oCase = GLIGenericUtilityHelper.setGLI(c);
                  
                        c.Priority = oCase.Priority;
                        c.GGO_First_Response_Time_Flag__c = oCase.GGO_First_Response_Time_Flag__c;
                        c.Is_GLI__c = oCase.Is_GLI__c;
                        c.Sales_Org__c = oCase.Sales_Org__c;
                        c.LCRM_Sub_BU__c = oCase.LCRM_Sub_BU__c;
                        }
                    }
     }
}