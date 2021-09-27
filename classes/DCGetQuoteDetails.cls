/*
* CHANGE HISTORY
* ==================================================================================================================================
* Date         Name                  Description
* 2018-01-17   Ramesh Reddy          DLT-7044 - Performance Issues : Phase 2 - API Service has replaced the ESI service
* 2018-02-14   Ramesh Reddy          DLT-7719 - eBilling exempt flag to be provided
* 2018-02-15   Ramesh Reddy          DLT-7446 - Set Indigo flag in the Response when Subs contained within offer
* 2018-03-01   Bharat Bhushan        DLT-7943 - Update getQuote Service to include Current Contract Term Length
* 2018-03-29   srujana Gori          DLT-8688 - Update getQuote Service with digital firm field
* 2018-05-04   Bharat Bhushan        DLT-6726 - [SLF / CORP] Enhanced Help Text in benefits table
* 2018-05-09   Rajan Tatuskar        DLT-8973 - SAP Contact ID from Analytics for Quote Generation
* 2018-06-04   Rajan Tatuskar        DLT-9839 - Reassign users link on Confirmation page (up-sell only)
* 2018-06-14   Navleen Kaur          DLT-9760 - Update Opportunities for stage / record type changes and GLI Account / Contact / lookup field changes
* 2018-06-19   Benjamin Her          DLT-10225 - Updated code to resolve Code Scan issues.
* 2018-06-29   Divija S              DLT-9760 - Updated Code to handle old/deleted Account/Opportunity Id's
* 2018-07-11   Harika Sai P          DLT-10373 - [MID-CONTRACT - SLF/CORP] New Landing Page for mid-Contract up-sells
* 2018-07-13   Rajan Tatuskar        DLT-11055 - No tool tip is presented when trying reduce the number of users
* 2018-07-16   Navleen Kaur          DLT-11115 - Hardbounce functionality is not working as expected
* 2018-07-23   Navleen Kaur          DLT-9760  - Added Order_Confirmation_Contact_SSD__c at quote level.
* 2018-08-13   Harika Sai P          DLT-11661 - Combine the Landing Page service into a single service
* 2018-08-14   Benjamin Her          DLT-7380 - Eligible manual proposal to be sent to Renewal Page
* 2018-08-22   Harika Sai P          DLT-11734 - [Code Scan] Fix DCGetQuoteDetails
* 2018-09-14   Navleen Kaur          DLT-11781 - Westlaw Edge/Indigo banner for two offer renewals
* 2018-09-21   Srikanth Kota         DLT-12127/ DLT-12510- SFDC changes for Marketing banner
* 2018-10-04   Benjamin Her          DLT-12694 - Send DigitallySignedDate field to AEM
* 2018-11-16   Benjamin Her          DLT-13445 - Place Manual proposal last in order for AEM response
* 2018-12-06   Bishanka Dassarma     DLT-13754- Addition of Account ID in DCGetQuoteDetails
* 2018-12-11   Harika Sai P          DLT-13174 - [ALL] Inform Customer of Non-Compliant Credentialing Status - Removed******
* 2018-12-19   Navleen Kaur          DLT-14155 : [Tech Story] [Code Scan] - Fix Code Scan Security Issues
* 2018-12-26   Benjamin Her          DLT-14244 - Manual Proposal Bug Fix - Added 'Manual' to 'quoteTypeToType' map
* 2019-01-10   Navleen Kaur          DLT-14349  : Code Scan
* 2019-01-28   Navleen Kaur          DLT-14679  :Contact is not getting updated to new one when changed in not you pop-up.
* 2019-02-05   Navleen Kaur          DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
* 2019-02-19   Benjamin Her          DLT-15324 - Added Base Price to AEM response
* 2019-02-20   Harika Sai P          DLT-15252 - Send credential flag to AEM when any public records are added on
* 2019-03-04   Srikanth Kota         DLT-15474- [TECH STORY] [FindLaw] Verify and update Current Holding calculation         
* 2019-03-15   Benjamin Her          DLT-15612 - Manual Straight offer confirmation pricing fix when only a few products are selected.
* 2019-03-22   Bishanka Dassarma     DLT-15720 [Findlaw] Camel case for Product names in subscriptions.
* 2019-03-26   Navleen Kaur          DLT-15731 [Tech Story] First name not updating / displaying correctly.
* 2019-04-30   Navleen Kaur          DLT-16286 [SLF] - Automation Failure - Digital_ProposalAutomaion DML Exception Issue
* 2019-04-25   Harika Sai P          DLT-16262 - Public record product title should contain text or word 'Public Records'
* 2019-05-09   Benjamin Her          DLT-16096 - Null pointer exception fix in getContactInformation() method
* 2019-05-14   Bishanka Dassarma     DLT-16477 - SFDC Support to send Captured Promocodes to AEM
* 2019-05-22   Navleen Kaur          DLT-16511 - Old Opportunity/Account Check(As part of GLI migration)
* 2019-06-12   HarikaSai P           DLT-16791 - Code Scan Fixes
* 2019-07-11   Bishanka Dassarma     DLT-17073 - [Tech Story] - Handle Automation and Landing API if digital Subscriptions has multiple entries for same customer but different segments(SmallLaw/Gov/Corp/FindLaw)
* 2019-07-14   Srikanth Kota         DLT-16970 [SLF][SFDC] Send the Ineligible sub flag to AEM
* 2019-09-04   Srikanth kota         DLT-17452 - [CORP][SFDC] Straight renew Option products alongwith the core product
* 2019-09-09   Benjamin Her          DLT-17630 - Update Personalized offer to pull Digital Firm off Proposal
* 2019-09-19   Bishanka Dassarma     DLT-17670 - [CORP] Help button (?) is missing and Product name is in all CAPS for Products for Option Products scenario
* 2019-23-19   Benjamin Her          DLT-17663 - Manual Options Proudct offer - Null check added
* 2019-10-07   Srikanth Kota         DLT-17827 - Name formatting is not consistent in Place order docker and Not You modal
* 2019-10-21   Bishanka Dassarma     DLT-17802 - [SFDC] Add material number in the onlinecontacts for the per-seat products
* 2019-10-22   Benjamin Her          DLT-18017 - [FindLaw] Added PA/Geo assignment to line item JSON
* 2019-11-05   Sumanth Padarapaka    DLT-18303 - [FindLaw] Added contractNumber assignment to line item JSON
* 2019-11-13   Sumanth Padarapaka    DLT-18189 - [FindLaw] Added oneYearExperienceFlag to DS Object
* 2019-11-25   Harika Sai P          DLT-18485 - Corp Personalized with option products-Plan features and benefits are missing in landing page
* 2020-01-14   Benjamin Her          DLT-19233 - Add West Proflex subproducts to response
* 2020-01-13   Bishanka Dassarma     DLT-19548 - [SLF][CORP][GOV] Order confirmation page displaying incorrect firm size value
* 2020-05-05   Benjamin Her          DLT-19985 - Improve landing page performance
* 2020-05-18   Benjamin Her          DLT-20045 - Add 'quoteId' to API parameter to improve confirmation page performance
* 2020-06-17   Benjamin Her          DLT-20165 - Update query to pull 'Amended' line items
* 2020-06-25   Benjamin Her          DLT-20233 - Update api to display up to 3 manual proposals
* 2020-06-29   Benjamin Her          DLT-20239 - Added logic to identify NTO customer
* 2020-08-18   Benjamin Her          DLT-20651 - INC3635751 Superceded carts pulled in confirmation page
* 2020-08-24   Benjamin Her          DLT-20634 - Critical/Blocker PMD fix
* 2020-09-23   Benjamin Her          DLT-20827 - Fix PMD issues
* 2021-04-01   Brenda Shields        DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
*                                                Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
==================================================================================================================================  
*/
//@RestResource(urlMapping='/digitalconfigurator/DCGetQuoteDetails/*')
public without sharing class DCGetQuoteDetails {
    private static final String CART_STATUS_FINALIZED = 'Finalized';
    private static final String DIGITAL_QUOTE_TYPE_MANUAL = 'Manual';
    private static final String INELIGIBLE='Ineligible'; //DLT-16970

    private static Set<String> serviceNumbers = new Set<String>();//DLT-15252
    private static Set<id> publicProdIdsSET = new Set<id>();//DLT-15252
    private Set<Id> setQuoteIds = new Set<Id>();

    private static Map<String,String> quoteTypeToType = new Map<String,String>();
    private static Map<String,String> dgfirmMap = new Map<String,String>();
    private Map<String,Map<String,List<QuoteDetailsResponse.Material>>> productIdToMaterial = new Map<String,Map<String,List<QuoteDetailsResponse.Material>>>();
    private Map<string,product2> prodMap = new Map<string,product2>();

    private boolean oneYearExperience; //DLT-18189

    private Integer termCurrent;  
    private String qTypeBundlProdId;
    
    public static List<DC_Global_Settings__mdt> globalSettings;

    //Set values for 'quoteTypeToType'. Used in Addon functionality
    static {
        quoteTypeToType.put('Straight Renewal','Straight');
        quoteTypeToType.put('Premium','Premium');
        quoteTypeToType.put('Best Value','Plus');
        quoteTypeToType.put('Best Value+Config','Config');
        quoteTypeToType.put('Manual','Manual');
    }

    /**
    * The post method is to return the response
    * Inputs: Opportunity Id, Account Id, Quote Id
    */
    //DLT-20045 Added quoteId as a new parameter
    public  static DCQuoteDetails getAllQuotesByOppertunityIdAndAccountId(Id opportunityId,Id accountId, Id quoteId){
        DCGetQuoteDetails quoteData = new DCGetQuoteDetails();
        DCQuoteDetails response= new DCQuoteDetails();//DLT-11661  Starts
        QuoteDetailsResponse qdRespose= new QuoteDetailsResponse();
        try{          
            qdRespose.getQuoteResponseDetails = quoteData.getQuotesByOppertunityId(opportunityId,accountId,quoteId);
            response.getQuoteDetails = qdRespose;           
            response.ResponseCode= 200;
            response.ResponseMessage= 'Success';     
        }Catch(Exception ex){
            DCUtils.trackLog(ex,'DCGetQuoteDetails','getAllQuotesByOppertunityIdAndAccountId');
            response.ResponseCode= 400;
            response.ResponseMessage=  ex.getMessage();      
        }
        return response;//DLT-11661 Ends
    }

    /**
    * Get all Quotes with Line Items by OpprtunityId and Bill to Account
    */
    private List<QuoteDetailsResponse.GetQuoteResponseDetails> getQuotesByOppertunityId(Id opportunityId,Id accountId, Id quoteId){

        //Map Declarations--DLT-16791 moved declarations here
        Map<String,QuoteDetailsResponse.GetQuoteResponseDetails> quoteIdToResponse = new Map<String,QuoteDetailsResponse.GetQuoteResponseDetails>();
        Map<String,String> quoteTypeToQuoteId = new Map<String,String>();  
        Map<ID,LCRM_Contact_SSD__c> mapContactSSD = new Map<ID,LCRM_Contact_SSD__c>();
        List<Apttus_Config2__ProductConfiguration__c> carts;

        if (!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()
            && !Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()) {//DLT-11734
                throw new DCCustomException('Apttus_Config2__ProductConfiguration__c is not queryable.');
        }
        //Getting the Cart Information based on opportunity Id and AccountSSD Id
        carts = DCLandingServiceHelper.queryCartDetails(opportunityId,accountId,quoteId);

        //DLT-7380 - Eligible manual proposal to be sent to Renewal Page
        carts = DCLandingServiceHelper.manualOfferReplacement(carts); 

        if(carts.isEmpty()){
            throw new DCCustomException('No Apttus_Config2__ProductConfiguration__c meets search critera.');
        }
        
        //Gets field data from digital subscriptions
        getDigitalSubscriptionData( carts[0].Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c,
                                    carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c,
                                    carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c);

        //Gets a map of Contact System Detail information
        mapContactSSD = getContactSSDMap(carts, accountId);

        //Gets a product mapping to its relevant CPRO product
        prodMap = getCPROProductsForBundles();

        //Get products from Opportunity id and account id
        getDigitalProductsByOpportunityId(opportunityId, accountId);

        for( Apttus_Config2__ProductConfiguration__c quote : carts){
            QuoteDetailsResponse.GetQuoteResponseDetails details = new QuoteDetailsResponse.GetQuoteResponseDetails();
            QuoteDetailsResponse.QuoteHeader header = createQuoteResponseHeader(quote,mapContactSSD,dgfirmMap);
            details.quoteHeader = header;

            //Filling the maps quotetypetoQuoteID and quoteIdToResponse
            if(String.isNotBlank(quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c)){
                quoteTypeToQuoteId.put(quoteTypeToType.get(quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c),quote.Apttus_QPConfig__Proposald__c);
            }

            quoteIdToResponse.put(quote.Apttus_QPConfig__Proposald__c,details);
            hasAddons(quote.Apttus_QPConfig__Proposald__c, quoteTypeToQuoteId, quoteIdToResponse);
        }
        System.debug('ret'+JSON.serialize(quoteIdToResponse));

        //Constructing Response
        JSON.serialize(quoteIdToResponse);
        return quoteIdToResponse.values();
    }

    //getContactSSDMap() method
    //Returns a map of ID key to its sObject value
    private Map<ID,LCRM_Contact_SSD__c> getContactSSDMap(List<Apttus_Config2__ProductConfiguration__c> carts, String accountId){
        
        Set<ID> setContID = new Set<ID>();
        Map<ID,LCRM_Contact_SSD__c> mapContactSSD;
        String contId;

        //Looping through Carts
        for( Apttus_Config2__ProductConfiguration__c quote : carts){
            contId=quote.Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c;
            setQuoteIds.add(quote.Apttus_QPConfig__Proposald__c);
            setContID.add(contId);
        }//End  of For
        if (!Schema.sObjectType.LCRM_Contact_SSD__c.isQueryable()) {
            throw new DCCustomException('LCRM_Contact_SSD__c is not queryable.');
        }

        //Queries LCRM_Contact_SSD__c and store into Id/sObject map
        mapContactSSD = new Map<ID,LCRM_Contact_SSD__c>(
                            [SELECT ID,LCRM_Contact__c,LCRM_Account_SSD__c,Digital_FirstName__c,LCRM_Last_Name__c,
                                LCRM_Phone__c,LCRM_Hard_Bounce__c,LCRM_Email__c 
                            FROM LCRM_Contact_SSD__c 
                            WHERE Id IN :setContID 
                            AND LCRM_Account_SSD__c = : accountId]);

        return mapContactSSD;
    }//end of getContactSSDMap() method

    //getDigitalSubscriptionData() method
    //Populates various variables used in this class based on Digital Subscription values
    private void getDigitalSubscriptionData(String customerNumber,String campaignCode,Date renewalDate){

        //Getting the Digital Subscriptions for cart's Zp Customer Number ,Renewal date and Campaign code match
        List<Product_Account_Detail__c> subscriptions = DCLandingServiceHelper.getDigitalSubscription(customerNumber,campaignCode,renewalDate);

        system.debug('subscriptions e::'+subscriptions);

        if(!subscriptions.isEmpty()){
            termCurrent = Integer.valueOf(subscriptions[0].Current_Term_Length__c);
            oneYearExperience = subscriptions[0].One_Year_Experience_Flag__c;
            //DLT-15252 starts
            for(product_Account_Detail__c pad: subscriptions){
                dgfirmMap.put(pad.ZP_Cust_Number__c,pad.Digital_Firm__c);
                if(pad.Add_On_Svc__c != null && pad.Add_On_Svc__c != ''){
                    serviceNumbers.add(pad.Add_On_Svc__c);
                }
            }
            if(!Schema.sObjectType.Product2.isAccessible()){
                throw new DCCustomException(UserInfo.getName()+' does not have access to: Product2');
            }
            if(!serviceNumbers.isEmpty()){  
                for(product2 p: [SELECT Id,Name 
                                FROM Product2 
                                WHERE productCode IN :serviceNumbers 
                                AND Name LIKE '%Public Records%']){

                    publicProdIdsSET.add(p.Id);
                }
                system.debug('publicProdIdsSET::'+publicProdIdsSET);
            }
        }
    }//end of getDigitalSubscriptionData() method

    /*
    *  createQuoteResponseHeader()
    *  Returns a QuoteHeader from quote details
    */
    private QuoteDetailsResponse.QuoteHeader createQuoteResponseHeader(Apttus_Config2__ProductConfiguration__c quote, Map<ID,LCRM_Contact_SSD__c> mapContactSSD, Map<String,String> dsFirmMap){
        
        QuoteDetailsResponse.QuoteHeader header = new QuoteDetailsResponse.QuoteHeader();
        Map<String, List<QuoteDetailsResponse.OnlineContacts>> materialIdOnlineContactMap;

        //Set values for QuoteHeader information
        header.quoteId = quote.Apttus_QPConfig__Proposald__c;
        header.cartId = quote.Id;
        header.orderConfirmationContactSSD = quote.Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c;
        header.couponCode = quote.Apttus_Config2__CouponCodes__c;
        header.hasAddOns = false;
        header.exempt = quote.Apttus_QPConfig__Proposald__r.APTS_Ebilling_exempt__c;
        header.contract_Not_In_Sync =  quote.Apttus_QPConfig__Proposald__r.DC_Contract_Not_In_Sync__c;
        header.oneYearExperienceFlag = oneYearExperience;
        //Account information
        header.accounts = new List<QuoteDetailsResponse.Account>{getAccountInformation(quote,dsFirmMap)};
        //Contact information
        header.contacts =  new List<QuoteDetailsResponse.Contact>{getContactInformation(quote,mapContactSSD)};
        //Opportunity information
        header.opportunities = new List<QuoteDetailsResponse.Opportunity>{getOpportunityInformation(quote)};
        header.termCurrent = termCurrent;
        //Added as Part of DLT-9251
        header.sendEmailOnBeHalfOf = getSendEmailOnBehalfOf(quote.Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c);
        header.primaryQuoteFlag = quote.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Primary__c;
        header.quoteType = quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
        header.updatedOnConfigurator = quote.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c;
        header.lastModifiedDate = quote.Apttus_QPConfig__Proposald__r.LastModifiedDate;
        header.aprovalStage = quote.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c;
        header.paymentOption = quote.Apttus_QPConfig__Proposald__r.APTS_Payment_Option__c;
        header.eSignEnvelopeId = quote.Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c;
        header.eSignDocSignerId = quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c;
        header.eSignDocSignerName = DCUtils.formatName(quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Name__c); //DLT-17827
        header.amount = getAmount(quote);

        if(quote.Apttus_QPConfig__Proposald__r.APTS_Incremental__c != null && quote.Apttus_QPConfig__Proposald__r.APTS_Incremental__c > 0){
            header.incrementalAmount = quote.APTS_New_Holdings__c != null ? quote.APTS_New_Holdings__c * 12 : 0 ;
        }
        //DLT-9839 - Reassign users link on Confirmation page (up-sell only)
        if(header != null && String.isNotBlank(header.quoteId)){
            DCAddOnProducts addProdService = new DCAddOnProducts();
            system.debug(logginglevel.INFO, 'Products: ' + addProdService);
            materialIdOnlineContactMap = getOnlineContacts(header.quoteId);
        }
        //QuoteLineItem information
        system.debug('!!!@#'+quote + materialIdOnlineContactMap);
        System.debug('prodMap==>'+prodMap);
        header.quoteLineItems = getQuoteLineItems(quote,materialIdOnlineContactMap,prodMap);
        header.quoteLineItems = DCGetQuoteDetailsHelper.getWestProflexSubproduct(header.quoteLineItems,quote); //DLT-19233
        header.ContractType = getContractType(quote);
        header.digitallySignedDate = quote.Apttus_QPConfig__Proposald__r.Digitally_Signed_Date__c;//DLT-12694
        //header.generateAVC = quote.Apttus_QPConfig__Proposald__r.Digital_Is_AVC_Required__c; //DLT-13174
        return header;
    }
    //getContractType() method
    //Returns the contract type of the offer (New Mid Contract, Old Mid Contract, Ingelligible, NTO)
    private string getContractType(Apttus_Config2__ProductConfiguration__c quote){
        if(DCGetQuoteDetailsHelper.isNTOCustomer(quote)){
            return 'NTO';
        }
        else{
            return quote.Apttus_QPConfig__Proposald__r.Contract_Type__c;
        }
    }//end of getContractType() method

    //getAmount() method
    //Returns the 'amount' which is the current holdings for the cart
    private decimal getAmount(Apttus_Config2__ProductConfiguration__c quote){
        decimal amount = 0;

        if(quote.Apttus_QPConfig__Proposald__r.APTS_Renewal__c != null && quote.Apttus_QPConfig__Proposald__r.APTS_Renewal__c > 0){
            system.debug('quote===================>'+quote);

            if (quote.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c =='FindLaw') {
                //&& quote.Apttus_QPConfig__Proposald__r.APTS_Approval_Segment_Default__c =='FindLaw'){ //Added for FL DLT-15474
                amount = flCurrentHoldings(quote.id);
            }
            else if (quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_MANUAL){
                amount = manualCurrentHoldings(quote);
            }
            else{
                amount = quote.APTS_Current_Holdings__c;
            }           
        }

        //If amount was set to null, ensure it is set to 0
        if(amount == null){
            amount = 0;
        }

        return amount;
    }//end of getAmount() method

    /*
    *  getAccountInformation()
    *  Returns an Account from Apttus_Config2__ProductConfiguration__c parameter
    */
    private QuoteDetailsResponse.Account getAccountInformation(Apttus_Config2__ProductConfiguration__c quote, Map<String,String> digiFirmMap){
        
        QuoteDetailsResponse.Account acc = new QuoteDetailsResponse.Account();
        QuoteDetailsResponse.Address ad = new QuoteDetailsResponse.Address();

        //Set values for Account information
        acc.companyId = quote.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c;//Changed for DLT-13754
        acc.companyName = quote.APTS_SSD_bill_to__r.Digital_Firm_Name__c;
        acc.accountType = 'BillTo';
        acc.sourceOrTargetReferenceNumber = quote.APTS_SSD_bill_to__r.Source_System_Account_Number__c;
        acc.TerritoryNumber = quote.Apttus_Config2__AccountId__r.Field_Sales_Territory__c;
        //added as part of DLT-16286 by Navleen
        // updated for DLT-21586 - use business unit only for FindLaw
        if (quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_MANUAL) {
        	if (quote.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c == 'FindLaw') {
            	acc.digitalFirm = quote.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c;
        	} else {
        		acc.digitalFirm = quote.Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c;
        	}
        } else {
            acc.digitalFirm = digiFirmMap.get(quote.APTS_SSD_bill_to__r.Source_System_Account_Number__c);
        }

        //Set values for Account's address information
        ad.city = quote.APTS_SSD_bill_to__r.Digital_Billing_City__c;
        ad.region = quote.APTS_SSD_bill_to__r.State__c;
        ad.postalcode = quote.APTS_SSD_bill_to__r.Postal_Code__c;
        ad.country = quote.APTS_SSD_bill_to__r.Country__c;
        
        acc.address = ad;

        return acc;
    }

    /*
    *  getContactInformation()
    *  Returns a Contact from Apttus_Config2__ProductConfiguration__c parameter
    */
    private QuoteDetailsResponse.Contact getContactInformation(Apttus_Config2__ProductConfiguration__c quote, Map<ID,LCRM_Contact_SSD__c> mapContactSSD){
        QuoteDetailsResponse.Contact contact = new QuoteDetailsResponse.Contact();
        
        //DLT-16791 Code scan
        if (!Schema.sObjectType.Contact.isQueryable()) {
            throw new DCCustomException('Contact Object is not queryable.');
        }

        //DLT-16096 Validate Order Confirmation Contact. If current contact is invalid, select a contact where all required fields exist.
        if(quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.FirstName == null
            || quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.LastName == null
            || quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c == null
            || quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c == null){

            Contact tempContact = 
                            [SELECT id, FirstName, LastName, Email, Phone
                            FROM Contact
                            WHERE FirstName != null
                            AND LastName != null
                            AND Email != null
                            AND AccountId =: quote.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__c
                            LIMIT 1];

            //Validate query results. Database issue if there are no valid contacts on the Account.
            if(tempContact == null){
                throw new DCCustomException('Database Issue : No valid Contact that contains a First Name, Last Name, and Email exists on the Account ');
            }

            contact.firstname = DCUtils.formatName(tempContact.FirstName);
            contact.lastname = DCUtils.formatName(tempContact.LastName);
            contact.name = contact.firstname + ' ' + contact.lastname;
            contact.contactId = tempContact.id;
            contact.email = tempContact.Email;
            contact.Phone = (tempContact.Phone != null) ? tempContact.Phone : '';

            return contact;
        }//end if

        //DLT-14679
        contact.firstname = (quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.FirstName != null) ? DCUtils.formatName(quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.FirstName) : '';  
        contact.lastname = (quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.LastName != null) ? DCUtils.formatName(quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.LastName) : '';
        // updated as per the DLT-17827
        contact.name = (quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Name__c != null) ? DCUtils.formatName(quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Name__c) : contact.firstname + ' ' + contact.lastname;
        if(quote.Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c!=null){
            //DLT-9760 - Update Opportunities for stage / record type changes and GLI Account / Contact / lookup field changes
            contact.HardBounce = mapContactSSD.get(quote.Apttus_QPConfig__Proposald__r.Order_Confirmation_Contact_SSD__c).LCRM_Hard_Bounce__c;
        }
        contact.contactId = (quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c != null) ? quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c : '';
        contact.email = (quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c != null) ? quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c : '';
        contact.Phone = (quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.Phone != null) ? quote.Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.Phone : '';
        return contact;
    }

    /*
    * getOpportunityInformation()
    * Return an Opportunity from Apttus_Config2__ProductConfiguration__c parameter
    */
    private QuoteDetailsResponse.Opportunity getOpportunityInformation(Apttus_Config2__ProductConfiguration__c quote){
        QuoteDetailsResponse.Opportunity opportunity = new QuoteDetailsResponse.Opportunity();
        opportunity.campaign_Code = quote.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c;
        opportunity.opportunityUrl = quote.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_Offer__c;
        opportunity.amount = quote.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Amount;
        opportunity.renewalDate = quote.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c;
        
        return opportunity;
    }

    /*
    *  getQuoteLineItems()
    *  Returns a list of Quote Line Items from Apttus_Config2__ProductConfiguration__c parameter
    */
    private List<QuoteDetailsResponse.QuoteLineItems> getQuoteLineItems(Apttus_Config2__ProductConfiguration__c quote,Map<String, List<QuoteDetailsResponse.OnlineContacts>> materialIdOnlineContactMap,map<string,product2> bundleIdToCPROProdMap){
        
        List<QuoteDetailsResponse.QuoteLineItems> quoteLineItemList = new List<QuoteDetailsResponse.QuoteLineItems>();     
        String addOnPublicProducts;// DLT-16262   

        if (!Schema.sObjectType.DC_Global_Settings__mdt.isQueryable()) {
            throw new DCCustomException('DC_Global_Settings__mdt is not queryable.');
        }
        globalSettings = [SELECT Id,Indigo_Products__c,public_addon_products__c 
                        FROM DC_Global_Settings__mdt
                        LIMIT 50000];

        String indigoProducts = globalSettings.size() > 0 ? globalSettings[0].Indigo_Products__c : '' ; // Label.DC_Indigo_Products    

        for(DC_Global_Settings__mdt gsmdt: globalSettings){
            if(String.isNotBlank(gsmdt.public_addon_products__c)){
                addOnPublicProducts= gsmdt.public_addon_products__c;
            }
        }
        system.debug('***addOnProducts ::'+addOnPublicProducts);

        // DLT-16262 Ends
        //Adding Quote Line Items to the response
        for( Apttus_Config2__LineItem__c lineItem : quote.Apttus_Config2__LineItems__r){
            qTypeBundlProdId = quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c + lineItem.Apttus_Config2__ProductId__c;

            QuoteDetailsResponse.QuoteLineItems line = new QuoteDetailsResponse.QuoteLineItems();
            line.lineId = lineItem.Id;         
            line.ProductId = lineItem.Apttus_Config2__ProductId__c; //added to include ProductID information for AEM.
            line.optionProductId = lineItem.Apttus_Config2__OptionId__c; //DLT-17452
            line.optionProductDescription = lineItem.Apttus_Config2__OptionId__r.Digital_Description__c; // DLT-17670            
            line.material = new List<QuoteDetailsResponse.Material>();
            line.material = getQuoteDetailResponseMaterial(lineItem);
            //Changed for DLT-15720
            line.productFamily = lineItem.Apttus_Config2__ProductId__r.Family; // Added for DLT-12510
            line.digitalDescription = lineItem.Apttus_Config2__ProductId__r.Digital_Description__c;
            line.status = lineItem.Apttus_Config2__LineStatus__c;
            line.format = lineItem.APTS_Format__c;
            line.isAddOn = lineItem.DC_Is_Add_On__c;
            // Check for Indigo products
            //DLT-11781 - Westlaw Edge/Indigo banner for two offer renewals.
            line.isIndigo = DCGetQuoteDetailsHelper.checkIsIndigo(indigoProducts,lineItem,quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c);
            line.shortDescription = lineItem.Apttus_Config2__ProductId__r.DC_Short_Description__c;
            line.longDescription = lineItem.Apttus_Config2__ProductId__r.DC_Long_Description__c;
            line.pricingModel = getPricingModel(lineItem,bundleIdToCPROProdMap);
            line.price = lineItem.Apttus_Config2__NetPrice__c;
            line.billingFrequency = lineItem.Apttus_Config2__BillingFrequency__c;
            line.firmSize = lineItem.Apttus_Config2__Quantity__c;
            line.attorney = lineItem.APTS_Number_of_Attorneys__c;
            line.bandNumber = getBandNumber(lineItem, quote);
            line.autoRenewalTerm = lineitem.Apttus_Config2__AutoRenewalTerm__c;
            line.subscriptionNumber = lineItem.Apttus_Config2__ProductId__r.Subscription_Number__c;
            line.startDate = lineItem.Apttus_Config2__StartDate__c;
            line.contractTerm = lineItem.APTS_Contract_Term__c;
            line.renewalAdjustment = lineItem.APTS_Yr_1_Renewal_Adjustment__c;
            line.YearOnYearAdjustment = lineItem.APTS_Years_2_Plus_Adjustment__c;
            line.basePrice = lineItem.Apttus_Config2__BasePrice__c;
            line.OriginalQuantity = lineItem.APTS_Original_Quantity__c;
            line.productName = lineItem.Apttus_Config2__ProductId__r.name;
            line.optionProductName = lineItem.Apttus_Config2__OptionId__r.name; //DLT-17452       
            if(lineItem.Apttus_Config2__ConfigurationId__r.APTS_Proposal_Business_Unit__c == 'FindLaw'){
               line.productName =  lineItem.Apttus_Config2__ProductId__r.DC_Product_Title__c;
            }
            line.onlineContacts = getQuoteDetailResponseOnlineContact(materialIdOnlineContactMap,lineItem,bundleIdToCPROProdMap);
            //DLT-15252 
            line.isPublicAddon = checkIsPublicAddon(lineItem, addOnPublicProducts);
            //DLT-18017 [FindLaw] Assign PA/Geo values
            line.PA = lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;
            line.Geo = lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name;
            //DLT-18303 - [FindLaw] Assign contractNumber values
            line.contractNumber = lineItem.APTS_Contract_Number__c;
            
            //Add to list
            quoteLineItemList.add(line);
        }

        return quoteLineItemList;
    }

    //getQuoteDetailResponseOnlineContact() method
    //Returns List<QuoteDetailsResponse.OnlineContacts> for the given line item
    private List<QuoteDetailsResponse.OnlineContacts> getQuoteDetailResponseOnlineContact(Map<String, List<QuoteDetailsResponse.OnlineContacts>> materialIdOnlineContactMap,Apttus_Config2__LineItem__c lineItem,Map<string,product2> bundleIdToCPROProdMap){
        List<QuoteDetailsResponse.OnlineContacts> onlineContacts = new List<QuoteDetailsResponse.OnlineContacts>();
        System.debug('materialIdOnlineContactMap==>'+materialIdOnlineContactMap);
        System.debug('bundleIdToCPROProdMap'+bundleIdToCPROProdMap);
        system.debug('VAlues::' + lineItem.Apttus_Config2__HasOptions__c + lineItem.Apttus_Config2__ProductId__c);
        if(!materialIdOnlineContactMap.isEmpty()){  

            if(materialIdOnlineContactMap.containsKey(lineItem.Apttus_Config2__ProductId__r.Service_Number__c)){
                onlineContacts = materialIdOnlineContactMap.get(lineItem.Apttus_Config2__ProductId__r.ProductCode);
            }            
            else if(lineItem.Apttus_Config2__HasOptions__c == true 
                && bundleIdToCPROProdMap!=null 
                && bundleIdToCPROProdMap.containsKey(qTypeBundlProdId)
                && (materialIdOnlineContactMap.containsKey(bundleIdToCPROProdMap.get(qTypeBundlProdId).Service_Number__c))){

                system.debug('online con inside' + bundleIdToCPROProdMap.get(qTypeBundlProdId).Service_Number__c);
                system.debug('online con materialIdOnlineContactMap' + materialIdOnlineContactMap.get(bundleIdToCPROProdMap.get(qTypeBundlProdId).Service_Number__c));                   
                onlineContacts = materialIdOnlineContactMap.get(bundleIdToCPROProdMap.get(qTypeBundlProdId).Service_Number__c);
            }
        }

        return onlineContacts;
    }//end of getQuoteDetailResponseOnlineContact() method

    //checkIsPublicAddon() method
    //Returns boolean based on whether line item is a public product
    private boolean checkIsPublicAddon(Apttus_Config2__LineItem__c lineItem, String addOnPublicProducts){
        
        system.debug('productid***'+lineItem.Apttus_Config2__ProductId__c);
        if((!publicProdIdsSET.isEmpty() && publicProdIdsSET.contains(lineItem.Apttus_Config2__ProductId__c))
            || (addOnPublicProducts!= null && (lineItem.Apttus_Config2__ProductId__r.Service_Number__c != null 
            && lineItem.Apttus_Config2__ProductId__r.Service_Number__c != '' 
            && addOnPublicProducts.contains(lineItem.Apttus_Config2__ProductId__r.Service_Number__c))) ){  //DLT-16262   -Added OR condition ){
            
            return true;
        }

        return false;
    }//end of checkIsPublicAddon() method

    //getBandNumber() method
    //Returns the band number for the line item
    private integer getBandNumber(Apttus_Config2__LineItem__c lineItem, Apttus_Config2__ProductConfiguration__c quote){
        integer bandNumber;
        
        if(quote.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == 'Manual'){
            bandNumber = Integer.valueOf(lineItem.Apttus_Config2__Quantity__c); 
        }
        else{
            bandNumber = Integer.valueOf(quote.APTS_SSD_bill_to__r.LCRM_APTS_Band_Number__c);
        }

        return bandNumber;
    }//end of getBandNumber() method

    //getPricingModel() method
    //Returns the product pricing model of the line item.
    private String getPricingModel(Apttus_Config2__LineItem__c lineItem, map<string,product2> bundleIdToCPROProdMap){
        String pricingModel = '';

        if(lineItem.Apttus_Config2__HasOptions__c = true && bundleIdToCPROProdMap!=null 
            && bundleIdToCPROProdMap.get(qTypeBundlProdId)!=null){

            pricingModel = (bundleIdToCPROProdMap.get(qTypeBundlProdId)).APTS_Product_Pricing_Model__c;
        }
        else{
            pricingModel = lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c;
        }

        return pricingModel;
    }//end of getPricingModel() method

    //getQuoteDetailResponseMaterial() method
    //Returns a List<QuoteDetailsResponse.Material> for the provided line items
    private List<QuoteDetailsResponse.Material> getQuoteDetailResponseMaterial(Apttus_Config2__LineItem__c lineItem){
        if(productIdToMaterial.get(lineItem.Apttus_Config2__ProductId__c) != null 
            && productIdToMaterial.get(lineItem.Apttus_Config2__ProductId__c).get(lineItem.Apttus_Config2__ProductId__r.Subscription_Number__c) != null ){

            return productIdToMaterial.get(lineItem.Apttus_Config2__ProductId__c).get(lineItem.Apttus_Config2__ProductId__r.Subscription_Number__c);                   
        }
        else if(productIdToMaterial.get(lineItem.Apttus_Config2__ProductId__c) == null && !prodMap.isEmpty() && prodMap.get(qTypeBundlProdId) != null
            && prodMap.get(qTypeBundlProdId).Subscription_Number__c != null && productIdToMaterial.get(prodMap.get(qTypeBundlProdId).Id) != null){

            system.debug('prodMap.get(qTypeBundlProdId).Id::' + qTypeBundlProdId + prodMap.get(qTypeBundlProdId));
            system.debug('productIdToMaterial:: ' +productIdToMaterial);
            return productIdToMaterial.get(prodMap.get(qTypeBundlProdId).Id).get(prodMap.get(qTypeBundlProdId).Subscription_Number__c);
        }

        return new List<QuoteDetailsResponse.Material>();
    }

    /**
    *  will check the Quote has AddOns or not
    */
    private void hasAddons(id proposal, Map<String,String> quoteTypeToId, Map<String,QuoteDetailsResponse.GetQuoteResponseDetails> quoteIdToResponse){
        if (!Schema.sObjectType.Product_Account_Detail__c.isQueryable() || !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()) {
            throw new DCCustomException('Product_Account_Detail__c/Apttus_Proposal__Proposal__c is not queryable.');
        }
        Apttus_Proposal__Proposal__c prop = 
                        [SELECT APTS_SSD_bill_to__r.Source_System_Account_Number__c, 
                            Apttus_Proposal__Opportunity__r.Campaign_Code__c, Apttus_Proposal__Opportunity__r.Renewal_Date__c
                        FROM Apttus_Proposal__Proposal__c
                        WHERE id =: proposal
                        LIMIT 1];

        for(Product_Account_Detail__c plan : 
                        [SELECT Id,name,Add_On_Sub__c,Add_On_Svc__c,Add_on_Type__c,Current_Term_Length__c ,Digital_Firm__c
                        FROM Product_Account_Detail__c
                        WHERE ZP_Cust_Number__c =: prop.APTS_SSD_bill_to__r.Source_System_Account_Number__c 
                        AND Add_on_Type__c in :quoteTypeToId.keySet() 
                        AND Renewal_Date__c =: prop.Apttus_Proposal__Opportunity__r.Renewal_Date__c 
                        AND Campaign_Code__c =: prop.Apttus_Proposal__Opportunity__r.Campaign_Code__c ]){

            quoteIdToResponse.get(quoteTypeToId.get(plan.Add_on_Type__c)).quoteHeader.hasAddOns = true;
        }
    }
    /*
* get the SendEmailOnBehalfOf email Id from Docusign envelop
*/
    @testVisible
    private string getSendEmailOnBehalfOf(string envelopId){
        string sendEmailOnBeHalfOf;
        string envContent;

        if (!Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isQueryable()) {
            throw new DCCustomException('LCRM_Contact_SSD__c is not queryable.');
        }
        envContent =[SELECT Apttus_DocuApi__EnvelopeContent__c 
                    FROM Apttus_DocuApi__DocuSignEnvelope__c 
                    WHERE Apttus_DocuApi__EnvelopeId__c =: envelopId
                    LIMIT 1].Apttus_DocuApi__EnvelopeContent__c;      
        
        //Parse through JSON content
        JSONParser parser = JSON.createParser(envContent);
        while (parser.nextToken() != null){
            if(parser.getText() == 'sendAsUserEmail') {
                parser.nextToken();
                sendEmailOnBeHalfOf = parser.getText();
                sendEmailOnBeHalfOf = sendEmailOnBeHalfOf.replace('@example.com','');
                sendEmailOnBeHalfOf = sendEmailOnBeHalfOf.replace('=','@');
                break;
            }
        } // end of while loop

        return sendEmailOnBeHalfOf;
    }

    /**
    * will get the Materials by Opporunity
    */
    private void getDigitalProductsByOpportunityId(String opportunityId, String accountId){      
        if (!Schema.sObjectType.Digital_Product_Plans__c.isQueryable()&& !Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()) {
            throw new DCCustomException('Digital_Product_Plans__c is not queryable.');
        }
        //Getting the product plans for digital finalized carts
        List<Digital_Product_Plans__c> plans =
                [SELECT id, name, Material_Number__c,Material_Description__c, Product__c, 
                    Subscription_Number__c,SLF_Jurisdiction__c, DB_Group__c, DB_Group_Sort_Order__c,
                    DB_Category__c,DB_Category_Sort_Order__c,SLF_Help_Text__c,Additional_Help_Text__c
                FROM Digital_Product_Plans__c
                WHERE Product__c IN ( SELECT Apttus_Config2__ProductId__c
                                      FROM Apttus_Config2__LineItem__c
                                      WHERE  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c =: opportunityId
                                      AND  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__c =: accountId //old value:Apttus_Config2__ConfigurationId__r.Apttus_Config2__BillToAccountId__c
                                      AND Apttus_Config2__LineStatus__c  in  ('New','Renewed','Existing') //DLT-17452 updated with new line status Existing
                                      AND  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.is_Digital_Channel__c=TRUE
                                      AND  Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c =: CART_STATUS_FINALIZED
                                      AND  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DocuSign_Envelope_ID__c!=NULL)];
        //18485
        set<id> cPROPrdIDSET;    
        if (!prodMap.isEMpty() && ProdMap.Size() > 0){    
            cPROPrdIDSET =new set<id>(); 
            if(!Test.isRunningTest()){   
                cPROPrdIDSET = getCPROProdcutIds();   
            }
        }

        if(cPROPrdIDSET != null && !cPROPrdIDSET.isEmpty()){
            List<Digital_Product_Plans__c> cPROplans = 
                            [SELECT id, name, Material_Number__c,Material_Description__c, Product__c, 
                                Subscription_Number__c,SLF_Jurisdiction__c, DB_Group__c, DB_Group_Sort_Order__c,
                                DB_Category__c,DB_Category_Sort_Order__c,SLF_Help_Text__c,Additional_Help_Text__c       
                            FROM Digital_Product_Plans__c
                            WHERE product__r.Id IN :cPROPrdIDSET];
            plans.addAll(cPROPlans);

        }

        //Adding materials to the response
        for(Digital_Product_Plans__c plan : plans){
            QuoteDetailsResponse.Material material = new QuoteDetailsResponse.Material();
            material.materialId = plan.Id;
            material.materialNumber = plan.Material_Number__c;
            material.materialDescription = plan.Material_Description__c;
            material.internalDescription = plan.SLF_Help_Text__c;
            material.classificationValue = plan.DB_Category__c;
            material.classificationValueSortOrder = Integer.valueOf(plan.DB_Category_Sort_Order__c);
            material.subscriptionNumber = plan.Subscription_Number__c;
            material.jurisdiction = plan.SLF_Jurisdiction__c;
            material.productPlanId = plan.Product__c;
            material.productGroup = plan.DB_Group__c;
            material.productGroupSortOrder = Integer.valueOf(plan.DB_Group_Sort_Order__c);
            material.additionalInternalDescription = plan.Additional_Help_Text__c;
            if(productIdToMaterial.get(plan.Product__c) == null){
                productIdToMaterial.put(plan.Product__c,new Map<String,List<QuoteDetailsResponse.Material>>());
            }
            if(productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c) == null){
                productIdToMaterial.get(plan.Product__c).put(plan.Subscription_Number__c,new List<QuoteDetailsResponse.Material>());
            }
            productIdToMaterial.get(plan.Product__c).get(plan.Subscription_Number__c).add(material);
        }    
    }

    //DLT-9839 - Reassign users link on Confirmation page (up-sell only)
    @testVisible
    private Map<String, List<QuoteDetailsResponse.OnlineContacts>> getOnlineContacts(String quoteId){
        Map<String, List<QuoteDetailsResponse.OnlineContacts>> materialIdOnlineContactMap = new Map<String, List<QuoteDetailsResponse.OnlineContacts>>();
        List<Online_Contacts__c> onlineContactList;

        if (!Schema.sObjectType.Online_Contacts__c.isQueryable()) {
            throw new DCCustomException('Online_Contacts__c is not queryable.');
        }      
        onlineContactList =[SELECT Id, ContactID__c, Material__c, Middle_Name__c, QuoteId__c,QuoteLineItem__c, 
                                Product_Attribute__c, First_Name__c, Last_Name__c, Email__c
                            FROM Online_Contacts__c
                            WHERE QuoteId__c = :quoteId];      
        //Adding Online Contacts to the response
        for(Online_Contacts__c onlineContact : onlineContactList) {
            QuoteDetailsResponse.OnlineContacts onc = new QuoteDetailsResponse.OnlineContacts();
            onc.contactSFId = onlineContact.Id;
            onc.contactExternalId = onlineContact.ContactID__c;
            onc.firstName = onlineContact.First_Name__c;
            onc.lastname = onlineContact.Last_Name__c;
            onc.email = onlineContact.Email__c;
            onc.materialNumber = onlineContact.Material__c;
            if(!materialIdOnlineContactMap.keySet().contains(onlineContact.Material__c)){
                materialIdOnlineContactMap.put(onlineContact.Material__c, new List<QuoteDetailsResponse.OnlineContacts>());
            }
            materialIdOnlineContactMap.get(onlineContact.Material__c).add(onc);
        }
        return materialIdOnlineContactMap;
    }

    //DLT-15474
    public decimal flCurrentHoldings(id qCartId){
        decimal fltotalCurrentItems=0.0;

        for(Apttus_Config2__LineItem__c lineItem :
                [SELECT id, Apttus_Config2__AssetLineItemId__c, Apttus_Config2__BasePrice__c, 
                    Apttus_Config2__ListPrice__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c 
                FROM Apttus_Config2__LineItem__c 
                WHERE Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c ='Activated' 
                AND Apttus_Config2__ConfigurationId__c = :qCartId]){

           fltotalCurrentItems += lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c; //Net Price from Asset as Current price
        }
        return fltotalCurrentItems;
    }

    //manualCurrentHoldings() method
    //Calculates the value of current holdings for Manual offers off of Line Items in the cart.
    //Used for Confirmation Page Pricing
    //Added DLT-15612
    public decimal manualCurrentHoldings(Apttus_Config2__ProductConfiguration__c cart){
        decimal manualAmount = 0;
        for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){
            manualAmount += lineItem.Apttus_Config2__NetPrice__c;
        }
        return manualAmount;
    }//end of manualCurrentHoldings() method

    //Get the map of Bundle prduct to CPRO Product for the given quotes from bundle proposal line item and assosiated CPRO product2
    private Map<string,Product2> getCPROProductsForBundles(){
        
        system.debug('setQuoteIds::' + setQuoteIds);
        Map<string,Product2> bundleIdToCPROProdMap = new Map<string,Product2>();
        Map<string,product2> cPROMatrlToProdMap = new Map<string,product2>();
        Set<string> bundleServiceOverrideNumSet = new Set<string>();
        List<Apttus_Proposal__Proposal_Line_Item__c> pLineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        

        if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible()){
            pLineItemList =
                    [SELECT Id,APTS_Service_Number_Override__c,Apttus_Proposal__Product__c,
                        Apttus_Proposal__Proposal__r.Digital_quote_Type__c 
                    FROM Apttus_Proposal__Proposal_Line_Item__c 
                    WHERE Apttus_QPConfig__HasOptions__c = true 
                    AND Apttus_Proposal__Proposal__c IN : setQuoteIds 
                    AND APTS_Service_Number_Override__c!= null];
            /*
            if(Test.isRunningTest()){
                pLineItemList = 
                        [SELECT Id,APTS_Service_Number_Override__c,Apttus_Proposal__Product__c,
                            Apttus_Proposal__Proposal__r.Digital_quote_Type__c 
                        FROM Apttus_Proposal__Proposal_Line_Item__c
                        LIMIT 50000];
            }*/
        }

        for(Apttus_Proposal__Proposal_Line_Item__c pli: pLineItemList){
            //Holds quotetypeand bundleid as key and value as cPRO service number 
            bundleServiceOverrideNumSet.add(pli.APTS_Service_Number_Override__c);
        }
        
        System.debug('bundleServiceOverrideNumSet==>'+bundleServiceOverrideNumSet);

        if(Schema.sObjectType.Product2.isAccessible()){ 
            for(product2 p: [SELECT Id,Service_Number__c,Subscription_Number__c,APTS_Product_Pricing_Model__c,ProductCode 
                            FROM Product2
                            WHERE Service_Number__c IN :bundleServiceOverrideNumSet 
                            AND APTS_Product_Pricing_Model__c!=null 
                            AND APTS_Product_Pricing_Model__c !='']){

                cPROMatrlToProdMap.put(p.Service_Number__c,p);
            }
            /*
            if(Test.isRunningTest()){
                for(Product2 p: [SELECT Id,Service_Number__c,Subscription_Number__c,APTS_Product_Pricing_Model__c,ProductCode 
                                FROM Product2
                                LIMIT 50000]){
                    cPROMatrlToProdMap.put(p.Service_Number__c,p);
                }
            }
            */
        }

        if(!cPROMatrlToProdMap.isEMpty()){
            for(Apttus_Proposal__Proposal_Line_Item__c pli : pLineItemList){ 
                bundleIdToCPROProdMap.put(pli.Apttus_Proposal__Proposal__r.digital_Quote_Type__c+ pli.Apttus_Proposal__Product__c,cPROMatrlToProdMap.get(pli.APTS_Service_Number_Override__c));
            }
        }
        system.debug('mapppppp'+bundleIdToCPROProdMap);

        return bundleIdToCPROProdMap;                           
    }

    // Reads bundleToCPROProdMap and get all CPRO prod Ids
    private set<id> getCPROProdcutIds(){   //18485      
        set<id> cPRODProdIdSET = new set<id>();

        if(prodMap != null && prodMap.size() >0 && prodMap.Values() != null && prodMap.Values().size() > 0 ){
            for(product2 p: prodMap.Values()){                
                cPRODProdIdSET.add(p.Id);
            }
        }
        return cPRODProdIdSET;
    }

}