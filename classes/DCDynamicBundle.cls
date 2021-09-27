/* CHANGE HISTORY
==================================================================================================================================
Date         Name                  Description
2018-06-19   Srikanth Kota         DLT-9753 -APTS_Source_System_Detail_c is update with Proposal Sold To SSD(APTS_SSD_Sold_To_c) and removed Account as per GLI.
2018-08023   Poonam Garg           DLT 11818- Added null checks for groupNameMap,groupListTobeInsert and addGroup.
2018-12-21   Navleen Kaur          DLT-14155 : [Tech Story] [Code Scan] - Fix Code Scan Security Issues
2019-01-08   Navleen Kaur          DLT-14349 : [Tech Story] [Code Scan] 
2019-04-11   HarikaSai P           DLT-15968 - Create Data Layer (operational Layer)
2019-05-24   Harika Sai P          DLT-16538 - [SLF][Tech Story] Enhance exception processing - Digital_GenerateDocumentsBatch 
2020-12-14   Benjamin Her          DLT-21165 - Create Dynamic Bundle as a line item (Order Capture update)
==================================================================================================================================   
*/
public without sharing class DCDynamicBundle{
    private static list<string> groupNameList;
    private static set<String> setOfTabNames = new Set<String>{'Print','Online/Software'};
    // Custom Settings variables ===============================
    private static final String CUSTOMSETTINGSNAME = 'Bundle Page Properties';
    private static APTS_ConfigBundlePageSettings__c bundlePageSettings{get; set;}
    private static Set<String> onlineCodes;
    private static Set<String> printCodes;
    private static  Set<String> setOfWPKValid;
    private static List<String> adjustmentPicklistValues;
    private static boolean hasBundleProduct = false;
    
    private static String allName{get; set;}
    private static Set<String> ineligibleExistingDealsList;
    private static Map<Id,BundleData> cartToBundleData = new Map<Id,BundleData>();
    private static Map<Id,decimal> bundleProdIdToLineNumber = new Map<id,decimal>();

    private static List<Id> configIds = new List<Id>();
    private static Map<String,Apttus_Config2__ProductConfiguration__c> busTypeMap = new Map<String, Apttus_Config2__ProductConfiguration__c>();
    private static Set<Id> proposalIds = new Set<Id>();
    private static Map<Id, List<Apttus_Config2__LineItem__c>> lnItemsMap = new Map<Id, List<Apttus_Config2__LineItem__c>>();
    //Used in both methods: Add these into wrapper
    private static DynamicBundleWrapper bundlewrapper = new DynamicBundleWrapper();
    /**
     * Get values from APTS_ConfigBundlePageSettings based on Custom setting name  
    */
    private static void configCustomSettings(){
        Map<String, APTS_ConfigBundlePageSettings__c> configBundlePageList = APTS_ConfigBundlePageSettings__c.getall();
        
        if(!configBundlePageList.isEmpty()
           && configBundlePageList.containsKey(CUSTOMSETTINGSNAME)) {
               bundlePageSettings = configBundlePageList.get(CUSTOMSETTINGSNAME);
           }
        
        String[] onlineCodesStr = bundlePageSettings.Eligibility_codes_for_online_software__c.split(',');
        String[] printCodesStr = bundlePageSettings.Eligibility_codes_for_print__c.split(',');
        
        onlineCodes = new Set<String>(onlineCodesStr);
        printCodes = new Set<String>(printCodesStr);
        
        setOfWPKValid = new Set<String>(bundlePageSettings.WestPack_valid_codes__c.split(','));
        adjustmentPicklistValues = new List<String>(bundlePageSettings.Adjustment_Picklist_Values__c.split(','));
        ineligibleExistingDealsList = new Set<String>(bundlePageSettings.Ineligible_Existing_Deals__c.split(','));
        allName = bundlePageSettings.Main_Bundle_Name__c;
        
    }
    

    //Retrive all configurations createddate today  
    public static void performBundling(String groupId, List<Apttus_Config2__ProductConfiguration__c> configList){
        configCustomSettings();
        groupNameList = new list<string>();
        allName = groupId;
        System.debug('group name --------'+ getGroupPicklistValues(groupId));
        groupNameList.addAll(getGroupPicklistValues(groupId));
        System.debug('configList ----------------'+ configList.size());
        for(Apttus_Config2__ProductConfiguration__c obj : configList){
            configIds.add(obj.Id);
            busTypeMap.put(obj.Id, obj);
            proposalIds.add(obj.Apttus_QPConfig__Proposald__c);
            System.debug('obj.Apttus_Config2__Status__c---------'+ obj.Apttus_Config2__Status__c);
        }
        //update configList;
        System.debug('configIds ---------------'+ configIds);
        
        lnItemsMap = DCDynamicBundleHelper.retriveLineItemList(configIds,ineligibleExistingDealsList);
        System.debug('lnItemsMap -------------------'+ lnItemsMap);
        System.debug('ineligibleExistingDealsList---------------'+ ineligibleExistingDealsList);
        
        addGroupLineitems();
    }
    
    //Mapping of tab names to line items  
    public static Map<String, List<Apttus_Config2__LineItem__c>> mapTabNameToLineItems(List<Apttus_Config2__LineItem__c> lineItems){
        Map<String, List<Apttus_Config2__LineItem__c>> retMap = new Map<String, List<Apttus_Config2__LineItem__c>>();
        for(String tabName : setOfTabNames){
            retMap.put(tabName, new List<Apttus_Config2__LineItem__c>());
        }
        
        for(Apttus_Config2__LineItem__c li: lineItems){
            if(li.Apttus_Config2__ChargeType__c != 'Subscription Fee'){
                continue;
            }
            
            //For options
            if(li.Apttus_Config2__LineType__c != 'Option'){
                mapTabNameToLineItemsHelper(li,retmap);
            }
        }
        System.debug('retMap -----------------'+ retMap);
        return retMap;
    }

    private static Map<String, List<Apttus_Config2__LineItem__c>> mapTabNameToLineItemsHelper(Apttus_Config2__LineItem__c li,Map<String, List<Apttus_Config2__LineItem__c>> retMap){
        Map<String, List<Apttus_Config2__LineItem__c>> tempMap = retMap;
        if(li.Apttus_Config2__AttributeValueId__c!=null 
            && ((li.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c != null && li.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c.contains('APP')&&printCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c))
            || (li.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c != null && li.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c.contains('APP')&&printCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c)))){
                tempMap.get('Print').add(li);
            }
        else if(onlineCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c+li.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c)){
            tempMap.get('Online/Software').add(li);
        }  
        return tempMap;
    }

    private static void addGroupLineitems(){

        bundlewrapper.grpList = DCDynamicBundleHelper.getGrouplnItems(proposalIds); 
        if(!bundlewrapper.grpList.isEmpty()){  
            for(APTS_Group__c previousGroup : bundlewrapper.grpList){
                if(previousGroup.APTS_MLA__c){
                    bundlewrapper.isMLA = previousGroup.APTS_MLA__c;
                }
                if(previousGroup.APTS_Decentralized__c){
                    bundlewrapper.decentralized = previousGroup.APTS_Decentralized__c;
                }
            }
        }
        //Id accountId = null;
        doinit();
        parseAndSaveData();

    }

    private static void doinit(){

        for(Id obj : configIds){

            bundlewrapper.lnItemList.addAll(lnItemsMap.get(obj));
            bundlewrapper.lnItems = lnItemsMap.get(obj);
            Map<String, List<Apttus_Config2__LineItem__c>> tabNameTolineItem = mapTabNameToLineItems(bundlewrapper.lnItems);
            for(String tabName : setOfTabNames){
                doInitHelper(obj,tabName,tabNameTolineItem);
            }
        }
        
        System.debug('bundlewrapper.groupListTobeInsert -----------------'+ bundlewrapper.groupListTobeInsert);
        //End Group type specific
        if(!bundlewrapper.groupListTobeInsert.isEmpty() && Schema.sObjectType.APTS_Group__c.isCreateable()){
            //if(groupId == ''){
            insert bundlewrapper.groupListTobeInsert;
            //}
        }
    }

    private static void doInitHelper(Id obj,String tabName,Map<String, List<Apttus_Config2__LineItem__c>> tabNameTolineItem){

        //Start tab specific
        List<Apttus_Config2__LineItem__c> liList = tabNameTolineItem.get(tabName);

        //If line item list is empty, exit metho
        if(liList.isEmpty()){
            return;
        }
        map<string,list<Apttus_Config2__LineItem__c>> lineGroupMap = new map<string,list<Apttus_Config2__LineItem__c>>();
        Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap = new Map<String, List<Apttus_Config2__LineItem__c>>();
        lineGroupMap = mapOfLnByGrp(liList, assetPreGroupMap, tabName);
        system.debug('###assetPreGroupMap--> '+assetPreGroupMap.size());
        
        System.debug('groupNameList------------'+groupNameList);

        for(string keyStr : groupNameList){
            APTS_Group__c grp =  new APTS_Group__c();
            grp.APTS_Group_Name__c = tabName+' '+keyStr;
            grp.APTS_Group_Name_Original__c = tabName+' '+keyStr;
            grp.APTS_ProductConfiguration__c = obj;
            grp.APTS_Discount_Amount__c=null;
            grp.APTS_Quantity__c=null;
            setGroupProposalField(grp,obj);
            setGroupMLA(grp,tabName,keyStr);
            
            Set<String> optionList = new Set<String>();
            List<Decimal> netAmounts = new List<Decimal>{0,0,0,0,0,0,0};
            List<Apttus_Config2__LineItem__c> liLists = new List<Apttus_Config2__LineItem__c>();


            list<Apttus_Config2__LineItem__c> lineItemsOfGroup =  new list<Apttus_Config2__LineItem__c>();
            if(!lineGroupMap.isEmpty()){
                //If there are already items in the bundle
                if(lineGroupMap.containsKey(keyStr)){
                    lineItemsOfGroup = lineGroupMap.get(keyStr);
                }
                //It's an empty bundle. Try to put the other map in this bundle
                else{
                    getFromAssetPreGroupMap(assetPreGroupMap,lineItemsOfGroup,tabName);

                }
                
                if(tabName == 'Online/Software' && keyStr != allName && !assetPreGroupMap.isEmpty()){
                    for(String key : assetPreGroupMap.keySet()){
                        lineItemsOfGroup.addAll(assetPreGroupMap.get(key));
                        assetPreGroupMap.remove(key);
                    }
                }
                
                system.debug('###lineItemsOfGroup--> '+lineItemsOfGroup.size());
                
                netAmounts= calculateNets(lineItemsOfGroup, optionList, liLists);
                System.debug('liLists ----------'+ liLists);
                setGroupPrimaryMaterial(grp);
            }
            netAmounts= calculateNets(bundlewrapper.lnItems, optionList, liLists);
            System.debug('netAmounts -----------'+ netAmounts);
            //netAmount, grossAmount, incrementalRevenue, incrementalRevenueRequired
            Decimal existingAgreementTotal = netAmounts[0];
            grp.APTS_Adjustment_Type__c = 'Select Adjustment'; 
            grp.APTS_NetAmount__c = netAmounts[0];
            grp.APTS_Incremental_Revenue__c = netAmounts[2];
            grp.APTS_Incremental_Revenue_Required__c = netAmounts[3];
            grp.APTS_Incremental_Revenue_Above_Threshold__c = netAmounts[2] - netAmounts[3];
            grp.APTS_Existing_Agreement_Total__c = netAmounts[0];
            grp.APTS_Online_Incremental__c = 0;
            grp.APTS_Max_Blended_Discount__c = netAmounts[5];
            
            bundlewrapper.groupListTobeInsert.add(grp);
        }
    }
    
    private static void setGroupPrimaryMaterial(APTS_Group__c grp){

        Apttus_Config2__LineItem__c li = DCDynamicBundleHelper.getFirstLineItem(bundlewrapper.lnItems);
        if(null !=  li){
            System.debug('li.APTS_Group_Primary_Material_Name__c ---- '+li.APTS_Group_Primary_Material_Name__c);
            System.debug('-------------group--'+ li.APTS_Product_Group_Primary_Material__c.substring(0,li.APTS_Product_Group_Primary_Material__c.indexOf(':')));
            String primaryMat = li.APTS_Product_Group_Primary_Material__c.substring(0,li.APTS_Product_Group_Primary_Material__c.indexOf(':'));
            grp.APTS_Primary_Material__c = primaryMat;
            System.debug('primaryMat -----------'+ primaryMat);
            bundlewrapper.materialNumber = li.APTS_Product_Group_Primary_Material__c.substring(li.APTS_Product_Group_Primary_Material__c.indexOf(':')+1,li.APTS_Product_Group_Primary_Material__c.length());
            bundlewrapper.matrialMap.put(li.Apttus_Config2__ConfigurationId__c, bundlewrapper.materialNumber);
        }
    }
    private static void setGroupMLA(APTS_Group__c grp,String tabName,string keyStr){

        if(tabName == 'Online/Software' && keyStr != allName){
            grp.APTS_MLA__c = bundlewrapper.isMLA;
            grp.APTS_Decentralized__c = bundlewrapper.decentralized;
        }
    }
    private static void setGroupProposalField(APTS_Group__c grp,Id obj ){

        if(busTypeMap.get(obj).Apttus_Config2__BusinessObjectType__c == 'Proposal'){
            grp.APTS_Quote_Proposal__c = busTypeMap.get(obj).Apttus_QPConfig__Proposald__c;
        }
        else{
            grp.APTS_Agreement__c = busTypeMap.get(obj).Apttus_QPConfig__Proposald__c;
        }
    }
    private static void getFromAssetPreGroupMap(Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap,list<Apttus_Config2__LineItem__c> lineItemsOfGroup,String tabName){
        if(!assetPreGroupMap.isEmpty()){
            for(String key : assetPreGroupMap.keySet()){
                if(tabName != 'Online/Software'){
                    lineItemsOfGroup = assetPreGroupMap.get(key);
                    assetPreGroupMap.remove(key);
                    break;
                }
            }
        }
    }
    private static void populateGroupNameMap(Map<String, String> groupNameMap){

        if(bundlewrapper.grpList.isEmpty()){
            return;
        }

        for(APTS_Group__c ln: bundlewrapper.grpList){
            if(bundlewrapper.groupListTobeInsert!=null && bundlewrapper.groupListTobeInsert[0]!=null && bundlewrapper.groupListTobeInsert[0].id!=null){
                if(bundlewrapper.groupListTobeInsert[0].Id == ln.Id){
                    groupNameMap.put(ln.Id, ln.APTS_Group_Name__c);
                }
            }
            System.debug('material '+ln.APTS_Primary_Material__c);
        }
            
        
    }
    private static void setMLAAgreementNumber(Apttus_Config2__LineItem__c ln){
        if(ln.APTS_SAP_MLA_Agreement_Number__c != null){
            bundlewrapper.mlaAgreementNumber = ln.APTS_SAP_MLA_Agreement_Number__c;
        }  
    }
    private static void updateLineItemDetails(Apttus_Config2__LineItem__c ln,Map<String, String> groupNameMap,List<Apttus_Config2__LineItem__c> lnItemsToUpdate){
        if(null != ln.Apttus_Config2__Quantity__c 
            && groupNameMap!=null && !groupNameMap.isEmpty() 
            && bundlewrapper.groupListTobeInsert!=null 
            && !bundlewrapper.groupListTobeInsert.isEmpty() 
            && bundlewrapper.groupListTobeInsert[0]!=null 
            && bundlewrapper.groupListTobeInsert[0].id!=null){

            System.debug('bundlewrapper.existOnlineSoftwareProduct------------'+ bundlewrapper.existOnlineSoftwareProduct);
            bundlewrapper.existOnlineSoftwareProduct = true;
            System.debug('-----primary '+ln.APTS_SAP_Deal_Primary_Material__c);
            
            System.debug('grpName ----------'+ allName);
            System.debug('bundlewrapper.materialNumber -----------------'+ bundlewrapper.matrialMap.get(ln.Apttus_Config2__ConfigurationId__c));
            ln.APTS_Group__c = allName;
            ln.APTS_Proposal_Group__c = bundlewrapper.grpMap.get(ln.Apttus_Config2__ConfigurationId__c).Id; //groupListTobeInsert[0].Id;
            ln.Apttus_Config2__PricingStatus__c =  'Pending';
            ln.APTS_Keep_Terms__c =  false;
            ln.APTS_Group_Primary_Material__c = bundlewrapper.matrialMap.get(ln.Apttus_Config2__ConfigurationId__c);
            ln.APTS_Group_Primary_Material_Name__c =bundlewrapper.grpMap.get(ln.Apttus_Config2__ConfigurationId__c).APTS_Primary_Material__c;
            if(ln.APTS_Keep_Terms__c){
                bundlewrapper.isKeepTerms = true;
            }
            
            lnItemsToUpdate.add(ln);
            
        }
    }

    private static void updateBundleDataPrice(Apttus_Config2__LineItem__c ln, BundleData tempBundleData){
        if((ln.Apttus_Config2__LineStatus__c == 'New' || ln.Apttus_Config2__LineStatus__c == 'Amended')  
            && ((ln.APTS_Product_Code__c != null && !System.Label.APTS_Proflex_Materials.contains(ln.APTS_Product_Code__c))
            || (ln.APTS_Product_Code__c == null && ln.Apttus_Config2__HasOptions__c))){
            tempBundleData.basevalue = tempBundleData.basevalue + ln.Apttus_Config2__BasePrice__c;
            tempBundleData.listvalue = tempBundleData.listvalue + ln.Apttus_Config2__ListPrice__c;
            tempBundleData.adjustvalue = ln.Apttus_Config2__AdjustmentAmount__c;
            tempBundleData.adjusttype = ln.Apttus_Config2__AdjustmentType__c;
        } 
    }
    private static void updateBundleDataName(Apttus_Config2__LineItem__c ln, BundleData tempBundleData){
        if((ln.Apttus_Config2__LineStatus__c == 'New' || ln.Apttus_Config2__LineStatus__c == 'Amended')  && ln.APTS_Product_Group_Primary_Material__c != null && ln.APTS_Group__c != null){
            tempBundleData.bundlename = ln.APTS_Group_Primary_Material_Name__c+';'+ln.APTS_Group__c+':'+ln.APTS_Product_Group_Primary_Material__c.substringAfter(':');
        }
    }
    private static void updateBundleDataLineStatusCheck(Apttus_Config2__LineItem__c ln, BundleData tempBundleData){
        System.debug('ln.Apttus_Config2__LineStatus__c'+ln.Apttus_Config2__LineStatus__c);
        if(ln.Apttus_Config2__LineStatus__c =='Amended' || ln.Apttus_Config2__LineStatus__c =='Renewed' || (ln.APTS_Product_Code__c != null && System.Label.APTS_Proflex_Materials.contains(ln.APTS_Product_Code__c) && tempBundleData.bundles.containsKey(tempBundleData.bundlename) )){
            tempBundleData.isNotNewLineItem =true;
        }
    }
    private static void populateLineItemDetails(Map<String,APTS_Group__c> groupNameUpdated){

        List<Apttus_Config2__LineItem__c> lnItemsToUpdate = new list<Apttus_Config2__LineItem__c>();
        Map<String, String> groupNameMap= new Map<String, String>();

        populateGroupNameMap(groupNameMap);
        System.debug('groupNameMap' + groupNameMap);

        for(Apttus_Config2__LineItem__c ln:bundlewrapper.lnItemList){
            //If line item's cart is not a key in cartToBundleData, initialize and add new key-value pair to cartToBundleData
            if(!cartToBundleData.containsKey(ln.Apttus_Config2__ConfigurationId__c)){
                cartToBundleData = initializeBundleData(cartToBundleData,ln.Apttus_Config2__ConfigurationId__c);
            }
            BundleData tempBundleData = cartToBundleData.get(ln.Apttus_Config2__ConfigurationId__c);
            System.debug('tempBundleData1:::::'+tempBundleData);
            System.debug('ln:::::'+ln);
            setMLAAgreementNumber(ln);
            if(ln.Apttus_Config2__HasOptions__c){
                hasBundleProduct = true;
            }
            updateLineItemDetails(ln,groupNameMap,lnItemsToUpdate);
            
            //End of-Added as part of SOC-3699 : validation for Non-EDP products in EDP LT Bundle
            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here
            updateBundleDataPrice(ln,tempBundleData);
            updateBundleDataName(ln,tempBundleData);
            updateBundleDataLineStatusCheck(ln,tempBundleData);

            tempBundleData.groupPrimaryMaterial=ln.APTS_Group_Primary_Material__c;
            tempBundleData.count = tempBundleData.count + 1;
            tempBundleData.pricing = tempBundleData.listvalue+'list'+tempBundleData.basevalue+'base'+tempBundleData.adjusttype+'adjust'+tempBundleData.adjustvalue;
            tempBundleData.bundles.put(tempBundleData.bundlename,tempBundleData.pricing);
            tempBundleData.bundlecount.put(tempBundleData.bundlename,tempBundleData.count);
            tempBundleData.prdcode.add(tempBundleData.bundlename.substringAfter(':'));
            groupNameUpdated.put(tempBundleData.bundlename,bundlewrapper.grpMap.get(ln.Apttus_Config2__ConfigurationId__c));  
            System.debug(groupNameUpdated);
            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Ends Here
            cartToBundleData.put(ln.Apttus_Config2__ConfigurationId__c,tempBundleData);
        }
                
        System.debug('lnItemsToUpdate ---------------'+ lnItemsToUpdate);
        
        if(!lnItemsToUpdate.isEmpty() && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
            try{
                update lnItemsToUpdate;
            }catch(DMLException ex){
                System.debug('line 360-------exception'+ ex);
            }
        }
    }
    private static List<string> getBundleList(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap,Id configId ){

        List<String> btemplist = new List<String>();
        for(Apttus_Config2__LineItem__c ln: cartIDToLineItemsMap.get(configId)){
            String bundle = '';
            System.debug(ln.APTS_Product_Group_Primary_Material__c +'product code' + ln.APTS_Product_Code__c);
            if(ln.APTS_Product_Group_Primary_Material__c != null){
                bundle = ln.APTS_Group_Primary_Material_Name__c+';'+ln.APTS_Group__c+':'+ln.APTS_Product_Group_Primary_Material__c.substringAfter(':');
            }
            if(ln.APTS_Product_Group_Primary_Material__c != null && ln.APTS_Product_Group_Primary_Material__c.substringAfter(':') == ln.APTS_Product_Code__c){
                btemplist.add(bundle);           
            }
        }
        return btemplist;
    }
    private static void createDynamicBundleLineItem(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap,Map<String,Apttus_Config2__PriceListItem__c> plimap){

        for(Id configId : configIds){
            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here
            List<String> btemplist = new List<String>();
            btemplist = getBundleList(cartIDToLineItemsMap,configId);
            //This is code for creating the Dynamic Bundle line item can calling Apttus
            System.debug('plimap'+plimap);
            Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
            request.CartId = configId;
            System.debug('Testdata1'+request.CartId);
            System.debug('configId'+configId);
            Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            Boolean callapi = false;
            for(String str : cartToBundleData.get(configId).bundles.keySet()){
                if(btemplist != null && !btemplist.contains(str)){
                    String temp = str.substringAfter(':');
                    if(!plimap.isEmpty() && plimap.get(temp) != null && !(cartToBundleData.get(configId).isNotNewLineItem)){
                        selectedProduct.ProductId = plimap.get(temp).Apttus_Config2__ProductId__c;
                        System.debug('Testdata2'+selectedProduct.ProductId);
                        selectedProduct.Quantity = 1;
                        selectedProduct.SellingTerm = 12; 
                        Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c(); 
                        List<String> customFields = new List<String>{'Apttus_Config2__Uom__c','Apttus_Config2__ChargeType__c','Apttus_Config2__SellingFrequency__c','Apttus_Config2__PriceUom__c','Apttus_Config2__PriceType__c','Apttus_Config2__Frequency__c','Apttus_Config2__Term__c','Apttus_Config2__BasePriceMethod__c','Apttus_Config2__PriceMethod__c','Apttus_Config2__LineStatus__c','apts_keep_terms__c'};
                        selectedProduct.CustomFields = customFields;      
                        customData.Apttus_Config2__ChargeType__c= plimap.get(temp).Apttus_Config2__ChargeType__c; 
                        customData.Apttus_Config2__SellingFrequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
                        customData.Apttus_Config2__PriceType__c=plimap.get(temp).Apttus_Config2__PriceType__c;
                        customData.Apttus_Config2__Frequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
                        customData.Apttus_Config2__Term__c=1;
                        customData.Apttus_Config2__BasePriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c;
                        customData.Apttus_Config2__PriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c;  
                        customData.Apttus_Config2__LineStatus__c='New';
                        customdata.apts_keep_terms__c =bundlewrapper.isKeepTerms ;
                        System.debug(selectedProduct);
                        System.debug(customData);
                        selectedProduct.CustomData = customData; 
                        request.SelectedProducts.add(selectedProduct);
                        System.debug('request'+request);
                        
                        callapi = true;
                    }
                }
            }
            callApttusAddMultipleProduct(configId,request,callapi);
            //End of dynamic bundle/ calling apttus logic
        }
    }
    private static void callApttusAddMultipleProduct(Id configId, Apttus_CPQApi.CPQ.AddMultiProductRequestDO request,Boolean callapi ){

        if(callapi == true && !Test.isRunningTest()){
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
            Digital_CartCreationHelper.updateLineItemFields(configId,request.SelectedProducts);
        }
    }
    private static void setLineItemPrice(Apttus_Config2__LineItem__c li,Id configId,String str ){
        if(cartToBundleData.get(configId).bundles.get(str) != null){
            li.Apttus_Config2__ListPrice__c = Decimal.valueOf(cartToBundleData.get(configId).bundles.get(str).substringBefore('list'));
            li.Apttus_Config2__BasePrice__c= Decimal.valueOf(cartToBundleData.get(configId).bundles.get(str).substringBetween('list','base'));
            li.Apttus_Config2__IsCustomPricing__c = true;
        }
    }
    private static void setLineItemPriceListItemDetail(Apttus_Config2__LineItem__c li,Map<String,Apttus_Config2__PriceListItem__c> plimap,String temp){

        if(!plimap.isEmpty() && plimap.get(temp)!=null){
            li.Apttus_Config2__ChargeType__c= plimap.get(temp).Apttus_Config2__ChargeType__c; 
            li.Apttus_Config2__SellingFrequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
            li.Apttus_Config2__PriceType__c=plimap.get(temp).Apttus_Config2__PriceType__c;
            li.Apttus_Config2__Frequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
            li.Apttus_Config2__Term__c=1;
            li.Apttus_Config2__BasePriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c;
            li.Apttus_Config2__PriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c; 
            if(!(li.Apttus_Config2__LineStatus__c=='Amended')){ 
                li.Apttus_Config2__LineStatus__c='New'; 
            }
        }
    }
    private static void setLineItemProposalGroup(Apttus_Config2__LineItem__c li,Map<String,APTS_Group__c> groupNameUpdated,String str){

        if(groupNameUpdated!=null && groupNameUpdated.get(str)!=null){  
            System.debug('bundle'+groupNameUpdated.get(str));                          
            li.APTS_Existing_Agreement_Total__c = groupNameUpdated.get(str).APTS_Existing_Agreement_Total__c;
            li.APTS_Online_Incremental__c = groupNameUpdated.get(str).APTS_Online_Incremental__c;
            li.APTS_Proposal_Group__c = groupNameUpdated.get(str).id; 
        }
    }
    private static void setLineItemPriceAdjustment(Apttus_Config2__LineItem__c li,Map<String,Apttus_Config2__LineItem__c> fieldmap){

        if(fieldmap != null && fieldmap.get(li.APTS_Totaling_Summary_Group__c) != null){
            li.APTS_Bridge__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Bridge__c;
            li.APTS_New_Bridge_Discount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_New_Bridge_Discount__c;
            li.APTS_Contract_Term__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Contract_Term__c;
            li.APTS_Years_2_Plus_Adjustment__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Years_2_Plus_Adjustment__c;
            li.Apttus_Config2__BillingFrequency__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__BillingFrequency__c;
            li.Apttus_Config2__AdjustmentType__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentType__c;
            li.Apttus_Config2__AdjustmentAmount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentAmount__c;
        }
    }
    private static void populateFieldMap(Map<String,Apttus_Config2__LineItem__c> fieldmap,Id configId,List<Apttus_Config2__LineItem__c> liList){
        Apttus_Config2__LineItem__c adjustedLineItem;
        for(Apttus_Config2__LineItem__c li: liList){
            if(cartToBundleData.get(configId).prdcode != null && !cartToBundleData.get(configId).prdcode.contains(li.APTS_Product_Code__c)){
                fieldmap.put(li.APTS_Totaling_Summary_Group__c,li);
                //If a line item has adjustment amount, store the line item to be put into 'fieldmap'
                if(li.Apttus_Config2__AdjustmentAmount__c != null && li.Apttus_Config2__AdjustmentAmount__c != 0){
                    adjustedLineItem = li;
                }
            }
        }
        //Update 'fieldmap' with line item that contains adjustment amount
        if(adjustedLineItem != null){
            fieldmap.put(adjustedLineItem.APTS_Totaling_Summary_Group__c,adjustedLineItem);
        }
        return;
    }

    private static void updateDynamicBundleLineItem(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap,Map<String,APTS_Group__c> groupNameUpdated,Map<String,Apttus_Config2__PriceListItem__c> plimap){
        
        List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>();

        for(Id configId : configIds){
            //This logic is for populating the dynamic bundle line item details
            Decimal count1 = 1;
            Map<String,Apttus_Config2__LineItem__c> fieldmap = new Map<String,Apttus_Config2__LineItem__c>();
            populateFieldMap(fieldmap,configId,cartIDToLineItemsMap.get(configId));

            for(Apttus_Config2__LineItem__c li: cartIDToLineItemsMap.get(configId)){
                System.debug(li.Apttus_Config2__ConfigurationId__c + ''+  li);
                if(cartToBundleData.get(configId).prdcode != null && cartToBundleData.get(configId).prdcode.contains(li.APTS_Product_Code__c)){
                    for(String str : cartToBundleData.get(configId).bundles.keyset()){
                        String temp = str.substringAfter(':');
                        if(li.APTS_Product_Code__c == temp){
                            li.APTS_Group__c = str.substringBetween(';',':');
                            li.APTS_Group_Primary_Material_Name__c = str.substringBefore(';');
                            setLineItemPrice(li,configId,str);
                            li.Apttus_Config2__LineSequence__c  = count1;
                            li.Apttus_Config2__LineNumber__c = count1;
                            li.Apttus_Config2__ItemSequence__c = count1;
                            li.Apttus_Config2__PriceUom__c='Each';
                            li.Apttus_Config2__Uom__c='Each';
                            li.APTS_Group_Primary_Material__c = cartToBundleData.get(configId).groupPrimaryMaterial;
                            setLineItemPriceListItemDetail(li,plimap,temp);
                            setLineItemProposalGroup(li,groupNameUpdated,str);
                            li.APTS_Decentralized__c= bundlewrapper.decentralized;
                            li.APTS_MLA__c = bundlewrapper.existOnlineSoftwareProduct;
                            li.APTS_is_Primary_in_Bundle__c=true;                       
                            li.APTS_Existing_Subscriptions_Total__c = DCDynamicBundleHelper.getExistingSubscriptionTotal(cartIDToLineItemsMap.get(configId));
                            li.APTS_New_Subscriptions_Total__c = DCDynamicBundleHelper.getNewSubscriptionTotal(cartIDToLineItemsMap.get(configId)); 
                            li.apts_keep_terms__c =bundlewrapper.isKeepTerms ;
                            count1 = count1 + 1 + cartToBundleData.get(configId).bundlecount.get(str);
                            setLineItemPriceAdjustment(li,fieldmap);
                            lineitemlist.add(li);
                            cartToBundleData.get(configId).bundles.remove(str);
                            break;
                        }
                    }
                }
            }
            //end of logic for populating dynamic bundle line item details
        }

        System.debug(lineitemlist);
        if(!lineitemlist.isEmpty() && !Test.isRunningTest()){
            update lineitemlist;
        }
    }

    private static void updateDynamicBundleLineItem2(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap ){

        List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>();
        Map<String,Decimal> linseq = new Map<String,Decimal>();
        for(Id configId : configIds){

            Map<String,Apttus_Config2__LineItem__c> fieldmap = new Map<String,Apttus_Config2__LineItem__c>();
            populateFieldMap(fieldmap,configId,cartIDToLineItemsMap.get(configId));

            //This logic is for populating dynamic bundle line item details.... AGAIN????
            List<Apttus_Config2__LineItem__c> lilist = cartIDToLineItemsMap.get(configId);
            for(Apttus_Config2__LineItem__c li: lilist){
                if(cartToBundleData.get(configId).prdcode != null && cartToBundleData.get(configId).prdcode.contains(li.APTS_Product_Code__c)){
                    linseq.put(li.APTS_Totaling_Summary_Group__c,li.Apttus_Config2__LineNumber__c);
                    if(fieldmap != null && fieldmap.get(li.APTS_Totaling_Summary_Group__c) != null){
                        li.APTS_Bridge__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Bridge__c;
                        li.APTS_New_Bridge_Discount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_New_Bridge_Discount__c;
                        li.APTS_Contract_Term__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Contract_Term__c;
                        li.APTS_Years_2_Plus_Adjustment__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Years_2_Plus_Adjustment__c;
                        li.Apttus_Config2__BillingFrequency__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__BillingFrequency__c;
                        li.Apttus_Config2__AdjustmentType__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentType__c;
                        li.Apttus_Config2__AdjustmentAmount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentAmount__c;
                        lineitemlist.add(li);
                    }
                }
                
            }
            //end of logic to again update dynamic bundle
        }

        if(!lineitemlist.isEmpty() && !Test.isRunningTest()){
            update lineitemlist;
        }
        updateLineItemSequence(cartIDToLineItemsMap,linseq);
    }
    private static void updateLineItemSequence(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap,Map<String,Decimal> linseq){

        List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>();
        for(Id configId : configIds){
            List<Apttus_Config2__LineItem__c> lilist = cartIDToLineItemsMap.get(configId);
            Decimal count2 = 0;
            //Sets line item sequence for dynamic bundle subproducts
            for(Apttus_Config2__LineItem__c li : lilist){
                if((li.Apttus_Config2__LineStatus__c == 'New' || li.Apttus_Config2__LineStatus__c=='Amended') && cartToBundleData.get(configId).prdcode != null && !cartToBundleData.get(configId).prdcode.contains(li.APTS_Product_Code__c) && linseq.get(li.APTS_Totaling_Summary_Group__c)!=null && li.APTS_Bundle__c.contains('Bundle')){
                    li.Apttus_Config2__LineSequence__c = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                    li.Apttus_Config2__LineNumber__c = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                    li.Apttus_Config2__ItemSequence__c = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                    bundleProdIdToLineNumber.put(li.Apttus_Config2__AttributeValueId__c, li.Apttus_Config2__LineNumber__c);
                    linseq.put(li.APTS_Totaling_Summary_Group__c,li.Apttus_Config2__LineSequence__c);
                    lineitemlist.add(li);
                    count2 = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                }
            }
            //Sets line item sequence of products not in dynamic bundle
            setLineItemSequence(lineitemlist,lilist,count2);    
            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Ends Here
        }
        if(!lineitemlist.isEmpty() && !Test.isRunningTest()){
            update lineitemlist;
        }  
    }
    private static void setLineItemSequence(List<Apttus_Config2__LineItem__c> lineitemlist,List<Apttus_Config2__LineItem__c> lilist,Decimal count2){

        for(Apttus_Config2__LineItem__c li : lilist){
            if((li.Apttus_Config2__LineStatus__c == 'New' || li.Apttus_Config2__LineStatus__c=='Amended') && li.APTS_Bundle__c == null && count2 > 0){
                li.Apttus_Config2__LineNumber__c = count2;
                li.Apttus_Config2__LineSequence__c = count2;
                li.Apttus_Config2__ItemSequence__c = count2;
                //setOptionsLineNumber(li);
                lineitemlist.add(li);
                count2 = count2 + 1;
            }
        }  
        setCancelledLineItemSequence(lineitemlist,lilist,count2);

    }
    private static void setCancelledLineItemSequence(List<Apttus_Config2__LineItem__c> lineitemlist,List<Apttus_Config2__LineItem__c> lilist,Decimal count2){
        for(Apttus_Config2__LineItem__c li : lilist){
            if(li.Apttus_Config2__LineStatus__c != 'New' && li.Apttus_Config2__LineStatus__c!='Amended' && count2 > 0){
                li.Apttus_Config2__LineSequence__c = count2;
                li.Apttus_Config2__LineNumber__c = count2;
                if(li.Apttus_Config2__HasOptions__c){
                    bundleProdIdToLineNumber.put(li.Apttus_Config2__AttributeValueId__c, li.Apttus_Config2__LineNumber__c);
                }
                //setOptionsLineNumber(li);
                lineitemlist.add(li);
                count2 = count2 + 1;
            }
        }
    }

    private static void setOptionsLineNumber(Apttus_Config2__LineItem__c li){
        if(String.isNotBlank(li.Apttus_Config2__OptionId__c) && bundleProdIdToLineNumber.containsKey(li.Apttus_Config2__AttributeValueId__c)){
            li.Apttus_Config2__LineNumber__c = bundleProdIdToLineNumber.get(li.Apttus_Config2__AttributeValueId__c);
        }
    }
    private static Map<String,Apttus_Config2__PriceListItem__c> getPrceListItem(){
        Set<String> productCodes = new Set<String>();
        List<Apttus_Config2__PriceListItem__c> plis = new List<Apttus_Config2__PriceListItem__c>();
        Map<String,Apttus_Config2__PriceListItem__c> plimap = new Map<String,Apttus_Config2__PriceListItem__c>();
        
        for(id configId : configIds){
            productCodes.addAll(cartToBundleData.get(configId).prdcode);
        }
        if(!productCodes.isEmpty()){
            plis = [Select Id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductCode__c,Apttus_Config2__ProductName__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__Frequency__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__ChargeType__c,Apttus_Config2__ListPrice__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductCode__c IN: productCodes AND Apttus_Config2__PriceType__c != 'One Time'];
        }
        for(Apttus_Config2__PriceListItem__c str : plis){
            plimap.put(str.Apttus_Config2__ProductCode__c,str);
        }

        return plimap;
    }
    private static void deleteGroupList(){

        List<APTS_Group__c> grpListToDelete = new List<APTS_Group__c>();
        if(!bundlewrapper.grpList.isEmpty()){  
            for(APTS_Group__c groupData : bundlewrapper.grpList){
                System.debug('----------'+ bundlewrapper.grpMap.get(groupData.APTS_ProductConfiguration__c));
                System.debug('groupData.APTS_ProductConfiguration__c -----'+ groupData.APTS_ProductConfiguration__c);
                if(null != bundlewrapper.grpMap.get(groupData.APTS_ProductConfiguration__c)
                    && !String.valueOf(bundlewrapper.grpMap.get(groupData.APTS_ProductConfiguration__c).Id).contains(groupData.Id)){
                        
                    grpListToDelete.add(groupData);
                    
                }
            }
        }
        
        // Delete the previous group list
        if (Schema.sObjectType.APTS_Group__c.isDeletable()) { 
            delete grpListToDelete;
        }
    }
    private static void parseAndSaveData(){

        Map<String,APTS_Group__c> groupNameUpdated=new Map<String,APTS_Group__c>();

        for(APTS_Group__c grps : bundlewrapper.groupListTobeInsert){
            bundlewrapper.grpMap.put(grps.APTS_ProductConfiguration__c, grps);
        }
        
        System.debug('bundlewrapper.grpMap ------------------'+ bundlewrapper.grpMap);
        
        bundlewrapper.grpList = DCDynamicBundleHelper.getGrouplnItems(proposalIds);  
        populateLineItemDetails(groupNameUpdated);

        System.debug('CARTTOBUNDLEDATA:::::'+cartToBundleData);

        Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap = new Map<id,List<Apttus_Config2__LineItem__c>>();
        Map<String,Apttus_Config2__PriceListItem__c> plimap = new Map<String,Apttus_Config2__PriceListItem__c>();
        plimap = getPrceListItem();

        cartIDToLineItemsMap = DCDynamicBundleHelper.getCartLineItems(configIds);
        createDynamicBundleLineItem(cartIDToLineItemsMap,plimap);

        cartIDToLineItemsMap = DCDynamicBundleHelper.getCartLineItems(configIds);
        updateDynamicBundleLineItem(cartIDToLineItemsMap,groupNameUpdated,plimap);

        cartIDToLineItemsMap = DCDynamicBundleHelper.getCartLineItems2(configIds);
        updateDynamicBundleLineItem2(cartIDToLineItemsMap);

        System.debug('bundlewrapper.grpMap-----------'+ bundlewrapper.grpMap);
        deleteGroupList();
        String actionType = 'backToCart';
        
        if(!bundlewrapper.isMLA && actionType == 'backToCart'){
            deleteExistingRecords();
            insertNewLocation();
            
        } else if(bundlewrapper.isMLA && actionType == 'backToCart' && bundlewrapper.isKeepTerms && bundlewrapper.mlaAgreementNumber != null){
            updateExistingLocation();
        }


        //Call reprice for dynamic bundle line item
        repriceCart();
        //If Bundle Product exists, call second reprice to fix pricing issue.
        if(hasBundleProduct){
            repriceCart();
        }
        
        DCDynamicBundleHelper.createSummaryGroup(bundlewrapper.grpMap,configIds);
        
        DCDynamicBundleHelper.updateCartToNewStatus(configIds);
    }
    private static void repriceCart(){
        for(id cartId : configIds){
            if(!Test.isRunningTest()){
                DigitalBundleBatch.callApttusPriceUpdateAPI(cartId);
            }
        }
    }
    private static void updateExistingLocation(){
        
        List<APTS_Quote_Agreement_Locations__c> existingAgreementLocations = DCDynamicBundleHelper.getExistingAgreementLocations(proposalIds);
        if(existingAgreementLocations != null && !existingAgreementLocations.isEmpty()){
            for(APTS_Quote_Agreement_Locations__c aLocation:existingAgreementLocations){
                aLocation.APTS_Agreement_Number__c = bundlewrapper.mlaAgreementNumber;
            }
            if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isUpdateable()){
                update existingAgreementLocations;
            }
        }
    }
    private static void insertNewLocation(){

        List<APTS_Quote_Agreement_Locations__c> bundleLocationList = new List<APTS_Quote_Agreement_Locations__c>();
        for(Id obj : configIds){
            if(bundlewrapper.existOnlineSoftwareProduct){
                String status = bundlewrapper.isKeepTerms ? 'Existing' : 'New';
                APTS_Quote_Agreement_Locations__c bundleLocation = new APTS_Quote_Agreement_Locations__c();
                bundleLocation.APTS_Subscriber_Location__c = busTypeMap.get(obj).Apttus_Config2__AccountId__c; 
                bundleLocation.APTS_Subscriber_Location_SSD__c = busTypeMap.get(obj).APTS_SSD_Sold_To__c;// DLT-9753 Update APTS_Subscriber_Location_SSD__c with APTS_SSD_Sold_To__c as per the GLI.
                bundleLocation.APTS_Quote_Proposal__c = busTypeMap.get(obj).Apttus_QPConfig__Proposald__c;
                bundleLocation.APTS_Status__c = status;
                
                if(bundlewrapper.isKeepTerms){
                    bundleLocation.APTS_Agreement_Number__c = bundlewrapper.mlaAgreementNumber;
                }
                bundleLocationList.add(bundleLocation);
                //insert bundleLocation;
            }
        }
        if(!bundleLocationList.isEmpty() && Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isCreateable()){
            insert bundleLocationList;
        }
    }
    private static void deleteExistingRecords(){

        List<APTS_Quote_Agreement_Locations__c> existingAgreementLocations = DCDynamicBundleHelper.getExistingAgreementLocations(proposalIds);
        List<APTS_Additional_Subscription_Actions__c> existingSubscriptionActions = DCDynamicBundleHelper.getExistingSubscriptionActions(proposalIds);
        
        if(existingAgreementLocations != null && !existingAgreementLocations.isEmpty() && Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isDeletable()){
            delete existingAgreementLocations;
        }
        
        if(existingSubscriptionActions != null && !existingSubscriptionActions.isEmpty() && Schema.sObjectType.APTS_Additional_Subscription_Actions__c.isDeletable()){
            delete existingSubscriptionActions;
        }
    }

    //Mapping of line items according to APTS_Group__c
    private static map<string,list<Apttus_Config2__LineItem__c>> mapOfLnByGrp(list<Apttus_Config2__LineItem__c> lineItems, Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap, String tabName){
        map<string,list<Apttus_Config2__LineItem__c>> grpLnMap = new map<string,list<Apttus_Config2__LineItem__c>>();
        for(Apttus_Config2__LineItem__c ln : lineItems){
            String key = ln.APTS_Group__c==null ?allName:ln.APTS_Group__c;
            //|| ln.Apttus_Config2__AssetLineItemId__c != null
            if(grpLnMap.containsKey(key)){
                list<Apttus_Config2__LineItem__c> oldlnList = grpLnMap.get(key);
                oldlnList.add(ln);
                grpLnMap.put(key,oldlnList);
            }
            else{
                list<Apttus_Config2__LineItem__c> newlnList = new list<Apttus_Config2__LineItem__c>();
                newlnList.add(ln);
                grpLnMap.put(key,newlnList);
            }
        }
        

        populateAssetPreGroupMap(grpLnMap,assetPreGroupMap,tabName);        
        return grpLnMap;
    }

    private static void populateAssetPreGroupMap(map<string,list<Apttus_Config2__LineItem__c>> grpLnMap,Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap, String tabName){

        List<Apttus_Config2__LineItem__c> allList = grpLnMap.get(allName);
        
        if(allList==null){
            return;
        }

        for(Integer i=0; i<allList.size(); ++i){
            Apttus_Config2__LineItem__c li = allList.get(i);

            if(li.Apttus_Config2__AssetLineItemId__c != null 
                && ( DCDynamicBundleHelper.isValidPrint(tabName,li) || DCDynamicBundleHelper.isValidOnlineSoftware(tabName,li)) ){
                
                String key = null;
                key = DCDynamicBundleHelper.getKeyValue(tabName,li);

                //+ li.APTS_SAP_Deal_Primary_Material__c;
                if(assetPreGroupMap.containsKey(key)){
                    List<Apttus_Config2__LineItem__c> assetBundle = assetPreGroupMap.get(key);
                    i = populateAssetPreGroupMapHelper(i,assetBundle,allList);
                    assetBundle.add(li);
                    allList.remove(i--);
                }
                else{
                    assetPreGroupMap.put(key, new List<Apttus_Config2__LineItem__c>{li});
                }
            }
        }
        DCDynamicBundleHelper.removeSingleValueKey(assetPreGroupMap);

    }
    private static integer populateAssetPreGroupMapHelper(Integer i, List<Apttus_Config2__LineItem__c> assetBundle, List<Apttus_Config2__LineItem__c> allList){
        Integer tempInt = i;
        if(assetBundle.size() == 1){
            Set<Apttus_Config2__LineItem__c> temp=new Set<Apttus_Config2__LineItem__c>(assetBundle);
            for(Integer x = 0; x<allList.size(); ++x){
                if(temp.contains(allList.get(x))){
                    allList.remove(x);
                    --tempInt;
                    break;
                }
            }    
        }
        return tempInt;
    }
    
    //Calculating netAmount, grossAmount, incrementalRevenue, incrementalRevenueRequired, allowKeepTerms, maxDiscountedAmount 
    private static List<Decimal> calculateNets(List<Apttus_Config2__LineItem__c> lineItemsOfGroup, Set<String> optionList, List<Apttus_Config2__LineItem__c> liList){           
        Decimal netAmount = 0;
        Decimal grossAmount = 0;
        Decimal incrementalRevenue = 0;
        Decimal incrementalRevenueRequired = 0;
        Decimal allowKeepTerms = 0;
        //Decimal incrementalValueNeeded = 0;
        Decimal maxDiscountedAmount = 0;
        Apttus_Config2__LineItem__c li;
        for(Apttus_Config2__LineItem__c ln : lineItemsOfGroup){
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
            if(ln.Apttus_Config2__ExtendedPrice__c != null){
                
                grossAmount += ln.Apttus_Config2__ExtendedPrice__c;
                Decimal discountAmount = !setOfWPKValid.contains(ln.APTS_SAP_Deal_Type__c) ? bundlePageSettings.APTS_Max_Discount__c : bundlePageSettings.APTS_WestPack_Discount__c;
                maxDiscountedAmount += ln.Apttus_Config2__ExtendedPrice__c * discountAmount/100;
            }
            li = checkLineItem(li,ln);

            Integer indexOfSplit = ln.APTS_Product_Group_Primary_Material__c.indexOf(':');
            
            String matName = ln.APTS_Product_Group_Primary_Material__c.substring(0, indexOfSplit);
            optionList.add(matName);
        }
        incrementalRevenueRequired *= bundlePageSettings.Incremental_Revenue_Required__c;
        maxDiscountedAmount = grossAmount == 0 ? 0 : maxDiscountedAmount / grossAmount;
        liList.add(li);
        return new List<Decimal>{netAmount, grossAmount, incrementalRevenue, incrementalRevenueRequired, allowKeepTerms, maxDiscountedAmount};
    }

    private static Apttus_Config2__LineItem__c checkLineItem(Apttus_Config2__LineItem__c li,Apttus_Config2__LineItem__c ln){
        if(li==null || li.Apttus_Config2__NetPrice__c < ln.Apttus_Config2__NetPrice__c){
            return ln;
        }
        return li;
    }
    
    // Mathod to get dynamically picklist values of Group field
    private static List<string> getGroupPicklistValues(String groupName){
        List<string> pickValues= new List<string>();        
        Schema.DescribeFieldResult fieldResult = Apttus_Config2__LineItem__c.APTS_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){   
            if(groupName.equals(f.getValue())){
                pickValues.add(f.getValue());
            }    
            
        }       
        return pickValues;
    }
    
    //Called from DCBundleFinalizeService
    public static void finalizeCart(String cartId){  
       // DLT-15968 starts
       //using frame work method to finalize the cart
       IGlobalOperationLayer glbOpObj =new GlobalOperationLayer();
       glbOpObj.FinalizeCart(cartId,'DCDynamicBundle > finalizeCart');//16538 added class reference
       // DLT-15968 Ends
        
    }
        
    public static Map<Id,BundleData> initializeBundleData(Map<Id,BundleData> cartToBundleData, Id cartId){
        Map<Id,BundleData> cartBundleMap = cartToBundleData;
        BundleData bundle = new BundleData();
        bundle.listvalue = 0;
        bundle.basevalue = 0;
        bundle.adjustvalue = 0;
        bundle.count = 0;
        bundle.bundlename = '';
        bundle.adjusttype = '';
        bundle.pricing = '';

        cartBundleMap.put(cartId,bundle);

        return cartToBundleData;
    }
    public class BundleData{
        
        String bundlename;
        String adjusttype;
        String pricing;
        Decimal listvalue;
        Decimal basevalue;
        Decimal adjustvalue;
        Decimal count;
        Boolean isNotNewLineItem = false;
        Map<String,String> bundles = new Map<String,String>();
        Map<String,Decimal> bundlecount = new Map<String,Decimal>();
        Set<String> prdcode = new Set<String>();
        String groupPrimaryMaterial='';
    }
    
    public class DynamicBundleWrapper{

        boolean isMLA = false;
        boolean decentralized = false;
        boolean isKeepTerms = false;
        String mlaAgreementNumber;
        Boolean existOnlineSoftwareProduct =false;
        String materialNumber;
        Map<Id, String> matrialMap = new Map<Id, String>();
        List<Apttus_Config2__LineItem__c> lnItems = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> lnItemList = new List<Apttus_Config2__LineItem__c>();
        List<APTS_Group__c> groupListTobeInsert =  new list<APTS_Group__c>();
        List<APTS_Group__c> grpList = new list<APTS_Group__c>();
        Map<Id, APTS_Group__c> grpMap = new Map<Id, APTS_Group__c>();
    }
}