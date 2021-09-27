global without sharing class ESC_ArticleLinksUpdateBatch implements Database.Batchable <sObject>{
   global  Map<String,String> mapArtNumber = new Map<String,String>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<ESC_KnowledgeLinkUpdate__c> artNumblst = [select id, ArticleNumber__c,ESC_KnowledgeLink__c from ESC_KnowledgeLinkUpdate__c];
        for(ESC_KnowledgeLinkUpdate__c art : artNumblst){
            mapArtNumber.put(art.ArticleNumber__c,art.ESC_KnowledgeLink__c);
        }
        system.debug('###1'+mapArtNumber);
        return Database.getQueryLocator([SELECT Id, ArticleNumber, KnowledgeArticleId, Administrative_Customer_Support_Adminis5__c FROM Knowledge__kav WHERE PublishStatus = 'online' and ArticleNumber IN :mapArtNumber.keyset()]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> supportArticles){
        List<Id> articleIDs = new List<Id>();
        List<String> articleNumbers = new List<String>();
        //Step 1: Open published articles in editing mode which is Draft status
        List<ESC_KnowledgeLinkUpdate__c> artNumblst = [select id, ArticleNumber__c,ESC_KnowledgeLink__c from ESC_KnowledgeLinkUpdate__c];
        
        for(ESC_KnowledgeLinkUpdate__c art : artNumblst){
            mapArtNumber.put(art.ArticleNumber__c,art.ESC_KnowledgeLink__c);
        }
                
        system.debug('###1b'+mapArtNumber.keyset().size());
        system.debug('###1a'+mapArtNumber);
        for(Knowledge__kav a: (List<Knowledge__kav>)supportArticles){
            system.debug('###2'+a);
            String Id;
            try{
                Id = KbManagement.PublishingService.editOnlineArticle(a.KnowledgeArticleId, true);
                system.debug('###3'+Id);
            }catch(exception ex){
                system.debug('exception'+ex+a);
            }
            if (Id == null) {
                System.debug('##### ERROR While Editing');
            }
            else{
                system.debug('###4'+a.ArticleNumber);
                articleNumbers.add(a.ArticleNumber);
            }
        }
        system.debug('###5'+articleNumbers);
        List<Knowledge__kav> articles = new List<Knowledge__kav>();
        for (Knowledge__kav d : [SELECT Id, KnowledgeArticleId,Administrative_Customer_Support_Adminis5__c,ArticleNumber FROM Knowledge__kav WHERE PublishStatus = 'draft' AND ArticleNumber IN :articleNumbers]) {
            // Step 2: perform your updates
            system.debug('###6'+d);
            if(mapArtNumber.containsKey(d.ArticleNumber)){
                system.debug('###7'+mapArtNumber.get(d.ArticleNumber));
                d.Administrative_Customer_Support_Adminis5__c = mapArtNumber.get(d.ArticleNumber);
                articles.add(d);
            }
            articleIDs.add(d.KnowledgeArticleId);
            
        }
        system.debug('###8'+articles);
        if(articles.size() > 0){
            try{
                update articles;
                }Catch(Exception ex){
                    system.debug('exception1'+ex);
                }
        }
        //Step 3: re-publish all the draft article of this batch.
        for (String articleId : articleIDs) {
            KbManagement.PublishingService.publishArticle(articleId, true);
            system.debug('###9'+articleId);
        }
    }
    global void finish(Database.BatchableContext BC) {
        system.debug('Finished');
    }
}