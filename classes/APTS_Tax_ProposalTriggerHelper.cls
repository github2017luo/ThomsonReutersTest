/*Author - Gokila for Tax professional
Date- 13/8/2019
Purpose- Renewal Grace Period Extension after Approval
*/
public with sharing class APTS_Tax_ProposalTriggerHelper{
    
    /*Code added as part of DOC-10300 for Tax Professional changes starts*/ 
    public static void updateWinLostReason(Map<Id, Apttus_Proposal__Proposal__c> mapOldProposals,Map<Id, Apttus_Proposal__Proposal__c> mapNewProposals)
    {
        system.debug('Kh*** updateWinLostReason method called****');
        for(Apttus_Proposal__Proposal__c oProposal : mapNewProposals.Values())
        {
            Apttus_Proposal__Proposal__c  oldProposal = mapOldProposals.get(oProposal.ID);
            
            if(oProposal.APTS_Proposal_Business_Unit__c != null 
               && oProposal.APTS_Proposal_Business_Unit__c.equalsIgnoreCase('Tax Professional')
               && oldProposal.Apttus_Proposal__Approval_Stage__c != null 
               && oProposal.Apttus_Proposal__Approval_Stage__c != null
               && oldProposal.Apttus_Proposal__Approval_Stage__c != oProposal.Apttus_Proposal__Approval_Stage__c)
            {
                if(oProposal.Apttus_Proposal__Approval_Stage__c != null && oProposal.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase('Cancelled')) 
                {
                    if(oProposal.SAP_Credit_Check_Status__c != null 
                         && oProposal.SAP_Credit_Check_Status__c.equalsIgnoreCase('Fail'))
                    {
                        oProposal.Latam_APTS_Reason__c = 'Credit Check Failed';
                        System.Debug('Kh*** oProposal.Latam_APTS_Reason__c===>'+oProposal.Latam_APTS_Reason__c);
                    }
                }
            }     
        }
    }
    /*Code added as part of DOC-10300 for Tax Professional changes ends*/
   
    /*DOC-10572: Payment Sync for New Customer and Existing Customer
      Roma: 27 March 20
    */
    
    public static void updatePaymentDetailsforExisting(List<Apttus_Proposal__Proposal__c> listNewProposals,Map<Id, Apttus_Proposal__Proposal__c> mapOldObjects)
    {
        System.debug('inside updatePaymentDetailsforExisting');
        list<Id> ssdlistIds = new list<Id>();
        Map<Id, Source_System_Detail__c> ssdMap = new Map<Id, Source_System_Detail__c>();
        List<FeedItem> postList = new List<FeedItem>();
        Apttus_Proposal__Proposal__c oldRecord = new Apttus_Proposal__Proposal__c();
        Boolean taxFlag = false;
        for(Apttus_Proposal__Proposal__c currentProposal : listNewProposals){
            System.debug('currentProposal.APTS_SSD_Sold_To__c : '+currentProposal.APTS_SSD_Sold_To__c);
            System.debug('currentProposal.APTS_Proposal_Business_Unit__c : '+currentProposal.APTS_Proposal_Business_Unit__c);
            if(currentProposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                if(currentProposal.APTS_SSD_Sold_To__c!=NULL){
                    ssdlistIds.add(currentProposal.APTS_SSD_Sold_To__c); 
                }
                taxFlag = true;
            }else if(currentProposal.APTS_Proposal_Business_Unit__c == null){
                taxFlag = true;
            }
        }
        if(ssdlistIds.size()<=0){
            if(taxFlag==true){
                APTS_ProposalTriggerHandler.taxPaymentBeforeUpdate = false;
            }
            return;
        }else{
            ssdMap = new Map<Id, Source_System_Detail__c>([SELECT ID,APTS_Is_Customer__c,Default_Payment_Method__c,Card_Number__c,Card_Type__c,Expiry_Date__c,Bank_Account_Number__c,Bank_Name__c,Bank_Routing_Number__c from Source_System_Detail__c where ID IN :ssdlistIds]);
        
            for(Apttus_Proposal__Proposal__c currentProposal : listNewProposals)
            {
                if(!ssdMap.isEmpty() && ssdMap != null)
                {
                    if(mapOldObjects!=Null){
                        oldRecord = mapOldObjects.get(currentProposal.id);
                    }
                    Source_System_Detail__c ssdRecord = ssdMap.get(currentProposal.APTS_SSD_Sold_To__c);
                    System.Debug('Kh*** ssdRecord===>'+ssdRecord);
                    //System.Debug('Kh*** ssdRecord.APTS_Is_Customer__c===>'+ssdRecord.APTS_Is_Customer__c);
                    System.Debug('Kh*** currentProposal.APTS_Payment_Option__c ===>'+currentProposal.APTS_Payment_Option__c);
                    System.Debug('Kh*** currentProposal.Tax_Payment_Option__c ===>'+currentProposal.Tax_Payment_Option__c);
                    if(ssdRecord != null && ssdRecord.APTS_Is_Customer__c != null && ssdRecord.APTS_Is_Customer__c == true)
                    {
                        
                       //if (!Test.isRunningTest()){
                        if(mapOldObjects!=Null && oldRecord.APTS_SSD_Sold_To__c!=null && oldRecord.APTS_SSD_Sold_To__c != currentProposal.APTS_SSD_Sold_To__c && currentProposal.Apttus_Proposal__Approval_Stage__c != 'Accepted'){
                            FeedItem post = new FeedItem();
                            post.ParentId = currentProposal.Id;
                            post.Body='SoldTo SSD was changed on Proposal. Newly mapped SSD is existing customer which enabled additional Payment Options. Please discuss Payment Options with Customer again.';
                            postList.add(post);
                            //insert post;
                        }
                      // } 
                        if(ssdRecord.Default_Payment_Method__c != null && (currentProposal.Tax_Payment_Option__c==null || oldRecord.APTS_SSD_Sold_To__c != currentProposal.APTS_SSD_Sold_To__c)){
                            currentProposal.APTS_Payment_Option__c= ssdRecord.Default_Payment_Method__c;
                        }else if(ssdRecord.Default_Payment_Method__c == null && (currentProposal.Tax_Payment_Option__c==null || oldRecord.APTS_SSD_Sold_To__c != currentProposal.APTS_SSD_Sold_To__c)){
                            currentProposal.APTS_Payment_Option__c= 'Payment Express Auto EFT/Auto Charge';    
                        }
                        
                        if(ssdRecord.Bank_Account_Number__c != null && ssdRecord.Bank_Name__c != null && ssdRecord.Bank_Routing_Number__c != null)
                        {
                            currentProposal.APTS_Bank_Account_Number__c = ssdRecord.Bank_Account_Number__c;
                            currentProposal.APTS_Bank_Name__c = ssdRecord.Bank_Name__c;
                            currentProposal.APTS_Bank_Routing_Number__c = ssdRecord.Bank_Routing_Number__c;
                        }
                        if(ssdRecord.Card_Number__c != null && ssdRecord.Card_Type__c != null && ssdRecord.Expiry_Date__c != null){
                           currentProposal.APTS_Credit_Card_Token__c =  ssdRecord.Card_Number__c;
                           currentProposal.APTS_Card_Type__c = ssdRecord.Card_Type__c;
                           currentProposal.APTS_Card_Expiration_Date__c = ssdRecord.Expiry_Date__c;
                        } 
                    }
                    if(ssdRecord != null && ssdRecord.APTS_Is_Customer__c == false && currentProposal.Tax_Payment_Option__c==null){
                        currentProposal.APTS_Payment_Option__c= 'Payment Express Auto EFT/Auto Charge';    
                    }
                }
                System.debug('currentProposal.APTS_Payment_Option__c : '+currentProposal.APTS_Payment_Option__c);
            }
            if(postList!= null && postList.size()>0){
                insert postList;
            }
        }
    }
    
    //DOC-10572 Ends
// DOC-10193 changes start here
    public static void templateFieldUpdate(Id proposalId)
        {
        system.debug('Inside templatefieldupdate method');
        decimal netvalueDisplayMonthlyRec = 0;
        decimal netvalueDisplayMonthlyOnT = 0;
        decimal netvalueDisplayAnnual = 0;
        decimal netvalueDisplay = 0;
        decimal netvalueDisplayYearly = 0;
        decimal TRenewBilledMonthly = 0;
        decimal TRenewBilledAnnually = 0;
        decimal TModBilledAnnually = 0;
        decimal TModBilledMonthly = 0;
        decimal TotalforCoTerm = 0;
        decimal TotalforCoTermMonthly = 0;
        decimal totalRIODSub = 0;
        decimal totalCLPSOneT = 0;
        decimal totalCLPSSub = 0;
        decimal totalRICLSub = 0;
        decimal totalRisk2PS = 0;
        Apttus_Proposal__Proposal__c proposal;
        List<Apttus_Proposal__Proposal_Line_Item__c> lstProposalLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        List<Apttus_Proposal__Proposal_Line_Item__c> lstProposalLineItemsSCS = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Set<String> rsmllevels2=new Set<String>{'NW','NT','NX'};
        Set<String> PBUs = new Set<String>{'SCS','Canada','Argentina-LLEY','Brazil-TSL','Hong Kong-SMHK','India-INWL','Australia-PNG-LRA','NZ-Fiji-BKRS','FACT-TRFR','Russia-1S','SouthKorea-DUZON','SMGE','Dofiscal'};
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()&&Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
            proposal=[Select XA_Net_Value_Display_Monthly__c,XA_Net_Value_Display_Annual__c,
                      XA_Net_Value_Display_Yearly__c,XA_Net_Value_Display__c,XA_Total_for_Renewal_Billed_Annually__c,XA_Total_for_Renewal_Billed_Monthly__c,
                      XA_Total_Modification_Billed_Annually__c,XA_Total_for_Modification_Billed_Monthly__c,XA_Total_for_Co_Term__c,XA_ProRate_MonthlyCharges__c,
                      APTS_Proposal_Business_Unit__c,XA_Totals_for_CL_PS_Non_Sub_Products__c,XA_Totals_for_RI_Oden_Sub_Prod__c,XA_Totals_for_CL_PS_Sub_Prod__c, 
                      XA_PSONLY_Sub__c,XA_RICL_NOPS__c FROM 
                      Apttus_Proposal__Proposal__c WHERE id =:proposalId LIMIT 1];}
        system.debug('Proposal Record: '+proposal);
        if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible()&&Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){
            lstProposalLineItems = [Select Id, Apttus_QPConfig__NetUnitPrice__c, 
                                    Apttus_QPConfig__NetPrice__c, Apttus_QPConfig__LineStatus__c, APTS_Term_Type__c, Apttus_QPConfig__BillingFrequency__c, 
                                    Apttus_QPConfig__ChargeType__c, Apttus_QPConfig__PriceType__c, APTS_ProRate_Charge__c, Apttus_Proposal__Proposal__c from Apttus_Proposal__Proposal_Line_Item__c where 
                                    Apttus_Proposal__Proposal__c =: proposalId AND APTS_Proposal_Business_Unit__c like '%Tax Professional%'];
            
            lstProposalLineItemsSCS = [Select Id, Apttus_QPConfig__NetUnitPrice__c,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Product__r.APTS_Cat_L5__c, 
                                    Apttus_QPConfig__NetPrice__c, Apttus_QPConfig__LineStatus__c, APTS_Term_Type__c,APTS_Contract_Term__c,APTS_Calculated_Year_1__c,  
                                    Apttus_QPConfig__ChargeType__c, Apttus_QPConfig__PriceType__c, Apttus_Proposal__Proposal__c,APTS_Media_Lower_Level_Code__c,APTS_Media_High_Level_Code__c from Apttus_Proposal__Proposal_Line_Item__c where 
                                    Apttus_Proposal__Proposal__c =: proposalId AND (APTS_Proposal_Business_Unit__c IN :PBUs /*'%SCS%' OR APTS_Proposal_Business_Unit__c like '%Canada%'*/)];
        }
        system.debug('List of PLI: '+lstProposalLineItems);
        system.debug('List of PLI SCS/Canada: '+lstProposalLineItemsSCS);
        
        if(lstProposalLineItems != null && lstProposalLineItems.size() > 0)
        {
            for(Apttus_Proposal__Proposal_Line_Item__c pLI: lstProposalLineItems){
                if( pLI.Apttus_QPConfig__LineStatus__c == 'New' && (pLI.APTS_Term_Type__c != 'Co-Term' && pLI.APTS_Term_Type__c != 'Future Start Date and Co-Term') && 
                   pLI.Apttus_QPConfig__ChargeType__c == 'Subscription Fee')
                {
                    if( pLI.Apttus_QPConfig__BillingFrequency__c== 'Monthly' && pLI.Apttus_QPConfig__NetUnitPrice__c != null )
                    {
                        if(pLI.Apttus_QPConfig__PriceType__c == 'Recurring')
                        {
                            netvalueDisplayMonthlyRec = netvalueDisplayMonthlyRec+pLI.Apttus_QPConfig__NetUnitPrice__c;
                        }
                        if(pLI.Apttus_QPConfig__PriceType__c == 'OneTime')
                        {
                            netvalueDisplayMonthlyOnT = netvalueDisplayMonthlyOnT+pLI.Apttus_QPConfig__NetUnitPrice__c;
                        }
                    }
                    if(pLI.Apttus_QPConfig__BillingFrequency__c== 'Yearly' && pLI.Apttus_QPConfig__NetPrice__c != null )
                    {
                        if(pLI.Apttus_QPConfig__PriceType__c == 'Recurring' )
                        {
                            netvalueDisplayAnnual = netvalueDisplayAnnual+pLI.Apttus_QPConfig__NetPrice__c;
                        }
                        if(pLI.Apttus_QPConfig__PriceType__c == 'OneTime' )
                        {
                            netvalueDisplayYearly = netvalueDisplayYearly+pLI.Apttus_QPConfig__NetPrice__c;
                        }
                    }
                }
                if( pLI.Apttus_QPConfig__LineStatus__c == 'New' && (pLI.APTS_Term_Type__c != 'Co-Term' && pLI.APTS_Term_Type__c != 'Future Start Date and Co-Term') && 
                   pLI.Apttus_QPConfig__ChargeType__c == 'Standard Price' && pLI.Apttus_QPConfig__PriceType__c == 'OneTime' && 
                   pLI.Apttus_QPConfig__NetPrice__c != null)
                {
                    netvalueDisplay = netvalueDisplay+pLI.Apttus_QPConfig__NetPrice__c;
                }
                if( pLI.Apttus_QPConfig__LineStatus__c == 'Renewed' && pLI.APTS_Term_Type__c == null && 
                   pLI.Apttus_QPConfig__ChargeType__c == 'Subscription Fee'&& pLI.Apttus_QPConfig__PriceType__c == 'Recurring')
                {
                    if(pLI.Apttus_QPConfig__BillingFrequency__c== 'Monthly' && pLI.Apttus_QPConfig__NetUnitPrice__c != null)
                    {
                        TRenewBilledMonthly = TRenewBilledMonthly+pLI.Apttus_QPConfig__NetUnitPrice__c;
                    }
                    if(pLI.Apttus_QPConfig__BillingFrequency__c== 'Yearly' && pLI.Apttus_QPConfig__NetPrice__c != null)
                    {
                        TRenewBilledAnnually = TRenewBilledAnnually+pLI.Apttus_QPConfig__NetPrice__c;
                    }
                }
                if( pLI.Apttus_QPConfig__LineStatus__c == 'Amended' && pLI.APTS_Term_Type__c == null && 
                   pLI.Apttus_QPConfig__ChargeType__c == 'Subscription Fee'&& pLI.Apttus_QPConfig__PriceType__c == 'Recurring')
                {
                    if(pLI.Apttus_QPConfig__BillingFrequency__c== 'Monthly' && pLI.Apttus_QPConfig__NetUnitPrice__c != null)
                    {
                        TModBilledMonthly = TModBilledMonthly+pLI.Apttus_QPConfig__NetUnitPrice__c;
                    }
                    if(pLI.Apttus_QPConfig__BillingFrequency__c== 'Yearly' && pLI.Apttus_QPConfig__NetPrice__c != null)
                    {
                        TModBilledAnnually = TModBilledAnnually+pLI.Apttus_QPConfig__NetPrice__c;
                    }
                }
                if( pLI.Apttus_QPConfig__LineStatus__c == 'New' && pLI.Apttus_QPConfig__ChargeType__c == 'Subscription Fee'
                   && pLI.Apttus_QPConfig__PriceType__c == 'Recurring' && pLI.APTS_ProRate_Charge__c != null)
                {
                    if(pLI.Apttus_QPConfig__BillingFrequency__c== 'Yearly')
                    {
                        TotalforCoTerm = TotalforCoTerm+pLI.APTS_ProRate_Charge__c;
                    }
                    if(pLI.Apttus_QPConfig__BillingFrequency__c== 'Monthly')
                    {
                        TotalforCoTermMonthly = TotalforCoTermMonthly+pLI.APTS_ProRate_Charge__c;
                    }

                }
                
            }
        }
        proposal.XA_Net_Value_Display_Monthly__c = netvalueDisplayMonthlyRec;
        proposal.XA_Net_Value_Display_Sub_OT_Monthly__c = netvalueDisplayMonthlyOnT;
        proposal.XA_Net_Value_Display_Annual__c = netvalueDisplayAnnual;
        proposal.XA_Net_Value_Display_Yearly__c = netvalueDisplayYearly;
        proposal.XA_Net_Value_Display__c = netvalueDisplay;
        proposal.XA_Total_for_Renewal_Billed_Annually__c = TRenewBilledAnnually;
        proposal.XA_Total_for_Renewal_Billed_Monthly__c = TRenewBilledMonthly;
        proposal.XA_Total_Modification_Billed_Annually__c = TModBilledAnnually;
        proposal.XA_Total_for_Modification_Billed_Monthly__c = TModBilledMonthly;
        proposal.XA_Total_for_Co_Term__c = TotalforCoTerm;
        proposal.XA_ProRate_MonthlyCharges__c = TotalforCoTermMonthly;    
        system.debug('Net Value Display Monthly Recurring: '+proposal.XA_Net_Value_Display_Monthly__c);
        system.debug('Net Value Display Monthly OneTime: '+proposal.XA_Net_Value_Display_Sub_OT_Monthly__c);
        system.debug('Net Value Display Annual: '+proposal.XA_Net_Value_Display_Annual__c);
        system.debug('Net Value Display Yearly: '+proposal.XA_Net_Value_Display_Yearly__c);
        system.debug('Net Value Display: '+proposal.XA_Net_Value_Display__c);
        system.debug('Total for Renewal Billed Annually: '+proposal.XA_Total_for_Renewal_Billed_Annually__c);
        system.debug('Total for Renewal Billed Monthly: '+proposal.XA_Total_for_Renewal_Billed_Monthly__c);
        system.debug('Total for Modification Billed Monthly: '+proposal.XA_Total_for_Modification_Billed_Monthly__c);
        system.debug('Total for Co-Term: '+proposal.XA_Total_for_Co_Term__c);
        system.debug('Total for Co-Term Monthly: '+proposal.XA_ProRate_MonthlyCharges__c);
        if(lstProposalLineItemsSCS != null && lstProposalLineItemsSCS.size() > 0)
        {
            for(Apttus_Proposal__Proposal_Line_Item__c pLI: lstProposalLineItemsSCS)
            {
                if( pLI.Apttus_QPConfig__LineStatus__c == 'New' && pLI.Apttus_QPConfig__NetPrice__c != null )
                {  
                   if( pLI.Apttus_QPConfig__ChargeType__c == 'Subscription Fee' && pLI.Apttus_QPConfig__PriceType__c == 'Recurring' && pLI.APTS_Contract_Term__c != null )
                    {
                        //if(pLI.APTS_Proposal_Business_Unit__c != null && !System.Label.Risk_PBUs.contains(pLI.APTS_Proposal_Business_Unit__c))
                        //{
                            if(pLI.APTS_Media_High_Level_Code__c == '05' && pLI.APTS_Media_Lower_Level_Code__c == 'E9')
                            {
                                totalCLPSSub = totalCLPSSub+pLI.Apttus_QPConfig__NetPrice__c;
                            }
                            if((pLI.APTS_Media_High_Level_Code__c == '05' && pLI.APTS_Media_Lower_Level_Code__c == 'NZ') || 
                                (pLI.APTS_Media_High_Level_Code__c == '06' && pLI.APTS_Media_Lower_Level_Code__c == 'AB') ||
                                (pLI.APTS_Media_High_Level_Code__c == '13' && rsmllevels2.contains(pli.APTS_Media_Lower_Level_Code__c)))
                            {
                                totalRIODSub = totalRIODSub+pLI.Apttus_QPConfig__NetPrice__c;
                            }
                       // }
                       // else{
                                if(((pLI.APTS_Media_High_Level_Code__c == '05' && pLI.APTS_Media_Lower_Level_Code__c == 'E9') || 
                                    (pLI.APTS_Media_High_Level_Code__c == '06' && pLI.APTS_Media_Lower_Level_Code__c == 'AB') ||
                                    ((pLI.APTS_Media_High_Level_Code__c == '05'|| pLI.APTS_Media_High_Level_Code__c == '26') && 
                                    (pLI.APTS_Media_Lower_Level_Code__c == null || pLI.APTS_Media_Lower_Level_Code__c =='' )))
                                    && pLI.APTS_Calculated_Year_1__c != null && pLI.Apttus_Proposal__Product__r.APTS_Cat_L5__c != System.Label.Risk_CatL5_PS_Value)    
                                {
                                    totalRICLSUb = totalRICLSUb+pLI.APTS_Calculated_Year_1__c;
                                }
                                
                                if(((pLI.APTS_Media_High_Level_Code__c == '05'|| pLI.APTS_Media_High_Level_Code__c == '26') && 
                                    (pLI.APTS_Media_Lower_Level_Code__c == null || pLI.APTS_Media_Lower_Level_Code__c =='' ))&&
                                    pLI.APTS_Calculated_Year_1__c != null && pLI.Apttus_Proposal__Product__r.APTS_Cat_L5__c == System.Label.Risk_CatL5_PS_Value)    
                                {    
                                    totalRisk2PS= totalRisk2PS+pLI.APTS_Calculated_Year_1__c;
                                }
                        //}
                        
                    }
                    if( pLI.Apttus_QPConfig__ChargeType__c == 'Standard Price' && pLI.Apttus_QPConfig__PriceType__c == 'One Time' )
                    {
                        if((pLI.APTS_Media_High_Level_Code__c == '05'|| pLI.APTS_Media_High_Level_Code__c == '26') && (pLI.APTS_Media_Lower_Level_Code__c == null || pLI.APTS_Media_Lower_Level_Code__c =='' ))
                        {
                            totalCLPSOneT = totalCLPSOneT+pLI.Apttus_QPConfig__NetPrice__c;
                        }
                    }    
                }
        
            }            
        }
        proposal.XA_Totals_for_CL_PS_Sub_Prod__c = totalCLPSSub;
        proposal.XA_Totals_for_RI_Oden_Sub_Prod__c = totalRIODSub;
        proposal.XA_Totals_for_CL_PS_Non_Sub_Products__c = totalCLPSOneT;
        proposal.XA_PSONLY_Sub__c = totalRisk2PS;
        proposal.XA_RICL_NOPS__c = totalRICLSUb;
        system.debug('Totals for CL/PS Non Sub Products: '+proposal.XA_Totals_for_CL_PS_Non_Sub_Products__c);
        system.debug('Totals for RI/Oden Subscription Products: '+proposal.XA_Totals_for_RI_Oden_Sub_Prod__c);
        system.debug('Totals for CL/PS Subscription Products: '+proposal.XA_Totals_for_CL_PS_Sub_Prod__c);
        system.debug('Total for Risk PS Sub Products: '+proposal.XA_PSONLY_Sub__c);
        system.debug('Totals for RI/CL Subscription Products: '+proposal.XA_RICL_NOPS__c);
        if(proposal != null && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
            update proposal;
        }
    }
    //DOC-10193 changes ends here

    
}