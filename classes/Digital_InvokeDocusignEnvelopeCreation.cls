/*
 * Class contains invocable method to called DigitalDocusignEnvelopeCreation envelope creation method.
 *
 *
 *                      ****** Change History *******
 *    Date                      Name                                Description
 *    2018-08-10                Benjamin Her                        DLT-7380 Initial creation of class.
 *    2018-11-15                Benjamin Her                        DLT-13445 Updated missing fields
 *    2019-01-17                Benjamin Her                        DLT-14478 Update adjustment fields on Proposals
 *    2019-02-14                Navleen Kaur                        DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 *    2019-02-19                Benjamin Her                        DLT-15266 - Fix duplicate ID error due to multiple configurations on quote
 *                                                                            - Added Exception logging 
 *    2019-03-06                Benjamin Her                        DLT-15149 Removed IF condition to update quote when configuration changes
 *    2019-03-25                Benjamin Her                        DLT-15835 Update variable assignments with defaults values if valid value does not exist.
 *    2019-07-05                Benjamin Her                        DLT-16910 Create method to enable Rep Driven Persaonlized Offers
 *    2019-10-30                David Hoel                          DLT-18211 Allow reps to modify the manual proposal when one of the proposal is in presented state.  
 *    2020-01-23                Bishanka Dassarma                   DLT-19226 [Rep driven/Personalized]WIN/LOSS reason - fields on proposal
 *    2020-05-27                Brenda Shields                      DLT-20094 - Update the unmarked as digital field if needed     
 *    2020-06-12                Benjamin Her                        DLT-20164  Update logic for NSE type offer
 *    2020-06-24                Brenda Shields                      DLT-20224 - Limit Rep to only 3 manual quotes per Opp offer         
 *    2020-10-19                Benjamin Her                        DLT-20971 Update Rep Driven Renewal date
 *    2020-11-05                Rahul Natarajan                     DLT-20994 [SFDC] [REP][ALL] - Update rep-driven NTO contract type
 *    2021-04-01                Brenda Shields                      DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 *   2021-04-05					Ameeta A							DLT-21574 - Incorrect Opportunity Staging on Rep Added Offers(Including DLT-21629)
 */
/**
    @description Class contains invocable method to called DigitalDocusignEnvelopeCreation envelope creation method
  */
public without sharing class Digital_InvokeDocusignEnvelopeCreation {

    //static variable declaration
    private static final String STATUS_FINALIZED = 'Finalized';
    private static final String MANUAL_QUOTE_TYPE = 'Manual';
    private static final integer REPDRIVEN_DATELIMIT = Integer.valueOf(System.Label.Digital_RepDriven_RenewalDateLimit);
    public static Boolean isNTO = false;

    /** 
        @description invoke CreateEnvelopes
		@param  quoteIds
     */
    @InvocableMethod
    public static void invokeCreateEnvelopes(List < ID > quoteIds) {
        //Queries the Proposal from the ID
        List < Apttus_Proposal__Proposal__c > listquote = new List < Apttus_Proposal__Proposal__c > ();
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
            listquote = [SELECT id, Display_in_CXD_Renewals__c, APTS_Order_Confirmation_Contact_Email__c,
                Order_Confirmation_Contact_SSD__c, APTS_Order_Confirmation_Contact__r.Email,
                Apttus_Proposal__Opportunity__c, Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c,
                Apttus_Proposal__Opportunity__r.Digital_Review_Complete__c
                FROM Apttus_Proposal__Proposal__c
                WHERE id IN: quoteIds
            ];
        }

        List < Apttus_Config2__ProductConfiguration__c > configlist = new List < Apttus_Config2__ProductConfiguration__c > ();
        configlist = [SELECT id, Apttus_Config2__Status__c, APTS_SSD_bill_to__c,
            Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__c,
            Apttus_QPConfig__Proposald__c, APTS_SSD_bill_to__r.id, Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c,
            Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c,
            Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c,
            Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c,
            Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c,
            (SELECT id, Apttus_Config2__AdjustmentType__c,
                Apttus_Config2__AdjustmentAmount__c,
                Apttus_Config2__Quantity__c, APTS_Contract_Term__c FROM Apttus_Config2__LineItems__r WHERE Apttus_Config2__LineStatus__c = 'New'
                LIMIT 1)
            FROM Apttus_Config2__ProductConfiguration__c
            WHERE Apttus_QPConfig__Proposald__c IN: listquote
            AND Apttus_Config2__Status__c =: STATUS_FINALIZED
            WITH SECURITY_ENFORCED
        ];

        //calls method to update manual proposal
        try {
            //generateOrderForm(quoteIds);
            system.debug(LoggingLevel.INFO, '68 Cart List->' + configlist[0]);
            if (!configlist.isEmpty()) {
                //DLT-20994 - getting NTO details
                isNTO = DCGetQuoteDetailsHelper.isNTOCustomer(configlist[0]);
                system.debug(LoggingLevel.INFO, '221 isNTO value->' + isNTO);
            }
            updateProposals(listquote, configlist);
            updateConfiguration(configlist);
            invokeCreateEnvelopesHelper(quoteIds);
        } catch (Exception ex) {
            DCUtils.trackLog(ex, 'Digital_InvokeDocusignEnvelopeCreation', 'invokeCreateEnvelopes');
        }
    } //end invokeCreateEnvelopes() method

	/** 
        @description updateProposals() method-to ensure manual proposal displays properly on landing page
		@param  listquote
		@param  configlist
     */
    public static void updateProposals(List < Apttus_Proposal__Proposal__c > listquote, List < Apttus_Config2__ProductConfiguration__c > configlist) {

        //Query all opps and its associated manual proposals from the passed in Manual quotes
        List < Opportunity > listOpps = new List < Opportunity > ();
        listOpps = [
            SELECT id, Key_Contact__c, Contract_Type__c, isDigitalSpearHead__c, Digital_Review_Complete__c, Renewal_Date__c, Unmarked_Digital_Channel__c,
            (SELECT id, Display_in_CXD_Renewals__c, Contract_Type__c, Latam_APTS_Reason__c, APTS_Order_Confirmation_Contact_Email__c,
                Order_Confirmation_Contact_SSD__c, APTS_Order_Confirmation_Contact__r.Email,
                APTS_SSD_bill_to__c, Apttus_Proposal__Approval_Stage__c FROM R00N70000001yUfDEAU__r //Child Relationship name for Apttus Proposal
                WHERE Digital_Quote_Type__c =: MANUAL_QUOTE_TYPE)
            FROM Opportunity
            WHERE id IN(SELECT Apttus_Proposal__Opportunity__c FROM Apttus_Proposal__Proposal__c WHERE id IN: listquote)
            WITH SECURITY_ENFORCED
        ];

        //Query all Contact Source Detail associated with the opportunities
        List < LCRM_Contact_SSD__c > listContacts = new List < LCRM_Contact_SSD__c > ();
        listContacts = [SELECT id, LCRM_Email__c, LCRM_Contact__c
            FROM LCRM_Contact_SSD__c
            WHERE LCRM_Email__c != null
            AND LCRM_SAP_Role__c != null
            AND LCRM_Account_SSD__c IN(SELECT Source_System_Detail__c FROM Opportunity WHERE id IN: listOpps)
            WITH SECURITY_ENFORCED
            ORDER BY LastModifiedDate DESC
        ];


        //Filters out similar Contact Source Details and maps to Contact 
        //Only need Contact Source Detail record per Contact             

        Map < String, LCRM_Contact_SSD__c > mapEmailLCRMContact = new Map < String, LCRM_Contact_SSD__c > ();
        for (LCRM_Contact_SSD__c contactSSD: listContacts) {
            mapEmailLCRMContact.put(contactSSD.LCRM_Email__c, contactSSD);
        }

        List < Apttus_Proposal__Proposal__c > updateQuotes = new List < Apttus_Proposal__Proposal__c > ();

        //Iterate through all opportunity
        for (Opportunity opp: listOpps) {
            //Iterate through all proposals associated with the opportunity
            for (Apttus_Proposal__Proposal__c quote: opp.R00N70000001yUfDEAU__r) {
                //If 'quote' is found in 'listquote', update relevant fields
                if (listContainsQuote(listquote, quote)) {
                    quote.Display_in_CXD_Renewals__c = true;
                    quote.Latam_APTS_Reason__c = 'Digital'; //DLT-19226
                    quote = updateQuoteContactData(quote, mapEmailLCRMContact, listContacts);
                    quote = updateProposalAdjustmentField(quote, configlist);
                }
                //DLT-20994,Check NTO Value & Update Quote Details
                system.debug(LoggingLevel.INFO, '129 isNTO value->' + isNTO);
                if (isNTO) {
                    quote.Contract_Type__c = System.Label.Digital_NTO;
                    system.debug(LoggingLevel.INFO, '130 Quote value->' + quote.Contract_Type__c);
                }

                updateQuotes.add(quote);
            }
        }
        system.debug(LoggingLevel.INFO, 'updateQuotes: ' + updateQuotes);
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
            update updateQuotes;
        }

        //DLT-16910
        updateOpportunityToDigital(listOpps);

    } //end of updateProposals() method

    //updateQuoteContactData() method
    //Updates the contact information on the quote
    private static Apttus_Proposal__Proposal__c updateQuoteContactData(Apttus_Proposal__Proposal__c proposal, Map < String, LCRM_Contact_SSD__c > mapEmailLCRMContact, List < LCRM_Contact_SSD__c > listContacts) {

        Apttus_Proposal__Proposal__c quote = proposal;

        //DLT-20164 Update 'else' logic with null check since NSE customer has no Contact SSD
        if (mapEmailLCRMContact.containsKey(quote.APTS_Order_Confirmation_Contact__r.Email)) {
            quote.APTS_Order_Confirmation_Contact_Email__c = mapEmailLCRMContact.get(quote.APTS_Order_Confirmation_Contact__r.Email).LCRM_Email__c;
            quote.Order_Confirmation_Contact_SSD__c = mapEmailLCRMContact.get(quote.APTS_Order_Confirmation_Contact__r.Email).id;
        } else {
            quote.APTS_Order_Confirmation_Contact_Email__c = quote.APTS_Order_Confirmation_Contact__r.Email;

            if (listContacts != null && !listContacts.isEmpty()) {
                quote.Order_Confirmation_Contact_SSD__c = listContacts[0].id;
            }
        }

        return quote;
    } //end of updateQuoteContactData() method

    /** 
        @description listContainsQuote() method-Checks if the proposal is contained within a list of proposals
		@param  listquote
		@param  quote
		@return boolean
     */
    public static boolean listContainsQuote(List < Apttus_Proposal__Proposal__c > listquote, Apttus_Proposal__Proposal__c quote) {
        for (Apttus_Proposal__Proposal__c q: listquote) {
            if (quote.id == q.id) {
                return true;
            }
        }
        return false;
    } //end listContainsQuote() method

    /** 
        @description updateConfiguration()) method-Updates the Product Configuration on the Proposal to be ready for landing page
		@param  configlist
     */
    public static void updateConfiguration(List < Apttus_Config2__ProductConfiguration__c > configlist) {

        List < Apttus_Config2__ProductConfiguration__c > updateConfigurations = new List < Apttus_Config2__ProductConfiguration__c > ();

        for (Apttus_Config2__ProductConfiguration__c configuration: configlist) {

            if (configuration.APTS_SSD_bill_to__c != configuration.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__c) {
                configuration.APTS_SSD_bill_to__c = configuration.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__c;
            }
            updateConfigurations.add(configuration);
        }

        if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable()) {
            update updateConfigurations;
        }

    } //end updateConfiguration() method

    /** 
        @description updateProposalAdjustmentField() method-DLT-14478: Updates the missing adjustment fields on the proposal record.
		@param  proposal
		@param  configlist
		@return proposal
     */
    public static Apttus_Proposal__Proposal__c updateProposalAdjustmentField(Apttus_Proposal__Proposal__c proposal, List < Apttus_Config2__ProductConfiguration__c > configlist) {

        Apttus_Proposal__Proposal__c quote = proposal;

        for (Apttus_Config2__ProductConfiguration__c prodconfig: configlist) {

            if (prodconfig.Apttus_QPConfig__Proposald__c == proposal.id) {
                for (Apttus_Config2__LineItem__c line: prodconfig.Apttus_Config2__LineItems__r) {
                    quote.DC_Default_Adjustment_Amount__c = line.Apttus_Config2__AdjustmentAmount__c;
                    quote.DC_Default_Adjustment_Type__c = line.Apttus_Config2__AdjustmentType__c;
                    quote.DC_Default_Contract_Term__c = line.APTS_Contract_Term__c;
                    quote.DC_Default_Quantity__c = line.Apttus_Config2__Quantity__c;

                    break;
                }
            }
        }

        return quote;
    }

    /** 
        @description invokeCreateEnvelopesHelper() method-Calls CXD class, DigitalDocusignEnvelopeCreation to process Manual quote
		@param  quoteIds
     */
    @future(callout = true)
    public static void invokeCreateEnvelopesHelper(List < ID > quoteIds) {
        List < Apttus_Proposal__Proposal__c > listQuotes = new List < Apttus_Proposal__Proposal__c > ();
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
            listQuotes = [Select id, name, Apttus_Proposal__Opportunity__c,
                Apttus_Proposal__Opportunity__r.SAP_Account_Number__c,
                Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c,
                Apttus_Proposal__Opportunity__r.Owner.Email, Apttus_Proposal__Opportunity__r.Owner.Name,
                Apttus_Proposal__Opportunity__r.Digital_PreviousStageName__c,
                APTS_Order_Confirmation_Contact__c, APTS_Order_Confirmation_Contact_Name__c,
                APTS_Order_Confirmation_Contact_Email__c,Digital_Quote_Failure_Reason__c,
                Apttus_Proposal__Primary__c, Digital_Quote_Type__c, APTS_Renewal__c,
                APTS_Sold_To_SAP_Account_Number__c, APTS_Proposal_Business_Unit__c, APTS_Approval_Segment__c,
                Apttus_Proposal__Opportunity__r.Renewal_Date__c, CreatedDate, Is_Digital_New_Sales__c
                FROM Apttus_Proposal__Proposal__c WHERE Id IN: quoteIds
            ];
        }
        if (!Test.isRunningTest()) {
            DigitalDocuSignEnvelopeCreation.CreateEnvelopes(listQuotes);
        }

    } //end invokeCreateEnvelopesHelper() method  

    /** 
        @description updateOpportunityToDigital() method-Marks the opportunity as Digtial and set Digital Review Complete to TRUE
		@param  listOpps
     */
    public static void updateOpportunityToDigital(List < Opportunity > listOpps) {
        boolean bUpdateOpp;
        list < Opportunity > updateOpps = new list < Opportunity > ();

        for (Opportunity opp: listOpps) {
            bUpdateOpp = false;
            if (!opp.isDigitalSpearHead__c) {
                opp.isDigitalSpearHead__c = true;
                bUpdateOpp = true;
            }
            if (opp.Unmarked_Digital_Channel__c) {
                opp.Unmarked_Digital_Channel__c = false;
                bUpdateOpp = true;
            }
            if (!opp.Digital_Review_Complete__c) {
                opp.Digital_Review_Complete__c = true;
                bUpdateOpp = true;
            }
            if (opp.Renewal_Date__c == null) {
                opp.Renewal_Date__c = system.today() + REPDRIVEN_DATELIMIT;
                bUpdateOpp = true;
            }

            //DLT-20994,Check NTO Value & Update opportunity Details
            system.debug(LoggingLevel.INFO, '280 isNTO value->' + isNTO);
            if (isNTO) {
                opp.Contract_Type__c = System.Label.Digital_NTO;
                system.debug(LoggingLevel.INFO, '281 opp value->' + opp.Contract_Type__c);
                bUpdateOpp = true;
            }
            // only update the Opp if needed
            if (bUpdateOpp) {
                updateOpps.add(opp);
            }
        }
        // are there any Opps to update
        if (updateOpps.size() > 0 && updateOpps != Null && Schema.sObjectType.Opportunity.isUpdateable()) {
            update updateOpps;
        }

    } //end of updateOpportunityToDigital() method

 	/** 
        @description generateOrderForm() method
		@param  quoteIds
     */
    public static void generateOrderForm(List < ID > quoteIds) {
        // get list to send to Order Form cration method
        //Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c = TRUE AND 
        //AND Apttus_QPConfig__Proposald__r.Digital_Batch_Processed__c = TRUE AND Digital_Pending_Cart__c = FALSE
        //AND (Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Draft' OR Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Approved') 
        //AND Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c != Null AND Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c IN (Null,'')) 
        list < Apttus_Config2__ProductConfiguration__c > cartList = [select id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
            Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c, Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c, APTS_Proposal_Business_Unit__c, Apttus_QPConfig__Proposald__r.Contract_Type__c
            from Apttus_Config2__ProductConfiguration__c
            where Apttus_Config2__Status__c = 'Finalized'
            AND Apttus_QPConfig__Proposald__c in: quoteIds
        ];

        if (!Test.isRunningTest()) {
            Digital_GenerateDocumentsBatch.generateOrderForm(cartList);
        }
    }

}