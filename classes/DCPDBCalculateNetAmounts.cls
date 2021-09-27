/********************************************************************************
Class Name : DCPDBCalculateNetAmounts
@description : This class used in dynamic bundling for creating groups.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
12/07/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDBCalculateNetAmounts{ 

    /** 
    @description Calculating netAmount, grossAmount, incrementalRevenue, incrementalRevenueRequired, allowKeepTerms, maxDiscountedAmount 
    @param lineItemsOfGroup list of line item groups
    @return Returns List<Decimal> which contains the amounts 
    */
    public static List<Decimal> calculateNets(List<Apttus_Config2__LineItem__c> lineItemsOfGroup){      

        Map<String,Decimal> calculateNetsVariableMap = new Map<String,Decimal>{'netAmount'=>0,'grossAmount'=>0,'incrementalRevenue'=>0,
            'incrementalRevenueRequired'=>0,'allowKeepTerms'=>0,'maxDiscountedAmount'=>0};
        //Decimal netAmount = 0;
        //Decimal grossAmount = 0;
        //Decimal incrementalRevenue = 0;
        Decimal incrementalRevenueRequired = 0;
        //Decimal allowKeepTerms = 0;
        //Decimal incrementalValueNeeded = 0;
        Decimal maxDiscountedAmount = 0;
        Apttus_Config2__LineItem__c li;
        for(Apttus_Config2__LineItem__c ln : lineItemsOfGroup){
            
            calculateNetsNetPriceLogic(calculateNetsVariableMap,ln );
            calculateNetsExtendedPriceLogic(calculateNetsVariableMap,ln );

            li = checkLineItem(li,ln);
        }

        incrementalRevenueRequired = calculateNetsVariableMap.get('incrementalRevenueRequired');
        incrementalRevenueRequired *= DCPDynamicBundling.configBundleCS.Incremental_Revenue_Required__c;
        calculateNetsVariableMap.put('incrementalRevenueRequired',incrementalRevenueRequired);

        if(calculateNetsVariableMap.get('grossAmount') == 0){
            maxDiscountedAmount = 0;
        }
        else{
            maxDiscountedAmount = calculateNetsVariableMap.get('maxDiscountedAmount') / calculateNetsVariableMap.get('grossAmount');
        }
        calculateNetsVariableMap.put('maxDiscountedAmount',maxDiscountedAmount);


        return new List<Decimal>{calculateNetsVariableMap.get('netAmount'), calculateNetsVariableMap.get('grossAmount'), 
            calculateNetsVariableMap.get('incrementalRevenue'), calculateNetsVariableMap.get('incrementalRevenueRequired'), 
            calculateNetsVariableMap.get('allowKeepTerms'), calculateNetsVariableMap.get('maxDiscountedAmount')};
    }

    private static void calculateNetsExtendedPriceLogic(Map<String,Decimal> calculateNetsVariableMap ,Apttus_Config2__LineItem__c ln ){
        Decimal grossAmount = calculateNetsVariableMap.get('grossAmount');
        Decimal maxDiscountedAmount = calculateNetsVariableMap.get('maxDiscountedAmount');

        if(ln.Apttus_Config2__ExtendedPrice__c != null){
        
            Set<String> setOfWPKValid = new Set<String>(DCPDynamicBundling.configBundleCS.WestPack_valid_codes__c.split(','));
            grossAmount += ln.Apttus_Config2__ExtendedPrice__c;
            Decimal discountAmount = !setOfWPKValid.contains(ln.APTS_SAP_Deal_Type__c) ? DCPDynamicBundling.configBundleCS.APTS_Max_Discount__c : DCPDynamicBundling.configBundleCS.APTS_WestPack_Discount__c;
            maxDiscountedAmount += ln.Apttus_Config2__ExtendedPrice__c * discountAmount/100;
            
        }

        calculateNetsVariableMap.put('grossAmount',grossAmount);
        calculateNetsVariableMap.put('maxDiscountedAmount',maxDiscountedAmount);
    }
    
    private static void calculateNetsNetPriceLogic(Map<String,Decimal> calculateNetsVariableMap ,Apttus_Config2__LineItem__c ln ){
        Decimal netAmount = calculateNetsVariableMap.get('netAmount');
        Decimal incrementalRevenue = calculateNetsVariableMap.get('incrementalRevenue');
        Decimal incrementalRevenueRequired = calculateNetsVariableMap.get('incrementalRevenueRequired');
        Decimal allowKeepTerms = calculateNetsVariableMap.get('allowKeepTerms');


        if(ln.Apttus_Config2__NetPrice__c != null){
            netAmount += ln.Apttus_Config2__NetPrice__c;
            if(ln.Apttus_Config2__LineStatus__c == 'New'){
                incrementalRevenue += ln.Apttus_Config2__NetPrice__c;
            }    
            else{
                if(ln.APTS_SAP_Deal_Number__c == null){
                    incrementalRevenueRequired += ln.Apttus_Config2__ExtendedPrice__c - ln.Apttus_Config2__NetPrice__c;
                }
                allowKeepTerms = 1;
            }
        }

        calculateNetsVariableMap.put('netAmount',netAmount);
        calculateNetsVariableMap.put('incrementalRevenue',incrementalRevenue);
        calculateNetsVariableMap.put('incrementalRevenueRequired',incrementalRevenueRequired);
        calculateNetsVariableMap.put('allowKeepTerms',allowKeepTerms);

    }

    private static Apttus_Config2__LineItem__c checkLineItem(Apttus_Config2__LineItem__c li,Apttus_Config2__LineItem__c ln){
        if(li==null || li.Apttus_Config2__NetPrice__c < ln.Apttus_Config2__NetPrice__c){
            return ln;
        }
        return li;
    }

    /** 
    @description to populate APTS_Primary_Material__c and bundle wrapper
    @param grp group on which operation has to be done
    */
    public static void setGroupPrimaryMaterial(APTS_Group__c grp){

        Apttus_Config2__LineItem__c li = getFirstLineItem(DCPDynamicBundling.bundlewrapper.lnItems);
        if(null !=  li){
            System.debug(LoggingLevel.DEBUG,'li.APTS_Group_Primary_Material_Name__c ---- '+li.APTS_Group_Primary_Material_Name__c);
            System.debug(LoggingLevel.DEBUG,'-------------group--'+ li.APTS_Product_Group_Primary_Material__c.substring(0,li.APTS_Product_Group_Primary_Material__c.indexOf(':')));
            String primaryMat = li.APTS_Product_Group_Primary_Material__c.substring(0,li.APTS_Product_Group_Primary_Material__c.indexOf(':'));
            grp.APTS_Primary_Material__c = primaryMat;
            System.debug(LoggingLevel.DEBUG,'primaryMat -----------'+ primaryMat);
            DCPDynamicBundling.bundlewrapper.materialNumber = li.APTS_Product_Group_Primary_Material__c.substring(li.APTS_Product_Group_Primary_Material__c.indexOf(':')+1,li.APTS_Product_Group_Primary_Material__c.length());
            DCPDynamicBundling.bundlewrapper.matrialMap.put(li.Apttus_Config2__ConfigurationId__c, DCPDynamicBundling.bundlewrapper.materialNumber);
        }
    }
    
     private static Apttus_Config2__LineItem__c getFirstLineItem(List<Apttus_Config2__LineItem__c> lnItems){

        if(lnItems != null && lnItems.size() > 0){
            return lnItems.get(0);
        }
        else{
            return new Apttus_Config2__LineItem__c();
        }
    }
}