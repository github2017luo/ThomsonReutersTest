@isTest
private class ESC_UnifiedAttachmentListControllertest {
    @isTest
    private static void testmethod1()
    {
        Test.startTest();
        
        Case c= new Case();
        insert c;
        
        emailmessage e=new emailmessage(Subject='Test',parentid=c.id);
        insert e;
        ESC_DataTableEntity dte = new ESC_DataTableEntity();
        //List<ESC_DataTableEntity> dteList = new List<ESC_DataTableEntity>();
       // dteList.add(dte);
        
        attachment att = new attachment();
        att.parentid = c.id;
        att.name = 'Test';
        att.contentType ='text/plain';
        att.body=Blob.valueOf('asdfsdfsdfsfasdfa');
        //att.docName = 'fdf';
        insert att;

         attachment att1 = new attachment();
        att1.parentid = c.id;
        att1.name = 'Test123';
        att1.contentType ='text/plain';
        att1.body=Blob.valueOf('asdfsdfsdfsfasdfafdgfh');
        //att.bodyLength = 10485760;
        insert att1;
        
        
        PageReference pageRef = Page.ESC_UnifiedAttachmentList;
         PageRef.getParameters().put('id', c.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        
        ESC_UnifiedAttachmentListController controller = new ESC_UnifiedAttachmentListController (sc);
        ESC_UnifiedAttachmentListController.AttachmentDetails attach = new ESC_UnifiedAttachmentListController.AttachmentDetails(att);
        ESC_UnifiedAttachmentListController.AttachmentDetails attach1 = new ESC_UnifiedAttachmentListController.AttachmentDetails(att1);
        attach.getUploadedDate(); 
        //attach.docName=att.name;
        String size = attach.getAttachmentSize();
        controller.GetRefreshed();
        controller.updateCaseFlagToFalse();
        controller.getDataTableEntity();
        controller.chosenID = '';
        Integer s = attach.compareTo(attach1);
        controller.allAttachmentsMapEntry();
    }
    @isTest
    private static void testmethod2()
    {
        
        Test.startTest();
        
        Case c= new Case();
        insert c;
        
        emailmessage e=new emailmessage(Subject='Test',parentid=c.id,incoming=true,TextBody='test');
        insert e;
        ESC_DataTableEntity dte = new ESC_DataTableEntity();
        //List<ESC_DataTableEntity> dteList = new List<ESC_DataTableEntity>();
       // dteList.add(dte);
        
        attachment att = new attachment();
        att.parentid = c.id;
        att.name = 'Test';
        att.contentType ='text/plain';
        att.body=Blob.valueOf('asdfsdfsdfsfasdfa');
        //att.bodyLength = 10485760;
        insert att;
        
        PageReference pageRef = Page.ESC_UnifiedAttachmentList;
         PageRef.getParameters().put('id', c.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        
        ESC_UnifiedAttachmentListController controller = new ESC_UnifiedAttachmentListController (sc);
        ESC_UnifiedAttachmentListController.AttachmentDetails attach = new ESC_UnifiedAttachmentListController.AttachmentDetails(att,true);
        attach.getUploadedDate();  
        String size = attach.getAttachmentSize();
        controller.GetRefreshed();
        Test.stopTest();
    }
    @isTest
    private static void testmethod3()
    {
        
        Test.startTest();
        
        Case c= new Case();
        insert c;
        
        emailmessage e=new emailmessage(Subject='Test',parentid=c.id,incoming=true,TextBody='test');
        insert e;
        ESC_DataTableEntity dte = new ESC_DataTableEntity();
        //List<ESC_DataTableEntity> dteList = new List<ESC_DataTableEntity>();
       // dteList.add(dte);
        
        attachment att = new attachment();
        att.parentid = e.id;
        att.name = 'Test';
        att.contentType ='text/plain';
        att.body=Blob.valueOf('asdfsdfsdfsfasdfa');
        //att.bodyLength = 10485760;
        insert att;
        
        PageReference pageRef = Page.ESC_UnifiedAttachmentList;
         PageRef.getParameters().put('id', c.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        
        ESC_UnifiedAttachmentListController controller = new ESC_UnifiedAttachmentListController (sc);
        ESC_UnifiedAttachmentListController.AttachmentDetails attach = new ESC_UnifiedAttachmentListController.AttachmentDetails(att,true);
        attach.getUploadedDate();  
        String size = attach.getAttachmentSize();
        controller.GetRefreshed();
        Test.stopTest();
    }
    
    @isTest
    private static void testmethod4()
    {
        Test.startTest();
        
        Case c= new Case();
        insert c;
        
        emailmessage e=new emailmessage(Subject='Test',parentid=c.id);
        insert e;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
       
        insert content;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=c.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        
        
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        
        ESC_UnifiedAttachmentListController controller = new ESC_UnifiedAttachmentListController (sc);
        try{
        ESC_UnifiedAttachmentListController.AttachmentDetails attach = new ESC_UnifiedAttachmentListController.AttachmentDetails(contentlink);
        attach.getUploadedDate(); 
        String size = attach.getAttachmentSize();
        }
        catch(exception exp)
        {
        }
        
        Test.stopTest();
    }
}