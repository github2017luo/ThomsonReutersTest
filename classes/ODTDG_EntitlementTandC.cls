/*
Author : Mallikarjuna Rao
Date: June 2021
Description: This  class is for mainly to create Entitlement for T&C page, this will be call from Trial initiated from salesforce ECJ and ECJ from invited users 
Returns: JSON object data class ODTDG_EntitlementTandC
Sample Request:ODTDG_TrialRecord
@description ODTDG_EntitlementTandC class to call entitlement for TC page 
*/
/**
 * CHANGE HISTORY
 * ========================================================================================================================
 * Date         Name             Description
 * 2021-07-22   Ameeta A         DCP-2343:[SFDC] (Sales Rep Journey) - Update entitlement status after T&C is accepted by the customer 
 
 * ========================================================================================================================
 */

/********************************************************************************************************
* @param container : parameter to accept trial record details 
*  @description ODTDG_EntitlementTandC : class to call entitlement for primary INC and T&C page 
*********************************************************************************************************/
public with sharing class ODTDG_EntitlementTandC {
    
    private static string trialId;
    private static List<string> emailIds;
    private static List<id> sfContactIdList;
    private static List<id> sfProductIdList;
   // private static List<string> productCodes;
    private static List<Trial_Contact__c> trialContacts;
    private static List<Trial_Product__c> trialProducts;
    
    /********************************************************************************************************
* @param container : parameter to accept trial record details 
* @return ODTDG_EntitlementWrapper : retrn the success or failure message 
*  @description initiatedEntitlement : class to call entitlement for primary INC and T&C page 
*********************************************************************************************************/
    public static ODTDG_EntitlementWrapper initiatedEntitlement(ODTDG_TrialRecord container) {
        
        System.debug(LoggingLevel.INFO,'ODTDG_EntitlementTandC.initiatedEntitlement...............'+container);
        ODTDG_EntitlementWrapper td = new ODTDG_EntitlementWrapper();
        td.status = new ODTDG_EntitlementWrapper.StatusResp();
        td.sfdcDetails = new ODTDG_EntitlementWrapper.RespDetails();
        
        ODTDG_TrialRecord.OdtdgTrialDetails trialData = container.odtdgTrialDetails;
        ODTDG_TrialRecord_TrialHelper.TrialInfo trIn = trialData.trialInfo;
        //List<ODTDG_TrialRecord.TrialProdInfo> trPrIn = trialData.trialProdInfo;
        // List<ODTDG_TrialRecord.LeadTrial> leTr = trialData.leadTrialInfo;
        // ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAcc = trialData.trialAccountInfo;
        List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trCon = trialData.trialContacts;
        trialContacts = new List<Trial_Contact__c>();
        sfContactIdList = new list<id>();
        sfProductIdList = new list<id>();
        
        trialId = '';
        emailIds = new List<string>();
      //  productCodes = new List<string>();
        
        if(trIn.trialSfId != null){
            trialId = trIn.trialSfId;
        }
        
        if(!trCon.isEmpty()){
            // emailIds
            for(ODTDG_TrialRecord_ContactHelper.TrialContacts con: trCon){
                emailIds.add(con.email);
                if(con.trialContactSfId != null){
                    trialContacts.add(updateTrialContact(con));
                    sfContactIdList.add(con.trialContactSfId);
                }
            }
        }
        
    td = validateEndDate(sfContactIdList);
    if(!td.errors.isEmpty()){ 
        return td;
    } 
        
        trialProducts = ODTDG_EntitleTrialCustomerRecordsService.getTrialProducts(trialId, new List<String>());
            
         
        for(Trial_Product__c tp: trialProducts){
            sfProductIdList.add(tp.id);
        }
      /*  
        if(!trPrIn.isEmpty()){
            // emailIds
            for(ODTDG_TrialRecord.TrialProdInfo p: trPrIn){
                sfProductIdList.add(p.productSfId);
                productCodes.add(p.trialProductNumber);
            }
        }
        */
        
         System.debug(LoggingLevel.INFO,'sfContactIdList...............'+sfContactIdList);
         System.debug(LoggingLevel.INFO,'sfProductIdList...............'+sfProductIdList);
        
        List<Database.UpsertResult> trialContRes = Database.upsert(trialContacts, false);
         for(Database.UpsertResult tp: trialContRes){
             if(!tp.isSuccess()){
                  ODTDG_EntitleTrialCustomerService.isAnyErrorOnProcess = TRUE;
             }
         }
        
        td = callEntitlements();
    
        return td;
        
    }
    
    
    private static ODTDG_EntitlementWrapper callEntitlements(){
        ODTDG_EntitlementWrapper td = new ODTDG_EntitlementWrapper();
        System.debug(LoggingLevel.INFO,'trialId...............'+trialId);
        System.debug(LoggingLevel.INFO,'emailIds...............'+emailIds);
      //  System.debug(LoggingLevel.INFO,'productCodes...............'+productCodes);
        
        if(trialId != null && !sfContactIdList.isEmpty() && !sfProductIdList.isEmpty()){
            
            ODTDG_CallEntitlementFromQueueable cEntitlement = new ODTDG_CallEntitlementFromQueueable(trialId, sfContactIdList, sfProductIdList);
            id jobId = System.enqueueJob(cEntitlement); 
            
            System.debug(LoggingLevel.INFO,'isSuccess...............'+jobId);
            if(jobId != null){
                ODTDG_EntitleTrialCustomerService.trialSfId=trialId;
                td = ODTDG_EntitleTrialCustomerRecordsService.getSuccessMsg(td, trialContacts, trialProducts);
            }else{
                td = ODTDG_EntitleTrialCustomerRecordsService.getFailureMsg(td);
            }
            td.sfdcDetails.entitleJobId = jobId;
            
            return td;
        }else{
            td = ODTDG_EntitleTrialCustomerRecordsService.getFailureMsg(td);
            return td;
        }
        
    }
    
    /***********************************************************************************    *********************
*  @description callToEloqua : Method to create product and contact junction objects 
* @param trialId , Salesforce trial id 
* @param contactsIds , all contacts to process 
* @param productIds , all products to process 
*********************************************************************************************************/ 
    public static void callToEloqua(id trialId, LIST<Trial_Contact__c> contactsIds, list<Trial_Product__c> productIds){
        boolean isSuccess = false;
        
        if(!contactsIds.isEmpty() && !productIds.isEmpty()){
            //    isSuccess =  OmniCalltoEloqua.getOmniTrialsEloquaCalls(trialId, getIdsFromsObject(contactsIds), getIdsFromsObject(productIds));
            
            ODTDG_CallEloquaFromQueueable callEloqua = new ODTDG_CallEloquaFromQueueable(trialId, getIdsFromsObject(contactsIds), getIdsFromsObject(productIds));
            id jobId = System.enqueueJob(callEloqua); 
            System.debug(LoggingLevel.INFO,'JobID... '+jobId);
            if(jobId != null){
                isSuccess = true;
            }
        }
        
        if(!isSuccess || Test.isRunningtest()){
            String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
            
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Digital Trial','expMsg'=>'Eloqua Call has Failed For Trial Contacts','webServiceName'=>'Eloqua Call','requestType'=>'Trial Contacts Invitation','reqMsg'=>'ODTDG_EntitleTrialCustomerRecordsService','module'=>'Trials','recId'=>trialId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
        }
        
        
    }
    
    
    /***********************************************************************************    *********************
*  @description getIdsFromsObject : Method to get all Ids from sobjects  
* @param records , getting sfdc object list and
* @return  List<id> , return list of Ids 
*********************************************************************************************************/
    public static List<id> getIdsFromsObject(list<sObject> records){
        
        list<id> recordIds = new List<id>();
        
        for(sObject s: records){
            recordIds.add(s.id);
        }
        
        return recordIds;
        
    }
    
    /********************************************************************************************************
*  @description updateTrialContact : Method to update trial contacts  
* @param tCon , list of trial contacts from request
* @return  Trial_Contact__c , return Trial_Contact__c record
*********************************************************************************************************/
   public static Trial_Contact__c updateTrialContact(ODTDG_TrialRecord_ContactHelper.TrialContacts tCon){
       Trial_Contact__c tc = new Trial_Contact__c();
       tc.id = tCon.trialContactSfId;
       tc.One_Pass_ID__c = tCon.userAuthId;
       tc.Status__c = (ODTDG_Helper.getStaticValues('ODTDG_AcceptStatus') != null)?ODTDG_Helper.getStaticValues('ODTDG_AcceptStatus'):'Accepted';
       tc.Start_Date__c = System.today();
       tc.Accept_Terms_Date__c = tCon.trialAcceptanceDateTime;
       if(Schema.sObjectType.Trial_Contact__c.isQueryable()){
           Trial_Contact__c contacts = [SELECT Id, Email__c, One_Pass_ID__c, Primary__c, Unique_Name__c
                                                FROM Trial_Contact__c 
                                                WHERE id= :tCon.trialContactSfId];
            tc.Email__c = contacts.Email__c;
       }
       //tc.Email__c = tCon.email;
       //tc.Primary__c = tCon.primaryUser;
       //tc.Unique_Name__c = tCon.trialContactUniqueName;
       
       if(String.isNotBlank(tCon.cobaltGUID)){
        tc.COBALT_GUID__c = tCon.cobaltGUID;
       }
       if(String.isNotBlank(tCon.dataroomGUID)){
        tc.DATAROOM_GUID__c = tCon.dataroomGUID;
       }
       if(String.isNotBlank(tCon.contactNumber)){
        tc.External_Contact_Number__c = tCon.contactNumber;
       }
       if(String.isNotBlank(tCon.contactNumSource)){
        tc.External_Contact_Number_Source__c = tCon.contactNumSource;
       }
       
       return tc;
   } 
    
private static ODTDG_EntitlementWrapper entitleError(ODTDG_EntitlementWrapper td,String profile){
    string errNameBL;
    string fCode = '205';
    string fmsg = 'Failure';
    td.status.respCode = fCode; //'205';
    td.status.respMsg  = fmsg; //'Failure';
    if(profile==ODTDG_Helper.getStaticValues('ODTDG_NEW_CUSTOMER')){
        errNameBL = 'NC_EXP';
    }
    else{
        errNameBL = 'EC_EXP';
    }
    ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
    er = ODTDG_ErrorCodeDataService.parseErrorMessage(errNameBL);
    td.errors.add(er);
    return td;
}

/********************************************************************************************************
*  @description validateEndDate: Method to check if product offering and other request fields are valid
*  @param trialConIds : this will pass the customer input data
*  @return ODTDG_EntitlementWrapper : error response for service
*********************************************************************************************************/ 
    public static ODTDG_EntitlementWrapper validateEndDate(LIST<id> trialConIds){
        
        ODTDG_EntitlementWrapper td = new ODTDG_EntitlementWrapper();
        td.status = new ODTDG_EntitlementWrapper.StatusResp();
        td.sfdcDetails = new ODTDG_EntitlementWrapper.RespDetails();
        
        date trialEndDate=date.today();
        string conStatus;
        string profileType;
        string tandCAccStatus = ODTDG_Helper.getStaticValues('ODTDG_TandCAccStatus'); 
        if(Schema.sObjectType.Trial_Contact__c.isQueryable()){
            for(Trial_Contact__c tcon : [SELECT Id, Trials__r.Trial_End_Date__c, Trials__r.Trial_Status__c, status__c,Profile_Type__c FROM Trial_Contact__c WHERE ID IN: trialConIds]){
                trialEndDate= tcon.Trials__r.Trial_End_Date__c;
                conStatus = tcon.status__c;
                profileType = tcon.Profile_Type__c;
            }
          
        }
        if((date.today() > trialEndDate && trialEndDate!=null) ){
            td=entitleError(td,profileType);
        }
        if(!tandCAccStatus.contains(conStatus)){
            string fCode = '205';
            string fmsg = 'Failure';
            td.status.respCode = fCode; //'205';
            td.status.respMsg  = fmsg; //'Failure';
            string errNameBL = ODTDG_Helper.getStaticValues('ODTDG_TandCEntInvalidStatus');
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errNameBL);
            td.errors.add(er);
        }

        return td;
        
    }
   
}