/**
 * @description Apex Class 'APTS_FL_LineItemTriggerHelper'
 */
public with sharing class APTS_FL_LineItemTriggerHelper1 { 
    /**
     * @description Method created for SOC-6724 from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineitem
     * @param anualSpend
     * @return lineitem
     */
    public static Apttus_Config2__LineItem__c returnLineItemAnnualSpendCalc(Apttus_Config2__LineItem__c lineitem, Decimal anualSpend){
        Decimal flCalcattheend =0;
        //SOC-6724 Start
        if(lineitem.Apttus_Config2__LineType__c =='Product/Service' && lineitem.Apttus_Config2__LineStatus__c == 'New' && lineitem.Apttus_Config2__ChargeType__c == 'Subscription Fee' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineitem.Apttus_Config2__NetPrice__c!=null){
            flCalcattheend = flCalcattheend+lineitem.Apttus_Config2__NetPrice__c;}                                                 
        if(anualSpend!=null){
            lineitem.APTS_FL_Annual_spend_Calc__c=flCalcattheend+anualSpend; 
            system.debug(LoggingLevel.WARN,'!!!!!'+lineitem.APTS_FL_Annual_spend_Calc__c);  
         }             
        else{
            lineitem.APTS_FL_Annual_spend_Calc__c=flCalcattheend; 
            system.debug(LoggingLevel.WARN,'!!!!!'+lineitem.APTS_FL_Annual_spend_Calc__c);  
          }        
      //SOC-6724 End 
      return lineitem;
    }

    /**
     * @description Method created for SOC-9197 from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @return lineitem
     */
    public static Apttus_Config2__LineItem__c returnLineItemExposurePack(Apttus_Config2__LineItem__c lineItem){
        //AS part of SOC-9197 added exposure pack discount condition
        if(hasExposureDisc(lineItem)){
            system.debug(LoggingLevel.WARN,'entered findlaw approval condition');
            lineItem.Findlaw_Approval_Required__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';     
        system.debug(LoggingLevel.WARN,'##### In');                
        }
        //soc-9197
        if(lineItem.APTS_Exposure_Pack_Disc__c!=null && lineItem.APTS_Exposure_Pack_Disc__c!=0 && lineItem.Apttus_Config2__AdjustmentAmount__c!=null && lineItem.APTS_Exposure_Pack_Disc__c!=lineItem.Apttus_Config2__AdjustmentAmount__c && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw'){
            lineItem.APTS_ExposurePack_Approval_Required__c = true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';  
            system.debug(LoggingLevel.WARN,'##### In');
        }
        return lineItem;
    }

    @testVisible
    private static Boolean hasExposureDisc(Apttus_Config2__LineItem__c lineItem){
        Boolean flag= false;
        if((lineItem.Apttus_Config2__LineStatus__c == 'Renewed' 
            && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' 
            && lineItem.APTS_Renewal_Approval_Required__c== true) || (lineItem.Apttus_Config2__LineStatus__c == 'New'&& lineItem.APTS_Contract_Term__c=='1 Year' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.APTS_IMS_IME_Product__c==true)){
                flag= true;
            }
        return flag;
    }

    /**
     * @description Method created for SOC-7996 from Class 'APTS_FL_LineItemTriggerHelper' to reduce complexity as a part of PMD Fix
     * @param lineItem
     * @return lineitem
     */
    public static Apttus_Config2__LineItem__c returnLineItemContractYear(Apttus_Config2__LineItem__c lineItem){
        //Added by Gowthami for SOC-7996 FL:Approval for Contract 2 or 3 yr 
        system.debug(LoggingLevel.WARN,'!!!!!'+lineitem.APTS_FL_Annual_spend_Calc__c);  
        if((lineItem.Apttus_Config2__LineStatus__c == 'Renewed' ||lineItem.Apttus_Config2__LineStatus__c == 'New') 
            && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' 
            && (lineItem.APTS_Contract_Term__c=='2 Years' || lineItem.APTS_Contract_Term__c=='3 Years') 
            && hasProductCode(lineItem)){
            lineItem.APTS_Answer_Service_Approval__c= true;
            lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';  
        system.debug(LoggingLevel.WARN,'##### In');                
        } 
        return lineItem;
    }
    @testVisible
    private static Boolean hasProductCode(Apttus_Config2__LineItem__c lineItem){
        Boolean flag= false;
        if((lineItem.APTS_Product_Code__c =='42532852' || lineItem.APTS_Product_Code__c == '42532853' || lineItem.APTS_Product_Code__c == '42532854' || lineItem.APTS_Product_Code__c == '42532855' )){
            flag= true;
        }
        return flag;
    }
    
}