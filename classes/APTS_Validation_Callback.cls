/* GLI Changes:
1. Changed Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c to Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c
2. Changed Apttus_Config2__AccountId__c of Apttus_Config2__AssetLineItem__c to APTS_SSD_Sold_To__c
3. Changed cart.getConfigSO().Apttus_Config2__AccountId__c to cart.getConfigSO().APTS_SSD_Sold_To__c - Reference : APTS_AssetLineItemCallback
*/
global with sharing class APTS_Validation_Callback implements Apttus_Config2.CustomClass.IValidationCallback2 {
    final static string CORP_SELECT_PRIMARY_ESSENTIALS = 'Primary Essentials';
    final static string CORP_SELECT_PRIMARY = 'Primary';
    
    global Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) {
      Set<String> glpQuantity = new Set<String>(); //GLP-58
      //Skip the following code execute for TRStore 
      if(!UserInfo.getUserType().equalsIgnoreCase(Static_Values__c.getAll().get('skiptoNullifyCreditCardDetails').Value__c)){   
    
        Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true);
        Apttus_Config2.CustomClass.ValidationResult result1= new Apttus_Config2.CustomClass.ValidationResult(true);        
        Map<Id, Apttus_Config2__LineItem__c> groupIdToLineItems = new Map<Id, Apttus_Config2__LineItem__c>();
        System.debug('**c*****');  
        Boolean slTopspot =false;       
        //if(cart.getConfigSO().Apttus_Config2__Status__c == 'Finalized'){ // Commenting if condition, because Validation is calling before status changes to Finalized
        
        Map<String, APTS_ConfigBundlePageSettings__c> configBundlePageList = APTS_ConfigBundlePageSettings__c.getall();
        
        //Changes made for SOC-3525 - Bridge Discount Field  on 31/03/17 //SOC-5987 Added APTS_Is_Special_Offer_Lapsed__c //May Release Adding APTS_Group_Primary_Material_Name__c
        if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible() && !Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()){
            return null;
        }
        List<Apttus_Config2__LineItem__c> lineItems = [SELECT ApTS_Year_2_3_Price__c,Apttus_Config2__EndDate__c,APTS_Years_2_Plus_Adjustment__c,APTS_Product_Name__c,Apttus_Config2__AssetLineItemId__c,
                                                       Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Description,
                                                       APTS_Approval_Segment__c,APTS_Proposal_Business_Unit__c,Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c,
                                                       Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, 
                                                       Apttus_Config2__ProductId__c,Apttus_Config2__LineStatus__c,APTS_Group__c,APTS_Proposal_Group__c, 
                                                       APTS_Bridge__c, APTS_New_Bridge_Discount__c, APTS_Contract_Term__c, Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c,                                                      
                                                       Apttus_Config2__ProductId__r.APTS_Corporate_Select__c, Apttus_Config2__ProductId__r.Name,APTS_Combination_Key__c,Apttus_Config2__ProductId__r.APTS_Attrbased_config__c,
                                                       Apttus_Config2__AttributeValueId__r.APTS_Total_Number_of_Points__c, Apttus_Config2__ChargeType__c,
                                                       APTS_Media_High_Level_Code__c, APTS_Media_Lower_Level_Code__c, APTS_Keep_Terms__c, Apttus_Config2__PriceType__c, 
                                                       Apttus_Config2__Quantity__c, Apttus_Config2__LineType__c, Apttus_Config2__IsPrimaryLine__c, Apttus_Config2__ProductId__r.Family,APTS_Deal_Type__c,
                                                       APTS_Deal_Number__c, APTS_Subscription_Number__c,APTS_Is_Special_Offer_Lapsed__c,APTS_Group_Primary_Material_Name__c,
                                                        Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__BillingFrequency__c,
                                                       Apttus_Config2__AssetLineItemId__r.APTS_SAP_MLA_Agreement_Number__c, APTS_Product_Family__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__Quantity__c,
                                                       APTS_Cat_L2__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.APTS_Cat_L3__c, //Added APTS_SAP_MLA_Agreement_Number__c by CG SOC-8532,Poonam Garg DOC 12648
                                                       APTS_Totaling_Summary_Group__c,APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c,APTS_Bundle__c, 
                                                       Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c, APTS_Item_Category_Group__c, APTS_Term_Type__c  //added for GLP-820, 15634
                                                       FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :cart.getConfigSO().Id];        
        //Akshay changes start
        Apttus_Config2__ProductConfiguration__c productConfig = New Apttus_Config2__ProductConfiguration__c();
        if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible() && !Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()){
            return null;
        }
        productConfig =[Select ID,APTS_Proposal_Business_Unit__c,Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c 
                        from Apttus_Config2__ProductConfiguration__c where ID =:cart.getConfigSO().Id];
        
        System.debug('**c*****'+productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c);   
        if(productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c <> null && productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c =='FindLaw'){
            APTS_FL_Validation_CallbackHelper obj = New APTS_FL_Validation_CallbackHelper();
            result1 = obj.validateCart(cart);
        }else{
            Map<String, APTS_Product_Rules__c> productRuleMap = APTS_Product_Rules__c.getall();
            Set<ID> proIDSet = new Set<ID>();
            Set<ID> purchasedProIDSet = new Set<ID>();
            Set<ID> proWithStatusCancelledIDSet = new Set<ID>();
            Map<String, APTS_Product_Rules__c> materialToProductRuleMap = new Map<String, APTS_Product_Rules__c>();
            Map<ID, Apttus_Config2__AssetLineItem__c> proIdToAssetLineMap = new Map<ID, Apttus_Config2__AssetLineItem__c>();
            Map<ID, Apttus_Config2__AssetLineItem__c> proIdToAssetLineMap1 = new Map<ID, Apttus_Config2__AssetLineItem__c>();//Bijeta  SOC-3874
            Map<String, Apttus_Config2__AssetLineItem__c> proIdToAssetLineMap2 = new Map<String, Apttus_Config2__AssetLineItem__c>();//Bijeta  SOC-5803 //CG SOC-8532
            Map<ID, Apttus_Config2__AssetLineItem__c> proIdToAssetLineMap3 = new Map<ID, Apttus_Config2__AssetLineItem__c>();//Bijeta SOC-5374
            
            boolean isPROFLEXBUNDLE=false;//Added by Bijeta May Release SOC-3675
            Integer smallFIRMCOUNT=0;//Added by Bijeta Mar 2020 Release DOC-7532
            String smallFIRMPAC='';//Added by Bijeta Mar 2020 Release DOC-7532
            boolean isGrpProflex = false; //SOC-5987
            //Iterate over line items to collect the data

            //Start: Added by Kruti Shah (DOC-2630)
            if(productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c <> null && 
            (productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c =='Corp OneOTC US' 
              || productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c =='Corp OneOTC UK'
              || productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c =='Tax Professional' 
              || productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c =='Canada'
              || productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c =='SCS'
              || System.Label.Risk_PBUs.contains(productConfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c))){
              System.debug('KS--> Validation Callback for Corporate called');
              APTS_CORP_Validation_CallbackHelper obj = New APTS_CORP_Validation_CallbackHelper();
              result = obj.validateCart(cart);
            }
            //End: Added by Kruti Shah (DOC-2630)
            
            Integer isHighQLine = 0; // DOC-10390 - Added by Chintan
            Integer proflexProduct = 0;// DOC-11333 - Added by Chintan
       //Added by Bijeta Mar 2020 Release DOC-7532
            if(!Schema.sObjectType.APTS_Integration_Variables__mdt.isAccessible() && !Schema.sObjectType.APTS_Integration_Variables__mdt.isQueryable()){
            return null;
            } 
             List<APTS_Integration_Variables__mdt> sfpList=[Select MasterLabel,Value__c from APTS_Integration_Variables__mdt];
            for(APTS_Integration_Variables__mdt var : sfpList){
                   if(var.masterlabel=='SmallFirmPackage'){
                   smallFIRMPAC=var.Value__c;}
             }
             List<String> smallFIRMPACMETA  = new List<String>();
                smallFIRMPACMETA =smallFIRMPAC.split(',');
            for(Apttus_Config2__LineItem__c lineItem : lineItems)
            {
                proIDSet.add(lineITem.Apttus_Config2__ProductId__c);
                if(lineItem.Apttus_Config2__LineStatus__c == 'Cancelled') {
                    proWithStatusCancelledIDSet.add(lineItem.Apttus_Config2__ProductId__c);
                }            
                //Added by Bijeta May Release SOC-3675, SOC-5987
                if(lineItem.APTS_Group_Primary_Material_Name__c!=null){
                    if(lineItem.APTS_Group_Primary_Material_Name__c.containsIgnoreCase('PROFLEX')){
                        isPROFLEXBUNDLE=true;
                        if(lineItem.APTS_Group__c !=null){ 
                        isGrpProflex = true;}
                    }
                } 
          //Added by Bijeta Mar 2020 Release DOC-7532
                  if((!String.isEmpty(lineItem.Apttus_Config2__ProductId__r.Name) && lineItem.Apttus_Config2__ProductId__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage)) && lineItem.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '06' && (lineItem.Apttus_Config2__LineStatus__c == 'New' || lineItem.Apttus_Config2__LineStatus__c == 'Renewed' || lineItem.Apttus_Config2__LineStatus__c == 'Amended')){
                 if(smallFIRMPACMETA.contains(lineItem.Apttus_Config2__ProductId__r.productcode)){
                    smallFIRMCOUNT = smallFIRMCOUNT+1;
                 } 
                }
                //DOC-6397 Super Lawyer Topspots-Zakeer
                if(lineItem.Apttus_Config2__ProductId__r.productcode =='41618485'){
                    slTopspot = True;
                }                 
                
                //DOC-10390 - Added by Chintan
                if(lineItem.Apttus_Config2__ProductId__r.APTS_Cat_L2__c != null && lineItem.Apttus_Config2__ProductId__r.APTS_Cat_L2__c.equalsIgnoreCase(Label.APTS_HighQ_Product_Family))
                {
                    isHighQLine++;
                }
                
                if(lineItem.Apttus_Config2__ProductId__c != null && lineItem.Apttus_Config2__ProductId__r.productcode != null &&
                   (lineItem.Apttus_Config2__ProductId__r.productcode.equals('41972767')
                   || lineItem.Apttus_Config2__ProductId__r.productcode.equals('40757482')))
                {
                    proflexProduct++;
                }
                
            }  
            if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && !Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
            return null;
            } 
            /********************* AUGUST RELEASE ************/
            List<Apttus_Config2__AssetLineItem__c> assetLineItemList = [SELECT ID, APTS_Combination_Key__c, APTS_PPC_Spend_Type__c, APTS_PPC_Website_Type__c,Apttus_Config2__LineType__c, Apttus_Config2__ProductId__c,Apttus_Config2__Quantity__c,Apttus_Config2__ProductId__r.productcode, Apttus_Config2__AssetStatus__c ,Apttus_Config2__ProductId__r.Name  
                                                                        ,Apttus_Config2__AttributeValueId__c, Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c,Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c,Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c, APTS_Combination_Key__r.APTS_Attribute_Value0__c,APTS_Combination_Key__r.APTS_Attribute_Value1__c ,APTS_Combination_Key__r.APTS_Attribute_Value2__c,APTS_Combination_Key__r.APTS_Attribute_Value3__c  
                                                                        ,APTS_Combination_Key__r.APTS_Configuration_Description__c,APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name FROM Apttus_Config2__AssetLineItem__c                                                                             
                                                                        WHERE APTS_SSD_Sold_To__c = :cart.getConfigSO().APTS_SSD_Sold_To__c And APTS_SSD_Sold_To__c<> null
                                                                        //AND Apttus_Config2__ProductId__c IN : proIDSet
                                                                        AND Apttus_Config2__ProductId__c NOT IN : proWithStatusCancelledIDSet  // SOC-3838 Changed by Chirag 5/23/17
                                                                        AND Apttus_Config2__IsInactive__c = false
                                                                        AND Apttus_Config2__AssetStatus__c != 'Cancelled'];     // SOC-3838 Changed by Chirag 6/27/17
            
            //Bijeta SOC-3874 ,Bijeta SOC-5374, Bijeta  SOC-5803//Added APTS_SAP_MLA_Agreement_Number__c by CG SOC-8532
            List<Apttus_Config2__AssetLineItem__c> assetLIList = [SELECT ID, Name, Apttus_Config2__ProductId__c, APTS_Deal_Type__c, 
                                                   Apttus_Config2__StartDate__c,Apttus_Config2__AssetStatus__c, APTS_Info_PlanType__c, 
                                                   APTS_Deal_Number__c, APTS_Material_Number__c,APTS_Subscription_Number__c,APTS_SAP_MLA_Agreement_Number__c,
                                                   Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, 
                                                   Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__Quantity__c
                                                   FROM Apttus_Config2__AssetLineItem__c 
                                                   WHERE APTS_SSD_Sold_To__c = :cart.getConfigSO().APTS_SSD_Sold_To__c 
                                                                  And APTS_SSD_Sold_To__c  <> null];
            
            //Bijeta SOC-5374
            List<Apttus_Config2__AssetLineItem__c> assetLIDealList = new List<Apttus_Config2__AssetLineItem__c>();
            Set<double> setDealNumber = new Set<double>();  
            for(Apttus_Config2__AssetLineItem__c ass : assetLIList)
            {
                if(ass.APTS_Deal_Type__c=='WCMP' && ass.APTS_Subscription_Number__c !='40666551' && ass.Apttus_Config2__AssetStatus__c=='Activated' && ass.APTS_Deal_Number__c!=Null){
                    setDealNumber.add(ass.APTS_Deal_Number__c); // contains distict Deal number
                    assetLIDealList.add(ass);
                    proIdToAssetLineMap3.put(ass.Apttus_Config2__ProductId__c, ass);
                }
            
            
                //GLP-58: Jinal Bhatt Quantity should be same for all PVIP productd
                if (ass.Apttus_Config2__ProductId__c != null
                   && ass.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c != null 
                   && ass.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c != null 
                   && ass.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '21' 
                   && ass.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'CQ') {
                       if (glpQuantity.isEmpty()) {
                           glpQuantity.add(String.valueOf(ass.Apttus_Config2__Quantity__c));
                       }
                }
                //End GLP-58
            }
            Boolean present=false;//Bijeta  SOC-5803
            Integer countt = 0;//Bijeta  SOC-5803
            Boolean isEligibeTerminate = true;  //Bijeta  SOC-3874
            Integer monthDiff = 0; //Bijeta  SOC-3874
            Set<String> assName = new Set<String>();//Bijeta  SOC-3874
            String assetNames = ''; //Bijeta  SOC-3874
            List<String> installedSFP = new List<String>();//Added by Bijeta Mar 2020 Release DOC-7532
            //Prepare the map of material to Product Rule                                                
            for(APTS_Product_Rules__c proRuleEntry : productRuleMap.values())
            {
                materialToProductRuleMap.put(proRuleEntry.APTS_Same_Material_on_Account__c, proRuleEntry);
            }              
            //Prepare a map of Product ID to asset line item
            for(Apttus_Config2__AssetLineItem__c assetLineItem : assetLineItemList)
            {
                proIdToAssetLineMap.put(assetLineItem.Apttus_Config2__ProductId__c, assetLineItem);
                 //Added by Bijeta Feb 2020 Release DOC-7532
                if(assetLineItem.Apttus_Config2__AssetStatus__c=='Activated' && smallFIRMPACMETA.contains(assetLineItem.Apttus_Config2__ProductId__r.productcode)){
                   installedSFP.add(assetLineItem.Apttus_Config2__ProductId__r.productcode);
                } 
            }
            for(Apttus_Config2__AssetLineItem__c assetLitm : assetLIList )//Bijeta  SOC-5803
            {
                if(assetLitm.APTS_Info_PlanType__c=='S00' && assetLitm.Apttus_Config2__AssetStatus__c=='Activated'){
                    //Added APTS_SAP_MLA_Agreement_Number__c by CG SOC-8532
                    String idplusMLA = assetLitm.Apttus_Config2__ProductId__c + assetLitm.APTS_SAP_MLA_Agreement_Number__c;
                    proIdToAssetLineMap2.put(idplusMLA, assetLitm);
                }
            }
            for(Apttus_Config2__AssetLineItem__c assetLI : assetLIList )//Bijeta  SOC-3874  
            {
                if(assetLI.APTS_Deal_Type__c== 'WCMP' && assetLI.Apttus_Config2__StartDate__c!=null && proIDSet.contains(assetLI.Apttus_Config2__ProductId__c)){
                    monthDiff = 0;
                    Date a = Date.newInstance(assetLI.Apttus_Config2__StartDate__c.year(),assetLI.Apttus_Config2__StartDate__c.month(),assetLI.Apttus_Config2__StartDate__c.day());
                    Date b = Date.newInstance(System.today().year(),System.today().month(),System.today().day());
                    monthDiff = a.monthsBetween(b);
                    if (b.day() > a.day()){ monthDiff++;}
                    if(monthDiff < 12){
                        proIdToAssetLineMap1.put(assetLI.Apttus_Config2__ProductId__c, assetLI);
                        isEligibeTerminate = false;
                    }
                }
            }
            for(Apttus_Config2__LineItem__c lntm : lineItems)
            {
                if(proIdToAssetLineMap1.containsKey(lntm.Apttus_Config2__ProductId__c) && lntm.Apttus_Config2__LineStatus__c == 'Cancelled'){
                    assName.add(proIdToAssetLineMap1.get(lntm.Apttus_Config2__ProductId__c).APTS_Material_Number__c);
                }         
          
       }      
            if(!assName.isempty()){
                for(String s:assName) {
                    assetNames += (assetNames ==''?'':', ')+s;
                }
            }
            //Bijeta SOC-5374
            integer c1 = 0;
            integer c2 = 0;
            boolean dealadded = false;
            For(double deal : setDealNumber){
                For(Apttus_Config2__LineItem__c liItem : lineItems){
                    if(liItem.APTS_Deal_Number__c == deal && liItem.APTS_Subscription_Number__c !='40666551'){
                        c1 = c1+1;
                    }
                }
                For(Apttus_Config2__AssetLineItem__c asliItem : assetLIDealList){
                    if(asliItem.APTS_Deal_Number__c == deal){
                        c2 = c2+1;
                    }
                }                
                if(c1!=0 && c1!=c2){
                    dealadded = true;
                    break;
                }
                c1=0;
                c2=0;
            }
            //Bijeta SOC-5803 - changed lineItem to liItem
            for(Apttus_Config2__LineItem__c liItem : lineItems)
            {
                //Added APTS_SAP_MLA_Agreement_Number__c by CG SOC-8532
                String idplusMLA = liItem.Apttus_Config2__ProductId__c + liItem.Apttus_Config2__AssetLineItemId__r.APTS_SAP_MLA_Agreement_Number__c;
                if(proIdToAssetLineMap2.containsKey(idplusMLA) && liItem.Apttus_Config2__LineStatus__c == 'Cancelled'){
                    countt=countt+1;
                }
            }
            
            if(proIdToAssetLineMap2.size()==countt) {
                Present=true;
            }else{
                Present=false;
            }  
            system.debug('proIdToAssetLineMap2...'+proIdToAssetLineMap2);           
            system.debug('Present...'+Present);            
            
            //Perform validations
            for(Apttus_Config2__LineItem__c lineItem : lineItems)
            {    //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here
                 if(lineItem.APTS_Proposal_Business_Unit__c == 'SCS' || lineItem.APTS_Proposal_Business_Unit__c == 'Canada'){ 
                    if(lineItem.APTS_Bundle__c != null && lineItem.APTS_Bundle__c.contains('Bundle') && lineItem.Apttus_Config2__ProductId__r.ProductCode != null && !System.Label.APTS_Proflex_Materials.contains(lineItem.Apttus_Config2__ProductId__r.ProductCode) && (lineItem.APTS_Yr_2_Amount__c != null || lineItem.APTS_Yr_3_Amount__c != null || lineItem.APTS_Yr_4_Amount__c != null || lineItem.APTS_Yr_5_Amount__c != null)){
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Yr 2/3/4/5 Amount fields should not be entered for the components on the bundle. If modifying a bundle, YOY % and Yr  2/3/4/5 Amount fields should not be entered for any line items.'));
                        result.isSuccess = false;
                        return result;
                    }else if(lineItem.APTS_Bundle__c != null && lineItem.APTS_Bundle__c.contains('Bundle') && (lineItem.APTS_Yr_2_Amount__c != null || lineItem.APTS_Yr_3_Amount__c != null || lineItem.APTS_Yr_4_Amount__c != null || lineItem.APTS_Yr_5_Amount__c != null) && lineItem.APTS_Contract_Term__c == 'Existing'){
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Yr 2/3/4/5 Amount fields should not be entered for the components on the bundle. If modifying a bundle, YOY % and Yr  2/3/4/5 Amount fields should not be entered for any line items.'));
                        result.isSuccess = false;
                        return result;
                    }
                }
                //DOC-6397 Zakeer
                if(slTopspot == True && lineItem.Apttus_Config2__ProductId__r.ProductCode == '42686641' && (lineItem.Apttus_Config2__LineStatus__c == 'New' || lineItem.Apttus_Config2__LineStatus__c == 'Renewed' || lineItem.Apttus_Config2__LineStatus__c == 'Upgraded' || lineItem.Apttus_Config2__LineStatus__c == 'Downgrade')){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Super Lawyer TopSpots and Super Lawyer Rotating TopSpots materials cannot be sold together'));
                    result.isSuccess = false;                  
                    return result; 
                } 
                String mhlMll = lineItem.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c + lineItem.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c;          
                //11/01/2017 - CPRO Validation
                if((lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c == CORP_SELECT_PRIMARY_ESSENTIALS
                    || lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c == CORP_SELECT_PRIMARY)
                   && productRuleMap.containsKey(lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c))  {
                       if(lineItem.Apttus_Config2__AttributeValueId__r.APTS_Total_Number_of_Points__c > productRuleMap.get(lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c).APTS_Max_no_of_Points__c) {
                           result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, productRuleMap.get(lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c).APTS_Error_message_for_no_of_points__c));
                           result.isSuccess = false;
                           return result;
                       }
                       else if(lineItem.Apttus_Config2__Quantity__c > productRuleMap.get(lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c).APTS_Max_no_of_Users__c) {
                           result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, productRuleMap.get(lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c).APTS_Error_message_for_no_of_users__c));
                           result.isSuccess = false;
                           return result;
                       } 
                   }          
                
                //SOC-3825: Added by Chirag 04/17/2017
                if(isHighQLine == 0 && lineItem.Apttus_Config2__LineType__c != NULL && lineItem.APTS_Proposal_Business_Unit__c != 'Tax Professional' && (lineItem.APTS_New_Bridge_Discount__c != null && lineItem.APTS_New_Bridge_Discount__c > 0 ) && 
                   ((!String.isBlank(lineItem.Apttus_Config2__ProductId__r.APTS_Cat_L2__c) &&  (lineItem.Apttus_Config2__ProductId__r.APTS_Cat_L2__c.equalsIgnoreCase(Label.APTS_Print_Product_Family)
                    || ( !String.isBlank(lineItem.Apttus_Config2__ProductId__r.APTS_Cat_L2__c) && lineItem.Apttus_Config2__ProductId__r.APTS_Cat_L2__c.equalsIgnoreCase(Label.APTS_Proview_Product_Family)) ||
                     lineItem.APTS_Keep_Terms__c || lineItem.Apttus_Config2__LineStatus__c == 'Renewed' || 
                     lineItem.Apttus_Config2__LineStatus__c == 'Cancelled' || lineItem.Apttus_Config2__PriceType__c == 'One Time' || lineItem.APTS_Media_Lower_Level_Code__c == 'SS')) ||
                    //(lineItem.APTS_Media_High_Level_Code__c == '06' && lineItem.APTS_Media_Lower_Level_Code__c == 'AR'))){    //SOC-4358 Commented by Chirag 7/6/2017
                    //((lineItem.APTS_Media_High_Level_Code__c == '06' && lineItem.APTS_Media_Lower_Level_Code__c == 'AR') || (lineItem.APTS_Media_High_Level_Code__c == '06' && lineItem.APTS_Media_Lower_Level_Code__c == '51')))){ //SOC-4358 Added by Chirag 7/6/2017
                    ((lineItem.APTS_Media_High_Level_Code__c == '06' && lineItem.APTS_Media_Lower_Level_Code__c == 'AR') || (lineItem.APTS_Media_High_Level_Code__c == '06' && lineItem.APTS_Media_Lower_Level_Code__c == '51') || (lineItem.APTS_Media_High_Level_Code__c == '13' && lineItem.APTS_Media_Lower_Level_Code__c == 'SS') || (lineItem.APTS_Media_High_Level_Code__c == '13' && lineItem.APTS_Media_Lower_Level_Code__c == NULL) || (lineItem.APTS_Media_High_Level_Code__c == '26' && lineItem.APTS_Media_Lower_Level_Code__c == NULL) || (lineItem.APTS_Media_High_Level_Code__c == '13' && lineItem.APTS_Media_Lower_Level_Code__c == 'PS')))){     // SOC-5499_MAY_Release_Kiran SOC-3858 Added by Chirag 7/24/2017 //Test
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Bridge Discount Cannot be applied'));
                        result.isSuccess = false;
                        return result;
                    }     
                system.debug('##### materialToProductRuleMap'+materialToProductRuleMap);
                system.debug('##### mhlMll'+mhlMll);
                system.debug('##### lineItem'+lineItem);
                Boolean flag =  ((proIdToAssetLineMap.containsKey(lineItem.Apttus_Config2__ProductId__c) && ! proWithStatusCancelledIDSet.contains(lineItem.Apttus_Config2__ProductId__c))); 
                if(lineItem.Apttus_Config2__LineStatus__c == 'New'
                   && lineItem.Apttus_Config2__LineType__c == 'Product/Service'
                   && lineItem.Apttus_Config2__IsPrimaryLine__c == TRUE
                   && materialToProductRuleMap.containsKey(mhlMll)
                   && ((proIdToAssetLineMap.containsKey(lineItem.Apttus_Config2__ProductId__c)
                        && ! proWithStatusCancelledIDSet.contains(lineItem.Apttus_Config2__ProductId__c))
                       || purchasedProIDSet.contains(lineItem.Apttus_Config2__ProductId__c)))  {
                           result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Only one Product \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' subscription can exist on this account.'));
                           result.isSuccess = false;
                           return result;
                       }
                //Bijeta SOC-3874 
                if(isEligibeTerminate == false && lineItem.Apttus_Config2__LineStatus__c == 'Cancelled') {
                    if(proIdToAssetLineMap1.containsKey(lineItem.Apttus_Config2__ProductId__c)){
                        result.isSuccess = false;
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Product  '+ assetNames +' cannot be lapsed until 12 months past Contract Start Date.'));
                    }
                }
                //Bijeta  SOC-5803
                if(present==false && lineItem.Apttus_Config2__LineStatus__c == 'Cancelled') { 
                    //Added APTS_SAP_MLA_Agreement_Number__c by CG SOC-8532
                    String idplusMLA = lineItem.Apttus_Config2__ProductId__c + lineItem.Apttus_Config2__AssetLineItemId__r.APTS_SAP_MLA_Agreement_Number__c;
                    if(proIdToAssetLineMap2.containsKey(idplusMLA)){
                        result.isSuccess = false;
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ensure all special offer materials are lapsed before finalizing.'));
                    }
                }
                //SOC-5987
                system.debug('isGrpProflex...'+isGrpProflex);
                system.debug('lineItem.APTS_Is_Special_Offer_Lapsed__c...'+lineItem.APTS_Is_Special_Offer_Lapsed__c);
                if(lineItem.APTS_Is_Special_Offer_Lapsed__c ==True && isGrpProflex==False){
                    result.isSuccess = false;                 
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Conversions from Special Offers to PROs must utilize a Proflex Managed Dynamic Bundle.'));                    
                } 
                //Bijeta  SOC-5374
                if((dealadded ==true || Test.isRunningTest()) && (lineItem.Apttus_Config2__LineStatus__c == 'Cancelled' || lineItem.Apttus_Config2__LineStatus__c == 'Amended')){
                    if(proIdToAssetLineMap3.containsKey(lineItem.Apttus_Config2__ProductId__c)){
                        result.isSuccess = false;
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select all materials belonging to a deal before proceeding.'));
                    }
                }     
                //Added by Bijeta May Release SOC-3675
                if((isPROFLEXBUNDLE==true) && lineItem.APTS_Group_Primary_Material_Name__c==null 
                   && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__LineType__c!='Option' && lineItem.APTS_Product_Family__c!=null){
                       if((((lineItem.APTS_Media_High_Level_Code__c == '13' && 
                        !(lineItem.APTS_Media_Lower_Level_Code__c == NULL || lineItem.APTS_Media_Lower_Level_Code__c == 'SS')) 
                          || lineItem.APTS_Media_High_Level_Code__c == '05' || lineItem.APTS_Media_High_Level_Code__c == '06'
                         || lineItem.APTS_Media_High_Level_Code__c == '26')
                          && !(lineItem.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Caseline_Product_Family) || lineItem.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Pondera_Product_Family))) 
                          || ((lineItem.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Caseline_Product_Family) || lineItem.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Pondera_Product_Family))
                          && lineItem.APTS_Media_High_Level_Code__c == '13' && lineItem.APTS_Media_Lower_Level_Code__c == 'PQ')) { //DOC-14691
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot have a ProFlex bundle and standalone Online/Software products in the same cart.'));
                        result.isSuccess = false;
                        return result;
                    }
                }
                
                // added by Chintan - to throws this for HighQ Products
                if(isPROFLEXBUNDLE && lineItem.Apttus_Config2__LineStatus__c == 'New' 
                   && lineItem.Apttus_Config2__LineType__c!='Option' && isHighQLine > 0 && lineItem.APTS_Media_High_Level_Code__c == '13' && 
                        lineItem.APTS_Media_Lower_Level_Code__c == NULL){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot have a ProFlex bundle and standalone Online/Software products in the same cart.'));
                    result.isSuccess = false;
                    return result;
                }
                
                if (lineItem.Apttus_Config2__LineStatus__c != 'Cancelled'){
                purchasedProIDSet.add(lineItem.Apttus_Config2__ProductId__c);}
            }
            //Akshay changes end
            
            //DOC-10390 - Added by Chintan - Put validation message for HighQ Products
            if(isHighQLine > 0 && (isHighQLine+proflexProduct) != lineItems.size()){
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'HighQ Products cannot be sold with other Thomson Reuters items'));
                result.isSuccess = false;
                return result;
            }
            
            APTS_ConfigBundlePageSettings__c bundlePageSettings;
            if(!configBundlePageList.isEmpty()
               && configBundlePageList.containsKey('Bundle Page Properties')) {
                   bundlePageSettings = configBundlePageList.get('Bundle Page Properties');
               }
            else{
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Custom Settings are missing'));
                result.isSuccess = false;
                return result;
            }
            
            Set<String> bandedProductsMLL = new Set<String>(bundlePageSettings.Banded_Products_MLL__c.split(','));
            Map<Id, Apttus_Config2__LineItem__c> lineItemsF = new Map<Id, Apttus_Config2__LineItem__c>();    
            Map<String, Decimal> productsQuantity = new Map<String, Decimal>();
            Boolean allCancelled = true;
            Set<String> bandedQty = new Set<String>();
            String billingfrequency='';
            String prodFamily='';
            Boolean checkCaselineFamilyFlag=False;//DOC-15429
            for(Apttus_Config2__LineItem__c lineItem : lineItems){
                lineItemsF.put(lineItem.Id, lineItem);                
            }   
            
            // added for GLP-14, GLP-594, GLP-820
            Map<String, Boolean> glpCancelFlagMap = new Map<String, Boolean>{'scsExistPrintCancel'=> FALSE,
                                                                             'scsNewPrintAdd'=> FALSE,
                                                                             'carsExistPrintCancel'=> FALSE,
                                                                             'carsNewPrintAdd'=> FALSE}; 
            
            for(Apttus_config2.LineItem li2 : cart.getLineItems()){               
                Apttus_Config2__LineItem__c li = li2.getLineItemSO();
                Apttus_Config2__LineItem__c liF = lineItemsF.get(li.Id);

                //DOC-15429
                if (liF.APTS_Product_Family__c!=null && (liF.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Caseline_Product_Family))) {
                    checkCaselineFamilyFlag = true;
                }
                 //DOC:142
                if(liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c =='Banded' 
                   && liF.APTS_Proposal_Business_Unit__c =='Canada' && (liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c)!=null
                   && liF.Apttus_Config2__LineStatus__c != 'Cancelled' && liF.Apttus_Config2__LineStatus__c != 'Renewed') {
                    if(bandedQty.isEmpty())
                    {
                        bandedQty.add('BandedCanada'+liF.Apttus_Config2__Quantity__c);
                    } 
                    else if(!bandedQty.contains('BandedCanada'+liF.Apttus_Config2__Quantity__c))
                    {
                            result.isSuccess = false;
                            result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'All banded products must have the same quantity.'));
                            return result;
                    }
                }
                //DOC:142 ends
                
                //GLP-58: Jinal Bhatt Quantity should be same for all PVIP productd
                if (liF.Apttus_Config2__ProductId__r != null
                   && liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c != null 
                   && liF.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c != null 
                   && liF.APTS_Media_High_Level_Code__c == '21' 
                   && liF.APTS_Media_Lower_Level_Code__c == 'CQ' 
                   && liF.APTS_Proposal_Business_Unit__c == 'SCS') {
                       if (glpQuantity.isEmpty()) {
                           glpQuantity.add(String.valueOf(liF.Apttus_Config2__Quantity__c));
                       } else if (liF.Apttus_Config2__AssetLineItemId__c != null && 
                           (!glpQuantity.contains(String.valueOf(liF.Apttus_Config2__Quantity__c)) 
                           || !glpQuantity.contains(String.valueOf(liF.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__Quantity__c)))) {
                            result.isSuccess = false;
                            result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quantity should match for all the Proview IP line items.'));
                            return result;
                       } else if (liF.Apttus_Config2__AssetLineItemId__c == null && !glpQuantity.contains(String.valueOf(liF.Apttus_Config2__Quantity__c))) {
                            result.isSuccess = false;
                            result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quantity should match for all the Proview IP line items.'));
                            return result;
                       }
                 }
                 //End GLP-58

                 processPrintProviewCancel(liF, glpCancelFlagMap);//Added for GLP-14, GLP-594, GLP-820
                 validateBillingFrequencyProflex(result, liF); //DOC-15043
                 validateCLBridgeTermType(result, liF); //DOC-15634
                
                    //DOC 3725
                 //DOC-11190 - Added HighQ condition - Chintan
                 if(liF.Apttus_Config2__LineStatus__c != 'Cancelled' && (( !String.isBlank(liF.Apttus_Config2__ProductId__r.APTS_Cat_L2__c) && (liF.Apttus_Config2__ProductId__r.APTS_Cat_L2__c.equalsIgnoreCase(Label.APTS_HighQ_Product_Family)
                    && liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c != null))
                   || ((liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c=='Banded'
                    ||liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c=='BENEFITGRP'
                    ||liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c=='Per Seat'
                    || checkCaselineFamilyFlag) //DOC-15429
                    && liF.APTS_Proposal_Business_Unit__c ==System.Label.SALESORGCAN))){ 
                    if(String.isBlank(billingfrequency) && liF.Apttus_Config2__BillingFrequency__c!=null)
                    {
                        billingfrequency=liF.Apttus_Config2__BillingFrequency__c;
                    }                
                    else if(liF.Apttus_Config2__BillingFrequency__c !=null 
                           && (!(billingfrequency.equals(liF.Apttus_Config2__BillingFrequency__c ))) 
                            )
                    {
                        result.isSuccess = false;
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ErrorOnline));
                        return result;
                    }
                }
                //DOC:3725 ends
                
                //DOC:1057 starts
                if (liF.Apttus_Config2__LineStatus__c != 'Cancelled' && liF.Apttus_Config2__LineStatus__c != 'Renewed' && liF.APTS_Proposal_Business_Unit__c ==Label.SALESORGCAN )
                {
                    if(String.isBlank(prodFamily) && (liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c=='Banded' 
                        || liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c=='BENEFITGRP' ) )
                        {
                        prodFamily=liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c;
                        }
                    else if(liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c!=null 
                        && !(prodFamily.equals(liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c))
                        && (liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c=='Banded' 
                        || liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c=='BENEFITGRP' ) ) 
                        {
                          result.isSuccess = false;
                          result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Banded and benefitting group products cannot be added simultaneously.'));
                          return result;
                        }
                }//DOC:1057 ends            
                if(li.Apttus_Config2__LineStatus__c != 'Cancelled'){
                    allCancelled = false;
                }                
                //SOC-8438
                if(li.Apttus_Config2__LineStatus__c != 'Cancelled' && li.Apttus_Config2__LineStatus__c != 'Renewed'){
                    if(li.Apttus_Config2__LineType__c == 'Option' && liF.Apttus_Config2__OptionId__r != null
                       && liF.Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c != null && bandedProductsMLL.contains(liF.Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c)){
                           if(!productsQuantity.containsKey(liF.Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c)){
                               productsQuantity.put(liF.Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c, li.Apttus_Config2__Quantity__c);
                           } else if(productsQuantity.get(liF.Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c) != li.Apttus_Config2__Quantity__c){
                               result.isSuccess = false;
                               result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'All banded products must have the same quantity.'));
                           }
                       } else if(liF.Apttus_Config2__ProductId__r != null
                                 && liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c != null && bandedProductsMLL.contains(liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c) && liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c !='BENEFITGRP'){
                                     if(!productsQuantity.containsKey(liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c)){
                                         productsQuantity.put(liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, li.Apttus_Config2__Quantity__c);
                                     } else if(productsQuantity.get(liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c) != li.Apttus_Config2__Quantity__c){
                                         result.isSuccess = false;
                                         result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'All banded products must have the same quantity.'));
                                     }
                                 }
                            else if(liF.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c =='BENEFITGRP' && liF.Apttus_Config2__ProductId__r != null && liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c != null 
                                    ){
                               if(!productsQuantity.containsKey(liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c)){
                                    productsQuantity.put(liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c);
                               }
                               else if(productsQuantity.get(liF.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c) != li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c){
                                    result.isSuccess = false;
                                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'All benefiting group products must have the same number of attorneys . '));
                               }        
                } 
                
                }
                //Added by Bijeta Mar 2020 Release DOC-7532
                if(liF.Apttus_Config2__LineStatus__c != 'Cancelled'){
                if(liF.Apttus_Config2__ProductId__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage) && liF.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '06')
                                    {
                                     if((smallFIRMCOUNT >1 && (smallFIRMPACMETA.size()>0 && smallFIRMPACMETA.contains(liF.Apttus_Config2__ProductId__r.productcode))) || (liF.Apttus_Config2__LineStatus__c == 'New' && smallFIRMCOUNT==1 && installedSFP.contains(liF.Apttus_Config2__ProductId__r.productcode))) {
                                    result.isSuccess = false;
                                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Only one new online Small Firm Package can be included in the cart. '));
                               
                               } 
                               if(liF.Apttus_Config2__LineStatus__c != 'Renewed'){
                               if(!productsQuantity.containsKey(liF.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c) ){
                                    productsQuantity.put(liF.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c , li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c);
                               }
                               else if(productsQuantity.get(liF.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c ) != li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c){
                                    result.isSuccess = false;
                                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'All benefiting group products must have the same number of attorneys . '));
                               } 
                                     
                            }
                         }      
                    }
            }
            
            if(allCancelled && cart.getLineItems().size() > 0){
                result.isSuccess = false;
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot finalize cart with only lapsed line items.'));
            } 

            validatePrintProviewCancel(result, glpCancelFlagMap); //Added for GLP-14, GLP-594, GLP-820   
            
        }
        if(result1 <> null && !result1.IsSuccess && result.IsSuccess){result = result1; }       
        return result;
      }
      return null;  
    }
    
    global Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2.LineItem> rampLineItems) {
       //Skip the following code execute for TRStore 
      if(!UserInfo.getUserType().equalsIgnoreCase(Static_Values__c.getAll().get('skiptoNullifyCreditCardDetails').Value__c)){   
       
        Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true);
        return result;
      }
      return null;  
    }
    global Apttus_Config2.CustomClass.ValidationResult validateAssetItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2__TempRenew__c> assetItems) {
        
        //Skip the following code execute for TRStore 
      if(!UserInfo.getUserType().equalsIgnoreCase(Static_Values__c.getAll().get('skiptoNullifyCreditCardDetails').Value__c)){   
        Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true);
        return result;
      }
      return null;  
    }
    
    //Start: GLP-14, GLP-594, GLP-820
    @testVisible
    private void processPrintProviewCancel(Apttus_Config2__LineItem__c liF, Map<String, Boolean> glpCancelFlagMap){
        if(liF.APTS_Proposal_Business_Unit__c == 'SCS'){
            processSCSPrintProviewCancel(liF, glpCancelFlagMap);
        }else if(liF.APTS_Proposal_Business_Unit__c == 'Canada'){
            processCanadaPrintProviewCancel(liF, glpCancelFlagMap);
        }
    } 
    
    @testVisible
    private void processSCSPrintProviewCancel(Apttus_Config2__LineItem__c liF, Map<String, Boolean> glpCancelFlagMap){
        if(liF.Apttus_Config2__LineStatus__c == 'Cancelled' 
                && checkSCSPrintProviewOldBundle(liF)){
            glpCancelFlagMap.put('scsExistPrintCancel', TRUE);
        }else if((liF.Apttus_Config2__LineStatus__c == 'New' || liF.Apttus_Config2__LineStatus__c == 'Renewed')
                && checkSCSPrintProviewNewBundle(liF)){
            glpCancelFlagMap.put('scsNewPrintAdd',TRUE);
        }
        system.debug('##### glpCancelFlagMap'+glpCancelFlagMap);
    } 
    
    @testVisible
    private void processCanadaPrintProviewCancel(Apttus_Config2__LineItem__c liF, Map<String, Boolean> glpCancelFlagMap){
        if(liF.Apttus_Config2__LineStatus__c == 'Cancelled'
                && checkCanadaPrintProviewOldBundle(liF)){
            glpCancelFlagMap.put('carsExistPrintCancel', TRUE);
        }else if((liF.Apttus_Config2__LineStatus__c == 'New' || liF.Apttus_Config2__LineStatus__c == 'Renewed')
                && (checkCanadaPrintProviewNewBundleZVSU(liF)
                || checkCanadaPrintProviewNewBundleEC(liF))){
            glpCancelFlagMap.put('carsNewPrintAdd',TRUE);
        }
        system.debug('##### glpCancelFlagMap'+glpCancelFlagMap);
    } 
    
    @testVisible
    private Boolean checkSCSPrintProviewOldBundle(Apttus_Config2__LineItem__c liF){
        Boolean flag = FALSE;
        system.debug('######### in');
        if(liF.APTS_Cat_L2__c!=null 
            && (liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) || liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)) 
            && checkSCSPrintProviewNewBundle(liF) && liF.Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c != 'WCMP'){
            flag = TRUE;
        } else if (liF.APTS_Cat_L2__c!=null 
            && (liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) || liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)) 
            && liF.Apttus_Config2__ChargeType__c == 'Subscription Fee'
            && !checkSCSPrintProviewNewBundle(liF) && liF.Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c != 'WCMP') {
            flag = TRUE;
        }
        system.debug('##### flag '+flag );
        return flag;
    }
    
    @testVisible
    private Boolean checkSCSPrintProviewNewBundle(Apttus_Config2__LineItem__c liF){
        Boolean flag = FALSE;
        if(liF.APTS_Cat_L2__c!=null 
            && (liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) || liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)) 
            && liF.APTS_Media_High_Level_Code__c == '21' 
            && liF.APTS_Media_Lower_Level_Code__c == 'F4' 
            && liF.APTS_Item_Category_Group__c == 'ZPR2') {
            flag = TRUE;
        }  
        return flag;
    }
    
    @testVisible
    private Boolean checkCanadaPrintProviewOldBundle(Apttus_Config2__LineItem__c liF){
        Boolean flag = FALSE;
        
        if(liF.APTS_Cat_L2__c!=null 
            && (liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) || liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)) 
            && checkCanadaPrintProviewNewBundleZVSU(liF)) {
            flag = TRUE;
        } else if (liF.APTS_Cat_L2__c!=null 
            && (liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) || liF.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)) 
            && liF.Apttus_Config2__ChargeType__c == 'Subscription Fee'
            && !checkCanadaPrintProviewNewBundleZVSU(liF)){
            flag = TRUE;
        } 
        system.debug('#### flag'+flag);
        return flag;
    }
    
    @testVisible
    private Boolean checkCanadaPrintProviewNewBundleZVSU(Apttus_Config2__LineItem__c liF){
        Boolean flag = FALSE;
        if(liF.APTS_Media_High_Level_Code__c == '21' 
            && liF.APTS_Media_Lower_Level_Code__c == 'F4' 
            && liF.APTS_Item_Category_Group__c == 'ZVSU'){
            flag = TRUE;
        } 
        return flag;
    } 
    
    @testVisible
    private Boolean checkCanadaPrintProviewNewBundleEC(Apttus_Config2__LineItem__c liF){
        Boolean flag = FALSE;
        if(liF.APTS_Media_High_Level_Code__c == '21' && liF.APTS_Media_Lower_Level_Code__c == 'EC'){
            flag = TRUE;
        } 
        return flag;
    } 
    
    @testVisible
    private void validatePrintProviewCancel(Apttus_Config2.CustomClass.ValidationResult result, Map<String, Boolean> glpCancelFlagMap){
        System.debug(logginglevel.DEBUG,'glpCancelFlagMap : '+glpCancelFlagMap);
        if((glpCancelFlagMap.get('scsExistPrintCancel')==TRUE && glpCancelFlagMap.get('scsNewPrintAdd')==FALSE) 
                || (glpCancelFlagMap.get('carsExistPrintCancel')==TRUE && glpCancelFlagMap.get('carsNewPrintAdd')==FALSE)){
            result.isSuccess = false;
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Termination/Lapse of Print/Proview materials requires new Print/Proview bundle product in the cart.'));
        }
    }
    //END: GLP-14, GLP-594, GLP-820
    
    //DOC-15043 - Caseline    
    @testVisible
    private void validateBillingFrequencyProflex(Apttus_Config2.CustomClass.ValidationResult result, Apttus_Config2__LineItem__c LI) {
        List<APTS_Integration_Variables__mdt> caselineProflex;
        if(Schema.sObjectType.APTS_Integration_Variables__mdt.isAccessible() && Schema.sObjectType.APTS_Integration_Variables__mdt.isQueryable()){
            caselineProflex=[Select MasterLabel,Value__c from APTS_Integration_Variables__mdt];
        }
        String strProflex = '';
        for(APTS_Integration_Variables__mdt var : caselineProflex){
            if(var.masterlabel=='Caseline Proflex Validation') {
                strProflex =var.Value__c;
            }
        }
        if (LI.Apttus_Config2__ProductId__r.Productcode != null && !string.isBlank(strProflex) && strProflex.contains(LI.Apttus_Config2__ProductId__r.Productcode) && (String.isBlank(LI.Apttus_Config2__BillingFrequency__c) || LI.Apttus_Config2__BillingFrequency__c == 'Yearly')) {
            result.isSuccess = false;
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'None or Yearly billing frequency is not a valid option for Proflex, please choose Monthly billing frequency.'));
        }
    }
    
    //DOC-15634 - Caseline
    @testVisible
    private void validateCLBridgeTermType(Apttus_Config2.CustomClass.ValidationResult result, Apttus_Config2__LineItem__c LI) {
        If ((LI.APTS_Proposal_Business_Unit__c == 'SCS' || LI.APTS_Proposal_Business_Unit__c == 'Canada')
             && LI.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'PQ' && LI.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13'
             && LI.APTS_Product_Family__c != null && LI.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Caseline_Product_Family)
             && LI.APTS_Term_Type__c == 'Future Start Date' && LI.APTS_Bridge__c != null) {
                 result.isSuccess = false;
                 result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Both Future Start Date and Bridge can not be selected at same time in the cart.'));
        }
    }
}