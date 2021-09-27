/********************************************************************************
Class Name : DCPDBGroupHelper                          
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             DCPDBPopulateLineItemsDetails                          Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/

public without sharing class DCPDBGroupHelper{
    /** 
    @description call the execute bundling method
    */
    public static void deleteGroupList(){

        List<APTS_Group__c> grpListToDelete = new List<APTS_Group__c>();
        if(!DCPDynamicBundling.bundlewrapper.grpList.isEmpty()){  
            for(APTS_Group__c groupData : DCPDynamicBundling.bundlewrapper.grpList){
                //System.debug(LoggingLevel.DEBUG,'----------'+ bundlewrapper.grpMap.get(groupData.APTS_ProductConfiguration__c));
                //System.debug(LoggingLevel.DEBUG,'groupData.APTS_ProductConfiguration__c -----'+ groupData.APTS_ProductConfiguration__c);
                if(null != DCPDynamicBundling.bundlewrapper.grpMap.get(groupData.APTS_ProductConfiguration__c)
                    && !String.valueOf(DCPDynamicBundling.bundlewrapper.grpMap.get(groupData.APTS_ProductConfiguration__c).Id).contains(groupData.Id)){
                        
                    grpListToDelete.add(groupData);
                    
                }
            }
        }
        
        // Delete the previous group list
        if (Schema.sObjectType.APTS_Group__c.isDeletable()) { 
            delete grpListToDelete;
        }
    }

    /**
        @description
        @param tabName
        @param li
        @return
     */

    public static String getKeyValue(String tabName,Apttus_Config2__LineItem__c li){
        if(tabName == 'Print' && li.APTS_SAP_Deal_Number__c!=null && li.APTS_SAP_Deal_Type__c!=null){
            return li.APTS_SAP_Deal_Number__c + li.APTS_SAP_Deal_Type__c;
        } else{
            return li.APTS_SAP_MLA_Agreement_Number__c;
        }
    }
    
    /**
        @description
        @param assetPreGroupMap
        @return 
     */

    public static Map<String, List<Apttus_Config2__LineItem__c>> removeSingleValueKey(Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap){
        //So only values with more than one value are assigned to a bundle
        for(String key : assetPreGroupMap.keySet()){
            if(assetPreGroupMap.get(key).size() < 2){
            assetPreGroupMap.remove(key);
            }
        }
        return assetPreGroupMap;
    }

    /**
        @description
        @param i
        @param assetBundle
        @param allList
        @return
     */

    public static integer populateAssetPreGroupMapHelper(Integer i, List<Apttus_Config2__LineItem__c> assetBundle, List<Apttus_Config2__LineItem__c> allList){
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

}