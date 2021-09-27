/*
======================================================================================================================
CLASS NAME:  AccountTerritoriesHandler
======================================================================================================================
PURPOSE:  A new batch needs to be written to load TMS Territory and Account Territory from Territory. Refresh periodically after the informatica job runs.
Technical Details:  A new batch class needs to be created in SFDC to populate TMS Territory and Account Territory Objects
JIRA story: CRM-11669 Display Territories in GLI - SFDC Batch classes
CHANGE HISTORY:
======================================================================================================================
DATE           Developer NAME             DESC
8/12/2017      Radhika Pawar     
======================================================================================================================
*/

//Commenting out as a part of removal of TM1.0 components
public class AccountTerritoriesHandler{

public AccountTerritoriesHandler()
{}
    /*public Static void AccountTerrCreationandUpdation(List<TMS_Territory__c> Acclst){
        System.debug('**Method Called AccountTerritoryCreation:');
        set<Id> accId= new set<Id>();
        if(!Acclst.isempty()){
            for(TMS_Territory__c acc: Acclst){
                accId.add(acc.Account__c);
            }
        }   
        System.debug('accId:-'+accId);  
        //Check size of set of Account IDS
        Try{
            IF(!accId.isempty()){ 
                //Map Of AccountId and TMS  Territories
                Map<String,List<TMS_Territory__c>> MapOfAccountTMSterritory =New map<String,List<TMS_Territory__c>>(); 
                Map<String,TMS_Territory__c> MapoftmsTerritory= new Map<String,TMS_Territory__c> ();
                //for(TMS_Territory__c TMSRecord:[Select id,Account__c,TMS_Sales_Force_Code__c,TMS_Market_Segment_Code__c,TMS_Ref_Function_Code__c from TMS_Territory__c where Account__c IN: accId and  (TMS_Sales_Force_Code__c !=null and TMS_Market_Segment_Code__c != null and TMS_Ref_Function_Code__c !=null and Territory_ID__c != null )]){
                for(TMS_Territory__c TMSRecord: Acclst){
                    
                    //Create Map OF Territory ID and Its Records
                    MapoftmsTerritory.put(TMSRecord.Id,TMSRecord);
                    
                    //Create Map OF Account ID and Its related TMS Territory Records
                    System.debug('Debug**'+MapOfAccountTMSterritory.get(TMSRecord.Account__c));
                    
                    if (MapOfAccountTMSterritory.containsKey(TMSRecord.Account__c)) {
                        MapOfAccountTMSterritory.get(TMSRecord.Account__c).add(TMSRecord);
                    }else {
                        MapOfAccountTMSterritory.put(TMSRecord.Account__c, new List < TMS_Territory__c > {TMSRecord});
                    }
                }
                System.debug('MapoftmsTerritory:-'+MapoftmsTerritory);
                System.debug('MapoftmsTerritory.Size():-'+MapoftmsTerritory.size());
                System.debug('MapOfAccountTMSterritory:-'+MapOfAccountTMSterritory);
                System.debug('MapOfAccountTMSterritory.size():-'+MapOfAccountTMSterritory.size());          
                //End Of mapping of Account and TMS Terriotry 
                //Query on Custom Setting name as Account_Territory_Creation__c
                //map to store the Account territory Field=>Territory Combine code to Create Account Territory
                Map<String, String> CombineCodeAccTerritorymap = new Map<String, String>();
                for(Account_Territory_Creation__c obj : Account_Territory_Creation__c.getall().values()) {
                    CombineCodeAccTerritorymap.put(obj.Terr_Combine_code__c, obj.Account_Territory_Fields__c);
                }     
                System.debug('CombineCodeAccTerritorymap values:-'+CombineCodeAccTerritorymap.values());
                System.debug('CombineCodeAccTerritorymap Keyset:-'+CombineCodeAccTerritorymap.KeySet());
                System.debug('CombineCodeAccTerritorymap Keyset:-'+CombineCodeAccTerritorymap);
                
                //SOQl On Account Terriotry for Updation  Account_Territories
                Map<String,List<Account_Territory__c>> MapOfAccountterritory =New map<String,List<Account_Territory__c>>(); 
                
                for(Account Acc : [Select ID,Is_GLI__c,(Select id,Account__c,AMI_Territory__c,AM_Territory__c,Field_Sales_Territory__c from Account_Territories__r where Account__c IN:accId) from Account where Id IN:accId and Is_GLI__c = true] ){
                    if(acc.Account_Territories__r.size()>0){
                        System.debug('**Debug**'+MapOfAccountterritory.get(acc.ID));
                        if (MapOfAccountterritory.containsKey(acc.ID)) {
                            //MapOfAccountterritory.get(acc.ID).add(acc.Account_Territories__r);
                        }else {
                            MapOfAccountterritory.put(acc.ID,acc.Account_Territories__r);
                        }
                    }
                }
                
                System.debug('MapOfAccountterritory Keyset**'+MapOfAccountterritory.KeySet());
                System.debug('MapOfAccountterritory Values**'+MapOfAccountterritory.values());
                System.debug('MapOfAccountterritory Size**'+MapOfAccountterritory.size());
                //Start Creation and Updation logic for Account Territory
                //saleforcode||'-'||marketsegment||'-'refunctioncode as Terr-Combine-code from TMs Terriotry
                List<Account_Territory__c> CreateUpdateAccTerritorylst= new List<Account_Territory__c>();
                //List<Account> accountlst = [Select ID,Is_GLI__c,(Select id,Account__c,AMI_Territory__c,AM_Territory__c,Field_Sales_Territory__c from Account_Territories__r) from Account where Id IN:accId];
                for(Id acc : accId ){ 
                    if(MapOfAccountterritory.containsKey(acc)){
                    System.debug('ValuesTerracc '+MapOfAccountterritory.get(acc));
                    for(Account_Territory__c AccterrRecord : MapOfAccountterritory.get(acc)){
                        System.debug('AccterrRecord :-'+AccterrRecord );
                        System.debug('MapoftmsTerritory Keyset():-'+MapoftmsTerritory.keyset() );
                        System.debug('MapoftmsTerritory values() :-'+MapoftmsTerritory.values() );
                        System.debug('MapOfAccountTMSterritory:-'+MapOfAccountTMSterritory);
                        Map<String, Object> FieldMapVal =  new Map<String,Object>();
                        //updateAccountTerrwithTMSTerrcode(AccterrRecord, FieldMapVal,MapoftmsTerritory,TMSTerr_Combinecode,CombineCodeAccTerritorymap,AccTerritoryFieldSetting,MapOfAccountTMSterritory);
                        updateAccountTerrwithTMSTerrcombcode(AccterrRecord, MapoftmsTerritory,CombineCodeAccTerritorymap,MapOfAccountTMSterritory);   
                        CreateUpdateAccTerritorylst.add(AccterrRecord);
                        //get the territory values from Below Fields Only
                    }//End For loop
                }//New changes above
                    else if(MapOfAccountTMSterritory.containsKey(acc)){
                        System.debug('MapOfAccountTMSterritory.containsKey(acc.ID):***'+MapOfAccountTMSterritory.containsKey(acc));
                        Account_Territory__c accTerr= new Account_Territory__c();
                        String TMSTerr_Combine_code = '';
                        String AccTerritoryFieldDetails =''; 
                        if(MapOfAccountTMSterritory.size()>0) {
                            System.debug('Get TMS Territory**:-'+MapOfAccountTMSterritory.get(acc));
                            for(TMS_Territory__c TMSTerritory :MapOfAccountTMSterritory.get(acc)){
                                TMSTerr_Combine_code = TMSTerritory.TMS_Sales_Force_Code__c+'-'+TMSTerritory.TMS_Market_Segment_Code__c+'-'+TMSTerritory.TMS_Ref_Function_Code__c;
                                //TMSTerrIdCombineCode.put(TMSTerritory.Id,TMSTerr_Combine_code);
                                if(String.IsNotBlank(TMSTerr_Combine_code)){
                                    if(CombineCodeAccTerritorymap.containsKey(TMSTerr_Combine_code)){
                                        System.debug(''+CombineCodeAccTerritorymap.get(TMSTerr_Combine_code));
                                        AccTerritoryFieldDetails = CombineCodeAccTerritorymap.get(TMSTerr_Combine_code);
                                        String apiFieldResult = Schema.getGlobalDescribe().get('Account_Territory__c').getDescribe().fields.getMap().get(AccTerritoryFieldDetails).getDescribe().getName();
                                        System.debug('apiFieldResult:-'+apiFieldResult);
                                        IF(apiFieldResult == AccTerritoryFieldDetails){
                                            accTerr.put(apiFieldResult,TMSTerritory.id);
                                        } 
                                        accTerr.Account__c= Acc;
                                    }
                                }
                            }//End for loop
                            //accTerr.Account__c= Acc;
                            System.debug('Account Territory_:***'+accTerr);
                            If(String.isnotblank(accTerr.AMI_Territory__c) || String.isnotblank(accTerr.AM_Territory__c) || String.isnotblank(accTerr.Field_Sales_Territory__c)){
                                CreateUpdateAccTerritorylst.add(accTerr);
                            }
                            System.debug('Inside For Loop Account:***'+CreateUpdateAccTerritorylst);                    
                        }//End Size checking
                    }//End IF for new Accountterritory 
                }//End For Loop-Account
                System.debug('OutSide For Loop Account:***'+CreateUpdateAccTerritorylst);
                
                   if(CreateUpdateAccTerritorylst.size()>0){
                    //upsert CreateUpdateAccTerritorylst;
                    Database.UpsertResult[] results = Database.upsert(CreateUpdateAccTerritorylst, false);
                    trackDatabaseStaus(results);    
                    System.debug('***CreateUpdateAccTerritorylst Upsert***:-'+CreateUpdateAccTerritorylst);
                }
                //End Updation with Creation Locgic
                //Delete Logic
                //DateTime rightNow =  DateTime.now();
                //DateTime d12hAgo = rightNow.addHours(-12);
                //List<Account_Territory__c> deleted_AccTerritory =[select id,name ,Account__c,LastModifiedDate from Account_Territory__c where  Account__c IN: accId and (LastModifiedDate < :d12hAgo OR LastModifiedDate != Today)];
                /*
                List<Account_Territory__c> deleted_AccTerritory = [select id,name ,Account__c,AMI_Territory__c,AM_Territory__c,LastModifiedDate,Field_Sales_Territory__c from Account_Territory__c where  Account__c IN: AccId and (AMI_Territory__c= null and AM_Territory__c = null and Field_Sales_Territory__c = null)];
                System.debug('deleted_AccTerritory:--'+deleted_AccTerritory);
                IF(!deleted_AccTerritory.isempty()){
                    Delete deleted_AccTerritory;
                }
                
                //Account Update with Account Territory ID
                updateAccountwithAccTerritory(AccId);
                
            }//End of the size checking for AccountID
        }Catch(Exception Excep){
            System.debug('Excep***'+Excep);
            List<LCRM_Exception_Log__c> excepList = new List<LCRM_Exception_Log__c>();
            String strException = Excep.getMessage();
            String strStackTrace = Excep.getStackTraceString();
            createExceptionLog(excepList,strException,strStackTrace);
        }
    }//End Method
    
    
*@Method:- getFields
* @purpose: This method is used to read the FieldSet of Account Territory

    public Static List<Schema.FieldSetMember> getFields() {
        System.debug('****getFields called***');
        List<Schema.FieldSetMember> fieldSetFields = SObjectType.Account_Territory__c.FieldSets.Request_Account_Territory_Updater.getFields();
        System.debug('fieldSetFields :-'+fieldSetFields );
        List<Schema.FieldSetMember> fieldsWithReference = new List<Schema.FieldSetMember>();
        for(Schema.FieldSetMember field:fieldSetFields){
            fieldsWithReference.add(field);
        }
        System.debug('fieldsWithReference***'+fieldsWithReference);
        return fieldsWithReference;
    }//End Method
    
    
*@Method:- TrackDatabaseStaus
* @purpose: Represents information about an error that occurred during a DML operation
 
    public static void trackDatabaseStaus(List<Database.UpsertResult> results){
        List<Id> SuccessTMSTerritorieslst = new List<Id>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        // Iterate through each returned result
        for (Database.UpsertResult sr : results) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Account Territories ID: ' + sr.getId());
                system.debug('+++ Is Account Territories is TRUE');
                SuccessTMSTerritorieslst.add(sr.getId());
                system.debug('+++ SuccessfullyTMSTerritories '+ SuccessTMSTerritorieslst );
            }else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account Territories fields that affected this error: ' + err.getFields());
                    LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                    excepObj.LCRM_Exception_Message__c = err.getMessage();
                    excepObj.LCRM_Exception_Trace__c = 'Display_AccTerritory_Batch class'+String.valueof(err.getFields());
                    excepObj.LCRM_Exception_Type__c = 'Error found in Account Territories Creation/Updation';
                    excepObj.LCRM_User_ID__c = userinfo.getUserId();
                    exceptionList.add(excepObj);                
                }//end for loop
            }
        }
        if(!exceptionList.isempty()){
            insert exceptionList;
        }
        
    }//End Method
    
    
    
*@Method:- TrackDatabaseStaus
* @purpose: Represents information about an error that occurred during a DML operation for updating Account
  
    public static void trackDatabaseStausforAccount(List<Database.SaveResult> results){
        List<Id> SuccessTMSTerritorieslst = new List<Id>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        // Iterate through each returned result
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated Account with Account territories: ' + sr.getId());
                system.debug('+++ Is Account Territories is TRUE');
                SuccessTMSTerritorieslst.add(sr.getId());
                system.debug('+++ SuccessfullyTMSTerritories '+ SuccessTMSTerritorieslst );
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Updating the Account with account Territories Id that affected this error: ' + err.getFields());
                    LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                    excepObj.LCRM_Exception_Message__c = err.getMessage();
                    excepObj.LCRM_Exception_Trace__c = 'Display_AccTerritory_Batch class'+String.valueof(err.getFields());
                    excepObj.LCRM_Exception_Type__c = 'Error found in Account Updation';
                    excepObj.LCRM_User_ID__c = userinfo.getUserId();
                    exceptionList.add(excepObj);                
                }//
                
            }
        }//End For loop
        if(!exceptionList.isempty()){
            insert exceptionList;
        }
    }//End Method
    
    
    
*@Method:- updateAccountwithAccTerritory
* @purpose: update the Account with Account Territory Id and Its used for Training Event
 
    public static void updateAccountwithAccTerritory(Set<ID> accountId){
        //get the Id from selected account  
        List<Account> updatesAcc = new List<Account>();
        if(!accountId.isempty()){
            for(Account acc: [Select id,Account_Territory__c,Is_GLI__c,(Select id,Account__c,AMI_Territory__c,AM_Territory__c,Field_Sales_Territory__c from Account_Territories__r where Account__c IN:accountId and (AMI_Territory__c!= null or AM_Territory__c != null or Field_Sales_Territory__c != null )) from Account where Id IN: accountId and Is_GLI__c = true]){
                IF(acc.Account_Territories__r.size()>0){
                    System.debug('acc.Account_Territory__c:-'+acc.Account_Territory__c);
                    System.debug('Account_Territory__c ID:-'+acc.Account_Territories__r[0].Id);
                    If(acc.Account_Territory__c != acc.Account_Territories__r[0].Id || String.Isblank(acc.Account_Territory__c)){
                        System.debug('acc.Account_Territories__r[0].Id:-'+acc.Account_Territories__r[0].Id);
                        acc.Account_Territory__c =(acc.Account_Territories__r[0].Id);
                        updatesAcc.add(acc);
                    }
                }   
            }   
            System.debug('updatesAcc:-'+updatesAcc);
        }//end of account id size checking*
        //Check size of the list
        if(!updatesAcc.isempty()){
            List<Database.SaveResult> results = Database.update(updatesAcc, false);
            System.debug('results:-'+results);
            trackDatabaseStausforAccount(results);
        }
    }//end method
    
*Exception Log

    public static void createExceptionLog( List<LCRM_Exception_Log__c> excepList,String Excep,String strStackTrace ){
        System.debug('**createExceptionLog**');
        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c = Excep;
        excepObj.LCRM_Exception_Trace__c = 'Display_AccTerritory_Batch class'+(strStackTrace);
        excepObj.LCRM_Exception_Type__c = 'Error found in Account Territories Creation/Updation';                
        excepObj.LCRM_User_ID__c = userinfo.getUserId();
        excepList.add(excepObj);
        if(!excepList.isempty()){
            insert excepList;
        }
    }
    
    
*@purpose:If any changes occure in salesforce code,Rep function code and marketsegment code from TMS Territory 
*then update Account Territory 
 
    public static void updateAccountTerrwithTMSTerrcombcode(Account_Territory__c acc,  Map<String,TMS_Territory__c> MapoftmsTerritory,Map<String, String> CombineCodeAccTerritorymap,Map<String,List<TMS_Territory__c>> MapOfAccountTMSterritory){
        System.debug('****updateAccountTerrwithTMSTerrcombcode***'+acc);  
        for(Schema.FieldSetMember f : getFields()){
            String AccTerrFieldVal=String.valueOf(acc.get(f.getFieldPath()));
            System.debug('AccTerrFieldVal:-'+AccTerrFieldVal);
            if(String.Isnotblank(AccTerrFieldVal)){
                System.debug('MapoftmsTerritory.get(AccTerrFieldVal):-'+MapoftmsTerritory.get(AccTerrFieldVal));
                if(MapoftmsTerritory.get(AccTerrFieldVal) !=null){
                    if(MapOfAccountTMSterritory.containsKey(acc.Account__c)){
                        System.debug('MapOfAccountTMSterritory.containsKey(acc.ID):***'+MapOfAccountTMSterritory.containsKey(acc.Account__c));
                        String TMSTerr_Combine_code = '';
                        String AccTerritoryFieldDetails =''; 
                        if(MapOfAccountTMSterritory.size()>0) {
                            System.debug('Get TMS Territory**:-'+MapOfAccountTMSterritory.get(acc.Account__c));
                            for(TMS_Territory__c TMSTerritory :MapOfAccountTMSterritory.get(acc.Account__c)){
                                TMSTerr_Combine_code = TMSTerritory.TMS_Sales_Force_Code__c+'-'+TMSTerritory.TMS_Market_Segment_Code__c+'-'+TMSTerritory.TMS_Ref_Function_Code__c;
                                System.debug('TMSTerr_Combine_code:-'+TMSTerr_Combine_code);
                                //TMSTerrIdCombineCode.put(TMSTerritory.Id,TMSTerr_Combine_code);
                                if(String.IsNotBlank(TMSTerr_Combine_code)){
                                    if(CombineCodeAccTerritorymap.containsKey(TMSTerr_Combine_code)){
                                        System.debug(''+CombineCodeAccTerritorymap.get(TMSTerr_Combine_code));
                                        AccTerritoryFieldDetails = CombineCodeAccTerritorymap.get(TMSTerr_Combine_code);
                                        System.debug('AccTerritoryFieldDetails :-'+AccTerritoryFieldDetails );
                                        System.debug('f.getFieldPath():-'+f.getFieldPath());
                                        if(f.getFieldPath() == AccTerritoryFieldDetails){
                                            //System.debug('This are Equal: '+Territory.id);
                                            acc.put(f.getFieldPath(),TMSTerritory.id);
                                        } 
                                    }
                                }
                            } //for loop for tms_territory                  
                        }//End Size checking
                        System.debug('acc:-'+acc);
                    }//End IF for new Accountterritory 
                }
            }else{
                if(MapOfAccountTMSterritory.containsKey(acc.Account__c)){
                    System.debug('MapOfAccountTMSterritory.containsKey(acc.ID):***'+MapOfAccountTMSterritory.containsKey(acc.Account__c));
                    //Account_Territory__c accTerr = new Account_Territory__c(ID = acc.ID);
                    // System.debug('accTerr:-'+accTerr);
                    String TMSTerr_Combine_code = '';
                    String AccTerritoryFieldDetails =''; 
                    if(MapOfAccountTMSterritory.size()>0) {
                        System.debug('Get TMS Territory**:-'+MapOfAccountTMSterritory.get(acc.Account__c));
                        for(TMS_Territory__c TMSTerritory :MapOfAccountTMSterritory.get(acc.Account__c)){
                            TMSTerr_Combine_code = TMSTerritory.TMS_Sales_Force_Code__c+'-'+TMSTerritory.TMS_Market_Segment_Code__c+'-'+TMSTerritory.TMS_Ref_Function_Code__c;
                            System.debug('TMSTerr_Combine_code:-'+TMSTerr_Combine_code);
                            //TMSTerrIdCombineCode.put(TMSTerritory.Id,TMSTerr_Combine_code);
                            if(String.IsNotBlank(TMSTerr_Combine_code)){
                                if(CombineCodeAccTerritorymap.containsKey(TMSTerr_Combine_code)){
                                    System.debug(''+CombineCodeAccTerritorymap.get(TMSTerr_Combine_code));
                                    AccTerritoryFieldDetails = CombineCodeAccTerritorymap.get(TMSTerr_Combine_code);
                                    System.debug('AccTerritoryFieldDetails :-'+AccTerritoryFieldDetails );
                                    System.debug('f.getFieldPath():-'+f.getFieldPath());
                                    if(f.getFieldPath() == AccTerritoryFieldDetails){
                                        //System.debug('This are Equal: '+Territory.id);
                                        acc.put(f.getFieldPath(),TMSTerritory.id);
                                    } 
                                }
                            }
                        } //End for loop                  
                    }//End Size checking
                    System.debug('acc:-'+acc);
                }//End IF for new Accountterritory 
            }  //If the values are blank in Account Territory fields(AMI,AM and field sales)      
        }//End for loop for fieldset
    }//End Method
    
    
  */  
}//End class