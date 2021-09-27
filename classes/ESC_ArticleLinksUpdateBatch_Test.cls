@IsTest

public class ESC_ArticleLinksUpdateBatch_Test{

   testMethod static void Method1(){
    List<Knowledge__kav> lstKnowledg= new List<Knowledge__kav>();
   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'standt99', Email='sysadmin@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin99@testorg.com',UserPermissionsKnowledgeUser=true,UserPermissionsSupportUser=true);
      insert u;
      
       System.runAs(u){
         
  
   
   Knowledge__kav lstkno= new Knowledge__kav();
  
   lstkno.title='test 3445';
   lstkno.summary='summary';
   lstkno.UrlName='test3445';
  
   
   //lstKnowledg.add(lstkno);
   insert lstkno;
   Knowledge__kav d = [SELECT Id, KnowledgeArticleId,ESC_Legacy_Article_Number__c,ArticleNumber,Administrative_Customer_Support_Adminis5__c  FROM Knowledge__kav WHERE PublishStatus = 'draft'] ;
     KbManagement.PublishingService.publishArticle(d.KnowledgeArticleId, true);
 
   string temp=d.articlenumber;
   system.debug('Publish'+ temp);
   ESC_KnowledgeLinkUpdate__c art= new ESC_KnowledgeLinkUpdate__c();
   art.ArticleNumber__c = temp; 
   art.ESC_KnowledgeLink__c = 'test';   
   insert art;
   Test.startTest();

   ESC_ArticleLinksUpdateBatch articlebatch = new ESC_ArticleLinksUpdateBatch();
    DataBase.executeBatch(articlebatch );
Test.stopTest();
}
   }
   }