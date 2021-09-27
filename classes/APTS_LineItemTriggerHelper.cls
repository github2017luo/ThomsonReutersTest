/*
*Change Items:
1. Neeharika Upadrasta, 23rd Aug 2017

Added lineItem.APTS_Minimum_YoY_Increase = true for Line Items where the Approval is triggered on Minimum YOY violation. 
This will be used in Approval Rule (Entries) to update the Condition when Minimum YOY violation is true.

2. Neeharika Upadrasta, 6th Oct 2017
To fix SOQL 101 issue in LRP1QA1(E-commerce CXD team) env,removed the Segment Threshold SOQL from 'ProdConfigApproval' method and added it as a Static List to the class(segmentThresholdList).
3. Punitha - SOC-8090 - Fixing SOQL : Making AssetLineItems List Static from the Method CalculateIncrementalrevenuegrowth
*/

public with sharing class APTS_LineItemTriggerHelper { 
    //Added by Chirag to optimize
    //static Profile UserProfile = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
    //Static String userdetail = [Select Sub_Bu__c From User Where Id = :UserInfo.getUserId()][0].Sub_Bu__c;
    //Added following SOQL as Change 2
    //SOC-5933 Added by CG 12/19/17 Added new fields in the SOQL
    static List<APTS_Segment_Threshold__c> segmentThresholdList = new List<APTS_Segment_Threshold__c>([Select APTS_Approval_Required__c,APTS_Customer_Category__c,APTS_Minimum_Incremental_Growth__c,APTS_Minimum_OY_Increase__c,APTS_Product_Family__c,APTS_Segment__c,APTS_Term_in_years__c,APTS_Promo_Codes__c, APTS_Promo_Minimum_OY_Increase__c, APTS_Renewal_Window__c from APTS_Segment_Threshold__c]);    //DOC-14800
    //SOC-8090
    Static List<Apttus_Config2__AssetLineItem__c> assetLineItems = new List<Apttus_Config2__AssetLineItem__c>();
    Static Boolean isNewSSD = FALSE;
    //SOC-7601
    
    // Static  List<Apttus_Config2__AdjustmentLineItem__c> promoApp = new List<Apttus_Config2__AdjustmentLineItem__c> ();
    Static boolean isShortTermTrial = False;
    Static boolean isBridgePromo = False;
    Static boolean isMinYoyPromo = False; 
       
    // This method calculates incremental growth.
    //public static void calculateIncrementGrowth(List<Apttus_Config2__LineItem__c> lineItems)
    public static void calculateIncrementGrowth(Id configId)
    {   //Added  by Poonam Garg to avoid Too Many SOQL error
        //if(checkRecursive.runLineItemCalIncrementalMethflagOnce()){
        Id cartId;
        decimal totalNewItems=0.0;
        decimal taxTotalNewItems=0.0;
        decimal totalRenewedItems=0.0;
        decimal totalRenewedItemsRPA=0.0;    //DOC-16112
        decimal totalLapsedItems=0.0;
        decimal taxTotalLapsedItems=0.0;
        decimal totalCurrentItems=0.0;
        decimal taxTotalCurrentItems=0.0;
        decimal incrementalGrowth=0.0;
        string mediaHighLevel;
        //Added as part of DOC-14800 
        decimal totalAmendedItemsALI=0.0;
        decimal totalAmendedItemsNP=0.0;
        decimal totalCurrentItemsDG=0.0;
        decimal totalRenewedItemsDG=0.0; 
        integer renewalWindow;
        List<integer> renewalwindowtmp = new List<Integer>();
        //DOC-13386
        Integer amendProflexLICount = 0;
        decimal totalAmendedItems=0.0;
        //Start:GLP-14, 747, 594
        decimal incrementalGrowtthGLP;
        Boolean dealTypeNonAPP = false;
        Decimal totalCancelledItemsGLP = 0.0;
        Decimal totalNewItemsGLP = 0.0;
        Decimal totalCancelledItemsGLPAPP = 0.0;
        Decimal totalNewItemsGLPAPP = 0.0;
        Integer quantity = 0;
        Integer newLICount = 0;
        //End GLP-14, 747, 594
        //Added by Priyanka for DOC-1600
        String proposalBU ;
        Boolean rutterApproval1=false;
        Boolean rutterApproval2=false;
        Boolean rutterApproval3=true; 
        //SOC-4838 Added by Chirag 8/7/17
        Boolean tempWLECApproval1 = FALSE;
        Boolean tempWLECApproval2 = FALSE;
        Boolean tempWLECApproval3 = FALSE;
        Boolean wlecApproval = TRUE; 
        string family;
        string prodFamily=''; // Added By Poonam Garg DOC  11744
        Set<String> supportedBusinessUnits=new Set<String>{'FindLaw','SCS',label.SALESORGCAN,'Corp OneOTC US','Corp OneOTC UK','Tax Professional','Argentina-LLEY','Brazil-TSL','Hong Kong-SMHK','India-INWL','Australia-PNG-LRA','NZ-Fiji-BKRS','FACT-TRFR','Russia-1S','SouthKorea-DUZON','SMGE','Dofiscal'};
            //Profile UserProfile; moved the declaration to main class       
            
            //Added by Chirag 2828
        Decimal totalLapsedItems180 = 0.0;
        Boolean within180Days = FALSE;
        Decimal numberOfAttorneys;
        Boolean isRenewedOnly = FALSE;
        Boolean tempIsNotRenewed = FALSE;
        Boolean tempIsRenewed = FALSE;
        
        //SOC-5804 Added by Chirag
        Boolean specialOfferLapsed = FALSE;
        
        //SOC-2971 Added by Chirag 1/5/18
        Boolean appapproval = FALSE;  
        String CustCategory='';//DOC-14800
        String condition = '';
        
        Map<String, Boolean> printProviewFlagMap = new Map<String, Boolean>{'printAPPCancel'=>FALSE, 'printBundleAdd'=>FALSE};//GLP-820 
                        
        //Commented by Chirag to add APTS_Deal_Type__c field in the query SOC-4938 8/30/2017
        //List<Apttus_Config2__LineItem__c> lineItems = [SELECT APTS_media_high_level__c, APTS_Product_Family__c,APTS_Media_High_Level_Code__c, APTS_Media_Lower_Level_Code__c,Apttus_Config2__NetPrice__c, apttus_config2__linestatus__c, APTS_Yr_1_Renewal_Adjustment__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c=:configId];
        
        //Added by Chirag to add APTS_Deal_Type__c field in the query SOC-4938 8/30/2017
        //Field APTS_Proposal_Business_Unit__c added in the query by Sakshi SOC-6727 on 3/23/2017 // Apttus_Config2__ProductId__r.Family for SOC-9627
        List<Apttus_Config2__LineItem__c> lineItems;
        //DOC-14800
        List<APTS_Segment_Threshold__c> segThrsList1=new List<APTS_Segment_Threshold__c>();
        Map<String,APTS_Segment_Threshold__c> SegThresholdComDownMap = new Map<String,APTS_Segment_Threshold__c>();     //DOC-13572
        if(segmentThresholdList!=null && segmentThresholdList.size()>0){
            segThrsList1.addall(segmentThresholdList); 
        }
        system.debug('segmentThresholdList--'+segmentThresholdList);
        for(APTS_Segment_Threshold__c seg1:segThrsList1){
            //DOC-13572
            if(seg1.APTS_Minimum_Incremental_Growth__c != null && seg1.APTS_Renewal_Window__c !=null && seg1.APTS_Segment__c !=null)
            {
                String keysetComDwnId = seg1.APTS_Segment__c+seg1.APTS_Term_in_years__c+seg1.APTS_Customer_Category__c;
                System.debug('RK --> SegKey'+keysetComDwnId);
                SegThresholdComDownMap.put(keysetComDwnId,seg1);
                System.debug('RK --> Seg Map'+SegThresholdComDownMap);
            }
            
        }

        if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        
        lineItems = [SELECT name,APTS_Proposal_Business_Unit__c,Apttus_Config2__AssetLineItemId__c,APTS_Info_PlanType__c,APTS_media_high_level__c, APTS_Product_Family__c,Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c,APTS_Media_High_Level_Code__c,
                                                       APTS_Media_Lower_Level_Code__c,Apttus_Config2__NetPrice__c, Apttus_Config2__NetUnitPrice__c, apttus_config2__linestatus__c, APTS_Years_2_Plus_Adjustment__c,
                                                       APTS_Yr_1_Renewal_Adjustment__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c,
                                                       APTS_Deal_Type__c, Apttus_Config2__PriceUom__c, Apttus_Config2__Quantity__c,     //SOC-2828 Added Apttus_Config2__PriceUom__c, Apttus_Config2__Quantity__c by Chirag 9/20/2017
                                                       Apttus_Config2__AssetLineItemId__r.APTS_Info_PlanType__c,    APTS_Item_Category_Group__c,                  //SOC-5804 Added Apttus_Config2__AssetLineItemId__r.APTS_Info_PlanType__c
                                                       APTS_Print_Purchase_Options__c , APTS_Contract_Term_Whole_Years__c, APTS_Purchase_Options__c,APTS_1_Year_APP_Approval_Required__c,                //SOC-2971 Added APTS_Print_Purchase_Options__c , APTS_Contract_Term_Number__c by Chirag 1/5/2018
                                                       LMS_Profile_Approval__c,  Purchase_Option_Bundle_Print__c ,    //SOC-7735
                                                       Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c,Apttus_Config2__ProductId__r.Family, APTS_Cat_L2__c, APTS_Cat_L3__c,
                                                       APTS_Product_Delivery__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__SellingTerm__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__BasePriceMethod__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__Quantity__c,Apttus_CQApprov__Approval_Status__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_LMS_Catalog__c,
                                                       APTS_Approval_Segment__c,Apttus_Config2__AssetLineItemId__r.APTS_Contract_End_Dates__c,Apts_Product_Code__c, //13387 Poonam Garg
                                                       Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c, Apttus_Config2__BasePrice__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__ListPrice__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__ChargeType__c, Apttus_Config2__ListPrice__c, //GPP-14,747, 594, 594, 594, 594

                                                       Apttus_Config2__AssetLineItemId__r.Apttus_Config2__PriceType__c, Apttus_Config2__ProductId__r.Productcode, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__PriceMethod__c, APTS_Program_ID__c, Apttus_Config2__LineType__c,
                                                       Apttus_Config2__ChargeType__c , Apttus_Config2__PriceType__c,APTS_Group__c,APTS_Customer_Category__c,APTS_Contract_Term__c   //GPP-14, 747
                                                       FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c=:configId];
        
        
        //SOC-3870 Added by Chirag 4/27
        //Added null check as part of class optimization by Tejaswi
        //SOC-5804 Added by CG 12/5/17
        //Removed multiple for loops on Lineitem object 
        
        //Start: GLP-14,747, 594
        Map<String, Decimal> mapProductToListPrice = new Map<String, Decimal>();


        if (lineItems != null && lineItems.size() > 0) {
            
            Set<String> setProuctCodeGPP = new Set<String>();
            Set<String> setProuctCodeNonGPP = new Set<String>();
            List<Apttus_Config2__PriceListItem__c> lstPLI = new List<Apttus_Config2__PriceListItem__c>();

            List<Apttus_Config2__PriceListItem__c> lstPLINoFP = new List<Apttus_Config2__PriceListItem__c>();
            List<Apttus_Config2__PriceListItem__c> lstPLIGPP = new List<Apttus_Config2__PriceListItem__c>();
            List<Apttus_Config2__PriceListItem__c> lstPLINonGPP = new List<Apttus_Config2__PriceListItem__c>();
            Map<String, String> mapFlatPrice = new Map<String, String>();
            Map<String, Decimal> mapFinalFlatPrice = new Map<String, Decimal>();
            for (Apttus_Config2__LineItem__c  objLI : lineItems) {
                 system.debug('Apttus_Config2__NetPrice__c++++++++'+objLI.Name +objLI.Apttus_Config2__NetPrice__c);   
           
                if (objLI.APTS_Cat_L2__c!=null && (objLI.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) 
                || objLI.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family))
                && (objLI.APTS_Proposal_Business_Unit__c == 'SCS' || objLI.APTS_Proposal_Business_Unit__c == 'Canada')
                && objLI.Apttus_Config2__LineStatus__c == 'Cancelled') {
                    system.debug('########### objLI.Apttus_Config2__ProductId__r.Productcode'+objLI.Apttus_Config2__ProductId__r.Productcode);
                    if (checkGPPProduct(objLI)) {
                        setProuctCodeGPP.add(objLI.Apttus_Config2__ProductId__r.Productcode);
                        mapFlatPrice.put(objLI.Apttus_Config2__ProductId__r.Productcode, objLI.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__PriceMethod__c);
                    } else if (!checkGPPProduct(objLI) && objLI.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__ChargeType__c == 'Subscription Fee') {
                        setProuctCodeNonGPP.add(objLI.Apttus_Config2__ProductId__r.Productcode);
                        mapFlatPrice.put(objLI.Apttus_Config2__ProductId__r.Productcode, objLI.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__PriceMethod__c);

                        system.debug('###### setProuctCodeNonGPP'+setProuctCodeNonGPP);
                    }
                }
            }


            lstPLINonGPP = retrieveNonGPPPLI(setProuctCodeNonGPP); //Prepare List For Non-GPP
            system.debug('#### lstPLINonGPP'+lstPLINonGPP);
            lstPLIGPP = retrieveGPPPLI(setProuctCodeGPP); //Prepare List For GPP
            system.debug('#### lstPLIGPP '+lstPLIGPP );
            lstPLI = preparePLI(lstPLINonGPP, lstPLIGPP); //Contains all PLIs
            system.debug('#### lstPLI '+lstPLI );
            mapFinalFlatPrice = retrieveLIFlatPrice(lstPLI, mapFlatPrice); //Filter Flat Price
            system.debug('#### mapFlatPrice '+mapFlatPrice );
            lstPLINoFP = prepareNonFPPLI(lstPLI, mapFlatPrice);// Filter Non Flat Price
            system.debug('#### lstPLINoFP '+lstPLINoFP );
            mapProductToListPrice = prepareMapFromList(lstPLINoFP, mapFinalFlatPrice); //Prepare Final Map
            system.debug('#### mapProductToListPrice '+mapProductToListPrice );
            

        }
        
        //End GLP-14, 747, 594
        
        System.Debug('Kh***GPN LI calcIncreGrowth called===>');
        String strTaxBundleProductDelAttributes ; //DOC-10825
        for(Apttus_Config2__LineItem__c lineItem : lineItems){
            mediaHighLevel = lineItem.APTS_media_high_level__c;
            family = lineItem.APTS_Product_Family__c;
            Boolean isProflexMaterial=false;
            if(lineItem.Apts_Product_Code__c != null
            && System.Label.APTS_Proflex_Materials.contains(lineItem.Apts_Product_Code__c)){
            isProflexMaterial=true;
            }
            //DOC-14800
            if(lineItem.APTS_Customer_Category__c!=null){
            CustCategory = lineItem.APTS_Customer_Category__c;
          } else {CustCategory = '0';}
            if(lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Contract_Term__c != null ){                    
                          System.debug('Sakshi 4>>>>Lineitem'+lineItem);
            condition=lineItem.APTS_Approval_Segment__c+lineItem.APTS_Contract_Term_Whole_Years__c+CustCategory;}
            system.debug('RK --> C1= '+condition);
            //DOC-14800
                          //SOC-5933/6873 Added by Chirag 3/2/2018
            //Added By Poonam Garg DOC 11744
            if(String.isEmpty(prodFamily) && lineItem .Apttus_CQApprov__Approval_Status__c=='Approval Required' && supportedBusinessUnits.contains(lineItem.APTS_Proposal_Business_Unit__c )){ 
                prodFamily=lineItem.APTS_Product_Family__c;
            }
            //Added by Priyanka for DOC-1600
            proposalBU = lineItem.APTS_Proposal_Business_Unit__c;
            cartId = configId;
            
            if(lineItem.Apttus_Config2__AssetLineItemId__r.APTS_Info_PlanType__c == 'S00' ){    //&& lineItem.Apttus_Config2__LineStatus__c == 'Cancelled' 
                specialOfferLapsed = TRUE;
            }
            //SOC-2971 Added by Chirag 1/5/18
            if((lineItem.APTS_Print_Purchase_Options__c == 'Ship & Enter Sub APP' || lineItem.APTS_Print_Purchase_Options__c == 'Sub only APP' || lineItem.APTS_Purchase_Options__c == 'APP') && lineItem.APTS_Contract_Term_Whole_Years__c == 1){
                appapproval = TRUE;                
            }
            //SOC-3869 Added by Prabhu 5/10
            //if(lineItem.APTS_Media_High_Level_Code__c=='08'){   Commented by Chirag 6/6/2017
            if(lineItem.APTS_Cat_L3__c!=null && lineItem.APTS_Cat_L3__c.equalsIgnoreCase(System.Label.APTS_Rutter_Product_Family)){
                rutterApproval1 = true;
            }
            else{
                rutterApproval2 = true;
            }            
            if((rutterApproval1 == false && rutterApproval2 == true) || (rutterApproval2 == true)){
                rutterApproval3 = False;
            }
            
            //SOC-4838 Added by Chirag 8/7/17
            if(lineItem.APTS_Media_High_Level_Code__c=='05' && lineItem.APTS_Media_Lower_Level_Code__c=='E2'){   
                tempWLECApproval1 = TRUE;
            }else if (lineItem.APTS_Cat_L2__c!=null && (lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) 
            || lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family))){
                tempWLECApproval2 = TRUE;
            }else{
                tempWLECApproval3 = TRUE;
            }
            
            if((tempWLECApproval1 == FALSE && tempWLECApproval2 == FALSE && tempWLECApproval3 == TRUE) || (tempWLECApproval3 == TRUE)){
                wlecApproval = FALSE;
            }
            
            //SOC-2828
            if(lineItem.Apttus_Config2__PriceUom__c != NULL && lineItem.Apttus_Config2__PriceUom__c == 'Attorneys' && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineitem.APTS_Approval_Segment__c != 'Small Law'){
                numberOfAttorneys = lineItem.Apttus_Config2__Quantity__c;
            }
            else if(lineItem.Apttus_Config2__PriceUom__c != NULL && lineItem.Apttus_Config2__PriceUom__c == 'Attorneys' && (lineItem.Apttus_Config2__LineStatus__c == 'New' || lineItem.Apttus_Config2__LineStatus__c == 'Amended' || lineItem.Apttus_Config2__LineStatus__c == 'Renewed')  && lineitem.APTS_Approval_Segment__c == 'Small Law'){
                numberOfAttorneys = lineItem.Apttus_Config2__Quantity__c;
            }
            
            
            //SOC-5720 Added Online Non-Westlaw media high level: Added by CG 11/20/17
            System.Debug('proposalBU===>'+proposalBU); 
            System.Debug('lineItem.APTS_Product_Delivery__c===>'+lineItem.APTS_Product_Delivery__c);
            System.Debug('lineItem.Apttus_Config2__NetPrice__c===>'+lineItem.Apttus_Config2__NetPrice__c);
            //DOC-10825
            if(proposalBU != null && proposalBU.equalsIgnoreCase('Tax Professional') && lineItem.APTS_Product_Delivery__c != null)
            {
                strTaxBundleProductDelAttributes = lineItem.APTS_Product_Delivery__c;
            }
            
            //GLP-14, 747, 594
            if (lineItem.APTS_Cat_L2__c!=null && (lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) 
            || lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family))
            && (lineItem.APTS_Proposal_Business_Unit__c == 'Canada' 
            || lineItem.APTS_Proposal_Business_Unit__c == 'SCS')) {
                totalNewItemsGLP = checkIncrementalGrowthGPPNew(lineItem, totalNewItemsGLP);
                totalCancelledItemsGLP = checkIncrementalGrowthGPPCancelled(lineItem, totalCancelledItemsGLP, mapProductToListPrice);
                newLICount = countNewLI(lineItem, newLICount);
            }
            //End
            
            checkPrintProviewAPPApproval(lineItem, printProviewFlagMap);//GLP-820
            
            if ((((((mediaHighLevel == 'Software') || (mediaHighLevel == 'Online')) && !(lineItem.APTS_Media_High_Level_Code__c=='13' && lineItem.APTS_Media_Lower_Level_Code__c == null)) || ((mediaHighLevel == 'Online Non-Westlaw') && !(lineItem.APTS_Media_High_Level_Code__c=='05' && lineItem.APTS_Media_Lower_Level_Code__c == null))) || 
                    (proposalBU =='Corp OneOTC UK' || proposalBU =='Corp OneOTC US' || (!(lineItem.APTS_Media_High_Level_Code__c=='13' && lineItem.APTS_Media_Lower_Level_Code__c == null) && !(lineItem.APTS_Media_High_Level_Code__c=='26' && lineItem.APTS_Media_Lower_Level_Code__c == null) && proposalBU != null && (proposalBU =='Canada' || System.Label.Risk_PBUs.contains(proposalBU)) ))) 
                && (lineItem.Apttus_Config2__NetPrice__c != null)
                ||(proposalBU != null && proposalBU.equalsIgnoreCase('Tax Professional') && lineItem.APTS_Product_Delivery__c != null  
                   && (lineItem.APTS_Product_Delivery__c.equalsIgnoreCase('Online/Internet') 
                       || lineItem.APTS_Product_Delivery__c.equalsIgnoreCase('Download') 
                       || (String.isNotBlank(strTaxBundleProductDelAttributes) && (strTaxBundleProductDelAttributes.contains('Bundle')
                                                                                   || strTaxBundleProductDelAttributes.contains('Pick')))) /*DOC-10825*/ 
                   && lineItem.Apttus_Config2__NetUnitPrice__c != null))
            {    
                //SOC-7735 Added by Chirag 7/5/18  Added lineItem.LMS_Profile_Approval__c != 'LMS'
                if ((proposalBU != null && System.Label.Risk_PBUs.contains(proposalBU)) || ((!String.isBLANK(lineItem.APTS_Cat_L3__c) && lineItem.APTS_Cat_L3__c != System.Label.APTS_Case_Logistix_Product_Family) 
                && (!String.isBLANK(lineItem.APTS_Cat_L2__c) && lineItem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family) 
                && (!String.isBLANK(lineItem.APTS_Cat_L2__c) && lineItem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family) && (family != 'FINDLAW') 
                && (!String.isBLANK(lineItem.APTS_Cat_L3__c) && lineItem.APTS_Cat_L3__c != System.Label.APTS_Ediscovery_Product_Family) && (lineItem.LMS_Profile_Approval__c != 'LMS'))) 
                {
                    if ((lineItem.APTS_Group__c== null || (lineItem.APTS_Group__c != null && isProflexMaterial)) && (lineItem.apttus_config2__linestatus__c == 'New' || lineItem.apttus_config2__linestatus__c == 'Amended'))
                    {   //DOC-13386
                        if((lineItem.APTS_Group__c != null && isProflexMaterial) && lineItem.apttus_config2__linestatus__c == 'Amended'){
                                totalAmendedItems += (lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c - lineItem.Apttus_Config2__NetPrice__c);
                                amendProflexLICount += 1;
                                totalAmendedItemsALI += lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
                                totalAmendedItemsNP += lineItem.Apttus_Config2__NetPrice__c;
                                system.debug('totalAmendedItems ='+totalAmendedItems+'amendProflexLICount ='+amendProflexLICount);
                        }
                        else{totalNewItems += lineItem.Apttus_Config2__NetPrice__c;}                    
            if(lineItem.APTS_Proposal_Business_Unit__c != null && lineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional' && lineItem.Apttus_Config2__NetUnitPrice__c != null 
                           && lineItem.Apttus_Config2__BasePriceMethod__c != null && lineItem.Apttus_Config2__SellingTerm__c > 0)   
                        {
                            System.Debug('Kh***GPD ELSE li.Apttus_Config2__NetUnitPrice__c==>'+ lineItem.Apttus_Config2__NetUnitPrice__c);
                            if(lineItem.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
                            {
                                taxTotalNewItems = taxTotalNewItems + (lineItem.Apttus_Config2__NetPrice__c/lineItem.Apttus_Config2__SellingTerm__c ); 
                            }
                            else if (lineItem.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
                            {
                                taxTotalNewItems = taxTotalNewItems + ((lineItem.Apttus_Config2__NetPrice__c/lineItem.Apttus_Config2__SellingTerm__c) * lineItem.Apttus_Config2__Quantity__c);
                                
                            }
                        }
                        tempIsNotRenewed = TRUE;    //SOC-2828
                        System.Debug('totalNewItems===>'+totalNewItems);
                        System.Debug('taxTotalNewItems===>'+taxTotalNewItems);
                    }else if (lineItem.apttus_config2__linestatus__c == 'Renewed') {
                        tempIsRenewed = TRUE;   //SOC-2828
                        totalRenewedItemsDG += lineItem.Apttus_Config2__NetPrice__c;    //DOC-14800 
                        //if ((lineItem.APTS_Yr_1_Renewal_Adjustment__c != null) && (integer.valueof(lineItem.APTS_Yr_1_Renewal_Adjustment__c) > 0))
                        if (lineItem.APTS_Yr_1_Renewal_Adjustment__c != null) {
                            totalRenewedItems += (lineItem.Apttus_Config2__NetPrice__c * integer.valueof(lineItem.APTS_Yr_1_Renewal_Adjustment__c)/100);
                            totalRenewedItemsRPA += lineItem.Apttus_Config2__NetPrice__c + (lineItem.Apttus_Config2__NetPrice__c * integer.valueof(lineItem.APTS_Yr_1_Renewal_Adjustment__c)/100);
                        } else {
                            totalRenewedItems += lineItem.Apttus_Config2__NetPrice__c;
                            totalRenewedItemsRPA += lineItem.Apttus_Config2__NetPrice__c;
                        }
                    }
                    else if (lineItem.apttus_config2__linestatus__c == 'Cancelled') 
                    {
                        //totalLapsedItems += lineItem.Apttus_Config2__NetPrice__c;
                        System.debug('Kh***GPN LI STATUS = ' + lineItem.apttus_config2__linestatus__c);
                        if(lineItem.APTS_Proposal_Business_Unit__c != null && lineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional' && lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c != null 
                           && lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__BasePriceMethod__c != null)   
                        {
                            //System.Debug('ELSE Apttus_Config2__NetUnitPrice__c==>'+ lineItem.Apttus_Config2__NetUnitPrice__c);
                            if(lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
                            {
                                taxTotalLapsedItems = taxTotalLapsedItems + (lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c ); 
                            }
                            else if (lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
                            {
                                taxTotalLapsedItems = taxTotalLapsedItems + (lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c * lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__Quantity__c);
                                
                            }
                            System.debug('totalLapsedItems = ' + taxTotalLapsedItems);
                        }
                        if (lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c != null && !( isProflexMaterial && (lineItem.apttus_config2__linestatus__c=='New' || lineItem.apttus_config2__linestatus__c=='Amended'))){
                            totalLapsedItems += lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
                                                        
                            System.debug('Kh***GPN 11totalLapsedItems = ' + totalLapsedItems);
                            //Merged code as part of FL SOC-6701 Start--Zakeer //SOC-9627 Adding FL BU in If condition
                            system.debug('##### lineitem.APTS_Proposal_Business_Unit__c'+lineitem.APTS_Proposal_Business_Unit__c+'RK --> Cond1 ='+SegThresholdComDownMap.get(condition));
                            system.debug('##### lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c'+lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c);
                            //system.debug('date ='+date.valueOf(lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c).daysBetween(System.Date.today()));
                            if(lineitem.APTS_Proposal_Business_Unit__c =='FindLaw' && lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c != NULL && date.valueOf(lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c).daysBetween(System.Date.today()) <= 180){
                                System.debug('lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c  ' + lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c );
                                //System.debug('lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c  ' + System.Date.today().daysBetween(date.valueOf(lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c )));
                                totalLapsedItems180 += lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
                                system.debug('Line ITEM Lapsed***'+ totalLapsedItems180);
                            } //SOC-6701 End
                            //SOC-9627 Adding below condition for SCS Line items
                            
                            else if(lineitem.APTS_Proposal_Business_Unit__c =='SCS' && lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c != NULL && date.valueOf(lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c).daysBetween(System.Date.today()) >= -180 && lineitem.APTS_Approval_Segment__c != 'Small Law')
                            {
                                if(lineitem!=null && (!String.isBLANK(lineItem.APTS_Cat_L2__c) && lineitem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family && lineitem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family) && lineitem.Apttus_Config2__ProductId__r.Family!= 'FINDLAW' &&
                               (!String.isBLANK(lineItem.APTS_Cat_L3__c) && lineitem.APTS_Cat_L3__c != System.Label.APTS_Ediscovery_Product_Family && lineitem.APTS_Cat_L3__c != System.Label.APTS_Case_Logistix_Product_Family ) && (lineitem.APTS_media_high_level__c =='Software' || lineitem.APTS_media_high_level__c =='Online')){
                                   if(lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c != null && lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c == 0.0){
                                    totalLapsedItems180  += lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c;
                                    }
                                    else{totalLapsedItems180 += lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;}
                                   //totalLapsedItems180 += lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
                                   system.debug('Line ITEM Lapsed***'+ totalLapsedItems180);}
                            }
                            else if(lineitem.APTS_Proposal_Business_Unit__c =='SCS' && lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c != NULL && (SegThresholdComDownMap.get(condition) != null && date.valueOf(lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c).daysBetween(System.Date.today()) >= -(SegThresholdComDownMap.get(condition).APTS_Renewal_Window__c)) 
                            && lineitem.APTS_Approval_Segment__c == 'Small Law')
                            {
                                if(lineitem!=null && (!String.isBLANK(lineItem.APTS_Cat_L2__c) && lineitem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family && lineitem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family) &&
                               lineitem.Apttus_Config2__ProductId__r.Family!= 'FINDLAW' && (!String.isBLANK(lineItem.APTS_Cat_L3__c) && lineitem.APTS_Cat_L3__c != System.Label.APTS_Ediscovery_Product_Family && lineitem.APTS_Cat_L3__c != System.Label.APTS_Case_Logistix_Product_Family ) &&
                               (lineitem.APTS_media_high_level__c =='Software' || lineitem.APTS_media_high_level__c =='Online')){
                                   totalLapsedItems180 += lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
                                   system.debug('RK --> Line ITEM Lapsed***'+ totalLapsedItems180);
                               }
                            }
                        }
                        tempIsNotRenewed = TRUE;   //SOC-2828
                        //Added as part of DOC-14800
                        if(!String.isBLANK(lineitem.APTS_Approval_Segment__c) && lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c!= null )
                        {
                            renewalwindowtmp.add((System.Date.today()).daysBetween(date.valueOf(lineitem.Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c)));
                            system.debug('RK --> RW Map = '+renewalwindowtmp);
                            
                        }
                    }
                    
                    //SOC-3870 Added by Chirag 4/27/17        
                    //SOC-7735 Added by Chirag 7/5/18  Added lineItem.LMS_Profile_Approval__c == 'LMS'
                }else if((lineItem.APTS_Cat_L3__c!=null && (lineitem.APTS_Cat_L3__c.equalsIgnoreCase(System.Label.APTS_Ediscovery_Product_Family)
                     || lineitem.APTS_Cat_L3__c.equalsIgnoreCase(System.Label.APTS_Case_Logistix_Product_Family))) 
                     &&  (lineItem.LMS_Profile_Approval__c == 'LMS')) {
                    System.debug('UserProfile ++ LMS' );
                    if ((lineItem.apttus_config2__linestatus__c == 'New' || lineItem.apttus_config2__linestatus__c == 'Amended') && !isProflexMaterial) {
                        totalNewItems += lineItem.Apttus_Config2__NetPrice__c;
                    } else if (lineItem.apttus_config2__linestatus__c == 'Renewed') {
                        if (lineItem.APTS_Yr_1_Renewal_Adjustment__c != null) {
                            totalRenewedItems += (lineItem.Apttus_Config2__NetPrice__c * integer.valueof(lineItem.APTS_Yr_1_Renewal_Adjustment__c)/100);
                            totalRenewedItemsRPA += lineItem.Apttus_Config2__NetPrice__c + (lineItem.Apttus_Config2__NetPrice__c * integer.valueof(lineItem.APTS_Yr_1_Renewal_Adjustment__c)/100);
                        } else {
                            totalRenewedItems += lineItem.Apttus_Config2__NetPrice__c;
                            totalRenewedItemsRPA += lineItem.Apttus_Config2__NetPrice__c;
                        }
                    } else if (lineItem.apttus_config2__linestatus__c == 'Cancelled') {                       
                        if (lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c != null) {
                            totalLapsedItems += lineitem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
                        }
                    } 
                }
            }
        }
        
        //SOC-2828
        if(tempIsNotRenewed == FALSE && tempIsRenewed == TRUE ){
            isRenewedOnly = TRUE;
        }
        
        //get account id associated with the configuration
        // Replaced Apttus_Config2__AccountId__c with APTS_SSD_Sold_To__c  by Tejaswi as part of GLI change(Account fields replace with SSD fields)
        //As part of Lineitemtriggerhelper Optmization , sold to ssd of product configuration queried from above line item query by Tejaswi
        //string ssdId=[SELECT APTS_SSD_Sold_To__c FROM Apttus_Config2__ProductConfiguration__c WHERE id=:cartId].APTS_SSD_Sold_To__c;
        string ssdId;
        Boolean lmsflag;
        if(lineItems!=null && lineItems.size()>0){
            ssdId=lineItems[0].Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c;
            lmsflag = lineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_LMS_Catalog__c;
        }
        if ((ssdId == null) || (ssdId == '')) {
            return;
        }
        
        //Added as part of DOC-14800
        renewalwindowtmp.sort();
        if(!renewalwindowtmp.isempty()){ renewalwindow = renewalwindowtmp[renewalwindowtmp.size()-1];}
        System.debug('RK --> RW ='+renewalwindow);
        //SOC-2828 Added by Chirag 10/30/2017  //Adding If Condition for 101 SOQL SOC-8090
        if(assetLineItems.isEmpty()){
            if(isNewSSD ==False){               
                assetLineItems = [SELECT APTS_Info_RenewalDate__c, Apttus_Config2__NetPrice__c, Apttus_Config2__Quantity__c,Apttus_Config2__NetUnitPrice__c, APTS_Proposal_Business_Unit__c, Apttus_Config2__AssetStatus__c,Apttus_Config2__IsInactive__c,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.Sales_Org__c,Apttus_Config2__BasePriceMethod__c,
                                  Apttus_Config2__ProductId__r.Media_High_Level__c,Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c ,  Apttus_Config2__ProductId__r.APTS_Cat_L3__c , Apttus_Config2__ProductId__r.APTS_Cat_L2__c
                                  , Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c
                                  , Apttus_Config2__ProductId__r.APTS_Estimated_Annual_Subscription_Price__c , Apttus_Config2__ListPrice__c, Apttus_Config2__ChargeType__c 
                                  , Apttus_Config2__PriceType__c, Apttus_Config2__ProductId__r.Productcode
                                  FROM Apttus_Config2__AssetLineItem__c 
                                  WHERE APTS_SSD_Sold_To__c =: ssdId];                                                                                                        
                //SOC-8090
                if(assetLineItems.isEmpty()){
                    isNewSSD =True;  
                }                
            }    
        }
        //SOC-9627 Commenting Below code 
        //SOC-8090
        //addded condition bt Priyanka for DOC-1600
        //get current software/online items value
        AggregateResult[] groupedResults;
        
        for(Apttus_Config2__AssetLineItem__c ali :assetLineItems){
            if(ali.Apttus_Config2__assetstatus__c=='Activated'&& ali.Apttus_Config2__IsInactive__c !=TRUE && 
            (((ali.Apttus_Config2__ProductId__r.media_high_level__c=='Online' || ali.Apttus_Config2__ProductId__r.media_high_level__c=='Software') && !(ali.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ali.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == null)) ||
             ((ali.Apttus_Config2__ProductId__r.media_high_level__c=='Online Non-Westlaw') && !(ali.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='05' && ali.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == null) ) || 
             ali.Apttus_Config2__ProductId__r.Sales_Org__c=='TA78'|| ali.Apttus_Config2__ProductId__r.Sales_Org__c=='TA61' || ali.Apttus_Config2__ProductId__r.Sales_Org__c=='S100' ||
             (ali.Apttus_Config2__ProductId__r.Sales_Org__c != null && System.Label.Risk_Sales_Orgs.contains(ali.Apttus_Config2__ProductId__r.Sales_Org__c) && !(ali.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ali.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == null)&& !(ali.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='26' && ali.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == null)))){
                //System.Debug('userdetail===>'+userdetail);
                System.Debug('ali.Apttus_Config2__ProductId__r.family===>'+ali.Apttus_Config2__ProductId__r.family);
                //if(userdetail == 'LMS'){
                if(lmsflag == true){//DOC-12752-Added as part of  CrossSell
                    if(ali!=null && ali.Apttus_Config2__ProductId__c!=null && !String.isBLANK(ali.Apttus_Config2__ProductId__r.APTS_Cat_L3__c) && ( ali.Apttus_Config2__ProductId__r.APTS_Cat_L3__c.equalsIgnoreCase(System.Label.APTS_Case_Logistix_Product_Family)
                    || ali.Apttus_Config2__ProductId__r.APTS_Cat_L3__c.equalsIgnoreCase(System.Label.APTS_Ediscovery_Product_Family))){
                        totalCurrentItems  += ali.Apttus_Config2__NetPrice__c;
                    }
                }else if(ali!=null && ali.Apttus_Config2__ProductId__c!=null && ((ali.Apttus_Config2__ProductId__r.Sales_Org__c != null && System.Label.Risk_Sales_Orgs.contains(ali.Apttus_Config2__ProductId__r.Sales_Org__c)) || ((!String.isBLANK(ali.Apttus_Config2__ProductId__r.APTS_Cat_L3__c) && ali.Apttus_Config2__ProductId__r.APTS_Cat_L3__c != System.Label.APTS_Case_Logistix_Product_Family && ali.Apttus_Config2__ProductId__r.APTS_Cat_L3__c != System.Label.APTS_Ediscovery_Product_Family)
                 && (!String.isBLANK(ali.Apttus_Config2__ProductId__r.APTS_Cat_L2__c) && ali.Apttus_Config2__ProductId__r.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family 
                 && ali.Apttus_Config2__ProductId__r.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family) 
                 && ali.Apttus_Config2__ProductId__r.family != 'FINDLAW')) 
                 ){
                    totalCurrentItems  += ali.Apttus_Config2__NetPrice__c;
                     system.debug('#### 1'+ali.APTS_Proposal_Business_Unit__c);
                     system.debug('#### 2'+ali.Apttus_Config2__NetUnitPrice__c);
                    if(ali.APTS_Proposal_Business_Unit__c != null && ali.APTS_Proposal_Business_Unit__c == 'Tax Professional' && ali.Apttus_Config2__NetUnitPrice__c != null 
                       && ali.Apttus_Config2__BasePriceMethod__c != null)   
                    {
                        if(ali.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
                        {
                            taxTotalCurrentItems = taxTotalCurrentItems + (ali.Apttus_Config2__NetUnitPrice__c ); 
                        }
                        else if (ali.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
                        {
                            taxTotalCurrentItems = taxTotalCurrentItems + (ali.Apttus_Config2__NetUnitPrice__c * ali.Apttus_Config2__Quantity__c);
                        }
                        System.debug('taxTotalCurrentItems = ' + taxTotalCurrentItems);
                    }
                }
            }
        }       
        System.Debug('totalNewItems===>'+totalNewItems);
        system.debug('################# '+APTS_LineItemTriggerHandler.afterUpdate);
        System.Debug('taxTotalNewItems===>'+taxTotalNewItems);
        System.Debug('totalCurrentItems===>'+totalCurrentItems);
        System.Debug('taxTotalCurrentItems===>'+taxTotalCurrentItems);
        System.debug('totalLapsedItems = ' + totalLapsedItems);
        System.debug('totalRenewedItems = ' + totalRenewedItems);
        System.debug('totalRenewedItemsRPA = ' + totalRenewedItemsRPA);
        System.debug('totalLapsedItems180 = ' + totalLapsedItems180);
        
        System.debug('totalCancelledItemsGLP= '+totalCancelledItemsGLP); //GLP-14,747, 594,
        System.debug('totalNewItemsGLP= '+totalNewItemsGLP); //GLP-14, 747
        system.debug('########## dealTypeNonAPP'+dealTypeNonAPP);  //GLP-14, 747
        system.debug('########## totalCancelledItemsGLP'+totalCancelledItemsGLP);  //GLP-14, 747
        system.debug('########### mapProductToListPrice'+mapProductToListPrice);  //GLP-14, 747
        system.debug('########### newLICount'+newLICount);  //GLP-14, 747

        system.debug('########### totalNewItemsGLP'+totalNewItemsGLP); //GLP-14,747

        // calculate Incremental Growth as the non-negative percentage increase of
        // the value of items in the cart over the current value of all assets,
        // NOTE: truncate to 1 decimal place (eg 1.99 ==> 1.9);
        // NOTE: -1 indicates "not applicable" when there are no current assets
        // example:  102 in cart, 100 in assets ==> 2.0% incremental growth (growth)
        // example:  100 in cart, 100 in assets ==> 0.0% incremental growth (no growth)
        // example:  98 in cart, 100 in assets ==> 0.0% incremental growth (non-negative growth)
        // example:  45 in cart, 0 in assets ==> -1 incremental growth (n/a; sentinel value); changed this to 100 to prevent every proposal from getting approval
        system.debug('totalAmendedItems ='+totalAmendedItems+'amendProflexLICount ='+amendProflexLICount);
        double tmp = 0.0;
        if (totalCurrentItems > 0) {   
            if(totalAmendedItems != null && totalAmendedItems != 0.0 && amendProflexLICount  > 0){    //DOC-13386
            system.debug('Inside GLI block');
                tmp = 100 * ((0 - totalLapsedItems - totalAmendedItems) / totalCurrentItems);               
            }
            else{tmp = 100 * ((totalRenewedItems + totalNewItems - totalLapsedItems) / totalCurrentItems);} // 10/14/2016
            //else{tmp = 100 * ((0 - totalLapsedItems-(totalRenewedItems + totalNewItems)) / totalCurrentItems); // 05/13/2021
            System.debug('*** tmp  = ' + tmp);
            // floor this at 0, since we aren't interested in anything but growth
          
        } else {
            // -1 indicates no current assets exist and, therefore, increment growth is "not applicable"
            //tmp = -1.0;
            tmp = 100.0; // based on my conversation with Harish -- 10/14/2016.
        }
        //Start: GLP-14, 747, 594
        double tmpGLP;
        if (totalCancelledItemsGLP > 0  && newLICount > 0) {            
            tmpGLP = 100 * ((totalNewItemsGLP - totalCancelledItemsGLP) / totalCancelledItemsGLP);
            System.debug('*** tmpGLP = ' + tmpGLP );
            System.debug('*** totalCancelledItemsGLP = ' + totalCancelledItemsGLP);
            // floor this at 0, since we aren't interested in anything but growth
        } 
        if(tmpGLP != null){
            incrementalGrowtthGLP = truncate(tmpGLP , 3);
        }
        totalCurrentItemsDG = (totalCurrentItems - (totalRenewedItemsDG+totalLapsedItems+totalAmendedItemsALI));
        system.debug('totalCurrentItemsDG = '+totalCurrentItemsDG+'totalAmendedItemsALI ='+totalAmendedItemsALI);
        //End
        /*For the defect DOC-15414, issue-2, Julie confirmed that we should be using values upto 3 decimal places, instead of truncating it to only 1 decimal place. 
        Hence, 3 is being passed to the method instead of 1 now*/
        incrementalGrowth = truncate(tmp, 3);      
        System.debug('*** incrementalGrowth = ' + incrementalGrowth);
        System.debug('*** incrementalGrowtthGLP= ' + incrementalGrowtthGLP);
        //update product configuration
        Apttus_Config2__ProductConfiguration__c pc = new Apttus_Config2__ProductConfiguration__c(id=cartId);
        pc.APTS_Incremental_Growth__c = incrementalGrowth;
        pc.APTS_Renewal_Holdings__c = totalRenewedItemsRPA;
        pc.APTS_New_Holdings__c = totalNewItems;
        pc.APTS_Tax_New_Holdings__c = taxTotalNewItems;    //DOC-10261
        System.Debug('APTS_New_Holdings__c===>'+pc.APTS_New_Holdings__c);
        pc.APTS_Lapsed_Holdings__c = totalLapsedItems;
        pc.APTS_Tax_Lapsed_Holdings__c = taxTotalLapsedItems;
        pc.APTS_Current_Holdings__c = totalCurrentItems;
        pc.APTS_Tax_Current_Holdings__c = taxTotalCurrentItems;
        pc.APTS_Rutter_Approval__c = rutterApproval3;
        pc.APTS_WLEC_Approval_Required__c = wlecApproval;   //SOC-4838 Added by Chirag 8/7/17
        pc.APTS_Value_of_Lapsed_within_180_days__c = totalLapsedItems180;   //SOC-2828 Added by Chirag 8/23/17
        //Added today
        pc.APTS_Amended_Holdings__c = totalAmendedItemsNP;
        pc.APTS_Current_Holdings_DG__c = totalCurrentItemsDG;
        //Merged as part of FindLaw SOC-6701 Start--Zakeer
        if(totalCurrentItems!= NULL && totalNewItems != NULL && totalLapsedItems180!= NULL && ((totalCurrentItems - totalNewItems) > totalLapsedItems180)) {
            within180Days = TRUE;
        }//SOC-6701 End
        //pc.APTS_Downgrade_Logic_Applicable__c = within180Days;//Added as part of merging Findlaw changes
        pc.APTS_Proposed_Number_of_Attorneys__c = numberOfAttorneys;    //SOC-2828 Added by Chirag 9/20/2017
        pc.APTS_Is_Renewal_Only_Configuration__c = isRenewedOnly;       //SOC-2828 Added by Chirag 11/8/2017
        pc.APTS_Special_Offer_Lapsed__c = specialOfferLapsed;           //SOC-5804 Added by CG 12/5/17
        pc.APTS_1_Year_APP_Approval_Required__c = appapproval;          //SOC-2971 Added by Chirag 1/5/18
        pc.APTS_Product_Family__c=prodFamily; // Added By Poonam Garg for DOC 11744
        
        pc.APTS_PrintProview_APP_Approval_Required__c = processPrintProviewFlagMap(printProviewFlagMap);    //GLP-820
        system.debug('####### APTS_Incremental_Growth_GLP__c '+PC.APTS_Incremental_Growth_GLP__c );
        pc.APTS_Incremental_Growth_GLP__c = incrementalGrowtthGLP;  //GLP-14,747, 594, 594
        system.debug('####### APTS_Incremental_Growth_GLP__c '+PC.APTS_Incremental_Growth_GLP__c );
        pc.APTS_Renewal_Window__c=renewalwindow;    //DOC-14800
        if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isUpdateable()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        update pc;
        System.debug('pc.APTS_Rutter_Approval__c****'+pc.APTS_Rutter_Approval__c );
        System.debug('pc.APTS_WLEC_Approval_Required__c****'+pc.APTS_WLEC_Approval_Required__c );
        //}
    }
    
    
    public static decimal truncate(decimal nbr, integer decimalPlaces) {
        String s = String.valueOf(nbr);
        String[] parts = s.split('\\.');
        
        String decimalStr;
        if (parts != null && parts.size() > 1) {
            if(parts[1].Length() > 3){
                decimalStr = parts[0] + '.' + parts[1].substring(0,3);
            }else if(parts[1].Length() == 3){
                decimalStr = parts[0] + '.' + parts[1];
            }else if(parts[1].Length() == 2){
                decimalStr = parts[0] + '.' + parts[1] + '0';
            }else if(parts[1].Length() == 1){
                decimalStr = parts[0] + '.' + parts[1] + '00';
            }
        }
        else if(parts != null){
            decimalStr = parts[0] + '.000';
        }
        return decimal.valueof(decimalStr);   
    }
    
    /*
* Below code added by Bhupendra Jain on 27-Oct-16 for Before Update logic.
* Requirement is to populate five Approval Required Checkboxes on basis of specific criteria.
*/
    public static void populateAllApprovalRequiredCB(List<Apttus_Config2__LineItem__c> lineItems) {        
        //SOC-7061
        //Boolean isShortTermTrial = False;
        system.debug('lineItems***' + lineItems);
        List<Apttus_Config2__AdjustmentLineItem__c> promoApp = new List<Apttus_Config2__AdjustmentLineItem__c>();
        
        if(APTS_ApprovalRequestTriggerHelper.approvalRequest== false){
            if (Schema.sObjectType.Apttus_Config2__AdjustmentLineItem__c.isAccessible()) {
                promoApp= [select id,Approvals_Impacted__c,Bridge_override__c,Apttus_Config2__LineItemId__c,Minimum_YOY_override__c from Apttus_Config2__AdjustmentLineItem__c where Apttus_Config2__LineItemId__c IN :lineItems];
            }
            System.debug('PROMO LIST...'+promoApp);
        }      
        //ssuri@apttus.com Starts
        List<APTS_Segment_Threshold__c> segThrsList=new List<APTS_Segment_Threshold__c>();
        Map<String,Boolean> segThresholdCorMap = new Map<String,Boolean>();
        Map<String,Boolean> segThresholdGovMap = new Map<String,Boolean>();
        Map<String,Boolean> segThreSmallLawMap = new Map<String,Boolean>();
        Map<String,Boolean> segThreMediumLawMap = new Map<String,Boolean>(); // SOC-8938 Added by Priyanka
        Map<String,Boolean> segThresholdMapPrint = new Map<String,Boolean>();        
        
        //SOC-5933/6873 Added by Chirag 3/1/2018
        Map<String,APTS_Segment_Threshold__c> segThresholdCorMapPROMO = new Map<String,APTS_Segment_Threshold__c>();
        Map<String,APTS_Segment_Threshold__c> segThresholdGovMapPROMO = new Map<String,APTS_Segment_Threshold__c>();
        Map<String,APTS_Segment_Threshold__c> segThreSmallLawMapPROMO = new Map<String,APTS_Segment_Threshold__c>();
        Map<String,APTS_Segment_Threshold__c> segThresholdMapPrintPROMO = new Map<String,APTS_Segment_Threshold__c>();
        Map<String,Decimal> segThresholdBlank = new Map<String,Decimal>();
        Map<String,Decimal> segThresholdcorpgov = new Map<String,Decimal>();
        Map<String,Decimal> segThresholdmediumsmall = new Map<String,Decimal>();
        
        String custCategory='';  
        Set<String> rsmllevels2=new Set<String>{'NW','NT','NX'};            //Added by Kruti Shah for DOC-12385
        Set<String> rsmllevels=new Set<String>{'E9','NZ'};   

        if(segmentThresholdList!=null && segmentThresholdList.size()>0){
            segThrsList.addall(segmentThresholdList); 
        }
        system.debug('segmentThresholdList--'+segmentThresholdList);
        for(APTS_Segment_Threshold__c seg:segThrsList){
            //system.debug('segment--'+seg.APTS_Segment__c);
            //SOC-8508 changed it to contains Added by Chirag 8/6/2018
            if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c.contains('Government') && seg.APTS_Minimum_OY_Increase__c!=null && seg.APTS_Minimum_OY_Increase__c!=0){
                seg.APTS_Segment__c = 'Government';
                for(Integer oyInc=0;oyInc < seg.APTS_Minimum_OY_Increase__c;oyInc++){
                    String keysetGovId=seg.APTS_Segment__c+seg.APTS_Customer_Category__c+seg.APTS_Term_in_years__c+oyInc+seg.APTS_Product_Family__c;
                    segThresholdGovMap.put(keysetGovId,Seg.APTS_Approval_Required__c);}
            }
            //SOC-8508 changed it to contains Added by Chirag 8/6/2018
            if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c.contains('Corporate') && seg.APTS_Minimum_OY_Increase__c!=null && seg.APTS_Minimum_OY_Increase__c!=0){
                seg.APTS_Segment__c = 'Corporate';
                for(Integer oyInc=0;oyInc < seg.APTS_Minimum_OY_Increase__c;oyInc++){
                    String keysetId=seg.APTS_Segment__c+seg.APTS_Customer_Category__c+seg.APTS_Term_in_years__c+oyInc+seg.APTS_Product_Family__c;
                    segThresholdCorMap.put(keysetId,Seg.APTS_Approval_Required__c);}
            }
            //SOC-8508 Added NULL Check Added by Chirag 8/6/2018
            if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c=='Small Law' && seg.APTS_Minimum_OY_Increase__c!=null && seg.APTS_Minimum_OY_Increase__c!=0){
                for(Integer oyInc=0;oyInc < seg.APTS_Minimum_OY_Increase__c;oyInc++){
                    String keysetSmallId=seg.APTS_Segment__c+seg.APTS_Customer_Category__c+seg.APTS_Term_in_years__c+oyInc;
                    segThreSmallLawMap.put(keysetSmallId,Seg.APTS_Approval_Required__c);}
            }
            //SOC-8938 Added by Priyanka
            if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c=='Medium Law' && seg.APTS_Minimum_OY_Increase__c!=null && seg.APTS_Minimum_OY_Increase__c!=0){
                for(Integer oyInc=0;oyInc < seg.APTS_Minimum_OY_Increase__c;oyInc++){
                    String keysetSmallId=seg.APTS_Segment__c+seg.APTS_Customer_Category__c+seg.APTS_Term_in_years__c+oyInc;
                    segThreMediumLawMap.put(keysetSmallId,Seg.APTS_Approval_Required__c);}
            }
            system.debug('###'+seg.APTS_Product_Family__c+'->'+Seg.APTS_Minimum_OY_Increase__c);
            if(seg.APTS_Product_Family__c != null && (seg.APTS_Product_Family__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family_Value) 
            || seg.APTS_Product_Family__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family_Value)) && seg.APTS_Minimum_OY_Increase__c!=null && seg.APTS_Minimum_OY_Increase__c!=0){
                for(Integer oyInc=0;oyInc < seg.APTS_Minimum_OY_Increase__c;oyInc++){
                    String keysetIdPrint=Seg.APTS_Product_Family__c+seg.APTS_Term_in_years__c+oyInc;
                    segThresholdMapPrint.put(keysetIdPrint,Seg.APTS_Approval_Required__c);}
            }
            //SOC-5933/6873 Added by Chirag 3/2/2018
            //SOC-8508 changed it to contains Added by Chirag 8/6/2018
            if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c.contains('Government') && seg.APTS_Promo_Minimum_OY_Increase__c!=null && seg.APTS_Promo_Minimum_OY_Increase__c!=0){
                System.debug('In Government++');
                seg.APTS_Segment__c = 'Government';
                for(Integer oyInc=0;oyInc < seg.APTS_Promo_Minimum_OY_Increase__c;oyInc++){
                    String keysetGovId=seg.APTS_Segment__c+seg.APTS_Customer_Category__c+seg.APTS_Term_in_years__c+oyInc+seg.APTS_Product_Family__c;
                    segThresholdGovMapPROMO.put(keysetGovId,Seg);}
                System.debug('segThresholdGovMapPROMO++'+ segThresholdGovMapPROMO);
            }
            //SOC-8508 changed it to contains Added by Chirag 8/6/2018
            if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c.contains('Corporate') && seg.APTS_Promo_Minimum_OY_Increase__c!=null && seg.APTS_Promo_Minimum_OY_Increase__c!=0){
                seg.APTS_Segment__c = 'Corporate';
                for(Integer oyInc=0;oyInc < seg.APTS_Promo_Minimum_OY_Increase__c;oyInc++){
                    String keysetId=seg.APTS_Segment__c+seg.APTS_Customer_Category__c+seg.APTS_Term_in_years__c+oyInc+seg.APTS_Product_Family__c;
                    segThresholdCorMapPROMO.put(keysetId,Seg);}
            }
            //SOC-8508 Added NULL Check Added by Chirag 8/6/2018
            if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c=='Small Law' && seg.APTS_Promo_Minimum_OY_Increase__c!=null && seg.APTS_Promo_Minimum_OY_Increase__c!=0){
                for(Integer oyInc=0;oyInc < seg.APTS_Promo_Minimum_OY_Increase__c;oyInc++){
                    String keysetSmallId=seg.APTS_Segment__c+seg.APTS_Customer_Category__c+seg.APTS_Term_in_years__c+oyInc;
                    segThreSmallLawMapPROMO.put(keysetSmallId,Seg);}
            }
            if(seg.APTS_Product_Family__c != null && (seg.APTS_Product_Family__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family_Value)
             || seg.APTS_Product_Family__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family_Value)) && seg.APTS_Promo_Minimum_OY_Increase__c!=null && seg.APTS_Promo_Minimum_OY_Increase__c!=0){
                for(Integer oyInc=0;oyInc < seg.APTS_Promo_Minimum_OY_Increase__c;oyInc++){
                    String keysetIdPrint=Seg.APTS_Product_Family__c+seg.APTS_Term_in_years__c+oyInc;
                    segThresholdMapPrintPROMO.put(keysetIdPrint,Seg);}
            }
      //Tiered Pricing
            if(seg.APTS_Minimum_OY_Increase__c != null){
                String keytemp = '';
                if(seg.APTS_Product_Family__c != null && (seg.APTS_Product_Family__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family_Value)
                 || seg.APTS_Product_Family__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family_Value))){
                    keytemp=seg.APTS_Product_Family__c+String.valueOf(seg.APTS_Term_in_years__c);
                    segThresholdBlank.put(keytemp,seg.APTS_Minimum_OY_Increase__c);
                }else if(seg.APTS_Segment__c == 'Corporate' || seg.APTS_Segment__c == 'Government'){
                    keytemp=seg.APTS_Segment__c+seg.APTS_Product_Family__c+seg.APTS_Customer_Category__c+String.valueOf(seg.APTS_Term_in_years__c);
                    segThresholdcorpgov.put(keytemp,seg.APTS_Minimum_OY_Increase__c);
                }else if(seg.APTS_Segment__c == 'Small Law' || seg.APTS_Segment__c == 'Medium Law'){
                    keytemp=seg.APTS_Segment__c+seg.APTS_Customer_Category__c+String.valueOf(seg.APTS_Term_in_years__c);
                    segThresholdmediumsmall.put(keytemp,seg.APTS_Minimum_OY_Increase__c);
                }
            }
        }
        system.debug('map 1'+segThresholdCorMapPROMO);      
        system.debug('map 2'+segThresholdCorMap);
        //ssuri@apttus.com ends
        Set<String> llawcodes=new Set<String> (); //Added by Poonam Garg products exclusion from Large Law Approval segment. DOC 12321
        getApprovalExclusionCriteria(llawcodes);   //Added by Poonam Garg products exclusion from Large Law Approval segment. DOC 12321
        for(Apttus_Config2__LineItem__c lineItem : lineItems) {            
            // Set all Approval Required Checkboxes to false initially. Only those checkbox(es)
            // will later be checked which fulfills criteria mentioned in the for loop.
            lineItem.APTS_Small_Law_Approval_Required__c = false;
            lineItem.APTS_Medium_Law_Approval_Required__c = false; // SOC-8938 Added by Priyanka
            lineItem.APTS_Corporate_Approval_Required__c = false;
            lineItem.APTS_Government_Approval_Required__c = false;
            lineItem.APTS_Print_Product_Approval_Required__c = false;
            lineItem.APTS_Guidance_Approval_Required__c = false;
            lineItem.LML_Approval_Required__c= false;
            lineItem.APTS_Calculat_Min_YOY_Approval_Required__c= false;
            lineItem.LMS_Channel_Approval_Required__c= false;
            lineItem.APTS_Bridg_Contract_Term_Approval__c= false;
            lineItem.APTS_Minimum_YoY_Increase__c = false;
            lineItem.APTS_1_Year_APP_Approval_Required__c  = FALSE;    //SOC-2971 Added by Chirag
            lineItem.APTS_Short_Term_Bridge_Approval__c = FALSE;          //SOC-6447 Added by Chirag
            lineItem.Apttus_CQApprov__Approval_Status__c = '';
            lineItem.APTS_Canada_Approval_Required__c =false;
            lineItem.APTS_Tax_Approval_Required__c = false;
            String temp = '';
            Boolean checkLlaw=checkExclusion(lineItem,llawcodes); //Added by Poonam Garg products exclusion from Large Law Approval segment. DOC 12321
            System.debug('checkLlaw+++'+checkLlaw);            
            if(lineItem.APTS_Customer_Category__c==null){
                       custCategory='0';   
                   }
                   else{
                       custCategory=lineItem.APTS_Customer_Category__c;
                   }      
            if(!segThresholdBlank.isEmpty() && (lineItem.APTS_Cat_L2__c != null && (lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family)
             || lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)))){
                temp = lineItem.APTS_Product_Family__c+lineItem.APTS_Contract_Term_Whole_Years__c;
                if(segThresholdBlank.containsKey(temp)){
                    lineItem.APTS_Minimum_OY_Increase__c = segThresholdBlank.get(temp);
                }
            }else{
                if(!segThresholdcorpgov.isEmpty() && (lineItem.APTS_Approval_Segment__c!=null && lineItem.APTS_Approval_Segment__c.contains('Corporate') || lineItem.APTS_Approval_Segment__c == 'Government')){
                    String segfamily = '';
                    if(lineItem.APTS_Cat_L2__c != null && lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Clear_Product_Family)){
                        segfamily = 'CLEAR';
                    }
                    //DOC-15911
                    else if(lineItem.APTS_Cat_L2__c != null && lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.Pondera_L2_Value)){
                        segfamily = 'PONDERA';
                    }
                    else if((lineItem.APTS_Cat_L2__c != null && lineItem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family
                    || lineItem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family || lineItem.APTS_Cat_L2__c != System.Label.APTS_Clear_Product_Family )
                    || lineItem.APTS_Product_Family__c!='Findlaw'                     
                    || (lineItem.APTS_Cat_L3__c != null && lineItem.APTS_Cat_L3__c != System.Label.APTS_Ediscovery_Product_Family 
                    || lineItem.APTS_Cat_L3__c != System.Label.APTS_Case_Logistix_Product_Family)){
                        segfamily = 'Non-Clear';
                    }
                    if(lineItem.APTS_Approval_Segment__c.contains('Corporate')){
                        temp = lineItem.APTS_Approval_Segment__c.left(9)+segfamily+/*lineItem.APTS_Customer_Category__c*/custCategory+lineItem.APTS_Contract_Term_Whole_Years__c;
                    }else if(lineItem.APTS_Approval_Segment__c == 'Government'){
                        temp = lineItem.APTS_Approval_Segment__c+segfamily+/*lineItem.APTS_Customer_Category__c*/custCategory+lineItem.APTS_Contract_Term_Whole_Years__c;
                    }
                    if(segThresholdcorpgov.containsKey(temp)){
                        lineItem.APTS_Minimum_OY_Increase__c = segThresholdcorpgov.get(temp);
                    }
                }else if(!segThresholdmediumsmall.isEmpty() && (lineItem.APTS_Approval_Segment__c == 'Small Law' || lineItem.APTS_Approval_Segment__c == 'Medium Law')){
                    temp = lineItem.APTS_Approval_Segment__c+/*lineItem.APTS_Customer_Category__c*/custCategory+lineItem.APTS_Contract_Term_Whole_Years__c;
                    if(segThresholdmediumsmall.containsKey(temp)){
                        lineItem.APTS_Minimum_OY_Increase__c = segThresholdmediumsmall.get(temp);
                    }
                }
            }                       
            if(lineItem.APTS_Proposal_Business_Unit__c!='Corp OneOTC US' 
               && lineItem.APTS_Proposal_Business_Unit__c !='Corp OneOTC UK' 
               && lineItem.APTS_Proposal_Business_Unit__c !='Tax Professional' && ((lineItem.APTS_Product_Code__c!=null && lineItem.APTS_Group__c!=null &&  System.Label.APTS_Proflex_Materials.contains(lineItem.APTS_Product_Code__c)) || lineItem.APTS_Group__c==null )){ 
                   //SOC-7061
                   isShortTermTrial = False;
                   isBridgePromo = False;
                   isMinYoyPromo = False;       
                  /* Moved above
                   if(lineItem.APTS_Customer_Category__c==null){
                       custCategory='0';   
                   }
                   else{
                       custCategory=lineItem.APTS_Customer_Category__c;
                   } */               
                   //if condition commented by APTTUS(ssuri@apttus.com) ends Dated:- 02-June-2017                
                   //SOC-7735 Added by Chirag removed && lineItem.LMS_Profile_Approval__c!='LMS - User'
                   //if(lineItem.Apttus_Config2__Guidance__c != null && lineItem.Apttus_Config2__Guidance__c != 'GREEN' && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' && ((lineItem.APTS_Approval_Segment__c != 'Large Law' && lineItem.LMS_Profile_Approval__c!='LMS - User') ||(lineItem.APTS_Approval_Segment__c == 'Large Law' && lineItem.LMS_Profile_Approval__c!='LMS - User'))){
                   if(lineItem.Apttus_Config2__Guidance__c != null && lineItem.Apttus_Config2__Guidance__c != 'GREEN' 
                      && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' && lineItem.APTS_Proposal_Business_Unit__c != 'Tax Professional' ){
                          lineItem.APTS_Guidance_Approval_Required__c = true;
                          lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                      }
                   
                   //Added by Prabhu for SOC-2981
                   // 6. Logic to populate 'LML Approval Required' Checkbox   
                   //SOC-7735 Added by Chirag updated lineItem.LMS_Profile_Approval__c!='LMS - User' to LMS
                   //DOC-11189 : adding if condition for HighQ
                   if(((lineItem.APTS_media_high_level__c=='Software' || lineItem.APTS_media_high_level__c=='Online')
                       || (lineItem.APTS_Media_High_Level_Code__c == '13' &&
                           (lineItem.APTS_Media_Lower_Level_Code__c == 'PQ' || lineItem.APTS_Media_Lower_Level_Code__c == 'AV'
                            || String.isBlank(lineItem.APTS_Media_Lower_Level_Code__c) || rsmllevels2.contains(lineItem.APTS_Media_Lower_Level_Code__c))
                          ) || (lineItem.APTS_Media_High_Level_Code__c == '05' && (rsmllevels.contains(lineItem.APTS_Media_Lower_Level_Code__c) || String.isBlank(lineItem.APTS_Media_Lower_Level_Code__c))) || (lineItem.APTS_Media_High_Level_Code__c == '26' && String.isBlank(lineItem.APTS_Media_Lower_Level_Code__c)))
                      && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled'
                      && (lineItem.APTS_Approval_Segment__c == 'Large Law'
                          && lineItem.LMS_Profile_Approval__c != 'LMS') && !checkLlaw){ //Added by Poonam Garg products exclusion from Large Law Approval segment. DOC 12321                   
                              lineItem.LML_Approval_Required__c= true;
                              lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                              System.debug('Inside APTS_Approval_Segment__c ....'+lineItem.APTS_Approval_Segment__c );
                              System.debug('Inside LMS_Profile_Approval__c....'+lineItem.LMS_Profile_Approval__c);
                          }
                   
                   //SOC-7735 Added by Chirag removed   lineItem.LMS_Profile_Approval__c!='LMS - User'
                   if((lineItem.APTS_media_high_level__c=='Software' || lineItem.APTS_media_high_level__c=='Online') 
                      && lineItem.APTS_Approval_Always_Required__c==true && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' 
                      && lineItem.Apttus_Config2__LineStatus__c != 'Renewed' ){                    
                          lineItem.APTS_Product_Approval_Required__c=true;
                          lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                      }
                   
                    if((lineItem.APTS_media_high_level__c=='Print') 
                      && lineItem.APTS_Approval_Always_Required__c==true && lineItem.Apttus_Config2__LineStatus__c == 'New'){                    
                          lineItem.APTS_Product_Approval_Required__c=true;
                          lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                      }
                   // 7. Logic to populate 'Bridge/Contract Term Approval' Checkbox SOC-2050                
                   //SOC-7735 Added by Chirag removed   lineItem.LMS_Profile_Approval__c!='LMS - User'
                   //Added by Chirag SOC-6447 3/15/2018            Added Contract term != Short term trial condition
                   //if((lineItem.APTS_media_high_level__c=='Software' || lineItem.APTS_media_high_level__c=='Online') && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' && lineItem.APTS_Product_Family__c != 'EDISCOVERY POINT' && ((lineItem.APTS_Approval_Segment__c != 'Large Law' && lineItem.LMS_Profile_Approval__c!='LMS - User') ||(lineItem.APTS_Approval_Segment__c == 'Large Law' && lineItem.LMS_Profile_Approval__c!='LMS - User')) && lineItem.APTS_Contract_Term__c != 'Short Term Trial'){
                   
                   checkPromo(lineItem,promoApp);
                   if(isBridgePromo !=True){                         
                       if(((lineItem.APTS_media_high_level__c=='Software' || lineItem.APTS_media_high_level__c=='Online' 
                            || (lineItem.APTS_media_high_level__c=='Online Non-Westlaw' && lineItem.APTS_Media_High_Level_Code__c=='05' 
                                && rsmllevels.contains(lineItem.APTS_Media_Lower_Level_Code__c)))
                           || (lineItem.APTS_Media_High_Level_Code__c=='13' && rsmllevels2.contains(lineitem.APTS_Media_Lower_Level_Code__c))) //Added by Kruti Shah for DOC-12385
                          && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' 
                          && (lineItem.APTS_Cat_L3__c!=null && lineItem.APTS_Cat_L3__c!=System.Label.APTS_Ediscovery_Product_Family)
                          &&  lineItem.APTS_Contract_Term__c != 'Short Term Trial'){                        
                              System.debug('lineItem.APTS_Contract_Term__c+++' + lineItem.APTS_Contract_Term__c);
                              System.debug('lineItem.APTS_Bridge_Length__+++' + lineItem.APTS_Bridge_Length__c);
                              System.debug('check annual proflex'+lineItem.Apttus_Config2__BillingFrequency__c+''+lineItem.APTS_Group__c+''+lineItem.APTS_Customer_Group__c );
                              System.debug('check annual proflex'+lineItem.APTS_Has_Online_Assets__c);
                              //DOC-372 starts
                              if(! lineItem.APTS_Has_Online_Assets__c && lineItem.APTS_Proposal_Business_Unit__c =='Canada'){
                                  if(lineItem.APTS_Bridge_Length__c > 2 && lineItem.APTS_Contract_Term__c=='1 Year' ){
                                      System.debug('Bridge Approvals++++');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }else if(lineItem.APTS_Bridge_Length__c > 4 && lineItem.APTS_Contract_Term_Whole_Years__c == 2 ){
                                      System.debug('Bridge Approvals++++2');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }else if(lineItem.APTS_Bridge_Length__c > 6 && lineItem.APTS_Contract_Term_Whole_Years__c == 3 ){
                                      System.debug('Bridge Approvals++++2');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }
                                  else if(lineItem.APTS_Bridge_Length__c != NULL && lineItem.APTS_Bridge_Length__c != 0 && lineItem.APTS_Contract_Term_Whole_Years__c > 3){
                                      System.debug('Bridge Approvals++++3');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }
                              }
                              else if(lineItem.APTS_Has_Online_Assets__c == true && lineItem.APTS_Proposal_Business_Unit__c =='Canada'){
                                  if(lineItem.APTS_Bridge_Length__c != NULL && lineItem.APTS_Bridge_Length__c != 0 && lineItem.APTS_Contract_Term__c != NULL ){
                                      System.debug('Bridge Approvals++++3');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }
                              }
                              
                              //DOC-372 ends
                              //SOC-7338 Added by Chirag 4/5/2018 and changed Contract term to Contract term whole years
                              System.debug('Poonam Bridge'+lineItem.APTS_Has_Online_Assets__c+lineItem.APTS_Proposal_Business_Unit__c);
                              if(lineItem.APTS_Has_Online_Assets__c && lineItem.APTS_Proposal_Business_Unit__c !='Canada' && lineItem.APTS_Proposal_Business_Unit__c !='FindLaw'){    //Added FindLaw condition as part of DOC-14663
                                  //September start
                                  System.debug('Bridge Approvals++++0');
                                  if(lineItem.APTS_Bridge_Length__c >= 1 && lineItem.APTS_Contract_Term__c=='1 Year' && (lineItem.APTS_Approval_Segment__c == 'Small Law' || lineItem.APTS_Approval_Segment__c == 'Medium Law')){
                                      System.debug('Bridge Approvals++++');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }else if(lineItem.APTS_Bridge_Length__c > 1 && lineItem.APTS_Contract_Term_Whole_Years__c >= 2 && (lineItem.APTS_Approval_Segment__c == 'Small Law' || lineItem.APTS_Approval_Segment__c == 'Medium Law')){
                                      System.debug('Bridge Approvals++++2');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }else if(lineItem.APTS_Bridge_Length__c != NULL && lineItem.APTS_Bridge_Length__c != 0 && lineItem.APTS_Contract_Term__c != NULL && lineItem.APTS_Approval_Segment__c != 'Small Law' && lineItem.APTS_Approval_Segment__c != 'Medium Law'){
                                      System.debug('Bridge Approvals++++3');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }
                                  //September end
                                  //SOC-8199 Added by Chirag 8/20/2018
                                  if(lineItem.APTS_Bridge_Length__c == 1 && lineItem.APTS_New_Bridge_Discount__c == 100 && (lineItem.APTS_Approval_Segment__c == 'Small Law' || lineItem.APTS_Approval_Segment__c == 'Medium Law')){
                                      System.debug('Bridge Approvals++++4');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }
                                  System.debug('Poonam ***' + lineItem.APTS_Bridge_Length__c+lineItem.APTS_New_Bridge_Discount__c+lineItem.APTS_Approval_Segment__c);
                                  //SOC-8199 Added by Chirag 8/24/2018
                                  if(lineItem.APTS_Bridge_Length__c != 1 && lineItem.APTS_New_Bridge_Discount__c != NULL && (lineItem.APTS_Approval_Segment__c == 'Small Law' || lineItem.APTS_Approval_Segment__c == 'Medium Law')){
                                      System.debug('Bridge Approvals++++5');
                                      lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  }
                                  
                              } else if(((lineItem.APTS_Contract_Term__c=='1 Year' && lineItem.APTS_Bridge_Length__c>1) || (lineItem.APTS_Contract_Term__c=='2 Years' && lineItem.APTS_Bridge_Length__c>2) || (lineItem.APTS_Contract_Term_Whole_Years__c >= 3 && lineItem.APTS_Bridge_Length__c>3)) && lineItem.APTS_Proposal_Business_Unit__c !='Canada'){
                                  lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                              }
                              
                              // 7. Logic to populate 'Group' Checkbox
                              if(lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' && lineItem.Group_Approval_Required__c==true){
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                              }
                          }
                   }//BRidge Promo         
                   //SOC-7735 Added by Chirag added   lineItem.LMS_Profile_Approval__c=='LMS'
                   if(lineItem.LMS_Profile_Approval__c=='LMS' && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' && lineItem.APTS_Bridge_Length__c != NULL && lineItem.APTS_Bridge_Length__c != 0){
                       lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                       lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                   }
                   //DOC 3744 Added By Poonam Garg
                   Set<String> ssdCg=new Set<String>{'ACADEMIC','GOVERNMENT'};
                       Set<String> mhlevels=new Set<String>{'06','13','05'};
                           if(lineItem.Apttus_Config2__BillingFrequency__c== 'Yearly' && mhlevels.contains(lineItem.APTS_Media_High_Level_Code__c) && lineItem.APTS_Customer_Group__c!=null
                              && lineItem.APTS_Proposal_Business_Unit__c ==Label.SALESORGCAN && !ssdCg.contains(lineItem.APTS_Customer_Group__c.toUpperCase()) && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                                  System.debug('Annual billed online CANADA');
                                  lineitem.APTS_Canada_Approval_Required__c =true;  
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                              }
                   //if condition logic by Apttus(ssuri@apttus.com) -- Dated:- 02-June-2017 starts                
                   String conditionString='';
                   String family='';
                   if(lineItem.APTS_Cat_L2__c != null && lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Clear_Product_Family)){
                        family='CLEAR';
                   }
                   //DOC-15911
                   else if(lineItem.APTS_Cat_L2__c != null && lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.Pondera_L2_Value)){
                        family = 'PONDERA';
                    }
                   else if((lineItem.APTS_Cat_L2__c!=null && lineItem.APTS_Cat_L2__c!=System.Label.APTS_Print_Product_Family  
                   || lineItem.APTS_Cat_L2__c!=System.Label.APTS_Proview_Product_Family || lineItem.APTS_Cat_L2__c!=System.Label.APTS_Clear_Product_Family ) 
                   || lineItem.APTS_Product_Family__c!='Findlaw'                    
                   || (lineItem.APTS_Cat_L3__c!=null && lineItem.APTS_Cat_L3__c!=System.Label.APTS_Ediscovery_Product_Family
                   || lineItem.APTS_Cat_L3__c!=System.Label.APTS_Case_Logistix_Product_Family)){
                       Family='Non-Clear';
                   }
                   else{
                       Family=lineItem.APTS_Product_Family__c;
                   }
                   
                   // 1. Logic to populate 'Small Law Approval Required' Checkbox                
                   System.debug('Sakshi>>>>Lineitem'+lineItem);
                   if(lineItem.APTS_Approval_Segment__c == 'Small Law' && lineItem.Apttus_Config2__LineStatus__c !='Cancelled' 
                      && lineItem.APTS_Media_Lower_Level_Code__c != 'AR' && (lineItem.APTS_Cat_L2__c!=null && lineItem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family  
                      && lineItem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family)  && lineItem.APTS_Contract_Term__c != 'Short Term Trial'
                      /*&& lineItem.Apttus_Config2__IncentiveCode__c != ''*/ && lineItem.APTS_Proposal_Business_Unit__c !='FindLaw'){        //Added FindLaw condition as part of DOC-14663
                          System.debug('Enterned Small law');
                          String condition=lineItem.APTS_Approval_Segment__c+custCategory+lineItem.APTS_Contract_Term_Whole_Years__c+lineItem.APTS_YOY_Least_Increase__c;
                          System.debug('condition'+condition);
                          //SOC-5933/6873 Added by Chirag 3/2/2018
                          Boolean approval;    
                          approval = segThreSmallLawMap.get(condition);   
                          System.debug('Approval'+Approval);
                          if(Approval!=null && lineItem.APTS_Small_Law_Approval_Required__c != Approval){
                             /* if(isMinYoyPromo==False) {
                                  lineItem.APTS_Small_Law_Approval_Required__c = Approval;
                              }*/
                              if(Approval==true && isMinYoyPromo==False && lineItem.APTS_Yr_2_Amount__c == NULL){
                                  lineItem.APTS_Small_Law_Approval_Required__c = Approval;
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Minimum_YoY_Increase__c = true;//Added by Neeharika Upadrasta, 23/Aug/2017
                              } 
                          }                    
                      }
                   // SOC-8939 Added by priyanka to popoulate medium Law approval required
                   if(lineItem.APTS_Approval_Segment__c == 'Medium Law' && lineItem.Apttus_Config2__LineStatus__c !='Cancelled' 
                      && lineItem.APTS_Media_Lower_Level_Code__c != 'AR' && (lineItem.APTS_Cat_L2__c!=null && lineItem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family 
                      && lineItem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family)  && lineItem.APTS_Contract_Term__c != 'Short Term Trial' 
                      /*&& lineItem.Apttus_Config2__IncentiveCode__c != ''*/&& lineItem.APTS_Proposal_Business_Unit__c !='FindLaw'){        //Added FindLaw condition as part of DOC-14663
                          System.debug('Enterned Medium law');
                          String condition=lineItem.APTS_Approval_Segment__c+custCategory+lineItem.APTS_Contract_Term_Whole_Years__c+lineItem.APTS_YOY_Least_Increase__c;
                          System.debug('condition'+condition);                    
                          Boolean approval;
                          if(String.isBlank(lineItem.Apttus_Config2__IncentiveCode__c)){
                              Approval = segThreMediumLawMap.get(condition);
                          }
                          System.debug('Approval'+Approval);
                          if(Approval!=null && lineItem.APTS_Medium_Law_Approval_Required__c != Approval){
                              /*if(isMinYoyPromo==False) {
                                  lineItem.APTS_Medium_Law_Approval_Required__c = Approval;
                              }*/
                              if(Approval==true && isMinYoyPromo==False && lineItem.APTS_Yr_2_Amount__c == NULL){
                                  lineItem.APTS_Medium_Law_Approval_Required__c = Approval;
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Minimum_YoY_Increase__c = true;
                              } 
                          }                    
                      }
                   
                   // 2. Logic to populate 'Corporate Approval Required' Checkbox    
                   //DOC-15911            
                   if( lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Approval_Segment__c.contains('Corporate') 
                      && lineItem.Apttus_Config2__LineStatus__c !='Cancelled' && lineItem.APTS_Media_Lower_Level_Code__c != '51' 
                      &&  (((lineItem.APTS_Cat_L2__c!=null && lineItem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family  
                      && lineItem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family) )
                           || (lineItem.APTS_Cat_L2__c!=null && lineItem.APTS_Cat_L2__c == System.Label.APTS_Clear_Product_Family ) || (lineItem.APTS_Cat_L2__c != null && lineItem.APTS_Cat_L2__c == System.Label.Pondera_L2_Value)) && lineItem.APTS_Contract_Term__c != 'Short Term Trial' 
                      /*&& lineItem.Apttus_Config2__IncentiveCode__c != ''*/){
                          System.debug('Sakshi 2>>>>Lineitem'+lineItem);
                          String segement = 'Corporate';  //SOC-8508 changed it to string Added by Chirag 8/21/2018
                          String condition=segement+custCategory+lineItem.APTS_Contract_Term_Whole_Years__c+lineItem.APTS_YOY_Least_Increase__c+Family;
                          //SOC-5933/6873 Added by Chirag 3/2/2018
                          Boolean approval;                    
                          approval = segThresholdCorMap.get(condition);                    
                          System.debug('condition>>>'+condition+'   Approval>>>>'+Approval+'lineItem.APTS_Yr_2_Amount__c == NULL'+lineItem.APTS_Yr_2_Amount__c == NULL);
                          if(Approval!=null && lineItem.APTS_Corporate_Approval_Required__c != Approval){
                              /*if(isMinYoyPromo==False) {                    
                                  lineItem.APTS_Corporate_Approval_Required__c = Approval;
                              }*/
                              if(Approval==true && isMinYoyPromo==False && lineItem.APTS_Yr_2_Amount__c == NULL){
                                  lineItem.APTS_Corporate_Approval_Required__c = Approval;
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Minimum_YoY_Increase__c = true;//Added by Neeharika Upadrasta, 23/Aug/2017
                              } 
                          }
                      }
                   
                   // 2. Logic to populate 'Corporate Approval Required' Checkbox for Category 5                
                   if( lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Approval_Segment__c.contains('Corporate') 
                      && lineItem.Apttus_Config2__LineStatus__c !='Cancelled' && lineItem.APTS_Media_Lower_Level_Code__c != '51' 
                      && (lineItem.APTS_Cat_L2__c !=null && lineItem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family
                      && lineItem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family)
                      && lineItem.APTS_Contract_Term__c != 'Short Term Trial' 
                      /*&& lineItem.Apttus_Config2__IncentiveCode__c != ''*/){
                          System.debug('Sakshi 2nd cop>>>>Lineitem'+lineItem);
                          String segement = 'Corporate';     //SOC-8508 changed it to string Added by Chirag 8/21/2018
                          String condition=segement+custCategory+lineItem.APTS_Contract_Term_Whole_Years__c+lineItem.APTS_YOY_Least_Increase__c+Family;
                          System.debug('Sakshi 2nd cop>>>>Lineitem'+condition);
                          //SOC-5933/6873 Added by Chirag 3/2/2018
                          Boolean approval;                    
                          approval = segThresholdCorMap.get(condition);                    
                          System.debug('condition>>>'+condition+'   Approval>>>>'+Approval);
                          if(Approval!=null && lineItem.APTS_Corporate_Approval_Required__c != Approval){
                              /*if(isMinYoyPromo==False) {                      
                                  lineItem.APTS_Corporate_Approval_Required__c = Approval;
                              }*/
                              if(Approval==true && isMinYoyPromo==False && lineItem.APTS_Yr_2_Amount__c == NULL){
                                  lineItem.APTS_Corporate_Approval_Required__c = Approval;    
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Minimum_YoY_Increase__c = true; //Added by Neeharika Upadrasta, 23/Aug/2017
                              } 
                          }                    
                      }
                   
                   // 3. Logic to populate 'Government Approval Required' Checkbox                
                   
                   if( lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Approval_Segment__c.contains('Government') 
                      && lineItem.Apttus_Config2__LineStatus__c !='Cancelled' && lineItem.APTS_Media_Lower_Level_Code__c != '51' &&(lineItem.APTS_Cat_L2__c !=null && lineItem.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family  
                      && lineItem.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family)  
                      && lineItem.APTS_Contract_Term__c != 'Short Term Trial' 
                      ){
                          System.debug('Sakshi 3>>>>Lineitem'+lineItem);
                          String segement = 'Government';     //SOC-8508 changed it to string Added by Chirag 8/21/2018
                          String condition=segement+custCategory+lineItem.APTS_Contract_Term_Whole_Years__c+lineItem.APTS_YOY_Least_Increase__c+Family;
                          //SOC-5933/6873 Added by Chirag 3/2/2018
                          
                          Boolean approval;
                          System.debug('SegmentMapPROMO' + segThresholdGovMapPROMO);
                          System.debug('SegmentMapPROMO' + segThresholdGovMap.get(condition));
                          System.debug('SegmentMapPROMO' + String.isBlank(lineItem.Apttus_Config2__IncentiveCode__c));
                          System.debug('SegmentMapPROMO1' + lineItem.Apttus_Config2__IncentiveCode__c);                    
                          System.debug('insideSegmentMapPROMO');
                          Approval = segThresholdGovMap.get(condition);                    
                          System.debug('condition>>>'+condition+'   Approval>>>>'+Approval);
                          if(Approval!=null && lineItem.APTS_Government_Approval_Required__c != Approval){
                              /*if(isMinYoyPromo==False) {                 
                                  lineItem.APTS_Government_Approval_Required__c = Approval;
                              }*/
                              if(Approval==true && isMinYoyPromo==False && lineItem.APTS_Yr_2_Amount__c == NULL){
                                  lineItem.APTS_Government_Approval_Required__c = Approval;
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Minimum_YoY_Increase__c = true;//Added by Neeharika Upadrasta, 23/Aug/2017
                              }
                          }
                      }
                   
                   // 4. Logic to populate 'Print Product Approval Required' Checkbox
                   
                   //SOC-7735 Added by Chirag removed   lineItem.LMS_Profile_Approval__c!='LMS - User' //Added by Bijeta Feb 2020 Release DOC-7532        
                   if( (lineItem.APTS_Cat_L2__c != null && (lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family)
                    || lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)))  
                      && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' &&  (!String.isEmpty(lineItem.APTS_Product_Name__c) && !lineItem.APTS_Product_Name__c.Contains(System.Label.APTS_CARS_SmallFirmPackage))){                    
                          System.debug('Sakshi 4>>>>Lineitem'+lineItem);
                          String condition=lineItem.APTS_Product_Family__c+lineItem.APTS_Contract_Term_Whole_Years__c+lineItem.APTS_YOY_Least_Increase__c;
                          //SOC-5933/6873 Added by Chirag 3/2/2018
                          Boolean approval;                    
                          approval = segThresholdMapPrint.get(condition);                   
                          System.debug('Sakshi 4>>>>condition'+condition);
                          System.debug('Sakshi 4>>>>Approval'+Approval);
                          if(Approval!=null && lineItem.APTS_Print_Product_Approval_Required__c != Approval){
                              //if(isMinYoyPromo==False)                       
                                  //lineItem.APTS_Print_Product_Approval_Required__c = Approval;
                                  if(Approval==true && isMinYoyPromo==False && lineItem.APTS_Yr_2_Amount__c == NULL){
                                      lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                      lineItem.APTS_Minimum_YoY_Increase__c = true;//Added by Neeharika Upadrasta, 23/Aug/2017
                                  } 
                          }
                          //Added by Chirag SOC-4938 8/30/2017
                          if(lineItem.APTS_Deal_Type__c == 'APP' && lineItem.Apttus_Config2__LineStatus__c == 'Amended'){
                              //lineItem.APTS_Print_Product_Approval_Required__c = TRUE;
                              lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                          }
                      }                
                   //SOC-7735 Added by Chirag
                   // 5. LMS Approvals
                   if( lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Approval_Segment__c.contains('LMS') 
                      && lineItem.Apttus_Config2__LineStatus__c !='Cancelled' && lineItem.APTS_YOY_Least_Increase__c < 5 
                      && (lineItem.APTS_Cat_L3__c != null && lineItem.APTS_Cat_L3__c.equalsIgnoreCase(System.Label.APTS_Case_Logistix_Product_Family))){
                          System.debug('LMS5>>>>Lineitem'+lineItem);
                          lineItem.LMS_Channel_Approval_Required__c= TRUE;
                          lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                      }
                   //SOC-5804 Added by Chirag 11/30/2017
                   if(lineItem.APTS_Is_Special_Offer_Lapsed__c == TRUE){
                       lineItem.APTS_Special_Offer_Lapsed__c = TRUE;
                       lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                   } 
                   //SOC-2971 Added by Chirag 1/5/18
                   if((lineItem.APTS_Print_Purchase_Options__c == 'Ship & Enter Sub APP' 
                       || lineItem.APTS_Print_Purchase_Options__c == 'Sub only APP' || lineItem.APTS_Purchase_Options__c == 'APP' 
                       || lineItem.APTS_Print_Purchase_Options__c == 'Fill-Up & Enter Sub APP'
                       || (lineItem.APTS_Media_High_Level_Code__c == '21' && lineItem.APTS_Media_Lower_Level_Code__c == 'CQ')) //GLP-74
                      && lineItem.APTS_Contract_Term_Whole_Years__c == 1){
                          lineItem.APTS_1_Year_APP_Approval_Required__c = TRUE;
                          lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';                    
          }
                   
                   
                   //SOC-7061            //Added by Chirag SOC-6447 3/13/2018
                   System.debug('lineItem.APTS_Bridge__c++ ' + lineItem.APTS_Bridge__c);
                   if(isShortTermTrial !=True){   
                       if(lineItem.APTS_Contract_Term__c == 'Short Term Trial' && lineItem.APTS_Bridge__c != NULL 
                          && lineItem.APTS_Bridge__c != '7 Days' && lineItem.APTS_Bridge__c != '14 Days' 
                          && lineItem.APTS_Bridge__c != '28 Days'){
                              if((lineItem.APTS_Approval_Segment__c == 'Small Law' || lineItem.APTS_Approval_Segment__c == 'Medium Law') && lineItem.APTS_Proposal_Business_Unit__c !='FindLaw'){    //Added FindLaw condition as part of DOC-14663
                                  System.debug('In small law');
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Short_Term_Bridge_Approval__c = TRUE;
                              }else if(lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Approval_Segment__c.contains('Corporate')){
                                  System.debug('InCorp');
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Short_Term_Bridge_Approval__c = TRUE;
                              }else if(lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Approval_Segment__c.contains('Government')){
                                  System.debug('In Govt');
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Short_Term_Bridge_Approval__c = TRUE;
                              }// DOC-1176
                              else if(lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Approval_Segment__c.contains('Canada')){
                                  System.debug('In Canada');
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Short_Term_Bridge_Approval__c = TRUE;
                              }
                              else if(lineItem.APTS_Cat_L2__c != null && lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family)){
                                  System.debug('In Print');
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Short_Term_Bridge_Approval__c = TRUE;
                              }
                              else if(lineItem.APTS_Approval_Segment__c != null && lineItem.APTS_Approval_Segment__c == 'Large Law'){
                                  System.debug('In Large Law');
                                  lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                                  lineItem.APTS_Short_Term_Bridge_Approval__c = TRUE;
                              }
                          }              
                   }//STT end 
               }
            //Added by Priyanka for DOC-1600
            if(lineItem.Apttus_Config2__Guidance__c != null && lineItem.Apttus_Config2__Guidance__c != 'GREEN' 
               && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' && lineItem.APTS_Proposal_Business_Unit__c != 'Tax Professional'&& ((lineItem.APTS_Product_Code__c!=null && lineItem.APTS_Group__c!=null &&  System.Label.APTS_Proflex_Materials.contains(lineItem.APTS_Product_Code__c)) || lineItem.APTS_Group__c==null )){                
                   lineItem.APTS_Guidance_Approval_Required__c = true;
                   lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';                
               }
            //Added as part of DOC 3237 By Poorva
            if(lineItem.Apttus_Config2__Guidance__c != null && lineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional' && lineItem.Apttus_Config2__Guidance__c != 'GREEN' && lineItem.Apttus_Config2__Guidance__c != 'YELLOW' 
               && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' ){                
                   lineItem.APTS_Guidance_Approval_Required__c = true;
                   lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';                
               }
            if(lineItem.APTS_Years_2_Plus_Adjustment__c !=null  || (lineItem.APTS_Proposal_Business_Unit__c !=null && System.Label.Risk_PBUs.contains(lineItem.APTS_Proposal_Business_Unit__c))){                
               
                // DOC-3232 Roma
                system.debug('#### lineItem.APTS_Calculated_Min_YOY__c'+lineItem.APTS_Calculated_Min_YOY__c);
                system.debug('#### lineItem.APTS_Proposal_Business_Unit__c'+lineItem.APTS_Proposal_Business_Unit__c);
                if(lineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional'
                   && lineItem.APTS_Calculated_Min_YOY__c != null && lineItem.APTS_Calculated_Min_YOY__c <= 2){                    
                       lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';   
                       lineItem.APTS_Minimum_YoY_Increase__c = true;    
                       lineItem.APTS_Tax_Approval_Required__c =true;                    
                   }
                
                if(!lineItem.APTS_Has_Online_Assets__c && (lineItem.APTS_Proposal_Business_Unit__c =='Tax Professional' ||
                     (lineItem.APTS_Proposal_Business_Unit__c !=null && System.Label.Risk_PBUs.contains(lineItem.APTS_Proposal_Business_Unit__c)))){
                    if(lineItem.APTS_Bridge_Length__c > 1 && lineItem.APTS_Contract_Term__c=='1 Year' ){
                        System.debug('Bridge Approvals++++');
                        lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                        lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                    }else if(lineItem.APTS_Bridge_Length__c > 2 && lineItem.APTS_Contract_Term_Whole_Years__c == 2 ){
                        System.debug('Bridge Approvals++++2');
                        lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                        lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                    }else if(lineItem.APTS_Bridge_Length__c > 3 && lineItem.APTS_Contract_Term_Whole_Years__c == 3 ){
                        System.debug('Bridge Approvals++++2');
                        lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                        lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                    }
                    else if(lineItem.APTS_Bridge_Length__c != NULL && lineItem.APTS_Bridge_Length__c != 0 && lineItem.APTS_Bridge_Length__c > 3){
                        System.debug('Bridge Approvals++++3');
                        lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                        lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                    }
                    
               // }
                
                }else if(lineItem.APTS_Has_Online_Assets__c == true && (lineItem.APTS_Proposal_Business_Unit__c =='Tax Professional' ||
                           (lineItem.APTS_Proposal_Business_Unit__c !=null && System.Label.Risk_PBUs.contains(lineItem.APTS_Proposal_Business_Unit__c)))){
                system.debug('#####'+lineItem.APTS_Has_Online_Assets__c+'---->'+lineItem.APTS_Proposal_Business_Unit__c+lineItem.APTS_Bridge_Length__c+lineItem.APTS_Contract_Term__c);
                    if(lineItem.APTS_Bridge_Length__c != NULL && lineItem.APTS_Bridge_Length__c != 0 && lineItem.APTS_Contract_Term__c != NULL ){
                        System.debug('Bridge Approvals++++3');
                        lineItem.APTS_Bridg_Contract_Term_Approval__c= true;
                        lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                    }
                }
                
                //DOC 6401 & DOC-3242 ends
                
                
                //DOC-367 Added by Priyanka
                if((lineItem.APTS_Proposal_Business_Unit__c =='Canada' && ((lineItem.APTS_Product_Code__c!=null && lineItem.APTS_Group__c!=null &&  System.Label.APTS_Proflex_Materials.contains(lineItem.APTS_Product_Code__c)) || lineItem.APTS_Group__c==null )) 
                   && Integer.valueOf(lineItem.APTS_Years_2_Plus_Adjustment__c) < 2 && lineItem.APTS_Yr_2_Amount__c == NULL){                    
                       lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';   
                       lineItem.APTS_Minimum_YoY_Increase__c = true;    
                       lineitem.APTS_Canada_Approval_Required__c =true;                    
                   }    
            }                     
            
            if((lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC US' 
                || lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC UK') 
               && lineItem.APTS_Approval_Always_Required__c==true && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' 
               && lineItem.Apttus_Config2__LineStatus__c != 'Renewed' && lineItem.APTS_WLEC_Product_Category__c== 'PS' ){
                   lineItem.APTS_Product_Approval_Required__c=true;   
                   lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
               }
            if((lineItem.APTS_Proposal_Business_Unit__c =='Tax Professional' || (lineItem.APTS_Proposal_Business_Unit__c !=null && System.Label.Risk_PBUs.contains(lineItem.APTS_Proposal_Business_Unit__c))) 
               && lineItem.APTS_Approval_Always_Required__c==true && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' 
               && lineItem.Apttus_Config2__LineStatus__c != 'Renewed' ){
                   lineItem.APTS_Product_Approval_Required__c=true;   
                   lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
               }
            if(lineItem.APTS_Proposal_Business_Unit__c =='SCS' && lineItem.APTS_Yr_2_Amount__c != NULL && lineItem.APTS_Calculated_Min_YOY__c <= lineItem.APTS_Minimum_OY_Increase__c && (lineItem.Apttus_Config2__LineStatus__c == 'Renewed' || lineItem.Apttus_Config2__LineStatus__c == 'New' ) && (lineItem.APTS_Contract_Term__c!='1 Year' &&  lineItem.APTS_Contract_Term__c!='Short Term Trial' &&  lineItem.APTS_Contract_Term__c!='Existing') && (lineItem.APTS_Media_Lower_Level_Code__c!='51' && lineItem.APTS_Media_Lower_Level_Code__c!='AR') && ((lineItem.APTS_Product_Code__c!=null && lineItem.APTS_Group__c!=null &&  System.Label.APTS_Proflex_Materials.contains(lineItem.APTS_Product_Code__c)) || lineItem.APTS_Group__c==null )){
                lineItem.APTS_Calculat_Min_YOY_Approval_Required__c=true;   
                lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
            }
            if(lineItem.APTS_Proposal_Business_Unit__c =='Canada' && lineItem.APTS_Yr_2_Amount__c != NULL && lineItem.APTS_Calculated_Min_YOY__c < 1.99 && (lineItem.Apttus_Config2__LineStatus__c == 'Renewed' || lineItem.Apttus_Config2__LineStatus__c == 'New' ) && (lineItem.APTS_Contract_Term__c!='1 Year' &&  lineItem.APTS_Contract_Term__c!='Short Term Trial' &&  lineItem.APTS_Contract_Term__c!='Existing') && (lineItem.APTS_Media_Lower_Level_Code__c!='51' && lineItem.APTS_Media_Lower_Level_Code__c!='AR') && ((lineItem.APTS_Product_Code__c!=null && lineItem.APTS_Group__c!=null &&  System.Label.APTS_Proflex_Materials.contains(lineItem.APTS_Product_Code__c)) || lineItem.APTS_Group__c==null )){
                lineItem.APTS_Calculat_Min_YOY_Approval_Required__c=true;   
                lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
            }
        }
        
    } // End of 'populateAllApprovalRequiredCB' method
    // Changes done by Bhupendra Jain on 27-Oct-16 for Before Update logic ends here
    
    //SOC-5933/6873 Added by Chirag 3/20/2018   
    public static Boolean matchPromo(String cartPromo, String segmentPromo){
        List<String> cartPromos = cartPromo.split(',');
        List<String> segmentPromos = segmentPromo.split(',');
        Boolean promoMatch = FALSE;
        for(String promo : cartPromos){
            if(segmentPromos.contains(promo)) {
                promoMatch = TRUE;
            }
        }        
        return promoMatch;
    } 
    
    //SOC-4319 
    public static void retrieveAdjustmentAmount(List <Apttus_Config2__LineItem__c> lItemList){
        List<Apttus_Config2__LineItem__c> cancelledItem = new List<Apttus_Config2__LineItem__c>();
        Set<id> prodId = new Set<id>();
        list<Apttus_Config2__PriceMatrixEntry__c > matrxList = new List<Apttus_Config2__PriceMatrixEntry__c>();
        Map <Id,Apttus_Config2__PriceMatrixEntry__c> amendedEntry = new Map<Id,Apttus_Config2__PriceMatrixEntry__c>();
        for(Apttus_Config2__LineItem__c c:lItemList){
            If(c.Apttus_Config2__LineStatus__c == 'Cancelled'){
                cancelledItem.add(c);
                prodId.add(c.Apttus_Config2__ProductId__c);
            }            
        }
        //SOC-8090     
        if(!prodId.isEmpty()) {
            System.debug('Count this method+++');
          
            if(!Schema.sObjectType.Apttus_Config2__PriceMatrixEntry__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            matrxList = [Select id ,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__PriceMatrixId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c from Apttus_Config2__PriceMatrixEntry__c where Apttus_Config2__Dimension1Value__c = 'Amended' AND 
                         Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c =: prodId AND Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ChargeType__c ='Subscription Fee' AND 
                         Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceType__c = 'Recurring'];
        }   
        
        for(Apttus_Config2__PriceMatrixEntry__c matrixEntry: matrxList){            
            amendedEntry.put(matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,matrixEntry);
            System.debug('amendedEntry...' + amendedEntry);            
        }
        for(Apttus_Config2__LineItem__c cItem :cancelledItem ){
            If(!amendedEntry.isEmpty() && amendedEntry.containskey(cItem.Apttus_Config2__ProductId__c) 
               && (amendedEntry.get(cItem.Apttus_Config2__ProductId__c).Apttus_Config2__AdjustmentAmount__c)!=NULL ){                
                   System.debug('Inside cancelleditemlist');
                   cItem.APTS_Cancelled_Adjustment_Amount__c= amendedEntry.get(cItem.Apttus_Config2__ProductId__c).Apttus_Config2__AdjustmentAmount__c*cItem.Apttus_Config2__Quantity__c;
                   System.debug('Inside cancelleditemlist1'+cItem.APTS_Cancelled_Adjustment_Amount__c);
               }                      
        }        
    }
    
    //SOC_7601 
    public static void checkPromo ( Apttus_Config2__LineItem__c li, List<Apttus_Config2__AdjustmentLineItem__c> promoList){
        //Boolean isShortTermTrial = False;
        Decimal bridgePromoOvr =0.0;
        Decimal bridgePromoOvr1 =0.0;
        Decimal minYoy =0.0;
        
        System.debug('isShortTermTrial ....'+ isShortTermTrial );
        for(Apttus_Config2__AdjustmentLineItem__c promo : promoList){
            if(li.id == promo.Apttus_Config2__LineItemId__c){
                if(li.APTS_Bridge_Length__c !=70 && li.APTS_Bridge_Length__c !=14 && li.APTS_Bridge_Length__c !=28){
                    if(promo.Approvals_Impacted__c !=Null && promo.Approvals_Impacted__c !='' 
                       && promo.Approvals_Impacted__c.containsIgnorecase('Short Term Trials')){
                           if(bridgePromoOvr==0){
                               bridgePromoOvr = promo.Bridge_override__c;
                           }else if(bridgePromoOvr  < promo.Bridge_override__c){
                               bridgePromoOvr  = promo.Bridge_override__c;
                           }
                           if(bridgePromoOvr > li.APTS_Bridge_Length__c) {
                               isShortTermTrial = True;    
                           }
                       }                   
                }
                if(promo.Approvals_Impacted__c !=Null && promo.Approvals_Impacted__c !='' 
                   && promo.Approvals_Impacted__c.containsIgnorecase('Bridges')){
                       if(bridgePromoOvr1==0){
                           bridgePromoOvr1 = promo.Bridge_override__c;
                       }else if(bridgePromoOvr1 < promo.Bridge_override__c){
                           bridgePromoOvr1 = promo.Bridge_override__c;
                       }
                       if(bridgePromoOvr1 > li.APTS_Bridge_Length__c) {
                           isBridgePromo =True;
                       }
                   }
                if(promo.Approvals_Impacted__c !=Null && promo.Approvals_Impacted__c !='' 
                   && promo.Approvals_Impacted__c.containsIgnorecase('Minimum YOY Increase')){
                       System.debug('Minimum YOY Increase Inside **');
                       if(minYoy ==0){
                           minYoy = promo.Minimum_YOY_override__c;                       
                       }else if(minYoy > promo.Minimum_YOY_override__c){
                           minYoy = promo.Minimum_YOY_override__c;
                       }
                       system.debug('minYoy****'+minYoy);
                       if(li.APTS_Years_2_Plus_Adjustment__c!=null){
                           String str = li.APTS_Years_2_Plus_Adjustment__c;
                           Decimal liMinYoy = decimal.valueOf(str); 
                           system.debug('liMinYoy***'+liMinYoy);        
                           if(minYoy< liMinYoy) {
                               isMinYoyPromo=True;
                           }
                       }
                   }
            }
        }
    } 
    public static void multiYearTieredPricingSCSandCanada(List<Apttus_Config2__LineItem__c> lineItemsList){
        
        Integer contractTerm;
        List<Decimal> dollarValues;
        //DOC-12697 YearIncrease varialbles
        List<Decimal> dollarYear12Values; 
        List<Decimal> dollarYear23Values; 
        List<Decimal> dollarYear34Values; 
        List<Decimal> dollarYear45Values; 
        List<Decimal> multiYearPrices;
        Decimal calculatedYear1Price;
        Integer calculatedMinYoy;
        Integer yoy2;        
        //DOC-12822
        Integer yoy1Renewal; 
        String aliBillFreq;
        String liBillFreq;
        Decimal contractExitAmount;
        //
        List<Apttus_Config2__LineItem__c> multiYearLineItems=new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> proflexseconLineItems=new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> shorttermLineItems=new List<Apttus_Config2__LineItem__c>();
        
        Boolean isProflexMaterial=false;
         for(Apttus_Config2__LineItem__c lineItem:lineItemsList){
            if(lineItem.Apttus_Config2__LineStatus__c !='Cancelled' && lineItem.Apts_Product_Code__c != null
            && System.Label.APTS_Proflex_Materials.contains(lineItem.Apts_Product_Code__c)){
            isProflexMaterial=true;
            }
        }
        for(Apttus_Config2__LineItem__c lineItem:lineItemsList){
            system.debug('entered term check--'+lineItem.APTS_Contract_Term__c);
            system.debug('entered term check--'+lineItem.APTS_Group__c);
            system.debug('entered term check--'+lineItem.Apts_Product_Code__c );
            //Blank the values for secondary materials on the cart.
            if(lineItem.Apttus_Config2__LineStatus__c !='Cancelled' && ((lineItem.APTS_Group__c !=null && lineItem.Apts_Product_Code__c != null
            && !System.Label.APTS_Proflex_Materials.contains(lineItem.Apts_Product_Code__c))  || ((lineItem.Apttus_Config2__OptionId__c !=null || (lineItem.Apttus_Config2__HasOptions__c && lineItem.APTS_Product_Code__c !='40666420')) && (isProflexMaterial && lineItem.APTS_Group__c !=null)))){
                proflexseconLineItems.add(lineItem);
                System.debug(lineItem.Name);
            }
            if(lineItem.APTS_Contract_Term__c==null){
                lineItem.APTS_Calculated_Year_1__c=0;
                lineItem.APTS_Calculated_Year_2__c=0;
                lineItem.APTS_Calculated_Year_3__c=0;
                lineItem.APTS_Calculated_Year_4__c=0;
                lineItem.APTS_Calculated_Year_5__c=0;
                lineItem.APTS_Increase_Yr1_Yr2__c=0;
                lineItem.APTS_Increase_Yr2_Yr3__c=0;
                lineItem.APTS_Increase_Yr3_Yr4__c=0;
                lineItem.APTS_Increase_Yr4_Yr5__c=0;
            }
            // Standalone products or group with only proflex materials.
            else if(lineItem.APTS_Contract_Term__c!=null &&(lineItem.APTS_Contract_Term__c=='1 Year' || 
            lineItem.APTS_Contract_Term__c=='2 Years' || lineItem.APTS_Contract_Term__c=='3 Years' ||
             lineItem.APTS_Contract_Term__c=='4 Years' || lineItem.APTS_Contract_Term__c=='5 Years')
              && (lineItem.Apttus_Config2__LineStatus__c =='New' || lineItem.Apttus_Config2__LineStatus__c =='Renewed' 
              || (lineItem.APTS_Group__c !=null && lineItem.Apts_Product_Code__c != null
              && System.Label.APTS_Proflex_Materials.contains(lineItem.Apts_Product_Code__c) &&  lineItem.Apttus_Config2__LineStatus__c =='Amended'))){
                system.debug('entered term check');
                multiYearLineItems.add(lineItem);
                
            } 
            else if(lineItem.APTS_Contract_Term__c!=null && (lineItem.APTS_Contract_Term__c=='Short Term Trial' || lineItem.APTS_Contract_Term__c=='Existing')){
                shorttermLineItems.add(lineItem);
                System.debug('RK --> shorttermLineItems'+lineItem.Name);
            
            }     
        }
        if(!shorttermLineItems.isEmpty()){
            populateBlankValues(shorttermLineItems);
        }
        
        for(Apttus_Config2__LineItem__c lineItem:multiYearLineItems){
            
            dollarValues=new List<Decimal>();
            //DOC-12697
            dollarYear12Values=new List<Decimal>();   
            dollarYear23Values=new List<Decimal>();
            dollarYear34Values=new List<Decimal>();
            dollarYear45Values=new List<Decimal>();
            //End
            multiYearPrices=new List<Decimal>();
            calculatedYear1Price=0.0;
            yoy2=(lineItem.APTS_Years_2_Plus_Adjustment__c!=null)?Integer.valueOf(lineItem.APTS_Years_2_Plus_Adjustment__c):0;
            contractTerm=(lineItem.APTS_Contract_Term_Whole_Years__c).intValue();
            //DOC-12822
            aliBillFreq = lineItem.APTS_Asset_Billing_Frequency__c;
            liBillFreq = lineItem.Apttus_Config2__BillingFrequency__c;
            system.debug('ALI BF ='+aliBillFreq+'LI BF='+liBillFreq );
            contractExitAmount = 0.0;
            yoy1Renewal=(lineItem.APTS_Yr_1_Renewal_Adjustment__c!=null)?Integer.valueOf(lineItem.APTS_Yr_1_Renewal_Adjustment__c):0;   
            if(lineItem.APTS_Contract_Exit_Amount__c!=null){
            contractExitAmount=lineItem.APTS_Contract_Exit_Amount__c;}
            system.debug('CEA = '+lineItem.APTS_Contract_Exit_Amount__c);
            
            if(lineItem.Apttus_Config2__LineStatus__c =='Renewed'){
            system.debug('Inside Renewal CY1 block');
                if(String.isNotBlank(aliBillFreq) && String.isNotBlank(liBillFreq)){
                system.debug('Billing Frequency populated');
                    if(aliBillFreq  =='Yearly' && liBillFreq == 'Monthly' ){
                        calculatedYear1Price = (((contractExitAmount*yoy1Renewal)/100)+contractExitAmount)/12;
                        calculatedYear1Price = calculatedYear1Price!=null ? calculatedYear1Price.setscale(2) : 0.0;
                        System.debug('CY1 YearlyMon='+calculatedYear1Price);
                    }
                    else if((aliBillFreq  =='Monthly' && liBillFreq == 'Monthly') || (aliBillFreq  =='Yearly' && liBillFreq == 'Yearly')){
                        calculatedYear1Price = ((contractExitAmount*yoy1Renewal)/100)+contractExitAmount;
                        calculatedYear1Price = calculatedYear1Price!=null ? calculatedYear1Price.setscale(2) : 0.0;
                        
                        System.debug('CY1 MMYY='+calculatedYear1Price);
                    }
                    else if(aliBillFreq  =='Monthly' && liBillFreq == 'Yearly'){
                        calculatedYear1Price = (((contractExitAmount*yoy1Renewal)/100)+contractExitAmount)*12;
                        calculatedYear1Price = calculatedYear1Price!=null ? calculatedYear1Price.setscale(2) : 0.0;
                        
                        System.debug('CY1 MonYearly='+calculatedYear1Price);
                    }
                    else{
                        calculatedYear1Price=lineItem.Apttus_Config2__NetPrice__c;
                    }
                    
                }
                lineItem.APTS_Calculated_Year_1__c=calculatedYear1Price;
                System.debug('CY1 for Renewal Line ='+lineItem.APTS_Calculated_Year_1__c);
            }
            //End
            if(lineItem.Apttus_Config2__LineStatus__c =='New'){
                calculatedYear1Price=lineItem.Apttus_Config2__NetPrice__c;
                lineItem.APTS_Calculated_Year_1__c=lineItem.Apttus_Config2__NetPrice__c;
            }
            
            system.debug('calculatedYear1Price :'+calculatedYear1Price+'###### in 3'+contractTerm);         
            if(contractTerm==1){   
                lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                if(lineItem.APTS_Calculated_Year_2__c!=null || lineItem.APTS_Calculated_Year_3__c!=null || lineItem.APTS_Calculated_Year_4__c!=null || lineItem.APTS_Calculated_Year_5__c!=null){
                    lineItem.APTS_Calculated_Year_2__c=null;
                    lineItem.APTS_Calculated_Year_3__c=null;
                    lineItem.APTS_Calculated_Year_4__c=null;
                    lineItem.APTS_Calculated_Year_5__c=null;
                }
                if(lineItem.APTS_Increase_Yr1_Yr2__c!=null || lineItem.APTS_Increase_Yr2_Yr3__c!=null || lineItem.APTS_Increase_Yr3_Yr4__c!=null || lineItem.APTS_Increase_Yr4_Yr5__c!=null){
                    lineItem.APTS_Increase_Yr1_Yr2__c=null;
                    lineItem.APTS_Increase_Yr2_Yr3__c=null;
                    lineItem.APTS_Increase_Yr3_Yr4__c=null;
                    lineItem.APTS_Increase_Yr4_Yr5__c=null;
                }
            }           
            if(contractTerm==2){
                system.debug('Contract Term as 2, RK --> lineItem.APTS_Yr_2_Amount__c'+lineItem.APTS_Yr_2_Amount__c);
                if(lineItem.APTS_Yr_2_Amount__c!=null){                  
                    lineItem.APTS_Calculated_Year_2__c=lineItem.APTS_Yr_2_Amount__c; 
                    lineItem.APTS_Is_Multi_Tiered_Pricing__c=true;                 
                    dollarValues.add(calculatedYear1Price);
                    dollarValues.add(lineItem.APTS_Yr_2_Amount__c);
                    lineItem.APTS_Calculated_Min_YOY__c=calculateMinYoy(dollarValues);
                    //DOC-12697
                        dollarYear12Values.add(calculatedYear1Price);         
                        dollarYear12Values.add(lineItem.APTS_Yr_2_Amount__c); 
                        lineItem.APTS_Increase_Yr1_Yr2__c=calculatePerInc(dollarYear12Values);    
                    //End
                    system.debug('CT2 RK--> APTS_Calculated_Min_YOY__c = '+lineItem.APTS_Calculated_Min_YOY__c);
                    system.debug('CT2 RK--> APTS_Increase_Yr1_Yr2__c = '+lineItem.APTS_Increase_Yr1_Yr2__c);
                    system.debug('CT2 RK--> APTS_Increase_Yr2_Yr3__c = '+lineItem.APTS_Increase_Yr2_Yr3__c);
                    
                }else if(lineItem.APTS_Yr_2_Amount__c==null){
                    multiYearPrices=getCalculatedMultiYearPrices(contractTerm,yoy2,calculatedYear1Price);
                    if(multiYearPrices!= null && !multiYearPrices.isEmpty()){
                        lineItem.APTS_Calculated_Year_2__c=multiYearPrices[0];
                    }    
                    lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                    lineItem.APTS_Increase_Yr1_Yr2__c=yoy2; //DOC-12697
                    system.debug(' Yr2 Amount is null');
                    system.debug('CT2 RK--> APTS_Increase_Yr1_Yr2__c = '+lineItem.APTS_Increase_Yr1_Yr2__c);
                    system.debug('CT2 RK--> APTS_Increase_Yr2_Yr3__c = '+lineItem.APTS_Increase_Yr2_Yr3__c);
                    
                }
                if(lineItem.APTS_Calculated_Year_3__c!=null || lineItem.APTS_Calculated_Year_4__c!=null || lineItem.APTS_Calculated_Year_5__c!=null){
                    lineItem.APTS_Calculated_Year_3__c=null;
                    lineItem.APTS_Calculated_Year_4__c=null;
                    system.debug('###### in 3');
                    lineItem.APTS_Calculated_Year_5__c=null;
                }    
                if(lineItem.APTS_Increase_Yr2_Yr3__c!=null || lineItem.APTS_Increase_Yr3_Yr4__c!=null || lineItem.APTS_Increase_Yr4_Yr5__c!=null){
                    lineItem.APTS_Increase_Yr2_Yr3__c=null;
                    lineItem.APTS_Increase_Yr3_Yr4__c=null;
                    system.debug('###### in 3');
                    lineItem.APTS_Increase_Yr4_Yr5__c=null;
                }          
            }
            if(contractTerm==3){
                if(lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c!=null){                  
                    lineItem.APTS_Calculated_Year_2__c=lineItem.APTS_Yr_2_Amount__c;
                    lineItem.APTS_Calculated_Year_3__c=lineItem.APTS_Yr_3_Amount__c;  
                    lineItem.APTS_Is_Multi_Tiered_Pricing__c=true;                
                    dollarValues.add(calculatedYear1Price);
                    dollarValues.add(lineItem.APTS_Yr_2_Amount__c);
                    dollarValues.add(lineItem.APTS_Yr_3_Amount__c);
                    //DOC-12697
                        dollarYear12Values.add(calculatedYear1Price);         
                        dollarYear12Values.add(lineItem.APTS_Yr_2_Amount__c); 
                        lineItem.APTS_Increase_Yr1_Yr2__c=calculatePerInc(dollarYear12Values);    
                        dollarYear23Values.add(lineItem.APTS_Yr_2_Amount__c);         
                        dollarYear23Values.add(lineItem.APTS_Yr_3_Amount__c);       
                        lineItem.APTS_Increase_Yr2_Yr3__c=calculatePerInc(dollarYear23Values); 
                    //End
                    system.debug('###### in 3');
                    system.debug('CT3 RK--> APTS_Increase_Yr1_Yr2__c = '+lineItem.APTS_Increase_Yr1_Yr2__c);
                    system.debug('CT3 RK--> APTS_Increase_Yr2_Yr3__c = '+lineItem.APTS_Increase_Yr2_Yr3__c);
                    system.debug('CT3 RK--> APTS_Increase_Yr3_Yr4__c = '+lineItem.APTS_Increase_Yr3_Yr4__c);
                    lineItem.APTS_Calculated_Min_YOY__c=calculateMinYoy(dollarValues);
                    
                }else if(lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null){
                    multiYearPrices=getCalculatedMultiYearPrices(contractTerm,yoy2,calculatedYear1Price);
                    if(multiYearPrices!= null && !multiYearPrices.isEmpty()){
                        lineItem.APTS_Calculated_Year_2__c=multiYearPrices[0];
                        lineItem.APTS_Calculated_Year_3__c=multiYearPrices[1];
                    }  
                    lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                    //DOC-12697
                    lineItem.APTS_Increase_Yr1_Yr2__c=yoy2;
                    lineItem.APTS_Increase_Yr2_Yr3__c=yoy2;
                    system.debug(' Yr2 & Yr3 Amount is null');
                    system.debug('CT3 RK--> APTS_Increase_Yr1_Yr2__c = '+lineItem.APTS_Increase_Yr1_Yr2__c);
                    system.debug('CT3 RK--> APTS_Increase_Yr2_Yr3__c = '+lineItem.APTS_Increase_Yr2_Yr3__c);
                    system.debug('CT3 RK--> APTS_Increase_Yr3_Yr4__c = '+lineItem.APTS_Increase_Yr3_Yr4__c);                    
                    
                }
                if(lineItem.APTS_Calculated_Year_4__c!=null || lineItem.APTS_Calculated_Year_5__c!=null){
                    lineItem.APTS_Calculated_Year_4__c=null;
                    lineItem.APTS_Calculated_Year_5__c=null;
                } 
                if(lineItem.APTS_Increase_Yr3_Yr4__c!=null || lineItem.APTS_Increase_Yr4_Yr5__c!=null){
                    lineItem.APTS_Increase_Yr3_Yr4__c=null;
                    lineItem.APTS_Increase_Yr4_Yr5__c=null;
                }
            }
            if(contractTerm==4){
                if(lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c!=null && lineItem.APTS_Yr_4_Amount__c!=null){                  
                    lineItem.APTS_Calculated_Year_2__c=lineItem.APTS_Yr_2_Amount__c;
                    lineItem.APTS_Calculated_Year_3__c=lineItem.APTS_Yr_3_Amount__c; 
                    lineItem.APTS_Calculated_Year_4__c=lineItem.APTS_Yr_4_Amount__c;   
                    lineItem.APTS_Is_Multi_Tiered_Pricing__c=true;              
                    dollarValues.add(calculatedYear1Price);
                    dollarValues.add(lineItem.APTS_Yr_2_Amount__c);
                    dollarValues.add(lineItem.APTS_Yr_3_Amount__c);
                    dollarValues.add(lineItem.APTS_Yr_4_Amount__c);
                    lineItem.APTS_Calculated_Min_YOY__c=calculateMinYoy(dollarValues);
                    //DOC-12697
                        dollarYear12Values.add(calculatedYear1Price);         
                        dollarYear12Values.add(lineItem.APTS_Yr_2_Amount__c); 
                        lineItem.APTS_Increase_Yr1_Yr2__c=calculatePerInc(dollarYear12Values);    
                        dollarYear23Values.add(lineItem.APTS_Yr_2_Amount__c);         
                        dollarYear23Values.add(lineItem.APTS_Yr_3_Amount__c);       
                        lineItem.APTS_Increase_Yr2_Yr3__c=calculatePerInc(dollarYear23Values);    
                        dollarYear34Values.add(lineItem.APTS_Yr_3_Amount__c);         
                        dollarYear34Values.add(lineItem.APTS_Yr_4_Amount__c);       
                        lineItem.APTS_Increase_Yr3_Yr4__c=calculatePerInc(dollarYear34Values);    
                    //End
                }else if(lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null){
                    multiYearPrices=getCalculatedMultiYearPrices(contractTerm,yoy2,calculatedYear1Price);
                    if(multiYearPrices!= null && !multiYearPrices.isEmpty()){
                        lineItem.APTS_Calculated_Year_2__c=multiYearPrices[0];
                        lineItem.APTS_Calculated_Year_3__c=multiYearPrices[1];
                        lineItem.APTS_Calculated_Year_4__c=multiYearPrices[2];
                    }  
                    lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                    //DOC-12697
                    lineItem.APTS_Increase_Yr1_Yr2__c=yoy2;
                    lineItem.APTS_Increase_Yr2_Yr3__c=yoy2;
                    lineItem.APTS_Increase_Yr3_Yr4__c=yoy2;
                    
                }
                if(lineItem.APTS_Calculated_Year_5__c!=null){
                    lineItem.APTS_Calculated_Year_5__c=null;
                }
                if(lineItem.APTS_Increase_Yr4_Yr5__c!=null){
                    lineItem.APTS_Increase_Yr4_Yr5__c=null;
                }                
            }
            if(contractTerm==5 && lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c!=null && lineItem.APTS_Yr_4_Amount__c!=null && lineItem.APTS_Yr_5_Amount__c!=null){                  
                lineItem.APTS_Calculated_Year_2__c=lineItem.APTS_Yr_2_Amount__c;
                lineItem.APTS_Calculated_Year_3__c=lineItem.APTS_Yr_3_Amount__c; 
                lineItem.APTS_Calculated_Year_4__c=lineItem.APTS_Yr_4_Amount__c; 
                lineItem.APTS_Calculated_Year_5__c=lineItem.APTS_Yr_5_Amount__c;  
                lineItem.APTS_Is_Multi_Tiered_Pricing__c=true;              
                dollarValues.add(calculatedYear1Price);
                dollarValues.add(lineItem.APTS_Yr_2_Amount__c);
                dollarValues.add(lineItem.APTS_Yr_3_Amount__c);
                dollarValues.add(lineItem.APTS_Yr_4_Amount__c);
                dollarValues.add(lineItem.APTS_Yr_5_Amount__c);
                lineItem.APTS_Calculated_Min_YOY__c=calculateMinYoy(dollarValues);
                //DOC-12697
                    dollarYear12Values.add(calculatedYear1Price);         
                    dollarYear12Values.add(lineItem.APTS_Yr_2_Amount__c); 
                    lineItem.APTS_Increase_Yr1_Yr2__c=calculatePerInc(dollarYear12Values);    
                    dollarYear23Values.add(lineItem.APTS_Yr_2_Amount__c);         
                    dollarYear23Values.add(lineItem.APTS_Yr_3_Amount__c);       
                    lineItem.APTS_Increase_Yr2_Yr3__c=calculatePerInc(dollarYear23Values);    
                    dollarYear34Values.add(lineItem.APTS_Yr_3_Amount__c);         
                    dollarYear34Values.add(lineItem.APTS_Yr_4_Amount__c);       
                    lineItem.APTS_Increase_Yr3_Yr4__c=calculatePerInc(dollarYear34Values);    
                    dollarYear45Values.add(lineItem.APTS_Yr_4_Amount__c);         
                    dollarYear45Values.add(lineItem.APTS_Yr_5_Amount__c);       
                    lineItem.APTS_Increase_Yr4_Yr5__c=calculatePerInc(dollarYear45Values); 
                //End
                
            }else if(contractTerm==5 && (lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null || lineItem.APTS_Yr_5_Amount__c==null)){
                multiYearPrices=getCalculatedMultiYearPrices(contractTerm,yoy2,calculatedYear1Price);
                if(multiYearPrices!= null && !multiYearPrices.isEmpty()){
                    lineItem.APTS_Calculated_Year_2__c=multiYearPrices[0];
                    lineItem.APTS_Calculated_Year_3__c=multiYearPrices[1];
                    lineItem.APTS_Calculated_Year_4__c=multiYearPrices[2];
                    lineItem.APTS_Calculated_Year_5__c=multiYearPrices[3];
                }  
                lineItem.APTS_Calculated_Min_YOY__c=yoy2;
                //DOC-12697
                lineItem.APTS_Increase_Yr1_Yr2__c=yoy2;
                lineItem.APTS_Increase_Yr2_Yr3__c=yoy2;
                lineItem.APTS_Increase_Yr3_Yr4__c=yoy2;
                lineItem.APTS_Increase_Yr4_Yr5__c=yoy2;
                
            }
        }

        if(!proflexseconLineItems.isEmpty()){
            populateBlankValues(proflexseconLineItems);
        }
        
    }
    //Populated secondary materials with Zero
    public static void populateBlankValues(List<Apttus_Config2__LineItem__c> lineItemsList){
    for(Apttus_Config2__LineItem__c lineItem:lineItemsList){
        lineItem.APTS_Calculated_Year_1__c=0.0;
        lineItem.APTS_Calculated_Year_2__c=0.0;
        lineItem.APTS_Calculated_Year_3__c=0.0;
        lineItem.APTS_Calculated_Year_4__c=0.0;
        lineItem.APTS_Calculated_Year_5__c=0.0;
        lineItem.APTS_Increase_Yr1_Yr2__c=0.0;
        lineItem.APTS_Increase_Yr2_Yr3__c=0.0;
        lineItem.APTS_Increase_Yr3_Yr4__c=0.0;
        lineItem.APTS_Increase_Yr4_Yr5__c=0.0;
        System.debug('Blank Values'+lineItem);
    }
    }
    public static Decimal calculateMinYoy(List<Decimal> dollarValuesList){
        
        List<Integer> yoyList=new List<Integer>();
        List<Decimal> yoyListDecimal =new List<Decimal>();
        System.debug('Dollar values:'+dollarValuesList);
        
        // if(dollarValuesList.contains(0) || dollarValuesList.contains(0.0) || dollarValuesList.contains(0.00))
        // return 0;
        for(Integer i=0;i<dollarValuesList.size()-1;i++){
            if((i==0 && dollarValuesList[0]==0.00000 && dollarValuesList[i+1]!=0.00)||(dollarValuesList[i]==0.00 && dollarValuesList[i+1]!=0.00 ))
            {
                yoyListDecimal.add(100);
                system.debug('###### '+yoyListDecimal);
            }
            else if((i==0 && dollarValuesList[0]==0.00000 && dollarValuesList[i+1]==0.00) ||(dollarValuesList[i]==0.00 && dollarValuesList[i+1]==0.00 )){
                yoyListDecimal.add(0);
                system.debug('###### '+yoyListDecimal);
            }
            else{
                yoyListDecimal.add((((dollarValuesList.get(i+1)-dollarValuesList.get(i))*100)/dollarValuesList.get(i)));
                system.debug('###### '+yoyListDecimal);
                system.debug('###### '+(((dollarValuesList.get(i+1)-dollarValuesList.get(i))*100)/dollarValuesList.get(i)));
            }
        }
        yoyListDecimal.sort();
        System.debug('yoyList:'+yoyListDecimal);
        return yoyListDecimal[0];
        //return null;
        
    }
    //Added newly
    public static Decimal calculatePerInc(List<Decimal> dollarYearValuesList){
        
        List<Integer> yoyList=new List<Integer>();  
        List<Decimal> yearIncListDecimal =new List<Decimal>();
        System.debug('Dollar Year values:'+dollarYearValuesList);
        
        for(Integer i=0;i<dollarYearValuesList.size()-1;i++){   
            if((i==0 && dollarYearValuesList[0]==0.00000 && dollarYearValuesList[i+1]!=0.00)||(dollarYearValuesList[i]==0.00 && dollarYearValuesList[i+1]!=0.00 ))
            {
                yearIncListDecimal.add(100);
                system.debug('###### '+yearIncListDecimal);
            }
            else if((i==0 && dollarYearValuesList[0]==0.00000 && dollarYearValuesList[i+1]==0.00) ||(dollarYearValuesList[i]==0.00 && dollarYearValuesList[i+1]==0.00 )){
                yearIncListDecimal.add(0);
                system.debug('###### '+yearIncListDecimal);
            }
            else{
                yearIncListDecimal.add((((dollarYearValuesList.get(i+1)-dollarYearValuesList.get(i))/dollarYearValuesList.get(i))*100).setScale(5));
                system.debug('% Increase Value = '+yearIncListDecimal);
                system.debug('New Value = '+(((dollarYearValuesList.get(i+1)-dollarYearValuesList.get(i))*100)/dollarYearValuesList.get(i)));
            }
        }
        yearIncListDecimal.sort();
        System.debug('YearList:'+yearIncListDecimal);
        return yearIncListDecimal[0];
        
    }
    //End
    public static List<Decimal> getCalculatedMultiYearPrices(Integer contractTerm,Integer yoy2,Decimal calculatedYear1Price){
        
        List<Decimal> priceList=new List<Decimal>();
        for(Integer i=0;i<contractTerm-1;i++){      
            if(priceList.isEmpty()){
                if(calculatedYear1Price!=null) {           
                    priceList.add((((calculatedYear1Price*yoy2)/100)+calculatedYear1Price).setScale(2)); 
                }         
            }else{
                priceList.add((((priceList.get(i-1)*yoy2)/100)+priceList.get(i-1)).setScale(2));
            }
        }
        return priceList;
    }
    
    //GLP-820
    @testvisible
    private static void checkPrintProviewAPPApproval(Apttus_Config2__LineItem__c lineItem, Map<String,Boolean> printProviewFlagMap){
        if(lineItem.APTS_Proposal_Business_Unit__c == 'SCS'){

            if (lineItem.apttus_config2__linestatus__c == 'Cancelled'
            && lineItem.Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c != 'WCMP'
            && lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__ChargeType__c == 'Subscription Fee'
            && lineItem.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__PriceType__c == 'Recurring'
            && (lineItem.APTS_Cat_L2__c!=null && (lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family)  
            || lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)))){
                printProviewFlagMap.put('printAPPCancel',TRUE);
            }

        }
    }
    
    //GLP-820
    @testvisible
    private static Boolean processPrintProviewFlagMap(Map<String,Boolean> printProviewFlagMap){
        Boolean printAPPCancel = printProviewFlagMap.get('printAPPCancel');
        //Boolean printBundleAdd = printProviewFlagMap.get('printBundleAdd');
        Boolean flag = FALSE;
        if(printAPPCancel == TRUE){
            flag = TRUE;
        }
        return flag;
    }
    //Start: GLP-14,747, 594, 594
    @testvisible

    private static List<Apttus_Config2__PriceListItem__c> retrieveGPPPLI(Set<String> setProuctCodeGPP) {
        List<Apttus_Config2__PriceListItem__c> lstPLIGPP;
        if (setProuctCodeGPP != null && setProuctCodeGPP.size() > 0) {
            lstPLIGPP = [Select Id, Apttus_Config2__ProductId__r.Productcode, Apttus_Config2__ListPrice__c, Apttus_Config2__ChargeType__c, Apttus_Config2__PriceType__c, Apttus_Config2__PriceMethod__c from Apttus_Config2__PriceListItem__c 
                        where Apttus_Config2__ProductId__r.Productcode IN: setProuctCodeGPP
                        and Apttus_Config2__ChargeType__c = 'Standard Price' and Apttus_Config2__PriceType__c = 'One Time'];
            
        }
        return lstPLIGPP;
    }
    
    @testvisible
    private static List<Apttus_Config2__PriceListItem__c> retrieveNonGPPPLI(Set<String> setProuctCodeNonGPP) {
        List<Apttus_Config2__PriceListItem__c> lstPLINonGPP;
        if (setProuctCodeNonGPP != null && setProuctCodeNonGPP.size() > 0) {
             lstPLINonGPP= [Select Id, Apttus_Config2__ProductId__r.Productcode, Apttus_Config2__ListPrice__c, Apttus_Config2__ChargeType__c, Apttus_Config2__PriceType__c, Apttus_Config2__PriceMethod__c    from Apttus_Config2__PriceListItem__c 
                        where Apttus_Config2__ProductId__r.Productcode IN: setProuctCodeNonGPP 
                        and Apttus_Config2__ChargeType__c = 'Subscription Fee' and Apttus_Config2__PriceType__c = 'One Time'];
              
        }
        return lstPLINonGPP;
    }
    
    @testvisible
    private static List<Apttus_Config2__PriceListItem__c> preparePLI(List<Apttus_Config2__PriceListItem__c> lstPLINonGPP, List<Apttus_Config2__PriceListItem__c> lstPLIGPP ) {
        List<Apttus_Config2__PriceListItem__c> lstPLI = new List<Apttus_Config2__PriceListItem__c>();
        if (lstPLINonGPP != null && lstPLINonGPP.size() > 0) {
            for (Apttus_Config2__PriceListItem__c objPLINonGPP : lstPLINonGPP) {
                lstPLI.addAll(lstPLINonGPP);
            }
        }
        if (lstPLIGPP != null && lstPLIGPP.size() > 0) {
            for (Apttus_Config2__PriceListItem__c objPLIGPP : lstPLIGPP) {
                lstPLI.addAll(lstPLIGPP);
            }
        }
        return lstPLI;
    }
    
    @testvisible
    private static Map<String, Decimal> retrieveLIFlatPrice(List<Apttus_Config2__PriceListItem__c> lstPLI,  Map<String, String> mapDerivedFlatPrice) {
        Map<String, String> mapPLI = new Map<String, String>();
        Map<String, Decimal> mapFlatPrice = new Map<String, Decimal>();
         system.debug('############## mapDerivedFlatPrice'+mapDerivedFlatPrice);
        if (lstPLI != null && lstPLI.size() > 0) {
            for (Apttus_Config2__PriceListItem__c objPLI : lstPLI) {
                if (mapDerivedFlatPrice != null && mapDerivedFlatPrice.size() > 0) {
                    for (String objProduct : mapDerivedFlatPrice.keyset()) {
                        if (objPLI.Apttus_Config2__ProductId__r.ProductCode == objProduct && mapDerivedFlatPrice.get(objPLI.Apttus_Config2__ProductId__r.ProductCode) != null && mapDerivedFlatPrice.get(objPLI.Apttus_Config2__ProductId__r.ProductCode) == 'Flat Price') {
                            mapPLI.put(objPLI.Id, objPLI.Apttus_Config2__ProductId__r.Productcode);
                        }
                    }
                }
            }
            system.debug('############## mapPLI'+mapPLI);
            if (mapPLI != null && mapPLI.size() > 0) {
                List<Apttus_Config2__PriceMatrix__c> lstPriceMatrixs = [select id,  Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.Productcode,
                                                                        (select id, Apttus_Config2__AdjustmentAmount__c from Apttus_Config2__MatrixEntries__r order by Apttus_Config2__Sequence__c limit 1) 
                                                                        from Apttus_Config2__PriceMatrix__c  where Apttus_Config2__PriceListItemId__c IN: mapPLI.keyset()];
                if (lstPriceMatrixs != null && lstPriceMatrixs.size() > 0) {
                    for (Apttus_Config2__PriceMatrix__c objMatrix : lstPriceMatrixs) {
                        Apttus_Config2__PriceMatrixEntry__c objPME = objMatrix.Apttus_Config2__MatrixEntries__r[0];
                        mapFlatPrice.put(objMatrix.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.Productcode, objPME.Apttus_Config2__AdjustmentAmount__c);
                    }
                } 
            }    
        }
        system.debug('############## mapFlatPrice'+mapFlatPrice);
        return mapFlatPrice;                                               
    }
    
    
    
    @testvisible
    private static List<Apttus_Config2__PriceListItem__c> prepareNonFPPLI(List<Apttus_Config2__PriceListItem__c> lstPLIAll, Map<String, String> mapFlatPrice) {
         List<Apttus_Config2__PriceListItem__c> lstPLI = new List<Apttus_Config2__PriceListItem__c>();
        if (lstPLIAll != null && lstPLIAll.size() > 0) {
            for (Apttus_Config2__PriceListItem__c objPLI : lstPLIAll) {
                if (mapFlatPrice != null && mapFlatPrice.size() > 0) {
                    for (String objProduct : mapFlatPrice.keyset()) {
                        if (objPLI.Apttus_Config2__ProductId__r.ProductCode == objProduct && mapFlatPrice.get(objPLI.Apttus_Config2__ProductId__r.ProductCode) != null && mapFlatPrice.get(objPLI.Apttus_Config2__ProductId__r.ProductCode) != 'Flat Price') {
                            lstPLI.add(objPLI);
                        }
                    }
                }
            }
        }
        system.debug('#### lstPLI'+lstPLI);
        return lstPLI;
    }
    
    
    
    @testvisible
    private static map<String,Decimal> prepareMapFromList(List<Apttus_Config2__PriceListItem__c> lstPLINonFP, Map<String, Decimal> mapFlatPrice) {
        Map<String, Decimal> mapProductToListPrice = new Map<String, Decimal>();
        system.debug('#### lstPLINonFP'+lstPLINonFP+'#### mapFlatPrice'+mapFlatPrice);
        if (lstPLINonFP != null && lstPLINonFP.size() > 0) {
            for (Apttus_Config2__PriceListItem__c objPLI : lstPLINonFP) { 
                mapProductToListPrice.put(objPLI.Apttus_Config2__ProductId__r.Productcode, objPLI.Apttus_Config2__ListPrice__c);
            }
        }
        if (mapFlatPrice != null && mapFlatPrice.size() > 0) {
            mapProductToListPrice.putAll(mapFlatPrice);
        }
        system.debug('#### mapProductToListPrice'+mapProductToListPrice);
        return mapProductToListPrice;
    }
    
    
    @testvisible
    private static Boolean checkGPPProduct(Apttus_Config2__LineItem__c lineItem) {
        Boolean blnIsGPP = false;
        if (lineItem.APTS_Media_High_Level_Code__c == '21' && lineItem.APTS_Media_Lower_Level_Code__c== 'F4'
                && (lineItem.APTS_Item_Category_Group__c == 'ZPR2' || lineItem.APTS_Item_Category_Group__c == 'ZVSU')) {
             blnIsGPP = true;   
        }
        return blnIsGPP;
    }
    
    @testvisible
    private static Decimal checkIncrementalGrowthGPPNew(Apttus_Config2__LineItem__c lineItem, Decimal totalNewItemsGLP) {
        if (lineItem.apttus_config2__linestatus__c == 'Renewed' || lineItem.apttus_config2__linestatus__c == 'New'  
        && (lineItem.APTS_Cat_L2__c!=null && (lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family)  
            || lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)) && lineItem.Apttus_Config2__NetPrice__c != null && lineItem.Apttus_Config2__NetPrice__c > 0) 
            && lineItem.APTS_Program_ID__c != 'WCMP') {
                system.debug('APTS_Print_Purchase_Options__c'+lineItem.APTS_Print_Purchase_Options__c);
                system.debug('APTS_Purchase_Options__c'+lineItem.APTS_Purchase_Options__c);
                system.debug('Purchase_Option_Bundle_Print__c'+lineItem.Purchase_Option_Bundle_Print__c);
                if ((lineItem.APTS_Print_Purchase_Options__c!= null && lineItem.APTS_Print_Purchase_Options__c.contains('APP')
                && !lineItem.APTS_Print_Purchase_Options__c.contains('Fill-Up'))
                || (lineItem.APTS_Purchase_Options__c != null && lineItem.APTS_Purchase_Options__c.contains('APP'))
                || (lineItem.Purchase_Option_Bundle_Print__c != null && lineItem.Purchase_Option_Bundle_Print__c.contains('APP'))
                || (lineItem.Apttus_Config2__ChargeType__c == 'Subscrption Fee' 
                    && lineItem.Apttus_Config2__PriceType__c == 'Recurring')) {
                  
                    system.debug('################## lineItem.Apttus_Config2__NetPrice__c'+lineItem.Apttus_Config2__NetPrice__c);
                    Decimal netPrice = lineItem.Apttus_Config2__NetPrice__c * 12;
                    totalNewItemsGLP += netPrice;
                }  else  if (lineItem.APTS_Print_Purchase_Options__c!= null && lineItem.APTS_Print_Purchase_Options__c.contains('Fill-Up')
                && lineItem.Apttus_Config2__NetPrice__c != null) {
                    totalNewItemsGLP += checkIncrementalGrowthGPPNewForFillUp(lineItem, lineItem.APTS_Print_Purchase_Options__c);
                } else if ((lineItem.APTS_Print_Purchase_Options__c == null || lineItem.APTS_Purchase_Options__c == null || lineItem.Purchase_Option_Bundle_Print__c == null) && lineItem.Apttus_Config2__NetPrice__c != null){
                    totalNewItemsGLP += lineItem.Apttus_Config2__NetPrice__c;
                }
         }
         system.debug('#### totalNewItemsGLP'+totalNewItemsGLP);

         return totalNewItemsGLP;
    }
    
    @testvisible

    private static Decimal checkIncrementalGrowthGPPNewForFillUp(Apttus_Config2__LineItem__c lineItem, String printPO) {
        Decimal totalNewItemsGLP = 0;
        if (printPO == 'Fill-Up' && lineItem.Apttus_Config2__LineType__c == 'Product/Service' && lineItem.Apttus_Config2__NetPrice__c > 0) {
            totalNewItemsGLP += lineItem.Apttus_Config2__NetPrice__c;
        } else if (printPO == 'Fill-Up & Enter Sub APP' && lineItem.Apttus_Config2__LineType__c == 'Product/Service' && lineItem.Apttus_Config2__NetPrice__c > 0) {
            totalNewItemsGLP += lineItem.Apttus_Config2__NetPrice__c * 12;
        } else if (printPO == 'Fill-Up & Enter Sub'  && lineItem.Apttus_Config2__LineType__c == 'Option' && lineItem.Apttus_Config2__NetPrice__c > 0) {
            totalNewItemsGLP += lineItem.Apttus_Config2__NetPrice__c;
        } 

        system.debug('########### totalNewItemsGLP------------->'+totalNewItemsGLP);
        return totalNewItemsGLP;
    }
    
    @testvisible
    private static Decimal checkIncrementalGrowthGPPCancelled(Apttus_Config2__LineItem__c objLI, Decimal totalCancelledItemsGLP, Map<String, Decimal> mapProductToListPrice) {
        Set<String> setDealType = new Set<String>{'WCMP'};
        if (mapProductToListPrice != null && mapProductToListPrice.size() > 0
            && mapProductToListPrice.containsKey(objLI.Apttus_Config2__ProductId__r.ProductCode) 
            && mapProductToListPrice.get(objLI.Apttus_Config2__ProductId__r.ProductCode) != null
            && objLI.Apttus_Config2__LineStatus__c == 'Cancelled'
            && !setDealType.contains(objLI.Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c)) {

            if (objLI.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__PriceMethod__c == 'Per Unit') {
                Decimal cancelAmount = mapProductToListPrice.get(objLI.Apttus_Config2__ProductId__r.Productcode) * objLI.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__Quantity__c;
                totalCancelledItemsGLP += cancelAmount;
            } else {
                totalCancelledItemsGLP += mapProductToListPrice.get(objLI.Apttus_Config2__ProductId__r.Productcode);
            }
            system.debug('#### in else');
        }
        system.debug('###### totalCancelledItemsGLP '+totalCancelledItemsGLP );
        system.debug('#### mapProductToListPrice'+mapProductToListPrice);
        return totalCancelledItemsGLP;
    }
    
    @testvisible
    private static Integer countNewLI(Apttus_Config2__LineItem__c lineItem, Integer count) {
        if (lineItem.apttus_config2__linestatus__c == 'Renewed' || lineItem.apttus_config2__linestatus__c == 'New'
        && (lineItem.APTS_Cat_L2__c!=null && (lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Print_Product_Family) 
            || lineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_Proview_Product_Family)))) {
            count += count+1;
         }
         return count;
    }
     //Added by Poonam Garg products exclusion from Large Law Approval segment. DOC 12321
    public static void getApprovalExclusionCriteria(Set<String> llawcodes){
    List<Approvals_Exclusion_Criteria__mdt> excludeLargeLaw= new List<Approvals_Exclusion_Criteria__mdt>();
    if(Schema.sObjectType.Approvals_Exclusion_Criteria__mdt.isAccessible() && Schema.sObjectType.Approvals_Exclusion_Criteria__mdt.isQueryable()){
        excludeLargeLaw=[Select MasterLabel,APTS_L2_L3_and_L5_codes__c  from Approvals_Exclusion_Criteria__mdt];}
    if(!excludeLargeLaw.isEmpty()){
    for(Approvals_Exclusion_Criteria__mdt var : excludeLargeLaw){
               if(var.masterlabel.containsIgnoreCase('Large Law')){     
                       if(!String.isEmpty(var.APTS_L2_L3_and_L5_codes__c)){
                           llawcodes.add(var.APTS_L2_L3_and_L5_codes__c);
                       } 
                                    
               }
    }
    }
    System.debug('llawcodes+++'+llawcodes);
    }
    //Added by Poonam Garg products exclusion from Large Law Approval segment. DOC 12321
    private static Boolean checkExclusion(Apttus_Config2__LineItem__c lineItem,Set<String> llawcodes){
                        Boolean flag=false;
                        if(llawcodes.contains(lineItem.APTS_Cat_L2__c) ||
                        llawcodes.contains(lineItem.APTS_Cat_L3__c) ||
                        llawcodes.contains(lineItem.APTS_Cat_L5__c)){
                        flag=true;
                        }
                        return flag;
    }   


    
    //End GLP-14,747, 594, 594
}