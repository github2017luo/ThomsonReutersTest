/********************************************************************************
Class Name : DCPDBInitializeData
@description : This class used in dynamic bundling for creating groups.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
12/07/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDBInitializeData{

    private static set<String> setOfTabNames = new Set<String>{'Print','Online/Software'};
    //private static APTS_ConfigBundlePageSettings__c bundleCustomSettingData;
    private static String bundleName  = 'Bundle A';
    private static list<string> groupNameList;
    //private static Apttus_Config2__ProductConfiguration__c objectCart;
       
    private static void getGroupLineitems(){
       
       //objectCart = cart;
       
       DCPDynamicBundling.bundleWrapper.grpList = getGrouplnItems(DCPDynamicBundling.objectCart.Apttus_QPConfig__Proposald__c);
        
       if(!DCPDynamicBundling.bundleWrapper.grpList.isEmpty()){  
           for(APTS_Group__c previousGroup : DCPDynamicBundling.bundleWrapper.grpList){
               if(previousGroup.APTS_MLA__c){
                   DCPDynamicBundling.bundleWrapper.isMLA = previousGroup.APTS_MLA__c;
               }
               if(previousGroup.APTS_Decentralized__c){
                   DCPDynamicBundling.bundleWrapper.decentralized = previousGroup.APTS_Decentralized__c;
               }
           }
       }
   }
   
    /** 
    @description call the execute bundling method
    @param proposalId to fectch group associated with it
    @return Returns list<APTS_Group__c> 
    */
   public static list<APTS_Group__c> getGrouplnItems(id proposalId){
       list<APTS_Group__c> listOfGroups = new list<APTS_Group__c>();
       if(Schema.sObjectType.APTS_Group__c.isAccessible()){
           listOfGroups =  [SELECT Id, Name, APTS_Adjustment_Value__c, APTS_Adjustment_Type__c,APTS_Primary_Material__c, 
                           APTS_Agreement__c, APTS_Discount__c, APTS_GrossAmount__c, APTS_Group_Name__c, APTS_Group_Name_Original__c, 
                           APTS_NetAmount__c, APTS_ProductConfiguration__c, APTS_Quote_Proposal__c, APTS_Online_Incremental__c, 
                           APTS_Existing_Agreement_Total__c, APTS_MLA__c, APTS_Decentralized__c 
                           FROM APTS_Group__c WHERE APTS_Quote_Proposal__c =:proposalId];
       }
       return listOfGroups;
   }
   
   /** 
    @description call the execute bundling method
    @param tabName will be the name of the tab
    @param li will be the lineitem
    @return Returns boolean 
   */
   public static boolean isValidPrint(String tabName, Apttus_Config2__LineItem__c li){
        if (tabName == 'Print' && li.APTS_SAP_Deal_Number__c!=null && li.APTS_SAP_Deal_Type__c!=null) {
            return true;
        }
        else{
            return false;
        }
    }
    
    /** 
    @description call the execute bundling method
    @param tabName will be the name of the tab
    @param li will be the lineitem
    @return Returns boolean 
   */
    public  static boolean isValidOnlineSoftware(String tabName, Apttus_Config2__LineItem__c li){
        if (tabName == 'Online/Software' && li.APTS_SAP_MLA_Agreement_Number__c!=null){
            return true;
        }
        else{
            return false;
        }
    }
 
   /** 
    @description call inititialize method
    @return BundleWrapper 
    */

   public static BundleWrapper initializeData(){
       
       getGroupLineitems();
       
       
       Map<Id, List<Apttus_Config2__LineItem__c>> cartIdLineItemMap= new Map<Id, List<Apttus_Config2__LineItem__c>>();
       cartIdLineItemMap = getMapOfCartIdLinitems(DCPDynamicBundling.objectCart.id ,new Set<String>(DCPDynamicBundling.configBundleCS.Ineligible_Existing_Deals__c.split(',')));
       
       DCPDynamicBundling.bundlewrapper.lnItemList.addAll(cartIdLineItemMap.get(DCPDynamicBundling.objectCart.id));
       DCPDynamicBundling.bundlewrapper.lnItems = cartIdLineItemMap.get(DCPDynamicBundling.objectCart.id);
       
       
       Map<String, List<Apttus_Config2__LineItem__c>> tabNameTolineItem = mapTabNameToLineItems(DCPDynamicBundling.bundlewrapper.lnItems);
       
       for(String tabName : setOfTabNames){
            DCPDBCreateGroup.createGroupHelper(tabName,tabNameTolineItem);
       }
       
       
       System.debug(LoggingLevel.DEBUG,'DCPDynamicBundling.bundlewrapper.groupListTobeInsert -----------------'+ DCPDynamicBundling.bundlewrapper.groupListTobeInsert);
       //End Group type specific
       if(!DCPDynamicBundling.bundlewrapper.groupListTobeInsert.isEmpty() && Schema.sObjectType.APTS_Group__c.isCreateable()){
           insert DCPDynamicBundling.bundlewrapper.groupListTobeInsert;
       }
       
       return DCPDynamicBundling.bundleWrapper;
   }
   
       
   private static Map<Id,List<Apttus_Config2__LineItem__c>> getMapOfCartIdLinitems(Id cartId,Set<String> ineligibleExistingDealsList){
   
       Map<Id,List<Apttus_Config2__LineItem__c>> mapOfCartIdLinitems =new Map<Id, List<Apttus_Config2__LineItem__c>>();
      
       List<Apttus_Config2__LineItem__c> listLineItems = new List<Apttus_Config2__LineItem__c>();
       
       if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){
        listLineItems = [SELECT Id, Name, APTS_Deal_Number__c, APTS_DefaultNetPrice__c, Apttus_Config2__BaseExtendedPrice__c,
                      APTS_Product_Name__c, Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c, 
                      APTS_Product_Or_Option_Name__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ChargeType__c, Apttus_Config2__ExtendedCost__c,Apttus_Config2__Quantity__c, 
                      Apttus_Config2__ExtendedPrice__c, APTS_Group__c, Apttus_Config2__LineType__c, Apttus_Config2__ListPrice__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PricingStatus__c, 
                      Apttus_Config2__ProductId__c, Apttus_Config2__ProductOptionId__c, Apttus_Config2__PriceAdjustment__c,Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c,Apttus_Config2__SellingTerm__c, 
                      Apttus_Config2__NetPrice__c, Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c, Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c,  
                      Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c, Apttus_Config2__ProductId__r.Service_Number__c,Apttus_Config2__OptionId__r.APTS_Media_High_Level_Code__c, Apttus_Config2__OptionId__r.APTS_Media_Lower_Level_Code__c, 
                      Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, 
                      APTS_Years_2_Plus_Adjustment__c, APTS_YoY_Adjustment_Type__c, APTS_Year_2_Adj_Default__c, APTS_Years_3_5_Adj_Default__c, APTS_Years_6_10_Adj_Default__c, APTS_SAP_Deal_Number__c, 
                      APTS_SAP_Deal_Type__c, APTS_SAP_Deal_Primary_Material__c, Apttus_Config2__AssetLineItemId__c,APTS_Bundle__c, APTS_Product_Group_Primary_Material__c, APTS_Group_Primary_Material__c, 
                      APTS_Contract_Term_Default__c, APTS_Group_Primary_Material_Name__c, APTS_Keep_Terms__c, APTS_Max_Discount__c, APTS_WestPack_Discount__c, APTS_SAP_MLA_Agreement_Number__c, 
                      APTS_Years_2_Plus_Default__c, APTS_Yr_1_Renewal_Default__c, Apttus_Config2__ShipToAccountId__c, APTS_Proposal_Group__r.APTS_Group_Name__c, 
                      APTS_Proposal_Group__c, APTS_Deal_Type__c, Apttus_Config2__ConfigurationId__c,APTS_Product_Code__c,Apttus_Config2__HasOptions__c,Apttus_Config2__OptionId__c
                      FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c =: cartId
                      AND Apttus_Config2__LineStatus__c!= 'Cancelled' 
                      AND Apttus_Config2__LineType__c ='Product/Service'
                      AND APTS_SAP_Deal_Type__c not in :ineligibleExistingDealsList order by Name,Apttus_Config2__LineNumber__c];
       }
      if(listLineItems.size()>0){
          mapOfCartIdLinitems.put(cartId , listLineItems);
      }
      
      System.debug(LoggingLevel.DEBUG,'mapOfCartIdLinitems---'+mapOfCartIdLinitems);
       
      return mapOfCartIdLinitems;
   }
   
   /**
   @description to get the map of tabname to list of line items
   @param lineItems will contains all lineitems associted with cart as a parameter.
   @return Returns map mapTabNameToLineItems
   */  
   private static Map<String, List<Apttus_Config2__LineItem__c>> mapTabNameToLineItems(List<Apttus_Config2__LineItem__c> lineItems){
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
       System.debug(LoggingLevel.DEBUG,'retMap -----------------'+ retMap);
       return retMap;
   }
   
   private static Map<String, List<Apttus_Config2__LineItem__c>> mapTabNameToLineItemsHelper(Apttus_Config2__LineItem__c li,Map<String, List<Apttus_Config2__LineItem__c>> retMap){
       
       Map<String, List<Apttus_Config2__LineItem__c>> tempMap = retMap;
       Set<String> onlineCodes = new Set<String>(DCPDynamicBundling.configBundleCS.Eligibility_codes_for_online_software__c.split(','));
       Set<String> printCodes = new Set<String>(DCPDynamicBundling.configBundleCS.Eligibility_codes_for_print__c.split(','));
       
       if(li.Apttus_Config2__AttributeValueId__c!=null 
           && ((li.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c != null && li.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c.contains('APP')&& printCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c))
           || (li.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c != null && li.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c.contains('APP')&& printCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c)))){
               tempMap.get('Print').add(li);
        }
       else if(onlineCodes.contains(li.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c+li.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c)){
           tempMap.get('Online/Software').add(li);
        }  
       return tempMap;
   }

    /** 
    @description get the picklist values
    @param groupName name of the group
    @return list of picklistvalues/group 
    */

   public static List<string> getGroupPicklistValues(String groupName){
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
  
/**
Class Name : BundleWrapper
@description : This is the wrapper class to hold group and associted line items details
*/
   public class BundleWrapper{
       public boolean isMLA = false;
       public boolean decentralized = false;
       public boolean isKeepTerms = false;
       public String mlaAgreementNumber;
       public Boolean existOnlineSoftwareProduct =false;
       public String materialNumber;
       public Map<Id, String> matrialMap = new Map<Id, String>();
       public List<Apttus_Config2__LineItem__c> lnItems = new List<Apttus_Config2__LineItem__c>();
       public List<Apttus_Config2__LineItem__c> lnItemList = new List<Apttus_Config2__LineItem__c>();
       public List<APTS_Group__c> groupListTobeInsert =  new list<APTS_Group__c>();
       public List<APTS_Group__c> grpList = new list<APTS_Group__c>();
       public Map<Id, APTS_Group__c> grpMap = new Map<Id, APTS_Group__c>();
   }  
}