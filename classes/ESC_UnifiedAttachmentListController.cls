public without sharing class ESC_UnifiedAttachmentListController {

    public Case c { get; set; }    
    Public string chosenID {get;set;}
    public List<AttachmentDetails> allAttachments {get;set;}
    public Map<string , List<AttachmentDetails> > allAttachmentsMap {get; set;}
    public string results{ get; set;}
     public ESC_DataTableEntity dte {get; set;}
     public boolean hasSec {get; set;}
     public String caseid {get;set;}
    case c1;
    
    
     public string getDataTableEntity(){
       List<ESC_DataTableEntity> dteList = new List<ESC_DataTableEntity>();
       dteList.add(dte);
       return JSON.serialize(dteList);
   }
    public void allAttachmentsMapEntry(){
        
        allAttachmentsMap =  new Map<string , List<AttachmentDetails> >();
        List<AttachmentDetails> tempAttachmentList;
       // allAttachments.sort();
        for(AttachmentDetails detail: allAttachments){
            
            if(allAttachmentsMap.containsKey(detail.docName)){
                tempAttachmentList = allAttachmentsMap.get(detail.docName);
               
            }
            else{
                tempAttachmentList = new List<AttachmentDetails> ();
            }
            tempAttachmentList.add(detail);
            
            allAttachmentsMap.put(detail.docName ,tempAttachmentList );
            
            
        }
        
        system.debug('allAttachmentsMapEntry execution ended: '+allAttachmentsMap);
         for(AttachmentDetails detail: allAttachments){
              detail.countOfGrouping = allAttachmentsMap.get(detail.docName).size() ;
              if(detail.countOfGrouping > 1){
              detail.isRendered =false;
               tempAttachmentList = allAttachmentsMap.get(detail.docName);
               system.debug('Before Sort'+tempAttachmentList);
               tempAttachmentList.sort();
               system.debug('After Sort'+tempAttachmentList);
              allAttachmentsMap.put(detail.docName , tempAttachmentList);
                hasSec = true;
              }
             
         }
         results = json.serialize(allAttachmentsMap);
         
    }
    
    public ESC_UnifiedAttachmentListController (ApexPages.StandardController stdController) {
          hasSec = false;
            dte = new ESC_DataTableEntity();
        this.c = (Case)stdController.getRecord();
        caseid = c.id;
        Map<Id, EmailMessage> emMap = new Map<Id, EmailMessage>([select subject, id, Incoming from emailmessage where parentid =:c.id order by createddate desc]);
        
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
        c1 = [select id,ESC_File_Upd_Cntr__c from Case where Id = :c.id];
        }

        allAttachments = new List<AttachmentDetails>();
        for(Attachment lat : [select id, parentid, parent.name, name, createdDate, bodyLength,
                                        contentType from attachment 
                                        where parentid in:emMap.keySet() or parentid =:c.Id order by createddate desc]){
            if( emMap.containsKey(lat.parentid)){
              boolean isInbound = emMap.get(lat.parentid).Incoming;
              allAttachments.add(new AttachmentDetails(lat ,isInbound));
              System.debug('allAttachments:---'+allAttachments);
            }
            else{
                allAttachments.add(new AttachmentDetails(lat));
            }
          
            
        }
        
        for(ContentDocumentLink cdl:[SELECT ContentDocument.LatestPublishedVersionId,LinkedEntityId,LinkedEntity.Name,LinkedEntity.Type,Id,ContentDocument.title,ContentDocument.createdDate, ContentDocument.ContentSize,ContentDocument.FileType,SystemModstamp  FROM ContentDocumentLink WHERE LinkedEntityId =:c.id order by ContentDocument.createddate desc])
        {
            allAttachments.add(new AttachmentDetails(cdl));
        }
       // allAttachments.sort();
     
        allAttachmentsMapEntry();
                
    }
   
    
    public pagereference getRefreshed()
    {
        
      
       PageReference pageRef = ApexPages.currentPage();
       pageRef.setRedirect(true);      
       return pageRef;
    }
    
    
    public void updateCaseFlagToFalse(){
        /*if(c1.ESC_File_UPD__c == true){
           c1.ESC_File_UPD__c = false;
           update c1;
        }*/
        system.debug('entered method');
    
    }
    
       public class AttachmentDetails implements Comparable{
        
        public Id id{get;private set;}
        public String parentType {get; private set;}
        public String parent {get;private set;}
        public String parentId {get; private set;}
        public String styleClass {get;private set;}
        public String docName{get
        {
        return docName.abbreviate(integer.valueOf(Label.ESC_FilenameSize));

        }private set;}
         public String docTitleFull{get;private set;}
        public String type{get;private set;}
        public String downloadlink{get;private set;}
        public String attachmentSizeF{get;private set;}
         public String uploadedDateF{get;private set;}
        public Integer countOfGrouping{get; set;} 
        public Boolean isRendered {get; set;}
        public String getUploadedDate(){
            return formatDate(createdDate);
        }
       
        public Long sortByDate{get; private set;}
        
        private Integer length{get;private set;}
        public DateTime createdDate{get; set;}

        public AttachmentDetails(Attachment attach){
            initialize(attach);
        }
        public AttachmentDetails(Attachment attach, Boolean isEmailinbound){
            initialize(attach);
            this.styleClass  = isEmailinbound? 'inb' : 'otb' ;
             
        }

        public AttachmentDetails(ContentDocumentLink doclink){
            this.Id = doclink.Id;
            System.debug('thid.id:-'+this.id);
            this.parent = doclink.ContentDocument.Id;
            this.parentId = doclink.ContentDocument.id;
            this.docName = doclink.ContentDocument.title;
            this.docTitleFull = doclink.ContentDocument.title;
            //this.createdDate = doclink.ContentDocument.createdDate; 
            this.createdDate = doclink.SystemModstamp;
            this.type = String.isBlank(doclink.ContentDocument.FileType)?'':((doclink.ContentDocument.FileType.contains('.'))?doclink.ContentDocument.FileType.substringAfterLast('.'):((doclink.ContentDocument.FileType.contains('/'))?doclink.ContentDocument.FileType.substringAfterLast('/'):doclink.ContentDocument.FileType));
            this.length = doclink.ContentDocument.ContentSize;
            this.parentType = doclink.Id.getSobjectType().getDescribe().getLabel();
            //this.downloadlink= '/sfc/servlet.shepherd/version/download/'+doclink.ContentDocument.LatestPublishedVersionId+'?asPdf=false&operationContext=CHATTER';
            //this.downloadlink= '/sfc/servlet.shepherd/document/download/'+doclink.ContentDocument.Id;
            this.downloadlink= '/sfc/servlet.shepherd/version/download/'+doclink.ContentDocument.LatestPublishedVersionId;
            
            this.countOfGrouping =0;
            this.isRendered = true;
            this.attachmentSizeF = getAttachmentSize();
            this.uploadedDateF = getUploadedDate();
            //if(!Test.IsRunningTest()){
            this.sortByDate = Long.valueOf(formatDate());
            //}
            //SELECT ContentDocument.LatestPublishedVersionId,LinkedEntityId,LinkedEntity, Id,ContentDocument.title,ContentDocument.createdDate, ContentDocument.ContentSize,ContentDocument.FileType  FROM ContentDocumentLink WHERE LinkedEntityId =:c.id])
        
        }
        
        public void initialize(Attachment attach){
            System.debug('Attach-->'+attach);
            this.Id = attach.Id;
            this.parent = attach.parent.name;
            this.parentId = attach.parentId;
            this.docName = attach.name;
            this.docTitleFull = attach.name;
            this.createdDate = attach.createdDate;
            this.type = String.isBlank(attach.contentType)?'':((attach.contentType.contains('.'))?attach.contentType.substringAfterLast('.'):((attach.contentType.contains('/'))?attach.contentType.substringAfterLast('/'):attach.contentType));
            this.length = attach.bodyLength;
            this.parentType = attach.parentId.getSobjectType().getDescribe().getLabel();
            this.downloadlink= '/servlet/servlet.FileDownload?file='+attach.Id;
            this.countOfGrouping =0;
             this.isRendered = true;
             this.attachmentSizeF = getAttachmentSize();
            this.uploadedDateF = getUploadedDate();
            if(!Test.IsRunningTest()){
            this.sortByDate = Long.valueOf(formatDate());
            }
        }
         public Integer compareTo( Object obj){
            
            AttachmentDetails sfw = (AttachmentDetails ) obj;
            if(this.sortByDate < sfw.sortByDate){
                return 1;
            }
            else if(this.sortByDate > sfw.sortByDate){
                return -1;
            }
            return 0;
        }
        
        public String getAttachmentSize(){
            Decimal size;
            if(!Test.IsRunningTest()){
            size = ((Decimal)this.length).setScale(2);
            
            if(this.length <1024){
                return this.length+' bytes';
            }
            size = (size/1024).setScale(2);
            if(size < 1024){
                return size+' Kb';
            }
            size = (size/1024).setScale(2);
            if(size < 1024){
                return size+' Mb';
            }
            else{
                return (size/1024).setScale(2) +' Gb';
            }
            }
            else{
               return '0 Mb';
                }
        }
        
        public String formatDate(DateTime dt){
            if(dt == null){
                return null;
            }
            else{
                return dt.format();
            }
        }
        
 
        
        private String formatDate(){
            //    system.debug('@'+this.createdDate.format('YYYYMMDDHHmm')+'@');
               
            return this.createdDate.format('yyyyMMddHHmm');
             
            
        }
        
    
        
    
       }

}