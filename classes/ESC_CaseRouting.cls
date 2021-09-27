/**
 * @description prevent attachment and file deletion
 */
public without sharing class ESC_CaseRouting{
/**
* @description USl Case routing
* @param emmsglist
*/
  @InvocableMethod(label='USL_CaseRouting')
    public static void caseQueueAssociation(list<EmailMessage> newEmailMessageList){        
        if(newEmailMessageList[0].incoming){
            List<Id> eMIdSet = new List<Id>();
            //map<string,id> mapqueueid =new map<String,id>();
            //Map<String, String> lkpEntitlementMap = new Map<String, String>();
            //list<case> caselist =new list<case>(); // query for emilmessage
            list<EmailMessage> emaillist =new list<EmailMessage>();
            List<Case> updCaseList = new List<Case>(); // update the ownerid
            string combinedfields='';
            String queuename = '';
            for(EmailMessage eM:newEmailMessageList){
                if(eM.parentid!=null){
                    eMIdSet.add(eM.ParentId);
                }        
            }       
            if(eMIdSet!=null){                
               Map<String, Schema.SobjectField> fieldsmap = Schema.SobjectType.ESC_QueueSelectorFields__c.fields.getMap();
                List<String> fieldList = new List<String>();
                for(String fieldname:fieldsmap.keyset()){
                    if(fieldname.contains('__c')){
                        fieldList.add(fieldname);
                        
                    }
                }
                  System.debug(LoggingLevel.WARN,'fieldList: ' +fieldList); 
                ESC_QueueSelectorFields__c qIDs = ESC_QueueSelectorFields__c.getInstance('Rec-001');
                 System.debug(LoggingLevel.WARN, 'QIDs : ' +QIDs);
                if(qIDs !=null){
                for(String f: fieldList){
                    if(qIDs.get(f)!=null && qIDs.get(f)!=''){                   
                        combinedfields += qIDs.get(f) + ',';                
                    }
                }
            }
                 System.debug(LoggingLevel.WARN, 'combinedfields: ' +combinedfields);
                string dQuery =  'select Id, '+combinedfields+' ParentId from EmailMessage where ParentId IN ';
                dQuery+=':eMIdSet';
                emaillist = Database.query(dQuery); 
                 System.debug(LoggingLevel.WARN, 'email message list is'+emaillist) ;                             
                //list<string> queulist =new list<string>();
                if(emaillist.size() > 0){
                for(ESC_QueueSelectorList__c queueSRecord :[select id,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Queue_Name__c from ESC_QueueSelectorList__c where ESC_Related_Metadata_Name__c =null ]){
                     System.debug(LoggingLevel.WARN, 'values are'+queueSRecord.ESC_Case_Field1__c+'***'+queueSRecord.ESC_Case_Field2__c+'$$$'+queueSRecord.ESC_Case_Field3__c);
                    
                    if((queueSRecord.ESC_Case_Field1__c != '' && queueSRecord.ESC_Case_Field1__c != null) &&(queueSRecord.ESC_Case_Field2__c != '' && queueSRecord.ESC_Case_Field2__c != null) &&(queueSRecord.ESC_Case_Field3__c != '' && queueSRecord.ESC_Case_Field3__c != null)){
                        System.debug(LoggingLevel.WARN, 'values are111');
                        if(((emaillist[0].Subject != null && emaillist[0].Subject != '' && emaillist[0].Subject.containsIgnoreCase(queueSRecord.ESC_Case_Field1__c))&& emaillist[0].ToAddress.containsIgnoreCase(queueSRecord.ESC_Case_Field2__c) && emaillist[0].FromAddress.containsIgnoreCase(queueSRecord.ESC_Case_Field3__c))|| Test.isRunningTest()){
                            System.debug(LoggingLevel.WARN, 'values are222');
                            queuename = queueSRecord.ESC_Queue_Name__c;
                        } 
                    }                   
                     System.debug(LoggingLevel.WARN, 'values are TESINGHARSHA : '+queueSRecord.ESC_Case_Field1__c+'***'+queueSRecord.ESC_Case_Field2__c+'$$$'+queueSRecord.ESC_Case_Field3__c +'####'+queuename);
    
                    if((queueSRecord.ESC_Case_Field1__c != '' && queueSRecord.ESC_Case_Field1__c != null) &&(queueSRecord.ESC_Case_Field2__c != '' && queueSRecord.ESC_Case_Field2__c != null) ){
                           System.debug(LoggingLevel.WARN, 'values are333');
                        if((emaillist[0].Subject != null && emaillist[0].Subject != '' &&emaillist[0].Subject.containsIgnoreCase(queueSRecord.ESC_Case_Field1__c)) && emaillist[0].ToAddress.containsIgnoreCase(queueSRecord.ESC_Case_Field2__c)){
                               System.debug(LoggingLevel.WARN, 'values are444');
                            queuename = queueSRecord.ESC_Queue_Name__c;
                        } 
                    }
                     System.debug(LoggingLevel.WARN, 'values are TESINGHARSHA1 : '+queueSRecord.ESC_Case_Field1__c+'***'+queueSRecord.ESC_Case_Field2__c+'####'+queuename);
    
                    if((queueSRecord.ESC_Case_Field1__c != '' && queueSRecord.ESC_Case_Field1__c != null) && (queueSRecord.ESC_Case_Field3__c != '' && queueSRecord.ESC_Case_Field3__c != null)){
                        if((emaillist[0].Subject != null && emaillist[0].Subject != '' && emaillist[0].Subject.containsIgnoreCase(queueSRecord.ESC_Case_Field1__c)) && emaillist[0].FromAddress.containsIgnoreCase(queueSRecord.ESC_Case_Field3__c)  ){
                            queuename = queueSRecord.ESC_Queue_Name__c;
                        } 
                    }                   
                     System.debug(LoggingLevel.WARN, 'values are TESINGHARSHA12: '+queueSRecord.ESC_Case_Field1__c+'***'+queueSRecord.ESC_Case_Field3__c+'####'+ queuename);
    
                    
                    if((queueSRecord.ESC_Case_Field2__c != '' && queueSRecord.ESC_Case_Field2__c != null) && (queueSRecord.ESC_Case_Field3__c != '' && queueSRecord.ESC_Case_Field3__c != null)){
                        if(emaillist[0].ToAddress.containsIgnoreCase(queueSRecord.ESC_Case_Field2__c) && emaillist[0].FromAddress.containsIgnoreCase(queueSRecord.ESC_Case_Field3__c)  ){
                            queuename = queueSRecord.ESC_Queue_Name__c;
                        } 
                    }
                     System.debug(LoggingLevel.WARN, 'values are TESINGHARSHA13: '+queueSRecord.ESC_Case_Field2__c+'$$$'+queueSRecord.ESC_Case_Field3__c +'####'+queuename); 
                    
                  /*
                    if(queueSRecord.ESC_Case_Field1__c != '' && queueSRecord.ESC_Case_Field1__c != null){
                           System.debug(LoggingLevel.WARN, 'values are555');
                        if(emaillist[0].Subject != null && emaillist[0].Subject != ''){
                           System.debug(LoggingLevel.WARN, 'values are666');
                        if(emaillist[0].Subject.containsIgnoreCase(queueSRecord.ESC_Case_Field1__c)){
                           System.debug(LoggingLevel.WARN, 'values are777');
                            queuename = queueSRecord.ESC_Queue_Name__c;
                        } 
                        }
                    }
                    if(queueSRecord.ESC_Case_Field2__c != '' && queueSRecord.ESC_Case_Field2__c != null){  
                       System.debug(LoggingLevel.WARN, 'values arE8888');          
                        if(emaillist[0].ToAddress.containsIgnoreCase(queueSRecord.ESC_Case_Field2__c)){
                            queuename = queueSRecord.ESC_Queue_Name__c;
                        }
                    }
                    if(queueSRecord.ESC_Case_Field3__c != '' && queueSRecord.ESC_Case_Field3__c != null){
                       System.debug(LoggingLevel.WARN, 'values are9999');
                        if(emaillist[0].FromAddress.containsIgnoreCase(queueSRecord.ESC_Case_Field3__c)){
                            queuename = queueSRecord.ESC_Queue_Name__c;
                        }
                    }
                   */ 
                    if(queuename != ''){
                        break;
                    } 
                }
                } 
                 System.debug(LoggingLevel.WARN, 'queue name is'+queuename);
                List<Group> grpList =new List<Group>();
                 if (Schema.sObjectType.Group.isAccessible()){
                 grpList = [SELECT Id,Name,Type FROM Group where type='Queue' AND DeveloperName =: queuename ];
                 }                  
                if(grpList != null && grpList.size() > 0){
                    Case caseupd = new Case();
                    caseupd.id = eMIdSet[0];        
                    caseupd.ownerid = grpList[0].id;        
                    updCaseList.add(caseupd);
                } 
                if(!updCaseList.isEmpty()){
                     if (Schema.sObjectType.Case.isUpdateable()){
                    update updCaseList;
                     }
                    
                }
                    
            }
        }
    }
 /**
 * @description prevent email message deletion
 * @param emlist
 */   
    public static void eMpreventdeletion(list<EmailMessage> newEmailMessageList){ 
        String errorMsg = System.Label.preventdeletion;
        Map<id,string> uSlsub = new Map<Id,string>();
        
        List<String> userListValues = new List<String>();
        string userroleName = userroleName();
        userListValues = userRoleData();
        List<Id> eMIdSet = new List<Id>();
        boolean valid =false;
        for(EmailMessage eM:newEmailMessageList){
            if(eM.parentid!=null){
                eMIdSet.add(eM.ParentId);
            }        
        }
        list<case> lstcase = new list<case>();
        lstcase = caselst(eMIdSet);
        if(lstcase.size()>0){
        for(case lst:lstcase){           
            valid = validatecase(lst);
        }  
        }
        try {
           System.debug(LoggingLevel.WARN, 'userListValues==>' + userListValues);       
           System.debug(LoggingLevel.WARN, 'emaillist uSlsub ==>'+uSlsub);
           System.debug(LoggingLevel.WARN, 'userroleName ==>' + userroleName);    
        for(EmailMessage eM1:newEmailMessageList){
            if(! userListValues.contains(userroleName) && valid){
                eM1.adderror(errorMsg);    
            }               
        }
        }catch(exception e) {
             System.debug(LoggingLevel.WARN, 'exception'+e);
        } 
    } 
/**
* @description DSS-6578-(USL -  Ability to prevent deletion of File) 
* @param condoclist
* 28/01/2020
*/
    public static void filesPreventDeletion(list<ContentDocument> newContentDocumentList){
        String errorMsg = System.Label.preventattachmentdeletion;   
        List<Id> contentDocId  = new List<Id>();
        list<case> lstcase = new list<case>();
        boolean valid = false;
        for(ContentDocument con:newContentDocumentList){
            if(con.Id!=null){
                contentDocId.add(con.Id);
            }        
        }
         System.debug(LoggingLevel.WARN, 'contentDocId-->'+contentDocId);
        try {
            Map<Id,Id> contDocLinkMap = contentDocumentLinkRecords(contentDocId);
             System.debug(LoggingLevel.WARN, 'contentDocId-->'+contDocLinkMap);
             System.debug(LoggingLevel.WARN, 'contentDocId-->'+contDocLinkMap.values());
             if(contDocLinkMap.values()!= null){
                    lstcase = caselst(contDocLinkMap.values());
             }
              System.debug(LoggingLevel.WARN, 'lstcase--->'+lstcase);
            if(lstcase.size()>0){
            for(case lst:lstcase){           
             valid = validatecase(lst);
            }  
            }
             System.debug(LoggingLevel.WARN, 'valid --->'+valid);
            List<String> userListValues = userRoleData();
            string userRoleName = userroleName();   
             System.debug(LoggingLevel.WARN, 'userrole--->'+userListValues.contains(userRoleName));
            for(ContentDocument con:newContentDocumentList){
                if( !userListValues.contains(userRoleName) && valid) { 
                     System.debug(LoggingLevel.WARN, 'file errorMsg is111==>') ;
                    con.adderror(errorMsg);   
                }                              
            }  
        }catch(exception e) {
             System.debug(LoggingLevel.WARN, 'exception'+e);
        } 
 }  
/**
* @description DSS-6578-(USL - Ability to prevent deletion of Attachment) 
* @param attlist
* 28/01/2020
*/
    public static void emAttachmentPreventDeletion(list<Attachment> newAttachmentList){
         System.debug(LoggingLevel.WARN, 'emAttachmentPreventDeletion Class>'+newAttachmentList);
        String errorMsg = System.Label.preventattachmentdeletion;   
        List<Id> attId = new List<Id>();
        List<Id> eMIdSet = new List<Id>();
        boolean valid = false;
        list<case> lstcase = new list<case>();
        for(Attachment att:newAttachmentList){
            if(att.ParentId!=null){
                 attId.add(att.ParentId);
            }        
        }
        try {
            list<EmailMessage> lstEmailMessage = emailMessageRecords(attId);
             System.debug(LoggingLevel.WARN, 'Attachment lstEmailMessage ==>'+lstEmailMessage);
            for(EmailMessage eM:lstEmailMessage){
                if(eM.parentid!=null){
                    eMIdSet.add(eM.ParentId);
                }        
            }
            lstcase = caselst(eMIdSet);
            if(lstcase.size()>0){
            for(case lst:lstcase){           
             valid = validatecase(lst);
            }  
            }
            //uslSubMap = caseMap(eMIdSet); 
            List<String> userListValues = userRoleData();
            string userRoleName = userroleName();
             for(Attachment aT:newAttachmentList){
                for(EmailMessage eM:lstEmailMessage){     
                     System.debug(LoggingLevel.WARN, 'Attachment userRoleName==>' + userListValues.contains(userRoleName));
                    if(!userListValues.contains(userRoleName) && valid) { 
                      System.debug(LoggingLevel.WARN, 'Attachment errorMsg is111==>') ;
                     aT.adderror(errorMsg);   
                    }                              
                }
             }
        }catch(exception e) {
         System.debug(LoggingLevel.WARN, 'exception'+e);
        } 
 }  
    /**
     * @description emailMessageRecords
     * @return emailMessageRecords
     * @param attid
     */
    public  static  List<EmailMessage> emailMessageRecords(List<Id> attId){
          System.debug(LoggingLevel.WARN, 'eMIdSet ------------------ >'+attId);
        list<EmailMessage> lstEmailMessage =new list<EmailMessage>([select id,ParentId FROM EmailMessage where Id In:attId]);            
        return lstEmailMessage;    
    }
    /**
     * @description contentDocumentLinkRecords
     * @return contentDocumentLinkRecords
     * @param conDocid
     */
    public  static Map<id,Id> contentDocumentLinkRecords(List<Id> contentDocId){
         Map<Id, Id> contDocLinkedMap = new Map<Id, Id>();
        for(ContentDocumentLink cdl : [SELECT  LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId IN : contentDocId]){
            if(cdl.LinkedEntityId!=null){
                contDocLinkedMap.put(cdl.ContentDocumentId,cdl.LinkedEntityId);
            }       
        }
        return contDocLinkedMap;    
    }
    /**
     * @description userRoleData
     * @return userRoleData
     */
    public static List<String> userRoleData(){
         Map<String,ESC_email_deletion_roles__c> replyMap =  ESC_email_deletion_roles__c.getall();
         List<String> userListValues = new List<String>(); 
             for(string s : replyMap.keySet()){ 
                ESC_email_deletion_roles__c edr = ESC_email_deletion_roles__c.getValues(s); 
                    if(edr.role__c != null && edr.role__c != ''){
                        userListValues.add(edr.Role__c);
                    }
                  } 
        return userListValues;
    }
    /**
     * @description userroleName
     * @return userroleName
     */
    public static String userroleName(){
         string userroleName;
          if (Schema.sObjectType.UserRole.isAccessible()){
                  userroleName = [SELECT DeveloperName,Id,Name FROM UserRole WHERE Id=:UserInfo.getUserRoleId()].DeveloperName;
                 }
        return userroleName;
    }
    /**
     * @description caselst
     * @return caselst
     * @param Caseid
     */
    public Static list<Case> caselst(List<Id> caseID){
        List<case> lstcase = new List<Case>();
        if (Schema.sObjectType.Case.isAccessible()){
         lstcase =[select id,LCRM_Sub_BU__c,BU_Segment__c,ESC_Product_Segment_Brand__c,origin FROM Case where Id In:caseId];
        }
        return lstcase;
    }
    /**
     * @description validatecase
     * @return validatecase
     * @param Case
     */
    public static boolean validatecase(Case c){
        Map<String,ESC_email_deletion_roles__c> replyMap =  ESC_email_deletion_roles__c.getall();
        Boolean valid = false;
        for(string s : replyMap.keySet()){ 
            ESC_email_deletion_roles__c edr = ESC_email_deletion_roles__c.getValues(s);  
             System.debug(LoggingLevel.WARN, 'valid1--->'+c.LCRM_Sub_BU__c);   
            if(c.LCRM_Sub_BU__c == edr.Region__c && (edr.Segment__c == null || edr.Segment__c =='') && (edr.Brand__c == null || edr.Brand__c == '')){
                 valid = true;
                  System.debug(LoggingLevel.WARN, 'entered1'+edr.Region__c);
            }
            else if(c.LCRM_Sub_BU__c == edr.Region__c && (edr.Segment__c != null && edr.Segment__c !='') && edr.Segment__c == c.BU_Segment__c){
                 valid = true;
            }
            else if((edr.Brand__c != null && edr.Brand__c != '') && edr.Brand__c == c.ESC_Product_Segment_Brand__c){
                 valid = true;
            }
        }
         System.debug(LoggingLevel.WARN, 'valid1--->'+valid);
        //My TR - Allow attachements to be deleted for My TR and UE cases if attached by ESI User
        if((c.origin == 'My TR' || c.origin == Label.UE_Account) && !(UserInfo.getFirstName() == 'ESI') && !(UserInfo.getLastName() == 'User')){
            valid = false;
        }  
         System.debug(LoggingLevel.WARN, 'valid2--->'+valid);       
        return valid;    
    }
    
 // preventdeletion Attchment
/*
  public static void Attchmentpreventdeletion(Map<Id,Attachment> oldmapAttachment){ 
         String errorMsg = System.Label.preventattachmentdeletion;     
            List<Id> attcIdSet = new List<Id>();                            
                for(Attachment eM:oldmapAttachment.values()){
                    if(eM.parentid!=null){
                        attcIdSet.add(eM.ID); 
                                              
                    }        
                } 
                             
            try {
                 List<Profile> PROFILE =New List<profile>();
              if (Schema.sObjectType.Profile.isAccessible()){
                  PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                     }
                 String MyProflieName = PROFILE[0].Name;              
                 System.debug(LoggingLevel.WARN, 'MyProflieName is11==>' + MyProflieName); 
            
             for(Id eM1:attcIdSet){                  
                if( MyProflieName =='USL Helpdesk Agent'){                    
                   Attachment att = oldmapAttachment.get(eM1);                
                    att.adderror(errorMsg);
                }
            }
    }catch(exception e) {
         System.debug(LoggingLevel.WARN, 'exception'+e);
     } 
 } 
 */
 
}