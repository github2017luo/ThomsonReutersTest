/**
* @description       : 
* @jira              : DPS-21106
* @author            : TCS Developer
* @TestClass         :  OmniEndTrial_Test
* @last modified on  : 07-30-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-24-2021   TCS Developer                         Initial Version 
**/
public with sharing class OmniEndTrialRequestJSON {

    public static Set<Id> trialActiveContIds;
    /**
* @description       : submitEntitlement
* @param trialId      
* @param endReason
* @param requestType
* @return reqBody
* */
    
    public static String endTrialRequest(Id trialId, String endReason,string requestType){
       
        trialActiveContIds = new Set<Id>();
        
        Ent_Trial__c  trialRecord =getTrailRecodDetails(trialId);
        list<Trial_Contact__c> trialContacts = getTrailContactDtls(trialId);
        list<Trial_Product__c> trialProducts = getTrailProductDtls(trialId);
        
        OmniEndTrialBooomiHeaderReqWrap boomiHeader = new OmniEndTrialBooomiHeaderReqWrap();
        boomiHeader.companyId = 'WEST';
        
        OmniEndTrialRequestWrapper entlWrap = new OmniEndTrialRequestWrapper();
        entlWrap.BOOMIHeader = boomiHeader;
        entlWrap.trialId = trialRecord.id; 
        entlWrap.requestType = requestType;
        entlWrap.trialUseCase = null ;
        entlWrap.effectiveDate = string.valueof(trialRecord.Trial_Start_Date__c);
        entlWrap.endDate = string.valueOf(trialRecord.Trial_End_Date__c);
        entlWrap.dataOwner = 'ODT';
        
        if(requestType == 'TRIAL_END'){
            entlWrap.reasonCode = 'End product';
        }
        entlWrap.customer = getCustomerWrapper(trialRecord);
        entlWrap.products = getProductsWrapper(trialRecord,trialContacts,trialProducts);
        
        //SYSTEM.DEBUG('JSON--->'+json.serialize(entlWrap));
        String reqBody= JSON.serialize(entlWrap);
        return reqBody;
        
    }
       /**
* @description       : submitEntitlement
* @param trialId      
* @param noOfDaysToExtend
* @param requestType
* @return reqBody
* */
    
    public static String extendTrialRequest(Id trialId, string noOfDaysToExtend ,string requestType){
       
        trialActiveContIds = new Set<Id>();
        
        Ent_Trial__c  trialRecord =getTrailRecodDetails(trialId);
       
        Date endDate = trialRecord.Trial_End_Date__c;
        
        Integer noOfDays = Integer.valueOf(noOfDaysToExtend);
        Date updatedEndDate = endDate.addDays(noOfDays);
        
        list<Trial_Contact__c> trialContacts = getTrailContactDtls(trialId);
        list<Trial_Product__c> trialProducts = getTrailProductDtls(trialId);
        
        OmniEndTrialBooomiHeaderReqWrap boomiHeader = new OmniEndTrialBooomiHeaderReqWrap();
        boomiHeader.companyId = 'WEST';
        
        OmniEndTrialRequestWrapper entlWrap = new OmniEndTrialRequestWrapper();
        entlWrap.BOOMIHeader = boomiHeader;
        entlWrap.trialId = trialRecord.id; 
        entlWrap.requestType = requestType;
        entlWrap.trialUseCase = null ;
        entlWrap.effectiveDate = string.valueof(trialRecord.Trial_Start_Date__c);
        entlWrap.endDate = string.valueOf(updatedEndDate);
        entlWrap.dataOwner = 'ODT';
        
        if(requestType == 'TRIAL_EXTEND'){
            entlWrap.reasonCode = 'Extend product';
        }
        entlWrap.customer = getCustomerWrapper(trialRecord);
        entlWrap.products = getProductsWrapper(trialRecord,trialContacts,trialProducts);
        
        //System.Debug('Extend Request JSON--->'+json.serialize(entlWrap));
        String reqBody= JSON.serialize(entlWrap);
        return reqBody;
        
    }
    
    /**
* @description       : getTrailRecodDetails
* @param trialId
* @return trialRecord
* */
    public static Ent_Trial__c getTrailRecodDetails(Id trialId){
        Ent_Trial__c  trialRecord;
        if(Schema.sObjectType.Ent_Trial__c.isAccessible() ){
            trialRecord =[select id,Account__r.BillingCountryCode, Trial_Start_Date__c, Trial_End_Date__c,Number_of_Times_Extended__c,Number_of_Days__c,External_Account_Number__c,
                          Account__r.name,Profile_Type__c,CurrencyIsoCode,Account__r.billingcity,Account__r.billingstatecode,
                          Lead__r.Company, Lead__r.BU_Segment__c,Lead__r.CountryCode, Lead__r.CurrencyIsoCode, Lead__r.City, Lead__r.Statecode, 
                          Lead__r.PostalCode,Account__r.Currencyisocode,Trial_Source__c,
                          Account__r.BillingpostalCode, Account__r.Bu_Segment__c
                          from Ent_Trial__c  where Id =: trialId];
            
            
        }
        
        return trialRecord;
    }
    
    
   /**
* @description       : getTrailContactDtls
* @param trialId
* @return trlContact
* */
    
    public static  list<Trial_Contact__c>  getTrailContactDtls(Id trialId){
        
        list<Trial_Contact__c>  trlContact;
        if(Schema.sObjectType.Trial_Contact__c.isAccessible()){            
             trlContact  = [select id,Email__c, First_Name__c, Last_Name__c,COBALT_GUID__c,DATAROOM_GUID__c,Request_Type__c,
                                                   Status__c, One_Pass_ID__c,External_Contact_Number__c,trials__c
                                                   from Trial_Contact__c where Status__c ='Active' and trials__c = : trialId] ;            
            
           
        }
        
        Map<Id, Trial_Contact__c> trialContMap = new Map<Id, Trial_contact__C>(trlContact);
        trialActiveContIds = trialContMap.keySet();
        
        
        return trlContact;
    }
    
   
    /**
* @description       : getTrailProductDtls
* @param trialId
* @return trlProduct
* */
    public static list<Trial_Product__c>  getTrailProductDtls(Id trialId){
        
        list<Trial_Product__c> trlProduct;
        if(Schema.sObjectType.Trial_Product__c.isAccessible()){
            
            trlProduct = [select Id, Product_Name__r.Name, Product_Name__r.ProductCode,Material_Number__c,
                          Product_Name__r.product_level_2__c,Product_Name__r.Promotion_Code__c ,trial__c,Product_Type__c
                          from Trial_Product__c
                          where trial__c = : trialId];
            
            
        }
        
        return trlProduct;
    }

    
    /**
* @description       : getTrailRecodDetails
* @param trialRecord
* @return customerWrapper
* */
    
    public static OmniEndTrialCustomerReqWrap getCustomerWrapper(Ent_Trial__c  trialRecord){
        OmniEndTrialCustomerReqWrap customerWrapper = new OmniEndTrialCustomerReqWrap();
        if(trialRecord.External_Account_Number__c != null){
        customerWrapper.customerNumber = Long.valueOf(trialRecord.External_Account_Number__c);
        customerWrapper.salesOrg = 'WEST';
        }
       
        
        return  customerWrapper;
    }
    
    
    /**
* @description       : 
* @param trialRecord
* @param trlContacts
* @param trialProducts
* @return productsWrapperList
* */
    public static  list<OmniEndTrialProductsReqWrap> getProductsWrapper(Ent_Trial__c  trialRecord, list<Trial_Contact__c> trlContacts,list<Trial_Product__c>  trialProducts){
        
        list<OmniEndTrialProductsReqWrap> productsWrapperList = new  list<OmniEndTrialProductsReqWrap>();
        
        list<OmniEndTrialContactsReqWrap> contactsWrapperList = getContactsWrapper(trialRecord,trlContacts);
        
        for(Trial_Product__c tpr : trialProducts){
            OmniEndTrialProductsReqWrap prod = new OmniEndTrialProductsReqWrap();
            prod.productId = tpr.Material_Number__c ;
            prod.productName=tpr.Product_Name__r.Name;
            prod.productType = tpr.Product_Type__c;
            prod.offerId = null;
            prod.referenceId = tpr.id;
            prod.contact = ContactsWrapperList;
            productsWrapperList.add(prod);
        }
        return productsWrapperList;
        
    }
    
    /**
* @description       : 
* @param trialRecord
* @param trlContacts
* @return contactsWrapperList
* */
    
    public static list<OmniEndTrialContactsReqWrap> getContactsWrapper(Ent_Trial__c  trialRecord,list<Trial_Contact__c> trlContacts){
        
        list<OmniEndTrialContactsReqWrap> contactsWrapperList = new  list<OmniEndTrialContactsReqWrap>();
        for(Trial_Contact__c trcon : trlContacts){
            OmniEndTrialContactsReqWrap trailContactWrap = new OmniEndTrialContactsReqWrap();  
            trailContactWrap.contactNumber = trcon.External_Contact_Number__c;
            trailContactWrap.profileIdentifier= trcon.One_Pass_ID__c;
            trailContactWrap.extContactId= trcon.id;
            trailContactWrap.users =getTrailUserDetailsWrapper(trcon);
            contactsWrapperList.add(trailContactWrap);
        }
        return contactsWrapperList;
    }
    
    
    /**
* @description       : getTrailUserDetailsWrapper
* @param trlContact
* @return usrsWrapperList
* */
    
    public static list<OmniEndTrialUsersReqWrap> getTrailUserDetailsWrapper(Trial_Contact__c trlContact){
        list<OmniEndTrialUsersReqWrap> usrsWrapperList = new list<OmniEndTrialUsersReqWrap>();
        
        if(trlContact.COBALT_GUID__c != null && trlContact.COBALT_GUID__c != ''){
            OmniEndTrialUsersReqWrap usrWrap =  new OmniEndTrialUsersReqWrap();
            usrWrap.domain = 'COBALT';
            usrWrap.userGUID = trlContact.COBALT_GUID__c;
            usrWrap.storageKey = null;
            usrsWrapperList.add(usrWrap);
        }
        
         if(trlContact.DATAROOM_GUID__c  != null && trlContact.DATAROOM_GUID__c  != ''){
            OmniEndTrialUsersReqWrap usrWrap =  new OmniEndTrialUsersReqWrap();
            usrWrap.domain = 'DATAROOM';
            usrWrap.userGUID = trlContact.DATAROOM_GUID__c;
            usrWrap.storageKey = null;
            usrsWrapperList.add(usrWrap);
        }
        return usrsWrapperList;
    }
    
  
}