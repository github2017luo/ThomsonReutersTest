/********************************************************************************
Class Name : DCPDBCreateGroup
@description : This class used in dynamic bundling for creating groups.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
12/07/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDBCreateGroup{ 
    
    private static list<string> groupNameList;
    private static String bundleName  = 'Bundle A';
    private static String tabName;
    
    /** 
    @description to get the cart and bundle wrapper from method
    @param tabNameParam to get the tab name
    @param tabNameTolineItem will have map of tabname to list of line items
    @return Returns DCPDBInitializeData.BundleWrapper
    */

    public static DCPDBInitializeData.BundleWrapper createGroupHelper(String tabNameParam,Map<String, List<Apttus_Config2__LineItem__c>> tabNameTolineItem){

        //Start tab specific
        List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
        liList = tabNameTolineItem.get(tabNameParam);

        //If line item list is empty, exit metho
        if(liList.isEmpty()){
            return null;
        }
        tabName = tabNameParam;
        map<string,list<Apttus_Config2__LineItem__c>> lineGroupMap = new map<string,list<Apttus_Config2__LineItem__c>>();
        Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap = new Map<String, List<Apttus_Config2__LineItem__c>>();
        lineGroupMap = mapOfLnByGrp(liList, assetPreGroupMap, tabName);
        System.debug(LoggingLevel.DEBUG,'###assetPreGroupMap--> '+assetPreGroupMap.size());
        
        groupNameList = new list<string>();
        groupNameList.addAll(DCPDBInitializeData.getGroupPicklistValues(bundleName));
        System.debug(LoggingLevel.DEBUG,'groupNameList------------'+groupNameList);

        for(string keyStr : groupNameList){
            APTS_Group__c grp =  new APTS_Group__c();
            grp.APTS_Group_Name__c = tabName+' '+keyStr;
            grp.APTS_Group_Name_Original__c = tabName+' '+keyStr;
            grp.APTS_ProductConfiguration__c = DCPDynamicBundling.objectCart.id;
            grp.APTS_Discount_Amount__c=null;
            grp.APTS_Quantity__c=null;
            setGroupProposalField(grp);
            setGroupMLA(grp,tabName,keyStr);
            
            List<Decimal> netAmounts = new List<Decimal>{0,0,0,0,0,0,0};

            list<Apttus_Config2__LineItem__c> lineItemsOfGroup =  new list<Apttus_Config2__LineItem__c>();
            if(!lineGroupMap.isEmpty()){
                lineItemsOfGroup = getLineItemsOfGroup(lineGroupMap ,keyStr,assetPreGroupMap);
                
                if(tabName == 'Online/Software' && keyStr != bundleName && !assetPreGroupMap.isEmpty()){
                    for(String key : assetPreGroupMap.keySet()){
                        lineItemsOfGroup.addAll(assetPreGroupMap.get(key));
                        assetPreGroupMap.remove(key);
                    }
                }
                
                System.debug(LoggingLevel.DEBUG,'###lineItemsOfGroup--> '+lineItemsOfGroup.size());
                
                netAmounts= DCPDBCalculateNetAmounts.calculateNets(lineItemsOfGroup);
                DCPDBCalculateNetAmounts.setGroupPrimaryMaterial(grp);
            }
            netAmounts= DCPDBCalculateNetAmounts.calculateNets(DCPDynamicBundling.bundlewrapper.lnItems);
            System.debug(LoggingLevel.DEBUG,'netAmounts -----------'+ netAmounts);
            //netAmount, grossAmount, incrementalRevenue, incrementalRevenueRequired
            //Decimal existingAgreementTotal = netAmounts[0];
            grp.APTS_Adjustment_Type__c = 'Select Adjustment'; 
            grp.APTS_NetAmount__c = netAmounts[0];
            grp.APTS_Incremental_Revenue__c = netAmounts[2];
            grp.APTS_Incremental_Revenue_Required__c = netAmounts[3];
            grp.APTS_Incremental_Revenue_Above_Threshold__c = netAmounts[2] - netAmounts[3];
            grp.APTS_Existing_Agreement_Total__c = netAmounts[0];
            grp.APTS_Online_Incremental__c = 0;
            grp.APTS_Max_Blended_Discount__c = netAmounts[5];
            
            DCPDynamicBundling.bundlewrapper.groupListTobeInsert.add(grp);
        }
        
        return DCPDynamicBundling.bundlewrapper;
        
    }
    
    private static List<Apttus_Config2__LineItem__c> getLineItemsOfGroup(map<string,list<Apttus_Config2__LineItem__c>> lineGroupMap,
        string keyStr,Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap){

        list<Apttus_Config2__LineItem__c> lineItemsOfGroup =  new list<Apttus_Config2__LineItem__c>();
        //If there are already items in the bundle
        if(lineGroupMap.containsKey(keyStr)){
            lineItemsOfGroup = lineGroupMap.get(keyStr);
        }
        //It's an empty bundle. Try to put the other map in this bundle
        else{
            getFromAssetPreGroupMap(assetPreGroupMap,lineItemsOfGroup,tabName);
        }

        return lineItemsOfGroup;
    }
     //Mapping of line items according to APTS_Group__c
    private static map<string,list<Apttus_Config2__LineItem__c>> mapOfLnByGrp(list<Apttus_Config2__LineItem__c> lineItems, Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap, String tabName){
        map<string,list<Apttus_Config2__LineItem__c>> grpLnMap = new map<string,list<Apttus_Config2__LineItem__c>>();
        for(Apttus_Config2__LineItem__c ln : lineItems){
            String key = ln.APTS_Group__c==null ?bundleName :ln.APTS_Group__c;
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

        List<Apttus_Config2__LineItem__c> allList = grpLnMap.get(bundleName);
        
        if(allList==null){
            return;
        }

        for(Integer i=0; i<allList.size(); ++i){
            Apttus_Config2__LineItem__c li = allList.get(i);

            if(li.Apttus_Config2__AssetLineItemId__c != null 
                && (DCPDBInitializeData.isValidPrint(tabName,li) || DCPDBInitializeData.isValidOnlineSoftware(tabName,li)) ){
                
                String key = null;
                key = DCPDBGroupHelper.getKeyValue(tabName,li);

                //+ li.APTS_SAP_Deal_Primary_Material__c;
                if(assetPreGroupMap.containsKey(key)){
                    List<Apttus_Config2__LineItem__c> assetBundle = assetPreGroupMap.get(key);
                    i = DCPDBGroupHelper.populateAssetPreGroupMapHelper(i,assetBundle,allList);
                    assetBundle.add(li);
                    allList.remove(i--);
                }
                else{
                    assetPreGroupMap.put(key, new List<Apttus_Config2__LineItem__c>{li});
                }
            }
        }
        assetPreGroupMap= DCPDBGroupHelper.removeSingleValueKey(assetPreGroupMap);

    }
    
    private static void setGroupMLA(APTS_Group__c grp,String tabName,string keyStr){

        if(tabName == 'Online/Software' && keyStr != bundleName){
            grp.APTS_MLA__c = DCPDynamicBundling.bundlewrapper.isMLA;
            grp.APTS_Decentralized__c = DCPDynamicBundling.bundlewrapper.decentralized;
        }
    }
    
    private static void setGroupProposalField(APTS_Group__c grp){

        if(DCPDynamicBundling.objectCart.Apttus_Config2__BusinessObjectType__c == 'Proposal'){
            grp.APTS_Quote_Proposal__c = DCPDynamicBundling.objectCart.Apttus_QPConfig__Proposald__c;
        }
        else{
            grp.APTS_Agreement__c = DCPDynamicBundling.objectCart.Apttus_QPConfig__Proposald__c;
        }
    }
    
     @Testvisible
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
}