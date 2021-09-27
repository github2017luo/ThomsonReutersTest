/**
 * @description ESC_ArticlesUpdateBatch class
 */
global without sharing class ESC_ArticlesUpdateBatch implements Database.Batchable <sObject>{
   global  Map<String,String> mapArtNumber = new Map<String,String>();
   /**
     * @description start method
     * @return Database.QueryLocator
	 * @param Database.BatchableContext bc
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<ESC_ArticleNumberMapping__c> artNumblst = ESC_ArticleNumberMapping__c.getAll().Values();
        for(ESC_ArticleNumberMapping__c art : artNumblst){
            mapArtNumber.put(art.Name,art.ESC_Old_Article_Number__c);
        }
        system.debug(logginglevel.warn,'###1'+mapArtNumber);
        return Database.getQueryLocator([SELECT Id, ArticleNumber, KnowledgeArticleId,IsVisibleInPkb,IsVisibleInCsp,Article_Classification__c FROM Knowledge__kav WHERE PublishStatus = 'online' and ArticleNumber IN :mapArtNumber.keyset() and (IsVisibleInCsp = true or IsVisibleInPkb = true) and Article_Classification__c!='CaseLines']);
    }
    /**
     * @description execute method
	 * @param Database.BatchableContext bc
	 * @param List<sObject> supportArticles
     */
    global void execute(Database.BatchableContext bc, List<sObject> supportArticles){
        List<Id> articleIDs = new List<Id>();
        List<String> articleNumbers = new List<String>();
        //Step 1: Open published articles in editing mode which is Draft status
        List<ESC_ArticleNumberMapping__c> artNumblst = ESC_ArticleNumberMapping__c.getAll().Values();
       
        for(ESC_ArticleNumberMapping__c art : artNumblst){
           mapArtNumber.put(art.Name,art.ESC_Old_Article_Number__c);
        }
        for(Knowledge__kav a: (List<Knowledge__kav>)supportArticles){
            system.debug(logginglevel.warn,'###2'+a);
            String id;
            try{
                id = KbManagement.PublishingService.editOnlineArticle(a.KnowledgeArticleId, true);
            }catch(exception ex){
                system.debug(logginglevel.warn,'exception'+ex+a);
            }
            if (id == null) {
                System.debug(logginglevel.warn,'##### ERROR While Editing');
            }
            else{
                system.debug(logginglevel.warn,'###4'+a.ArticleNumber);
                articleNumbers.add(a.ArticleNumber);
            }
        }
        system.debug(logginglevel.warn,'###5'+articleNumbers);
        List<Knowledge__kav> articles = new List<Knowledge__kav>();
        for (Knowledge__kav d : [SELECT Id, ArticleNumber, KnowledgeArticleId,IsVisibleInPkb,IsVisibleInCsp,Article_Classification__c FROM Knowledge__kav WHERE PublishStatus = 'draft' AND ArticleNumber IN :articleNumbers]) {
            // Step 2: perform your updates
            system.debug(logginglevel.warn,'###6'+d);
            if(mapArtNumber.containsKey(d.ArticleNumber)){
                system.debug(logginglevel.warn,'###7'+mapArtNumber.get(d.ArticleNumber));
                d.IsVisibleInPkb = false;
                d.IsVisibleInCsp = false;
                articles.add(d);
            }
            articleIDs.add(d.KnowledgeArticleId);
            
        }
        system.debug(logginglevel.warn,'###8'+articles);
        if(articles.size() > 0){
            try{
                update articles;
                }Catch(Exception ex){
                    system.debug(logginglevel.warn,'exception1'+ex);
                }
        }
        //Step 3: re-publish all the draft article of this batch.
        for (String articleId : articleIDs) {
            KbManagement.PublishingService.publishArticle(articleId, true);
            system.debug(logginglevel.warn,'###9'+articleId);
        }
    }
	
	/**
     * @description finish method
	 * @param Database.BatchableContext bc
     */
	 
    global void finish(Database.BatchableContext bc) {
        system.debug(logginglevel.warn,'Finished');
    }
}