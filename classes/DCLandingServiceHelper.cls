/*
 * This class contains methods that are used only in BOTH DCGetQuoteDetails and DCQuoteService
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 *  Date            Name                    Description
 *  2020-09-23      Benjamin Her            DLT-20827 Creation of class. PMD fix of DCGetQuote/DCQuoteService
 *  2021-04-01      Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                      Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 *  2021-07-29      Brenda Shields          DLT-21983 - [SFDC][SLF][REN] Update How Product Displays on FindLaw Rep Driven Renewal Landing Page
 * ==================================================================================================================================
 */
/**
    @description class contains methods that are used only in BOTH DCGetQuoteDetails and DCQuoteService
 */
public without sharing class DCLandingServiceHelper {

    private static final String DIGITAL_QUOTE_TYPE_PLUS = 'Best Value';
    private static final String DIGITAL_QUOTE_TYPE_MANUAL = 'Manual';
    private static final String DIGITAL_QUOTE_TYPE_STRAIGHT = 'Straight Renewal'; //DLT-16970
    private static final String APPROVAL_STAGE_EXPIRED = 'Expired';
    private static final String CART_STATUS_FINALIZED = 'Finalized';
    private static final String CART_OPTION_PRODUCT = 'Option';
    private static final String CART_BUSINESS_UNIT = 'FindLaw';

    /**
        @description queryCartDetails() method
        @param opportunityId
        @param accountId
        @param quoteId
        @return List < Apttus_Config2__ProductConfiguration__c >
     */
    public static List < Apttus_Config2__ProductConfiguration__c > queryCartDetails(Id opportunityId, Id accountId, Id quoteId) {

        String strOpportunityId;
        String strAccountId;
        String strQuoteId;
        String strLineItemQuery = '';
        String strWhereClause = '';
        String cartQuery = '';
        List < String > lineItemStatus = new List < String > {
            'New',
            'Existing',
            'Renewed',
            'Amended'
        };
        system.debug(logginglevel.INFO, 'Line Item Status Codes: ' + lineItemStatus);
        List < Apttus_Config2__ProductConfiguration__c > carts = new List < Apttus_Config2__ProductConfiguration__c > ();

        //Build cart query
        //Queries various fields on the cart, proposal, and opportunity
        /*
         * Because Static Code Analysis throws a SOQL injection error for this particular line of code 
         * truncating fields over multiple lines and
         * deployment of code to higher environments will not happen if SOQL injection errors are found 
         * during static code analysis, this code is intentionally a one-liner.
         */ 
        // DLT-21586 - add APTS_Proposal_Business_Unit__c to query
        cartQuery = 'SELECT id,Rollup_Net_Price__c,Apttus_Config2__CouponCodes__c,Apttus_QPConfig__Proposald__r.APTS_Ebilling_exempt__c,Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c, Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c, APTS_Approval_Segment__c, APTS_Proposal_Business_Unit__c, Apttus_QPConfig__Proposald__r.APTS_Approval_Segment_Default__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c,Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c,APTS_SSD_bill_to__r.Digital_Firm__c, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.DC_Contract_Not_In_Sync__c,name,APTS_New_Holdings__c,APTS_Current_Holdings__c,APTS_SSD_bill_to__r.LCRM_APTS_Band_Number__c,Apttus_Config2__AccountId__r.Field_Sales_Territory__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Primary__c,Apttus_QPConfig__Proposald__r.APTS_Incremental__c,Apttus_QPConfig__Proposald__r.APTS_Renewal__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c,Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c,Apttus_QPConfig__Proposald__r.APTS_Payment_Option__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,Apttus_QPConfig__Proposald__r.Contract_Type__c, Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,Apttus_QPConfig__Proposald__r.LastModifiedDate,Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c,Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Name__c,Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c,Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c, Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.FirstName,Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.LastName, Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.Phone,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Amount,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_Offer__c,Apttus_Config2__AccountId__r.Number_of_Attorneys_Org__c,APTS_SSD_bill_to__r.Digital_Firm_Name__c,APTS_SSD_bill_to__r.Source_System_Account_Number__c, Apttus_Config2__BillToAccountId__c,APTS_SSD_bill_to__r.Digital_Billing_City__c,APTS_SSD_bill_to__r.State__c,APTS_SSD_bill_to__r.Country__c,APTS_SSD_bill_to__r.Postal_Code__c,Apttus_QPConfig__Proposald__r.Display_in_CXD_Renewals__c, Apttus_QPConfig__Proposald__r.Digitally_Signed_Date__c,APTS_SSD_bill_to__r.id,Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c,Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c,Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c,Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c,Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__c ';

        // DLT-21983 - Don't select option products for FindLaw
        //Build line item subquery
        strLineItemQuery = ',(SELECT  DC_Is_Add_On__c,Apttus_Config2__NetPrice__c,Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__ProductId__r.DC_Short_Description__c, ' +
            'Apttus_Config2__OptionId__r.name,APTS_SSD_ship_to__r.LCRM_APTS_Band_Number__c,Apttus_Config2__OptionId__r.Digital_Description__c,Apttus_Config2__LineType__c,Apttus_Config2__OptionId__c, ' +
            'Apttus_Config2__ProductId__r.DC_Long_Description__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Service_Number__c, ' +
            'Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.DC_Product_Title__c,Apttus_Config2__ProductId__r.Family,APTS_Number_of_Attorneys__c, ' +
            'Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,Apttus_Config2__ConfigurationId__r.APTS_Approval_Segment__c, ' +
            'Apttus_Config2__ConfigurationId__r.APTS_Proposal_Business_Unit__c, Apttus_Config2__ProductId__r.Digital_Description__c,Apttus_Config2__AutoRenewalTerm__c, ' +
            'Apttus_Config2__BillingFrequency__c, Apttus_Config2__Quantity__c, APTS_Original_Quantity__c,Apttus_Config2__LineStatus__c,APTS_Format__c,APTS_Contract_Term__c, ' +
            'Apttus_Config2__StartDate__c,Apttus_Config2__ProductId__r.Subscription_Number__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,' +
            'APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name, APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name,APTS_Contract_Number__c, ' +
            'id,name,Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__HasOptions__c, ' +
            'Apttus_Config2__OptionId__r.APTS_Module_Points__c,Apttus_Config2__BasePrice__c, ' +
            'Apttus_Config2__OptionId__r.Subscription_Number__c,Apttus_Config2__AssetLineItemId__r.APTS_Subscription_Number__c,Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c,Apttus_Config2__AssetLineItemId__r.APTS_SAP_MLA_Agreement_Number__c ' +
            'FROM Apttus_Config2__LineItems__r ' +
            'WHERE Apttus_Config2__LineStatus__c IN: lineItemStatus ' +
            'and (APTS_Proposal_Business_Unit__c != : CART_BUSINESS_UNIT or Apttus_Config2__LineType__c != : CART_OPTION_PRODUCT)' +
            'ORDER BY Apttus_Config2__Quantity__c Desc) ';

        //Build where clause
        //Updated as part of INC3635751
        if (String.isNotBlank(quoteId)) {
            strQuoteId = String.escapeSingleQuotes(String.valueOf(quoteId));
            strWhereClause = 'FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c =:strQuoteId ' +
                'AND Apttus_QPConfig__Proposald__r.is_Digital_Channel__c = TRUE ' +
                'AND Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c != NULL ' +
                'AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED ';
        } else {
            strOpportunityId = String.escapeSingleQuotes(String.valueOf(opportunityId));
            strAccountId = String.escapeSingleQuotes(String.valueOf(accountId));
            strWhereClause = 'FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c =: strOpportunityId ' +
                'AND  Apttus_QPConfig__Proposald__r.is_Digital_Channel__c = TRUE ' +
                'AND  Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c != NULL ' +
                'AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED ' +
                'AND  Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__c =:strAccountId ' +
                'AND (Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c !=: DIGITAL_QUOTE_TYPE_MANUAL ' +
                'OR (Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c =: DIGITAL_QUOTE_TYPE_MANUAL ' +
                'AND Apttus_QPConfig__Proposald__r.Display_in_CXD_Renewals__c = TRUE)) ' +
                'AND Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c !=:APPROVAL_STAGE_EXPIRED ';
        }

        //Build SOQL query
        cartQuery = cartQuery + strLineItemQuery + strWhereClause;
        System.debug(LoggingLevel.INFO,'cartQuery::::::' + cartQuery);

        if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible() && Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable() &&
            Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable() && Schema.sObjectType.Apttus_Config2__LineItem__c.Fields.Apttus_Config2__LineStatus__c.isAccessible() && Schema.sObjectType.Apttus_Config2__LineItem__c.Fields.Apttus_Config2__LineStatus__c.isUpdateable()) { //DLT-11734

            //Carts List assignment
            //DLT-20045 Query cart details based on whether a quoteId is provided else default query is used.
            carts = Database.query(cartQuery);
        }

        return carts;
    } //end of queryCartDetails() method

    /**
        @description manualOfferReplacement() method.Updated DLT-20233 - Replaces automated offers with up to 3 manual offers
        @param carts
        @return List < Apttus_Config2__ProductConfiguration__c >
     */
    public static List < Apttus_Config2__ProductConfiguration__c > manualOfferReplacement(List < Apttus_Config2__ProductConfiguration__c > carts) {
        //List < Apttus_Config2__ProductConfiguration__c > configlist = new List < Apttus_Config2__ProductConfiguration__c > ();
        List < Apttus_Config2__ProductConfiguration__c > manualProposalList = new List < Apttus_Config2__ProductConfiguration__c > ();
        Apttus_Config2__ProductConfiguration__c straightProposal;
        Apttus_Config2__ProductConfiguration__c bestProposal;

        //Data validation check. Return passed in cart.
        if (carts == null || carts.isEmpty()) {
            return carts;
        }

        //Iterates over passed in cart list and stores any 'Manual' proposals
        //Stores Straight and Best proposals for easier access
        for (Apttus_Config2__ProductConfiguration__c pconfig: carts) {
            if (pconfig.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_MANUAL) { //Change to constants.
                manualProposalList.add(pconfig);
            } else if (pconfig.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_STRAIGHT) { //Change to constants.
                straightProposal = pconfig;
            } else if (pconfig.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_PLUS) { //Change to constants.
                bestProposal = pconfig;
            }
        }



        //If zero manual offers exists, return original cart
        if (manualProposalList.isEmpty()) {
            return carts;
        } else {
            //Build/Return new list since manual proposals are present
            return manualOfferReplacementHelper(manualProposalList, straightProposal, bestProposal);

        }
    } //end of manualOfferReplacement() method

    //manualOfferReplacementHelper() method
    //Builds the final cart list with manual propsal and automated proposals
    private static List < Apttus_Config2__ProductConfiguration__c > manualOfferReplacementHelper(List < Apttus_Config2__ProductConfiguration__c > manualProposalList,
        Apttus_Config2__ProductConfiguration__c straightProposal, Apttus_Config2__ProductConfiguration__c bestProposal) {

        List < Apttus_Config2__ProductConfiguration__c > configlist = new List < Apttus_Config2__ProductConfiguration__c > ();
        if (manualProposalList != null) {
            configlist.addAll(manualProposalList);
        }
        //Landing page only supports up to 3 offers, so add Straight and Best Value only if the new list size < 3
        if (straightProposal != null && configlist.size() < 3) {
            configlist.add(0, straightProposal);
        }
        if (bestProposal != null && configlist.size() < 3) {
            configlist.add(1, bestProposal);
        }

        return configlist;
    }

     /**
        @description getMissingCurrentDigitalSubNumber() method.Returns a Set<String> of any subscription number that is found in Digital Subscription but not found in the cart.
        @param quote
        @return Set < String >
     */
    public static Set < String > getMissingCurrentDigitalSubNumber(Apttus_Config2__ProductConfiguration__c quote) {

        Set < String > subscriptionNumberDifferences = new Set < String > ();
        Set < String > lineItemSubNumberSet = new Set < String > ();

        //Stores line item subscription numbers into a Set
        for (Apttus_Config2__LineItem__c lineItem: quote.Apttus_Config2__LineItems__r) {
            lineItemSubNumberSet.add(lineItem.Apttus_Config2__AssetLineItemId__r.APTS_Subscription_Number__c);
        }

        for (Product_Account_Detail__c digitalSub: [SELECT Current_Subscription__c
                FROM Product_Account_Detail__c
                WHERE ZP_Cust_Number__c =: quote.APTS_SSD_bill_to__r.Source_System_Account_Number__c
                AND Current_Subscription__c != NULL
                AND Renewal_Date__c > TODAY
            ]) {

            //If DS subscription number is NOT contained in set, add to 'differences'
            if (!(lineItemSubNumberSet.contains(digitalSub.Current_Subscription__c))) {
                subscriptionNumberDifferences.add(digitalSub.Current_Subscription__c);
            }
        }

        return subscriptionNumberDifferences;
    } //end of getMissingCurrentDigitalSubNumber() method

    /**
        @description getDigitalSubscription() method.eturns a list of digital subscriptions
        @param customerNumber
        @param campaignCode
        @param renewalDate
        @return List < Product_Account_Detail__c >
     */
    public static List < Product_Account_Detail__c > getDigitalSubscription(String customerNumber, String campaignCode, Date renewalDate) {
        List < Product_Account_Detail__c > subscriptions = new List < Product_Account_Detail__c > ();

        if (customerNumber == null ||
            campaignCode == null ||
            renewalDate == null ||
            !Schema.sObjectType.Product_Account_Detail__c.isQueryable()) {
            System.debug(LoggingLevel.INFO,'getDigitalSubscription() method returned empty list due parameter or object access');
            return subscriptions;
        }
        subscriptions = [SELECT Id, name, Bundle_Id__c, Current_Term_Length__c, Year1_YoYvalue__c, Year2_YoYvalue__c, Year3_YoYvalue__c,
            Current_Subscription__c, Actual_New_Service__c, Actual_New_Subscription__c, Premium_New_Service__c,
            Premium_New_Subscription__c, Plus_Rec_Text_Code__c, Premium_Rec_Text_Code__c, Digital_Firm__c, ZP_Cust_Number__c,
            Add_On_Svc__c, One_Year_Experience_Flag__c
            FROM Product_Account_Detail__c
            WHERE ZP_Cust_Number__c =: customerNumber
            AND Renewal_Date__c =: renewalDate
            AND Campaign_Code__c =: campaignCode
        ];

        return subscriptions;
    }
}