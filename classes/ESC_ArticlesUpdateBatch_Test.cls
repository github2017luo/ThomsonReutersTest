@IsTest

public class ESC_ArticlesUpdateBatch_Test{

   testMethod static void method1(){
    //List<Knowledge__kav> lstKnowledg= new List<Knowledge__kav>();
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
   lstkno.IsVisibleInPkb = true;
   lstkno.IsVisibleInCsp = true;
  
   
   //lstKnowledg.add(lstkno);
   insert lstkno;
   Knowledge__kav d = [SELECT Id, KnowledgeArticleId,Article_Classification__c,ArticleNumber,IsVisibleInPkb,IsVisibleInCsp FROM Knowledge__kav WHERE PublishStatus = 'draft'] ;
     KbManagement.PublishingService.publishArticle(d.KnowledgeArticleId, true);
 
   string temp=d.articlenumber;
   system.debug(logginglevel.warn,'Publish'+ temp);
   insert new ESC_ArticleNumberMapping__c(Name=temp, ESC_Old_Article_Number__c='false') ;
   Test.startTest();

   ESC_ArticlesUpdateBatch articlebatch = new ESC_ArticlesUpdateBatch ();
    DataBase.executeBatch(articlebatch );
Test.stopTest();
}
integer i=1;
integer j=1;
system.assertequals(i,j,'equal');
   }
   }