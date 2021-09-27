public without sharing class ESC_SNCreateacknowledgementClass{
    
    /*
    This method will be invoked by Service Now Staging object when the SNOW Id Staging table is updated by ESI/SN
    */
    
    @InvocableMethod(label='SN Create acknowledgement' description='Chatter creation on case from SN Ticket Create')
    public static void SNCreateacknowledgementMethod(List<ESC_ServiceNow_Staging__c> SNStaging){
        system.debug('1--------->');
        
        if(SNStaging == null || SNStaging.isEmpty())
            return;
        map<string,ESC_ServiceNow_Staging__c> MapStag=new Map<string,ESC_ServiceNow_Staging__c>();
        map<string,ESC_ServiceNow_Staging__c> MapCSidStagingobj=new Map<string,ESC_ServiceNow_Staging__c>();
        List<Id> lstReferral = new List<Id>();
        List<Id> lstcsId = new List<Id>();
        List<ESC_Case_Collaborator__c> Referlist = new List<ESC_Case_Collaborator__c>();
        List<FeedItem> listpost= new List<FeedItem>();
        for(ESC_ServiceNow_Staging__c si:SNStaging){
            if(si.ESC_SNOW_ID__c  != ''&& si.ESC_SNOW_ID__c !=null && si.ESC_ID__c != null){
               lstReferral.add(si.ESC_ID__c);
               MapStag.put(si.ESC_ID__c,si);
            }
            
            if(si.ESC_SNOW_ID__c  != ''&& si.ESC_SNOW_ID__c !=null && si.ESC_Case_Id__c != null){
               lstcsId.add(si.ESC_Case_Id__c);
               MapCSidStagingobj.put(si.ESC_Case_Id__c,si);
                
            }
        }
        system.debug('MapStag****'+ MapStag + 'lstReferral***' +lstReferral );
        system.debug('2--------->');
        if(lstReferral.size()>0){
            Referlist = [select id,name,ESC_Case__c,ESC_Referral_Status__c,OwnerId,owner.name from ESC_Case_Collaborator__c where Id IN :lstReferral];
            
        }
        
        for(ESC_Case_Collaborator__c c:Referlist){
            String chatterPost;
            if(MapStag.get(c.Id)!=null){
             chatterPost= 'The Referral: '+c.Name+' assigned to '+c.owner.name+' '+Label.ESC_SN_ChatterLabel+' '+ MapStag.get(c.Id).ESC_SNOW_ID__c +' & Task Referrence Number: '+ MapStag.get(c.Id).ESC_External_Task_Reference_Number__c;
           
            //Adding a Text post
             FeedItem post = new FeedItem();
             post.ParentId = c.ESC_Case__c; 
             post.Body = chatterPost;
             listpost.add(post);
             system.debug('listpost****'+ listpost);
            }   
        }
       List<Case> cslist = new List<Case>();
       for(Id csid:lstcsId){
            if(MapCSidStagingobj.get(csid)!=null){
             Case csobj = new Case();
             csobj.id = csid;
             csobj.ESC_External_Task_Reference_Number__c = MapCSidStagingobj.get(csid).ESC_External_Task_Reference_Number__c; 
             csobj.ESC_External_Ticket_Number__c= MapCSidStagingobj.get(csid).ESC_SNOW_ID__c;
             
             cslist.add(csobj);
             system.debug('cslist****'+ cslist);
            }   
        }
        
        if(cslist.size()>0){
            Update cslist;
        }
       
       if(listpost.size()>0){
            Insert listpost;
        }
    }
    
}