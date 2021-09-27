/******************************************************************************************
* Class         : OmniCalltoEloqua
* @description  : OmniCalltoEloqua
* @param        : NA
* @return       : NA
* Created Date  : JUL-2021
* Author        : TCS Developer 
* ****************************************************************************************/
public without sharing  class OmniCalltoEloqua {

    private static string trialSource;
    
    private static string encryptedURLMain='';
    
    public static List<ContentVersion> contNotesList;
    /**
    * @description getOmniTrialsEloquaCalls
    * @param trialId
    * @param trialContIds
    * @param trialProdIds
    * @return true
    */ 
    @auraEnabled
    public static Boolean getOmniTrialsEloquaCallsLWC(String trialId, String trialContIds, String trialProdIds) {
        
        System.debug(LoggingLevel.DEBUG, '@@trialId: '+trialId);
        System.debug(LoggingLevel.DEBUG, '@@trialContIds: '+trialContIds);
        System.debug(LoggingLevel.DEBUG, '@@trialProdIds: '+trialProdIds);
        string trialIdLwc = (string) JSON.deserialize(trialId, String.class);
        List<Id> trialContIdsLwc = (List<Id>) JSON.deserialize(trialContIds, List<Id>.class);
        List<Id> trialProdIdsLwc= (List<Id>) JSON.deserialize(trialProdIds, List<Id>.class);
        Boolean isSuccess = getOmniTrialsEloquaCalls(trialIdLwc , trialContIdsLwc, trialProdIdsLwc);
        return isSuccess;
    }
    
    /**
    * @description getOmniTrialsEloquaCalls
    * @param trialId
    * @param trialContIds
    * @param trialProdIds
    * @return true
    */ 
    public static Boolean getOmniTrialsEloquaCalls(String trialId, List<Id> trialContIds, List<Id> trialProdIds) {
        
        System.debug(LoggingLevel.DEBUG, '##trialContIds: '+trialContIds);
        
        Boolean isSuccess;
        Ent_Trial__c trialRecord = getEntTrial(trialId);
        List<Trial_contact__c> trialConts = getTrialContacts(trialId,  trialContIds);
        list<Trial_Product__c> trialPrds = getTrialProds(trialId, trialProdIds);
        
        String entMappingURL = OmniCalltoEloquaHelper.getEntTrialMappingUrl(trialRecord);
        String trialPrdsMappingURL = OmniCalltoEloquaHelper.getTrialProdMappingUrl(trialRecord, trialPrds);
        
        //encrypted url
        encryptedURLMain = OmniCalltoEloquaHelper.encryptedURLCommon;
        
        List<Trial_contact__c> trialContToUpdate = new List<Trial_contact__c>();
        contNotesList = new List<ContentVersion>();
        
        for(Trial_contact__c trialCont : trialConts){
            String trialContMappingURL = OmniCalltoEloquaHelper.getTrialContMappingUrl(trialRecord,trialCont);
            
            
            String rawURL = entMappingURL +trialPrdsMappingURL+trialContMappingURL;
            
            rawURL = OmniCalltoEloquaHelper.getRemovedSpaceNullChar(rawURL);
            
            System.debug(LoggingLevel.DEBUG, '@@rawURL: '+rawURL );
            trialContToUpdate = prepareCallout(rawURL,trialCont,trialContToUpdate);
            
        }
        System.debug(LoggingLevel.DEBUG, '@@trialContToUpdate: '+trialContToUpdate);
        isSuccess = OmniCalltoEloquaHelperTwo.updateTrialStatus(trialId,trialContToUpdate);
        
        //Insert Note in future method
        OmniCalltoEloquaHelperTwo.insertContentNotes(contNotesList);
        
        return isSuccess;
    }
    
    /**
    * @description getOmniTrialsEloquaCalls
    * @param rawURL
    * @param trialCont
    * @param trialContToUpdate
    * @return true
    */ 
    @testvisible
    private static List<Trial_contact__c>  prepareCallout(String rawURL, Trial_contact__c trialCont,List<Trial_contact__c> trialContToUpdate){
    
        //encrypted url
        String encryptedTrialContURL = OmniCalltoEloquaHelper.encryptedTrialContURL;
        String encryptVariables = encryptedURLMain+encryptedTrialContURL;
        
        encryptVariables = OmniCalltoEloquaHelper.getRemovedSpaceNullChar(encryptVariables);
        
        String debugURL = encryptVariables;
        System.debug(LoggingLevel.DEBUG, '@@debugEndPoint : '+debugURL);
        
        String omniCrptoKey = KeyValueListStore__c.getValues('OmniEloquaCallEncryptionKey').TextValue__c;
        
        Blob onDemandTrialBlob = blob.valueof(omniCrptoKey);
        string onDemandTrialString = EncodingUtil.base64Encode(onDemandTrialBlob);
        Blob cryptoKey = EncodingUtil.base64Decode(onDemandTrialString);
        Blob data = Blob.valueOf(encryptVariables);
        Blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
        String encryptedURL = EncodingUtil.base64Encode(encryptedData);
        String encodedURL = EncodingUtil.urlEncode(encryptedURL, 'UTF-8');
        
        
        WebServiceSettings__c eloquaSettings;    
        
        if(trialSource == 'Digital'){        
            eloquaSettings = AppUtil.getWebServiceSettings('ODTDGEloquaFormName');
        }else{
            eloquaSettings = AppUtil.getWebServiceSettings('OmniEntTrialsEloqua');
        }    
        Integer timeout = (Integer) eloquaSettings.Timeout__c;
        timeout = timeout * 100;
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setTimeout(120000)  ;      
        
        if(trialCont.Status__c == 'Active'){
            req.setEndpoint(eloquaSettings.Endpoint__c+'&'+rawURL);
        }
        else{
            req.setEndpoint(eloquaSettings.Endpoint__c+'&'+rawURL+'&eUrl='+encodedURL );
        }
        
        Http http = new Http();
        HTTPResponse res;
        res = http.send(req);   
        
        system.debug(LoggingLevel.DEBUG,'res--->'+res.getBody());
        
        //store Note
        String verisionData = OmniCalltoEloquaHelperTwo.getVersionDataInString(debugURL, encryptedURL, req);
        ContentVersion conNote = OmniCalltoEloquaHelperTwo.getContentVersion(res, verisionData, trialCont.Id);
        contNotesList.add(conNote);
        
        String eloquaResp = String.valueOf(res.getBody());
        
        trialContToUpdate = updateTrialContactAfterSuccess(eloquaResp, trialCont, trialContToUpdate);
        
        return trialContToUpdate;
    }
    
    /**
    * @description updateTrialContactAfterSuccess
    * @param eloquaResp
    * @param trialCont
    * @param trialContToUpdate
    * @return trialContToUpdate
    */ 
    private static List<Trial_contact__c> updateTrialContactAfterSuccess(String eloquaResp, Trial_contact__c trialCont, List<Trial_contact__c> trialContToUpdate){
        
        String omniEloquaSuccessString = System.Label.OmniEloquaSuccessString;
        
        Trial_contact__c tc = new Trial_contact__c();
        tc.Id = trialCont.Id;
        
        if(eloquaResp != null && eloquaResp.contains(omniEloquaSuccessString)){
            system.debug(LoggingLevel.DEBUG,'Inside Success');
            
            //sucess for BounceBack 
            if(trialCont.status__c == 'Bounceback'){
                tc.status__c = 'Rep Initiated';
                trialContToUpdate.add(tc);
            }
            //sucess for Trial Status Active which we invoke from Trial cont Trigger 
            else if(trialCont.status__c == 'Active'){
                tc.Entitlement_Email_Sent__c = true;
                trialContToUpdate.add(tc);
            }
             //sucess for Trial Status Extended which we invoke from Trial cont Trigger 
            else if(trialCont.status__c == 'Extended'){
                tc.Extended_Email_Sent__c = true;
                trialContToUpdate.add(tc);
            }
            
        }
        //failure for Create Trial Console page back to draft->Updating back to Draft only when Status is Rep Initiated
        else if(!eloquaResp.contains(omniEloquaSuccessString) && trialCont.status__c == 'Rep Initiated'){ 
            tc.status__c = 'Draft';
            trialContToUpdate.add(tc);
        }
        return trialContToUpdate;
    }
      
    
    /**
    * @description getEntTrial
    * @param trialId
    * @return trialRecord
    */ 
    @testvisible
    private static Ent_Trial__c getEntTrial(String trialId){
        Ent_Trial__c trialRecord = new Ent_Trial__c ();
        if(Schema.sObjectType.Ent_Trial__c.isAccessible()){
        trialRecord =[select Id,Account__r.BillingCountry,Trial_Source__c,Trial_Status__c, External_Account_Number__c, External_Account_Number_Source__c,
                      Trial_Start_Date__c, Trial_End_Date__c ,Campaign__c ,Number_of_Days__c, Opportunity__c,Account_Name__c,
                      Profile_Type__c, Owner.Email, Owner.Phone, Owner.Title, Owner.FirstName, Owner.LastName,
                      Account__r.ECC_Segment_Level_2__c, Account__r.Name,Total_NumberofTrial_Contacts__c,Account__r.BillingState
                      from Ent_Trial__c where Id =: trialId];
        }
        
        
        trialSource = trialRecord.Trial_Source__c;
        
        return trialRecord;
    }
    
    /**
    * @description getTrialContacts
    * @param trialId
    * @param trialContIds
    * @return trlCons
    */ 
    @testvisible
    private static list<Trial_contact__c> getTrialContacts(String trialId, list<id> trialContIds){
        list<Trial_contact__c> trlCons = new list<Trial_contact__c> ();
        
        if(Schema.sObjectType.Trial_contact__c.isAccessible()){
        trlCons = [select id,Email__c, First_Name__c, Last_Name__c,
                   Status__c, Contact__c, One_Pass_ID__c, COBALT_GUID__c,DATAROOM_GUID__c, External_Contact_Number__c,
                    Unique_Name__c, Primary__c,External_Contact_Number_Source__c, Request_Type__c, Profile_Type__c
                    ,Invite_User_First_Name__c,Invite_User_Last_Name__c,Contact_Phone__c,One_Pass_User_Name__c,Country__c,State__c
                   from Trial_contact__c where id in :trialContIds and Trials__c = : trialId];
        }
        return trlCons;
    }
    
    /**
    * @description getTrialProds
    * @param trialId
    * @param trialProdIds
    * @return trlPrds
    */ 
    @testvisible
    private static list<Trial_Product__c> getTrialProds(String trialId, list<id> trialProdIds){
        
        list<Trial_Product__c> trlPrds = new list<Trial_Product__c> ();
        if(Schema.sObjectType.Trial_Product__c.isAccessible()){
        trlPrds = [select Id, Product_Name__r.Name, Product_Name__r.ProductCode,Product_Name__r.family,Material_Number__c, Relationship_Type__c,
                    Base_Material_Number__r.ProductCode, Segment__c, Product_Offerings__c 
                    from Trial_Product__c where id in :trialProdIds and Trial__c = : trialId];
        }
        return trlPrds;
    }
}