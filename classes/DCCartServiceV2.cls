/*
 * This class has all services related to Digital Configuration Page.
 * CHANGE HISTORY 
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-03-07   Ramesh Reddy          DLT-7843 - When changing Attorneys, only update Banded Products 
 * 2018-03-09   Raviteja Muruulta     DLT-7844 - added methods AddOnlineContacts, RemoveOnlineContacts
 * 2018-06-13   Rajan Tatuskar        DLT-9752 - Updates Account/Contact reference For Classes mentioned
 * 2018-08-30   Srikanth kota         DLT-11995 - Update with Segment__c in Soql for Configurator issue Change in term on config page
 * 2018-12-17   Benjamin Her          DLT-13780 - Code Scan fixes
 * 2019-02-12   Navleen Kaur          DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 2019-03-28   Bishanka Dassarma     DLT-15439 - [SFDC] Error handling for Configurator Page - ESI
 * 2019-06-13   Benjamin Her          DLT-16782 - Critical Code Scan fix
 * 2019-06-24	Benjamin Her		  DLT-16921 - Minor Code Scan fix
 * ==================================================================================================================================  
 */ 

public with sharing class DCCartServiceV2 {
    
    public static final String  CANCEL_LINE_STATUS = 'Cancelled';
    private static string cartStatus = 'Finalized';
    //private static Final String QUOTE_TYPE_STRAIGHT_RENEWAL = 'Straight Renewal';
    private Static Final String PRICING_MODEL_BANDED = 'Banded';
    private static string keyMaterial;
    /*
     * Add/remove products to Config Quote based on addProductIds passed as parameter.
     * updated the Quote If changes has been made as compare to Bestvalue Quote.
     */ 
    public static DCMessage addToCart(List<String> addProductIds,String contractTerm,integer iQuantity,String cQuoteId,String bQuoteId) {
        DCMessage response = new DCMessage();
        System.debug('addProductIds=====DLT======>'+ addProductIds);
        String cartId = '';
       
        if(String.isBlank(cQuoteId)) {
            return new DCMessage('Exception',400,'Custom Quote Id Should not be blank');
        }
    
        DCMessage msg = updateAllLineItems(iQuantity, contractTerm,addProductIds, cQuoteId, bQuoteId);
        
        if(!(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()
                && Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible())){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Config2__ProductConfiguration__c and/or Apttus_Config2__LineItem__c');
        }
        List<Apttus_Config2__ProductConfiguration__c> carts = [select id,name,Apttus_Config2__Status__c ,Apttus_QPConfig__Proposald__c,Ecom_No_of_Attorneys__c,
                                                               (select id,name,Apttus_Config2__LineStatus__c ,Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Name, Apttus_Config2__ProductId__r.Apttus_Filter_Jurisdiction__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,APTS_Yr_1_Renewal_Adjustment__c,
                                                                APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__PrimaryLineNumber__c,APTS_Bridge_Discount__c,APTS_Bridge__c,APTS_Contract_Term__c from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c != :CANCEL_LINE_STATUS) 
                                                               from Apttus_Config2__ProductConfiguration__c 
                                                               where Apttus_Config2__Status__c = :cartStatus and Apttus_QPConfig__Proposald__c =: cQuoteId ];
        if(carts == null || carts.isEmpty()){
            return new DCMessage('Exception',406,'Custom Quote should have the ProductConfiguration with status Finalized');
        }
        //Decimal adjustmentAmount = -1;
        //String adjustmentType = '';

        //Apttus_Config2__LineItem__c removableObj = null; // new Apttus_Config2__LineItem__c();
        Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
        
        cartId = carts[0].Id;
        if((iQuantity != null) && (carts[0].Ecom_No_of_Attorneys__c == Null || carts[0].Ecom_No_of_Attorneys__c != iQuantity)) {
            carts[0].Ecom_No_of_Attorneys__c = iQuantity;
            try{
              update carts[0];        
            }catch(Exception ex){
                DCCartServiceV2.trackLog(ex,'DCCartService_V2','addToCart');
                response.code = 400;
                response.cause = ex.getMessage();
                response.severity = 'Exception';
                return response;
          }
        }

        if(addProductIds == null || addProductIds.isEmpty()){
            return msg;
        }
    
        addToLineItem(customData,'Apttus_Config2__BillingFrequency__c','Monthly');
        if( !carts.isEmpty() && !carts[0].Apttus_Config2__LineItems__r.isEmpty()){
            Apttus_Config2__LineItem__c lineItem = carts[0].Apttus_Config2__LineItems__r[0];
            customData.Apttus_Config2__AdjustmentAmount__c = lineItem.Apttus_Config2__AdjustmentAmount__c;
            addToLineItem(customData,'Apttus_Config2__AdjustmentType__c',lineItem.Apttus_Config2__AdjustmentType__c);
            addToLineItem(customData,'APTS_Yr_1_Renewal_Adjustment__c',lineItem.APTS_Yr_1_Renewal_Adjustment__c);            
            addToLineItem(customData,'APTS_Years_2_Plus_Adjustment__c',lineItem.APTS_Years_2_Plus_Adjustment__c);           
            addToLineItem(customData,'APTS_Bridge_Discount__c',lineItem.APTS_Bridge_Discount__c);            
            addToLineItem(customData,'APTS_Bridge__c',lineItem.APTS_Bridge__c);           
            addToLineItem(customData,'APTS_Contract_Term__c',lineItem.APTS_Contract_Term__c);

        }
        //sfOLC Data Start
        List<Online_Contacts__c> olclist = new List<Online_Contacts__c>();
        set<String> materialNum = new set<String>();
        Map<String,List<Online_Contacts__c>> materialOLCMap = new Map<String,List<Online_Contacts__c>>();

        if(!Schema.sObjectType.Online_Contacts__c.isAccessible()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Online_Contacts__c');
        }
        olclist = [Select ID,Name,First_Name__c,Last_Name__c,QuoteId__c,Is_Banded_Product__c,WLEc_Juris__c,
                   Sftwr_Admin__c,Type__c,Position__c,Material__c,ContactID__c,Email__c from Online_Contacts__c Where QuoteId__c = : cQuoteId];
        
        for(Online_Contacts__c matolc: olclist ){
            materialNum.add(matolc.Material__c);
            keyMaterial = matolc.Material__c;
        }
        
        try{

            materialOLCMap = getMaterialOLCMap(materialNum, cQuoteId); 
            
            //SFOLC Data End
            msg = addToCartProductAndOLCHelper(carts,cartId,addProductIds,iQuantity,customData,materialOLCMap);
        }
        catch(Exception e){
            DCCartServiceV2.trackLog(e,'DCCartService_V2','addToCart');
            response.code = 400;
            response.cause = e.getMessage();
            response.severity = 'Exception';
            return response;
        }

        return msg;//new DCMessage('Success',200,'successfully addes');
    }

    /*
     * getMaterialOLCMap() method
     * Returns materialOLCMap
     */
    private static Map<String,List<Online_Contacts__c>> getMaterialOLCMap(Set<String> materialNum,String cQuoteId){
        Map<String,List<Online_Contacts__c>> materialOLCMap = new Map<String,List<Online_Contacts__c>>();

        List<Online_Contacts__c> olcformaplist = new  List<Online_Contacts__c>([Select ID,Name,First_Name__c,Last_Name__c,QuoteId__c,Is_Banded_Product__c,WLEc_Juris__c,
                   Sftwr_Admin__c,Type__c,Position__c,Material__c,ContactID__c,Email__c from Online_Contacts__c Where Material__c IN : materialNum and QuoteId__c =:cQuoteId]);

        for(String material: materialNum){  
            List<Online_Contacts__c> OLContactList = new List<Online_Contacts__c>();
            for(Online_Contacts__c OLContact: olcformaplist){
                if(material == OLContact.Material__c){

                    OLContactList.add(OLContact);
                }
            }
            
            materialOLCMap.put(material,OLContactList);
        }
        return materialOLCMap;
    }

    /*
    * addtoCartProductAndOLCHelper() method
    *
    */
    public static DCMessage addToCartProductAndOLCHelper(List<Apttus_Config2__ProductConfiguration__c> carts, String cartId,List<String> addProductIds, Integer iQuantity,Apttus_Config2__LineItem__c customData, Map<String,List<Online_Contacts__c>> materialOLCMap){

       Map<String,Integer> productIdsToLineNumber = new Map<String,Integer>();
       List<Integer> removablelines = new list<integer>();
       Boolean isAvailable = false;
       DCMessage msg = new DCMessage();
        //get LineItems from Custom Quote
        for( Apttus_Config2__LineItem__c lineItem : carts[0].Apttus_Config2__LineItems__r){
            if(lineItem.Apttus_Config2__LineStatus__c != 'New') continue;
            productIdsToLineNumber.put(lineItem.Apttus_Config2__ProductId__c,lineItem.Apttus_Config2__PrimaryLineNumber__c.intValue());
        }
        
        Set<String> lineItemProductIds = productIdsToLineNumber.keyset();
        Set<String> cloneAddProductIds = new Set<String>(addProductIds);
        cloneAddProductIds.removeAll(lineItemProductIds);
        productIdsToLineNumber.keyset().removeAll(addProductIds);
        
        try{
            boolean isRemoved = false;
            boolean isAdded = false;
            msg = new DCMessage('Success',200,'Successfully updated');
            if( !productIdsToLineNumber.isEmpty()) {
                removablelines = new list<integer>(productIdsToLineNumber.values());
                
                // Removed onlineContacts
                DCCartServiceV2.removeOnlineContacts(productIdsToLineNumber.keySet(), cartId);
                DCCartServiceV2.removeCartItem(removablelines, cartId);
                isRemoved = true;
                msg = new DCMessage('Success',200,'Successfully Removed');
            } 
            List<Decimal> lineNumbers = null;
            if(!cloneAddProductIds.isEmpty() && !isAvailable  ) {
                lineNumbers = addMultipleProducts(cloneAddProductIds, iQuantity, cartId, customData);
                DCCartServiceV2.AddOnlineContacts(lineNumbers, cartId,materialOLCMap);
                
                isAdded = true;
                msg = new DCMessage('Success',200,'Successfully updated');
            }  
            
            if( isAdded || isRemoved ){
                Boolean isPending = DCCartServiceV2.reprice(cartId);
                msg.isPending = isPending;
            }
        }catch(Exception ex){
            DCCartServiceV2.trackLog(ex,'DCCartServiceV2','addToCart');
            throw ex;
        }

        return msg;
    }//end of addToCartProductAndOLCHelper() method
 
    /*
     * Delete online contacts for given set of product Ids.
     * 
     */ 
    public static void removeOnlineContacts(Set<String> productIdList, String cartId){
        System.debug('productIdList===========>'+ productIdList);
        System.debug('cartId===========>'+ cartId);
       List<Apttus_Config2__LineItem__c> items = [select id,name, Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c 
                                       from Apttus_Config2__LineItem__c 
                                       where Apttus_Config2__ConfigurationId__c = :cartId and Apttus_Config2__ProductId__c in :productIdList];
        List<String> materialNumbers = new List<String>();
            for(Apttus_Config2__LineItem__c lineItem : items) {
            materialNumbers.add(lineItem.Apttus_Config2__ProductId__r.ProductCode);
            }
            
            if(materialNumbers != null)
            {
                if(!Schema.sObjectType.Online_Contacts__c.isAccessible()){
                    throw new DCCustomException(UserInfo.getName()+' does not have access to: Online_Contacts__c');
                }
                List<Online_Contacts__c> onlineContacts =[select id 
                                from Online_Contacts__c 
                                where Material__c in :materialNumbers and QuoteID__c = :items[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c];
                if(onlineContacts != null && Schema.sObjectType.Online_Contacts__c.isDeletable()){
                    delete onlineContacts;
                }
            }
   }
   
   /*
     * Add(Insert) online contacts for given set of lineNumbers.
     * 
     */ 
     
    public static void AddOnlineContacts(List<Decimal> lineNumbers, String cartId,Map<String,List<Online_Contacts__c>> materialOLCMap){
        System.debug('methodentrance===========>'+ lineNumbers);
        List<Online_Contacts__c> olcList = new list<Online_Contacts__c>();
        List<Apttus_Config2__LineItem__c> conItems = [select id,name, Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c 
                                               from Apttus_Config2__LineItem__c 
                                               where Apttus_Config2__ConfigurationId__c = :cartId and Apttus_Config2__PrimaryLineNumber__c in :lineNumbers];
        System.debug('conItems====================>'+ conItems);
        //List<String> materialNumbers = new List<String>();
        for(Apttus_Config2__LineItem__c lineItem : conItems) {

            if(materialOLCMap != null & keyMaterial != null & keyMaterial != '') {
                for(Online_Contacts__c sfOLc : materialOLCMap.get(keyMaterial)){
                    
                    Online_Contacts__c olcSele = new Online_Contacts__c();
                    
                    //*** START :: Added by Rajan :: DLT-9752 - Updates Account/Contact reference For Classes mentioned
                    //olcSele.Account__c = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__BillToAccountId__c;
                    olcSele.APTS_Source_System_Detail__c = lineItem.Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c;
                    //*** END :: Added by Rajan :: DLT-9752 - Updates Account/Contact reference For Classes mentioned
                    
                    olcSele.QuoteId__c = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
                    olcSele.Is_Banded_Product__c = True; // Config  will have all Banded only 
                    olcSele.Material__c = lineItem.Apttus_Config2__ProductId__r.ProductCode;
                    olcSele.First_Name__c = sfOLc.First_Name__c;
                    olcSele.Last_Name__c = sfOLc.Last_Name__c;
                    olcSele.ContactID__c = sfOLc.ContactID__c;
                    olcSele.Email__c = sfOLc.Email__c;
                    olcSele.Sftwr_Admin__c =  sfOLc.Sftwr_Admin__c;
                    olcSele.WLEc_Juris__c =  sfOLc.WLEc_Juris__c;
                    olcSele.ProductId__c = lineItem.Apttus_Config2__ProductId__c;
                    olcList.add(olcSele);
                }
            }
        }

        System.debug('olcList====================>'+ olcList);
        Database.upsert(olcList);
    
    }
    
    /*
     * Update all lineitems with Quantity and Contractterm for ConfigQuote and BestValue Quote.
     * 
     */ 
    public static DCMessage updateAllLineItems(Integer quantity,String contractTerm,List<String> cProductIds, String cQuoteId,String bQuoteId){
        
        List<String> quoteIds = new List<String>{cQuoteId,bQuoteId};
        List<Apttus_Config2__LineItem__c> items = [select id,name,Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__Quantity__c,APTS_Contract_Term__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, 
                                                                    Apttus_Config2__ProductId__r.Name,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Ecom_No_of_Attorneys__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c,
                                                                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c,
                                                                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c,
                                                                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c,
                                                                    Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,
                                                                    Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c,
                                                                    Apttus_Config2__ConfigurationId__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c
                                                       from Apttus_Config2__LineItem__c 
                                                       where Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = :cartStatus  and Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c in :quoteIds 
                                                       And Apttus_Config2__LineStatus__c != :CANCEL_LINE_STATUS ];
        
        Integer intQuantity;
        if(quantity == null){
            intQuantity = 0;
        }
        else{
            intQuantity = quantity;
        }

        QuoteVariables quotevar = new QuoteVariables();
        System.debug('quotevar created:::::'+quotevar);

        for(Apttus_Config2__LineItem__c lineItem : items) {
            if(! PRICING_MODEL_BANDED.equalsIgnoreCase(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c))
                continue;
            if(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c == cQuoteId){
                updateAllLineItemsConfigHelper(lineItem,intQuantity,contractTerm,quotevar);
                continue;
            }
            if(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c == bQuoteId){
                updateAllLineItemsBestHelper(lineItem,intQuantity,quotevar);
                // if(isContinued)break; 
            }    
        }
        DCMessage msg = new DCMessage('Success',200,'No Items to update');
        if( !quotevar.bestValueLineItems.isEmpty()){
            msg = updateAllLineItemsUpdateBestHelper(intQuantity, bQuoteId, quotevar);
        }
        
        
        if(quotevar.isContinued){
            msg = updateAllLineItemsHelper(contractTerm, items,intQuantity, bQuoteId, cQuoteId, quotevar );
        }

        updateAllLineItemsCustomProductHelper(cProductIds, quotevar, intQuantity, contractTerm, cQuoteId);

        return msg;   
    }

    /*
     * updateAllLineItemsCustomProductHelper() method
     *
     */
    public static void updateAllLineItemsCustomProductHelper(List<String> cProductIds,QuoteVariables quotevar,Integer intQuantity,String contractTerm,String cQuoteId){
        List<String> customProductList = new List<String>();
        if(cProductIds == null ){
            customProductList = quotevar.customProductIds;
            System.debug(customProductList+'<customProductList>'+quotevar.bValueProductIds+'<defaultQuantity>'+quotevar.defaultQuantity+'<bQuantity>'+quotevar.bValueQuantity+'<Quantity>'+intquantity+'<bValueContractTem>'+quotevar.bValueContractTem+'<contractTerm>'+contractTerm);
        }
        if( ((cProductIds != null && quotevar.bValueProductIds.containsAll(cProductIds)) || (!customProductList.isEmpty() && quotevar.bValueProductIds.containsAll(customProductList)))
            && (quotevar.defaultQuantity == intquantity) && quotevar.bValueContractTem != null && (quotevar.bValueContractTem.equals(contractTerm)) ){

            quotevar.quoteIdToUpdateQuotes.put(cQuoteId, compareCustomAndBV(true,quotevar.updatedOnConfigurator,cQuoteId));
        }
        else{
            quotevar.quoteIdToUpdateQuotes.put(cQuoteId, compareCustomAndBV(false,quotevar.updatedOnConfigurator,cQuoteId));
        }
        if(!quotevar.quoteIdToUpdateQuotes.isEmpty() && !quotevar.quoteIdToUpdateQuotes.isEmpty()) {
            update quotevar.quoteIdToUpdateQuotes.values();
        }
    }
    /*
    * updateAllLineItemsConfigHelper() method
    *
    */
    public static void updateAllLineItemsConfigHelper(Apttus_Config2__LineItem__c lineItem,Integer quantity,String contractTerm,QuoteVariables quotevar){
        System.debug('lineItem:::::::::::::'+lineItem);
        System.debug('quotevar:::::::::::::'+quotevar);
        Product_Account_Detail__c subscription = new Product_Account_Detail__c();
        quotevar.customProductIds.add(lineItem.Apttus_Config2__ProductId__c);
        quotevar.updatedOnConfigurator = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c;
        if(Schema.sObjectType.Product_Account_Detail__c.isAccessible()){   
            subscription = [SELECT ZP_Cust_Number__c,Digital_Firm__c FROM Product_Account_Detail__c 
                                     where ZP_Cust_Number__c = :lineItem.Apttus_Config2__ConfigurationId__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c limit 1];
        }       
        quotevar.segmentType = subscription.Digital_Firm__c;
        if(lineItem.Apttus_Config2__Quantity__c == quantity && lineItem.APTS_Contract_Term__c.equalsIgnoreCase(contractTerm) )
            quotevar.isContinued = false;
    }//end of updateAllLineItemsConfigHelper() method

    /*
    * updateAllLineItemsBestHelper() method
    *
    */
    public static void updateAllLineItemsBestHelper(Apttus_Config2__LineItem__c lineItem, Integer quantity, QuoteVariables quotevar){
        quotevar.bvAdjustmentAmount = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c;
        quotevar.bvAdjustmentType = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c;
        quotevar.bValueProductIds.add(lineItem.Apttus_Config2__ProductId__c);
        if(PRICING_MODEL_BANDED.equalsIgnoreCase(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c)) 
            quotevar.bValueQuantity = Integer.valueOf(lineItem.Apttus_Config2__Quantity__c);
        quotevar.bValueContractTem = lineItem.APTS_Contract_Term__c;
        if(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c == null){
            quotevar.defaultQuantity = 0;
        }
        else{
            quotevar.defaultQuantity = Integer.valueOf(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c);
        }
        quotevar.defaultContractTem = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c ;

        if(quantity != null && quantity > 0 && quotevar.bValueQuantity != quantity && PRICING_MODEL_BANDED.equalsIgnoreCase(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c)){
            quotevar.bestValueCart.Id = lineItem.Apttus_Config2__ConfigurationId__c ;
            quotevar.bestValueCart.Ecom_No_of_Attorneys__c = quantity;
            quotevar.bestValueUpdatedOnConfigurator = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c;
            Apttus_Config2__LineItem__c bLineItem = new Apttus_Config2__LineItem__c(
                                                                    Id = lineItem.id,
                                                                    Apttus_Config2__Quantity__c = quantity,
                                                                    Apttus_Config2__PricingStatus__c = 'Pending' );
            if(PRICING_MODEL_BANDED.equalsIgnoreCase(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c))
                quotevar.bestValueLineItems.add(bLineItem);    
        }

    }//end of updateAllLineItemsBestHelper() method

    /*
    * updateAllLineItemsUpdateBestHelper() method
    *
    */
    public static DCMessage updateAllLineItemsUpdateBestHelper(Integer quantity,String bQuoteId,  QuoteVariables quotevar){
        update quotevar.bestValueLineItems;
        update quotevar.bestValueCart;

        String bvContractTerm;
        if(quotevar.bValueContractTem != null){
            bvContractTerm = quotevar.bValueContractTem;
        }
        else{
            bvContractTerm = '';
        }
        //String bvDefaultContractTerm = quotevar.defaultContractTem != null ? quotevar.defaultContractTem : '';
        DCMessage msg = new DCMessage();
        if(bvContractTerm.equalsIgnoreCase(quotevar.defaultContractTem) && quotevar.defaultQuantity == quantity ){
            quotevar.quoteIdToUpdateQuotes.put(bQuoteId, compareCustomAndBV(true,quotevar.bestValueUpdatedOnConfigurator,bQuoteId));
        }else{
            quotevar.quoteIdToUpdateQuotes.put(bQuoteId, compareCustomAndBV(false,quotevar.bestValueUpdatedOnConfigurator,bQuoteId));
        }
        msg = new DCMessage('Success',200,' Best Value lineItems are updated ');
        msg.isPending = true;

        return msg;
    }//end of updateAllLineItemsUpdateBestHelper() method

    /*
    * updateAllLineItemsHelper() method
    *
    */
    public static DCMessage updateAllLineItemsHelper(String contractTerm,List<Apttus_Config2__LineItem__c> items, Integer quantity, String bQuoteId, String cQuoteId, QuoteVariables quotevar){
        List<Apttus_Config2__LineItem__c>  updateItems = new List<Apttus_Config2__LineItem__c>();
        DCMessage msg = new DCMessage();
        if(!(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible())
                && Schema.sObjectType.DC_Contract_Term_V2__mdt.isAccessible()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Proposal__Proposal__c and/or DC_Contract_Term_V2__mdt');
        }
            Apttus_Proposal__Proposal__c cQuote = [select APTS_Customer_Category__c,Digital_Quote_Type__c from Apttus_Proposal__Proposal__c where id=: cQuoteId ];
            Integer customerCategory;
            if(cQuote.APTS_Customer_Category__c == null){
                customerCategory = null;
            }
            else{
                customerCategory = Integer.valueOf(cQuote.APTS_Customer_Category__c);
            }
            List<DC_Contract_Term_V2__mdt> Contract_Terms = [select Markup_Percentage__c,YoY_1_Renewal__c,Sequence_No__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c From DC_Contract_Term_V2__mdt 
                                                             Where Customer_Category__c =: customerCategory
                                                             and Quote_Type__c =: cQuote.Digital_Quote_Type__c
                                                             And Contract_Term__c =:contractTerm 
                                                             AND Segment__c =: quotevar.segmentType ];
            if(customerCategory == null || Contract_Terms.isEmpty())
                Contract_Terms = [select Markup_Percentage__c,YoY_1_Renewal__c,Sequence_No__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c 
                                 from DC_Contract_Term_V2__mdt 
                                 where Default_Customer_Category__c = true 
                                 and Quote_Type__c =: cQuote.Digital_Quote_Type__c
                                 And Contract_Term__c =:contractTerm 
                                 AND Segment__c =: quotevar.segmentType ];


            String Years_2_Plus_Adjustment = '0';
            Decimal markup = 0.0;

            if((Contract_Terms != null) && (!Contract_Terms.isEmpty())) {
                Years_2_Plus_Adjustment = getYear2PlusAdjustment(Contract_Terms);
                markup = getMarkup(Contract_Terms);
            }

            Decimal newAdjustmentAmount = getNewAdjustmentAmount(quotevar,markup,Contract_Terms);

            String newAdjustmentType = getNewAdjustmentType(newAdjustmentAmount,quotevar);
            
            //Get absolute value AFTER determining adjustment type.
            newAdjustmentAmount = newAdjustmentAmount.abs();

            // if( quantity < 1 ) return new DCMessage('Exception',406,' Quantity should be greater than or equal to 1');      
            //Integer no_Of_Attorneys = 0;

            //iterate through list of Apttus Line Items and update values
            updateAllLineItemsHelper2(items,bQuoteId, contractTerm ,newAdjustmentAmount,newAdjustmentType,quantity,updateItems, Years_2_Plus_Adjustment);
            
            try{
                if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
                    throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Config2__LineItem__c');
                }
                if(updateItems != null && !updateItems.isEmpty()){
                update updateItems;
            }
            }catch(Exception ex){
                DCCartServiceV2.trackLog(ex,'DCCartServiceV2','updateAllLineItems');
                throw ex;
            }   
            try{
                if(quantity != null && quantity > 0 && updateItems != null && !updateItems.isEmpty()){
                    Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
                    cart.Id = updateItems[0].Apttus_Config2__ConfigurationId__c ;
                    cart.Ecom_No_of_Attorneys__c = quantity;
                    
                    if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
                    throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Config2__ProductConfiguration__c');
                    }
                    if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable()) {
                    update cart;
                    }
                    msg = new DCMessage('Success',200,'Successfully updated');
                    msg.isPending = true;
                    // return msg;
                }
            }catch(Exception ex){
                DCCartServiceV2.trackLog(ex,'DCCartServiceV2','updateAllLineItems');
                throw ex;
            }    
            return msg;       
    }//end of updateAllLineItemsHelper() method

    /*
     * getYear2PlusAdjustment()
     * Returns Year 2 Plus Adjustment based on whether value exists in DC Contract Term V2 metadata
     */
    private static String getYear2PlusAdjustment(List<DC_Contract_Term_V2__mdt> Contract_Terms){
        String Years_2_Plus_Adjustment = '0';

        if(Contract_Terms[0].DC_Years_2_Plus_Adjustment__c != null){
            Years_2_Plus_Adjustment = String.valueOf(Integer.valueOf( Contract_Terms[0].DC_Years_2_Plus_Adjustment__c));
        }

        return Years_2_Plus_Adjustment;
    }

    /*
     * getMarkup()
     * Returns markup based on whether value exists in DC Contract Term V2 metadata
     */
    private static Decimal getMarkup(List<DC_Contract_Term_V2__mdt> Contract_Terms){
        Decimal markup = 0.0;

        if(Contract_Terms[0] != null){
            markup = Contract_Terms[0].Markup_Percentage__c;
        }

        return markup;
    }
    /*
     * getNewAdjustmentAmount()
     */
    private static Decimal getNewAdjustmentAmount(QuoteVariables quotevar, Decimal markup,List<DC_Contract_Term_V2__mdt> Contract_Terms){
        Decimal newAdjustmentAmount = 0.0;
        if((Contract_Terms != null) && (!Contract_Terms.isEmpty())) {
            if(quotevar.bvAdjustmentType == Label.DC_PERCENT_DISCOUNT) {
                newAdjustmentAmount = quotevar.bvAdjustmentAmount - markup;
            } 
            else if(quotevar.bvAdjustmentType == Label.DC_PERCENT_MARKUP) {
                newAdjustmentAmount = quotevar.bvAdjustmentAmount + markup;
            }
        } 
        else {
            newAdjustmentAmount = quotevar.bvAdjustmentAmount;
        }
        return newAdjustmentAmount;
    }
    /*
     * getNewAdjustmentType()
     */
    private static String getNewAdjustmentType(Decimal newAdjustmentAmount,QuoteVariables quotevar){
        String newAdjustmentType;

        if(newAdjustmentAmount < 0) {
            newAdjustmentType = Label.DC_PERCENT_MARKUP;
        } 
        else {        
            newAdjustmentType = quotevar.bvAdjustmentType;
        }

        return newAdjustmentType;
    }

    /*
    * updateAllLineItemsConfigHelper2() method
    *
    */
    public static void updateAllLineItemsHelper2(List<Apttus_Config2__LineItem__c> items,String bQuoteId, String contractTerm ,Decimal newAdjustmentAmount,String newAdjustmentType,Integer quantity,List<Apttus_Config2__LineItem__c> updateItems,String Years_2_Plus_Adjustment){
        for(Apttus_Config2__LineItem__c line : items){
            if(line.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c == bQuoteId) continue;
                boolean hasChanged = false;
                if(String.isNotBlank(contractTerm)){
                    line.Apttus_Config2__AdjustmentAmount__c = newAdjustmentAmount;
                    if(newAdjustmentType != null){
                        line.Apttus_Config2__AdjustmentType__c = newAdjustmentType;
                    }
                    line.APTS_Years_2_Plus_Adjustment__c = Years_2_Plus_Adjustment;
                    line.APTS_Contract_Term__c = contractTerm;
                    hasChanged = true;
                }
                if(quantity > 0 && PRICING_MODEL_BANDED.equalsIgnoreCase(line.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c)) {
                    line.Apttus_Config2__Quantity__c = quantity;
                    hasChanged = true;
                }
                if(hasChanged){
                    line.Apttus_Config2__PricingStatus__c = 'Pending';   
                    updateItems.add(line);
                }
        }
    }//end of updateAllLineItemsConfigHelper2() method


    /*
     * Compare the Best Value And Config Quote and update updatedOnConfigurator flag.
     */ 
    public static Apttus_Proposal__Proposal__c compareCustomAndBV(boolean isEqual, boolean updatedOnConfigurator, String cQuoteId  ) {
        if(isEqual) {     
            // if(!updatedOnConfigurator) return;
            Apttus_Proposal__Proposal__c cQuote = new Apttus_Proposal__Proposal__c();
            cQuote.DC_Updated_On_Configurator__c = false;
            cQuote.DC_Contract_Not_In_Sync__c = true;
            cQuote.id = cQuoteId;
            return cQuote;          
        } else {
            // if(updatedOnConfigurator) return;
            Apttus_Proposal__Proposal__c cQuote = new Apttus_Proposal__Proposal__c();
            cQuote.DC_Updated_On_Configurator__c = true;
            cQuote.DC_Contract_Not_In_Sync__c = true;
            cQuote.id = cQuoteId;
            return cQuote;
        }        
    }    
    
    /*
     * Add multiple Products to cart using Apttus API.
     */ 
    public static List<Decimal> addMultipleProducts(Set<string> productIds,integer iQuantity,String cartID,Apttus_Config2__LineItem__c liSO ){
        
        //DCMessage response = new DCMessage();
        //String currentProdID = '';
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO addMultiProdRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        
        addMultiProdRequest.cartId = cartId;
        addMultiProdRequest.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
        try{
        for( String productId : productIds ){
            //currentProdID = productId;
            Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            selectedProduct.productId = productId;
            selectedProduct.Quantity = iQuantity;
            selectedProduct.comments = 'Inserted via Ecommerce';
            Map<String,Object> line = liSO.getPopulatedFieldsAsMap(); 
            System.debug('line  '+line);
            if(line.keySet() != null && !line.keySet().isEmpty()){
                List<String> allFields = new List<String>(line.keySet());
                selectedProduct.CustomFields = allFields;
                selectedProduct.CustomData = liSO; 
            }        
            addMultiProdRequest.selectedProducts.add(selectedProduct);  
        }
        }
        catch(Exception ex){
                DCCartServiceV2.trackLog(ex,'DCCartService_V2','addMultipleProducts');
                //response.code = 400;
                //response.cause = currentProdID + ': ' +ex.getMessage();
                //response.severity = 'Exception';
                throw ex;
          }
        
        Apttus_CPQApi.CPQ.AddMultiProductResponseDO addMultiProdResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(addMultiProdRequest);
        
        Apttus_Config2__ProductConfiguration__c cartObj = new Apttus_Config2__ProductConfiguration__c();
        cartObj.Apttus_Config2__IsPricePending__c = true;
        cartObj.ID = cartID;  
        
        if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Config2__ProductConfiguration__c');
        }                                                 
        update cartObj;

        return addMultiProdResponse.LineNumbers;

    }
    /**
     *  add a field and value to the LineItem object.
     */ 
    
    public static void addToLineItem(Apttus_Config2__LineItem__c obj, String field, String value){
        if(obj.get(field) == null && value != null)
            obj.put(field,value);
    }
    /**
     * update the cart price based on cartId passed as parameter
     */ 
    public static boolean reprice (Id cartId) {
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
        objUpdatePriceRequestDO.CartId = cartID;
        //Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
        
        return Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO).IsPricePending;
    }
    
    /*
     * update the cart which has Finalized status for Quote
     */ 
    public static DCMessage repriceByQuoteId (Id cQuoteId) {
        DCMessage msg = new DCMessage('Success', 200, 'Successfully updated');
        msg.isPending = false;
        List<Apttus_Config2__ProductConfiguration__c> carts = [select id,name,Apttus_Config2__Status__c ,Apttus_QPConfig__Proposald__c
                                                               from Apttus_Config2__ProductConfiguration__c 
                                                               where Apttus_Config2__Status__c =: cartStatus and Apttus_QPConfig__Proposald__c =: cQuoteId ];
        if(carts != null && !carts.isEmpty()) {
            msg.isPending = reprice(carts[0].id);
        } 
        return msg;
    }
    /*
     * remove multiple lineItem using Apttus API based on removablelines and cartId passed as parameter.
     */ 
    public static void removeCartItem(List<Integer> removablelines, String cartId){
        
        Apttus_CPQApi.CPQ.RemoveLineItemsRequestDO request = new Apttus_CPQApi.CPQ.RemoveLineItemsRequestDO();
        request.CartId = cartId;
        request.PrimaryLineNumbers.addAll(removablelines);
        Apttus_CPQApi.CPQ.RemoveLineItemsResponseDO result = Apttus_CPQApi.CPQWebService.removeLineItems(request);
        //delete removableObj;
        //Apttus_CPQApi.CPQWebService.applyConstraintRulesOnDelete(cartId, new String[] {removableObj.Apttus_Config2__ProductId__c});
        System.debug('Is deleted '+result); 

    }
    /**
     * reset all Quotes based on Opportunity with their Default values.
     */ 
    public static DCQuoteUpdate.QuoteUpdateResponse resetQuotes(String customQuoteId, String bestValueQuoteId){   
        Apttus_Proposal__Proposal__c proposal = [select Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where id =: bestValueQuoteId limit 1];
        String opportunityId = proposal.Apttus_Proposal__Opportunity__c;
        
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Proposal__Proposal__c');
        }
        List<Apttus_Proposal__Proposal__c> resetQuotes = [select id,name,DC_Default_Contract_Term__c,DC_Default_Quantity__c,Digital_Quote_Type__c ,Apttus_Proposal__Opportunity__c,DC_Updated_On_Configurator__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =: opportunityId and DC_Updated_On_Configurator__c = true];
        //List<String> quoteIdList = new List<String>();
        List<DCQuoteUpdate.QuoteUpdateRequest> resetDetails = new List<DCQuoteUpdate.QuoteUpdateRequest>();
        for(Apttus_Proposal__Proposal__c quote : resetQuotes ){
            if(quote.id == customQuoteId )  continue;
            DCQuoteUpdate.QuoteUpdateRequest request = new DCQuoteUpdate.QuoteUpdateRequest();
            request.quoteId = quote.id;
            request.contractTerm = quote.DC_Default_Contract_Term__c;
            if(quote.DC_Default_Quantity__c == null){
                request.quantity = null;
            }
            else{
                request.quantity = quote.DC_Default_Quantity__c.intValue();
            }
            request.quoteType = quote.Digital_Quote_Type__c;
            resetDetails.add(request);  
        }
        DCQuoteUpdate.QuoteUpdateResponse res = new DCQuoteUpdate.QuoteUpdateResponse();
        if(!resetDetails.isEmpty()){
            DCQuoteService service  = new DCQuoteService();
            res = service.updateAllLineItems(resetDetails,true);  
            // return res;
        }
        try{
            DCQuoteUpdate.QuotePricingStatus pricingStatus = new DCQuoteUpdate.QuotePricingStatus();
            pricingStatus.quoteId = customQuoteId;
            pricingStatus.isPricingPending = cloneLineItems(customQuoteId, cleanupLineItems(customQuoteId) , bestValueQuoteId); 
            res.quotePricingStatus.add(pricingStatus);
        }catch(Exception ex){
            res.responseCode = 400;
            res.responseMessage = ex.getMessage();
            trackLog(ex,'DCCartServiceV2','resetQuotes');
        }
        return res;
    }
    /*
        reset the config Quote means create a copy of best value Quote
     */ 
    public static boolean resetQuote(String customQuoteId, String bestValueQuoteId){    
        return cloneLineItems(customQuoteId, cleanupLineItems(customQuoteId) , bestValueQuoteId); 
    }
    
    /**
     * remove the all lineItems from Config Quote
     */ 
    public static String cleanupLineItems(String cQuoteId){

        String status = 'Finalized';
        Map<String,String> quoteIdTocartId = new Map<String,String>();
        
        if(!(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()
                && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible())){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Config2__ProductConfiguration__c and/or Apttus_Proposal__Proposal__c');
        }            
        List<Apttus_Config2__ProductConfiguration__c> carts = [select id,name,Apttus_Config2__Status__c ,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c,Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c,
                                                           (select id,name,Apttus_Config2__LineStatus__c,Apttus_Config2__PrimaryLineNumber__c  from Apttus_Config2__LineItems__r) 
                                                           from Apttus_Config2__ProductConfiguration__c 
                                                           where Apttus_Config2__Status__c =: status and Apttus_QPConfig__Proposald__c =:cQuoteId ];
        if(!Test.isRunningTest()) delete carts[0].Apttus_Config2__LineItems__r; 
         List<Apttus_Proposal__Proposal__c> listOfquotes = new List<Apttus_Proposal__Proposal__c>(); 
         List<Apttus_Config2__ProductConfiguration__c> listOfCarts = new List<Apttus_Config2__ProductConfiguration__c>();                                               
        for(Apttus_Config2__ProductConfiguration__c cart : carts){
            if(quoteIdTocartId.get(cQuoteId) == null && cQuoteId == cart.Apttus_QPConfig__Proposald__c){
                quoteIdTocartId.put(cQuoteId,cart.id);
                // DC_Updated_On_Configurator__c set to false 
                Apttus_Proposal__Proposal__c quote = compareCustomAndBV(true,cart.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c,cQuoteId);
            
                listOfquotes.add(quote);
                
                // update default quantity
                cart.Ecom_No_of_Attorneys__c = cart.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c;
                
                listOfCarts.add(cart);
                // delete all existing line items
                //List<Integer> removableLines = new List<Integer>(); 
               
            }
        }
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
            update listOfquotes;
        }
        if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable()) {
            update listOfCarts;
        }  
        System.debug('quoteIdTocartId.get(cQuoteId)  '+quoteIdTocartId.get(cQuoteId));
        return quoteIdTocartId.get(cQuoteId);
        
    }
    
    /*
     * clone all the related list to Config Quote based Best Value Quote.
     */ 
    public static boolean cloneLineItems(String cQuoteId,String cCartId,String bQuoteId){

        map<String,String> mapSummaryGroup = new map<String,String>();
        string query = Digital_BestProposalCloneHelper.queryAllFields('Apttus_Config2__SummaryGroup__c');
        query = query + 'Apttus_Config2__SummaryGroup__c where Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = \'Finalized\' and  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =\''+String.escapeSingleQuotes(bQuoteId)+'\'';
    
        List<Apttus_Config2__SummaryGroup__c> bestValSummaryGroupList = new List<Apttus_Config2__SummaryGroup__c>();
        List<Apttus_Config2__SummaryGroup__c> bestValSummaryGroupListCloned = new List<Apttus_Config2__SummaryGroup__c>();
        bestValSummaryGroupList = Database.query(query);
    
        if(bestValSummaryGroupList !=null && !bestValSummaryGroupList.isEmpty()){
    
            for(Apttus_Config2__SummaryGroup__c sg :bestValSummaryGroupList){
    
                Apttus_Config2__SummaryGroup__c summaryCloned = new Apttus_Config2__SummaryGroup__c();
                summaryCloned = sg.clone(false,true,false,false);
                summaryCloned.Apttus_Config2__ConfigurationId__c = cCartId;
                bestValSummaryGroupListCloned.add(summaryCloned);
            }
    
            Database.insert(bestValSummaryGroupListCloned,false);
            integer i=0;
            for(Apttus_Config2__SummaryGroup__c sg :bestValSummaryGroupListCloned){
                mapSummaryGroup.put(bestValSummaryGroupList.get(i).id,sg.id);
                i++;
            }
        }
    
        map<String,String> mapAdHocGroup = new map<String,String>();
    
        query = Digital_BestProposalCloneHelper.queryAllFields('Apttus_Config2__AdHocGroup__c');
        query = query + 'Apttus_Config2__AdHocGroup__c where Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = \'Finalized\' and  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =\''+String.escapeSingleQuotes(bQuoteId)+'\'';
    
        List<Apttus_Config2__AdHocGroup__c> bestValAdhocGroupList = new List<Apttus_Config2__AdHocGroup__c>();
        List<Apttus_Config2__AdHocGroup__c> bestValAdhocGroupListCloned = new List<Apttus_Config2__AdHocGroup__c>();
        bestValAdhocGroupList = Database.query(query);
    
        if(bestValAdhocGroupList != null && !bestValAdhocGroupList.isEmpty()){
    
            for(Apttus_Config2__AdHocGroup__c ad : bestValAdhocGroupList){
    
                Apttus_Config2__AdHocGroup__c adCloned = new Apttus_Config2__AdHocGroup__c();
                adCloned = ad.clone(false,true,false,false);
                adCloned.Apttus_Config2__ConfigurationId__c = cCartId;
                bestValAdhocGroupListCloned.add(adCloned);
    
            }
            Database.insert(bestValAdhocGroupListCloned,false);
            integer i=0;
            for(Apttus_Config2__AdHocGroup__c ad : bestValAdhocGroupListCloned){
                mapAdHocGroup.put(bestValAdhocGroupList.get(i).id,ad.id);
                i++;
            }
        }
    
        query = Digital_BestProposalCloneHelper.queryAllFields('Apttus_Config2__LineItem__c');
        query = query + 'Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = \'Finalized\' and  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =\''+String.escapeSingleQuotes(bQuoteId)+'\'';
    
        List<Apttus_Config2__LineItem__c> bestValconfigCartLineList = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> bestValconfigCartLineListCloned = new List<Apttus_Config2__LineItem__c>();
        bestValconfigCartLineList = Database.query(query);
    
        if(bestValconfigCartLineList != null && !bestValconfigCartLineList.isEmpty()){
     
            for(Apttus_Config2__LineItem__c line : bestValconfigCartLineList){
    
                Apttus_Config2__LineItem__c bestValConfigLineCloned = new Apttus_Config2__LineItem__c();
                bestValConfigLineCloned = line.clone(false,true,false,false);
                bestValConfigLineCloned.Apttus_Config2__ConfigurationId__c = cCartId;
                bestValConfigLineCloned.Apttus_Config2__AdHocGroupId__c = mapAdHocGroup.get(line.Apttus_Config2__AdHocGroupId__c);
                bestValConfigLineCloned.Apttus_Config2__SummaryGroupId__c = mapSummaryGroup.get(line.Apttus_Config2__SummaryGroupId__c);
                bestValconfigCartLineListCloned.add(bestValConfigLineCloned);
            }
    
            database.insert(bestValconfigCartLineListCloned,false);
    
        }
        
        updateOLContacts(cQuoteId);
        
        return reprice (cCartId); 
    }
    /**
     * Insert exception details in Digital_Exception_Log__c
     */     
    public static void trackLog(Exception e,String className,String methodName){
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();  
        ex.Exception_Message__c = e.getMessage();
        ex.Exception_Type__c = e.getStackTraceString();        
        ex.Additional_Information__c = String.valueof(e.getLineNumber());   
        ex.User_Message__c = String.valueof(e.getCause());
        ex.Class_Reference__c = '<'+className+'> > <'+methodName+'>';  
        if(!Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Digital_Exception_Log__c');
        }
        insert ex;     
    }
    
    
    /*
    Update Online Contacts to have records only for the Products that are currently available in the Quote as line items 
    */
    public static void updateOLContacts(Id cQuoteId) {
        Map<String,List<Online_Contacts__c>> materialOLCMap = getsfOLC(cQuoteId);
        List<Online_Contacts__c> ocAddList = new List<Online_Contacts__c>();
        List<Online_Contacts__c> ocDeleteList = new List<Online_Contacts__c>();
        
        List<Apttus_Config2__LineItem__c> lineItemList = [select id, name, Apttus_Config2__LineStatus__c, Apttus_Config2__PrimaryLineNumber__c ,
                                                                Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,
                                                                Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c
                                                            from Apttus_Config2__LineItem__c
                                                            WHERE Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :cQuoteId
                                                                AND Apttus_Config2__LineStatus__c != :CANCEL_LINE_STATUS];
        
        List<Online_Contacts__c> ocCopyList = materialOLCMap.get(keyMaterial);  
                    
        for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
            List<Online_Contacts__c> ocPerLineItemList = createClone(ocCopyList);
            for(Online_Contacts__c ocPerLineItem : ocPerLineItemList) {
                ocPerLineItem.Material__c = lineItem.Apttus_Config2__ProductId__r.ProductCode;
                ocPerLineItem.ProductId__c = lineItem.Apttus_Config2__ProductId__c;
            }

            ocAddList.addAll(ocPerLineItemList);
        }
        System.debug('ocAddList==>'+JSON.serialize(ocAddList));
        
        if(!Schema.sObjectType.Online_Contacts__c.isCreateable()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Online_Contacts__c');
        }
        if(!ocAddList.isEmpty())
                Insert ocAddList;
            
        for(String materialNum : materialOLCMap.keySet()) {
            ocDeleteList.addAll(materialOLCMap.get(materialNum));
        }   
        System.debug('ocDeleteList==>'+JSON.serialize(ocDeleteList));   
        if(!ocDeleteList.isEmpty() && Schema.sObjectType.Online_Contacts__c.isDeletable()){
            Delete ocDeleteList;
        }
            
    }
    
    /*
    Create copy of Online_Contacts__c list without the ID and Name
    */
    
    private static List<Online_Contacts__c> createClone(List<Online_Contacts__c> ocCopyList) {
        List<Online_Contacts__c> ocList = new List<Online_Contacts__c>();
        
        for(Online_Contacts__c oc : ocCopyList) {
            Online_Contacts__c ocNew = new Online_Contacts__c();
            ocNew.First_Name__c = oc.First_Name__c;
            ocNew.Last_Name__c = oc.Last_Name__c;
            ocNew.QuoteId__c = oc.QuoteId__c;
            ocNew.Is_Banded_Product__c = oc.Is_Banded_Product__c;
            ocNew.WLEc_Juris__c = oc.WLEc_Juris__c;
            ocNew.Sftwr_Admin__c = oc.Sftwr_Admin__c;
            ocNew.Type__c = oc.Type__c;
            ocNew.Position__c = oc.Position__c;
            ocNew.Material__c = oc.Material__c;
            ocNew.ContactID__c = oc.ContactID__c;
            ocNew.Email__c = oc.Email__c;
            ocNew.ProductId__c = oc.ProductId__c;

            ocList.add(ocNew);
        }
        
        return ocList;
    }
    
    /*
    Create map of Material Number to Online Contacts for the given Quote Id
    */
    public static Map<String,List<Online_Contacts__c>> getsfOLC(Id cQuoteId){
    
        List<Online_Contacts__c> olclist = new List<Online_Contacts__c>();
        set<String> materialNum = new set<String>();
        Map<String,List<Online_Contacts__c>> materialOLCMap = new Map<String,List<Online_Contacts__c>>();
        
        if(!Schema.sObjectType.Online_Contacts__c.isAccessible()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Online_Contacts__c');
        }        
        olclist = [Select ID,Name, First_Name__c, Last_Name__c,QuoteId__c, Is_Banded_Product__c, WLEc_Juris__c,
                        Sftwr_Admin__c, Type__c, Position__c, Material__c, ContactID__c, Email__c, ProductId__c
                    from Online_Contacts__c 
                    Where QuoteId__c = : cQuoteId];
        System.debug('olclistfrist==>'+olclist);
        for(Online_Contacts__c matolc : olclist ) {
            materialNum.add(matolc.Material__c);
            if(!materialOLCMap.containsKey(matolc.Material__c)) 
                materialOLCMap.put(matolc.Material__c, new List<Online_Contacts__c>());
            
            materialOLCMap.get(matolc.Material__c).add(matolc);
            
            keyMaterial = matolc.Material__c;
        }
        
        return materialOLCMap;  
    }

    private class QuoteVariables{
        Decimal bvAdjustmentAmount;
        String bvAdjustmentType;
        Boolean isContinued;
        Boolean updatedOnConfigurator;
        Boolean bestValueUpdatedOnConfigurator;
        Set<String> bValueProductIds;
        List<String> customProductIds;
        Integer defaultQuantity;
        String defaultContractTem;
        Integer bValueQuantity;
        String bValueContractTem;
        String segmentType;
        List<Apttus_Config2__LineItem__c> bestValueLineItems;
        Apttus_Config2__ProductConfiguration__c bestValueCart;
        Map<String,Apttus_Proposal__Proposal__c> quoteIdToUpdateQuotes;

        //constructor
        QuoteVariables(){
            bvAdjustmentAmount = 0;
            isContinued = true;
            updatedOnConfigurator = false;
            bestValueUpdatedOnConfigurator = false;
            bValueProductIds = new Set<String>();
            customProductIds = new List<String>();
            defaultQuantity = 0;
            defaultContractTem = '';
            bValueQuantity = 0;
            bValueContractTem = '';
            bestValueLineItems = new List<Apttus_Config2__LineItem__c>();
            bestValueCart = new Apttus_Config2__ProductConfiguration__c();
            quoteIdToUpdateQuotes = new Map<String,Apttus_Proposal__Proposal__c>();
        } 
    }
}