/*
===============================================================================
LCRMPreferenceMethod
===============================================================================

PURPOSE: Helper class for MarketingPreferenceController and LCRMLeadPreferenceController

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-09-29      Vaishali                  Created 
===============================================================================
*/
public without sharing class LCRMPreferenceMethod{

    public string preferenceCenterLink;
    Public string IDofthePage{get;set;}
    public boolean CheckObectStatus{get;set;}
    
    public LCRMPreferenceMethod(){
    IDofthePage= ApexPages.currentPage().getParameters().get('id');
    if(IDofthePage<> null && IDofthePage<>''){
       
        if(IDofthePage.startsWith('00Q')){
          CheckObectStatus=true;
          
        }else if(IDofthePage.startsWith('003')){
        CheckObectStatus=false;
        }
    }
   
    }

     //form the preference center link for lead and contact page layouts
     public string getPreferenceCenterLink(string Email, string contactId , string SubBu, string oCountry,String pageId){
     
          Map<string,LCRM_Preference_Center__c> mapCountry =LCRM_Preference_Center__c.getAll();
              List<String> listCountry = new List<String>(mapCountry.keySet());
              string Link =  '?emailAddress=' + Email + '&contactID=' + contactId + '&subBU=' + SubBu;
              for(String country:listCountry){
              
                  if(country.equalsIgnoreCase(oCountry)){
                      
                      preferenceCenterLink = mapCountry.get(oCountry).LCRM_Preference_Center_Link__c + Link;
                      break;
                  }else{
                    String headerdata= ApexPages.currentPage().getHeaders().get('Host');
                    
                    String urlvalue='/apex/LCRMPreferenceCenterNotFound?id='+pageId;
                    
                    String  url='https://' + headerdata+ urlvalue;
                    
                    preferenceCenterLink = url;
                   
                  }
      
          
      }
      return preferenceCenterLink;
   }  
  
  @AuraEnabled(cacheable=true)
     public static string getTRPreferenceCenterLink(string contactId){ 
          String preferenceCenterLink ;
          Contact con = [Select id, Email, LCRM_Country__c from contact where id=:contactId];
          User username = [SELECT Id,Sub_Bu__c FROM User where Id =:UserInfo.getUserId()];
          Map<string,LCRM_Preference_Center__c> mapCountry =LCRM_Preference_Center__c.getAll();
              List<String> listCountry = new List<String>(mapCountry.keySet());
              string Link =  '?emailAddress=' + con.Email + '&contactID=' + contactId + '&subBU=' + username.Sub_Bu__c;
              for(String country:listCountry){             
                  if(country.equalsIgnoreCase(con.LCRM_Country__c)){                     
                      preferenceCenterLink = mapCountry.get(con.LCRM_Country__c).LCRM_Preference_Center_Link__c + Link;
                      break;
                  }else{
                    //String headerdata= ApexPages.currentPage().getHeaders().get('Host'); 
                    String headerdata = System.URL.getSalesforceBaseURL().getHost();                   
                    String urlvalue='/apex/LCRMPreferenceCenterNotFound?id='+con.id;                    
                    String  url='https://' + headerdata+ urlvalue;                    
                    preferenceCenterLink = url;                   
                  }                
      }
      return preferenceCenterLink;
   }  
  //form the TPS Screening Document Link for lead and contact page layouts  
   /*public string getTPSLink(string PageId){
       
       //get the document title and library name from keyvalueliststore custom setting
       List<String> dataList = (KeyValueListStore__c.getValues('TPS Screening') == null || 
                                   KeyValueListStore__c.getValues('TPS Screening').TextValue__c == null || 
                                   KeyValueListStore__c.getValues('TPS Screening').TextValue__c == '')?
                                   new List<String>():
                                   KeyValueListStore__c.getValues('TPS Screening').TextValue__c.split(',');
       
       //query the contentdocumentlink object to get the documentid
       
       
       List<ContentDocumentLink> fileList = new List<ContentDocumentLink>();
       List<ContentDocument> contentDoc = new List<ContentDocument>();
       String urlvalue='';
       String  url = '';
       try{
           
          if(dataList <> null && dataList.size() > 0){
          
           contentDoc = [select id, title from ContentDocument where title =:dataList[0]];
        }
        
        if(contentDoc<> null && contentDoc.size() > 0){
            
            Id contentDocId = contentDoc[0].Id;
        
            fileList = [SELECT ContentDocument.title,ContentDocumentId, ContentDocument.LatestPublishedVersionId  FROM
                    ContentDocumentLink WHERE ContentDocumentId =: contentDocId];
        }
        
         
       //form the TPS screening URl
       String headerdata= ApexPages.currentPage().getHeaders().get('Host');
       if(fileList.size() >0 && fileList<> null){
           
           urlvalue='/sfc/servlet.shepherd/version/download/' + fileList[0].ContentDocument.LatestPublishedVersionId;
       }else{
          
           urlvalue = '/apex/LCRMTPSDocumentNotFound?id='+PageId;
       }
       
           url = 'https://' + headerdata+ urlvalue;
       
       }
       catch(Exception ex){
            system.debug('@@ Exception in ContentDocument Query' + ex);
       }
        return url;
      
   }  */
}