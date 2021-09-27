/**
* @description       : 
* @author            : TCS Developer
* @group             : 
* @last modified on  : 06-22-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-24-2021   TCS Developer                         Initial Version 
**/
public with sharing class OmniSubmitEntitlRequestJSON {
    
    public static String contactFunctionValue = '';
    public static String customerSegmentValue ='';
    private static string digitalCountry = '';
    private static string digitalStateCode= '';
    
        
    /**
* @description       : submitEntitlement
* @param trialId
* @param trialContIds
* @param trialPrdIds
* @return reqBody
* */
    
    public static String submitEntitlement(Id trialId,  List<Id> trialContIds, List<Id> trialPrdIds){
               
        Ent_Trial__c  trialRecord =getTrailRecodDetails(trialId);//,emailIds,productCodes);
        list<Trial_Contact__c> trialContacts = getTrailContactDtls(trialId,trialContIds);
        list<Trial_Product__c> trialProducts = getTrailProductDtls(trialId,trialPrdIds);
        
        digitalCountry = getCountry(trialContacts);
        
        
        if(trialRecord.Trial_Source__c != null && trialRecord.Trial_Source__c == 'Digital'){
            contactFunctionValue =ODTDG_EntitleTrialCustomerServiceHelper.getContactFunctionValue(trialRecord.Organization_Type__c) ;
            customerSegmentValue =ODTDG_EntitleTrialCustomerServiceHelper.getcustomerSegmentValue(trialRecord.Market_Segment__c);
            //customerSegmentValue =OmniSubmitEntitlRequestJSONHelper.getCustomerSegmentValue(digitalSegment, trialRecord.Lead__r.ECC_Government_Type__c, digitalCountry) ;
        }
        else
        {
            contactFunctionValue =OmniSubmitEntitlRequestJSONHelper.getContactFuntionValue(trialRecord.Account__r.Bu_Segment__c) ;
            customerSegmentValue =OmniSubmitEntitlRequestJSONHelper.getCustomerSegmentValue(trialRecord.Account__r.Bu_Segment__c, trialRecord.Account__r.ECC_Government_Type__c, trialRecord.Account__r.BillingCountryCode) ;
        }
        
        OmniSubmitEntiBooomiHeaderReqWrap boomiHeader = new OmniSubmitEntiBooomiHeaderReqWrap();
        boomiHeader.companyId = 'WEST';
        
        OmniSubmitEntitlementRequestWrapper entlWrap = new OmniSubmitEntitlementRequestWrapper();
        entlWrap.BOOMIHeader = boomiHeader;
        entlWrap.trialId = trialRecord.id; 
        String reqType = trialContacts[0].Request_Type__c;
        
        if(reqType == 'TRIAL_ADDUSER'){
             reqType = 'TRIAL';
        }
        entlWrap.requestType = reqType;
        entlWrap.trialUseCase = trialRecord.Profile_Type__c ;
        entlWrap.effectiveDate = string.valueof(system.today());//trialRecord.Trial_Start_Date__c
        entlWrap.endDate = string.valueOf(trialRecord.Trial_End_Date__c);
        entlWrap.dataOwner = 'ODT';
        //cust.taxClass;
        /* Optional Start
cust.industryCode;
cust.industryCode1;
cust.jurisdictionCode;
Optional End */

        entlWrap.products = getProductsWrapper(trialRecord,trialContacts,trialProducts);
        entlWrap.customer = getCustomerWrapper(trialRecord);
        
        //SYSTEM.DEBUG('JSON--->'+json.serialize(entlWrap));
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
            trialRecord =[select id,Account__r.BillingCountryCode, Trial_Start_Date__c, Trial_End_Date__c,External_Account_Number__c,
                          Account__r.name,Profile_Type__c,CurrencyIsoCode,Account_Name__c,Account__r.billingcity,Account__r.billingstatecode,
                          Account__r.Currencyisocode,Trial_Source__c,Account__r.ECC_Government_Type__c,Lead__r.ECC_Government_Type__c,
                          Account__r.BillingpostalCode, Account__r.Bu_Segment__c,Organization_Type__c,Industry_code__c,Market_Segment__c
                          from Ent_Trial__c  where Id =: trialId];
            
            
        }
        
        return trialRecord;
    }
    
    
   /**
* @description       : getTrailContactDtls
* @param trialId
* @param trialContIds
* @return trlConMap
* */
    
    public static  list<Trial_Contact__c>  getTrailContactDtls(Id trialId,  List<Id> trialContIds){
        
        list<Trial_Contact__c>  trlContact;
        if(Schema.sObjectType.Trial_Contact__c.isAccessible()){            
             trlContact  = [select id,Email__c, First_Name__c, Last_Name__c,COBALT_GUID__c,DATAROOM_GUID__c,Request_Type__c,Start_Date__c,End_Date__c,
                                                   Status__c, One_Pass_ID__c,External_Contact_Number__c,trials__c,Country__c,State__c,stateCode__c
                                                   from Trial_Contact__c where ID in :trialContIds and trials__c = : trialId] ;            
            
           
        }
        return trlContact;
    }
    
   
    /**
* @description       : getTrailProductDtls
* @param trialId
* @param trialPrdIds
* @return trlPrdMap
* */
    public static list<Trial_Product__c>  getTrailProductDtls(Id trialId,  List<Id> trialPrdIds){
        
        list<Trial_Product__c> trlProduct;
        if(Schema.sObjectType.Trial_Product__c.isAccessible()){
            
            trlProduct = [select Id, Product_Name__r.Name, Product_Name__r.ProductCode,Material_Number__c,Segment__c,
                          Product_Name__r.product_level_2__c,Product_Name__r.Promotion_Code__c ,trial__c
                          from Trial_Product__c
                          where ID in :trialPrdIds and trial__c = : trialId];
            
            
        }
        return trlProduct;
    }

    
    /**
* @description       : getTrailRecodDetails
* @param trialRecord
* @return customerWrapper
* */
    
    public static OmniSubmitEntiCustomerReqWrap getCustomerWrapper(Ent_Trial__c  trialRecord){
        OmniSubmitEntiCustomerReqWrap customerWrapper = new OmniSubmitEntiCustomerReqWrap();
        if(trialRecord.External_Account_Number__c != null){
        customerWrapper.customerNumber = Long.valueOf(trialRecord.External_Account_Number__c);
        }
        
        customerWrapper.salesOrg ='WEST';
        
        if(trialRecord.Trial_Source__c != null && trialRecord.Trial_Source__c == 'Digital'){
            customerWrapper.currencyCode=trialRecord.CurrencyIsoCode;
            customerWrapper.countryCode=digitalCountry;
            customerWrapper.city=ODTDG_Helper.getStaticValues('ODTDG_City');
            customerWrapper.state=digitalStateCode;
            customerWrapper.zipcode=ODTDG_Helper.getStaticValues('ODTDG_PostalCode');
            customerWrapper.customerName= trialRecord.Account_Name__c;
        }
        else
        {
            customerWrapper.currencyCode=trialRecord.Account__r.CurrencyIsoCode ;
            customerWrapper.countryCode=trialRecord.Account__r.BillingCountryCode;
            customerWrapper.city=trialRecord.Account__r.billingcity;
            customerWrapper.state=trialRecord.Account__r.billingstateCode;
            customerWrapper.zipcode=trialRecord.Account__r.BillingpostalCode;
            customerWrapper.customerName= trialRecord.Account__r.name;
        }
        customerWrapper.customerSegment =customerSegmentValue;
        customerWrapper.taxClass = '2';
        customerWrapper.industryCode = trialRecord.Industry_code__c;
        return  customerWrapper;
    }
    
    
    /**
* @description       : 
* @param trialRecord
* @param trlContacts
* @param trialProducts
* @return productsWrapperList
* */
    public static  list<omniSubmitEntiProductsReqWrap> getProductsWrapper(Ent_Trial__c  trialRecord, list<Trial_Contact__c> trlContacts,list<Trial_Product__c>  trialProducts){
        
        list<omniSubmitEntiProductsReqWrap> productsWrapperList = new  list<omniSubmitEntiProductsReqWrap>();
        
        list<OmniSubmitEntiContactsReqWrap> contactsWrapperList = getContactsWrapper(trialRecord,trlContacts);
        
        for(Trial_Product__c tpr : trialProducts){
            omniSubmitEntiProductsReqWrap prod = new omniSubmitEntiProductsReqWrap();
            prod.productId = tpr.Material_Number__c ;
            prod.productName=tpr.Product_Name__r.Name;
            prod.productType = tpr.Product_Name__r.product_level_2__c;
            prod.promotionCode = tpr.Product_Name__r.Promotion_Code__c ;
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
    
    public static list<OmniSubmitEntiContactsReqWrap> getContactsWrapper(Ent_Trial__c  trialRecord,list<Trial_Contact__c> trlContacts){
        
        list<OmniSubmitEntiContactsReqWrap> contactsWrapperList = new  list<OmniSubmitEntiContactsReqWrap>();
        for(Trial_Contact__c trcon : trlContacts){
            OmniSubmitEntiContactsReqWrap trailContactWrap = new OmniSubmitEntiContactsReqWrap();  
            trailContactWrap.contactNumber = trcon.External_Contact_Number__c;
            trailContactWrap.firstName= trcon.First_Name__c;
            trailContactWrap.lastName= trcon.Last_Name__c;
            trailContactWrap.emailAddress= trcon.Email__c;
            trailContactWrap.contactFunction= contactFunctionValue;
            trailContactWrap.effectiveDate= string.valueOf(trcon.Start_Date__c);
            trailContactWrap.endDate= string.valueOf(trcon.End_Date__c);
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
    
    public static list<OmniSubmitEntiUsersReqWrap> getTrailUserDetailsWrapper(Trial_Contact__c trlContact){
        list<OmniSubmitEntiUsersReqWrap> usrsWrapperList = new list<OmniSubmitEntiUsersReqWrap>();
        
        if(trlContact.COBALT_GUID__c != null && trlContact.COBALT_GUID__c != ''){
            OmniSubmitEntiUsersReqWrap usrWrap =  new OmniSubmitEntiUsersReqWrap();
            usrWrap.domain = 'COBALT';
            usrWrap.userGUID = trlContact.COBALT_GUID__c;
            usrWrap.storageKey = null;
            usrsWrapperList.add(usrWrap);
        }
        
         if(trlContact.DATAROOM_GUID__c  != null && trlContact.DATAROOM_GUID__c  != ''){
            OmniSubmitEntiUsersReqWrap usrWrap =  new OmniSubmitEntiUsersReqWrap();
            usrWrap.domain = 'DATAROOM';
            usrWrap.userGUID = trlContact.DATAROOM_GUID__c;
            usrWrap.storageKey = null;
            usrsWrapperList.add(usrWrap);
        }
        return usrsWrapperList;
    }
    
  
  
      /**
* @description : getCountry-method to store digital countey and state value
* @param tc
* @return string
* */
      private static string getCountry(list<Trial_Contact__c> tc){
          for(Trial_Contact__c t: tc){
              if(String.isNotBlank(t.Country__c) && String.isBlank(digitalCountry)){
                digitalCountry = t.Country__c;
              }
              if(String.isNotBlank(t.stateCode__c) && String.isBlank(digitalStateCode)){
                digitalStateCode= t.stateCode__c;                
              }
              if(String.isBlank(digitalCountry) && String.isBlank(digitalStateCode)){
                  continue;
              }
          }
         return   digitalCountry;
      }
        
}