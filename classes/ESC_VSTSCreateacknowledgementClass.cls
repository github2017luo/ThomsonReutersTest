public class ESC_VSTSCreateacknowledgementClass{
    
    /*
    This method will be invoked by VSTS staging object when the VSTS Id Staging table is updated by ESI/VSTS
    */
    
    @InvocableMethod(label='VSTS Create acknowledgement' description='Chatter creation on case from VSTS Ticket Create')
    public static void VSTSCreateacknowledgementMethod(List<ESC_VSTS_Staging__c> VSTSStaging){
       if(VSTSStaging == null || VSTSStaging.isEmpty())
            return;
        map<string,ESC_VSTS_Staging__c> MapStag=new Map<string,ESC_VSTS_Staging__c>();
        List<Id> lstReferral = new List<Id>();
        List<ESC_Case_Collaborator__c> Referlist = new List<ESC_Case_Collaborator__c>();
        List<FeedItem> listpost= new List<FeedItem>();
        List<String> caseListId= new List<String>();
        List<Case> caseList= new List<Case>();
    
        for(ESC_VSTS_Staging__c si:VSTSStaging){
            if(si.ESC_VSTS_Id__c  != ''&& si.ESC_VSTS_Id__c !=null && si.ESC_Referral_Id__c != null){
               lstReferral.add(si.ESC_Referral_Id__c);
               MapStag.put(si.ESC_Referral_Id__c,si);
               caseListId.add(si.ESC_Case_Id__c);
            }
        }
        if(caseListId.size()>0){
            caseList = [select id,CaseNumber,Status,ESC_VSTS_Id__c from Case where Id IN :caseListId];
        }
        system.debug('MapStag****'+ MapStag + 'lstReferral***' +lstReferral );
        //system.debug('caseList--> '+caseList);
        
        if(lstReferral.size()>0){
            Referlist = [select id,name,ESC_Case__c,ESC_Referral_Status__c,OwnerId,owner.name from ESC_Case_Collaborator__c where Id IN :lstReferral];
            
        }
        
        
        List<Case> caseList1= new List<Case>();
        for (Case ca:caseList) {
            for(ESC_VSTS_Staging__c evs : VSTSStaging)
            {
                ca.ESC_VSTS_Id__c = evs.ESC_VSTS_Id__c;
            }
                caseList1.add(ca);
        }
        
        
        if(caseList1.size()>0){
            Update caseList1;
        }
        
        for(ESC_Case_Collaborator__c c:Referlist){
            String chatterPost;
            if(MapStag.get(c.Id)!=null){
             chatterPost= 'The Referral: '+c.Name+' '+Label.ESC_VSTS_ChatterLabel;
           
            //Adding a Text post
             FeedItem post = new FeedItem();
             post.ParentId = c.ESC_Case__c; 
             post.Body = chatterPost;
             listpost.add(post);
             system.debug('listpost****'+ listpost);
            }   
        }
       
       if(listpost.size()>0){
            Insert listpost;
        }
        
        
    }
    
}