/**
     * @description OmniTrialValidation
*/
public without sharing class OmniTrialValidation{
    
  public  static map<string,string> reasonCodeMap ;

  /**
  * @description getDigitalBlacklistCompetitorStatus
  * @param emailId
  * @return digitalBlackList
  */
 @AuraEnabled //(cacheable=true)
 public static Digital_Blacklist_or_CompetitorList__c getDigitalBlacklistCompetitorStatus(String emailId){
     /**
      * @description digitalBlackList
      */
     List<Digital_Blacklist_or_CompetitorList__c> digitalBlackList = new List<Digital_Blacklist_or_CompetitorList__c> ();
     if(Schema.sObjectType.Digital_Blacklist_or_CompetitorList__c.isAccessible()){
         digitalBlackList = [SELECT Id,Email__c,Status__c,Email_Domains__c,Type__c from Digital_Blacklist_or_CompetitorList__c WHERE Email__c = :emailId LIMIT 1];//:optyId];
         
     }
     
     if(digitalBlackList.size() > 0){
         return digitalBlackList[0];
     }
     else{
         return null;
     }
 }
 /**
  * @description getDigitalDomainCheck
  * @param domainName
  * @return isValidDomain
  */
 @AuraEnabled //(cacheable=true)
 public static Boolean getDigitalDomainCheck(String domainName){
     
     Boolean isValidDomain = true;
     List<Digital_Blacklist_or_CompetitorList__c> digitalBlackList = new List<Digital_Blacklist_or_CompetitorList__c> ();
     if(Schema.sObjectType.Digital_Blacklist_or_CompetitorList__c.isAccessible()){
         digitalBlackList = [SELECT Id from Digital_Blacklist_or_CompetitorList__c where Email_Domains__c=:domainName   LIMIT 1];
         
     }
     
     if(digitalBlackList.size()>=1){
         isValidDomain = false;
     }
     
    
     return isValidDomain;
 }
 
 
 /**
  * @description getLapsedAccount
  * @return reasonCodesDescription
  */
 @testVisible
 private static list<string>  getreasonCodeList(){
     
     
     reasonCodeMap = new map<string,string>();
     list<string> reasonCodesDescription = new list<string>();
     
     list<ODT_Trial_Reason_Codes__mdt > reasonCodeList = new list<ODT_Trial_Reason_Codes__mdt > ();
     
     if(Schema.sObjectType.ODT_Trial_Reason_Codes__mdt.isAccessible()){
         reasonCodeList = new list<ODT_Trial_Reason_Codes__mdt > ([Select ODT_Reason_Code__c, ODT_Reason_Description__c, 
                         ODT_Reason_Validity__c FROM ODT_Trial_Reason_Codes__mdt]);
     }
     
     if (reasonCodeList.size() > 0) {
         for (ODT_Trial_Reason_Codes__mdt code: reasonCodeList) {
             reasonCodeMap.put(code.ODT_Reason_Description__c,code.ODT_Reason_Code__c);
             reasonCodesDescription.add(code.ODT_Reason_Description__c);
         }
     }
     return reasonCodesDescription;
 }
 
 /**
  * @description getLapsedAccount
  * @param reasonCodesDescription
  * @param accountID
  * @return assetData
  */
 @testVisible
 private static List<asset>  getAssetData(List<string> reasonCodesDescription, string accountID){
     
     List<asset> assetData = new List<asset> ();
     if(Schema.sObjectType.asset.isAccessible() && Schema.sObjectType.Source_System_Detail__c.isAccessible()){
         assetData = [select id, Lapsed_Reason_Code_Description__c, Source_System_Detail__c from asset  where Source_System_Detail__c in 
                              (select Id from Source_System_Detail__c where Source_System_Account_Number__c =: accountID) 
                              and Lapsed_Reason_Code_Description__c in :reasonCodesDescription];
     }
     return assetData;
 }
 
 /**
  * @description getLapsedAccount
  * @param reasonCodesDescription
  * @param accountID
  * @return apttusAsset
  */
 @testVisible
 private static List<Apttus_Config2__AssetLineItem__c>   apttusAsset(List<string> reasonCodesDescription, string accountID){
     
     List<Apttus_Config2__AssetLineItem__c> apttusAsset = new List<Apttus_Config2__AssetLineItem__c> ();
     if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Source_System_Detail__c.isAccessible()){
          apttusAsset = [select id,APTS_Cancellation_Reason_Code__c from Apttus_Config2__AssetLineItem__c where APTS_SSD_Sold_To__c in 
                              (select Id from Source_System_Detail__c where Source_System_Account_Number__c =: accountID) 
                              and APTS_Cancellation_Reason_Code__c in :reasonCodesDescription];
     }
     return apttusAsset ;
 }
 
 /**
  * @description getLapsedAccount
  * @param accountID
  * @return lapsedReason
  */
 @AuraEnabled //(cacheable=true)
 public static LapsedReasonWrapper getLapsedAccount(string accountID){
      
         list<string> reasonCodes = getreasonCodeList();  
     
            
         List<Apttus_Config2__AssetLineItem__c> apttusAsset  = apttusAsset(reasonCodes, accountID);
           LapsedReasonWrapper objLapsedReason = new LapsedReasonWrapper();   
     if(apttusAsset != NULL && apttusAsset.size() > 0){
         objLapsedReason.lapsedreasonDesc= apttusAsset[0].APTS_Cancellation_Reason_Code__c;
         objLapsedReason.lapsedReasonCode = reasonCodeMap.get(apttusAsset[0].APTS_Cancellation_Reason_Code__c);
         objLapsedReason.isLapsedBlock = true;
         objLapsedReason.isLapsed = true;
         //System.debug('Lapsed Wrapper return '+objLapsedReason);
             //string lapsedReasonCode = reasonCodeMap.get(apttusAsset[0].APTS_Cancellation_Reason_Code__c);
             //string lapsedReason = 'Reason Code: '+lapsedReasonCode +'&& Description: '+apttusAsset[0].APTS_Cancellation_Reason_Code__c;
             return objLapsedReason;
         }else{
             List<asset> assetData = getAssetData(reasonCodes,accountID );
             if(assetData != NULL && assetData.size()> 0){
                 objLapsedReason.lapsedreasonDesc= assetData[0].Lapsed_Reason_Code_Description__c;
                 objLapsedReason.lapsedReasonCode = reasonCodeMap.get(assetData[0].Lapsed_Reason_Code_Description__c);
                 objLapsedReason.isLapsedBlock = true;
                 objLapsedReason.isLapsed = true;
                return objLapsedReason;
               }
         }
     
     return NULL;
 }
  /**
  * @description LapsedReasonWrapper
  */
    public class LapsedReasonWrapper{
        @AuraEnabled public string lapsedreasonDesc;
        @AuraEnabled public string lapsedReasonCode;
        @AuraEnabled public boolean isLapsedBlock;
        @AuraEnabled public boolean isLapsed;
        
    }
}