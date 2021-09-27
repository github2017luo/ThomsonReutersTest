/**
* JIRA Details: DPS-18603: No Deleting Docs on Opportunities Stage 95% or 100%
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-10-28   Miriam Ghosh            Created     
* =============================================================================
*/

public without sharing class ContentDocuDelRestrictionHandler {
    
    //Method to get profile name from custom settings
    public static boolean getProfileName(){
        string strProfileNAme = [SELECT Name from Profile Where Id =:UserInfo.getProfileID()].Name;   
        System.debug('strProfileNAme: '+strProfileNAme); 
        String user = LatAm_Profile_List__c.getValues('LatAmProfileList').Profile_List__c;
        if(user.contains(strProfileNAme)){
             return true;
        }
        return false; 
    }
    
    //Prevent Deletion of File from Related List if Opportunity stage is 0, 95 or 100%
    public static void onBeforeDeleteContentDocuLink(Boolean isDelete, Map<id, ContentDocumentLink> cdOldmap)
    {
        //Checking Exclusion Framework
        if(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){return;}
        
        Boolean usrProfile = getProfileName();
        
        if(isDelete && usrProfile){
        
            set<Id> cdlLinkId = new set<Id>();
            
            for (ContentDocumentLink cdlk : cdOldmap.values()) 
            {
                //Checking whether the object is Opportunity or not
                string cdlId = cdlk.LinkedEntityId;
                if (cdlId.startsWith('006')) {
                    //Collecting all the Oppty IDs
                    cdlLinkId.add(cdlk.LinkedEntityId);
                }
            }
             
            
            Map<Id, Opportunity> nonValidOptyList = getOpportunityForError(cdlLinkId);
            
            if(nonValidOptyList != null){
                showErrorMsgDeletionFileLinks(cdOldmap, nonValidOptyList);
            }
        }
    }
    
    @testVisible
    private static void showErrorMsgDeletionFileLinks(Map<id, ContentDocumentLink> cdOldmap, Map<Id, Opportunity> nonValidOptyList){
    
        for(ContentDocumentLink cdlink: cdOldmap.values()){
            
            if(nonValidOptyList.get(cdlink.LinkedEntityId) != null){
                cdlink.addError(System.label.File_Deletion_Restriction_Alert);
            }
        }
    }
    
    //Prevent Deletion of File and Notes if Opportunity stage is 0, 95 or 100%
    public static void onBeforeDeleteContentDocu(Boolean isDelete, Map<id, ContentDocument> cdOldmap){
    
        if(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){return;}
        
        Boolean usrProfile = getProfileName();
        
        if(isDelete && usrProfile){
            
            System.debug('@@@cdOldmap: '+cdOldmap);
            
            List<ContentDocument> cd = cdOldmap.values();
            
            Map<Id, ContentDocument> mapCD = getContentDocumentwithLinks(cdOldmap.keyset());
            
            Set<Id> cdlOptyLinkId = getLinkedEntityIdforContentDocu(mapCD);
            
            Map<Id, Opportunity> nonValidOptyList = getOpportunityForError(cdlOptyLinkId);
            
            if(nonValidOptyList != null){
                showErrorMsgDeletionFileNotes(cd, mapCD, nonValidOptyList);
            }
        }
    }
    
    //show error message while Deletion if Opportunity stage is 0,100 or 95%
    @testVisible
    private static void showErrorMsgDeletionFileNotes(List<ContentDocument> cd, Map<Id, ContentDocument> mapCD, Map<Id, Opportunity> nonValidOptyList){
        
        for(ContentDocument cdd : cd){
        
            for(ContentDocumentLink cdlink: mapCD.get(cdd.Id).ContentDocumentLinks){
                
                if(nonValidOptyList.get(cdlink.LinkedEntityId) != null && cdd.FileType == 'SNOTE' ){
                    cdd.addError(System.label.Note_Deletion_Restriction_Alert);
                }
                else if(nonValidOptyList.get(cdlink.LinkedEntityId) != null && cdd.FileType != 'SNOTE'){
                    cdd.addError(System.label.File_Deletion_Restriction_Alert);
                }
            }
        }
    }
    
    //Prevent updatation of File and Notes if Opportunity stage is 0, 95 or 100%
    public static void onBeforeUpdateContentDocu(Boolean isBefore, Boolean isUpdate, Map<id, ContentDocument> cdNewmap){
    
        if(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){return;}
        
        Boolean usrProfile = getProfileName();
        
        if(isBefore && isUpdate && usrProfile){
            
            System.debug('@@@cdNewmap: '+cdNewmap);
            
            List<ContentDocument> cd = cdNewmap.values();
            
            Map<Id, ContentDocument> mapCD = getContentDocumentwithLinks(cdNewmap.keyset());
            
            Set<Id> cdlOptyLinkId = getLinkedEntityIdforContentDocu(mapCD);
            
            Map<Id, Opportunity> nonValidOptyList = getOpportunityForError(cdlOptyLinkId);
            
            if(nonValidOptyList != null){
                showErrorMsgUpdationFileNotes(cd, mapCD, nonValidOptyList);
            }
        }
    }
    
    //show error message if Opportunity stage is 0,100 or 95%
    @testVisible
    private static void showErrorMsgUpdationFileNotes(List<ContentDocument> cd, Map<Id, ContentDocument> mapCD, Map<Id, Opportunity> nonValidOptyList){
        
        for(ContentDocument cdd : cd){
        
            for(ContentDocumentLink cdlink: mapCD.get(cdd.Id).ContentDocumentLinks){
                
                if(nonValidOptyList.get(cdlink.LinkedEntityId) != null && cdd.FileType == 'SNOTE' ){
                    cdd.addError(System.label.Note_Deletion_Restriction_Alert);
                }
                else if(nonValidOptyList.get(cdlink.LinkedEntityId) != null && cdd.FileType != 'SNOTE'){
                    cdd.addError(System.label.File_Deletion_Restriction_Alert);
                }
            }
        }
    }
    
    //get Content  and related Lins to collet Opportunity Ids
    @testVisible
    private static Map<Id, ContentDocument> getContentDocumentwithLinks(Set<Id> contentDocuIds){
        Map<Id, ContentDocument> mapCD = new Map<Id, ContentDocument>();
        if(contentDocuIds != null && Schema.sObjectType.ContentDocument.isAccessible()){
            mapCD = new Map<Id, ContentDocument>(
                    [Select Id, FileType,Title, (select LinkedEntityId,ContentDocumentId FROM ContentDocumentLinks) 
                    from ContentDocument where Id in: contentDocuIds]);
        }
        return mapCD;    
    }
    
    //Method to get LinkedEntityIds from ContentDocument object
    @testVisible
    private static Set<Id> getLinkedEntityIdforContentDocu(Map<Id, ContentDocument> mapCD){

        set<Id> cdlLinkId = new set<Id>();
        
        for(ContentDocument cdd : mapCD.values()){
            for(ContentDocumentLink cdlink: mapCD.get(cdd.Id).ContentDocumentLinks){
                
                //get only Opportunity related Ids
                if(String.valueOf(cdlink.LinkedEntityId).startsWith('006')){
                    cdlLinkId.add(cdlink.LinkedEntityId);
                }
            }
        }
    
        return cdlLinkId;
    }
    
    @testVisible
    private static Map<Id, Opportunity> getOpportunityForError(Set<Id> OptyIds){
        
        Map<Id, Opportunity> nonValidOptyList = new Map<Id, Opportunity>();
        
        if(OptyIds != null && Schema.sObjectType.Opportunity.isAccessible()){
            nonValidOptyList = new Map<Id, Opportunity>([SELECT id, stageName From Opportunity WHERE Id IN :OptyIds AND 
                             (StageName = '0%' OR StageName = '95%' OR StageName = '100%')]);
        }
        return nonValidOptyList;
    }    
}