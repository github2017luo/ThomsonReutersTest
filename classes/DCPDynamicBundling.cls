/********************************************************************************
Class Name : DCPDynamicBundling
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDynamicBundling{ 

    public static Apttus_Config2__ProductConfiguration__c objectCart;
    public static APTS_ConfigBundlePageSettings__c configBundleCS;
    public static DCPDBInitializeData.BundleWrapper bundleWrapper;
    public static Map<Id,DCPDBWrapper.BundleData> cartToBundleData = new Map<Id,DCPDBWrapper.BundleData>();
    public static boolean hasBundleProduct = false;
    
    //private static Map<Id, List<Apttus_Config2__LineItem__c>> cartIdLineItemMap= new Map<Id, List<Apttus_Config2__LineItem__c>>();
    private static Id cartId;   
    private static list<string> groupNameList;
    private static set<String> setOfTabNames = new Set<String>{'Print','Online/Software'};     
    private static Map<Id,decimal> bundleProdIdToLineNumber = new Map<id,decimal>();    
    private static String bundleName{get; set;}
    

    /** 
    @description call the execute bundling method
    @param requestBody will contain "cartId" as a parameter.
    @return Returns string in case of success OR thows execption in case of failure
    */
    public static string executeDynamicBundling(Map<string,string> requestBody){
        try{
            if(requestBody.containskey('cartId') && !String.isBlank(requestBody.get('cartId'))){
                cartId = requestBody.get('cartId');
                
                bundleName = 'Bundle A';
                
                //get group name list
                groupNameList = new list<string>();
                groupNameList.addAll(DCPDynamicBundlingHelper.getGroupPicklistValues(bundleName));
                   
                //get Cart details/field
                objectCart = DCPDBCartQuery.getCartDetails(cartId);
                            
                //To Populate Custom SettingS detail                
                configBundleCS = APTS_ConfigBundlePageSettings__c.getValues('Bundle Page Properties');                               
                
                // Call Initialize
                bundleWrapper = new DCPDBInitializeData.BundleWrapper(); 
                bundleWrapper = DCPDBInitializeData.initializeData();
                
                // Call Main Save method
                parseAndSaveData();
                
                return 'Success';
              
            }else{
                 return('ImproperRequestFormat');   
            }
        }catch(Exception ex){
             throw new DCCustomException(ex.getStackTraceString());
        }               
    }
    
     private static void parseAndSaveData(){

        Map<String,APTS_Group__c> groupNameUpdated=new Map<String,APTS_Group__c>();

        for(APTS_Group__c grps : bundlewrapper.groupListTobeInsert){
            bundlewrapper.grpMap.put(grps.APTS_ProductConfiguration__c, grps);
        }
        
        System.debug(LoggingLevel.DEBUG,'bundlewrapper.grpMap ------------------'+ bundlewrapper.grpMap);
        
        bundlewrapper.grpList = DCPDBInitializeData.getGrouplnItems(objectCart.Apttus_QPConfig__Proposald__c);  
        DCPDBPopulateLineItemsDetails.populateLineItemDetails(groupNameUpdated);

        System.debug(LoggingLevel.DEBUG,'CARTTOBUNDLEDATA:::::'+cartToBundleData);

        Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap = new Map<id,List<Apttus_Config2__LineItem__c>>();
        Map<String,Apttus_Config2__PriceListItem__c> plimap = new Map<String,Apttus_Config2__PriceListItem__c>();
        plimap = DCPDBCreateBundleLineItem.getPrceListItem();

        cartIDToLineItemsMap = DCPDBCartQuery.getCartLineItems(cartId);
        DCPDBCreateBundleLineItem.createDynamicBundleLineItem(cartIDToLineItemsMap,plimap);

        cartIDToLineItemsMap = DCPDBCartQuery.getCartLineItems(cartId);
        updateDynamicBundleLineItem(cartIDToLineItemsMap,groupNameUpdated,plimap);

        cartIDToLineItemsMap = DCPDBCartQuery.getCartLineItems2(cartId);
        DCPDBUpdateBundleLineItem.updateDynamicBundleLineItem(cartIDToLineItemsMap);

        System.debug(LoggingLevel.DEBUG,'bundlewrapper.grpMap-----------'+ bundlewrapper.grpMap);
        DCPDBGroupHelper.deleteGroupList();
        String actionType = 'backToCart';
        
        if(!bundlewrapper.isMLA && actionType == 'backToCart'){
            DCPDBLocation.deleteExistingRecords();
            DCPDBLocation.insertNewLocation();
            
        } else if(bundlewrapper.isMLA && actionType == 'backToCart' && bundlewrapper.isKeepTerms && bundlewrapper.mlaAgreementNumber != null){
            DCPDBLocation.updateExistingLocation();
        }


        //Call reprice for dynamic bundle line item
        //repriceCart();
        
        //If Bundle Product exists, call second reprice to fix pricing issue.
        if(hasBundleProduct){
            repriceCart();
        }
        
        DCPDBSummaryGroup.createSummaryGroup(bundlewrapper.grpMap,cartId);
        
        DCPDynamicBundlingHelper.updateCartToNewStatus(cartId);
    }
    
    private static void repriceCart(){
        if(!Test.isRunningTest()){
            DCPDynamicBundlingHelper.callApttusPriceUpdateAPI(cartId);
        }      
    }
                 
      private static void updateDynamicBundleLineItem(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap,Map<String,APTS_Group__c> groupNameUpdated,Map<String,Apttus_Config2__PriceListItem__c> plimap){
        
        List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>();

        //This logic is for populating the dynamic bundle line item details
        Decimal count1 = 1;
        Map<String,Apttus_Config2__LineItem__c> fieldmap = new Map<String,Apttus_Config2__LineItem__c>();
        DCPDBUpdateBundleLineItem.populateFieldMap(fieldmap,cartId,cartIDToLineItemsMap.get(cartId));

        for(Apttus_Config2__LineItem__c li: cartIDToLineItemsMap.get(cartId)){
            System.debug(LoggingLevel.DEBUG,li.Apttus_Config2__ConfigurationId__c + ''+  li);
            if(cartToBundleData.get(cartId).prdcode != null && cartToBundleData.get(cartId).prdcode.contains(li.APTS_Product_Code__c)){
                for(String str : cartToBundleData.get(cartId).bundles.keyset()){
                    String temp = str.substringAfter(':');
                    if(li.APTS_Product_Code__c == temp){
                        li.APTS_Group__c = str.substringBetween(';',':');
                        li.APTS_Group_Primary_Material_Name__c = str.substringBefore(';');
                        setLineItemPrice(li,cartId,str);
                        li.Apttus_Config2__LineSequence__c  = count1;
                        li.Apttus_Config2__LineNumber__c = count1;
                        li.Apttus_Config2__ItemSequence__c = count1;
                        li.Apttus_Config2__PriceUom__c='Each';
                        li.Apttus_Config2__Uom__c='Each';
                        li.APTS_Group_Primary_Material__c = cartToBundleData.get(cartId).groupPrimaryMaterial;
                        setLineItemPriceListItemDetail(li,plimap,temp);
                        setLineItemProposalGroup(li,groupNameUpdated,str);
                        li.APTS_Decentralized__c= bundlewrapper.decentralized;
                        li.APTS_MLA__c = bundlewrapper.existOnlineSoftwareProduct;
                        li.APTS_is_Primary_in_Bundle__c=true;                       
                        li.APTS_Existing_Subscriptions_Total__c = DCPDynamicBundlingHelper.getExistingSubscriptionTotal(cartIDToLineItemsMap.get(cartId));
                        li.APTS_New_Subscriptions_Total__c = DCPDynamicBundlingHelper.getNewSubscriptionTotal(cartIDToLineItemsMap.get(cartId)); 
                        li.apts_keep_terms__c =bundlewrapper.isKeepTerms ;
                        count1 = count1 + 1 + cartToBundleData.get(cartId).bundlecount.get(str);
                        setLineItemPriceAdjustment(li,fieldmap);
                        lineitemlist.add(li);
                        cartToBundleData.get(cartId).bundles.remove(str);
                        break;
                    }
                }
            }
        }
        //end of logic for populating dynamic bundle line item details
        

        System.debug(LoggingLevel.DEBUG,lineitemlist);
        if(!lineitemlist.isEmpty() && !Test.isRunningTest() 
           && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
            update lineitemlist;
        }
    }
    
    private static void setLineItemPrice(Apttus_Config2__LineItem__c li,Id configId,String str ){
        if(cartToBundleData.get(configId).bundles.get(str) != null){
            li.Apttus_Config2__ListPrice__c = Decimal.valueOf(cartToBundleData.get(configId).bundles.get(str).substringBefore('list'));
            li.Apttus_Config2__BasePrice__c= Decimal.valueOf(cartToBundleData.get(configId).bundles.get(str).substringBetween('list','base'));
            li.Apttus_Config2__IsCustomPricing__c = true;
        }
    }
    
    private static void setLineItemPriceListItemDetail(Apttus_Config2__LineItem__c li,Map<String,Apttus_Config2__PriceListItem__c> plimap,String temp){

        if(!plimap.isEmpty() && plimap.get(temp)!=null){
            li.Apttus_Config2__ChargeType__c= plimap.get(temp).Apttus_Config2__ChargeType__c; 
            li.Apttus_Config2__SellingFrequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
            li.Apttus_Config2__PriceType__c=plimap.get(temp).Apttus_Config2__PriceType__c;
            li.Apttus_Config2__Frequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
            li.Apttus_Config2__Term__c=1;
            li.Apttus_Config2__BasePriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c;
            li.Apttus_Config2__PriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c; 
            if(!(li.Apttus_Config2__LineStatus__c=='Amended')){ 
                li.Apttus_Config2__LineStatus__c='New'; 
            }
        }
    }
    
    private static void setLineItemProposalGroup(Apttus_Config2__LineItem__c li,Map<String,APTS_Group__c> groupNameUpdated,String str){

        if(groupNameUpdated!=null && groupNameUpdated.get(str)!=null){  
            System.debug(LoggingLevel.DEBUG,'bundle'+groupNameUpdated.get(str));                          
            li.APTS_Existing_Agreement_Total__c = groupNameUpdated.get(str).APTS_Existing_Agreement_Total__c;
            li.APTS_Online_Incremental__c = groupNameUpdated.get(str).APTS_Online_Incremental__c;
            li.APTS_Proposal_Group__c = groupNameUpdated.get(str).id; 
        }
    }
    
    private static void setLineItemPriceAdjustment(Apttus_Config2__LineItem__c li,Map<String,Apttus_Config2__LineItem__c> fieldmap){

        if(fieldmap != null && fieldmap.get(li.APTS_Totaling_Summary_Group__c) != null){
            li.APTS_Bridge__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Bridge__c;
            li.APTS_New_Bridge_Discount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_New_Bridge_Discount__c;
            li.APTS_Contract_Term__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Contract_Term__c;
            li.APTS_Years_2_Plus_Adjustment__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Years_2_Plus_Adjustment__c;
            li.Apttus_Config2__BillingFrequency__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__BillingFrequency__c;
            li.Apttus_Config2__AdjustmentType__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentType__c;
            li.Apttus_Config2__AdjustmentAmount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentAmount__c;
        }
    }

}