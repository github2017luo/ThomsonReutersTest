/**
 * @description ESC_ChatUtility
 */
public  without sharing Class ESC_ChatUtility{
     /**
   * @description changeCaseOwnerTransfer 
   * @param newlst
   * @param oldMap
   */
    public static void changeCaseOwnerTransfer(List<LiveChatTranscript> newlst,Map<id,LiveChatTranscript> oldMap){
    List<Case> lstupdateCase = new List<Case>();
    Set<Id> relatedCaseIds = new Set<Id>();
    Map<Id,Id> mapOwnership = new Map<Id,Id>();
    Map<Id,Id> mapcasebuttonId = new Map<Id,Id>();
        Map<Id,String> mapsalesrep = new Map<Id,String>();
    List<Id> lstusrid = new List<Id>();
     Map<Id,User> usrMap;
    Map<String,User> maprep = new Map<String,User>();
     Map<Id,Case> caseMap;
     system.debug(logginglevel.warn,'transcript:newlst'+newlst);
     system.debug(logginglevel.warn,'transcript:newlst'+userinfo.getusername());
        for(LiveChatTranscript transcript:newlst) {
           if(transcript.id!=null && oldMap.containsKey(transcript.id))
           {
            if(transcript.ownerid != oldMap.get(transcript.id).ownerId){
            relatedCaseIds.add(transcript.caseId);
            mapOwnership.put(transcript.caseId,transcript.ownerId);
            }          
            else if(transcript.caseId != null && transcript.ownerid != null && ((String)transcript.ownerid).startsWith('005') && transcript.status!='Completed'){
            relatedCaseIds.add(transcript.caseId);
            //lstusrid.add(transcript.ownerid);
            mapOwnership.put(transcript.caseId,transcript.ownerId);
            mapcasebuttonId.put(transcript.caseId,transcript.LiveChatButtonId);
                    if(transcript.ESC_GSI_SalesPerson__c!=null){
                        mapsalesrep.put(transcript.caseId,transcript.ESC_GSI_SalesPerson__c);
                    }
                }
            }
            lstusrid.add(transcript.ownerid);
        }
        if(lstusrid.size()>0){
            usrMap = new Map<Id,User>([select id,Division,Department,Email,isActive,Manager.Email,ManagerId,Regional_Mgr__c, Sales_Org__c,Segment__c,Sub_Bu__c,Default_Catalog__c, Rep_Type_Description__c,profileid,profile.name,FederationIdentifier from User where id in :lstusrid or FederationIdentifier in:mapsalesrep.values()]);
        }
        for(User u:usrMap.values()){
        if(u.FederationIdentifier!=null){
            maprep.put(u.FederationIdentifier,u);
            }
        }
       
        if(relatedCaseIds.size()> 0){
            caseMap = new Map<Id,Case>([select id,casenumber,status from case where id in:relatedCaseIds]);
        }
        system.debug(logginglevel.warn,'caseMap&&&'+caseMap);
        if(relatedCaseIds.size()> 0)
        {
           for(Id cid:relatedCaseIds){
           Case c =new Case();
           c.id =cid;
           c.Origin = 'Chat';
           //c.ownerid = mapOwnership.get(cid);
           //Added for Commissions Cases of Chat
           system.debug(logginglevel.warn,'mapcasebuttonId'+mapcasebuttonId);
                if(mapcasebuttonId.get(cid) == label.ESC_CommissionBtnId  ){
                /* ||
                   mapcasebuttonId.get(cid) == label.ESC_GSI_comission_Chat ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Commissions_Chat ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Comp_Exceptions_SCS ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Customer_Service ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Finance ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Order_Fulfillment ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Payments ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Renewals ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Territories ||
                    mapcasebuttonId.get(cid) == label.Inquiry_Manager */
                    system.debug(logginglevel.warn,'inside mapbuttonid');
                        if(caseMap.get(cid).status=='New'){
                system.debug(logginglevel.warn,'inside buttonid');
                c.ownerid = mapOwnership.get(cid);
                c.status= 'Open';
                //c.Origin = 'Chat';
                c.recordtypeid = '01213000001CEU8';
                 if(mapsalesrep.get(cid)!=null && maprep.get(mapsalesrep.get(cid))!=null){
                        c.Salesperson__c = maprep.get(mapsalesrep.get(cid)).id;
                        c.ESC_GSI_Salesperson_Email__c = maprep.get(mapsalesrep.get(cid)).Email;
                        c.Sales_Org__c = maprep.get(mapsalesrep.get(cid)).Sales_Org__c;
                        c.LCRM_Sub_BU__c = maprep.get(mapsalesrep.get(cid)).Sub_Bu__c;
                        c.BU_Segment__c = maprep.get(mapsalesrep.get(cid)).Segment__c;
                        c.ESC_Default_Catalog__c = maprep.get(mapsalesrep.get(cid)).Default_Catalog__c;
                      }
               
                  
                        }
           }else{
               c.ownerid = mapOwnership.get(cid);
               c.ESC_Omni_Routed__c=True;
               if(!usrMap.isEmpty()){
                   c.ESC_Case_Owner_Role_Static__c = usrMap.get(c.OwnerId).Division;
                   c.ESC_Case_Owner_Team__c = usrMap.get(c.OwnerId).Department;
                   c.Manager__c = (Id) usrMap.get(c.OwnerId).ManagerId;
                   c.Case_Owner_Manager_Email__c = usrMap.get(c.OwnerId).Manager.Email;
               }
           }
           if(((String)c.ownerid).startsWith('005')){
                   lstupdateCase.add(c);
           }
           }
           system.debug(logginglevel.warn,'lstupdateCaseid' + lstupdateCase);
        }
        if(lstupdateCase.size()>0){
        system.debug(logginglevel.warn,'lstupdateCaseid' + lstupdateCase);
            update lstupdateCase;
        }
        if(lstupdateCase.size()>0 && lstupdateCase[0].ESC_Omni_Routed__c==True){
        lstupdateCase[0].ESC_Omni_Routed__c= False;
            update lstupdateCase;
        }
    }
}