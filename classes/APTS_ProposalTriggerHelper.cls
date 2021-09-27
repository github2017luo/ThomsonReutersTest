public with sharing class APTS_ProposalTriggerHelper {
    //SOC-4017-Pathra added this to make sure the job is not enqueued repeatedly
    public static boolean Docusignjob = false;
    private static final String APTS_CPQADMINADDON = 'Apttus_CPQ_Admin_Add_On';
    //DOC-5003 Starts
    private static final String GLI_SALES = 'GLI Sales User';
    private static final String GLI_SALES_OP = 'GLI Sales Ops User';
    private static final String TR_SALES = 'TR Sales';
    private static final String TR_SALES_OP = 'TR Sales Ops';
    private static final String TR_SALES_LIGHT = 'TR Sales - Lightning';
    //DOC-5003 Starts
    private static final String DISCARDED = 'Discarded';
    private static final String INVOICED = 'Invoiced';
    private static final String ACCEPTED = 'Accepted';
    private static final String PRESENTED = 'Presented';
    private static final String COMPLETED = 'Completed';
    private static final String GENERATED = 'Generated';
    public Static Profile currentUserPro = [select id, Name from Profile where id =: Userinfo.getProfileid() limit 1];
    public static List < PermissionSetAssignment > currentUserPermissionsList = [SELECT Id, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: Userinfo.getUserId() and PermissionSet.Name =: APTS_CPQADMINADDON];


    // This method defaults the price list field to 'Thomson Reuters Master - US Legal'.
    public static void updatePriceList(List < Apttus_Proposal__Proposal__c > proposals) {
        //Set<String> catalogSet=new Set<String>{'Findlaw','LMS','USL'}; 
        set < Id > optyIds = new Set < Id > ();
        Map < String, Id > pricelistmap = new Map < String, Id > ();
        Map < String, String > pbus = new Map < String, String > ();
        //Added If Condition as per of SOC-6701--Zakeer
        if (checkRecursive.runpropsaltrgr_updatePriceListOnce()) {
            //Apttus_Config2__PriceList__c PriceList;
            for (Apttus_Proposal__Proposal__c proposal: proposals) {
                if (proposal.Apttus_Proposal__Opportunity__c != null) {
                    optyIds.add(proposal.Apttus_Proposal__Opportunity__c);
                }
            }
            system.debug('Opty Ids = ' + optyIds);
            List < Apttus_Config2__PriceList__c > listPriceList;
            //DOC-12752-Commented as part of CrossSell
            //listPriceList = [SELECT Id FROM Apttus_Config2__PriceList__c WHERE Name = 'Thomson Reuters Master - US Legal' limit 1];
            /*User currentUser = new User();
            if(Schema.sObjectType.user.fields.id.isAccessible()&&Schema.sObjectType.user.fields.Sub_Bu__c.isAccessible()&&Schema.sObjectType.user.fields.Segment__c.isAccessible())
            currentUser=[select id,Sub_Bu__c,Default_Catalog__c,Segment__c from user where id =: UserInfo.getUserId()];
            system.debug('###currentUser'+currentUser);*/
            if (Schema.sObjectType.Apttus_Config2__PriceList__c.isAccessible()){
                listPriceList = [SELECT Id, Name, CurrencyIsoCode, Apttus_Config2__Active__c FROM Apttus_Config2__PriceList__c where Name != 'TR Demo Price List'];}
            if (listPriceList.isEmpty()) {
                return;
            }
            //DOC-12752-Added as part of CrossSell
            for (Apttus_Config2__PriceList__c pricelist: listPriceList) {
                if (pricelist.CurrencyIsoCode != null && pricelist.Id != null) {
                    pricelistmap.put(pricelist.CurrencyIsoCode, pricelist.Id);
                }
            }
            if (Schema.sObjectType.APTS_Proposal_Business_Unit_Default__mdt.isAccessible()) {
                List < APTS_Proposal_Business_Unit_Default__mdt > propbus = [Select APTS_Proposal_Business_Unit__c, APTS_Sales_Org__c, MasterLabel from APTS_Proposal_Business_Unit_Default__mdt];
                for (APTS_Proposal_Business_Unit_Default__mdt
                    var: propbus) {
                    if (var.APTS_Sales_Org__c != null &&
                        var.APTS_Proposal_Business_Unit__c != null) {
                        pbus.put(var.APTS_Sales_Org__c,
                            var.APTS_Proposal_Business_Unit__c);
                    }
                }
            }
            if (!optyIds.isEmpty()) {
                // Add Digital Field on Opportunity Query - DLT-20734 - Rahul
                Map < Id, Opportunity > optymap = new Map < Id, Opportunity > ([SELECT Id, isDigitalSpearHead__c, Is_Digital_New_Sales__c, Source_System_Detail__r.Billing_Currency__c, Source_System_Detail__r.LCRM_Sales_Org__c, APTS_Proposal_Business_Unit__c FROM Opportunity WHERE Id IN: optyIDs]);
                for (Apttus_Proposal__Proposal__c proposal: proposals) {
                    Opportunity opty = optymap.get(proposal.Apttus_Proposal__Opportunity__c);
                    system.debug('Opty Values' + opty);
                    proposal.APTS_Is_Order_Created__c = false; //Added By Poonam Garg. To resolve Duplicate Orders DOC 2996
                    //DOC-12752-Added as part of CrossSell
                    if (!pricelistmap.isEmpty() && pricelistmap != null && opty.Source_System_Detail__r.Billing_Currency__c != null) {
                        if (pricelistmap.containskey(opty.Source_System_Detail__r.Billing_Currency__c)) {
                            proposal.Apttus_QPConfig__PriceListId__c = pricelistmap.get(opty.Source_System_Detail__r.Billing_Currency__c);
                        }
                        proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c;
                    }
                    // Buisness Unit Default-Shouldnt Work for CXD quotes - DLT-20734 - Rahul
                     if (!pbus.isEmpty() && pbus != null && opty.Source_System_Detail__r.LCRM_Sales_Org__c != null ) {
                         if ((pbus.containskey(opty.Source_System_Detail__r.LCRM_Sales_Org__c)) && (opty.isDigitalSpearHead__c == false && opty.Is_Digital_New_Sales__c == false) && opty.APTS_Proposal_Business_Unit__c!='FindLaw'&&opty.APTS_Proposal_Business_Unit__c!='Russia-1S'&&opty.APTS_Proposal_Business_Unit__c!='SouthKorea-DUZON'&&opty.APTS_Proposal_Business_Unit__c!='Dofiscal' ) {//  && (opty.APTS_Proposal_Business_Unit__c!=null)
                            proposal.APTS_Proposal_Business_Unit__c = pbus.get(opty.Source_System_Detail__r.LCRM_Sales_Org__c);
                        }
                        //DOC-17277- Dominic Thomas
                       else{
                       updateProposalBusinessUnit(opty,proposal);
                       }
                      //DOC-17277 Ends - Dominic Thomas
                    }
                    //DOC-12752-Commented as part of CrossSell
                    /*for(Apttus_Config2__PriceList__c pricelist :listPriceList ){  
                        system.debug('###currentUser'+pricelist );
            // DOC-3114 Condition added By Poorva  for implementing cross selling scenario           
                        if (proposal.Apttus_QPConfig__PriceListId__c == null){
                            system.debug('### in if');
                            if((currentUser.Sub_Bu__c == label.SALESORGCAN  || 
                            (currentUser.Segment__c == label.SALESORGTAX && opty.Source_System_Detail__r.LCRM_Sales_Org__c == Label.SALESORGCARS))
                            && pricelist.Name !=null && pricelist.Name !='' && pricelist.Name == label.CanadaPriceList){
                                proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id;
                                system.debug('###currentUser 1');
                            } // Based on User Default Catalog and segments global and corporate pricelist is decided
                        else if (pricelist.Name !=null && pricelist.Name !='' && pricelist.Name == 'Thomson Reuters Master - US Legal'){
                            if((catalogSet.contains(currentUser.Default_Catalog__c) 
                            || (string.isBlank(currentUser.Default_Catalog__c) 
                            && (currentUser.Segment__c=='Global' || currentUser.Segment__c=='Corporate')) 
                            || currentUser.Segment__c == 'Professional Tax')
                            && opty.Source_System_Detail__r.Billing_Currency__c == 'USD') {
                                system.debug('Billing Currency'+opty.Source_System_Detail__r.Billing_Currency__c);
                                proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id;
                            }
                        }
                        else if((currentUser.Segment__c=='Global' || currentUser.Segment__c=='Corporate' ||
                            (currentUser.Segment__c == label.SALESORGTAX && opty.Source_System_Detail__r.LCRM_Sales_Org__c != label.SALESORGS100)) 
                            && opty.Source_System_Detail__r.Billing_Currency__c != 'USD' && pricelist.Name !=null && pricelist.Name !=''){
                            if(opty.Source_System_Detail__r.Billing_Currency__c == 'GBP' && pricelist.Name == label.GBPPricelist){
                                system.debug('###currentUser 2');
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c;
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'AED' && pricelist.Name == label.AEDPricelist){
                                system.debug('###currentUser AED');
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'AUD' && pricelist.Name == label.AUDPricelist){
                                system.debug('###currentUser 3');
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'BRL' && pricelist.Name == label.BRLPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'CAD' && pricelist.Name == label.CanadaPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'CHF' && pricelist.Name == label.CHFPricelist){
                                system.debug('###currentUser 3');
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'EUR' && pricelist.Name == label.EURPricelist){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            } 
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'HKD' && pricelist.Name == label.HKDPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }  
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'IDR' && pricelist.Name == label.IDRPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }                         
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'INR' && pricelist.Name == label.INRPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'JPY' && pricelist.Name == label.JPYPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'KRW' && pricelist.Name == label.KRWPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'MYR' && pricelist.Name == label.MYRPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'NZD' && pricelist.Name == label.NZDPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'SGD' && pricelist.Name == label.SGDPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                            else if(opty.Source_System_Detail__r.Billing_Currency__c == 'TWD' && pricelist.Name == label.TWDPriceList){
                              proposal.Apttus_QPConfig__PriceListId__c = pricelist.Id; 
                              proposal.CurrencyISOCode = opty.Source_System_Detail__r.Billing_Currency__c; 
                            }
                           }
                        }
                    }
                    if(System.Label.Risk_Sales_Orgs.contains(opty.Source_System_Detail__r.LCRM_Sales_Org__c)){
                        if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'LLEY'){
                            proposal.APTS_Proposal_Business_Unit__c = 'Argentina-LLEY';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'TSL'){
                            proposal.APTS_Proposal_Business_Unit__c = 'Brazil-TSL';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'SMHK'){
                            proposal.APTS_Proposal_Business_Unit__c = 'Hong Kong-SMHK';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'INWL'){
                            proposal.APTS_Proposal_Business_Unit__c = 'India-INWL';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'LRA'){
                            proposal.APTS_Proposal_Business_Unit__c = 'Australia-PNG-LRA';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'BKRS'){
                            proposal.APTS_Proposal_Business_Unit__c = 'NZ-Fiji-BKRS';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'FACT'){
                            proposal.APTS_Proposal_Business_Unit__c = 'FACT-TRFR';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == '1S-Russia'){
                            proposal.APTS_Proposal_Business_Unit__c = 'Russia-1S';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'Duzon'){
                            proposal.APTS_Proposal_Business_Unit__c = 'SouthKorea-DUZON';
                        }else if(opty.Source_System_Detail__r.LCRM_Sales_Org__c == 'SMGE'){
                            proposal.APTS_Proposal_Business_Unit__c = 'SMGE';
                        }
                    }*/
                }

            }
        }
    }

    // This method defaults the Bill To and Ship To the Sold To if they are empty.
    public static void updateBillToAndShipTo(List < Apttus_Proposal__Proposal__c > proposals) {
        //Added If Condition as part of SOC-6701--Zakeer
        if (checkRecursive.runpropsaltrgr_propsaltrgr_updatebilltoshiptoOnce()) {
            for (Apttus_Proposal__Proposal__c proposal: proposals) {

                if (proposal.APTS_SSD_bill_to__c == null){
                    proposal.APTS_SSD_bill_to__c = proposal.APTS_SSD_Sold_To__c;}

                if (proposal.APTS_SSD_ship_to__c == null){
                    proposal.APTS_SSD_ship_to__c = proposal.APTS_SSD_Sold_To__c;}
            }
        }
    }

    // This method updates the opportunity stage
    public static void updateOpportunityStage(Map < Id, Apttus_Proposal__Proposal__c > mapOldProposals, List < Apttus_Proposal__Proposal__c > listNewProposals, Map < Id, Apttus_Proposal__Proposal__c > mapNewProposals) {
        //Added if condition as part of merging findlaw changes
        if (checkRecursive.runpropsaltrgr_updateOpportunityStageOnce()) {
            // create a list of opportunities
            List < Id > opptys = new List < Id > ();
            Set < Id > generatedQuoteOpptys = new Set < Id > ();
            Set < Id > presentedQuoteOpptys = new Set < Id > ();
            Set < Id > acceptedQuoteOpptys = new Set < Id > ();
            Set < Id > generatedTaxQuoteOpptys = new Set < Id > ();
            Set < Id > presentedTaxQuoteOpptys = new Set < Id > ();
            Set < Id > acceptedTaxQuoteOpptys = new Set < Id > ();
            Set < Id > completedTaxQuoteOpptys = new Set < Id > ();
            Set < Id > discardedTaxQuoteOpptys = new Set < Id > ();
            Set < Id > approvedTaxQuoteOpptys = new Set < Id > ();
            Set < Id > cancelledTaxQuoteOpptys = new Set < Id > (); // DOC-8284

            Set < Id > taxProfOpty = new Set < Id > ();
            Map < Id, String > mapWLReason = new Map < Id, String > ();
            Map < Id, String > mapWLValue = new Map < Id, String > (); //Added as part DOC-8896 - Jinal Bhatt
            //map<Id, decimal> mapPricingOpptys = new map<Id, decimal>();//merging findlaw changes

            for (Apttus_Proposal__Proposal__c prop: listNewProposals) {
                if (prop.APTS_Proposal_Business_Unit__c != 'Tax Professional') {
                    if (prop.Apttus_Proposal__Approval_Stage__c == 'Generated' && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        generatedQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                    } else if (prop.Apttus_Proposal__Approval_Stage__c == 'Presented' && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        presentedQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                    } else if (prop.Apttus_Proposal__Approval_Stage__c == 'Accepted' && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        acceptedQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                        // DLT-7917 - update opp and opp pricing with Incremental value
                        // DLT-8819 - Do not update Opp Pricing if this is a manual Proposal
                        // DLT-9762 - GLI Update- Remove Opp Pricing 
                        //if (prop.Digital_Quote_type__c != 'Straight Renewal' && prop.Digital_Quote_type__c != 'Manual' && prop.is_Digital_Channel__c == true) {
                        //    mapPricingOpptys.put(prop.Apttus_Proposal__Opportunity__c, prop.APTS_Incremental__c);   
                        //} 
                    }

                    //Start: DOC-8896: Jinal Bhatt
                    if (prop.Apttus_Proposal__Approval_Stage__c == 'Accepted') {
                        mapWLReason.put(prop.Apttus_Proposal__Opportunity__c, prop.Latam_APTS_Reason__c);
                        mapWLValue.put(prop.Apttus_Proposal__Opportunity__c, prop.Latam_APTS_Win_Loss__c);
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                    }
                    System.debug('mapWLReason --> ' + mapWLReason + 'mapWLValue -->' + mapWLValue);
                    //End DOC-8896
                }

                if (prop.APTS_Proposal_Business_Unit__c == 'Tax Professional') {
                    taxProfOpty.add(prop.Apttus_Proposal__Opportunity__c);
                    system.debug('Tax Professional Opty : ' + taxProfOpty);
                    if ((mapOldProposals.get(prop.Id).Latam_APTS_Reason__c != prop.Latam_APTS_Reason__c && prop.SAP_Credit_Check_Status__c == null) ||
                        (prop.SAP_Credit_Check_Status__c != null && !prop.SAP_Credit_Check_Status__c.equalsIgnoreCase('Fail')))
                    //And Conditions added by Khushboo Vaidya as part of DOC-10300 
                    {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        mapWLReason.put(prop.Apttus_Proposal__Opportunity__c, prop.Latam_APTS_Reason__c);
                        System.debug('$$PS Entry in opptys' + opptys);
                        System.debug('$$PS Entry in wl Reason Map' + mapWLReason);
                    }
                    /* Author : Roma
       DOC 6659: TAX Professional Update Oppty Stage from Quote
       Date: 21 Aug 2019
   */
                    if (prop.Apttus_Proposal__Approval_Stage__c == 'Generated' && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        generatedTaxQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                    }
                    if (prop.Apttus_Proposal__Approval_Stage__c == 'Presented' && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        presentedTaxQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                    }
                    if ((prop.Apttus_Proposal__Approval_Stage__c == 'Accepted' || prop.Apttus_Proposal__Approval_Stage__c == 'Rejected') && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        acceptedTaxQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                        //mapWLReason.put(prop.Apttus_Proposal__Opportunity__c, prop.Latam_APTS_Reason__c);
                    }
                    if (prop.Apttus_Proposal__Approval_Stage__c == 'Completed' && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        completedTaxQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                        System.debug('TAX Oppty Stage TEST IF Block' + prop.Apttus_Proposal__Approval_Stage__c + 'SSSS' + completedTaxQuoteOpptys);
                    }
                    if (prop.Apttus_Proposal__Approval_Stage__c == 'Cancelled' && prop.Apttus_Proposal__Primary__c == true &&
                        ((prop.SAP_Credit_Check_Status__c != null && !prop.SAP_Credit_Check_Status__c.equalsIgnoreCase('Fail')) ||
                            (prop.SAP_Credit_Check_Status__c == null)))
                    //And Conditions added by Khushboo Vaidya as part of DOC-10300 
                    {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        cancelledTaxQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                    }
                    if ((prop.Apttus_Proposal__Approval_Stage__c == 'Discarded' || prop.Apttus_Proposal__Approval_Stage__c == 'Expired') && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        discardedTaxQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                    }
                    if ((prop.Apttus_Proposal__Approval_Stage__c == 'Denied' || prop.Apttus_Proposal__Approval_Stage__c == 'Approved' || prop.Apttus_Proposal__Approval_Stage__c == 'Approval Required' || prop.Apttus_Proposal__Approval_Stage__c == 'In Review') && prop.Apttus_Proposal__Primary__c == true) {
                        opptys.add(prop.Apttus_Proposal__Opportunity__c);
                        approvedTaxQuoteOpptys.add(prop.Apttus_Proposal__Opportunity__c);
                    }
                }
            }

            if (opptys.isEmpty()){ 
            return;}

            String oppWinLossValue = 'Won';
            String oppCompetitorValue = 'Unknown';
            String oppReasonValue = 'Other';

            if (keyvalueliststore__c.getValues('AptsOpportunityWinLoss') != null){
                oppWinLossValue = keyvalueliststore__c.getValues('AptsOpportunityWinLoss').TextValue__c;}
            if (keyvalueliststore__c.getValues('AptsOpportunityCompetitor') != null){
                oppCompetitorValue = keyvalueliststore__c.getValues('AptsOpportunityCompetitor').TextValue__c;}
            if (keyvalueliststore__c.getValues('AptsOpportunityReason') != null){
                oppReasonValue = keyvalueliststore__c.getValues('AptsOpportunityReason').TextValue__c;}

            List < Opportunity > oppUpdateList = new List < Opportunity > (); //SOC-8266 August Release
            //get list of opportunity records that match the ids.
            if (opptys != Null && opptys.size() > 0) {
                //List<Opportunity> oppList = [SELECT stageName,isDigitalSpearHead__c, Total_Renewal__c, Total_Incremental__c FROM opportunity WHERE id IN :opptys];
                //for (Opportunity opp:oppList){
                // DLT-8142 - Get the new Digital Firm field from the Account - Poonam
                //Removed field Account.Digital_Firm__c during 
                List < Opportunity > oppList;
                if (Schema.sObjectType.opportunity.isAccessible()){
                    oppList = [SELECT stageName, Reason__c, Was_There_a_Competitor__c, isDigitalSpearHead__c, Total_Renewal__c, Total_Incremental__c, Account.Digital_Firm__c, Win_Loss__c FROM opportunity WHERE id IN: opptys];}

                // DLT-3259 - For Digital Proposals do NOT update the Opportuntiy Stage if it is Presented and 5%
                // and do NOT update the Opportunity Stage if it is Accepted and 100%
                for (Opportunity opp: oppList) {

                    system.debug('Opp stage inside for loop... ' + opp.stageName);

                    //Roma:Development Tax Prof DOC 6659 Starts
                    if (generatedTaxQuoteOpptys != null && generatedTaxQuoteOpptys.contains(opp.Id)) {
                        opp.stageName = 'Generate Contract';

                    } else if (presentedTaxQuoteOpptys != null && presentedTaxQuoteOpptys.contains(opp.Id)) {
                        opp.stageName = 'Negotiate Contract';

                    } else if (acceptedTaxQuoteOpptys != null && acceptedTaxQuoteOpptys.contains(opp.Id) && opp.stageName != 'Order Complete') {
                        opp.stageName = 'Contract Signed';
                    } else if (completedTaxQuoteOpptys != null && completedTaxQuoteOpptys.contains(opp.Id)) {
                        opp.stageName = 'Order Complete';
                        System.debug('TAX Oppty Stage TEST IF Block' + opp.stageName + 'SSSS' + completedTaxQuoteOpptys);

                    }
                    //DOC-8284
                    else if (cancelledTaxQuoteOpptys != null && cancelledTaxQuoteOpptys.contains(opp.id)) {
                        opp.stageName = 'Closed Lost';
                        opp.Was_There_a_Competitor__c = 'NO';
                    } else if (discardedTaxQuoteOpptys != null && discardedTaxQuoteOpptys.contains(opp.Id)) {
                        opp.stageName = 'Closed Lost';
                        //opp.Reason__c = 'Billing System Cancellation';   //DOC-8284
                        opp.Was_There_a_Competitor__c = 'No';

                    } else if (approvedTaxQuoteOpptys != null && approvedTaxQuoteOpptys.contains(opp.Id)) {
                        opp.stageName = 'Solution Recommended';
                    }
                    //Roma: Development Tax Prof DOC 6659 Ends
                    if (mapWLReason != null && mapWLReason.containsKey(opp.Id)) {
                        opp.Reason__c = mapWLReason.get(opp.Id);
                        system.debug('2222Reason Value :' + opp.Reason__c);
                    }
                    //Start:DOC-8896: Jinal Bhatt
                    if (mapWLValue != null && mapWLValue.containsKey(opp.Id)) {
                        opp.Win_Loss__c = mapWLValue.get(opp.Id);
                        system.debug('mapWLValue' + opp.Win_Loss__c + 'mapWLValue-->' + mapWLValue);
                    }
                    //End DOC-8896
                    if (opp.stageName != 'Order Complete') {
                        // DLT-8142 - Exclude Corporate accounts from updating Opp Pricing - Poonam
                        // DLT-9762 - GLI Update- Remove Opp Pricing 
                        //if (mapPricingOpptys.get(opp.id) != null && opp.Account.Digital_Firm__c == 'Corporate') {   
                        //    mapPricingOpptys.remove(opp.id);  
                        //}
                        if (generatedQuoteOpptys.contains(opp.Id)) {
                            if ((opp.stageName == 'Qualifying') || (opp.stageName == 'Appointment Scheduled') || (opp.stageName == 'Needs Analysis') || (opp.stageName == 'Solution Recommended')){
                                //if ((opp.stageName == '5%') || (opp.stageName == '10%') || (opp.stageName == '25%') || (opp.stageName == '50%'))
                                opp.stageName = 'Generate Contract';}
                            //opp.stageName = '75%';
                        } else if (presentedQuoteOpptys.contains(opp.Id)) {
                            if ((opp.stageName == 'Qualifying') || (opp.stageName == 'Appointment Scheduled') || (opp.stageName == 'Needs Analysis') || (opp.stageName == 'Solution Recommended') || (opp.stageName == 'Generate Contract')){
                                //if ((opp.stageName == '5%') || (opp.stageName == '10%') || (opp.stageName == '25%') || (opp.stageName == '50%') || (opp.stageName == '75%'))
                                opp.stageName = 'Negotiate Contract';}
                            //opp.stageName = '90%';
                        } else if (acceptedQuoteOpptys.contains(opp.Id)) {
                            opp.stageName = 'Contract Signed';
                            //opp.stageName = '95%';
                            /* Removed as per the DLT-19222     
                                if(!(opp.StageName == 'Order Complete' && opp.isDigitalSpearHead__c == true)) {
                                            opp.stageName = 'Contract Signed';
                                          opp.Win_Loss__c = oppWinLossValue;
                                          opp.Reason__c = oppReasonValue;
                                          opp.Was_There_a_Competitor__c = oppCompetitorValue;
                                }
                            DLT-19222 End */
                            // DLT-7917 update the Opportunity when an up-sell proposals has been accepted
                            // DLT-9762 - GLI Update- Remove Opp Pricing 
                            //if (mapPricingOpptys.get(opp.id) != null) {   
                            //system.debug('Updating Opp: ' + opp.id + ' Quote Inc Amt: ' + mapPricingOpptys.get(opp.id) + ' Quote Renewal Amt: ' + opp.Total_Renewal__c);
                            //    opp.Total_Incremental__c = mapPricingOpptys.get(opp.id) - opp.Total_Renewal__c;
                            //}
                        }
                        // oppUpdateList.add(opp); //SOC-8266 August Release
                    }

                    oppUpdateList.add(opp); //SOC-8266 August Release
                } //SOC-8266 August Release
                if (!oppUpdateList.isEmpty() && Schema.sObjectType.Opportunity.isUpdateable()){
                    try{
                        update oppUpdateList;
                    }catch(Exception e){System.debug('Exception : '+e.getMessage()+' : '+e.getStackTraceString());}
                }
            }
            //SOC-8266 August Release

            // DLT-9762 - GLI Update- Remove Opp Pricing
            /* 
            List<Opportunity_Product_Type__c> opt = new List<Opportunity_Product_Type__c>(); 
            // DLT-7917 update the Opportunity Pricing records for each opp
            if(opptys != Null && opptys.size() > 0) {
                  list<Opportunity_Product_Type__c> listOppPricing = [Select id, Incremental_Amount__c, Renewal_Amount__c, Opportunity__c,Opportunity__r.stageName from Opportunity_Product_Type__c 
                                  where Opportunity__c in : opptys];                  
                  if(listOppPricing != null && listOppPricing.size() > 0) {
                      for(Opportunity_Product_Type__c oOppRecord : listOppPricing) {
                          system.debug('Creating Opp Pricing Record for Opp: ' + oOppRecord.ID);
                          system.debug('Inside if Opportunity__r.stageName...'+oOppRecord.Opportunity__r.stageName);
                          if(oOppRecord.Opportunity__r.stageName != 'Order Complete'){
                          if (mapPricingOpptys.get(oOppRecord.Opportunity__c) != null) {   
                              system.debug('Updating Opp: ' + oOppRecord.Opportunity__c + ' Quote Inc Amt: ' + mapPricingOpptys.get(oOppRecord.Opportunity__c) + ' Opp Pricing Renewal Amt: ' + oOppRecord.Renewal_Amount__c);  
                              oOppRecord.Incremental_Amount__c = mapPricingOpptys.get(oOppRecord.Opportunity__c) - oOppRecord.Renewal_Amount__c;
                          }
                opt.add(oOppRecord); 
                      }
                      }    
                  if(!opt.isEmpty())    
                      update opt;
                  }
            }   // end of processing Opportunity Pricing records   
            */

        }


    }

    //Merging code as part of SOC-6701 Start --ZAkeer
    //This method updates Online contact validation flag when quote is clonned- SOC-3915    
    public static void updateAPTSOnlineContactsValidation(Map < Id, Apttus_Proposal__Proposal__c > mapOldProposals, List < Apttus_Proposal__Proposal__c > listNewProposals, Map < Id, Apttus_Proposal__Proposal__c > mapNewProposals) {
        system.debug('Inside updateAPTSOnlineContactsValidation method STARTS');
        Set < Id > proposalIds = new Set < Id > ();
        for (Apttus_Proposal__Proposal__c proposal: listNewProposals) {
            proposalIds.add(proposal.id);
        }
        List < Apttus_Proposal__Proposal_Line_Item__c > lineItems;
        if (Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible()){
            lineItems = new List < Apttus_Proposal__Proposal_Line_Item__c > ([SELECT id, APTS_Online_Contacts_Validation__c, Apttus_Proposal__Proposal__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c IN: proposalIds]);}
        if (lineItems.size() > 0) {
            for (Apttus_Proposal__Proposal_Line_Item__c lineItem: lineItems) {
                if (lineItem.APTS_Online_Contacts_Validation__c == true){
                    system.debug('Inside updateAPTSOnlineContactsValidation method IF');
                lineItem.APTS_Online_Contacts_Validation__c = false;}
            }
        }
        if (Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isupdateable()){
            update lineItems;}
        system.debug('Inside updateAPTSOnlineContactsValidation method ENDS');

    }
    //SOC-6701 End     
    // This method updates the approval segment

    /*Merged if condition as part of  SOC-6701--Zakeer
   
   if(checkRecursive.runpropsaltrgr_updateApprovalSegmentOnce())
        if(prop.Digital_Quote_Automation__c != TRUE)
        if(propIds != Null && propIds.size() > 0)  End*/

    // This method updates the approval segment
    public static void updateApprovalSegment(Map < Id, Apttus_Proposal__Proposal__c > mapOldProposals, List < Apttus_Proposal__Proposal__c > listNewProposals, Map < Id, Apttus_Proposal__Proposal__c > mapNewProposals) {

        if (checkRecursive.runpropsaltrgr_updateApprovalSegmentOnce()) {
            Set < Id > propIds = new Set < Id > ();

            for (Apttus_Proposal__Proposal__c prop: listNewProposals) {
                if (prop.Digital_Quote_Automation__c != TRUE){
                    propIds.add(prop.id);}
            }
            if (propIds != Null && propIds.size() > 0 && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
                List < Apttus_Proposal__Proposal__c > newRecs = new List < Apttus_Proposal__Proposal__c > ([SELECT id, APTS_Approval_Segment__c, APTS_Approval_Segment_Default__c FROM Apttus_Proposal__Proposal__c WHERE id IN: propIds]);
                for (Apttus_Proposal__Proposal__c proposal: newRecs) {
                    System.debug('Segment Field Value ' + proposal.APTS_Approval_Segment__c);
                    if (proposal.APTS_Approval_Segment__c == null){
                        proposal.APTS_Approval_Segment__c = proposal.APTS_Approval_Segment_Default__c;}
                    System.debug('Inside IF' + proposal.APTS_Approval_Segment__c + 'segment default ' + proposal.APTS_Approval_Segment_Default__c);
                }
                // if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isupdateable()) 
                // update newRecs;
            }
        }
    }

    //This method defaults the Approval segment based on the SP Frozen Market Segment
    public static void defaultApprovalSegment(List < Apttus_Proposal__Proposal__c > newProposals) {
        /*
              Set<Id> acctIds = new Set<Id>();
              List<Apttus_Proposal__Proposal__c> filteredProp = new List<Apttus_Proposal__Proposal__c>();
              for(Apttus_Proposal__Proposal__c prop : newProposals){
                if(prop.Apttus_Proposal__Account__c!=null){
                  filteredProp.add(prop);
                  acctIds.add(prop.Apttus_Proposal__Account__c);
                }
              }
              if(!acctIds.isEmpty()){
                Map<Id, Account> accts = new Map<Id, Account>([SELECT FrozenMarketSegment__c FROM Account WHERE Id IN: acctIDs]);
                List<APTS_FMS_to_ApprovalSeg__c> fmsToApprovalSeg = APTS_FMS_to_ApprovalSeg__c.getAll().values();
                Set<String> helper;
                for(Apttus_Proposal__Proposal__c prop : filteredProp){
                  Account a = accts.get(prop.Apttus_Proposal__Account__c);
                  boolean isTBD = true;
                  for(APTS_FMS_to_ApprovalSeg__c fmsToAppr : fmsToApprovalSeg){
                    helper = new Set<String>(fmsToAppr.Field_Names__c.split(','));
                    if(helper.contains(a.FrozenMarketSegment__c)){
                      isTBD = false;
                      prop.APTS_Approval_Segment__c = fmsToAppr.Name;
                    }
                  }
                  if(isTBD)
                    prop.APTS_Approval_Segment__c = null;
                }
              }*/
              system.debug('Empty Block');
    }

    //This method updates Ship to and Bill to fields based on Partner's field      Added by Chirag 8/25/16
    /*Merged If condition as part of SOC-6701--Zakeer
    if(checkRecursive.runpropsaltrgr_updateAddressFeildsOnce()) */
    public static void updateAddressFeilds(List < Apttus_Proposal__Proposal__c > newProposals) {
        if (checkRecursive.runpropsaltrgr_updateAddressFeildsOnce()) {
            Set < Id > PartnerSet = new Set < Id > ();
            for (Apttus_Proposal__Proposal__c proposal: newProposals) {
                PartnerSet.add(proposal.APTS_Partner_Bill_To__c);
                PartnerSet.add(proposal.APTS_Partner_Ship_To__c);
            }
            //Reference to new related gli account instead of old Related_Account__c
            Map < Id, Business_Partner_Function__c > BizPartnerMap;
            If(Schema.sObjectType.Business_Partner_Function__c.isAccessible()){
            BizPartnerMap = new Map < Id, Business_Partner_Function__c > ([SELECT Id, Related_Account_GLI__c FROM Business_Partner_Function__c WHERE Id IN: PartnerSet]);}
            System.debug('BizPartnerMap____' + BizPartnerMap);


        }
    }

    /*
     //this function simulates the accept button in the proposal page -- need to be called only when the approval stage is updated by Docusign
     public static void createOrderAndAssetLineItems(Map<Id, Apttus_Proposal__Proposal__c> mapOldProposals, List<Apttus_Proposal__Proposal__c> listNewProposals, Map<Id, Apttus_Proposal__Proposal__c> mapNewProposals) {
        // create a list of proposals that moved from 'Generated' to 'Accepted'
        List<Id> props = new List<Id>();
          
        for(Apttus_Proposal__Proposal__c newRec : ListNewProposals) {
           Apttus_Proposal__Proposal__c oldRec = mapOldProposals.get(newRec.id);
           if ((newRec.Apttus_Proposal__Approval_Stage__c == 'Accepted') && (oldRec.Apttus_Proposal__Approval_Stage__c != 'Accepted'))
                //ID jobID = System.enqueueJob(new APTS_OrderAssetCreateQJob(newRec.id));
              props.add(newRec.id);
        }
        
        System.debug('props size = ' + props.size());
 
         List<Apttus_DocuApi__DocusignEnvelope__c> envList = [SELECT id,Apttus_QPDSign__QuoteProposal__c FROM Apttus_DocuApi__DocusignEnvelope__c WHERE Apttus_QPDSign__QuoteProposal__c IN :props];
         for (Apttus_DocuApi__DocusignEnvelope__c env:envList){
            System.debug('inside the for loop');
            System.debug('proposal=' + env.Apttus_QPDSign__QuoteProposal__c);
            ID jobID = System.enqueueJob(new APTS_OrderAssetCreateQJob(env.Apttus_QPDSign__QuoteProposal__c));
         }        
     }
     */

    //this function simulates the accept button in the proposal page -- need to be called only when the approval stage is updated by Docusign
    public static void createOrderAndAssetLineItems(Map < Id, Apttus_Proposal__Proposal__c > mapOldProposals, List < Apttus_Proposal__Proposal__c > listNewProposals, Map < Id, Apttus_Proposal__Proposal__c > mapNewProposals) {
        //Merged if condition code as part of SOC-6701--Zakeer
        //if (checkRecursive.runpropsaltrgr_createOrderAndAssetLineItemsOnce()) {
            // create a list of proposals that moved from 'Generated' to 'Accepted'
            List < Id > props = new List < Id > ();
            Set < Id > proposals = new Set < Id > ();
            List < Apttus_Proposal__Proposal__c > digitalProposals = new List < Apttus_Proposal__Proposal__c > (); //DLT-16077

            for (Apttus_Proposal__Proposal__c newRec: ListNewProposals) {
                Apttus_Proposal__Proposal__c oldRec = mapOldProposals.get(newRec.id);
                if ((newRec.Apttus_Proposal__Approval_Stage__c == 'Accepted') && (oldRec.Apttus_Proposal__Approval_Stage__c != 'Accepted')){
                    //ID jobID = System.enqueueJob(new APTS_OrderAssetCreateQJob(newRec.id));
                    props.add(newRec.id);}

                //DLT-16077 - Store CXD's Digital Quotes for CXD processing
                //DLT-15815 - Include CXD NSE quotes
                if ((newRec.is_Digital_Channel__c == TRUE || newRec.Is_Digital_New_Sales__c == true) && ((newRec.Apttus_Proposal__Approval_Stage__c == 'Accepted' && oldRec.Apttus_Proposal__Approval_Stage__c != 'Accepted') || (newRec.Apttus_Proposal__Approval_Stage__c == 'Denied' && oldRec.Apttus_Proposal__Approval_Stage__c != 'Denied'))) {
                    digitalProposals.add(newRec);
                    //optyIdSet.add(quote.Apttus_Proposal__Opportunity__c);    
                }
            }
            //DOC-16997
            if(!props.isEmpty() || !digitalProposals.isEmpty()) {
            if(checkRecursive.runpropsaltrgr_createOrderAndAssetLineItemsOnce()){
            System.debug('props size = ' + props.size());
            if (props != Null && props.size() > 0 && Schema.sObjectType.Apttus_DocuApi__DocusignEnvelope__c.isAccessible()) {
                //List<Apttus_DocuApi__DocusignEnvelope__c> envList = [SELECT id,Apttus_QPDSign__QuoteProposal__c FROM Apttus_DocuApi__DocusignEnvelope__c WHERE Apttus_QPDSign__QuoteProposal__c IN :props];    //Commented by CG SOC-4974 8/18/2017
                List < Apttus_DocuApi__DocusignEnvelope__c > envList = [SELECT Id, Apttus_QPDSign__QuoteProposal__c
                    FROM Apttus_DocuApi__DocusignEnvelope__c
                    WHERE Apttus_QPDSign__QuoteProposal__c IN: props
                    AND Apttus_DocuApi__Status__c != 'voided'
                    AND Apttus_QPDSign__QuoteProposal__r.APTS_Wet_Signature__c != TRUE //Merged where condition as part of SOC-6701--Zakeer
                    AND Apttus_QPDSign__QuoteProposal__r.APTS_Assent_DateTime__c = NULL //added by bijeta for soc-5134
                    AND Apttus_QPDSign__QuoteProposal__r.APTS_Assent_Name_of_Rep__c = NULL
                    AND Apttus_QPDSign__QuoteProposal__r.APTS_Assent_Customer_Name__c = NULL
                ]; //Added by CG SOC-4974 8/18/2017];    //Added by CG SOC-4974 8/18/2017 

                for (Apttus_DocuApi__DocusignEnvelope__c env: envList) {
                    System.debug('inside the for loop');
                    System.debug('proposal=' + env.Apttus_QPDSign__QuoteProposal__c);
                    proposals.add(env.Apttus_QPDSign__QuoteProposal__c);
                    //ID jobID = System.enqueueJob(new APTS_OrderAssetCreateQJob(env.Apttus_QPDSign__QuoteProposal__c));
                }
                //Added for SOC-9607 by Priyanka
                List < Apttus_Proposal__Proposal__c > propToUpdate = new List < Apttus_Proposal__Proposal__c > ();
                if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
                    propToUpdate = [Select id, DocusignOrderAssetFlag__c from Apttus_Proposal__Proposal__c where ID IN: proposals];}
                for (Apttus_Proposal__Proposal__c prop: propToUpdate) {

                    prop.DocusignOrderAssetFlag__c = true;

                }
                if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                    update propToUpdate;}
                //Added for SOC-9607 by Priyanka ends
                system.debug(proposals.size());
                //SOC-4017 adding condition to stop execution repeatedly
                if (Docusignjob == false) {
                    Docusignjob = true;
                    //if (proposals.size() > 0)
                    //ID jobID = System.enqueueJob(new APTS_OrderAssetCreateQJob(proposals));
                    //SOC-9607
                    //Database.executeBatch(new APTS_CreateOrderAssetJob(proposals),1);
                }
            }

            //DLT-16077 Call CXD quote expiration method
            try {
                Digital_SecondaryQuoteExpiration(digitalProposals);
            } catch (exception ex) {
                System.debug('Digital_SecondaryQuoteExpiration() method error:' + ex);
            }
          }
         }
        //}
    }
    // This method set Temp Order Confirmation Contact field 
    public static void updateTmpOrderConfirmationContact(List < Apttus_Proposal__Proposal__c > proposals) {
        if (checkRecursive.runpropsaltrgr_updateTmpOrderConfirmationContactOnce()) { //Merged below if condition as part os SOC-6701--Zakeer
            set < Id > accIds = new set < Id > ();
            for (Apttus_Proposal__Proposal__c proposal: proposals) {
                if (proposal.Digital_Quote_Automation__c != TRUE){ //Merged below if condition as part os SOC-6701--Zakeer
                    accIds.add(proposal.Apttus_Proposal__Account__c);}
            }

            //Added by gowthami as part of OC-GLI for too many rows SOQL error
            //Modified by Keerthana to add one more filter LCRM_Is_GLI__c in this query to remove too many rows errror as part of CRM-10885
            Map < Id, Contact > accContacts;
            if (Schema.sObjectType.Contact.isAccessible()){
                accContacts = new Map < Id, Contact > ([SELECT AccountId, Id, Name FROM Contact WHERE AccountId IN: accIds and LCRM_Is_GLI__c = true Limit 999]);}
            /*for(Contact con : accContact.values()){
                if(!accContact.containsKey(con.AccountId)){
                    accContact.put(con.AccountId, con);
                }
            }*/

            for (Apttus_Proposal__Proposal__c proposal: proposals) {
                //proposal.APTS_has_line_items__c = false;
                if (proposal.APTS_Order_Confirmation_Contact__c != NULL) {
                    proposal.APTS_Temp_Order_Confirmation_Contact__c = proposal.APTS_Order_Confirmation_Contact__c;
                } else {
                    if (accContacts.containsKey(proposal.Apttus_Proposal__Account__c) && accContacts.get(proposal.Apttus_Proposal__Account__c) != NULL){
                        proposal.APTS_Temp_Order_Confirmation_Contact__c = accContacts.get(proposal.Apttus_Proposal__Account__c).Id;}
                }
            }
        }
    }
    /* Author - Dinesh Kumar Voonna 
        Purpose - Once User renews the Quote, Expires the second Quote If any 
        Project - CX Digital MVP-A Sprint 1
        Created Date - 15 May 2017
        jira Number - DLT-283
 
        Updated by Benjamin Her - 22-04-2019 - DLT-16077 Updated method to be called from createOrderAndAssetLineItems()
    */

    public static void digital_secondaryQuoteExpiration(List < Apttus_Proposal__Proposal__c > listNewProposals) {

        if (checkRecursive.runpropsaltrgr_Digital_SecondaryQuoteExpirationOnce()) { //Merged if condition as part of SOC-6701--Zakeer
            List < String > quoteExpirationValueList;
            Set < Id > optyIdSet = new Set < Id > ();
            Map < Id, List < Apttus_Proposal__Proposal__c >> OptyQuoteListMap = new Map < Id, List < Apttus_Proposal__Proposal__c >> ();
            List < Apttus_Proposal__Proposal__c > FinalExpiredQuoteList = new list < Apttus_Proposal__Proposal__c > ();
            Database.SaveResult[] lsr;
            list < Digital_Exception_Log__c > exList = new list < Digital_Exception_Log__c > ();

            if (listNewProposals.size() > 0 && listNewProposals != Null) {
                for (Apttus_Proposal__Proposal__c quote: listNewProposals) {
                    //Apttus_Proposal__Proposal__c oldQuote = mapOldProposals.get(quote.id);
                    system.debug('>>>' + quote.is_Digital_Channel__c);
                    System.debug('>>>2' + quote.Apttus_Proposal__Opportunity__c);

                    //DLT-16077 Updated criteria for IF statement
                    //DLT-15815 Updated criteria for CXD NSE
                    if ((quote.is_Digital_Channel__c == TRUE || quote.Is_Digital_New_Sales__c == true) && (quote.Apttus_Proposal__Approval_Stage__c == 'Accepted' || quote.Apttus_Proposal__Approval_Stage__c == 'Denied')) {
                        optyIdSet.add(quote.Apttus_Proposal__Opportunity__c);
                    }
                }
                if (optyIdSet != null && optyIdSet.size() > 0 && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) { //Merged if condition as part of SOC-6701--Zakeer
                    for (Apttus_Proposal__Proposal__c FinalQuoteList: [select id, Apttus_Proposal__Approval_Stage__c, Apttus_Proposal__Primary__c, Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c IN: optyIdSet]) {

                        if (OptyQuoteListMap.containskey(FinalQuoteList.Apttus_Proposal__Opportunity__c)) {
                            List < Apttus_Proposal__Proposal__c > QuoteList = OptyQuoteListMap.get(FinalQuoteList.Apttus_Proposal__Opportunity__c);
                            QuoteList.add(FinalQuoteList);
                            OptyQuoteListMap.put(FinalQuoteList.Apttus_Proposal__Opportunity__c, QuoteList);
                        } else {
                            OptyQuoteListMap.put(FinalQuoteList.Apttus_Proposal__Opportunity__c, new List < Apttus_Proposal__Proposal__c > {
                                FinalQuoteList
                            });
                        }
                    }
                }
                if (OptyQuoteListMap.keyset() != null && OptyQuoteListMap.keyset().size() > 0) {
                    for (Id oId: OptyQuoteListMap.keyset()) {
                        if (OptyQuoteListMap.get(oId).size() > 1) {
                            for (Apttus_Proposal__Proposal__c quote: OptyQuoteListMap.get(oId)) {
                                if (quote.Apttus_Proposal__Approval_Stage__c != 'Accepted' && quote.Apttus_Proposal__Approval_Stage__c != 'Denied' && quote.Apttus_Proposal__Approval_Stage__c != 'Expired') {
                                    Apttus_Proposal__Proposal__c secondaryQuotes = new Apttus_Proposal__Proposal__c();
                                    secondaryQuotes.id = quote.id;
                                    secondaryQuotes.Apttus_Proposal__Approval_Stage__c = 'Expired';
                                    //secondaryQuotes.Apttus_Proposal__Primary__c = FALSE;

                                    FinalExpiredQuoteList.add(secondaryQuotes);
                                }
                            }
                        }
                    }
                }
            }

            if (FinalExpiredQuoteList.size() > 0 && FinalExpiredQuoteList != Null) {
                lsr = Database.update(FinalExpiredQuoteList, False);
                if (lsr != Null && lsr.size() > 0) {
                    for (Integer i = 0; i < lsr.size(); i++) {
                        if (!lsr.get(i).isSuccess()) {
                            // DML operation failed
                            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
                            Database.Error error = lsr.get(i).getErrors().get(0);
                            String failedDML = error.getMessage();
                            ex.Exception_Message__c = failedDML;
                            ex.Exception_Type__c = 'Quote/Proposal Expired Updation - QuoteId - ' + FinalExpiredQuoteList.get(i).Id; //failed record from the list
                            for (string errorField: error.getfields()) {
                                ex.Additional_Information__c += errorField + ',';
                            }
                            ex.User_Message__c = String.Valueof(error.getStatusCode());
                            ex.Class_Reference__c = 'APTS_ProposalTriggerHelper > Digital_SecondaryQuoteExpiration';
                            exList.add(ex);
                        }
                    }
                }
                if (exList != Null && exList.size() > 0 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()) {
                    try {
                        insert exList;
                    }
                    Catch(Exception e) {
                        System.debug('Exception Quotes/Proposals' + e);
                    }
                }

            }
        }
    }

    // New method to update quote/proposal fields for the CX Digital project
    // 2017-07-24  Brenda Shields  DLT-1848 
    // 2017-12-01  Brenda Shields  DLT-6453 - Expire voided envelopes
    // 2018-02-16  Brenda Shields  DLT-7772 - For Declined envelopes, set the SFDC status to Denied
    //Merged this method code as per the SOC-6701 Start--Zakeer
    // 2018-07-27  Brenda Sheilds  DLT-11413 - adding back code from Production that was missed during GLI
    //DLT-15815 Include CXD NSE quotes for processing
    public static void digitalUpdateToProposal(List < Apttus_Proposal__Proposal__c > proposals) {
        //if(checkRecursive.runpropsaltrgr_DigitalUpdateToProposalOnce()){ 
        //get list of proposal ids and then get the DocuSign envelope records
        Map < Id, string > envIdMap = new Map < Id, string > ();
        Map < Id, string > envStatusMap = new Map < Id, string > ();
        Map < Id, string > envReasonMap = new Map < Id, string > ();
        string strEnvelopeId;
        string strEnvelopeStatus;
        string strEnvelopeReason;
        List < Id > proposalIds = new List < Id > ();
        for (Apttus_Proposal__Proposal__c proposal: proposals) {
            if (proposal.is_Digital_Channel__c == true || proposal.Is_Digital_New_Sales__c == true) {
                proposalIds.add(proposal.id);
            }
        }
        List < Apttus_DocuApi__DocuSignEnvelope__c > envList = new List < Apttus_DocuApi__DocuSignEnvelope__c > ();
        if (Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isAccessible()){
            envList = [SELECT Id, Apttus_QPDSign__QuoteProposal__c, Apttus_DocuApi__EnvelopeId__c, Apttus_DocuApi__Status__c, APTTUS_DOCUAPI__RECALLREASON__C
                FROM Apttus_DocuApi__DocuSignEnvelope__c WHERE Apttus_QPDSign__QuoteProposal__c IN: proposalIds order by Apttus_DocuApi__ParentId__c, Apttus_QPDSign__QuoteProposal__c, createdDate ASC
            ];}
        if (envList.size() > 0) {
            for (Apttus_DocuApi__DocuSignEnvelope__c envStatusList: envList) {
                envStatusMap.put(envStatusList.Apttus_QPDSign__QuoteProposal__c, envStatusList.Apttus_DocuApi__Status__c);
                envReasonMap.put(envStatusList.Apttus_QPDSign__QuoteProposal__c, envStatusList.APTTUS_DOCUAPI__RECALLREASON__C);
                envIdMap.put(envStatusList.Apttus_QPDSign__QuoteProposal__c, envStatusList.Apttus_DocuApi__EnvelopeId__c);
            }
        }

        // update the propposals as needed
        for (Apttus_Proposal__Proposal__c proposal: proposals) {
            if (proposal.is_Digital_Channel__c == true || proposal.Is_Digital_New_Sales__c == true) {
                if (!envStatusMap.isEmpty() && envStatusMap.ContainsKey(proposal.Id)) {
                    strEnvelopeStatus = envStatusMap.get(proposal.Id);
                    strEnvelopeId = envIdMap.get(proposal.Id);
                    strEnvelopeReason = envReasonMap.get(proposal.Id);
                } else {
                    strEnvelopeStatus = '';
                    strEnvelopeId = '';
                    strEnvelopeReason = '';
                }
                system.debug('DocuSign Envelope - Quote id: ' + proposal.Id + ', Evn Status: ' + strEnvelopeStatus + ', Evn Id: ' + strEnvelopeId + ', Evn Reason: ' + strEnvelopeReason);
                system.debug('Proposal Info - Stage: ' + proposal.Apttus_Proposal__Approval_Stage__c + ', Proposal Evn id: ' + proposal.DocuSign_Envelope_ID__c);

                // check for udpate to approval stage - do not update manual proposals
                if (proposal.Digital_Quote_Type__c != 'Manual') {
                    if (proposal.Apttus_Proposal__Approval_Stage__c != 'Accepted' && strEnvelopeStatus == 'voided') {
                        if (strEnvelopeReason == '' || strEnvelopeReason == null || strEnvelopeReason == 'Envelope has expired.') {
                            // if the envelope is voided (Expired Process), then set the stage to expired
                            proposal.Apttus_Proposal__Approval_Stage__c = 'Expired';
                            system.debug('Updated to Expired');
                        } else {
                            // if the envelope is voided (Declined Process), then set the stage to Denied
                            proposal.Apttus_Proposal__Approval_Stage__c = 'Denied';
                            system.debug('Updated to Denied');
                        }
                    }
                }
                // if this was a manually created quote set the envelope id
                if (proposal.Apttus_Proposal__Approval_Stage__c == 'Presented' && strEnvelopeId != '' &&
                    (proposal.DocuSign_Envelope_ID__c == '' || proposal.DocuSign_Envelope_ID__c == null)) {
                    proposal.DocuSign_Envelope_ID__c = strEnvelopeId;
                    system.debug('Updated Envelope ID');
                }
                // if moving the stage to generated, remove the env id, so a new env will be created            
                if (proposal.Apttus_Proposal__Approval_Stage__c == 'Generated' && proposal.DocuSign_Envelope_ID__c != '' && strEnvelopeStatus != 'voided') {
                    proposal.DocuSign_Envelope_ID__c = '';
                    system.debug('Removed Envelope ID');
                }
            } // end of if Digital
        } // end of for all Proposals
    }
    //}//SOC-6701--End Zakeer


    //Merged Code as part of SOC-6701--Zakeer
    public static void updateLegalLanguage(List < Apttus_Proposal__Proposal__c > proposals) {
        if (checkRecursive.runFirstTime()) {
            List < Id > proposalIds = new List < Id > ();
            List < Apttus_Proposal__Proposal__c > proposalList = new List < Apttus_Proposal__Proposal__c > ();
            Set < Apttus_Proposal__Proposal__c > proposalSet = new Set < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > shortTermProposalList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > longTermProposalList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > renewalProposalList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > otherStatusProposalList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > priceqtynewList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > priceqtyrenewList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > myrnewList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > myrrenewList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > canprodList = new List < Apttus_Proposal__Proposal__c > ();
            List < Apttus_Proposal__Proposal__c > smallFirmList = new List < Apttus_Proposal__Proposal__c > (); //Added by Bijeta DOC-5386 Small Law Cluster : 
            List < APTS_Product_Legal_Language_FL_Settings__c > productLegalLanguageSettings = new List < APTS_Product_Legal_Language_FL_Settings__c > ();
            Map < String, Set < String >> productCodeLanguageMap = new Map < String, Set < String >> ();
            Map < String, Set < String >> productNameLanguageMap = new Map < String, Set < String >> ();
            Map < String, Set < String >> shortTermLanguageMap = new Map < String, Set < String >> ();
            Set < String > materialno = new Set < String > ();
            Id propId = null;
        string pickValues = '',brandvalue;
            Map < Id, string > firmsiteMap = new Map < Id, string > ();
        Integer updateCount,prodcount;
            Boolean isRenewal;
            Boolean isShortTerm;
            Boolean ispriceqtynew;
            Boolean ispriceqtyrenew;
            Boolean ismyrnew;
            Boolean ismyrrenew;
            Boolean iscanprod;
            Boolean isSmallFirm; //Added by Bijeta DOC-5386 Small Law Cluster
            Map < id, Boolean > naciMap = new Map < Id, Boolean > (); //Added by Poonam Garg for DOC 9821
        Map<Id,String> casebrandmap = new Map<id,String>();
            for (Apttus_Proposal__Proposal__c proposal: proposals) {
                proposalIds.add(proposal.id);
            }
            List < Apttus_Proposal__Proposal__c > proposallst;
            if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
                /*&& Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() 
                           && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.fields.Apttus_Proposal__Proposal__c.isAccessible())*/
        proposallst = [SELECT Id, Name,APTS_FL_Product_Language__c,APTS_NACI_Form__c,APTS_Boolean_Short_Term_Trials__c,APTS_FL_Renewal_OnlyFlag__c,APTS_Proposal_Business_Unit__c,APTS_Payment_Option__c,currencyIsoCode,APTS_Case_Brand_Value__c, (SELECT Id,Apttus_Proposal__Product__r.Name,Apttus_QPConfig__PriceType__c,Apttus_QPConfig__ChargeType__c,APTS_Proposal_Business_Unit__c, APTS_Contract_Term__c,Apttus_Proposal__Product__r.ProductCode,Apttus_QPConfig__OptionId__r.ProductCode,Apttus_Proposal__Proposal_Line_Item__c.Apttus_Proposal__Proposal__c,Apttus_QPConfig__LineStatus__c,Apttus_QPConfig__LineType__c, Name,Apttus_Proposal__Proposal_Line_Item__c.APTS_Renewal_Type__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Item_Category_Group__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Media_High_Level_Code__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Media_Lower_Level_Code__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Availability_Date__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_WLEC_Product_Category__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Term_Type__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Contract_Term_Number__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Product_Pricing_Model__c,APTS_FL_Renewal_Only_Clone__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Pricing_Quantity__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Calculated_Year_2__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Calculated_Year_3__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Calculated_Year_4__c,Apttus_Proposal__Proposal_Line_Item__c.APTS_Calculated_Year_5__c,Apttus_QPConfig__Frequency__c,Apttus_Proposal__Proposal__r.APTS_Payment_Option__c,Apttus_QPConfig__NetPrice__c,Apttus_Proposal__Product__r.Product_Level_2__c  FROM R00N70000001yUfBEAU) FROM Apttus_Proposal__Proposal__c WHERE id IN :proposalIds]; //Removed SECURITY ENFORCED 
        }
            for (CORPMaterialNumber__c matno: CORPMaterialNumber__c.getall().values()) {
                materialno.add(matno.MaterialNumber__c);
            }

            if (proposallst.size() > 0) {
                for (Apttus_Proposal__Proposal__c prop: proposallst) {
                    prop.APTS_FL_Product_Language__c = '';
                    isShortTerm = false;
                    isRenewal = false;
                    ispriceqtynew = false;
                    ispriceqtyrenew = false;
                    ismyrnew = false;
                    ismyrrenew = false;
                    iscanprod = false;
                    isSmallFirm = false; //Added by Bijeta DOC-5386 Small Law Cluster
           brandvalue = '';
           prodcount = 0;
                    //Added By Poonam Garg for DOC 9821
                    if (prop.APTS_NACI_Form__c) {
                        prop.APTS_NACI_Form__c = false;
                        naciMap.put(prop.id, prop.APTS_NACI_Form__c);
                    }
                    if ((((prop.APTS_Proposal_Business_Unit__c == 'SCS' || prop.APTS_Proposal_Business_Unit__c == 'Findlaw') &&
                                (prop.APTS_Payment_Option__c == 'Auto EFT/Auto Charge' || prop.APTS_Payment_Option__c == 'Bill to Account')) ||
                            ((prop.APTS_Proposal_Business_Unit__c == 'Canada' || prop.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' || prop.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK') &&
                                (prop.APTS_Payment_Option__c == 'Auto Charge' || prop.APTS_Payment_Option__c == 'Bill to Account'))) &&
                        prop.APTS_Proposal_Business_Unit__c != 'Tax Professional' && !(prop.APTS_NACI_Form__c)) {
                        prop.APTS_NACI_Form__c = false;
                        naciMap.putAll(sendNaciForm(prop, prop.R00N70000001yUfBEAU));
                    }
                    for (Apttus_Proposal__Proposal_Line_Item__c plineitem: prop.R00N70000001yUfBEAU) {
                        if (plineitem.APTS_Proposal_Business_Unit__c == 'FindLaw' && plineitem.APTS_Contract_Term__c != null && plineitem.APTS_Contract_Term__c != '1 Year' &&
                            plineitem.APTS_Contract_Term__c != '2 Years' && plineitem.APTS_Contract_Term__c != '3 Years' &&
                            plineitem.Apttus_QPConfig__PriceType__c != 'One Time' && plineitem.Apttus_QPConfig__ChargeType__c != 'Standard Price' &&
                            plineitem.Apttus_QPConfig__LineType__c == 'Product/Service') {
                            isShortTerm = true;
                        }

                        //Added by Bijeta DOC-5386 Small Law Cluster
                        if ((pLineItem.Apttus_QPConfig__LineStatus__c == 'New' || pLineItem.Apttus_QPConfig__LineStatus__c == 'Renewed') && (!String.isEmpty(plineitem.Apttus_Proposal__Product__r.Name) && plineitem.Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage))) {
                            isSmallFirm = true;
                        }
                        if (plineitem.Apttus_QPConfig__LineStatus__c == 'Renewed' && plineitem.APTS_Proposal_Business_Unit__c == 'FindLaw'){
                            isRenewal = true;}

                        if (propId == null || propId == pLineItem.Apttus_Proposal__Proposal__c || propId != pLineItem.Apttus_Proposal__Proposal__c) {
                            if (propId != pLineItem.Apttus_Proposal__Proposal__c) {
                                propId = pLineItem.Apttus_Proposal__Proposal__c;
                                pickValues = '';
                            }
                            if (pLineItem.Apttus_QPConfig__LineStatus__c == 'New') {
                                for (APTS_Product_Legal_Language_FL_Settings__c legalLanguageSetting: APTS_Product_Legal_Language_FL_Settings__c.getall().values()) {
                                    if ((legalLanguageSetting.APTS_Product_Codes__c != null && ((legalLanguageSetting.APTS_Product_Codes__c.contains(',') && legalLanguageSetting.APTS_Product_Codes__c.split(',').contains(pLineItem.Apttus_Proposal__Product__r.ProductCode)) || (legalLanguageSetting.APTS_Product_Codes__c == pLineItem.Apttus_Proposal__Product__r.ProductCode))) ||
                                        (legalLanguageSetting.APTS_Product_Names__c != null && ((legalLanguageSetting.APTS_Product_Names__c.contains(',') && legalLanguageSetting.APTS_Product_Names__c.split(',').contains(pLineItem.Apttus_Proposal__Product__r.Name)) || (legalLanguageSetting.APTS_Product_Codes__c == pLineItem.Apttus_Proposal__Product__r.Name)))) {
                                        if (legalLanguageSetting.APTS_Short_Term_Applicable__c && !legalLanguageSetting.APTS_Short_Term_Not_Applicable__c) {
                                            if (plineitem.APTS_Contract_Term__c != '1 Year' && plineitem.APTS_Contract_Term__c != '2 Years' && plineitem.APTS_Contract_Term__c != '3 Years'){
                                                pickValues = mapProductLanguageValues(pickValues, legalLanguageSetting.Name);}
                                        } else if (!legalLanguageSetting.APTS_Short_Term_Applicable__c && legalLanguageSetting.APTS_Short_Term_Not_Applicable__c) {
                                            if (plineitem.APTS_Contract_Term__c == '1 Year' || plineitem.APTS_Contract_Term__c == '2 Years' || plineitem.APTS_Contract_Term__c == '3 Years') {
                                                pickValues = mapProductLanguageValues(pickValues, legalLanguageSetting.Name);
                                            }
                                        } else if (!legalLanguageSetting.APTS_Short_Term_Applicable__c && !legalLanguageSetting.APTS_Short_Term_Not_Applicable__c) {
                                            pickValues = mapProductLanguageValues(pickValues, legalLanguageSetting.Name);
                                        }
                                    }
                                }
                            }
                            //SOC-7425 starts, added by Keerthana
                            if ((pLineItem.Apttus_QPConfig__LineStatus__c == 'New' || pLineItem.Apttus_QPConfig__LineStatus__c == 'Renewed') && plineitem.APTS_Proposal_Business_Unit__c != 'Corp OneOTC US' && plineitem.APTS_Proposal_Business_Unit__c != 'Corp OneOTC UK') {
                                if (pLineItem.APTS_Contract_Term__c == '1 Year') {
                                    pickValues = mapProductLanguageValues(pickValues, '12');
                                } else if (pLineItem.APTS_Contract_Term__c == '2 Years') {
                                    pickValues = mapProductLanguageValues(pickValues, '24');
                                } else if (pLineItem.APTS_Contract_Term__c == '3 Years') {
                                    pickValues = mapProductLanguageValues(pickValues, '36');
                                }//Added as part of DOC-13399, by Rishi
                                 else if(pLineItem.APTS_Contract_Term__c == '4 Years'){
                                    pickValues = mapProductLanguageValues(pickValues, '48');                   
                                }else if(pLineItem.APTS_Contract_Term__c == '5 Years'){
                                    pickValues = mapProductLanguageValues(pickValues, '60');                   
                                }

                            }
                            //DOC-2848,DOC-4514,DOC-4860,DOC-5119-Added by Nandha:Starts here
                            if (plineitem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' || plineitem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK') {
                                Boolean ancflag = false;
                                if (plineitem.APTS_Term_Type__c == NULL && ((((plineitem.APTS_Item_Category_Group__c == 'ZT07' && plineitem.APTS_Product_Pricing_Model__c == 'TAX INFORMATION REPORTING') || plineitem.Apttus_Proposal__Product__r.ProductCode == '30081375') && plineitem.Apttus_QPConfig__LineStatus__c == 'New') || materialno.contains(plineitem.Apttus_Proposal__Product__r.ProductCode) || plineitem.APTS_WLEC_Product_Category__c == 'PS')) {
                                    ancflag = true;
                                }
                                if (plineitem.APTS_FL_Renewal_Only_Clone__c == 'Yes') {
                                    pickValues = mapProductLanguageValues(pickValues, 'No-Renew');
                                }
                                if (plineitem.APTS_WLEC_Product_Category__c == 'PS' && plineitem.APTS_Term_Type__c == NULL) {
                                    if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                        pickValues = mapProductLanguageValues(pickValues, 'PS-AR-New MYR');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                        pickValues = mapProductLanguageValues(pickValues, 'PS-EVG');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                        pickValues = mapProductLanguageValues(pickValues, 'PS-TC');
                                    }
                                    if (plineitem.Apttus_QPConfig__PriceType__c == 'One Time') {
                                        pickValues = mapProductLanguageValues(pickValues, 'PS-One Time');
                                    }
                                }
                                if (plineitem.APTS_Item_Category_Group__c != NULL && (plineitem.APTS_Item_Category_Group__c == 'ZT04' || plineitem.APTS_Item_Category_Group__c == 'ZT06' || plineitem.APTS_Item_Category_Group__c == 'ZT22' || plineitem.APTS_Item_Category_Group__c == 'ZT24')) {
                                    pickValues = mapProductLanguageValues(pickValues, 'One Time');
                                }
                                if ((plineitem.APTS_Media_High_Level_Code__c == '02' && (plineitem.APTS_Media_Lower_Level_Code__c == 'AQ' || plineitem.APTS_Media_Lower_Level_Code__c == 'IR' || plineitem.APTS_Media_Lower_Level_Code__c == 'TK' || plineitem.APTS_Media_Lower_Level_Code__c == 'UA')) || (plineitem.APTS_Media_High_Level_Code__c == '06' && (plineitem.APTS_Media_Lower_Level_Code__c == '20' || plineitem.APTS_Media_Lower_Level_Code__c == 'TX')) || (plineitem.APTS_Media_High_Level_Code__c == '51' && (plineitem.APTS_Media_Lower_Level_Code__c == 'IT' || plineitem.APTS_Media_Lower_Level_Code__c == 'TK' || plineitem.APTS_Media_Lower_Level_Code__c == 'TU' || plineitem.APTS_Media_Lower_Level_Code__c == 'UB')) || (plineitem.APTS_Media_High_Level_Code__c == '52' && (plineitem.APTS_Media_Lower_Level_Code__c == 'IU' || plineitem.APTS_Media_Lower_Level_Code__c == 'IV' || plineitem.APTS_Media_Lower_Level_Code__c == 'TH' || plineitem.APTS_Media_Lower_Level_Code__c == 'TI' || plineitem.APTS_Media_Lower_Level_Code__c == 'TK'))) {
                                    pickValues = mapProductLanguageValues(pickValues, 'Subscription');
                                }
                                if (plineitem.APTS_Availability_Date__c != NULL && plineitem.APTS_Term_Type__c == NULL && ancflag == false && plineitem.APTS_FL_Renewal_Only_Clone__c != 'Yes') {
                                    if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Ver-AR-New MYR');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                        pickValues = mapProductLanguageValues(pickValues, 'Ver-EVG');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                        pickValues = mapProductLanguageValues(pickValues, 'Ver-TC');
                                    }
                                }
                                if (plineitem.APTS_Availability_Date__c == NULL && plineitem.APTS_Term_Type__c == NULL && ancflag == false) {
                                    if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Non Ver-AR-New MYR');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                        pickValues = mapProductLanguageValues(pickValues, 'Non Ver-EVG');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                        pickValues = mapProductLanguageValues(pickValues, 'Non Ver-TC');
                                    }
                                }
                                if (plineitem.APTS_Term_Type__c == NULL) {
                                    if (plineitem.APTS_Product_Pricing_Model__c == 'TAX INFORMATION REPORTING' && plineitem.APTS_Item_Category_Group__c == 'ZT07' && plineitem.Apttus_QPConfig__LineStatus__c == 'New') {
                                        pickValues = mapProductLanguageValues(pickValues, 'Anc-OTIR');
                                    }
                                    if (plineitem.Apttus_Proposal__Product__r.ProductCode == '30081375' && plineitem.Apttus_QPConfig__LineStatus__c == 'New') {
                                        pickValues = mapProductLanguageValues(pickValues, 'Anc-Trust Tax');
                                    }
                                    if (materialno.contains(plineitem.Apttus_Proposal__Product__r.ProductCode)) {
                                        if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                            pickValues = mapProductLanguageValues(pickValues, 'Anc-AR-New MYR');
                                        }
                                        if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                            pickValues = mapProductLanguageValues(pickValues, 'Anc-EVG');
                                        }
                                        if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                            pickValues = mapProductLanguageValues(pickValues, 'Anc-TC');
                                        }
                                    }
                                }
                                if (plineitem.Apttus_QPConfig__LineStatus__c == 'Renewed') {
                                    if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                        pickValues = mapProductLanguageValues(pickValues, 'Renew-EVG');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Renew -AR-MYR');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                        pickValues = mapProductLanguageValues(pickValues, 'Renew-TC');
                                    }
                                }
                                if (plineitem.APTS_Term_Type__c == 'Co-Term') {
                                    if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                        pickValues = mapProductLanguageValues(pickValues, 'CT-EVG');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                        pickValues = mapProductLanguageValues(pickValues, 'CT-AR-New MYR');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                        pickValues = mapProductLanguageValues(pickValues, 'CT-TC');
                                    }
                                }
                                if (plineitem.APTS_Term_Type__c == 'ProRate') {
                                    if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                        pickValues = mapProductLanguageValues(pickValues, 'PR-EVG');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                        pickValues = mapProductLanguageValues(pickValues, 'PR-AR-New MYR');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                        pickValues = mapProductLanguageValues(pickValues, 'PR-TC');
                                    }
                                }
                                if (plineitem.APTS_Term_Type__c == 'Co-Term and ProRate') {
                                    if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                        pickValues = mapProductLanguageValues(pickValues, 'CT&PR-EVG');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                        pickValues = mapProductLanguageValues(pickValues, 'CT&PR-AR-New MYR');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                        pickValues = mapProductLanguageValues(pickValues, 'CT&PR-TC');
                                    }
                                }
                                if (plineitem.APTS_Term_Type__c == 'Delivery Date') {
                                    if (plineitem.APTS_Renewal_Type__c == 'Evergreen') {
                                        pickValues = mapProductLanguageValues(pickValues, 'DD-EVG');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Auto Renew' && plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 12 || plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                        pickValues = mapProductLanguageValues(pickValues, 'DD-AR-New MYR');
                                    }
                                    if (plineitem.APTS_Renewal_Type__c == 'Term Commitment') {
                                        pickValues = mapProductLanguageValues(pickValues, 'DD-TC');
                                    }
                                }
                                if (plineitem.Apttus_QPConfig__LineStatus__c == 'New') {
                                    if (plineitem.APTS_Calculated_Year_2__c != NULL) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Annual Year 2 New');
                                    }
                                    if (plineitem.APTS_Calculated_Year_3__c != NULL) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Annual Year 3 New');
                                    }
                                    if (plineitem.APTS_Calculated_Year_4__c != NULL) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Annual Year 4 New');
                                    }
                                    if (plineitem.APTS_Calculated_Year_5__c != NULL) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Annual Year 5 New');
                                    }
                                }
                                if (plineitem.Apttus_QPConfig__LineStatus__c == 'Renewed') {
                                    if (plineitem.APTS_Calculated_Year_2__c != NULL) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Annual Year 2 Renewed');
                                    }
                                    if (plineitem.APTS_Calculated_Year_3__c != NULL) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Annual Year 3 Renewed');
                                    }
                                    if (plineitem.APTS_Calculated_Year_4__c != NULL) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Annual Year 4 Renewed');
                                    }
                                    if (plineitem.APTS_Calculated_Year_5__c != NULL) {
                                        pickValues = mapProductLanguageValues(pickValues, 'Annual Year 5 Renewed');
                                    }
                                }
                            }
                            //DOC-2848,DOC-4514,DOC-4860,DOC-5119-Added by Nandha:Ends here
                            if (!String.isEmpty(pickValues)){
                                firmsiteMap.put(prop.id, pickValues);}
                            //SOC-7425 ends 
                        }
                        //DOC-3800 - Added by Nandha : Starts here
                        if ((plineitem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' || plineitem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK') && plineitem.APTS_Pricing_Quantity__c != NULL) {
                            if (plineitem.Apttus_QPConfig__LineStatus__c == 'New' && plineitem.APTS_Pricing_Quantity__c > 0) {
                                ispriceqtynew = true;
                            }
                            if (plineitem.Apttus_QPConfig__LineStatus__c == 'Renewed' && plineitem.APTS_Pricing_Quantity__c > 0) {
                                ispriceqtyrenew = true;
                            }
                        }
                        //DOC-3800 - Added by Nandha : Ends here
                        //DOC-5120 - Added by Nandha : Starts here
                        if ((plineitem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' || plineitem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK') && plineitem.APTS_Contract_Term_Number__c != NULL) {
                            if (plineitem.Apttus_QPConfig__LineStatus__c == 'New' && (plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                ismyrnew = true;
                            }
                            if (plineitem.Apttus_QPConfig__LineStatus__c == 'Renewed' && (plineitem.APTS_Contract_Term_Number__c == 24 || plineitem.APTS_Contract_Term_Number__c == 36 || plineitem.APTS_Contract_Term_Number__c == 48 || plineitem.APTS_Contract_Term_Number__c == 60)) {
                                ismyrrenew = true;
                            }
                        }
                        //DOC-5120 - Added by Nandha : Ends here
                        //DOC-5703 - Added by Nandha : Starts here
                        if (plineitem.APTS_Proposal_Business_Unit__c == 'Canada' && plineitem.APTS_Item_Category_Group__c != NULL && plineitem.APTS_Item_Category_Group__c != '' && plineitem.APTS_Media_High_Level_Code__c != NULL && plineitem.APTS_Media_High_Level_Code__c != '') {
                            if (plineitem.APTS_Item_Category_Group__c == 'ZVAM' && plineitem.APTS_Media_High_Level_Code__c == '07') {
                                iscanprod = true;
                            }
                        }
                        //DOC-5703 - Added by Nandha : Ends here
            //DOC-13411 - Added by Nandha : Starts here
            if(plineitem.Apttus_Proposal__Product__r.Product_Level_2__c != null && prodcount <= 1 
            && !(System.Label.APTS_Proflex_Materials.contains(plineitem.Apttus_Proposal__Product__r.Productcode))){ //DOC-14691
                brandvalue = plineitem.Apttus_Proposal__Product__r.Product_Level_2__c;
                prodcount++;
                    }
            //DOC-13411 - Added by Nandha : Ends here
           } 
                    if (isShortTerm){
                        shortTermProposalList.add(prop);}
                    if (!isShortTerm && prop.APTS_Proposal_Business_Unit__c == 'FindLaw'){
                        longTermProposalList.add(prop);}
                    if (isRenewal){
                        renewalProposalList.add(prop);}
                    if (!isRenewal && prop.APTS_Proposal_Business_Unit__c == 'FindLaw'){
                        otherStatusProposalList.add(prop);}
                    //DOC-3800 - Added by Nandha : Starts here
                    if (ispriceqtynew){
                        priceqtynewList.add(prop);}
                    if (ispriceqtyrenew){
                        priceqtyrenewList.add(prop);}
                    //DOC-3800 - Added by Nandha : Ends here
                    //DOC-5120 - Added by Nandha : Starts here
                    if (ismyrnew){
                        myrnewList.add(prop);}
                    if (ismyrrenew){
                        myrrenewList.add(prop);}
                    //DOC-5120 - Added by Nandha : Ends here
                    //DOC-5703 - Added by Nandha : Starts here
                    if (iscanprod){
                        canprodList.add(prop);}
                    //DOC-5703 - Added by Nandha : Ends here
                    if (isSmallFirm){
                        smallFirmList.add(prop);} //Added by Bijeta DOC-5386 Small Law Cluster : 
            //DOC-13411 - Added by Nandha : Starts here
            if(brandvalue != null){
                casebrandmap.put(prop.id,brandvalue);
            }
            //DOC-13411 - Added by Nandha : Ends here
                }
            }
            for (Apttus_Proposal__Proposal__c proposal: proposallst) {
                updateCount = 0;
                if (!firmsiteMap.isEmpty() && firmsiteMap.ContainsKey(proposal.id)) {
                    updateCount++;
                    proposal.APTS_FL_Product_Language__c = firmsiteMap.get(proposal.id);
                }
                if (shortTermProposalList.contains(proposal)) {
                    if (proposal.APTS_Boolean_Short_Term_Trials__c != true) {
                        updateCount++;
                        proposal.APTS_Boolean_Short_Term_Trials__c = true;
                    }
                }
                if (longTermProposalList.contains(proposal)) {
                    if (proposal.APTS_Boolean_Short_Term_Trials__c == true) {
                        updateCount++;
                        proposal.APTS_Boolean_Short_Term_Trials__c = false;
                    }
                }
                if (renewalProposalList.contains(proposal)) {
                    if (proposal.APTS_FL_Renewal_OnlyFlag__c != true) {
                        updateCount++;
                        proposal.APTS_FL_Renewal_OnlyFlag__c = true;
                    }
                }
                if (otherStatusProposalList.contains(proposal)) {
                    if (proposal.APTS_FL_Renewal_OnlyFlag__c == true) {
                        updateCount++;
                        proposal.APTS_FL_Renewal_OnlyFlag__c = false;
                    }
                }
                //DOC-3800 - Added by Nandha : Starts here
                if (priceqtynewList.contains(proposal)) {
                    updateCount++;
                    proposal.APTS_Price_Qty_New_Exists__c = true;
                }
                if (priceqtyrenewList.contains(proposal)) {
                    updateCount++;
                    proposal.APTS_Price_Qty_Renew_Exists__c = true;
                }
                //DOC-3800 - Added by Nandha : Ends here
                //DOC-5120 - Added by Nandha : Starts here
                if (myrnewList.contains(proposal)) {
                    updateCount++;
                    proposal.APTS_New_Sale_MYR__c = true;
                }
                if (myrrenewList.contains(proposal)) {
                    updateCount++;
                    proposal.APTS_Renewal_MYR__c = true;
                }
                //DOC-5120 - Added by Nandha : Ends here
                //DOC-5703 - Added by Nandha : Starts here
                if (canprodList.contains(proposal)) {
                    updateCount++;
                    proposal.APTS_Print_Monthly_Non_App_Canada__c = true;
                }
                //DOC-5703 - Added by Nandha : Ends here
                //Added by Bijeta DOC-5386 Small Law Cluster : 
                if (smallFirmList.contains(proposal)) {
                    updateCount++;
                    proposal.APTS_Small_Law_Cluster__c = true;
                }
                if (!smallFirmList.contains(proposal)) {
                    updateCount++;
                    proposal.APTS_Small_Law_Cluster__c = false;
                }
                //Added By Poonam Garg for DOC 9821
                if (!nacimap.isEmpty() && nacimap.containskey(proposal.id)) {
                    updateCount++;
                    proposal.APTS_NACI_Form__c = nacimap.get(proposal.id);
                }
         //DOC-13411 - Added by Nandha : Starts here
         if(!casebrandmap.isEmpty() && casebrandmap.containsKey(proposal.id)){
             updateCount++;
             proposal.APTS_Case_Brand_Value__c = casebrandmap.get(proposal.id);
         }
         //DOC-13411 - Added by Nandha : Ends here
         if(updateCount>0) 
           proposalList.add(proposal);
            }

            if (proposalList.size() > 0 && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                update proposalList;}
        }
    }

    public static string mapProductLanguageValues(string pValues, string pValue) {
        if (String.isEmpty(pValues)){
            pValues = pValue;}
        else if (!pValues.contains(';') && !(pValues.equals(pValue))){
            pValues = pValues + ';' + pValue;}
        else if (pValues.contains(';')) {
            List < String > pValuesList = pValues.split(';');
            if (!pValuesList.contains(pValue)){
                pValues = pValues + ';' + pValue;}
        }
        return pValues;
    }

    //SOC-6701--End Zakeer
    //DOC-3658 starts added by Keerthana
    public static void validateQuoteStageUpdate(Map < Id, Apttus_Proposal__Proposal__c > oldProposalMap, Map < Id, Apttus_Proposal__Proposal__c > newProposalMap) {

        Map < String, Schema.SObjectField > mapFields = Schema.SObjectType.Apttus_Proposal__Proposal__c.fields.getMap();

         if (!System.isScheduled() && !System.IsFuture() && !System.isQueueable() && !System.ISBatch() && RestContext.request == null && UserInfo.getName()!='Dell Boomi') {
            for (Apttus_Proposal__Proposal__c proposal: newProposalMap.values()) {
                Apttus_Proposal__Proposal__c oldMap = oldProposalMap.get(proposal.Id);
                Apttus_Proposal__Proposal__c newMap = newProposalMap.get(proposal.Id);
                system.debug('approvalstage' + oldMap.Apttus_Proposal__Approval_Stage__c + ',' + currentUserPro.Name + ',' + newMap.Apttus_Proposal__Approval_Stage__c + ',' + oldMap.APTS_Proposal_Business_Unit__c);
                if (oldMap.Apttus_Proposal__Approval_Stage__c != null && newMap.Apttus_Proposal__Approval_Stage__c != null) {
                    if (currentUserPermissionsList.isEmpty() && ((oldMap.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(PRESENTED) && newMap.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(PRESENTED)) || (oldMap.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(ACCEPTED) && newMap.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(ACCEPTED)))) {
                        for (String str: mapFields.keyset()) {
                            if (str != 'lastmodifieddate' && str != 'systemmodstamp' && newMap.get(str) != oldMap.get(str)) {
                                if (oldMap.Apttus_Proposal__Primary__c) {
                                    if (str != 'Apttus_Proposal__Primary__c' && str != 'Apttus_QPConfig__SyncWithOpportunity__c' && str != 'Apttus_Proposal__MakePrimary__c' && newMap.get(str) != oldMap.get(str)) {
                                        system.debug('fieldname' + str);
                                        if (!Test.isRunningTest()){
                                            proposal.addError(Label.APTS_Validate_Quote_StageUpdate);}
                                    }
                                } else {
                                    system.debug('Inside if approvalstage1' + oldMap.Apttus_Proposal__Approval_Stage__c + ',' + currentUserPro.Name + ',' + newMap.Apttus_Proposal__Approval_Stage__c + ',' + oldMap.APTS_Proposal_Business_Unit__c);
                                    system.debug('fieldname' + str);
                                    if (!Test.isRunningTest()){
                                        proposal.addError(Label.APTS_Validate_Quote_StageUpdate);}
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //DOC-3658 ends
    //DOC-5003 Starts
    //DOC-11048
    public static void validateQuoteStageforDelete(List < Apttus_Proposal__Proposal__c > proposals) {

        system.debug('approvalstage start of method');

        if (!System.isScheduled() && !System.IsFuture() && !System.isQueueable() && !System.ISBatch() && RestContext.request == null) {
            if (!proposals.isEmpty()) {
                for (Apttus_Proposal__Proposal__c proposal: proposals) {
                    system.debug('approvalstage after for' + proposal.Apttus_Proposal__Approval_Stage__c);
                    if (proposal.Apttus_Proposal__Approval_Stage__c != null) {
                        if ((proposal.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(ACCEPTED) || proposal.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(PRESENTED)) && (currentUserPermissionsList.isEmpty()) && (currentUserPro.Name.equalsIgnoreCase(GLI_SALES) || currentUserPro.Name.equalsIgnoreCase(GLI_SALES_OP) || currentUserPro.Name.equalsIgnoreCase(TR_SALES) || currentUserPro.Name.equalsIgnoreCase(TR_SALES_OP) || currentUserPro.Name.equalsIgnoreCase(TR_SALES_LIGHT)) && (proposal.APTS_Proposal_Business_Unit__c == 'SCS' || proposal.APTS_Proposal_Business_Unit__c == 'FindLaw' || proposal.APTS_Proposal_Business_Unit__c == 'Canada' || proposal.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' || proposal.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK' || proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'))

                        {
                            system.debug('approvalstage inside if' + proposal.Apttus_Proposal__Approval_Stage__c);
                            proposal.addError(Label.APTS_Validate_Quote_StageDelete);

                        }
                    }
                }
            }
        }



    }
    //DOC-5003 Ends

    //DOC-6335 - Jinal Bhatt
    Public static void populateApprovalDashBoard(Map < ID, Apttus_Proposal__Proposal__c > oldMap, List < Apttus_Proposal__Proposal__c > lstProposal) {
        if (checkRecursive.runForApproval()) {
            system.debug('#### inside Approval Dashboard');
            Boolean isDashboardNeeded = True;
            system.debug('#### oldMap' + oldMap);
            system.debug('#### lstProposal' + lstProposal);
            Set < Id > setProposalIds = new Set < Id > ();
            for (Apttus_Proposal__Proposal__c newProposal: lstProposal) {
                if ((oldMap.get(newProposal.ID).Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(PRESENTED) ||
                        (oldMap.get(newProposal.Id).Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(ACCEPTED))) &&
                    oldMap.get(newProposal.Id).APTS_Approval_Dashboard_URL__c != null) {
                    isDashboardNeeded = False;
                }

                if (newProposal.Apttus_Proposal__Approval_Stage__c != null &&
                    (newProposal.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(PRESENTED) ||
                        newProposal.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(ACCEPTED))) {
                    setProposalIds.add(newProposal.Id);
                }
            }

            if (isDashboardNeeded && setProposalIds.size() > 0) {
                String BaseURL = URL.getSalesforceBaseUrl().getHost();
                String ProposalId;
                String ProductConfigId;
                String TempObjectId;
                String BusinessUnit;

                List < Apttus_Config2__ProductConfiguration__c > lstProductConfiguration = new List < Apttus_Config2__ProductConfiguration__c > ();
                if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
                    //Fetch Product Configuration
                    lstProductConfiguration = [Select Id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c
                        from Apttus_Config2__ProductConfiguration__c
                        where Apttus_QPConfig__Proposald__c IN: setProposalIds
                        AND Apttus_Config2__Status__c = 'Finalized'
                    ];}

                if (lstProductConfiguration != null && lstProductConfiguration.size() > 0) {
                    //Fetch relevant Temp Object
                    List < Apttus_Config2__TempObject__c > lstTempObject = new List < Apttus_Config2__TempObject__c > ();
                    if (Schema.sObjectType.Apttus_Config2__TempObject__c.isAccessible()){
                        lstTempObject = [Select Id,
                            Apttus_Config2__ConfigurationId__c,
                            Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,
                            Apttus_Config2__ConfigurationId__r.APTS_Proposal_Business_Unit__c,
                            Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c
                            from Apttus_Config2__TempObject__c
                            where Apttus_Config2__ConfigurationId__c IN: lstProductConfiguration
                        ];}

                    //Map<Proposal Id, URL>
                    Map < Id, String > mapProposalToURL = new Map < Id, String > ();

                    //Iterate through temp object and prepare URL
                    if (lstTempObject != null && lstTempObject.size() > 0) {
                        system.debug('#### lstTempObject' + lstTempObject);
                        for (Apttus_Config2__TempObject__c objTemp: lstTempObject) {
                            ProposalId = objTemp.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
                            ProductConfigId = objTemp.Apttus_Config2__ConfigurationId__c;
                            BusinessUnit = objTemp.Apttus_Config2__ConfigurationId__r.APTS_Proposal_Business_Unit__c;
                            TempObjectId = objTemp.Id;
                            if (BusinessUnit != 'FindLaw') {
                                String strURL = 'https://' + BaseURL + '/apex/ApprovalDashboardPage?' +
                                    '&configRequestId=' + TempObjectId +
                                    '&businessObjectId=' + ProposalId +
                                    '&retId=' + ProposalId +
                                    '&id=' + ProductConfigId +
                                    '&flow=corpFlow';
                                mapProposalToURL.put(objTemp.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, strURL);
                            } else {
                                String strURL = 'https://' + BaseURL + '/apex/FL_ApprovalDashboardPage?' +
                                    '&configRequestId=' + TempObjectId +
                                    '&businessObjectId=' + ProposalId +
                                    '&retId=' + ProposalId +
                                    '&id=' + ProductConfigId +
                                    '&flow=flflow';
                                mapProposalToURL.put(objTemp.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, strURL);
                            }

                        }

                        system.debug('########### mapProposalToURL' + mapProposalToURL);


                        //Fetch proposal to update URL
                        if (lstProposal != null && lstProposal.size() > 0) {
                            for (Apttus_Proposal__Proposal__c objProposal: lstProposal) {
                                objProposal.APTS_Approval_Dashboard_URL__c = mapProposalToURL.get(objProposal.Id);
                            }
                        }
                    }
                }
            }
        }
    }
    //End 6335
    /*DOC-8284 This method is used to update the "Win/Lost" and "Reason" fields on proposal
      public static void updateProposal(List<Apttus_Proposal__Proposal__c> proposals)
      {
      
      Boolean checkRenewed=false;
      List<Apttus_Proposal__Proposal__c> listNewProposals=new List<Apttus_Proposal__Proposal__c>();
      List<Id> proposalIds=new List<Id>();
      List<Apttus_Proposal__Proposal_Line_Item__c> propTC=new List<Apttus_Proposal__Proposal_Line_Item__c>();
      List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineitemDetails = new List<Apttus_Proposal__Proposal_Line_Item__c>();
      for(Apttus_Proposal__Proposal__c i: proposals)
              {
                  proposalIds.add(i.id);
              }
      system.debug('Proposal Ids Navpreet'+proposalIds);
      if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible()&&Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){
        proposalLineitemDetails=[select id,Apttus_QPConfig__LineStatus__c,Apttus_QPConfig__AssetLineItemId__c,Apttus_Proposal__Proposal__c,Apttus_QPConfig__AssetLineItemId__r.APTS_Renewal_Type__c,Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c from 
             Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c in :proposalIds and APTS_Proposal_Business_Unit__c='Tax Professional' and Apttus_QPConfig__LineStatus__c='Renewed'];
      }
          system.debug('Proposal line items Navpreet'+proposalLineitemDetails.size());
      if(proposalLineitemDetails != null && proposalLineitemDetails.size() > 0 )
      {
        for(Apttus_Proposal__Proposal_Line_Item__c propLineitems :proposalLineitemDetails)
        {
          if(propLineitems.Apttus_QPConfig__AssetLineItemId__r.APTS_Renewal_Type__c=='Auto Renew' || propLineitems.Apttus_QPConfig__AssetLineItemId__r.APTS_Renewal_Type__c=='Term Commitment')
          {
            checkRenewed=true;
          }
          if(propLineitems.Apttus_QPConfig__AssetLineItemId__r.APTS_Renewal_Type__c=='Term Commitment')
          {
            propTC.add(propLineitems);
          }
        }
      }
          system.debug('check renewed status Navpreet'+checkRenewed);
            for(Apttus_Proposal__Proposal__c prop : proposals)
            {
                if(prop.APTS_Proposal_Business_Unit__c=='Tax Professional' && (
                (checkRenewed==true && prop.Apttus_Proposal__Approval_Stage__c == 'Cancelled') ||
                 (prop.Apttus_Proposal__Approval_Stage__c == 'Cancelled') ||
                 (prop.Apttus_Proposal__Approval_Stage__c == 'Rejected' && prop.SAP_Credit_Check_Status__c=='Fail')))
                   {
                      prop.Latam_APTS_Win_Loss__c='Lost';
                      prop.Latam_APTS_Reason__c='Auto Cancelled/Rejected';

                   }
                   for(Apttus_Proposal__Proposal_Line_Item__c propLI: propTC)
                   {
                       if(prop.Apttus_Proposal__Approval_Stage__c =='Expired')
                       {
                           prop.Latam_APTS_Win_Loss__c='Lost';
                           prop.Latam_APTS_Reason__c='Contract Terms';
                       }
                   }
                   
            }
           //if(!updateProp.isEmpty())
                //update updateProp;
                
            //system.debug('Size of proposals Navpreet'+updateProp.size());
      }*/
    //DOC 9821 Added By Poonam Garg.
    public static Map < Id, Boolean > sendNaciForm(Apttus_Proposal__Proposal__c prop, List < Apttus_Proposal__Proposal_Line_Item__c > plineItems) {
        Boolean checkMonthlyRecProduct = false;
        Boolean checkAnnualRecProduct = false;
        Boolean checkOneTimeProduct = false;
        Integer count = 0;
        Integer countY = 0;
        Decimal sumOfNetPrice = 0;
        Decimal varMonthlyPrice = 0;
        Decimal varAnnualPrice = 0;
        Decimal sumOfNetPriceY = 0;
        Decimal sumOfNetPriceOneTimeMonthly = 0;
        Integer sizeOfRecords = 0;
        if (!plineItems.isEmpty()) {
            for (Apttus_Proposal__Proposal_Line_Item__c plineItem: plineItems) {
                if (plineItem.Apttus_QPConfig__LineType__c == 'Product/Service' && plineItem.Apttus_QPConfig__LineStatus__c == 'New' &&
                    ((plineItem.Apttus_QPConfig__PriceType__c == 'Recurring' && plineItem.Apttus_QPConfig__Frequency__c == 'Monthly') ||
                        (plineItem.Apttus_QPConfig__PriceType__c == 'Recurring' && plineItem.Apttus_QPConfig__Frequency__c == 'Yearly') || plineItem.Apttus_QPConfig__PriceType__c == 'One Time')) {
                    sizeOfRecords = sizeOfRecords + 1;
                }
            }
        }
        Map < Id, Boolean > naciMap = new Map < Id, Boolean > ();
        List < APTS_NACI_Form_Variables__mdt > naciVariablesList;
        if (Schema.sObjectType.APTS_NACI_Form_Variables__mdt.isAccessible()){
            naciVariablesList = [Select MasterLabel, Annual_Price__c, Currency_Type__c, Monthly_Price__c from APTS_NACI_Form_Variables__mdt];}
        for (APTS_NACI_Form_Variables__mdt
            var: naciVariablesList) {
            if (var.Currency_Type__c == prop.currencyIsoCode) {
                varMonthlyPrice =
                    var.Monthly_Price__c;
                varAnnualPrice =
                    var.Annual_Price__c;
            }
        }
        System.debug('varMonthlyPrice' + varMonthlyPrice);
        //Check if order has all monthly recurring products
        for (Apttus_Proposal__Proposal_Line_Item__c plineItem: plineItems) {
            if (plineItem.Apttus_QPConfig__LineType__c == 'Product/Service' && plineItem.Apttus_QPConfig__LineStatus__c == 'New' && plineItem.Apttus_QPConfig__PriceType__c == 'Recurring' && plineItem.Apttus_QPConfig__Frequency__c == 'Monthly') {
                count = count + 1;
                sumOfNetPrice = plineItem.Apttus_QPConfig__NetPrice__c + sumOfNetPrice;
            } else if (plineItem.Apttus_QPConfig__LineType__c == 'Product/Service' && plineItem.Apttus_QPConfig__LineStatus__c == 'New' && (plineItem.Apttus_QPConfig__PriceType__c == 'Recurring' && plineItem.Apttus_QPConfig__Frequency__c == 'Yearly') || plineItem.Apttus_QPConfig__PriceType__c == 'One Time') {
                countY = countY + 1;
                sumOfNetPriceY = plineItem.Apttus_QPConfig__NetPrice__c + sumOfNetPriceY;
            }
            if ((count == sizeOfRecords && sumOfNetPrice > varMonthlyPrice) || (countY == sizeOfRecords && sumOfNetPriceY > varAnnualPrice)) {
                prop.APTS_NACI_Form__c = true;
            } else if (count > 0 && countY > 0 && ((count + countY) == sizeOfRecords)) {
                if (count > 0) {
                    sumOfNetPriceOneTimeMonthly = (sumOfNetPrice * 12) + sumOfNetPriceY;
                }
                System.debug(sumOfNetPriceOneTimeMonthly);
                if (sumOfNetPriceOneTimeMonthly > varAnnualPrice) {
                    prop.APTS_NACI_Form__c = true;
                }
            }
        }
        naciMap.put(prop.id, prop.APTS_NACI_Form__c);
        return naciMap;
    }
    //DOC-17277 Dominic Starts
    public static void updateProposalBusinessUnit(Opportunity opty,Apttus_Proposal__Proposal__c proposal)
    {
     if(opty.APTS_Proposal_Business_Unit__c!=null && opty.APTS_Proposal_Business_Unit__c=='FindLaw'){
                        proposal.APTS_Proposal_Business_Unit__c = 'FindLaw';
                      }  
     if(opty.APTS_Proposal_Business_Unit__c!=null && opty.APTS_Proposal_Business_Unit__c=='Russia-1S'){
                        proposal.APTS_Proposal_Business_Unit__c = 'Russia-1S';
                      }  
     if(opty.APTS_Proposal_Business_Unit__c!=null && opty.APTS_Proposal_Business_Unit__c=='SouthKorea-DUZON'){
                        proposal.APTS_Proposal_Business_Unit__c = 'SouthKorea-DUZON';
                      }  
     if(opty.APTS_Proposal_Business_Unit__c!=null && opty.APTS_Proposal_Business_Unit__c=='Dofiscal'){
                        proposal.APTS_Proposal_Business_Unit__c = 'Dofiscal';
                      }
    }   //DOC-17277 Dominic Ends
}