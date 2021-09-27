/**
* Pricing callback used for CPQ and cart page
* @author Alex Shung
* @version 7/8/2016
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
*/
global with sharing class APTS_PricingCallback implements Apttus_Config2.CustomClass.IPricingCallback2 {
    private Apttus_Config2.ProductConfiguration cart = null;
    private Apttus_Config2.CustomClass.PricingMode mode = null;
    public Boolean isFindLaw = false;//Added as part of Findlaw changes
    public Boolean isDirectoryProduct = false; //Added as part of Findlaw CustomLineItem Solution changes by Deepthi
    public Boolean isPricingCallRequired = false;//DOC-1043
    public Boolean isTaxProf = false; //Tax prof changes
    private List<Apttus_Config2__LineItem__c> allAttachedLineItems;
    List<Apttus_Config2__PriceMatrixEntry__c > priceMatricetry = new List<Apttus_Config2__PriceMatrixEntry__c >();
    Set<Id> plistIds = new Set<Id>();
    Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap = new Map<Decimal, List<Apttus_Config2__LineItem__c>>();
    List<Apttus_Config2__LineItem__c> bundleItems = new List<Apttus_Config2__LineItem__c>();
    
    public Apttus_Config2__ProductConfiguration__c cartRec; //NOV release
    
    //Start : Findlaw descope APTS_FL_LineItemTriggerHelper.populateCategory
    @testvisible private Map<ID,Apttus_Config2__ProductClassification__c > mCatageory = New Map<id,Apttus_Config2__ProductClassification__c>();
    //end : Findlaw descope APTS_FL_LineItemTriggerHelper.populateCategory
    global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
        this.mode = mode;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Pricing Callback: '+ mode));
    }
    
    global void start(Apttus_Config2.ProductConfiguration prodConfig) {
       this.cart = prodConfig; 
       cartRec = prodConfig.getConfigSO();//Nov Release
       allAttachedLineItems = new List<Apttus_Config2__LineItem__c>();
       Set<ID> findLawsProducts = New Set<ID>();//Findlaw descope APTS_LineItemTriggerHelper.updateContactTerm
       //NOV Release
       Set<String> prodCodes = new Set<String>{'41343504','41343505','41343506','41343503','41451338','41689175','41689176','41689177','41689178','41689180'};
       List<Apttus_Config2__LineItem__c> dbheader = new List<Apttus_Config2__LineItem__c>(); 
       List<Apttus_Config2__LineItem__c> dbcomponent = new List<Apttus_Config2__LineItem__c>();
       Boolean corpSelect= false;
       System.debug('Start Pricing'); 
       for(Apttus_Config2.LineItem lineItem : cart.getLineItems()){ //DOC-15961
            Apttus_Config2__LineItem__c liSO = lineItem.getLineItemSO(); 
           if(liSO.Apttus_Config2__LineStatus__c!='Cancelled' && liSO.APTS_Module_Points__c>0 && liSO.Apttus_Config2__LineType__c == 'Product/Service' && liSO.APTS_Group__c!=null){
               corpSelect= true;
           }
           if(liSO.Apttus_Config2__LineStatus__c!='Cancelled' && liSO.Apttus_Config2__LineType__c == 'Option' && corpSelect== true){ //&& liSO.APTS_IsProflex_Line_Item__c!= null
                    liSO.Apttus_Config2__GroupAdjustmentPercent__c=0.00;
                    liSO.Apttus_Config2__AllocateGroupAdjustment__c= false;
                    system.debug('### cartRec.Name'+liSO.Apttus_Config2__AllocateGroupAdjustment__c);
           }
       } 
       for(Apttus_Config2.LineItem lineItem : cart.getLineItems()){
            Apttus_Config2__LineItem__c liSO = lineItem.getLineItemSO(); 
            System.debug(liSO );           
            allAttachedLineItems.add(liSO);
            
            // moved from buildLineNumberToOptionsMap method from APTS_PricingCallbackMethods class
            checkOptionOrBundle(liSO);
            /*if(liSO.Apttus_Config2__LineType__c == 'Option'){
                Decimal key = liSO.Apttus_Config2__LineNumber__c;
                if(lineNumberToOptionsMap.containsKey(key)){
                    lineNumberToOptionsMap.get(key).add(liSO);}
                else{
                    lineNumberToOptionsMap.put(key, new List<Apttus_Config2__LineItem__c>{liSO});}
            }
            else{
                bundleItems.add(liSO);
            }*/          
            /*if(liSO.APTS_Proposal_Business_Unit__c=='FindLaw' && (liSO.Apttus_Config2__LineStatus__c=='New' || liSO.Apttus_Config2__LineStatus__c=='Renewed')){
                plistIds.add(liSO.Apttus_Config2__PriceListItemId__c);
                findLawsProducts.Add(liSO.Apttus_Config2__ProductId__c);//Findlaw descope APTS_FL_LineItemTriggerHelper.populateCategory
            }*/
            findLawsProducts = buildPLAndindlawIDList(liSO, findLawsProducts);
            
            /*//start : Findlaw optimization Nov Release
            if(liso.Apttus_Config2__LineStatus__c == 'Renewed' && liso.Apttus_Config2__LineType__c == 'Product/Service' && prodCodes.contains(liso.Apttus_Config2__ProductId__r.ProductCode)){
                liso.Apttus_Config2__IsAssetPricing__c = true;
            }//decoped : WF - APTS FL Set PPC Asset Pricing*/
            liso = checkAssetPricingForFindlaw(liso, prodCodes);
            system.debug('##### liso.Apttus_Config2__LineStatus__c '+liso.Apttus_Config2__LineStatus__c );
            system.debug('##### liso.Apttus_Config2__LineStatus__c '+liso.APTS_Proposal_Business_Unit__c );
            system.debug('### cartRec.Name'+cartRec.Name);
            liso = checkAssetPricingForRisk(liso);
            /*if(liSO.APTS_Proposal_Business_Unit__c != null && liso.Apttus_Config2__LineStatus__c == 'Renewed' && (System.Label.Risk_PBUs.contains(liSO.APTS_Proposal_Business_Unit__c)) && !(cartRec.Name.contains('Product Config - Renew:-'))){
                liso.Apttus_Config2__IsQuantityModifiable__c = false;
                liso.Apttus_Config2__IsAssetPricing__c = true;
                if(liso.Apttus_Config2__AssetLineItemId__c!=null && liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c!=null && liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__BasePriceMethod__c != null){
                    liso.Apttus_Config2__BasePrice__c = liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c;
                }
            }*/
            // || (System.Label.APTS_Proflex_Materials.contains(liso.APTS_Product_Code__c) && liso.Apttus_Config2__LineStatus__c == 'Amended'
            liso = checkAssetPricingForSCSCanada(liso);
            /*if(liso.Apttus_Config2__LineStatus__c == 'Renewed'  
             && (liSO.APTS_Proposal_Business_Unit__c=='SCS' || liSO.APTS_Proposal_Business_Unit__c=='Canada') && !(cartRec.Name.contains('Product Config - Renew:-'))){
                liso.Apttus_Config2__IsQuantityModifiable__c = false;
                liso.Apttus_Config2__IsAssetPricing__c = true;
                if(liso.Apttus_Config2__AssetLineItemId__c!=null){
                    liso.Apttus_Config2__BasePrice__c = liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
                }
            }*/
            /*if(liso.APTS_Product_Code__c!=null && System.Label.APTS_Proflex_Materials.contains(liso.APTS_Product_Code__c) && liso.Apttus_Config2__LineStatus__c == 'Amended'
             && (liSO.APTS_Proposal_Business_Unit__c=='SCS' || liSO.APTS_Proposal_Business_Unit__c=='Canada') && !(cartRec.Name.contains('Product Config - Renew:-'))){
                liso.Apttus_Config2__IsAssetPricing__c = true;
            }*/
            liso = checkAssetPricingForProflex(liso);
            /*//decope WF - APTS Set Asset Pricing
            if(liSO.APTS_Proposal_Business_Unit__c=='FindLaw' && liSO.Apttus_Config2__LineStatus__c=='Renewed' && liso.Apttus_Config2__ProductId__r.ProductCode == '40656701' && liso.Apttus_Config2__AdjustmentAmount__c == null){
                liSO.Apttus_Config2__AdjustmentAmount__c = liSO.APTS_Exposure_Pack_Disc__c;
            }//decope WF - APTS_ExposurePack_AdjAmt_Renewal*/
            liso = populateAdjustmentAmount(liso);
            liso.APTS_Product_Family__c = liso.Apttus_Config2__ProductId__r.Family; // descoped WF - APTS Set Product Family
            //end : Findlaw optimization Nov Release
            
        }        
        /*if(!plistIds.isEmpty()){
                for(Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry : [SELECT Apttus_Config2__PriceMatrixId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2ValueType__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2Id__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__PriceOverride__c,Apttus_Config2__Dimension1Value__c,Apttus_Config2__Dimension2Value__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2Id__r.Name,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension3Id__r.Name,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension4Id__r.Name,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__Dimension3Value__c,Apttus_Config2__Dimension4Value__c FROM Apttus_Config2__PriceMatrixEntry__c WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c in :plistIds and Apttus_Config2__Dimension1Value__c='Renewed' ORDER BY Apttus_Config2__Dimension2Value__c DESC]){
                 if(priceMatricetry!=null){
                    priceMatricetry.add(priceMatrixEntry);
                    system.debug('priceMatricetry'+ priceMatricetry);
                   }
            }
        }*/
        populatePriceMatricetry();
        //start : Findlaw descope APTS_FL_LineItemTriggerHelper.populateCategory
        /*if(findLawsProducts!=null && findLawsProducts.size()>0){
            for(Apttus_Config2__ProductClassification__c  CH : [select id,Apttus_Config2__ProductId__c, Apttus_Config2__ClassificationId__c,Apttus_Config2__ClassificationId__r.Name  from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__c IN :findLawsProducts]){
                mCatageory.put(CH.Apttus_Config2__ProductId__c, CH);
            }
        }*/
        populateCategoryMap(findLawsProducts);
        //end : Findlaw descope APTS_FL_LineItemTriggerHelper.populateCategory
    }
    
    //Baseprice mode: adds options to bundle based on date defined in attribute value
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl lineItemColl) {
        try{
            System.debug('Before Pricing'); 
            //Added as part of SOC-6701 Start--Zakeer
            //if(this.mode == Apttus_config2.CustomClass.PricingMode.BASEPRICE || this.mode == Apttus_config2.CustomClass.PricingMode.ADJUSTMENT){
            if(checkPricingMode()){
                List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>(); 
                //Added as part of Tax prof
                List<Apttus_Config2__LineItem__c> lineitemlisTax = new List<Apttus_Config2__LineItem__c>();  
                system.debug('Beforepricing '+this.mode+' MODE');
                isDirectoryProduct = false;           
                for(Apttus_Config2.LineItem lineItem : lineItemColl.getAllLineItems()){
                    Apttus_Config2__LineItem__c liSO = lineItem.getLineItemSO();
                    System.debug(liso.APTS_Contract_Term__c +liso.Name);
                    if(liSO.APTS_Proposal_Business_Unit__c=='FindLaw'){ 
                        isFindLaw=true;
                        lineitemlist.add(liSO);                         
                        liso = checkAndSetDirectoriesBasePriceFindlaw(liso);
                        /*if(liSO.APTS_Combination_Key__c!=null){
                          isDirectoryProduct = true;
                        }
                        //Nandeesh: moved from  setDirectoriesBasePrice method of APTS_FL_PricingCallbackMethods class
                        if(isDirectoryProduct == true && liSO.APTS_PAGEO_Price__c!=null && liSO.APTS_PAGEO_Price__c != 0) { 
                           liSO.Apttus_Config2__BasePrice__c= liSO.APTS_PAGEO_Price__c;  
                            if(liSO.Apttus_Config2__LineStatus__c=='New' || liSO.Apttus_Config2__LineStatus__c=='Renewed'){
                                liSO.APTS_Year_2_3_Price__c=liSO.Apttus_Config2__BasePrice__c;
                            }             
                        }*/
                        liso = populateCategoryFindlaw(liso);
                        /*//start : Findlaw descope APTS_FL_LineItemTriggerHelper.populateCategory
                        if(mCatageory.containskey(liSO.Apttus_Config2__ProductId__c) && mCatageory.get(liSO.Apttus_Config2__ProductId__c).Apttus_Config2__ClassificationId__c <>null){
                            liSO.APTS_Category_Name__c = mCatageory.get(liSO.Apttus_Config2__ProductId__c).Apttus_Config2__ClassificationId__r.Name; 
                            System.debug('test : liSO.APTS_Category_Name__c : '+liSO.APTS_Category_Name__c);
                        }*/
                        liso = defaultContractTermFindlaw(liso, this.mode);
                        /*//Nandeesh: DOC-11979
                        if(this.mode == Apttus_config2.CustomClass.PricingMode.ADJUSTMENT){

                            //Nandeesh: moved from  findlawdefaultContractTerm method of APTS_FL_PricingCallbackMethods class  
                            if(liSO.Apttus_Config2__LineType__c != 'Option'){
                                if (liSO.APTS_Contract_Term__c == null) {
                                    liSO.APTS_Contract_Term__c = liSO.APTS_Contract_Term_Default__c;
                                    if (liSO.Apttus_Config2__ChargeType__c=='Subscription Fee' && liSO.Apttus_Config2__AdjustmentType__c == null) {
                                        liSO.Apttus_Config2__AdjustmentType__c = '% Discount';
                                    }
                                }
                                if(liSO.Apttus_Config2__AdjustmentType__c == null && liSO.Apttus_Config2__ChargeType__c == 'Standard Price'){
                                    liSO.Apttus_Config2__AdjustmentType__c = '% Discount';
                                }
                                if(liSO.Apttus_Config2__PriceType__c == 'One Time'){
                                    liSO.APTS_Contract_Term__c = null;                
                                }             
                       
                            }
                            if(lineNumberToOptionsMap.containsKey(liSO.Apttus_Config2__LineNumber__c)){
                                for(Apttus_Config2__LineItem__c optionLineItem : lineNumberToOptionsMap.get(liSO.Apttus_Config2__LineNumber__c)){
                                    if(optionLineItem.APTS_Contract_Term__c != liSO.APTS_Contract_Term__c){
                                    optionLineItem.APTS_Contract_Term__c = liSO.APTS_Contract_Term__c;                          
                                    }
                                } 
                            }  
                        }*/     
                    } 
                    else if(liSO.APTS_Proposal_Business_Unit__c=='Tax Professional'){ 
                        isTaxProf=true;
                        lineitemlisTax.add(liSO);                         
                    }
                }
                processBPCallFLTaxMethods(lineitemlist, lineitemlisTax);
                /*if(!lineitemlist.isEmpty() && isFindLaw == true && isDirectoryProduct == false){ 
                    //Added as part of Findlaw changes           
                        System.debug('-----start---'+ Limits.getCpuTime()+ '/' + Limits.getLimitCpuTime());
                        APTS_FL_PricingCallbackMethods.yoypriceUpdate(lineitemlist,priceMatricetry);
                        //  System.debug('-----end---'+ Limits.getCpuTime()+ '/' + Limits.getLimitCpuTime());
                        //   APTS_FL_PricingCallbackMethods.setYear2_3Price(lineitemlist);              
                }
                //Tax Professional Changes
                if(!lineitemlisTax.isEmpty() && isTaxProf == true){               
                        APTS_TaxProf_PricingCallbackMethods.updatepricemethod(lineitemlisTax); 
                        APTS_TaxProf_PricingCallbackMethods.defaultyoyincrease(lineitemlisTax); 
                        APTS_TaxProf_PricingCallbackMethods.defaultingOptionLineItem(lineitemlisTax); 
                        //isTaxProf = false;              
                }*/
                
                          
            }
            processBPNonFindlaw();
            //if(isFindLaw == false){                  // Nandeesh: this will stop executing all below lines for findlaw
                //system.debug('Mode Before defaultRenewalType called = '+this.mode);
                //if(this.mode == Apttus_config2.CustomClass.PricingMode.BASEPRICE){
                    //System.debug('Inside the renewal type method');
                    /*List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>();
                    for(Apttus_Config2.LineItem lineItem : lineItemColl.getAllLineItems()){
                        Apttus_Config2__LineItem__c liSO = lineItem.getLineItemSO();
                        if(!lineitemlist.contains(liSO) && (liso.APTS_Proposal_Business_Unit__c=='Corp OneOTC US' || liso.APTS_Proposal_Business_Unit__c=='Corp OneOTC UK')){
                            lineitemlist.add(liSO);                    
                        }
                    }*/
                    //APTS_PricingCallbackMethods.defaultRenewalType(lineitemlist);
                //}
                //else{
                    //processNonBasePriceForNonFindlaw();
                    /*List<Apttus_Config2__LineItem__c> canadalineitemlist = new List<Apttus_Config2__LineItem__c>();
                    List<Apttus_Config2__LineItem__c> dbheader = new List<Apttus_Config2__LineItem__c>(); 
                    List<Apttus_Config2__LineItem__c> dbcomponent = new List<Apttus_Config2__LineItem__c>();
                    List<Apttus_Config2__LineItem__c> lineItemsBundle= new List<Apttus_Config2__LineItem__c>();
                    Map<Id, Apttus_Config2__LineItem__c> lineItemsF = new Map<Id, Apttus_Config2__LineItem__c>();    
            
                    Decimal numberOfAttorneys=0;
                    //Nandeesh: moved below line to start method
                    //     Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap = APTS_PricingCallbackMethods.buildLineNumberToOptionsMap(allAttachedLineItems, bundleItems); //
                    //Added By Poonam Garg. Set Number OF Attorneys for BGB Prining Model in Canada
                    for(Apttus_Config2.LineItem lineItem : cart.getLineItems()){
                       Apttus_Config2__LineItem__c liSO = lineItem.getLineItemSO();
                        if(liSO.APTS_Proposal_Business_Unit__c==Label.SALESORGCAN 
                           && liSO.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c==Label.BGBPRICINGMODEL)  { 
                           canadalineitemlist.add(liSO);
                           if(numberOfAttorneys==0 && liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c!=null && 
                                liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c>0){
                                numberOfAttorneys=liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c;
                           }
                        } 
                        //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here 
                        if((liSO.APTS_Proposal_Business_Unit__c == 'SCS' || liSO.APTS_Proposal_Business_Unit__c == 'Canada') && (liSO.Apttus_Config2__LineStatus__c == 'New' || liSO.Apttus_Config2__LineStatus__c == 'Amended')){
                            if(liSO.APTS_Product_Code__c != null && System.Label.APTS_Proflex_Materials.contains(liSO.APTS_Product_Code__c)){
                                dbheader.add(liSO);
                            }else if(liSO.APTS_Product_Code__c != null && !System.Label.APTS_Proflex_Materials.contains(liSO.APTS_Product_Code__c) && liSO.APTS_Bundle__c != null){
                                dbcomponent.add(liSO);
                            }
                            lineItemsBundle.add(liso);
                            lineItemsF.put(liso.Id, liso);   
                        }
                    }
                    System.debug('dbheader'+dbheader);
                    System.debug(dbcomponent);
                    //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Ends Here
                    //Added By Poonam Garg. Set Number OF Attorneys for BGB Prining Model in Canada
                    if(!canadalineitemlist.isEmpty()){
                        System.debug('%canadalineiTemList%'+canadalineitemlist.size());
                        APTS_PricingCallbackMethods.setPricedAttrorneysForCanada(canadalineitemlist,numberOfAttorneys); 
                    } 
                    if(!bundleItems.isEmpty() && isTaxProf == false && isFindLaw == false){
                        //Run discount to max                
                        APTS_PricingCallbackMethods.discountToMax(bundleItems, lineNumberToOptionsMap);
                        System.debug(bundleItems);
                        APTS_PricingCallBackMethods.defaultContractTermDiscounts(bundleItems, lineNumberToOptionsMap, cartRec); //Added parameter as part of descope
                        System.debug(bundleItems);
                        system.debug('KS-->  method called in mode '+this.mode);             
                        APTS_CORP_PricingCallbackMethods.defaultContractTermYOYRenewalType(bundleItems, lineNumberToOptionsMap);
                    }  
                    if(!dbheader.isEmpty() && !dbcomponent.isEmpty()){
                        System.debug(dbheader);
                        System.debug(dbcomponent);
                        APTS_PricingCallbackMethods.setPricingForMultiTier(dbheader,dbcomponent);
                        System.debug(dbheader);
                        System.debug(dbcomponent);
                    }*/  
                //}    
            //}  
        }catch(Exception ex){
            System.debug(' Exception --- ' + ex.getStackTraceString());
            throw ex;
        }
    }
    
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl lineItemColl, Apttus_Config2.LineItem lineItem) {
        System.debug('inside beforePricingLineItem');    
    }

    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl lineItemColl) {
        //Added as part of Tax prof
        if(this.mode == Apttus_config2.CustomClass.PricingMode.BASEPRICE || this.mode == Apttus_config2.CustomClass.PricingMode.ADJUSTMENT){       
            List<Apttus_Config2__LineItem__c> lineitemlis = new List<Apttus_Config2__LineItem__c>();  
            List<Apttus_Config2__LineItem__c> dbheader = new List<Apttus_Config2__LineItem__c>(); 
            List<Apttus_Config2__LineItem__c> dbcomponent = new List<Apttus_Config2__LineItem__c>();
        
            for(Apttus_Config2.LineItem lineItems : lineItemColl.getAllLineItems()){
                Apttus_Config2__LineItem__c liSO = lineItems.getLineItemSO();
                system.debug('Proposal business unit is$$$$$$$$$' +liSO.APTS_Proposal_Business_Unit__c);
                if(liSO.APTS_Proposal_Business_Unit__c=='Tax Professional')  { 
                    isTaxProf=true;
                    lineitemlis.add(liSO);                         
                }
            } 
            
            if(!lineitemlis.isEmpty() && isTaxProf == true){ 
                System.debug('Entering tax prof method call');                     
                APTS_TaxProf_PricingCallbackMethods.multiYearTieredPricing(lineitemlis); //Added as part of DOC-8995 by Poorva
                isTaxProf = false;              
            }
        }    
    }
   
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl lineItemColl, Apttus_Config2.LineItem lineItem){
        system.debug('inside afterPricingLineItem');
    }


    global void finish(){       
       /* ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'allAttachedLineItems size: '+allAttachedLineItems.size()+ ' mode is : '+mode));
        if( mode == Apttus_config2.CustomClass.PricingMode.ADJUSTMENT){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Attepmting to call test insert'));
            APTS_PricingCallbackMethods.totallingGroupForDynamicBundle(allAttachedLineItems);
        }*/
        system.debug('inside finish');                
    }
     
    @testvisible
    private void checkOptionOrBundle(Apttus_Config2__LineItem__c liSO){
        if(liSO.Apttus_Config2__LineType__c == 'Option'){
            Decimal key = liSO.Apttus_Config2__LineNumber__c;
            if(lineNumberToOptionsMap.containsKey(key)){
                lineNumberToOptionsMap.get(key).add(liSO);
            }
            else{
                lineNumberToOptionsMap.put(key, new List<Apttus_Config2__LineItem__c>{liSO});
            }
        }else{
            bundleItems.add(liSO);
        }    
    }
    
    @testvisible
    private Set<ID> buildPLAndindlawIDList(Apttus_Config2__LineItem__c liSO, Set<ID> findLawsProducts){
        if(liSO.APTS_Proposal_Business_Unit__c=='FindLaw' && (liSO.Apttus_Config2__LineStatus__c=='New' || liSO.Apttus_Config2__LineStatus__c=='Renewed')){
            plistIds.add(liSO.Apttus_Config2__PriceListItemId__c);
            findLawsProducts.Add(liSO.Apttus_Config2__ProductId__c);//Findlaw descope APTS_FL_LineItemTriggerHelper.populateCategory
        }
        return findLawsProducts;
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c checkAssetPricingForFindlaw(Apttus_Config2__LineItem__c liSO, Set<String> prodCodes){
        //start : Findlaw optimization Nov Release
        if(liso.Apttus_Config2__LineStatus__c == 'Renewed' && liso.Apttus_Config2__LineType__c == 'Product/Service' && prodCodes.contains(liso.Apttus_Config2__ProductId__r.ProductCode)){
            liso.Apttus_Config2__IsAssetPricing__c = true;
        }//decoped : WF - APTS FL Set PPC Asset Pricing
        return liSO;
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c checkAssetPricingForRisk(Apttus_Config2__LineItem__c liSO){
        if(liSO.APTS_Proposal_Business_Unit__c != null && liso.Apttus_Config2__LineStatus__c == 'Renewed' && (System.Label.Risk_PBUs.contains(liSO.APTS_Proposal_Business_Unit__c)) && !(cartRec.Name.contains('Product Config - Renew:-'))){
            liso.Apttus_Config2__IsQuantityModifiable__c = false;
            liso.Apttus_Config2__IsAssetPricing__c = true;
            if(liso.Apttus_Config2__AssetLineItemId__c!=null && liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c!=null && liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__BasePriceMethod__c != null){
                liso.Apttus_Config2__BasePrice__c = liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c;
            }
        }
        return liSO;
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c checkAssetPricingForSCSCanada(Apttus_Config2__LineItem__c liSO){
        if(liso.Apttus_Config2__LineStatus__c == 'Renewed'  
             && (liSO.APTS_Proposal_Business_Unit__c=='SCS' || liSO.APTS_Proposal_Business_Unit__c=='Canada') && !(cartRec.Name.contains('Product Config - Renew:-'))){
            liso.Apttus_Config2__IsQuantityModifiable__c = false;
            liso.Apttus_Config2__IsAssetPricing__c = true;
            if(liso.Apttus_Config2__AssetLineItemId__c!=null){
                liso.Apttus_Config2__BasePrice__c = liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
            }
        }return liSO;
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c checkAssetPricingForProflex(Apttus_Config2__LineItem__c liSO){
        if(liso.APTS_Product_Code__c!=null && System.Label.APTS_Proflex_Materials.contains(liso.APTS_Product_Code__c) && liso.Apttus_Config2__LineStatus__c == 'Amended'
             && (liSO.APTS_Proposal_Business_Unit__c=='SCS' || liSO.APTS_Proposal_Business_Unit__c=='Canada') && !(cartRec.Name.contains('Product Config - Renew:-'))){
            liso.Apttus_Config2__IsAssetPricing__c = true;
            if(liso.Apttus_Config2__AssetLineItemId__c!=null){
                liso.Apttus_Config2__BasePrice__c = liso.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
            }
        }
        return liSO;
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c populateAdjustmentAmount(Apttus_Config2__LineItem__c liSO){
        //decope WF - APTS Set Asset Pricing
        if(liSO.APTS_Proposal_Business_Unit__c=='FindLaw' && liSO.Apttus_Config2__LineStatus__c=='Renewed' && liso.Apttus_Config2__ProductId__r.ProductCode == '40656701' && liso.Apttus_Config2__AdjustmentAmount__c == null){
            liSO.Apttus_Config2__AdjustmentAmount__c = liSO.APTS_Exposure_Pack_Disc__c;
        }//decope WF - APTS_ExposurePack_AdjAmt_Renewal
        return liSO;
    }
    
    @testvisible
    private void populatePriceMatricetry(){
        if(!plistIds.isEmpty()){
                for(Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry : [SELECT Apttus_Config2__PriceMatrixId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2ValueType__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2Id__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__PriceOverride__c,Apttus_Config2__Dimension1Value__c,Apttus_Config2__Dimension2Value__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension2Id__r.Name,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension3Id__r.Name,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension4Id__r.Name,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__Dimension3Value__c,Apttus_Config2__Dimension4Value__c FROM Apttus_Config2__PriceMatrixEntry__c WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c in :plistIds and Apttus_Config2__Dimension1Value__c='Renewed' ORDER BY Apttus_Config2__Dimension2Value__c DESC]){
                 if(priceMatricetry!=null){
                    priceMatricetry.add(priceMatrixEntry);
                    system.debug('priceMatricetry'+ priceMatricetry);
                   }
            }
        }
    }
    
    @testvisible
    private void populateCategoryMap(Set<ID> findLawsProducts){
        if(findLawsProducts!=null && findLawsProducts.size()>0){
            for(Apttus_Config2__ProductClassification__c  CH : [select id,Apttus_Config2__ProductId__c, Apttus_Config2__ClassificationId__c,Apttus_Config2__ClassificationId__r.Name  from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__c IN :findLawsProducts]){
                mCatageory.put(CH.Apttus_Config2__ProductId__c, CH);
            }
        }
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c checkAndSetDirectoriesBasePriceFindlaw(Apttus_Config2__LineItem__c liSO){
        if(liSO.APTS_Combination_Key__c!=null){
            isDirectoryProduct = true;
        }
        //Nandeesh: moved from  setDirectoriesBasePrice method of APTS_FL_PricingCallbackMethods class
        if(isDirectoryProduct == true && liSO.APTS_PAGEO_Price__c!=null && liSO.APTS_PAGEO_Price__c != 0) { 
           liSO.Apttus_Config2__BasePrice__c= liSO.APTS_PAGEO_Price__c;  
            if(liSO.Apttus_Config2__LineStatus__c=='New' || liSO.Apttus_Config2__LineStatus__c=='Renewed'){
                liSO.APTS_Year_2_3_Price__c=liSO.Apttus_Config2__BasePrice__c;
            }             
        }
        return liso;
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c populateCategoryFindlaw(Apttus_Config2__LineItem__c liSO){
        //start : Findlaw descope APTS_FL_LineItemTriggerHelper.populateCategory
        if(mCatageory.containskey(liSO.Apttus_Config2__ProductId__c) && mCatageory.get(liSO.Apttus_Config2__ProductId__c).Apttus_Config2__ClassificationId__c <>null){
            liSO.APTS_Category_Name__c = mCatageory.get(liSO.Apttus_Config2__ProductId__c).Apttus_Config2__ClassificationId__r.Name; 
            System.debug('test : liSO.APTS_Category_Name__c : '+liSO.APTS_Category_Name__c);
        }
        return liso;
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c defaultContractTermFindlaw(Apttus_Config2__LineItem__c liSO, Apttus_Config2.CustomClass.PricingMode mode){
        if(mode == Apttus_config2.CustomClass.PricingMode.ADJUSTMENT){
            //Nandeesh: moved from  findlawdefaultContractTerm method of APTS_FL_PricingCallbackMethods class  
            if(liSO.Apttus_Config2__LineType__c != 'Option'){
                liso = defaultOptionContractTermFindlaw(liso);
            }
            populateOptionLIContractTermFindlaw(liso); 
        }
        return liso;
    }
    
    @testvisible
    private Apttus_Config2__LineItem__c defaultOptionContractTermFindlaw(Apttus_Config2__LineItem__c liSO){
        if (liSO.APTS_Contract_Term__c == null){
            liSO.APTS_Contract_Term__c = liSO.APTS_Contract_Term_Default__c;
            if (liSO.Apttus_Config2__ChargeType__c=='Subscription Fee' && liSO.Apttus_Config2__AdjustmentType__c == null) {
                liSO.Apttus_Config2__AdjustmentType__c = '% Discount';
            }
        }
        if(liSO.Apttus_Config2__AdjustmentType__c == null && liSO.Apttus_Config2__ChargeType__c == 'Standard Price'){
            liSO.Apttus_Config2__AdjustmentType__c = '% Discount';
        }
        if(liSO.Apttus_Config2__PriceType__c == 'One Time'){
            liSO.APTS_Contract_Term__c = null;                
        }             
        return liso;
    }
    
    @testvisible
    private void populateOptionLIContractTermFindlaw(Apttus_Config2__LineItem__c liSO){
        if(lineNumberToOptionsMap.containsKey(liSO.Apttus_Config2__LineNumber__c)){
            for(Apttus_Config2__LineItem__c optionLineItem : lineNumberToOptionsMap.get(liSO.Apttus_Config2__LineNumber__c)){
                if(optionLineItem.APTS_Contract_Term__c != liSO.APTS_Contract_Term__c){
                    optionLineItem.APTS_Contract_Term__c = liSO.APTS_Contract_Term__c;                          
                }
            } 
        } 
    }

    @testvisible
    private boolean checkSCSCanadaNewAmended(Apttus_Config2__LineItem__c liSO){
        Boolean flag = false;
        flag = ((liSO.APTS_Proposal_Business_Unit__c == 'SCS' || liSO.APTS_Proposal_Business_Unit__c == 'Canada') && (liSO.Apttus_Config2__LineStatus__c == 'New' || liSO.Apttus_Config2__LineStatus__c == 'Amended'));
        return flag;
    }
    
    @testvisible
    private boolean checkCanadaPriceModel(Apttus_Config2__LineItem__c liSO){
        Boolean flag = false;
        flag = (liSO.APTS_Proposal_Business_Unit__c==Label.SALESORGCAN 
        && ( liSO.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c==Label.BGBPRICINGMODEL) );
        return flag;
    }

    @testvisible
    private void processNonBasePriceForNonFindlaw(){
        List<Apttus_Config2__LineItem__c> canadalineitemlist = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> dbheader = new List<Apttus_Config2__LineItem__c>(); 
        List<Apttus_Config2__LineItem__c> dbcomponent = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> lineItemsBundle= new List<Apttus_Config2__LineItem__c>();
        Map<Id, Apttus_Config2__LineItem__c> lineItemsF = new Map<Id, Apttus_Config2__LineItem__c>();    

        Decimal numberOfAttorneys=0;
        //Nandeesh: moved below line to start method
        //     Map<Decimal, List<Apttus_Config2__LineItem__c>> lineNumberToOptionsMap = APTS_PricingCallbackMethods.buildLineNumberToOptionsMap(allAttachedLineItems, bundleItems); //
        //Added By Poonam Garg. Set Number OF Attorneys for BGB Prining Model in Canada
        for(Apttus_Config2.LineItem lineItem : cart.getLineItems()){
           Apttus_Config2__LineItem__c liSO = lineItem.getLineItemSO();
            //if(liSO.APTS_Proposal_Business_Unit__c==Label.SALESORGCAN 
            //    && liSO.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c==Label.BGBPRICINGMODEL)  { 
            if(checkCanadaPriceModel(liSO))  { 
            canadalineitemlist.add(liSO);
                /*if(numberOfAttorneys==0 && liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c!=null && 
                    liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c>0){
                    numberOfAttorneys=liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c;
                }*/
                numberOfAttorneys = countNumberOfAttorneys(liSO, numberOfAttorneys);
            } 
            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here 
            //if((liSO.APTS_Proposal_Business_Unit__c == 'SCS' || liSO.APTS_Proposal_Business_Unit__c == 'Canada') && (liSO.Apttus_Config2__LineStatus__c == 'New' || liSO.Apttus_Config2__LineStatus__c == 'Amended')){
            if(checkSCSCanadaNewAmended(liSO)){
                if(liSO.APTS_Product_Code__c != null && System.Label.APTS_Proflex_Materials.contains(liSO.APTS_Product_Code__c)){
                    dbheader.add(liSO);
                }else if((liSO.APTS_Product_Code__c == null || (liSO.APTS_Product_Code__c != null && !System.Label.APTS_Proflex_Materials.contains(liSO.APTS_Product_Code__c))) && liSO.APTS_Bundle__c != null){
                    dbcomponent.add(liSO);
                }
                lineItemsBundle.add(liso);
                lineItemsF.put(liso.Id, liso);   
            }
        }
        System.debug('dbheader'+dbheader);
        System.debug(dbcomponent);
        //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Ends Here
                
        processNonBasePriceForNonFindlawContinue(new Map<String, List<Apttus_Config2__LineItem__c>>{'canadalineitemlist'=>canadalineitemlist
                                                                            , 'dbheader'=>dbheader, 'dbcomponent'=>dbcomponent}
                                                                            , numberOfAttorneys);
        
    }
    
    @testvisible
    private void processNonBasePriceForNonFindlawContinue(Map<String, List<Apttus_Config2__LineItem__c>> attMap, Decimal numberOfAttorneys){
        List<Apttus_Config2__LineItem__c> canadalineitemlist = attMap.get('canadalineitemlist');
        List<Apttus_Config2__LineItem__c> dbheader = attMap.get('dbheader');
        List<Apttus_Config2__LineItem__c> dbcomponent = attMap.get('dbcomponent');
        //Added By Poonam Garg. Set Number OF Attorneys for BGB Prining Model in Canada
        if(!canadalineitemlist.isEmpty()){
            System.debug('%canadalineiTemList%'+canadalineitemlist.size());
            APTS_PricingCallbackMethods.setPricedAttrorneysForCanada(canadalineitemlist,numberOfAttorneys); 
        } 
        if(!bundleItems.isEmpty() && isTaxProf == false && isFindLaw == false){
            //Run discount to max                
            APTS_PricingCallbackMethods.discountToMax(bundleItems, lineNumberToOptionsMap);
            System.debug(bundleItems);
            APTS_PricingCallBackMethods.defaultContractTermDiscounts(bundleItems, lineNumberToOptionsMap, cartRec); //Added parameter as part of descope
            System.debug(bundleItems);
            system.debug('KS-->  method called in mode '+this.mode);             
            APTS_CORP_PricingCallbackMethods.defaultContractTermYOYRenewalType(bundleItems, lineNumberToOptionsMap);
        }  
        if(!dbheader.isEmpty() && !dbcomponent.isEmpty()){
            System.debug(dbheader);
            System.debug(dbcomponent);
            APTS_PricingCallbackMethods.setPricingForMultiTier(dbheader,dbcomponent);
            System.debug(dbheader);
            System.debug(dbcomponent);
        }
    }
    
    @testvisible
    private Decimal countNumberOfAttorneys(Apttus_Config2__LineItem__c liSO, Decimal numberOfAttorneys){
        if(numberOfAttorneys==0 && liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c!=null && 
                    liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c>0){
            numberOfAttorneys=liSO.Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c;
        }
        return numberOfAttorneys;
    }
    
    @testvisible
    private boolean checkPricingMode(){
        Boolean flag = false;
        flag = (this.mode == Apttus_config2.CustomClass.PricingMode.BASEPRICE || this.mode == Apttus_config2.CustomClass.PricingMode.ADJUSTMENT);
        return flag;
    }

    @testvisible
    private void processBPNonFindlaw(){
        if(isFindLaw == false){                  // Nandeesh: this will stop executing all below lines for findlaw
            system.debug('Mode Before defaultRenewalType called = '+this.mode);
            if(this.mode == Apttus_config2.CustomClass.PricingMode.BASEPRICE){
                processNonBasePriceForNonFindlaw();
                System.debug('Inside the renewal type method');
            }
            else{
                processNonBasePriceForNonFindlaw();
            }    
        }  
    }
    
    @testvisible
    private void processBPCallFLTaxMethods(List<Apttus_Config2__LineItem__c> lineitemlist, List<Apttus_Config2__LineItem__c> lineitemlisTax){
        if(!lineitemlist.isEmpty() && isFindLaw == true && isDirectoryProduct == false){ 
            //Added as part of Findlaw changes           
                System.debug('-----start---'+ Limits.getCpuTime()+ '/' + Limits.getLimitCpuTime());
                APTS_FL_PricingCallbackMethods.yoypriceUpdate(lineitemlist,priceMatricetry);
        }
        //Tax Professional Changes
        if(!lineitemlisTax.isEmpty() && isTaxProf == true){               
            APTS_TaxProf_PricingCallbackMethods.updatepricemethod(lineitemlisTax); 
            APTS_TaxProf_PricingCallbackMethods.defaultyoyincrease(lineitemlisTax); 
            APTS_TaxProf_PricingCallbackMethods.defaultingOptionLineItem(lineitemlisTax); 
            //isTaxProf = false;              
        }
    }
}