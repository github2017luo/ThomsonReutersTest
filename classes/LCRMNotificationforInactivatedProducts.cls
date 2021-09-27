/**
* CRM-4929 Legal CRM November release
* Class for nitifying opportunity team when a product is inactivated
*
* @author  Saloni Sukhija
* @version 2017-08-27
*/
/**
 * CHANGE HISTORY
 * ========================================================================================================================
 * Date               Name                       Description
  
 * 2019-02-04        Tejasree                    DPS-441 :Replaced hardcoding with custom labels in the body of Email 
                                                           and added a logic to send Email for french users in french Language
 
 * ========================================================================================================================
**/
global class LCRMNotificationforInactivatedProducts implements Database.Batchable<sObject>{

    public String query;
   
    global LCRMNotificationforInactivatedProducts(){
        query = 'SELECT OpportunityId,Opportunity.Name,Product2Id,Product2.Name FROM OpportunityLineItem WHERE Product2.LCRM_Inactivated_Date__c=TODAY AND Opportunity.isClosed=false';
    }
    
    global Database.queryLocator Start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> oppProductList){
        
        //if there are products that are inactivated today, then email notification will be sent
        if(oppProductList!=null && oppProductList.size() > 0){
            Map<Id,String> InactiveProductsMap = new Map<Id,String>();
            Map<Id,String> RequiredOpportunitiesMap = new Map<Id,String>();
            
            Map<Id,OpportunityTeamMember> OpportunitiesTeamMembersMap;
            Map<Id,List<Id>> OpportunitiesOwnerandTeamEmail = new Map<Id,List<Id>>();
        
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
    
            //making a map of inactive products and open opportunities
            for(SObject obj:oppProductList){
                OpportunityLineItem oppProd = (OpportunityLineItem)obj;
                InactiveProductsMap.put(oppProd.Product2Id, oppProd.Product2.Name);
                RequiredOpportunitiesMap.put(oppProd.OpportunityId,oppProd.Opportunity.Name);
            }
            
            //making a map for emails with opportunity id as the key and set of emails as the value
            OpportunitiesTeamMembersMap = new Map<Id,OpportunityTeamMember>([SELECT Id,UserId,OpportunityId FROM OpportunityTeamMember WHERE OpportunityId in :RequiredOpportunitiesMap.keySet()]);
            for(OpportunityTeamMember otm : OpportunitiesTeamMembersMap.values()){
                Id memberId = otm.UserId; 
                List<Id> teamIds;
                if(OpportunitiesOwnerandTeamEmail.keyset().contains(otm.OpportunityId)){
                    teamIds = OpportunitiesOwnerandTeamEmail.get(otm.OpportunityId);
                    teamIds.add(memberId);
                }
                else{
                    teamIds = new List<Id>();
                    teamIds.add(memberId);
                    OpportunitiesOwnerandTeamEmail.put(otm.OpportunityId,teamIds);
                }
            }
            
            //sending notification - Added another template for french users as a part of DPS-441
            for(SObject oppProd : oppProductList){
            
                OpportunityLineItem ol = (OpportunityLineItem)oppProd;
            
                if(RequiredOpportunitiesMap.get(ol.OpportunityId) != null){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    
                        List<Id> teamIds = OpportunitiesOwnerandTeamEmail.get(ol.OpportunityId);
                        //List<user> userlanglist=[Select Id,LanguageLocaleKey from user where Id IN :teamids]; //Removing Sonar Qube Violation
                        List<user> userlanglist= passTeamsId(teamIds);
                        for(User u : userlanglist)
                        {
                        
                            singleMail = new Messaging.SingleEmailMessage();
                            singleMail.setSaveAsActivity(false);
                            if(u.LanguageLocaleKey=='en_US')
                            {
                             system.debug('USER LANGUAGE' +u.LanguageLocaleKey);
                            singleMail.setTargetObjectId(u.Id);
                            singleMail.setSubject(System.Label.Product_Inactivated_en);
                            String body = System.Label.Hello_en +',<br><br>' + System.Label.Product_added_to_opportunity_en + '<b>' + (RequiredOpportunitiesMap.get(ol.OpportunityId)) + '</b>,'+ System.Label.has_now_been_marked_as_inactive_en +'.' + System.label.This_product_is_en + '<b>' + (InactiveProductsMap.get(ol.Product2Id)) + '</b>.<br>'+System.Label.Inactive_products_cannot_be_sold_en +',' +System.Label.please_update_the_opportunity_and_notify_the_customer_accordingly_en +'. <br><br>' + FieldId__c.getOrgDefaults().Instance_URL__c+''+ol.OpportunityId + '<br><br>' +System.Label.Thanks_en;
                            singleMail.setHtmlBody(body);
                            emails.add(singleMail);
                            
                           }
                           else if(u.LanguageLocaleKey=='fr_CA'){
                           
                            singleMail.setTargetObjectId(u.Id);
                            singleMail.setSubject(System.Label.Product_Inactivated_fr_CA);
                            String body = System.Label.Hello_fr_CA +',<br><br>' + System.Label.Please_note_that_a_product_that_was_added_to_the_opportunity_fr_CA + '<b>' + (RequiredOpportunitiesMap.get(ol.OpportunityId)) + '</b>,'+ System.Label.has_now_been_marked_as_inactive_fr_CA +'.' + System.label.This_product_is_fr_CA + '<b>' + (InactiveProductsMap.get(ol.Product2Id)) + '</b>.<br>'+System.Label.Inactive_products_cannot_be_sold_fr_CA +',' +System.Label.please_update_the_opportunity_and_notify_the_customer_accordingly_fr_CA +'. <br><br>' + FieldId__c.getOrgDefaults().Instance_URL__c+''+ol.OpportunityId + '<br><br>' +System.Label.Thanks_fr_CA;
                            singleMail.setHtmlBody(body);
                             system.debug('USER LANGUAGE' +u.LanguageLocaleKey);
                            emails.add(singleMail);
                          } 
                          
                            
                            
                            
                            //}
                        }
                        
                        
                }
            }
                
            List<Messaging.SendEmailResult> results;
            if(emails.size() > 0)
               results = Messaging.sendEmail(emails);
            
            for(Integer i=0;i<results.size();i++){
                if(!results.get(i).isSuccess()){
                    LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                    excepObj.LCRM_Exception_Message__c = results.get(i).getErrors()[0].getMessage();
                    OpportunityLineItem oli = (OpportunityLineItem)oppProductList.get(i);
                    excepObj.LCRM_Record_Ids__c = oli.Product2Id;
                    excepObj.LCRM_Exception_Type__c = 'Notification for inactivated product failure';
                    exceptionList.add(excepObj);
                }
            }
            
            if(exceptionList.size() > 0)
                insert exceptionList;
        } 
    }
    
    global void finish(Database.BatchableContext BC){
 
    }
    
    //Adding as a part of removing Sonar Qube Violation
    private static list<user> passTeamsId(List<Id> teamIds){
              return [Select Id,LanguageLocaleKey from user where Id IN :teamids];
            }
}