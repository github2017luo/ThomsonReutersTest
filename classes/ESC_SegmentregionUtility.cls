public without sharing class ESC_SegmentregionUtility{
public static String getDetailInfo(id recid, String param){
    
    List<ESCSegmentRegionMappingSet__c> lstSegment = new List<ESCSegmentRegionMappingSet__c>();
    List<Contact> conlst = new List<Contact>();
    List<Case> caslst = new List<Case>();
    List<User> lstusr = new List<User>();
    lstusr = [select id,Sub_Bu__c,Segment__c from user where id=:Userinfo.getuserid()];
    String usrrolename = '';
    if(param == 'BusHrs' || param =='Rectype'){
        conlst = [select id,BU_Segment__c,BU_Region__c from contact where id=:recid];
        
        if (Schema.sObjectType.UserRole.isAccessible()){
          usrrolename = [SELECT Id,DeveloperName,Name FROM UserRole WHERE Id=:UserInfo.getUserRoleId()].DeveloperName;
        }
    }else if(param =='OrgEmailAdd'){
        caslst = [select id,BU_Segment__c,LCRM_Sub_BU__c from case where id=:recid];
    }
    
    
    
    String curUserTimeZone = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId()].TimeZoneSidKey;
    

    string temp ='';
    if(LCRMGenericComponent.isLotusUser()){
    temp = param =='OrgEmailAdd'?((caslst[0].BU_Segment__c!=''?caslst[0].BU_Segment__c:'')+(caslst[0].LCRM_Sub_BU__c!=''?caslst[0].LCRM_Sub_BU__c:'')+curUserTimeZone):((conlst[0].BU_Segment__c!=null?conlst[0].BU_Segment__c:'')+(conlst[0].BU_Region__c!=''?conlst[0].BU_Region__c:'')+curUserTimeZone);
    }else{
    temp = param =='OrgEmailAdd'?((caslst[0].BU_Segment__c!=''?caslst[0].BU_Segment__c:'')+(caslst[0].LCRM_Sub_BU__c!=''?caslst[0].LCRM_Sub_BU__c:'')+
        curUserTimeZone):((lstusr[0].Segment__c!=null?lstusr[0].Segment__c:'')+(lstusr[0].Sub_Bu__c!=null?lstusr[0].Sub_Bu__c:'')+curUserTimeZone);
    }
    system.debug('temp***'+temp);
    lstSegment = [select id,name,ESC_BusHours__c,ESC_LKP__c,ESC_OrgWideDisplayName__c,ESC_IsRecType_BusHours__c,ESC_Region__c,ESC_Segment__c,ESC_Timezones__c,ESC_Role__c,ESC_Recordtype__c from ESCSegmentRegionMappingSet__c where ESC_LKP__c=:temp And ESC_IsRecType_BusHours__c='Record Type'];
    system.debug('temp***'+lstSegment);
    if(lstSegment.size()>0){
    for(ESCSegmentRegionMappingSet__c esc:lstSegment){
        if(LCRMGenericComponent.isLotusUser()){
            if(param == 'BusHrs'){
                return esc.ESC_BusHours__c;
            } 
        }
        if(param == 'OrgEmailAdd'){
                return esc.ESC_OrgWideDisplayName__c;
        }
        else if(param =='Rectype'){
            List<String> rolelst = new List<String>();
            if(esc.ESC_Role__c!=null){
            rolelst.addall(esc.ESC_Role__c.split(','));
            }
            if(usrrolename!='' && rolelst.size()>0 && rolelst.contains(usrrolename)){
            return esc.ESC_Recordtype__c;
            }
        }
        
        }
        
        
    }
return '';    
}

}