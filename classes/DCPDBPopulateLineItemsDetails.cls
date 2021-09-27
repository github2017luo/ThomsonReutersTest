/********************************************************************************
Class Name : DCPDBPopulateLineItemsDetails                          
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             DCPDBPopulateLineItemsDetails                          Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/

public without sharing class DCPDBPopulateLineItemsDetails{
    private static String bundleName = 'Bundle A';
    
    /**
        @description
        @param groupNameUpdated
     */   
    public static void populateLineItemDetails(Map<String,APTS_Group__c> groupNameUpdated){
        List<Apttus_Config2__LineItem__c> lnItemsToUpdate = new list<Apttus_Config2__LineItem__c>();
        
        Map<String, String> groupNameMap= new Map<String, String>();
        populateGroupNameMap(groupNameMap);
        System.debug(LoggingLevel.DEBUG,'groupNameMap' + groupNameMap);
        
        for(Apttus_Config2__LineItem__c ln:DCPDynamicBundling.bundlewrapper.lnItemList){
            //If line item's cart is not a key in DCPDynamicBundling.cartToBundleData, initialize and add new key-value pair to DCPDynamicBundling.cartToBundleData
            if(!DCPDynamicBundling.cartToBundleData.containsKey(ln.Apttus_Config2__ConfigurationId__c)){
                DCPDynamicBundling.cartToBundleData = initializeBundleData(DCPDynamicBundling.cartToBundleData,ln.Apttus_Config2__ConfigurationId__c);
            }
            DCPDBWrapper.BundleData tempBundleData = DCPDynamicBundling.cartToBundleData.get(ln.Apttus_Config2__ConfigurationId__c);
            System.debug(LoggingLevel.DEBUG,'tempBundleData1:::::'+tempBundleData);
            System.debug(LoggingLevel.DEBUG,'ln:::::'+ln);
            setMLAAgreementNumber(ln);
            if(ln.Apttus_Config2__HasOptions__c){
                DCPDynamicBundling.hasBundleProduct = true;
            }
            updateLineItemDetails(ln,groupNameMap,lnItemsToUpdate);
            
            //End of-Added as part of SOC-3699 : validation for Non-EDP products in EDP LT Bundle
            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here
            tempBundleData = DCPDynamicBundlingHelper.updateBundleDataPrice(ln,tempBundleData);
            tempBundleData = DCPDynamicBundlingHelper.updateBundleDataName(ln,tempBundleData);
            tempBundleData = DCPDynamicBundlingHelper.updateBundleDataLineStatusCheck(ln,tempBundleData);

            tempBundleData.groupPrimaryMaterial=ln.APTS_Group_Primary_Material__c;
            tempBundleData.count = tempBundleData.count + 1;
            tempBundleData.pricing = tempBundleData.listvalue+'list'+tempBundleData.basevalue+'base'+tempBundleData.adjusttype+'adjust'+tempBundleData.adjustvalue;
            tempBundleData.bundles.put(tempBundleData.bundlename,tempBundleData.pricing);
            tempBundleData.bundlecount.put(tempBundleData.bundlename,tempBundleData.count);
            tempBundleData.prdcode.add(tempBundleData.bundlename.substringAfter(':'));
            groupNameUpdated.put(tempBundleData.bundlename,DCPDynamicBundling.bundlewrapper.grpMap.get(ln.Apttus_Config2__ConfigurationId__c));  
            System.debug(LoggingLevel.DEBUG,groupNameUpdated);
            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Ends Here
            DCPDynamicBundling.cartToBundleData.put(ln.Apttus_Config2__ConfigurationId__c,tempBundleData);
        }
                
        System.debug(LoggingLevel.DEBUG,'lnItemsToUpdate ---------------'+ lnItemsToUpdate);
        
        if(!lnItemsToUpdate.isEmpty() && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
            try{
                update lnItemsToUpdate;
            }catch(DMLException ex){
                System.debug(LoggingLevel.DEBUG,'line 360-------exception'+ ex);
            }
        }
    }
       
    private static void populateGroupNameMap(Map<String, String> groupNameMap){
                
        if(DCPDynamicBundling.bundlewrapper.grpList.isEmpty()){
            return;
        }

        for(APTS_Group__c ln: DCPDynamicBundling.bundlewrapper.grpList){
        
            system.debug(LOGGINGLEVEL.DEBUG,'DCPDynamicBundling.bundlewrapper.groupListTobeInsert---'+DCPDynamicBundling.bundlewrapper.groupListTobeInsert);
            if(DCPDynamicBundling.bundlewrapper.groupListTobeInsert!=null && DCPDynamicBundling.bundlewrapper.groupListTobeInsert[0]!=null 
                && DCPDynamicBundling.bundlewrapper.groupListTobeInsert[0].id!=null){
                if(DCPDynamicBundling.bundlewrapper.groupListTobeInsert[0].Id == ln.Id){
                    groupNameMap.put(ln.Id, ln.APTS_Group_Name__c);
                }
            }
            System.debug(LoggingLevel.DEBUG,'material '+ln.APTS_Primary_Material__c);
        }
      
    }
    
    private static void setMLAAgreementNumber(Apttus_Config2__LineItem__c ln){
        if(ln.APTS_SAP_MLA_Agreement_Number__c != null){
            DCPDynamicBundling.bundlewrapper.mlaAgreementNumber = ln.APTS_SAP_MLA_Agreement_Number__c;
        }  
    }
    
    private static void updateLineItemDetails(Apttus_Config2__LineItem__c ln,Map<String, String> groupNameMap,List<Apttus_Config2__LineItem__c> lnItemsToUpdate){
        if(null != ln.Apttus_Config2__Quantity__c 
            && groupNameMap!=null && !groupNameMap.isEmpty() 
            && DCPDynamicBundling.bundlewrapper.groupListTobeInsert!=null 
            && !DCPDynamicBundling.bundlewrapper.groupListTobeInsert.isEmpty() 
            && DCPDynamicBundling.bundlewrapper.groupListTobeInsert[0]!=null 
            && DCPDynamicBundling.bundlewrapper.groupListTobeInsert[0].id!=null){

            System.debug(LoggingLevel.DEBUG,'DCPDynamicBundling.bundlewrapper.existOnlineSoftwareProduct------------'+ DCPDynamicBundling.bundlewrapper.existOnlineSoftwareProduct);
            DCPDynamicBundling.bundlewrapper.existOnlineSoftwareProduct = true;
            System.debug(LoggingLevel.DEBUG,'-----primary '+ln.APTS_SAP_Deal_Primary_Material__c);
            
            System.debug(LoggingLevel.DEBUG,'grpName ----------'+ bundleName);
            System.debug(LoggingLevel.DEBUG,'DCPDynamicBundling.bundlewrapper.materialNumber -----------------'+ DCPDynamicBundling.bundlewrapper.matrialMap.get(ln.Apttus_Config2__ConfigurationId__c));
            ln.APTS_Group__c = bundleName;
            ln.APTS_Proposal_Group__c = DCPDynamicBundling.bundlewrapper.grpMap.get(ln.Apttus_Config2__ConfigurationId__c).Id; //groupListTobeInsert[0].Id;
            ln.Apttus_Config2__PricingStatus__c =  'Pending';
            ln.APTS_Keep_Terms__c =  false;
            ln.APTS_Group_Primary_Material__c = DCPDynamicBundling.bundlewrapper.matrialMap.get(ln.Apttus_Config2__ConfigurationId__c);
            ln.APTS_Group_Primary_Material_Name__c =DCPDynamicBundling.bundlewrapper.grpMap.get(ln.Apttus_Config2__ConfigurationId__c).APTS_Primary_Material__c;
            if(ln.APTS_Keep_Terms__c){
                DCPDynamicBundling.bundlewrapper.isKeepTerms = true;
            }
            
            lnItemsToUpdate.add(ln);
            
        }
    }

     /** 
    @description to initialize the bundle wrapper varibales
    @param cartToBundleData will contain cart to bundle data.
    @param cartId will contain cart id 
    @return Returns map of cart id to bundle data
    */

     public static Map<Id,DCPDBWrapper.BundleData> initializeBundleData(Map<Id,DCPDBWrapper.BundleData> cartToBundleData, Id cartId){
        Map<Id,DCPDBWrapper.BundleData> cartBundleMap = cartToBundleData;
        DCPDBWrapper.BundleData bundle = new DCPDBWrapper.BundleData();
        bundle.listvalue = 0;
        bundle.basevalue = 0;
        bundle.adjustvalue = 0;
        bundle.count = 0;
        bundle.bundlename = '';
        bundle.adjusttype = '';
        bundle.pricing = '';

        cartBundleMap.put(cartId,bundle);

        return cartBundleMap;
    }      
}