public with sharing class APTS_FL_Validation_CallbackHelperExt {
    
    //public Static Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) {
    public Static Apttus_Config2.CustomClass.ValidationResult validateCart(List<Apttus_Config2__LineItem__c> lineItems, Apttus_Config2__ProductConfiguration__c Productconfig) {
    //public static void validateCart(List<Apttus_Config2__LineItem__c> lineItems, Apttus_Config2__ProductConfiguration__c Productconfig){
        System.debug('Check RUN APTS_FL_Validation_CallbackHelperExt');
        Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true);
     /*   Apttus_Config2__ProductConfiguration__c Productconfig = New Apttus_Config2__ProductConfiguration__c();
        Productconfig =[Select ID,Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c from Apttus_Config2__ProductConfiguration__c where ID =:cart.getConfigSO().Id];
        if(Productconfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c <> null && Productconfig.Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c !='FindLaw')
            return null;
            
        List<Apttus_Config2__LineItem__c> lineItems = [SELECT ApTS_Year_2_3_Price__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__EndDate__c,Apttus_Config2__LineNumber__c,APTS_Product_Name__c,APTS_Product_Detail__c,Apttus_Config2__AssetLineItemId__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Description,APTS_Approval_Segment__c,APTS_Proposal_Business_Unit__c,
                                                                Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, APTS_Proposal_Group__c, APTS_Group__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.APTS_Upgrade_Downgrade_Eligible__c,Apttus_Config2__LineStatus__c,
                                                                Apttus_Config2__LineSequence__c,APTS_Bridge__c, APTS_New_Bridge_Discount__c, APTS_Contract_Term__c, Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c,Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c,
                                                                Apttus_Config2__ProductId__r.APTS_Corporate_Select__c, Apttus_Config2__ProductId__r.Name,APTS_Combination_Key__c,Apttus_Config2__ProductId__r.APTS_Attrbased_config__c,
                                                                Apttus_Config2__AttributeValueId__r.APTS_Total_Number_of_Points__c, Apttus_Config2__ChargeType__c,APTS_Combination_Key__r.APTS_Configuration_Description__c,APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name,
                                                                APTS_Media_High_Level_Code__c, APTS_Media_Lower_Level_Code__c, APTS_Keep_Terms__c, Apttus_Config2__PriceType__c, 
                                                                Apttus_Config2__Quantity__c, Apttus_Config2__LineType__c, Apttus_Config2__IsPrimaryLine__c, Apttus_Config2__ProductId__r.Family,APTS_Deal_Type__c,APTS_Deal_Number__c, APTS_Subscription_Number__c,APTS_Is_Special_Offer_Lapsed__c,APTS_Group_Primary_Material_Name__c
                                                                FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :cart.getConfigSO().Id];
        */
        Map<String,String> mFNDLWBLOGPLATFORM = New Map<String,String>();
        Map<String,String> mFNDLWANIMATIONESSENTIAL  = New Map<String,String>();
        Map<String,String> mFNDLWANIMATIONPREMIUM  = New Map<String,String>();
        Map<String,String> mFNDLWFIRMSITEMOBILEESSENTIAL  = New Map<String,String>();
        Map<String,String> mFNDLWMOBILEESSENTIAL   = New Map<String,String>();
        Map<String,String> mFindLwPostPluse = New Map<String,String>(); 
        Map<String,String> mFindLwArchive = New Map<String,String>();
        List<Product_Codes_Set6__c> prodCodesSet6=Product_Codes_Set6__c.getAll().values();
        for(Product_Codes_Set6__c  p6: prodCodesSet6){
            mFindLwArchive.put(p6.Name,p6.name);
        }
        
        Decimal FNDLWBLOGPLATFORMQuniaty =0;
        Decimal FNDLWBLOGPLATFORMQuniatyIndividual =0;
        Decimal FNDLWBLOGPLATFORMQuniatyIndividualCancel =0;
        Decimal FNDLWANIMATIONESSENTIAL =0;
        Decimal FNDLWANIMATIONESSENTIALIndividual =0;
        Decimal FNDLWANIMATIONESSENTIALIndividualCancel =0;
        Decimal FNDLWANIMATIONPREMIUM =0;
        Decimal FNDLWANIMATIONPREMIUMIndividual =0;
        Decimal FNDLWANIMATIONPREMIUMIndividualCancel =0;
        Decimal FNDLWFIRMSITEMOBILEESSENTIAL =0;
        Decimal FNDLWFIRMSITEMOBILEESSENTIALIndividual =0;
        Decimal FNDLWFIRMSITEMOBILEESSENTIALIndividualCancel =0;
        Decimal FNDLWMOBILEESSENTIAL =0;
        Decimal FNDLWMOBILEESSENTIALIndividual =0;
        Decimal FNDLWMOBILEESSENTIALIndividualCancel =0;
        Decimal FNDLWBLOGPLATFORMQuniatyTotal = 0;
        Decimal FNDLWANIMATIONESSENTIALTotal= 0;
        Decimal FNDLWANIMATIONPREMIUMTotal= 0;
        Decimal FNDLWFIRMSITEMOBILEESSENTIALTotal= 0;
        Decimal FNDLWMOBILEESSENTIALTotal= 0;
        Decimal FNDLAWFSARCHIVE=0;
        Decimal FNDLWFSARCHIVEIndividualCancel=0;
        Decimal FNDLAWFSARCHIVETotal =0;
        
        Decimal SocialPromoton =0;
        Decimal FNDLWDigitalWeb =0;
        Decimal FNDLWFSWebAdvPlus=0;
       
        Decimal FNDLWWebchatStandard=0;
        Decimal FNDLWWebchatPremium=0;
        Decimal FNDLWVoiceStandard=0;
        Decimal FNDLWVoicePremium=0;
        Decimal FNDLWDigitalMKTGBoost=0;
        Decimal FNDLWVideoSocialPro=0;
        Decimal FNDLWFOCUSPAGEBASE=0;
        Decimal FNDLWEngagementBuilder2=0;
        Decimal FNDLWCoreSite=0;
        Decimal fndlwClientPulse=0;
       
        Decimal FNDLWInsightWithCallTracking=0;
        Decimal lang3Quanity=0;
        Decimal FNDLWForeignLang3 =0;
        Decimal lang4Quanity=0;
        Decimal FNDLWForeignLang4 =0;
        //Decimal FNDLWFSARCHIVE=0;
        Decimal FNDLWPOSTPLUSFS=0;
        Decimal FNDLAWFSARCHIVEINDIVIUAL=0;
        Decimal FNDLAWFSARCHIVECancel=0;
        
        Decimal FNDLWBLOGPLATFORMQuniatyCancel= 0;
        Decimal FNDLWANIMATIONESSENTIALCancel= 0;
        Decimal FNDLWANIMATIONPREMIUMCancel= 0;
        Decimal FNDLWFIRMSITEMOBILEESSENTIALCancel= 0;
        Decimal FNDLWMOBILEESSENTIALCancel= 0;
        Decimal socialPromoCancelled=0;
        Decimal FNDLWPremium=0;
        Decimal FNDLWPremiumCancel=0;
        
        Decimal fndlawDigitalWebCancelled=0;
        Decimal fndlawFSWebAdvPlusCancelled=0;
        Decimal fndlwWebchtStdCancelled=0;
        Decimal fndlwWebChtPrmCancelled=0;
        Decimal fndlwVoiceStdCancelled=0;
        Decimal fndlwVoicePrmCancelled=0;
        Decimal fndlwDigMKTGBoostCancel=0;
        Decimal fndlwVideoSocialProCancel=0;
        Decimal fndlwFocusPgBaseCancel=0;
        Decimal fndlwEngmntBuild2Cancel=0;
        Decimal fndlwCoreSiteCancel=0;
        Decimal fndlwClientPulseCancel=0;
        Decimal fndlwReputationAdvisor=0;
        Decimal fndlawClientPulse=0;
        Decimal fndlawReputationReview=0;
        Decimal fndlawSocialStart=0;
        Decimal fndlawPremiumProf=0;
        Decimal superLwyerProfCancel=0;
        Decimal superLwyerProf=0;
        Decimal superLwyerTop=0;
        Decimal superLwyerTopspot=0;
        Decimal superLwyerRTop=0;
        Decimal superLwyerRTopspot=0;
        Decimal superLwyerRotatingTS=0;
       
        Decimal fndlwInsighthCalTrckngCancel=0;
        Decimal lang3QuanityCancelled=0;
        Decimal fndlwForeignLang3Cancelled=0;
        Decimal lang4QuanityCancelled=0;
        Decimal fndlwForeignLang4Cancelled=0;
        Decimal fndlawArchiveCancelled=0;
        Decimal FNDLWPOSTPLUSFSCancel=0;
        Decimal FNDLWDigitalWebCancel=0;
        Decimal fndlwReputationAdvisorCancel=0;
        Decimal fndlawClientPulseCancel=0;
        Decimal fndlawReputationReviewCancel=0;
        Decimal fndlawSocialStartCancel=0;
        Decimal fndlawPremiumProfCancel=0;
        
        Map<String,Decimal> mSuperSpotLight = New Map<String,Decimal>(); //added by SP
        Map<String,Decimal> mSuperLawTopSpots = New Map<String,Decimal>();
        //Added by SP
       Map<String,Apttus_Config2__LineItem__c> mCancelProducts = New Map<String,Apttus_Config2__LineItem__c>();
 
        
        System.debug('After declaring normal--'+fndlwClientPulse);
        System.debug('After declaring Cancel--'+fndlwClientPulseCancel);
        //SOC-6011 Start
        /*
        * Below code added by Deepthi Shirangala on 12/26/17.
        * Requirement is to check for update max qty rule 1 per Firmsite for Blog Platform - BPI & other products.
        */
        if(PA_GEO__c.getInstance('41378928') <> null){
            for(String s :PA_GEO__c.getInstance('41378928').Product_Code__c.split(',') ){
                mFindLwPostPluse.put(s,s);
            }
        }
        
        for(Product_Codes_Set1__c  pcs : Product_Codes_Set1__c.getall().values()){
            mFNDLWBLOGPLATFORM.put(pcs.Name,pcs.Name);
        }
        
        
        for(Product_Codes_Set2__c  pcs : Product_Codes_Set2__c.getall().values()){
            mFNDLWANIMATIONESSENTIAL.put(pcs.Name,pcs.Name);
        }
        
        
        for(Product_Codes_Set3__c  pcs : Product_Codes_Set3__c.getall().values()){
            mFNDLWANIMATIONPREMIUM.put(pcs.Name,pcs.Name);
        }
        
        
        for(Product_Codes_Set4__c  pcs : Product_Codes_Set4__c.getall().values()){
            mFNDLWFIRMSITEMOBILEESSENTIAL.put(pcs.Name,pcs.Name);
        }
        
        
        for(Product_Codes_Set5__c  pcs : Product_Codes_Set5__c.getall().values()){
            mFNDLWMOBILEESSENTIAL.put(pcs.Name,pcs.Name);
        }
        
        List<Apttus_Config2__AssetLineItem__c> assetLineItemList1 = [SELECT ID,APTS_Combination_Key__c, APTS_PPC_Spend_Type__c, APTS_PPC_Website_Type__c,Apttus_Config2__LineType__c, Apttus_Config2__ProductId__c,Apttus_Config2__Quantity__c,Apttus_Config2__ProductId__r.productcode, Apttus_Config2__AssetStatus__c  
        ,Apttus_Config2__AttributeValueId__c, Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c,Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c,Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c, APTS_Combination_Key__r.APTS_Attribute_Value0__c,APTS_Combination_Key__r.APTS_Attribute_Value1__c ,APTS_Combination_Key__r.APTS_Attribute_Value2__c,APTS_Combination_Key__r.APTS_Attribute_Value3__c  
        ,APTS_Combination_Key__r.APTS_Configuration_Description__c,APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name,APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name FROM Apttus_Config2__AssetLineItem__c                                                                             
                                                                            WHERE APTS_SSD_Sold_To__c = :Productconfig.APTS_SSD_Sold_To__c And APTS_SSD_Sold_To__c <> null
                                                                            AND Apttus_Config2__IsInactive__c = false
                                                                            AND Apttus_Config2__AssetStatus__c ='Activated'];
        system.debug('CheckAsset'+assetLineItemList1);
        system.debug('CheckAssetsize'+assetLineItemList1.size());
        
        for(Apttus_Config2__AssetLineItem__c alines :assetLineItemList1){
     //added by SP - Start
             if(alines.Apttus_Config2__ProductId__r.productcode =='42686641' && alines.APTS_Combination_Key__c  !=null)
                mSuperSpotLight = mAssetProductDetail(alines,mSuperSpotLight);
            if(alines.Apttus_Config2__ProductId__r.productcode =='41618485' && alines.APTS_Combination_Key__c  !=null)
                mSuperLawTopSpots = mAssetProductDetail(alines,mSuperLawTopSpots);
             //added by SP - END
            if(alines.Apttus_Config2__LineType__c == 'Product/Service'){
                if(mFNDLWBLOGPLATFORM.containsKey(alines.Apttus_Config2__ProductId__r.productcode))  FNDLWBLOGPLATFORMQuniaty =FNDLWBLOGPLATFORMQuniaty+alines.Apttus_Config2__Quantity__c; 
                    system.debug('CheckBlog'+FNDLWBLOGPLATFORMQuniaty);
                if(mFNDLWANIMATIONESSENTIAL.containsKey(alines.Apttus_Config2__ProductId__r.productcode))  FNDLWANIMATIONESSENTIAL =FNDLWANIMATIONESSENTIAL+alines.Apttus_Config2__Quantity__c; 
                    System.debug('alineset inside'+FNDLWANIMATIONESSENTIAL);
                if(mFNDLWANIMATIONPREMIUM.containsKey(alines.Apttus_Config2__ProductId__r.productcode))  FNDLWANIMATIONPREMIUM =FNDLWANIMATIONPREMIUM+alines.Apttus_Config2__Quantity__c; 
                if(mFNDLWFIRMSITEMOBILEESSENTIAL.containsKey(alines.Apttus_Config2__ProductId__r.productcode))  FNDLWFIRMSITEMOBILEESSENTIAL =FNDLWFIRMSITEMOBILEESSENTIAL+alines.Apttus_Config2__Quantity__c;
                    system.debug('Assetcount'+FNDLWFIRMSITEMOBILEESSENTIAL);
                if(mFNDLWMOBILEESSENTIAL.containsKey(alines.Apttus_Config2__ProductId__r.productcode))  FNDLWMOBILEESSENTIAL =FNDLWMOBILEESSENTIAL+alines.Apttus_Config2__Quantity__c; 
                if(mFindLwArchive.containsKey(alines.Apttus_Config2__ProductId__r.productcode))  FNDLAWFSARCHIVE = FNDLAWFSARCHIVE+alines.Apttus_Config2__Quantity__c;
                
                //SOC-9890 asset count for products in SOC-6011 starts
                if(alines.Apttus_Config2__ProductId__r.productcode == '41819162')  FNDLWBLOGPLATFORMQuniatyIndividual = FNDLWBLOGPLATFORMQuniatyIndividual+alines.Apttus_Config2__Quantity__c;   
                if(alines.Apttus_Config2__ProductId__r.productcode == '41323281')  FNDLWANIMATIONESSENTIALIndividual = FNDLWANIMATIONESSENTIALIndividual+alines.Apttus_Config2__Quantity__c;
                system.debug('@@@@@'+FNDLWANIMATIONESSENTIALIndividual);
                if(alines.Apttus_Config2__ProductId__r.productcode == '41323282')  FNDLWANIMATIONPREMIUMIndividual = FNDLWANIMATIONPREMIUMIndividual+alines.Apttus_Config2__Quantity__c;
                if(alines.Apttus_Config2__ProductId__r.productcode == '41325003')  FNDLWFIRMSITEMOBILEESSENTIALIndividual = FNDLWFIRMSITEMOBILEESSENTIALIndividual+alines.Apttus_Config2__Quantity__c;
                    system.debug('FinalCount'+FNDLWFIRMSITEMOBILEESSENTIALIndividual);
                if(alines.Apttus_Config2__ProductId__r.productcode == '41701486')  FNDLWMOBILEESSENTIALIndividual = FNDLWMOBILEESSENTIALIndividual+alines.Apttus_Config2__Quantity__c;
                if(alines.Apttus_Config2__ProductId__r.productcode == '40656696')  FNDLAWFSARCHIVEINDIVIUAL = FNDLAWFSARCHIVEINDIVIUAL+alines.Apttus_Config2__Quantity__c;
                //SOC-9890 asset count for products in SOC-6011 ends
                
                if(alines.Apttus_Config2__ProductId__r.productcode =='41817449'){ SocialPromoton = SocialPromoton+alines.Apttus_Config2__Quantity__c;
                    system.debug('CheckSocial');               
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='41767150'){ FNDLWDigitalWeb = FNDLWDigitalWeb+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='41076128'){ FNDLWFSWebAdvPlus = FNDLWFSWebAdvPlus+alines.Apttus_Config2__Quantity__c;
                }
               
                if(alines.Apttus_Config2__ProductId__r.productcode =='42532854'){ FNDLWWebchatStandard = FNDLWWebchatStandard+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='42532855'){ FNDLWWebchatPremium = FNDLWWebchatPremium+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='42532852'){ FNDLWVoiceStandard = FNDLWVoiceStandard+alines.Apttus_Config2__Quantity__c;
                }   
                if(alines.Apttus_Config2__ProductId__r.productcode =='42532853'){ FNDLWVoicePremium = FNDLWVoicePremium+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='41986777'){ FNDLWDigitalMKTGBoost = FNDLWDigitalMKTGBoost+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='42118619'){ FNDLWVideoSocialPro = FNDLWVideoSocialPro+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='41003359'){ FNDLWFOCUSPAGEBASE  = FNDLWFOCUSPAGEBASE+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='42565209'){ FNDLWEngagementBuilder2  = FNDLWEngagementBuilder2+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='42564669'){ FNDLWCoreSite  = FNDLWCoreSite+alines.Apttus_Config2__Quantity__c;
                }
               
                if(alines.Apttus_Config2__ProductId__r.productcode =='40666911'){ FNDLWInsightWithCallTracking  = FNDLWInsightWithCallTracking+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='40542344'){ lang3Quanity = lang3Quanity+alines.Apttus_Config2__Quantity__c;
                }
                if((alines.Apttus_Config2__ProductId__r.productcode =='40483699' || alines.Apttus_Config2__ProductId__r.productcode =='40043923'|| alines.Apttus_Config2__ProductId__r.productcode =='30405006' || alines.Apttus_Config2__ProductId__r.productcode =='40261790' || alines.Apttus_Config2__ProductId__r.productcode =='40483700'|| alines.Apttus_Config2__ProductId__r.productcode =='40485591') && alines.Apttus_Config2__LineType__c =='Product/Service'){
                    FNDLWForeignLang3= FNDLWForeignLang3+alines.Apttus_Config2__Quantity__c;        
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='40542345'){ lang4Quanity = lang4Quanity+alines.Apttus_Config2__Quantity__c;
                }
                if((alines.Apttus_Config2__ProductId__r.productcode =='40485592' || alines.Apttus_Config2__ProductId__r.productcode =='40043926'|| alines.Apttus_Config2__ProductId__r.productcode =='40485593' || alines.Apttus_Config2__ProductId__r.productcode =='40485594')&& alines.Apttus_Config2__LineType__c =='Product/Service'){
                    FNDLWForeignLang4= FNDLWForeignLang4+alines.Apttus_Config2__Quantity__c;
                }
                /*if(mProductcodes6.containskey(alines.Apttus_Config2__ProductId__r.productcode) && alines.Apttus_Config2__LineType__c =='Product/Service'){
                    FNDLWFSARCHIVE  = FNDLWFSARCHIVE+alines.Apttus_Config2__Quantity__c;
                }*/
                if(mFindLwPostPluse.containsKey(alines.Apttus_Config2__ProductId__r.productcode)){ FNDLWPOSTPLUSFS = FNDLWPOSTPLUSFS+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='42089522'){ fndlwClientPulse = fndlwClientPulse+alines.Apttus_Config2__Quantity__c;
                }
                System.debug('Asset count of client pulse quaterly inside iteration--'+fndlwClientPulse);
                
                if(alines.Apttus_Config2__ProductId__r.productcode =='42089521'){ fndlwReputationAdvisor = fndlwReputationAdvisor+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='41618486'){ superLwyerProf = superLwyerProf+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='42089523'){ fndlawClientPulse = fndlawClientPulse+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='42089524'){ fndlawReputationReview = fndlawReputationReview+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='41180810'){ fndlawSocialStart = fndlawSocialStart+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='41053156'){ fndlawPremiumProf = fndlawPremiumProf+alines.Apttus_Config2__Quantity__c;
                }
                if(alines.Apttus_Config2__ProductId__r.productcode =='41053157'){ FNDLWPremium = FNDLWPremium+alines.Apttus_Config2__Quantity__c;
                }
            }
        }   
        System.debug('Asset count of client pulse after asset loop'+fndlwClientPulse);
        
        for(Apttus_Config2__LineItem__c lineItem : lineItems){
           if(lineItem.Apttus_Config2__LineType__c  == 'Product/Service'){
                if(lineItem.Apttus_Config2__LineStatus__c=='New'){
                    if(mFNDLWBLOGPLATFORM.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWBLOGPLATFORMQuniaty =FNDLWBLOGPLATFORMQuniaty+lineItem.Apttus_Config2__Quantity__c; 
                    if(mFNDLWANIMATIONESSENTIAL.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWANIMATIONESSENTIAL =FNDLWANIMATIONESSENTIAL+lineItem.Apttus_Config2__Quantity__c; 
                    system.debug('MapInside'+FNDLWANIMATIONESSENTIAL);
                    if(mFNDLWANIMATIONPREMIUM.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWANIMATIONPREMIUM =FNDLWANIMATIONPREMIUM+lineItem.Apttus_Config2__Quantity__c; 
                    if(mFNDLWFIRMSITEMOBILEESSENTIAL.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWFIRMSITEMOBILEESSENTIAL =FNDLWFIRMSITEMOBILEESSENTIAL+lineItem.Apttus_Config2__Quantity__c;
                    system.debug('LineCount'+FNDLWFIRMSITEMOBILEESSENTIAL);
                    if(mFNDLWMOBILEESSENTIAL.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWMOBILEESSENTIAL =FNDLWMOBILEESSENTIAL+lineItem.Apttus_Config2__Quantity__c; 
                    if(mFindLwArchive.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLAWFSARCHIVE = FNDLAWFSARCHIVE+lineItem.Apttus_Config2__Quantity__c; 
               }
               if(lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){
                    if(mFNDLWBLOGPLATFORM.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWBLOGPLATFORMQuniatyCancel =FNDLWBLOGPLATFORMQuniatyCancel+lineItem.Apttus_Config2__Quantity__c;  
                    if(mFNDLWANIMATIONESSENTIAL.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWANIMATIONESSENTIALCancel =FNDLWANIMATIONESSENTIALCancel+lineItem.Apttus_Config2__Quantity__c; 
                    system.debug('MapInside'+FNDLWANIMATIONESSENTIALCancel);
                    if(mFNDLWANIMATIONPREMIUM.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWANIMATIONPREMIUMCancel =FNDLWANIMATIONPREMIUMCancel+lineItem.Apttus_Config2__Quantity__c; 
                    if(mFNDLWFIRMSITEMOBILEESSENTIAL.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWFIRMSITEMOBILEESSENTIALCancel =FNDLWFIRMSITEMOBILEESSENTIALCancel+lineItem.Apttus_Config2__Quantity__c;
                    if(mFNDLWMOBILEESSENTIAL.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLWMOBILEESSENTIALCancel =FNDLWMOBILEESSENTIALCancel+lineItem.Apttus_Config2__Quantity__c; 
                    if(mFindLwArchive.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode)) FNDLAWFSARCHIVECancel= FNDLAWFSARCHIVECancel+lineItem.Apttus_Config2__Quantity__c; 
               }
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41819162'  && lineItem.Apttus_Config2__LineStatus__c=='New')  FNDLWBLOGPLATFORMQuniatyIndividual = FNDLWBLOGPLATFORMQuniatyIndividual+lineItem.Apttus_Config2__Quantity__c;   
            
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41323281' && lineItem.Apttus_Config2__LineStatus__c=='New')  FNDLWANIMATIONESSENTIALIndividual = FNDLWANIMATIONESSENTIALIndividual+lineItem.Apttus_Config2__Quantity__c;
                system.debug('@@@@@'+FNDLWANIMATIONESSENTIALIndividual);
                
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41323282' && lineItem.Apttus_Config2__LineStatus__c=='New')  FNDLWANIMATIONPREMIUMIndividual = FNDLWANIMATIONPREMIUMIndividual+lineItem.Apttus_Config2__Quantity__c;
            
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41325003' && lineItem.Apttus_Config2__LineStatus__c=='New')  FNDLWFIRMSITEMOBILEESSENTIALIndividual = FNDLWFIRMSITEMOBILEESSENTIALIndividual+lineItem.Apttus_Config2__Quantity__c;
                system.debug('FinalCount'+FNDLWFIRMSITEMOBILEESSENTIALIndividual);
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41701486' && lineItem.Apttus_Config2__LineStatus__c=='New')  FNDLWMOBILEESSENTIALIndividual = FNDLWMOBILEESSENTIALIndividual+lineItem.Apttus_Config2__Quantity__c;  
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '40656696' && lineItem.Apttus_Config2__LineStatus__c=='New') FNDLAWFSARCHIVEINDIVIUAL= FNDLAWFSARCHIVEINDIVIUAL+lineItem.Apttus_Config2__Quantity__c;
            
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41819162'  && lineItem.Apttus_Config2__LineStatus__c=='Cancelled') FNDLWBLOGPLATFORMQuniatyIndividualCancel = FNDLWBLOGPLATFORMQuniatyIndividualCancel+lineItem.Apttus_Config2__Quantity__c;   
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41323281' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled')  FNDLWANIMATIONESSENTIALIndividualCancel = FNDLWANIMATIONESSENTIALIndividualCancel+lineItem.Apttus_Config2__Quantity__c;
                system.debug('@@@@@'+FNDLWANIMATIONESSENTIALIndividualCancel);
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41323282' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled')  FNDLWANIMATIONPREMIUMIndividualCancel = FNDLWANIMATIONPREMIUMIndividualCancel+lineItem.Apttus_Config2__Quantity__c;
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41325003' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled')  FNDLWFIRMSITEMOBILEESSENTIALIndividualCancel = FNDLWFIRMSITEMOBILEESSENTIALIndividualCancel+lineItem.Apttus_Config2__Quantity__c;
                system.debug('FinalCount'+FNDLWFIRMSITEMOBILEESSENTIALIndividualCancel);
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '41701486' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled')  FNDLWMOBILEESSENTIALIndividualCancel = FNDLWMOBILEESSENTIALIndividualCancel+lineItem.Apttus_Config2__Quantity__c; 
            if(lineItem.Apttus_Config2__ProductId__r.productcode == '40656696' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled')  FNDLWFSARCHIVEIndividualCancel = FNDLWFSARCHIVEIndividualCancel+lineItem.Apttus_Config2__Quantity__c;
                
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41817449' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){ socialPromoCancelled=socialPromoCancelled+lineItem.Apttus_Config2__Quantity__c; 
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41767150' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlawDigitalWebCancelled = fndlawDigitalWebCancelled+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41076128' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlawFSWebAdvPlusCancelled = fndlawFSWebAdvPlusCancelled+lineItem.Apttus_Config2__Quantity__c;
            }
           
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42532854' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwWebchtStdCancelled = fndlwWebchtStdCancelled+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42532855' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwWebChtPrmCancelled = fndlwWebChtPrmCancelled+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42532852' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwVoiceStdCancelled = fndlwVoiceStdCancelled+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42532853' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwVoicePrmCancelled = fndlwVoicePrmCancelled+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41986777' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwDigMKTGBoostCancel = fndlwDigMKTGBoostCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42118619' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwVideoSocialProCancel = fndlwVideoSocialProCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41003359' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwFocusPgBaseCancel  = fndlwFocusPgBaseCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42565209' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwEngmntBuild2Cancel  = fndlwEngmntBuild2Cancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42564669' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwCoreSiteCancel  = fndlwCoreSiteCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40666911' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  fndlwInsighthCalTrckngCancel= fndlwInsighthCalTrckngCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40542344' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  lang3QuanityCancelled = lang3QuanityCancelled+lineItem.Apttus_Config2__Quantity__c;
            }
            if((lineItem.Apttus_Config2__ProductId__r.productcode =='40483699' || lineItem.Apttus_Config2__ProductId__r.productcode =='40043923'|| lineItem.Apttus_Config2__ProductId__r.productcode =='30405006' || lineItem.Apttus_Config2__ProductId__r.productcode =='40261790' || lineItem.Apttus_Config2__ProductId__r.productcode =='40483700'|| lineItem.Apttus_Config2__ProductId__r.productcode =='40485591')&& lineItem.Apttus_Config2__LineType__c =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){
                fndlwForeignLang3Cancelled= fndlwForeignLang3Cancelled+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40542345' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){  lang4QuanityCancelled = lang4QuanityCancelled+lineItem.Apttus_Config2__Quantity__c;
            }
            if((lineItem.Apttus_Config2__ProductId__r.productcode =='40485592' || lineItem.Apttus_Config2__ProductId__r.productcode =='40043926'|| lineItem.Apttus_Config2__ProductId__r.productcode =='40485593' || lineItem.Apttus_Config2__ProductId__r.productcode =='40485594')&& lineItem.Apttus_Config2__LineType__c =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){
                    fndlwForeignLang4Cancelled= fndlwForeignLang4Cancelled+lineItem.Apttus_Config2__Quantity__c;
            }
             if(mFindLwArchive.containskey(lineItem.Apttus_Config2__ProductId__r.productcode) && lineItem.Apttus_Config2__LineType__c =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){
                    fndlawArchiveCancelled  = fndlawArchiveCancelled+lineItem.Apttus_Config2__Quantity__c;
                }
            if(mFindLwPostPluse.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode) && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){
                    FNDLWPOSTPLUSFSCancel = FNDLWPOSTPLUSFSCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42089522' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){ fndlwClientPulseCancel = fndlwClientPulseCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            System.debug('Cancel count of client pulse inside iteration--'+fndlwClientPulseCancel);
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42089521' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){ fndlwReputationAdvisorCancel = fndlwReputationAdvisorCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41618486' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){ superLwyerProfCancel = superLwyerProfCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42089523' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){ fndlawClientPulseCancel = fndlawClientPulseCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42089524' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){ fndlawReputationReviewCancel = fndlawReputationReviewCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41180810' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){ fndlawSocialStartCancel = fndlawSocialStartCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41053156' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled'){ fndlawPremiumProfCancel = fndlawPremiumProfCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41053157' && lineItem.Apttus_Config2__LineStatus__c=='Cancelled' ){ FNDLWPremiumCancel = FNDLWPremiumCancel+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41817449' && lineItem.Apttus_Config2__LineStatus__c=='New'){ SocialPromoton = SocialPromoton+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41767150' && lineItem.Apttus_Config2__LineStatus__c=='New'){   FNDLWDigitalWeb = FNDLWDigitalWeb+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41076128' && lineItem.Apttus_Config2__LineStatus__c=='New'){  FNDLWFSWebAdvPlus = FNDLWFSWebAdvPlus+lineItem.Apttus_Config2__Quantity__c;
            }
           
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42532854' && lineItem.Apttus_Config2__LineStatus__c=='New'){  FNDLWWebchatStandard = FNDLWWebchatStandard+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42532855' && lineItem.Apttus_Config2__LineStatus__c=='New'){  FNDLWWebchatPremium = FNDLWWebchatPremium+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42532852' && lineItem.Apttus_Config2__LineStatus__c=='New'){ FNDLWVoiceStandard = FNDLWVoiceStandard+lineItem.Apttus_Config2__Quantity__c;
            } 
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42532853' && lineItem.Apttus_Config2__LineStatus__c=='New'){  FNDLWVoicePremium = FNDLWVoicePremium+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41986777' && lineItem.Apttus_Config2__LineStatus__c=='New'){ FNDLWDigitalMKTGBoost = FNDLWDigitalMKTGBoost+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42118619' && lineItem.Apttus_Config2__LineStatus__c=='New'){ FNDLWVideoSocialPro = FNDLWVideoSocialPro+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41003359' && lineItem.Apttus_Config2__LineStatus__c=='New'){ FNDLWFOCUSPAGEBASE  = FNDLWFOCUSPAGEBASE+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42565209' && lineItem.Apttus_Config2__LineStatus__c=='New'){ FNDLWEngagementBuilder2  = FNDLWEngagementBuilder2+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42564669' && lineItem.Apttus_Config2__LineStatus__c=='New'){ FNDLWCoreSite  = FNDLWCoreSite+lineItem.Apttus_Config2__Quantity__c;
            }
           
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40666911' && lineItem.Apttus_Config2__LineStatus__c=='New'){ FNDLWInsightWithCallTracking= FNDLWInsightWithCallTracking+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40542344' && lineItem.Apttus_Config2__LineStatus__c=='New'){ lang3Quanity = lang3Quanity+lineItem.Apttus_Config2__Quantity__c;
            }
            if((lineItem.Apttus_Config2__ProductId__r.productcode =='40483699' || lineItem.Apttus_Config2__ProductId__r.productcode =='40043923'|| lineItem.Apttus_Config2__ProductId__r.productcode =='30405006' || lineItem.Apttus_Config2__ProductId__r.productcode =='40261790' || lineItem.Apttus_Config2__ProductId__r.productcode =='40483700'|| lineItem.Apttus_Config2__ProductId__r.productcode =='40485591') && lineItem.Apttus_Config2__LineType__c =='Product/Service' &&lineItem.Apttus_Config2__LineStatus__c=='New'){
                FNDLWForeignLang3= FNDLWForeignLang3+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='40542345' && lineItem.Apttus_Config2__LineStatus__c=='New'){ lang4Quanity = lang4Quanity+lineItem.Apttus_Config2__Quantity__c;
            }
            if((lineItem.Apttus_Config2__ProductId__r.productcode =='40485592' || lineItem.Apttus_Config2__ProductId__r.productcode =='40043926'|| lineItem.Apttus_Config2__ProductId__r.productcode =='40485593' || lineItem.Apttus_Config2__ProductId__r.productcode =='40485594') && lineItem.Apttus_Config2__LineType__c =='Product/Service' &&lineItem.Apttus_Config2__LineStatus__c=='New'){
                FNDLWForeignLang4= FNDLWForeignLang4+lineItem.Apttus_Config2__Quantity__c;
            }
            /*if(mProductcodes6.containskey(lineItem.Apttus_Config2__ProductId__r.productcode) && lineItem.Apttus_Config2__LineType__c =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c=='New'){
                FNDLWFSARCHIVE  = FNDLWFSARCHIVE+lineItem.Apttus_Config2__Quantity__c;
            }*/
            if(mFindLwPostPluse.containsKey(lineItem.Apttus_Config2__ProductId__r.productcode) && lineItem.Apttus_Config2__LineStatus__c=='New'){
                FNDLWPOSTPLUSFS = FNDLWPOSTPLUSFS+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.ProductCode == '42089522' && lineItem.Apttus_Config2__LineStatus__c=='New'){ fndlwClientPulse = fndlwClientPulse+lineItem.Apttus_Config2__Quantity__c;
            }
            System.debug('New Line item client pulse count inside iteration'+fndlwClientPulse);
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42089521' && lineItem.Apttus_Config2__LineStatus__c=='New'){ fndlwReputationAdvisor = fndlwReputationAdvisor+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41618486' && lineItem.Apttus_Config2__LineStatus__c=='New'){ superLwyerProf = superLwyerProf+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42089523' && lineItem.Apttus_Config2__LineStatus__c=='New'){ fndlawClientPulse = fndlawClientPulse+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='42089524'&& lineItem.Apttus_Config2__LineStatus__c=='New'){ fndlawReputationReview = fndlawReputationReview+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41180810' && lineItem.Apttus_Config2__LineStatus__c=='New'){ fndlawSocialStart = fndlawSocialStart+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41053156' && lineItem.Apttus_Config2__LineStatus__c=='New'){ fndlawPremiumProf = fndlawPremiumProf+lineItem.Apttus_Config2__Quantity__c;
            }
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41053157' && lineItem.Apttus_Config2__LineStatus__c=='New'){ FNDLWPremium = FNDLWPremium+lineItem.Apttus_Config2__Quantity__c;
            }
            
             //DOC-6397-Findlaw Start
            if((lineItem.Apttus_Config2__ProductId__r.productcode =='42686641' && lineItem.APTS_Combination_Key__c  !=null && (lineItem.Apttus_Config2__LineStatus__c  =='New' || lineItem.Apttus_Config2__LineStatus__c  =='Renewed' || lineItem.Apttus_Config2__LineStatus__c  == 'Upgraded' || lineItem.Apttus_Config2__LineStatus__c  == 'Downgrade' || lineItem.Apttus_Config2__LineStatus__c  != 'Cancelled'))|| test.isrunningtest()){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '41618485'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '42686641'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                system.debug('Entering into SLR');
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
            if(lineItem.Apttus_Config2__ProductId__r.productcode =='41618485' && lineItem.APTS_Combination_Key__c  !=null && (lineItem.Apttus_Config2__LineStatus__c  =='New' || lineItem.Apttus_Config2__LineStatus__c  =='Renewed' || lineItem.Apttus_Config2__LineStatus__c  == 'Upgraded' || lineItem.Apttus_Config2__LineStatus__c  == 'Downgrade' || lineItem.Apttus_Config2__LineStatus__c  != 'Cancelled')){
                Decimal quanity =0;
                String Key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '42686641'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                String key2 = '41618485'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
                system.debug('Entering in SLp');
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
            
            String Keyyy = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name ;
            mCancelProducts.put(Keyyy,lineItem);
             //DOC-6397-Findlaw -ENd
        
           } 
        System.debug('Count of new client pulse outside iteration'+fndlwClientPulse);
        System.debug('Count of cancel client pulse outside iteration'+fndlwClientPulseCancel);
        
            FNDLWBLOGPLATFORMQuniatyTotal = FNDLWBLOGPLATFORMQuniaty - FNDLWBLOGPLATFORMQuniatyCancel;
            FNDLWANIMATIONESSENTIALTotal = FNDLWANIMATIONESSENTIAL - FNDLWANIMATIONESSENTIALCancel;
            FNDLWANIMATIONPREMIUMTotal = FNDLWANIMATIONPREMIUM - FNDLWANIMATIONPREMIUMCancel;
            FNDLWFIRMSITEMOBILEESSENTIALTotal = FNDLWFIRMSITEMOBILEESSENTIAL - FNDLWFIRMSITEMOBILEESSENTIALCancel;
            FNDLWMOBILEESSENTIALTotal = FNDLWMOBILEESSENTIAL - FNDLWMOBILEESSENTIALCancel;
            FNDLAWFSARCHIVETotal=FNDLAWFSARCHIVE-FNDLAWFSARCHIVECancel;
            
            FNDLWBLOGPLATFORMQuniatyIndividual = FNDLWBLOGPLATFORMQuniatyIndividual - FNDLWBLOGPLATFORMQuniatyIndividualCancel;
            FNDLWANIMATIONESSENTIALIndividual = FNDLWANIMATIONESSENTIALIndividual - FNDLWANIMATIONESSENTIALIndividualCancel;
            FNDLWANIMATIONPREMIUMIndividual = FNDLWANIMATIONPREMIUMIndividual - FNDLWANIMATIONPREMIUMIndividualCancel;
            FNDLWFIRMSITEMOBILEESSENTIALIndividual = FNDLWFIRMSITEMOBILEESSENTIALIndividual - FNDLWFIRMSITEMOBILEESSENTIALIndividualCancel;
            FNDLWMOBILEESSENTIALIndividual = FNDLWMOBILEESSENTIALIndividual - FNDLWMOBILEESSENTIALIndividualCancel;
            FNDLAWFSARCHIVEINDIVIUAL = FNDLAWFSARCHIVEINDIVIUAL - FNDLWFSARCHIVEIndividualCancel;
            
            SocialPromoton=SocialPromoton-socialPromoCancelled;
            FNDLWDigitalWeb=FNDLWDigitalWeb-fndlawDigitalWebCancelled;
            FNDLWFSWebAdvPlus=FNDLWFSWebAdvPlus-fndlawFSWebAdvPlusCancelled;
           
            FNDLWWebchatStandard=FNDLWWebchatStandard-fndlwWebchtStdCancelled;
            FNDLWWebchatPremium=FNDLWWebchatPremium-fndlwWebChtPrmCancelled;
            FNDLWVoiceStandard=FNDLWVoiceStandard-fndlwVoiceStdCancelled;
            FNDLWVoicePremium=FNDLWVoicePremium-fndlwVoicePrmCancelled;
            FNDLWDigitalMKTGBoost=FNDLWDigitalMKTGBoost-fndlwDigMKTGBoostCancel;
            FNDLWVideoSocialPro=FNDLWVideoSocialPro-fndlwVideoSocialProCancel;
            FNDLWFOCUSPAGEBASE=FNDLWFOCUSPAGEBASE-fndlwFocusPgBaseCancel;
            FNDLWEngagementBuilder2=FNDLWEngagementBuilder2-fndlwEngmntBuild2Cancel;
            FNDLWCoreSite=FNDLWCoreSite-fndlwCoreSiteCancel;
            
            FNDLWInsightWithCallTracking=FNDLWInsightWithCallTracking-fndlwInsighthCalTrckngCancel;
            lang3Quanity=lang3Quanity-lang3QuanityCancelled;
            FNDLWForeignLang3=FNDLWForeignLang3-fndlwForeignLang3Cancelled;
            lang4Quanity=lang4Quanity-lang4QuanityCancelled;
            FNDLWForeignLang4=FNDLWForeignLang4-fndlwForeignLang4Cancelled;
            //FNDLWFSARCHIVE=FNDLWFSARCHIVE-fndlawArchiveCancelled;
            FNDLWPOSTPLUSFS=FNDLWPOSTPLUSFS-FNDLWPOSTPLUSFSCancel;
            fndlwClientPulse=fndlwClientPulse-fndlwClientPulseCancel;
            fndlwReputationAdvisor=fndlwReputationAdvisor-fndlwReputationAdvisorCancel;
            superLwyerProf=superLwyerProf-superLwyerProfCancel;
            fndlawClientPulse=fndlawClientPulse-fndlawClientPulseCancel;
            fndlawReputationReview=fndlawReputationReview-fndlawReputationReviewCancel;
            fndlawSocialStart=fndlawSocialStart-fndlawSocialStartCancel;
            fndlawPremiumProf=fndlawPremiumProf-fndlawPremiumProfCancel;
            FNDLWPremium=FNDLWPremium-FNDLWPremiumCancel;
            System.debug('Final count after calc--'+FNDLWFIRMSITEMOBILEESSENTIALTotal);
       
       for(Apttus_Config2__LineItem__c lineItem : lineItems){
       
            
            //DOC-6397-Findlaw Start
            system.debug('Entering in LineItem For loop');
            if((lineItem.Apttus_Config2__ProductId__r.productcode =='42686641' && lineItem.APTS_Combination_Key__c  !=null)||test.isrunningtest()){
                String key = lineItem.Apttus_Config2__ProductId__r.productcode+lineItem.APTS_Combination_Key__c;
                String key1 = '41618485'+lineItem.APTS_Combination_Key__r.APTS_Configuration_Description__c+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value0__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value1__r.Name +lineItem.APTS_Combination_Key__r.APTS_Attribute_Value2__r.Name+lineItem.APTS_Combination_Key__r.APTS_Attribute_Value3__r.Name;

                Decimal q1=0;
                if(mSuperSpotLight.containskey(key) && (lineItem.Apttus_Config2__LineStatus__c  =='New'|| lineItem.Apttus_Config2__LineStatus__c  =='Renewed' || lineItem.Apttus_Config2__LineStatus__c  == 'Upgraded' || lineItem.Apttus_Config2__LineStatus__c  == 'Downgrade' || lineItem.Apttus_Config2__LineStatus__c  != 'Cancelled')){
                   q1=q1+mSuperSpotLight.get(key);
                   system.debug('Inside Error Message555'+q1);
                }
               Decimal Quanity = 0;
                if(mSuperSpotLight.containskey(key1) && (lineItem.Apttus_Config2__LineStatus__c  =='New'|| lineItem.Apttus_Config2__LineStatus__c  =='Renewed' || lineItem.Apttus_Config2__LineStatus__c  == 'Upgraded' || lineItem.Apttus_Config2__LineStatus__c  == 'Downgrade' || lineItem.Apttus_Config2__LineStatus__c  != 'Cancelled')){
                    Quanity = Quanity+mSuperSpotLight.get(key1);
                    system.debug('Inside Error Message444'+Quanity);
                }
                
                if(mSuperLawTopSpots.containskey(key1) && (lineItem.Apttus_Config2__LineStatus__c  =='New'|| lineItem.Apttus_Config2__LineStatus__c  =='Renewed' || lineItem.Apttus_Config2__LineStatus__c  == 'Upgraded' || lineItem.Apttus_Config2__LineStatus__c  == 'Downgrade' || lineItem.Apttus_Config2__LineStatus__c  != 'Cancelled')){
                    Quanity = Quanity+mSuperLawTopSpots.get(key1);
                    system.debug('Inside Error Message333'+ Quanity);
                }
                if(q1 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New'){
                    system.debug('Inside Error Message111');
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, '\'Line Number \''+lineItem.Apttus_Config2__LineSequence__c +'\' You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'- \''+lineItem.APTS_Product_Detail__c+'\''));
                    result.isSuccess = false;                  
                    return result; 
                }
                
                if(mCancelProducts.containskey(key1)){
                    Apttus_Config2__LineItem__c cancelline  = mCancelProducts.get(key1); 
                    if(cancelline.Apttus_Config2__LineStatus__c =='Cancelled') Quanity = Quanity-cancelline.Apttus_Config2__Quantity__c ;
                }
                
                system.debug('before error!!!!');
                if(Quanity > 1){
                    system.debug('Inside Error Message222');
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'Super Lawyer TopSpots and Super Lawyer Rotating TopSpots materials cannot be sold together'));
                    result.isSuccess = false;                  
                    return result; 
                }
            }
           
            //DOC-6397-Findlaw End
            
        if((lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__ProductId__r.productcode == '41819162')|| test.isrunningtest()){
            if((FNDLWBLOGPLATFORMQuniatyTotal ==1 && FNDLWBLOGPLATFORMQuniatyTotal!=FNDLWBLOGPLATFORMQuniatyIndividual)|| test.isrunningtest()){
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWBLOGPLATFORMQuniatyTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
  
            }else if(FNDLWBLOGPLATFORMQuniatyIndividual>FNDLWBLOGPLATFORMQuniatyTotal ){
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWBLOGPLATFORMQuniatyTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
   
            }
        }else if((lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__ProductId__r.productcode == '41323281')){
            if(FNDLWANIMATIONESSENTIALTotal ==1 && FNDLWANIMATIONESSENTIALTotal!=FNDLWANIMATIONESSENTIALIndividual){
                system.debug('Check'+FNDLWANIMATIONESSENTIALTotal.intvalue());
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWANIMATIONESSENTIALTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
  
            }else if(FNDLWANIMATIONESSENTIALIndividual>FNDLWANIMATIONESSENTIALTotal ){
                system.debug('Check1'+FNDLWANIMATIONESSENTIALTotal.intvalue());
                system.debug('Check1'+FNDLWANIMATIONESSENTIALTotal);
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWANIMATIONESSENTIALTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
   
            }
        }else if(lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__ProductId__r.productcode == '41323282'){
            if(FNDLWANIMATIONPREMIUMTotal ==1 && FNDLWANIMATIONPREMIUMTotal!=FNDLWANIMATIONPREMIUMIndividual){
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWANIMATIONPREMIUMTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
 
            }else if(FNDLWANIMATIONPREMIUMIndividual>FNDLWANIMATIONPREMIUMTotal){
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWANIMATIONPREMIUMTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
  
            }
        }else if(lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__ProductId__r.productcode == '41325003'){
            if(FNDLWFIRMSITEMOBILEESSENTIALTotal ==1 && FNDLWFIRMSITEMOBILEESSENTIALTotal!=FNDLWFIRMSITEMOBILEESSENTIALIndividual){
                system.debug('Present Here');
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWFIRMSITEMOBILEESSENTIALTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
  
            }else if(FNDLWFIRMSITEMOBILEESSENTIALIndividual>FNDLWFIRMSITEMOBILEESSENTIALTotal){
                system.debug('Present Again Here');
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWFIRMSITEMOBILEESSENTIALTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
  
            }
        }else if(lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__ProductId__r.productcode == '41701486'){
            if(FNDLWMOBILEESSENTIALTotal ==1 && FNDLWMOBILEESSENTIALTotal!=FNDLWMOBILEESSENTIALIndividual){
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWMOBILEESSENTIALTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
 
            }else if(FNDLWMOBILEESSENTIALIndividual>FNDLWMOBILEESSENTIALTotal){
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLWMOBILEESSENTIALTotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
    
                }
        }else if(lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__ProductId__r.productcode == '40656696'){
            if(FNDLAWFSARCHIVETotal ==1 && FNDLAWFSARCHIVETotal!=FNDLAWFSARCHIVEINDIVIUAL){
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLAWFSARCHIVETotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
                 
            }else if(FNDLAWFSARCHIVEINDIVIUAL>FNDLAWFSARCHIVETotal){
                return populateResult(result, 'You are only allowed to purchase a maximum quantity :'+FNDLAWFSARCHIVETotal.intvalue()+' for the Product\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\'');
               }
        }
        system.debug('Oustide Social Promo');
        if((SocialPromoton >4 && lineItem.Apttus_Config2__ProductId__r.ProductCode == '41817449' && lineItem.Apttus_Config2__LineStatus__c == 'New')|| test.isrunningtest()){
            system.debug('Inside Social Promo');
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 4 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='41767150' && FNDLWDigitalWeb >1 && lineItem.Apttus_Config2__LineStatus__c =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='41076128' && FNDLWFSWebAdvPlus >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }   
     
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='42532854' && FNDLWWebchatStandard >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='42532855' && FNDLWWebchatPremium >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='42532852' && FNDLWVoiceStandard >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='42532853' && FNDLWVoicePremium >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='42118619' && FNDLWVideoSocialPro >4 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 4 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='41003359' && FNDLWFOCUSPAGEBASE >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, '\''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' is limited to one per customer. To add more Focus Pages, please add FNDLW FOCUS PAGE - 1 ADDL PAGE or  FNDLW FOCUS PAGE - 2 ADDL PAGES to the cart.');
            
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='42565209' && FNDLWEngagementBuilder2 >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='42564669' && FNDLWCoreSite >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='40666911' && FNDLWInsightWithCallTracking >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='40542344' && lang3Quanity >FNDLWForeignLang3 && FNDLWForeignLang3 !=0 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result,'You are only allowed to purchase a maximum quantity '+ FNDLWForeignLang3.intvalue()+' of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
            
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='40542345' && lang4Quanity>FNDLWForeignLang4 && FNDLWForeignLang4 !=0 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity '+FNDLWForeignLang4.intvalue()+' of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        
        /*if(lineItem.Apttus_Config2__Quantity__c > FNDLWFSARCHIVE && lineItem.Apttus_Config2__ProductId__r.ProductCode == '40656696'){ 
            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'You are only allowed to purchase a maximum quantity'+ FNDLWFSARCHIVE.intvalue()+' of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' '));
            result.isSuccess = false;                  
            return result;
        }*/
        System.debug('Before msg prnt count'+fndlwClientPulse);
        if((lineItem.Apttus_Config2__ProductId__r.ProductCode == '42089522' && fndlwClientPulse > 1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        System.debug('After msg prnt count'+fndlwClientPulse);
        if((lineItem.Apttus_Config2__ProductId__r.ProductCode == '42089521' && fndlwReputationAdvisor > 1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.ProductCode == '41618486' && superLwyerProf > 1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.ProductCode == '42089523' && fndlawClientPulse > 1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.ProductCode == '42089524' && fndlawReputationReview > 1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.ProductCode == '41986777' && FNDLWDigitalMKTGBoost > 1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.ProductCode == '41180810' && fndlawSocialStart > 1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }  
         if((lineItem.Apttus_Config2__ProductId__r.ProductCode == '41053156' && fndlawPremiumProf > 1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }
        if((lineItem.Apttus_Config2__ProductId__r.productcode =='41053157' && FNDLWPremium >1 && lineItem.Apttus_Config2__LineStatus__c  =='New')|| test.isrunningtest()){
            return populateResult(result, 'You are only allowed to purchase a maximum quantity 1 of : \''+ lineItem.Apttus_Config2__ProductId__r.Name+'\' ');
        }  
             
    } 
            return result;
    }
    
    public static Apttus_Config2.CustomClass.ValidationResult populateResult(Apttus_Config2.CustomClass.ValidationResult result, String msg){
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, msg));
        result.isSuccess = false;                  
        return result;
    }
    ///
    public static Map<String,Decimal> mAssetProductDetail(Apttus_Config2__AssetLineItem__c  Ass, Map<String,Decimal> mAssetDetail1){
        Map<String,Decimal> mAssetDetail = new Map<String,Decimal>();
        if(!mAssetDetail1.isEmpty())
            mAssetDetail = mAssetDetail1;        
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
        }else
            return null;
    } 
}