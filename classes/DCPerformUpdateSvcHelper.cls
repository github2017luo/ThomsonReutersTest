/*
 * This class has all service related to Digital configurations like Loading data using opportunity, add/Remove product from Cart. 
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 *  Date            Name                    Description
 *  2020-09-23      Benjamin Her            DLT-20827 Creation of class. PMD fix of DCGetQuoteDetails/DCQuoteService
 * ==================================================================================================================================

 */
public without sharing class DCPerformUpdateSvcHelper{

    //Final Variables
    private static final String LINE_STATUS_CANCELLED = 'Cancelled';
    private static final String CART_STATUS_FINALIZED = 'Finalized';
    private static final String QUOTE_TYPE_STRAIGHT_RENEWAL = 'Straight Renewal';
    private static final String PRODUCT_PRICING_MODEL_BANDED = 'Banded'; 

    public DCQuoteService.YOYValues objYoy = new DCQuoteService.YOYValues();
    private static Map<String, String> dsFirmMap = new Map<String, String>();  
    
    private Set<String> quoteIds = new Set<String>();
    private Map<String,String> quoteIdToType = new Map<String,String>();
    private Map<String,DCQuoteUpdate.QuoteUpdateRequest> quoteIdToUpdateRequestLanding = new Map<String,DCQuoteUpdate.QuoteUpdateRequest>();
    private Map<String,DCQuoteUpdate.QuotePricingStatus> quoteIdToPricingStatus = new Map<String,DCQuoteUpdate.QuotePricingStatus>();
    private Map<String,Apttus_Proposal__Proposal__c> quoteIdToToBeUpdatedQuotes = new Map<String,Apttus_Proposal__Proposal__c>();
    private String yr1RenewalAdjustment;
    private String yr2RenewalAdjustment;
    private Decimal newAdjustmentAmount;
    private String newAdjustmentType;        
    private Decimal defaultAdjustmentAmount;
    private Decimal dsAdjustmentAmount;
    private String defaultContractTem;
    private String defaultAdjustmentType;
    private Integer defaultQuantity;


    private void getRequestDetails(List<DCQuoteUpdate.QuoteUpdateRequest> landings){
        for(DCQuoteUpdate.QuoteUpdateRequest landing : landings){
            if(String.isNotBlank(landing.quoteId)){//If Quote is not null
                quoteIds.add(landing.quoteId);
                //Setting maps
                quoteIdToType.put(landing.quoteId,landing.quoteType);
                quoteIdToUpdateRequestLanding.put(landing.quoteId,landing);
            }
        }//End of For Loop
    }

    public DCQuoteUpdate.QuoteUpdateResponse updateAllLineItems(List<DCQuoteUpdate.QuoteUpdateRequest> landings,Boolean isResetQuote){
        System.debug('landings  '+landings);
        //Initailizing the mapsupdateAllLineItems
        DCQuoteUpdate.QuoteUpdateResponse response = new DCQuoteUpdate.QuoteUpdateResponse();//Looping through AEM request to update Line items sent form Landing page.
        
        //Parse through the 'landings' request and gets the values 
        getRequestDetails(landings);

        System.debug('quoteIdToUpdateRequestLanding-->'+quoteIdToUpdateRequestLanding);
        System.debug('quoteIds  '+quoteIds);        
        
        try{
            //Getting the Carts data for the requested proposals
            List<Apttus_Config2__ProductConfiguration__c> carts = new List<Apttus_Config2__ProductConfiguration__c>();
            List<Apttus_Config2__LineItem__c> lineItemsToBeUpdated = new List<Apttus_Config2__LineItem__c>();
            List<Apttus_Config2__ProductConfiguration__c> cartsToBeUpdated = new List<Apttus_Config2__ProductConfiguration__c>();
            List<Product_Account_Detail__c> dslist = new List<Product_Account_Detail__c>();


            if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible() 
                && Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){ //DLT-11738

                carts = [SELECT id,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                            Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c,
                            Ecom_No_of_Attorneys__c,Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c,Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c,
                            Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c,Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c,
                            Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c,
                            Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c, APTS_SSD_bill_to__r.LCRM_SAP_Account_Number__c,
                            (SELECT id,name,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__PrimaryLineNumber__c, 
                                Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__Quantity__c, Apttus_Config2__NetPrice__c,
                                APTS_Contract_Term__c , APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Bridge_Discount__c,APTS_Bridge__c,
                                Apttus_Config2__BasePrice__c,Apttus_Config2__HasOptions__c // DLT-18617
                            FROM Apttus_Config2__LineItems__r 
                            WHERE Apttus_Config2__LineStatus__c !=:LINE_STATUS_CANCELLED ) 
                        FROM Apttus_Config2__ProductConfiguration__c 
                        //Filtering based on Quote Ids and Finalized cart status
                        WHERE Apttus_QPConfig__Proposald__c IN : quoteIds 
                        AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED
                        WITH SECURITY_ENFORCED];
            }//End of If

            dsList = getDigitalSubscriptionData(carts);

            // Getting customer number,campaign code and renewal date from cart.
            System.debug('carts'+carts);
            //Looping through Carts
            for(Apttus_Config2__ProductConfiguration__c cart : carts){

                DCQuoteUpdate.QuoteUpdateRequest request = quoteIdToUpdateRequestLanding.get(cart.Apttus_QPConfig__Proposald__c);
                System.debug('request'+request);

                List<Apttus_Config2__LineItem__c> updatelines = updateLineItems(cart,request,dslist);
                System.debug('updatedallline==> '+ updatelines);

                if(updatelines != null && updatelines.size() > 0){
                    lineItemsToBeUpdated.addAll(updatelines);
                    
                    updateAllLineItemsHelper(cart,updatelines);
                    cartsToBeUpdated = getUpdateCarts(quoteIdToUpdateRequestLanding,cart,cartsToBeUpdated);                    
                }// End of main If
            }// End of For Loop          

            updateLineItemRecords(lineItemsToBeUpdated);
            updateCartRecords(cartsToBeUpdated);

            for( Apttus_Config2__ProductConfiguration__c cart : carts){
                callAddMutlipleProducts(cart);
            }//End of For

            if(quoteIdToToBeUpdatedQuotes.values() != null && quoteIdToToBeUpdatedQuotes.size() > 0 &&
                Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){//Check for Access permission before DML

                update quoteIdToToBeUpdatedQuotes.values();
            }
            response.quotePricingStatus = quoteIdToPricingStatus.values();

            //Adding Pricing status fo the Quote ot the Response.
            if(response.quotePricingStatus != null && response.quotePricingStatus.size() > 0){
                String quoteId = response.quotePricingStatus[0].quoteId;
                boolean status = DCUtils.repriceByQuoteId(quoteId);
                response.quotePricingStatus[0].isPricingPending = status;
            }//end of If

            response.responseCode = 200;
            response.responseMessage = 'Success';    
            return response;
        }catch(Exception ex){//Sending Error message in Response if operation fails
            response = new DCQuoteUpdate.QuoteUpdateResponse();
            response.responseCode = 400;
            response.responseMessage = ex.getMessage();//Sending exception message to AEM.
            DCUtils.trackLog(ex,'DCQuoteService','updateAllLineItems');
            return response;
        } //End of Catch   
    }

    public void updateLineItemRecords(List<Apttus_Config2__LineItem__c> lineItemsToBeUpdated){
        try{
            if(!lineItemsToBeUpdated.isEmpty() && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()) { 
                update lineItemsToBeUpdated; //End of DML
            }
        }
        catch(Exception ex){
            throw new DCCustomException(ex);
        }
    }

    public void updateCartRecords(List<Apttus_Config2__ProductConfiguration__c> cartsToBeUpdated){
        try{
            if(!cartsToBeUpdated.isEmpty() && Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable()) {
                update cartsToBeUpdated; // End of DML
            }
        }
        catch(Exception ex){
            throw new DCCustomException(ex);
        }
    }

    private List<Product_Account_Detail__c> getDigitalSubscriptionData(List<Apttus_Config2__ProductConfiguration__c> carts){
        String cusno;  
        String campcod;
        Date rendat;
        List<Product_Account_Detail__c> dsList = new List<Product_Account_Detail__c>();

        if(carts !=null && !carts.isEmpty()){
            cusno= carts[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c;
            campcod = carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c;
            rendat = carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c;

            if(Schema.sObjectType.Product_Account_Detail__c.isAccessible()){
                dslist =[SELECT id,name,Current_Term_Length__c,Year1_YoYvalue__c,Year2_YoYvalue__c,Year3_YoYvalue__c,
                            Offer_Price__c,Digital_Firm__c,Current_Subscription__c,Actual_New_Service__c,
                            Actual_New_Subscription__c,Premium_New_Service__c,Premium_New_Subscription__c,
                            Plus_Rec_Text_Code__c,Premium_Rec_Text_Code__c,ZP_Cust_Number__c
                        FROM Product_Account_Detail__c 
                        WHERE ZP_Cust_Number__c=: cusno
                        AND Campaign_Code__c=: campcod
                        AND Renewal_Date__c =: rendat];
            }

            for(Product_Account_Detail__c pad : dsList){
                dsFirmMap.put(pad.ZP_Cust_Number__c, pad.Digital_Firm__c); 
            }

            System.debug('dslist'+dslist);
        }

        return dsList;
    }
    private void updateAllLineItemsHelper(Apttus_Config2__ProductConfiguration__c cart,List<Apttus_Config2__LineItem__c> updatelines){
        // Assigning Pricing status
        DCQuoteUpdate.QuotePricingStatus pricingStatus = new DCQuoteUpdate.QuotePricingStatus();
        pricingStatus.quoteId = cart.Apttus_QPConfig__Proposald__c;
        pricingStatus.isPricingPending = true;
        // response.quotePricingStatus.add(pricingStatus);
        quoteIdToPricingStatus.put(cart.Apttus_QPConfig__Proposald__c,pricingStatus);

        if(updatelines[0].APTS_Contract_Term__c.equalsIgnorecase(cart.Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c) && updatelines[0].Apttus_Config2__Quantity__c == cart.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c ){
            updateConfiguratorFlagOnQuote( quoteIdToToBeUpdatedQuotes, cart, true);
        } 
        else{
            updateConfiguratorFlagOnQuote( quoteIdToToBeUpdatedQuotes, cart, false);
        }//End of If else 

        if(quoteIdToToBeUpdatedQuotes.get(cart.Apttus_QPConfig__Proposald__c) == null){
            Apttus_Proposal__Proposal__c updateflag = new Apttus_Proposal__Proposal__c(Id = cart.Apttus_QPConfig__Proposald__c,
                                                                                        DC_Contract_Not_In_Sync__c = true);
            quoteIdToToBeUpdatedQuotes.put(cart.Apttus_QPConfig__Proposald__c, updateflag); 
        }
        else{
            quoteIdToToBeUpdatedQuotes.get(cart.Apttus_QPConfig__Proposald__c).put('DC_Contract_Not_In_Sync__c' , true);
        }//End of If Else
    }

    private void callAddMutlipleProducts(Apttus_Config2__ProductConfiguration__c cart){
        DCQuoteUpdate.QuoteUpdateRequest request = quoteIdToUpdateRequestLanding.get(cart.Apttus_QPConfig__Proposald__c);

        if(request.productIds != null && !request.productIds.isEmpty()){
            // updateConfiguratorFlagOnQuote( quoteIdToToBeUpdatedQuotes, cart, isResetQuote);
            //Adding multiple products to the cart.
            System.debug('cart'+cart);
            addMultipleProducts(cart,request.productIds,request.quantity);
            DCQuoteUpdate.QuotePricingStatus pricingStatus = new DCQuoteUpdate.QuotePricingStatus();
            //Setting the pricing status for the Quote
            pricingStatus.quoteId = cart.Apttus_QPConfig__Proposald__c;                    
            pricingStatus.isPricingPending = true;
            quoteIdToPricingStatus.put(cart.Apttus_QPConfig__Proposald__c,pricingStatus);
        }//End of If
    }

    private List<Apttus_Config2__ProductConfiguration__c> getUpdateCarts(Map<String,DCQuoteUpdate.QuoteUpdateRequest> quoteIdToUpdateRequestLanding,Apttus_Config2__ProductConfiguration__c cart,List<Apttus_Config2__ProductConfiguration__c> cartsToBeUpdated){
        
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();

        if((quoteIdToUpdateRequestLanding.get(cart.Apttus_QPConfig__Proposald__c).quantity != null) &&
            (cart.Ecom_No_of_Attorneys__c == null || cart.Ecom_No_of_Attorneys__c != quoteIdToUpdateRequestLanding.get(cart.Apttus_QPConfig__Proposald__c).quantity) ) {
        
            DCQuoteUpdate.QuoteUpdateRequest request = quoteIdToUpdateRequestLanding.get(cart.Apttus_QPConfig__Proposald__c);    
            // We should update the Ecom_No_of_Attorneys__c when the quantity is changed 
            // to overcome the "default QUANTITY feature" in APTTUS
            cart.Ecom_No_of_Attorneys__c = request.quantity;
            cartList.add(cart);   
            
            return cartList;                  
        }//End of If   
        else{
            return cartsToBeUpdated;
        }
    }
    private boolean isValidUpdateRequest(List<Apttus_Config2__LineItem__c> items,Apttus_Config2__ProductConfiguration__c cart,DCQuoteUpdate.QuoteUpdateRequest requestDetail){
        
        for(Apttus_Config2__LineItem__c lineItem : items) {

            //DLT-11652 - removed condition applied for DLT-10632. Corporate cannot continue now.
            //DLT-10632 - Update APIs to accommodate per seat products assignment and Quantity updates from landing page.
            //DLT-17751 corporate also will continue, added corporate to the if condition.//DLT-18617 hasoptions check added
            if(isNotBandedOrOptions(lineItem, cart)){
                continue;
            }

            //If Quantity is matched form request and contract term is matched
            if(lineItem.Apttus_Config2__Quantity__c == requestDetail.quantity && lineItem.APTS_Contract_Term__c.equalsIgnoreCase(requestDetail.contractTerm) ){
                return false;
            }

            //If There is no Quantity sent from request and contract terms matches with the request
            if( (requestDetail.quantity == null || requestDetail.quantity < 1 ) && lineItem.APTS_Contract_Term__c.equalsIgnoreCase(requestDetail.contractTerm) ){
                return false;
            }

            //If quantity is matched and Contract Term is empty from the request
            if( lineItem.Apttus_Config2__Quantity__c == requestDetail.quantity && String.isBlank(requestDetail.contractTerm) ){
                return false;
            }
              
        }

        return true;
    }

    private boolean isNotBandedOrOptions(Apttus_Config2__LineItem__c lineItem, Apttus_Config2__ProductConfiguration__c cart){

        if( (!(PRODUCT_PRICING_MODEL_BANDED.equalsIgnoreCase(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c)) || lineItem.Apttus_Config2__HasOptions__c == true)
            && ((dsFirmMap.get(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c) == label.DC_SegmentName_SLaw) 
            || (dsFirmMap.get(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c) == label.Corporate_Digital_Firm) ) ){
            return true;
        }

        return false;
    }

    /*
     * updated the all lineItem with ContractTerm and Quantity If the values has been modified
     * Updated Ecom_No_Of_Attorneys in Cart object if Quantity has been changed and It will be used when new Products are added to cart. 
     */
    public List<Apttus_Config2__LineItem__c> updateLineItems(Apttus_Config2__ProductConfiguration__c cart,DCQuoteUpdate.QuoteUpdateRequest requestDetail,list<Product_Account_Detail__c> dslist){
        
        if(String.isBlank(requestDetail.contractTerm) && ( requestDetail.quantity == null || requestDetail.quantity < 1 ) ){
            return new List<Apttus_Config2__LineItem__c>();
        }

        List<Apttus_Config2__LineItem__c> items = cart.Apttus_Config2__LineItems__r; 
        List<Apttus_Config2__LineItem__c>  updateItems = new List<Apttus_Config2__LineItem__c>();
        List<DC_Contract_Term_V2__mdt> contractTerms;
        Boolean updatedOnConfigurator = false;
        defaultAdjustmentAmount = cart.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c;  
        dsAdjustmentAmount = 0.0;

        defaultContractTem = cart.Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c; 
        defaultAdjustmentType = cart.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c;   

        defaultQuantity = cart.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c == null ? 0 : Integer.valueOf(cart.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c);

        yr1RenewalAdjustment = '0';
        yr2RenewalAdjustment = '0';
        newAdjustmentAmount = 0.0;

        //Setting updateConfigurator Flag
        updatedOnConfigurator = cart.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c;

        System.debug('items  '+items);System.debug('requestDetail  '+requestDetail);
        System.debug('&&&%dsFirmMap'+dsFirmMap);        
        //DLT-8663 Digital_Firm__c
        
        if(!isValidUpdateRequest(items,cart,requestDetail)){
            return new List<Apttus_Config2__LineItem__c>();
        }

        contractTerms = queryContractTerms(cart,requestDetail);

        System.debug('Contract_Terms  '+contractTerms); // QUOTE_TYPE_STRAIGHT_RENEWAL
        
        System.debug('subscriptions-->'+dslist);
        for(Product_Account_Detail__c pad: dslist){

            //Populates the objYOY variable with YOY values from Digital Subscriptions
            objYoy = DCQuoteServiceHelper.getYOYValues(objYoy,pad,true);
            
            // Findlaw DS Discount
            if(pad.Digital_Firm__c =='FindLaw' && pad.Offer_Price__c != null){
                dsAdjustmentAmount  = pad.Offer_Price__c ;       
            }
        } //End of For loop  
        
        //Sets the renewal adjustments and new adjustments
        setAdjustments(contractTerms);

        //newAdjustment values are corrected if adjustment is a negative value
        correctNewAdjustmentValues();

        
        //Adding line item details
        for(Apttus_Config2__LineItem__c line : items){
            updateItems.add(getUpdateLineItemDetails(requestDetail, line,cart)); 
        }
        return updateItems;   
    }
    public List<DC_Contract_Term_V2__mdt> queryContractTerms(Apttus_Config2__ProductConfiguration__c cart,DCQuoteUpdate.QuoteUpdateRequest requestDetail){
        List<DC_Contract_Term_V2__mdt> contractTerms = new List<DC_Contract_Term_V2__mdt>();

        Integer customerCategory;
        customerCategory = cart.Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c == null ? Null :Integer.valueOf(cart.Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c);

        //Getting the Contract terms
        if(Schema.sObjectType.DC_Contract_Term_V2__mdt.isQueryable()){//DLT-11734
            if(customerCategory == null || dsFirmMap.get(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c)=='FindLaw'){//Getting the default Customer category contract terms from metadata
                    contractTerms = [SELECT Markup_Percentage__c,YoY_1_Renewal__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c,Segment__c 
                                    FROM DC_Contract_Term_V2__mdt 
                                    WHERE Default_Customer_Category__c = true 
                                    AND Quote_Type__c =: cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c  
                                    AND Contract_Term__c =: requestDetail.contractTerm 
                                    AND Segment__c =: dsFirmMap.get(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c)];
            }//End of inner if
            else if(dsFirmMap.get(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c) !='FindLaw'){//DLT-16887
                contractTerms= [SELECT Markup_Percentage__c,YoY_1_Renewal__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c,Segment__c 
                                FROM DC_Contract_Term_V2__mdt 
                                WHERE Customer_Category__c =: customerCategory 
                                AND Quote_Type__c =: cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c 
                                AND Contract_Term__c =: requestDetail.contractTerm  
                                AND Segment__c =: dsFirmMap.get(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c)];
            }
        }//End of main IF
        else{//DLT-11734
            throw new DCCustomException('DC_Contract_Term_V2__mdt is not accessible.');
        }

        return contractTerms;
    }
    
    private void setAdjustments(List<DC_Contract_Term_V2__mdt> contractTerms){
        if((contractTerms != null) && (contractTerms.size() > 0)){
            setRenewalAdjustment(contractTerms);
            newAdjustmentAmount = calculateNewAdjustmentAmount(contractTerms);
        }
        else{ //Setting Default Adjustment amount if Contract terms not set.
            newAdjustmentAmount = defaultAdjustmentAmount;
        }//End of If Else

        System.debug('yr1RenewalAdjustment'+yr1RenewalAdjustment);
        System.debug('yr2RenewalAdjustment'+yr2RenewalAdjustment);
    }

    private void correctNewAdjustmentValues(){
        if(newAdjustmentAmount < 0) {
            newAdjustmentAmount = newAdjustmentAmount * (-1);
            newAdjustmentType = Label.DC_PERCENT_MARKUP;
        } 
        else {       
            newAdjustmentType = defaultAdjustmentType;
        }
    }

    private Apttus_Config2__LineItem__c getUpdateLineItemDetails(DCQuoteUpdate.QuoteUpdateRequest requestDetail,Apttus_Config2__LineItem__c line,Apttus_Config2__ProductConfiguration__c cart){
        Apttus_Config2__LineItem__c lineItem = line;

        if(String.isNotBlank(requestDetail.contractTerm)){
            // Check for straight Quote type
            if(QUOTE_TYPE_STRAIGHT_RENEWAL.equalsIgnoreCase(requestDetail.quoteType)){             
                lineItem.APTS_Yr_1_Renewal_Adjustment__c = yr1RenewalAdjustment;
            }//End of If     

            //Setting Adjustments   
            lineItem.APTS_Years_2_Plus_Adjustment__c = yr2RenewalAdjustment;
            lineItem.Apttus_Config2__AdjustmentAmount__c = newAdjustmentAmount;
            lineItem.Apttus_Config2__AdjustmentType__c = newAdjustmentType != null ? newAdjustmentType : lineItem.Apttus_Config2__AdjustmentType__c;
            //Setting Contract term to the line item.
            lineItem.APTS_Contract_Term__c = requestDetail.contractTerm;
        }   
        lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
        //DLT-8663 Digital_Firm__c
        //DLT-11652 - removed condition applied for DLT-10632. Corporate per-seat cannot get default quantity here.
        // changed by Navleen as part of DLT-16885
        if(requestDetail.quantity != null && (requestDetail.quantity >= 1) 
            && (PRODUCT_PRICING_MODEL_BANDED.equalsIgnoreCase(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c)
            && dsFirmMap.get(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c) != label.DCSegmentFindLaw)) {
            
            lineItem.Apttus_Config2__Quantity__c = requestDetail.quantity;
        }
        System.debug('lineItem'+lineItem);

        return lineItem;
    }

    private decimal calculateNewAdjustmentAmount(List<DC_Contract_Term_V2__mdt> contractTerms){
        Decimal adjustmentAmount = 0.0;

        //Setting year1 adjustment type from Contract term YOY1 Renewal.
        Decimal markup = contractTerms[0] != null ? contractTerms[0].Markup_Percentage__c : 0.0;
        //Setting new adjustment amount
        if(contractTerms[0].Segment__c =='FindLaw'){ // Findlaw default Discount
            adjustmentAmount  = dsAdjustmentAmount + (contractTerms[0].Contract_Term__c == '3 Years'? contractTerms[0].DC_Years_2_Plus_Adjustment__c:(contractTerms[0].Contract_Term__c == '2 Years'?  contractTerms[0].YoY_1_Renewal__c : 0.0))  ;       
        }
        else if(defaultAdjustmentType == Label.DC_PERCENT_DISCOUNT) {
            adjustmentAmount = defaultAdjustmentAmount - markup;
        }
        //Adding mark up to default adjustment amount if matches with dc % markup. 
        else if(defaultAdjustmentType == Label.DC_PERCENT_MARKUP) {
            adjustmentAmount = defaultAdjustmentAmount + markup;                
        }

        return adjustmentAmount;
    }

    public void setRenewalAdjustment(List<DC_Contract_Term_V2__mdt> contractTerms){
        if(objYoy.arrYoyStraight[0]!= 0.0 || objYoy.arrYoyStraight[1]!= 0.0 || objYoy.arrYoyStraight[2]!= 0.0){
            yr1RenewalAdjustment = String.valueof(Integer.valueOf(getYearOnYearAmount(contractTerms[0],objYoy.arrYoyStraight))); 
            yr2RenewalAdjustment = String.valueof(Integer.valueOf(getYearOnYearAmount(contractTerms[0],objYoy.arrYoyStraight))); 
        }//For straight proposal
        else if(objYoy.arrYoyBest[0]!= 0.0 || objYoy.arrYoyBest[1]!= 0.0 || objYoy.arrYoyBest[2]!= 0.0){
            yr1RenewalAdjustment = String.valueof(Integer.valueOf(getYearOnYearAmount(contractTerms[0],objYoy.arrYoyBest))); 
            yr2RenewalAdjustment = String.valueof(Integer.valueOf(getYearOnYearAmount(contractTerms[0],objYoy.arrYoyBest))); 
        }//For best proposal
        else if(objYoy.arrYoyPremium[0]!= 0.0 || objYoy.arrYoyPremium[1]!= 0.0 || objYoy.arrYoyPremium[2]!= 0.0){
            yr1RenewalAdjustment = String.valueof(Integer.valueOf(getYearOnYearAmount(contractTerms[0],objYoy.arrYoyPremium))); 
            yr2RenewalAdjustment = String.valueof(Integer.valueOf(getYearOnYearAmount(contractTerms[0],objYoy.arrYoyPremium))); 
        }//For Premium proposal
        else {
            yr1RenewalAdjustment = (contractTerms[0].YoY_1_Renewal__c == null) ? '0' : String.valueOf(Integer.valueOf( contractTerms[0].YoY_1_Renewal__c));
            yr2RenewalAdjustment =  (contractTerms[0].DC_Years_2_Plus_Adjustment__c == null ) ? '0' : String.valueOf(Integer.valueOf(contractTerms[0].DC_Years_2_Plus_Adjustment__c)) ;
        }
    }

    private decimal getYearOnYearAmount(DC_Contract_Term_V2__mdt termObj, Decimal[] arrYOY){
        if(termObj.Contract_Term__c == '3 Years'){
            return arrYOY[2];
        }
        else if(termObj.Contract_Term__c == '2 Years'){
            return arrYOY[1];
        }
        else{
            return arrYOY[0];
        }
    }

    /*
     * add multiple Products to cart with quantity which are passed as parameter.
     */ 
    private void addMultipleProducts(Apttus_Config2__ProductConfiguration__c cart,List<String> productIds,Integer iQuantity){
        
        Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
        List<Integer> removablelines = new list<integer>();
        //map holding line item product ids to line item primary line number
        Map<String,Integer> productIdsToLineNumber = new Map<String,Integer>();
        //Sets holding product Ids.
        Set<String> lineItemProductIds;
        Set<String> cloneAddProductIds;

        DCUtils.addToLineItem(customData,'Apttus_Config2__BillingFrequency__c','Monthly'); 
        //If cartrs are not empty
        if( cart != null && !cart.Apttus_Config2__LineItems__r.isEmpty()){
            Apttus_Config2__LineItem__c lineItem = cart.Apttus_Config2__LineItems__r[0];
            System.debug('lineItem'+lineItem);
            customData.Apttus_Config2__AdjustmentAmount__c = lineItem.Apttus_Config2__AdjustmentAmount__c;            
            //Adding Adjustment types to line item
            DCUtils.addToLineItem(customData,'Apttus_Config2__AdjustmentType__c',lineItem.Apttus_Config2__AdjustmentType__c);
            DCUtils.addToLineItem(customData,'APTS_Yr_1_Renewal_Adjustment__c',lineItem.APTS_Yr_1_Renewal_Adjustment__c);            
            DCUtils.addToLineItem(customData,'APTS_Years_2_Plus_Adjustment__c',lineItem.APTS_Years_2_Plus_Adjustment__c);           
            //Adding bridge data and contract term to line item.
            DCUtils.addToLineItem(customData,'APTS_Bridge_Discount__c',lineItem.APTS_Bridge_Discount__c);            
            DCUtils.addToLineItem(customData,'APTS_Bridge__c',lineItem.APTS_Bridge__c);           
            DCUtils.addToLineItem(customData,'APTS_Contract_Term__c',lineItem.APTS_Contract_Term__c);
        }//End of If
        System.debug('customData'+customData);

        //For Quantity less than 1 
        if(iQuantity == null || iQuantity < 1 ) {
            for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){
                //For Banded product setting the iQuanity
                if(PRODUCT_PRICING_MODEL_BANDED.equalsIgnoreCase(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c) ){
                    iQuantity = lineItem.Apttus_Config2__Quantity__c.intValue(); 
                }//End of Inner If
            }//End of For loop
        }//End of Outer If
        System.debug('iQuantity'+iQuantity);

        for( Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){
            productIdsToLineNumber.put(lineItem.Apttus_Config2__ProductId__c,lineItem.Apttus_Config2__PrimaryLineNumber__c.intValue());
        }


        lineItemProductIds = productIdsToLineNumber.keyset();
        cloneAddProductIds = new Set<String>(productIds);
        //Removing product IDs
        cloneAddProductIds.removeAll(lineItemProductIds);
        productIdsToLineNumber.keyset().removeAll(productIds);
        try{
            if( !productIdsToLineNumber.isEmpty()){
                removablelines = new list<integer>(productIdsToLineNumber.values());
                DCUtils.removeLineItems(removablelines, cart.Id);
            } //End of If
    
            if(!cloneAddProductIds.isEmpty()){
                DCUtils.addMultipleProducts(cloneAddProductIds, iQuantity, cart.Id, customData);
            } //End of If 
        }
        catch(Exception ex){
            DCUtils.trackLog(ex,'DCQuoteService','addMultipleProducts() method');
        }
    }
    /*
     * update the DC_Updated_On_Configurator__c on Quote object when chnages are happened to Quote or Reset the Quote
     */ 
    private static void updateConfiguratorFlagOnQuote(Map<String,Apttus_Proposal__Proposal__c> quoteIdToToBeUpdatedQuotes,Apttus_Config2__ProductConfiguration__c cart,Boolean isTrue){
        
        Apttus_Proposal__Proposal__c quote = compareCustomAndBV(isTrue,cart.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c,cart.Apttus_QPConfig__Proposald__c);
        if(quote != null){
            quoteIdToToBeUpdatedQuotes.put(cart.Apttus_QPConfig__Proposald__c,quote);
        }
    }

    /*
    @isEqual : True, Custom Quote is replica of Best Value
                False, difference in b/w custom and Best Value for other Quotes while update,
                we should pass false value to set TRUE for DC_Updated_On_Configurator__c
    */
    public static Apttus_Proposal__Proposal__c compareCustomAndBV(boolean isEqual, boolean updatedOnConfigurator, String quoteId  ) {
        Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
        quote.id = quoteId;
        if(isEqual){  //If custom Quote value and best value are equal   
            if(!updatedOnConfigurator){ 
                return Null;
            }

            quote.DC_Updated_On_Configurator__c = false;
            return quote;           
        } 
        else{
            if(updatedOnConfigurator) {
                return Null;
            }

            quote.DC_Updated_On_Configurator__c = true;
            return quote;
        }   //End of If Else     
    } 
}