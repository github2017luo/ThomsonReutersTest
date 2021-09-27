/** 
* @author Kunal Mishra
* @date 22/06/2021
* @description Helper class to create ContentVersion records and attach them to the Renewal Quotes
*/

@SuppressWarnings('PMD.ApexDoc,PMD.DebugsShouldUseLoggingLevel')
public without sharing class RenewalQuoteTriggerHelper{
    
    public static list<Renewal_Quote__c> listOfrenQuotes = new list<Renewal_Quote__c>();
    public static list<ContentDocumentLink> listOFContentDocumetns = new list<ContentDocumentLink>();
    public static list<ContentDistribution> listOfContentDistribution = new list<ContentDistribution>();
    public static list<Renewal_Quote__c> listOfFinalrQuotes = new list<Renewal_Quote__c>();
    
    public static set<ID> setOfContentVersionIds = new set<ID>();
    public static set<ID> setOfCreatedConDis = new Set<ID>();
    
    public static list<ContentDocumentLink> conDocLinkList = new list<ContentDocumentLink>();
    public static set<ID> setOfCreatedConVrsnIDs = new set<ID>();
    public static map<ID,ID> mapOfContentVersionTorQuote = new map<ID,ID>();
    public static map<ID,Renewal_Quote__c> mapOfContentVersionTorQuoteDetails = new map<ID,Renewal_Quote__c>();
    
    public static  void genericAfterUpdate(map<ID,Renewal_Quote__c> mapOfNewValues,map<ID,Renewal_Quote__c> mapOfOldValues){
    
    
        for(Renewal_Quote__c rQuote : mapOfNewValues.values()){
               Renewal_Quote__c oldrQuote = (Renewal_Quote__c)mapOfOldValues.get(rQuote.ID);
               if(rQuote.Content_Version_ID__c!=null && (oldrQuote.Content_Version_ID__c == null || oldrQuote.Content_Version_ID__c ==''))
                   {listOfrenQuotes.add(rQuote);}
           }
           
           if(!listOfrenQuotes.isEmpty()){
               for(Renewal_Quote__c rQuote : listOfrenQuotes){
                   mapOfContentVersionTorQuote.put(rQuote.Content_Version_ID__c,rQuote.ID);
                   mapOfContentVersionTorQuoteDetails.put(rQuote.Content_Version_ID__c,rQuote);
                   setOfContentVersionIds.add(rQuote.Content_Version_ID__c);
                   rQuote.Document_Created__c = true;
                   //listOfFinalrQuotes.add(rQuote);
               }
           }
           
           if(!setOfContentVersionIds.isEmpty())
               {formContentDocumentLinks(setOfContentVersionIds);}
               

        
    }
    
     public static void formContentDocumentLinks(set<ID> setOfCVIds){
     try{
        for(ContentVersion cvRecs : [SELECT ID,ContentDocumentId FROM ContentVersion WHERE Id in :setOfContentVersionIds]){
            ContentDocumentLink conDoc = new ContentDocumentLink();
            conDoc.LinkedEntityId = mapOfContentVersionTorQuote.get(cvRecs.ID);
            conDoc.ContentDocumentId = cvRecs .ContentDocumentId;
            conDoc.shareType = 'V';
            
            ContentDistribution cd = new ContentDistribution();
            cd.Name = 'Test';
            cd.ContentVersionId = cvRecs.id;
            cd.PreferencesAllowViewInBrowser= true;
            cd.PreferencesLinkLatestVersion=true;
            cd.PreferencesNotifyOnVisit=false;
            cd.PreferencesPasswordRequired=false;
            cd.PreferencesAllowOriginalDownload= true;
            listOfContentDistribution.add(cd);

            listOFContentDocumetns.add(conDoc);
        }
        
           if(!listOFContentDocumetns.isEmpty())
                {insert listOFContentDocumetns;}
        
        if(!listOfContentDistribution.isEmpty()){
            
            Database.SaveResult[] srList = Database.insert(listOfContentDistribution, false);
             
            // Iterate through each returned result
            for (Database.SaveResult sr : srList){
            if(sr.isSuccess())
                {setOfCreatedConDis.add(sr.getId());}
            }
            
            if(!setOfCreatedConDis.isEmpty()){
                for(ContentDistribution conDstr : [SELECT ID,ContentDownloadUrl,ContentVersionID FROM ContentDistribution  WHERE ID in :setOfCreatedConDis]){
                    
                    mapOfContentVersionTorQuoteDetails.get(conDstr.ContentVersionID).Public_URL__c = conDstr.ContentDownloadUrl;
                    
                }
            }
                

        
        }
        }
        catch(Exception ex){ 
                system.debug('$$$'+ex.getLineNumber()+''+ex.getMessage()+''+ex.getCause()+''+ex.getTypeName());
        }

     
     }
     
     public static void updateFRecordsPostCallout(list<Renewal_Quote__c> listOFFail){
         try{if(!listOFFail.isEmpty())
         {update listOFFail;}}
            catch(Exception ex){ 
                system.debug('$$$'+ex.getLineNumber()+''+ex.getMessage()+''+ex.getCause()+''+ex.getTypeName());
        }
         
     }
     
     public static void processContentDocuments(list<ContentVersion> cvList,map<ID,Renewal_Quote__c> mapOfRenewalIDtoQuote){
     try{
         if(!cvList.isEmpty()){
            Database.SaveResult[] srList = Database.insert(cvList, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList){
            if(sr.isSuccess())
                {setOfCreatedConVrsnIDs.add(sr.getId());}
            }
            system.debug('ID List'+setOfCreatedConVrsnIDs);
            for(ContentVersion oCVrsn : [SELECT ID,ContentDocumentId,Renewal_Quote_ID__c FROM ContentVersion  WHERE ID in :setOfCreatedConVrsnIDs]){

                mapOfRenewalIDtoQuote.get(oCVrsn.Renewal_Quote_ID__c).Content_Version_ID__c = oCVrsn.ID;
            }
            
            
            //insert conDocLinkList;
            update mapOfRenewalIDtoQuote.values();
          }
     }
        catch(Exception ex){ 
                system.debug('$$$'+ex.getLineNumber()+''+ex.getMessage()+''+ex.getCause()+''+ex.getTypeName());
        }
             
             }
             
              @invocablemethod(label='Update Failed Records')
             public static void resubmitFailedRenewalQuotes(List<Renewal_Quote__c> listOfFailedQuotes){
             system.debug(listOfFailedQuotes);
                 for(Renewal_Quote__c processQuote : listOfFailedQuotes){
                     processQuote.Status__c = 'In Progress';
                 }
              update listOfFailedQuotes;processUpdate();
                           
                              
             }
             
             public static void processUpdate(){
             if(!Test.isRunningTest() && GLI_Load_Tracker__c.sObjectType.getDescribe().isUpdateable()){GLI_Load_Tracker__c testBulkLoadGLI = [SELECT ID,Name,JobCompletedDate__c FROM GLI_Load_Tracker__c WHERE Name = 'Informatica Renewal Notifications Load'];
                testBulkLoadGLI.JobCompletedDate__c = Datetime.now();update testBulkLoadGLI;}}
             
             
}