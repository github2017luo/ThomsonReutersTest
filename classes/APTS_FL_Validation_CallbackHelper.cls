/**
 * @description 
 */
public without sharing class APTS_FL_Validation_CallbackHelper {
  
    /**
     * @description
     * @param cart
     * @return  
     */
    public Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) {
        
        Apttus_Config2__ProductConfiguration__c Productconfig = New Apttus_Config2__ProductConfiguration__c();
        if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()){
            return null;
        }
        Productconfig =[Select ID,Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c,APTS_SSD_Sold_To__c from Apttus_Config2__ProductConfiguration__c where ID =:cart.getConfigSO().Id];
        if(Productconfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c <> null && Productconfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c !='FindLaw'){
            return null;
        }
        Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true);
        if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()){
            return null;
        }        
        List<Apttus_Config2__LineItem__c> lineItems = [SELECT ApTS_Year_2_3_Price__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__EndDate__c,Apttus_Config2__LineNumber__c,APTS_Product_Name__c,APTS_Product_Detail__c,Apttus_Config2__AssetLineItemId__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Description,APTS_Approval_Segment__c,APTS_Proposal_Business_Unit__c,
                                                                Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, APTS_Proposal_Group__c, APTS_Group__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.APTS_Upgrade_Downgrade_Eligible__c,Apttus_Config2__LineStatus__c,
                                                                Apttus_Config2__LineSequence__c,APTS_Bridge__c, APTS_New_Bridge_Discount__c, APTS_Contract_Term__c, Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c,Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c,
                                                                Apttus_Config2__ProductId__r.APTS_Corporate_Select__c, Apttus_Config2__ProductId__r.Name,APTS_Combination_Key__c,Apttus_Config2__ProductId__r.APTS_Attrbased_config__c,
                                                                Apttus_Config2__AttributeValueId__r.APTS_Total_Number_of_Points__c, Apttus_Config2__ChargeType__c,APTS_Combination_Key__r.APTS_Configuration_Description__c,APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name,
                                                                APTS_Media_High_Level_Code__c, APTS_Media_Lower_Level_Code__c, APTS_Keep_Terms__c, Apttus_Config2__PriceType__c, 
                                                                Apttus_Config2__Quantity__c, Apttus_Config2__LineType__c, Apttus_Config2__IsPrimaryLine__c, Apttus_Config2__ProductId__r.Family,APTS_Deal_Type__c,APTS_Deal_Number__c, APTS_Subscription_Number__c,APTS_Is_Special_Offer_Lapsed__c,APTS_Group_Primary_Material_Name__c
                                                                FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :cart.getConfigSO().Id];
        system.debug(LoggingLevel.WARN,'checkbox--'+lineItems[0].Apttus_Config2__ProductId__r.APTS_Upgrade_Downgrade_Eligible__c);
        //Map<String, APTS_Product_Rules__c> productRuleMap = APTS_Product_Rules__c.getall(); //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        Set<ID> proIDSet = new Set<ID>();
        //Set<ID> purchasedProIDSet = new Set<ID>(); //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        Set<ID> proWithStatusCancelledIDSet = new Set<ID>();
        Decimal assetliquan; 
        Decimal lineQan;
        String prodName; 
        String assetNo;
        String prodCode;
        Boolean maxProd = false;
        Boolean upgradeDowngradeEligible=false;
        String segment;
        //Boolean maxQuantity = false; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        set<string> maxQuanmaterial = new set<string>();        
        //Map<String, APTS_Product_Rules__c> materialToProductRuleMap = new Map<String, APTS_Product_Rules__c>(); //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Map<ID, Apttus_Config2__AssetLineItem__c> proIdToAssetLineMap = new Map<ID, Apttus_Config2__AssetLineItem__c>(); //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        Map<String,String> mfirmSite = new Map<String,String>();
        Decimal dFirmSiteQuanity=0;
        Map<String,String> mPPC = new Map<String,String>();
        Decimal dPPCQanityEnglish =0;
        Decimal dPPCQanitySpanish =0;
        Boolean isRenewed = false;
        Map<String, FirmSiteVSPPC__c> FirmSitePPCCodes = FirmSiteVSPPC__c.getAll();
        Map<String,Apttus_Config2__AssetLineItem__c> mAssetswithProductCode = New Map<String,Apttus_Config2__AssetLineItem__c>();
        Map<ID,Apttus_Config2__AssetLineItem__c> mAssets = New Map<ID,Apttus_Config2__AssetLineItem__c>();
        Decimal FNDLWPOSTPLUSFS =0;
        Map<String,String> mFindLwPostPluse = New Map<String,String>();
        Map<String,String> productCodesMap=new Map<String,String>();
        Map<String,Decimal> mSpotLight = New Map<String,Decimal>();
        Map<String,Decimal> mTopSpot = New Map<String,Decimal>();
        Map<String,Decimal> mSpotLighthub = New Map<String,Decimal>();
        Map<String,Decimal> mRefineSpotLighthub = New Map<String,Decimal>();
        Map<String,Decimal> mDirSpotLighthub = New Map<String,Decimal>();
        Map<String,Decimal> mCountryTopSpot = New Map<String,Decimal>();
        Map<String,Decimal> mRefinedTopStop = New Map<String,Decimal>();
        Map<String,Decimal> mTopSpotsub = New Map<String,Decimal>();
        Map<String,Decimal> mRoatingTopSpot = New Map<String,Decimal>();
        Map<String,Decimal> mLDirSpotLight = New Map<String,Decimal>();
        Map<String,Decimal> mLDirTopSpot = New Map<String,Decimal>();
        Map<String,Decimal> mSuperSpotLight = New Map<String,Decimal>();
        Map<String,Decimal> mNetworkskylight = New Map<String,Decimal>();
        Map<String,Decimal> mSuperLawTopSpots = New Map<String,Decimal>();
        //Decimal lang3Quanity=0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal lang4Quanity=0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal fsarchive=0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        Map<String,String> mProductcodes6 = New Map<String,String>();
        //decimal SocialPromoton =0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        Boolean HasAssetBundle12=false;
        Boolean HasAssetBundle45=false;
        Map<String,Integer> mDuplicateProducts = New Map<String,Integer>();
        //Decimal qunaity1 =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        Map<String,Apttus_Config2__LineItem__c> mLineQuanity = New Map<String,Apttus_Config2__LineItem__c>();
        
        Map<String,Decimal> mAssetQuanity = New Map<String,Decimal>();
        Map<String,String> mFirmSiteProducts = New Map<String,String>();
        //Decimal BPIProductsCount =0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        Decimal FirmProductsCount=0;
        set<ID> ProductAttributeID = New Set<ID>();
        Map<ID,Apttus_Config2__ProductAttributeValue__c> mProductAtribute = New Map<ID,Apttus_Config2__ProductAttributeValue__c>();
        Map<String,String> mPPCProductsIDs = New Map<String,String>();
        mPPCProductsIDs.put('30010890','30010890');
        Boolean hasNewPPC=false;
        Boolean hasExsistingPPC = false;
        Boolean hasNewPPC1=false;
        Boolean hasExsistingPPC1 = false;
        //Decimal FNDLWBLOGPLATFORMQuniaty =0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWBLOGPLATFORMQuniatyIndividual =0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWANIMATIONESSENTIAL =0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWANIMATIONESSENTIALIndividual =0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWANIMATIONPREMIUM =0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWANIMATIONPREMIUMIndividual =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWFIRMSITEMOBILEESSENTIAL =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWFIRMSITEMOBILEESSENTIALIndividual =0; //Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWMOBILEESSENTIAL =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWMOBILEESSENTIALIndividual =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWBLOGPLATFORMQuniatyTwice =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWANIMATIONESSENTIALTwice =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWANIMATIONPREMIUMTwice =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWFIRMSITEMOBILEESSENTIALTwice =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        //Decimal FNDLWMOBILEESSENTIALTwice =0;//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)
        Map<String, Boolean> aliProductCodeMap = new Map<String, Boolean>();
        Decimal dFirmSiteCancelQuanity =0;//SOC-9684 starts
        Decimal dPPCCancelQanityEnglish =0;
        Decimal dPPCCancelQanitySpanish =0; 
        Decimal dFirmsiteTotalQanity =0;
        Decimal dPPCTtotalQanityEnglish =0;
        Decimal dPPCTotalQanitySpanish =0;//SOC-9684 ends
        Decimal SUPERLAWYERSASKANSWERPAGE=0; //SOC-8028
        Decimal fLABOGADOPREMIUM=0; //DOC 9870
        Decimal quanABOGADOPREMIUM = 0; // DOC 9870
        
        for(FirmSiteVSPPC__c fsp : FirmSitePPCCodes.values()){
            if(fsp.Product_Family__c =='Firmsite'){
              mfirmSite.put(fsp.Name,fsp.Name);  
            }else if(fsp.Product_Family__c =='PPC'){
                mPPC.put(fsp.Name,fsp.Name); 
            }  
        }
        
        for(Product_codes__c  pcode: Product_codes__c.getAll().values()){
            productCodesMap.put(pcode.Name,pcode.name);
        }
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
            return null;
        } 
         List<Apttus_Config2__AssetLineItem__c> assetLineItemList = [SELECT ID,APTS_Combination_Key__c, APTS_PPC_Spend_Type__c, APTS_PPC_Website_Type__c,Apttus_Config2__LineType__c, Apttus_Config2__ProductId__c,Apttus_Config2__Quantity__c,Apttus_Config2__ProductId__r.productcode, Apttus_Config2__AssetStatus__c  
        ,Apttus_Config2__AttributeValueId__c, Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c,Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c,Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c, APTS_Combination_Key__r.APTS_Attribute_Value0__c,APTS_Combination_Key__r.APTS_Attribute_Value1__c ,APTS_Combination_Key__r.APTS_Attribute_Value2__c,APTS_Combination_Key__r.APTS_Attribute_Value3__c  
        ,APTS_Combination_Key__r.APTS_Configuration_Description__c,APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name FROM Apttus_Config2__AssetLineItem__c                                                                             
                                                                            WHERE APTS_SSD_Sold_To__c = :cart.getConfigSO().APTS_SSD_Sold_To__c And APTS_SSD_Sold_To__c <> null
                                                                            AND Apttus_Config2__ProductId__c NOT IN : proWithStatusCancelledIDSet  // SOC-3838 Changed by Chirag 5/23/17
                                                                            AND Apttus_Config2__IsInactive__c = false
                                                                            AND Apttus_Config2__AssetStatus__c != 'Cancelled'];  
        //added by Gowthami to Debug 
        system.debug(LoggingLevel.WARN,'AssetLineItem'+assetLineItemList);
        
        
        //SOC-4448 Start
        //SOC-7431,SOC-4590,SOC-4523 Start
    /*
    * Below code added by Deepthi Shirangala on 4/2/18.
    * Requirement is to Implement the Max Quantity rules associated to PA/GEO (Directory) model products.
    * Requirement is to Implement the mutual exclusive rule for PA/GEO (Directory) Products.
    */
        
        if(PA_GEO__c.getInstance('41378928') <> null){
            for(String s :PA_GEO__c.getInstance('41378928').Product_Code__c.split(',') ){
                mFindLwPostPluse.put(s,s);
            } 
        }
                
        
        for(Product_Codes_Set6__c  p6: Product_Codes_Set6__c.getAll().values()){
            mProductcodes6.put(p6.Name,p6.name);
        }
        
        
        //Asset calc
        for(Apttus_Config2__AssetLineItem__c Ass :assetLineItemList ){            
            if(Ass.Apttus_Config2__AssetStatus__c  == 'Activated'){
                mAssetswithProductCode.put(Ass.Apttus_Config2__ProductId__r.productcode,Ass);
                mAssets.put(Ass.id,Ass);
            }
            if(mFindLwPostPluse.containsKey(Ass.Apttus_Config2__ProductId__r.productcode)){
                FNDLWPOSTPLUSFS = FNDLWPOSTPLUSFS+Ass.Apttus_Config2__Quantity__c;
            }
           
            if(Ass.Apttus_Config2__ProductId__r.productcode =='42027607' && Ass.APTS_Combination_Key__c  !=null){
                mSpotLight = mAssetProductDetail(Ass,mSpotLight);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='42027608' && Ass.APTS_Combination_Key__c  !=null){
                mTopSpot = mAssetProductDetail(Ass,mTopSpot);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='41680342' && Ass.APTS_Combination_Key__c  !=null){
                mSpotLighthub = mAssetProductDetail(Ass,mSpotLighthub);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='40987608' && Ass.APTS_Combination_Key__c  !=null){
                mRefineSpotLighthub = mAssetProductDetail(Ass,mRefineSpotLighthub);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='37005004' && Ass.APTS_Combination_Key__c  !=null){
                mDirSpotLighthub = mAssetProductDetail(Ass,mDirSpotLighthub);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='37005072' && Ass.APTS_Combination_Key__c  !=null){
                mCountryTopSpot = mAssetProductDetail(Ass,mCountryTopSpot);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='40987607' && Ass.APTS_Combination_Key__c  !=null){
                mRefinedTopStop = mAssetProductDetail(Ass,mRefinedTopStop);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='37005005' && Ass.APTS_Combination_Key__c  !=null){
                mTopSpotsub = mAssetProductDetail(Ass,mTopSpotsub);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='42088301' && Ass.APTS_Combination_Key__c  !=null){
                mRoatingTopSpot = mAssetProductDetail(Ass,mRoatingTopSpot);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='42027609' && Ass.APTS_Combination_Key__c  !=null){
                mLDirSpotLight = mAssetProductDetail(Ass,mLDirSpotLight);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='42027610' && Ass.APTS_Combination_Key__c  !=null){
                mLDirTopSpot = mAssetProductDetail(Ass,mLDirTopSpot);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='41937760' && Ass.APTS_Combination_Key__c  !=null){
                mSuperSpotLight = mAssetProductDetail(Ass,mSuperSpotLight);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='41618485' && Ass.APTS_Combination_Key__c  !=null){
                mSuperLawTopSpots = mAssetProductDetail(Ass,mSuperLawTopSpots);}
            if(Ass.Apttus_Config2__ProductId__r.productcode =='41976905' && Ass.APTS_Combination_Key__c  !=null){
                mNetworkskylight = mAssetProductDetail(Ass,mNetworkskylight);}
              //Bundle 1&2 30010890
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' &&Ass.Apttus_Config2__ProductId__r.ProductCode == '30010890' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c =='New PPC' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c =='FirmSite or FindLaw Landing Page Hosting' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c =='English' ) {
                    HasAssetBundle12 = true;
                }
                //Bundle 1&2 41343504
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' && Ass.Apttus_Config2__ProductId__r.ProductCode == '41343504' && Ass.APTS_PPC_Spend_Type__c  =='New PPC' && Ass.APTS_PPC_Website_Type__c =='FirmSite') {
                    HasAssetBundle12 = true;
                }
                
                //Bundle 1&2 30010890
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' &&Ass.Apttus_Config2__ProductId__r.ProductCode == '30010890' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c =='New PPC' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c =='Third Party Site (No Landing Pages)' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c =='English') {
                    HasAssetBundle12 = true;
                }
                
                //Bundle 1&2 30010890
               if(Ass.Apttus_Config2__LineType__c  =='Product/Service' && Ass.Apttus_Config2__ProductId__r.ProductCode == '41343504' && Ass.APTS_PPC_Spend_Type__c =='New PPC' && Ass.APTS_PPC_Website_Type__c =='Live Site (Non Firmsite)') {
                    HasAssetBundle12 = true;
                }
                
                //Buldle 4&5 30010890
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' &&Ass.Apttus_Config2__ProductId__r.ProductCode == '30010890' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c =='New PPC' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c =='FirmSite or FindLaw Landing Page Hosting' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c =='Español') {
                    HasAssetBundle45 = true;
                }
                //Buldle 4&5 41689176
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' && Ass.Apttus_Config2__ProductId__r.ProductCode == '41689176' && Ass.APTS_PPC_Spend_Type__c =='New PPC' && Ass.APTS_PPC_Website_Type__c =='FirmSite') {
                    HasAssetBundle45 = true;
                }
                
                //Buldle 4&5 30010890
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' &&Ass.Apttus_Config2__ProductId__r.ProductCode == '30010890' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c =='New PPC' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c =='Third Party Site (No Landing Pages)' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c =='Español') {
                    HasAssetBundle45 = true;
                }
                
                //Buldle 4&5 41689176
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' && Ass.Apttus_Config2__ProductId__r.ProductCode == '41689176' && Ass.APTS_PPC_Spend_Type__c =='New PPC' && Ass.APTS_PPC_Website_Type__c =='NON-FIRMSITE/LAWINFO') {
                    HasAssetBundle45 = true;
                }
                //SOC-6035 End
                
                //SOC-8028
                if(Ass.Apttus_Config2__ProductId__r.productcode =='42157433'){
                  SUPERLAWYERSASKANSWERPAGE= SUPERLAWYERSASKANSWERPAGE+Ass.Apttus_Config2__Quantity__c;
                }
                
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service'&&mfirmSite.containsKey(Ass.Apttus_Config2__ProductId__r.ProductCode)){
                    dFirmSiteQuanity = dFirmSiteQuanity+1;
                }
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c =='English' && mPPC.containsKey(Ass.Apttus_Config2__ProductId__r.ProductCode) && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c == 'New PPC' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c=='FirmSite or FindLaw Landing Page Hosting'  ){
                    dPPCQanityEnglish = dPPCQanityEnglish+1;
                }
                if(Ass.Apttus_Config2__LineType__c  =='Product/Service' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c =='Español' && mPPC.containsKey(Ass.Apttus_Config2__ProductId__r.ProductCode) && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c == 'New PPC' && Ass.Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c=='FirmSite or FindLaw Landing Page Hosting'  ){
                    dPPCQanitySpanish = dPPCQanitySpanish+1;
                }
                if(Ass.Apttus_Config2__ProductId__r.ProductCode =='41343504' && Ass.APTS_PPC_Spend_Type__c =='New PPC' && Ass.APTS_PPC_Website_Type__c =='FIRMSITE' ){
                    dPPCQanityEnglish = dPPCQanityEnglish+1;
                }
                if(Ass.Apttus_Config2__ProductId__r.ProductCode =='41689176' && Ass.APTS_PPC_Spend_Type__c =='New PPC' && Ass.APTS_PPC_Website_Type__c =='FIRMSITE' ){
                    dPPCQanitySpanish = dPPCQanitySpanish+1;
                }
                //Added By Poonam Garg DOC 9870 count only line Items which have asset status as activated
                if(Ass.Apttus_Config2__ProductId__r.ProductCode =='42762345' && Ass.Apttus_Config2__AssetStatus__c== 'Activated' ){
                    fLABOGADOPREMIUM = fLABOGADOPREMIUM+1;    
               }
                 
        }
        //SOC-4448 End
        //SOC-7431,SOC-4590,SOC-4523 End 
                   
        //SOC-4544 Start
    /*
    * Below code added by Deepthi Shirangala on 12/11/17.
    * Requirement is to check for Maximum Quantity of 1.
    */
        Map<String,String> mProductsCods = New Map<String,String>();
        Map<String,Apttus_Config2__LineItem__c> mCancelProducts = New Map<String,Apttus_Config2__LineItem__c>();
        Map<String,Apttus_Config2__LineItem__c> mCartBPIProducts = New Map<String,Apttus_Config2__LineItem__c>();
        String scodes ='30790769,30790796,41948733,41903514,41903515,41948732,41874867,41819164,41817448';
        for(String s :scodes.split(',')){
            mProductsCods.put(s,s);
        }
        //cal lines
        list<Apttus_Config2__LineItem__c> flLineItems = new list<Apttus_Config2__LineItem__c>();
        for(Apttus_Config2__LineItem__c lineItem : lineItems){
           if(lineItem.Apttus_Config2__ProductId__r.APTS_Upgrade_Downgrade_Eligible__c){
            upgradeDowngradeEligible=true;}
            mCartBPIProducts.put(lineItem.Apttus_Config2__ProductId__r.ProductCode,lineItem);
            if(lineItem.APTS_Proposal_Business_Unit__c =='FindLaw' && productCodesMap.containsKey(lineItem.Apttus_Config2__ProductId__r.ProductCode))
            {   
                flLineItems.add(lineItem);
                system.debug(LoggingLevel.WARN,'Checkkkkkkkk1'+flLineItems);
               /* Apttus_Config2.CustomClass.ValidationResult result1 = APTS_FL_Validation_CallbackHelperExt.validateCart(cart); 
                if(result1.isSuccess == false){
                    return result1;
                }*/
            }
            system.debug(LoggingLevel.WARN,'Checkkkkkkkk2');
            if(lineItem.APTS_Proposal_Business_Unit__c =='FindLaw' && lineItem.Apttus_Config2__LineStatus__c == 'New' && mProductsCods.ContainsKey(lineItem.Apttus_Config2__ProductId__r.ProductCode)){
                Integer i=0;
                if(!mDuplicateProducts.containsKey(lineItem.Apttus_Config2__ProductId__r.ProductCode)){
                    i++;mDuplicateProducts.put(lineItem.Apttus_Config2__ProductId__r.ProductCode,i);
                }else{
                    Integer count = mDuplicateProducts.get(lineItem.Apttus_Config2__ProductId__r.ProductCode)+1;
                    mDuplicateProducts.put(lineItem.Apttus_Config2__ProductId__r.ProductCode,count);
                }                                                                                                   
            }
            //Added By Poonam Garg DOC 9870
            if(lineItem .Apttus_Config2__ProductId__r.ProductCode =='42762345' && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                fLABOGADOPREMIUM = fLABOGADOPREMIUM+1;
            }//Added By Poonam Garg DOC 9870   
            if(lineItem .Apttus_Config2__ProductId__r.ProductCode =='42762345' && lineItem.Apttus_Config2__LineStatus__c == 'Cancelled'){
                fLABOGADOPREMIUM = fLABOGADOPREMIUM - 1;
            }//Added By Poonam Garg DOC 9870  
            if(lineItem .Apttus_Config2__ProductId__r.ProductCode =='42762345' && (lineItem.Apttus_Config2__LineStatus__c == 'New'
                 || lineItem.Apttus_Config2__LineStatus__c == 'Renewed')){
                quanABOGADOPREMIUM=lineItem.Apttus_Config2__Quantity__c;
            }
            //SOC-4448 Start
            //SOC-7431,SOC-4590,SOC-4523 Start
            if(mFindLwPostPluse.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)){
                FNDLWPOSTPLUSFS = FNDLWPOSTPLUSFS+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.ProductCode == '41378928'){
                FNDLWPOSTPLUSFS = FNDLWPOSTPLUSFS+lineItem.Apttus_Config2__Quantity__c;
            }
            
            //SOC-8028
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42157433'){
              SUPERLAWYERSASKANSWERPAGE= SUPERLAWYERSASKANSWERPAGE+lineItem.Apttus_Config2__Quantity__c;
            }
            
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42027607' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New' ){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42027608'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '42027607'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
            
                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mSpotLight.containsKey(Key)){
                    mSpotLight.put(Key,quanity);
                }else{
                    quanity = quanity+mSpotLight.get(key);
                    mSpotLight.put(Key,quanity);
                }
                
                if(!mSpotLight.containsKey(Key1)){
                    mSpotLight.put(Key1,1);
                }else{
                    Decimal numerofproducts = 1+mSpotLight.get(key1);
                    mSpotLight.put(Key1,numerofproducts);
                }
                if(!mSpotLight.containsKey(Key2)){
                    mSpotLight.put(Key2,1);
                }else{
                    Decimal numerofproducts = 1+mSpotLight.get(key2);
                    mSpotLight.put(Key2,numerofproducts);
                }

            }
              
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42027608' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42027607'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '42027608'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                
                if(!mTopSpot.containsKey(Key)){
                    mTopSpot.put(Key,quanity);
                }else{
                    quanity = quanity+mTopSpot.get(key);
                    mTopSpot.put(Key,quanity);
                }
                
                if(!mTopSpot.containsKey(key1)){
                    mTopSpot.put(key1,1);
                }else{
                    Decimal numberofproducts = 1+mTopSpot.get(key1);
                    mTopSpot.put(key1,numberofproducts);
                }
                if(!mTopSpot.containsKey(key2)){
                    mTopSpot.put(key2,1);
                }else{
                    Decimal numberofproducts = 1+mTopSpot.get(key2);
                    mTopSpot.put(key2,numberofproducts);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41680342' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '37005072'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '41680342'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mSpotLighthub.containsKey(Key)){
                    mSpotLighthub.put(Key,quanity);
                }else{
                    quanity = quanity+mSpotLighthub.get(key);
                    mSpotLighthub.put(Key,quanity);
                }
                if(!mSpotLighthub.containsKey(Key1)){
                    mSpotLighthub.put(Key1,1);
                }else{
                    Decimal numberofproducts = 1+mSpotLighthub.get(key1);
                    mSpotLighthub.put(Key1,numberofproducts);
                }
                if(!mSpotLighthub.containsKey(Key2)){
                    mSpotLighthub.put(Key2,1);
                }else{
                    Decimal numberofproducts = 1+mSpotLighthub.get(Key2);
                    mSpotLighthub.put(Key2,numberofproducts);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40987608' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '40987607'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '40987608'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mRefineSpotLighthub.containsKey(Key)){
                    mRefineSpotLighthub.put(Key,quanity);
                }else{
                    quanity = quanity+mRefineSpotLighthub.get(key);
                    mRefineSpotLighthub.put(Key,quanity);
                }
                if(!mRefineSpotLighthub.containsKey(Key1)){
                    mRefineSpotLighthub.put(Key1,1);
                }else{
                    Decimal numerbofprds = 1+mRefineSpotLighthub.get(key1);
                    mRefineSpotLighthub.put(Key1,numerbofprds);
                }
                if(!mRefineSpotLighthub.containsKey(key2)){
                    mRefineSpotLighthub.put(key2,1);
                }else{
                    Decimal numerbofprds = 1+mRefineSpotLighthub.get(key2);
                    mRefineSpotLighthub.put(key2,numerbofprds);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='37005004' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '37005005'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '37005004'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mDirSpotLighthub.containsKey(Key)){
                    mDirSpotLighthub.put(Key,quanity);
                }else{
                    quanity = quanity+mDirSpotLighthub.get(key);
                    mDirSpotLighthub.put(Key,quanity);
                }
                if(!mDirSpotLighthub.containsKey(Key1)){
                    mDirSpotLighthub.put(Key1,1);
                }else{
                    Decimal numberofprods = 1+mDirSpotLighthub.get(key1);
                    mDirSpotLighthub.put(Key1,numberofprods);
                }
                if(!mDirSpotLighthub.containsKey(key2)){
                    mDirSpotLighthub.put(key2,1);
                }else{
                    Decimal numberofprods = 1+mDirSpotLighthub.get(key2);
                    mDirSpotLighthub.put(key2,numberofprods);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='37005072' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '41680342'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '37005072'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mCountryTopSpot.containsKey(Key)){
                    mCountryTopSpot.put(Key,quanity);
                }else{
                    quanity = quanity+mCountryTopSpot.get(key);
                    mCountryTopSpot.put(Key,quanity);
                }
                if(!mCountryTopSpot.containsKey(Key1)){
                    mCountryTopSpot.put(Key1,1);
                }else{
                    Decimal numberofprods = 1+mCountryTopSpot.get(key1);
                    mCountryTopSpot.put(Key1,numberofprods);
                }
                if(!mCountryTopSpot.containsKey(key2)){
                    mCountryTopSpot.put(key2,1);
                }else{
                    Decimal numberofprods = 1+mCountryTopSpot.get(key2);
                    mCountryTopSpot.put(key2,numberofprods);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40987607' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '40987608'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '40987607'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mRefinedTopStop.containsKey(Key)){
                    mRefinedTopStop.put(Key,quanity);
                }else{
                    quanity = quanity+mRefinedTopStop.get(key);
                    mRefinedTopStop.put(Key,quanity);
                }
                if(!mRefinedTopStop.containsKey(Key1)){
                    mRefinedTopStop.put(Key1,1);
                }else{
                    Decimal numberofproducts = 1+mRefinedTopStop.get(key1);
                    mRefinedTopStop.put(Key1,numberofproducts);
                }
                if(!mRefinedTopStop.containsKey(key2)){
                    mRefinedTopStop.put(key2,1);
                }else{
                    Decimal numberofproducts = 1+mRefinedTopStop.get(key2);
                    mRefinedTopStop.put(key2,numberofproducts);
                }
            }
            
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='37005005' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                System.debug(LoggingLevel.WARN,'-------topspot----'+lineItem.Apttus_Config2__ProductId__r.productcode);
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '37005004'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '37005005'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key3 = '42088301'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mTopSpotsub.containsKey(Key)){
                    mTopSpotsub.put(Key,quanity);
                }else{
                    quanity = quanity+mTopSpotsub.get(key);
                    mTopSpotsub.put(Key,quanity);
                }
                if(!mTopSpotsub.containsKey(Key1)){
                    mTopSpotsub.put(Key1,1);
                }else{
                    Decimal numberofproduct = mTopSpotsub.get(key1)+1;
                    mTopSpotsub.put(Key1,numberofproduct);
                }
                if(!mTopSpotsub.containsKey(key2)){
                    mTopSpotsub.put(key2,1);
                }else{
                    Decimal numberofproduct = mTopSpotsub.get(key2)+1;
                    mTopSpotsub.put(key2,numberofproduct);
                }
                
                if(!mTopSpotsub.containsKey(key3)){
                    mTopSpotsub.put(key3,1);
                }else{
                    Decimal numberofproduct = mTopSpotsub.get(key3)+1;
                    mTopSpotsub.put(key3,numberofproduct);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42088301' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '37005005'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '42088301'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mRoatingTopSpot.containsKey(Key)){
                    mRoatingTopSpot.put(Key,quanity);
                }else{
                    quanity = quanity+mRoatingTopSpot.get(key);
                    mRoatingTopSpot.put(Key,quanity);
                }
                
                if(!mRoatingTopSpot.containsKey(Key1)){
                    mRoatingTopSpot.put(Key1,1);
                }else{
                    Decimal numberofpro = 1+mRoatingTopSpot.get(key1);
                    mRoatingTopSpot.put(Key1,numberofpro);
                }
                if(!mRoatingTopSpot.containsKey(key2)){
                    mRoatingTopSpot.put(key2,1);
                }else{
                    Decimal numberofpro = 1+mRoatingTopSpot.get(key2);
                    mRoatingTopSpot.put(key2,numberofpro);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42027609' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42027610'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '42027609'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mLDirSpotLight.containsKey(Key)){
                    mLDirSpotLight.put(Key,quanity);
                }else{
                    quanity = quanity+mLDirSpotLight.get(key);
                    mLDirSpotLight.put(Key,quanity);
                }
                if(!mLDirSpotLight.containsKey(Key1)){
                    mLDirSpotLight.put(Key1,1);
                }else{
                    Decimal numbprods = 1+mLDirSpotLight.get(key1);
                    mLDirSpotLight.put(Key1,numbprods);
                }
                if(!mLDirSpotLight.containsKey(key2)){
                    mLDirSpotLight.put(key2,1);
                }else{
                    Decimal numbprods = 1+mLDirSpotLight.get(key2);
                    mLDirSpotLight.put(key2,numbprods);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42027610' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42027609'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '42027610'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mLDirTopSpot.containsKey(Key)){
                    mLDirTopSpot.put(Key,quanity);
                }else{
                    quanity = quanity+mLDirTopSpot.get(key);
                    mLDirTopSpot.put(Key,quanity);
                }
                if(!mLDirTopSpot.containsKey(Key1)){
                    mLDirTopSpot.put(Key1,1);
                }else{
                    Decimal numberprods = 1+mLDirTopSpot.get(key1);
                    mLDirTopSpot.put(Key1,numberprods);
                }
                if(!mLDirTopSpot.containsKey(Key2)){
                    mLDirTopSpot.put(Key2,1);
                }else{
                    Decimal numberprods = 1+mLDirTopSpot.get(key2);
                    mLDirTopSpot.put(Key2,numberprods);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41937760' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '41618485'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '41937760'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mSuperSpotLight.containsKey(Key)){
                    mSuperSpotLight.put(Key,quanity);
                }else{
                    quanity = quanity+mSuperSpotLight.get(key);
                    mSuperSpotLight.put(Key,quanity);
                }
                if(!mSuperSpotLight.containsKey(Key1)){
                    mSuperSpotLight.put(Key1,1);
                }else{
                    Decimal numberprods = 1+mSuperSpotLight.get(key1);
                    mSuperSpotLight.put(Key1,numberprods);
                }
                if(!mSuperSpotLight.containsKey(key2)){
                    mSuperSpotLight.put(key2,1);
                }else{
                    Decimal numberprods = 1+mSuperSpotLight.get(key2);
                    mSuperSpotLight.put(key2,numberprods);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41618485' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '41937760'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '41618485'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mSuperLawTopSpots.containsKey(Key)){
                    mSuperLawTopSpots.put(Key,quanity);
                }else{
                    quanity = quanity+mSuperLawTopSpots.get(key);
                    mSuperLawTopSpots.put(Key,quanity);
                }
                
                if(!mSuperLawTopSpots.containsKey(Key1)){
                    mSuperLawTopSpots.put(Key1,1);
                }else{
                    Decimal numberprods = 1+mSuperLawTopSpots.get(key1);
                    mSuperLawTopSpots.put(Key1,numberprods);
                }
                if(!mSuperLawTopSpots.containsKey(key2)){
                    mSuperLawTopSpots.put(key2,1);
                }else{
                    Decimal numberprods = 1+mSuperLawTopSpots.get(key2);
                    mSuperLawTopSpots.put(key2,numberprods);
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41976905' && lineItem.APTS_Combination_Key__c  !=null && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__c +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__c +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__c ;

                quanity = quanity+lineItem.Apttus_Config2__Quantity__c;
                if(!mNetworkskylight.containsKey(Key)){
                    mNetworkskylight.put(Key,quanity);
                }else{
                    quanity = quanity+mNetworkskylight.get(key);
                    mNetworkskylight.put(Key,quanity);
                }
                if(!mNetworkskylight.containsKey(Key1)){
                    mNetworkskylight.put(Key1,1);
                }else{
                    Decimal numbrpods = 1+mNetworkskylight.get(key1);
                    mNetworkskylight.put(Key1,numbrpods);
                }

            }
            if(lineItem.Apttus_Config2__LineStatus__c  =='New'  || lineItem.Apttus_Config2__LineStatus__c  =='Cancelled'){
                ProductAttributeID.Add(lineItem.Apttus_Config2__AttributeValueId__c);}
            
            String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
            mCancelProducts.put(Key,lineItem);
            
        }
        
        if(!flLineItems.isempty() && flLineItems!=Null && Productconfig!=Null){
            Apttus_Config2.CustomClass.ValidationResult result1 = APTS_FL_Validation_CallbackHelperExt.validateCart(flLineItems,Productconfig); 
                if(result1.isSuccess == false){
                    return result1;
                }
        }    
        
        //SOC-4448 End
        //SOC-7431,SOC-4590,SOC-4523 End
        
        //error lines
        
        for(Apttus_Config2__LineItem__c lineItem : lineItems){
            //Duplicate products
            if(mDuplicateProducts.containsKey(lineItem.Apttus_Config2__ProductId__r.ProductCode) && mDuplicateProducts.get(lineItem.Apttus_Config2__ProductId__r.ProductCode)>1){
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' '));
                result.isSuccess = false;                  
                return result;
            }
            //Quantity check
            if(lineItem.APTS_Proposal_Business_Unit__c =='FindLaw' && lineItem.Apttus_Config2__LineStatus__c == 'New' && mProductsCods.ContainsKey(lineItem.Apttus_Config2__ProductId__r.ProductCode)){ 
                
                if(!mLineQuanity.containsKey(lineItem.Apttus_Config2__ProductId__r.ProductCode)){
                    mLineQuanity.put(lineItem.Apttus_Config2__ProductId__r.ProductCode,lineItem);
                }
                if(lineItem.Apttus_Config2__Quantity__c>1 && lineItem.Apttus_Config2__ProductId__r.ProductCode != '41817449'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' '));
                    result.isSuccess = false;                  
                    return result; 
                }
              }
            //SOC-4448 Start
            //SOC-7431,SOC-4590,SOC-4523 Start
            if(lineItem.Apttus_Config2__ProductId__r.ProductCode == '41378928' && FNDLWPOSTPLUSFS > 10 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum quantity 10 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' '));
                result.isSuccess = false;                  
                return result; 
            } 
            
            //SOC-8028
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42157433' && SUPERLAWYERSASKANSWERPAGE >5 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum quantity 5 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' '));
                result.isSuccess = false;                  
                return result;
            } 
            
            //SOC-9083
            system.debug(LoggingLevel.WARN,'Product code----'+lineItem.Apttus_Config2__ProductId__r.productcode);
            //SOC-9083        
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42027607' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42027608'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;
                
                Decimal Qunaitysl=0;
                
                if(mSpotLight.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Qunaitysl = Qunaitysl+mSpotLight.get(key);
                }
                Decimal Quanity = 0;
                if(mTopSpot.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mTopSpot.get(key1);
                }
                if(mSpotLight.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mSpotLight.get(key1);
                }
                
                if(Qunaitysl>1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts, key1);
                }
                     
                if(Quanity>1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42027608' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42027607'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal Q1 =0;
                if(mTopSpot.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                   Q1 = Q1+mTopSpot.get(key); 
                }
                 Decimal Quanity = 0;
                if(mTopSpot.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mTopSpot.get(key1);
                }
                
                if(mSpotLight.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mTopSpot.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                if(Q1>1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(Quanity >1){
                  result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c  +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41680342' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '37005072'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;
                Decimal Quanity1 =0;
                if(mSpotLighthub.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                   Quanity1 = Quanity1+mSpotLighthub.get(key);
                }
               Decimal Quanity = 0;
                
                if(mSpotLighthub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mSpotLighthub.get(key1);
                }
                
                if(mCountryTopSpot.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mCountryTopSpot.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                     /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                if(Quanity1>1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
               
                if(Quanity >1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40987608' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '40987607'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1 =0;
                if(mRefineSpotLighthub.containskey(key)&& lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1 = q1 +mRefineSpotLighthub.get(key);
                }
                Decimal Quanity = 0;
                if(mRefineSpotLighthub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mRefineSpotLighthub.get(key1);
                }
                if(mRefinedTopStop.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mRefinedTopStop.get(key1);
                }
                
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                if(mCancelProducts.containskey(key1)){
                     /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                if(Quanity > 1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='37005004' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '37005005'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1 =0;
                
                if(mDirSpotLighthub.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1 = q1 + mDirSpotLighthub.get(key); 
                }
                Decimal Quanity = 0;
                if(mDirSpotLighthub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mDirSpotLighthub.get(key1);
                }
                
                if(mTopSpotsub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mTopSpotsub.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(Quanity >1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
                
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='37005072' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '41680342'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1 =0;
                
                if(mCountryTopSpot.containskey(key)  && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1 = q1+mCountryTopSpot.get(key);
                }
                
                 Decimal Quanity = 0;
                if(mCountryTopSpot.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mCountryTopSpot.get(key1);
                }
                
                if(mSpotLighthub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mSpotLighthub.get(key1);
                }
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(Quanity >1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40987607' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '40987608'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1=0;
                if(mRefinedTopStop.containskey(key)  && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1 = q1+mRefinedTopStop.get(key);
                }
              
                 Decimal Quanity = 0;
                if(mRefinedTopStop.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mRefinedTopStop.get(key1);
                }
                
                if(mRefineSpotLighthub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mRefineSpotLighthub.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(Quanity>1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='37005005' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '37005004'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;
                String key2 = '42088301'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1=0;
                if(mTopSpotsub.containskey(key)  && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1 = q1 +mTopSpotsub.get(key);
                }
                Decimal Quanity = 0;
                if(mTopSpotsub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mTopSpotsub.get(key1);
                }
                if(mDirSpotLighthub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mDirSpotLighthub.get(key1);
                }
                if(mRoatingTopSpot.containskey(key2) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mRoatingTopSpot.get(key2);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                if(mCancelProducts.containskey(key2) && (key2!=null)){
                    
                        Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key2);
                        if((cancelline!=null) && (cancelline.Apttus_Config2__LineStatus__c =='Cancelled')){ 
                            Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;
                        }
                    
                }
                
                
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(Quanity >1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42088301' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '37005005'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1=0;
                if(mRoatingTopSpot.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1= q1+mRoatingTopSpot.get(key);
                }
                Decimal Quanity = 0;
                if(mRoatingTopSpot.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mRoatingTopSpot.get(key1);
                }
                
                if(mTopSpotsub.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mTopSpotsub.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }

                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                                
                if(Quanity >1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42027609' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42027610'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1=0;
                if(mLDirSpotLight.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1= q1+mLDirSpotLight.get(key);
                }
               Decimal Quanity = 0;
                if(mLDirSpotLight.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mLDirSpotLight.get(key1);
                }
                if(mLDirTopSpot.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mLDirTopSpot.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(Quanity>1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42027610' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42027609'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;
                Decimal q1=0;
                if(mLDirTopSpot.containskey(key)&& lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1 = q1+ mLDirTopSpot.get(key);
                }
                Decimal Quanity = 0;
                if(mLDirTopSpot.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mLDirTopSpot.get(key1);
                }
                
                if(mLDirSpotLight.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mLDirSpotLight.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(Quanity > 1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41937760' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '41618485'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1=0;
                if(mSuperSpotLight.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                   q1=q1+mSuperSpotLight.get(key);
                }
               Decimal Quanity = 0;
                if(mSuperSpotLight.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mSuperSpotLight.get(key1);
                }
                
                if(mSuperLawTopSpots.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mSuperLawTopSpots.get(key1);
                }
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                
                if(Quanity > 1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41618485' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '41937760'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1=0;
                if(mSuperLawTopSpots.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1=q1+mSuperLawTopSpots.get(key);
                }
              Decimal Quanity = 0;
                if(mSuperLawTopSpots.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mSuperLawTopSpots.get(key1);
                }
                if(mSuperSpotLight.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mSuperSpotLight.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                    
                if(q1>1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(Quanity > 1){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41976905' && lineItem.APTS_Combination_Key__c  !=null){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__c +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__c +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__c ;

                Decimal q1=0;
                
                if(mNetworkskylight.containskey(key) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    q1 = q1+mNetworkskylight.get(key);
                }
                
                Decimal Quanity = 0;
                if(mNetworkskylight.containskey(key1) && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    Quanity = Quanity+mNetworkskylight.get(key1);
                }
                
                if(mCancelProducts.containskey(key1)){
                    /*Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}*/
                    //Fixed by Tanmay for  (rule: Design-AvoidDeeplyNestedIfStmts)
                    Quanity = returnQuantiy(Quanity, mCancelProducts,key1);
                }
                
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(mNetworkskylight.containskey(key1) && mNetworkskylight.get(key1)>1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'This customer already has this \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' as an asset or in Cart.Please remove \''+lineItem.APTS_Product_Name__c+'\' \''+lineItem.APTS_Product_Detail__c+'\' from \'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' in this order.'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
          //SOC-4448 End  //SOC-7431,SOC-4590,SOC-4523 End
        }   
        //Added By Poonam Garg DOC 9870 If More than 1 Abogado Products found in cart
        if(fLABOGADOPREMIUM>1  ){
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'Only one Abogado.com Premium Profile allow per customer.'));
                    result.isSuccess = false;                  
                    return result;
            
        }
        //Added By Poonam Garg DOC 9870 If More than 1 quantity for Abogado Products found in cart
        if(quanABOGADOPREMIUM>1){
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'You are allowed to purchase a maximum quantity of 1 for Abogado.com Premium Profile.'));
                    result.isSuccess = false;                  
                    return result;
            
        }
        for(Apttus_Config2__AssetLineItem__c aItem : [select id , Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__Quantity__c,Apttus_QPConfig__ProposalId__r.APTS_Approval_Segment__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__AssetStatus__c from Apttus_Config2__AssetLineItem__c where APTS_SSD_Sold_To__c = :cart.getConfigSO().APTS_SSD_Sold_To__c  AND Apttus_Config2__AssetStatus__c = 'Activated' ]){
            mAssetQuanity.put(aItem.Apttus_Config2__ProductId__r.ProductCode,aItem.Apttus_Config2__Quantity__c);
            if(mLineQuanity.containsKey(aItem.Apttus_Config2__ProductId__r.ProductCode)){
                Apttus_Config2__LineItem__c lines = mLineQuanity.get(aItem.Apttus_Config2__ProductId__r.ProductCode);
                if(lines.Apttus_Config2__ProductId__r.ProductCode == aItem.Apttus_Config2__ProductId__r.ProductCode){
                    Decimal Quanity =  aItem.Apttus_Config2__Quantity__c+lines.Apttus_Config2__Quantity__c;
                    if(Quanity>1){
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum quantity 1 of : \''+ aItem.Apttus_Config2__ProductId__r.Name+'\' '));
                        result.isSuccess = false;                  
                        return result; 
                    }
                }   
            }
          if(mFirmSiteProducts.containsKey(aItem.Apttus_Config2__ProductId__r.ProductCode)){
            FirmProductsCount = FirmProductsCount+aItem.Apttus_Config2__Quantity__c;}
        }
        
        //SOC-4544 End 
        //SOC-6057 End
        
        
        //SOC-4570 Start
        //SOC-6515 Start
    /*
    * Below code added by Deepthi Shirangala on 1/25/18.
    * Requirement is to Implement the Max Quantity Rule For PPC Products.
    * Requirement is to implement the Max Quantity Rue for Existing PPC Assets.
    */  
        
       for(Apttus_Config2__ProductAttributeValue__c  PA : [Select ID,APTS_PPC_Type__c, APTS_PPC_Language_Selection__c, APTS_PPC_Website_Selection__c from Apttus_Config2__ProductAttributeValue__c where ID IN : ProductAttributeId]){
            mProductAtribute.put(PA.id,PA);
        }
        
        for(Apttus_Config2__LineItem__c lineItem : lineItems){
            
                if(lineitem.Apttus_Config2__LineType__c  =='Product/Service'&& mfirmSite.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) && lineitem.Apttus_Config2__LineStatus__c=='New'){
                    dFirmSiteQuanity = dFirmSiteQuanity+1;
                }
                if(lineitem.Apttus_Config2__LineType__c  =='Product/Service'&& mfirmSite.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) && lineitem.Apttus_Config2__LineStatus__c=='Cancelled'){
                    dFirmSiteCancelQuanity = dFirmSiteCancelQuanity+1;
                }
                 
                if(lineitem.Apttus_Config2__LineStatus__c=='New'   && lineitem.Apttus_Config2__LineType__c  =='Product/Service'&& mPPC.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='New PPC' && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c =='English'&& mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Website_Selection__c  == 'FirmSite or FindLaw Landing Page Hosting' ){
                    dPPCQanityEnglish = dPPCQanityEnglish+1; isRenewed = true;
                } 
                if((lineitem.Apttus_Config2__LineStatus__c=='Cancelled'   && lineitem.Apttus_Config2__LineType__c  =='Product/Service'&& mPPC.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='New PPC' && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c =='English'&& mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Website_Selection__c  == 'FirmSite or FindLaw Landing Page Hosting') || (lineitem.Apttus_Config2__ProductId__r.ProductCode=='41343504' && lineitem.Apttus_Config2__LineStatus__c=='Cancelled')){
                    dPPCCancelQanityEnglish = dPPCCancelQanityEnglish+1; 
                } 
                
                if(lineitem.Apttus_Config2__LineStatus__c=='New'  && lineitem.Apttus_Config2__LineType__c  =='Product/Service'&& mPPC.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='New PPC' && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c == 'Español' && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Website_Selection__c  == 'FirmSite or FindLaw Landing Page Hosting' ){                 
                    dPPCQanitySpanish = dPPCQanitySpanish+1;isRenewed = true;
                } 
                if((lineitem.Apttus_Config2__LineStatus__c=='Cancelled'  && lineitem.Apttus_Config2__LineType__c  =='Product/Service'&& mPPC.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='New PPC' && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c == 'Español' && mProductAtribute.get(lineItem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Website_Selection__c  == 'FirmSite or FindLaw Landing Page Hosting') || (lineitem.Apttus_Config2__ProductId__r.ProductCode=='41689176' && lineitem.Apttus_Config2__LineStatus__c=='Cancelled')){                 
                    dPPCCancelQanitySpanish = dPPCCancelQanitySpanish+1;
                } 
             }
        dFirmsiteTotalQanity=dFirmSiteQuanity-dFirmSiteCancelQuanity; 
        dPPCTtotalQanityEnglish=dPPCQanityEnglish-dPPCCancelQanityEnglish;
        dPPCTotalQanitySpanish=dPPCQanitySpanish-dPPCCancelQanitySpanish;
        system.debug(LoggingLevel.WARN,'dFirmSiteQuanity--'+dFirmSiteQuanity);
        system.debug(LoggingLevel.WARN,'dFirmSiteQuanity--'+dFirmSiteCancelQuanity);
        system.debug(LoggingLevel.WARN,'dFirmSiteQuanity--'+dPPCQanityEnglish);
        system.debug(LoggingLevel.WARN,'dFirmSiteQuanity--'+dPPCCancelQanityEnglish);
        system.debug(LoggingLevel.WARN,'dFirmSiteQuanity--'+dPPCQanitySpanish);
        system.debug(LoggingLevel.WARN,'dFirmSiteQuanity--'+dPPCCancelQanitySpanish);
        
        //SOC-6035 Start
       /*
       * Below code added by Deepthi Shirangala on 1/25/18.
       * Requirement is to Implement Prerequisite Validations For PPC Products.
       */
        
        if(dPPCTtotalQanityEnglish > dFirmsiteTotalQanity && isRenewed){
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Please add a qualifying Firmsite or Solution to the cart. If you want to add spend to this customer’s existing PPC campaign, please select the Additional Spend PPC Bundle or create a new contract if the client’s total PPC spend will now exceed $5000.'));
            result.isSuccess = false;                   
            return result; 
         } 
        if(dPPCTotalQanitySpanish > dFirmsiteTotalQanity && isRenewed){
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Please add a qualifying Firmsite or Solution to the cart. If you want to add spend to this customer’s existing PPC campaign, please select the Additional Spend PPC Bundle or create a new contract if the client’s total PPC spend will now exceed $5000.'));
            result.isSuccess = false;                   
            return result; 
         }
        
        //SOC-4570 End
        //SOC-6515 End
                    
        //SOC-6207 Start
    /*
    * Below code added by Deepthi Shirangala on 1/22/18.
    * Requirement is to implement Rules for PPC.
    */   
   
        for(Apttus_Config2__LineItem__c lineItem : lineItems){
            
            if(lineitem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c  =='New' && mProductAtribute.containsKey(lineitem.Apttus_Config2__AttributeValueId__c) && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='New PPC' && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c =='Español' && mPPCProductsIDs.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) ){
                hasNewPPC1 = true;
            }
            if(lineitem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c  =='New' && mProductAtribute.containsKey(lineitem.Apttus_Config2__AttributeValueId__c) && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='Existing PPC (Increase the Monthly Spend)' && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c =='Español' && mPPCProductsIDs.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) ){
                 hasExsistingPPC1 = true;
            }
            
            if(lineitem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c  =='New' && mProductAtribute.containsKey(lineitem.Apttus_Config2__AttributeValueId__c) && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='New PPC' && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c =='English' && mPPCProductsIDs.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) ){
                hasNewPPC = true;
            }
            if(lineitem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c  =='New' && mProductAtribute.containsKey(lineitem.Apttus_Config2__AttributeValueId__c) && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='Existing PPC (Increase the Monthly Spend)' && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c =='English' && mPPCProductsIDs.containsKey(lineitem.Apttus_Config2__ProductId__r.ProductCode) ){
                hasExsistingPPC = true;
            }
            //SOC-6035
            //Buldle 12
            if(lineitem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c  =='New' && (lineItem.Apttus_Config2__ProductId__r.ProductCode =='30010890') && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='Existing PPC (Increase the Monthly Spend)' && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c =='English' && !HasAssetBundle12){
               result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You cannot order PPC Additional Spend, you must have an existing PPC subscription.'));
                result.isSuccess = false;                   
                return result;
            }
            //SOC-6035
            //Buldle 45
            if(lineitem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c  =='New' && (lineItem.Apttus_Config2__ProductId__r.ProductCode =='30010890') && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Type__c =='Existing PPC (Increase the Monthly Spend)' && mProductAtribute.get(lineitem.Apttus_Config2__AttributeValueId__c).APTS_PPC_Language_Selection__c =='Español' && !HasAssetBundle45){
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You cannot order PPC Español Additional Spend, you must have an existing PPC Español subscription.'));
                result.isSuccess = false;                   
                return result;
            }
        }
       
        if(hasNewPPC && hasExsistingPPC){
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum of 1 Line item(s) of FindLaw PPC Advertising - Management at the cart level'));
            result.isSuccess = false;                   
            return result; 
        }
        
        if(hasNewPPC1 && hasExsistingPPC1){
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum of 1 Line item(s) of FindLaw PPC Advertising - Management at the cart level.'));
            result.isSuccess = false;                   
            return result; 
        }

        //SOC-6207 End        
        
        //SOC-6011 Start
        /*
        * Below code added by Deepthi Shirangala on 12/26/17.
        * Requirement is to check for update max qty rule 1 per Firmsite for Blog Platform - BPI & other products.
        */
        
       Map<Id, Apttus_Config2__LineItem__c> lineItemsF = new Map<Id, Apttus_Config2__LineItem__c>();
       for(Apttus_Config2__LineItem__c lineItem : lineItems){
             lineItemsF.put(lineItem.Id, lineItem);           
                //SOC-7034 added by Gowthami 29/3/18    
            if(lineItem.APTS_Proposal_Business_Unit__c=='FindLaw' && lineItem.APTS_Combination_Key__c== null && lineItem.Apttus_Config2__ProductId__r.APTS_Attrbased_config__c==TRUE && lineItem.Apttus_Config2__LineStatus__c == 'New'){
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'A PA/GEO product was added incorrectly from the catalog and is priced at 0.00. Please remove the product from the cart and go to the PA/GEO button below to configure and add the product to the cart.'));
                result.isSuccess=false;
                return result;
            }
               //SOC-6778 
            if(lineItem.Apttus_Config2__LineStatus__c == 'Cancelled')    {
                proWithStatusCancelledIDSet.add(lineItem.Apttus_Config2__ProductId__c);
                if(lineItem.Apttus_Config2__EndDate__c>system.today() && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw'){
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Lapsing is only available for immediate lapse, please enter the current date. If future lapse is needed, please contact your Account Manager'));
                    result.isSuccess = false;                  
                    return result; 
                }     
            } 
             proIDSet.add(lineITem.Apttus_Config2__ProductId__c); 
            maxQuanmaterial.addall(Label.Max_Quantity.split(','));           
             if(lineItem.APTS_Proposal_Business_Unit__c =='FindLaw' && lineItem.Apttus_Config2__LineStatus__c == 'New' && maxQuanmaterial.contains(lineItem.Apttus_Config2__ProductId__r.ProductCode)){
              lineQan=lineItem.Apttus_Config2__Quantity__c;
              prodName=lineItem.Apttus_Config2__ProductId__r.Name;
              prodCode=lineItem.Apttus_Config2__ProductId__r.ProductCode;
              segment=lineItem.APTS_Proposal_Business_Unit__c;
              maxProd= true;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
            }
        }
           Boolean allCancelled = true;           
            for(Apttus_config2.LineItem li2 : cart.getLineItems()){               
                Apttus_Config2__LineItem__c li = li2.getLineItemSO();
                //Apttus_Config2__LineItem__c liF = lineItemsF.get(li.Id);//Commented by Tanmay as a Part of PMD Fix - apex pmd (UnusedLocalVariable)

                if(li.Apttus_Config2__LineStatus__c != 'Cancelled'){
                    allCancelled = false;
               }
               }
               if(allCancelled && cart.getLineItems().size() > 0){
                result.isSuccess = false;
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot finalize cart with only lapsed line items.'));
                return result;
            }
        
       // SOC-6011 End  
        //SOC-4449 /4450 Start  
        //error - asset
        for(Apttus_Config2__AssetLineItem__c aItem : [select id , Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__Quantity__c,Apttus_QPConfig__ProposalId__r.APTS_Approval_Segment__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__AssetStatus__c from Apttus_Config2__AssetLineItem__c where APTS_SSD_Sold_To__c = :cart.getConfigSO().APTS_SSD_Sold_To__c  AND Apttus_Config2__AssetStatus__c = 'Activated' ]){
            aliProductCodeMap.put(aItem.Apttus_Config2__ProductId__r.Productcode, True);                
            maxQuanmaterial.addall(Label.Max_Quantity.split(','));
            assetliquan=aItem.Apttus_Config2__Quantity__c;
            assetNo=aItem.Apttus_Config2__ProductId__r.ProductCode;
            if(segment =='FindLaw' && lineQan>1 && (maxQuanmaterial.contains(aItem.Apttus_Config2__ProductId__r.ProductCode) && maxProd==true && aItem.Apttus_Config2__AssetStatus__c=='Activated') ){
            //if(segment =='FindLaw' && lineQan > 1){
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum quantity 1 of : \''+ prodName+'\' '));
                result.isSuccess = false;                  
                return result;  
            }            
                       
        }  
         system.debug(LoggingLevel.WARN,'upgradeDowngradeEligible---'+upgradeDowngradeEligible);
        if(upgradeDowngradeEligible){
            result=APTS_FL_UpgradeDowngrade_Validation.validateUpgradeDowngradeError(lineItems,assetLineItemList);
            return result;
        }  
        return result;
    }
    @testVisible
    private static Decimal returnQuantiy(Decimal Quanity, Map<String,Apttus_Config2__LineItem__c> mCancelProducts, String key1){
        Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
        if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled'){ Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;}
        return Quanity;
    }
    /**
     * @description 
     * @param Ass
     * @param mAssetDetail1
     * @return 
     */
     public Map<String,Decimal> mAssetProductDetail(Apttus_Config2__AssetLineItem__c  Ass, Map<String,Decimal> mAssetDetail1){
        Map<String,Decimal> mAssetDetail = new Map<String,Decimal>();
        if(!mAssetDetail1.isEmpty()){
            mAssetDetail = mAssetDetail1;}        
        if(Ass.APTS_Combination_Key__c  !=null){
            String key = Ass.Apttus_Config2__ProductId__r.productcode+Ass.APTS_Combination_Key__c;
            String key1 = Ass.Apttus_Config2__ProductId__r.productcode+Ass.APTS_Combination_Key__r.APTS_Configuration_Description__c+Ass.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name+Ass.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name+Ass.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+Ass.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;
            Decimal quanity = 0;
            quanity = quanity+Ass.Apttus_Config2__Quantity__c;
            if(!mAssetDetail.containskey(key)){
                mAssetDetail.put(Key,quanity);
            }else{
                Decimal Quanity1 = mAssetDetail.get(Key)+quanity;
                mAssetDetail.put(Key,quanity1);
            }
            
            if(!mAssetDetail.containskey(key1)){
                mAssetDetail.put(Key1,1);
            }else{
                Decimal numberofproducts = mAssetDetail.get(Key1)+1;
                mAssetDetail.put(Key1,numberofproducts);
            }
            return  mAssetDetail;
        }else{
            return null;}
    }
    
    
}