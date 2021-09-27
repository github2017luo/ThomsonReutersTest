/*
Author : Mallikarjuna Rao
Date: May 2021
Description: This  class is for mainly to create trial and related records for primary user and this will be helper class forODTDG_EntitleTrialCustomerservice . 
Returns: multiple records as return types 
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
*  @description ODTDG_EntitleTrialCustomerRecordsService  : class to create various records 
*********************************************************************************************************/

public with sharing class ODTDG_EntitleTrialCustomerRecordsService {
    
    public static Trial_Contact__c trialInvitationContact;
     
    /********************************************************************************************************
    *  @description getFailureMsg: This is the method to return failure messages 
    * @return ODTDG_EntitlementWrapper  as a return type 
    * @param td , expected entitlement wrapper existing error messages 
    *********************************************************************************************************/ 
    public static ODTDG_EntitlementWrapper getFailureMsg(ODTDG_EntitlementWrapper td){
        td.status = new ODTDG_EntitlementWrapper.StatusResp();
        td.sfdcDetails = new ODTDG_EntitlementWrapper.RespDetails();

        string fCode = '205';
        string fmsg = 'Failure';

        if(Static_Values__c.getAll().containsKey('ODTDGFailureMsg')){ 
            fmsg = Static_Values__c.getValues('ODTDGFailureMsg').value__c;
        } 
        if(Static_Values__c.getAll().containsKey('ODTDGFailureCode')){ 
            fCode = Static_Values__c.getValues('ODTDGFailureCode').value__c;
        } 


        td.status.respCode = fCode; //'205';
        td.status.respMsg  = fmsg; //'Failure';
        
        return td;
    }

    /********************************************************************************************************
    *  @description createNewTrialContact: This is the method to create trial contacts 
    * @return Trial_Contact__c  as a return type 
    * @param tpcn , expected trial contact wrapper 
    * @param profileType , expected trial contact wrapper 
    * @param trAcc , expected trial contact wrapper  
    *********************************************************************************************************/ 
    public static Trial_Contact__c createNewTrialContact(ODTDG_TrialRecord_ContactHelper.TrialContacts tpcn, String profileType, ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAcc){
           
        Trial_Contact__c ctcon = new Trial_Contact__c();
            ctcon.First_Name__c = tpcn.firstName;      
            ctcon.Last_Name__c = tpcn.lastName;    
            ctcon.Email__c = tpcn.email;
            //ctcon.Contact__c = tpcn.primaryUser;
            ctcon.External_Contact_Number__c = tpcn.contactNumber;
            ctcon.External_Contact_Number_Source__c = tpcn.contactNumSource;
            ctcon.COBALT_GUID__c = tpcn.cobaltGUID;
            ctcon.DATAROOM_GUID__c = tpcn.dataroomGUID;
            ctcon.One_Pass_ID__c = tpcn.userAuthId; 
            ctcon.Unique_Name__c = tpcn.trialContactUniqueName;
            ctcon.Contact_Phone__c = tpcn.businessPhone;
          	ctcon.Country__c = trAcc.countryCode;
            ctcon.State__c = trAcc.state;
            ctcon.Profile_Type__c=profileType;
        	ctcon.stateCode__c=ODTDG_EntitleTrialCustomerServiceHelper.getStateCode(trAcc.countryCode,trAcc.state);
            
            if(tpcn.primaryUser ){
                ctcon.Primary__c = tpcn.primaryUser;
                ctcon.Request_Type__c='TRIAL';
                ctcon.Status__c = (ODTDG_Helper.getStaticValues('ODTDG_AcceptStatus') != null)?ODTDG_Helper.getStaticValues('ODTDG_AcceptStatus'):'Accepted';
            }  
            else{
                ctcon.Request_Type__c='TRIAL_ADDUSER';
                ctcon.Status__c = 'Draft';
            }  
            if(tpcn.trialAcceptanceDateTime != null ){
                ctcon.Accept_Terms_Date__c =   tpcn.trialAcceptanceDateTime;  
            }
            else{
                ctcon.Accept_Terms_Date__c = System.now();
            }


            if(ODTDG_EntitleTrialCustomerRecordsService.trialInvitationContact != null){
                ctcon.Invite_User_First_Name__c = ODTDG_EntitleTrialCustomerRecordsService.trialInvitationContact.First_Name__c; 
                ctcon.Invite_User_Last_Name__c = ODTDG_EntitleTrialCustomerRecordsService.trialInvitationContact.Last_Name__c;
            }
            if(tpcn.trialContactSfId != null && tpcn.trialContactSfId != ''){
                ctcon.id = tpcn.trialContactSfId;
            }
            if(ODTDG_EntitleTrialCustomerService.trialSfId != null){
                 ctcon.Trials__c = ODTDG_EntitleTrialCustomerService.trialSfId;
            }
            if(ODTDG_EntitleTrialCustomerService.leadId != null){
                ctcon.Lead__c = ODTDG_EntitleTrialCustomerService.leadId;
            }   

            ODTDG_EntitleTrialCustomerService.emailIds.add(tpcn.email);// This variable will be used for entitlement process to call omni services 


        return ctcon;   
   }

   /********************************************************************************************************
    *  @description getExistingTrialProducts: This is the method to return existing trial products 
    * @return LIST<Trial_Product__c> queries list of products 
    * @param trPrIn , expected trial product Info wrapper  
    *********************************************************************************************************/ 
   /*public static List<Trial_Product__c> getExistingTrialProducts(List<ODTDG_TrialRecord.TrialProdInfo> trPrIn) {
        // MAP<string, product2> productsMap = new MAP<string, product2>();
        set<string> productsCodes = new set<string>();
        productsCodes =  productCodes(trPrIn,'');

        List<Trial_Product__c> tplist = new List<Trial_Product__c>();
        if(Schema.sObjectType.Trial_Product__c.isQueryable()){
            tplist = [SELECT id, name from Trial_Product__c where Product_Name__r.productCode IN: productsCodes AND Trial__c =: ODTDG_EntitleTrialCustomerService.trialSfId ];
        }
        System.debug(LoggingLevel.INFO,'productsMap...............'+productsCodes);
        System.debug(LoggingLevel.INFO,'tplist...............'+tplist);

        return tplist;
    }*/  
    
    /********************************************************************************************************
    *  @description getTrialProducts: get Trial Products for invited users
    * @return LIST<Trial_Product__c > get list of products  
    * @param trialId   
    * @param prodOffer list of product offerings
    *********************************************************************************************************/
    public static List<Trial_Product__c> getTrialProducts(String trialId, List<String> prodOffer){
        List<Trial_Product__c> triaProdList = new List<Trial_Product__c>();
        if(Schema.sObjectType.Trial_Product__c.isQueryable()){
            triaProdList = [SELECT id, name, Trial__c, Product_Offerings__c, Material_Number__c from Trial_Product__c where Trial__c =: trialId];
        }
        return triaProdList;
    }

    /********************************************************************************************************
    *  @description productCodes: get product codes based on request 
    * @return LIST<string > get list of products  codes
    * @param trPrIn , expected trial product Info wrapper  
    * @param custSegment expecting customer segment to query related products 
    * @param custState expecting state
    *********************************************************************************************************/ 
    public  static Set<string> productCodes(List<ODTDG_TrialRecord.TrialProdInfo> trPrIn, String custSegment, String custState){
        Set<string> productSet = new Set<string>();
        List<String> prodOffering = new List<String>();
       
        for(ODTDG_TrialRecord.TrialProdInfo tpin:trPrIn){
            if(tpin.productOffering != null){
                prodOffering.add(tpin.productOffering);
            }
        }
        List<String> pCodeList = ODTDG_Helper.getProductCodesByState(prodOffering, custSegment, custState);
        Set<String> pCodeSet = new Set<String>(pCodeList);
        productSet.addAll(pCodeSet);
        ODTDG_EntitleTrialCustomerService.productCodes.addAll(productSet);// This variable will be used for entitlement process to call omni services 
        
        System.debug(LoggingLevel.INFO,'productSet...............'+productSet);

           return productSet;

   }

   

    /********************************************************************************************************
    *  @description fetchProduct2Records: get product codes based on request 
    * @return MAP<string, product2> get list of products  codes
    * @param prodCodes , expected trial product codes
    *********************************************************************************************************/ 
   public static List<product2> fetchProduct2Records(set<string> prodCodes){
       List<product2> productsList = new List<product2>();

        if(Schema.sObjectType.product2.isQueryable()){
            for(product2  p: [SELECT id,name, productCode from Product2 where productCode IN: prodCodes and IsActive = true]){
                productsList.add(p);
            }
        } 

        System.debug(LoggingLevel.INFO,'productsList...............'+productsList);
        return productsList;

   }

    /********************************************************************************************************
    *  @description fetchExisstingTrialDetails : get trial contacts from query  
    * @return string  return lead Id
    * @param trialSfId , trial id
    *********************************************************************************************************/ 
   public static string fetchExisstingTrialDetails(string trialSfId){
        if(  Schema.sObjectType.Trial_Contact__c.isQueryable() ){
                for(Trial_Contact__c tc : [Select id, name, Lead__c from Trial_Contact__c WHERE Trials__c =: trialSfId AND Primary__c= true ]){
                    if(tc.Lead__c != null ){
                        return tc.Lead__c;
                    }
            }   
        }  

        return null;
    }


    /********************************************************************************************************
    *  @description queryTrialforINC: get trial details from query  for INC journey
    * @return string  return lead Id
    * @param tpCat , trial categories like PL, PLB....
    * @param tcEmail expected primary user email address 
    *********************************************************************************************************/ 
    /*public static string  queryTrialforINC(set<string> tpCat, string tcEmail){
        if(  Schema.sObjectType.Trial_Product_Contact__c.isQueryable() ){
            string activeStatus = 'Active';

            for(Trial_Product_Contact__c tpc : [SELECT id, name, Trials__c, Trial_Contact__c, Trial_Product__c FROM Trial_Product_Contact__c WHERE Trial_Product__r.Product_Offerings__c IN: tpCat AND Trial_Contact__r.Primary__c = TRUE AND Trial_Contact__r.Email__c =:tcEmail AND Trials__r.Trial_Status__c =: activeStatus]){
                    if(tpc.Trials__c != null){
                        return tpc.Trials__c;
                    }
            }
            
        } 

    return null;

    }*/

    /********************************************************************************************************
    *  @description getProductCategories : get trial codes 
    * @return set<string>  return product categories 
    * @param trPrIn , trial products list  from service 
    *********************************************************************************************************/ 
    /*public static Set<string> getProductCategories(List<ODTDG_TrialRecord.TrialProdInfo> trPrIn){
        Set<string> productSet = new Set<string>();
        for(ODTDG_TrialRecord.TrialProdInfo tpin:trPrIn){
            if(tpin.trialProductNumber != null){
                productSet.add(tpin.trialProductCode);
            }
        }
        System.debug(LoggingLevel.INFO,'productSet...............'+productSet);
        return productSet;
    }*/


    /********************************************************************************************************
    *  @description getPrimaryContactEmail : get trial codes 
    * @return string  return primary user email
    * @param trCon , trial contacts list  from service 
    *********************************************************************************************************/ 
    public  static string getPrimaryContactEmail(List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trCon){
        string email;
        for(ODTDG_TrialRecord_ContactHelper.TrialContacts c: trCon){
            if(c.primaryUser ){
                email =  c.email;
            }  
        }
        return email;
    }


    /********************************************************************************************************
    *  @description getSuccessMsg : get trial codes 
    * @return ODTDG_EntitlementWrapper  Updated with success message 
    * @param td , ODTDG_EntitlementWrapper
    * @param trCont expecting trial contacts list to sned the data on success resp
    * @param trProd expecting trial contacts list to sned the data on success resp
    *********************************************************************************************************/ 
    public static ODTDG_EntitlementWrapper getSuccessMsg(ODTDG_EntitlementWrapper td, List<Trial_Contact__c> trCont, List<Trial_Product__c> trProd){
        td.status = new ODTDG_EntitlementWrapper.StatusResp();
        td.sfdcDetails = new ODTDG_EntitlementWrapper.RespDetails();
        td.sfdcDetails.trialContacts = new List<ODTDG_EntitlementWrapper.TrialContacts>();

        td.status.respCode = '200';
        td.status.respMsg  = 'SUCCESS';
        td.sfdcDetails.trialId = ODTDG_EntitleTrialCustomerService.trialSfId;
        td.sfdcDetails.trialProducts = new List<ODTDG_EntitlementWrapper.TrialProducts>();

        for(Trial_Contact__c trc : trCont){
            ODTDG_EntitlementWrapper.TrialContacts tc = new ODTDG_EntitlementWrapper.TrialContacts();
            tc.trialContactSfId = trc.id;
            tc.customerEmail = trc.Email__c;
            tc.conStatus = 'Success';
            td.sfdcDetails.trialContacts.add(tc);
        }
        for(Trial_Product__c trp : trProd){
            ODTDG_EntitlementWrapper.TrialProducts tp = new ODTDG_EntitlementWrapper.TrialProducts();
            tp.trialProductSfId = trp.id;
            tp.ProductCode = trp.Material_Number__c;
            td.sfdcDetails.trialProducts.add(tp);
        }

        return td;
    }


    /********************************************************************************************************
    *  @description createContactProduct : Method to create product and contact junction objects 
    * @return LIST<Trial_Product_Contact__c>  Ulist of trial products after save 
    * @param trialContacts , all contacts to process 
    * @param trialProducts , all products to process 
    * @param trialSfId , Salesforce trial id 
    *********************************************************************************************************/ 
    public  static LIST<Trial_Product_Contact__c> createContactProduct(List<Trial_Contact__c> trialContacts, List<Trial_Product__c> trialProducts, string trialSfId){
        List<Trial_Product_Contact__c> tpcList = new List<Trial_Product_Contact__c>();

        System.debug(LoggingLevel.INFO,'productsMap...............'+trialContacts.size()+'    '+trialContacts);
        System.debug(LoggingLevel.INFO,'productsMap...............'+trialProducts.size()+'    '+trialProducts);

        for(Trial_Contact__c tc : trialContacts){

            for(Trial_Product__c tp: trialProducts){
                Trial_Product_Contact__c tpc = new Trial_Product_Contact__c();
                tpc.Trial_Product__c = tp.id;
                tpc.Trial_Contact__c = tc.id;
                tpc.Trials__c = trialSfId;


                tpcList.add(tpc);
            }
        }

      List<Database.saveResult> tpcJunResult = Database.insert(tpcList, false);

      for(Database.saveResult tpcj: tpcJunResult){
            if(!tpcj.isSuccess()){
                ODTDG_EntitleTrialCustomerService.isAnyErrorOnProcess = TRUE;
            }
        }

        return tpcList;
    }
    
  /********************************************************************************************************
    *  @description getProdRelationMap : get trial codes 
    * @return Map<String, String>  return primary user email
    * @param trPrIn , trial contacts list  from service 
    * @param custSegment , trial contacts list  from service 
    * @param customerState , trial contacts list  from service 
    *********************************************************************************************************/ 
    public  static Map<String, String> getProdRelationMap(List<ODTDG_TrialRecord.TrialProdInfo> trPrIn, String custSegment, String customerState){
        Map<String, String> prodRelationMap = new Map<String, String>();
        Set<String> prodRelList = productCodes(trPrIn, custSegment, customerState);
        for(product_relationship__c pr : [Select Id,name,product_to__r.productcode,relationship_type__c  from product_relationship__c where product_to__r.productcode IN: prodRelList]){
            prodRelationMap.put(pr.product_to__r.productcode,pr.relationship_type__c);
        }
        return prodRelationMap;
    }

}