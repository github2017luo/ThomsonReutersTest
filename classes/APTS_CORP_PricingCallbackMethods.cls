/**
* Pricing callback used for Corporate Business Unit to get price from SAP 
* @author Keerthana Thallam
* @version 7/2/2019 as part of DOC-1043
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
*/
public with sharing class APTS_CORP_PricingCallbackMethods{
    //Start: Added by Kruti Shah (DOC-2007-2008,1577)
    public static void defaultContractTermYOYRenewalType(List<Apttus_Config2__LineItem__c> bundleItems, Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap){
        System.debug('Artem bundleItems' + lineNumberToOptionsMap.size());
        //For all the bundle level ones
           for(Apttus_Config2__LineItem__c lineItem : bundleItems){
            if(lineItem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' || lineItem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK'){
                if(lineItem.APTS_Contract_Term__c == null && lineItem.Apttus_Config2__PriceType__c != 'One Time')
                    lineItem.APTS_Contract_Term__c = lineItem.APTS_Contract_Term_Default__c;
                if(lineItem.APTS_Years_2_Plus_Adjustment__c == null && lineItem.Apttus_Config2__PriceType__c != 'One Time')
                    lineItem.APTS_Years_2_Plus_Adjustment__c = String.valueOf(lineItem.APTS_Years_2_Plus_Default__c);
                //DOC-4350 starts
                if(lineItem.APTS_Yr_1_Renewal_Adjustment__c == null && lineItem.Apttus_Config2__PriceType__c != 'One Time' && lineItem.APTS_Yr_1_Renewal_Default__c!=null)
                    lineItem.APTS_Yr_1_Renewal_Adjustment__c = String.valueOf(lineItem.APTS_Yr_1_Renewal_Default__c);
                //DOC-4350 ends
                if(lineItem.APTS_Renewal_Type__c == null)
                    lineItem.APTS_Renewal_Type__c = lineItem.APTS_Renewal_Type_Default__c;         
                if(lineItem.APTS_WLEC_Product_Category__c != null && lineItem.APTS_WLEC_Product_Category__c =='PS'){
                    if(lineItem.Apttus_Config2__BillingFrequency__c == null && (lineItem.APTS_Item_Category_Group__c != null && lineItem.APTS_Item_Category_Group__c != 'ZRRB'))
                    lineItem.Apttus_Config2__BillingFrequency__c = lineItem.APTS_Billing_Frequency_Default__c;
                    
                }
            }
			 //Added as part of DOC-12660 for Risk Sep Release
            if(lineItem.APTS_Proposal_Business_Unit__c !=null && System.Label.Risk_PBUs.contains(lineItem.APTS_Proposal_Business_Unit__c))
            {
                system.debug('RK --> YOY1Renew'+lineItem.APTS_Yr_1_Renewal_Default__c);
                if(lineItem.APTS_Yr_1_Renewal_Adjustment__c == null && lineItem.Apttus_Config2__PriceType__c != 'One Time' && lineItem.Apttus_Config2__LineStatus__c=='Renewed')
                    lineItem.APTS_Yr_1_Renewal_Adjustment__c = String.valueOf(lineItem.APTS_Yr_1_Renewal_Default__c);

            }
        }
    }
    //End: added by Kruti Shah (DOC-2007-2008,1577)
}