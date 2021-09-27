/***************************************************************************************************
Class Name : HATriggerHandler
Description : This class will handle the logic for UPD Flags(Customer, Resolver and Owner)
-----------------------------------------------------------------------------------------------------
Date              Author        Version            Comments
07-May-2018       Karthi G        1.0               Initial Development
*****************************************************************************************************/
public without sharing class ESC_UPD_Utility {
     /***************************************************************************************************
    Method to Update UPD flag on the Help App Cases based on subscribed fields from FieldSet.
    
    Referenced from Class: HATriggerHandler
    *****************************************************************************************************/
    public static void updFlagHelper(Map<Id,Sobject> newSobjectMap,Map<Id,Sobject> oldSobjectMap){
        Id sampleId = (new list<Id>(newSobjectMap.keySet()))[0];
        String objectType=sampleId.getSObjectType().getDescribe().getName();
        List<Schema.FieldSetMember> updFields = new List<Schema.FieldSetMember>();
        Map<String,List<Schema.FieldSetMember>> updFieldMap= new Map<String,List<Schema.FieldSetMember>>();
        Map<String,List<String>> updFieldAPIMap= new Map<String,List<String>>();
        Set<String> fsAPINameList = new Set<String>();
        List<String> updFlagsList = new List <String>();
        Map<Id,Id> contactCustomerMap= new Map<Id,Id>();
        List<Id> contactIdList= new List<Id>();
        String existingLabelVal = Label.ESC_ViaNormal;
        Id currentUserId = UserInfo.getuserId();
        try{
            if(objectType=='Case'){
                for(Sobject cs: newSobjectMap.values()){
                    contactIdList.add((ID)cs.get('ContactId'));
                }
                for(User us :[Select Id,ContactId from User where ContactId In :contactIdList]){
                    contactCustomerMap.put(us.ContactId,us.Id);
                }
            }
            
            ESC_UpdFieldSetting__c customData =ESC_UpdFieldSetting__c.getInstance();
            if(test.isRunningTest()){
            system.debug('customData setting values:' +customData.ESC_ObjectName__c);
            system.debug('customData:' +customData);
            }
            if(customData != null && customData.ESC_ObjectName__c != null){
                if(customData.ESC_CustomerUPD__c != null){
                    List<String> splitData= customData.ESC_CustomerUPD__c.Split(',');
                    updFieldMap.put(splitData[1],ESC_Utility.readFieldSet(splitData[0],customData.ESC_ObjectName__c));
                }
                if(customData.ESC_OwnerUPD__c != null){
                    List<String> splitData1= customData.ESC_OwnerUPD__c.Split(',');
                    updFieldMap.put(splitData1[1],ESC_Utility.readFieldSet(splitData1[0],customData.ESC_ObjectName__c));
                }
                if(customData.ESC_ResloverUPD__c != null){
                    List<String> splitData2= customData.ESC_ResloverUPD__c.Split(',');
                    updFieldMap.put(splitData2[1],ESC_Utility.readFieldSet(splitData2[0],customData.ESC_ObjectName__c));
                }
            }
            for(String fs:updFieldMap.keyset()){
                List<String> tempAPIList = new List<String>();
                 for(Schema.FieldSetMember fs1:updFieldMap.get(fs)){
                 if(!fsAPINameList.contains(fs1.getFieldPath())){
                     fsAPINameList.add(fs1.getFieldPath());
                 }
                    
                    tempAPIList.add(fs1.getFieldPath());
                    }
                    updFieldAPIMap.put(fs,tempAPIList);
                }
            for(SObject rec : newSobjectMap.values()){
                SObject newSobj=(SObject)rec;
                SObject oldSobj=(SObject)oldSobjectMap.get(rec.Id);
                
                Boolean updActionFld = false;
                Boolean updResActionFld = false;
                Boolean updCustActionFld = false;
                for(String updFld:updFieldAPIMap.keyset()){
                    System.debug('updFld:-->'+updFld);
                    for(String fsField : fsAPINameList){
                        if(newSobj.get(fsField) != oldSobj.get(fsField)){
                            system.debug('newSobj fsField :'+newSobj.get(fsField));
                            system.debug('oldSobj fsField :'+oldSobj.get(fsField));
                            if((updFieldAPIMap.get(updFld)).contains(fsfield)){
                            
                                if(newSobj.get('OwnerId')==currentUserId){
                                    if(updFld.containsIgnoreCase('Customer') && contactCustomerMap.size()>0){
                                        updCustActionFld = true;
                                        newSobj.put(updFld,true);
                                    }else if(updFld.containsIgnoreCase('Resolver') && newSobj.get('ESC_ResolverID__c') != null){
                                        updResActionFld = true;
                                        newSobj.put(updFld,true);
                                    }
                                    
                                    /*if((!updFld.containsIgnoreCase('Owner') && newSobj.get('ESC_ResolverID__c') != null) || (!updFld.containsIgnoreCase('Owner') && contactCustomerMap.size()>0))
                                        newSobj.put(updFld,true);
                                        system.debug('Inside first if owner');*/
                                }
                                else if( contactCustomerMap.size()>0 && contactCustomerMap.get((Id)newSobj.get('ContactId'))==currentUserId){
                                    if(updFld.containsIgnoreCase('Resolver') && newSobj.get('ESC_ResolverID__c') != null){
                                        updResActionFld = true;
                                        newSobj.put(updFld,true);
                                    }else if(updFld =='ESC_UPD__c'){
                                        updActionFld = true;
                                        newSobj.put(updFld,true);
                                    }
                                    
                                }
                                else if(newSobj.get('ESC_ResolverID__c') != null && newSobj.get('ESC_ResolverID__c')==currentUserId ){
                                    if(updFld.containsIgnoreCase('Customer')&& contactCustomerMap.size()>0){
                                        updCustActionFld = true;
                                        newSobj.put(updFld,true);
                                    }else if(updFld =='ESC_UPD__c'){
                                        updActionFld = true;
                                        newSobj.put(updFld,true);
                                    }
                                    
                                }
                                else{
                                
                                if(updFld.containsIgnoreCase('Customer') && contactCustomerMap.size()>0){
                                    updCustActionFld = true;
                                    newSobj.put(updFld,true);
                                }else if( updFld.contains('Resolver')&& newSobj.get('ESC_ResolverID__c') != null){
                                    updResActionFld = true;
                                    newSobj.put(updFld,true); 
                                    
                                }else if(updFld=='ESC_UPD__c' && newSobj.get('OwnerId')!=currentUserId){
                                    
                                    updActionFld = true;
                                    newSobj.put(updFld,true); 
                                }
                                    system.debug('Inside else admin');
                                }
                                
                                newSobj.put('ESC_Last_Update__c','Modified by '+UserInfo.getName());
                                
                            }
                            
                        }
                    }

                }
                System.debug('updActionFld:-->'+updActionFld+'updResActionFld-->'+updResActionFld+'updCustActionFld-->'+updCustActionFld);
                if(updActionFld){
                    String fldAPI = 'ESC_UPD_Action__c';
                    updateActionField(newSobj,fldAPI);
                }
                if(updResActionFld){
                    String fldAPI = 'ESC_Resolver_UPD_Action__c';
                    updateActionField(newSobj,fldAPI);
                }
                if(updCustActionFld){
                    String fldAPI = 'ESC_Customer_UPD_Action__c';
                    updateActionField(newSobj,fldAPI);
                }
                
            }
        }
        catch(Exception e){
            System.debug('UPD Flag Error' +e.getMessage());
        }
    }
    
    public static void updateActionField(SObject newSobj, String fldAPI){
        String oldVal = (String)newSobj.get(fldAPI);
         String existingLabelVal = Label.ESC_ViaNormal;           
        if(string.isBlank(oldVal) || oldVal == null ){
            system.debug('entered first if with oldval'+oldVal);
            newSobj.put(fldAPI,'1# ' +existingLabelVal);
            system.debug('Count in first if loop : 1 count via manual update');
        }
        else{
            system.debug('entered first else with oldval'+oldVal);
            if(oldVal.indexOf(existingLabelVal) == -1 ){
                system.debug('entered first else if with oldval'+oldVal.indexOf(existingLabelVal));
                newSobj.put(fldAPI,oldVal+',1#' +existingLabelVal);
                system.debug('Count in first else if loop : 1 count via manual update');
            } else {
                system.debug('entered first else if else with oldval'+oldVal);
                string newValPattern = '';
                string newVal = '';
                for(string currString  : oldVal.split( ',')){
                    system.debug('entered for'+currString);
                    if(currString.indexOf(existingLabelVal) != -1){
                        integer newCount = integer.valueOf(currString.split('#')[0]) + 1;
                        newVal = newCount+'#'+ existingLabelVal;
                       system.debug('Count in first else if loop : 1 count via manual update-->'+newVal);
                    }else{
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
              //caseRec.ESC_UPD_Action__c =  newValPattern;
              newSobj.put(fldAPI,newValPattern);
            
            }
        
        }
    }
    
    public static void caseUPDCustomerAttachment(List<Attachment> attachList){
        List<Id> caseIdList= new List<Id>();
        List<case> updateList = new List<case>();
         User u = new User();
         if(Schema.sObjectType.User.isQUeryable() && Schema.sObjectType.User.isAccessible()){
             u=[Select Id,ContactId from User where id =:UserInfo.GetUserId() LIMIT 1];
        }
        for(Attachment a:attachList){
        system.debug('a***'+a.ParentId);
        if(a.ParentId!=null){
            if(((String)a.ParentId).StartsWith('500')){
                caseIdList.add(a.parentId);
            }
            }
        }
        if(caseIdList.Size()>0){
            for(Case c:[Select Id,contactId,ESC_UPD_Customer__c,IS_ESC_Case__c from Case where id in: CaseIdList]){
                if(c.IS_ESC_Case__c && c.ContactId!=null && u.ContactId!=null && u.ContactId==c.ContactId){
                    c.ESC_UPD_Customer__c=true;
                    c.ESC_Last_Update__c='File Added By Customer';
                }
                updateList.add(c);
            }
            if(updateList.Size()>0)
            {
                if(Schema.sObjectType.case.isAccessible() || Schema.sObjectType.case.isUpdateable()){
                        Update updateList;
                }
            }
        }
    }
    
    public static void updateCaseUPD(List<FeedItem> refFeedList){
         
        
        Set<id> caseId = new Set<Id>();
        Set<id> casRefId = new Set<Id>();
        List<Case> csupdateList = new List<Case>();
        List<Case> csResolverUpdList = new List<Case>();
        List<FeedItem> postToCaseList = new List<FeedItem>();
        Map<FeedItem,id> refFeedMap = new Map<FeedItem,Id>();
        //List<ESC_Case_Collaborator__c>  refList = List<ESC_Case_Collaborator__c>();
        Map<id,ESC_Case_Collaborator__c> refMap = new Map<id,ESC_Case_Collaborator__c>();
        for(FeedItem rf:refFeedList){
            refFeedMap.put(rf,rf.parentid);
        }
        
        if(refFeedMap.size()>0){
            
            for(ESC_Case_Collaborator__c ref : [Select id, ESC_Case__c,ESC_Case__r.OwnerId, OwnerId , RecordType.Name from ESC_Case_Collaborator__c where id IN :refFeedMap.values() AND RecordType.Name = :Label.ESC_RefRecordType]){
                refMap.put(ref.id,ref);
            }
            
            /**(ESC_Case_Collaborator__c ref :refList){
                
                caseId.add(ref.ESC_Case__c);
                
            }**/
            if(refMap.size()>0){
                
                for(FeedItem fi:refFeedList){
                    ESC_Case_Collaborator__c ref = refMap.get(refFeedMap.get(fi));
                    System.debug('Referrral:-'+ref);
                    if(fi.createdbyid != ref.ESC_Case__r.OwnerId){
                    System.debug('Owner');
                        caseId.add(ref.ESC_Case__c);
                        postToCaseList.add(fi);
                    } 
                    if(fi.createdbyid != ref.OwnerId) {
                    System.debug('Resolver');
                        casRefId.add(ref.ESC_Case__c);
                    }
                }
                
                if(casRefId.size()>0){
                    for(Case cs : [Select id,ESC_UPD_Action__c,ESC_UPD_Resolver__c from Case where Id IN :casRefId]){
                        cs.ESC_UPD_Resolver__c = true;
                        csResolverUpdList.add(cs);
                    }
                }
                if(csResolverUpdList.size()>0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
                        update csResolverUpdList;
                    }
                if(caseId.size()>0){
                    for(Case cs : [Select id,ESC_UPD_Action__c,ESC_UPD__c from Case where Id IN :caseId]){
                        cs.ESC_UPD__c = true;
                        String oldVal = String.ValueOf(cs.ESC_UPD_Action__c);
                        System.debug('updateupd');
                        if(String.isBlank(oldVal)){
                            cs.ESC_UPD_Action__c = '#1 '+Label.ESC_ReferralFeed;
                        } else{
                            /**String splitVal = currentVal.split(' ')[0];
                            System.debug('splistring :-'+splitVal);
                            integer newCount = Integer.ValueOf(splitVal.split('#')[1]) +1;
                            System.debug('newCount: '+newCount);
                            cs.ESC_UPD_Action__c = '#'+newCount+' '+Label.ESC_ReferralFeed;**/
                             if(oldVal.indexOf(Label.ESC_ReferralFeed) == -1 ){
                                 system.debug('add 1');
                                 cs.ESC_UPD_Action__c = oldVal+',#1'+' '+Label.ESC_ReferralFeed;
                                 System.debug('val'+cs.ESC_UPD_Action__c);
                             } else{
                            string newValPattern = '';
                            string newVal = '';
                                for(string currString  : oldVal.split( ',')){
                                    if(currString.indexOf(Label.ESC_ReferralFeed)!= -1){
                                        String splitVal = currString.split(' ')[0];
                                        System.debug('splistring :-'+splitVal);
                                        integer newCount = Integer.ValueOf(splitVal.split('#')[1]) +1;
                                        newVal = '#'+newCount+' '+Label.ESC_ReferralFeed;
                                    } else{
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
                                 cs.ESC_UPD_Action__c = newValPattern;
                             }
                        }
                        csupdateList.add(cs);
                    }
                    if(csupdateList.size()>0){
                        
                        update csupdateList;
                    }
                    if(postToCaseList.size()>0){
                        postFeedonCase(postToCaseList);
                    }
                    
                }
            }
        }
    }
    
   
    public static void postFeedonCase(List<FeedItem> postToCaseList){
        
        
     Map<FeedItem,id> refFeedMap = new Map<FeedItem,Id>();
      Map<id,ESC_Case_Collaborator__c> refMap = new Map<id,ESC_Case_Collaborator__c>();
      List<FeedItem> insertFeedList = new List<FeedItem>();
     if(postToCaseList.size()>0){
        for(FeedItem rf:postToCaseList){
            refFeedMap.put(rf,rf.parentid);
        }
        
        if(refFeedMap.size()>0){
            for(ESC_Case_Collaborator__c ref : [Select id, ESC_Case__c,ESC_Case__r.OwnerId, OwnerId,Name,RecordType.Name from ESC_Case_Collaborator__c where id IN :refFeedMap.values() AND RecordType.Name = :Label.ESC_RefRecordType]){
                refMap.put(ref.id,ref);
            }
            
            if(refMap.size()>0){
                for(FeedItem caseFeed :postToCaseList){
                    FeedItem newFeed = new FeedItem();
                    newFeed.parentId = refMap.get(refFeedMap.get(caseFeed)).ESC_Case__c;
                    newFeed.Body = Label.ESC_CaseFeed+' '+refMap.get(refFeedMap.get(caseFeed)).Name;
                    insertFeedList.add(newFeed);
                }
                
                if(insertFeedList.size()>0){
                    if(Schema.sObjectType.FeedItem.isCreateable()){
                        insert insertFeedList;
                    }
                }
            }
        }
     }
    }
     
        
        
}