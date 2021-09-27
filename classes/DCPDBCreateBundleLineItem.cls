/********************************************************************************
Class Name : DCPDBPopulateLineItemsDetails                          
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             DCPDBPopulateLineItemsDetails                          Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/

public without sharing class DCPDBCreateBundleLineItem{
    
    public static id cartId ;    
      /**
        @description
        @param cartIDToLineItemsMap
        @param plimap
     */   
    public static void createDynamicBundleLineItem(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap,Map<String,Apttus_Config2__PriceListItem__c> plimap){

        //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here
        cartId = DCPDynamicBundling.objectCart.id;
        List<String> btemplist = new List<String>();
        btemplist = getBundleList(cartIDToLineItemsMap,cartId);
        //This is code for creating the Dynamic Bundle line item can calling Apttus
        System.debug(LoggingLevel.DEBUG,'plimap'+plimap);
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        request.CartId = cartId;
        System.debug(LoggingLevel.DEBUG,'Testdata1'+request.CartId);
        System.debug(LoggingLevel.DEBUG,'cartId'+cartId);
        Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
        Boolean callapi = false;
        for(String str : DCPDynamicBundling.cartToBundleData.get(cartId).bundles.keySet()){
            if(btemplist != null && !btemplist.contains(str)){
                String temp = str.substringAfter(':');
                if(!plimap.isEmpty() && plimap.get(temp) != null && !(DCPDynamicBundling.cartToBundleData.get(cartId).isNotNewLineItem)){
                    selectedProduct.ProductId = plimap.get(temp).Apttus_Config2__ProductId__c;
                    System.debug(LoggingLevel.DEBUG,'Testdata2'+selectedProduct.ProductId);
                    selectedProduct.Quantity = 1;
                    selectedProduct.SellingTerm = 12; 
                    Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c(); 
                    List<String> customFields = new List<String>{'Apttus_Config2__Uom__c','Apttus_Config2__ChargeType__c','Apttus_Config2__SellingFrequency__c','Apttus_Config2__PriceUom__c','Apttus_Config2__PriceType__c','Apttus_Config2__Frequency__c','Apttus_Config2__Term__c','Apttus_Config2__BasePriceMethod__c','Apttus_Config2__PriceMethod__c','Apttus_Config2__LineStatus__c','apts_keep_terms__c'};
                    selectedProduct.CustomFields = customFields;      
                    customData.Apttus_Config2__ChargeType__c= plimap.get(temp).Apttus_Config2__ChargeType__c; 
                    customData.Apttus_Config2__SellingFrequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
                    customData.Apttus_Config2__PriceType__c=plimap.get(temp).Apttus_Config2__PriceType__c;
                    customData.Apttus_Config2__Frequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
                    customData.Apttus_Config2__Term__c=1;
                    customData.Apttus_Config2__BasePriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c;
                    customData.Apttus_Config2__PriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c;  
                    customData.Apttus_Config2__LineStatus__c='New';
                    customdata.apts_keep_terms__c = DCPDynamicBundling.bundlewrapper.isKeepTerms ;
                    System.debug(LoggingLevel.DEBUG,selectedProduct);
                    System.debug(LoggingLevel.DEBUG,customData);
                    selectedProduct.CustomData = customData; 
                    request.SelectedProducts.add(selectedProduct);
                    System.debug(LoggingLevel.DEBUG,'request'+request);
                    
                    callapi = true;
                }
            }
        }
        callApttusAddMultipleProduct(cartId,request,callapi);
        //End of dynamic bundle/ calling apttus logic
        
    }
    
    private static List<string> getBundleList(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap,Id configId ){

        List<String> btemplist = new List<String>();
        for(Apttus_Config2__LineItem__c ln: cartIDToLineItemsMap.get(configId)){
            String bundle = '';
            System.debug(LoggingLevel.DEBUG,ln.APTS_Product_Group_Primary_Material__c +'product code' + ln.APTS_Product_Code__c);
            if(ln.APTS_Product_Group_Primary_Material__c != null){
                bundle = ln.APTS_Group_Primary_Material_Name__c+';'+ln.APTS_Group__c+':'+ln.APTS_Product_Group_Primary_Material__c.substringAfter(':');
            }
            if(ln.APTS_Product_Group_Primary_Material__c != null && ln.APTS_Product_Group_Primary_Material__c.substringAfter(':') == ln.APTS_Product_Code__c){
                btemplist.add(bundle);           
            }
        }
        return btemplist;
    }
    
    private static void callApttusAddMultipleProduct(Id configId, Apttus_CPQApi.CPQ.AddMultiProductRequestDO request,Boolean callapi ){
        /*
        if(callapi == true && !Test.isRunningTest()){
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            DCPDynamicBundlingHelper.updateLineItemFields(configId,request.SelectedProducts);
        }*/
        
        if(callapi == true){
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            
            //Code should no longer be needed as new Apttus package has been
            //DCPDynamicBundlingHelper.updateLineItemFields(configId,request.SelectedProducts);
        }
    }
    
      /**
        @description
        @param 
        @return 
     */   

    public static Map<String,Apttus_Config2__PriceListItem__c> getPrceListItem(){
        cartId = DCPDynamicBundling.objectCart.id;
        Set<String> productCodes = new Set<String>();
        List<Apttus_Config2__PriceListItem__c> plis = new List<Apttus_Config2__PriceListItem__c>();
        Map<String,Apttus_Config2__PriceListItem__c> plimap = new Map<String,Apttus_Config2__PriceListItem__c>();
        
        productCodes.addAll(DCPDynamicBundling.cartToBundleData.get(cartId).prdcode);
        
        if(!productCodes.isEmpty()){
            plis = [Select Id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductCode__c,Apttus_Config2__ProductName__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__Frequency__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__ChargeType__c,Apttus_Config2__ListPrice__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductCode__c IN: productCodes AND Apttus_Config2__PriceType__c != 'One Time'];
        }
        for(Apttus_Config2__PriceListItem__c str : plis){
            plimap.put(str.Apttus_Config2__ProductCode__c,str);
        }

        return plimap;
    }
}