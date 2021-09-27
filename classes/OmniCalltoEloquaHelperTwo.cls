/******************************************************************************************
* Class         : OmniCalltoEloqua
* @description  : OmniCalltoEloqua
* @param        : NA
* @return       : NA
* Created Date  : AUG-2021
* Author        : TCS Developer 
* ****************************************************************************************/

public without sharing class OmniCalltoEloquaHelperTwo {
    
    /**
    * @description getParam
    * @param trialRec
    * @param digitalParam
    * @param omniParam
    * @return string
    */ 
    public static string getParam(Ent_Trial__c trialRec,String digitalParam, String omniParam){
        String value = omniParam; 
        if(trialRec.Trial_Source__c == 'Digital'){
            value = digitalParam;
        }else{
            value = omniParam;
        }
        
        return value;
    }
    
    /**
    * @description getContentVersion
    * @param res
    * @param versionData
    * @param firstPublishLocationId
    * @return objCntNote
    */ 
    public static ContentVersion getContentVersion(HTTPResponse res, String versionData, Id firstPublishLocationId){
        
        versionData +=String.valueOf(res);
        
        ContentVersion objCntNote = new ContentVersion();
        objCntNote.Title = 'Eloqua Request';
        objCntNote.PathOnClient = 'Eloqua Request' + '.txt';
        objCntNote.VersionData = Blob.valueOf(versionData.escapeHtml4().replace('\r\n', '<br>').replace('\n', '<br>').replace('\r', '<br>'));
        objCntNote.FirstPublishLocationId = firstPublishLocationId;
        return objCntNote;
    }
    
    /**
    * @description getVersionDataInString
    * @param debugURL
    * @param encryptedURL
    * @param req
    * @return data
    */ 
    public static String getVersionDataInString(String debugURL, String encryptedURL, HttpRequest req){
        
        String data='';
        data += 'URL To Be Encrypted:        '+ debugURL +'\n'+'\n';
        data += 'Base64Encode Encrypted URL:        '+ encryptedURL+'\n'+'\n';
        data += 'HttpRequest :        '+ String.valueOf(req)+'\n'+'\n';
        return data;
    }
    
    /**
    * @description insertContentNotes
    * @param contNotesList
    */ 
    public static void insertContentNotes(List<ContentVersion> contNotesList){
        try{
            if(!Test.isRunningTest() && !contNotesList.isEmpty() && contNotesList != null){
                insert contNotesList;
            }
        }catch(Exception exp){
            System.debug(LoggingLevel.DEBUG, '@@exp : '+exp);
        }
        
    }
    
    /**
    * @description getVersionDataInString
    * @param prdFamilySet
    * @return prdFamilyStr 
    */ 
    public static String getVersionDataInString(Set<String> prdFamilySet){
        
        String prdFamilyStr = '';
        
        Integer counter = 1;
        if(prdFamilySet != null){
            for(String family :  prdFamilySet){
                
                if(counter == 1){
                    prdFamilyStr += '&pFam'+'=' + family;
                }
                else
                {
                    prdFamilyStr += '&pFam'+counter+'=' + family;
                }
                counter++;
            }
        }
        
        
        return prdFamilyStr;
    }
    
     /**
    * @description updateTrialStatusToDraft
    * @param trialRecordId
    * @param trialconts
    * @return trialContMappingURL
    */ 
    public static Boolean updateTrialStatus(Id trialRecordId, List<Trial_contact__c> trialconts){
        Boolean isSuccess = true;
         
        if(!trialconts.isEmpty() && trialconts != null){
           
            for(Trial_contact__c trialCon : trialconts){
                
                //failure Eloqua call move Trial status to Draft only from Rep Initiated
                if(trialCon.status__c == 'Draft'){
                    System.debug(LoggingLevel.DEBUG, '@@Inside Failure: ');
                    //ELoqua fail
                    isSuccess = false;
                    break;
                }
            }
            
            if(Schema.sObjectType.Trial_contact__c.isUpdateable()){
                System.debug(LoggingLevel.DEBUG, '@@trialContList : '+trialconts);
                update trialconts;
            }
            
            
            //Ent Trial status will be Draft if Trial Contact Status is Draft - Applicable for Rep Initiated Scenario Submit Button From Add USer and Trial Console
            if(!isSuccess && Schema.sObjectType.Ent_Trial__c.isUpdateable()){
                System.debug(LoggingLevel.DEBUG, '@@trialRecordId: '+trialRecordId);
                Ent_Trial__c entTrial = new Ent_Trial__c();
                entTrial.Trial_status__c = 'Draft';
                entTrial.Id = trialRecordId;
                update entTrial;
            }
            
        }
        return isSuccess;
    } 
}