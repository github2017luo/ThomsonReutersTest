public class LeadConvDetail {
    public static boolean trialLeadConvStopR = false;
    public static void getLeadProdDetails(Set<Id> leadrec){
        System.debug('In class- getLeadProdDetails');
        List<Invite_Colleagues__c>  ivlist = new    List<Invite_Colleagues__c>();
        Set<Id> ContactIds =new Set<Id>();
        list<Account> acclist = new list<account>();
        list<id> convertedAcctIdlist = new list<id>();
        list<id> convertedleadIdlist = new list<id>(); 
        map<id,lead> accleadmap = new map<id,lead>();
        Set<string> sapnumberset =new set<string>();
        list<Source_System_Detail__c> ssdlist = new list<Source_System_Detail__c>();
        list<Trial__c> triallist = new list<Trial__c>(); 
        List<Invite_Colleagues__c> acceptedInvColleagues = new List<Invite_Colleagues__c>();  
        List<Opportunity_Trial__c>  oppTrial = new List<Opportunity_Trial__c>();
        map<id,List<Trial__c>> trialmap = new map<id,List<Trial__c>>();
        MAP<id, id> accSSDMap = new MAP<id, id>();
        MAP<id, id> prodPrimaryContactMap = new MAP<id, id>();
        
        List<Lead> leadDet= new List<Lead>([Select Id, Name,Trial_ID__c,GUID__c,LCRM_Trial_Start_Date__c,LCRM_Trial_End_Date__c,External_Trial_Account_ID__c,SAPAccountNumber__c,convertedOpportunityId,ConvertedDate,ConvertedAccountId,ConvertedContactId,Operating_Unit__c,
                                            (SELECT Id,Name,/*Product_Description__c,*/LCRM_Product_Name__c,LCRM_Product_Name__r.Duration__c,LCRM_Product_Name__r.Name FROM Recommended_Products__r), (Select id,name,Contact_LeadId__c,Source_System_Detail__c,Account_Name__c from Trials__r ) FROM Lead Where ID IN: leadrec]);
        List<Invite_Colleagues__c> invitedColleguesList =[Select id,Contact_Id_from_Lead__c,lead__r.ConvertedContactId,Trial_Status__c,Trial__c,lead__r.ConvertedAccountId from Invite_Colleagues__c where Lead__c IN: leadrec];
        //Account ssd creation changes-start 
        for(Lead l : leadDet){
            if(l.ConvertedAccountId != null){   
                convertedAcctIdlist.add(l.ConvertedAccountId);
                convertedleadIdlist.add(l.id);
                accleadmap.put(l.ConvertedAccountId,l); 
                sapnumberset.add(l.SAPAccountNumber__c);
                triallist.addAll(l.trials__r); 
                trialmap.put(l.id,triallist);
            } 
        }
        try{
            acclist = [Select id,name,OLC_Account_Number__c,SAPAccountNumber__c,(select id,name,OLC_Account_Number__c,Source_System_Name__c,Source_System_Account_Number__c  from Source_System_Details__r where Source_System_Account_Number__c  IN : sapnumberset OR OLC_Account_Number__c IN : sapnumberset) from account where id IN :convertedAcctIdlist];
            
            Id ssdrectype= Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
            LIST<Source_System_Detail__c> newSSDs = new LIST<Source_System_Detail__c>();
            
            for(Account acc : acclist){
                //If SSD Account doesnt exist on converted account            
                if(acc.Source_System_Details__r.size() < 1){   
                    Source_System_Detail__c ssd = new Source_System_Detail__c();        
                    ssd.Name=acc.name;
                    ssd.Account_Name__c=acc.id;
                    ssd.RecordtypeId=ssdrectype;
                    ssd.Source_System_Name__c=acc.name;
                    ssd.Operating_Unit__c = accleadmap.get(acc.id).Operating_Unit__c;
                    //ssd.Source_System_Account_Number__c =accleadmap.get(acc.id).SAPAccountNumber__c;
                    ssd.OLC_Account_Number__c =accleadmap.get(acc.id).SAPAccountNumber__c;
                    if(accleadmap.get(acc.id).External_Trial_Account_ID__c !=null){
                        ssd.OLC_Account_Number__c=accleadmap.get(acc.id).External_Trial_Account_ID__c;
                    }else{
                        ssd.OLC_Account_Number__c=accleadmap.get(acc.id).SAPAccountNumber__c;
                    }     
                    newSSDs.add(ssd);                 }
                //If SSDaccount exists on converted account
                else{
                    ssdlist.addAll(acc.Source_System_Details__r);          
                }
            }
            if(!newSSDs.isEmpty()){
                Database.insert(newSSDs, false);
                ssdlist.addAll(newSSDs);
            }
            for(Source_System_Detail__c accssd : ssdlist){
                accSSDMap.put(accssd.Account_Name__c , accssd.id) ;
            }
            if(ssdlist.size()>0) {
                
                tagTrialToSSD(ssdlist,accleadmap,trialmap);
            } 
        
        //Account ssd creation changes-End
        
       
        for(Invite_Colleagues__c i : invitedColleguesList)
        { 
            if(i.Trial__c == null ){
                for(Trial__c t : trialmap.get(i.lead__c)){
                    i.Trial__c = t.id;
                }
            }
            if(i.Trial_Status__c == 'Accepted')
                acceptedInvColleagues.add(i);
        }
        update invitedColleguesList;
        
        SET<ID> selProds = new SET<ID>();
        LIST<Asset> assetItems = new LIST<Asset>();
        Map<Id, List<Invite_Colleagues__c>> prodCont = new Map<Id, List<Invite_Colleagues__c>>();
        for(Lead l : leadDet){
            List<Trial__c> leadTrial= new List<Trial__c>();
            if(trialmap.containsKey(l.id)){
                leadTrial.addAll(trialmap.get(l.id));
            }
                      
               for(trial__C t : l.trials__r)
                {
                    if(l.convertedOpportunityId != null)
                    {
                        Opportunity_Trial__c oppTrialJun = CallToOLCTofetchActiveTr.createOpportunityTrialJun(l.convertedOpportunityId, t.id);
                  oppTrial.add(oppTrialJun);
                    }
                            
                }  
                  
            
            for(LCRM_Recommended_Product__c lp: l.Recommended_Products__r){
                //Integer trial_duration = 7;
                //prodCont.put(lp.Product__c, l.ConvertedContactId);
                prodCont.put(lp.LCRM_Product_Name__c,acceptedInvColleagues);
                prodPrimaryContactMap.put(lp.LCRM_Product_Name__c,l.ConvertedContactId);
                //Creation of the assets
                //if(lp.Product__r.Duration__c != null)
                //trial_duration = Integer.valueOf(lp.Product__r.Duration__c );
                System.debug('@@@AssetName'+lp.Name+'AcctId'+l.ConvertedAccountId);
                system.debug('========>'+leadTrial);
                if(!leadTrial.isEmpty())
                    assetItems.add(new Asset(Name=lp.LCRM_Product_Name__r.Name, Accountid=l.ConvertedAccountId, Product2id=lp.LCRM_Product_Name__c, Status='Installed',InstallDate=l.ConvertedDate, LCRM_Sold_To_Account__c=l.ConvertedAccountId,Source_System_Detail__c=accSSDMap.get(l.ConvertedAccountId),LCRM_Asset_Type__c='On Demand Trial', Trial_Details__c=leadTrial[0].id));
            }
        }
        /*for(Lead l : leadDet){
        for(LCRM_Recommended_Product__c lp: l.Recommended_Products__r){
        if(pbeProds.containsKey(lp.product__c)){
        System.debug('@@OLIDet'+pbeProds.get(lp.product__c)+'oppp'+l.convertedOpportunityId);
        opptyLineItems.add(new OpportunitylineItem(PricebookEntryId=pbeProds.get(lp.product__c), opportunityId=l.convertedOpportunityId,    unitPrice=1));
        }    
        }
        }*/
        System.debug('@@@AssetSize        '+assetItems.size());
        List<Database.SaveResult> result= database.insert(assetItems, false);
        System.debug('@@@Result        '+result);
        System.debug('@@@AssetItems        '+assetItems);
        
        List<LCRM_Contact_Entitlement__c> contEntiList = new List<LCRM_Contact_Entitlement__c>();
        Set<Id> convertedContactIds = new Set<ID>();
        convertedContactIds.addAll(prodPrimaryContactMap.values());
        for(Asset a : assetItems){
            
            if(prodCont.containsKey(a.Product2Id)){
                //contEntiList.add(new Contact_Entitlement__c(Name=a.Name+' Entitlement',Asset__c=a.Id,Trial_Status__c='Trial Started',Access_Start_Date__c=a.Trial_Start_Date__c, Access_End_Date__c   =a.Trial_End_Date__c,contact__c=prodCont.get(a.Product2Id)));
                //for(Invite_Colleagues__c inv : invitedColleguesList){
                
                for(Invite_Colleagues__c i: prodCont.get(a.Product2Id))
                {
                    contEntiList.add(new LCRM_Contact_Entitlement__c(Name=a.Name+' Entitlement',LCRM_Asset__c=a.Id,Trial_Status__c='Trial Started',LCRM_Access_Start_Date__c=a.Trial_Start_Date__c, LCRM_Access_End_Date__c=a.Trial_End_Date__c,Invited_Colleagues__c=i.Id));
                }
                //}  
                
                for(Id i: convertedContactIds)
                {
                    contEntiList.add(new LCRM_Contact_Entitlement__c(Name=a.Name+' Entitlement',LCRM_Asset__c=a.Id,Trial_Status__c='Trial Started',LCRM_Access_Start_Date__c=a.Trial_Start_Date__c, LCRM_Access_End_Date__c=a.Trial_End_Date__c,LCRM_Contact__c=i));
                }  
            }
        }
        List<Database.SaveResult> contResult = Database.insert(contEntiList, false);  
        if(!oppTrial.isEmpty())
        {
        List<Database.SaveResult> oppTrialResult = Database.insert(oppTrial, false);
        }      
        
        // SELECT Id,Name,Pricebook2Id,Product2Id,ProductCode FROM PricebookEntry WHERE Pricebook2Id = '01s30000000JBCIAA4' AND Product2Id IN (SELECT Id FROM LCRM_Recommended_Product__c) 
        System.debug('#####CE'+contEntiList);
        System.debug('#####CE'+contResult);        
        //getContractDetails(leadrec);
        }
        catch(Exception e){
            system.debug('Exception caught====>'+e);
        }
        
    }
    
    /**Method to tag the existing trial record to account ssd object**/
    
    public static void tagTrialToSSD(list<Source_System_Detail__c> ssdlist,map<id,lead> accleadmap,map<id,List<Trial__c>> leadtrialmap){ 
        system.debug('=======>'); 
        list<Trial__c> trialupdatelist = new list<Trial__c>();
        for(Source_System_Detail__c ssd  : ssdlist){
            id leadid  = accleadmap.get(ssd.Account_Name__c).id;            
            for(Trial__c t : leadtrialmap.get(leadid)){
                t.Source_System_Detail__c = ssd.id;
                trialupdatelist.add(t);
            } 
        }
        if(trialupdatelist.size()>0)    
            system.debug('=======>'+ trialupdatelist);      
        database.update(trialupdatelist, FALSE);      
    }
    
    @future(callout = true)
    public static void getContractDetails(Set<ID> leadIds){
        System.debug('@@@@@In getContractDetails');
        Set<ID> leadId = new Set<ID>();
        List<Lead> leadDet= new List<Lead>([Select Id, Name,Trial_ID__c,GUID__c,LCRM_Trial_Start_Date__c,LCRM_Trial_End_Date__c,convertedOpportunityId,ConvertedDate,ConvertedAccountId,ConvertedContactId, (SELECT Id,Name,/*Product_Description__c,*/LCRM_Product_Name__c,LCRM_Product_Name__r.Duration__c,LCRM_Product_Name__r.Name FROM Recommended_Products__r) FROM Lead Where ID IN: leadIds]);
        
        LIST<Contract> contractItems = new LIST<Contract>();
        //System.debug('@@@@@ContractDetails'+new Contract(Accountid=l.ConvertedAccountId, Status='Draft', StartDate=l.LCRM_Trial_Start_Date__c, /*EndDate=l.LCRM_Trial_End_Date__c,*/ ContractTerm=Integer.valueof(1)));  
        for(Lead l : leadDet){
            //  for(LCRM_Recommended_Product__c lp : l.Recommended_Products__r){
            
            contractItems.add(new Contract(Accountid=l.ConvertedAccountId, Status='Draft', StartDate=l.LCRM_Trial_Start_Date__c, /*EndDate=l.LCRM_Trial_End_Date__c,*/ ContractTerm=Integer.valueof(1)));
            //leadId.add(l.Id);
            //   }
            
        }
        System.debug('###Size'+contractItems.size());
        List<Database.SaveResult> contractResult = Database.insert(contractItems, false);
        createContractPDF(contractItems, leadDet);
    }
    
    public static void createContractPDF(LIST<Contract> contractDet, LIST<Lead> leadDet){
        
        for(Lead l : leadDet){
            PageReference contractPage = new PageReference('/apex/contractPDF?id='+l.Id);
            
            Blob contPdf;
            try{
                contPdf =  contractPage.getContent(); 
            }
            catch(Exception e){
                contPdf = Blob.valueOf(e.getMessage());
            }
            
            for(Contract con : contractDet){
                Attachment attach = new Attachment();
                attach.ParentId = con.Id;
                attach.name = 'name.pdf';
                attach.body = contPdf;
                attach.ContentType ='application/pdf';
                if(!Test.IsrunningTest()){
                    insert attach;
                }
            }
        }
    }
    public static void createInvitedColleagues(Set<Id> invitedCollList){
        List<Lead> InvCol= new List<Lead>([Select id,convertedOpportunityId,ConvertedDate,ConvertedAccountId,ConvertedContactId,(Select id,First_Name__c,Last_Name__c,Email__c,GUID__c,SapContactId__c,Trial_Start_Date__c,Trial_End_Date__c,Trial_Status__c from Invite_Colleagues__r) from Lead Where ID IN:invitedCollList]);
        List<Contact> cont = new List<Contact>();
        for(Lead le : InvCol){
            for(Invite_Colleagues__c Ic : le.Invite_Colleagues__r){
                cont.add(new contact(FirstName=Ic.First_Name__c));
            }
        }
        List<Database.SaveResult> result= database.insert(cont, false);
    }
    
    
}