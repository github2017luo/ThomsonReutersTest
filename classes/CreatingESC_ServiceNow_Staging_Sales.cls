Public Class CreatingESC_ServiceNow_Staging_Sales{
    public static void CreateAndUpdateStagingRecords(List<Case> listCase){
        
        Boolean insertOpration= false;
        SN_ESI_Values_del__c snesival = SN_ESI_Values_del__c.getInstance();
        if(snesival.Type__c !=null){
            List<ESC_ServiceNow_Staging__c> SNowUpdateList = new List<ESC_ServiceNow_Staging__c>();
            List<Case> listCaseData = [select id,Description,AccountId,Account.SAPAccountNumber__c,ESC_SLA__c,ESC_SLA_Justification__c,CaseNumber from Case where Id IN:listCase];
            Set<Id> caseId = new Set<Id>(); 
            for(Case Ref: listCase){
                caseId.add(Ref.id);
            }
            List<ESC_ServiceNow_Staging__c> allESCval = [select id,ESC_Staging_Status__c,ESC_ID__c from ESC_ServiceNow_Staging__c where ESC_ID__c IN:caseId];
            Map<Id,Id> caseESC = new Map<Id,Id>();
            for(ESC_ServiceNow_Staging__c escVal :allESCval){
                caseESC.put(escVal.ESC_ID__c,escVal.Id);
            }
            for(Case Ref: listCaseData){
                ESC_ServiceNow_Staging__c Staging = new ESC_ServiceNow_Staging__c();
                if(caseESC !=null && caseESC.ContainsKey(Ref.id)){
                    Staging.id= caseESC.get(Ref.id);
                    insertOpration = true;
                }
                Staging.ESC_ID__c = Ref.id;
                Staging.ESC_Staging_Status__c = snesival.Staging_Status__c;
                if(Ref.Description !=null){
                    Staging.ESC_Description__c =Ref.Description;
                }else{
                    Staging.ESC_Description__c =snesival.Description__c;
                }
                Staging.ESC_SourceSystem__c = snesival.sourceSystem__c;
                Staging.ESC_ReportKey__c =snesival.reportKey__c+'84854554648';
                Staging.ESC_BusinessArea__c = snesival.businessArea__c;
                Staging.ESC_Source__c = snesival.source__c;
                Staging.ESC_AssignmentGroup__c = snesival.assignmentGroup__c;
                Staging.ESC_RequestType__c = snesival.requestType__c;
                Staging.ESC_SourceLink__c = snesival.SourceLink__c;
                if(Ref.Account.SAPAccountNumber__c !=null){
                    Staging.ESC_CustomerNumber__c = Ref.Account.SAPAccountNumber__c;
                }
                else{
                Staging.ESC_CustomerNumber__c = snesival.customerNumber__c;
                }
                
                if(Ref.ESC_SLA__c != null){
                    Staging.ESC_SLA__c= Ref.ESC_SLA__c.left(1);
                }
                else{
                    Staging.ESC_SLA__c=snesival.SLA__c;
                }
                if(Ref.ESC_SLA_Justification__c !=null) {       
                    Staging.ESC_SLAJustification__c = Ref.ESC_SLA_Justification__c;
                }else{
                    Staging.ESC_SLAJustification__c = snesival.SLAJustification__c;
                }
                Staging.ESC_CaseNumber__c = Ref.CaseNumber;
                Staging.ESC_AuditResult__c = snesival.AuditResult__c;
                Staging.ESC_QuoteNumber__c = snesival.quoteNumber__c;
                Staging.ESC_Feed_Comment__c=snesival.FeedComment__c;
                Staging.ESC_SystemIdentifier__c = snesival.systemIdentifier__c;
                Staging.ESC_Key__c = snesival.key__c;
                
                SNowUpdateList.add(staging);
            
            
            }
            try{
                upsert SNowUpdateList;
                if(!insertOpration){
                    List<ESC_ServiceNow_Staging__c> SNowUpdateListNew =[select id,ESC_ID__c,Name from ESC_ServiceNow_Staging__c where id IN:SNowUpdateList];
                
                    SNCreateacknowledgementMethod(SNowUpdateListNew);
                }
            }
            catch(Exception e){
                
                system.debug(e);
            }
        }
    
    }
    public static void SNCreateacknowledgementMethod(List<ESC_ServiceNow_Staging__c> SNStaging){
        system.debug('1--------->');
        List<FeedItem> listpost= new List<FeedItem>();
        if(SNStaging == null || SNStaging.isEmpty())
            return;
        
        for(ESC_ServiceNow_Staging__c c:SNStaging){
            system.debug('My data--'+c);
           String chatterPost;
            
             chatterPost= 'The Service Now Referral: '+c.name;
           
            //Adding a Text post
             FeedItem post = new FeedItem();
             post.ParentId = c.ESC_ID__c; 
             post.Body = chatterPost;
             listpost.add(post);
             system.debug('listpost****'+ listpost);
              
        }
       
       if(listpost.size()>0){
            Insert listpost;
        }
    }

}