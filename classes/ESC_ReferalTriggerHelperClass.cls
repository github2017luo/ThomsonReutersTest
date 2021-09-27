/**********************************
Class Name: ESC_ReferalTriggerHelperClass
Purpose:
Author:Mousumi Panda
Date Created:20/06/2017
Date Updated:V0:
*******************************************************************************
Date Modified    Modified By            Change
11/8/2020        Deepika Motamarri      Added condition to By-Pass updating Case 
                                        for UE cases
17/8/2020        Herin Acharya          Added condition to fix PMD Rule ApexCRUDViolation
                                        in getQueue() method
*******************************************************************************/

public without sharing Class ESC_ReferalTriggerHelperClass{
    public static boolean isInsertContext = false;
    private static boolean runTriggerCaseChatterPostforRejectedReferral = true; 
    public static List<CaseTeamRole> caseTeamRolelst = new List<CaseTeamRole>();
    public Static Map<Id,User> mapuser = new Map<Id,User>();
    public static Map<String,id> caseteamtileMaps = new Map<String,id>();
    private static Boolean isFromInboundEmail;
    private static Map<string,string> emailsFromAddressMap;
    @TestVisible public static Boolean isInLightning = UserInfo.getUiThemeDisplayed() == 'Theme4t' || UserInfo.getUiThemeDisplayed() =='Theme4d';
    static set<string> activeReferralStatuses = new set<string>{'New' , 'Accepted','In Progress'};
        //Filter records before executing the operation
        //For Owner and Role change
        public static void addremoveOwnerToCaseTeamFilter(Map<id,ESC_Case_Collaborator__c> newreferralMap,Map<id,ESC_Case_Collaborator__c> oldreferralMap){
            List<ESC_Case_Collaborator__c> listRefNew = new List<ESC_Case_Collaborator__c>();
            List<ESC_Case_Collaborator__c> listRefold = new List<ESC_Case_Collaborator__c>();
            for(id refid:newreferralMap.keyset()){
                if((newreferralMap.get(refid).Ownerid != oldreferralMap.get(refid).Ownerid) || (newreferralMap.get(refid).ESC_Role__c!= oldreferralMap.get(refid).ESC_Role__c)){
                    listRefNew.add(newreferralMap.get(refid));
                    listRefold.add(oldreferralMap.get(refid));
                }
            }
            addremoveOwnerToCaseTeam(listRefNew, listRefold);
            //ESC_ReferalTriggerHelperClass.removeOwnerToCaseTeam(trigger.new, trigger.old);
            
            
        }
    
    //Enddating Accountable Resolver
    public static void endDatingOldReferralFilter(Map<id,ESC_Case_Collaborator__c> newreferralMap,Map<id,ESC_Case_Collaborator__c> oldreferralMap){
        List<ESC_Case_Collaborator__c> listRefNew = new List<ESC_Case_Collaborator__c>();
        for(id refid:newreferralMap.keyset()){
            if(newreferralMap.get(refid).ESC_Role__c!= oldreferralMap.get(refid).ESC_Role__c){
                listRefNew.add(newreferralMap.get(refid));
            }
        }
        EndDatingOldReferral(listRefNew);
        //ESC_ReferalTriggerHelperClass.removeOwnerToCaseTeam(trigger.new, trigger.old);
        
        
    }
    
    
    
    
    //******************************************************************
    public static void addremoveOwnerToCaseTeam(List<ESC_Case_Collaborator__c> newreferralList,List<ESC_Case_Collaborator__c> oldreferralList){
        try{
            if(newreferralList != null){
                Map<Id,List<ESC_Case_Collaborator__c>> mapcaseIdRefRec = new Map<Id,List<ESC_Case_Collaborator__c>>();
                for(ESC_Case_Collaborator__c ref:newreferralList){
                    string refOwnerId=ref.OwnerId;
                    if(refOwnerId.substring(0,3)=='005'){
                        List<ESC_Case_Collaborator__c> listRef = new List<ESC_Case_Collaborator__c>();
                        if (mapcaseIdRefRec.containsKey(ref.ESC_Case__c))
                        {
                            listRef =mapcaseIdRefRec.get(ref.ESC_Case__c);
                        }
                        listRef.add(ref);
                        mapcaseIdRefRec.put(ref.ESC_Case__c,listRef);
                    }
                    
                }
                
                Map<id,List<CaseTeamMember>> mapCaseIdListTeammem= new Map<id,List<CaseTeamMember>>();
                for(CaseTeamMember casetm: [SELECT Id,MemberId,ParentId,TeamRole.Name FROM CaseTeamMember WHERE ParentId IN: mapcaseIdRefRec.keyset()]){
                    string memId=casetm.MemberId;
                    
                    if(memId.substring(0,3)=='005'){
                        List<CaseTeamMember> listTeamMem = new List<CaseTeamMember>();
                        if(mapCaseIdListTeammem.containsKey(casetm.ParentId))
                        {
                            listTeamMem=mapCaseIdListTeammem.get(casetm.ParentId);
                        }
                        listTeamMem.add(casetm);
                        mapCaseIdListTeammem.put(casetm.ParentId,listTeamMem);
                        
                    }
                    
                }
                
                
                system.debug('mapCaseIdListTeammem****'+mapCaseIdListTeammem);
                
                Map<String,id> caseteamtileMap = getCaseteamRoles();
                system.debug('CaseteamtileMap****'+caseteamtileMap);
                List<CaseTeamMember> listInsert = new List<CaseTeamMember>();
                List<CaseTeamMember> listUpdateRole = new List<CaseTeamMember>();
                for(Id casId: mapcaseIdRefRec.keyset()){
                    for(ESC_Case_Collaborator__c ref : mapcaseIdRefRec.get(casId)){
                        Boolean isAlreadyAdded = false;
                        system.debug('isAlreadyAdded****1***'+isAlreadyAdded);
                        if(mapCaseIdListTeammem != null && !mapCaseIdListTeammem.isEmpty()){ 
                            for(CaseTeamMember cst: mapCaseIdListTeammem.get(casId)){
                                if(ref.OwnerId==cst.MemberId){
                                    if (ref.ESC_Role__c!=cst.TeamRole.Name){
                                        cst.TeamRoleId=caseteamtileMap.get(ref.ESC_Role__c);
                                        listUpdateRole.add(cst);
                                    }
                                    isAlreadyAdded=true;
                                    break;
                                }
                                
                            }}
                        system.debug('isAlreadyAdded****2***'+isAlreadyAdded);
                        
                        if(isAlreadyAdded == false){
                            CaseTeamMember obj= new CaseTeamMember();
                            obj.ParentId=ref.ESC_Case__c;
                            obj.MemberId=ref.OwnerId;
                            if(caseteamtileMap != null && !caseteamtileMap.isEmpty() && caseteamtileMap.get(ref.ESC_Role__c) != null){
                                obj.TeamRoleId=caseteamtileMap.get(ref.ESC_Role__c);}
                            else{
                                obj.TeamRoleId=caseteamtileMap.get('Accountable Resolver');
                            }
                            listInsert.add(obj);
                        }
                        
                        
                    }
                    
                }
                system.debug('listInsert******'+listInsert);
                if(listInsert.size()>0 && (Schema.sObjectType.CaseTeamMember.isAccessible() || Schema.sObjectType.CaseTeamMember.isCreateable())){
                    
                    insert listInsert;
                }
                if(listUpdateRole.size()>0 && (Schema.sObjectType.CaseTeamMember.isAccessible() || Schema.sObjectType.CaseTeamMember.isUpdateable())){
                    update listUpdateRole;
                }
            }
            
            //To handle Update of Referral Owner
            
            if(oldreferralList != null){
                Map<Id,List<ESC_Case_Collaborator__c>> mapcaseIdoldRefRec = new Map<Id,List<ESC_Case_Collaborator__c>>();
                //Map<Id,List<Id>> MapcaseIdOwnerId = new Map<Id,List<Id>>();
                for(ESC_Case_Collaborator__c ref:oldreferralList){
                    string refOldOwnerId=ref.OwnerId;
                    if(refOldOwnerId.substring(0,3)=='005'){
                        List<ESC_Case_Collaborator__c> listRef = new List<ESC_Case_Collaborator__c>();
                        if (mapcaseIdoldRefRec.containsKey(ref.ESC_Case__c))
                        {
                            listRef =mapcaseIdoldRefRec.get(ref.ESC_Case__c);
                        }
                        listRef.add(ref);
                        mapcaseIdoldRefRec.put(ref.ESC_Case__c,listRef);
                        
                    }
                    
                }
                
                
                Map<id,List<ESC_Case_Collaborator__c>> mapCaseIdexistingRefList= new Map<id,List<ESC_Case_Collaborator__c>>();
                for(ESC_Case_Collaborator__c ref: [SELECT Id,ESC_Role__c,OwnerId,ESC_Case__c,ESC_End_Date__c FROM ESC_Case_Collaborator__c WHERE ESC_Case__c IN: mapcaseIdoldRefRec.keyset()]){
                    string memId=ref.OwnerId;
                    
                    if(memId.substring(0,3)=='005'){
                        List<ESC_Case_Collaborator__c> listRefMem = new List<ESC_Case_Collaborator__c>();
                        if(mapCaseIdexistingRefList.containsKey(ref.ESC_Case__c))
                        {
                            listRefMem =mapCaseIdexistingRefList.get(ref.ESC_Case__c);
                        }
                        listRefMem.add(ref);
                        mapCaseIdexistingRefList.put(ref.ESC_Case__c,listRefMem);
                        
                    }
                    
                }
                
                
                system.debug('oldreferralList*****'+oldreferralList);
                system.debug('mapCaseIdexistingRefList*****'+mapCaseIdexistingRefList);
                
                List<CaseTeamMember> listCaseTeamDelete= new List<CaseTeamMember>();
                Map<id,id> caseiddeleteCaseTeamids= new Map<id,id>();
                for(Id casId: mapCaseIdexistingRefList.keyset()){
                    for(ESC_Case_Collaborator__c delRef: mapcaseIdoldRefRec.get(casId)){
                        Boolean userexist= false;
                        for(ESC_Case_Collaborator__c ref: mapCaseIdexistingRefList.get(casId)){
                            system.debug('ref.ESC_Role__c*****'+ref.ESC_Role__c);
                            system.debug('ref.ESC_End_Date__c*****'+ref.ESC_End_Date__c);
                            if(ref.OwnerId == delRef.OwnerId && (ref.ESC_Role__c != 'Accountable Resolver' && ref.ESC_End_Date__c == null)){
                                userexist= true;
                                break;
                            }
                        }
                        if(userexist== false){
                            caseiddeleteCaseTeamids.put(delRef.ESC_Case__c,delRef.OwnerId);
                            system.debug('CaseiddeleteCaseTeamids*****'+caseiddeleteCaseTeamids);
                        }
                        
                    }
                    
                }
                
                for(CaseTeamMember ctm: [SELECT Id,MemberId,ParentId,TeamRole.Name FROM CaseTeamMember WHERE ParentId IN: caseiddeleteCaseTeamids.keyset()]){
                    if(ctm.MemberId == caseiddeleteCaseTeamids.get(ctm.ParentId)){
                        listCaseTeamDelete.add(ctm);
                    }
                }
                if(Schema.sObjectType.CaseTeamMember.isAccessible() || Schema.sObjectType.CaseTeamMember.isDeletable()){
                    delete listCaseTeamDelete;
                }
            }
        }catch(exception ex){
            system.debug('Exception:'+ex);
        }
    }
    
    
    
    public static void endDatingOldReferral(List<ESC_Case_Collaborator__c> newreferralList){
        list<id> caseids= new list<id>();
        list<ESC_Case_Collaborator__c> endDatingReferral= new list<ESC_Case_Collaborator__c>();
        for(ESC_Case_Collaborator__c ecc: newreferralList){
            if(ecc.ESC_Role__c=='Accountable Resolver'){
                caseids.add(ecc.ESC_Case__C);
            }
        }
        for(ESC_Case_Collaborator__c  existingAccResolver :[SELECT Id,ESC_Role__c,OwnerId,ESC_Case__c,ESC_End_Date__c,ESC_Form_Id__c,ESC_Case__r.LCRM_Sub_BU__c,ESC_Case__r.Is_GLI__c FROM ESC_Case_Collaborator__c WHERE ESC_Case__c IN: caseids and id NOT in:newreferralList and ESC_Role__c='Accountable Resolver']){
            if((existingAccResolver.ESC_Case__r.LCRM_Sub_BU__c == 'GGO' && existingAccResolver.ESC_Case__r.Is_GLI__c != true) && existingAccResolver.ESC_End_Date__c == null){   
        //for(ESC_Case_Collaborator__c  existingAccResolver :[SELECT Id,ESC_Role__c,OwnerId,ESC_Case__c,ESC_End_Date__c,ESC_Form_Id__c FROM ESC_Case_Collaborator__c WHERE ESC_Case__c IN: caseids and id NOT in:newreferralList and ESC_Role__c='Accountable Resolver' and ESC_Form_Id__c = null]){
            //if(existingAccResolver.ESC_Form_Id__c == null && existingAccResolver.ESC_End_Date__c == null){
                existingAccResolver.ESC_End_Date__c=datetime.Now();
                existingAccResolver.ESC_Referral_Status__c='Completed';
                endDatingReferral.add(existingAccResolver);
            }
        }
        if(Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isUpdateable()){
            Update endDatingReferral;
        }
        addremoveOwnerToCaseTeam(null, endDatingReferral);
    }
    
    /*public static void CaseChatterPostforRejectedReferral(List<ESC_Case_Collaborator__c> newreferralList){
Map<id,List<ESC_Case_Collaborator__c>> caseidwithRefMap= new Map<id,List<ESC_Case_Collaborator__c>>();
//list<id> caseids= new list<id>();
if(runTriggerCaseChatterPostforRejectedReferral){
for(ESC_Case_Collaborator__c ecc: newreferralList){

if(ecc.ESC_Referral_Status__c=='Rejected' || ecc.ESC_Referral_Status__c=='Closed'){ 

List<ESC_Case_Collaborator__c> listRef = new List<ESC_Case_Collaborator__c>();
if (caseidwithRefMap.containsKey(ecc.ESC_Case__c))
{
listRef =caseidwithRefMap.get(ecc.ESC_Case__c);
}
listRef.add(ecc);
caseidwithRefMap.put(ecc.ESC_Case__c,listRef);
}
}
system.debug('caseidwithRefMap******'+caseidwithRefMap);

List<FeedItem> listpost= new List<FeedItem>();
for(id casid: caseidwithRefMap.keySet()){
for(ESC_Case_Collaborator__c ecc: caseidwithRefMap.get(casid)){
//string loggedinUser= UserInfo.getUserName();
String chatterPost;  
if(ecc.ESC_Role__c=='Escalation' && ecc.ESC_Referral_Status__c=='Closed'){  
chatterPost= 'Escalation: '+ ecc.Name +' was completed by '+UserInfo.getFirstName()+' '+UserInfo.getLastName()+' '+System.Now()+' with the resolution comment of '+ ecc.ESC_Escalation_Resolution__c;
}
else if(ecc.ESC_Role__c!='Escalation' && ecc.ESC_Referral_Status__c=='Rejected'){
chatterPost= 'Refferal: '+ ecc.Name+' was rejected for the reason of  "'+ecc.ESC_Rejection_Cancellation_Reason__c +'" by '+ UserInfo.getFirstName()+' '+UserInfo.getLastName()+' '+System.Now();
}else if(ecc.ESC_Role__c!='Escalation' && ecc.ESC_Referral_Status__c=='Closed'){
chatterPost= 'Refferal: '+ ecc.Name+' was closed by '+ UserInfo.getFirstName()+' '+UserInfo.getLastName()+' '+System.Now();
}
//Adding a Text post
FeedItem post = new FeedItem();
post.ParentId = casid; 
post.Body = chatterPost;
listpost.add(post);
}

}
insert listpost;
runTriggerCaseChatterPostforRejectedReferral =false;
}
}*/
    
    
    public static void caseChatterPostforRejectedReferral(Map<id,ESC_Case_Collaborator__c> newreferralMap,Map<id,ESC_Case_Collaborator__c> oldreferralMap){
        Map<id,List<ESC_Case_Collaborator__c>> caseidwithRefMap= new Map<id,List<ESC_Case_Collaborator__c>>();
        //list<id> caseids= new list<id>();
        if(runTriggerCaseChatterPostforRejectedReferral){
            for(id refid: newreferralMap.keySet()){
                
                if((newreferralMap.get(refid).ESC_Referral_Status__c=='Rejected' && oldreferralMap.get(refid).ESC_Referral_Status__c !='Rejected' ) || (newreferralMap.get(refid).ESC_Referral_Status__c=='Closed' && oldreferralMap.get(refid).ESC_Referral_Status__c !='Closed')|| (newreferralMap.get(refid).ESC_Referral_Status__c=='Completed' && oldreferralMap.get(refid).ESC_Referral_Status__c !='Completed')){ 
                    
                    List<ESC_Case_Collaborator__c> listRef = new List<ESC_Case_Collaborator__c>();
                    if (caseidwithRefMap.containsKey(newreferralMap.get(refid).ESC_Case__c))
                    {
                        listRef =caseidwithRefMap.get(newreferralMap.get(refid).ESC_Case__c);
                    }
                    listRef.add(newreferralMap.get(refid));
                    caseidwithRefMap.put(newreferralMap.get(refid).ESC_Case__c,listRef);
                }
            }
            
            
            List<FeedItem> listpost= new List<FeedItem>();
            for(id casid: caseidwithRefMap.keySet()){
                for(ESC_Case_Collaborator__c ecc: caseidwithRefMap.get(casid)){
                    //string loggedinUser= UserInfo.getUserName();
                    String chatterPost='';  
                    if(ecc.ESC_Role__c=='Escalation' && ecc.ESC_Referral_Status__c=='Closed'){  
                        chatterPost= UserInfo.getName()+' '+label.GGO_ClosedEsc+' '+ ecc.Name;
                    }
                    else if(ecc.ESC_Role__c!='Escalation' && ecc.ESC_Referral_Status__c=='Rejected'){
                        chatterPost= 'Referral '+ ecc.Name+' '+label.GGO_Rejected+' '+ecc.ESC_Rejection_Cancellation_Reason__c +' '+label.GGO_By+' '+UserInfo.getName();
                    }/*else if(ecc.ESC_Role__c!='Escalation' && ecc.ESC_Referral_Status__c=='Closed'){
                        chatterPost= 'Referral '+ ecc.Name+' was closed by '+ UserInfo.getName();
                    }*/
                    //Adding a Text post
                    if(chatterPost!=''){
                        FeedItem post = new FeedItem();
                        post.ParentId = casid; 
                        post.Body = chatterPost;
                        listpost.add(post);
                        
                    }
                    
                }
                
            }
            if(listpost.size()>0 && (Schema.sObjectType.FeedItem.isAccessible() || Schema.sObjectType.FeedItem.isCreateable())){
                insert listpost;
            }
            runTriggerCaseChatterPostforRejectedReferral =false;
        }
    }
    
    
    
    private static string formQueryPartFromSet(set<string> names){
        List<string> namesList = new List<string>();
        for(string objName :names){
            if(string.isNotBlank(objName)){
                namesList.add('\''+objName+'\'');
                }
        }
        return ('('+string.join(namesList, ',') +')');
    }
    private static void updateRefForCases(Set<string> applicableRefIDs,set<string> allCasesRelated){
        system.debug('insert context flag is'+isInsertContext );
        if(!isInsertContext){
            List<Case> allCases = new List<Case>();
            map<String,Boolean> referralmap = new map<String,Boolean> ();
            set<string> casesWithRefIDS=  new set<string>();
            system.debug('applicableRefIDs: '+applicableRefIDs);
            system.debug('allCasesRelated: '+allCasesRelated);
            String excludeEscalation ='Escalations';
            string query ='SELECT count(id) openRefferal,ESC_Case__c   FROM ESC_Case_Collaborator__c where  ESC_Referral_Status__c in '+formQueryPartFromSet(activeReferralStatuses)+' and ESC_Case__c in '+formQueryPartFromSet(allCasesRelated)+' and recordtype.Name!=\''+string.escapeSingleQuotes(excludeEscalation)+'\' group by ESC_Case__c'; 
            for(ESC_Case_Collaborator__c ref :  [Select esc_case__c,esc_case__r.esc_ref__c from ESC_Case_Collaborator__c where esc_case__c IN:allcasesrelated and ESC_Referral_Status__c IN:activeReferralStatuses and recordtype.name !=:excludeEscalation ]){
                referralmap.put(ref.esc_case__c,ref.esc_case__r.esc_ref__c);
            }
            system.debug('query : ' +query);
             //AggregateResult[]  groupedResults = Database.query(query);
            AggregateResult[]  groupedResults = [SELECT count(id) openRefferal,ESC_Case__c   FROM ESC_Case_Collaborator__c where  ESC_Referral_Status__c in :activeReferralStatuses and ESC_Case__c in :allCasesRelated and recordtype.Name!=:excludeEscalation group by ESC_Case__c];
            for(AggregateResult agr:groupedResults) {
                
                string caseIDWithRef = (string)agr.get('ESC_Case__c');
                
                casesWithRefIDS.add(caseIDWithRef);
                
                Case caseObj = new Case(ID = caseIDWithRef);
                if(referralmap.get(caseIDWithRef) != true){
                    caseObj.ESC_Ref__C = true;
                    allCases.add(caseObj);
                }
                
            }
            
            for(string caseID : allCasesRelated){
                if(!casesWithRefIDS.contains(caseID)){
                    try{    
                        Case caseObj = new Case(ID = caseID);
                        if(referralmap.get(caseID) != false){
                            caseObj.ESC_Ref__C = false;
                            allCases.add(caseObj);
                        }
                    }
                    catch(exception ex){
                    system.debug('exception'+ex);
                    }
                }
                
            }
            
            if(allcases.size() > 0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
                update allCases;
            }
        }
    }
    public static void updateRelatedCaseRefStatus(Map<id, ESC_Case_Collaborator__c> newreferralmap , Map<id, ESC_Case_Collaborator__c> oldreferralMap ){
        
        
        Set<string> applicableRefIDs = new set<string>();
        Set<string> allCasesRelated = new set<string>();
        for(string newRecordId : newreferralmap.keyset()){
            string statusNew = '';
            string statusOld ='';
            string caseOld ='';
            string caseNew ='';
            if(oldreferralMap !=  null && oldreferralMap.size() >=1){
                statusOld = oldreferralMap.get(newRecordId).ESC_Referral_Status__c;
                caseOld = oldreferralMap.get(newRecordId).esc_case__C;
            }
            
            
            if(newreferralmap !=  null && newreferralmap.size() >= 1){
                caseNew = newreferralmap.get(newRecordId).esc_case__C;
                statusNew =  newreferralmap.get(newRecordId).ESC_Referral_Status__c;
            }
            
            if( !statusNew.equalsIgnoreCase(statusOld) || (caseNew != caseOld)){
                
                
                applicableRefIDs.add(newRecordId);
                if(caseNew != null) {
                    allCasesRelated.add(caseNew);
                    }
                if(caseNew != null) {
                    allCasesRelated.add(caseOld);
                    }
            }
        }
        set<String> validIDsList = new set<string>();
        for(string value: allCasesRelated){
            string validIDVal = validateId(value);
            if(string.isNotBlank(validIDVal)){
                validIDsList.add(validIDVal);
            }
            
        }
        
        if(validIDsList.size() !=0){
            updateRefForCases(applicableRefIDs ,validIDsList);
        }
    }
    
    static public String validateId(String idparam) {
        String id = String.escapeSingleQuotes(idparam);
        if((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return id;
        }
        return null;
    }
    
    public static void updateUPDFlagForReferrals(set<String> caseIDs){  
        List<ESC_Case_Collaborator__c> applicableRefs = new List<ESC_Case_Collaborator__c>();
        if(Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isQueryable()){
            applicableRefs = [select id, ESC_ReferralUPD__c from ESC_Case_Collaborator__c where (id in : caseIDs or ESC_Case__c in : caseIDs) and ESC_ReferralUPD__c = false ];
        }
         System.debug('ref1----->'+applicableRefs); 
        for(ESC_Case_Collaborator__c ref :applicableRefs){
            ref.ESC_ReferralUPD__c = true;
            System.debug('ESC_ReferralUPD__c---->'+ref.ESC_ReferralUPD__c);
        }
        
        if(applicableRefs.size()>0 && (Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isUpdateable())){
            update applicableRefs;
        }
        
    }
    
    public static void updateUPDFlagForReferrals(set<string> caseIDs, string labelName , string labelValue){
        updateUPDFlagForReferrals(caseIDs);
        updateUPDForCases(caseIDs, labelName , labelValue);
    }
    // ESC_File_UPD__c flag update.
    /* public static void updateFileUPDForCases(set<String> caseIDs){
       
        List<Case>  casesList = new List<Case>();
        List<Case>  updateList = new List<Case>();
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
            casesList = [ select id,ESC_File_Upd_Cntr__c from Case where id in : caseIDs];
        }
       
        for(Case caseObj: casesList ){
          if(caseObj.ESC_File_Upd_Cntr__c == null || caseObj.ESC_File_Upd_Cntr__c == 0)
            {
            caseObj.ESC_File_Upd_Cntr__c = 1;
      }else{
      caseObj.ESC_File_Upd_Cntr__c = caseObj.ESC_File_Upd_Cntr__c +1;
      }
            updateList.add(caseObj);
            
                       
        }
        if(updateList.size()>0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
            update updateList; 
        }  
    }*/
    
    
    @InvocableMethod(label='Update Referrals UPD and UPD Action for cases' description='set the related Referrals UPD flag to specified Case IDs.')
    public static void updateUPDFlagForReferrals(List<EmailMessage> emails){
        isFromInboundEmail = true;
        emailsFromAddressMap = new Map<string,string>();
        set<string> caseIDS = new set<string>();
        for(EmailMessage em :emails){
            if(em.parentid !=null){
                caseIDS.add(em.parentid);
                emailsFromAddressMap.put(em.parentid, em.FromAddress);
                
            }
        }
        
        List<ESC_Case_Collaborator__c> applicableRefs = [select ESC_ReferralUPD__c from ESC_Case_Collaborator__c where ESC_Case__c in :caseIDS and ESC_ReferralUPD__c = false];
        for(ESC_Case_Collaborator__c ref :applicableRefs){
            ref.ESC_ReferralUPD__c = true;
        }
        
        if(applicableRefs.size()>0){
            update applicableRefs;
        }
        //emailsList = emails;
        updateUPDForCases(caseIDs, 'ESC_ViaEmail' ,Label.ESC_ViaEmail);
         isFromInboundEmail = false;
    }
    
    public static void updateUPDForCases(set<String> caseIDs, string labelName , string existingLabelVal){
        string userID = UserInfo.getUserId() ;
        List<Case>  casesList = new List<Case>();
        List<Case>  updateList = new List<Case>();
        //DM : Added condition to by pass for Unified Experience Cases
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
            casesList = [ select ESC_UPD__c,owner.isactive,ownerid,ESC_File_Upd_Cntr__c,ESC_LastQueueOwner__c,
                            ESC_UPD_Action__c,contact.email,ESC_Last_Update__c,ESC_UPD_Resolver__c from Case 
                            where id in : caseIDs and origin !=: Label.UE_Account];
        }
        
        for(Case caseObj: casesList ){
            if(labelName == 'ESC_ViaAttachment'){
                system.debug('entered viaattachment');
                if( caseObj.ownerid != userID){
                    string updActionValue = '';
                    caseObj.ESC_UPD__c = true;
                    if(caseObj.owner.isactive == false && string.isNotBlank(caseObj.ESC_LastQueueOwner__c)){
                    caseObj.ownerid = caseObj.ESC_LastQueueOwner__c;
                    }
                    string oldVal = caseObj.ESC_UPD_Action__c;
                    if(string.isBlank(oldVal) ){
                    caseObj.ESC_UPD_Action__c = '1#' +existingLabelVal;
                    
                    }
                    else{
                    if(oldVal.indexOf(existingLabelVal) == -1 ){
                    //integer newCount = integer.valueOf(caseObj.ESC_UPD_Action__c.split('#')[0]) + 1;
                         caseObj.ESC_UPD_Action__c = oldVal+',1#' +existingLabelVal;
                    }
                    else{
                        string newValPattern = '';
                        string newVal = '';
                        
                       for(string currString  : caseObj.ESC_UPD_Action__c.split( ',')){
                            if(currString.indexOf(existingLabelVal) != -1){
                                integer newCount = integer.valueOf(currString.split('#')[0]) + 1;
                                newVal = newCount+'#'+ existingLabelVal;
                               
                            }
                            else{
                                if(string.isBlank(newValPattern)){
                                    newValPattern = currString;
                                }
                                else{
                                    newValPattern += ','+currString;
                                }
                            }
                       }
                      system.debug('newValPattern b4 '+newValPattern);
                       newValPattern = newValPattern+','+newVal;
                        if(newValPattern.startsWith(',')){
                         newValPattern =  newValPattern.substringAfter(',');
                       }
                     caseObj.ESC_UPD_Action__c =  newValPattern;
                    }
                }
                }
             if(caseObj.ESC_File_Upd_Cntr__c == null || caseObj.ESC_File_Upd_Cntr__c == 0){
                caseObj.ESC_File_Upd_Cntr__c = 1;
                }else{
                caseObj.ESC_File_Upd_Cntr__c = caseObj.ESC_File_Upd_Cntr__c +1;
                }   
                system.debug('ESC_File_Upd_Cntr__c-->'+caseObj.ESC_File_Upd_Cntr__c);
                updateList.add(caseObj);
            }
            else{
                system.debug('entered for labelname'+labelName);
                string updActionValue = '';
                caseObj.ESC_UPD__c = true;
                if(caseObj.owner.isactive == false && string.isNotBlank(caseObj.ESC_LastQueueOwner__c)){
                caseObj.ownerid = caseObj.ESC_LastQueueOwner__c;
                }
                if(labelName == 'ESC_ViaEmail'){
                string oldVal = caseObj.ESC_UPD_Action__c;
                string caseEmail = caseObj.contact.email;
                
                if(isFromInboundEmail && caseObj.contact !=null && emailsFromAddressMap.containsKey(caseObj.id) && (emailsFromAddressMap.get(caseObj.id)).  equalsIgnoreCase(caseEmail)){
                    caseObj.ESC_Last_Update__c = 'Email From Customer';
                    caseObj.ESC_UPD__c = true;
                    caseObj.ESC_UPD_Resolver__c = true;
                }
                }
                string oldVal = caseObj.ESC_UPD_Action__c;
                if(string.isBlank(oldVal) ){
                    caseObj.ESC_UPD_Action__c = '1#' +existingLabelVal;
                    
                }
                else{
                    if(oldVal.indexOf(existingLabelVal) == -1 ){
                    //integer newCount = integer.valueOf(caseObj.ESC_UPD_Action__c.split('#')[0]) + 1;
                         caseObj.ESC_UPD_Action__c = oldVal+',1#' +existingLabelVal;
                    }
                    else{
                        string newValPattern = '';
                        string newVal = '';
                        
                       for(string currString  : caseObj.ESC_UPD_Action__c.split( ',')){
                            if(currString.indexOf(existingLabelVal) != -1){
                                integer newCount = integer.valueOf(currString.split('#')[0]) + 1;
                                newVal = newCount+'#'+ existingLabelVal;
                               
                            }
                            else{
                                if(string.isBlank(newValPattern)){
                                    newValPattern = currString;
                                }
                                else{
                                    newValPattern += ','+currString;
                                }
                            }
                       }
                      system.debug('newValPattern b4 '+newValPattern);
                       newValPattern = newValPattern+','+newVal;
                        if(newValPattern.startsWith(',')){
                         newValPattern =  newValPattern.substringAfter(',');
                       }
                     caseObj.ESC_UPD_Action__c =  newValPattern;
                    }
                }
            updateList.add(caseObj);
        }
        }
        if(updateList.size()>0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
            update updateList;
        }
        
    }
    public static void updateCaseEscalation(Map<id, ESC_Case_Collaborator__c> newreferralmap , Map<id, ESC_Case_Collaborator__c> oldreferralMap ){
        Set<id> caseidstoUpdateEscalation= new Set<id>();
        
        for(Id newRecordId : newreferralmap.keyset()){
            string memId=newreferralmap.get(newRecordId).OwnerId;
            
            if(oldreferralMap != null){
                string oldmemId=oldreferralMap.get(newRecordId).OwnerId;
                if(newreferralmap.get(newRecordId).ESC_Role__c == 'Escalation' && (memId.substring(0,3)=='005' && oldmemId.substring(0,3)!='005')){
                    caseidstoUpdateEscalation.add(newreferralmap.get(newRecordId).ESC_Case__c);
                }
            }
            else{
                if(newreferralmap.get(newRecordId).ESC_Role__c == 'Escalation' && memId.substring(0,3)=='005'){
                    caseidstoUpdateEscalation.add(newreferralmap.get(newRecordId).ESC_Case__c);
                }}
        }
        List<Case> caselisttoUpdateEscalation = new List<Case>();
        if(caseidstoUpdateEscalation.size()>0){
            for(Case cs:[Select id from Case where id IN: caseidstoUpdateEscalation]){
                //cs.ESC_Escalation__c=True;//Removed this as Escalation is going to be Formula field as per latest document sent by Dore
                caselisttoUpdateEscalation.add(cs);
            }
        }
        if(caselisttoUpdateEscalation.size()>0){
            update caselisttoUpdateEscalation;
        }
    }
    
    
    public static void referralOwnerTeamDivisionUpdate(Map<id, ESC_Case_Collaborator__c> newreferralmap , Map<id, ESC_Case_Collaborator__c> oldreferralMap ){
        List<Id> listUserOwnerid= new List<Id>();
        
        for(Id refid : newreferralmap.keyset()){
            String refOwnerId=newreferralmap.get(refid).OwnerId;
            if(refOwnerId.substring(0,3)=='005'){
                if(oldreferralMap != null && newreferralmap.get(refid).OwnerId != oldreferralMap.get(refid).OwnerId){
                    listUserOwnerid.add(newreferralmap.get(refid).OwnerId);
                }
                
            }
        }
        Map<Id,User> mapusers = getUsersMap();
        
        List<User> userList= new List<User>();
        for(Id uid:listUserOwnerid){
            if(mapusers.keySet().contains(uid)){
                userList.add(mapusers.get(uid));
            }
        }
        Map<id,String> mapUserIdDivision = new Map<id,String>();
        for(User us:userList){
            mapUserIdDivision.put(us.id,us.Division);
            
        }
        
        for(Id refid : newreferralmap.keyset()){
            String refOwnerId=newreferralmap.get(refid).OwnerId;
            if(refOwnerId.substring(0,3)=='005'){
                if(oldreferralMap != null && newreferralmap.get(refid).OwnerId != oldreferralMap.get(refid).OwnerId){
                    newreferralmap.get(refid).ESC_Team__c=mapUserIdDivision.get(newreferralmap.get(refid).OwnerId);
                    newreferralmap.get(refid).ESC_Team1__c=mapUserIdDivision.get(newreferralmap.get(refid).OwnerId);
                }
                
            }
        }
    }
    
    public static Map<Id,User> getUsersMap(){ 
        if(mapuser.isempty()){
            mapuser = new Map<Id,User>([Select id,Division from User where isActive=true]);
        }    
        
        return mapuser; 
    }
    
    public static Map<String,Id> getCaseteamRoles(){
        if(caseTeamRolelst.isempty()){
            caseTeamRolelst = [SELECT Id,Name FROM CaseTeamRole];
            for(CaseTeamRole ctr:caseTeamRolelst){
                caseteamtileMaps.put(ctr.Name,ctr.id);
            }
        }
        
        return caseteamtileMaps;
    }
    
    
    public static void referralOwnerTeamDivisionInsert(List<ESC_Case_Collaborator__c> newreferrallist){
        List<Id> listUserOwnerid= new List<Id>();
        
        for(ESC_Case_Collaborator__c ecc: newreferrallist){
            String refOwnerId=ecc.OwnerId;
            if(refOwnerId.substring(0,3)=='005'){
                listUserOwnerid.add(ecc.OwnerId);
            }
        }
        List<User> userList= new List<User>();
        Map<Id,User> mapusers = getUsersMap();
        for(Id uid:listUserOwnerid){
            if(mapusers.keySet().contains(uid)){
                userList.add(mapusers.get(uid));
            }  
        }
        
        Map<id,String> mapUserIdDivision = new Map<id,String>();
        for(User us:userList){
            mapUserIdDivision.put(us.id,us.Division);
            
        }
        
        for(ESC_Case_Collaborator__c ecc: newreferrallist){
            String refOwnerId=ecc.OwnerId;
            if(refOwnerId.substring(0,3)=='005'){
                ecc.ESC_Team__c=mapUserIdDivision.get(ecc.OwnerId);
                ecc.ESC_Team1__c=mapUserIdDivision.get(ecc.OwnerId);
            }
        }
        
    }
    
    //CaseChatterPostforReferralCreated method created as required in EES-229(Chatter Post on Case when an Escalation/Referral is created)
    
    public static void caseChatterPostforReferralCreated(Map<id,ESC_Case_Collaborator__c> newreferralMap){
        
        Map<id,List<ESC_Case_Collaborator__c>> caseidwithRefMap= new Map<id,List<ESC_Case_Collaborator__c>>();
        //list<id> caseids= new list<id>();
        
        for(id refid: newreferralMap.keySet()){
            
            List<ESC_Case_Collaborator__c> listRef = new List<ESC_Case_Collaborator__c>();
            
            if (caseidwithRefMap.containsKey(newreferralMap.get(refid).ESC_Case__c))
            {
                listRef =caseidwithRefMap.get(newreferralMap.get(refid).ESC_Case__c);
            }
            listRef.add(newreferralMap.get(refid));
            caseidwithRefMap.put(newreferralMap.get(refid).ESC_Case__c,listRef);
            
        }
        
        //caseidwithRefMap [it contain id of case and corresponding record of refferal for that case.]
        
        List<FeedItem> listpost= new List<FeedItem>();
        
        //string recordtypename = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosById().get(ecc.recordtypeid).getname();
        
        for(id casid: caseidwithRefMap.keySet()){
            for(ESC_Case_Collaborator__c ecc: caseidwithRefMap.get(casid)){
                //string loggedinUser= UserInfo.getUserName();
                String chatterPost;
                string recordtypename = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosById().get(ecc.recordtypeid).getname();     //checking record type
                if(recordtypename=='Service Cloud Referral'){
                    chatterPost= Label.ESC_ReferralName+' '+ ecc.Name+' '+Label.ESC_ReferralCreationLabel+' '+ ecc.ESC_CaseNumber__c;
                }
                else if(recordtypename=='Escalations'){
                    chatterPost= Label.ESC_EscalationName+' '+ecc.Name+' '+Label.ESC_ReferralCreationLabel+' '+ ecc.ESC_CaseNumber__c;
                }
                
                //Adding a Text post
                FeedItem post = new FeedItem();
                post.ParentId = casid; 
                post.Body = chatterPost;
                listpost.add(post);
            }
            
        }
        if(listpost.size()>0 && (Schema.sObjectType.FeedItem.isAccessible() || Schema.sObjectType.FeedItem.isCreateable())){
            insert listpost;
        }
        
    }
    
    // Update owner as part of Escalation creation if no manager associated with Logged in User(EES-222)
    
    public static void escalationChangeOwnerShip(list<ESC_Case_Collaborator__c> newreferrallist){
        for(ESC_Case_Collaborator__c ecc: newreferrallist){
            string recordtypename = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosById().get(ecc.recordtypeid).getname();     
            if(recordtypename=='Escalations' && ecc.ESC_Assign_To__c!=ecc.OwnerId && ecc.ESC_Assign_To__c!=null ){
                ecc.OwnerId=ecc.ESC_Assign_To__c;
            }
        }
    }
    public static void updUnchecking(list<ESC_Case_Collaborator__c> newreferrallist){
        if(isInLightning){
            system.debug('In lightning console');
        for(ESC_Case_Collaborator__c ecc: newreferrallist){  
           if(ecc.OwnerId == UserInfo.getUserId() && ecc.ESC_ReferralUPD__c == True){
              ecc.ESC_ReferralUPD__c = False;
              } 
        }
        }
    }
     public static void CalculateReferralSLA(Map<id, ESC_Case_Collaborator__c> newreferralmap , Map<id, ESC_Case_Collaborator__c> oldreferralMap){
        Map<id,ESC_Case_Collaborator__c> csidreflist= new Map<id,ESC_Case_Collaborator__c>();
        
        for(Id newRecordId : newreferralmap.keyset()){
            string memId=newreferralmap.get(newRecordId).OwnerId;
            
            if(oldreferralMap != null){
                string oldmemId=oldreferralMap.get(newRecordId).OwnerId;
                if(newreferralmap.get(newRecordId).ESC_Role__c == 'Accountable Resolver' && ((memId != oldmemId) && memId.substring(0,3)=='00G')){
                    csidreflist.put(newreferralmap.get(newRecordId).ESC_Case__c,newreferralmap.get(newRecordId));
                }
            }
            else{
                if(newreferralmap.get(newRecordId).ESC_Role__c == 'Accountable Resolver' && memId.substring(0,3)=='00G'){
                     csidreflist.put(newreferralmap.get(newRecordId).ESC_Case__c,newreferralmap.get(newRecordId));
                }}
        }
        
        Map<id,id> casewithBHour = new Map<id,id>();
        if(csidreflist.size()>0){
            for(Case cs:[Select id,BusinessHoursId from Case where id IN: csidreflist.Keyset()]){
                casewithBHour.put(cs.id,cs.BusinessHoursId);
            }
        }
        if(casewithBHour.size()>0){
        
        for(id casid : casewithBHour.keyset()){
         Group refQueue = getQueue(csidreflist.get(casid).OwnerId);
         csidreflist.get(casid).Form_Referral_Response_Time__c =getReferralSLA(refQueue,casewithBHour.get(casid),'update',csidreflist.get(casid));
        }
            
        }}
        
         public static void CalculateReferralSLAinsert(List<ESC_Case_Collaborator__c> newreferralmap){
        Map<id,ESC_Case_Collaborator__c> csidreflist= new Map<id,ESC_Case_Collaborator__c>();
        
        for(ESC_Case_Collaborator__c newRecordId : newreferralmap){
            string memId=newRecordId.OwnerId;
            if(newRecordId.ESC_Role__c == 'Accountable Resolver' && memId.substring(0,3)=='00G'){
                     csidreflist.put(newRecordId.ESC_Case__c,newRecordId);
                }
        }
        
        Map<id,id> casewithBHour = new Map<id,id>();
        if(csidreflist.size()>0){
            for(Case cs:[Select id,BusinessHoursId from Case where id IN: csidreflist.Keyset()]){
                casewithBHour.put(cs.id,cs.BusinessHoursId);
            }
        }
        if(casewithBHour.size()>0){
        
        for(id casid : casewithBHour.keyset()){
         Group refQueue = getQueue(csidreflist.get(casid).OwnerId);
         csidreflist.get(casid).Form_Referral_Response_Time__c =getReferralSLA(refQueue,casewithBHour.get(casid),'insert',csidreflist.get(casid));
        }
            
        }}
        
        
    private static DateTime getReferralSLA(Group refQueue,id Businesshrid,String value,ESC_Case_Collaborator__c refobj)
    {
        DateTime refSLA = null;
        Integer referralSLAmins = 0;
        
        for(USL_Case_SLA_Matrix__c caseSLA : USL_Case_SLA_Matrix__c.getAll().values()){
            if(caseSLA.USL_Queue__c == refQueue.DeveloperName)
            {
                referralSLAmins = Integer.valueOf(caseSLA.USL_Referral_SLA_Minutes__c);
                break;
            }
        }
        
        Id referralbusinesshrid = Businesshrid;
        if(value=='insert'){
        refSLA = businesshours.add(referralbusinesshrid,System.now(),referralSLAmins*60*1000L);}
        else{
        refSLA = businesshours.add(referralbusinesshrid,refobj.CreatedDate,referralSLAmins*60*1000L); }  
        return refSLA;
    }
    
   private static Group getQueue(id OwnerId)
    {   
        List<Group> referralQueue = new List<Group>();
        //Below condition to fix PMD vioalation is been added by Herin Acharya for the deplyment of DUE-4438      
        if(Schema.sObjectType.Group.isAccessible() && Schema.sObjectType.Group.isQueryable()){
            referralQueue = [SELECT Id, developerName, Name from Group where id = :OwnerId LIMIT 1];
        }     
        if(referralQueue != null && referralQueue.size() > 0)
        {
            return referralQueue[0];
        }

        return null;
    }

    
}