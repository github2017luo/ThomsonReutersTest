/**
* CHANGE HISTORY
* ============================================================================================================================
* Date           Name             JIRA          Description
* ============================================================================================================================
* 
 * 2019-03-12   Vaishali Nagar           DSS        Trigger Handler to update Case Sub-Bu
   2019-03-14   Vaishali Nagar           DSS        Invocable method called from PB for Generic case routnig
* ============================================================================================================================
*/
/**
 * @description ESC_EmailUtility for prepopulate case fields
 */
public without sharing class ESC_EmailUtility{

     //to update the case SubBu from the ESC_QueueSelector_Email_id_List__mdt 
     /**
     * @description recursiveCheck
     */
    public static Boolean recursiveCheck = False;
    /**
     * @description setcaseFields 
     */
    public static Boolean setcaseFields = false;
    /**
     * @description updateCaseSubBu
     * @param emailMessageList
     */
    public static void updateCaseSubBu(List<EmailMessage> emailMessageList){
         List<EmailMessage> emailMessageLst = new List<EmailMessage>();
         List<ESC_QueueSelector_Email_id_List__mdt> queueSelectorList;
         Map<string,ESC_QueueSelector_Email_id_List__mdt> queueSelectorMap = new Map<string,ESC_QueueSelector_Email_id_List__mdt>();              
         Set<Id> emailIdSet = new Set<Id>();
         Map<Id,Case> caseMap;
         List<case> caseLst = new List<Case>();
         system.debug(LoggingLevel.WARN,'@@ emailMessageList:' + emailMessageList);
         for(EmailMessage eMsgObj:emailMessageList){
             
               if(eMsgObj.ParentId != null && string.valueOf(eMsgObj.ParentId).startsWith('500') && eMsgObj.Incoming && (eMsgObj.ToAddress!=null || eMsgObj.CcAddress!=null)){
                 emailIdSet.add(eMsgObj.ParentId);
             }
         }
         if(emailIdSet.size() >0 ){
             caseMap =new Map<Id,Case>([SELECT id,LCRM_Sub_Bu__c,BU_Segment__c,Origin,ESC_Origin_Name__c,Is_ESC_Case__c,Is_GLI__c,Sales_Org__c,ESC_Unique_Identifier__c from Case where id in:emailIdSet]);
         }
         system.debug(LoggingLevel.WARN,'@@caseMap:' + caseMap);
         if(caseMap !=null){
             for(EmailMessage emsg:emailMessageList){
                 if(caseMap.get(emsg.ParentId).Origin =='Email' && caseMap.get(emsg.ParentId).Is_ESC_Case__c ){
                         
                         emailMessageLst.add(emsg);
                     
                 }
             }
         }
         
         system.debug(LoggingLevel.WARN,'@@Email Message List:' + emailMessageLst);
         if(Schema.sObjectType.ESC_QueueSelector_Email_id_List__mdt.isQUeryable() && Schema.sObjectType.ESC_QueueSelector_Email_id_List__mdt.isAccessible()){
                queueSelectorList = [Select ESC_To_Email_Address__c,Sub_Bu__c,Bu_Segment__c,ESC_Is_GLI__c,ESC_Sales_Org__c,ESC_Case_Routing_Required__c,ESC_Unique_Identifier__c  from ESC_QueueSelector_Email_id_List__mdt];
                System.debug(LoggingLevel.WARN,'####queueSelectorList' +queueSelectorList);
         }
         if(queueSelectorList.size() >0){
             for(ESC_QueueSelector_Email_id_List__mdt queueSelector:queueSelectorList ){
                 queueSelectorMap.put(queueSelector.ESC_To_Email_Address__c,queueSelector);
             }
         }
         system.debug(LoggingLevel.WARN,'@@QueueSelectorMap:' + queueSelectorMap);
        if(emailMessageLst.size() >0){
            for(EmailMessage eMessage:emailMessageLst){
             
                 for(string toEmailAddress: queueSelectorMap.keySet()){
                     if((eMessage.toAddress!=null && eMessage.toAddress.containsIgnoreCase(toEmailAddress)) || (eMessage.CcAddress!=null && eMessage.CcAddress.containsIgnorecase(toEmailAddress))){
                         
                         system.debug(LoggingLevel.WARN,'to address '+toemailaddress);
                         system.debug(LoggingLevel.WARN,'queue map is'+queueSelectorMap.get(toEmailAddress));
                         caseMap.get(eMessage.ParentId).LCRM_Sub_BU__c = queueSelectorMap.get(toEmailAddress).Sub_Bu__c;
                         caseMap.get(eMessage.ParentId).ESC_Email_Origin__c= queueSelectorMap.get(toEmailAddress).ESC_To_Email_Address__c;
                         caseMap.get(eMessage.ParentId).Is_GLI__c = queueSelectorMap.get(toEmailAddress).ESC_Is_GLI__c;
                         caseMap.get(eMessage.ParentId).Sales_Org__c = queueSelectorMap.get(toEmailAddress).ESC_Sales_Org__c; 
                        caseMap.get(eMessage.ParentId).BU_Segment__c = queueSelectorMap.get(toEmailAddress).Bu_Segment__c;
                        caseMap.get(eMessage.ParentId).ESC_Unique_Identifier__c = queueSelectorMap.get(toEmailAddress).ESC_Unique_Identifier__c;
                         if(eMessage.toAddress.length() >255)
                         {
                             caseMap.get(eMessage.ParentId).ESC_Origin_Name__c = eMessage.toAddress<>null?eMessage.toAddress.substring(0,255):eMessage.CcAddress.substring(0,255);                       
                         }
                         else{
                             caseMap.get(eMessage.ParentId).ESC_Origin_Name__c = eMessage.toAddress<>null?eMessage.toAddress:eMessage.CcAddress;                       
                         }
                         //caseLst.add(caseMap.get(eMessage.ParentId));
                         
                         break;
                     }
                     
                 }                
                caseLst.add(caseMap.get(eMessage.ParentId));
             }
             try{
                 if(Schema.sObjectType.case.isUpdateable() &&!caseLst.isEmpty())
                 {
                    setcaseFields = true;
                    update caseLst;
                 }
             }catch(exception ex){
             
             }
             
        }
         system.debug(LoggingLevel.WARN,'@@caseLSt:' + caseLst);
        
    }
    
    //method to call from process builder to assign the case to queue
   
 /*   @InvocableMethod(label='GenericCaseRouting')
    public static void genericCaseQueueRouting(List<EmailMessage> emailMessageList){
    system.debug('@@ Emailmessage:' + emailMessageList.size());
    if(emailMessageList != null && !emailMessageList.isEmpty()) {
        try{
        List<Id> emIDSet = new List<Id>();
        Map<Id,case> caseMap;
        Set<string> subBu = new Set<String>();
        Set<String> toAddress = new Set<String>();
        Map<Id,EmailMessage> caseEMailMessageMap= new Map<Id,EmailMessage>();
        string caseFields = '';
        string query= '';
        string caseQuery = '';
        Map<string,ESC_QueueSelector_Email_id_List__mdt> queueSelectorMap = new Map<string,ESC_QueueSelector_Email_id_List__mdt>();
        for(EmailMessage eMsg:emailMessageList){
            if(eMsg.ParentId !=null && string.valueOf(eMsg.ParentId).startsWith('500')){
                emIDSet.add(eMsg.ParentId);
                caseEMailMessageMap.put(eMsg.ParentId,eMsg);
            }
        }
        
        if(emIDSet.size() > 0){
            caseMap = new Map<Id,case>([SELECT id,LCRM_Sub_Bu__c,ESC_Email_Origin__c,ESC_Origin_Name__c from case where id in:emIDSet]);
            for(Id caseId:caseMap.keySet()){
                subBu.add(caseMap.get(caseId).LCRM_Sub_Bu__c);
                toAddress.add(caseMap.get(caseId).ESC_Email_Origin__c);
            }
        }
        Map < String, String > emailMessageLKPValueMap = new Map < String, String > ();
        Map < String, String > emailMessageSearchValueMap = new Map < String, String > ();
        
        for( ESC_QueueSelector_Email_id_List__mdt queueSelectorObj:[SELECT ESC_API_Names__c,ESC_Search_Field_Set__c,Sub_Bu__c,ESC_To_Email_Address__c from ESC_QueueSelector_Email_id_List__mdt 
                                where (Sub_Bu__c in:subBu and ESC_To_Email_Address__c in:toAddress)]){
            
            if(!queueSelectorMap.containsKey(queueSelectorObj.Sub_Bu__c+':'+queueSelectorObj.ESC_To_Email_Address__c)){
                queueSelectorMap.put(queueSelectorObj.Sub_Bu__c+':'+queueSelectorObj.ESC_To_Email_Address__c,queueSelectorObj);
            }
            List<string> fieldApiList = new List<string>();
            List <string> searchApiList = new List<string>();
            if(queueSelectorObj.ESC_API_Names__c!=null){
               fieldApiList = queueSelectorObj.ESC_API_Names__c.split(',');
                for(string fieldApi:fieldApiList){
                     if(fieldApi.contains('.') && !caseFields.contains(fieldApi.split('\\.').get(1)) && !fieldApi.containsIgnoreCase('ESC_Email_Origin__c')){
                        caseFields+=fieldApi.split('\\.').get(1)+',';
                    }
                }
            }
            if(queueSelectorObj.ESC_Search_Field_Set__c!=null){
            searchApiList = queueSelectorObj.ESC_Search_Field_Set__c.split(',');
                for(string searchApi:searchApiList){
                    if(searchApi.contains('.') && !caseFields.contains(searchApi.split('\\.').get(1)) && !searchApi.containsIgnoreCase('ESC_Email_Origin__c')){
                        caseFields+=searchApi.split('\\.').get(1)+',';
                    }
                    
                }
            }
            
            }
        //query= 'SELECT id,'+combinedFields+'ParentId,Parent.LCRM_Sub_Bu__c FROM EmailMessage WHERE ParentId IN :keyIds';
        if(caseFields!=null && caseFields!=''){
            caseQuery = 'SELECT id,'+caseFields+'ESC_Email_Origin__c,LCRM_Sub_Bu__c FROM Case WHERE id IN: emIDSet';
        }else{
            caseQuery = 'SELECT id,LCRM_Sub_Bu__c,ESC_Email_Origin__c FROM Case WHERE id IN:emIDSet';
        }
            system.debug('### dynamic query case ###' +caseQuery);
            List<Case> caseList = Database.query(caseQuery);
            system.debug('### casequery ###' + caseList);
            for(Case caseObj:caseList){
            ESC_QueueSelector_Email_id_List__mdt queueSelector = queueSelectorMap.get(caseObj.LCRM_Sub_Bu__c+':'+caseObj.ESC_Email_Origin__c);
            List<string> fieldApiLst = new List<string>();
            List<string> searchApiList =new List<string>();
            string lkp='';
            string searchLkp = '';
            if(queueSelector.ESC_API_Names__c!=null){
                fieldApiLst = queueSelector.ESC_API_Names__c.split(',');
                for(string fs:fieldApiLst){
                    if(!fs.contains('.')){
                        lkp+=string.valueOf(caseEmailMessageMap.get(caseObj.Id).get(fs));
                    }else{
                        lkp+=caseObj.get(fs.split('\\.').get(1));
                    }
                }
            }
            if(queueSelector.ESC_Search_Field_Set__c!=null){
                searchApiList = queueSelector.ESC_Search_Field_Set__c.split(',');
                    for(string searchvalue:searchApiList){
                    
                    if(!searchValue.contains('.')){
                        searchLkp+=string.valueOf(caseEMailMessageMap.get(caseObj.Id).get(searchvalue));
                    }else{
                        searchLkp+=caseObj.get(searchvalue.split('\\.').get(1));
                    }
                }
            }
            if(lkp!='' && lkp!=null){
                emailMessageLKPValueMap.put(caseObj.Id,lkp);
            }
            if(searchLkp!='' && searchLkp!=null){
                emailMessageSearchValueMap.put(caseObj.Id,searchLkp);
            }
            
        }
    System.debug('### emailMessageLKPValueMap ### ' + emailMessageLKPValueMap);
        System.debug('### emailMessageSearchValueMap ### ' + emailMessageSearchValueMap);
        Map<string,List<ESC_QueueSelectorList__c>> queueSelectorLkpMap = new Map<string,List<ESC_QueueSelectorList__c>>();
        if(!emailMessageLKPValueMap.isEmpty()){
             for(ESC_QueueSelectorList__c queueSelectLkpObj:[SELECT ESC_LKP__c,ESC_Queue_Name__c,ESC_Search_Field1__c,ESC_Search_Field2__c,ESC_Search_Field3__c,ESC_Search_Field4__c,ESC_Search_Field5__c FROM ESC_QueueSelectorList__c WHERE ESC_LKP__c in:emailMessageLKPValueMap.values()]){
                if(queueSelectorLkpMap.containsKey(queueSelectLkpObj.ESC_LKP__c)){
                
                    queueSelectorLkpMap.get(queueSelectLkpObj.ESC_LKP__c).add(queueSelectLkpObj);
                }else{
                    queueSelectorLkpMap.put(queueSelectLkpObj.ESC_LKP__c,new List<ESC_QueueSelectorList__c>{queueSelectLkpObj});
                }
            }
        }
       
        Map < Id, String > caseQueueMap = new Map < Id, String > ();
        Map<Id, List<ESC_QueueSelectorList__c >> caseQueueObjMap = new Map<Id, List<ESC_QueueSelectorList__c >>();
        for(Id caseId:emailMessageLKPValueMap.keySet()){
            
            List<ESC_QueueSelectorList__c> queueSelectorList = queueSelectorLkpMap.get(emailMessageLKPValueMap.get(caseId));
            if(queueSelectorList!=null && !queueSelectorList.isEmpty()){
                if(queueSelectorList.size() ==1 || emailMessageSearchValueMap.get(caseId)==null){
                    caseQueueMap.put(caseId, queueSelectorList.get(0).ESC_Queue_Name__c);
                } else {
                    caseQueueObjMap.put(caseId,queueSelectorList);
                }
            }
            
        }
        system.debug('### caseQueueObjMAp ###' + caseQueueObjMap);
        //and check of CustomMetadata searchfieldvalue with customobject search field values
        if(caseQueueObjMap!=null && !caseQueueObjMap.isEmpty()){
            for(Id caseId:caseQueueObjMap.keyset()){
                string searchValue = emailMessageSearchValueMap.get(caseId);
                system.debug('### searchValue ###' + searchValue);
                if(searchValue!=null && searchValue!=''){
                    List<ESC_QueueSelectorList__c > queueSelectList = caseQueueObjmap.get(caseId);
                    for(ESC_QueueSelectorList__c queueSelectObj:queueSelectList ){
                    string searchValueObj = queueSelectObj.ESC_Search_Field1__c + queueSelectObj.ESC_Search_Field2__c + queueSelectObj.ESC_Search_Field3__c + queueSelectObj.ESC_Search_Field4__c + queueSelectObj.ESC_Search_Field5__c;
                        system.debug('### searchValueObj ###' + searchValueObj);
                        if(searchValueObj.remove('null').equalsIgnoreCase(searchValue) || (queueSelectObj.ESC_Search_Field1__c!=null && searchValue.containsIgnoreCase(queueSelectObj.ESC_Search_Field1__c) && queueSelectObj.ESC_Search_Field2__c!=null && searchValue.containsIgnoreCase(queueSelectObj.ESC_Search_Field2__c))){
                            caseQueueMap.put(caseId,queueSelectObj.ESC_Queue_Name__c);
                            break;
                        }
                    
                    }
                    if(caseQueueMap.containsKey(caseId)){
                        caseQueueObjmap.remove(caseId);
                    }
                }
                
            }
        }
        
        //OR check of CustomMetadata searchfieldvalue with customobject search field values in case AND condition is not satisfied
            if(caseQueueObjMap !=null && !caseQueueObjMap.isEmpty()){
                for(Id caseId:caseQueueObjMap.keyset()){
                    string searchValue = emailMessageSearchValueMap.get(caseId);
                    system.debug('### searchValue ###' + searchValue);
                    List<ESC_QueueSelectorList__c > queueSelectList = caseQueueObjmap.get(caseId);
                    if(queueSelectList !=null && !queueSelectList.isEmpty() && searchValue!=null){
                        for(ESC_QueueSelectorList__c queueSelectObj:queueSelectList ){
                        
                            system.debug('### searchValueObj ###' + queueSelectObj.ESC_Search_Field1__c +queueSelectObj.ESC_Search_Field1__c+queueSelectObj.ESC_Search_Field2__c+queueSelectObj.ESC_Search_Field3__c+queueSelectObj.ESC_Search_Field4__c + queueSelectObj.ESC_Search_Field5__c);
                            if((queueSelectObj.ESC_Search_Field1__c!=null && searchValue.containsIgnoreCase(queueSelectObj.ESC_Search_Field1__c))|| ( queueSelectObj.ESC_Search_Field2__c!=null && searchValue.containsIgnoreCase(queueSelectObj.ESC_Search_Field2__c)) || (queueSelectObj.ESC_Search_Field3__c!=null && searchValue.containsIgnoreCase(queueSelectObj.ESC_Search_Field3__c))){
                                caseQueueMap.put(caseId,queueSelectObj.ESC_Queue_Name__c);
                                break;
                            }
                        
                        }
                    }
                    
                    
                }
            }
            
        system.debug('### caseQueueMap ###' + caseQueueMap);
        
        if(caseQueueMap!=null){
            Map<string,ID> caseQueueMapId = new Map<string,ID> ();
            for(Group grpList: [SELECT Id,Name,DeveloperName,Type FROM Group where type='Queue' AND DeveloperName IN: caseQueueMap.values()]){
                system.debug('### qrpList ###' + grpList);
                if(!caseQueueMapId.containsKey(grpList.DeveloperName)){
                    caseQueueMapId.put(grpList.DeveloperName,grpList.Id);
                }
            }
            
            system.debug('### caseQueueMapId ###' + caseQueueMapId);
            List<case> caseIdLst = new List<case>();
            for(Id csIds:caseQueueMap.keyset()){
                if(caseQueueMapId.get(caseQueueMap.get(csIds))!=null){
                    Case cs = new Case();
                    cs.Id = csIds;
                    cs.ownerId = caseQueueMapId.get(caseQueueMap.get(csIds));
                    caseIdLst.add(cs);
                }
                
           }
           system.debug('### caseIdLst ###' + caseIdLst);
                if(caseIdLst!=null && !caseIdLst.isEmpty()) {
                  if(Schema.sObjectType.case.isUpdateable() ){
                    update(caseIdLst);
                   }
                   
               }
           
        }
        }catch(Exception ex){
    
    } 
        
        
        
    }
    
  }  */
}