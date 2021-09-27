/**
 * @description Apex Class 'APTS_FL_LineItemTriggerHelper'
 */
public with sharing class APTS_FL_LineItemTriggerHelper3 { 
    /**
     * @description Method created for SOC-7051  from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @return lineitem
     */
    public static Apttus_Config2__LineItem__c returnLineItemRLPApp(Apttus_Config2__LineItem__c lineItem){
        
        //SOC-7051 starts,Added by Keerthana            
        if(lineItem.APTS_RLP_FLApproval_Required__c 
            && lineItem.APTS_Rep_Type_Description__c 
            && lineItem.APTS_Proposal_Business_Unit__c=='Findlaw'
            && lineItem.Apttus_Config2__LineStatus__c == 'Renewed'){              
                lineItem.APTS_RepType_Approval_Required__c=true;
                lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                system.debug(LoggingLevel.WARN,'##### In');
        }
       return lineItem;
    }
    
    /**
     * @description Added product codes for IME2 and CORE as part of SOC-9084.Method created from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @param firmSiteIMCodes
     * @param firmSiteQuanity
     * @return lineItem
     */
    public static Apttus_Config2__LineItem__c returnFSIMAppRequired(Apttus_Config2__LineItem__c lineItem, Set<String> firmSiteIMCodes, Decimal firmSiteQuanity){
        System.debug(LoggingLevel.WARN,'lineItem.APTS_Product_Code__c---'+lineItem.APTS_Product_Code__c);
        //SOC-8550
        //added product codes for IME2 and CORE as part of SOC-9084
        if(firmSiteIMCodes.contains(lineItem.APTS_Product_Code__c) && firmSiteQuanity>1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
            lineItem.APTS_FS_IM_Approval_Required__c= true;
            system.debug(LoggingLevel.WARN,'lineItem.APTS_FS_IM_Approval_Required__c'+lineItem.APTS_FS_IM_Approval_Required__c);
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
            system.debug(LoggingLevel.WARN,'##### In');
            
        }
        return lineItem;
    }

    /**
     * @description SOC-9193.Method created from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @param flNFCSubdomain
     * @return lineItem
     */
    public static Apttus_Config2__LineItem__c returnNFCQTYAppRequired(Apttus_Config2__LineItem__c lineItem, Decimal flNFCSubdomain){
        system.debug(LoggingLevel.WARN,'flNFCSubdomain-----:'+flNFCSubdomain);
        //SOC-9193
        if(lineItem.APTS_Product_Code__c == '42594853' && flNFCSubdomain >1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
            lineItem.APTS_NFC_Qty_Approval_Required__c= true;
            system.debug(LoggingLevel.WARN,'lineItem.APTS_NFC_Qty_Approval_Required__c---'+lineItem.APTS_NFC_Qty_Approval_Required__c);
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';   
            system.debug(LoggingLevel.WARN,'##### In');
        }
        return lineItem;
    }
    /**
     * @description SOC-9890.Method created from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @param fNDLWPremiumTotal
     * @return lineItem
     */
    public static Apttus_Config2__LineItem__c returnMaxQtyAppRequired1(Apttus_Config2__LineItem__c lineItem, Decimal fNDLWPremiumTotal){

        if(lineItem.APTS_Product_Code__c == '41053157' && fNDLWPremiumTotal > 1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
            lineItem.APTS_MaxQuantity_Approval_Required__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';  
            system.debug(LoggingLevel.WARN,'##### In');
        }
        return lineItem;
    }
    /**
     * @description SOC-9890.Method created from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @param fNDLWADDLCALLTRACKINGNUMBERTotal
     * @return lineItem
     */
    public static Apttus_Config2__LineItem__c returnMaxQtyAppRequired2(Apttus_Config2__LineItem__c lineItem, Decimal fNDLWADDLCALLTRACKINGNUMBERTotal){

        if(lineItem.APTS_Product_Code__c == '40586465' && fNDLWADDLCALLTRACKINGNUMBERTotal > 1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
            lineItem.APTS_MaxQuantity_Approval_Required__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';  
            system.debug(LoggingLevel.WARN,'##### In');
        }
        return lineItem;
    }
    /**
     * @description SOC-9890.Method created from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @param fNDLWLawinfoCallTrackingNumberTotal
     * @return lineItem
     */
    public static Apttus_Config2__LineItem__c returnMaxQtyAppRequired3(Apttus_Config2__LineItem__c lineItem, Decimal fNDLWLawinfoCallTrackingNumberTotal){

        if(lineItem.APTS_Product_Code__c == '41895338'&& fNDLWLawinfoCallTrackingNumberTotal > 1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
            lineItem.APTS_MaxQuantity_Approval_Required__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required'; 
            system.debug(LoggingLevel.WARN,'##### In');
        }
        return lineItem;
    }
}