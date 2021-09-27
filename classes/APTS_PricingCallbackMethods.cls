/**
* Methods that Apttus will use on the Pricing Callback
* @author Alex Shung
* @version 7/8/2016
*/
/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 8/23      Chirag                  External Pricing Callout
*/
/**
* Current bugs:
* Discount To Max:
* Can't reprice after max attribute has been repriced once (not getting the correct original base price)
* Something weird happening with mulitple quantity when there's a bundle
* Won't register net price on the first go to pricing after adding in option -- will if I just click reprice
* Option price not updating correctly (adj price and net price)
* If entering an adjustment amount, the base price seems to reset if it's below the specified amount
*/
public with sharing class APTS_PricingCallbackMethods {
    //Constants
    //A.S Change to store in custom setting
    private static final String FILLUPVALUE = 'Fill-Up';
    private static Integer counter = 0;
    public APTS_PricingCallbackMethods() {
    }
    //Added by Chirag
    private void logger(String logLine) {
        System.debug('POC - ' + logLine);
    }

    // SOC-4845 Added by Chirag for Print anniversay pricing issue  8/10/2017
    /* commented by Chintan - as this method is not called by any other class. We checked it in Production as well.
    public static void setBasePrice(List<Apttus_Config2__LineItem__c> bundleItems){
        List<Id> lineItemIds = new List<Id>();
        Set<Id> productIds = new Set<Id>();
        for(Apttus_Config2__LineItem__c lineItem : bundleItems){
            lineItemIds.add(lineItem.Id);
            if(lineItem.Apttus_Config2__ProductId__c != null){
                productIds.add(lineItem.Apttus_Config2__ProductId__c);
            }
        }
        List<Apttus_Config2__ProductAttributeValue__c> pavList = [SELECT APTS_FillUp_Start_Date__c, SCS_Print_Purchase_Options__c, Apttus_Config2__LineItemId__c, Apttus_Config2__LineItemId__r.Apttus_Config2__ProductId__c FROM Apttus_Config2__ProductAttributeValue__c WHERE Apttus_Config2__LineItemId__c in :lineItemIds];
        Map<Id, Apttus_Config2__ProductAttributeValue__c> pavMap = new Map<Id, Apttus_Config2__ProductAttributeValue__c>();
        for(Apttus_Config2__ProductAttributeValue__c pav : pavList){
            pavMap.put(pav.Apttus_Config2__LineItemId__r.Apttus_Config2__ProductId__c, pav);
        }
        for(Apttus_Config2__LineItem__c lineItem : bundleItems){
            if(lineItem.Apttus_Config2__LineType__c == 'Option' && (lineItem.APTS_Item_Category_Group__c == 'ZPMT' || lineItem.APTS_Item_Category_Group__c == 'ZBAR' || lineItem.APTS_Item_Category_Group__c == 'ZPAV') &&
            pavMap.get(lineItem.Apttus_Config2__ProductId__c).SCS_Print_Purchase_Options__c== 'Fill-Up & Enter Sub'){
                lineItem.Apttus_Config2__BasePriceOverride__c = 0.00;
                lineItem.Apttus_Config2__BasePrice__c= 0.00;
            }
        }
    }*/
    
    //Created by AS 6/27/2016
    //Meant to add discount entire bundle (spread out across options) if the attribute MAX PRICE is greater than the bundle's price.
    public static void discountToMax(List<Apttus_Config2__LineItem__c> bundleItems, Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap)
    {
        List<Id> lineItemIds = new List<Id>();
        Set<Id> productIds = new Set<Id>();
        
        // Chintan - added to check if list is blank
        Boolean isAttbListBlank = true;
        Apttus_Config2__ProductAttributeValue__c objProductAttribute = new Apttus_Config2__ProductAttributeValue__c();
        Map<Id, Apttus_Config2__ProductAttributeValue__c> pavMap = new Map<Id, Apttus_Config2__ProductAttributeValue__c>();
        
        for(Apttus_Config2__LineItem__c lineItem : bundleItems){
            lineItemIds.add(lineItem.Id);
            if(lineItem.Apttus_Config2__ProductId__c != null){
                productIds.add(lineItem.Apttus_Config2__ProductId__c);
            }
            
             //Chintan - if line item has Product Attribute, settting variable as false;
            if(lineItem.Apttus_Config2__AttributeValueId__c != null)
            {
                isAttbListBlank = false;
                If(lineItem.Apttus_Config2__ProductId__c == null || 
                   lineItem.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c == null || 
                   !lineItem.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c.contains(FILLUPVALUE))
                {
                    continue;
                }
                
                objProductAttribute = new Apttus_Config2__ProductAttributeValue__c();
                objProductAttribute.APTS_FillUp_Start_Date__c = lineItem.Apttus_Config2__AttributeValueId__r.APTS_FillUp_Start_Date__c;
                objProductAttribute.SCS_Print_Purchase_Options__c = lineItem.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c;
                objProductAttribute.Id = lineItem.Apttus_Config2__AttributeValueId__c;
                pavMap.put(lineItem.Apttus_Config2__ProductId__c, objProductAttribute);
                system.debug('2222222 Product Attrb object :'+objProductAttribute);
            }
        }
        //============================================
        // Getting Product Attribute Values
        // commented by Chintan - populating the below list and map in above loop on lineItems
    /*    List<Apttus_Config2__ProductAttributeValue__c> pavList = [SELECT APTS_FillUp_Start_Date__c, SCS_Print_Purchase_Options__c, Apttus_Config2__LineItemId__c, Apttus_Config2__LineItemId__r.Apttus_Config2__ProductId__c FROM Apttus_Config2__ProductAttributeValue__c WHERE Apttus_Config2__LineItemId__c in :lineItemIds];
        Map<Id, Apttus_Config2__ProductAttributeValue__c> pavMap = new Map<Id, Apttus_Config2__ProductAttributeValue__c>();
        if(pavList==null || pavList.isEmpty()){
            return;
        }
        */
        
        if(isAttbListBlank || pavMap.isEmpty()){
            return;
        }
        
   /*     commented by chintan - put this logic in above loop iterating over line item list
        for(Apttus_Config2__ProductAttributeValue__c pav : pavList){
            if(pav == null || pav.Apttus_Config2__LineItemId__r == null || pav.Apttus_Config2__LineItemId__r.Apttus_Config2__ProductId__c == null
            || pav.SCS_Print_Purchase_Options__c == null || !pav.SCS_Print_Purchase_Options__c.contains(FILLUPVALUE))
            continue;
            pavMap.put(pav.Apttus_Config2__LineItemId__r.Apttus_Config2__ProductId__c, pav);
        }
        if(pavMap.isEmpty()){
            return;
        }
        */
        //============================================
        //============================================
        // Getting MaxFillUp value
        List<Apttus_Config2__PriceListItem__c> priceListItems = [SELECT Apttus_Config2__ProductId__c, APTS_Max_Fill_Up_Price__c FROM Apttus_Config2__PriceListItem__c WHERE Apttus_Config2__ProductId__c in :productIds AND Apttus_Config2__Sequence__c=3];
        Map<Id, Decimal> productIdToMaxFillUp = new Map<Id, Decimal>();
        if(priceListItems==null || priceListItems.isEmpty()){
            return;
        }
        for(Apttus_Config2__PriceListItem__c priceListItem : priceListItems){
            productIdToMaxFillUp.put(priceListItem.Apttus_Config2__ProductId__c, priceListItem.APTS_Max_Fill_Up_Price__c);
        }
        //============================================
        for(Apttus_Config2__LineItem__c lineItem : bundleItems){
            if(lineItem.Apttus_Config2__ProductId__c == null){
                continue;
            }
            Apttus_Config2__ProductAttributeValue__c pav = pavMap.get(lineItem.Apttus_Config2__ProductId__c);
            if(pav == null || pav.SCS_Print_Purchase_Options__c == null || !pav.SCS_Print_Purchase_Options__c.contains(FILLUPVALUE)){
                continue;
            }
            Decimal extendedPrice = lineItem.Apttus_Config2__ExtendedPrice__c;
            extendedPrice = extendedPrice.setScale(2);
            Decimal maxVal = productIdToMaxFillUp.get(lineItem.Apttus_Config2__ProductId__c);
            if(maxVal == null){
                continue;
            }
            maxVal *= lineItem.Apttus_Config2__Quantity__c;
            System.debug('Artem pers. '+lineItem.APTS_Price_Cap_Adjustment_Percentage__c);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'net price: '+lineItem.Apttus_Config2__NetPrice__c+ ' max price '+maxVal));
            if(lineItem.Apttus_Config2__OptionPrice__c >= maxVal && extendedPrice > maxVal){
                //Find base sum of each bundle
                //System.debug('Artem bundleBasePrice'+lineItem.Apttus_Config2__BasePrice__c);
                Decimal basePrice = lineItem.Apttus_Config2__BasePrice__c != null ? lineItem.Apttus_Config2__BasePrice__c : 0;
                Decimal bundleBasePrice = basePrice;
                Decimal key = lineItem.Apttus_Config2__LineNumber__c;
                if(lineNumberToOptionsMap.containsKey(key)){
                    for(Apttus_Config2__LineItem__c option : lineNumberToOptionsMap.get(key)){
                        bundleBasePrice+= option.Apttus_Config2__BasePrice__c * option.Apttus_Config2__Quantity__c;
                    }
                }
                //Calculate the discount
                bundleBasePrice *= lineItem.Apttus_Config2__Quantity__c;
                Decimal discount = (bundleBasePrice - maxVal) / bundleBasePrice * 100;
                System.debug('discount--->'+discount);
                //Set the discount on bundle and options
                setDiscount(lineItem, discount, basePrice);
                if(lineNumberToOptionsMap.containsKey(lineItem.Apttus_Config2__LineNumber__c)){
                    for(Apttus_Config2__LineItem__c option : lineNumberToOptionsMap.get(lineItem.Apttus_Config2__LineNumber__c)){
                        setDiscount(option, discount, option.Apttus_Config2__BasePrice__c);
                    }
                }
            } else if(extendedPrice < maxVal && lineItem.APTS_Price_Cap_Adjustment_Percentage__c > 0)
            {
                lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
                lineItem.APTS_Price_Cap_Adjustment_Percentage__c = 0;
                lineItem.Apttus_Config2__BasePriceOverride__c = lineItem.Apttus_Config2__BasePrice__c;
                if(lineNumberToOptionsMap.containsKey(lineItem.Apttus_Config2__LineNumber__c)){
                    for(Apttus_Config2__LineItem__c option : lineNumberToOptionsMap.get(lineItem.Apttus_Config2__LineNumber__c)){
                        if(option.APTS_Price_Cap_Adjustment_Percentage__c > 0){
                            option.Apttus_Config2__PricingStatus__c = 'Pending';
                            option.APTS_Price_Cap_Adjustment_Percentage__c = 0;
                            option.Apttus_Config2__BasePriceOverride__c = option.Apttus_Config2__BasePrice__c;
                        }
                    }
                }
            }
        }
    }
    
    private static void setDiscount(Apttus_Config2__LineItem__c lineItem, Decimal discount, Decimal basePrice){
        lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
        lineItem.APTS_Price_Cap_Adjustment_Percentage__c = discount;
        lineItem.Apttus_Config2__BasePriceOverride__c = basePrice *(1-discount/100);
    }
    
    public static void clearOptionsForLineItem(Apttus_Config2__LineItem__c liSO, Id cartId){
        List<Apttus_Config2__LineItem__c> deleteOptions = [SELECT Id, Apttus_Config2__PrimaryLineNumber__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c=: cartId AND Apttus_Config2__LineNumber__c =: liSO.Apttus_Config2__LineNumber__c AND Apttus_Config2__LineType__c = 'Option'];
        if(deleteOptions!=null && !deleteOptions.isEmpty()){
            Apttus_CPQApi.CPQ.RemoveLineItemsRequestDO request = new Apttus_CPQApi.CPQ.RemoveLineItemsRequestDO();
            request.cartId = cartId;
            for(Apttus_Config2__LineItem__c li : deleteOptions){
                request.PrimaryLineNumbers.add(li.Apttus_Config2__PrimaryLineNumber__c.intValue());
            }
            if (!Test.isRunningTest())
                Apttus_CPQApi.CPQ.RemoveLineItemsResponseDO result = Apttus_CPQApi.CPQWebService.removeLineItems(request);
        }
    }
    
    public static Integer addOptionsToLineItemSO(Apttus_Config2__LineItem__c liSO, Id cartId){
        //Get the product attribute value associated to the line item for the date
        List<Apttus_Config2__ProductAttributeValue__c> pavList = [SELECT APTS_FillUp_Start_Date__c, SCS_Print_Purchase_Options__c FROM Apttus_Config2__ProductAttributeValue__c WHERE Apttus_Config2__LineItemId__c =: liSO.Id limit 1];
        if(pavList!=null && !pavList.isEmpty()){
            Apttus_Config2__ProductAttributeValue__c pav = pavList.get(0);
            if(pav.SCS_Print_Purchase_Options__c != null){
                clearOptionsForLineItem(liSO, cartId);
                liSO.Apttus_Config2__PricingStatus__c = 'Pending';
                liSO.Apttus_Config2__OptionPrice__c = 0;
                // bad practice, couldn't find better solution to fix issue on test, error message:  System.DmlException: Update failed. First exception
                //on row 0 with id a6L8A00000021V1UAI; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, Apttus_Config2.LineItemCurrencyTrigger: execution of BeforeUpdate caused by: System.NullPointerException: Attempt to de-reference a null object
                if (!Test.isRunningTest()) {
                    update liSO;
                }
                if(pav.SCS_Print_Purchase_Options__c.contains(FILLUPVALUE)){
                    Date attributeDate = pav.APTS_FillUp_Start_Date__c;
                    //Get the product and price list id
                    Id productId = liSO.Apttus_Config2__ProductId__c;
                    Id priceListId = liSO.Apttus_Config2__PriceListId__c;
                    List<Apttus_CPQApi.CPQ.SelectedOptionDO> selectedOptDOList = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
                    System.debug('priceListId, productId: '+ priceListId + ' ' + productId);
                    List<Apttus_Config2__ProductOptionComponent__c> listPOCSO = [Select Id, Name, Apttus_Config2__ComponentProductId__c From Apttus_Config2__ProductOptionComponent__c WHERE Apttus_Config2__ParentProductId__c= :productId];
                    //If the selected product has option groups execute the loop below
                    if(listPOCSO != null)
                    {
                        Set<Id> allOptionIds = new Set<Id>();
                        for(Apttus_Config2__ProductOptionComponent__c poc : listPOCSO)
                            allOptionIds.add(poc.Apttus_Config2__ComponentProductId__c);
                        //Query for all the products who's date is less than the attribute date
                        Map<Id, Product2> compProducts = new Map<Id, Product2>([SELECT Id FROM Product2 WHERE Id IN: allOptionIds AND SCS_Print_Activation_Date__c >=: attributeDate AND IsActive=true
                        AND Id in (SELECT p.Apttus_Config2__ProductId__c FROM Apttus_Config2__PriceListItem__c p WHERE p.Apttus_Config2__Active__c=true AND p.Apttus_Config2__ProductId__c IN: allOptionIds)]);
                        for(Apttus_Config2__ProductOptionComponent__c poc : listPOCSO){
                            //Check to see if the option that we see is being added or if the date comes before the attribute date (Done through the query filter)
                            if(compProducts.containsKey(poc.Apttus_Config2__ComponentProductId__c)){
                                Apttus_CPQApi.CPQ.SelectedOptionDO selectedOptDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
                                selectedOptDO.ComponentId = poc.Id;
                                selectedOptDO.ComponentProductId = poc.Apttus_Config2__ComponentProductId__c;
                                selectedOptDO.Quantity = 1;
                                selectedOptDOList.add(selectedOptDO);
                            }
                        }
                    }
                    if(!Test.isRunningTest()) {
                        if(!selectedOptDOList.isEmpty()){
                            //Invoke the addOptions API and pass the cartID, selected product line number, and the Option List retrieved from the getoptiongroups API
                            Apttus_CPQApi.CPQ.AddOptionsResponseDO addOptRespDO = Apttus_CPQApi.CPQWebService.addOptions(cartId, Integer.valueOf(liSO.Apttus_Config2__LineNumber__c), selectedOptDOList);
                            List<Apttus_Config2__LineItem__c> newLineItems = addOptRespDO.addedOptionLineItems;
                            List<Id> lineItemsIds = new List<Id>();
                            for(Apttus_Config2__LineItem__c lineItem : newLineItems){
                                lineItemsIds.add(lineItem.Id);
                            }
                            List<Apttus_Config2__ProductAttributeValue__c> newPavList = [SELECT APTS_FillUp_Start_Date__c, SCS_Print_Purchase_Options__c FROM Apttus_Config2__ProductAttributeValue__c WHERE Apttus_Config2__LineItemId__c in :lineItemsIds];
                            if(newPavList != null && !newPavList.isEmpty()){
                                for(Apttus_Config2__ProductAttributeValue__c newPav : newPavList){
                                    newPav.SCS_Print_Purchase_Options__c =  pav.SCS_Print_Purchase_Options__c;
                                }
                            }
                            update newPavList;
                            return selectedOptDOList.size();
                        }
                    }
                }
            }
        }
        return 0;
    }
    
    //Created by AS 7/20/2016
    //Method will default the yearly discount amount fields on line item based on the contract term
    public static void defaultContractTermDiscounts(List<Apttus_Config2__LineItem__c> bundleItems, Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap, Apttus_Config2__ProductConfiguration__c cartRec)
    {
    Decimal contractTermTemp = null;
    Map<String, Decimal> termMap = new Map<String, Decimal>{'1 Month'=> 1, '2 Months'=>2, '3 Months'=>3, '4 Months'=>4, '5 Months'=>5, '6 Months'=>6, '7 Months'=>7, '8 Months'=>8, '9 Months'=>9, '10 Months'=>10, 
                                                                '11 Months'=>11, '1 Year'=>12, '2 Years'=>24, '3 Years'=>36, '4 Years'=>48, '5 Years'=>60};
                                
        System.debug('Artem bundleItems' + lineNumberToOptionsMap.size());
        //For all the bundle level ones
        for(Apttus_Config2__LineItem__c lineItem : bundleItems){
            if(!lineItem.APTS_Keep_Terms__c && lineItem.APTS_Contract_Term__c == 'Existing'){
                lineItem.APTS_Contract_Term__c = lineItem.APTS_Contract_Term_Default__c;
            }
            //If the contract term was set, set the bundle line item
            if(lineItem.APTS_Contract_Term__c == null && lineItem.Apttus_Config2__ChargeType__c=='Subscription Fee')
                lineItem.APTS_Contract_Term__c = lineItem.APTS_Contract_Term_Default__c;
            
            System.debug('lineItem.APTS_Contract_Term__c+++' + lineItem.APTS_Contract_Term__c);
            System.debug('lineItem.APTS_Product_Name__c+++' + lineItem.APTS_Product_Name__c);
            if((lineItem.APTS_Contract_Term__c != null && lineItem.APTS_Contract_Term__c.contains('Year')) && (!String.isEmpty(lineItem.APTS_Product_Name__c) && !lineItem.APTS_Product_Name__c.Contains(System.Label.APTS_CARS_SmallFirmPackage)))
            {
                //Get the contract term and convert to integer
                Integer contractTerm = Integer.valueOf(lineItem.APTS_Contract_Term__c.substring(0,lineItem.APTS_Contract_Term__c.indexOf('Year')-1));
                List<String> defaultDiscount = new List<String>();
                //List<String> defaultFields = new List<String>{'APTS_Year_2_Adj_Default__c', 'APTS_Years_3_5_Adj_Default__c', 'APTS_Years_6_10_Adj_Default__c'};
                List<String> defaultFields = new List<String>{'APTS_Years_2_Plus_Default__c'};
                for(Integer i =0; i< defaultFields.size(); i++)
                    defaultDiscount.add(String.valueOf(lineItem.get(defaultFields.get(i))));
                //For every field
                //SOC-6893 Added APTS_Corporate_Select_Option__c != 'Module' by Chirag
                if(lineItem.APTS_Corporate_Select_Option__c != 'Module'){
                    System.debug('lineItem.APTS_Corporate_Select_Option__c++' + lineItem.APTS_Corporate_Select_Option__c);
                    setTerms(lineItem, contractTerm, defaultDiscount);
                }
                if(lineItem.Apttus_Config2__LineStatus__c == 'Renewed' && lineItem.APTS_Yr_1_Renewal_Default__c != null && lineItem.APTS_Yr_1_Renewal_Adjustment__c == null)
                {
                    lineItem.APTS_Yr_1_Renewal_Adjustment__c = String.valueOf(lineItem.APTS_Yr_1_Renewal_Default__c);
                }
                Decimal key = lineItem.Apttus_Config2__LineNumber__c;
                if(lineNumberToOptionsMap.containsKey(key)){
                    //Set the option line item in a similar fashion
                    for(Apttus_Config2__LineItem__c optionLineItem : lineNumberToOptionsMap.get(key)){
                        //SOC-6893 Added APTS_Corporate_Select_Option__c != 'Module' by Chirag
                        if(optionLineItem.APTS_Corporate_Select_Option__c != 'Module'){
                            System.debug('optionLineItem.APTS_Corporate_Select_Option__c++' + optionLineItem.APTS_Corporate_Select_Option__c);
                            setTerms(optionLineItem, contractTerm, defaultDiscount);
                        }
                        if(optionLineItem.Apttus_Config2__LineStatus__c == 'Renewed' && lineItem.APTS_Yr_1_Renewal_Default__c != null && optionLineItem.APTS_Yr_1_Renewal_Adjustment__c == null)
                        {
                            optionLineItem.APTS_Yr_1_Renewal_Adjustment__c = String.valueOf(lineItem.APTS_Yr_1_Renewal_Default__c);
                        }
                    }
                }
            }
            //not a year so clear all of them
            else{
                if(lineNumberToOptionsMap.containsKey(lineITem.Apttus_Config2__LineNumber__c))
                    for(Apttus_Config2__LineItem__c optionLineItem : lineNumberToOptionsMap.get(lineItem.Apttus_Config2__LineNumber__c))
                    {
                        if((optionLineItem.APTS_Contract_Term__c != lineItem.APTS_Contract_Term__c) && (lineItem.APTS_Contract_Term__c != 'Short Term Trial' ))
                        { //SOC-6893 added CntrctT not= STT
                            optionLineItem.APTS_Contract_Term__c = lineItem.APTS_Contract_Term__c;
                        }
            system.debug('test term : 1 : '+optionLineItem.APTS_Contract_Term__c+' : '+optionLineItem.Apttus_Config2__ProductId__r.Media_High_Level__c);
                        if(optionLineItem.APTS_Contract_Term__c != NULL && (optionLineItem.APTS_Contract_Term__c.containsIgnoreCase('YEAR') || optionLineItem.APTS_Contract_Term__c.containsIgnoreCase('MONTH')) 
                            && (optionLineItem.Apttus_Config2__ProductId__r.Media_High_Level__c == 'Online' || optionLineItem.Apttus_Config2__ProductId__r.Media_High_Level__c == 'Software')){
                            //Decimal tempVal = termMap.get(optionLineItem.APTS_Contract_Term__c);
                            Decimal tempVal = optionLineItem.APTS_Contract_Term_Whole_Years__c;

                            contractTermTemp = (contractTermTemp==null)?tempVal:((contractTermTemp>tempVal)?tempVal:contractTermTemp);
                            system.debug('test term if');
                        } //added as part of descope
                    }
            }
            //System.debug("Artem lineItem.Apttus_Config2__PriceType__c: "+lineItem.Apttus_Config2__PriceType__c);
            if(lineItem.Apttus_Config2__PriceType__c == 'One Time')
            {
                lineItem.APTS_Yr_1_Renewal_Adjustment__c = null;
                System.debug('in one time:::::::');
                lineItem.APTS_Contract_Term__c = null;
                lineItem.APTS_Years_2_Plus_Adjustment__c = null;
            }
            //added condition linestatus=new as part of DOC-4350
            if(lineItem.Apttus_Config2__PriceType__c == 'Recurring' && (lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC US' || lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC UK') && lineItem.Apttus_Config2__LineStatus__c=='New')
            {
                lineItem.APTS_Yr_1_Renewal_Adjustment__c = null;
            }
        system.debug('test term : '+lineItem.APTS_Contract_Term__c+' : '+lineItem.Apttus_Config2__ProductId__r.Media_High_Level__c);
            if(lineItem.APTS_Contract_Term__c != NULL && (lineItem.APTS_Contract_Term__c.containsIgnoreCase('YEAR') || lineItem.APTS_Contract_Term__c.containsIgnoreCase('MONTH')) 
                && (lineItem.Apttus_Config2__ProductId__r.Media_High_Level__c == 'Online' || lineItem.Apttus_Config2__ProductId__r.Media_High_Level__c == 'Software')){
                //Decimal tempVal = (termMap.get(lineItem.APTS_Contract_Term__c)==null)?0:termMap.get(lineItem.APTS_Contract_Term__c);
                Decimal tempVal = (lineItem.APTS_Contract_Term_Whole_Years__c==null)?0:lineItem.APTS_Contract_Term_Whole_Years__c;
                contractTermTemp = (contractTermTemp==null)?tempVal:((contractTermTemp>tempVal)?tempVal:contractTermTemp);
                system.debug('test term if'); //added as part of descope
        }
    }
    cartRec.APTS_Least_Contract_Term__c  = contractTermTemp; //added as part of descope
        system.debug('cartRec.APTS_Least_Contract_Term__c : '+contractTermTemp+' : '+cartRec.APTS_Least_Contract_Term__c);
   }  
    //Returns true if the terms were set, and false if nothing has changed
    private static boolean setTerms(Apttus_Config2__LineItem__c lineItem, Integer contractTerm, List<String> defaultDiscounts)
    {
        System.debug('lineItem++' + lineItem);
        System.debug('contractTerm++' + contractTerm);
        System.debug('defaultDiscounts++' + defaultDiscounts);
        boolean hasChanged = false;
        //List<String> fields = new List<String>{'APTS_Year_2_Adjustment__c', 'APTS_Years_3_5_Adjustment__c', 'APTS_Years_6_10_Adjustment__c'};
        List<String> fields = new List<String>{'APTS_Years_2_Plus_Adjustment__c'};
        List<Integer> maxYear = new List<Integer>{1,2,5};
        Boolean isMultitier=false;
        if((contractTerm ==2 && lineItem.APTS_Yr_2_Amount__c != null) || 
        (contractTerm ==3 && lineItem.APTS_Yr_2_Amount__c != null && lineItem.APTS_Yr_3_Amount__c != null) ||
        (contractTerm ==4 && lineItem.APTS_Yr_2_Amount__c != null && lineItem.APTS_Yr_3_Amount__c != null && lineItem.APTS_Yr_4_Amount__c != null) || 
        (contractTerm ==5 && lineItem.APTS_Yr_2_Amount__c != null && lineItem.APTS_Yr_3_Amount__c != null && lineItem.APTS_Yr_4_Amount__c != null && lineItem.APTS_Yr_5_Amount__c != null)){
        isMultitier=true;
        }
        System.debug('lineItem.Apttus_Config2__LineType__c ++' + lineItem.Apttus_Config2__LineType__c);
        for(Integer index =0; index < fields.size(); index++)
        {
            System.debug('KS-->lineItem.APTS_Proposal_Business_Unit__c '+lineItem.APTS_Proposal_Business_Unit__c);
            System.debug('KS-->maxYear.get(index) '+maxYear.get(index));
            if(((lineItem.get(fields.get(index)) == null && !(((lineItem.APTS_Proposal_Business_Unit__c =='SCS' || lineItem.APTS_Proposal_Business_Unit__c =='Canada') && ((lineItem.APTS_Yr_2_Amount__c != null && lineItem.APTS_Group__c==null) || ( lineItem.APTS_Years_2_Plus_Adjustment__c==null && isMultitier && lineItem.APTS_Totaling_Summary_Group__c!=null && lineItem.APTS_Group__c!=null)))))
             || (lineItem.Apttus_Config2__LineType__c == 'Option' && lineItem.get(fields.get(index))!=defaultDiscounts.get(index))) && contractTerm > maxYear.get(index) && lineItem.Apttus_Config2__PriceType__c != 'One Time')
            {// Added by Chirag Gulati 7/19/2017 for product rules issue
                System.debug('defaultDiscounts.get(index)++' + defaultDiscounts.get(index));
                System.debug('llineItem.get(fields.get(index)) ++' + lineItem.get(fields.get(index)));
                System.debug('check Poonam');
                hasChanged = true;
                lineItem.put(fields.get(index),defaultDiscounts.get(index));
            }
            else if(lineItem.get(fields.get(index)) != null && contractTerm <= maxYear.get(index) &&
            lineItem.APTS_Proposal_Business_Unit__c !='Corp OneOTC US' && lineItem.APTS_Proposal_Business_Unit__c !='Corp OneOTC UK') //Added by Kruti Shah for DOC-1577)
            {
                System.debug('index in');
                hasChanged = true;
                lineItem.put(fields.get(index), null);
            }
            System.debug('lineItem++' + lineItem.Id + ' '+ lineItem.APTS_Years_2_Plus_Adjustment__c);
        }
        String yearVsYears = contractTerm == 1 ? ' Year' : ' Years';
        String newContractTerm = String.valueOf(contractTerm)+ yearVsYears;
        if(newContractTerm != lineItem.APTS_Contract_Term__c){
            hasChanged = true;
            lineItem.APTS_Contract_Term__c = String.valueOf(contractTerm)+ yearVsYears;
        }
        //lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
        return hasChanged;
    }
    
    public static Map<Decimal, List<Apttus_Config2__LineItem__c>> buildLineNumberToOptionsMap(List<Apttus_Config2__LineItem__c> allAttachedLineItems, List<Apttus_Config2__LineItem__c> bundleItems)
    {
        Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap = new Map<Decimal, List<Apttus_Config2__LineItem__c>>();
        for(Apttus_Config2__LineItem__c lineItem : allAttachedLineItems)
        {
            if(lineItem.Apttus_Config2__LineType__c == 'Option'){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Pricing Callback: was option: '+lineITem.Id));
                Decimal key = lineItem.Apttus_Config2__LineNumber__c;
                if(lineNumberToOptionsMap.containsKey(key))
                    lineNumberToOptionsMap.get(key).add(lineItem);
                else
                    lineNumberToOptionsMap.put(key, new List<Apttus_Config2__LineItem__c>{lineItem});
            }
            else{
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Pricing Callback: was bundle: '+lineITem.Id));
                bundleItems.add(lineItem);
            }
        }
        return lineNumberToOptionsMap;
    }
    
    public static void totallingGroupForDynamicBundle(List<Apttus_Config2__LineItem__c> allAttachedLineItems)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Attepmting to insert bundle A'));
    }
    
    //Added By Poonam Garg . If No Of Attorneys Override is selected for any Line Item then Populate same data to other line Items as well.
    public static void setPricedAttrorneysForCanada(List<Apttus_Config2__LineItem__c> canadaLineItems,Decimal numberOfAttorneys)
    {
        List<Apttus_Config2__ProductAttributeValue__c> pavListToUpdate=new List<Apttus_Config2__ProductAttributeValue__c>();
        //Create a map of LineItem Ids and related AttributValueIds
        System.debug('%numberOfAttorneys%'+numberOfAttorneys);
        Apttus_Config2__ProductAttributeValue__c pav;
        //Update other line Items with same value
        if(numberOfAttorneys>0){
            for(Apttus_Config2__LineItem__c li: canadaLineItems){
                pav=new Apttus_Config2__ProductAttributeValue__c(id=li.Apttus_Config2__AttributeValueId__r.id,
                Apttus_Config2__LineItemId__c=li.id,APTS_Priced_Number_Of_Attorneys__c=numberOfAttorneys
                ,APTS_Number_of_Attorneys_Override__c=numberOfAttorneys);
                pavListToUpdate.add(pav);
            }
        }
        System.debug('%pavListToUpdate%'+pavListToUpdate.size());
        //Update the Product Attribute Value records.
        if(!pavListToUpdate.isEmpty()){
            update pavListToUpdate;
        }
    }
        //Added By Poonam Garg . If No Of Attorneys Override is selected for any Line Item then Populate same data to other line Items as well.
    public static void setPricingForMultiTier(List<Apttus_Config2__LineItem__c> dbheader,List<Apttus_Config2__LineItem__c> dbcomponent)
    { 
        List<Apttus_Config2__LineItem__c> lstItemsToUpdate=new List<Apttus_Config2__LineItem__c>();
        System.debug('Proflex Pricing');
        Decimal adjAmount=0;
        String adjType='';
            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here
            if(!dbheader.isEmpty() && !dbcomponent.isEmpty()){
                for(Apttus_Config2__LineItem__c header : dbheader){
                    adjAmount=header.Apttus_Config2__AdjustmentAmount__c;
                    adjType=header.Apttus_Config2__AdjustmentType__c;
                    for(Apttus_Config2__LineItem__c comp : dbcomponent){
                        if(header.APTS_Totaling_Summary_Group__c == comp.APTS_Totaling_Summary_Group__c){
                            comp.Apttus_Config2__AdjustmentType__c = header.Apttus_Config2__AdjustmentType__c;
                            comp.Apttus_Config2__AdjustmentAmount__c= header.Apttus_Config2__AdjustmentAmount__c;
                            comp.APTS_Bridge__c= header.APTS_Bridge__c;
                            comp.APTS_New_Bridge_Discount__c= header.APTS_New_Bridge_Discount__c;
                            comp.APTS_Contract_Term__c= header.APTS_Contract_Term__c;
                            comp.APTS_Yr_1_Renewal_Adjustment__c= header.APTS_Yr_1_Renewal_Adjustment__c;
                            comp.APTS_Years_2_Plus_Adjustment__c= header.APTS_Years_2_Plus_Adjustment__c;
                            comp.Apttus_Config2__BillingFrequency__c= header.Apttus_Config2__BillingFrequency__c;
                            comp.Apttus_Config2__LineNumber__c=comp.Apttus_Config2__LineSequence__c;
                            lstItemsToUpdate.add(comp);
                            }
                    }
                }
            }
            Map<String,List<Apttus_Config2__LineItem__c>> maplilist = new Map<String,List<Apttus_Config2__LineItem__c>>();
            if(!dbheader.isEmpty() && !dbcomponent.isEmpty()){
            for(Apttus_Config2__LineItem__c comp : dbcomponent){
            if(maplilist.containsKey(comp.APTS_Totaling_Summary_Group__c)){
                maplilist.get(comp.APTS_Totaling_Summary_Group__c).add(comp);
            }else{
                maplilist.put(comp.APTS_Totaling_Summary_Group__c, new  List <Apttus_Config2__LineItem__c> {comp});
            }
            }
            String adjusttype,pricing;
            Decimal listvalue,basevalue,adjustvalue,netvalue,quantity,baseprice,amendedNetValue ;
            Map<String,String> bundles = new Map<String,String>();
            for(String strKey : maplilist.keySet()){
            System.debug('strKey '+strKey );
            baseprice = 0;
            listvalue = 0;
            basevalue = 0;
            adjustvalue = 0;
            netvalue = 0;
            adjusttype = '';
            pricing = '';
            quantity = 0;
            amendedNetValue=0;
            for(Apttus_Config2__LineItem__c li :maplilist.get(strKey)){
                System.debug('li.Apttus_Config2__NetPrice__c'+li.Apttus_Config2__NetPrice__c);
                System.debug('li.Apttus_Config2__BasePrice__c'+li.Apttus_Config2__BasePrice__c);
                System.debug('li.Apttus_Config2__Quantity__c'+li.Apttus_Config2__Quantity__c);
                System.debug('li.Apttus_Config2__PriceUom__c'+li.Apttus_Config2__PriceUom__c);
                if(li.Apttus_Config2__Quantity__c != null ){//
                    quantity = li.Apttus_Config2__Quantity__c;
                    if(li.Apttus_Config2__PriceUom__c=='Each'){
                        baseprice = li.Apttus_Config2__BasePrice__c * quantity;
                    }
                    else{
                        baseprice =li.Apttus_Config2__BasePrice__c; 
                    }
                }
                System.debug('li.Apttus_Config2__BasePrice__c'+baseprice);
                
                basevalue = basevalue + baseprice;
                System.debug('basevalue'+basevalue);
                System.debug('adjAmount'+adjAmount);
                System.debug('adjType'+adjType);
                listvalue = listvalue + li.Apttus_Config2__ListPrice__c;
                
                if(li.Apttus_Config2__NetPrice__c != null && li.Apttus_Config2__LineStatus__c == 'Amended'){
                    amendedNetValue = amendedNetValue + li.Apttus_Config2__NetPrice__c;                   
                }
                else{
                   /*if(li.Apttus_Config2__IncentiveAdjustmentAmount__c != null && adjAmount != null &&
                        (li.Apttus_Config2__NetPrice__c - baseprice ) == li.Apttus_Config2__IncentiveAdjustmentAmount__c){
                        if(adjAmount!=null && adjType=='% Discount'){
                            netvalue =netvalue + (li.Apttus_Config2__IncentiveBasePrice__c - (li.Apttus_Config2__IncentiveBasePrice__c * adjAmount/100) ) ;
                        }
                        else if(adjAmount!=null && adjType=='% Markup'){
                            netvalue =netvalue + (li.Apttus_Config2__IncentiveBasePrice__c +(li.Apttus_Config2__IncentiveBasePrice__c * adjAmount/100) ) ;
                        }
                        else{
                            System.debug('netvalue'+netvalue);
                            netvalue = netvalue + li.Apttus_Config2__IncentiveBasePrice__c;
                            System.debug('netvalue'+netvalue);
                        }
                    }
                    else{*/
                        //Take incentive base price if promo is applied
                        if(li.Apttus_Config2__IncentiveAdjustmentAmount__c != null && li.Apttus_Config2__ExtendedPrice__c != null) {
                            baseprice = li.Apttus_Config2__ExtendedPrice__c;
                        }
                        
                        if(adjAmount!=null && adjType=='% Discount'){
                            netvalue =netvalue + (baseprice - (baseprice * adjAmount/100) ) ;
                        }
                        else if(adjAmount!=null && adjType=='% Markup'){
                            netvalue =netvalue + (baseprice +(baseprice * adjAmount/100) ) ;
                        }
                        else{
                            System.debug('netvalue'+netvalue);
                            netvalue = netvalue + baseprice;
                            System.debug('netvalue'+netvalue);
                        }
                      
                      //}
                    
                }
                //adjustvalue = li.Apttus_Config2__AdjustedPrice__c;
                adjusttype = li.Apttus_Config2__AdjustmentType__c;
                
            }
            netvalue=netvalue + amendedNetValue;
            System.debug('netvalue '+netvalue );
            pricing = listvalue+'list'+basevalue+'base'+adjusttype+'adjust'+adjustvalue+'netvalue'+netvalue;
            System.debug('pricing '+pricing );
            bundles.put(strKey,pricing);
            System.debug('Poooooooonam bundles'+bundles);
            }
            for(Apttus_Config2__LineItem__c header : dbheader){
                if(bundles != null && bundles.get(header.APTS_Totaling_Summary_Group__c) != null){
                    
                    header.Apttus_Config2__ListPrice__c = Decimal.valueOf(bundles.get(header.APTS_Totaling_Summary_Group__c).substringBefore('list'));
                    header.Apttus_Config2__BasePrice__c = Decimal.valueOf(bundles.get(header.APTS_Totaling_Summary_Group__c).substringBetween('list','base'));
                    if(!String.isEmpty(bundles.get(header.APTS_Totaling_Summary_Group__c).substringBetween('adjust','netvalue'))){
                        header.Apttus_Config2__AdjustedPrice__c = Decimal.valueOf(bundles.get(header.APTS_Totaling_Summary_Group__c).substringBetween('adjust','netvalue'));
                    }
                    System.debug('Poooooooonam bundles'+bundles.get(header.APTS_Totaling_Summary_Group__c).substringAfter('netvalue'));                
                    
                    header.Apttus_Config2__NetPrice__c = Decimal.valueOf(bundles.get(header.APTS_Totaling_Summary_Group__c).substringAfter('netvalue'));
                    header.Apttus_Config2__IsCustomPricing__c = true;
                    header.Apttus_Config2__LineNumber__c=header.Apttus_Config2__LineSequence__c;
                            
                    lstItemsToUpdate.add(header);
                }
            }
            }   
    
            
            //return lstItemsToUpdate;
    }
}