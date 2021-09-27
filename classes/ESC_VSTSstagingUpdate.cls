public without sharing class ESC_VSTSstagingUpdate {
    public static boolean isvstsContext = false;
    public static void updateVSTSstaging(List<SObject> NewFeed){
        
        Map<Id,List<String>> caseIdMap = new Map<Id,List<String>>();        
        ESC_VSTS_Routing__c vstsdetails = ESC_VSTS_Routing__c.getInstance();
        try{
            Map<Id,Group> OwnerMap = new Map<Id,Group>([Select id,Name from Group where Type='Queue' and DeveloperName in :vstsDetails.VSTSAssignmentGroup__c.split(',')]);
            List<String> qnames = vstsDetails.VSTSAssignmentGroup__c.split(',');
            if(qnames.size()>0){
            caseIdMap = removetheSpecialCharactor(NewFeed,qnames);
            }           
            
           if(caseIdMap.size()>0){
            Map<String,String> specialInstructionMap= new Map<String,String>();
            String RecordtypeID=Schema.SObjectType.ESC_Special_Instruction__c.getRecordTypeInfosByName().get('Account Instruction').getRecordTypeId();
            System.debug('RecordtypeID of special instruction>>>' +RecordtypeID);
            system.debug('Map value>>' +caseIdMap.keyset());
             
             List<ESC_Case_Special_Instruction__c> testCPI=[Select id,ESC_Case__c,ESC_Special_Instruction__r.RecordType.Id,ESC_Special_Instruction__r.ESC_Category_Account__c,ESC_Special_Instruction__r.ESC_Instructions__c from ESC_Case_Special_Instruction__c where ESC_Case__c in:caseIdMap.keyset() AND ESC_Special_Instruction__r.RecordType.Id=:RecordtypeID AND ESC_Special_Instruction__r.ESC_Status__c='Active'];
            for(ESC_Case_Special_Instruction__c sp :testCPI){
                if(sp.ESC_Special_Instruction__r.ESC_Category_Account__c=='Premium Support Account' && sp.ESC_Special_Instruction__r.ESC_Instructions__c=='A'){
                    specialInstructionMap.put(sp.ESC_Case__c,'A');
                    break;
                }
                else{
                    specialInstructionMap.put(sp.ESC_Case__c,'B');
                }
            }
            
            List<ESC_VSTS_Staging__c> StagingList= new List<ESC_VSTS_Staging__c>();
            List<ESC_VSTS_Staging__c> UpdatedStagingList = new List<ESC_VSTS_Staging__c>();
            List<Id> NewStagCaseIdList = new List<Id>();
            //code block start for DSS-5235
            Map<String,ESC_VSTS_Product_List__c> ProdListmap = ESC_VSTS_Product_List__c.getall();
            Set<string> ProdList =ProdListmap.keySet();
           
                
                List<ESC_Case_Collaborator__c> listCC=[Select Id,ESC_Case__r.Id, ESC_Case__r.SAP_Account_Number__c,ESC_Case__r.ESC_Severity__c,ESC_Case__r.CaseNumber,ESC_Case__r.CreatedDate,ESC_Case__r.ESC_VSTS_Description__c,
                    ESC_Case__r.Description,ESC_Case__r.GGO_Product_Complement_2__c,ESC_Case__r.Account.RecordType.Name,ESC_Case__r.GGO_Product_Version__c,ESC_Case__r.Product__c,ESC_Case__r.ESC_IsAllowRepDB__c,ESC_Case__r.Account.name,ESC_Case__r.Priority,ESC_Case__r.Subject,ESC_Case__r.Owner.name,ESC_Case__r.ESC_Diagnosis_Summary__c,ESC_Case__r.Status from ESC_Case_Collaborator__c where ESC_Case__c In:caseIdMap.KeySet() and ESC_Referral_Status__c!='Closed' and ESC_Referral_Status__c!='Completed' and ESC_Role__c In :vstsDetails.ESC_Referral_Role__c.split(',') and OwnerId IN :OwnerMap.Keyset()];
                for(ESC_Case_Collaborator__c cs:listCC){
        
                    ESC_VSTS_Staging__c updStaging = new ESC_VSTS_Staging__c();
                    if(cs.ESC_Case__r.SAP_Account_Number__c==null || cs.ESC_Case__r.SAP_Account_Number__c==''){
                        updStaging.ESC_SAP_Account_Num__c='Empty';
                    }
                    else{
                        updStaging.ESC_SAP_Account_Num__c= cs.ESC_Case__r.SAP_Account_Number__c;
                    }
                    if(cs.ESC_Case__r.Account==null){
                        updStaging.ESC_Account_Name__c='Empty';
                    }
                    else{
                        updStaging.ESC_Account_Name__c=cs.ESC_Case__r.Account.name;
                    }
                    if(cs.ESC_Case__r.ESC_Severity__c=='Null' || cs.ESC_Case__r.ESC_Severity__c==null || cs.ESC_Case__r.ESC_Severity__c==''){
                        updStaging.ESC_Case_Severity__c='4 - Non-Service Affecting';
                    }
                    //added for DSS-9094
                    else if(cs.ESC_Case__r.ESC_Severity__c=='Critical'){
                        updStaging.ESC_Case_Severity__c='1 - High';
                    }
                    else{
                    updStaging.ESC_Case_Severity__c=cs.ESC_Case__r.ESC_Severity__c;
                    }
                    updStaging.ESC_Case_Number__c=cs.ESC_Case__r.CaseNumber;
                    updStaging.ESC_Case_Created_Date__c=cs.ESC_Case__r.CreatedDate;
                    updStaging.ESC_Case_Owner__c=cs.ESC_Case__r.Owner.name;
                    if((cs.ESC_Case__r.Description==null || cs.ESC_Case__r.Description=='')&& (cs.ESC_Case__r.ESC_VSTS_Description__c ==null || cs.ESC_Case__r.ESC_VSTS_Description__c =='')){
                        updStaging.ESC_Case_Description__c='Empty';
                    }
                    else if((cs.ESC_Case__r.Description==null || cs.ESC_Case__r.Description=='') && (cs.ESC_Case__r.ESC_VSTS_Description__c !=null && cs.ESC_Case__r.ESC_VSTS_Description__c !='')){
                        updStaging.ESC_Case_Description__c=cs.ESC_Case__r.ESC_VSTS_Description__c;
                    }
                    else if((cs.ESC_Case__r.Description!=null && cs.ESC_Case__r.Description !='') && (cs.ESC_Case__r.ESC_VSTS_Description__c ==null || cs.ESC_Case__r.ESC_VSTS_Description__c =='')){
                        updStaging.ESC_Case_Description__c=cs.ESC_Case__r.Description;
                    }
                    else{
                        updStaging.ESC_Case_Description__c=cs.ESC_Case__r.Description + '\n' + cs.ESC_Case__r.ESC_VSTS_Description__c;
                    }
                    if(cs.ESC_Case__r.Priority==null || cs.ESC_Case__r.Priority==''){
                        updStaging.ESC_Case_Priority__c='3 - Low';
                    }
                    else{
                        updStaging.ESC_Case_Priority__c=cs.ESC_Case__r.Priority;
                    }
                    updStaging.ESC_Referral_Id__c=cs.Id;
                    updStaging.ESC_Case_Id__c=cs.ESC_Case__c;
                    //code block start for DSS-5235
                    if(cs.ESC_Case__r.ESC_Diagnosis_Summary__c==null || cs.ESC_Case__r.ESC_Diagnosis_Summary__c==''){
                        updStaging.ESC_Case_Diagnosis__c='Empty';
                    }
                    else if(cs.ESC_Case__r.ESC_Diagnosis_Summary__c == 'Assistive Technology'){
                        updStaging.ESC_Case_Diagnosis__c='1';
                    }
                    else{
                        updStaging.ESC_Case_Diagnosis__c='2';
                    }
                    if(cs.ESC_Case__r.Subject==null || cs.ESC_Case__r.Subject==''){
                        updStaging.ESC_Case_Subject__c='Empty';
                    }
                    else if((cs.ESC_Case__r.Subject).length() > Integer.ValueOf(Label.VSTS_Subject_length)) {
                        updStaging.ESC_Case_Subject__c=(cs.ESC_Case__r.Subject).left(Integer.ValueOf(Label.VSTS_Subject_length));
                    }
                    else
                    {
                        updStaging.ESC_Case_Subject__c=cs.ESC_Case__r.Subject;
                    }
                    if(prodList.contains(cs.ESC_Case__r.Product__c)){
                        ESC_VSTS_Product_List__c myCS1 = ESC_VSTS_Product_List__c.getValues(cs.ESC_Case__r.Product__c);
                        updStaging.ESC_Case_Product__c = myCS1.Product_Code__c;
                    }
                    //code block end for DSS-5235
                    updStaging.ESC_Staging_Status__c='Pending';
                    updStaging.ESC_IsAllowRepDB__c=cs.ESC_Case__r.ESC_IsAllowRepDB__c;
                    
                    if(specialInstructionMap.size()>0){
                          updStaging.ESC_Customer_Category__c=specialInstructionMap.get(cs.ESC_Case__c);
                    }
                    if(cs.ESC_Case__r.GGO_Product_Complement_2__c==null || cs.ESC_Case__r.GGO_Product_Complement_2__c==''){
                        updStaging.ESC_Case_Product_Complement__c='Empty';
                    }
                    else{
                        updStaging.ESC_Case_Product_Complement__c=cs.ESC_Case__r.GGO_Product_Complement_2__c;
                    }
                    
                    updStaging.ESC_Case_Product_Version__c=cs.ESC_Case__r.GGO_Product_Version__c;
                    
                    if(cs.ESC_Case__r.Account.RecordType.Name=='Customer'){
                        updStaging.ESC_Is_Customer__c=true;
                    }
                    else{
                        updStaging.ESC_Is_Customer__c=false;
                    }
                    updStaging.ESC_SAP_TenancyName__c='Null';
                    
                    //updStaging.ESC_Feed_Comment__c= String.join(caseIdMap.get(cs.ESC_Case__c),+'\r',\n');
                    updStaging.ESC_Feed_Comment__c= caseIdMap.get(cs.ESC_Case__c)[0];
                    system.debug('ESC_Feed_Comment__c >>>' +updStaging.ESC_Feed_Comment__c);
                    updStaging.ESC_RequestType__c='addDiscussion';
                    updStaging.ESC_Feed_Commented_by__c=UserInfo.getName();
                    updStaging.ESC_Feed_Commented_Date__c=System.Now();
                    //updStaging.ESC_Feed_Comment__c= 'Post by '+UserInfo.getName()+' on '+System.Now()+'\r\n'+String.join(caseIdMap.get(cs.ESC_Case__c),'\r\n Post by '+UserInfo.getName()+' on '+System.Now()+'\r\n');
                    
                    UpdatedStagingList.add(updStaging);
                }
            //}
           /* if(StagingList.size()>0){
                update StagingList;
            }*/
            if(UpdatedStagingList.size()>0){
                insert UpdatedStagingList;
            }
           }
        }
        catch(Exception e){
            System.debug(e);
        }

    }
//Error Message to User  on Duplicate Referral creation for VSTS
    public static void ReferralTriggerHelper(List<ESC_Case_Collaborator__c> refList , Map<id,ESC_Case_Collaborator__c> oldrefMap, Boolean isInsert){
        try{
           //** filter for update
          
           if(!isInsert){
               List<ESC_Case_Collaborator__c> filteredList = new  List<ESC_Case_Collaborator__c>();
               for(ESC_Case_Collaborator__c ref:refList){
                   string oldOwner = oldrefMap.get(ref.id).ownerid;
                   if(ref.OwnerId != oldOwner || (ref.ESC_Role__c != oldrefMap.get(ref.id).ESC_Role__c  )){
                       filteredList.add(ref);
                   }
               }
               refList = filteredList;
           }
           
           
           //
            ESC_VSTS_Routing__c vstsdetails = ESC_VSTS_Routing__c.getInstance();
            Map<String,ESC_VSTS_Product_List__c> ProdListmap = ESC_VSTS_Product_List__c.getall();
            Set<string> ProdList =ProdListmap.keySet();
            system.debug('vstsdetails'+vstsdetails.VSTSAssignmentGroup__c);
            Map<Id,Group> OwnerMap = new Map<Id,Group>([Select id,Name from Group where Type='Queue' and DeveloperName in :vstsDetails.VSTSAssignmentGroup__c.split(',')]);
            List<id> caseIdList= new list<Id>();
            List<id> caseIdprodList= new list<Id>();
            system.debug(ownermap);
            for(ESC_Case_Collaborator__c ref:refList){
                if(! vstsDetails.ESC_Referral_Role__c.CONTAINS(ref.ESC_Role__c) && OwnerMap.Keyset().contains(ref.OwnerId)){
                    ref.addError(OwnerMap.get(ref.OwnerId).Name+' '+Label.VSTS_Referal_Role_Msg);
                }
                else if(vstsDetails.ESC_Referral_Role__c.CONTAINS(ref.ESC_Role__c) && OwnerMap.Keyset().contains(ref.OwnerId)){
                    caseIdprodList.add(ref.ESC_Case__c);
                    caseIdList.add(ref.ESC_Case__c);
                }
                else if(vstsDetails.ESC_Referral_Role__c.CONTAINS(ref.ESC_Role__c) ){
                    caseIdList.add(ref.ESC_Case__c);
                   // CaseRefMap.put(ref.ESC_Case__C,new List<ESC_Case_Collaborator__c>());
                }
            }
      system.debug('caseIdList*******'+caseIdList);
      if(caseIdprodList.size()>0){
            List<case> caselist = [select id,product__c from case where id in : caseIdprodList];
                for(Case c : caselist){
                     for(ESC_Case_Collaborator__c ref1: refList ){
                         string s= c.Product__c;
                           if(s == '' || s == null || !ProdList.contains(s)){
                                 ref1.addError(Label.VSTS_Wrong_Product_msg);
                                 break;
                            
                            }
                     }
                }
        }               
        if(caseIdList.size()>0){
                Map<Id,List<ESC_Case_Collaborator__c>> CaseRefMap= new Map<Id,List<ESC_Case_Collaborator__c>>();
                 List< ESC_Case_Collaborator__c> tempRefList;
                 List<ESC_Case_Collaborator__c> listCC2=[Select Name,ESC_Case__c,ESC_Role__c,ESC_Referral_Status__c,OwnerId,ESC_Case__r.Product__c,Owner.Name
                    from ESC_Case_Collaborator__c 
                    where ESC_Case__c in :caseIdList 
                    and ESC_Referral_Status__c Not in('Completed','Closed')
                    and ESC_Role__c In :vstsDetails.ESC_Referral_Role__c.split(',') 
                    and OwnerId IN :OwnerMap.Keyset()];
                for(ESC_Case_Collaborator__c ref:listCC2){
          
          if(CaseRefMap.containskey(ref.ESC_Case__c)){
              tempRefList=CaseRefMap.get(ref.ESC_Case__c);
          }
          else
              tempRefList= new List< ESC_Case_Collaborator__c>();
          
          tempRefList.add(ref);
          CaseRefMap.put(ref.ESC_Case__c,tempRefList);
                }
        
              
         System.debug('CaseRefMap>>>' + CaseRefMap);
          System.debug('CaseRefMap>>>size>>' + CaseRefMap.size());
                for(ESC_Case_Collaborator__c ref:refList){
                   if(CaseRefMap.size()>0 && CaseRefMap.get(ref.ESC_Case__c).size()>0){
                          ref.addError(Label.VSTS_Duplicate_Ref+' '+CaseRefMap.get(ref.ESC_Case__c)[0].Owner.Name);
                             
                    }
                }
                
            }
           
         isvstsContext= true;   
        }
       catch(Exception e){
            system.debug('Excep at: '+e.getStackTraceString());
        }
         
    }
    
//Generic method to remove unnecessary string from Feedcomment and FeedItem 
public static Map<Id,List<String>> removetheSpecialCharactor(List<SObject> NewFeed,List<String> listQueue){ 
    Map<Id,List<String>> caseIdMaptemp = new Map<Id,List<String>>();
    for(Sobject feed:NewFeed){
                if(feed.getSobjectType()==FeedItem.SObjectType){
                    
                    String tb='';
                    for(String qname:listQueue){
                    
                    if(feed.get('Type')=='TextPost'&& String.valueof(feed.get('body')).containsIgnorecase('@'+qname)){
                            //tb=String.valueof(feed.get('body')).remove('@').unescapeHtml4();
                            tb=String.valueof(feed.get('body')).remove('@').normalizeSpace();
                           
                            String backlash = '</p><p>';
                            String backlashReplacement = '---n';
                            tb=tb.remove(qname);
                            tb= tb.replaceAll(backlash, backlashReplacement);
                            System.debug( 'Tb value>>>' +tb );
                            tb = tb.stripHtmlTags();
                            backlash = '\n';
                            tb = tb.replaceAll(backlashReplacement, backlash);
                            system.debug( 'tb new value>>>' +tb );
                        
                    
                            if(string.valueof(feed.get('ParentId')).startswith('500')){
                                List<String> TempList= caseIdMaptemp.get((String)feed.get('ParentId'));
                                if(tempList==null){
                                    tempList= new List<String>();
                                }
                                tempList.add(tb);
                                caseIdMaptemp.put((String)feed.get('ParentId'),tempList);
                            } 
                    }
                  }
                }
                else if(feed.getSobjectType()==FeedComment.SObjectType){
                   String tb='';
                    for(String qname:listQueue){
                         if(feed.get('CommentType')=='TextComment'&& String.valueof(feed.get('commentbody')).containsIgnorecase('@'+qname)){
                            //tb=String.valueof(feed.get('commentbody')).remove('@').stripHtmlTags().normalizeSpace();
                          tb=String.valueof(feed.get('commentbody')).remove('@');
                          system.debug('Comment body>>>' +String.valueof(feed.get('commentbody')).remove('@'));
                          tb=tb.remove(qname);
                       
                            if(string.valueof(feed.get('ParentId')).startswith('500')){
                                List<String> TempList= caseIdMaptemp.get((String)feed.get('ParentId'));
                                if(tempList==null){
                                    tempList= new List<String>();
                                }
                                tempList.add(tb);
                                caseIdMaptemp.put((String)feed.get('ParentId'),tempList);
                            }
                         }
                    }
                }
                
            }
    return caseIdMaptemp;
}
    
}