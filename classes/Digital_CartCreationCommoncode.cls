/**********************************************************************************************************************
Change History
***********************************************************************************************************************
Name                Date            JIRA        Description
HarikaSai P                         DLT-12136   Digital Quote Automation optimization for Cart Creation for Straight Renewal, Best AND Premium.
Divija S                            DLT-12134   
                                    DLT_12139   Updated null check on YoY_1_Renewal__c by Srikanth Kota
Divija S            Oct 07 2018     DLT_12190   Optimized Code as part of this STory
HarikaSai P         Oct 08 2018     DLT-12193   Mid Contract AND Renewal opporunity will be same
Harika Sai P        Oct 18 2018     DLT-12773   Remove the automation exclusion logic code in Salesforce based on MHLC
Srikanth Kota       Dec 12 2018     DLT-14031
                                    DLT-14032   Term length is always 3 Years AND if DS YOY has AND these values need to apply related to 3 Year.
Divija Salla        Jan 24 2019     DLT-14487   [All] SR- Automation to validate the Asset renewal date to be within 15 months of opportunity renewal date
Benjamin Her        Feb 01 2019     DLT-14752   Exception logging improvements
Navleen Kaur        Feb 06 2019     DLT-14618   [All] Digital firm should be populated based Firm type in automation feed/file
Srikanth Kota       Feb 19 2019     DLT-15184   FL- Quote Automation for Findlaw proposals - Straight Renewal.
Navleen Kaur        Mar 15 2019     DLT-15435   Automation to pick only active assets AND not cancelled assets
Navleen Kaur        Mar 20 2019     DLT-15672   [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
Srikanth Kota       Mar 22 2019     DLT-15692   [Tech Story][FindLaw] Quote Automation - Apply discounts on Straight Renewal.
Bishanka Dassarma   Apr 02 2019     DLT-15809   Finance load of opportunities done does not have Status value - Automation
Srikanth Kota       Apr 11 2019     DLT-16116   New Midcontract - Digital Quote Automation Issues
Navleen Kaur        Apr 26 2019     DLT-16234   Add-on price is not added properly to personalized plan total.AND also there is a price mismatch both in landing page intro para AND confirmation page
Srikanth Kota       May 06 2019     DLT-16401   [FindLaw][SFDC] Straight Renewal - Apply multi-year pricing discount.
HarikaSai P         May 08 2019     DLT-16095   Attempt to de-reference a null object - null pointer Exception
Navleen Kaur        May 22 2019     DLT-16234   Adding Default_Add_On__c functionality as code is moved by Recommendation team
Harikasai P         Jun 25 2019     DLT-16854   [Tech Story] - Remove Unnecessary code lines FROM Proposal Automation AND move to Dataoperation Layer
Benjamin Her        Aug 14 2019     DLT-17401   [Tech Story] - Mark isAssetPricing to true for Findlaw Straight Renewal
Navleen Kaur        Aug 20 2019     DLT-17360   [ALL] Update CXD Automation class to not process an account if Digital Subscription bypass field has been Set
Harika Sai P        Aug 17 2019     DLT-17632   [ALL] Handling subs FROM different segments, added isRunningTest in this class to improve coverage of Digital_ProposalAutomation
Benjamin Her        Sep 24 2019     DLT-17762   Fix Prod issue due to Print Product
HarikaSaiP          Oct 21 2019     DLT-17793   [CORP][SFDC] Multi Offer - Add option products to the subscription List
Benjamin Her        Nov 05 2019     DLT-18013   [Tech Story] Update the automation process properly handle FindLaw assets
Sumanth Padarapaka  Nov 20 2019     DLT-18196   To add contract number as unique identifier for FindLaw product
Srikanth kota       Dec 09 2019     DLT-18554   MarkUp value for current simplified Govt value is not added
David Hoel          Dec 13 2019     DLT-18593   Handling duplicate West proflex in automation
Benjamin Her        Dec 17 2019     DLT-19035   Bug Fix: Straight Renewal Cart not created properly
Srikanth kota       Dec 18 2019     DLT-18962   Fixing PMD violations for Digital_CartCreationCommoncode /Avoid Soql queries inside loops
Harika Sai P        DEC 20 2019     DLT-19093   Corp Prod Issues
Benjamin Her        Jan 01 2020     DLT-19023   [FindLaw] Apply default discount to Markup
Benjamin Her        Jan 08 2020     DLT-19207   [FindLaw] Update line items when One Year Experience flag is TRUE
Harika Sai P        Dec 17 2019     DLT-18750 - [Tech - Automation] West Proflex sub components should not be added to cart while renewing
Benjamin Her        Feb 05 2020     DLT-17814   Handle accounts with more than 10 assets 
Benjamin Her        Apr 02 2020     DLT-19857   Updated class to workaround known Apttus Summer '19 Package issues
Brenda Shields      Jun 11 2020     DLT-20106   Update to fix issue of running SLF and FL in one batch can getting SLF products in the FL cart
Brenda Shields      Jly 22 2020     DLT-20449   Bug - use quote sold to SSD Digital Firm value to match assets to correct quote/cart
Benjamin Her        Aug 08 2020     DLT-20588   Implement MLF support
Benjamin Her        Nov 04 2020     DLT-20921   Remove West Proflex subproducts
Benjamin Her        Nov 04 2020     DLT-20755   PMD fix
Kavya S             Feb 03 2021     DLT-21380   REN - Fixed quote automation process
Ameeta A			Mar 23 2021		DLT-21505   Stop sending Contract Start date on line items
Brenda Shields      2021-04-01      DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
                                                Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
************************************************************************************************************************************/

/**
 * @description Purpose of this class is to create carts and line items
 */
public without sharing class Digital_CartCreationCommoncode{

    // Global varibles declaration used for different operations
    private static List<Digital_Exception_Log__c> exList = new List<Digital_Exception_Log__c>();
    private static Map<Id, Set<String>> accCancelProductsMap;
    // Variables used for contract terms population
    private static Map<Integer, DC_Contract_Term_V2__mdt> customerCatToDefaultTermMap = new Map<Integer, DC_Contract_Term_V2__mdt>();
    private static Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> contractTermsMap;
    // added as part of DLT-16234 by navleen
    private static Map<Id, List<Apttus_CPQApi.CPQ.AssetActionDO>> accAssetListMap= new Map<Id, List<Apttus_CPQApi.CPQ.AssetActionDO>>();
    // added as a part of DLT-20106 - we need to know what the Digital Firm is for each Cart and Asset
    private static map<id, string> mapCartDigitalFirm = new map<id, string>();
    private static map<id, string> mapQuoteDigitalFirm = new map<id, string>();
    private static set<String> setAssetDigitalFirms = new set<String>();
    
    // Config asset lists declartion for three proposal types.
    public static Set<Id> setSSDOpptyMidConDenied;
    public static Set<Id> setSSDOpptyMidConNotDenied;
    private static Map<Id, Date> renewalDateMaps = new Map<Id, Date>();
    
    private static Map<Id, List<Apttus_CPQApi.CPQ.SelectedProductDO>> accPrdListMap;

    //Fetching the contract terms based on the proposal type.
    /**
     * @description Main logic called for cart and line item creation
     * @param quoteProposalIdList List of quote ids which cart will be created for.
     * @param quoteName Digital quote type for the quotes: 'Straight Renewal', 'Best Value', Premium
     */
    public static void contractTerms(List<Id> quoteProposalIdList, String quoteName) {
        
        System.debug(LoggingLevel.DEBUG,'quoteProposalIdList==>' + quoteProposalIdList);
        Map<Id, Apttus_Proposal__Proposal__c> proposalMap = new Map<Id, Apttus_Proposal__Proposal__c>([
            SELECT Id, OwnerId, APTS_Proposal_Business_Unit__c, APTS_SSD_Sold_To__c, 
                APTS_SSD_Sold_To__r.APTS_Customer_Category__c, APTS_SSD_Sold_To__r.Digital_Firm__c, 
                Digital_Quote_Failure_Reason__c, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Opportunity__r.Renewal_Date__c, 
                Apttus_Proposal__Opportunity__r.Campaign_Code__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                Apttus_Proposal__Opportunity__r.name, Apttus_Proposal__Opportunity__r.SAP_Account_Number__c 
            FROM Apttus_Proposal__Proposal__c WHERE Id IN :quoteProposalIdList
        ]); 
        List<String> sapAccNo = new List<String>();
        for (Apttus_Proposal__Proposal__c proposal: proposalMap.Values()) {
            sapAccNo.add(proposal.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c);
            
            populateMapQuoteDigitalFirm(proposal);
        }
        Digital_CartCreationCommonVariables.dSubList = [
            SELECT Bundle_Id__c, Campaign_Code__c, ZP_Cust_Number__c, Digital_Firm__c, Contract_Type__c, 
                Add_on_Type__c, Default_Add_On__c, Add_On_Sub__c, Add_On_Svc__c, Current_Term_Length__c, 
                Type__c, Premium_New_Service__c, Premium_New_Subscription__c, Year1_YoYvalue__c, Year2_YoYvalue__c, 
                Year3_YoYvalue__c, AccountSSD__c, Actual_New_Service__c, Actual_New_Subscription__c, 
                Actual_New_Subscription_Product__c, Actual_New_Subscription_Product__r.APTS_Module_Points__c, 
                Quantity__c, Current_Subscription__c, Offer_Price__c, Renewal_Date__c, DC_Contract_Number__c,One_Year_Experience_Flag__c  
            FROM Product_Account_Detail__c 
            WHERE ZP_Cust_Number__c IN :sapAccNo AND Campaign_Code__c != null 
            AND Renewal_Date__c > Today AND Bypass_Automation__c = false
        ];  //Query changed as a part of DLT-15809

        for (Product_Account_Detail__c newprd: Digital_CartCreationCommonVariables.dSubList) {  //Query changed as a part of DLT-15809, DLT-17793        
            Digital_CartCreationCommonVariables.dgfirmap.put(newprd.ZP_Cust_Number__c, newprd.Digital_Firm__c);
            System.debug(LoggingLevel.DEBUG,'remove ds:' + newprd);
        }

        List<DC_Contract_Term_V2__mdt> fullContractTerms = new List<DC_Contract_Term_V2__mdt>(); 
        
        String query;
        // Dynamic query for DC_Contract_Term_V2__mdt filtering with proposal type
        query = 'SELECT Segment__c,Customer_Category__c,Default_Customer_Category__c,Default_Contract_Term__c,Markup_Percentage__c,YoY_1_Renewal__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c,Quote_Type__c FROM DC_Contract_Term_V2__mdt WHERE Segment__c != null AND Default_Contract_Term__c =true AND Quote_Type__c =\''+ String.escapeSingleQuotes(quoteName)+'\'';        
        fullContractTerms = Database.query(query);

        Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> tempAccFirmByContractTermMap = new Map<String, Map<Integer, DC_Contract_Term_V2__mdt>>();
        
        // DLT-9536 - get proposal owner to use to Set th e cart owner
        Map<Id, Id> mapPropOwner = new Map<Id, Id>();
        Map<Id, Id> quoteSoldToAccMap = new Map<Id, Id>();

        Digital_CartCreationCommonVariables.defaultByAccFirmMap = new Map<String, DC_Contract_Term_V2__mdt>();
        contractTermsMap = new Map<String, Map<Integer, DC_Contract_Term_V2__mdt>>();
        
        //Looping through full contract terms
        for (DC_Contract_Term_V2__mdt dcConTerm : fullContractTerms) {
            Digital_CartCreationCommonVariables.defaultByAccFirmMap = Digital_CartCreationHelper.addTodDefaultByAccFirmMap(dcConTerm,Digital_CartCreationCommonVariables.defaultByAccFirmMap);
            tempAccFirmByContractTermMap = Digital_CartCreationHelper.addToTempAccFirmByContractTerm(dcConTerm,tempAccFirmByContractTermMap);
        }
       
        System.debug(LoggingLevel.DEBUG,'proposalMap' + proposalMap);

        //Looping through List of proposals requested FROM automation batch job.
        for (Apttus_Proposal__Proposal__c  proposal : proposalMap.values()) {
            mapPropOwner.put(proposal.Id, proposal.Ownerid);
            System.debug(LoggingLevel.DEBUG,'proposal==>' + proposal);

            populateDataMapping(proposal,quoteSoldToAccMap,tempAccFirmByContractTermMap);

            }
        System.debug(LoggingLevel.DEBUG,'quoteSoldToAccMap==>' + quoteSoldToAccMap);
      
        //carts List preparation
        if (quoteProposalIdList != null && quoteProposalIdList.size() > 0 && quoteSoldToAccMap != null 
                && !quoteSoldToAccMap.isEmpty() ) {
            List<Apttus_Config2__ProductConfiguration__c> cartList = Digital_CartCreationHelper.prepareCartList(quoteProposalIdList, quoteSoldToAccMap, mapPropOwner);
            
            insertCartHelper(cartList,quoteSoldToAccMap,quoteName);

        }
    } 
    private static void insertCartHelper(List<Apttus_Config2__ProductConfiguration__c> cartList,Map<Id, Id> quoteSoldToAccMap,String quoteName){
            if (cartList != null && cartList.size() > 0) {
                //Initates DML for Carts insertion.
            insertCartlist(cartList, quoteSoldToAccMap, quoteName);
        }
            }

    private static void populateDataMapping(Apttus_Proposal__Proposal__c  proposal,Map<Id, Id> quoteSoldToAccMap,Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> tempAccFirmByContractTermMap){
        if (proposal.APTS_SSD_Sold_To__c != null && proposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c != null && proposal.Digital_Quote_Failure_Reason__c == 'NA'){
            quoteSoldToAccMap.put(proposal.Id, proposal.APTS_SSD_Sold_To__c);     
            renewalDateMaps.put(proposal.APTS_SSD_Sold_To__c, proposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c);

            addToContractTermsMap(proposal,tempAccFirmByContractTermMap);
        }
    } 
    
    //populateMapQuoteDigitalFirm() method
    //Adds the proposals Digital Firm to 'mapQuoteDigitalFirm'
    private static void populateMapQuoteDigitalFirm(Apttus_Proposal__Proposal__c proposal){
    
        // build a map of quote digital firms in order to know the digital firm of the cart
        if (proposal.APTS_Proposal_Business_Unit__c == 'FindLaw') {
            mapQuoteDigitalFirm.put(proposal.Id, 'FindLaw');
        } else {
            mapQuoteDigitalFirm.put(proposal.Id, proposal.APTS_SSD_Sold_To__r.Digital_Firm__c);   
        }
    }
    
    //addtoContractTermsMap() method
    //Adds the proposals to the 'tempAccFirmByContractTermMap'
    private static void addtoContractTermsMap(Apttus_Proposal__Proposal__c  proposal,Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> tempAccFirmByContractTermMap){

        if (proposal.APTS_SSD_Sold_To__r.APTS_Customer_Category__c != null 
                && (Digital_CartCreationCommonVariables.dgfirmap.get(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c) != null 
                || Digital_CartCreationCommonVariables.dgfirmap.get(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c) != 'None') ) {
            //DLT-15184 added for Findlaw
            if (proposal.APTS_Proposal_Business_Unit__c != 'FindLaw') {
                populateCategoryToDefaultTermMap(proposal,tempAccFirmByContractTermMap);

                contractTermsMap.put(
                    Digital_CartCreationCommonVariables.dgfirmap.get(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c),
                    customerCatToDefaultTermMap
                );
            } //End DLT-15184 added for Findlaw
        }
    }
    private static void populateCategoryToDefaultTermMap(Apttus_Proposal__Proposal__c  proposal,Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> tempAccFirmByContractTermMap){
                if (tempAccFirmByContractTermMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c)).containsKey(Integer.Valueof(proposal.APTS_SSD_Sold_To__r.APTS_Customer_Category__c))) {
                    customerCatToDefaultTermMap.put(
                        Integer.Valueof(proposal.APTS_SSD_Sold_To__r.APTS_Customer_Category__c), 
                        tempAccFirmByContractTermMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c)).get(Integer.Valueof(proposal.APTS_SSD_Sold_To__r.APTS_Customer_Category__c))
                    );
                } else {
                    customerCatToDefaultTermMap.put(
                        Integer.Valueof(proposal.APTS_SSD_Sold_To__r.APTS_Customer_Category__c), 
                        Digital_CartCreationCommonVariables.defaultByAccFirmMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c))
                    ); 
                }
    }

    //Insert CartList
    private static Map<Id, Id> insertCartlist(List<Apttus_Config2__ProductConfiguration__c> cartList, Map<Id, Id> quoteSoldToAccMap, String quoteName) {
        
        Map<Id, Id> accCartMap = new Map<Id, Id>();
        List<Id> successCartList = new List<Id>();
        Database.SaveResult[] lsr;
        
        if (!Test.isrunningtest()) {
            lsr =  Database.insert(cartList, false);
        } else if (Test.isrunningtest()) {
            Apttus_Config2__ProductConfiguration__c cartFail = new Apttus_Config2__ProductConfiguration__c();
            cartFail.APTS_SSD_bill_to__c = Digital_CartCreationCommonVariables.priceBookId ;
            cartList.add(cartFail);
            lsr = Database.insert(cartList,false);
        }
        if(lsr == null || lsr.size() == 0){
            throw new DCCustomException('Database.SaveResults is null/empty in insertCartlist() method');
        }

        for (Integer i = 0; i < lsr.size(); i++) {
            //If carts are successfully inserted, add them to list/map
            if (lsr.get(i).isSuccess()) {
                successCartList.add(lsr.get(i).getId());
                accCartMap.put(
                    quoteSoldToAccMap.get(cartList.get(i).Apttus_QPConfig__Proposald__c), 
                    lsr.get(i).getId()
                );
                // Create map of Cart Digital Firms to manage cart line items for FindLaw Quotes
                mapCartDigitalFirm.put(lsr.get(i).getId(), mapQuoteDigitalFirm.get(cartList.get(i).Apttus_QPConfig__Proposald__c));
            } else{
                // DML operation failed
                Database.Error error = lsr.get(i).getErrors().get(0);
                String addInfo;

                for (String errorField : error.getfields()) {
                    addInfo = errorField + ',';
                }
                Digital_Exception_Log__c ex = new Digital_Exception_Log__c(
                    Exception_Message__c = error.getMessage(),
                    Exception_Type__c = 'Cart Creation - Quote Id - ' + cartList.get(i).Apttus_QPConfig__Proposald__c,
                    Additional_Information__c = addInfo,
                    User_Message__c = String.Valueof(error.getStatusCode()),
                    Class_Reference__c = 'Digital_CartCreationCommoncode > cartCreation',
                    Object__c = Digital_CartCreationCommonVariables.CARTOBJ,
                    Record_Id__c = cartList.get(i).Id);
                exList.add(ex);
            } 
        }
        
        insertExceptionLogs(exList);

        System.debug(LoggingLevel.DEBUG,'Cart Insert: Acct Cart map : ' + accCartMap);
        System.debug(LoggingLevel.DEBUG,'Cart Insert: Cart Digital Firms : ' + mapCartDigitalFIrm);
        
        buildSSDOpportunityMidContractMaps(successCartList);
        populateYOYValues(accCartMap, Quotename);
        addBundleProductToUpsell(quoteName,accCartMap,cartList);

        return accCartMap;
    }

    //addBundleProductToUpsell()
    //Calls bundle product logic for Plus/Premium offers
    private static void addBundleProductToUpsell(String quoteName, Map<Id, Id> accCartMap,List<Apttus_Config2__ProductConfiguration__c> cartList){
        if ((quoteName == 'Best Value' || quoteName == 'Premium') && !cartList.isEmpty() && cartList.size() > 0) {
            Digital_BundleProductCreation.addOptionsandPerformBundling(accCartMap.get(cartList[0].APTS_SSD_bill_to__c), quoteName, Digital_CartCreationCommonVariables.dSubList);
        }
    }

    //buildSSDOpportunityMidContractMaps() method
    //Determine if Opportuntiy MidContract status is 'Denied', then add to one of two respective maps
    private static void buildSSDOpportunityMidContractMaps(List<Id> successCartList){
        //DLT-12193
        //Created two sets to exclude Ds records while creatign cart line items based on SSD Ids.
        setSSDOpptyMidConDenied = new Set<Id>();
        setSSDOpptyMidConNotDenied = new Set<Id>();
        Digital_CartCreationCommonVariables.listNewCarts = [SELECT Id, Apttus_QPConfig__Proposald__c, APTS_SSD_bill_to__c, 
                Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_MidContract_Status__c 
                FROM Apttus_Config2__ProductConfiguration__c 
                WHERE Id IN : successCartList];
        for (Apttus_Config2__ProductConfiguration__c newCart: Digital_CartCreationCommonVariables.listNewCarts) {
            
            if (newCart.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_MidContract_Status__c == 'Denied'){
                setSSDOpptyMidConDenied.add(newCart.APTS_SSD_bill_to__c);
            } else {
                setSSDOpptyMidConNotDenied.add(newCart.APTS_SSD_bill_to__c);
            }
        }
        System.debug(LoggingLevel.DEBUG,'Cart Insert: Select: ' + Digital_CartCreationCommonVariables.listNewCarts);
    }

    //createRenewedLineItems() method
    //Renew account assets and add them to the cart
    private static void createRenewedLineItems(Apttus_Config2__ProductConfiguration__c newCart,Map<Id, Id> accCartMap,List<Apttus_CPQApi.CPQ.AssetActionDO> assetActionDoList){
        id idAsset; 
        id accID = newCart.APTS_SSD_bill_to__c;
        id idCart = newCart.id;
        string strDigitalFirm = mapCartDigitalFirm.get(idCart);
        List<Apttus_CPQApi.CPQ.AssetActionDO> assetActionDoProcess = new List<Apttus_CPQApi.CPQ.AssetActionDO>();
        List<Apttus_CPQApi.CPQ.AssetActionDO> assetActionDoBatch;
        // DLT-20106 we only want to include assets that are the same digital firm as the cart
        // this only applies to FindLaw Straight Renewal quotes
        System.debug(LoggingLevel.DEBUG,'Asset Line Item: acctId: ' + accId + ' CartId: ' + idCart + ' Digital Firm: ' + strDigitalFirm);
        
        for (Integer iCount = 0; iCount < assetActionDoList.size(); ++iCount) {
            idAsset = assetActionDolist[iCount].AssetLineItemId;
            // include this asset in the cart
            if (setAssetDigitalFirms.contains(idAsset + strDigitalFirm)) {
                assetActionDoProcess.add(assetActionDoList[iCount]);
            }
        }   

        //While there are more than 10 assets that needs to be actioned upon, 
        //Continally call Apttus in batches of 10 until only 10 or less assets are pending action
        while(assetActionDoProcess.size() > 10){
            //Removes first 10 asset and add them to a second list used in Apttus call
            assetActionDoBatch = new List<Apttus_CPQApi.CPQ.AssetActionDO>();
            for (Integer i = 0; i < 10; ++i){
                assetActionDoBatch.add(assetActionDoProcess.remove(0));
            }
            Digital_CartCreationHelper.callApttusModifyAssetAPI(accCartMap.get(accID), assetActionDoBatch);
        }
        
        //Calls ApttusModifyCartAPI
        Digital_CartCreationHelper.callApttusModifyAssetAPI(idCart, assetActionDoProcess);
    }

    //createNewLineItems
    //Create 'New' Line Items and add them to the cart, also cancels existing account assets
    private static void createNewLineItems(Map<Id, Id> accCartMap,id accID,List<Apttus_CPQApi.CPQ.AssetActionDO> assetActionDoList){
        //If there are standalone products, call Apttus service to add them to cart.
        if (accPrdListMap!= null && !accPrdListMap.isEmpty()) {
            //Calls Apttus API to add products to the cart.
            Digital_CartCreationHelper.callApttusAddMultipleProductAPI(accCartMap.get(accID), accPrdListMap.get(accID));
            Digital_CartCreationHelper.updateLineItemFields(accCartMap.get(accID), accPrdListMap.get(accID));
        }
        
        //Store the list of assets to be Cancelled, this logic cancels both Standalone and Bundle assets
        List<Id> cancelledAssetList = new List<Id>();
        for (Apttus_CPQApi.CPQ.AssetActionDO asset : assetActionDoList){
            cancelledAssetList.add(asset.AssetLineItemId);
        }
        //Calls Apttus API to cancel assets
        System.debug(LoggingLevel.DEBUG,'Remove1' +cancelledAssetList);
        Digital_CartCreationHelper.callApttusCancelAssetAPI(accCartMap.get(accID), cancelledAssetList, Date.today().addMonths(0));
    }

    /**
     * updateLineItemFields() method
     * @description Calls method for updating line items. This method is called from NSE class
     * @param cartId Id of cart where line items should be updated
     * @param selectedProducts Apttus request for products
     */
    public static void updateLineItemFields(Id cartId, List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProducts){
        Digital_CartCreationHelper.updateLineItemFields(cartId, selectedProducts);
    }

    //Modify Asset Call Service
    private static void modifyAsset(String dcQuoteType, Map<Id, Id> accCartMap, Map<Id, List<Apttus_CPQApi.CPQ.AssetActionDO>> accAssetListMap) {
        
        System.debug(LoggingLevel.DEBUG,'Remove');
        System.debug(LoggingLevel.DEBUG,'Asset Digital Firms Set: ' + setAssetDigitalFirms);
        if (accCartMap == null || accCartMap.isEmpty()){
            return;
        }
        // An account can have more than one cart, so loop through all new carts to generate the line items
        //for (Id accID : accCartMap.keyset()) {
        for (Apttus_Config2__ProductConfiguration__c newCart: Digital_CartCreationCommonVariables.listNewCarts) {
            id accID = newCart.APTS_SSD_bill_to__c;
            try {
                System.debug(LoggingLevel.DEBUG,'Remove0' );
                //Store Assets into a List
                List<Apttus_CPQApi.CPQ.AssetActionDO> assetActionDoList = accAssetListMap.get(accID);
                
                if(dcQuoteType.equalsIgnoreCase('Straight Renewal')){       
                    createRenewedLineItems(newCart,accCartMap,assetActionDoList);
                }
                //If NOT Straight, then quote is either Plus/Premium. 
                //So check if there are products that needs to be added to the cart.
                else {
                    createNewLineItems(accCartMap,accID,assetActionDoList);
                }
            } catch (exception e) {
                Digital_Exception_Log__c ex = new Digital_Exception_Log__c(
                    Exception_Message__c = e.getMessage(),
                    Exception_Type__c = e.getTypeName(),
                    Additional_Information__c = e.getStackTraceString(),
                    User_Message__c = 'Source System Detail - ' + accId, 
                    Class_Reference__c = 'Digital_CartCreationCommoncode > CartCreation-ModifyAsset()',
                    Object__c = Digital_CartCreationCommonVariables.CARTOBJ,
                    Record_Id__c = '');
                exList.add(ex);
            } 
        }
        insertExceptionLogs(exList);
    }
    
    //addTopadList() method
    //Based the type of quote, add and return an updated Product Account Detail list.
    private static List<Product_Account_Detail__c> addTopadList(List<Product_Account_Detail__c> productAccountDetailList,Product_Account_Detail__c pdc, String quoteName){
        List<Product_Account_Detail__c> padList = productAccountDetailList;

        Digital_CartCreationHelper.addStraightpadList(quoteName,pdc,padList);
        Digital_CartCreationHelper.addBestpadList(quoteName,pdc,padList);
        Digital_CartCreationHelper.addPremiumpadList(quoteName,pdc,padList);
                    
        return padList;
    }


    // populateYOYValues
    private static void populateYOYValues(Map<Id, Id> accCartMap, String quoteName) {

        //Below List<Product_Account_Detail__c>'s will contain DS records associated with the offer.
        //For Plus/Premium, Straight Renewal DS records are also added since we cancel the assets on Plus/Premium.
        List<Product_Account_Detail__c> padStraight = new List<Product_Account_Detail__c>();
        List<Product_Account_Detail__c> padBest = new List<Product_Account_Detail__c>();
        List<Product_Account_Detail__c> padPremium = new List<Product_Account_Detail__c>();


        if (accCartMap == null || accCartMap.isEmpty()){
            throw new DCCustomException('accCartMap is null or empty');
        }

        populateconfigAssets(accCartMap);

        for (Product_Account_Detail__c pdc : Digital_CartCreationCommonVariables.dSubList) {
            padStraight = addTopadList(padStraight,pdc,quoteName);
            padBest = addTopadList(padBest,pdc,quoteName);
            padPremium = addTopadList(padPremium,pdc,quoteName);
        }

        //Create line items based on type of quote
        if (quoteName == 'Straight Renewal') {
            lineItemCreationStraight(padStraight,accCartMap);
        }

        if (quoteName == 'Best Value') {
            lineItemCreationBestValue(padBest,accCartMap);
        }

        if (quoteName == 'Premium') {
            lineItemCreationPremium(padPremium,accCartMap);
        }
    
    }   
    
    //lineItemCreationStraight() method
    //Creates line items of account's assets
    private static void lineItemCreationStraight(List<Product_Account_Detail__c> padStraight,Map<id,id> accCartMap){
    
        List<Product_Account_Detail__c> productDetailListStraight = new List<Product_Account_Detail__c>(); 
        Map<Id, List<Product_Account_Detail__c>> accountToDigitalSubsMap = new Map<Id, List<Product_Account_Detail__c>>();
        System.debug(LoggingLevel.DEBUG,'***padStraight' + padStraight);  
        for (Product_Account_Detail__c camp2 : padStraight) {
            productDetailListStraight.add(camp2);
            accountToDigitalSubsMap.put(camp2.AccountSSD__c, productDetailListStraight);
        } 
        System.debug(LoggingLevel.DEBUG,'***accountToDigitalSubsMap' + accountToDigitalSubsMap);
    
        validateAndCreateAssets(accountToDigitalSubsMap);
        
        //End of For loop 
        if (Test.IsRunningTest() || (accAssetListMap != null && accAssetListMap.keyset().size() > 0 
                && accCartMap.keyset().size() > 0)) {
            //Modify Asset Call Service
            System.debug(LoggingLevel.DEBUG,'accAssetListMap::' + accAssetListMap.Values());
            modifyAsset('Straight Renewal', accCartMap, accAssetListMap);
        }
    }

    //validateAndCreateAssets()
    //Validate that account assets are valid, then proceed with creation process
    private static void validateAndCreateAssets(Map<Id, List<Product_Account_Detail__c>> accountToDigitalSubsMap){

        //Logic for adding account assets to the cart
        Set<Id> addedAssetSet = new Set<Id>();
        for (Apttus_Config2__AssetLineItem__c soldToAssets : Digital_CartCreationCommonVariables.configAssets) { 
            System.debug(LoggingLevel.DEBUG,'***soldToAssets' + soldToAssets);
            if(accountToDigitalSubsMap == null || accountToDigitalSubsMap.isEmpty() || !accountToDigitalSubsMap.containsKey(soldToAssets.APTS_SSD_Sold_To__c)){
                continue;
            }
            addedAssetSet = validateAndCreateAssetsHelper(accountToDigitalSubsMap,soldToAssets,addedAssetSet);
            
        } 
    }

    //validateAndCreateAssetsHelper() method
    //Extends validateAndCreateAssets() method, generates the Apttus request for line item creation
    private static Set<Id>  validateAndCreateAssetsHelper(Map<Id, List<Product_Account_Detail__c>> accountToDigitalSubsMap,Apttus_Config2__AssetLineItem__c soldToAssets,Set<Id> checkAssid){
        Set<Id> addedAssetSet = checkAssid;
        for (Product_Account_Detail__c currentsub : accountToDigitalSubsMap.get(soldToAssets.APTS_SSD_Sold_To__c)) {
            Boolean checkAsset = Digital_CartCreationHelper.checkAssetsAgainstDS(soldToAssets, currentsub);
            string digiFirm = currentsub.Digital_Firm__c;
            System.debug(LoggingLevel.DEBUG,'digiFirm ::' + digiFirm);
            
            if (!checkAsset) {
                continue;
            }

            // Create set of asset ids and Digital Firm to determine if Findlaw
            setAssetDigitalFirms.add(soldToAssets.Id + digiFirm);

            if (Digital_CartCreationHelper.isValidAsset(addedAssetSet,soldToAssets,digiFirm)){
                
                populateYOY2Helper(currentsub, soldToAssets, 'Straight Renewal');
                addedAssetSet.add(soldToAssets.Id);

                //Break out of inner FOR loop to prevent any further processing now that a matching pair is found and added.
                break;
            }
        }

        return addedAssetSet;
    }
    
    
    //lineItemCreationBestValue() method
    //Creates the line items for Best Value proposals
    private static void lineItemCreationBestValue(List<Product_Account_Detail__c> padBest,Map<id,id> accCartMap){

        Map<String, List<Product_Account_Detail__c>> acctDSmapBest = new Map<String, List<Product_Account_Detail__c>>();
        List<Product_Account_Detail__c> productDetailListBest = new List<Product_Account_Detail__c>();
        Map<String, Product_Account_Detail__c> bestValueProductToDSMap = new Map<String, Product_Account_Detail__c>();
        Map<Id, Set<String>> accCancelProductsMapBest = new Map<Id, Set<String>>();
        Map<Id, Apttus_Config2__PriceListItem__c> priceListMap = new Map<Id, Apttus_Config2__PriceListItem__c>();

        populateNewMidContractAddonMap(padBest);
        
        for (Product_Account_Detail__c acctToPrds : padBest) {
            if (acctToPrds.Actual_New_Subscription_Product__c != null) {
                productDetailListBest.add(acctToPrds);
                acctDSmapBest.put(AcctToPrds.AccountSSD__c, productDetailListBest);
                bestValueProductToDSMap.put(acctToPrds.Actual_New_Subscription_Product__c, acctToPrds);
            }

            if(acctToPrds.Contract_Type__c == 'New Mid Contract' && acctToPrds.Add_on_Type__c == 'Plus' 
                    && acctToPrds.Default_Add_On__c == true && Digital_CartCreationCommonVariables.mapOfProductIds != null) {
                bestValueProductToDSMap.put(Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c),acctToPrds);
            }
        }

        getBundleDigitalSubscription(productDetailListBest,acctDSmapBest);
        
        priceListMap = Digital_CartCreationHelper.getPriceListMap(bestValueProductToDSMap);
        
        populateYOY1(padBest, bestValueProductToDSMap, priceListMap);
        accCancelProductsMapBest = accCancelProductsMap;
    
        createCancelledLineItems(acctDSmapBest,accCancelProductsMapBest,'Best Value');

        System.debug(LoggingLevel.DEBUG,'accCancelProductsMapBest::' + accCancelProductsMapBest + accPrdListMap + accCartMap );  
        callModifyAssets(accCancelProductsMapBest,accCartMap,'Best Value');
    }
    private static void getBundleDigitalSubscription(List<Product_Account_Detail__c> productDetailListBest,Map<String, List<Product_Account_Detail__c>> acctDSmapBest){
        //DLT-19093 Removed seperate cancellation for bundles and merging here.
        for (product_Account_Detail__c pad : Digital_CartCreationCommonVariables.dSubList) {
            if ( pad.Actual_New_Service__c != null && pad.Actual_New_Subscription__c != null && pad.Bundle_Id__c != null && pad.Bundle_Id__c != '') {
                productDetailListBest.add(pad);
                acctDSmapBest.put(pad.AccountSSD__c, productDetailListBest);
            } 
        }   
    }
 
    //lineItemCreationPremium() method
    //Creates the line items for Premium proposals
    private static void lineItemCreationPremium(List<Product_Account_Detail__c> padPremium,Map<id,id> accCartMap){

        Map<String, List<Product_Account_Detail__c>> acctDSmapPremium = new Map<String, List<Product_Account_Detail__c>>();
        List<Product_Account_Detail__c> productDetailListPremium = new List<Product_Account_Detail__c>();
        Map<String, Product_Account_Detail__c> premValueProductTODSMap = new Map<String, Product_Account_Detail__c>();
        Map<Id, Set<String>> accCancelProductsMapPremium = new Map<Id, Set<String>>();
        Map<Id, Apttus_Config2__PriceListItem__c> priceListMap = new Map<Id, Apttus_Config2__PriceListItem__c>();

        for (Product_Account_Detail__c acctToPrds : padPremium) {
            if (acctToPrds.Actual_New_Subscription_Product__c != null) {
                productDetailListPremium.add(AcctToPrds);
                acctDSmapPremium.put(AcctToPrds.AccountSSD__c, productDetailListPremium);
                premValueProductTODSMap.put(acctToPrds.Actual_New_Subscription_Product__c,acctToPrds);
            }    
        }
        
            //DLT-19093 Removed seperate cancellation for bundles and merging here.
        for (product_Account_Detail__c pad : Digital_CartCreationCommonVariables.dSubList) {                
            if ( pad.Premium_New_Service__c != null && pad.Premium_New_Subscription__c != null && pad.Bundle_Id__c != null && pad.Bundle_Id__c != '') {
                productDetailListPremium.add(pad);
                acctDSmapPremium.put(pad.AccountSSD__c, productDetailListPremium);
            } 
        } 

        priceListMap = Digital_CartCreationHelper.getPriceListMap(premValueProductTODSMap);
        
        populateYOY1(padPremium, premValueProductTODSMap, priceListMap);
        accCancelProductsMapPremium = accCancelProductsMap;


        createCancelledLineItems(acctDSmapPremium,accCancelProductsMapPremium,'Premium');
    
        System.debug(LoggingLevel.DEBUG,'accCancelProductsMapPremium::' + accCancelProductsMapPremium + accPrdListMap + accCartMap );  
        callModifyAssets(accCancelProductsMapPremium,accCartMap,'Premium');
    }

    //createCancelledLineItems() method
    //Creates the cancelled line items based on the valid assets on the account.
    private static void createCancelledLineItems(Map<String, List<Product_Account_Detail__c>> acctDSmap,Map<Id, Set<String>> accCancelProductsMap, String quoteType){

        for (Apttus_Config2__AssetLineItem__c soldToAssets : Digital_CartCreationCommonVariables.configAssets) {//DLT-19093 including bunde prod cancellation also here
            if (isBundleAsset(acctDSmap,soldToAssets)
                || (accCancelProductsMap != null && !accCancelProductsMap.isEmpty() 
                    && accCancelProductsMap.get(soldToAssets.APTS_SSD_Sold_To__c) != null 
                    && String.isNotBlank(soldToAssets.Apttus_Config2__ProductId__r.Subscription_Number__c)
                    && accCancelProductsMap.get(soldToAssets.APTS_SSD_Sold_To__c).contains(soldToAssets.Apttus_Config2__ProductId__r.Subscription_Number__c))) {
                System.debug(LoggingLevel.DEBUG,'Cancel');
                System.debug(LoggingLevel.DEBUG,'soldToAssets' + soldToAssets );
                populateYOY2(acctDSmap, soldToAssets,quoteType);
            }
        }
    }
    private static boolean isBundleAsset(Map<String, List<Product_Account_Detail__c>> acctDSmap,Apttus_Config2__AssetLineItem__c soldToAssets ){
        if((acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c.contains('Corporate') 
            && soldToAssets.Apttus_Config2__HasOptions__c == true 
            && String.isBlank(soldToAssets.Apttus_Config2__ProductId__r.Subscription_Number__c) 
            && soldToAssets.APTS_Info_RenewalDate__c != null)){
            return true;
            }
        else{
            return false;
        }
    }


    //callModifyAssets() method
    //If there are new products to be added and existing assets to be cancelled, allow Plus/Premium to create the line items.
    private static void callModifyAssets(Map<Id, Set<String>> accCancelProductsMap,Map<id,id> accCartMap, String quoteType){
        if (accPrdListMap.keyset().size() >= 0 && accCartMap.keyset().size() > 0 && accAssetListMap != null 
            && ((accCancelProductsMap.keyset().size() >= 0))) {//DLT-19093

            System.debug(LoggingLevel.DEBUG,'accAssetListMap::' + accAssetListMap.Values().size());//Remove
            modifyAsset(quoteType, accCartMap,accAssetListMap);
        } 
    }
    
    //populateconfigAssets() method
    //Populates the 'Digital_CartCreationCommonVariables.configAssets' with valid account assets
    private static void populateconfigAssets(Map<Id, Id> accCartMap){

        if (Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) { 
            System.debug(LoggingLevel.DEBUG,'brkpoint1 remove');
            // DLT -12833 :Removed MLValues FROM the below WHERE Clause.
            List<Apttus_Config2__AssetLineItem__c> configassets2 = [
                SELECT Id, APTS_SSD_Sold_To__c, Apttus_Config2__OptionId__c, 
                    Apttus_Config2__OptionId__r.Subscription_Number__c, 
                    Apttus_Config2__ProductId__r.Apttus_Config2__HasOptions__c, 
                    Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c, Apttus_Config2__HasOptions__c,Apttus_Config2__AssetLineItem__c.Apttus_Config2__AllowedActions__c,
                    APTS_SSD_ship_to__r.APTS_Customer_Category__c, Apttus_Config2__ProductId__r.ProductCode, 
                    Apttus_Config2__ProductId__r.Subscription_Number__c, 
                    APTS_SSD_ship_to__r.Source_System_Account_Number__c, Apttus_Config2__NetPrice__c, 
                    Apttus_Config2__StartDate__c, Apttus_Config2__Quantity__c, APTS_Info_RenewalDate__c, 
                    Apttus_Config2__EndDate__c, Apttus_Config2__AccountId__c, Apttus_Config2__ProductId__c, 
                    Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__c, Apttus_Config2__RenewalDate__c, 
                    Apttus_Config2__RenewalTerm__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, 
                    APTS_Contract_Number__c 
                FROM Apttus_Config2__AssetLineItem__c 
                WHERE APTS_SSD_Sold_To__c IN :accCartMap.keyset() AND APTS_Info_RenewalDate__c != null 
                AND Apttus_Config2__AssetStatus__c ='Activated'
            ];

            for (Apttus_Config2__AssetLineItem__c sasset : configassets2) {
                if (sasset.APTS_Info_RenewalDate__c >= System.Today() 
                        && sasset.APTS_Info_RenewalDate__c <= (renewalDateMaps.get(sasset.APTS_SSD_Sold_To__c) + Integer.valueof(System.label.Digital_Asset_Renewal_Date.trim()) )) {
                    Digital_CartCreationCommonVariables.configAssets.add(sasset);
                } else {
                    Digital_Exception_Log__c ex = new Digital_Exception_Log__c(
                        Exception_Message__c = 'Renewal date on Asset is either < today or > 15 months FROM Opportunity renewal date',
                        Exception_Type__c = 'Renewaldate invalid on Asset', 
                        Additional_Information__c = 'Account reference::' + sasset.APTS_SSD_Sold_To__c, 
                        User_Message__c = 'Please make sure the asset renewal date is less than 450 days FROM Opportunity renewal date', 
                        Class_Reference__c = 'Digital_CartCreationCommoncode-->execute',
                        Object__c = 'Apttus_Config2__AssetLineItem__c',
                        Record_Id__c = sasset.Id);
                    exList.add(ex);
                }
            }
        }
    }

    //populateNewMidContractAddonMap() method
    //Populates 'Digital_CartCreationCommonVariables.mapOfProductIds'
    private static void populateNewMidContractAddonMap(List<Product_Account_Detail__c> padBest){
        
        Set<String> setOfAddOnSvc  = new Set<String>();
        Set<String> setOfSubNo  = new Set<String>();
        for (Product_Account_Detail__c acctToPrds : padBest) {
            if (acctToPrds.Add_On_Svc__c != null && acctToPrds.Add_On_Sub__c != null) {
                setOfAddOnSvc.add(acctToPrds.Add_On_Svc__c);
                setOfSubNo.add(acctToPrds.Add_On_Sub__c);
            }
        } 
        
        List<Product2> listOfPdc2= new List<Product2>();
        if (Schema.sObjectType.Product2.isAccessible()) { 
            listOfPdc2 = [
                SELECT Id, ProductCode FROM Product2 
                WHERE ProductCode IN :setOfAddOnSvc AND Subscription_Number__c IN :setOfSubNo
            ];
        }

        for (Product2 p: listOfPdc2) {
            Digital_CartCreationCommonVariables.mapOfProductIds.put(p.ProductCode, p.Id);
        }
    }

    //createLineItemFromProductAccountDetail() method
    //Create Apttus line item request from product account detail
    private static void createLineItemFromProductAccountDetail(Product_Account_Detail__c acctToPrds, Map<String, Product_Account_Detail__c> bestValueProductToDSMap, Map<Id, Apttus_Config2__PriceListItem__c> priceListMap2){

        Apttus_CPQApi.CPQ.SelectedProductDO selecPrdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
        if ((acctToPrds!= null && acctToPrds.Actual_New_Subscription_Product__c != null) 
                || (acctToPrds.Contract_Type__c == 'New Mid Contract' && acctToPrds.Add_On_Type__c == 'Plus' 
                && acctToPrds.Default_Add_On__c == true )) {
            selecPrdDO.ProductID = acctToPrds.Actual_New_Subscription_Product__c;

            setDefaultAddonProduct(acctToPrds,selecPrdDO);

            selecPrdDO.Quantity = acctToPrds.Quantity__c;
            
            List<String> customFields = new List<String>();
            customFields = Digital_CartCreationHelper.addCustomFieldsYOY1();
            selecPrdDO.CustomFields = customFields;

            Apttus_Config2__LineItem__c liSO1 = new Apttus_Config2__LineItem__c();
            liSO1 = populateConfigLineItemYOY1(acctToPrds,bestValueProductToDSMap,priceListMap2);
            selecPrdDO.CustomData = liSO1;  //Added
            
            populateAccountProductListMap(acctToPrds,selecPrdDO);
        }
            
    }

    private static void setDefaultAddonProduct(Product_Account_Detail__c acctToPrds,Apttus_CPQApi.CPQ.SelectedProductDO selecPrdDO ){
        if (acctToPrds.Contract_Type__c == 'New Mid Contract' && acctToPrds.Add_On_Type__c == 'Plus' 
                && acctToPrds.Default_Add_On__c == true && !Digital_CartCreationCommonVariables.mapOfProductIds.isEmpty()) {
            selecPrdDO.ProductID = Digital_CartCreationCommonVariables.mapOfProductIds.get(acctToPrds.Add_On_Svc__c);
        }
    }

    private static void populateAccountProductListMap(Product_Account_Detail__c acctToPrds,Apttus_CPQApi.CPQ.SelectedProductDO selecPrdDO){
            if (accPrdListMap != null && !accPrdListMap.isEmpty() 
                    && accPrdListMap.containskey(acctToPrds.AccountSSD__c)) {
            List<Apttus_CPQApi.CPQ.SelectedProductDO> selecPrdDOList = accPrdListMap.get(acctToPrds.AccountSSD__c);
            selecPrdDOList.add(selecPrdDO);
                accPrdListMap.put(acctToPrds.AccountSSD__c, selecPrdDOList);
            } else {
                accPrdListMap.put(
                    acctToPrds.AccountSSD__c,
                    new List<Apttus_CPQApi.CPQ.SelectedProductDO>{selecPrdDO}
                );
            }
        }
            
    //addCurrentSubToCancelMap() method
    //Adds current subscriptions to list of subscriptions to cancell
    private static void addCurrentSubToCancelMap(Product_Account_Detail__c acctToPrds){

        if (accCancelProductsMap != null && !accCancelProductsMap.isEmpty() 
                && accCancelProductsMap.containsKey(acctToPrds.AccountSSD__c) 
                && acctToPrds.Current_Subscription__c != null) {
            Set<String> cancelAssetIds = accCancelProductsMap.get(acctToPrds.AccountSSD__c);
            cancelAssetIds.add(acctToPrds.Current_Subscription__c);
        } else {
            if (acctToPrds.Current_Subscription__c != null) {
                accCancelProductsMap.put(acctToPrds.AccountSSD__c, new Set<String> {acctToPrds.Current_Subscription__c});    
            }
        }
    }

    // populateYOY1
    private static Map<Id, Set<String>> populateYOY1(List<Product_Account_Detail__c> pdcacctoprds, Map<String, Product_Account_Detail__c> bestValueProductToDSMap, Map<Id, Apttus_Config2__PriceListItem__c> priceListMap2) {
        //assign line items to cart
        accCancelProductsMap = new Map<Id,Set<String>>();
        accPrdListMap = new Map<Id, List<Apttus_CPQApi.CPQ.SelectedProductDO>>();

        for (Product_Account_Detail__c acctToPrds : pdcacctoprds) {
            
            createLineItemFromProductAccountDetail(acctToPrds,bestValueProductToDSMap,priceListMap2);
            addCurrentSubToCancelMap(acctToPrds);
        }   //End of For loop
        return accCancelProductsMap;
    }

    // populateYOY2
    private static Map<Id,List<Apttus_CPQApi.CPQ.AssetActionDO>> populateYOY2(Map<String, List<Product_Account_Detail__c>> acctDSmap, Apttus_Config2__AssetLineItem__c soldToAssets, String quoteName) {
        System.debug(LoggingLevel.DEBUG,'soldToAssets--->>' + soldToAssets);
        Apttus_CPQApi.CPQ.AssetActionDO assetActDO = new Apttus_CPQApi.CPQ.AssetActionDO();
        
        setAssetActionAndDate(quoteName,assetActDO,soldToAssets);

        assetActDO.Pending = true;    
        assetActDO.AssetLineItemId = soldToAssets.Id;
        assetActDO.Quantity = soldToAssets.Apttus_Config2__Quantity__c;
        
        List<String> customFields = new List<String>();
        customFields.add('Apttus_Config2__Comments__c');
        customFields.add('Apttus_Config2__PricingStatus__c');
        customFields.add('APTS_Yr_1_Renewal_Adjustment__c');
        customFields.add('APTS_Years_2_Plus_Adjustment__c');
        customFields.add('Apttus_Config2__SellingTerm__c');
        customFields.add('APTS_Contract_Term__c');
        customFields.add('Apttus_Config2__AdjustedPrice__c');
        customFields.add('Apttus_Config2__BaseExtendedPrice__c');
        customFields.add('Apttus_Config2__ExtendedPrice__c');
        customFields.add('APTS_Yearly_Total__c');
        customFields.add('Apttus_Config2__AdjustmentType__c');      // DLT-15692
        customFields.add('Apttus_Config2__AdjustmentAmount__c');    // DLT-15692

        Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
        liSO = populateConfigLineItemYOY2(acctDSmap,soldToAssets,quoteName);    // DLT-17793- Removed the block AND moved to this method
        
        //DLT-18554 Updated for Government added Markup/Discoun
        System.debug(LoggingLevel.DEBUG,'acctDSmap::' + acctDSmap);
        if ( acctDSmap != null && !acctDSmap.isEmpty() && acctDSmap.containsKey(soldToAssets.APTS_SSD_Sold_To__c)//DLT-19093
                && !acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c).isEMpty() && acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0] != null 
                && (acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c=='FindLaw' || acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Digital_Firm__c=='Government')) {   // DLT-16401 changed for multi-year pricing AND used Custom Metadata Type DC Contract Term V2 Setting
            //DLT-17401 Add 'isAssetPricing' to FindLaw
            customFields.add('Apttus_Config2__IsAssetPricing__c');
            liso.Apttus_Config2__IsAssetPricing__c = true;

            liso = Digital_CartCreationHelper.updateStraightRenewalAdjustments(liso,soldToAssets,acctDSmap);
            //If customer is to undergo 1 Year Experience, line item is updated to 1 Year values
            liso = Digital_CartCreationHelper.updateLineItemToOneYearExperience(liso, acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].One_Year_Experience_Flag__c,acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Offer_Price__c);
         
        }

        assetActDO.CustomFields = customFields;
        assetActDO.CustomData = liSO;
        
        populateAccountAssetMap(soldToAssets,assetActDO);

        System.debug(LoggingLevel.DEBUG,'accAssetListMap-->' + accAssetListMap);
        return accAssetListMap;
    }

    private static void populateAccountAssetMap(Apttus_Config2__AssetLineItem__c soldToAssets,Apttus_CPQApi.CPQ.AssetActionDO assetActDO ){
        if (accAssetListMap != null && !accAssetListMap.isEmpty() 
                && accAssetListMap.containskey(soldToAssets.APTS_SSD_Sold_To__c)) {
            List<Apttus_CPQApi.CPQ.AssetActionDO> assetActDOList = accAssetListMap.get(soldToAssets.APTS_SSD_Sold_To__c);
            assetActDOList.add(assetActDO);
            accAssetListMap.put(soldToAssets.APTS_SSD_Sold_To__c, assetActDOList);
        } else {
            accAssetListMap.put(soldToAssets.APTS_SSD_Sold_To__c, new List<Apttus_CPQApi.CPQ.AssetActionDO> {assetActDO});
        }
    }
    private static void setAssetActionAndDate(String quoteName,Apttus_CPQApi.CPQ.AssetActionDO assetActDO,Apttus_Config2__AssetLineItem__c soldToAssets){
        if (quoteName == 'Straight Renewal') {
            assetActDO.AssetAction = 'Renew';
            //}
            assetActDO.EndDate = soldToAssets.APTS_Info_RenewalDate__c.addMonths(1) - 1;
            //assetActDO.StartDate = soldToAssets.APTS_Info_RenewalDate__c;
        }

        if (quoteName == 'Best Value' || quoteName == 'Premium') {
            assetActDO.AssetAction = 'Cancel';
            assetActDO.EndDate = Date.today().addMonths(0);
        }
    }

    // insertExceptionLogs
    private static void insertExceptionLogs(List<Digital_Exception_Log__c> exList) {
        if (exList != null && exList.size() > 0 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()) {
            try {
                insert exList;
                exList.clear();
            } catch(Exception e) {
                System.debug(LoggingLevel.DEBUG,'Exception Opportunities' + e);
            }
        }
    } 
    // populateConfigLineItemYOY2
    private static Apttus_Config2__LineItem__c populateConfigLineItemYOY2(Map<String, List<Product_Account_Detail__c>> acctDSmap, Apttus_Config2__AssetLineItem__c soldToAssets, String quoteName) {
        Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
        liSO.Apttus_Config2__Comments__c = 'Comments Added my Modify Asset API Code';

        if (quoteName == 'Straight Renewal') {
            liSO = Digital_CartCreationHelper.setLineItemContractTermYOY2(liSO,acctDSmap,soldToAssets);
        }
         
        System.debug(LoggingLevel.DEBUG,'inside populate yoy2::');
        if (Digital_CartCreationHelper.isPopulatedYearThreeYOYDigitalSubcription(acctDSmap,soldToAssets)) {
                
            //DLT-14032 always 3 Years in automation AND if DS YOY has AND these values need to apply related to 3 Year. 
            if (quoteName == 'Straight Renewal') {
                liso.APTS_Yr_1_Renewal_Adjustment__c = (acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Year3_YoYvalue__c!= null)? String.Valueof(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Year3_YoYvalue__c.intValue()) : '0';
            }
            
            liso.APTS_Years_2_Plus_Adjustment__c = (acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Year3_YoYvalue__c!= null)? String.Valueof(acctDSmap.get(soldToAssets.APTS_SSD_Sold_To__c)[0].Year3_YoYvalue__c.intValue()) : '0';
            System.debug(LoggingLevel.DEBUG,'inside populate yoy2 inside end of If::');
            //DLT-14032 YOY1 is only for  Straight AND YOY2 for all ** ENd
        } else if (Digital_CartCreationHelper.isAccountDigitalFirmToContractTermExist(soldToAssets,contractTermsMap)) {
            
            liso = getYearOnYearYOY2(liso, soldToAssets,contractTermsMap);

        } else if (Digital_CartCreationHelper.isDigitalFirmToDefaultContractTermExist(soldToAssets)) {
            
            liso = getYearOnYearYOY2(liso,soldToAssets,Digital_CartCreationCommonVariables.defaultByAccFirmMap);

        }
        liso.Apttus_Config2__SellingTerm__c= 1;
        
        return liso;
    }

    private static Apttus_Config2__LineItem__c getYearOnYearYOY2(Apttus_Config2__LineItem__c lineItem, Apttus_Config2__AssetLineItem__c soldToAssets,Map<String, Map<Integer, DC_Contract_Term_V2__mdt>> accountToContractTermsMap){
        Apttus_Config2__LineItem__c liSO = lineItem;
        if(accountToContractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).get(Integer.Valueof(soldToAssets.APTS_SSD_ship_to__r.APTS_Customer_Category__c)).YoY_1_Renewal__c != null) {
            liso.APTS_Yr_1_Renewal_Adjustment__c = String.Valueof(
                accountToContractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).get(Integer.Valueof(soldToAssets.APTS_SSD_ship_to__r.APTS_Customer_Category__c)).YoY_1_Renewal__c.intValue()
            );
        }
        
        if(accountToContractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).get(Integer.Valueof(soldToAssets.APTS_SSD_ship_to__r.APTS_Customer_Category__c)).DC_Years_2_Plus_Adjustment__c != null) {
            liso.APTS_Years_2_Plus_Adjustment__c = String.Valueof(
                accountToContractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).get(Integer.Valueof(soldToAssets.APTS_SSD_ship_to__r.APTS_Customer_Category__c)).DC_Years_2_Plus_Adjustment__c.intValue()
            );
        }

        return liSO;
    }
    private static Apttus_Config2__LineItem__c getYearOnYearYOY2(Apttus_Config2__LineItem__c lineItem, Apttus_Config2__AssetLineItem__c soldToAssets,Map<String, DC_Contract_Term_V2__mdt> digitalFirmToContractTermsMap){
        Apttus_Config2__LineItem__c liSO = lineItem; 
        if (digitalFirmToContractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).YoY_1_Renewal__c != null) {
            liso.APTS_Yr_1_Renewal_Adjustment__c = String.Valueof(digitalFirmToContractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).YoY_1_Renewal__c.intValue());
        }
        
        if (digitalFirmToContractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).DC_Years_2_Plus_Adjustment__c != null) {
            liso.APTS_Years_2_Plus_Adjustment__c = String.Valueof(digitalFirmToContractTermsMap.get(Digital_CartCreationCommonVariables.dgfirmap.get(soldToAssets.APTS_SSD_Ship_to__r.Source_System_Account_Number__c)).DC_Years_2_Plus_Adjustment__c.intValue());
        }

        return liSO;
    }
    
    //DLT-18013 Takes in a single digital subscription then calls populateYOY2 after modifying the data structure.
    private static Map<Id,List<Apttus_CPQApi.CPQ.AssetActionDO>> populateYOY2Helper(Product_Account_Detail__c currentSub, Apttus_Config2__AssetLineItem__c soldToAssets, String quoteName) {
        Map<String, List<Product_Account_Detail__c>> accDSMap = new Map<String, List<Product_Account_Detail__c>>();
        List<Product_Account_Detail__c> dsList = new List<Product_Account_Detail__c>();
        dsList.add(currentSub);
        accDSMap.put(soldToAssets.APTS_SSD_Sold_To__c, dsList);
        return populateYOY2(accDSMap, soldToAssets, quoteName);
    }
    
    // populateConfigLineItemYOY1
    /**
     * @description Creates the line item customData for Apttus request. Also called from Digital_BundleProductCreation
     * @param acctToPrds Digital Subscription record that represent the line item to be created
     * @param bestValueProductToDSMap Map of the product to the digital subscription
     * @param priceListMap2 Map of the product to its price list item
     * @return Returns a line item with appropriate product data
     */
    public static Apttus_Config2__LineItem__c populateConfigLineItemYOY1(Product_Account_Detail__c acctToPrds, Map<String,Product_Account_Detail__c> bestValueProductToDSMap, Map<Id,Apttus_Config2__PriceListItem__c> priceListMap2) {
        Apttus_Config2__LineItem__c liSO1 = new Apttus_Config2__LineItem__c();
                
        // as part of DLT-16234 
        // Start DLT-8692 Use Custmer Segment Add dymanic YOY by DC_Contract_Term_V2__mdt
        liSO1 = Digital_CartCreationHelper.setLineItemContractTermYOY1(liSO1,acctToPrds,Digital_CartCreationCommonVariables.defaultByAccFirmMap);
        liSO1 = Digital_CartCreationHelper.setYearOnYearValuesYOY1(liSO1,acctToPrds,Digital_CartCreationCommonVariables.defaultByAccFirmMap);
        // End DLT-8692
        
        liSO1.Apttus_Config2__SellingTerm__c = 1;
        liSO1.Apttus_Config2__Comments__c = 'Best Value';
        liSO1.Apttus_Config2__BillingFrequency__c = 'Monthly';

        liSO1 = Digital_CartCreationHelper.setPricingDetailsYOY1(liSO1,acctToPrds,priceListMap2);
        
        if (acctToPrds.Actual_New_Subscription_Product__c != null) { // DLT-16116 Added for New Mid Contract by SK
            if (bestValueProductToDSMap != null && !bestValueProductToDSMap.isEmpty() 
                    && bestValueProductToDSMap.get(acctToPrds.Actual_New_Subscription_Product__c) != null 
                    && bestValueProductToDSMap.get(acctToPrds.Actual_New_Subscription_Product__c).Offer_Price__c != null) { 
                Digital_CartCreationHelper.setYOY1Adjustments(liSO1,bestValueProductToDSMap,acctToPrds);
            }
        }

        liSO1.DC_Is_Add_On__c = false;
        if (acctToPrds.Contract_Type__c == 'New Mid Contract' && acctToPrds.Add_On_Type__c == 'Plus' 
                && acctToPrds.Add_On_Sub__c != null && acctToPrds.Default_Add_On__c == true 
                && Digital_CartCreationCommonVariables.discountAdjAmountMap != null && !Digital_CartCreationCommonVariables.discountAdjAmountMap.isEmpty()) {   //DLT-16116  Moved offer check below sometime Dissount not there for New Mid Contract by SK
            liSO1.Apttus_Config2__AdjustmentType__c = '% Discount';
            liSO1.Apttus_Config2__AdjustmentAmount__c =Digital_CartCreationCommonVariables.discountAdjAmountMap.get(acctToPrds.ZP_Cust_Number__c);
            liSO1.DC_Is_Add_On__c = true; //DLT-16116 Added for New Mid Contract by SK
        }

        return liSO1;
    }
}