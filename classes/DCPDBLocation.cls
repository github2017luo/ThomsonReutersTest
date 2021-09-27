/********************************************************************************
Class Name : DCPDynamicBundlingHelper
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDBLocation{ 

    /**
        @description
     */  
    public static void updateExistingLocation(){
        
        List<APTS_Quote_Agreement_Locations__c> existingAgreementLocations = getExistingAgreementLocations(DCPDynamicBundling.objectCart.Apttus_QPConfig__Proposald__c);
        if(existingAgreementLocations != null && !existingAgreementLocations.isEmpty()){
            for(APTS_Quote_Agreement_Locations__c aLocation:existingAgreementLocations){
                aLocation.APTS_Agreement_Number__c = DCPDynamicBundling.bundlewrapper.mlaAgreementNumber;
            }
            if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isUpdateable()){
                update existingAgreementLocations;
            }
        }
    }
    
    /**
        @description
     */  
    public static void insertNewLocation(){

        List<APTS_Quote_Agreement_Locations__c> bundleLocationList = new List<APTS_Quote_Agreement_Locations__c>();
        //for(Id obj : cartId){
        if(DCPDynamicBundling.bundlewrapper.existOnlineSoftwareProduct){
            String status = DCPDynamicBundling.bundlewrapper.isKeepTerms ? 'Existing' : 'New';
            APTS_Quote_Agreement_Locations__c bundleLocation = new APTS_Quote_Agreement_Locations__c();
            bundleLocation.APTS_Subscriber_Location__c = DCPDynamicBundling.objectCart.Apttus_Config2__AccountId__c; 
            bundleLocation.APTS_Subscriber_Location_SSD__c = DCPDynamicBundling.objectCart.APTS_SSD_Sold_To__c;// DLT-9753 Update APTS_Subscriber_Location_SSD__c with APTS_SSD_Sold_To__c as per the GLI.
            bundleLocation.APTS_Quote_Proposal__c = DCPDynamicBundling.objectCart.Apttus_QPConfig__Proposald__c;
            bundleLocation.APTS_Status__c = status;
            
            if(DCPDynamicBundling.bundlewrapper.isKeepTerms){
                bundleLocation.APTS_Agreement_Number__c = DCPDynamicBundling.bundlewrapper.mlaAgreementNumber;
            }
            bundleLocationList.add(bundleLocation);
            //insert bundleLocation;
        }
        //}
        if(!bundleLocationList.isEmpty() && Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isCreateable()){
            insert bundleLocationList;
        }
    }
    
    /**
        @description
     */  
    public static void deleteExistingRecords(){

        List<APTS_Quote_Agreement_Locations__c> existingAgreementLocations = getExistingAgreementLocations(DCPDynamicBundling.objectCart.Apttus_QPConfig__Proposald__c);
        List<APTS_Additional_Subscription_Actions__c> existingSubscriptionActions = getExistingSubscriptionActions(DCPDynamicBundling.objectCart.Apttus_QPConfig__Proposald__c);
        
        if(existingAgreementLocations != null && !existingAgreementLocations.isEmpty() && Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isDeletable()){
            delete existingAgreementLocations;
        }
        
        if(existingSubscriptionActions != null && !existingSubscriptionActions.isEmpty() && Schema.sObjectType.APTS_Additional_Subscription_Actions__c.isDeletable()){
            delete existingSubscriptionActions;
        }
    }
    /**
        @description
        @param proposalId
        @return
     */  
    private static List<APTS_Quote_Agreement_Locations__c> getExistingAgreementLocations(Id proposalId){
        List<APTS_Quote_Agreement_Locations__c> listOfLocation = new List<APTS_Quote_Agreement_Locations__c>();
        if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isAccessible()){
        listOfLocation = [Select Id, APTS_Subscriber_Location__c, APTS_Status__c FROM APTS_Quote_Agreement_Locations__c WHERE APTS_Quote_Proposal__c=: proposalId]; 
        }
        return listOfLocation;
    }
    
    /**
        @description
        @param proposalId
        @return
     */  
    private static List<APTS_Additional_Subscription_Actions__c> getExistingSubscriptionActions(Id proposalId){
        List<APTS_Additional_Subscription_Actions__c> listOfActions = new List<APTS_Additional_Subscription_Actions__c>();
        if(Schema.sObjectType.APTS_Additional_Subscription_Actions__c.isAccessible()){
        listOfActions =[Select Id, APTS_Subscription_Number__c, APTS_Product__c FROM APTS_Additional_Subscription_Actions__c WHERE APTS_Quote_Proposal__c =: proposalId];
        }
        return listOfActions;
    }
    
}