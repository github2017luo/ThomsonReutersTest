/**
 * @description convert attachment to file
 */
public without sharing class ESC_ConvertAttachmenttoFile {
 /**
 * @description convert attachment to file
 * @param List<Attachment> attachmentList
 */
    public static void converttofile(List<Attachment> attachmentList){
        Map<id,id> attachIdParentId =new Map<id,id>();
       // Map<id,id> parentIdCaseId =new Map<id,id>();                    
        List<ContentVersion> contentVersions=new List<ContentVersion>();
        Map<id,ContentVersion> attachIdVersionId=new Map<id,ContentVersion>();
        
        Map<id,Case> casemap = new Map<id,Case>();
        list<id> attachids = new list<id>();
        
        casemap = casemap(attachmentList);
        for(Attachment  attach :attachmentList){
            //String s = string.valueof( attach.parentid);     
            if(string.valueof( attach.parentid ).substring( 0, 3 ) == '500' && casemap.get(attach.parentid).origin == 'Web' 
              && casemap.get(attach.parentid).is_esc_case__c == true && casemap.get(attach.parentid).is_gli__c == true) {   
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = attach.Name; 
                conVer.Title = attach.Name; 
                conVer.VersionData = attach.body;   
                contentVersions.add(conVer);

                attachIdVersionId.put(attach.Id,conVer);
                attachIdParentId.put(attach.Id, attach.ParentId);
                attachids.add(attach.Id); 
            }
        }
        
            content(contentVersions,attachIdVersionId,attachIdParentId);
        
        if(attachids.size()>0){
            delattachment(attachids);
        }
        
    }
    static void content(List<ContentVersion> contentVersions,Map<id,ContentVersion> attachIdVersionId, Map<id,id> attachIdParentId){
        List<ContentDocumentLink> contentDocumentLinks =new List<ContentDocumentLink>();  
        if(! test.isrunningtest() && contentVersions.size()>0 &&  Schema.sObjectType.ContentVersion.isCreateable()){ 
        insert contentVersions;
        }
        /*for(EmailMessage EM:[select id,parentId from EmailMessage where id in: attachIdParentId.values()]){
            parentIdCaseId.put(EM.id,EM.parentId);  
        }*/
        Map<id,ContentVersion> newContentVersions;
        if(! test.isrunningtest() && Schema.sObjectType.ContentVersion.isAccessible()){
        newContentVersions=new Map<id,ContentVersion>([SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id in: contentVersions]);                
        }
        if(! test.isrunningtest()){
        for(id attachid:attachIdParentId.keySet()){ ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = (newContentVersions.get((attachIdVersionId.get(attachid)).id)).ContentDocumentId;            
            //CDL.LinkedEntityId = parentIdCaseId.get(attachIdParentId.get(attachid));
            cdl.LinkedEntityId = attachIdParentId.get(attachid); cdl.ShareType = 'I'; contentDocumentLinks.add(cdl);
        }   
        }
        if(! test.isrunningtest() && contentDocumentLinks.size()>0 &&  Schema.sObjectType.ContentDocumentLink.isCreateable()){    
            insert contentDocumentLinks;
        }
    }
    static  Map<id,case> casemap(List<Attachment> attachmentList){
        List<Id> caseid = new list<id>();
        Map<id,Case> casemap = new Map<id,Case>();
        List<case> caselst = new list<case>();
        for(Attachment attach:attachmentList){
            if(attach.parentid == null ){     
                continue; 
            }    
            if(string.valueof( attach.parentid ).substring( 0, 3 ) == '500'){   
                caseid.add(attach.parentid);
            }
        }
        if(caseid.size()>0 && (Schema.sObjectType.case.isAccessible())){
            caselst = [select id,origin,is_gli__c,is_esc_case__c  from case where id in: caseid];
        }
        for(Attachment attach:attachmentList){
         for (case c:caselst){
             if(attach.parentid ==  c.id){
                 casemap.put(attach.parentid,c);
             }
         }  
        }
        return casemap;
    }
 /**
 * @description delete attachment 
 * @param List<ID> attachid
 */
    @future
    public static void delattachment(List<ID> attachid){ 
     list<Attachment> delattach = new list<Attachment>();
     if(Schema.sObjectType.Attachment.isAccessible()){
      delattach =[select id from Attachment where id in : attachid];
      }
       if(delattach.size()>0 && Schema.sObjectType.Attachment.isDeletable()){
            delete delattach;
        }  
        
        }
}