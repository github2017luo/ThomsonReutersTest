public without sharing class USL_ResponseTimeCalculator{

    @InvocableMethod(label='USL Case Entitlment Respones Time Calc_1234')
    public static void getCaseResponseTime(List<Case> cases){
    
        if(cases == null || cases.isEmpty())
            return;
            
             // added as Jira DSS-6256 Tax profesional
              ESC_segment_Region_Lotus__c SegReg = ESC_segment_Region_Lotus__c.getOrgDefaults();
              
        List<String> caselst= new List<String>();
        List<String> caseusrlst= new List<String>();
        List<String> queuelst= new List<String>();     
        List<String> actIdlst= new List<String>();
        List<Group> QueueName=new List<Group>();
        List<User> userlist = new List<User>();
        List<String> Casequeue= new List<String>();
        List<Case> lstupdatecase = new List<case>();
        List<String> ReferralQueuelst = new List<String>();
        List<Boolean> IsReferalFlag = new List<Boolean>();
        set<string> primaryQueue = new set<string>();
        //List<USL_Case_SLA_Matrix__c> lstvs;
        Boolean setautofeed;
        //Boolean manualautofeed = false;
        Boolean inRole = false;
         List<Group> grplstvs;
     //   string AccountProjVSeg= 'Non Project V';      
        Id referralbusinesshrid;
        Id closurebusinesshrid;
        
 
        Set<String> roleList = new Set<String>();  
        for(USL_Roles_Static_CC_Milestone__c rv : USL_Roles_Static_CC_Milestone__c.getAll().values()) {
           roleList.add(rv.Rolename__c);
        }
        
        
        system.debug('CaseList'+cases);
        for(Case si:cases){
                system.debug('si.Owner.Name'+si.Owner.Name);
                if(((string)si.OwnerId).startsWith('00G')){
               caselst.add(si.OwnerId);
               }
               else{
                   caseusrlst.add(si.OwnerId);
                   }
                system.debug('caselst'+caselst);        
            if(si.GGOIsReferralFlag__c){
               ReferralQueuelst.add(si.GGO_Referral_Milestone_Type__c);
               IsReferalFlag.add(si.GGOIsReferralFlag__c);
            }
            if(si.ESC_Case_Owner_Team__c != null && si.ESC_Case_Owner_Team__c !=''){
            primaryQueue.add(si.ESC_Case_Owner_Team__c);
            }
        }
        
         system.debug('ReferralQueuelst is'+ReferralQueuelst );
        if(caselst.size()>0 && (Schema.sObjectType.Group.isAccessible()|| Schema.sObjectType.Group.isQueryable())){
            QueueName= [select DeveloperName,Id from Group where id IN :caselst];
            }
         if(caseusrlst.size()>0 && (Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable())){
            userlist =[select Id,UserRole.DeveloperName from User where id IN : caseusrlst];
            }  
        if(QueueName.size()>0){    
        for(Group Q:QueueName){
            if(Q.DeveloperName!=null){
                Casequeue.add(Q.DeveloperName);
                system.debug('Casequeue'+Casequeue);
                
            }
        }
        }
        if(userlist.size()>0){ 
        for(user u : userlist){
         if(roleList.contains(u.UserRole.DeveloperName)){
          inRole= true;
         }
        }
        } 

        List<group> queuelist = new List<group>();
        if(primaryQueue.size()>0 && (Schema.sObjectType.Group.isAccessible() || Schema.sObjectType.Group.isQueryable())){
           queuelist = [select id,Name,DeveloperName from Group where Type ='queue' and Name in :primaryQueue];
        }
        system.debug('queuelistis : ' + queuelist);
        set<string> queuesSet = new set<string>();
        for(Group q : queuelist){
            queuesSet.add(q.DeveloperName);
        }
        List<USL_Case_SLA_Matrix__c> lstvs = new List<USL_Case_SLA_Matrix__c>();
        Integer SLAmins;
        for(case c : cases){
            //if((c.origin == 'Phone' || c.origin =='Chat') &&  ((String)c.OwnerID).startsWith('005') && inRole && c.ESC_LastQueueOwner__c == null &&!(c.GGOIsReferralFlag__c))
              // added as Jira DSS-6256 Tax profesional
              //added getCloneSourceId() for DSS--8335/DSS-6785
             if((( c.BU_Segment__c != SegReg.SegmentTax__c || c.BU_Segment__c == null || c.BU_Segment__c =='') &&(c.origin == 'Phone' || c.origin =='Chat' || c.getCloneSourceId() != null) &&  ((String)c.OwnerID).startsWith('005') && inRole && c.ESC_LastQueueOwner__c == null &&!(c.GGOIsReferralFlag__c)) || ( c.BU_Segment__c == SegReg.SegmentTax__c && (c.origin == 'Phone' || c.getCloneSourceId() != null) &&  ((String)c.OwnerID).startsWith('005') && inRole && c.ESC_LastQueueOwner__c == null &&!(c.GGOIsReferralFlag__c))){
             system.debug('ESC_LastQueueOwner__c--->' + c.ESC_LastQueueOwner__c);
             system.debug('rolelist--->' +rolelist);
             system.debug('c.owner.UserRole.DeveloperName--->' + c.owner.UserRole.DeveloperName);
           // manualautofeed = true;
             //if(!((String)c.ESC_LastQueueOwner__c).startsWith('00G') || c.ESC_LastQueueOwner__c=='' || c.ESC_LastQueueOwner__c == null){
            for(USL_Case_SLA_Matrix__c caseSLA : USL_Case_SLA_Matrix__c.getAll().values()){
                    if(queuesSet.size()>0 && queuesSet.contains(caseSLA.USL_Queue__c)){
                        lstvs.add(caseSLA);
                    }
                }
               // }
            }
            else if(((String)c.OwnerID).startsWith('00G') &&!(c.GGOIsReferralFlag__c)){ 
            
                for(USL_Case_SLA_Matrix__c caseSLA : USL_Case_SLA_Matrix__c.getAll().values()){
                        if(Casequeue.size()>0 && Casequeue.contains(caseSLA.USL_Queue__c)){
                        lstvs.add(caseSLA);
                    }
                    
                }
             }
             if(IsReferalFlag.Size()>0){
             
                    for(USL_Case_SLA_Matrix__c caseSLA : USL_Case_SLA_Matrix__c.getAll().values()){
                        if(ReferralQueuelst.size()>0 && ReferralQueuelst.contains(caseSLA.USL_Queue__c)){
                        lstvs.add(caseSLA);
                        }
                    }   
                }
                
        }
 
        Integer referralSLAmins;
        for(USL_Case_SLA_Matrix__c SLA:lstvs){
            if(SLA.USL_SLA_Minutes__c!=null){
                SLAmins = Integer.valueOf(SLA.USL_SLA_Minutes__c);
                
                //Defaulting the referral SLA to closure time, incase referral time is blank, then closure time will
                //be picked as referral time.
                referralSLAmins = Integer.valueOf(SLA.USL_SLA_Minutes__c); 
                 system.debug('SLA mins is'+SLAMins);
            }
            if(SLA.USL_Referral_SLA_Minutes__c !=null){
                referralSLAmins = Integer.valueOf(SLA.USL_Referral_SLA_Minutes__c);
            }
            if(SLA.USL_Autofeed_Check__c==false)
            {
                setautofeed=SLA.USL_Autofeed_Check__c;
            }
           // else if(manualautofeed) {
              //  setautofeed=false;

            //}
            else{
                setautofeed=true;

            }
             system.debug('SLA mins is'+SLAMins);
        }
        system.debug('SLA mins is'+SLAMins);
       

        if(lstvs.size()>0){
             
             for(Case c:cases){
             Case cs=new Case();
              cs.id=c.id;
                 if(IsReferalFlag.Size()>0){
                     referralbusinesshrid = c.BusinessHoursId;
                     system.debug('referral business id'+referralbusinesshrid);                
                     cs.GGO_Referral_Response_Time__c = businesshours.add(referralbusinesshrid,System.now(),referralSLAmins*60*1000L);
                     cs.USL_Case_closure_flag__c =true;
                 }
                 else {
                     closurebusinesshrid = c.BusinessHoursId;                     
                     system.debug('case ckosure business id'+closurebusinesshrid );                   
                     if(c.Bu_Segment__c==SegReg.SegmentTax__c && c.Origin=='Chat'){
                     cs.GGO_Case_Response_Time__c=businesshours.add(closurebusinesshrid,System.now(),SLAMins*60*1000L);
                     }
                     else
                     {
                     cs.GGO_Case_Response_Time__c=businesshours.add(closurebusinesshrid,c.CreatedDate,SLAMins*60*1000L);
                     }
                    // cs.ESC_CustHoldTimeCheck__c=true;
                     cs.ESC_Omni_Routed__c=setautofeed;
                     system.debug('++issetautofeed'+setautofeed);
                     cs.USL_Case_closure_flag__c =true;
                    }
                    //system.debug('ESC_CustHoldTimeCheck'+cs.ESC_CustHoldTimeCheck__c);
                lstupdatecase.add(cs);
            
            }
        }
    if(lstupdatecase.size()>0){
        if (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable()){
        update lstupdatecase;
        }
    }
}
}