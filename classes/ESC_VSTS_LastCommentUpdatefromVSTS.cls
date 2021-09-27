public class ESC_VSTS_LastCommentUpdatefromVSTS{
    
    /*
    This method will be invoked by VSTS Staging object when the Last comment is updated by ESI/VSTS
    */
    
    @InvocableMethod(label='VSTSLastCommentUpdate' description='Chatter creation on case from VSTS Update')
    public static void VSTSPostCreation(List<ESC_VSTS_Staging__c> VSTSStaging){
       
       //if list is empty lets keep it nothing
        if(VSTSStaging == null || VSTSStaging.isEmpty() )
        {
            system.debug('listpost empty****');
            return;
        }
        List<string> csnumber = new List<string>();
        List<Case> caselist = new List<Case>();
        List<FeedItem> listpost= new List<FeedItem>();
        Map<string,ESC_VSTS_Staging__c> mapCasenumVSTSstaging= new  Map<string,ESC_VSTS_Staging__c>();
        for(ESC_VSTS_Staging__c si:VSTSStaging){
            if(si.ESC_Last_Comment_from_VSTS__c!= ''&& si.ESC_Last_Comment_from_VSTS__c!=null && si.ESC_Case_Number__c != null){
               csnumber.add(si.ESC_Case_Number__c);
              mapCasenumVSTSstaging.put(si.ESC_Case_Number__c,si);
              
            }
        }
       if(csnumber.size()>0){
            caselist = [select id,Owner.Name,Casenumber,ESC_Likely_Restoration_Time__c from Case where Casenumber IN :csnumber];
            
        }
        List<Case> listCaseUpd= new List<Case>();       
        for(Case c:caselist){
         if(mapCasenumVSTSstaging.size()>0){    
             c.ESC_Likely_Restoration_Time__c= mapCasenumVSTSstaging.get(c.casenumber).ESC_VSTS_SLA_End_Date__c;
              if(c.ESC_Likely_Restoration_Time__c != mapCasenumVSTSstaging.get(c.casenumber).ESC_VSTS_SLA_End_Date__c){
                 listCaseUpd.add(c);
                }
            String chatterPost;
            chatterPost='VSTS Update:'+'\n'+' '+ mapCasenumVSTSstaging.get(c.casenumber).ESC_Last_Comment_from_VSTS__c;
            system.debug('chatterPost****'+ chatterPost);
            //Adding a Text post
            FeedItem post = new FeedItem();
            post.ParentId = c.id; 
            post.Body = chatterPost;
            listpost.add(post);
            system.debug('listpost****'+ listpost);
          }
        }
       
        if(listpost.size()>0){
            Insert listpost;
        }
        if(listCaseUpd.size()>0){
            Update listCaseUpd;
        }
            
   } 
}