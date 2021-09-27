/**
 * @description APTS_QuoteDocPostBack
 */
global without sharing class  APTS_QuoteDocPostBack 
{  
    /**
 * @description Quote
 */
   //Define an object in apex that is exposed in apex web service
   global class Quote 
   {  
      webservice String attachhmentId;         
   }   
   /**
     * @description Bar
     * @param vQuote
     * @return sReturnMssge
     */
   webservice static Blob fetchQuoteDoc(Quote vQuote) 
   {
       Blob sReturnMssge = null;  
       try
       { 
            List<ContentVersion> quoteContentVersion = new List<ContentVersion>();            
            if(Schema.sObjectType.ContentVersion.isAccessible() && Schema.sObjectType.ContentVersion.isQueryable()){
            quoteContentVersion = [Select Id, ContentDocumentId, VersionData, Title from ContentVersion where ContentDocumentId =:vQuote.attachhmentId];
            }
            if(!quoteContentVersion.isEmpty())
            {                
                 sReturnMssge = quoteContentVersion[0].VersionData;                   
             }
            else
            {
                return Blob.valueOf('Attachment not Found');
            }
            
       }
       catch (Exception ex)
       {
        //sReturnMssge =  Blob.valueOf('Exception:'+ex.getMessage());
        System.debug(LoggingLevel.WARN,'Exception:'+ex);
       }
       system.debug(LoggingLevel.WARN,'sReturnMssge...'+sReturnMssge);
       return sReturnMssge; 
  }
}