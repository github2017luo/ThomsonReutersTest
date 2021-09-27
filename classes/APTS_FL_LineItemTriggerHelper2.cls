/**
 * @description Apex Class 'APTS_FL_LineItemTriggerHelper'
 */
public with sharing class APTS_FL_LineItemTriggerHelper2 { 
    /**
     * @description Method created for SOC-4589 from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @return lineitem
     */
    public static Apttus_Config2__LineItem__c returnLineItemAnnualSpendApp(Apttus_Config2__LineItem__c lineItem){
        //Added by Gowthami for SOC-4589 FL-Annual Spend Approval  
        if(annualSpendCalc(lineItem)){
            lineItem.APTS_FL_AnnualApprovalRequired__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';     
            system.debug(LoggingLevel.WARN,'!!!!!'+lineitem.APTS_FL_Annual_spend_Calc__c);   
        }   

        if(lineItem.Apttus_Config2__LineStatus__c == 'New' 
                && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' 
                && (lineItem.APTS_Product_Code__c == '42532853' || lineItem.APTS_Product_Code__c == '42532855') 
                && lineitem.APTS_FL_Annual_spend_Calc__c > 200000 ){
            lineItem.APTS_FL_AnnualApprovalRequired__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required'; 
            system.debug(LoggingLevel.WARN,'##### In');
        }
        return lineItem;
    }
    @testVisible
    private static Boolean annualSpendCalc(Apttus_Config2__LineItem__c lineItem){
        Boolean flag= false;
        if(lineItem.Apttus_Config2__LineStatus__c == 'New' 
            && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' 
            && (lineItem.APTS_Product_Code__c == '42532854' || lineItem.APTS_Product_Code__c == '42532852') 
            && lineitem.APTS_FL_Annual_spend_Calc__c >100000 ){
                flag= true;
        }
        return flag;
    }

    /**
     * @description Method created for SOC-4550 and SOC-6861 from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @param flcodeMap
     * @param mapOfIdLineItems
     * @return lineitem
     */
    public static Apttus_Config2__LineItem__c returnLineItemApprReqdChckBox(Apttus_Config2__LineItem__c lineItem, Map<String,List<String>> flcodeMap, Map<Id,Apttus_Config2__LineItem__c> mapOfIdLineItems){
        //Added by Deepthi Shirangala for SOC-4550 and SOC-6861
           //7. Logic to populate 'PPC Approval Required Checkbox'
        if((returnRoundedValue(lineItem, mapOfIdLineItems)) && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' 
            && (lineItem.APTS_Product_Code__c != '41876119'  || lineItem.APTS_Product_Code__c != '41877783' )
            && lineItem.APTS_Product_Code__c != '41877783' && flcodeMap.get('PPC MANAGEMENT').contains(lineItem.APTS_CAT_L5__c) 
            && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c <> null ){
            lineItem.APTS_PPC_Approval_Required__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
            system.debug(LoggingLevel.WARN,'!!!!!!!!!!!!!!!'+lineitem.APTS_PPC_Approval_Required__c); 
        }
        return lineItem;
    }
    @testVisible
    private static Boolean returnRoundedValue(Apttus_Config2__LineItem__c lineItem, Map<Id,Apttus_Config2__LineItem__c> mapOfIdLineItems){
        if(lineItem.APTS_PPC_Rounded_Value__c <500 || lineItem.APTS_PPC_Rounded_Value__c>10000 || mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Mgmt_Fee_Override__c >0){
            return true;
        }
        return false;
    }

    /**
     * @description Method created for SOC-9188 from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @param flcodeMap
     * @return lineitem
     */
    public static Apttus_Config2__LineItem__c returnLineItemShortTermOptn(Apttus_Config2__LineItem__c lineItem, Map<String,List<String>> flcodeMap){
        //SOC-9188
        /* Requirement is to implement Additional Short Term Options of 1 and 2 Month for PPC & requiring approval */
        if((flcodeMap.get('PPC MANAGEMENT').contains(lineItem.APTS_CAT_L5__c) || lineItem.APTS_Product_Code__c == '42594853') 
            && lineItem.Apttus_Config2__LineStatus__c == 'New'
            && (lineItem.APTS_Contract_Term__c =='1 Month' || lineItem.APTS_Contract_Term__c =='2 Months')){
            lineItem.APTS_PPC_Approval_Required__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required'; 
            system.debug(LoggingLevel.WARN,'##### In');
       }
       return lineItem;
    }

    
}