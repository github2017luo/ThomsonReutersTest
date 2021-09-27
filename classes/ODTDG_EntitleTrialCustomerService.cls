/*
Author : Mallikarjuna Rao
Date: May 2021
Description: This  class is for mainly to create trial and related records for primary user and trial contact and junction records for INC. 
Returns: JSON object data class ODTDG_EntitlementWrapper
Sample Request:ODTDG_TrialRecord
@description ODTDG_EntitleTrialCustomerService class to call entitlement for primary INC and T&C page 
*/
/**
 * CHANGE HISTORY
 * ========================================================================================================================
 * Date         Name             Description
 * 2021-07-08   Ameeta A         DCP-2675:[SFDC] Product offerings field changes on Validation and Trial initiation services 
 
 * ========================================================================================================================
 */
 
/********************************************************************************************************
 * @return ODTDG_EntitlementWrapper  return statement 
*  @description ODTDG_EntitleTrialCustomerService : class to call entitlement for primary INC and T&C page 
*********************************************************************************************************/
public with sharing class  ODTDG_EntitleTrialCustomerService {
   
    private static string primaryUserEmail;
    private static string primaryUserid;
    public static string trialSfId;
    public  static string leadId;
    private static string trialMode;
    public static Boolean isAnyErrorOnProcess;
    public static Boolean entitleProcessed;
    public static Boolean entitleInvitedProcessed;    

    public static LIST<string> emailIds= new LIST<string>();
    public static LIST<string> productCodes = new LIST<string>();
    
    public static string customerCountry; 
    public static string customerState; 
    public static string profileType;
    public static string emailBusiness;

/********************************************************************************************************
*  @description processTrialEntitlements: This is the main method to entitle for all types of users ex, primary user, INC and T&C
* @return ODTDG_EntitlementWrapper as a service response we will share the Success messsaage along with trial ID
* @param container it is expected incoming request as ODTDG_TrialRecord 
*********************************************************************************************************/ 

    public static ODTDG_EntitlementWrapper processTrialEntitlements(ODTDG_TrialRecord container){
        ODTDG_TrialRecord.OdtdgTrialDetails trialData = container.odtdgTrialDetails;
        ODTDG_TrialRecord_TrialHelper.TrialInfo trIn = trialData.trialInfo;
        System.debug(LoggingLevel.INFO,'trial Status...............'+trIn.trialStatus);
        ODTDG_EntitlementWrapper td = new ODTDG_EntitlementWrapper();

        string draftStatus = 'Draft';
        string inviteStatus = 'Invite';
        string entitleStatus = 'Entitle';
        
        if(ODTDG_Helper.getStaticValues('ODTDG_DraftStatus') != null){
            draftStatus = ODTDG_Helper.getStaticValues('ODTDG_DraftStatus');
        }
       if(ODTDG_Helper.getStaticValues('ODTDG_InviteStatus') != null){
           inviteStatus = ODTDG_Helper.getStaticValues('ODTDG_InviteStatus');
       }
        if(ODTDG_Helper.getStaticValues('ODTDG_EntitleStatus') != null){
            entitleStatus= ODTDG_Helper.getStaticValues('ODTDG_EntitleStatus');
        }
        


        if(trIn.trialStatus == draftStatus){
            td = ODTDG_EntitlementRequestValidation.validateRequestFields(container,td);
            if(td.errors.isEmpty()){
                td = createprimaryUserTrials(container);
            }

        }else if(trIn.trialStatus == inviteStatus){
            td = ODTDG_EntitlementRequestValidation.validateRequestFieldsTwo(container,td);
            if(td.errors.isEmpty()){
                td = createInvitedUserTrials(container);
            }
        }else if(trIn.trialStatus == entitleStatus){
           td = processTandCEntitlement(container);
        }
        
        return td;
    }

    private static ODTDG_EntitlementWrapper processTandCEntitlement(ODTDG_TrialRecord container){
        
        ODTDG_EntitlementWrapper td = ODTDG_EntitlementTandC.initiatedEntitlement(container);
        
        return td;
    }

    private static ODTDG_EntitlementWrapper createInvitedUserTrials(ODTDG_TrialRecord container){
        
       ODTDG_TrialRecord.OdtdgTrialDetails trialData = container.odtdgTrialDetails;
       ODTDG_TrialRecord_TrialHelper.TrialInfo trIn = trialData.trialInfo;
        profileType=trIn.trialProfileType;
       ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAcc = trialData.trialAccountInfo;
       //List<ODTDG_TrialRecord.TrialProdInfo> trPrIn = trialData.trialProdInfo;
      
       List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trCon = trialData.trialContacts;
   
            isAnyErrorOnProcess = FALSE;
           // getTrialId(trIn);
            //string pEmail = ODTDG_EntitleTrialCustomerRecordsService.getPrimaryContactEmail(trCon);
            //set<string> productsCat = ODTDG_EntitleTrialCustomerRecordsService.getProductCategories(trPrIn);
            //queryTrialforINC(productsCat, pEmail);
             //System.debug(LoggingLevel.INFO,'productsCat...............'+productsCat);
             //System.debug(LoggingLevel.INFO,'pEmail...............'+pEmail);
            String onePassId =  ODTDG_Helper.getPrimaryContactOnepass(trCon);
            
            Trial_Contact__c tc = ODTDG_Helper.getTrialContact(onePassId);
            leadId = tc.Lead__c;
            trialSfId = tc.Trials__c;
            ODTDG_EntitleTrialCustomerRecordsService.trialInvitationContact = new Trial_Contact__c();
            ODTDG_EntitleTrialCustomerRecordsService.trialInvitationContact = tc;
            
            
            List<Trial_Contact__c> trialContact = createTrialContact(trCon, null, trAcc);
            //List<Trial_Product__c> trialProducts = ODTDG_EntitleTrialCustomerRecordsService.getExistingTrialProducts(trPrIn);
            List<Trial_Product__c> trialProducts = ODTDG_EntitleTrialCustomerRecordsService.getTrialProducts(tc.Trials__c, new List<String>());
            
            System.debug(LoggingLevel.INFO,'trialContact...............'+trialContact);
            System.debug(LoggingLevel.INFO,'trialProducts ...............'+trialProducts );
            
            LIST<Trial_Product_Contact__c> trialProductContactJun = ODTDG_EntitleTrialCustomerRecordsService.createContactProduct(trialContact, trialProducts, trialSfId);
            System.debug(LoggingLevel.INFO,'trialProductContactJun...............'+trialProductContactJun);
            System.debug(LoggingLevel.INFO,'isAnyErrorOnProcess...............'+isAnyErrorOnProcess);
              
           ODTDG_EntitlementWrapper td = new ODTDG_EntitlementWrapper();
           
            if(!isAnyErrorOnProcess){  
                 ODTDG_EntitlementTandC.callToEloqua(trialSfId, trialContact, trialProducts);
                 //entitlement process is not required for INC currently 
                td = ODTDG_EntitleTrialCustomerRecordsService.getSuccessMsg(td,trialContact,trialProducts);
            }else{
                td = ODTDG_EntitleTrialCustomerRecordsService.getFailureMsg(td);
            }        
                return td; 
    }
    
    private static ODTDG_EntitlementWrapper createprimaryUserTrials(ODTDG_TrialRecord container){

        ODTDG_TrialRecord.OdtdgTrialDetails trialData = container.odtdgTrialDetails;
        ODTDG_TrialRecord_TrialHelper.TrialInfo trIn = trialData.trialInfo;
        profileType=trIn.trialProfileType;
        ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAcc = trialData.trialAccountInfo;
        List<ODTDG_TrialRecord.TrialProdInfo> trPrIn = trialData.trialProdInfo;
       // List<ODTDG_TrialRecord.LeadTrial> leTr = trialData.leadTrialInfo;
        List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trCon = trialData.trialContacts;
        emailBusiness=trCon[0].email;
    
        System.debug(LoggingLevel.INFO,'trIn.trialStatus...............'+trIn.trialStatus);
        isAnyErrorOnProcess = FALSE;
 
          
             Ent_Trial__c trialRec = createTrial(trIn, trAcc);
             System.debug(LoggingLevel.INFO,'trialRec...............'+trialRec.id);
 
 
             if(trialRec.id != null){
                 List<Trial_Contact__c> trialContact = createTrialContact(trCon, trialRec, trAcc);
                 System.debug(LoggingLevel.INFO,'trialContact...............'+trialContact);
 
                 List<Trial_Product__c> trialProduct = createTrialProduct(trPrIn, trialRec, trAcc.customerSegment);
                 System.debug(LoggingLevel.INFO,'trialProduct...............'+trialProduct);
 
                 LIST<Trial_Product_Contact__c> trialProductContactJun = ODTDG_EntitleTrialCustomerRecordsService.createContactProduct(trialContact, trialProduct, trialSfId);
                 System.debug(LoggingLevel.INFO,'trialProductContactJun...............'+trialProductContactJun);
 
                // List<Lead_Trial__c> leadTrailrecord; //= createLeadTrial(leTr, trialRec);
                // System.debug(LoggingLevel.INFO,'leadTrailrecord...............'+leadTrailrecord);
 
                 ODTDG_EntitlementWrapper td = new ODTDG_EntitlementWrapper();
                 if(!isAnyErrorOnProcess){
                     //call entitlement OMNI class
                     
                        list<id> contactIdsList = ODTDG_EntitlementTandC.getIdsFromsObject(trialContact);
                        list<id> productIdsList = ODTDG_EntitlementTandC.getIdsFromsObject(trialProduct);    

                        ODTDG_CallEntitlementFromQueueable cEntitlement = new ODTDG_CallEntitlementFromQueueable(trialRec.id, contactIdsList, productIdsList);
                        id jobId = System.enqueueJob(cEntitlement);  

                    System.debug(LoggingLevel.INFO,'isSuccess...............'+jobId);
                     td = ODTDG_EntitleTrialCustomerRecordsService.getSuccessMsg(td,trialContact,ODTDG_EntitleTrialCustomerRecordsService.getTrialProducts(trialRec.id, new List<String>()));
                     td.sfdcDetails.entitleJobId = jobId;
                 }else{
                     td = ODTDG_EntitleTrialCustomerRecordsService.getFailureMsg(td);
                 }
         
                 return td; 
 
 
             }else{
                 //Logiv to write Error message 
                 return null;
             }
         // return null;
  }

     
    @testVisible
    /*private static void getTrialId(ODTDG_TrialRecord_TrialHelper.TrialInfo trIn){
         
        if(trIn.trialSfId != null ) {
            trialSfId = trIn.trialSfId;
            fetchExisstingTrialDetails();
       }
    }*/

   private static Ent_Trial__c createTrial(ODTDG_TrialRecord_TrialHelper.TrialInfo trIn, ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAcc){
        
       Ent_Trial__c trial = new Ent_Trial__c();
        
       trial.Trial_Status__c = trIn.trialStatus;
       trial.Campaign_Code__c = trIn.campaignCode;
       trial.Profile_Type__c = ODTDG_Helper.getStaticValues(trIn.trialProfileType); 
       trial.External_Account_Number__c = trAcc.accountNumber;        
       trial.External_Account_Number_Source__c = trAcc.accountNumSource; 
       trial.Trial_Source__c = ODTDG_Helper.getStaticValues('ODTDG_digitalTrialSource'); 
       trial.Zip_Postal_Code__c = trAcc.zipCode;
       trial.Organization_Type__c = trAcc.customerSegment;
        trial.Market_Segment__c = trAcc.customerSegmentValue;
       trial.Industry_code__c = ODTDG_EntitleTrialCustomerServiceHelper.getIndustryCode(trAcc.customerSegmentValue);
       //Calling getAccountName method to retrieve existign acct name else populate name from request

       
       switch on trAcc.accountNumber{
           when null, ''{
               trial.Account_Name__c = trAcc.accountName;
               
           }
           when else{
               Map<String, String> accMap = ODTDG_EntitleTrialCustomerServiceHelper.getAccountName(trAcc.accountNumber, emailBusiness);
               trial.Account_Name__c = accMap.get('AccountName');
               trial.Account__c = accMap.get('AccountId');
           }
       }
       
       if(trIn.trialSfId != null &&  trIn.trialSfId != '' ) {
            trial.id = trIn.trialSfId;
            trialSfId = trIn.trialSfId;
            fetchExisstingTrialDetails();
       }
       if(trIn.apiCallPath != null && trIn.apiCallPath != '' ){
            trial.Trial_Source__c = ODTDG_Helper.getStaticValues(trIn.apiCallPath);
       }
       if(trIn.trialStartDate != null &&  trIn.trialStartDate != '' && trIn.trialDuration != null ){
            trial.Trial_Start_Date__c = Date.parse(trIn.trialStartDate);
            trial.Trial_End_Date__c = trial.Trial_Start_Date__c.addDays(trIn.trialDuration);
            trial.Number_of_Days__c = trIn.trialDuration;
       }
       

      database.upsertResult trialRes = Database.Upsert(trial, false); 
       if(!trialRes.isSuccess()){
            isAnyErrorOnProcess = TRUE;
       }else{ 
            trialSfId = trial.id; 
       }
      /*
          //Sprint15 
          if(trAcc.countryCode != null){
              customerState = trAcc.countryCode;
          }
          */
      
       return trial;
    }
   
    private static List<Trial_Contact__c> createTrialContact(List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trCon, Ent_Trial__c trialRec, ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAcc){
       
       List<Trial_Contact__c> allTrialContacts = new List<Trial_Contact__c>();
        string conDraftStatus = 'Draft';
        if(ODTDG_Helper.getStaticValues('ODTDG_ContactNewStatus') != null ){
            conDraftStatus = ODTDG_Helper.getStaticValues('ODTDG_ContactNewStatus');
        }

        if(trAcc.countryCode != null){
              customerCountry = trAcc.countryCode;
          }
          if(trAcc.state != null){
              customerState = trAcc.state;
          }

       // if(trialRec.Id!=null){
            for(ODTDG_TrialRecord_ContactHelper.TrialContacts tpcn : trCon){
                if(tpcn.trialStatus ==  conDraftStatus){
                    Trial_Contact__c  ctcon = ODTDG_EntitleTrialCustomerRecordsService.createNewTrialContact(tpcn, profileType, trAcc);
                    
                    allTrialContacts.add(ctcon);
                }
                
                if(tpcn.primaryUser  ){
                    primaryUserEmail = tpcn.email;
                    primaryUserid = tpcn.trialContactSfId;
                }

           } 
      //  }
          
        LIST<Database.upsertResult> contactsRes = Database.upsert(allTrialContacts, false);

        for(Database.upsertResult cr: contactsRes){
            if(!cr.isSuccess()){
                isAnyErrorOnProcess = TRUE;
            }
        }

             return allTrialContacts;
       }


      

    

   private static List<Trial_Product__c> createTrialProduct(List<ODTDG_TrialRecord.TrialProdInfo> trPrIn, Ent_Trial__c trialRec, String custSegment){
       List<Trial_Product__c> allTrialProducts = new List<Trial_Product__c>();
       List<product2> productsList = new List<product2>();
       Map<String, String> prodRelationMap = new Map<String, String>();
       String offering;
       System.debug(LoggingLevel.INFO,'customer selectd State ...............'+customerState);
        
       productsList = ODTDG_EntitleTrialCustomerRecordsService.fetchProduct2Records(ODTDG_EntitleTrialCustomerRecordsService.productCodes(trPrIn, custSegment, customerState));
       System.debug(LoggingLevel.INFO,'productsList...............'+productsList);
       
       prodRelationMap = ODTDG_EntitleTrialCustomerRecordsService.getProdRelationMap(trPrIn, custSegment, customerState);
      // Set<String> prodRelList = ODTDG_EntitleTrialCustomerRecordsService.productCodes(trPrIn, custSegment, customerState);
        //for(product_relationship__c pr : [Select Id,name,product_to__r.productcode,relationship_type__c  from product_relationship__c where product_to__r.productcode IN: prodRelList]){
          //  prodRelationMap.put(pr.product_to__r.productcode,pr.relationship_type__c);
        //}
       
       for(ODTDG_TrialRecord.TrialProdInfo tpin:trPrIn){
         offering = tpin.productOffering;
       }


       for(product2 tpin:productsList){
            Trial_Product__c ctp = new Trial_Product__c();
            
            
            ctp.Product_Name__c =  tpin.id;
            ctp.Segment__c = custSegment;
            ctp.Product_Offerings__c = offering;
            ctp.Trial__c = trialRec.Id;
            ctp.Relationship_Type__c = prodRelationMap.get(tpin.productcode);
            allTrialProducts.add(ctp);
       }


     List<Database.saveResult> trialProductsRes = Database.insert(allTrialProducts, false); 
       for(Database.saveResult tp: trialProductsRes){
           if(!tp.isSuccess()){
                isAnyErrorOnProcess = TRUE;
           }
       }
     
     return allTrialProducts;
   }


    
   
    private static void fetchExisstingTrialDetails(){
        leadId = ODTDG_EntitleTrialCustomerRecordsService.fetchExisstingTrialDetails(trialSfId);
        
    }

    

     
     
}