trigger ESC_FeedItemTrigger on FeedItem (before insert, after insert, before update, after update, 
                    before delete, after delete, after undelete) {
                    
    //LTS_6301 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}                    
                        system.debug('ESC_FeedItemTrigger fired');
                        string labelName = 'ESC_ViaChatterPost';
  If(Trigger.IsAfter && Trigger.IsInsert ){
        set<String> CaseIDs = new set<string>();
        set<String> CaseIDattach = new set<string>();
        List<FeedItem> refFeedList = new List<FeedItem>();
       for(FeedItem  em: Trigger.new){
           if(em.Type=='TextPost'){
               CaseIDs.add(em.parentid ) ;
               }
           else{
                CaseIDattach.add(em.parentid) ;  
               }
               
            String ObjectType=em.ParentId.getSObjectType().getDescribe().getName();
            System.debug('ObjectType:-'+ObjectType);
            System.debug('feed'+em);  
            if(ObjectType == 'ESC_Case_Collaborator__c'){
                refFeedList.add(em);
            }  
           }
           
        if(CaseIDs.size()>0){
            ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(CaseIDs,labelName, Label.ESC_ViaChatterPost);
        }
        if(CaseIDattach.size()>0){
        // To update ESC_File_UPD__c   
            //ESC_ReferalTriggerHelperClass.updateFileUPDForCases(CaseIDattach);
            ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(CaseIDattach,'ESC_ViaAttachment' , Label.ESC_ViaAttachment);
            }
            
         if(refFeedList.size()>0){
            ESC_UPD_Utility.updateCaseUPD(refFeedList);
            
        }
         if(UserInfo.getName() != 'Automated Process'){
        ESC_VSTSstagingUpdate.updateVSTSstaging(Trigger.new); 
        ESC_ServiceNowStagingHelper.updateSNstagingFeedUpdate(Trigger.New);
        }
    }
    /* If(Trigger.IsBefore && Trigger.IsInsert){
        ESC_VSTSstagingUpdate.PendingVSTSstaging(Trigger.new);
    }*/
}