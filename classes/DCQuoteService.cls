/*
 * This class has all service related to Digital configurations like Loading data using opportunity, add/Remove product from Cart. 
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-01-17   Ramesh Reddy          DLT-7265 - Performance Issues
 * 2018-03-07   Ramesh Reddy          DLT-7843 - When changing Attorneys, only update Banded Products 
 * 2018-04-24   Poonam Garg           DLT- 9284 - For Corporate Customers max attorney is 3 and for Small Law is 7.
 * 2018-04-25   Poonam Garg           DLT -9251 - Check If Segment is Corporate only Corporate Contract Terms should be used else if Segment is Small Law then Small Lae Contract Terms                                should be used. If none the     
 * 2018-05-07   Divija Salla          DLT- 9542 - Two Fields to be included in LOAD API Response and the logic should be as per the requirement in DLT- 5677
 * 2018-05-10   Srinivasulu T         DLT-9669 - removed Straight Renewal quoteType and  it's work for all quoteType
 * 2018-05-18   Srikanth Kota         DLT-8663 - Removed Product_Pricing_Model dependence for noOfAttorneys based on Quantity.
 * 2018-05-21   Harikasai P           DLT-9964 - Added Digital Firm in response.
 * 2018-05-31   Srikanth Kota         DLT-8663 - When Corporate changed quantity on AEM even PerSeat, it will update on Cart and line item, if Small law itâ€™s not update for PerSeat.
 * 2018-06-12   Divija S              DLT-9770 - Created new Opportunity ID to manage GLI changes and Changed Account references
 * 2018-07-09   Divija S              DLT-10763 - Customer Specific YoY values access from Digital Subscriptions
 * 2018-07-09   Rajan Tatuskar        DLT-10632 - Update APIs to accommodate per seat products assignment and Quantity updates from landing page.
 * 2018-08-16   Harika Sai P          DLT-11661 - Combine the Landing Page service into a single service     
 * 2018-08-20   Benjamin Her          DLT-7380 - Eligible manual proposal to be sent to Renewal Page 
 * 2018-08-22   Harika Sai P          DLT-11734 - [Code Scan] Fix DCQuoteService  
 * 2018-08-09   Rajan Tatuskar        DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts  
 * 2018-09-10   Harika Sai P          DLT-12184 - Annual increase is 0% on corp landing page for straight offer - UAT Issue fixing
 * 2018-11-05   Rajan Tatuskar        DLT-12679 - Recommendations reason from Automation file for Upsell Offers
 * 2018-11-15   Divija Salla          DLT-13464 - All. Streamline all Max users for landing page and add on page, added new Custom metadata: 'DC Max Users or Attorneys'
 * 2018-12-19   Navleen Kaur          DLT-14155 : [Tech Story] [Code Scan] - Fix Code Scan Security Issues
 * 2019-10-08   Navleen Kaur          DLT-14349 : [Tech Story] [Code Scan]
 * 2019-01-21   Divija Salla          DLT-14607 : PerformCartUpdate service needs to be updated according to YOY values in Digital Subscription Object 
 * 2019-02-15   Navleen Kaur          DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 2019-02-18   Divija Salla          DLT-15306 - [Tech Story] Fix Variable YoY values for YoY 1% renewal - This field must fill when straight renewal offer updating 
 * 2019-02-19   Benjamin Her          DLT-15324 - Added Base Price to Line Item response
 * 2019-03-04   Benjamin Her          DLT-15149 - Added getManualContractTermDetails() method to handle contractTermDetail for Manual quotes
 * 2019-05-08   Srikanth Kota         DLT-16401 - [FindLaw][SFDC] Straight Renewal - Apply multi-year pricing discount.
 * 2019-05-22   Navleen Kaur          DLT-16511 - Old Opportunity/Account Check(As part of GLI migration)
 * 2019-05-24   Srikanth Kota         DLT-16664 - [FindLaw][SFDC] Straight Renewal - Apply multi-year pricing discount at service related.
 * 2019-06-13   Benjamin Her          DLT-16846 - Remove Logic to cap adjustment amount
 * 2019-06-18   Navleen Kaur          DLT-16885 - Update APIs to accommodate banded products assignment and Quantity updates for government.
 * 2019-06-19   Srikanth Kota         DLT-16887 -Update APIs to accommodate banded products assignment and Quantity updates for government.
 * 2019-07-10   Benjamin Her          DLT-16910 - Rep Driven Personalized Quotes
 * 2019-07-12   Bishanka Dassarma     DLT-17073 - [Tech Story] - Handle Automation and Landing API if digital Subscriptions has multiple entries for same customer but different segments(SmallLaw/Gov/Corp/FindLaw)
 * 2019-07-26   Benjamin Her          DLT-17170 - [SLF] uto-renewal Percent (1 Year YoY) is always defaulted to 7%
 * 2019-09-04   Srikanth kota         DLT-17452 - [CORP][SFDC] Straight renew Option products alongwith the core product
 * 2019-09-04   Bishanka Dassarma     DLT-17519 - Update landing API in SFDC to ensure not to send null values in YOY rates
 * 2019-09-09   Benjamin Her          DLT-17630 - Update Personalized offer to pull Digital Firm from Proposal
 * 2019-10-03   Harika Sai P          DLT-17751 - Price mismatch in landing page, assign users page and confirmation page
 * 2019-10-31   Harika Sai P          DLT-17793 - [CORP][SFDC] Multi Offer - Add option products to the subscription list
 * 2019-11-25   Harika Sai P          DLT-18617 - When users changed for Bundle product in select users page, it is not getting saved in confirmation page.
 * 2019-12-16   Harika Sai P          DLT-18943 - [CORP][SFDC/UI] Displaying 0 price for current offer on landing page
 * 2020-01-09   Srikanth kota         DLT-19245 - [Prod Issue] Apply Auto renewal percentage only when customer have only Straight Renewal offer.
 * 2020-01-14   Benjamin Her          DLT-19233 - Add West Proflex subproducts to response
 * 2020-04-15   Benjamin Her          DLT-19940 - Updated Bundle logic for sending price matrix
 * 2020-05-05   Benjamin Her          DLT-19985 - Performance improvements
 * 2020-05-18   Benjamin Her          DLT-20045 - Update Promo code logic to take in a single quote id instead of opportunity id
 * 2020-06-17   Benjamin Her          DLT-20165 - Update query to pull 'Amended' line items
 * 2020-07-14   Benjamin Her          DLT-20210/DLT-20346 - Update Max Attorney for Banded/Per Seat
 * 2020-08-10   Benjamin Her          DLT-20255 - Update Bundle Per Seat price matrix logic
 * 2020-08-17   Benjamin Her          INC3635751 fix
 * 2020-08-12   Benjamin Her          DLT-20588 - Implement MLF support
 * 2020-08-24   Benjamin Her          DLT-20634 - Critical/Blocker PMD fix
 * 2020-09-01   Benjamin Her          DLT-20632 - Regression fix. Omit manual offers from bundle price matrix logic
 * 2020-09-23   Benjamin Her          DLT-20827 - PMD fix
 * 2021-04-01   Brenda Shields        DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 * 2021-05-10   Brenda Shields        DLT-21615 - FindLaw end to end testing - set correct digital firm for Manual quotes
==================================================================================================================================   
 */

public without sharing class DCQuoteService{

    //Final Variables
    private static final String STR_DIMENSION1_NAME = 'Quantity';
    private static final String LINE_STATUS_CANCELLED = 'Cancelled';
    private static final String CART_STATUS_FINALIZED = 'Finalized';
    private static final String QUOTE_TYPE_STRAIGHT_RENEWAL = 'Straight Renewal';
    private static final String QUOTE_TYPE_MANUAL = 'Manual';
    private static final String PRODUCT_PRICING_MODEL_BANDED = 'Banded'; 
    private static final string DESCENDING = 'DESC'; 
    private static final string WEST_PROFLEX = 'West Proflex';
    private static final List<String> LAW_FIRMS = System.Label.Digital_Law_Firm.split(',');
    
    @testvisible
    private Map<String,List<DCQuoteDetails.Pricematrix>> productIdToPriceMatrices = new Map<String,List<DCQuoteDetails.Pricematrix>>();
    @testvisible
    private Map<String,Map<Integer,DCQuoteDetails.Pricematrix>> productIdToQuantityPriceMatrices = new Map<String,Map<Integer,DCQuoteDetails.Pricematrix>>();
    private Map<String,List<DCQuoteDetails.Pricematrix>> bundleProductIdToPriceMatrices = new Map<String,List<DCQuoteDetails.Pricematrix>>(); 
    private Map<String,String> plusRecTextCodeMap = new Map<String,String>();
    private Map<String,String> premiumRecTextCodeMap = new Map<String,String>();  
    Map<String,DCQuoteDetails.QuoteDetail> idToQuoteDetails = new Map<String,DCQuoteDetails.QuoteDetail>();

    private Set<String> bundleProdIdSet = new Set<String>();

    @testvisible
    public static List<Product_Account_Detail__c> subscriptions;
    private static list<DCQuoteDetails.promocodetails> promoDetails = new list<DCQuoteDetails.promocodetails>();

    private Decimal newAdjustmentAmount = 0.0;

    private String newAdjustmentType = ''; 
    private String digitalFirm = '';
    private String digitalOfferType = ''; //DLT-19245
    private String quoteTypeBundleIDToModulePointMapKey;

    private Integer termCurrent;    
    private Integer maxNoOfAttorneys;

    public static DCQuoteService.YoyValues objYoy= new DCQuoteService.YoyValues();//DLT-11734

    /**
     * return the response of all Quotes bassed on opportunity Id passed as parameter.
     */ 
    public DCQuoteDetails landingPageLoadApi(Id oppId,Id accId,Id quoteId){
        If(oppId == null) {return null;}
        
        DCQuoteDetails quoteData = new DCQuoteDetails();
        try{
            //Fetching the Proposals based on Opportunity Id to map to Quote details
            getQuotesByOppertunityId(oppId,accId,quoteId);
            System.debug('idToQuoteDetails.values() > '+Json.serialize(idToQuoteDetails.values()));
            //Fetching the proposal details from DCGetQuoteDetails for Confirmation page in AEM.
            quoteData = DCGetQuoteDetails.getAllQuotesByOppertunityIdAndAccountId(oppId,accId,quoteId);//DLT-11661  
            quoteData.quoteDetails = idToQuoteDetails.values();
            quoteData.responseCode = 200;
            quoteData.responseMessage = 'Success';
        }catch(Exception ex){//Returing error response if service is failed.
            DCUtils.trackLog(ex,'DCQuoteService','landingPageLoadApi');
            quoteData.responseCode = 400;
            quoteData.responseMessage = ex.getMessage();//Sending exception message to AEM.
            throw ex;
        }//End of Try Catch
        
        return quoteData;
    }
    
    /*
     * Get Incentives the cart based on the passed in quote id
     * Updated DLT-20045 Method updated to use single quote id instead of opportunity id
     */ 
    public static list<DCQuoteDetails.promocodetails> getPromoCode(Id quoteId){
              
        List<Apttus_Config2__ProductConfiguration__c> carts;
        list<Id> incentiveId = new list<Id>();
        list<Apttus_Config2__Incentive__c> incentives1 = new list<Apttus_Config2__Incentive__c>();
        list<Apttus_Config2__Incentive__c> incentives2 = new list<Apttus_Config2__Incentive__c>();
        list<Apttus_Config2__PriceRuleEntry__c> priceRuleEntry = new list<Apttus_Config2__PriceRuleEntry__c>();
        Map<Id,Double> adjustmentAmountMap  = new Map<Id,Double>(); 

        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
            carts = [SELECT id 
                    FROM Apttus_Config2__ProductConfiguration__c 
                    WHERE Apttus_QPConfig__Proposald__c =: quoteId //DLT-20045 query filter changed to proposal
                    AND APTS_Customer_Pricing_Segment__c = 'Law Firm'
                    AND Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != 'Manual'];
        }

        //Loop through carts and call Apttus to provide incentives for each cart
        //Needs to be revised in the future as we do not need to get incentives for all carts
        for( Apttus_Config2__ProductConfiguration__c cart : carts){
              
            Apttus_CPQApi.CPQ.GetIncentivesForCartRequestDO objGetIncentivesForCartRequestDO = new Apttus_CPQApi.CPQ.GetIncentivesForCartRequestDO();
            objGetIncentivesForCartRequestDO.CartId = cart.Id;
            Apttus_CPQApi.CPQ.GetIncentivesForCartResponseDO result = Apttus_CpqApi.CPQWebService.getIncentivesForCart(objGetIncentivesForCartRequestDO);
           
            incentives1 = result.Incentives;
            for(Apttus_Config2__Incentive__c inc : incentives1){
                incentiveId.add(inc.id);
            }
        }
        
        //Queries the incentives based on what Apttus provided.
        //This query may not be needed as the Apttus API Looks like it is already returning these fields
        if(Schema.sObjectType.Apttus_Config2__Incentive__c.isAccessible()){
            incentives2 = 
                    [SELECT id,Apttus_Config2__IncentiveCode__c,Apttus_Config2__EffectiveDate__c,
                        Apttus_Config2__ExpirationDate__c 
                    FROM Apttus_Config2__Incentive__c WHERE id IN:incentiveId];
        }

        //Queries the price rule entries based on its incentives
        if(Schema.sObjectType.Apttus_Config2__PriceRuleEntry__c.isAccessible()){    
            priceRuleEntry = 
                    [SELECT id,Apttus_Config2__AdjustmentAmount__c,
                        Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.id 
                    FROM Apttus_Config2__PriceRuleEntry__c 
                    WHERE Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.id IN:incentiveId];
        }
        
        //Maps the incentives to the price rule entry adjustment amount
        for(Apttus_Config2__PriceRuleEntry__c prc : priceRuleEntry ){
            if(prc.Apttus_Config2__AdjustmentAmount__c!=null){
                adjustmentAmountMap.put(prc.Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__r.Apttus_Config2__IncentiveId__r.id,prc.Apttus_Config2__AdjustmentAmount__c);
            }
        }

        //Iterates over all the incentives and generate response
        for(Apttus_Config2__Incentive__c inc2:incentives2)
        {
            DCQuoteDetails.promocodetails details = new DCQuoteDetails.promocodetails();
            details.promocode = inc2.Apttus_Config2__IncentiveCode__c;
            details.EffectiveDate = inc2.Apttus_Config2__EffectiveDate__c;
            details.ExpiryDate = inc2.Apttus_Config2__ExpirationDate__c;
            details.adjustmentamount = adjustmentAmountMap.get(inc2.id);
            promoDetails.add(details);
        }
        /* Method added for implementing Promo code functionality(DLT-15749)*/

        return promoDetails;
    }

    //getQuotesByOppertunityId() method
    //Populates 'idToQuoteDetails' which is assigned to 'quoteData.quoteDetails' response
    public void getQuotesByOppertunityId(id opportunityId, id accId, id quoteId){
        
        try{
            Opportunity opp;
            List<Apttus_Config2__ProductConfiguration__c> carts;

            //Gettign the Oportunity detail from Id
            if(Schema.sObjectType.Opportunity.isAccessible()){//DLT-11738
                opp =   [SELECT id,Source_System_Detail__r.APTS_Apttus_Customer_Pricing_Segment__c 
                        FROM Opportunity where id=: opportunityId ];
            }
            //Getting the Carts details
            carts = DCLandingServiceHelper.queryCartDetails(opportunityId, accId, quoteId);

            if(!carts.isEmpty()) {
                
                //DLT-7380 - Eligible manual proposal to be sent to Renewal Page - Remove extra offers if more than 3
                carts = DCLandingServiceHelper.manualOfferReplacement(carts);
                
                //Gets values from digital subscriptions associated with the 'carts'
                getDigitalSubscriptionData(carts);
                
                //Method call for getting Max no.Of Attornies.
                getMaxNoOfAttorneys(digitalFirm,carts[0].Apttus_Config2__LineItems__r);
                
                //Getting the pricematrices for the proposals.
                getPricematricesV2(opp);
                getBundlePriceMatricesV2(carts,bundleProdIdSet);
            }

            //DLT-19245 defined digital Offer Type is Straight only.
            if(carts.size()==1 && carts[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == QUOTE_TYPE_STRAIGHT_RENEWAL){
                digitalOfferType = carts[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
            }
            
            //Adding Quote details to the response from the cart information.
            //'idToQuoteDetails' gets populated here
            for( Apttus_Config2__ProductConfiguration__c cart : carts){
                getCartDetails(cart);
            }
        }
        catch(Exception ex){//DLT-11738
            throw new DCCustomException('Exception is thrown '+ex.getMessage());
        }//End of try catch
    }//end of getQuotesByOppertunityId() method

    //getCartDetails() method
    //Gets data from the cart and associated line items and populates 'idToQuoteDetails'
    private void getCartDetails(Apttus_Config2__ProductConfiguration__c cart){
                
        DCQuoteDetails.QuoteDetail details = new DCQuoteDetails.QuoteDetail();
        List<DCQuoteDetails.LineItem> quoteLineItems = new List<DCQuoteDetails.LineItem>();  

        //Assigning proposal cutomer category to details.
        details.customerCategory = cart.Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c == null ? Null : Integer.valueOf(cart.Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c);
        details.quotePrice =  cart.APTS_New_Holdings__c; // APTS_Current_Holdings__c
        //Assigning Quote price for Straight Quote type.
        if(QUOTE_TYPE_STRAIGHT_RENEWAL.equalsIgnoreCase(cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c)){
            details.quotePrice = cart.APTS_Current_Holdings__c;
        }//End If
        details.Contract_Not_In_Sync =  cart.Apttus_QPConfig__Proposald__r.DC_Contract_Not_In_Sync__c;
        //Assigning max num of Attornies.
        details.maxNoOfAttorneys = maxNoOfAttorneys;
        details.quoteId =  cart.Apttus_QPConfig__Proposald__c;
        details.quoteType =  cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
        //Assigning default no.of attornies.
        details.defaultNoOfAttorneys =  cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c  == null ? Null :  Integer.valueOf(cart.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c) ;
        details.updatedOnConfigurator = cart.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c;
        
        details.digitalFirm= digitalFirm;
        
        //DLT-12679 - Recommendations reason from Automation file for Upsell Offers
        if(plusRecTextCodeMap.containsKey(cart.Apttus_QPConfig__Proposald__c)){
            details.PlusRecTextCode = plusRecTextCodeMap.get(cart.Apttus_QPConfig__Proposald__c);
        }
        if(premiumRecTextCodeMap.containsKey(cart.Apttus_QPConfig__Proposald__c)){
            details.PremiumRecTextCode = premiumRecTextCodeMap.get(cart.Apttus_QPConfig__Proposald__c);
        }
           
        //Adding Line item information to the response.
        for(Apttus_Config2__LineItem__c line : cart.Apttus_Config2__LineItems__r){

            //DLT-17793 exclude option prods for contract terms
            if(line.Apttus_Config2__LineType__c != 'Option'){
                details.contractTerm =  line.APTS_Contract_Term__c ;
            }
            //DLT-8663
            details.noOfAttorneys = Integer.valueOf( line.Apttus_Config2__Quantity__c);

            //Gets line item information and adds it to 'quoteLineItems'
            quoteLineItems.add(getLineItemDetails(line, cart));

        }

        details.lineItems = quoteLineItems;
        details.lineItems = DCQuoteServiceHelper.getWestProflexSubproduct(details.lineItems, cart);

        System.debug(' before getContractTerm method > customerCategory> '+details.customerCategory+'<quotetype>'+details.quoteType+'<contract Term>'+details.contractTerm +'<segment>'+ digitalFirm);
        details.contractTermDetails = getContractTerms(details,cart);

        idToQuoteDetails.put(cart.Id,details);

    }//end of getCartDetails() method

    //getLineItemDetails() method
    //Returns DCQuoteDetails.LineItem based on data in pass in Apttus_Config2__LineItem__c parameter
    private DCQuoteDetails.LineItem getLineItemDetails(Apttus_Config2__LineItem__c line, Apttus_Config2__ProductConfiguration__c cart){

        //Adding Quote line items by looping through the line item data..
        DCQuoteDetails.LineItem qLine = new DCQuoteDetails.LineItem();
        
        qLine.productId = line.Apttus_Config2__ProductId__c;
        qLine.optionProductId = line.Apttus_Config2__OptionId__c;   //DLT-17452
        qLine.price = line.Apttus_Config2__NetPrice__c;
        qLine.quantity = Integer.valueOf(line.Apttus_Config2__Quantity__c);
        //Setting pricing model.
        qLine.pricingModel = line.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c;
        //Adding price matrices to the Quote line item
        if(line.Apttus_Config2__LineType__c != 'Option' && line.Apttus_Config2__HasOptions__c == false){ //This condition is for core product
            qLine.matrices = productIdToPriceMatrices.get(line.Apttus_Config2__ProductId__c);
        }else if(line.Apttus_Config2__HasOptions__c == true){// bundle product price matrices are different, written a different logic for getting these
            qLine.matrices = bundleProductIdToPriceMatrices.get(cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c+line.Apttus_Config2__ProductId__c);
        }
        //DLT-15324 - Adding Base Price to AEM response
        qLine.basePrice = line.Apttus_Config2__BasePrice__c;
        
        return qLine;
    }//end of getLineItemDetails() method

    /*
    * get the Max no of attorneys from GlobalSetting 
    */ 
    @testVisible
    private void getMaxNoOfAttorneys(String digitalFirm, List<Apttus_Config2__LineItem__c> cartLineItems){
        //DLT-13464 Starts
        List<DC_Max_Users_or_Attorneys__mdt> globalSetting = new List<DC_Max_Users_or_Attorneys__mdt>();
        Map<String,DC_Max_Users_or_Attorneys__mdt> firmToMaxNoAttorneyMap = new Map<String,DC_Max_Users_or_Attorneys__mdt>();

        if(Schema.sObjectType.DC_Max_Users_or_Attorneys__mdt.isQueryable()){
            globalSetting = [SELECT Max_No_Of_Attorneys__c,Max_No_Of_Per_Seat_Users__c,Segment__c 
                            FROM DC_Max_Users_or_Attorneys__mdt
                            LIMIT 100];
        }//End If
        for(DC_Max_Users_or_Attorneys__mdt maxAttorney : globalSetting){
            firmToMaxNoAttorneyMap.put(maxAttorney.Segment__c, maxAttorney);
        }

        if(firmToMaxNoAttorneyMap.containsKey(digitalFirm)){
            maxNoOfAttorneys = Integer.valueOf(firmToMaxNoAttorneyMap.get(digitalFirm).Max_No_Of_Attorneys__c);
            
            if(LAW_FIRMS.contains(digitalFirm)){
                maxNoOfAttorneys = getSmallLawMaxAttorney(firmToMaxNoAttorneyMap.get(digitalFirm), cartLineItems);
            }
        }     
    }  

    //getSmallLawMaxAttorney() method
    //Returns the max attorney amount for Small Law based on whether a Per Seat product is in the cart.
    //Added DLT-20210/DLT-20346
    private integer getSmallLawMaxAttorney(DC_Max_Users_or_Attorneys__mdt smallLawMaxAttorney, List<Apttus_Config2__LineItem__c> cartLineItems){
        
        integer attorneyAmount = Integer.valueOf(smallLawMaxAttorney.Max_No_Of_Per_Seat_Users__c);

        for(Apttus_Config2__LineItem__c lineItem : cartLineItems){
            if(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == PRODUCT_PRICING_MODEL_BANDED 
               || lineItem.Apttus_Config2__ProductId__r.Name == WEST_PROFLEX){
                
                attorneyAmount = Integer.valueOf(smallLawMaxAttorney.Max_No_Of_Attorneys__c);
                break;
            }
        }
        
        return attorneyAmount;
    }//end of getSmallLawMaxAttorney() method
    
    /*
    Prepares Pricing map for Products using the Product Matrix based on the Products, Quantity and Customer Pricing Segment.
    Products are picked up from lineItem object and It's cart Status has Finalized .
    */ 
    public void getPricematricesV2(Opportunity opp){

        Set<String> attorneys = new Set<String>();
        List<Product2> productIds;
        List<Apttus_Config2__PriceMatrixEntry__c> entries;

        //Adding attorneys
        for(Integer i=1; i<= maxNoOfAttorneys; i++){
            attorneys.add(String.valueOf(i));
        }//End of For loop

        if(Schema.sObjectType.Product2.isAccessible() 
            && Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()
            && Schema.sObjectType.Apttus_Config2__PriceMatrixEntry__c.isAccessible()){//DLT-11738

            //Getting Finalized cart active products
            productIds = [
                        SELECT Id 
                        FROM Product2 
                        WHERE Id IN 
                            (SELECT Apttus_Config2__ProductId__c 
                            FROM Apttus_Config2__LineItem__c 
                            WHERE Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c =: opp.id 
                            AND Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c =: CART_STATUS_FINALIZED 
                            AND Apttus_Config2__LineStatus__c !=: LINE_STATUS_CANCELLED )];

            //Getting price matrices based on pricing segment and attornies                   
            entries = [
                        SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, Apttus_Config2__Dimension1Value__c,Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c 
                        FROM  Apttus_Config2__PriceMatrixEntry__c   
                        WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension1Id__r.name = :STR_DIMENSION1_NAME  
                        AND Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c in :productIds 
                        AND Apttus_Config2__Dimension1Value__c in :attorneys 
                        AND Apttus_Config2__Dimension2Value__c =: opp.Source_System_Detail__r.APTS_Apttus_Customer_Pricing_Segment__c ];
                            
        }//End of If
        else{        
            throw new DCCustomException('Product2 and Apttus_Config2__PriceMatrixEntry__c are not acccesible');
        }//End of If else

        productIdToQuantityPriceMatrices = getUpdatedDCPriceMatrices(entries, false);

        //Setting prioductIdpricematrix map 
        for(String prodId : productIdToQuantityPriceMatrices.keySet()) {
            productIdToPriceMatrices.put(prodId, productIdToQuantityPriceMatrices.get(prodId).values());
        }//End of For loop.

        System.debug(JSON.serialize(productIdToPriceMatrices));        
    } 

    //DLT-17793 Get price matrices for bundle products.
    private void getBundlePriceMatricesV2(List<Apttus_Config2__ProductConfiguration__c> carts,set<string> bundleProdIdSet){
        
        Set<String> attorneys = new Set<String>();
        List<DCQuoteDetails.Pricematrix> priceMatrixList= new List<DCQuoteDetails.Pricematrix>();
        system.debug(logginglevel.INFO, 'Price Matrix List: ' + priceMatrixList);
        List<Apttus_Config2__PriceMatrixEntry__c> bundleEntries;
        Map<string,Map<Integer, DCQuoteDetails.Pricematrix>> bundleIdModulePointToQuantityMap = new Map<string,Map<Integer,DCQuoteDetails.Pricematrix>>();
        Map<string,Integer> quoteTypeBundleIDToModulePointMap = new Map<string,Integer>();
        List<Apttus_Config2__ProductConfiguration__c> automatedCarts = new List<Apttus_Config2__ProductConfiguration__c>();


        if(bundleProdIdSet == null || bundleProdIdSet.isEmpty() || carts == null){
            return;
        }

        //Store only digitally created carts for processing.
        for(Apttus_Config2__ProductConfiguration__c cart : carts){
            if(cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != QUOTE_TYPE_MANUAL){
                automatedCarts.add(cart);
            }
        }

        System.debug('maxNoOfAttorneys::'+maxNoOfAttorneys);
        //Adding attornies
        for(Integer i=1; i<= maxNoOfAttorneys; i++){
            attorneys.add(String.valueOf(i));
        }//End of For loop

        //Gets a map of quote type + bundle Id key to module point value
        quoteTypeBundleIDToModulePointMap = getBundleModulePointMapping(automatedCarts);

        System.debug('quoteTypeBundleIDToModulePointMap::'+quoteTypeBundleIDToModulePointMap);
        System.debug('attorneys ::'+attorneys + bundleProdIdSet );

        if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){//DLT-11738
            if(Test.isRunningTest()){
                bundleEntries = [
                            SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,Apttus_Config2__Dimension2Value__c , 
                                Apttus_Config2__Dimension1Value__c,Apttus_Config2__AdjustmentAmount__c 
                            FROM  Apttus_Config2__PriceMatrixEntry__c   
                            WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2Id__r.name = 'Quantity'];
            }
            else{// bundleEntries contains price matrix entries for all bundle products from DS object
                bundleEntries = [
                        SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,
                            Apttus_Config2__Dimension2Value__c , Apttus_Config2__Dimension1Value__c,Apttus_Config2__AdjustmentAmount__c 
                        FROM  Apttus_Config2__PriceMatrixEntry__c   
                        WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2Id__r.name = 'Quantity'  
                        AND Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN :bundleProdIdSet
                        AND Apttus_Config2__Dimension2Value__c IN: attorneys 
                        ORDER BY Apttus_Config2__Dimension2Value__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c];
            }
        }
        else{
            throw new DCCustomException('Product2 and Apttus_Config2__PriceMatrixEntry__c are not acccesible');
        }

        //calls getUpdatedDCPriceMatrices() method to generate any missing price matrices that are missing within ranges
        bundleIdModulePointToQuantityMap = getUpdatedDCPriceMatrices(bundleEntries, true);

        System.debug('bundleIdModulePointToQuantityMap.keySet()::'+bundleIdModulePointToQuantityMap);

        for(Apttus_Config2__ProductConfiguration__c cart : automatedCarts){
            getFinalBundlePriceMatrices(cart,quoteTypeBundleIDToModulePointMap,bundleIdModulePointToQuantityMap);
        }
        //Setting the map
        
        System.debug(JSON.serialize(productIdToQuantityPriceMatrices));
    }// Ends DLT-17793.

    private void getFinalBundlePriceMatrices(Apttus_Config2__ProductConfiguration__c cart,Map<string,Integer> quoteTypeBundleIDToModulePointMap,Map<string,Map<Integer, DCQuoteDetails.Pricematrix>> bundleIdModulePointToQuantityMap){
        List<string> prodTopointsList = new List<string>();
        prodTopointsList.addAll(bundleIdModulePointToQuantityMap.keySet());
        System.debug('prodTopointsList::'+prodTopointsList);

        for(Apttus_Config2__LineItem__c line : cart.Apttus_Config2__LineItems__r){
            quoteTypeBundleIDToModulePointMapKey = cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c + line.Apttus_Config2__ProductId__c;
            System.debug('quoteTypeBundleIDToModulePointMapKey::'+quoteTypeBundleIDToModulePointMapKey);
            System.debug('line type::'+line );
            if(line.Apttus_Config2__HasOptions__c == true){
                Integer finalDim = getFinalDim(prodTopointsList,line,quoteTypeBundleIDToModulePointMap);             
                List<DCQuoteDetails.Pricematrix> bundlePriceMatricesList = new List<DCQuoteDetails.Pricematrix>();
                System.debug('finalDim::'+finalDim);
                bundlePriceMatricesList = bundleIdModulePointToQuantityMap.get(line.Apttus_Config2__ProductId__c + String.ValueOf(finalDim)).values();
                System.debug('bundlePriceMatricesList::'+bundlePriceMatricesList);
                bundleProductIdToPriceMatrices.put(quoteTypeBundleIDToModulePointMapKey, bundlePriceMatricesList);
            }
        }     
    }
    private Integer getFinalDim(List<string> prodTopointsList,Apttus_Config2__LineItem__c line,Map<string,Integer> quoteTypeBundleIDToModulePointMap){
        Integer finalDim = 9999;       
        //getFinalDim(prodTopointsList,line);             
        for(string s: prodTopointsList){
            System.debug('s::'+s);
            if(s.contains(line.Apttus_Config2__ProductId__c)){ //Added DLT-19940
                Integer currentDim = Integer.ValueOf(s.substring(string.valueOf(line.Apttus_Config2__ProductId__c).length()));
                System.debug('currentDim::' +currentDim);
                if(quoteTypeBundleIDToModulePointMap.get(quoteTypeBundleIDToModulePointMapKey) <= currentDim && (finalDim > currentDim)){
                    finalDim = currentDim;
                }
            }
        }

        return finalDim;
    }

    private Map<String,Integer> getBundleModulePointMapping(List<Apttus_Config2__ProductConfiguration__c> carts){

        Map<String,Integer> quoteTypeBundleIDToModulePointMap = new Map<string,Integer>();

        for(Apttus_Config2__ProductConfiguration__c cart : carts){
            for(Apttus_Config2__LineItem__c line : cart.Apttus_Config2__LineItems__r){
                String quoteTypeBundleIDToModulePointMapKey = cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c +  line.Apttus_Config2__ProductId__c;
                System.debug('quoteTypeBundleIDToModulePointMapKey::'+quoteTypeBundleIDToModulePointMapKey);
                //Build a map of quote type with bundle products key to total module point value
                if(line.Apttus_Config2__LineType__c == 'Option'){ 
                    quoteTypeBundleIDToModulePointMap = addOptionsProductToMap(quoteTypeBundleIDToModulePointMap,quoteTypeBundleIDToModulePointMapKey,line);
                }
            }
        }

        return quoteTypeBundleIDToModulePointMap;
    }

    private Map<String,Integer> addOptionsProductToMap(Map<String,Integer> quoteTypeBundleIDToModulePointMap, String quoteTypeBundleIDToModulePointMapKey,Apttus_Config2__LineItem__c line){
        Integer points= 0;
        Map<String,Integer> productToPointMap = quoteTypeBundleIDToModulePointMap;
        //If map is not empty and contains a value for the quotetype+bundleid
        if(!productToPointMap.isEMpty() && productToPointMap.get(quoteTypeBundleIDToModulePointMapKey) != null){
            //Add module point of current line item to cumulative module point
            points = Integer.ValueOf( productToPointMap.get(quoteTypeBundleIDToModulePointMapKey) + line.Apttus_Config2__OptionId__r.APTS_Module_Points__c);
            productToPointMap.put(quoteTypeBundleIDToModulePointMapKey , points);
        }
        else{
            points = Integer.ValueOf(line.Apttus_Config2__OptionId__r.APTS_Module_Points__c);
            productToPointMap.put(quoteTypeBundleIDToModulePointMapKey , Integer.valueOf( line.Apttus_Config2__OptionId__r.APTS_Module_Points__c));
        }
        return productToPointMap;
    }

    //getUpdatedDCPriceMatrices() method
    //Returns a map of product id to DCQuoteDetails.Pricematrix
    //Added DLT-20455
    public Map<String,Map<Integer,DCQuoteDetails.Pricematrix>> getUpdatedDCPriceMatrices(List<Apttus_Config2__PriceMatrixEntry__c> priceMatrixEntries, Boolean isBundleCall){
    
        Map<String,Map<Integer,DCQuoteDetails.Pricematrix>> productToPriceMatricesMap = new Map<String,Map<Integer,DCQuoteDetails.Pricematrix>>();
    
        for(Apttus_Config2__PriceMatrixEntry__c entry : priceMatrixEntries){
    
            DCQuoteDetails.Pricematrix matrix = new DCQuoteDetails.Pricematrix();
            matrix.amount = entry.Apttus_Config2__AdjustmentAmount__c;
            String productId;
    
            if(isBundleCall){
                productId = entry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c + entry.Apttus_Config2__Dimension1Value__c;
                matrix.quantity = Integer.valueOf(entry.Apttus_Config2__Dimension2Value__c);
            }
            else{
                productId = entry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
                matrix.quantity = Integer.valueOf(entry.Apttus_Config2__Dimension1Value__c);
            }
    
            if(!productToPriceMatricesMap.containsKey(productId)){
                productToPriceMatricesMap.put(productId, new Map<Integer,DCQuoteDetails.Pricematrix>());
            }
    
            productToPriceMatricesMap.get(productId).put(matrix.quantity,matrix);
        }

        //Calls method to fill in missing price matrices
        productToPriceMatricesMap = updateMissingPriceMatrices(productToPriceMatricesMap);
    
        return productToPriceMatricesMap;
    }//end of getUpdatedDCPriceMatrices() method

    //updateMissingPriceMatrices() method
    //Returns an updated Map<String,Map<Integer,DCQuoteDetails.Pricematrix>> with any missing price matrices filled in.
    //Added DLT-20455
    private Map<String,Map<Integer,DCQuoteDetails.Pricematrix>> updateMissingPriceMatrices(Map<String,Map<Integer,DCQuoteDetails.Pricematrix>> productToPriceMatricesMap){
        
        Map<String,Map<Integer,DCQuoteDetails.Pricematrix>> tempMap = productToPriceMatricesMap;

        if (productToPriceMatricesMap == null){
            return productToPriceMatricesMap;
        }

        //Iterate over all productIds found in the map key set
        for(String productId : tempMap.keySet()){
            DCQuoteDetails.Pricematrix prevMatrix; 
            //Iterate down over all attorney counts, starting from the highest
            for(Integer i = maxNoOfAttorneys; i >= 1; i--) {
                //If attorney count does not exist for the given price matrix, use set values equal to previous matrix
                if(!tempMap.get(productId).keySet().contains(i)) {
                    //If no previous matrix exists, set 'amount' to 0
                    if(prevMatrix == null) {
                        prevMatrix = new DCQuoteDetails.Pricematrix();
                        prevMatrix.amount = 0;
                    }
                    prevMatrix.quantity = i;
                    tempMap.get(productId).put(i, prevMatrix.clone());            
                }

                //Set 'prevMatrix' as a clone of the current price matrix
                prevMatrix = tempMap.get(productId).get(i).clone();
            }
        }

        return tempMap;
    }//end of updateMissingPriceMatrices() method

    /*
        Prepares Sort priceMap based on priceMap, Order passed as parameters.
    */
    @testVisible
    private Map<Integer, DCQuoteDetails.Pricematrix> sortMap (Map<Integer, DCQuoteDetails.Pricematrix> theMap, String theOrder) {
        
        Map<Integer, DCQuoteDetails.Pricematrix> returnMap = new Map<Integer, DCQuoteDetails.Pricematrix>();
        //get the set of the keys of the map we want to sort
        Set<Integer> keySet = theMap.keySet();
        //create a list and add all the keys from the set to sort
        List<Integer> keyList = new List<Integer>();
        keyList.addAll(keySet);
        //sort the list ascending (predefined behaviour)
        keyList.sort();
        if (theOrder == DESCENDING){
            //iterate from the last to the first key over the ascending ordered key list
            for (Integer i = (keyList.size() - 1); i >= 0; i--){
                returnMap.put(keyList[i], theMap.get(keyList[i]));
            }
        }
        else{
            //iterate from the first to the last key over the ascending ordered key list
            for (Integer i = 0; i < keyList.size(); i++){
                returnMap.put(keyList[i], theMap.get(keyList[i]));
            }
        //return the sorted map
        }
        return returnMap;
    }

    public List<DC_Contract_Term_V2__mdt> queryContractTermDetails(DCQuoteDetails.QuoteDetail qdetail){

        List<DC_Contract_Term_V2__mdt> contractTerms=new List<DC_Contract_Term_V2__mdt>();        
        String query;
        String qType = String.escapeSingleQuotes(qdetail.quoteType);
        String segType = String.escapeSingleQuotes(digitalFirm);  

        query ='select Markup_Percentage__c,YoY_1_Renewal__c,DC_Years_2_Plus_Adjustment__c, Contract_Term__c,Customer_Category__c,Segment__c,Default_Customer_Category__c from DC_Contract_Term_V2__mdt where Quote_Type__c =';
        
        //DLT-11734 to prevent SOQL Injection            

        query = query +'\''+ qType +'\' AND Segment__c=\''+segType;
        if(qdetail.customerCategory != null && qdetail.customerCategory != 0 && digitalFirm !='FindLaw'){ //DLT-16401 changed for multi-year pricing and used Custom Metadata Type DC Contract Term V2 Setting
            String customerCategory = String.escapeSingleQuotes(String.valueOf(qdetail.customerCategory)); 
            query = query + '\' AND Customer_Category__c ='+customerCategory ;
        }
        //Filtering contract terms for Default Customer Category if null
        else{
            query = query + '\' AND Default_Customer_Category__c = true' ;             
        }
        System.debug('Query :' +query);

        if(Schema.sObjectType.DC_Contract_Term_V2__mdt.isQueryable()){//DLT-11734
            contractTerms = Database.query(query);
        }

        return contractTerms;
    }

    private DCQuoteDetails.ContractTermDetail calculateYearOnYear(DCQuoteDetails.ContractTermDetail detail,DC_Contract_Term_V2__mdt termObj,DCQuoteDetails.QuoteDetail qdetail){
        
        DCQuoteDetails.ContractTermDetail contractTermDetail = detail;

        if(objYoy.arrYoyStraight[0]!= 0.0 || objYoy.arrYoyStraight[1]!= 0.0 || objYoy.arrYoyStraight[2]!= 0.0){
            contractTermDetail.yearOnYearRenewal = getYearOnYearAmount(termObj,objYoy.arrYoyStraight);
            contractTermDetail.yearOnYearTwoPlus = getYearOnYearAmount(termObj,objYoy.arrYoyStraight);

            //DLT-19245  When single-offer with term current is given as 3 years or no term current we are sending always defaulted to 7%. 
            if((termCurrent== 3 || termCurrent == null) && termObj.Contract_term__c == '1 Year' 
                && LAW_FIRMS.contains(digitalFirm) && qdetail.quoteType == QUOTE_TYPE_STRAIGHT_RENEWAL 
                && digitalOfferType == QUOTE_TYPE_STRAIGHT_RENEWAL){

                contractTermDetail.yearOnYearRenewal = 7.0;
                contractTermDetail.yearOnYearTwoPlus = 7.0;
            }

        }//For straight proposal
        else if(objYoy.arrYoyBest[0]!= 0.0 || objYoy.arrYoyBest[1]!= 0.0 || objYoy.arrYoyBest[2]!= 0.0){
            contractTermDetail.yearOnYearRenewal = getYearOnYearAmount(termObj,objYoy.arrYoyBest);
            contractTermDetail.yearOnYearTwoPlus = getYearOnYearAmount(termObj,objYoy.arrYoyBest);
        }//For best proposal
        else if(objYoy.arrYoyPremium[0]!= 0.0 || objYoy.arrYoyPremium[1]!= 0.0 || objYoy.arrYoyPremium[2]!= 0.0){
            contractTermDetail.yearOnYearRenewal = getYearOnYearAmount(termObj,objYoy.arrYoyPremium);
            contractTermDetail.yearOnYearTwoPlus = getYearOnYearAmount(termObj,objYoy.arrYoyPremium);
        }//For Premium proposal
        //DLT-10763 end
        else{
            contractTermDetail.yearOnYearRenewal = termObj.YoY_1_Renewal__c;
            contractTermDetail.yearOnYearTwoPlus = termObj.DC_Years_2_Plus_Adjustment__c;
        }

        return contractTermDetail;
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

    private DCQuoteDetails.ContractTermDetail calculateAdjustment(DCQuoteDetails.ContractTermDetail detail,DC_Contract_Term_V2__mdt termObj,Apttus_Config2__ProductConfiguration__c cart){
        
        DCQuoteDetails.ContractTermDetail contractTermDetail = detail;  

        //DLT-16664 update send as Default Disccount
        if(digitalFirm =='FindLaw'){
            newAdjustmentAmount = (termObj.Contract_Term__c == '3 Years'? termObj.DC_Years_2_Plus_Adjustment__c : (termObj.Contract_Term__c == '2 Years'? termObj.YoY_1_Renewal__c : 0.0));
            newAdjustmentType = Label.DC_PERCENT_DISCOUNT;
        }else{
            newAdjustmentAmount = 0.0;
            newAdjustmentType = '';
        }

        //Calculates new Adjustment amounts.
        calculateNewAdjustment(termObj,cart.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c,cart.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c);
        contractTermDetail.adjustmentType = newAdjustmentType;
        contractTermDetail.adjustmentAmount = newAdjustmentAmount;

        return contractTermDetail;
    }


    /*
     * Prepare list of ContractTerms based on customerCategory and QuoteType 
     * DLT-19245 Updated with digitalOfferType it give you only Straight.
     */ 
    private List<DCQuoteDetails.ContractTermDetail> getContractTerms(DCQuoteDetails.QuoteDetail qdetail, Apttus_Config2__ProductConfiguration__c cart){
        
        //Added DLT-15149
        //Fills contractTermDetails via cart data if quote type is 'Manual'
        if(qdetail.quoteType == 'Manual'){
            return DCQuoteServiceHelper.getManualContractTermDetails(cart);
        }
        //Added by Srini as part of DLT-9251
        try{
            List<DCQuoteDetails.ContractTermDetail> contractTermDetails = new List<DCQuoteDetails.ContractTermDetail>();
            List<DC_Contract_Term_V2__mdt> contractTerms=new List<DC_Contract_Term_V2__mdt>();        
            
            contractTerms = queryContractTermDetails(qdetail);
            
            System.debug('contractTerms***'+contractTerms );

            //Populating yoyRenwal and yoyTwoplus values based on the contract terms.
            for( DC_Contract_Term_V2__mdt termObj : contractTerms ){                
                DCQuoteDetails.ContractTermDetail detail = new DCQuoteDetails.ContractTermDetail();
                //Setting term and mark up %
                detail.term = termObj.Contract_Term__c;
                detail.markupPercentage = termObj.Markup_Percentage__c;
                if(digitalFirm !='FindLaw'){ //DLT-16401 changed for multi-year pricing and used Custom Metadata Type DC Contract Term V2 Setting YOY is not needed for FindLaw
                    detail = calculateYearOnYear(detail,termObj,qdetail);
                }                

                detail = calculateAdjustment(detail,termObj,cart);

                string term= qdetail.contractTerm;
                detail.isBestValue = false;
                if(String.isNotBlank(term) && term.equalsIgnorecase(termObj.Contract_Term__c)){
                    detail.isBestValue = true;
                }
                System.debug('termCurrent==>'+termCurrent);

                detail = DCQuoteServiceHelper.getAccessPermission(detail,termObj,termCurrent);

                contractTermDetails.add(detail);
                System.debug('contractTermDetails==>'+contractTermDetails);
            }
            return contractTermDetails;
        }catch(Exception ex){//DLT-11734
            System.debug('Exception Thrown DCQuoteService::' + ex.getMEssage()+ ex.getLineNumber());
            return new List<DCQuoteDetails.ContractTermDetail>();
        }
    }
    /*
     *  Calculate the Adjustment Amount based on defaultAdjustmentAmount, defaultAdjustmentType passed as Parameters.
     */ 
    private void calculateNewAdjustment(DC_Contract_Term_V2__mdt contractTerm,Decimal defaultAdjustmentAmount, String defaultAdjustmentType ){

        if(contractTerm != null){
            calculateNewAdjustmentHelper(contractTerm,defaultAdjustmentAmount,defaultAdjustmentType);
        } 
        else {// otherwise set it to default adjustment amount.
            newAdjustmentAmount = defaultAdjustmentAmount;
        }

        if(newAdjustmentAmount < 0) {// IF new adjustment amount is negative, set it to dc % markup
            newAdjustmentAmount = newAdjustmentAmount * (-1);
            newAdjustmentType = Label.DC_PERCENT_MARKUP;
        } 
        else {
            //DLT-16846 Remove logic to cap adjustment amount    
            newAdjustmentType = (defaultAdjustmentType == null && newAdjustmentAmount > 0 ? Label.DC_PERCENT_DISCOUNT : defaultAdjustmentType ); //DLT-16664 update if there is no defaultAdjustmentType,newAdjustmentAmount more than 0, updateing with AdjustmentType to Discount.
        }        
    }

    private void calculateNewAdjustmentHelper(DC_Contract_Term_V2__mdt contractTerm,Decimal defaultAdjustmentAmount, String defaultAdjustmentType ){
        //Setting markup % from contract term meta data.
        Decimal markup =  ((contractTerm.Markup_Percentage__c == Null) ? 0.0 : contractTerm.Markup_Percentage__c) ;
        //If default adjustment matched with the DC  % discount, calculate new adjustment amount by deducting markup .
        if(defaultAdjustmentType == Label.DC_PERCENT_DISCOUNT) {
            newAdjustmentAmount = defaultAdjustmentAmount - markup;
        } else {
            // if default adjustment type matches to dc % markup, add mark up amount to default adjustment amount.
            if(defaultAdjustmentType == Label.DC_PERCENT_MARKUP) {
                newAdjustmentAmount = defaultAdjustmentAmount + markup;
            }
        }
    }
 
    /*
     * updated the all lineItem with ContractTerm and Quantity If the values has been modified
     * Updated Ecom_No_Of_Attorneys in Cart object if Quantity has been changed and It will be used when new Products are added to cart. 
     */ 
    public DCQuoteUpdate.QuoteUpdateResponse updateAllLineItems(List<DCQuoteUpdate.QuoteUpdateRequest> landings,Boolean isResetQuote){
        DCPerformUpdateSvcHelper dcUpdate = new DCPerformUpdateSvcHelper();
        return dcUpdate.updateAllLineItems(landings,isResetQuote);
    }   

    /*
     *  update the Price on Cart using APttus API
     */ 
    public static DCPerformRepriceController.RepriceResponse repriceByQuoteId(String quoteId){
        DCPerformRepriceController.RepriceResponse response = new DCPerformRepriceController.RepriceResponse();
        try{
            //Sending repricing status if it pending or not and sending success message if operation is success.
            boolean isPending = DCUtils.repriceByQuoteId(quoteId);
            response.isPricingPending = isPending;
            response.responseCode = 200;
            response.responseMessage = 'Success';
            return response;
        }catch(Exception ex){//Sending the error message if service is failed.
            DCUtils.trackLog(ex,'DCQuoteService','repriceByQuoteId');
            response.responseCode = 400;
            response.responseMessage = ex.getMessage();//Sending Exception message to AEM.
            return response;
        }    
    }
     /*
     * Synchronize the cartLineItems with QuoteLineItems
     */     
    public static DCPerformSynchronizeController.SynchronizeResponse synchronizeCart(List<String> quoteIdList) {
        DCPerformSynchronizeController.SynchronizeResponse response = new DCPerformSynchronizeController.SynchronizeResponse();
        String currentQuoteId = '';
        try{
            for(String quoteId : quoteIdList){
                currentQuoteId = quoteId;
                //Syncronizing the cart for the requested proposal.
                DCConfiguratorUtil.synchronizeCart(quoteId);                
            }//End of For loop.
            //Sending Success message
            response.responseCode = 200;
            response.responseMessage = 'Success';
            return response;
        }catch(Exception ex){//sending the error message if service is failed.
            DCUtils.trackLog(ex,'DCQuoteService','synchronizeCart');
            response.responseCode = 400;
            response.responseMessage = currentQuoteId + ': ' +ex.getMessage();//Sending Exception message to AEM.
            return response;
        }  

    }

    //getDigitalSubscriptionData() method
    //Gets digital subscription data based on passed in carts
    private void getDigitalSubscriptionData(List<Apttus_Config2__ProductConfiguration__c> carts){

        String customerNumber = carts[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c;
        String campaignCode = carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c;
        Date renewalDate = carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c;

        //Getting the Digital subscriptions based on Customer number, campaign code and renewal date match
        subscriptions = DCLandingServiceHelper.getDigitalSubscription(customerNumber,campaignCode,renewalDate);

        System.debug('subscriptions==>'+subscriptions);

        //Setting the current term.
        if(!subscriptions.isEmpty()){
            if(subscriptions[0].Current_Term_Length__c!= null){
                termCurrent = Integer.valueOf(subscriptions[0].Current_Term_Length__c);
            }

            if(subscriptions[0].Digital_Firm__c!= null){
                digitalFirm =subscriptions[0].Digital_Firm__c;
            }
        }
        System.debug('termCurrent==>'+termCurrent);
        
        //DLT-16910 Rep Driven Personalized Offer do not have Digital Subscription records
        // updated for DLT-21586 - use business unit only for FindLaw
        if (carts[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == QUOTE_TYPE_MANUAL ){
        	if (carts[0].Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c == 'FindLaw') {
            	digitalFirm = carts[0].Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c;
        	} else {
        		digitalFirm = carts[0].Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c;
        	}
        }
        System.debug('digitalFirm==>'+digitalFirm);

        //Logic for populating data from each digital subscription
        for(Product_Account_Detail__c pad : Subscriptions ){
            getDigitalSubscriptionDataHelper(carts,pad);
        }

    }//end of getDigitalSubscriptionData() method

    private void getDigitalSubscriptionDataHelper(List<Apttus_Config2__ProductConfiguration__c> carts,Product_Account_Detail__c pad){
        //DLT-12679 - Recommendations reason from Automation file for Upsell Offers
        for( Apttus_Config2__ProductConfiguration__c cart : carts){
            if(!plusRecTextCodeMap.containsKey(cart.Apttus_QPConfig__Proposald__c) && String.isNotBlank(pad.Plus_Rec_Text_Code__c)){
                plusRecTextCodeMap.put(cart.Apttus_QPConfig__Proposald__c,pad.Plus_Rec_Text_Code__c);
            }
            if(!premiumRecTextCodeMap.containsKey(cart.Apttus_QPConfig__Proposald__c) && String.isNotBlank(pad.Premium_Rec_Text_Code__c)){
                premiumRecTextCodeMap.put(cart.Apttus_QPConfig__Proposald__c,pad.Premium_Rec_Text_Code__c);
            }                        
        }

        if(String.isNotBlank(pad.Bundle_Id__c)){
            bundleProdIdSet.add(pad.Bundle_Id__c);
        }

        //Populates the objYOY variable with YOY values from Digital Subscriptions
        objYoy = DCQuoteServiceHelper.getYOYValues(objYoy,pad,false);
    }

    public class YOYValues{
    
        public Decimal[] arrYoyStraight= new List<Decimal>{0.0,0.0,0.0};
        public Decimal[] arrYoyBest= new List<Decimal>{0.0,0.0,0.0};
        public Decimal[] arrYoyPremium= new List<Decimal>{0.0,0.0,0.0};        
    }
}