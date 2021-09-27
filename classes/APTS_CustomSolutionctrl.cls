global with sharing class APTS_CustomSolutionctrl{
    public static string configId;
    public static string billingPostalCode;
    public static string configReq;
    public static Apttus_Config2__ProductConfiguration__c config1{get; set;}
    public static Apttus_Config2__ProductConfiguration__c config2{get; set;}
    public string configRequestId{get;set;}
    public string businessObjectId{get;set;}
    public string productConfig{get;set;}
    public static Boolean isAddedSucessfullyExp;
    public Apttus_Config2__ProductConfiguration__c config {get; set;}
    public Boolean isOptionsAvailable {get;set;}
    
     public APTS_CustomSolutionctrl() {
        String cId = string.escapeSingleQuotes('id');
        system.debug('Configuration ID >>>>> '+cId);
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(cId))){         
            configId = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(cId)));
            system.debug('Configuration ID >>>>> '+configId);
        }
        String conId = string.escapeSingleQuotes('configRequestId');
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(conId))){     
            configRequestId = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId)));
        }
        String busId = string.escapeSingleQuotes('businessObjectId');
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(busId))){
             BusinessObjectId = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(busId)));
        }
        String pId = string.escapeSingleQuotes('id');
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(pId))){     
            productConfig = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(pId)));
        }
        String retURLStr =  '/apex/apttus-config2__Cart?configRequestId='+configRequestId+'&flow=flcpq%23%2Fcart&id='+configId+'#/cart';         

        system.debug('@@@@@ retURLStr :'+retURLStr);
        initConfig();
    }

    private void initConfig(){
        config = new Apttus_Config2__ProductConfiguration__c();  
        if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()){
            List<Apttus_Config2__ProductConfiguration__c> listOfProdConfig = new List<Apttus_Config2__ProductConfiguration__c>();
            listOfProdConfig =  [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Name, 
                    Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, 
                    Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,
                    Apttus_Config2__AccountId__r.BillingPostalCode,Apttus_QPConfig__Proposald__r.Name FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :configId];
            if(listOfProdConfig != null && !listOfProdConfig.isEmpty())
            {
                config = listOfProdConfig[0];
                // businessObj = config.Apttus_Config2__BusinessObjectType__c;
                billingPostalCode = config.Apttus_Config2__AccountId__r.BillingPostalCode;  
                System.debug(' In initConfig --------------- > '+billingPostalCode);
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No records found for Product Configuration.'));
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'User has no access to Product Configuration.'));
        }

        /*
         *  @Chintan
         *  Transferred this query from addExposurePackToCart method to avoid query in remoteAction
         *  Sending boolean if options are available under "FindLaw Exposure Pack" product
         */
        //Querying all the options from the Bundle/Product defintion
        isOptionsAvailable = false;
        if (Schema.sObjectType.Apttus_Config2__ProductOptionComponent__c.isQueryable()){
            List<Apttus_Config2__ProductOptionComponent__c> availableOptionsInBundleList = new List<Apttus_Config2__ProductOptionComponent__c>(
                [select Id from Apttus_Config2__ProductOptionComponent__c 
                    WHERE Apttus_Config2__ParentProductId__c = :Label.FINDLAW_EXPOSURE_PACK]);
            if(availableOptionsInBundleList != null && !availableOptionsInBundleList.isEmpty())
            {
                isOptionsAvailable = true;
            }
        }
        if(config != null)
        {
            String soldToSSDName = config.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Name;                                             
            getAssetLines(soldToSSDName);
        }
    }
     
    @RemoteAction //SOC-7033 & SOC-7034
    public static String getDefaultAttribute(String configId){
        system.debug('Method getDefaultAttribute is called...!!!'+configId);
        config1 = new Apttus_Config2__ProductConfiguration__c();
        if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()){
            config1 =  [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_Config2__AccountId__c,Apttus_Config2__AccountId__r.BillingPostalCode FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :configId];
        }
        if(config1 != null && config1.Apttus_Config2__AccountId__r.BillingPostalCode!=null){
            billingPostalCode= config1.Apttus_Config2__AccountId__r.BillingPostalCode;
            billingPostalCode=billingPostalCode.left(billingPostalCode.length()-5);
            System.Debug('---billingPostalCode ------------ > '+billingPostalCode); 
        }
        return billingPostalCode;
    }
    
    /*
     *  @Chintan
     *  Added to separate query from above method - getDefaultAttribute
     */
    @RemoteAction //SOC-7033 & SOC-7034
    public static List<APTS_FindLaw_GEO_Defualts__c> getGeoDefault(String billPostCode){
        List<APTS_FindLaw_GEO_Defualts__c> geoDefault;
        
        if (Schema.sObjectType.APTS_FindLaw_GEO_Defualts__c.isQueryable()){
            geoDefault = [SELECT id, Name,APTS_County__c,APTS_Metro__c,APTS_State__c FROM APTS_FindLaw_GEO_Defualts__c WHERE Name=:billPostCode];
        }
        System.Debug('------geoDefault--------- > '+geoDefault); 
        if(!geoDefault.isEmpty()){
            System.Debug('Not Empty--------------- >');
            return geoDefault;
        }
        
        return null;
    }
    
    @RemoteAction
    public static List<Product2> getProducts(){
        system.debug('Method getProducts is called...!!!');
        List<Product2> products;
        if (Schema.sObjectType.Product2.isQueryable()){
            products = new List<Product2>([SELECT Id,Name,APTS_Attrbased_config__C,APTS_Inventory_Applicable__c,LCRM_Sub_Bu__c,Product_Level_5__c,APTS_PAGEO_UISequence__c,APTS_CustomUI_Category__c,APTS_No_New_Sales__c,ProductCode FROM Product2 WHERE APTS_Attrbased_config__C = true AND LCRM_Sub_Bu__c='FindLaw' AND APTS_No_New_Sales__c = false ORDER BY APTS_PAGEO_UISequence__c ASC]);
        }
       
        return products;
    }
    @RemoteAction
     public static List<APTS_Attribute_Settings__c> getattributeSetting(String productId){
        system.debug('DDD'+productId);
        List<APTS_Attribute_Settings__c> attributesetting;
        if (Schema.sObjectType.APTS_Attribute_Settings__c.isQueryable()){
        attributesetting = [SELECT Id,Name,APTS_Dependent_Attribute__c,APTS_Display_Order__c,APTS_API_Method_Name__c,APTS_Filtered_Based_On__c,APTS_Is_Defaulted__c,APTS_UI_Selection_Optional__c FROM APTS_Attribute_Settings__c WHERE Product__c=:productId ORDER BY APTS_Display_Order__c ASC];
        }
        system.debug('attributesetting '+attributesetting);
        return attributesetting;        
        
    }
    @RemoteAction
     public static List<APTS_Attribute_Value__c> getattributeValues(String productId,String attributeName,String parentattributeId){        
        List<APTS_Attribute_Value__c> attributeValue;
        if (Schema.sObjectType.APTS_Attribute_Value__c.isQueryable()){
        if(parentattributeId!=null && parentattributeId!=''){
        attributeValue= [SELECT Id,Name,APTS_Attribute_Name__c,APTS_Parent_Attribute__c,APTS_Product__c FROM APTS_Attribute_Value__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Name__c =:attributeName AND APTS_Parent_Attribute__c=:parentattributeId];
        
        }
        else{
        attributeValue= [SELECT Id,Name,APTS_Attribute_Name__c,APTS_Parent_Attribute__c,APTS_Product__c FROM APTS_Attribute_Value__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Name__c =:attributeName];
        
        }
        }
        return attributeValue;        
        
    }
    @RemoteAction
     public static List<AttrValCombinationUI> getattributeCombination(String configId1,String productId,String productCode,List<String> attribute0,List<String> attribute1,List<String> attribute2,List<String> attribute3){
        List<String> attributelist1 = new List<String>();
        List<String> attributelist2 = new List<String>();
        List<String> attributelist3 = new List<String>();
        
        for(String attributevalue1 :attribute1){
          if(attributevalue1!=null && attributevalue1!=''){
           attributelist1.add(attributevalue1);
          }
          
        }
        attribute1 = attributelist1; 
        for(String attributevalue2 :attribute2){
          if(attributevalue2!=null && attributevalue2!=''){
           attributelist2.add(attributevalue2);
          }
          
        }
        attribute2 = attributelist2; 
        
        for(String attributevalue3 :attribute3){
          if(attributevalue3!=null && attributevalue3!=''){
           attributelist3.add(attributevalue3);
          }
          
        }
        attribute3 = attributelist3; 

        List<APTS_Attribute_Value_Combination__c> attributeCombination = new List<APTS_Attribute_Value_Combination__c>();
      if (Schema.sObjectType.APTS_Attribute_Value_Combination__c.isQueryable()){
        String exposurePackProdCode = '';
        
        if(productCode == '40656701'){
            if(!attribute0.isEmpty() && !attribute1.isEmpty() && !attribute2.isEmpty()){
                attributeCombination = [SELECT Id,Name,APTS_Configuration_Description__c,APTS_Exposure_Pack_Disc__c,APTS_Product_Code__c,APTS_Inventory_Available__c,APTS_Product_Name__c,APTS_Attribute_Value1__r.APTS_Attribute_Name__c,APTS_Attribute_Value0__c,APTS_Attribute_Value0__r.APTS_Attribute_Name__c,Attribute1_Name__c,Attribute2_Name__c,APTS_Price__c,APTS_Price_Matrix_Key__c,APTS_Product__c,APTS_Attribute_Value1__c,APTS_Attribute_Value2__c,Attribute3_Name__c,APTS_Attribute_Value3__r.APTS_Attribute_Name__c,APTS_Attribute_Value2__r.APTS_Attribute_Name__c,APTS_Attribute_Value3__c FROM APTS_Attribute_Value_Combination__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Value0__c =:attribute0 AND APTS_Attribute_Value2__c =:attribute1 AND APTS_Attribute_Value3__c=:attribute2];
                }
                if(!attribute0.isEmpty() && !attribute1.isEmpty() && attribute2.isEmpty()){
                attributeCombination = [SELECT Id,Name,APTS_Configuration_Description__c,APTS_Exposure_Pack_Disc__c,APTS_Product_Code__c,APTS_Inventory_Available__c,APTS_Product_Name__c,APTS_Attribute_Value1__r.APTS_Attribute_Name__c,APTS_Attribute_Value0__c,APTS_Attribute_Value0__r.APTS_Attribute_Name__c,Attribute1_Name__c,Attribute2_Name__c,APTS_Price__c,APTS_Price_Matrix_Key__c,APTS_Product__c,APTS_Attribute_Value1__c,APTS_Attribute_Value2__c,Attribute3_Name__c,APTS_Attribute_Value3__r.APTS_Attribute_Name__c,APTS_Attribute_Value2__r.APTS_Attribute_Name__c,APTS_Attribute_Value3__c,APTS_Attribute_Value3__r.Name FROM APTS_Attribute_Value_Combination__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Value0__c =:attribute0 AND APTS_Attribute_Value2__c =:attribute1];
                
                system.debug('attributeCombination'+attributeCombination);
                system.debug('Size of AttrList'+attributeCombination.size());
                }
        }
        else if(!attribute1.isEmpty() && !attribute2.isEmpty() && !attribute3.isEmpty()){
            attributeCombination = [SELECT Id,Name,APTS_Configuration_Description__c,APTS_Product_Code__c,APTS_Inventory_Available__c,APTS_Product_Name__c,APTS_Attribute_Value1__r.APTS_Attribute_Name__c,APTS_Attribute_Value0__c,APTS_Attribute_Value0__r.APTS_Attribute_Name__c,Attribute1_Name__c,Attribute2_Name__c,APTS_Price__c,APTS_Price_Matrix_Key__c,APTS_Product__c,APTS_Attribute_Value1__c,APTS_Attribute_Value2__c,Attribute3_Name__c,APTS_Attribute_Value3__r.APTS_Attribute_Name__c,APTS_Attribute_Value2__r.APTS_Attribute_Name__c,APTS_Attribute_Value3__c FROM APTS_Attribute_Value_Combination__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Value0__c =:attribute0 AND APTS_Attribute_Value1__c=:attribute1 AND APTS_Attribute_Value2__c =:attribute2 AND APTS_Attribute_Value3__c=:attribute3];
            system.debug('Inside first if');
        }
        else if(attribute1.isEmpty() && !attribute2.isEmpty() && !attribute3.isEmpty()){
            attributeCombination = [SELECT Id,Name,APTS_Configuration_Description__c,APTS_Product_Code__c,APTS_Inventory_Available__c,APTS_Product_Name__c,APTS_Attribute_Value1__r.APTS_Attribute_Name__c,APTS_Attribute_Value0__c,Attribute1_Name__c,APTS_Attribute_Value0__r.APTS_Attribute_Name__c,Attribute2_Name__c,APTS_Price__c,APTS_Price_Matrix_Key__c,APTS_Product__c,APTS_Attribute_Value2__r.APTS_Attribute_Name__c,APTS_Attribute_Value1__c,APTS_Attribute_Value3__r.APTS_Attribute_Name__c,APTS_Attribute_Value2__c,Attribute3_Name__c,APTS_Attribute_Value3__c FROM APTS_Attribute_Value_Combination__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Value0__c =:attribute0 AND APTS_Attribute_Value2__c =:attribute2 AND APTS_Attribute_Value3__c=:attribute3];
            system.debug('Inside first if');
        }
        else if(attribute2.isEmpty() && attribute1.isEmpty() && !attribute3.isEmpty()){
            attributeCombination = [SELECT Id,Name,APTS_Configuration_Description__c,APTS_Product_Code__c,APTS_Inventory_Available__c,APTS_Product_Name__c,APTS_Attribute_Value1__r.APTS_Attribute_Name__c,Attribute1_Name__c,APTS_Attribute_Value0__r.APTS_Attribute_Name__c,Attribute2_Name__c,APTS_Price__c,APTS_Price_Matrix_Key__c,APTS_Attribute_Value2__r.APTS_Attribute_Name__c,APTS_Product__c,APTS_Attribute_Value1__c,APTS_Attribute_Value3__r.APTS_Attribute_Name__c,APTS_Attribute_Value2__c,Attribute3_Name__c,APTS_Attribute_Value3__c,APTS_Attribute_Value0__c FROM APTS_Attribute_Value_Combination__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Value0__c =:attribute0 AND APTS_Attribute_Value1__c=:attribute1 AND APTS_Attribute_Value3__c=:attribute3];
            system.debug('Inside second if');
        }
        else if(attribute3.isEmpty() && !attribute2.isEmpty() && !attribute1.isEmpty()){
            attributeCombination = [SELECT Id,Name,APTS_Configuration_Description__c,APTS_Product_Code__c,APTS_Inventory_Available__c,APTS_Product_Name__c,APTS_Attribute_Value1__r.APTS_Attribute_Name__c,APTS_Attribute_Value0__c,Attribute1_Name__c,APTS_Attribute_Value0__r.APTS_Attribute_Name__c,Attribute2_Name__c,APTS_Price__c,APTS_Price_Matrix_Key__c,APTS_Attribute_Value2__r.APTS_Attribute_Name__c,APTS_Product__c,APTS_Attribute_Value1__c,APTS_Attribute_Value3__r.APTS_Attribute_Name__c,APTS_Attribute_Value2__c,Attribute3_Name__c,APTS_Attribute_Value3__c FROM APTS_Attribute_Value_Combination__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Value0__c =:attribute0 AND APTS_Attribute_Value1__c=:attribute1 AND APTS_Attribute_Value2__c =:attribute2];
            system.debug('Inside second if');
        }
        else if(!attribute1.isEmpty() && attribute2.isEmpty() && attribute3.isEmpty()){
            attributeCombination = [SELECT Id,Name,APTS_Configuration_Description__c,APTS_Product_Code__c,APTS_Inventory_Available__c,APTS_Product_Name__c,APTS_Attribute_Value1__r.APTS_Attribute_Name__c,Attribute1_Name__c,APTS_Attribute_Value0__r.APTS_Attribute_Name__c,APTS_Attribute_Value2__r.APTS_Attribute_Name__c,Attribute2_Name__c,APTS_Price__c,APTS_Price_Matrix_Key__c,APTS_Product__c,APTS_Attribute_Value1__c,APTS_Attribute_Value2__c,Attribute3_Name__c,APTS_Attribute_Value0__c,APTS_Attribute_Value3__r.APTS_Attribute_Name__c,APTS_Attribute_Value3__c FROM APTS_Attribute_Value_Combination__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Value0__c =:attribute0 AND APTS_Attribute_Value1__c=:attribute1];
            system.debug('Inside second if');
        }
        else if(attribute1.isEmpty() && !attribute2.isEmpty() && attribute3.isEmpty()){
            attributeCombination = [SELECT Id,Name,APTS_Configuration_Description__c,APTS_Product_Code__c,APTS_Inventory_Available__c,APTS_Product_Name__c,APTS_Attribute_Value1__r.APTS_Attribute_Name__c,Attribute1_Name__c,APTS_Attribute_Value0__c,Attribute2_Name__c,APTS_Attribute_Value2__r.APTS_Attribute_Name__c,APTS_Price__c,APTS_Attribute_Value0__r.APTS_Attribute_Name__c,APTS_Price_Matrix_Key__c,APTS_Product__c,APTS_Attribute_Value1__c,APTS_Attribute_Value2__c,Attribute3_Name__c,APTS_Attribute_Value3__c,APTS_Attribute_Value3__r.APTS_Attribute_Name__c FROM APTS_Attribute_Value_Combination__c WHERE APTS_Product__c=:productId AND APTS_Attribute_Value0__c =:attribute0 AND APTS_Attribute_Value2__c =:attribute2];
            system.debug('Inside second if');
        }
        system.debug('DDD'+attributeCombination);
        }
        //SOC-9490 Installed icon not to be shown for Misc prods - Sakshi
        List<AttrValCombinationUI> attrValCombinationUIList = new List<AttrValCombinationUI>();
        if(productCode == '41767150' || productCode == '41378928' || productCode == '42157433' || productCode == '41053157' || productCode == ' 41056102'){
            for(APTS_Attribute_Value_Combination__c attributevlcmbntn : attributeCombination){
                AttrValCombinationUI wrapperattribute = new AttrValCombinationUI();
                wrapperattribute.isInstalled = false;
                wrapperattribute.attributeValueInstance = attributevlcmbntn;
                system.debug('misc---'+wrapperattribute.isInstalled);
                attrValCombinationUIList.add(wrapperattribute);
            }
            
        }
        
        else{   
        
        //Added by Sakshi to query assets in the page
        Config2  = new Apttus_Config2__ProductConfiguration__c(); 
        if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()){
            config2 =  [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_Config2__AccountId__c,Apttus_Config2__AccountId__r.BillingPostalCode, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Name FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :configId1];
        }
        List<String> existingoptions = new List<String>();
        List<String> existingConfigDescription = new List<String>();
        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
        if (Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
            assetLineItem = [SELECT Id,Apttus_Config2__OptionId__c,Apttus_Config2__OptionId__r.ProductCode,Apttus_Config2__ProductId__r.ProductCode,APTS_Combination_Key__c,APTS_Combination_Key__r.APTS_Configuration_Description__c FROM Apttus_Config2__AssetLineItem__c WHERE APTS_SSD_Sold_To__r.Name = :config2.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Name AND Apttus_Config2__AssetStatus__c = 'Activated'];
        }
        system.debug('assetLineItemmmmm>>>>>>'+ assetLineItem);

        Map<Id,Apttus_Config2__AssetLineItem__c> assetLineItemMap = new Map<Id,Apttus_Config2__AssetLineItem__c>();
        if(assetLineItem.size() > 0){
        for(Apttus_Config2__AssetLineItem__c ai : assetLineItem){
            assetLineItemMap.put(ai.APTS_Combination_Key__c,ai);
             if((ai.Apttus_Config2__OptionId__r.ProductCode=='37005004' || ai.Apttus_Config2__OptionId__r.ProductCode=='37005005'||ai.Apttus_Config2__OptionId__r.ProductCode=='37005072'||ai.Apttus_Config2__OptionId__r.ProductCode=='41680342') &&(ai.Apttus_Config2__OptionId__c!=null)){
                existingoptions.add(ai.Apttus_Config2__OptionId__r.ProductCode);
                existingConfigDescription.add(ai.APTS_Combination_Key__r.APTS_Configuration_Description__c);
            }
            else{
            existingoptions.add('');
            existingConfigDescription.add('');
            }
        }
        }
       
         for(APTS_Attribute_Value_Combination__c attributevc : attributeCombination){
            AttrValCombinationUI wrapperattribute = new AttrValCombinationUI();
                if(assetLineItemMap.containsKey(attributevc.Id)||((existingConfigDescription.contains(attributevc.APTS_Configuration_Description__c) && (attributevc.APTS_Product_Code__c=='37005004'||attributevc.APTS_Product_Code__c=='37005005')&& (existingoptions.contains('37005004')||existingoptions.contains('37005005')))||(existingConfigDescription.contains(attributevc.APTS_Configuration_Description__c) && (attributevc.APTS_Product_Code__c=='37005072'||attributevc.APTS_Product_Code__c=='41680342')&& (existingoptions.contains('37005072')||existingoptions.contains('41680342'))))){
                
                    system.debug('inside if');
                    wrapperattribute.isInstalled=true;
                    wrapperattribute.attributeValueInstance = attributevc;
                    system.debug('qwerty'+wrapperattribute.isInstalled); 
                }
                else{
                    wrapperattribute.isInstalled = false;
                    wrapperattribute.attributeValueInstance = attributevc;
                    system.debug('qwerty'+wrapperattribute.isInstalled);
                }
               
                attrValCombinationUIList.add(wrapperattribute);
            }
         }   
        system.debug('attrValCombinationUIListttttt >>>>'+attrValCombinationUIList);  
        return attrValCombinationUIList; 
        
    }
    
    /*
     *  @Chintan
     *  3 Part of addExposurePackToCart method - moved out of remoteAction and calling from constructor
     *  Method Name: getAssetLines
     *  Passing soldToSSD > Name from method : getProductConfiguration and returning List of Asset Line
     */
    
    public void getAssetLines(String soldToSSDName)              
    {
        system.debug('@@@@@@@'+soldToSSDName);  
        List<Apttus_Config2__AssetLineItem__c> listOfAssetLines = new List<Apttus_Config2__AssetLineItem__c>();  
        
        if (Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
         
            system.debug('@@@@@@@2222-----'+soldToSSDName);
            listOfAssetLines = [SELECT Id,APTS_Combination_Key__c,APTS_Combination_Key__r.Attribute1_Name__c,                 
                            APTS_Combination_Key__r.Attribute3_Name__c, Apttus_Config2__ProductId__r.APTS_Attrbased_config__c,APTS_Combination_Key__r.APTS_Product_Code__c           
                            FROM Apttus_Config2__AssetLineItem__c            
                            WHERE APTS_SSD_Sold_To__r.Name = :soldToSSDName                
                            AND Apttus_Config2__AssetStatus__c = 'Activated'           
                            AND Apttus_Config2__ProductId__r.APTS_Attrbased_config__c = true];  
            
            Cache.Session.put('local.FindLawpaGeo.AssetLineItems',listOfAssetLines);
        }
    }          


    /*
     *  @Chintan
     *  4 Part of addExposurePackToCart method - called after 1st addingProductsToCart method
     *  Method Name: processAttbValueCombs
     *  Passing return value of getAttbValueCombination and returning TRUE is product is added Else FALSE
     */
    @RemoteAction
    public static Boolean processAttbValueCombs(String flag, Boolean isOptionsAvailableOrNo, Id priceListId, String CartId, List<String> keys, List<Double> values)
 //   public static List<Boolean> processAttbValueCombs(String flag, Boolean isOptionsAvailableOrNo, Id priceListId, String CartId, List<String> keys, List<Double> values, List<String> selectedProductDetails)
    {
        system.debug('ProcessAttbValueCombs Start Time : >>>'+DateTime.now());
        List<APTS_Attribute_Value_Combination__c> listOfAttrbCombination = new List<APTS_Attribute_Value_Combination__c>();
        if(Cache.session.contains('local.FindLawpaGeo.listOfAttributeValueCombs'))
        {
            listOfAttrbCombination = (List<APTS_Attribute_Value_Combination__c>) Cache.session.get('local.FindLawpaGeo.listOfAttributeValueCombs');
        }

        if(listOfAttrbCombination == null || listOfAttrbCombination.isEmpty())
        {
            return false;
        }
        
        //  New changes
    /*    List<Boolean> result = new List<Boolean>();
        System.debug('CPU Time Utilized before constructing List: '+Limits.getCpuTime());
        List<LineItemWrapper> lineItemWrapperList = new List<LineItemWrapper>();
        //Convert JSON to wrapper
        for(String selectedProd : selectedProductDetails){
            LineItemWrapper liWrapper = new LineItemWrapper();
            liWrapper = (LineItemWrapper) System.JSON.deserializeStrict(selectedProd,LineItemWrapper.class);
            lineItemWrapperList.add(liWrapper);
        }
        cartId = lineItemWrapperList[0].cartId; // remove from parameter*/
        List<String> existingCombinationKeys = new List<String>();
        List<String> existingProducts = new List<String>();
        List<String> existingoptions = new List<String>();
        List<String> existingConfigDescription = new List<String>();
 

        //Check existing line items has same combination key and product id 
        Decimal maxLineItemNumber = 0;
        for(Apttus_Config2__LineItem__c li: [SELECT Id,Apttus_Config2__OptionId__c,Apttus_Config2__OptionId__r.ProductCode,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Combination_Key__c,APTS_Combination_Key__r.APTS_Configuration_Description__c,Apttus_Config2__ConfigurationId__c, 
                                        Apttus_Config2__LineNumber__c FROM Apttus_Config2__LineItem__c
                                        WHERE Apttus_Config2__ConfigurationId__c=:cartID ORDER BY Apttus_Config2__LineNumber__c])
        {
                                            
            //Last line item number
            maxLineItemNumber = li.Apttus_Config2__LineNumber__c;
            existingCombinationKeys.add(li.APTS_Combination_Key__c);
            existingProducts.add(li.Apttus_Config2__ProductId__c);
            if((li.Apttus_Config2__OptionId__r.ProductCode=='37005004' || li.Apttus_Config2__OptionId__r.ProductCode=='37005005'||li.Apttus_Config2__OptionId__r.ProductCode=='37005072'||li.Apttus_Config2__OptionId__r.ProductCode=='41680342') &&(li.Apttus_Config2__OptionId__c!=null)){
                existingoptions.add(li.Apttus_Config2__OptionId__r.ProductCode);
                existingConfigDescription.add(li.APTS_Combination_Key__r.APTS_Configuration_Description__c);
            }
            else if((li.Apttus_Config2__ProductId__r.ProductCode=='37005004' || li.Apttus_Config2__ProductId__r.ProductCode=='37005005'||li.Apttus_Config2__ProductId__r.ProductCode=='37005072'||li.Apttus_Config2__ProductId__r.ProductCode=='41680342') &&(li.Apttus_Config2__OptionId__c==null)){
            existingoptions.add(li.Apttus_Config2__ProductId__r.ProductCode);
            existingConfigDescription.add(li.APTS_Combination_Key__r.APTS_Configuration_Description__c);
            }
        }
        System.debug('### Existing Combination Keys >>>'+existingCombinationKeys);
        System.debug('maxLineItemNumber: '+maxLineItemNumber);
        /*Map<Decimal,String> lineNumberCombinationKeyMap = new Map<Decimal, String>();
        Map<Decimal,String> lineNumberAttorneyMap = new Map<Decimal, String>();

        Apttus_CPQApi.CPQ.AddMultiProductRequestDO addMultiProdRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        addMultiProdRequest.cartId = cartId;
        addMultiProdRequest.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();

        Decimal index = maxLineItemNumber+1;
        boolean callAPI = false;
        
        List<String> customFields1 = new List<String>{'Apttus_Config2__ChargeType__c','APTS_Combination_Key__c','Apttus_Config2__SellingFrequency__c','Apttus_Config2__PriceUom__c','Apttus_Config2__PriceType__c','Apttus_Config2__Frequency__c','Apttus_Config2__Term__c','Apttus_Config2__BasePriceMethod__c','Apttus_Config2__PriceMethod__c',
'Apttus_Config2__IsCustomPricing__c','Apttus_Config2__ConfigStatus__c','Apttus_Config2__PricingStatus__c','Apttus_Config2__ConstraintCheckStatus__c','APTS_FL_Qty__c'};
        
        Apttus_Config2__LineItem__c customData;
        Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct;
        system.debug('@@@@@ Line Item Wrapper List >>> '+lineItemWrapperList);
        for(LineItemWrapper li: lineItemWrapperList){
            //Skip the line item which matches existing line items 
            if(existingCombinationKeys.contains(li.combinationKey) && existingProducts.contains(li.productId)){
                result.add(false);
                continue;
            }
            //Set callAPI true if line does not match existing line items 
            callAPI = true;         
            result.add(true);
            
            //Map with line item number and combination key to update newly created line items 
            lineNumberCombinationKeyMap.put(index, li.combinationKey);
            lineNumberAttorneyMap.put(index,li.attorney);
            index++;
            
            //Construct request object
            customData = new Apttus_Config2__LineItem__c();             
            selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            selectedProduct.productId = li.productId;
            selectedProduct.Quantity = 1;        
            selectedProduct.comments = 'Inserted via Ecommerce';
            customData = new Apttus_Config2__LineItem__c(Apttus_Config2__ChargeType__c= 'Subscription Fee',APTS_Combination_Key__c=li.combinationKey,Apttus_Config2__SellingFrequency__c='Monthly',Apttus_Config2__PriceUom__c='Each',Apttus_Config2__PriceType__c='Recurring',Apttus_Config2__Frequency__c='Monthly',Apttus_Config2__Term__c=1,Apttus_Config2__BasePriceMethod__c='Per Unit',Apttus_Config2__PriceMethod__c='Per Unit',
            Apttus_Config2__IsCustomPricing__c=true);
            
            selectedProduct.CustomFields = customFields1;
            selectedProduct.CustomData = customData;
            addMultiProdRequest.selectedProducts.add(selectedProduct);
        }
        System.debug('CPU Time Utilized before Calling API: '+Limits.getCpuTime());
        
        if(callAPI){
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO addMultiProdResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(addMultiProdRequest);
            System.debug('addMultiProdResponse SP'+addMultiProdResponse);
            System.debug('CPU Time Utilized after Calling API: '+Limits.getCpuTime());
            Apttus_Config2__LineItem__c lineItem;
            //Populate combination key on newly created Line Items- Begins 
            List<Apttus_Config2__LineItem__c> liToBeUpdated = new List<Apttus_Config2__LineItem__c>();
            for(Apttus_Config2__LineItem__c li: [SELECT Id,Apttus_Config2__LineNumber__c FROM Apttus_Config2__LineItem__c 
                                            WHERE Apttus_Config2__ConfigurationId__c =: cartID AND Apttus_Config2__LineNumber__c >: maxLineItemNumber])
            {
                if(lineNumberCombinationKeyMap.containsKey(li.Apttus_Config2__LineNumber__c) 
                   && lineNumberCombinationKeyMap.get(li.Apttus_Config2__LineNumber__c) != NULL)
                {
                    lineItem = new Apttus_Config2__LineItem__c();
                    lineItem.Id = li.Id;
                    lineItem.APTS_Combination_Key__c = lineNumberCombinationKeyMap.get(li.Apttus_Config2__LineNumber__c);
                    if(lineNumberAttorneyMap.containsKey(li.Apttus_Config2__LineNumber__c) && lineNumberAttorneyMap.get(li.Apttus_Config2__LineNumber__c) != NULL)
                    {
                        lineItem.APTS_FL_Qty__c= Decimal.valueOf(lineNumberAttorneyMap.get(li.Apttus_Config2__LineNumber__c));
                    }

                    lineItem.Apttus_Config2__ChargeType__c= 'Subscription Fee'; 
                    lineItem.Apttus_Config2__SellingFrequency__c='Monthly';
                    lineItem.Apttus_Config2__PriceUom__c='Each';
                    lineItem.Apttus_Config2__PriceType__c='Recurring';
                    lineItem.Apttus_Config2__Frequency__c='Monthly';
                    lineItem.Apttus_Config2__Term__c=1;
                    lineItem.Apttus_Config2__BasePriceMethod__c='Per Unit';
                    lineItem.Apttus_Config2__PriceMethod__c='Per Unit';  
                    lineItem.Apttus_Config2__IsCustomPricing__c= true;    

                    lineItem.Apttus_Config2__ConfigStatus__c= 'Pending'; 
                    lineItem.Apttus_Config2__PricingStatus__c= 'Pending'; 
                    liToBeUpdated.add(lineItem);
                }
            }
            
            if(liToBeUpdated.size()>0){
                Database.update(liToBeUpdated);
            }
            //Populate combination key on newly created Line Items- Ends
            System.debug('CPU Time Utilized after update Line Item: '+Limits.getCpuTime());
            
            if(!Test.isRunningTest()){
                Apttus_CPQApi.CPQWebService.associateConstraintRules(cartId, null);
                Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, false);                         
            }
            System.debug('CPU Time Utilized After constraint Rule run: '+Limits.getCpuTime()); 
            //Check whether API response
            if(addMultiProdResponse != null && addMultiProdResponse.LineNumbers != null 
               && addMultiProdResponse.LineNumbers.size() > 0)
            {
                return result;
            }else{
                result.clear();
                //Return false if API response is null
                for(LineItemWrapper li: lineItemWrapperList){
                    result.add(false);
                }               
            } 
            return result;     
        }
        //The below line will be executed only if all the selected products matches existing line items 
        return result;
    }*/
    
        system.debug('ProcessAttbValueCombs Start Time : >>>'+DateTime.now());
        //Map to hold only topspots and Spotlights
        Map<String,APTS_Attribute_Value_Combination__c> spotLightMap = new Map<String,APTS_Attribute_Value_Combination__c>();

        //addToCartList will hold the list of AVC records that has to be added as options to bundle
        Map<String, Apttus_Config2__AssetLineItem__c> assetCheckMap = new Map<String, Apttus_Config2__AssetLineItem__c>();
        List<Apttus_Config2__AssetLineItem__c> listOfAssetLines = new List<Apttus_Config2__AssetLineItem__c>();
        Map<String, String> assetprodMap = new Map<String, String>();

        if(Cache.Session.contains('local.FindLawpaGeo.AssetLineItems'))
        {
            listOfAssetLines = (List<Apttus_Config2__AssetLineItem__c>)Cache.Session.get('local.FindLawpaGeo.AssetLineItems');
        
            for(Apttus_Config2__AssetLineItem__c assetCheck : listOfAssetLines){
                assetCheckMap.put(assetCheck.APTS_Combination_Key__r.Attribute1_Name__c+'_'+assetCheck.APTS_Combination_Key__r.Attribute3_Name__c,assetCheck);
                assetprodMap.put(assetCheck.APTS_Combination_Key__r.Attribute1_Name__c+'_'+assetCheck.APTS_Combination_Key__r.Attribute3_Name__c,assetCheck.APTS_Combination_Key__r.APTS_Product_Code__c);
            }

            Cache.Session.remove('local.FindLawpaGeo.AssetLineItems');
        }
        system.debug('assetCheckMappppppp---'+assetCheckMap);
        String assetKey = '';
        List<APTS_Attribute_Value_Combination__c> attrValCombList;
        Map<Id,List<APTS_Attribute_Value_Combination__c>> addtoCartMap = new Map<Id,List<APTS_Attribute_Value_Combination__c>>();

        Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
        Map<Id, Apttus_CPQApi.CPQ.AddBundleRequestDO> mapOfRequests = new Map<Id, Apttus_CPQApi.CPQ.AddBundleRequestDO>();
        List<String> customFields = new List<String>{'Apttus_Config2__ChargeType__c','APTS_Combination_Key__c','Apttus_Config2__SellingFrequency__c','Apttus_Config2__PriceUom__c','Apttus_Config2__PriceType__c','Apttus_Config2__Frequency__c','Apttus_Config2__Term__c','Apttus_Config2__BasePriceMethod__c','Apttus_Config2__PriceMethod__c',
'Apttus_Config2__IsCustomPricing__c','Apttus_Config2__AdjustmentAmount__c','Apttus_Config2__ConfigStatus__c','Apttus_Config2__PricingStatus__c','Apttus_Config2__ConstraintCheckStatus__c','APTS_FL_Qty__c','Apttus_Config2__ProductVersion__c'};
        
        for(APTS_Attribute_Value_Combination__c objAttbCombination : listOfAttrbCombination){
          system.debug('### Custom UI Category >>'+objAttbCombination.APTS_CustomUI_Category__c);
            if(objAttbCombination.APTS_CustomUI_Category__c != null && objAttbCombination.APTS_CustomUI_Category__c.equalsIgnoreCase('SpotLights')){
                   spotLightMap.put(objAttbCombination.Attribute1_Name__c+'_'+objAttbCombination.APTS_Product_Name__c+'_'+objAttbCombination.Attribute3_Name__c, objAttbCombination);
            }
        }
        
        system.debug('##### spotLightMap >>>>>'+spotLightMap);
    
        Apttus_Config2__LineItem__c newliSO = new Apttus_Config2__LineItem__c();

        for(APTS_Attribute_Value_Combination__c productExist : listOfAttrbCombination){
            attrValCombList = new List<APTS_Attribute_Value_Combination__c>();
            assetKey = productExist.Attribute1_Name__c+'_'+productExist.Attribute3_Name__c;
            system.debug('productExist ----'+productExist);
            system.debug('$$$$ Custom UI Category ----'+productExist.APTS_CustomUI_Category__c);
            if(flag.equalsIgnoreCase('No') && ((!assetCheckMap.containsKey(assetKey) && productExist.APTS_Product_Code__c != '37005004' && productExist.APTS_Product_Code__c != '37005005' && productExist.APTS_Product_Code__c != '37005072' && productExist.APTS_Product_Code__c != '41680342') || (!(assetCheckMap.containsKey(assetKey) && (assetprodMap.get(assetKey) == '37005004' || assetprodMap.get(assetKey) == '37005005')) && (productExist.APTS_Product_Code__c == '37005004' || productExist.APTS_Product_Code__c == '37005005')) || (!(assetCheckMap.containsKey(assetKey) && (assetprodMap.get(assetKey) == '37005072' || assetprodMap.get(assetKey) == '41680342')) && (productExist.APTS_Product_Code__c == '37005072' || productExist.APTS_Product_Code__c == '41680342')))){
            if(productExist.APTS_CustomUI_Category__c != null 
                && productExist.APTS_CustomUI_Category__c.equalsIgnoreCase('TopSpots')){
                if(productExist.APTS_Inventory_Available__c == 0){
                    string topkey = productExist.Attribute1_Name__c +'_'+productExist.APTS_Product_Name__c+'_'+productExist.Attribute3_Name__c;
                    system.debug('@@@@@@ TopKEY >>>'+topkey);
                    topkey = topkey.replace('TOPSPOT','SPOTLIGHT');
                    if(spotLightMap.containsKey(topkey)){
                        APTS_Attribute_Value_Combination__c spotrec = spotlightMap.get(topkey);
                        system.debug('333333333333333333333');
                                        
                        if(!((existingCombinationKeys.contains(spotrec.id) && existingProducts.contains(spotrec.APTS_Product__c))||((existingConfigDescription.contains(spotrec.APTS_Configuration_Description__c) && (existingoptions.contains('37005004')||existingoptions.contains('37005005')) && (spotrec.APTS_Product_Code__c == '37005004' || spotrec.APTS_Product_Code__c == '37005005'))||(existingConfigDescription.contains(spotrec.APTS_Configuration_Description__c) && (existingoptions.contains('37005072')||existingoptions.contains('41680342'))&& (spotrec.APTS_Product_Code__c == '37005072' || spotrec.APTS_Product_Code__c == '41680342'))))){
                        if(addtoCartMap.containsKey(spotrec.APTS_Product__c)){
                            attrValCombList = addtoCartMap.get(spotrec.APTS_Product__c);
                            attrValCombList.add(spotrec);
                        }else{
                            attrValCombList = new List<APTS_Attribute_Value_Combination__c>();
                            attrValCombList.add(spotrec);
                        }
                        addtoCartMap.put(spotrec.APTS_Product__c, attrValCombList);
                        system.debug('##### Add to Cart Map ----'+addtoCartMap);
                    }
                    }
                }else{
                    if(!((existingCombinationKeys.contains(productExist.id) && existingProducts.contains(productExist.APTS_Product__c))||((existingConfigDescription.contains(productExist.APTS_Configuration_Description__c) && (existingoptions.contains('37005004')||existingoptions.contains('37005005'))&& (productExist.APTS_Product_Code__c == '37005004' || productExist.APTS_Product_Code__c == '37005005'))||(existingConfigDescription.contains(productExist.APTS_Configuration_Description__c) && (existingoptions.contains('37005072')||existingoptions.contains('41680342')) && (productExist.APTS_Product_Code__c == '37005072' || productExist.APTS_Product_Code__c == '41680342'))))){  
                    if(addtoCartMap.containsKey(productExist.APTS_Product__c)){
                        attrValCombList = addtoCartMap.get(productExist.APTS_Product__c);
                        attrValCombList.add(productExist);
                    }else{
                        attrValCombList = new List<APTS_Attribute_Value_Combination__c>();
                        attrValCombList.add(productExist);
                    }
                        addtoCartMap.put(productExist.APTS_Product__c, attrValCombList);
                    }
                }
            }
        }else if(flag.equals('Yes') && ((!assetCheckMap.containsKey(assetKey) && productExist.APTS_Product_Code__c != '37005004' && productExist.APTS_Product_Code__c != '37005005' && productExist.APTS_Product_Code__c != '37005072' && productExist.APTS_Product_Code__c != '41680342') || (!(assetCheckMap.containsKey(assetKey) && (assetprodMap.get(assetKey) == '37005004' || assetprodMap.get(assetKey) == '37005005')) && (productExist.APTS_Product_Code__c == '37005004' || productExist.APTS_Product_Code__c == '37005005')) || (!(assetCheckMap.containsKey(assetKey) && (assetprodMap.get(assetKey) == '37005072' || assetprodMap.get(assetKey) == '41680342')) && (productExist.APTS_Product_Code__c == '37005072' || productExist.APTS_Product_Code__c == '41680342'))) && 
            productExist.APTS_Product__c != null && 
            productExist.APTS_CustomUI_Category__c != null && productExist.APTS_CustomUI_Category__c.equalsIgnoreCase('SpotLights')){
                if(!((existingCombinationKeys.contains(productExist.id) && existingProducts.contains(productExist.APTS_Product__c))||((existingConfigDescription.contains(productExist.APTS_Configuration_Description__c) && (existingoptions.contains('37005004')||existingoptions.contains('37005005'))&& (productExist.APTS_Product_Code__c == '37005004' || productExist.APTS_Product_Code__c == '37005005'))||(existingConfigDescription.contains(productExist.APTS_Configuration_Description__c) && (existingoptions.contains('37005072')||existingoptions.contains('41680342')) && (productExist.APTS_Product_Code__c == '37005072' || productExist.APTS_Product_Code__c == '41680342'))))){
                if(addtoCartMap.containsKey(productExist.APTS_Product__c)){
                    attrValCombList = addtoCartMap.get(productExist.APTS_Product__c);
                    attrValCombList.add(productExist);
                }else{
                    attrValCombList = new List<APTS_Attribute_Value_Combination__c>();
                    attrValCombList.add(productExist);
                }
                addtoCartMap.put(productExist.APTS_Product__c, attrValCombList);
                }
        }
    }
        system.debug('ProcessAttbValueCombs Between Time : >>>'+DateTime.now());
        for (Integer i = 0 ; i < keys.size(); i++) {
            // attributeMap.put(keys[i],values[i]);
            request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
            request.CartId = cartId;
            request.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
            request.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            request.SelectedBundle.SelectedProduct.ProductId = Label.FINDLAW_EXPOSURE_PACK;
            request.SelectedBundle.SelectedProduct.Quantity = 1;
            request.SelectedBundle.SelectedProduct.SellingTerm = 1;
            request.SelectedBundle.SelectedProduct.comments = 'Inserted via Ecommerce';
            
            newliSO = new Apttus_Config2__LineItem__c(Apttus_Config2__ChargeType__c= 'Subscription Fee',APTS_Combination_Key__c=keys[i],Apttus_Config2__SellingFrequency__c='Monthly',Apttus_Config2__PriceUom__c='Each',Apttus_Config2__PriceType__c='Recurring',Apttus_Config2__Frequency__c='Monthly',Apttus_Config2__Term__c=1,Apttus_Config2__BasePriceMethod__c='Per Unit',Apttus_Config2__PriceMethod__c='Per Unit',
            Apttus_Config2__IsCustomPricing__c=true, Apttus_Config2__AdjustmentAmount__c=values[i],Apttus_Config2__ProductVersion__c = 1);
                            
            request.SelectedBundle.SelectedProduct.CustomFields = customFields;
            request.SelectedBundle.SelectedProduct.CustomData = newliSO;
            mapOfRequests.put(keys[i], request);
        }

        attrValCombList = new List<APTS_Attribute_Value_Combination__c>();
        Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO result = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(pricelistId, Label.FINDLAW_EXPOSURE_PACK);
        system.debug('ProcessAttbValueCombs In Between Time : >>>'+DateTime.now());
        List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> prodOptGrpDOList = result.OptionGroups;

        List<Apttus_CPQApi.CPQ.SelectedOptionDO> options = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
        string optionProduct = '';

        List<String> customFieldsOptions = new List<String>{'Apttus_Config2__AdjustmentAmount__c','Apttus_Config2__AdjustmentType__c','Apttus_Config2__ChargeType__c','APTS_Combination_Key__c','Apttus_Config2__SellingFrequency__c','Apttus_Config2__PriceUom__c','Apttus_Config2__PriceType__c','Apttus_Config2__Frequency__c','Apttus_Config2__Term__c','Apttus_Config2__BasePriceMethod__c','Apttus_Config2__PriceMethod__c','Apttus_Config2__ConfigStatus__c','Apttus_Config2__PricingStatus__c','Apttus_Config2__ConstraintCheckStatus__c',
        'APTS_FL_Qty__c','Apttus_Config2__IsCustomPricing__c','APTS_Combination_Key__c'};

        Apttus_Config2__LineItem__c newliSOOptions = new Apttus_Config2__LineItem__c();
        APTS_Attribute_Value_Combination__c current_AttrValCombrec = new APTS_Attribute_Value_Combination__c();
        List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> prodOptCompDOList;
        for(Apttus_CPQApi.CPQ.ProductOptionGroupDO prodOptGrpDO: prodOptGrpDOList)
        {
            if(isOptionsAvailableOrNo && prodOptGrpDO.HasOptionComponents)
            {
                prodOptCompDOList = new List<Apttus_CPQApi.CPQ.ProductOptionComponentDO>();
                prodOptCompDOList = prodOptGrpDO.OptionComponents;
                for(Apttus_CPQApi.CPQ.ProductOptionComponentDO prodOptCompDO :prodOptCompDOList)
                {
                    optionProduct = prodOptCompDO.ComponentProductId;//SPOTLIGHT
                    if(addtoCartMap != null && addtoCartMap.containsKey(optionProduct))
                    {
                        attrValCombList = addtoCartMap.get(optionProduct);
                        if(!attrValCombList.isEmpty())
                        {
                            current_AttrValCombrec = attrValCombList.get(0);
                            Apttus_CPQApi.CPQ.SelectedOptionDO objSelectedOptionDO= new Apttus_CPQApi.CPQ.SelectedOptionDO();
                            objSelectedOptionDO.ComponentId = prodOptCompDO.ComponentId;
                            objSelectedOptionDO.ComponentProductId = current_AttrValCombrec.APTS_Product__c;
                            objSelectedOptionDO.Quantity = 1;
                            newliSOOptions = new Apttus_Config2__LineItem__c(Apttus_Config2__AdjustmentType__c = '% Discount',
                                Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__SellingFrequency__c = 'Monthly',
                                Apttus_Config2__PriceUom__c = 'Each',Apttus_Config2__PriceType__c = 'Recurring',
                                Apttus_Config2__Frequency__c = 'Monthly',Apttus_Config2__Term__c = 1,
                                Apttus_Config2__BasePriceMethod__c = 'Per Unit',Apttus_Config2__PriceMethod__c='Per Unit',
                                Apttus_Config2__IsCustomPricing__c = true,APTS_Combination_Key__c = current_AttrValCombrec.Id);
                            
                            objSelectedOptionDO.CustomFields = customFieldsOptions;
                            objSelectedOptionDO.CustomData = newliSOOptions;
                            options.add(objSelectedOptionDO);
                            if(addtoCartMap.get(optionProduct).size() > 0)
                            {
                                addtoCartMap.get(optionProduct).remove(0);
                            }                                
                        }
                    }
                }
            }
        }

        if(options.size() > 0){
            for(String combinationId : mapOfRequests.keySet())
            {
                request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
                request = mapOfRequests.get(combinationId);
                request.SelectedBundle.SelectedOptions = options;
                Cache.session.put('local.FindLawpaGeo.requestDO'+combinationId, request);
            }
            return true;
        }
        system.debug('@@@@@@@ processAttbValueCombs Exit Time >>> '+DateTime.now());

        return false;
    }

    @RemoteAction
    public static Decimal addToBundle(String combinationId){
        system.debug('###### Object Request Size....'+DateTime.now());
       
        Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
        if(Cache.session.contains('local.FindLawpaGeo.requestDO'+combinationId))
        {
            request = (Apttus_CPQApi.CPQ.AddBundleRequestDO) Cache.session.get('local.FindLawpaGeo.requestDO'+combinationId);
            if(!Test.isRunningTest()){
                Apttus_CPQApi.CPQ.AddBundleResponseDO response = Apttus_CPQApi.CPQWebService.addBundle(request);
                Cache.session.remove('local.FindLawpaGeo.requestDO'+combinationId);
                
                if(response != null){
                    system.debug('ProcessAttbValueCombs End Time : >>>'+DateTime.now());
                    isAddedSucessfullyExp = true;
                    return response.LineNumber;
                }
            }
        }
        return 0;
    }

    @RemoteAction
    public static boolean getToCart(String cartId){
        system.debug('getToCart $$ : '+cartId);
        if(!Test.isRunningTest()){
            system.debug('#### Get To Cart Start Time :'+DateTime.now());
            Apttus_CPQApi.CPQWebService.associateConstraintRules(cartId, null);
            system.debug('### After Associating Constraint Rules :'+DateTime.now());
            Apttus_CPQApi.CPQWebService.applyConstraintRules(cartId, false);
            system.debug('#### Get To Cart End Time :'+DateTime.now());
        }
        return true;
    }
    
    @RemoteAction
    public static APTS_Attribute_Value_Combination__c getPriceForExposurePack1(String productId,String productCode,List<String> attribute0,List<String> attribute1,List<String> attribute2){
        system.debug('Controller getPriceForExposurePack method is called...!!!');
        List<String> attributelist = new List<String>();
        
        Set<String> setOfAttributes = new Set<String>();
        setOfAttributes.addAll(attribute1);
        setOfAttributes.remove('');
        setOfAttributes.remove(null);

        for(String attributevalue1 :attribute1){
            if(attributevalue1!=null && attributevalue1!=''){
                attributelist.add(attributevalue1);
            }
        }
        attribute1 = attributelist;
        attributelist = new List<String>();
        system.debug('Attribute 1 :'+attribute1);
        
        for(String attributevalue2 : attribute2){
            if(attributevalue2!=null && attributevalue2!=''){
                attributelist.add(attributevalue2);
            }
        }
        attribute2 = attributelist;
        attributelist = new List<String>();
        system.debug('Attribute 2 :'+attribute2);
        List<APTS_Attribute_Value_Combination__c> listOfAttrbCombination = new List<APTS_Attribute_Value_Combination__c>();
        
        APTS_Attribute_Value_Combination__c objAttributeCombination = new APTS_Attribute_Value_Combination__c();
        if (Schema.sObjectType.APTS_Attribute_Value_Combination__c.isAccessible()){
            if(attribute0 != null && attribute1 != null && attribute2 != null){
                listOfAttrbCombination = [SELECT Id, APTS_Exposure_Pack_Disc__c, APTS_Attribute_Value3__c   
                                            FROM APTS_Attribute_Value_Combination__c 
                                           WHERE APTS_Product__c=:productId 
                                           AND APTS_Attribute_Value0__c =:attribute0 
                                           AND APTS_Attribute_Value2__c =:attribute1 
                                           AND APTS_Attribute_Value3__c=:attribute2];
                
                if(listOfAttrbCombination != null && !listOfAttrbCombination.isEmpty())
                {
                    objAttributeCombination = listOfAttrbCombination.get(0);
                }
            }
            system.debug('##### Attb Combination Object ---'+objAttributeCombination);
        }
        
        return objAttributeCombination;
    }

    @RemoteAction
    public static List<APTS_Attribute_Value_Combination__c> getPriceForExposurePack2(List<String> attribute4,List<String> attribute5,List<String> attribute6){
        system.debug('Controller getPriceForExposurePack 2 method is called...!!!');
        List<String> attributelist = new List<String>();        
        for(String attributevalue4 :attribute4){
            if(attributevalue4!=null && attributevalue4!=''){
                attributelist.add(attributevalue4.replace('&amp;','&'));
            }
        }
        attribute4 = attributelist;
        attributelist = new List<String>();
        
        for(String attributevalue5 :attribute5){
            if(attributevalue5!=null && attributevalue5!=''){
                attributelist.add(attributevalue5.replace('&amp;','&'));
            }          
        }
        attribute5 = attributelist;
        attributelist = new List<String>();
        
        for(String attributevalue6 :attribute6 ){
            if(attributevalue6!=null && attributevalue6!=''){
                attributelist.add(attributevalue6.replace('&amp;','&'));
            }
        }
        attribute6 = attributelist;
        attributelist = new List<String>();

        List<APTS_Attribute_Value_Combination__c> metroNames = new List<APTS_Attribute_Value_Combination__c>();
        if (Schema.sObjectType.APTS_Attribute_Value_Combination__c.isAccessible()){
            metroNames = [SELECT Attribute1_Name__c FROM APTS_Attribute_Value_Combination__c 
                                                                WHERE APTS_CustomUI_Category__c = 'TopSpots'
                                                                AND Attribute0_Name__c =:attribute4
                                                                AND Attribute2_Name__c =:attribute5
                                                                AND Attribute3_Name__c =:attribute6
                                                                AND APTS_Inventory_Available__c = 0
                                                                AND APTS_Product_Name__c LIKE '%FINDLAW DIRECTORY%'];
            system.debug('List of Metro Names >>>>'+metroNames);
        }
        return metroNames;
    }
  
    @RemoteAction
    public static Map<String,Decimal> getPriceForExposurePack3(List<APTS_Attribute_Value_Combination__c> metroNames, List<String> attribute3,List<String> attribute4,List<String> attribute5,List<String> attribute6, APTS_Attribute_Value_Combination__c objAttbCombination){
        system.debug('Controller getPriceForExposurePack 3 method is called...!!!');
        List<String> attributelist = new List<String>();

        for(String attributevalue3 :attribute3){
            if(attributevalue3!=null && attributevalue3!=''){
                attributelist.add(attributevalue3);
            }
        }
        attribute3 = attributelist;
        attributelist = new List<String>();
        
        for(String attributevalue4 :attribute4){
            if(attributevalue4!=null && attributevalue4!=''){
                attributelist.add(attributevalue4.replace('&amp;','&'));
            }
        }
        attribute4 = attributelist;
        attributelist = new List<String>();
        
        for(String attributevalue5 :attribute5){
            if(attributevalue5!=null && attributevalue5!=''){
                attributelist.add(attributevalue5.replace('&amp;','&'));
            }          
        }
        attribute5 = attributelist;
        attributelist = new List<String>();
        
        for(String attributevalue6 :attribute6){
            if(attributevalue6!=null && attributevalue6!=''){
                attributelist.add(attributevalue6.replace('&amp;','&'));
            }
        }
        attribute6 = attributelist;
        attributelist = new List<String>();
        
        decimal finalPrice = 0;
        String[] stringList = new String[]{};
        List<AggregateResult> priceList = new List<AggregateResult>();
        Map<String,Decimal> finalMap = new Map<String,Decimal>();
        if (Schema.sObjectType.APTS_Attribute_Value_Combination__c.isAccessible()){
            if(attribute3[0] == 'No'){
                system.debug('--- Checking Exposure Pack Metro Names >>> '+metroNames);
                if(metroNames != null && !metroNames.isEmpty())
                {
                    for(APTS_Attribute_Value_Combination__c metroName : metroNames){
                        stringList.add(metroName.Attribute1_Name__c);
                    }
                }
                
                priceList = [SELECT SUM(APTS_Price__c)fnlPrc FROM APTS_Attribute_Value_Combination__c where IsMetro__c = FALSE 
                                                                                    AND Attribute0_Name__c =:attribute4
                                                                                    AND Attribute2_Name__c =:attribute5
                                                                                    AND Attribute3_Name__c=:attribute6
                                                                                    AND ((APTS_CustomUI_Category__c = 'TopSpots' 
                                                                                    AND APTS_Inventory_Available__c != 0) 
                                                                                    OR (APTS_CustomUI_Category__c = 'SpotLights' 
                                                                                    AND Attribute1_Name__c=:stringList))
                                                                                    AND APTS_Product_Name__c LIKE '%FINDLAW DIRECTORY%'
                                                                                    ];
            }else if(attribute3[0] == 'Yes'){
                system.debug('Yessss --- condition');
                priceList = [SELECT SUM(APTS_Price__c)fnlPrc FROM APTS_Attribute_Value_Combination__c where IsMetro__c = FALSE 
                                                                                    AND APTS_CustomUI_Category__c = 'SpotLights' 
                                                                                    AND Attribute0_Name__c=:attribute4
                                                                                    AND Attribute2_Name__c=:attribute5
                                                                                    AND Attribute3_Name__c=:attribute6
                                                                                    AND APTS_Product_Name__c LIKE '%FINDLAW DIRECTORY%'];
            }
            finalPrice = (Decimal)priceList[0].get('fnlPrc');
            system.debug('Final Price :'+finalPrice);
            if(objAttbCombination != null){
                if(finalPrice != null && objAttbCombination.APTS_Exposure_Pack_Disc__c != null)
                {
                    finalPrice = finalPrice*(1-(0.01*objAttbCombination.APTS_Exposure_Pack_Disc__c));
                    if(finalPrice!=null){
                        finalMap.put(objAttbCombination.APTS_Attribute_Value3__c, finalPrice);
                    }
                }
            }
        }
        return finalMap;
    }
    
    public pageReference returnToCart(){
        
          pageReference pageRef = new pagereference('/apex/Apttus_Config2__Cart');
          pageRef.getParameters().put('configRequestId',configRequestId);          
          pageRef.getParameters().put('id',productConfig);          
          pageRef.getParameters().put('flow', 'flcpq#/cart');          
          pageRef.setRedirect(true);
          return pageRef;
    }

    public pageReference goToCart(){
        system.debug('Go to Cart method is called...!!!');
        pageReference pageRef = new pagereference('/apex/Apttus_Config2__Cart');
        pageRef.getParameters().put('configRequestId',configRequestId);
        pageRef.getParameters().put('id',productConfig);          
        pageRef.getParameters().put('flow', 'flcpq#/cart');          
        pageRef.setRedirect(true);
        system.debug('PageRef :'+pageRef);
        return pageRef;
    }
            
   public pageReference exit(){
          system.debug('i am here');
          pageReference pageRef = new pagereference('/apex/Apttus_Config2__Cart');
          pageRef.getParameters().put('configRequestId',configRequestId);
          pageRef.getParameters().put('id',productConfig);
          pageRef.getParameters().put('flow', 'flcpq#/cart');
          pageRef.setRedirect(true);
          return pageRef;
    }   
        
    public pageReference cancel2(){
        system.debug('Cancel2 method is called!');
        pageReference pageRef = new pagereference('/apex/Apttus_Config2__Cart');
        pageRef.getParameters().put('configRequestId',configRequestId);
        pageRef.getParameters().put('id',productConfig);
        pageRef.getParameters().put('flow', 'flcpq'); 
        pageRef = new pageReference(pageRef.getURL()+'#!/catalog');
        pageRef.setRedirect(true);
        return pageRef;
    }
            
    public pageReference cancel(){
          
          pageReference pageRef = new pagereference('/apex/Apttus_Config2__Cart');
          pageRef.getParameters().put('configRequestId',configRequestId);
          pageRef.getParameters().put('id',productConfig);
          pageRef.getParameters().put('flow', 'flcpq');          
          //Added by Apttus Support (Managed service) || case : CAS-01684-D8Y7T1 || Date : 24-04-2018 || Desc : Unable to Redirect to Catalog page on click of custom button
          pageRef = new pageReference(pageRef.getURL()+'#!/catalog');
          pageRef.setRedirect(true);
          return pageRef;
            }   
    //Wrapper class- Added by Sakshi
    public class AttrValCombinationUI{
        public APTS_Attribute_Value_Combination__c attributeValueInstance{get;set;}  
        public boolean isInstalled{get;set;}  
    }

    /*
     *  @Chintan
     *  This method checks if the selected Attribute Value Combination Record is present in Cart
     *  If present, we pass the list to attributeValueCombination
     */
    @RemoteAction
    public static Boolean addingProductsToCart(List<APTS_Attribute_Value_Combination__c> listOfAttrValCombination, String isSpotlightOnly){
        system.debug('1111 AddingProductsToCart > listOfAttrValCombination Size ----'+listOfAttrValCombination.size());
        String productId = '';
        String attribute0 = '';
        String attribute2 = '';
        Set<Id> setOfCombinationIdToRemove = new Set<Id>();
        Set<Id> setOfCombinationIds = new Set<Id>();
        List<String> setOfAttribute3 = new List<String>();
        Map<Id, APTS_Attribute_Value_Combination__c> mapOfAttbCombinations = new Map<Id, APTS_Attribute_Value_Combination__c>();

        if(!listOfAttrValCombination.isEmpty())
        {
            productId = listOfAttrValCombination[0].APTS_Product__c;
            attribute0 = listOfAttrValCombination[0].Attribute1_Name__c;
            attribute2 = listOfAttrValCombination[0].Attribute2_Name__c.replace('&amp;','&');
            attribute2 = attribute2.replace('&#39;','\'');
            
            mapOfAttbCombinations.putAll(listOfAttrValCombination);
            
            if (Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()){
                for(Apttus_Config2__LineItem__c objLineItem : [select Id, APTS_Combination_Key__c from Apttus_Config2__LineItem__c 
                                                            Where Apttus_Config2__ConfigurationId__c=:configId 
                                                            and APTS_Combination_Key__c IN :mapOfAttbCombinations.keySet() 
                                                            AND Apttus_Config2__ProductId__c=:productId])
                {
                    setOfCombinationIdToRemove.add(objLineItem.APTS_Combination_Key__c);
                }
            }
            
        }

        if(!setOfCombinationIdToRemove.isEmpty())
        {
            for(Id removeKey : mapOfAttbCombinations.keySet())
            {
                if(setOfCombinationIdToRemove.contains(removeKey))
                {
                    mapOfAttbCombinations.remove(removeKey);
                }
            }
        }else{
            for(APTS_Attribute_Value_Combination__c objAttbValComb : listOfAttrValCombination)
            {
                objAttbValComb.Attribute3_Name__c=objAttbValComb.Attribute3_Name__c.replace('&amp;','&');
                objAttbValComb.Attribute3_Name__c=objAttbValComb.Attribute3_Name__c.replace('&#39;','\'');
                setOfAttribute3.add(objAttbValComb.Attribute3_Name__c);
            }
        }

        if(!setOfAttribute3.isEmpty())
        {
            //String customUI = '';
            List<String> customUI = new List<String>();
            if(isSpotlightOnly != null && isSpotlightOnly.equals('Yes'))
            {
                customUI.add('SpotLights');
            }else if(isSpotlightOnly != null && isSpotlightOnly.equals('No'))
            {
                customUI.add('TopSpots');
                customUI.add('SpotLights');
            }
            if(!customUI.equals(''))
            {
                List<Product2> listOfProducts = new List<Product2>([Select ID from Product2 where Name LIKE 'FINDLAW DIRECTORY%' AND APTS_CustomUI_Category__c IN :customUI]);
                system.debug('@@@ Products List Size >>>'+listOfProducts.size());
                if(listOfProducts != null && !listOfProducts.isEmpty())
                {
                    List<APTS_Attribute_Value_Combination__c> listOfAttributeCombinations = [SELECT Id,APTS_Exposure_Pack_Disc__c,APTS_Configuration_Description__c,APTS_CustomUI_Category__c, APTS_Product_Name__c, APTS_Product__c,APTS_Inventory_Available__c, IsMetro__c,Attribute1_Name__c, 
                                                                    Attribute2_Name__c,Attribute3_Name__c,APTS_Product_Code__c
                                                                    FROM APTS_Attribute_Value_Combination__c 
                                                                                    where Attribute3_Name__c IN :setOfAttribute3 
                                                                                    AND Attribute0_Name__c =:attribute0 AND IsMetro__c = false 
                                                                                    AND APTS_Product__c IN :listOfProducts
                                                                                    AND Attribute2_Name__c =:attribute2];
    
                    Cache.session.put('local.FindLawpaGeo.listOfAttributeValueCombs', listOfAttributeCombinations);
                    return true;
                }
            }

            return false;
        }

        return false;
    }
    
    // Added this method after APTTUS changes
    @RemoteAction
    public static List<Boolean> addToCart(List<String> selectedProductDetails){
        List<Boolean> result = new List<Boolean>();
        System.debug('CPU Time Utilized before constructing List: '+Limits.getCpuTime());
        List<LineItemWrapper> lineItemWrapperList = new List<LineItemWrapper>();
        List<Id> combinationIds = new List<Id>();
        //Convert JSON to wrapper
        for(String selectedProd : selectedProductDetails){
            LineItemWrapper liWrapper = new LineItemWrapper();
            liWrapper = (LineItemWrapper) System.JSON.deserializeStrict(selectedProd,LineItemWrapper.class);
            lineItemWrapperList.add(liWrapper);
            combinationIds.add(liWrapper.combinationKey);
        }
        Map<Id,APTS_Attribute_Value_Combination__c> prodmap = new Map<Id,APTS_Attribute_Value_Combination__c>([SELECT Id, APTS_Product_Code__c FROM APTS_Attribute_Value_Combination__c where Id IN: combinationIds]);
        Id cartId = lineItemWrapperList[0].cartId;
        
        List<String> existingCombinationKeys = new List<String>();
        List<String> existingProducts = new List<String>();
        List<String> existingoptions = new List<String>();
        List<String> existingConfigDescription = new List<String>();
        
        
        //Check existing line items has same combination key and product id 
        Decimal maxLineItemNumber = 0;
        for(Apttus_Config2__LineItem__c li: [SELECT Id,Apttus_Config2__OptionId__c,Apttus_Config2__OptionId__r.ProductCode,Apttus_Config2__ProductId__c,APTS_Combination_Key__c,APTS_Combination_Key__r.APTS_Configuration_Description__c,Apttus_Config2__ConfigurationId__c, 
                                        Apttus_Config2__LineNumber__c FROM Apttus_Config2__LineItem__c
                                        WHERE Apttus_Config2__ConfigurationId__c=:cartID ORDER BY Apttus_Config2__LineNumber__c]){
                                            
            //Last line item number
            maxLineItemNumber = li.Apttus_Config2__LineNumber__c;
            existingCombinationKeys.add(li.APTS_Combination_Key__c);
            existingProducts.add(li.Apttus_Config2__ProductId__c);
            if((li.Apttus_Config2__OptionId__r.ProductCode=='37005004' || li.Apttus_Config2__OptionId__r.ProductCode=='37005005'||li.Apttus_Config2__OptionId__r.ProductCode=='37005072'||li.Apttus_Config2__OptionId__r.ProductCode=='41680342') &&(li.Apttus_Config2__OptionId__c!=null)){
                existingoptions.add(li.Apttus_Config2__OptionId__r.ProductCode);
                existingConfigDescription.add(li.APTS_Combination_Key__r.APTS_Configuration_Description__c);
            }
            else{
            existingoptions.add('');
            existingConfigDescription.add('');
            }
            
        }
        
        System.debug('existingoptions: '+existingoptions);
        System.debug('existingConfigDescription: '+existingConfigDescription);
        System.debug('maxLineItemNumber: '+maxLineItemNumber);
        
        Map<Decimal,String> lineNumberCombinationKeyMap = new Map<Decimal, String>();
        Map<Decimal,String> lineNumberAttorneyMap = new Map<Decimal, String>();        
        
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO addMultiProdRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        addMultiProdRequest.cartId = cartId;
        addMultiProdRequest.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
        
        Decimal index = maxLineItemNumber+1;
        boolean callAPI = false;
        
        for(LineItemWrapper li: lineItemWrapperList){
            System.debug('li.ConfigurationDescription: '+li.ConfigurationDescription);
            //Skip the line item which matches existing line items 
            if((existingCombinationKeys.contains(li.combinationKey) && existingProducts.contains(li.productId)) || ((existingConfigDescription.contains(li.ConfigurationDescription) && (existingoptions.contains('37005004')||existingoptions.contains('37005005')) && (prodmap.get(li.combinationKey).APTS_Product_Code__c == '37005004'|| prodmap.get(li.combinationKey).APTS_Product_Code__c == '37005005'))||(existingConfigDescription.contains(li.ConfigurationDescription) && (existingoptions.contains('37005072')||existingoptions.contains('41680342')) && (prodmap.get(li.combinationKey).APTS_Product_Code__c == '37005072'|| prodmap.get(li.combinationKey).APTS_Product_Code__c == '41680342')))){
                result.add(false);
                continue;
            }
            //Set callAPI true if line does not match existing line items 
            callAPI = true;         
            result.add(true);
            
            //Map with line item number and combination key to update newly created line items 
            lineNumberCombinationKeyMap.put(index, li.combinationKey);
            lineNumberAttorneyMap.put(index,li.attorney);
            index++;
            
            //Construct request object
            Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();             
            Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();            
            selectedProduct.productId = li.productId;
            selectedProduct.Quantity = 1;        
            selectedProduct.comments = 'Inserted via Ecommerce';       
            List<String> customFields = new List<String>();
            customFields.add('Apttus_Config2__ChargeType__c'); 
            customFields.add('APTS_Combination_Key__c');
            customFields.add('Apttus_Config2__SellingFrequency__c');
            customFields.add('Apttus_Config2__PriceUom__c');
            customFields.add('Apttus_Config2__PriceType__c');
            customFields.add('Apttus_Config2__Frequency__c');
            customFields.add('Apttus_Config2__Term__c');
            customFields.add('Apttus_Config2__BasePriceMethod__c');
            customFields.add('Apttus_Config2__PriceMethod__c');  
            customFields.add('Apttus_Config2__IsCustomPricing__c');
            customFields.add('Apttus_Config2__ConfigStatus__c');
            customFields.add('Apttus_Config2__PricingStatus__c');
            customFields.add('Apttus_Config2__ConstraintCheckStatus__c');         
            customFields.add('APTS_FL_Qty__c');      
            selectedProduct.CustomFields = customFields;       
            customData.Apttus_Config2__ChargeType__c= 'Subscription Fee'; 
            customData.APTS_Combination_Key__c=li.combinationKey;
            customData.Apttus_Config2__SellingFrequency__c='Monthly';
            customData.Apttus_Config2__PriceUom__c='Each';
            customData.Apttus_Config2__PriceType__c='Recurring';
            customData.Apttus_Config2__Frequency__c='Monthly';
            customData.Apttus_Config2__Term__c=1;
            customData.Apttus_Config2__BasePriceMethod__c='Per Unit';
            customData.Apttus_Config2__PriceMethod__c='Per Unit';  
            customData.Apttus_Config2__IsCustomPricing__c= true;
                   
            selectedProduct.CustomData = customData; 
            addMultiProdRequest.selectedProducts.add(selectedProduct);          
        }
        
        System.debug('CPU Time Utilized before Calling API: '+Limits.getCpuTime());
        
        if(callAPI){
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO addMultiProdResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(addMultiProdRequest);
            system.debug('addMultiProdResponse SP'+addMultiProdResponse); 
            
            System.debug('CPU Time Utilized after Calling API: '+Limits.getCpuTime());
            
            //Populate combination key on newly created Line Items- Begins 
            List<Apttus_Config2__LineItem__c> liToBeUpdated = new List<Apttus_Config2__LineItem__c>();
            for(Apttus_Config2__LineItem__c li: [SELECT Id,Apttus_Config2__LineNumber__c FROM Apttus_Config2__LineItem__c 
                                            WHERE Apttus_Config2__ConfigurationId__c =: cartID AND Apttus_Config2__LineNumber__c >: maxLineItemNumber]){
                                                            
                if(lineNumberCombinationKeyMap.containsKey(li.Apttus_Config2__LineNumber__c) && lineNumberCombinationKeyMap.get(li.Apttus_Config2__LineNumber__c) != NULL){
                    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
                    lineItem.Id = li.Id;
                    lineItem.APTS_Combination_Key__c = lineNumberCombinationKeyMap.get(li.Apttus_Config2__LineNumber__c);
                    if(lineNumberAttorneyMap.containsKey(li.Apttus_Config2__LineNumber__c) && lineNumberAttorneyMap.get(li.Apttus_Config2__LineNumber__c) != NULL){
                        lineItem.APTS_FL_Qty__c= Decimal.valueOf(lineNumberAttorneyMap.get(li.Apttus_Config2__LineNumber__c));
                    }
                    
                    lineItem.Apttus_Config2__ChargeType__c= 'Subscription Fee'; 
                    lineItem.Apttus_Config2__SellingFrequency__c='Monthly';
                    lineItem.Apttus_Config2__PriceUom__c='Each';
                    lineItem.Apttus_Config2__PriceType__c='Recurring';
                    lineItem.Apttus_Config2__Frequency__c='Monthly';
                    lineItem.Apttus_Config2__Term__c=1;
                    lineItem.Apttus_Config2__BasePriceMethod__c='Per Unit';
                    lineItem.Apttus_Config2__PriceMethod__c='Per Unit';  
                    lineItem.Apttus_Config2__IsCustomPricing__c= true;    


                    lineItem.Apttus_Config2__ConfigStatus__c= 'Pending'; 
                    lineItem.Apttus_Config2__PricingStatus__c= 'Pending'; 
                    liToBeUpdated.add(lineItem);
                }                      
            }
            if(liToBeUpdated.size()>0){
                Database.update(liToBeUpdated);
            }
            //Populate combination key on newly created Line Items- Ends
            
            System.debug('CPU Time Utilized after update Line Item: '+Limits.getCpuTime());

            if(!Test.isRunningTest()){
                Apttus_CPQApi.CPQWebService.associateConstraintRules(cartId, null);
                Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, false);                         
            }
            
            System.debug('CPU Time Utilized After constraint Rule run: '+Limits.getCpuTime()); 
            //Check whether API response
            if(addMultiProdResponse != null && addMultiProdResponse.LineNumbers != null && addMultiProdResponse.LineNumbers.size() > 0){
                return result;
            }else{
                result.clear();
                //Return false if API response is null
                for(LineItemWrapper li: lineItemWrapperList){
                    result.add(false);
                }               
            } 
            return result;                      
        }
        //The below line will be executed only if all the selected products matches existing line items 
        return result;
    }
   
    // Added after APTTUS changes
    @RemoteAction
    public static Boolean addConstraintRules(Id cartId){
    
        Apttus_CPQApi.CPQWebService.associateConstraintRules(cartId, null);
        Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, false);
        return true;
    }

    // Added after APTTUS changes
    public class LineItemWrapper{
        public String productId;
        public String combinationKey;
        public String ConfigurationDescription;
        public String cartId;
        public String attorney;
        public String apiName;      
 
    }

}