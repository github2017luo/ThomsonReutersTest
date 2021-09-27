/**
 * @description Apex Class 'APTS_FL_LineItemTriggerHelper'
 */
public with sharing class APTS_FL_LineItemTriggerHelper { 
    Static Boolean isNewSSD = FALSE; //Added By Poonam Garg to fix Too many SOQL DOC 10322
    Static List<Apttus_Config2__AssetLineItem__c> lAssetsLines = New List<Apttus_Config2__AssetLineItem__c>();//Added By Poonam Garg to fix Too many SOQL DOC 10322
    /**
     * @description Apex Method 'populateAllApprovalRequiredCB'
     * @param lineItems
     * @param cartIdSet
     */
    public static void populateAllApprovalRequiredCB(List<Apttus_Config2__LineItem__c> lineItems, Set<id> cartIdSet) {
       system.debug(LoggingLevel.WARN,'incomming------'+lineItems.size());
      // Set<id> cartIdSet=new Set<id>();
       //Map<ID,Apttus_Config2__LineItem__c> mapOfIdLineItems = New Map<ID,Apttus_Config2__LineItem__c>();
       Map<String,Apttus_Config2__AssetLineItem__c> mapOfProductCodeAndAssets = New Map<String,Apttus_Config2__AssetLineItem__c>();
       //Commented By Prabhu below as part of DOC 14585 
       //Map<String,Apttus_Config2__AssetLineItem__c> mapOfPAGEOassets = New Map<String,Apttus_Config2__AssetLineItem__c>(); //SOC-9887 added by Sakshi
       
       ID shiptoSSD;
       //Added By Poonam Garg for findlaw TREPH changes
       Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
       List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
       for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            //String flvalue= pb.value__c;   //Commented by Tanmay as a part of PMD Fix 'apex pmd (UnusedLocalVariable)'           
            flcodeMap.put(pb.name,pb.value__c.split(','));
       }
        System.debug(LoggingLevel.WARN,'flcode'+flcodeMap);
       Decimal anualSpend; 
       //Decimal flCalcattheend =0; //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Variable moved to class 'APTS_FL_LineItemTriggerHelper1'
       Decimal cancelquanity =0;
       Decimal firmsiteOrIMCount=0;
       Decimal flNFCSubdomain =0; //added as part of descope
       //Decimal anualSpend;
       //Decimal FndDigitalMKT =0;
       //Decimal flCalcattheend =0;
       //Decimal cancelquanity =0;
       Boolean alignContract =false; //soc-9837
       Date farthestEndDate; //SOC-9837
       Date finalfarthestEndDate; //SOC-9837
       
       //List<Apttus_Config2__AssetLineItem__c> lAssetsLines = New List<Apttus_Config2__AssetLineItem__c>(); //Added By Poonam Garg to fix Too many SOQL DOC 10322
       //Set<String> firmSiteIMCodes=new Set<String>();
       //Commented By Prabhu below as part of DOC 14585 
       //set<string> fldirectory = new set<string>();  //soc-9887 , Sakshi
       //fldirectory.addall(Label.FLDirectory.split(','));  //soc-9887 , Sakshi 
       
       Boolean hasIMProductsAssets = false; 
       Boolean hasIMProductsLines = false; 
       Boolean hasPPCLandingAsset = false; 
       Boolean hasPPCLandinglines = false; 
       Boolean hasIMRECheckAsset = false;
       Boolean hasIMRECheckCart = false;
       Boolean hasIMSCheckAsset = false; 
       Boolean hasIMSCheckCart = false;
       Boolean hasPPCLandingEspanolAsset = false; 
       Boolean hasPPCLinesEng = false; 
       Boolean hasPPCLinesEsp = false; //Added as part of descope
             
      //SOC-9890 ends
      List<String> lProductCodes = New List<String>{'41915678','41822784','41767150','41777796','30010890','41343506','41689178','42594853','40483699',
                                                     '40485592','40483693','40483696','41915678','41892830','42124052','41822784','41777796','42564669',
                                                     '42565208','42595567','42565164','42595564','42595563','37005072','40987607','40987608','41680342',
                                                     '37005004','37005005','41976905','42088301'}; //Added as part of descope
        lProductCodes.add('41180810');
        lProductCodes.add('41053157');
        lProductCodes.add('40586465');
        lProductCodes.add('41895338');
        lProductCodes.add('40666911');
          
    
        Set<String> firmSiteIMCodes=new Set<String>{'40483699','40485592','40483693','40483696','41915678','41892830','42124052','41822784','41777796',
                                                   '42564669','42565208','42595567','42565164','42595564','42595563'}; //added as part of descope
        Decimal fNDLWPremiumTotal = 0; //SOC-9890
        Decimal fNDLWPremiumCancel = 0; //SOC-9890
        Decimal fNDLWADDLCALLTRACKINGNUMBERTotal = 0; //SOC-9890
        Decimal fNDLWADDLCALLTRACKINGNUMBERCancel = 0; //SOC-9890
        Decimal fNDLWLawinfoCallTrackingNumberTotal = 0; //SOC-9890
        Decimal fNDLWLawinfoCallTrackingNumberCancel = 0; //SOC-9890
        
       
      
       system.debug(LoggingLevel.WARN,'cartIdSet--'+cartIdSet);      
    
       Map<ID,Apttus_Config2__LineItem__c> mapOfIdLineItems = New Map<ID,Apttus_Config2__LineItem__c>([Select id, APTS_Contract_End_Date__c,APTS_FL_Current_price__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__OptionId__r.ProductCode,Apttus_Config2__ChargeType__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_ship_to__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_ship_to__r.LCRM_FL_Annual_Spend__c,Apttus_Config2__LineType__c,Apttus_Config2__LineStatus__c,APTS_Product_Code__c,Apttus_Config2__AttributeValueId__c , Apttus_Config2__AttributeValueId__r.APTS_PPC_Mgmt_Fee_Override__c ,Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c ,Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c  ,Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c ,Apttus_Config2__NetPrice__c ,APTS_Combination_Key__c,Inventory_Available_Product_Detail__c,APTS_Combination_Key__r.Name from 
                                               Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c IN : cartIdSet]);
       shiptoSSD=mapOfIdLineItems.values()[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_ship_to__c;   //Added as part of descope
       
       anualSpend = lineItems[0].APTS_FL_Annual_Spend__c;
        //Added more fields in the below query as part of Findlaw changes 
       if((lAssetsLines .isEmpty()) && (isNewSSD ==False)){
           //Added more fields in the below query as part of Findlaw changes 
           lAssetsLines =[Select id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.ProductCode ,Apttus_Config2__Quantity__c,APTS_PPC_Spend_Type__c ,APTS_PPC_Website_Type__c,Apttus_Config2__AttributeValueId__c,
                       Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c , Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c , Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c ,Apttus_Config2__NetPrice__c ,APTS_Combination_Key__c, APTS_Combination_Key__r.Name from Apttus_Config2__AssetLineItem__c
                       where Apttus_Config2__ProductId__r.ProductCode IN :lProductCodes And Apttus_Config2__LineType__c  ='Product/Service'  And APTS_SSD_ship_to__c =:ShiptoSSD and Apttus_Config2__AssetStatus__c ='Activated'];
           if(lAssetsLines .isEmpty()){
                    isNewSSD =True;  
                }
       }          
       
       System.debug(LoggingLevel.WARN,'ShiptoSSD '+shiptoSSD);
       System.debug(LoggingLevel.WARN,'lProductCodes '+lProductCodes);
       
       if(lAssetsLines.size()>=1){
           for(Apttus_Config2__AssetLineItem__c asset: lAssetsLines){
               System.debug(LoggingLevel.WARN,'Product codee Ass----'+asset.Apttus_Config2__ProductId__r.ProductCode+'-Q-'+asset.Apttus_Config2__Quantity__c);
               mapOfProductCodeAndAssets.put(asset.Apttus_Config2__ProductId__r.ProductCode, asset); 
               system.debug(LoggingLevel.WARN,'asset map--'+mapOfProductCodeAndAssets);
               System.debug(LoggingLevel.WARN,'Product codee Ass----'+asset.Apttus_Config2__ProductId__r.ProductCode+'-Q-'+asset.Apttus_Config2__Quantity__c);
               //SOC-8550
               if(firmSiteIMCodes.contains(asset.Apttus_Config2__ProductId__r.ProductCode)){ firmsiteOrIMCount = firmsiteOrIMCount+1;
               system.debug(LoggingLevel.WARN,'Firmsite3c'+ firmsiteOrIMCount);}
               if(asset.Apttus_Config2__ProductId__r.ProductCode  == '42594853'){ flNFCSubdomain = flNFCSubdomain+asset.Apttus_Config2__Quantity__c; } //SOC-9193
                System.debug(LoggingLevel.WARN,'Asset count for landing pages---'+flNFCSubdomain);
                //SOC-9887 added by Sakshi
                //Commented By Prabhu below as part of DOC 14585 
               /*if(fldirectory.contains(asset.Apttus_Config2__ProductId__r.ProductCode)){
                 mapOfPAGEOassets.put(asset.Apttus_Config2__ProductId__r.ProductCode+'_'+asset.APTS_Combination_Key__c,asset); 
               }*/
               //SOC-9890
               
            //   if(asset.Apttus_Config2__ProductId__r.ProductCode == '42157433') SUPERLAWYERSASKANSWERPAGETotal = SUPERLAWYERSASKANSWERPAGETotal + asset.Apttus_Config2__Quantity__c; //SOC-9890
               if(asset.Apttus_Config2__ProductId__r.ProductCode == '41053157'){ fNDLWPremiumTotal = fNDLWPremiumTotal + asset.Apttus_Config2__Quantity__c; }//SOC-9890
               if(asset.Apttus_Config2__ProductId__r.ProductCode == '40586465'){ fNDLWADDLCALLTRACKINGNUMBERTotal = fNDLWADDLCALLTRACKINGNUMBERTotal + asset.Apttus_Config2__Quantity__c; }//SOC-9890
               if(asset.Apttus_Config2__ProductId__r.ProductCode == '41895338'){ fNDLWLawinfoCallTrackingNumberTotal = fNDLWLawinfoCallTrackingNumberTotal + asset.Apttus_Config2__Quantity__c; }//SOC-9890
           } 
        }
       else{
         System.debug(LoggingLevel.WARN,'Size of list'+lAssetsLines.size());   
       }
        //Commented By Prabhu below as part of DOC 14585 
        //system.debug('PAGEO MAP ---' + mapOfPAGEOassets);
        //set<string> mapkeys = mapOfPAGEOassets.keySet();
        //system.debug('Keys of asset map--'+mapkeys);
        system.debug(LoggingLevel.WARN,'firmsiteOrIMCount'+firmsiteOrIMCount);
        System.debug(LoggingLevel.WARN,'Asset count for landing pages---'+flNFCSubdomain);
        system.debug(LoggingLevel.WARN,'cancelquanity'+cancelquanity);           
       //Subscription Approval logic //SOC-7171
        List<Date> lEndDatesubscription = New List<Date>();
        Decimal dCancelTotal =0;
        
        List<Date> lEndDateNewLines = New List<Date>();
        Decimal dNewTotal =0;
        Decimal dFinalTotal =0;
        Decimal dNewTotalOptions =0;
        
        for(Apttus_Config2__LineItem__c lineItem : lineItems){
            
            //SOC-9837 starts
            if((alignContract = true) && (lineItem.Apttus_Config2__LineStatus__c == 'Renewed')){
                    if(farthestEndDate == null){
                        farthestEndDate = lineItem.APTS_Contract_End_Date__c;
                    }
                    else{
                        if(farthestEndDate < lineItem.APTS_Contract_End_Date__c){
                            farthestEndDate = lineItem.APTS_Contract_End_Date__c;}
                    }
                    if(lineItem.APTS_Contract_End_Date__c == farthestEndDate && farthestEndDate!=null){
                        finalfarthestEndDate= returnfinalfarthestEndDate(lineItem,farthestEndDate, finalfarthestEndDate);
                    }           
            }
            //SOC-9837 ends
            
            system.debug(LoggingLevel.WARN,'q1---------'+Lineitem.APTS_Product_Code__c);
            //if(lineItem.APTS_FL_Current_price__c <> null && lineItem.APTS_Contract_End_Date__c <> null && lineItem.Apttus_Config2__LineType__c =='Product/Service' && lineItem.Apttus_Config2__LineType__c !='Option' && lineItem.Apttus_Config2__ChargeType__c == 'Subscription Fee' && lineItem.Apttus_Config2__LineStatus__c =='Cancelled' &&  mapOfIdLineItems.get(Lineitem.id).Apttus_Config2__ProductId__r.ProductCode <> '41343504' &&  mapOfIdLineItems.get(Lineitem.id).Apttus_Config2__ProductId__r.ProductCode <> '41689176'  && lineItem.Apttus_Config2__LineType__c == 'Product/Service') {
        if(lineItem.APTS_FL_Current_price__c <> null && lineItem.APTS_Contract_End_Date__c <> null && lineItem.Apttus_Config2__LineType__c =='Product/Service' && lineItem.Apttus_Config2__LineType__c !='Option' && lineItem.Apttus_Config2__ChargeType__c == 'Subscription Fee' && lineItem.Apttus_Config2__LineStatus__c =='Cancelled' &&  Lineitem.APTS_Product_Code__c <> '41343504' &&  Lineitem.APTS_Product_Code__c <> '41689176') {
                dCancelTotal = dCancelTotal+lineItem.APTS_FL_Current_price__c   ;
                lEndDatesubscription.Add(lineItem.APTS_Contract_End_Date__c); 
                system.debug(LoggingLevel.WARN,'dCancelTotal'+dCancelTotal);   
            }            
            //if(lineItem.Apttus_Config2__NetPrice__c<>null && lineItem.Apttus_Config2__LineStatus__c =='New' &&  mapOfIdLineItems.get(Lineitem.id).Apttus_Config2__ProductId__r.ProductCode <> '41343504' &&  mapOfIdLineItems.get(Lineitem.id).Apttus_Config2__ProductId__r.ProductCode <> '41689176' && lineItem.Apttus_Config2__ChargeType__c <> 'Standard Price' && lineItem.Apttus_Config2__LineType__c !='Option' && lineItem.Apttus_Config2__LineType__c == 'Product/Service') {
        if(lineItem.Apttus_Config2__NetPrice__c<>null && lineItem.Apttus_Config2__LineStatus__c =='New' &&  Lineitem.APTS_Product_Code__c <> '41343504' &&  Lineitem.APTS_Product_Code__c <> '41689176' && lineItem.Apttus_Config2__ChargeType__c <> 'Standard Price' && lineItem.Apttus_Config2__LineType__c !='Option' && lineItem.Apttus_Config2__LineType__c == 'Product/Service') {
                dNewTotal = dNewTotal+lineItem.Apttus_Config2__NetPrice__c;
                 Integer nextmonth = system.today().month()+1;
                Date endDate = Date.newInstance(system.today().year(),nextmonth,1);
                Date termdate = endDate.addDays(Integer.valueof(lineitem.APTS_Contract_Term_Number__c *30));
                Date termdate1 = termdate.addMonths(1).toStartofMonth().addDays(-1); 
                lendDateNewLines.Add(termdate1);    
                system.debug(LoggingLevel.WARN,'tester');
                //lendDateNewLines.Add(lineItem.APTS_Contract_End_Date__c);    
            }
            
            if(lineItem.Apttus_Config2__NetPrice__c<>null && lineItem.Apttus_Config2__LineStatus__c =='New' && lineItem.Apttus_Config2__LineType__c =='Option' &&  (mapOfIdLineItems.get(Lineitem.id).Apttus_Config2__OptionId__r.ProductCode == '41343504' ||  mapOfIdLineItems.get(Lineitem.id).Apttus_Config2__OptionId__r.ProductCode == '41689176') && lineItem.Apttus_Config2__ChargeType__c <> 'Standard Price' ) {
                dNewTotalOptions = dNewTotalOptions+lineItem.Apttus_Config2__NetPrice__c;
            }
            if(lineItem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c =='New'){
                  if(lineItem.APTS_Product_Code__c  == '42594853'){ 
                     flNFCSubdomain = flNFCSubdomain+lineItem.Apttus_Config2__Quantity__c;}   //SOC-9193
                  
                  if(lineItem.APTS_Product_Code__c  == '41053157'){
                     fNDLWPremiumTotal = fNDLWPremiumTotal+lineItem.Apttus_Config2__Quantity__c; }//SOC-9890
                  if(lineItem.APTS_Product_Code__c  == '40586465'){
                     fNDLWADDLCALLTRACKINGNUMBERTotal = fNDLWADDLCALLTRACKINGNUMBERTotal+lineItem.Apttus_Config2__Quantity__c; }//SOC-9890
                  if(lineItem.APTS_Product_Code__c  == '41895338'){
                     fNDLWLawinfoCallTrackingNumberTotal = fNDLWLawinfoCallTrackingNumberTotal+lineItem.Apttus_Config2__Quantity__c; }//SOC-9890
            }
            //SOC-9890
            if(lineItem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c =='Cancelled'){
                  
              if(lineItem.APTS_Product_Code__c == '41053157'){
                     fNDLWPremiumCancel = fNDLWPremiumCancel+lineItem.Apttus_Config2__Quantity__c;} //SOC-9890
                  if(lineItem.APTS_Product_Code__c == '40586465'){
                     fNDLWADDLCALLTRACKINGNUMBERCancel = fNDLWADDLCALLTRACKINGNUMBERCancel+lineItem.Apttus_Config2__Quantity__c; }//SOC-9890
                  if(lineItem.APTS_Product_Code__c == '41895338'){
                     fNDLWLawinfoCallTrackingNumberCancel = fNDLWLawinfoCallTrackingNumberCancel+lineItem.Apttus_Config2__Quantity__c; }//SOC-9890
                  
            }
         //Added By Prabhu INC3387957   
         if(lineItem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c =='New'){
                system.debug(LoggingLevel.WARN,'inininini-------');
                if(firmSiteIMCodes.contains(lineItem.APTS_Product_Code__c)){
                       firmsiteOrIMCount = firmsiteOrIMCount+1; 
                }  
                system.debug(LoggingLevel.WARN,'firmsiteOrIMCount @207-----'+ firmsiteOrIMCount);   
                system.debug(LoggingLevel.WARN,'ininininipehle-------'+flNFCSubdomain);   
           }
           else if(lineItem.Apttus_Config2__LineType__c  =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c =='Cancelled'){
                if(firmSiteIMCodes.contains(lineItem.APTS_Product_Code__c)){ cancelquanity = cancelquanity+1; }      
                system.debug(LoggingLevel.WARN,'cancelquanity @173----'+cancelquanity); 
            }
        }
        
     //   SUPERLAWYERSASKANSWERPAGETotal = SUPERLAWYERSASKANSWERPAGETotal-SUPERLAWYERSASKANSWERPAGECancel; //SOC-9890
        fNDLWPremiumTotal = fNDLWPremiumTotal - fNDLWPremiumCancel; //SOC-9890
        fNDLWADDLCALLTRACKINGNUMBERTotal = fNDLWADDLCALLTRACKINGNUMBERTotal - fNDLWADDLCALLTRACKINGNUMBERCancel; //SOC-9890
        fNDLWLawinfoCallTrackingNumberTotal = fNDLWLawinfoCallTrackingNumberTotal - fNDLWLawinfoCallTrackingNumberCancel; //SOC-9890
        
        system.debug(LoggingLevel.WARN,'cancelquanity@175----'+cancelquanity);
        lendDatesubscription.sort();
        Date farestEnddate;
        if(!lendDatesubscription.isempty()){ farestEnddate = lendDatesubscription[lendDatesubscription.size()-1];}

        lendDateNewLines.sort();
        Date latestEnddate;
        if(!lendDateNewLines.isempty()){ latestEnddate = lendDateNewLines[0];}
        
       
       Decimal firmSiteQuanity = firmsiteOrIMCount-cancelquanity;
       system.debug(LoggingLevel.WARN,'firmSiteQuanity @207-----'+ firmSiteQuanity);
     
       for(Apttus_Config2__LineItem__c lineItem : lineItems){
             lineItem.APTS_PPC_Approval_Required__c = false; //SOC-6701
             lineItem.APTS_IMR_IME_Approval_Required__c = false;
             lineItem.APTS_IMS_Approval_Required__c  = false;
             lineItem.APTS_WaivedProduct_Approval_Required__c = false;
             lineItem.Findlaw_Approval_Required__c = false; //SOC-6701
           // lineItem.Findlaw_LapseApproval_Required__c=false; //SOC-9012e
             lineItem.APTS_RepType_Approval_Required__c=false;
             lineItem.APTS_Guidance_Approval_Required__c = false;
             lineItem.APTS_FL_UpgradeDowngradeApprovalRequired__c=false;
             lineItem.APTS_FS_IM_Approval_Required__c=false;
             lineItem.APTS_Answer_Service_Approval__c = false;//SOC-7996
             lineItem.APTS_FL_AnnualApprovalRequired__c = false;//SOC-4589
             lineItem.Apttus_CQApprov__Approval_Status__c = '';
             //Commented By Prabhu below as part of DOC 14585 
             //lineItem.APTS_FLDirectory_Approval_Required__c = false; //SOC-9887
             lineItem.APTS_MaxQuantity_Approval_Required__c = false; //SOC-9890
             lineItem.APTS_ExposurePack_Approval_Required__c = false; //soc-9197
             system.debug(LoggingLevel.WARN,'!!!!!!!!!!!!!!!');
             //SOC-9837 starts
            if(alignContract = true){
                if(lineItem.Apttus_Config2__LineStatus__c == 'Renewed'){
                    
                 // lineItem.APTS_AdjRenewalStartDate__c = String.valueOf(lineItem.Apttus_Config2__StartDate__c.addMonths(1).toStartofMonth()); 
                    lineItem.APTS_FL_Current_Contract_End_Date__c = lineItem.APTS_Contract_End_Date__c;
                    lineItem.APTS_FL_Renewal_Contract_End_Date__c = finalfarthestendDate;
                }   
             }
             
           //SOC-9837 ends
             
             system.debug(LoggingLevel.WARN,'ExposurePackDiscount--'+lineItem.APTS_Exposure_Pack_Disc__c+','+lineItem.Apttus_Config2__AdjustmentAmount__c);
             if(lineItem.Apttus_Config2__Guidance__c != null && lineItem.Apttus_Config2__Guidance__c != 'GREEN' && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' ){
                lineItem.APTS_Guidance_Approval_Required__c = true;
                lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
             }
             if(mapOfProductCodeAndAssets.containsKey('41915678') || mapOfProductCodeAndAssets.containsKey('41822784') || mapOfProductCodeAndAssets.containsKey('41777796') || mapOfProductCodeAndAssets.containsKey('41767150')){
                hasIMProductsAssets = true; }
             if(lineItem.APTS_Product_Code__c == '41915678' || lineItem.APTS_Product_Code__c == '41822784' || lineItem.APTS_Product_Code__c == '41777796' || lineItem.APTS_Product_Code__c == '41767150'){
                hasIMProductsLines = true;}
             if(mapOfProductCodeAndAssets.containsKey('30010890') && mapOfProductCodeAndAssets.get('30010890').Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c =='New PPC'&& mapOfProductCodeAndAssets.get('30010890').Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c !=null && mapOfProductCodeAndAssets.get('30010890').Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c =='English' ){
                hasPPCLandingAsset = true;}
             if(lineitem.APTS_Product_Code__c =='41343506' && lineitem.Apttus_Config2__LineType__c =='Product/Service' && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c  =='New PPC' && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c =='FirmSite or FindLaw Landing Page Hosting' ){
                hasPPCLandinglines = true; }
             if(mapOfProductCodeAndAssets.containsKey('42124052') || mapOfProductCodeAndAssets.containsKey('41822784') ){//changes as part of SOC-7666
                hasIMRECheckAsset = true;}
             if(lineitem.APTS_Product_Code__c == '42124052' || lineitem.APTS_Product_Code__c == '41822784'){//changes on the SOC-7666
                hasIMRECheckCart = true;}
             if(mapOfProductCodeAndAssets.containsKey('41777796')){//changes as part of SOC-7666
                hasIMSCheckAsset = true;}
             if(lineitem.APTS_Product_Code__c == '41777796'){
                hasIMSCheckCart = true;}//changes ended SOc-7666
             if(mapOfProductCodeAndAssets.containsKey('30010890') && mapOfProductCodeAndAssets.get('30010890').Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c =='New PPC'&& mapOfProductCodeAndAssets.get('30010890').Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c !=null && mapOfProductCodeAndAssets.get('30010890').Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c =='Español' ){
                hasPPCLandingEspanolAsset = true; }
             if(lineitem.APTS_Product_Code__c =='30010890' && lineitem.Apttus_Config2__LineType__c =='Product/Service' && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c=='English' && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c  =='New PPC'
                  && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c !=null){
                 hasPPCLinesEng = true;}
             if(lineitem.APTS_Product_Code__c =='30010890' && lineitem.Apttus_Config2__LineType__c =='Product/Service' && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c=='Español' && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c  =='New PPC'
                  && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c !=null){
                 hasPPCLinesEsp = true;  }  
                 
                 //SOC-9887, 2/4/2019 starts
                 //Commented By Prabhu below as part of DOC 14585 
             /*if(fldirectory.contains(lineItem.APTS_Product_Code__c) && lineItem.Apttus_Config2__LineType__c =='Product/Service' && lineItem.Apttus_Config2__LineStatus__c == 'Renewed' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.APTS_Rep_Type_Description__c&& (lineItem.APTS_Product_Code__c=='37005072'||lineItem.APTS_Product_Code__c=='40987607'||lineItem.APTS_Product_Code__c=='40987608'||lineItem.APTS_Product_Code__c=='41680342'||lineItem.APTS_Product_Code__c=='37005004'||lineItem.APTS_Product_Code__c=='37005005'||lineItem.APTS_Product_Code__c=='41976905'||lineItem.APTS_Product_Code__c=='42088301')){
                  System.debug('FL Renewal Directory Block ='+lineItem.APTS_Rep_Type_Description__c);
                  String prodDetail = lineItem.APTS_Product_Code__c + '_' + lineItem.APTS_Combination_Key__c;
                  if(mapOfPAGEOassets.containsKey(prodDetail)){
                     Apttus_Config2__AssetLineItem__c assetli = new Apttus_Config2__AssetLineItem__c();
                     assetli = mapOfPAGEOassets.get(prodDetail);
                     if(lineItem.Inventory_Available_Product_Detail__c == 0){
                        //SOC-10054, added adj amt in if condition
                        if((((lineItem.APTS_Contract_Term__c == '1 Year' && lineItem.Apttus_Config2__AdjustmentAmount__c > 20 && lineItem.Apttus_Config2__AdjustmentAmount__c <= 50) || (lineItem.APTS_Contract_Term__c == '2 Years' && lineItem.Apttus_Config2__AdjustmentAmount__c > 25 && lineItem.Apttus_Config2__AdjustmentAmount__c <= 50) || (lineItem.APTS_Contract_Term__c == '3 Years' && lineItem.Apttus_Config2__AdjustmentAmount__c > 30 && lineItem.Apttus_Config2__AdjustmentAmount__c <= 50)) && lineItem.Apttus_Config2__NetPrice__c < (1.05 * assetli.Apttus_Config2__NetPrice__c)) || lineItem.Apttus_Config2__AdjustmentAmount__c > 50){
                        lineItem.APTS_FLDirectory_Approval_Required__c = true;
                        lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                        system.debug('RK --> FLD  = '+lineItem.APTS_FLDirectory_Approval_Required__c);
                     }}
                     else{
                        //SOC-10054, added adj amt in if condition
                        if(((lineItem.APTS_Contract_Term__c == '1 Year' && lineItem.Apttus_Config2__AdjustmentAmount__c > 20) || (lineItem.APTS_Contract_Term__c == '2 Years' && lineItem.Apttus_Config2__AdjustmentAmount__c > 25) || (lineItem.APTS_Contract_Term__c == '3 Years' && lineItem.Apttus_Config2__AdjustmentAmount__c > 30)) && lineItem.Apttus_Config2__NetPrice__c < assetli.Apttus_Config2__NetPrice__c){
                        lineItem.APTS_FLDirectory_Approval_Required__c = true;
                        lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required'; 
                        system.debug('RK --> 2FLD  = '+lineItem.APTS_FLDirectory_Approval_Required__c);
                     }}          
                  } 
             }  */
                 //SOC-9887, 2/4/2019 ends
                 
              //SOC-6724 Start
             /*if(lineitem.Apttus_Config2__LineType__c =='Product/Service' && lineitem.Apttus_Config2__LineStatus__c == 'New' && lineitem.Apttus_Config2__ChargeType__c == 'Subscription Fee' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineitem.Apttus_Config2__NetPrice__c!=null){
                 flCalcattheend = flCalcattheend+lineitem.Apttus_Config2__NetPrice__c;}                                                 
             if(anualSpend!=null){
                 lineitem.APTS_FL_Annual_spend_Calc__c=flCalcattheend+anualSpend; 
                 system.debug(LoggingLevel.WARN,'!!!!!'+lineitem.APTS_FL_Annual_spend_Calc__c);  
              }             
             else{
                 lineitem.APTS_FL_Annual_spend_Calc__c=flCalcattheend; 
                 system.debug(LoggingLevel.WARN,'!!!!!'+lineitem.APTS_FL_Annual_spend_Calc__c);  
               }
               */ 
              //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper1'
              lineitem= APTS_FL_LineItemTriggerHelper1.returnLineItemAnnualSpendCalc(lineitem,anualSpend);
           //SOC-6724 End     
                        
             if(lineitem.Apttus_Config2__AdjustmentAmount__c==100 && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineitem.Apttus_Config2__LineStatus__c == 'New'){
                 lineitem.APTS_WaivedProduct_Approval_Required__c=true;
                 lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                 system.debug(LoggingLevel.WARN,'##### In');
             }  
             if(((lineItem.APTS_Product_Code__c =='41876119' &&  !(hasPPCLandingAsset || hasPPCLinesEng)) || (lineItem.APTS_Product_Code__c =='41877783' && !(hasPPCLandingEspanolAsset || hasPPCLinesEsp))) && lineItem.Apttus_Config2__LineType__c  =='Product/Service' && (hasIMProductsAssets || hasIMProductsLines) ){
                 lineItem.APTS_PPC_Approval_Required__c = true;
                 lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                 system.debug(LoggingLevel.WARN,'##### In');
             }
             if(lineItem.APTS_Product_Code__c =='40542344' && lineitem.Apttus_Config2__LineStatus__c == 'New'  && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && (hasIMRECheckCart == true || hasIMRECheckAsset == true )){//Changes of SOC-7666
                 lineItem.APTS_IMR_IME_Approval_Required__c = true;
                 lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                 system.debug(LoggingLevel.WARN,'##### In');
             }
             if (lineItem.APTS_Product_Code__c =='40542345' && lineitem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && (hasIMSCheckCart == true || hasIMSCheckAsset == true)){//Changes of SOc-7666
                 lineItem.APTS_IMS_Approval_Required__c = true;
                 lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required'; 
                 system.debug(LoggingLevel.WARN,'##### In');
             }
             //AS part of SOC-9197 added exposure pack discount condition
             /*if((lineItem.Apttus_Config2__LineStatus__c == 'Renewed' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.APTS_Renewal_Approval_Required__c== true) || (lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Contract_Term__c=='1 Year' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.APTS_IMS_IME_Product__c==true)){
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
             }*/

             //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper1'
             lineItem = APTS_FL_LineItemTriggerHelper1.returnLineItemExposurePack(lineItem);
             
                //Added by Gowthami for SOC-7996 FL:Approval for Contract 2 or 3 yr 
                /*system.debug(LoggingLevel.WARN,'!!!!!'+lineitem.APTS_FL_Annual_spend_Calc__c);  
             if((lineItem.Apttus_Config2__LineStatus__c == 'Renewed' ||lineItem.Apttus_Config2__LineStatus__c == 'New') && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && (lineItem.APTS_Contract_Term__c=='2 Years' || lineItem.APTS_Contract_Term__c=='3 Years') && (lineItem.APTS_Product_Code__c =='42532852' || lineItem.APTS_Product_Code__c == '42532853' || lineItem.APTS_Product_Code__c == '42532854' || lineItem.APTS_Product_Code__c == '42532855' )){
                 lineItem.APTS_Answer_Service_Approval__c= true;
                 lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';  
                system.debug(LoggingLevel.WARN,'##### In');                
             }*/
             
             //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper1'
             lineItem = APTS_FL_LineItemTriggerHelper1.returnLineItemContractYear(lineItem);

             //Added by Gowthami for SOC-4589 FL-Annual Spend Approval  
             /*if(lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && (lineItem.APTS_Product_Code__c == '42532854' || lineItem.APTS_Product_Code__c == '42532852') && lineitem.APTS_FL_Annual_spend_Calc__c >100000 ){
                 lineItem.APTS_FL_AnnualApprovalRequired__c = true;
                 lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';     
                 system.debug(LoggingLevel.WARN,'!!!!!'+lineitem.APTS_FL_Annual_spend_Calc__c);   
             }   
    
            if(lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && (lineItem.APTS_Product_Code__c == '42532853' || lineItem.APTS_Product_Code__c == '42532855') && lineitem.APTS_FL_Annual_spend_Calc__c > 200000 ){
                lineItem.APTS_FL_AnnualApprovalRequired__c = true;
                lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required'; 
                system.debug(LoggingLevel.WARN,'##### In');
            }*/
            //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper2'
            lineItem = APTS_FL_LineItemTriggerHelper2.returnLineItemAnnualSpendApp(lineItem);

             //Added by Deepthi Shirangala for SOC-4550 and SOC-6861
           //7. Logic to populate 'PPC Approval Required Checkbox'
             /*if((lineItem.APTS_PPC_Rounded_Value__c <500 || lineItem.APTS_PPC_Rounded_Value__c>10000 || mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Mgmt_Fee_Override__c >0) && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && (lineItem.APTS_Product_Code__c != '41876119'  || lineItem.APTS_Product_Code__c != '41877783' )&& lineItem.APTS_Product_Code__c != '41877783' && flcodeMap.get('PPC MANAGEMENT').contains(lineItem.APTS_CAT_L5__c) && mapOfIdLineItems.get(lineItem.id).Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c <> null ){
                 lineItem.APTS_PPC_Approval_Required__c = true;
                 lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                 system.debug(LoggingLevel.WARN,'!!!!!!!!!!!!!!!'+lineitem.APTS_PPC_Approval_Required__c); 
             }*/ //APTS_PPC_TYPE__C &&mProductAttvalue
            //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper2'
            lineItem = APTS_FL_LineItemTriggerHelper2.returnLineItemApprReqdChckBox(lineItem, flcodeMap, mapOfIdLineItems);
             //SOC-7222 //SOC-9012
          /*   if(lineItem.Apttus_Config2__AssetLineItemId__c != Null && !String.isBlank(lineItem.APTS_Info_PlanType__c)){
                 MYR_Types__c myrValues =MYR_Types__c.getValues(lineItem.APTS_Info_PlanType__c);
                 if(lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineStatus__c == 'Cancelled' && myrValues != Null){
                    lineItem.Findlaw_LapseApproval_Required__c = true;
                    lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                 } 
              }  */
              //SOC-6701-End
             //if condition logic by Apttus(ssuri@apttus.com) -- Dated:- 02-June-2017 ends    
             //SOC-6687 Start Added by Deepthi Shirangala
             //SOC-9188
             /* Requirement is to implement Additional Short Term Options of 1 and 2 Month for PPC & requiring approval */
             /*if((flcodeMap.get('PPC MANAGEMENT').contains(lineItem.APTS_CAT_L5__c) || lineItem.APTS_Product_Code__c == '42594853') &&  lineItem.Apttus_Config2__LineStatus__c == 'New'&& (lineItem.APTS_Contract_Term__c =='1 Month' || lineItem.APTS_Contract_Term__c =='2 Months') ){
                   lineItem.APTS_PPC_Approval_Required__c = true;
                   lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required'; 
                   system.debug(LoggingLevel.WARN,'##### In');
              }*/
            //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper2'
            lineItem = APTS_FL_LineItemTriggerHelper2.returnLineItemShortTermOptn(lineItem,flcodeMap);
              //SOC-6687 End
              //SOC-7051 starts,Added by Keerthana            
             /*if(lineItem.APTS_RLP_FLApproval_Required__c && lineItem.APTS_Rep_Type_Description__c && lineItem.APTS_Proposal_Business_Unit__c=='Findlaw'&& lineItem.Apttus_Config2__LineStatus__c == 'Renewed'){              
                 lineItem.APTS_RepType_Approval_Required__c=true;
                 lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                 system.debug(LoggingLevel.WARN,'##### In');
              }*/
            //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper3'
            lineItem = APTS_FL_LineItemTriggerHelper3.returnLineItemRLPApp(lineItem);
              //SOC-7051 ends   
             
           //Subscription Approval //SOC-7171
           System.debug(LoggingLevel.WARN,'lineitem.Apttus_Config2__LineStatus__c'+lineitem.Apttus_Config2__LineStatus__c);
           System.debug(LoggingLevel.WARN,'lineItem.Apttus_Config2__LineType__c'+lineItem.Apttus_Config2__LineType__c);
           System.debug(LoggingLevel.WARN,'lineitem.Apttus_Config2__ChargeType__c'+lineitem.Apttus_Config2__ChargeType__c);
           if(lineitem.Apttus_Config2__LineStatus__c  =='Cancelled' 
                && lineItem.Apttus_Config2__LineType__c =='Product/Service' 
                && lineItem.Apttus_Config2__LineType__c !='Option' 
                && mapOfIdLineItems.get(Lineitem.id).Apttus_Config2__ProductId__r.ProductCode <> '41343504' 
                && mapOfIdLineItems.get(Lineitem.id).Apttus_Config2__ProductId__r.ProductCode <> '41689176' 
                && lineitem.Apttus_Config2__ChargeType__c <> 'Standard Price'){
               System.debug(LoggingLevel.WARN,'dNewTotal'+dNewTotal);
               System.debug(LoggingLevel.WARN,'dCancelTotal'+dCancelTotal );
               //System.debug('dMonthsDiff '+dMonthsDiff);
               System.debug(LoggingLevel.WARN,'inside first if');
               dFinalTotal = dNewTotal-dNewTotalOptions;
               System.debug(LoggingLevel.WARN,'dNewTotalOptions---'+dNewTotalOptions);
               System.debug(LoggingLevel.WARN,'dFinalTotal---'+dFinalTotal);
               System.debug(LoggingLevel.WARN,'final---latestEnddate '+latestEnddate );
               System.debug(LoggingLevel.WARN,'final---farestEnddate'+farestEnddate);
               
               //if((dFinalTotal > dCancelTotal && dMonthsDiff < 12) || (dFinalTotal < dCancelTotal && dMonthsDiff > 12) || (dFinalTotal < dCancelTotal && dMonthsDiff < 12)){
               if((dFinalTotal > dCancelTotal && latestEnddate < farestEnddate) || (dFinalTotal < dCancelTotal && latestEnddate < farestEnddate) || (dCancelTotal > dFinalTotal && latestEnddate > farestEnddate)){
                   System.debug(LoggingLevel.WARN,'Inside Upgrade');
                   lineItem.APTS_FL_UpgradeDowngradeApprovalRequired__c=true;
                   lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
                   system.debug(LoggingLevel.WARN,'##### In');
               }
           }
           //System.debug(LoggingLevel.WARN,'lineItem.APTS_Product_Code__c---'+lineItem.APTS_Product_Code__c);
           //SOC-8550
           //added product codes for IME2 and CORE as part of SOC-9084
           //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper3'
           lineItem = APTS_FL_LineItemTriggerHelper3.returnFSIMAppRequired(lineItem, firmSiteIMCodes, firmSiteQuanity);
           /*if(firmSiteIMCodes.contains(lineItem.APTS_Product_Code__c) && firmSiteQuanity>1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
               lineItem.APTS_FS_IM_Approval_Required__c= true;
               system.debug(LoggingLevel.WARN,'lineItem.APTS_FS_IM_Approval_Required__c'+lineItem.APTS_FS_IM_Approval_Required__c);
               lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';
               system.debug(LoggingLevel.WARN,'##### In');
               
           }*/
           //SOC-9193
           //system.debug(LoggingLevel.WARN,'flNFCSubdomain-----:'+flNFCSubdomain);
           //Commented by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper3'
           lineItem = APTS_FL_LineItemTriggerHelper3.returnNFCQTYAppRequired(lineItem, flNFCSubdomain);
           /*if(lineItem.APTS_Product_Code__c == '42594853' && flNFCSubdomain >1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
               lineItem.APTS_NFC_Qty_Approval_Required__c= true;
               system.debug(LoggingLevel.WARN,'lineItem.APTS_NFC_Qty_Approval_Required__c---'+lineItem.APTS_NFC_Qty_Approval_Required__c);
               lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';   
               system.debug(LoggingLevel.WARN,'##### In');
           }*/
           //SOC-9890
             
            
           
       /*    if(lineItem.APTS_Product_Code__c == '42157433' && SUPERLAWYERSASKANSWERPAGETotal > 1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
               lineItem.APTS_MaxQuantity_Approval_Required__c = true;
               lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';  
               system.debug('##### In');
           }    */
           //Commented below by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper3'
           lineItem = APTS_FL_LineItemTriggerHelper3.returnMaxQtyAppRequired1(lineItem, fNDLWPremiumTotal);
           /*if(lineItem.APTS_Product_Code__c == '41053157' && fNDLWPremiumTotal > 1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
               lineItem.APTS_MaxQuantity_Approval_Required__c = true;
               lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';  
               system.debug(LoggingLevel.WARN,'##### In');
           }*/
           //Commented below by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper3'
           lineItem = APTS_FL_LineItemTriggerHelper3.returnMaxQtyAppRequired2(lineItem, fNDLWADDLCALLTRACKINGNUMBERTotal);
           /*if(lineItem.APTS_Product_Code__c == '40586465' && fNDLWADDLCALLTRACKINGNUMBERTotal > 1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
               lineItem.APTS_MaxQuantity_Approval_Required__c = true;
               lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required';  
               system.debug(LoggingLevel.WARN,'##### In');
           }*/
           //Commented below by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)' --Logic moved to class 'APTS_FL_LineItemTriggerHelper3'
           lineItem = APTS_FL_LineItemTriggerHelper3.returnMaxQtyAppRequired3(lineItem, fNDLWLawinfoCallTrackingNumberTotal);
           /*if(lineItem.APTS_Product_Code__c == '41895338'&& fNDLWLawinfoCallTrackingNumberTotal > 1 && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Proposal_Business_Unit__c == 'FindLaw' && lineItem.Apttus_Config2__LineType__c =='Product/Service'){
               lineItem.APTS_MaxQuantity_Approval_Required__c = true;
               lineItem.Apttus_CQApprov__Approval_Status__c = 'Approval Required'; 
               system.debug(LoggingLevel.WARN,'##### In');
           }*/
          
       } 
       
    }
    //Added by Tanmay as a part of PMD Fix '(rule: Design-CyclomaticComplexity)'
    @testVisible
    private static Date returnfinalfarthestEndDate(Apttus_Config2__LineItem__c lineItem, Date farthestEndDate, Date finalfarthestEndDate){

        if(lineItem.APTS_Contract_Term__c == '1 Year'){
            finalfarthestEndDate = farthestEndDate.addYears(1);}
        if(lineItem.APTS_Contract_Term__c == '2 Years'){
            finalfarthestEndDate = farthestEndDate.addYears(2);}
        if(lineItem.APTS_Contract_Term__c == '3 Years'){
            finalfarthestEndDate = farthestEndDate.addYears(3);}

        return finalfarthestEndDate;
    }
    //SOC-5862 Start
    /**
     * @description Below code added by Deepthi Shirangala on 12/6/17.
     *              Requirement is to populate category Name field.
     * @param lConfiglines
     */
    public Static void populateCategory(List<Apttus_Config2__LineItem__c > lConfiglines){
        Set<ID> sProducts = New Set<ID>();
        Map<ID,Apttus_Config2__ProductClassification__c > mCatageory = New Map<id,Apttus_Config2__ProductClassification__c>();
        for(Apttus_Config2__LineItem__c lines : lConfiglines){
            //if(lines.Apttus_Config2__ClassificationId__c ==null || lines.Apttus_Config2__ClassificationId__c  =='')
                sProducts.Add(lines.Apttus_Config2__ProductId__c );
        }
        
        for(Apttus_Config2__ProductClassification__c  ch : [select id,Apttus_Config2__ProductId__c, Apttus_Config2__ClassificationId__c,Apttus_Config2__ClassificationId__r.Name  from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__c IN :sProducts]){
            mCatageory.put(ch.Apttus_Config2__ProductId__c, ch);
        }
        
        for(Apttus_Config2__LineItem__c lines : lConfiglines){
            //if(lines.Apttus_Config2__ClassificationId__c ==null && lines.Apttus_Config2__ClassificationId__c  =='')
               if(mCatageory.containskey(lines.Apttus_Config2__ProductId__c)){
                    if(mCatageory.get(lines.Apttus_Config2__ProductId__c).Apttus_Config2__ClassificationId__c <>null){
                        lines.APTS_Category_Name__c  
                        = mCatageory.get(lines.Apttus_Config2__ProductId__c).Apttus_Config2__ClassificationId__r.Name; }
                } 
       }
        
        
    }
    //SOC-5862 End

}