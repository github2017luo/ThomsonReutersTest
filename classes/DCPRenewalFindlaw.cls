/********************************************************************************
Class Name : DCPRenewalFindlaw
@description : This class is used by DCPGetRenewal class to populate findlaw product JSON data.
***************************************************************************************

Modification Details
Date              Description                                                              Owner
26/07/2021        Class Created                                                            By Herin Acharya
08/09/2021        Added 'contractNumbers' variable                                         Benjamin Her
*********************************************************************************/

public without sharing class DCPRenewalFindlaw{
    
    // DCPFindlawProductsWrapper
    /**
    @description Retrieves Findlaw product details from the associated cart
    @param cartId which related products needs to be retrieved
    @return DCPFindlawProductsWrapper
    */ 
    public static list<DCPFindlawProductsWrapper> getFindlawProducts(id cartId){
        
        list<DCPFindlawProductsWrapper> listFindlawWrapper;
        
        List<Apttus_Config2__LineItem__c> retrievedLineItems = new List<Apttus_Config2__LineItem__c>();
        
        //retrieve lineitems by cart id
        retrievedLineItems = DCPCart.getCartLineItems(cartId);
        
        //get the map of prouduct name to line items
        Map<string,list<Apttus_Config2__LineItem__c>> mapOfProductToLineItems = getMapOfProductToLineItems(retrievedLineItems);
        
        //Populate FindlawProductWrapper
        listFindlawWrapper = populateFindlawProductDetails(mapOfProductToLineItems);
        return listFindlawWrapper;
        
    }
       
    private static map<string,list<Apttus_Config2__LineItem__c>> getMapOfProductToLineItems(list<Apttus_Config2__LineItem__c> retrievedLineItems){
        
        Map<string,list<Apttus_Config2__LineItem__c>> mapOfProductToLineItems = new Map<string,list<Apttus_Config2__LineItem__c>>();
        list<Apttus_Config2__LineItem__c> tempListOfLineItems;
        
        //Prepare the map of prouduct name to line items
        for(Apttus_Config2__LineItem__c objCartLineItem : retrievedLineItems){
            tempListOfLineItems= new list<Apttus_Config2__LineItem__c>();
            if(mapOfProductToLineItems.containsKey(objCartLineItem.Apttus_Config2__ProductId__r.name)){
                tempListOfLineItems = mapOfProductToLineItems.get(objCartLineItem.Apttus_Config2__ProductId__r.name);
                tempListOfLineItems.add(objCartLineItem);
                mapOfProductToLineItems.put(objCartLineItem.Apttus_Config2__ProductId__r.name,tempListOfLineItems);
            }else{
                tempListOfLineItems.add(objCartLineItem);
                mapOfProductToLineItems.put(objCartLineItem.Apttus_Config2__ProductId__r.name,tempListOfLineItems);
            }
        }
        
        return mapOfProductToLineItems;
    }
    
    //DCPFindlawProductsWrapper 
    private static list<DCPFindlawProductsWrapper> populateFindlawProductDetails(Map<string,list<Apttus_Config2__LineItem__c>> mapOfProductToLineItems ){
         
         list<DCPFindlawProductsWrapper> listFindlawWrapper = new list<DCPFindlawProductsWrapper>();
         DCPFindlawProductsWrapper objFindlawWrapper;
         
         for(String key : mapOfProductToLineItems.keyset()){
             objFindlawWrapper = new DCPFindlawProductsWrapper();
             objFindlawWrapper.isEdge = false;
             objFindlawWrapper.contractNumbers = new List<String>();
                                
             decimal totalNetPrice = 0;
             List<DCPFindlawProductsWrapper.FindlawSubProducts> listSubProducts = new List<DCPFindlawProductsWrapper.FindlawSubProducts>();
             
             for(Apttus_Config2__LineItem__c lineItem : mapOfProductToLineItems.get(key)){
                 
                objFindlawWrapper.productId = lineItem.Apttus_Config2__ProductId__c; 
                totalNetPrice =  totalNetPrice + lineItem.Apttus_Config2__NetPrice__c;
                objFindlawWrapper.productName = lineItem.Apttus_Config2__ProductId__r.name;
                objFindlawWrapper.materialNumber = lineItem.Apttus_Config2__ProductId__r.productcode;
                objFindlawWrapper.qualifier = lineItem.APTS_Product_Pricing_Model__c != null? lineItem.APTS_Product_Pricing_Model__c : 'Banded';
                if(lineItem.APTS_Contract_Number__c != null){
                    objFindlawWrapper.contractNumbers.add(String.valueOf(lineItem.APTS_Contract_Number__c));
                }
                populateListSubProduct(lineItem,listSubProducts);
   
             }
             
             if(listSubProducts!= null && !listSubProducts.isEmpty()){
                 objFindlawWrapper.listSubProducts = listSubProducts;
             }
             
             objFindlawWrapper.price = totalNetPrice;
             listFindlawWrapper.add(objFindlawWrapper);
         }
         
         return listFindlawWrapper;         
    }

    private static void populateListSubProduct(Apttus_Config2__LineItem__c lineItem,List<DCPFindlawProductsWrapper.FindlawSubProducts> listSubProducts){
        if(!String.isBlank(lineItem.APTS_Combination_Key__c)){
        
            DCPFindlawProductsWrapper.FindlawSubProducts objSubProduct= new DCPFindlawProductsWrapper.FindlawSubProducts();                    
            objSubProduct.practiceArea = lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.name;
            objSubProduct.geography = lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.name;
            objSubProduct.lineItemId = lineItem.id; 
            
            listSubProducts.add(objSubProduct); 
        }
    }

    
}