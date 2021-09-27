/**
* @description Controller Class for VisualForce Page 'APTS_BundleGroupPage'
*/
public with sharing class APTS_BundleGroupCtrl{
   

    private string configId;
    public static string businessObj;
    public static string configReq;
    boolean ediscoveryLTProduct = false;
    boolean ediscoveryWOProduct = False;
    // Added by priyanaka for SOC-9359
    boolean notDiscountEligible =false;
    public List<String> nondiscntprodctslst; //added by gayatri for soc9359 
    public list<Apttus_Config2__LineItem__c> lnItemsduplist; //added by gayatri for soc9359 
    private boolean isMLA;
    private boolean decentralized;    
    private set<String> setOfTabNames = new Set<String>{'Print','Online/Software'};   
    private set<string> setOfGroupName;
    public string businessObjectId;  
    public String cId;
    public String buId;
    public String conId;
    public String pId;
    public String isMLAStr;
    public String decentr;
    public String mlaid;   
    private map<string,list<Apttus_Config2__LineItem__c>> groupLnMap;
   // private string businessObj;
    private list<string> adjustmentTypeList;
    private list<string> groupNameList; 
    // Custom Settings variables ===============================
    private static final String CUSTOMSETTINGSNAME = 'Bundle Page Properties';
    
    private Set<String> onlineCodes;
    private Set<String> printCodes;
    private Set<String> setOfWPKValid;
    public List<String> adjustmentPicklistValues;
    public Set<String> ineligibleExistingDealsList;
    public string retUrl ;

    /**
     * @description
     */
    public String allName{get; set;}
    /**
     * @description
     */
    public String keepTermsError{get; set;}
    /**
     * @description
     */
    public String adjustmentError{get; set;}
    /**
     * @description
     */
    public String maximumNumberError{get; set;}
    /**
     * @description
     */
    public String selectProductMessage{get; set;}
    /**
     * @description
     */
    public String fullAdjustmentPicklist{get; set;}
    /**
     * @description
     */
    public string jSONLineItemData {get; set;}
    /**
     * @description
     */
    public String jSONTabInfo {get; set;}
    /**
     * @description
     */
    public String jSONSetOfWPK{get; set;}
    /**
     * @description
     */
    public string jSONAccountsData {get; set;}
    /**
     * @description
     */
    public string retURLStr {get; set;}
    /**
     * @description
     */
    public string multiLocationsUrlStr {get; set;}
    /**
     * @description
     */
    public String bridgePickVal{get; set;}
    /**
     * @description
     */
    public string decentralizedStr{get;set;}
    /**
     * @description
     */    
    public string productConfig{get;set;}
    /**
     * @description
     */
    public string configRequestId{get;set;}
    /**
     * @description
     */
    public string adjustmentPickVal{get;set;}
    /**
     * @description
     */
    public string contractPickVal{get; set;}
    /**
     * @description
     */
    public string groupPickVal{get;set;}
    /**
     * @description
     */
    public string yoyPickVal{get; set;}
    /**
     * @description
     */
    private string oprMode {get; set;}
    /**
     * @description
     */
    public list<GroupLNWrapper> groupLnList {get; set;}
    /**
     * @description
     */
    public string fullLnList {get; set;}
    /**
     * @description
     */
    public Apttus_Config2__ProductConfiguration__c config {get; set;}
    /**
     * @description
     */
    public Apttus_Proposal__Proposal__c proposal {get; set;}
    /**
     * @description
     */
    public string canLnList {get;set;}
    /**
     * @description
     */
    public String lineItemsList {
        get;set;    
        // *** setter is NOT being called ***
       // set{
           // lineItemsList = value;
            //System.debug('value: '+lineItemsList);
       // }
    }
    /**
     * @description
     */
    public APTS_ConfigBundlePageSettings__c bundlePageSettings{get; set;}
    //==========================================================
    /**
     * @description method for VF Page APTS_BundleGroupPage
     * @param controller
     */
     public APTS_BundleGroupCtrl(ApexPages.StandardController controller){
         oprMode = 'new';
         //SOC-9796 PMD fixes
         cId = string.escapeSingleQuotes('id');
        if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(cId)))){       
         this.configId = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(cId)));}            
        conId = string.escapeSingleQuotes('configRequestId');
        if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId)))){     
         this.configRequestId = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId)));}             
        buId = string.escapeSingleQuotes('businessObjectId');
        if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId)))){
         this.businessObjectId = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId)));}                 
        pId = string.escapeSingleQuotes('id');
        if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(pId)))){     
         this.productConfig = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(pId))); }   
         if(ApexPages.currentPage().getParameters().get('isMLA')!=null){
             mlaid = string.escapeSingleQuotes('isMLA'); 
             if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(mlaid)))){     
             this.isMLAStr = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(mlaid))); }          
         }
         if(ApexPages.currentPage().getParameters().get('decentralized')!=null){
            // string decentralizedStr = ApexPages.currentPage().getParameters().get('decentralized');      
            decentr = string.escapeSingleQuotes('decentralized');   
            if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(decentr)))){     
             this.decentralizedStr = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(decentr))); }
         } 
         nondiscntprodctslst = new List<String>();    
         lnItemsduplist= new list<Apttus_Config2__LineItem__c>();
         isMLA = isMLAStr != null && isMLAStr == 'true' ? true : false;
         //SOC-9796 PMD fixes
         decentralized = decentralizedStr != null && decentralizedStr == 'true' ? true : false;
         //  string retUrl =  '/apex/apttus-config2__Cart?configRequestId= '+configRequestId+'&flow=ngcpq%23%2Fcart&id='+configId+'#/cart';           
         retUrl =  '/apex/apttus-config2__Cart?configRequestId=' + configRequestId  + '&flow=ngcpq%23%2Fcart&id=' + configId  + '#/cart';
         system.debug(LoggingLevel.WARN,retUrl );
         if(retUrl != null && retUrl != ''){
            retURLStr = retUrl;
         }
         else{
            
              //SOC-9796 PMD fixes
             //retURLStr = '/apex/apttus-config2__CartDetailView?configRequestId='+configRequestId+'&businessObjectId='+businessObjectId+'&id='+productConfig+'&retId='+businessObjectId;
              retURLStr = '/apex/apttus-config2__CartDetailView?configRequestId='+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId)))+'&businessObjectId='+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId)))+'&id='+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(pId)))+'&retId='+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId)));
           
         }
        //SOC-9796 PMD fixes
        //multiLocationsUrlStr = '/apex/APTS_MultiLocationsPage?configRequestId='+configRequestId+'&businessObjectId='+businessObjectId+'&id='+productConfig+'&retId='+BusinessObjectId+'&flow=ngFlow';
        multiLocationsUrlStr = '/apex/APTS_MultiLocationsPage?configRequestId='+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId)))+'&businessObjectId='+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId)))+'&id='+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(pId)))+'&retId='+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId)))+'&flow=ngFlow';
      
         configCustomSettings();
       
         
         adjustmentTypeList = new list<string>();
         groupNameList = new list<string>();
         groupNameList.add(allName);
         groupNameList.addAll(getGroupPicklistValues());
         adjustmentTypeList = getAdjustmentPicklistValues();
         List<String> contractTypeList = getContractTermPicklistValues();
         List<String> yoyPickList = getYOYPicklistValues();
         List<String> bridgePick = getBridgePicklistValues();
         bridgePickVal = JSON.serialize(bridgePick);
         yoyPickVal = JSON.serialize(yoyPickList);
         contractPickVal = JSON.serialize(contractTypeList);
         adjustmentPickVal = JSON.serialize(adjustmentTypeList);
         groupPickVal = JSON.serialize(groupNameList);
        
         initConfig();
     }
     
     private void initConfig(){
         Config  = new Apttus_Config2__ProductConfiguration__c();
         // Get the Configuration record   //SOC-9796 PMD fixes
         if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()){
             Config =  [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_Config2__AccountId__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :configId];
             businessObj = config.Apttus_Config2__BusinessObjectType__c;
             Proposal = new Apttus_Proposal__Proposal__c();
              //SOC-9796 PMD fixes
             if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
                Proposal = [SELECT id, APTS_SSD_Sold_To__c FROM Apttus_Proposal__Proposal__c WHERE  id = :Config.Apttus_QPConfig__Proposald__c];
             }
         }
     }

     private void configCustomSettings(){
        Map<String, APTS_ConfigBundlePageSettings__c> configBundlePageList = APTS_ConfigBundlePageSettings__c.getall();
            
        if(!configBundlePageList.isEmpty()
            && configBundlePageList.containsKey(CUSTOMSETTINGSNAME)) {
            bundlePageSettings = configBundlePageList.get(CUSTOMSETTINGSNAME);
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Custom Settings are missing'));  
            return;
        }

        String[] onlineCodesStr = bundlePageSettings.Eligibility_codes_for_online_software__c.split(',');
        String[] printCodesStr = bundlePageSettings.Eligibility_codes_for_print__c.split(',');
        
        onlineCodes = new Set<String>(onlineCodesStr);
        printCodes = new Set<String>(printCodesStr);
        
        setOfWPKValid = new Set<String>(bundlePageSettings.WestPack_valid_codes__c.split(','));
        adjustmentPicklistValues = new List<String>(bundlePageSettings.Adjustment_Picklist_Values__c.split(','));
        ineligibleExistingDealsList = new Set<String>(bundlePageSettings.Ineligible_Existing_Deals__c.split(','));
        fullAdjustmentPicklist = JSON.serialize(APTS_AdjustmentPickList__c.getAll().values());

        allName = bundlePageSettings.Main_Bundle_Name__c;
        keepTermsError = bundlePageSettings.Keep_Terms_Error__c;
        adjustmentError = bundlePageSettings.Adjustment_Error__c;
        maximumNumberError = bundlePageSettings.Maximum_number_error__c;
        selectProductMessage = bundlePageSettings.Select_Product_Message__c;
     }
     /**
      * @description 
      * @param groupName
      * @param groupLine
      * @return GroupLNWrapper
      */
     @RemoteAction
      public static GroupLNWrapper createGroup(String groupName,string groupLine)
        {
                   GroupLNWrapper grp1;
                   APTS_Group__c groupLineItem = (APTS_Group__c)JSON.deserialize(groupLine, APTS_Group__c.class);
                     //SOC-9796 PMD fixes
                   if(Schema.sObjectType.APTS_Group__c.isCreateable()){
                       APTS_Group__c grp =new APTS_Group__c();                   
                       grp.APTS_GrossAmount__c = 0;
                       grp.APTS_Group_Name_Original__c =groupName;
                       grp.APTS_Group_Name__c =groupName;
                       grp.APTS_NetAmount__c=0;
                       insert grp;
                    grp1 = new GroupLNWrapper(grp,null, null);  
                    }                   
                   return grp1;
        
        }
        /**
         * @description 
        * @param lineItems
        * 
        * @return Map
        */
     public Map<String, List<Apttus_Config2__LineItem__c>> mapTabNameToLineItems(List<Apttus_Config2__LineItem__c> lineItems){
        Map<String, List<Apttus_Config2__LineItem__c>> retMap = new Map<String, List<Apttus_Config2__LineItem__c>>();
        for(String tabName : SetOfTabNames){
            retMap.put(tabName, new List<Apttus_Config2__LineItem__c>());
        }
        //A.S Change to store in custom setting
        //Set<String> onlineCodes = new Set<String>{'05E5','05SN','062P','062Q','0649','0651','0672','06AB','06AO','06AP','06AR','06BA','06DA','06E5','06I9','06IA','06J9','06L2','06LB','06M4','06OA','06OR','06P7','06PC','06PN','06PR','06PS','06Q3','06WA','13AB','13AR','13CF','13CM','13CR','13E2','13E9','13I9','13IQ','13LB','13LG','13LO','13LQ','13LR','13LX','13PE','13PS','13PX','13SB','13SN','13ST','13SX','06Q0','06Q6','13Q6'};
        for(Apttus_Config2__LineItem__c li: lineItems){
            if(li.Apttus_Config2__ChargeType__c != 'Subscription Fee'){
                continue;
            }
            
            //For options
            if(li.Apttus_Config2__LineType__c == 'Option'){
                //Look at options product's media stuff
                /*if(li.Apttus_Config2__AttributeValueId__c!=null && ((li.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c != null && li.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c.contains('APP')&& printCodes.contains(li.Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c)) 
                    || (li.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c != null && li.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c.contains('APP')&&printCodes.contains(li.Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c))))
                    retMap.get('Print').add(li);
                else if(onlineCodes.contains(li.Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c+li.Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c))
                    retMap.get('Online/Software').add(li);*/
                System.debug(LoggingLevel.WARN, 'Line Type = Option');
            }
            // For Canada Products  Added by Poonam Garg DOC-3019
            else if(li.APTS_Proposal_Business_Unit__c==Label.SALESORGCAN ){
                String[] onlineCodesCanStr = bundlePageSettings.Eligibility_codes_for_online_Canada__c.split(',');
                Set<String> onlineCodesCanada= new Set<String>(onlineCodesCanStr );
                if(li.Apttus_Config2__ProductId__c!=null && li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c!=null &&
                li.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c!=null &&
                onlineCodesCanada.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c+li.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c)){
                    retMap.get('Online/Software').add(li);
                }
               /* else if(li.Apttus_Config2__ProductId__c!=null && li.Apttus_Config2__ProductId__r.Family!=null && li.Apttus_Config2__ProductId__r.Family=='PRINT'){
                    retMap.get('Print').add(li);
                }*/
            } 
            //Start: GLP-3 :Jinal Bhatt For 21, CQ High Level / Low level Code
            else if(li.APTS_Proposal_Business_Unit__c=='SCS'
                    && li.APTS_Media_High_Level_Code__c=='21' 
                    && li.APTS_Media_Lower_Level_Code__c=='CQ') {
                    if(li.Apttus_Config2__ProductId__c!=null && li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c!=null &&
                        li.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c!=null &&
                        printCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c)){
                            retMap.get('Print').add(li);
                }
            }
            //End GLP -3
            //For non-options
            else{
                if(li.Apttus_Config2__AttributeValueId__c!=null && (
                    (li.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c != null && li.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c.contains('APP')&&printCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c))
                    ||
                    (li.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c != null && li.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c.contains('APP')&&printCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c)))){
                    retMap.get('Print').add(li);
                }
                else if(onlineCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c+li.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c)){
                    retMap.get('Online/Software').add(li);
                }
            }
        }
        System.debug(LoggingLevel.WARN,'retMap'+retMap);
        return retMap;
     }
    
     /**
      * @description
      */
     public void doinit(){
     
      //SOC-4319
         list<Apttus_Config2__LineItem__c> cancelledList = retreiveCancelledLnItem ();
         System.debug(LoggingLevel.WARN,'cancelledList'+cancelledList);
         canLnList = JSON.serialize (cancelledList);
         list<APTS_Group__c> grpList = getGrouplnItems();   
         System.debug(LoggingLevel.WARN,'grpList'+grpList);
         if(!grpList.isEmpty()){  
             for(APTS_Group__c previousGroup : grpList){
                if(previousGroup.APTS_MLA__c){
                    isMLA = previousGroup.APTS_MLA__c;
                }

                if(previousGroup.APTS_Decentralized__c){
                    decentralized = previousGroup.APTS_Decentralized__c;
                }
             }
         }
         
         list<Apttus_Config2__LineItem__c> lnItems = retriveLineItemList();
         System.debug(LoggingLevel.WARN,'lnItems'+lnItems);   
         Id accountId = null;
         if(Proposal.APTS_SSD_Sold_To__c != null){
            list<Apttus_Config2__AssetLineItem__c> assetlnItems = retriveAssetLineItemList(Proposal.APTS_SSD_Sold_To__c);
            system.debug(LoggingLevel.WARN,assetlnItems);
            fullLnList = JSON.serialize(assetlnItems);
         }
         Map<String, List<Apttus_Config2__LineItem__c>> tabNameTolineItem = mapTabNameToLineItems(lnItems);
         system.debug(LoggingLevel.WARN,tabNameTolineItem);
         list<APTS_Group__c> groupListTobeInsert =  new list<APTS_Group__c>();
         List<TabWrapper> dataToDisplay = new List<TabWrapper>();
         GroupLnList = new list<GroupLNWrapper>();
         for(String tabName : SetOfTabNames){
             //Start tab specific
             List<Apttus_Config2__LineItem__c> liList = tabNameTolineItem.get(tabName);
             if(!liList.isEmpty()){
                 map<string,list<Apttus_Config2__LineItem__c>> lineGroupMap = new map<string,list<Apttus_Config2__LineItem__c>>();
                 Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap = new Map<String, List<Apttus_Config2__LineItem__c>>();
                lineGroupMap = MapOfLnByGrp(liList, assetPreGroupMap, tabName);
                 system.debug(LoggingLevel.WARN,'###assetPreGroupMap--> '+assetPreGroupMap.size());
                 list<GroupLNWrapper> tabGroups = new list<GroupLNWrapper>();
                 List<GroupLNWrapper> notDisplayed = new List<GroupLNWrapper>();
                system.debug(LoggingLevel.WARN,groupNameList);
                 for(string keyStr : groupNameList){
                     APTS_Group__c grp =  new APTS_Group__c();
                     grp.APTS_Group_Name__c = tabName+' '+keyStr;
                     grp.APTS_Group_Name_Original__c = tabName+' '+keyStr;
                    //grp.APTS_ProductConfiguration__c = configId;   //SOC-9796 PMD fixes
                    grp.APTS_ProductConfiguration__c = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(cId)));
                     grp.APTS_Discount_Amount__c=null;
                     grp.APTS_Quantity__c=null;
                     if(businessObj == 'Proposal'){
                        // grp.APTS_Quote_Proposal__c = businessObjectId;   //SOC-9796 PMD fixes                        
                            grp.APTS_Quote_Proposal__c = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId)));
                        
                     }
                     else{
                        // grp.APTS_Agreement__c = businessObjectId;    //SOC-9796 PMD fixes
                        grp.APTS_Agreement__c = (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId)));
                     }

                     if(tabName == 'Online/Software' && keyStr != allName){
                        grp.APTS_MLA__c = isMLA;
                        grp.APTS_Decentralized__c = decentralized;
                     }
                     
                     list<Apttus_Config2__LineItem__c> lineItemsOfGroup =  new list<Apttus_Config2__LineItem__c>();
                     Set<String> optionList = new Set<String>();
                     List<Decimal> netAmounts = new List<Decimal>{0,0,0,0,0,0,0};
                     if(!lineGroupMap.isEmpty()){
                        //If there are already items in the bundle
                         if(lineGroupMap.containsKey(keyStr)){
                             lineItemsOfGroup = lineGroupMap.get(keyStr);
                         }
                         //It's an empty bundle. Try to put the other map in this bundle
                         else{
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

                        if(tabName == 'Online/Software' && keyStr != allName && !assetPreGroupMap.isEmpty()){
                            for(String key : assetPreGroupMap.keySet()){
                                lineItemsOfGroup.addAll(assetPreGroupMap.get(key));
                                assetPreGroupMap.remove(key);
                            }
                        }

                         system.debug(LoggingLevel.WARN,'###lineItemsOfGroup--> '+lineItemsOfGroup);
                         List<Apttus_Config2__LineItem__c> liLists = new List<Apttus_Config2__LineItem__c>();
                         if(tabName.indexOf('Print') >= 0){
                            netAmounts= calculateNets(lineItemsOfGroup, optionList, liLists);
                         }
                         Apttus_Config2__LineItem__c li;
                         System.debug(LoggingLevel.WARN,'liLists ++ ' + liLists);
                         if(!liLists.isEmpty() && liLists.size() > 0){                            
                            li = liLists.get(0);
                         }
                         //For the top level group, always set to null
                         System.debug(LoggingLevel.WARN,'keyStr++' + keyStr + ' allName  +' +allName );
                         //System.debug('li ++' + li + 'li++' + li.Id);
                         if(keyStr == allName){
                            grp.APTS_Primary_Material__c = null;
                         }
                        //If there was a pre-defined material on the line item, then set it to that
                        
                        else if(li!=null && li.id!=null){                          
                            system.debug(LoggingLevel.WARN,'li :: '+li+' li.APTS_Group_Primary_Material_Name__c :: '+li.APTS_Group_Primary_Material_Name__c+'::  li.APTS_Product_Group_Primary_Material__c : '+li.APTS_Product_Group_Primary_Material__c);
                            String primaryMat = li.APTS_Group_Primary_Material_Name__c!=null ? li.APTS_Group_Primary_Material_Name__c : li.APTS_Product_Group_Primary_Material__c.substring(0,li.APTS_Product_Group_Primary_Material__c.indexOf(':'));
                            grp.APTS_Primary_Material__c = primaryMat;
                        }
                     }
                     grp.APTS_Adjustment_Type__c = 'Select Adjustment';             
                     GroupListTobeInsert.add(grp);

                     //Placeholder used for better drag and drog functionality
                     Apttus_Config2__LineItem__c placeHolder = new Apttus_Config2__LineItem__c();
                     lineItemsOfGroup.add(placeHolder);
                     GroupLNWrapper added = new GroupLNWrapper(grp,lineItemsOfGroup, optionList);
                     System.debug(LoggingLevel.WARN,'%%%%added'+added);
                    //Set potential pre-set values onto the group
                    if(!lineItemsOfGroup.isEmpty() && lineItemsOfGroup!=null && lineItemsOfGroup[0]!=null && lineItemsOfGroup[0].APTS_Keep_Terms__c!=null ){
                        added.keepTerms = lineItemsOfGroup[0].APTS_Keep_Terms__c;
                    }
                    /*if(netAmounts[4]==1)
                        added.allowKeepTerms = true;
                    added.blendDiscountRed = adjustmentTooHigh;
                    */
                     if(lineItemsOfGroup.size() > 1 || keyStr == allName){
                       tabGroups.add(added);
                     }else {
                        notDisplayed.add(added);
                     }
                     GroupLnList.add(added);  
                     if(tabName == 'Online/Software' && tabGroups.size()+notDisplayed.size() == 2){
                        break;}    
                 }
                 //Add at least one bundle to be visible
                 if(tabGroups.size() == 1){
                    tabGroups.add(notDisplayed.get(0));
                    notDisplayed.remove(0);
                 }
                 dataToDisplay.add(new TabWrapper(tabGroups,tabName, notDisplayed));
             }
         }
         //End Group type specific
         if(!GroupListTobeInsert.isEmpty()){
             insert GroupListTobeInsert;
         }
         System.debug(LoggingLevel.WARN,'&&&&&GroupLnList'+GroupLnList);  
         JSONLineItemData = JSON.serialize(GroupLnList);  
         System.debug(LoggingLevel.WARN,'&&&&&JSONLineItemData'+JSONLineItemData);    
         JSONTabInfo = JSON.serialize(dataToDisplay);
         JSONSetOfWPK = JSON.serialize(setOfWPKValid);
         JSONAccountsData = JSON.serialize(getAccounts());

         if(dataToDisplay.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, bundlePageSettings.No_Items_Error__c));
         }
     }
     
     
   @TestVisible  private List<Decimal> calculateNets(List<Apttus_Config2__LineItem__c> lineItemsOfGroup, Set<String> optionList, List<Apttus_Config2__LineItem__c> liList){           
            Decimal netAmount = 0;
            Decimal grossAmount = 0;
            Decimal incrementalRevenue = 0;
            Decimal incrementalRevenueRequired = 0;
            Decimal allowKeepTerms = 0;
            //Decimal incrementalValueNeeded = 0;
            Decimal maxDiscountedAmount = 0;
            Decimal discountAmount=0;
            Apttus_Config2__LineItem__c li;
            for(Apttus_Config2__LineItem__c ln : lineItemsOfGroup){
                if(ln.Apttus_Config2__NetPrice__c != null){
                    NetAmount += ln.Apttus_Config2__NetPrice__c;
                    if(ln.Apttus_Config2__LineStatus__c == 'New')
                    {
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
                    GrossAmount += ln.Apttus_Config2__ExtendedPrice__c;
                     discountAmount = !setOfWPKValid.contains(ln.APTS_SAP_Deal_Type__c) ? bundlePageSettings.APTS_Max_Discount__c : bundlePageSettings.APTS_WestPack_Discount__c;
                    maxDiscountedAmount += ln.Apttus_Config2__ExtendedPrice__c * discountAmount/100;
                }
                if(li==null || li.Apttus_Config2__NetPrice__c < ln.Apttus_Config2__NetPrice__c)
                {
                    li = ln;
                }
                Integer indexOfSplit;
                If(!String.isEmpty(ln.APTS_Product_Group_Primary_Material__c)){
                    indexOfSplit = ln.APTS_Product_Group_Primary_Material__c.indexOf(':');
                    

                String matName = ln.APTS_Product_Group_Primary_Material__c.substring(0, indexOfSplit);
                optionList.add(matName);
                }
               
                
            }
            incrementalRevenueRequired *= bundlePageSettings.Incremental_Revenue_Required__c;
            maxDiscountedAmount = GrossAmount == 0 ? 0 : maxDiscountedAmount / GrossAmount;
            liList.add(li);
            return new List<Decimal>{NetAmount, GrossAmount, incrementalRevenue, incrementalRevenueRequired, allowKeepTerms, maxDiscountedAmount};
        }
     
     // Mathod to get dynamically picklist values of Group field
     private List<string> getGroupPicklistValues(){
        List<string> pickValues= new List<string>();        
        Schema.DescribeFieldResult fieldResult = Apttus_Config2__LineItem__c.APTS_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){   
          pickValues.add(f.getValue());
        }       
        return pickValues;
     }
     
      // Method to get dynamically picklist values of Adjustment type field
     private List<string> getAdjustmentPicklistValues(){
        return adjustmentPicklistValues;
     }
     
     private List<String> getContractTermPicklistValues(){
        List<String> pickValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Apttus_Config2__LineItem__c.APTS_Contract_Term__c.getDescribe();
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){   
            pickValues.add(f.getValue());
        }
        return pickValues;
     }

     private List<String> getYOYPicklistValues(){
        List<String> pickValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Apttus_Config2__LineItem__c.APTS_YOY_Adjustment_Type__c.getDescribe();
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){   
            pickValues.add(f.getValue());
        }
        return pickValues;
     }
     private List<String> getBridgePicklistValues(){
        List<String> pickValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Apttus_Config2__LineItem__c.APTS_Bridge__c.getDescribe();
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){   
            pickValues.add(f.getValue());
        }
        return pickValues;
     } 
     /**
      * @description get the Configuration related data 
      @return list
      */   
     
     public list<Apttus_Config2__LineItem__c> getConfigLineItems(){
         //SOC-9796 PMD fixes 
        // string buildCondition = 'Apttus_Config2__ConfigurationId__c = \''+configId+'\' AND Apttus_Config2__LineType__c = \'Product/Service\'';
        string buildCondition = 'Apttus_Config2__ConfigurationId__c = \''+(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(cId)))+'\' AND Apttus_Config2__LineType__c = \'Product/Service\'';
         list<Apttus_Config2__LineItem__c> lineItems = new list<Apttus_Config2__LineItem__c>(); 
         lineItems = BuildQuery(true,'Apttus_Config2__LineItem__c',buildCondition,false,'',false,'');
         return lineItems;
     }
     
     private map<string,list<Apttus_Config2__LineItem__c>> mapOfLnByGrp(list<Apttus_Config2__LineItem__c> lineItems, Map<String, List<Apttus_Config2__LineItem__c>> assetPreGroupMap, String tabName){
         map<string,list<Apttus_Config2__LineItem__c>> grpLnMap = new map<string,list<Apttus_Config2__LineItem__c>>();
         for(Apttus_Config2__LineItem__c ln : lineItems){
            String key = ln.APTS_Group__c==null ?allName:ln.APTS_Group__c;
            //|| ln.Apttus_Config2__AssetLineItemId__c != null
             if(GrpLnMap.containsKey(key)){
                 list<Apttus_Config2__LineItem__c> oldlnList = GrpLnMap.get(key);
                 OldlnList.add(ln);
                 GrpLnMap.put(key,OldlnList);
             }
             else{
                 list<Apttus_Config2__LineItem__c> newlnList = new list<Apttus_Config2__LineItem__c>();
                 NewlnList.add(ln);
                 GrpLnMap.put(key,NewlnList);
             }
         }
        //Check for assets
        List<Apttus_Config2__LineItem__c> allList = GrpLnMap.get(allName);
        //Integer i =0;
        //for(Apttus_Config2__LineItem__c li: allList){
        if(allList!=null){
            for(Integer i=0; i<allList.size(); ++i){
                Apttus_Config2__LineItem__c li = allList.get(i);
                if(li.Apttus_Config2__AssetLineItemId__c != null && ( (tabName == 'Print' && li.APTS_SAP_Deal_Number__c!=null && li.APTS_SAP_Deal_Type__c!=null) 
                                                                        || (tabName == 'Online/Software' && li.APTS_SAP_MLA_Agreement_Number__c!=null) ) ){

                    String key = null;
                    if(tabName == 'Print' && li.APTS_SAP_Deal_Number__c!=null && li.APTS_SAP_Deal_Type__c!=null){
                        key = li.APTS_SAP_Deal_Number__c + li.APTS_SAP_Deal_Type__c;
                    } else{
                        key = li.APTS_SAP_MLA_Agreement_Number__c;
                    }

                    //+ li.APTS_SAP_Deal_Primary_Material__c;
                    if(assetPreGroupMap.containsKey(key)){
                        List<Apttus_Config2__LineItem__c> assetBundle = assetPreGroupMap.get(key);
                        if(assetBundle.size() == 1){
                            Set<Apttus_Config2__LineItem__c> temp=new Set<Apttus_Config2__LineItem__c>(assetBundle);
                            for(Integer x = 0; x<allList.size(); ++x){
                                if(temp.contains(allList.get(x))){
                                    allList.remove(x);
                                    --i;
                                    break;
                                }
                            }    
                        }
                        assetBundle.add(li);
                        allList.remove(i--);
                    }
                    else{
                        assetPreGroupMap.put(key, new List<Apttus_Config2__LineItem__c>{li});
                    }
                }
            }
             //So only values with more than one value are assigned to a bundle
             for(String key : assetPreGroupMap.keySet()){
                if(assetPreGroupMap.get(key).size() < 2){
                    assetPreGroupMap.remove(key);
                }
            }
        }
         return GrpLnMap;
     }
        
     // get group line items if any
     private  list<APTS_Group__c> getGrouplnItems(){
        List<APTS_Group__c> grplst;
        //SOC-9796 PMD fixes 
        if(Schema.sObjectType.APTS_Group__c.isQueryable()){
         grplst= [SELECT Id, Name, APTS_Adjustment_Value__c, APTS_WCMP_Current_Monthly_Spend__c, APTS_WCMP_Modified_Monthly_Spend__c, APTS_Adjustment_Type__c, APTS_Agreement__c, APTS_Discount__c, APTS_GrossAmount__c, APTS_Group_Name__c, APTS_Group_Name_Original__c, APTS_NetAmount__c, APTS_ProductConfiguration__c, APTS_Quote_Proposal__c, APTS_Online_Incremental__c, APTS_Existing_Agreement_Total__c, APTS_MLA__c, APTS_Decentralized__c,APTS_Existing_ship_and_charge_Total__c,APTS_Terminated_Lines_Total__c  FROM APTS_Group__c WHERE APTS_Quote_Proposal__c = :BusinessObjectId];
        }
        return grplst;
     }
    /**
     * @description Get cancelled Line Item List
     * @return list*/ 
    //SOC-4319  Get cancelled Line Item List
     public list<Apttus_Config2__LineItem__c> retreiveCancelledLnItem (){
         List<Apttus_Config2__LineItem__c> configlinetemlst;
         //SOC-9796 PMD fixes 
         if(Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()){
                configlinetemlst = [SELECT Id, Name,APTS_Cancelled_Adjustment_Amount__c,APTS_Deal_Number__c,Apttus_Config2__LineNumber__c,APTS_Deal_Type__c,Apttus_Config2__AssetLineItemId__c,
                Apttus_Config2__NetPrice__c,Apttus_Config2__LineStatus__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :configId
                    AND Apttus_Config2__LineStatus__c ='Cancelled' AND  APTS_Deal_Number__c != null AND APTS_Deal_Type__c != null order by Name,Apttus_Config2__LineNumber__c];
                }
                return configlinetemlst;
     }        
    // Method for getting data by dynamic SOQL
    // Method for creating query with all fields and conditional basis
    private list<sobject> buildQuery(boolean complex, string sobjectName, string condition, boolean orderOp, string orderpref, boolean limitOp, string limitpref){
        String sobjectApiName = sobjectName;
        string query;        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        query = 'SELECT ' + commaSepratedFields + ' FROM ' + string.escapesinglequotes(SobjectApiName);
        if (complex == true){        
            if(condition != null && condition != ''){
                query += ' WHERE ' + condition;
            }
            if(orderOp == true){
                if (orderpref != null && orderpref != ''){
                    query += ' ORDER BY ' + orderpref;
                }
            }
            if(limitOp == true){
                if(limitpref != null && limitpref != ''){
                    query += ' LIMIT ' + limitpref;
                }
            }
        }
        system.debug(LoggingLevel.WARN,'###Builded Query--> '+query);
        list<sObject> queryResult = Database.query(query);
 
        return queryResult;
    }
    /**
     * @description 
     * @return list
     */
    public list<Apttus_Config2__LineItem__c> retriveLineItemList(){
        list<Apttus_Config2__LineItem__c> configlnitem;
        //SOC-9796 PMD fixes 
        if(Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()){
        configlnitem= [SELECT Id, Name,APTS_Deal_Number__c, APTS_DefaultNetPrice__c, Apttus_Config2__BaseExtendedPrice__c,  APTS_Product_Name__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c, 
                APTS_Product_Or_Option_Name__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ChargeType__c, Apttus_Config2__ExtendedCost__c,Apttus_Config2__Quantity__c, 
                Apttus_Config2__ExtendedPrice__c, APTS_Group__c, Apttus_Config2__LineType__c, Apttus_Config2__ListPrice__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PricingStatus__c, 
                Apttus_Config2__ProductId__c, Apttus_Config2__ProductOptionId__c, Apttus_Config2__PriceAdjustment__c,Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c,Apttus_Config2__SellingTerm__c, 
                Apttus_Config2__NetPrice__c, Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c, Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c,  
                Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c,Apttus_Config2__ProductId__r.Service_Number__c,Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c, 
                Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, 
                APTS_Years_2_Plus_Adjustment__c, APTS_YoY_Adjustment_Type__c, APTS_Year_2_Adj_Default__c, APTS_Years_3_5_Adj_Default__c, APTS_Years_6_10_Adj_Default__c, APTS_SAP_Deal_Number__c, 
                APTS_SAP_Deal_Type__c, APTS_SAP_Deal_Primary_Material__c, Apttus_Config2__AssetLineItemId__c,APTS_Bundle__c, APTS_Product_Group_Primary_Material__c, APTS_Group_Primary_Material__c, 
                APTS_Contract_Term_Default__c, APTS_Group_Primary_Material_Name__c, APTS_Keep_Terms__c, APTS_Max_Discount__c, APTS_WestPack_Discount__c, APTS_SAP_MLA_Agreement_Number__c, 
                APTS_Years_2_Plus_Default__c, APTS_Yr_1_Renewal_Default__c, APTS_Deal_Type__c,APTS_SSD_ship_to__c,Apttus_Config2__AllowManualAdjustment__c,APTS_Proposal_Business_Unit__c,
                Apttus_Config2__ProductId__r.LCRM_Sub_Bu__c, APTS_Media_High_Level_Code__c, APTS_Media_Lower_Level_Code__c,APTS_Product_code__c,APTS_Is_Primary_in_Bundle__c,Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c //DOC-15605
            FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :configId 
                AND Apttus_Config2__LineStatus__c!= 'Cancelled'
                AND APTS_SAP_Deal_Type__c not in :ineligibleExistingDealsList order by Name,Apttus_Config2__LineNumber__c];
        }
        return configlnitem;
    }
    /**
     * @description Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c to below query
     * @return list
     * @param accountSSDId
     * */ 
    // punitha added Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c to below query
    public list<Apttus_Config2__AssetLineItem__c> retriveAssetLineItemList(Id accountSSDId){
        List<Apttus_Config2__AssetLineItem__c> asstlnitem ;
        //SOC-9796 PMD fixes 
        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
        asstlnitem = [SELECT Id, Name, APTS_Deal_Number__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c, Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__ProductId__r.ProductCode,APTS_SSD_Sold_To__c   
        FROM Apttus_Config2__AssetLineItem__c WHERE Apttus_Config2__AssetStatus__c = 'Activated' AND Apttus_Config2__IsInactive__c = false AND ( (APTS_Deal_Number__c != null AND APTS_Deal_Type__c != null) OR APTS_SAP_MLA_Agreement_Number__c != null)  AND APTS_SSD_Sold_To__c = :accountSSDId order by Name,Apttus_Config2__LineNumber__c];
        }
        return asstlnitem;
   }
   /**
     * @description
     *
     * 
     * */ 
    // Added by Gayatri for SOC-9359
     public void  checknondiscoutproducts(){         
        List<Apttus_Config2__LineItem__c>  conflnitms = new list<Apttus_Config2__LineItem__c>();
        for(Apttus_Config2__LineItem__c ln :  lnItemsduplist){
             if(ln.Apttus_Config2__AllowManualAdjustment__c == false && ( Integer.valueof(ln.Apttus_Config2__AdjustmentAmount__c) > 0.000 )){
              ln.Apttus_Config2__AdjustmentAmount__c= null;
              ln.Apttus_Config2__AdjustmentType__c=  null; 
              ln.Apttus_Config2__NetPrice__c=  ln.Apttus_Config2__BasePrice__c;            
              IF(! conflnitms.contains(ln)) {        
              conflnitms.add(ln);
              }
             }   
        }
        //SOC-9796 PMD fixes 
        if(Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
            update conflnitms;
        }
     }
     /**
      * @description
      @return pageref
       */  
    public pageReference saveAdjustmentData(){
        String jsonData = string.escapeSingleQuotes('JSONData');
         string jsonReturnedData;
         string actionType;
         string  groupId;
        if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(jsonData)))){      
             JsonReturnedData =(String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(jsonData)));
        }
        String acttype = string.escapeSingleQuotes('ActionType');
        if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(acttype)))){ 
             actionType = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(acttype)));
        }
        String grpId = string.escapeSingleQuotes('groupId');
        if(string.isNotBlank(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(grpId)))){        
             groupId = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(grpId)));
        }
        system.debug(LoggingLevel.WARN,'###JsonReturnedData '+JsonReturnedData);
        //GroupLNWrapper GrpWrapper =  new GroupLNWrapper();
      //  string makeJSONStr = '{"tabsList":'+JsonReturnedData+'}';
          //SOC-9796 PMD fixes
 
      string makeJSONStr = '{"tabsList":'+(String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(jsonData)))+'}';
        //system.debug('###makeJSONStr '+makeJSONStr);
        string parsedFilteredData = makeJSONStr.replace('T00:00:00.000Z','');
        parsedFilteredData=parsedFilteredData.unescapeEcmaScript();        
        //system.debug('###parsedFilteredData '+parsedFilteredData);
        JSONParser parser = JSON.createParser(parsedFilteredData);        
        system.debug(LoggingLevel.WARN,'###parser '+parser);
        JSONReadClass wrapData = (JSONReadClass)parser.readValueAs(JSONReadClass.class);
        system.debug(LoggingLevel.WARN,'##WrapData '+WrapData);
        if(parseAndSaveData(WrapData, actionType)){
        
            if(actionType == 'goToMultiLocation'){
                pageReference pageRef = new pagereference('/apex/APTS_MultiLocationsPage');
                //pageRef.getParameters().put('configRequestId',configRequestId);//SOC-9796 PMD fixes
               // pageRef.getParameters().put('businessObjectId',BusinessObjectId);//SOC-9796 PMD fixes
                //pageRef.getParameters().put('retId',BusinessObjectId);//SOC-9796 PMD fixes
                //pageRef.getParameters().put('id',productConfig);//SOC-9796 PMD fixes
                //pageRef.getParameters().put('groupId', groupId);    //SOC-9796 PMD fixes           
                pageRef.getParameters().put('configRequestId', (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId))));
            
                pageRef.getParameters().put('businessObjectId',(String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId))));
                pageRef.getParameters().put('retId',(String)(String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(buId))));
                pageRef.getParameters().put('id',(String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(pId))));
                pageRef.getParameters().put('groupId', (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(grpId))));
                pageRef.getParameters().put('flow', 'ngFlow');
                pageRef.setRedirect(true);
                return pageRef;
            } else {
                //pageReference pageRef = new pagereference('/apex/Apttus_Config2__Pricing');//Changed from Cart to Pricing as part of Apttus Upgrade.
                pageReference pageRef = new pagereference('/apex/Apttus_Config2__Cart');  //Commented by Rishi today 
                //pageRef.getParameters().put('configRequestId',configRequestId);    //SOC-9796 PMD fixes             
                 pageRef.getParameters().put('configRequestId',(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId))));
                // pageRef.getParameters().put('id',productConfig);  //SOC-9796 PMD fixes
                pageRef.getParameters().put('id',(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(pId))));
                pageRef.getParameters().put('flow', 'ngcpq#/cart');
                pageRef.setRedirect(true);
                return pageRef;
            }   
        }
        else{
        
            //Added as part of SOC-3699 : validation for Non-EDP products in EDP LT Bundle
            if(ediscoveryLTProduct == true && ediscoveryWOProduct){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Can’t bundle Non-EDP products in EDP LT Bundle'));
                   return null;
            }
            // Added by Gayatri for SOC-9359
            else if(notDiscountEligible == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,string.join(nondiscntprodctslst,',')+' '+'is a non-discountable product, please remove discount before proceeding'));
                   return null;
            }
            else{
            //A.S Change to store in custom setting
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, bundlePageSettings.Validation_Error__c));
            return null;}
        }
    }
    
    
    private boolean parseAndSaveData(JSONReadClass dataWrapClass, String actionType){
        boolean isMLA = false;
        boolean isKeepTerms = false;
        boolean existOnlineSoftwareProduct = false;
        Boolean isNotNewLineItem=false;
        String mlaAgreementNumber;
        //Added as part of SOC-3699 : validation for Non-EDP products in EDP LT Bundle
        ediscoveryLTProduct = false;
        ediscoveryWOProduct = False;
        notDiscountEligible =false; //added -soc9359 
        
        List<TabWrapper> tabs = DataWrapClass.tabsList;
        List<APTS_Group__c> grpListToUpdate =  new List<APTS_Group__c>();
        list<Apttus_Config2__LineItem__c> lnItemsToUpdate = new list<Apttus_Config2__LineItem__c>();
        Set<Id> groupIds = new Set<Id>();
        //13387
        String bundlename;
        String adjusttype;
        String pricing;
        Decimal listvalue;
        Decimal basevalue;
        Decimal adjustvalue;
        Decimal count;
        Map<String,String> bundles = new Map<String,String>();
        Map<String,Decimal> bundlecount = new Map<String,Decimal>();
        List<String> prdcode = new List<String>();
        String groupPrimaryMaterial='';
        Map<String,String> groupNameUpdated=new Map<String,String>();
        Map<String,APTS_Group__c > groupAssignedToLineItem=new Map<String,APTS_Group__c >();
        //13387
        for(TabWrapper tab : tabs){
            list<GroupLNWrapper> groupLnDataList = tab.dataList;  
            if(GroupLnDataList!=null){
                GroupLnDataList.addAll(tab.notShownDataList);               
                for(GroupLNWrapper gw : groupLnDataList){
                    APTS_Group__c grpLnToUpdate =  GW.grpLn;
                    system.debug(LoggingLevel.WARN,'group material number:'+grpLnToUpdate.APTS_Primary_Material__c);
                    GrpListToUpdate.add(grpLnToUpdate);
                    groupIds.add(grpLnToUpdate.Id);
                    list<Apttus_Config2__LineItem__c> lineItemsList = GW.lnItems;  
                    String grpName = !grpLnToUpdate.APTS_Group_Name__c.contains(allName)?grpLnToUpdate.APTS_Group_Name__c.substring(grpLnToUpdate.APTS_Group_Name__c.indexOf('Bundle'), grpLnToUpdate.APTS_Group_Name__c.length()):null;
                    system.debug(LoggingLevel.WARN,'group name:'+grpName);         
                    if(grpLnToUpdate.APTS_MLA__c){
                        isMLA = true;
                    }
                    if(grpLnToUpdate.APTS_SAP_MLA_Agreement_Number__c != null){
                        mlaAgreementNumber = grpLnToUpdate.APTS_SAP_MLA_Agreement_Number__c;
                    }
                    //13387
                    listvalue = 0;
                    basevalue = 0;
                    adjustvalue = 0;
                    count = 0;
                    bundlename = '';
                    adjusttype = '';
                    pricing = '';
                   
                    //13387
                    if(!lineItemsList.isEmpty()){
                        Apttus_Config2__LineItem__c sameCheck = lineItemsList.get(0);
                        if(sameCheck.Apttus_Config2__Quantity__c != null){
                        System.debug(LoggingLevel.WARN,'Poonam 1'+existOnlineSoftwareProduct );
                            if(!grpLnToUpdate.APTS_Group_Name__c.contains(allName) && grpLnToUpdate.APTS_Group_Name__c.contains('Online/Software') ){
                                existOnlineSoftwareProduct = true;
                            }          
                            
                            System.debug(LoggingLevel.WARN,'Poonam 2'+existOnlineSoftwareProduct );               
                            for(Apttus_Config2__LineItem__c ln:lineItemsList){
                                System.debug(LoggingLevel.WARN,'lnm'+ln);  
                                if(ln.Apttus_Config2__Quantity__c != null){
                                    /*if(sameCheck.APTS_Bridge__c != ln.APTS_Bridge__c || sameCheck.APTS_Bridge_Discount__c != ln.APTS_Bridge_Discount__c || sameCheck.APTS_Contract_Term__c != ln.APTS_Contract_Term__c || sameCheck.APTS_Year_2_Adjustment__c != ln.APTS_Year_2_Adjustment__c
                            || sameCheck.APTS_Years_3_5_Adjustment__c != ln.APTS_Years_3_5_Adjustment__c || sameCheck.APTS_Years_6_10_Adjustment__c != ln.APTS_Years_6_10_Adjustment__c || sameCheck.Apttus_Config2__AdjustmentAmount__c != ln.Apttus_Config2__AdjustmentAmount__c || sameCheck.Apttus_Config2__AdjustmentType__c != ln.Apttus_Config2__AdjustmentType__c)*/
                            
                            // Validation
                            /*if(sameCheck.APTS_Bridge__c != ln.APTS_Bridge__c || sameCheck.APTS_Bridge_Discount__c != ln.APTS_Bridge_Discount__c || sameCheck.APTS_Contract_Term__c != ln.APTS_Contract_Term__c || sameCheck.APTS_Yr_1_Renewal_Adjustment__c != ln.APTS_Yr_1_Renewal_Adjustment__c
                            || sameCheck.APTS_Years_2_Plus_Adjustment__c != ln.APTS_Years_2_Plus_Adjustment__c || sameCheck.Apttus_Config2__AdjustmentAmount__c != ln.Apttus_Config2__AdjustmentAmount__c || sameCheck.Apttus_Config2__AdjustmentType__c != ln.Apttus_Config2__AdjustmentType__c)
                                        return false;*/
                                    ln.APTS_Group__c = grpName;
                                    ln.APTS_Proposal_Group__c = grpLnToUpdate.Id;
                                    //ln.Apttus_Config2__PricingStatus__c =  'Pending';
                                    System.debug(LoggingLevel.WARN,'GW.allowKeepTerms'+GW.allowKeepTerms); 
                                    System.debug(LoggingLevel.WARN,'GW.keepTerms'+GW.keepTerms);
                                    ln.APTS_Keep_Terms__c = GW.allowKeepTerms ? GW.keepTerms : false;
                                    System.debug(LoggingLevel.WARN,'allowkeepterms'+ln.APTS_Keep_Terms__c); 
                                    if(ln.APTS_Keep_Terms__c && ln.APTS_Proposal_Business_Unit__c!=Label.SALESORGCAN ){
                                       if(!ln.APTS_Product_Group_Primary_Material__c.contains('40666420')){//SOC-3878 added by bijeta as WCMP modification 6/8/17
                                           ln.APTS_Group_Primary_Material__c = ln.APTS_SAP_Deal_Primary_Material__c;
                                           }
                                           if(ln.APTS_Product_Group_Primary_Material__c.contains('40666420')){ // SOC-4852 Bijeta
                                                ln.APTS_Group_Primary_Material_Name__c ='Existing WCMP';
                                            }
                                            else{
                                                ln.APTS_Group_Primary_Material_Name__c ='Existing Proflex';
                                            }

                                        isKeepTerms = true;
                                    }
                                     //Added by Poonam Garg DOC-3019
                                    if(ln.APTS_Keep_Terms__c && ln.APTS_Proposal_Business_Unit__c==Label.SALESORGCAN ){
                                       if(ln.APTS_Product_Group_Primary_Material__c.contains('41972767')){
                                           ln.APTS_Group_Primary_Material__c =  '41972767';
                                           ln.APTS_Group_Primary_Material_Name__c ='Existing Proflex';
                                           isKeepTerms = true;
                                        }
                                    }
                                    //added by gayatri- soc9359
                                      if(ln.Apttus_Config2__AdjustmentAmount__c == 0){
                                         ln.Apttus_Config2__AdjustmentAmount__c= null;
                                         ln.Apttus_Config2__AdjustmentType__c=  null;                                    
                                      }
                                    groupPrimaryMaterial=ln.APTS_Group_Primary_Material__c ;
                                    lnItemsToUpdate.add(ln);
                                }
                              
                                
                                //Added as part of SOC-3699 : validation for Non-EDP products in EDP LT Bundle
                                if(!string.isEmpty(ln.APTS_Group__c)){
                                     System.debug(LoggingLevel.WARN,'In side save method');
                                     if(ln.Apttus_Config2__ProductId__c!=null){
                                        if(((ln.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c+ ln.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c) != '13ST') && ln.Apttus_Config2__ProductId__r.Service_Number__c !='41841757'&& ln.Apttus_Config2__ProductId__r.Service_Number__c !='41841759'){ //DOC-15795 Added By Poonam Garg
                                            ediscoveryWOProduct =true;
                                            System.debug(LoggingLevel.WARN,'In side if APTS_Media_High_Level_Code__c'+ln.APTS_Media_High_Level_Code__c+ln.APTS_Media_Lower_Level_Code__c);
                                            //return false;
                                        }
                                        if(((ln.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c+ ln.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c) == '13ST') || ln.Apttus_Config2__ProductId__r.Service_Number__c =='41841757' || ln.Apttus_Config2__ProductId__r.Service_Number__c =='41841759' ){ //DOC-15795 Added By Poonam Garg
                                            ediscoveryLTProduct =true;    
                                        }
                                        if(ediscoveryLTProduct && ediscoveryWOProduct){
                                        return false;}
                                        // Added by gayatri & priyanka for SOC-9359
                                        if(ln.Apttus_Config2__AllowManualAdjustment__c == false && ( Integer.valueof(ln.Apttus_Config2__AdjustmentAmount__c) > 0.000 )){
                                         IF(! nondiscntprodctslst.contains(ln.APTS_Product_Name__c))  {                                      
                                            nondiscntprodctslst.add(ln.APTS_Product_Name__c); 
                                         }                                                                           
                                            notDiscountEligible =true;  
                                            return false;
                                        }                                   
                                     }                          
                             
                               }
                               //added by gayatri- soc9359
                               lnItemsduplist.add(ln);
                               //End of-Added as part of SOC-3699 : validation for Non-EDP products in EDP LT Bundle
                                                           //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here
                                if((ln.Apttus_Config2__LineStatus__c == 'New' || ln.Apttus_Config2__LineStatus__c == 'Amended')  && ln.APTS_Product_Code__c != null && !System.Label.APTS_Proflex_Materials.contains(ln.APTS_Product_Code__c)){
                                    basevalue = basevalue + ln.Apttus_Config2__BasePrice__c;
                                    listvalue = listvalue + ln.Apttus_Config2__ListPrice__c;
                                    adjustvalue = ln.Apttus_Config2__AdjustmentAmount__c;
                                    adjusttype = ln.Apttus_Config2__AdjustmentType__c;
                            }  
                                if((ln.Apttus_Config2__LineStatus__c == 'New' || ln.Apttus_Config2__LineStatus__c == 'Amended')  && ln.APTS_Product_Group_Primary_Material__c != null && ln.APTS_Group__c != null){
                                    bundlename = ln.APTS_Group_Primary_Material_Name__c+';'+ln.APTS_Group__c+':'+ln.APTS_Product_Group_Primary_Material__c.substringAfter(':');
                        }
                                System.debug(LoggingLevel.WARN,'ln.Apttus_Config2__LineStatus__c'+ln.Apttus_Config2__LineStatus__c);
                                System.debug(LoggingLevel.WARN,'ln.APTS_Product_Group_Primary_Material__c'+ln.APTS_Product_Group_Primary_Material__c);
                                System.debug(LoggingLevel.WARN,'Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c'+ln.Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c);
                                //DOC-15605 Added By poonam garg
                                if((ln.Apttus_Config2__LineStatus__c =='Amended' && ln.APTS_Product_Group_Primary_Material__c!=null && ln.APTS_Product_Group_Primary_Material__c.substringAfter(':')!='40666420' && ln.Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c=='WCMP') 
                                    || ln.Apttus_Config2__LineStatus__c =='Renewed' || (ln.APTS_Product_Code__c != null && System.Label.APTS_Proflex_Materials.contains(ln.APTS_Product_Code__c) && bundles.containsKey(bundlename) )){
                                        isNotNewLineItem =true;
                                }      
                                //DOC-15605 Added by Poonam Garg.  
                                count = count + 1;
                }
                            pricing = listvalue+'list'+basevalue+'base'+adjusttype+'adjust'+adjustvalue;
                            bundles.put(bundlename,pricing);
                            bundlecount.put(bundlename,count);
                            groupNameUpdated.put(bundlename,grpLnToUpdate.Id);  
                            groupAssignedToLineItem.put(bundlename,grpLnToUpdate);
                            System.debug(LoggingLevel.WARN,groupNameUpdated);
                            prdcode.add(bundlename.substringAfter(':'));
                            //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Ends Here
            }
        }
        }
            }
        }
        system.debug(LoggingLevel.WARN,'prdcode'+prdcode);
        if(!Test.isRunningTest()){
            if(!GrpListToUpdate.isEmpty() && Schema.sObjectType.APTS_Group__c.isUpdateable()){  //SOC-9796 PMD fixes-added schema check
                update GrpListToUpdate;
            }            
            if(!lnItemsToUpdate.isEmpty() && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){  //SOC-9796 PMD fixes-added schema check
                update lnItemsToUpdate;
            }
        }
        //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Starts Here
        Decimal existingTotal = 0;
        Decimal newTotal = 0;
        List<String> btemplist = new List<String>();
        for(Apttus_Config2__LineItem__c ln: [SELECT Id,Apttus_Config2__NetPrice__c,Apttus_Config2__LineStatus__c,APTS_Product_Group_Primary_Material__c,APTS_Totaling_Summary_Group__c,APTS_Bridge__c,APTS_New_Bridge_Discount__c,APTS_Contract_Term__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__Uom__c,Apttus_Config2__PriceUom__c,APTS_Product_Code__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__IsCustomPricing__c  ,Apttus_Config2__LineNumber__c,APTS_Group__c,APTS_Group_Primary_Material_Name__c FROM Apttus_Config2__LineItem__c 
                                            WHERE Apttus_Config2__ConfigurationId__c =: configId AND (Apttus_Config2__LineStatus__c = 'New' or Apttus_Config2__LineStatus__c = 'Amended')]){
            String bundle = '';
            System.debug(LoggingLevel.WARN,ln.APTS_Product_Group_Primary_Material__c +'product code' + ln.APTS_Product_Code__c);
            if(ln.APTS_Product_Group_Primary_Material__c != null){
                bundle = ln.APTS_Group_Primary_Material_Name__c+';'+ln.APTS_Group__c+':'+ln.APTS_Product_Group_Primary_Material__c.substringAfter(':');
            }
            if(ln.APTS_Product_Group_Primary_Material__c != null && ln.APTS_Product_Group_Primary_Material__c.substringAfter(':') == ln.APTS_Product_Code__c){
                btemplist.add(bundle);           
            }
            if(ln.Apttus_Config2__NetPrice__c!=null){
            if(ln.Apttus_Config2__LineStatus__c == 'New'){
                    newTotal+= ln.Apttus_Config2__NetPrice__c;}
            else{
                    existingTotal+= ln.Apttus_Config2__NetPrice__c;}  
            }        
        }
        List<Apttus_Config2__PriceListItem__c> plis = new List<Apttus_Config2__PriceListItem__c>();
        Map<String,Apttus_Config2__PriceListItem__c> plimap = new Map<String,Apttus_Config2__PriceListItem__c>();
        if(!prdcode.isEmpty()){
            if (Schema.sObjectType.Apttus_Config2__PriceListItem__c.isQueryable()){
            plis = [Select Id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductCode__c,Apttus_Config2__ProductName__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__Frequency__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__ChargeType__c,Apttus_Config2__ListPrice__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductCode__c IN: prdcode AND Apttus_Config2__PriceType__c != 'One Time'];
            }
        }
        for(Apttus_Config2__PriceListItem__c str : plis){
            plimap.put(str.Apttus_Config2__ProductCode__c,str);
        }
        System.debug(LoggingLevel.WARN,'plimap'+plimap);
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        request.CartId = configId;
        System.debug(LoggingLevel.WARN,'Testdata1'+request.CartId);
        System.debug(LoggingLevel.WARN,'configId'+configId);
        Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
        Boolean callapi = false;
        for(String str : bundles.keySet()){
            if(btemplist != null && !btemplist.contains(str)){
                String temp = str.substringAfter(':');
                if(!plimap.isEmpty() && plimap.get(temp) != null && !(isNotNewLineItem)){
                    selectedProduct.ProductId = plimap.get(temp).Apttus_Config2__ProductId__c;
                    System.debug(LoggingLevel.WARN,'Testdata2'+selectedProduct.ProductId);
                    selectedProduct.Quantity = 1;
                    selectedProduct.SellingTerm = 1; //Changed to 1 from 12 for Apttus Upgrade
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
                    customdata.apts_keep_terms__c =iskeepterms ;
                    System.debug(LoggingLevel.WARN,selectedProduct);
                    System.debug(LoggingLevel.WARN,customData);
                    selectedProduct.CustomData = customData; 
                    request.SelectedProducts.add(selectedProduct);
                    System.debug(LoggingLevel.WARN,'request'+request);
                    
                    callapi = true;
                }
            }
        }
        if(callapi == true && !Test.isRunningTest()){
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
        }
        Decimal count1 = 1;
        Map<String,Decimal> linseq = new Map<String,Decimal>();
        Map<String,Apttus_Config2__LineItem__c> fieldmap = new Map<String,Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>();
        for(Apttus_Config2__LineItem__c li: [SELECT Id,Apttus_Config2__ConfigurationId__c ,Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__LineStatus__c,Apttus_Config2__AdjustmentAmount__c,APTS_Totaling_Summary_Group__c,APTS_Bridge__c,APTS_New_Bridge_Discount__c,APTS_Contract_Term__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__Uom__c,Apttus_Config2__PriceUom__c,APTS_Product_Code__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__IsCustomPricing__c  ,Apttus_Config2__LineNumber__c,APTS_Group__c,APTS_Group_Primary_Material_Name__c,currencyisocode,Apttus_Config2__SellingTerm__c ,Apttus_Config2__PriceType__c ,Apttus_Config2__LineType__c,Apttus_Config2__ItemSequence__c ,Apttus_Config2__LineSequence__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__ChargeType__c, Apttus_Config2__NetPrice__c  ,Apttus_Config2__NetUnitPrice__c ,Apttus_Config2__PriceMethod__c
                                            FROM Apttus_Config2__LineItem__c
                                            WHERE Apttus_Config2__ConfigurationId__c =: configId AND (Apttus_Config2__LineStatus__c = 'New' or Apttus_Config2__LineStatus__c = 'Amended')]){
            System.debug(LoggingLevel.WARN,li.Apttus_Config2__ConfigurationId__c + ''+  li);
            if(prdcode != null && !prdcode.contains(li.APTS_Product_Code__c)){
                    fieldmap.put(li.APTS_Totaling_Summary_Group__c,li);
            }
            if(prdcode != null && prdcode.contains(li.APTS_Product_Code__c)){
                for(String str : bundles.keyset()){
                    System.Debug('@@@@ Conga TS 1: ' + li);
                    System.Debug('@@@@ Conga TS 2: ' + str);
                    String temp = str.substringAfter(':');
                    if(li.APTS_Product_Code__c == temp){
                        li.APTS_Group__c = str.substringBetween(';',':');
                        li.APTS_Group_Primary_Material_Name__c = str.substringBefore(';');
                        if(bundles.get(str) != null){
                            li.Apttus_Config2__ListPrice__c = Decimal.valueOf(bundles.get(str).substringBefore('list'));
                            li.Apttus_Config2__BasePrice__c= Decimal.valueOf(bundles.get(str).substringBetween('list','base'));
                            li.Apttus_Config2__IsCustomPricing__c = true;
                        }
                        system.debug('Count '+count1);
                        li.Apttus_Config2__LineSequence__c  = count1;
                        li.Apttus_Config2__LineNumber__c = count1;    
                        li.Apttus_Config2__PriceUom__c='Each';
                        li.Apttus_Config2__Uom__c='Each';
                        li.APTS_Group_Primary_Material__c =groupPrimaryMaterial;
                        if(!plimap.isEmpty() && plimap.get(temp)!=null){
                        li.Apttus_Config2__ChargeType__c= plimap.get(temp).Apttus_Config2__ChargeType__c; 
                        li.Apttus_Config2__SellingFrequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
                        li.Apttus_Config2__PriceType__c=plimap.get(temp).Apttus_Config2__PriceType__c;
                        li.Apttus_Config2__Frequency__c=plimap.get(temp).Apttus_Config2__Frequency__c;
                        li.Apttus_Config2__Term__c=1;
                        li.Apttus_Config2__BasePriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c;
                        li.Apttus_Config2__PriceMethod__c=plimap.get(temp).Apttus_Config2__PriceMethod__c; 
                        if(!(li.Apttus_Config2__LineStatus__c=='Amended')){ 
                        li.Apttus_Config2__LineStatus__c='New'; }
                        }
                        //li.APTS_MLA__c=isMLA;
                        System.debug(LoggingLevel.WARN,'Poonam 3'+existOnlineSoftwareProduct );
                        if ( existOnlineSoftwareProduct ) {
                            li.APTS_MLA__c = true;
                        } 
                        li.APTS_Decentralized__c=decentralized;
                        if(groupAssignedToLineItem!=null && groupAssignedToLineItem.get(str)!=null){
                        li.APTS_Existing_Agreement_Total__c = groupAssignedToLineItem.get(str).APTS_Existing_Agreement_Total__c;
                        li.APTS_Online_Incremental__c = groupAssignedToLineItem.get(str).APTS_Online_Incremental__c;
                        li.APTS_Proposal_Group__c = groupAssignedToLineItem.get(str).id;
                        }
                        li.APTS_Existing_Subscriptions_Total__c =existingTotal;
                        li.APTS_New_Subscriptions_Total__c   =newTotal; 
                        /*if(groupNameUpdated!=null && groupNameUpdated.get(str)!=null){  
                        System.debug('bundle'+groupNameUpdated.get(str));   
                          
                        }*/
                        li.APTS_is_Primary_in_Bundle__c=true;
                        li.apts_keep_terms__c =iskeepterms ;
                        count1 = count1 + 1 + bundlecount.get(str);
                        if(fieldmap != null && fieldmap.get(li.APTS_Totaling_Summary_Group__c) != null){
                        li.APTS_Bridge__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Bridge__c;
                        li.APTS_New_Bridge_Discount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_New_Bridge_Discount__c;
                        li.APTS_Contract_Term__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Contract_Term__c;
                        li.APTS_Years_2_Plus_Adjustment__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Years_2_Plus_Adjustment__c;
                        li.Apttus_Config2__BillingFrequency__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__BillingFrequency__c;
                        li.Apttus_Config2__AdjustmentType__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentType__c;
                        li.Apttus_Config2__AdjustmentAmount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentAmount__c;
                        }
                        lineitemlist.add(li);
                        bundles.remove(str);
                        break;
                    }
                }
            }
        }
        System.debug(LoggingLevel.WARN,lineitemlist);
        if(!lineitemlist.isEmpty() && !Test.isRunningTest()){
            update lineitemlist;
        }
        lineitemlist.clear();
        List<Apttus_Config2__LineItem__c> lilist = [SELECT Id,Apttus_Config2__LineType__c,Apttus_Config2__ProductId__c,APTS_Bundle__c,Apttus_Config2__LineStatus__c,APTS_Bridge__c,APTS_New_Bridge_Discount__c,Apttus_Config2__NetPrice__c,APTS_Contract_Term__c,APTS_Years_2_Plus_Adjustment__c,Apttus_Config2__BillingFrequency__c,APTS_Product_Code__c,APTS_Totaling_Summary_Group__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,Apttus_Config2__IsCustomPricing__c,Apttus_Config2__LineNumber__c,Apttus_Config2__LineSequence__c,APTS_Group__c,APTS_Group_Primary_Material_Name__c,APTS_SAP_MLA_Agreement_Number__c FROM Apttus_Config2__LineItem__c   // DOC 15998 Added By poonam Garg APTS_SAP_MLA_Agreement_Number__c
                                            WHERE Apttus_Config2__ConfigurationId__c =: configId ORDER BY APTS_Group_Primary_Material_Name__c,Apttus_Config2__LineNumber__c  ASC];
        for(Apttus_Config2__LineItem__c li: lilist){
            if((li.Apttus_Config2__LineStatus__c == 'New' || li.Apttus_Config2__LineStatus__c=='Amended') && prdcode != null && prdcode.contains(li.APTS_Product_Code__c)){
                //system.debug();
                linseq.put(li.APTS_Totaling_Summary_Group__c,li.Apttus_Config2__LineSequence__c);
                if(fieldmap != null && fieldmap.get(li.APTS_Totaling_Summary_Group__c) != null){
                    li.APTS_Bridge__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Bridge__c;
                    li.APTS_New_Bridge_Discount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_New_Bridge_Discount__c;
                    li.APTS_Contract_Term__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Contract_Term__c;
                    li.APTS_Years_2_Plus_Adjustment__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Years_2_Plus_Adjustment__c;
                    li.Apttus_Config2__BillingFrequency__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__BillingFrequency__c;
                    li.Apttus_Config2__AdjustmentType__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentType__c;
                    li.Apttus_Config2__AdjustmentAmount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentAmount__c;
                    li.Apttus_Config2__ConfigStatus__c= 'Pending'; 
                    li.Apttus_Config2__PricingStatus__c= 'Pending'; 
                    lineitemlist.add(li);
                }
            }
            
        }
        if(!lineitemlist.isEmpty() && !Test.isRunningTest()){
            update lineitemlist;
        }
        lineitemlist.clear();
        Decimal count2 = 0;
        Map<String, Decimal> tempMap = new Map<String, Decimal>(); //added to fix upgrade issue
        for(Apttus_Config2__LineItem__c li : lilist){
            if((li.Apttus_Config2__LineStatus__c == 'New' || li.Apttus_Config2__LineStatus__c=='Amended') && prdcode != null && !prdcode.contains(li.APTS_Product_Code__c) && linseq.get(li.APTS_Totaling_Summary_Group__c)!=null && li.APTS_Bundle__c.contains('Bundle')){
                system.debug('LS -->'+linseq.get(li.APTS_Totaling_Summary_Group__c));
                li.Apttus_Config2__LineSequence__c = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                li.Apttus_Config2__LineNumber__c = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;    
                linseq.put(li.APTS_Totaling_Summary_Group__c,li.Apttus_Config2__LineSequence__c);
                li.APTS_MLA__c=isMLA;
                li.APTS_Decentralized__c=decentralized;
                lineitemlist.add(li);
                count2 = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                tempMap.put(li.Apttus_Config2__ProductId__c, li.Apttus_Config2__LineNumber__c); //added to fix upgrade issue
                System.debug('li.Apttus_Config2__ProductId__c=======' + li.Apttus_Config2__ProductId__c);
                System.debug('li.Apttus_Config2__LineNumber__c=======' + li.Apttus_Config2__LineNumber__c);
                System.debug('li.Id======' + li.Id);
            }
            
            System.debug('tempMap--->' + tempMap);
            //tempMap.put(li.Apttus_Config2__ProductId__c,);
        }
        for(Apttus_Config2__LineItem__c li : lilist){
            if((li.Apttus_Config2__LineStatus__c == 'New' || li.Apttus_Config2__LineStatus__c=='Amended') && li.APTS_Bundle__c == null && count2 > 0){
                system.debug('LS -->'+count2);
                li.Apttus_Config2__LineSequence__c = count2;
                if(tempMap.get(li.Apttus_Config2__ProductId__c)!=null){ //added to fix upgrade issue
                    li.Apttus_Config2__LineNumber__c = tempMap.get(li.Apttus_Config2__ProductId__c);
                }
                else{
                    li.Apttus_Config2__LineNumber__c = count2;    //Apttus Upgrade
                    count2 = count2 + 1;
                }
                lineitemlist.add(li);
            }
        }
        Map<String, Decimal> tempMapCancel = new Map<String, Decimal>(); //added to fix upgrade issue
        for(Apttus_Config2__LineItem__c li : lilist){
            if(li.Apttus_Config2__LineStatus__c != 'New' && li.Apttus_Config2__LineStatus__c!='Amended' && count2 > 0 && li.APTS_SAP_MLA_Agreement_Number__c!=null){// DOC 15998 Added By poonam Garg APTS_SAP_MLA_Agreement_Number__c){
            system.debug('LS -->'+count2);
                li.Apttus_Config2__LineSequence__c = count2;
                if(tempMapCancel.get(li.Apttus_Config2__ProductId__c)!=null){//added to fix upgrade issue
                    li.Apttus_Config2__LineNumber__c = tempMapCancel.get(li.Apttus_Config2__ProductId__c);
                }
                else{
                    li.Apttus_Config2__LineNumber__c = count2;    
                    count2 = count2 + 1;
                }
                lineitemlist.add(li);
                tempMapCancel.put(li.Apttus_Config2__ProductId__c, li.Apttus_Config2__LineNumber__c);//added to fix upgrade issue
            }
             else if(li.Apttus_Config2__LineStatus__c != 'New' && li.Apttus_Config2__LineStatus__c!='Amended' && count2 > 0 &&li.APTS_SAP_MLA_Agreement_Number__c==null){ // DOC 15998 Added By poonam Garg APTS_SAP_MLA_Agreement_Number__c
                li.Apttus_Config2__LineSequence__c = count2;
                li.Apttus_Config2__LineNumber__c = count2; 
                count2 = count2 + 1;
                lineitemlist.add(li);
            }
        }
        System.debug('tempMapCancel--->' + tempMapCancel);
        if(!lineitemlist.isEmpty() && !Test.isRunningTest()){
            update lineitemlist;
        }
        //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Ends Here
        // Delete OLD groups
        list<APTS_Group__c> fullGrpList = getGrouplnItems();   
        list<APTS_Group__c> grpListToDelete = new list<APTS_Group__c>();

         if(!fullGrpList.isEmpty()){  
             for(APTS_Group__c groupData : fullGrpList){
                if(!groupIds.contains(groupData.Id)){
                    grpListToDelete.add(groupData);
                }
             }
         }
         // Delete the previous group list 
        if(Schema.sObjectType.APTS_Group__c.isDeletable()){
         delete grpListToDelete;
        }
        // Delete MLA's
        // on case if MLA is unchecked we are removing data from objects: APTS_Quote_Agreement_Locations__c and APTS_Additional_Subscription_Actions__c
        if(!isMLA && actionType == 'backToCart'){
           List<APTS_Quote_Agreement_Locations__c> existingAgreementLocations = getExistingAgreementLocations();
           List<APTS_Additional_Subscription_Actions__c> existingSubscriptionActions = getExistingSubscriptionActions();

            if((existingAgreementLocations != null && !existingAgreementLocations.isEmpty())&& Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isDeletable()){
                delete existingAgreementLocations;}

            if((existingSubscriptionActions != null && !existingSubscriptionActions.isEmpty())&& Schema.sObjectType.APTS_Additional_Subscription_Actions__c.isDeletable()){
                delete existingSubscriptionActions;}
                System.debug(LoggingLevel.WARN,'existOnlineSoftwareProduct--'+existOnlineSoftwareProduct);
            if(existOnlineSoftwareProduct){
                String status = isKeepTerms ? 'Existing' : 'New';
                APTS_Quote_Agreement_Locations__c bundleLocation = new APTS_Quote_Agreement_Locations__c();
                bundleLocation.APTS_Subscriber_Location_SSD__c = Proposal.APTS_SSD_Sold_To__c;
                bundleLocation.APTS_Quote_Proposal__c = Config.Apttus_QPConfig__Proposald__c;
                System.debug(LoggingLevel.WARN,'qUOTE id ---'+bundleLocation.APTS_Quote_Proposal__c);
                bundleLocation.APTS_Status__c = status;

                if(isKeepTerms){
                    bundleLocation.APTS_Agreement_Number__c = mlaAgreementNumber;
                    System.debug(LoggingLevel.WARN,'bundleLocation----'+bundleLocation);
                }
                if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isCreateable()){    
                    insert bundleLocation;
                }
            }
        } else if(isMLA && actionType == 'backToCart' && isKeepTerms && mlaAgreementNumber != null){
            List<APTS_Quote_Agreement_Locations__c> existingAgreementLocations = getExistingAgreementLocations();
            if(existingAgreementLocations != null && !existingAgreementLocations.isEmpty()){
                for(APTS_Quote_Agreement_Locations__c alocation:existingAgreementLocations){
                    ALocation.APTS_Agreement_Number__c = mlaAgreementNumber;
                }
                if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isUpdateable()){
                    update existingAgreementLocations;
                }
            }
        }
        //added by gayatri for soc9359 
        checknondiscoutproducts();
        return true;
    }
    
    private List<APTS_Quote_Agreement_Locations__c> getExistingAgreementLocations(){
        List<APTS_Quote_Agreement_Locations__c> agmtlcnlst ;
        //SOC-9796 PMD fixes
        if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isQueryable()){
            agmtlcnlst = [Select Id, APTS_Subscriber_Location_SSD__c, APTS_Status__c FROM APTS_Quote_Agreement_Locations__c WHERE APTS_Quote_Proposal__c = :Config.Apttus_QPConfig__Proposald__c];
        }
        return agmtlcnlst;
    }

    private List<APTS_Additional_Subscription_Actions__c> getExistingSubscriptionActions(){
      List<APTS_Additional_Subscription_Actions__c> addsublst ;
      //SOC-9796 PMD fixes
       if(Schema.sObjectType.APTS_Additional_Subscription_Actions__c.isQueryable()){
            addsublst = [Select Id, APTS_Subscription_Number__c, APTS_Product__c FROM APTS_Additional_Subscription_Actions__c WHERE APTS_Quote_Proposal__c = :Config.Apttus_QPConfig__Proposald__c]; 
       }
       return addsublst;
    }

    // Getting Account location for Print Ship-To 
    //Replaced Account object with Source_System_Detail__c object for GLI Implementation by Tejaswi
    private List<Source_System_Detail__c> getAccounts(){
         List<Source_System_Detail__c> ssdlst ;
        if(Schema.sObjectType.Source_System_Detail__c.isQueryable()){
        //SOC-9796 PMD fixes
                ssdlst = [select Id, Name,Source_System_Account_Number__c, Account_Name__r.Account_Name_2__c,City__c,Number_Street__c,State__c, Postal_Code__c FROM Source_System_Detail__c 
            WHERE Id in (select Related_Account_GLI__c from Business_Partner_Function__c WHERE Sold_To_Account_GLI__c = :Proposal.APTS_SSD_Sold_To__c AND Relationship_Type__c = 'Ship-to party')];
        }
        return ssdlst;
    }
    /**
     * @description 
     */
    public class JSONReadClass{
        /**
         * @description
         */
        public list<TabWrapper> tabsList{get; set;}
        public JSONReadClass(list<TabWrapper> tabsList){
            this.tabsList = tabsList;
        }
    }
    
    /**
     * @description
     */
    public class GroupLNWrapper{
        /**
         * @description
         */
        public APTS_Group__c grpLn {get; set;}
        /**
         * @description
         */
        public boolean showMessage{get;set;}
        /**
         * @description
         */
        public list<Apttus_Config2__LineItem__c> lnItems{get; set;}
        /**
         * @description
         */
        public Set<String> optionList{get; set;}
        /**
         * @description
         */
        public boolean keepTerms{get; set;}
        /**
         * @description
         */
        public boolean allowKeepTerms{get; set;}
        /**
         * @description
         */
        public boolean blendDiscountRed {get; set;}
        /**
         * @description
         * @param grpLn
         * @param lnItems
         * @param optionList
         */
        public GroupLNWrapper(APTS_Group__c grpLn, list<Apttus_Config2__LineItem__c> lnItems, Set<String> optionList){
            this.grpLn = grpLn;
            this.showMessage=false;
            this.lnItems = lnItems; 
            this.optionList = optionList;
            this.keepTerms = false;
            this.allowKeepTerms = false;
            this.blendDiscountRed = false;
        }
    }

    /**
     * @description
     */
    public class TabWrapper{
        /**
         * @description
         */
        public List<GroupLNWrapper> dataList{get;set;}
        /**
         * @description
         */
        public String name{get; set;}
        /**
         * @description
         */
        public List<GroupLNWrapper> notShownDataList{get; set;}
        /**
         * @description
         * @param dataList
         * @param name
         * @param notShownDataList
         */
        public TabWrapper(List<GroupLNWrapper> dataList, String name, List<GroupLNWrapper> notShownDataList){
            this.name = name;
            this.notShownDataList = notShownDataList;
            this.dataList=dataList;

        }
    }
    /**
     * @description added for Cancel button functionality of Manage Dynamic bundle
     * @return ''
     */
    public PageReference openCartPage() {
        PageReference pr = new PageReference(retURLStr);
    pr.setRedirect(true);
    return pr;
    }
}