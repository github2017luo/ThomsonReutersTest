/**
 * @description FL_ApprovalDashboardAJSController
 */
global with sharing class FL_ApprovalDashboardAJSController {

    public List<Apttus_Config2__AssetLineItem__c> lapsedProducts;
    private  Apttus_Config2__ProductConfiguration__c productConfiguration;
    public List<SObject> proposedDiscountList = new List<SObject>();
    public List<SObject> proposedOverAllDiscountList = new List<SObject>();
    List<Apttus_Config2__LineItem__c>  cartLinesProposednet = new List<Apttus_Config2__LineItem__c>();
    List<Apttus_Config2__LineItem__c>  cartLinesProposeddis = new List<Apttus_Config2__LineItem__c>();
    List<Apttus_Config2__LineItem__c>  cartLinesProposedtcv = new List<Apttus_Config2__LineItem__c>();
    List<String>  cartLines1 = new List<String>();   
    public List<Apttus_Config2__AssetLineItem__c> allAssetList = new List<Apttus_Config2__AssetLineItem__c>();
    private decimal currentOnlineSpendPrice=0;//added by ssuri@apttus.com on 28-july-2017
    private Decimal currentNetPrice = 0;
    private Decimal currentBand = 0;//added by ssuri@apttus.com on 26-july-2017
    private Decimal attorneyBand = 0;//added by ssuri@apttus.com on 26-july-2017
    private Decimal tCVChange = 0;//added by ssuri@apttus.com on 26-july-2017
    private Decimal currentNetPriceTCV = 0;
    private Decimal proposedNetPrice = 0;
    private Decimal currentDiscount = 0;
    private Decimal currentOverallDiscount = 0;
    private Decimal currentTotalDiscount = 0;
    private Decimal proposedDiscount = 0;
    private Decimal proposedOverallDiscount = 0;
    private Decimal overallDiscountChange = 0;
    private Decimal proposedTotalDiscount = 0;
    // ACV = Annual Contract Value
    private Decimal currentACV = 0;  
    private decimal percentage = 0; 
    private Decimal proposedACV = 0;
    private Decimal currentTotalAttorneys = 0;
    private Decimal proposedTotalAttorneys = 0;
    // TCV = (Total Contract Value)
    private Decimal currentTCV = 0;
    private Decimal proposedTCV = 0;  
    private set<Id> liPrdId= new Set<Id>();
    //For Discounts added as Change 7
    private Decimal totalAssetNetPrice = 0;
    private Decimal totalAssetListPrice = 0;
    /**
     * @description
     */
    public String quoteID {get; set;}
    /**
     * @description
     */
    public String quoteName {get; set;}
    /**
     * @description
     */
    public String ssdID {get; set;} 
    /**
     * @description
     */
    public String productConfigurationID {get; set;}
    
    /**
    * @description
    */
    public List<Apttus_Config2__LineItem__c> lineItem {get; set;}
    /**
     * @description
     */
    public Source_System_Detail__c ssd {get; set;}
    
    private Apttus_Proposal__Proposal__c quoteProposal {get; set;}
    /**
     * @description
     */
    public List<Apttus_Config2__LineItem__c> lineItems {get; set;}
    /**
     * @description
     */ 
    public List<Apttus_Config2__AssetLineItem__c> assetLineItem {get; set;}
    
    
    /**
     * @description
     */  
    public List<Apttus_Config2__AssetLineItem__c> currentTCVList {get; set;}
    /**
     * @description
     */
    public List<Apttus_Config2__AssetLineItem__c> printProviewList {get; set;}
    /**
     * @description
     */      
    public List<Apttus_Config2__AssetLineItem__c> currentOnlineSoftwareList {get; set;} 
    /**
     * @description
     */
    public List<Apttus_Config2__LineItem__c> proposedOnlineSoftwareList {get; set;}  
    
    
    /**
     * @description
     */
    public Boolean additionalApprovalLegal {get;set;}
    /**
     * @description
     */
    public Boolean additionalApprovalother {get;set;}
    
    
       
    /**
     * @description FL_ApprovalDashboardAJSController
     */
    public FL_ApprovalDashboardAJSController() {
    
        //List<Apttus_Config2__AssetLineItem__c> assetLineItemList;  
        String returnId = string.escapeSingleQuotes('retId');
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get(returnId))) {
            quoteID = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(returnId)));      
        }
        getPrintProviewLineItems(quoteID);  
        System.Debug(LoggingLevel.WARN, ' --------------- > '+quoteID);
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        quoteProposal = [SELECT Id, Name, Owner.Name, qp.APTS_SSD_Sold_To__c from Apttus_Proposal__Proposal__c qp 
            where qp.Id =: ApexPages.currentPage().getParameters().get('retId')];
        quoteName = quoteProposal.Name;
        if(!Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        ssd = [SELECT ID, act.Name, act.Source_System_Account_Number__c, act.LCRM_Market_Segment__c, act.LCRM_APTS_Band_Number__c,
                      act.APTS_Customer_Category__c FROM Source_System_Detail__c act WHERE act.Id =:  quoteProposal.APTS_SSD_Sold_To__c];
        ssdID = ssd.Id;
        
        try {
            if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            productConfiguration = [select Name, Id, APTS_New_Holdings__c, APTS_Lapsed_Holdings__c, APTS_Current_Holdings__c, Apttus_QPConfig__Proposald__r.Name,  APTS_Additional_Approval_Legal__c, 
                                        APTS_Additional_Approval_Other__c,APTS_Incremental_Growth__c  from Apttus_Config2__ProductConfiguration__c 
                                        where Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:quoteProposal.Id ORDER BY CreatedDate DESC LIMIT 1];
            productConfigurationID = productConfiguration.Id;                            
            additionalApprovalLegal = productConfiguration.APTS_Additional_Approval_Legal__c;
            additionalApprovalother = productConfiguration.APTS_Additional_Approval_Other__c;
        }catch(Exception e) {
            additionalApprovalLegal = false;
            additionalApprovalother = false;                    
        }        
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        assetLineItem = [SELECT Name, Apttus_Config2__ListPrice__c,Apttus_Config2__StartDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.List_Price__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,Apttus_Config2__BasePrice__c,
                            APTS_Contract_Term__c, APTS_Year_2_Adjustment__c, Apttus_Config2__AssetStatus__c, APTS_Discount_Percent_Retail__c,Apttus_Config2__Quantity__c,APTS_Info_PlanType__c,Apttus_Config2__PriceUom__c FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id AND APTS_Proposal_Business_Unit__c = 'FindLaw' AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed') AND Apttus_Config2__IsInactive__c = false ];
                    
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        lapsedProducts = [SELECT Name, Apttus_Config2__NetPrice__c FROM Apttus_Config2__AssetLineItem__c WHERE APTS_SSD_Sold_To__c =: ssd.Id AND Apttus_Config2__AssetStatus__c='Cancelled' AND APTS_Proposal_Business_Unit__c = 'FindLaw'];             
                            
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        currentTCVList = [SELECT Name, APTS_SSD_Sold_To__c,Apttus_Config2__ListPrice__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Term_Remaining__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,
                            APTS_Contract_Term__c, APTS_Year_2_Adjustment__c,APTS_Info_PlanType__c, Apttus_Config2__AssetStatus__c, APTS_Discount_Percent_Retail__c FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id
                            AND (APTS_Contract_Term__c != NULL AND APTS_Proposal_Business_Unit__c = 'FindLaw'
                            AND APTS_Contract_Term__c != '') AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed') AND Apttus_Config2__IsInactive__c = false];  
        
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        printProviewList = [SELECT Name, Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ListPrice__c,Apttus_Config2__StartDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name,APTS_Contract_Term__c, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c,Apttus_Config2__ProductId__r.List_Price__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id 
                            AND (Apttus_Config2__ProductId__r.Family = 'FINDLAW' 
                            OR Apttus_Config2__ProductId__r.APTS_Cat_L2__c=: Label.APTS_Proview_Product_Family) AND Apttus_Config2__AssetStatus__c!='Cancelled'];
        
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        currentOnlineSoftwareList = [SELECT Name, Apttus_Config2__ListPrice__c,APTS_Combination_Key__c,Apttus_Config2__Quantity__c,Apttus_Config2__ExtendedPrice__c, Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__StartDate__c, APTS_Info_RenewalDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,APTS_Contract_Term__c,  APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c,Apttus_Config2__LineType__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__EndDate__c, Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c,APTS_Year_2_Adjustment__c,APTS_Proposal_Business_Unit__c, APTS_Discount_Percent_Retail__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id                             
                            AND APTS_Proposal_Business_Unit__c = 'FindLaw' AND Apttus_Config2__ChargeType__c != 'Standard Price' AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed') AND Apttus_Config2__IsInactive__c = false AND Apttus_Config2__LineType__c = 'Product/Service']; 
                            
                            
                            
                             
        System.Debug(LoggingLevel.WARN,' ------------- '+currentOnlineSoftwareList.size());                                                      
                      
        
                                  
        if(productConfiguration != null) {
            if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
        lineItem = [Select Apttus_Config2__ListPrice__c, Apttus_Config2__LineStatus__c,APTS_FL_Qty__c,APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c,APTS_Number_of_Attorneys_on_Acct__c, APTS_Years_2_Plus_Adjustment__c, 
                                        APTS_Number_of_Attorneys__c, Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c, APTS_Discount_Percent_Retail__c, 
                                        Apttus_Config2__NetPrice__c, APTS_Bridge__c, APTS_Service_Number__c, APTS_Product_Name__c,Apttus_Config2__PriceUom__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c,Apttus_Config2__Quantity__c from  Apttus_Config2__LineItem__c li 
                                        where li.Apttus_Config2__ConfigurationId__c =: productConfiguration.Id
                                        AND li.Apttus_Config2__ChargeType__c != 'Standard Price'
                                        AND APTS_Proposal_Business_Unit__c = 'FindLaw' AND Apttus_Config2__LineStatus__c!='Amended' AND Apttus_Config2__LineType__c = 'Product/Service']; //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
         //Added by Priyanka - SOC-7776
         for(Apttus_Config2__LineItem__c li:lineItem){
          if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){
          li.APTS_Years_2_Plus_Adjustment__c = null;
          li.APTS_Contract_Term__c = null;
          }
         }
            if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            proposedOnlineSoftwareList = [Select Apttus_Config2__ListPrice__c,APTS_Combination_Key__c,APTS_FL_Current_price__c,APTS_Product_Code__c,Apttus_Config2__ExtendedPrice__c,Apttus_Config2__LineType__c ,APTS_Year_2_Adjustment__c,APTS_Asset_Contract_Term__c,APTS_Asset_Net_Price__c, Apttus_Config2__LineStatus__c,APTS_Info_RenewalDate__c,APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, APTS_Years_2_Plus_Adjustment__c, 
                                        APTS_Number_of_Attorneys__c, Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c, APTS_Discount_Percent_Retail__c, Apttus_Config2__AssetLineItemId__c,
                                        Apttus_Config2__NetPrice__c,APTS_Contract_Term_Number__c,APTS_Bridge__c, APTS_Service_Number__c, APTS_Product_Name__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c 
                                        , Apttus_Config2__Quantity__c 
                                        from  Apttus_Config2__LineItem__c li 
                                        where li.Apttus_Config2__ConfigurationId__c =: productConfiguration.Id AND li.APTS_Proposal_Business_Unit__c = 'FindLaw' AND Apttus_Config2__ChargeType__c != 'Standard Price' AND Apttus_Config2__LineStatus__c!='Amended' AND Apttus_Config2__LineType__c = 'Product/Service'];                        
                                        
                                        
                                        
        }
        
        if(currentOnlineSoftwareList != null) {
            proposedDiscountList.addAll((List<sObject>)(currentOnlineSoftwareList));
        }
        if(proposedOnlineSoftwareList != null) {
            proposedDiscountList.addAll((List<sObject>)(proposedOnlineSoftwareList));
        }
        if(assetLineItem!= null) {
            allAssetList.addAll((List<Apttus_Config2__AssetLineItem__c>)(assetLineItem));
        }                            
    }    
      /**
     * @description
     * @return ssd
     * @param ssdID
     */
    @RemoteAction
    public static Source_System_Detail__c getAccountDetail(String ssdID){
        Source_System_Detail__c ssd;
        if(!Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        ssd = [SELECT ID, act.Name, act.LCRM_FL_Account_Type__c,act.LCRM_FL_Annual_Spend__c, act.Source_System_Account_Number__c, act.LCRM_Market_Segment__c, act.LCRM_APTS_Band_Number__c,
                      act.APTS_Customer_Category__c FROM Source_System_Detail__c act WHERE act.Id =:  ssdID];              
        return ssd;             
    }
     /**
     * @description
     * @return assetLineItem
     * @param ssdID
     * @param productConfigurationID
     */
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getAssetLineItem(String ssdID,string productConfigurationID) {
        System.debug(LoggingLevel.WARN,'productConfigurationID>>>>'+productConfigurationID);

        
        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
        //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        assetLineItem = [SELECT Name,Id, APTS_SSD_Sold_To__c,APTS_Contract_Term__c,Apttus_QPConfig__ProposalLineItemId__r.Apttus_QPConfig__AdjustmentAmount__c,Apttus_Config2__StartDate__c,  APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c,  //added soc-7832
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c,APTS_Info_RenewalDate__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_SSD_Sold_To__c =: ssdID  AND Apttus_Config2__LineType__c = 'Product/Service' AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false]; 
        return assetLineItem;
     }
     /**
     * @description
     * @return assetLineItem
     * @param ssdID
     * @param productConfigurationID
     */
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getCurrentOnlineSoftwareList(String ssdID,string productConfigurationID) {
        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        assetLineItem = [SELECT Name,Id, Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__StartDate__c,Apttus_QPConfig__ProposalLineItemId__r.Apttus_QPConfig__AdjustmentAmount__c,APTS_Contract_Term__c,  APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,Apttus_Config2__BasePrice__c, Apttus_Config2__ListPrice__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c, 
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,APTS_Info_RenewalDate__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssdID
                            AND Apttus_Config2__LineType__c = 'Product/Service' AND (Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: Label.APTS_Print_Product_Family 
                            AND Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: Label.APTS_Proview_Product_Family
                            AND Apttus_Config2__ProductId__r.Family != 'FINDLAW') AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false];
        return assetLineItem;
    }
    /**
     * @description
     * @return assetLineItem
     * @param ssdID
     * @param productConfigurationID
     */
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getPrintProviewList(String ssdID,string productConfigurationID) {
        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
        
       
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        assetLineItem = [SELECT Name,Id, Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,APTS_Contract_Term__c,Apttus_QPConfig__ProposalLineItemId__r.Apttus_QPConfig__AdjustmentAmount__c,Apttus_Config2__StartDate__c,APTS_Info_RenewalDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,Apttus_Config2__BasePrice__c, Apttus_Config2__ListPrice__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c, //soc-7832
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssdID 
                            AND Apttus_Config2__LineType__c = 'Product/Service' AND (Apttus_Config2__ProductId__r.APTS_Cat_L2__c =: Label.APTS_Print_Product_Family 
                            OR Apttus_Config2__ProductId__r.APTS_Cat_L2__c =: Label.APTS_Proview_Product_Family) AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false];//Added condition Apttus_Config2__AssetStatus__c!='Cancelled' by ssuri@apttus on 27-July-2017 
        return assetLineItem;
     }
     
     /**
     * @description
     * @return assetLineItem
     * @param ssdID
     * @param productConfigurationID
     */
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getFindLawList(String ssdID,string productConfigurationID) {
        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
        
        
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        assetLineItem = [SELECT Name,Id, Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.APTS_Cat_L2__c,APTS_Contract_Term__c ,Apttus_Config2__ExtendedPrice__c,Apttus_QPConfig__ProposalLineItemId__r.Apttus_QPConfig__AdjustmentAmount__c,Apttus_Config2__StartDate__c,APTS_Info_RenewalDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,Apttus_Config2__BasePrice__c, Apttus_Config2__ListPrice__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,
                            Apttus_Config2__AssetStatus__c,Apttus_Config2__ProductId__r.List_Price__c, APTS_Discount_Percent_Retail__c,APTS_Combination_Key__r.Name,APTS_Info_PlanType__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssdID 
                            AND APTS_Proposal_Business_Unit__c = 'FindLaw' AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed') AND Apttus_Config2__LineType__c = 'Product/Service' AND Apttus_Config2__AssetStatus__c!='Cancelled']; //Added condition Apttus_Config2__AssetStatus__c!='Cancelled' by ssuri@apttus on 27-July-2017
        return assetLineItem;
     }
    
     /**
     * @description
     * @return lineItem
     * 
     * @param configurationId
     */
     @RemoteAction
     public static List<Apttus_Config2__LineItem__c> getLineItem(String configurationId) {
        List<Apttus_Config2__LineItem__c> lineItem;
        if(!Schema.sObjectType.Apttus_Config2__LineItem__c .isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        if(configurationId != null) {
             lineItem = [Select APTS_Contract_Term__c,APTS_Print_Purchase_Options__c,Id,Apttus_Config2__ListPrice__c,Apttus_Config2__LineType__c ,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__AdjustmentAmount__c,APTS_Yr_1_Renewal_Adjustment__c ,Apttus_Config2__PriceUom__c, APTS_Years_2_Plus_Adjustment__c, 
                                APTS_Number_of_Attorneys__c, Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c, APTS_Discount_Percent_Retail__c,Apttus_Config2__Quantity__c, 
                                Apttus_Config2__NetPrice__c, APTS_Bridge__c,Apttus_Config2__LineStatus__c, APTS_Product_Code__c,APTS_Product_Detail__c,Apttus_Config2__ExtendedPrice__c, APTS_Product_Name__c,APTS_Bundle__c,Apttus_Config2__IncentiveCode__c from  Apttus_Config2__LineItem__c li 
                                where li.Apttus_Config2__ConfigurationId__c =: configurationId AND Apttus_Config2__LineType__c = 'Product/Service' AND Apttus_Config2__LineStatus__c!='Amended' Order By Apttus_Config2__LineStatus__c]; 
                                                
         }
         
         for(Apttus_Config2__LineItem__c li:lineItem){
          if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){
          li.APTS_Years_2_Plus_Adjustment__c = null;
          li.APTS_Contract_Term__c = null;
          }
         }
         return lineItem;   
     }
     
     /**
     * @description
     * @return documents
     * 
     * @param id
     */
     @RemoteAction
     public static List<Document> getDocumentList(String id) {
        Apttus_Proposal__Proposal__c quoteProposal;
         if(!(Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Note.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible())) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
         }
         quoteProposal = [SELECT Id, Name, (SELECT Id, Name, LastModifiedDate, CreatedBy.name, CreatedDate  FROM Attachments Order By CreatedDate desc), 
                             (SELECT Id, Title, LastModifiedDate, CreatedBy.name, CreatedDate FROM Notes Order By CreatedDate desc),
                             qp.APTS_SSD_Sold_To__c from Apttus_Proposal__Proposal__c qp where qp.Id =: id WITH SECURITY_ENFORCED];
         List<Attachment> attachments = quoteProposal.Attachments;
         List<Note> notes = quoteProposal.Notes;
         List<Document> documents = new List<Document>();
         if(attachments != null && attachments.size() > 0) {
             for(Attachment attachment : attachments) {
                 documents.add(new Document(attachment.Id, attachment.Name, Id, quoteProposal.Name, 'Attachment', 
                     attachment.LastModifiedDate, attachment.CreatedBy.name));
             }
         }
         if(notes != null && notes.size() > 0) {
             for(Note note : notes) {
                 documents.add(new Document(note.Id, note.Title, Id, quoteProposal.Name, 'Note', 
                     note.LastModifiedDate, note.CreatedBy.name));
             }            
         }
         //documents.sort();
         return documents;   
     }
     
     /**
     * @description
     * @return approvalList
     * 
     * @param id
     */
     @RemoteAction
     public static List<Apttus_Approval__Approval_Request__c> getApprovalRequestList(String id) {
        List<Apttus_Approval__Approval_Request__c> approvalList;
        if(!Schema.sObjectType.Apttus_Approval__Approval_Request__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        approvalList = [SELECT Id, Name, Apttus_Approval__Request_Comments__c, Apttus_Approval__Assigned_To_Link__c, 
                     Apttus_Approval__Assigned_To_Name__c, Apttus_Approval__Date__c,Apttus_Approval__Approval_Status__c, Apttus_Approval__Approver_Comments__c, Apttus_Approval__SubmissionComment1__c,Apttus_Approval__Initial_Submitter__r.Name
                     FROM Apttus_Approval__Approval_Request__c ar WHERE ar.Apttus_QPApprov__ProposalId__c =: Id AND Apttus_Approval__Assigned_To_Name__c!=NULL Order By Apttus_Approval__Approval_Status__c ASC Nulls Last]; // SOC 5935 JKK //SOC-7797 //SOC-7796
         return approvalList; 
     } 
     
     /**
     * @description
     * @return approvalHistList
     * 
     * @param id
     */
     @RemoteAction
     public static List<Apttus_Approval__Approval_Request_History__c> getApprovalRequestHistoryList(String id) {
         List<Apttus_Approval__Approval_Request_History__c> approvalHistList;
         if(!Schema.sObjectType.Apttus_Approval__Approval_Request_History__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
         }
        approvalHistList= [SELECT Id, Name, Apttus_Approval__Request_Comments__c, Apttus_Approval__Assigned_To_Link__c,
                     Apttus_Approval__Assigned_To_Name__c, Apttus_Approval__Approval_Status__c, Apttus_Approval__Approver_Comments__c, Apttus_Approval__SubmissionComment1__c,Apttus_Approval__Initial_Submitter__r.Name,Apttus_Approval__Date__c
                     FROM Apttus_Approval__Approval_Request_History__c arh WHERE arh.Apttus_QPApprov__ProposalId__c =: Id AND Apttus_Approval__Assigned_To_Name__c!=NULL Order By Name DESC Nulls Last];  // SOC 5935 JKK //SOC-7796 //SOC-7797
         return approvalHistList;
     }  
     
     /**
     * @description
     * @return approvalHistList
     * 
     * @param id
     */
     @RemoteAction
     public static List<PrintProview> getPrintProviewLineItems(String id) {
         Apttus_Config2__ProductConfiguration__c configuration;
         List<Apttus_Config2__LineItem__c> lineItem;
         List<PrintProview> ppList = new List<PrintProview>();
         try {
            if (!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible() && !Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){
                return null;
            }
             configuration = [select Name, Id, Apttus_QPConfig__Proposald__r.Name, 
                         (select Id, Name, APTS_Product_Family__c,Apttus_Config2__ProductId__r.APTS_Cat_L2__c, APTS_Product_Name__c from Apttus_Config2__LineItems__r li where 
                         (li.APTS_Cat_L2__c =: Label.APTS_Print_Product_Family OR li.APTS_Cat_L2__c =: Label.APTS_Proview_Product_Family)) 
                         from Apttus_Config2__ProductConfiguration__c 
                         where Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:Id];
         } catch(Exception e) {
             return null;
         }            
                 
         if(configuration != null) {
             lineItem = configuration.Apttus_Config2__LineItems__r;
             if(lineItem != null && lineItem.size() > 0) {
                 for(Apttus_Config2__LineItem__c li : lineItem) {
                     ppList.add(new PrintProview(li.Id, li.APTS_Product_Family__c, li.APTS_Product_Name__c));                    
                 }    
             }                      
         }
         return ppList;
     } 
     
     /**
     * @description
     * @return ''
     */
     public String getOwnerName() {
         if(quoteProposal != null) {
             return quoteProposal.Owner.Name;
         } else {
             return '';
         }    
     }
     
     //SOC-5720 AND SOC-6588 Added by CG overriding currentholdings value from product config
     /**
     * @description
     * @return ''
     */ 
     public String getCurrentNetPrice() {
         currentNetPrice = 0;
         if(currentOnlineSoftwareList != null && currentOnlineSoftwareList.size() >0) {             
             for(Apttus_Config2__AssetLineItem__c cosl : currentOnlineSoftwareList) {
                 if(cosl.Apttus_Config2__NetPrice__c != null && cosl.APTS_Proposal_Business_Unit__c == 'FindLaw' && cosl.Apttus_Config2__LineType__c == 'Product/Service' ) {
                     currentNetPrice = currentNetPrice + cosl.Apttus_Config2__NetPrice__c;
                 }                 
             }
         }         

         Decimal num = currentNetPrice.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3 
         return ('USD ' + String.valueOf(num.format()));
     }
     
     /**
     * @description
     * @return ''
     */
     public String getCurrentOnlineSpendPrice() {
         if(currentOnlineSoftwareList != null && currentOnlineSoftwareList.size() >0) {
             currentOnlineSpendPrice = 0;
             for(Apttus_Config2__AssetLineItem__c cosl : currentOnlineSoftwareList) {
                 if(cosl.Apttus_Config2__NetPrice__c != null && cosl.APTS_Proposal_Business_Unit__c == 'FindLaw' && cosl.Apttus_Config2__LineType__c == 'Product/Service' ) {
                     currentOnlineSpendPrice = currentOnlineSpendPrice + cosl.Apttus_Config2__NetPrice__c;
                 }                 
             }
         }
         Decimal num = currentOnlineSpendPrice.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         //return ('USD $ ' + String.valueOf(num.format())); //SOC-5938
          return ('USD $ ' + String.valueOf(num));
     }
     
     //added by ssuri@apttus on 26-july-2017 Starts
     /**
     * @description
     * @return ''
     */
     public String getCurrentBand() {
         if(assetLineItem != null && assetLineItem.size() >0) {
             currentBand = 0;
             for(Apttus_Config2__AssetLineItem__c asl : assetLineItem) {
                 if(asl.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c != null) {
                     currentBand = asl.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c;
                 }
             }
         }
         return (String.valueOf(currentBand));
     }
     
     /**
     * @description
     * @return ''
     */
     public String getAttorneyBand() {
         if( lineItem!= null && lineItem.size() >0) {
             attorneyBand = 0;
             for(Apttus_Config2__LineItem__c li : lineItem) {
                 if(li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c != null && li.Apttus_Config2__LineStatus__c=='New') {
                     attorneyBand = li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c.setScale(0);
                 }
             }
         }
         return (String.valueOf(attorneyBand));
     }
     
      
     
     //added by ssuri@apttus on 26-july-2017 ends
     @TestVisible private void setCurrentNetPriceTCV() {
         currentNetPriceTCV = 0;
         if(currentTCVList != null && currentTCVList.size() >0) {
             for(Apttus_Config2__AssetLineItem__c asl : currentTCVList) {
                 if(asl.Apttus_Config2__NetPrice__c != null) {
                     currentNetPriceTCV = currentNetPriceTCV + asl.Apttus_Config2__NetPrice__c;
                 }
             }
         }
     }
     
     /**
     * @description
     * @return ''
     */
     public Decimal getLapsedProdNetPrice(){
         Decimal lapsedProdNetPrice = 0;
         if(lapsedProducts != null && lapsedProducts.size() > 0 ){
             for(Apttus_Config2__AssetLineItem__c asl : assetLineItem) {
                 if(asl.Apttus_Config2__NetPrice__c != null) {
                     lapsedProdNetPrice = lapsedProdNetPrice + asl.Apttus_Config2__NetPrice__c;
                 }
             }
         }
         return lapsedProdNetPrice;
     }
     
     /**
     * @description
     * @return ''
     */
     public Decimal getnewProductsNetPrice() {
         Decimal newProductsNetPrice = 0;                 
         if(lineItem != null && lineItem.size() >0) {
             for(Apttus_Config2__LineItem__c li : lineItem){
                 if(li.Apttus_Config2__NetPrice__c != null) {
                     newProductsNetPrice = newProductsNetPrice + li.Apttus_Config2__NetPrice__c;
                 }   
             }
         }
         return newProductsNetPrice;
     }
     
     /**
     * @description
     * @return ''
     */
     public String getProposedNetPrice() {         
         proposedNetPrice = 0;            
         Decimal cartPrice= 0;
         Decimal renewalPrice= 0;                           
         //Decimal lapsedProdPrice = 0; 
         Decimal totalAssetNetPrice =0; 
         Decimal totalrenewcancelNetPrice =0;
         Decimal totalAssetlineNetPrice =0;
         
         //Map<Apttus_Config2__AssetLineItem__c ,Boolean> assetMap = new  Map<Apttus_Config2__AssetLineItem__c,Boolean>();                            
         if(proposedOnlineSoftwareList != null && proposedOnlineSoftwareList.size() > 0){                          
             for(Apttus_Config2__LineItem__c li : proposedOnlineSoftwareList) {                 
                     if(li.Apttus_Config2__LineStatus__c == 'New' && li.Apttus_Config2__NetPrice__c!=null){
                         cartPrice= cartPrice+li.Apttus_Config2__NetPrice__c ;
                     }
                     else if(li.Apttus_Config2__LineStatus__c == 'Renewed' && li.Apttus_Config2__NetPrice__c!=null){
                         renewalPrice = renewalPrice+li.Apttus_Config2__NetPrice__c ;
                         cartLinesProposednet.add(li);                      
                     }                     
                     else if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){                         
                         cartLinesProposednet.add(li);
                        }
                     
             }                
         }         
         if(currentOnlineSoftwareList!= null && currentOnlineSoftwareList.size() > 0){ 
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList) { 
                     if(asl.Apttus_Config2__NetPrice__c!=null){ 
                         totalAssetNetPrice = totalAssetNetPrice + asl.Apttus_Config2__NetPrice__c; 
                         if(cartLinesProposednet!=null && cartLinesProposednet.size() > 0) {                       
                         for(Apttus_Config2__LineItem__c lines : cartLinesProposednet){                       
                               if(asl.APTS_Combination_Key__c!=null){
                                     if(asl.APTS_Combination_Key__c==lines.APTS_Combination_Key__c && lines.APTS_Product_Code__c==asl.APTS_Material_Number__c && asl.Apttus_Config2__NetPrice__c!=null && lines.APTS_FL_Current_price__c == asl.Apttus_Config2__NetPrice__c){
                                     totalrenewcancelNetPrice = totalrenewcancelNetPrice + asl.Apttus_Config2__NetPrice__c;                                   
                                     break;
                                     }
                                 
                                 }                                 
                             else{
                                 if(lines.APTS_Product_Code__c==asl.APTS_Material_Number__c && asl.Apttus_Config2__NetPrice__c!=null && lines.APTS_FL_Current_price__c == asl.Apttus_Config2__NetPrice__c){
                                       totalrenewcancelNetPrice = totalrenewcancelNetPrice + asl.Apttus_Config2__NetPrice__c;                                        
                                       break;
                                   }
                                 }                                                         
                         }
                      } 
                    }                 
                  }  
                   
                   totalAssetlineNetPrice = totalAssetNetPrice -totalrenewcancelNetPrice;
                   
             }
         proposedNetPrice = cartPrice+ renewalPrice + totalAssetlineNetPrice;         
         Decimal num = proposedNetPrice.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         return ('USD $' + String.valueOf(num)); //SOC-5938
     }
     
     /**
     * @description
     * @return ''
     */
     public String getCurrentAttorneysTotal() {
         currentTotalAttorneys = 0;
         if(assetLineItem != null && assetLineItem.size() >0) {
             for(Apttus_Config2__AssetLineItem__c asl : assetLineItem) {                
                if(asl.APTS_SSD_Sold_To__c!= null) {
                        if(asl.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c!=null){
                        currentTotalAttorneys = asl.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c;}
                }
             }
         } 
         return (String.valueOf(currentTotalAttorneys.format()));
     }
     
     /**
     * @description
     * @return ''
     */
    public String getProposedAttorneysTotal() {
         proposedTotalAttorneys = 0;
        if(lineItem != null && lineItem.size() >0) {
            for(Apttus_Config2__LineItem__c li : lineItem) {
                System.debug(LoggingLevel.WARN,'Inside if'+li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c);
                if(li.Apttus_Config2__LineStatus__c=='New' && li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c!=null){
                    if(li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c>proposedTotalAttorneys){
                    proposedTotalAttorneys=li.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c;
                }   
              }  
            }
        }
         return (String.valueOf(proposedTotalAttorneys.format()));
    }
     
    /**
     * @description
     * @return ''
     */
     public String getCurrentRPA() {
         if(currentNetPrice == 0) {
             getCurrentNetPrice();
         }
         if(currentTotalAttorneys == 0) {
             getCurrentAttorneysTotal();
         }
         
         Decimal rpa = (currentTotalAttorneys == 0 ? 0 : (currentNetPrice/currentTotalAttorneys));
         Decimal num = rpa.setScale(2,System.RoundingMode.HALF_UP); 
         return ('USD $' + String.valueOf(num));
     }
     
     /**
     * @description
     * @return ''
     */
     public String getProposedRPA() {
         if(proposedNetPrice == 0) {
             getProposedNetPrice();
         }
         if(proposedTotalAttorneys == 0) {
             getProposedAttorneysTotal();
         }
         
         Decimal rpa = (proposedTotalAttorneys == 0 ? 0 : (proposedNetPrice/proposedTotalAttorneys));
         Decimal num = rpa.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         //return ('USD $' + String.valueOf(num.format())); //SOC-5938
         return ('USD $' + String.valueOf(num));
     }
     
     /**
     * @description
     * @return ''
     */
     public String getCurrentOverallDiscount() {
         currentOverallDiscount = 0;
         if(assetLineItem != null && assetLineItem.size() >0) {
         // currentOnlineSoftwareList
             for(Apttus_Config2__AssetLineItem__c asl : assetLineItem) {
                     if(asl.APTS_Discount_Percent_Retail__c == null) {
                         currentOverallDiscount = currentOverallDiscount + (getCurrentMaterialWeight(asl) * 0);
                     } else {
                         currentOverallDiscount = currentOverallDiscount + ((getCurrentMaterialWeight(asl) * asl.APTS_Discount_Percent_Retail__c)/100); 
                     }
             }
         }
         Decimal num = currentOverallDiscount.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
         String output = String.valueOf(num.format()) + '%';
         return output;
     }
     /**
     * @description
     * @return ''
     */
     public String getCurrentDiscount() {
         currentDiscount = 0;
         totalAssetNetPrice = 0;
         totalAssetListPrice = 0;         
         if(currentOnlineSoftwareList != null && currentOnlineSoftwareList.size() >0) {         
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList) {
                     if(asl.Apttus_Config2__ListPrice__c!=null){
                        totalAssetListPrice = totalAssetListPrice + asl.Apttus_Config2__ListPrice__c; }
                     if(asl.Apttus_Config2__NetPrice__c!=null){
                        totalAssetNetPrice = totalAssetNetPrice + asl.Apttus_Config2__NetPrice__c; }                         
                     
             }
         }         
         if(totalAssetListPrice!=0){
            currentDiscount = ((totalAssetListPrice - totalAssetNetPrice )/totalAssetListPrice)*100;
            }           
            Decimal num = currentDiscount.setScale(1,System.RoundingMode.HALF_UP);
            String output = String.valueOf(num) + '%';
            return output;
     }
     
     private Decimal getCurrentMaterialWeight(Apttus_Config2__AssetLineItem__c asl) {
         if(currentNetPrice == 0) {
             getCurrentNetPrice();
         }
         if(asl.Apttus_Config2__ListPrice__c== null) {
             return 0;
         } else {
             return (currentNetPrice == 0 ? 0 : (asl.Apttus_Config2__ListPrice__c/ currentNetPrice));
         }
     }
         
     private Decimal getProposedMaterialWeight(Apttus_Config2__LineItem__c li) {
         if(proposedNetPrice ==0){
             getProposedNetPrice();
         }
         if(li.Apttus_Config2__ListPrice__c == null) {
             return 0;
         } else {
             return (proposedNetPrice == 0 ? 0 : (li.Apttus_Config2__ListPrice__c / proposedNetPrice));
         }
     }
     
     /**
     * @description
     * @return ''
     */
     public String getProposedTCV() {         
         proposedTCV = 0;            
         Decimal tcvCartPrice= 0;
         Decimal tcvRenewalPrice= 0;                           
         Decimal tcvTotalAssetNetPrice =0; 
         Decimal tcvTotalrenewcancelNetPrice =0;
         Decimal tcvTotalAssetlineNetPrice =0;
         Integer term=null;
         
         //Map<Apttus_Config2__AssetLineItem__c ,Boolean> assetMap = new  Map<Apttus_Config2__AssetLineItem__c,Boolean>();                            
         if(proposedOnlineSoftwareList != null && proposedOnlineSoftwareList.size() > 0){                          
             for(Apttus_Config2__LineItem__c li : proposedOnlineSoftwareList) {                 
                     if(li.Apttus_Config2__LineStatus__c == 'New' && li.Apttus_Config2__NetPrice__c!=null && li.APTS_Contract_Term_Number__c!=null){
                         tcvCartPrice= tcvCartPrice+li.Apttus_Config2__NetPrice__c*li.APTS_Contract_Term_Number__c;
                     }
                     else if(li.Apttus_Config2__LineStatus__c == 'Renewed' && li.Apttus_Config2__NetPrice__c!=null && li.APTS_Contract_Term_Number__c!=null){
                         tcvRenewalPrice = tcvRenewalPrice+li.Apttus_Config2__NetPrice__c*li.APTS_Contract_Term_Number__c ;
                         cartLinesProposedtcv.add(li);                      
                     }                     
                     else if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){                         
                         cartLinesProposedtcv.add(li);
                        }
                     
             }                
         }         
         if(currentOnlineSoftwareList!= null && currentOnlineSoftwareList.size() > 0){ 
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList) {
                     if(asl.APTS_Contract_Term__c!=null){
                        if(asl.APTS_Contract_Term__c=='1 Months'){ term = 1;} if(asl.APTS_Contract_Term__c=='2 Months'){ term = 2;} 
                        if(asl.APTS_Contract_Term__c=='3 Months'){ term = 3;} if(asl.APTS_Contract_Term__c=='4 Months'){ term = 4;} 
                        if(asl.APTS_Contract_Term__c=='5 Months'){ term = 5;} if(asl.APTS_Contract_Term__c=='6 Months'){ term = 6;} 
                        if(asl.APTS_Contract_Term__c=='7 Months'){ term = 7;} if(asl.APTS_Contract_Term__c=='8 Months'){ term = 8;} 
                        if(asl.APTS_Contract_Term__c=='9 Months'){ term = 9;} if(asl.APTS_Contract_Term__c=='10 Months'){ term = 10;} 
                        if(asl.APTS_Contract_Term__c=='11 Months'){ term = 11;} if(asl.APTS_Contract_Term__c=='1 Year'){ term = 12;} 
                        if(asl.APTS_Contract_Term__c=='2 Years'){ term = 24;} if(asl.APTS_Contract_Term__c=='3 Years'){ term = 36;} 
                             if(asl.Apttus_Config2__NetPrice__c!=null && term!=null){
                                 tcvTotalAssetNetPrice = tcvTotalAssetNetPrice + asl.Apttus_Config2__NetPrice__c*term; 
                                 } 
                                                   
                         if(cartLinesProposedtcv!=null && cartLinesProposedtcv.size() > 0) {                       
                         for(Apttus_Config2__LineItem__c lines : cartLinesProposedtcv){ 
                               System.debug(LoggingLevel.WARN,'Inside if'+lines );                      
                               if(asl.APTS_Combination_Key__c!=null){
                                     if(asl.APTS_Combination_Key__c==lines.APTS_Combination_Key__c && lines.APTS_Product_Code__c==asl.APTS_Material_Number__c && term!=null && asl.Apttus_Config2__NetPrice__c!=null){
                                     tcvTotalrenewcancelNetPrice = tcvTotalrenewcancelNetPrice + asl.Apttus_Config2__NetPrice__c*term;                                   
                                     break;
                                     }
                                 
                                 }                                 
                             else{
                                 if(lines.APTS_Product_Code__c==asl.APTS_Material_Number__c && term!=null && asl.Apttus_Config2__NetPrice__c!=null){
                                       tcvTotalrenewcancelNetPrice = tcvTotalrenewcancelNetPrice + asl.Apttus_Config2__NetPrice__c*term;                                        
                                       break;

                                   }
                                 }                                                         
                         }
                      } 
                                     
                  }
                  
                else{
                      if(asl.Apttus_Config2__NetPrice__c!=null){
                                 tcvTotalAssetNetPrice = tcvTotalAssetNetPrice + asl.Apttus_Config2__NetPrice__c; 
                                 } 
                                                  
                         if(cartLinesProposedtcv!=null && cartLinesProposedtcv.size() > 0) {                       
                         for(Apttus_Config2__LineItem__c lines : cartLinesProposedtcv){                       
                               if(asl.APTS_Combination_Key__c!=null){
                                     if(asl.APTS_Combination_Key__c==lines.APTS_Combination_Key__c && lines.APTS_Product_Code__c==asl.APTS_Material_Number__c && asl.Apttus_Config2__NetPrice__c!=null && lines.APTS_FL_Current_price__c == asl.Apttus_Config2__NetPrice__c){
                                     tcvTotalrenewcancelNetPrice = tcvTotalrenewcancelNetPrice + asl.Apttus_Config2__NetPrice__c;                                   
                                     break;

                                     }
                                 
                                 }                                 
                             else{
                                 if(lines.APTS_Product_Code__c==asl.APTS_Material_Number__c && asl.Apttus_Config2__NetPrice__c!=null && lines.APTS_FL_Current_price__c == asl.Apttus_Config2__NetPrice__c){
                                       tcvTotalrenewcancelNetPrice = tcvTotalrenewcancelNetPrice + asl.Apttus_Config2__NetPrice__c;                                        
                                       break;

                                   }
                                 }                                                         
                         }
                      }
                  }
                  }
                   
                   tcvTotalAssetlineNetPrice = tcvTotalAssetlineNetPrice + (tcvTotalAssetNetPrice-tcvTotalrenewcancelNetPrice);                   
                   
             }              
         proposedTCV = (tcvCartPrice+ tcvRenewalPrice + tcvTotalAssetlineNetPrice);  
         System.debug(LoggingLevel.WARN,'proposedTCV '+proposedTCV );
         Decimal num = proposedTCV.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         return ('USD $' + String.valueOf(num));         
     }
     
     /**
     * @description
     * @return ''
     */
     public String getProposedDiscount() {
         proposedDiscount = 0;         
         //Decimal pdTotalLineNetPrice = 0;
         //Decimal pdTotalLineListPrice = 0;
         Decimal pdTotalAssetListPrice = 0;
         Decimal pdCartPrice= 0;
         Decimal pdRenewalPrice= 0;                           
         Decimal pdTotalListprice = 0;
         Decimal pdProposedlistprice =0;
         Decimal pdTotalrenewcancelNetPrice =0;


         
         if(proposedNetPrice == 0) {
             getProposedNetPrice();
         }
         
         if(proposedOnlineSoftwareList != null && proposedOnlineSoftwareList.size() > 0){              
             for(Apttus_Config2__LineItem__c li : proposedOnlineSoftwareList) {                 
                     if(li.Apttus_Config2__LineStatus__c == 'New' && li.Apttus_Config2__ExtendedPrice__c!=null){
                         pdCartPrice= pdCartPrice+li.Apttus_Config2__ExtendedPrice__c ;
                     }
                     else if(li.Apttus_Config2__LineStatus__c == 'Renewed' && li.Apttus_Config2__ExtendedPrice__c!=null){
                         pdRenewalPrice= pdRenewalPrice+li.Apttus_Config2__ExtendedPrice__c ; 
                         cartLinesProposeddis.add(li);                          
                     }                     
                     else if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){                         
                         cartLinesProposeddis.add(li);  
                     }
                     
             } 
         }
          if(currentOnlineSoftwareList!= null && currentOnlineSoftwareList.size() > 0){ 
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList) { 
                     if(asl.Apttus_Config2__ListPrice__c!=null){  
                         pdTotalListprice = pdTotalListprice+ asl.Apttus_Config2__ListPrice__c; 
                         System.debug(LoggingLevel.WARN,'pdTotalListprice'+pdTotalListprice);
                         if(cartLinesProposeddis!=null && cartLinesProposeddis.size() > 0) {                       
                             for(Apttus_Config2__LineItem__c lines : cartLinesProposeddis){                        
                               if(asl.APTS_Combination_Key__c!=null){
                                         if(asl.APTS_Combination_Key__c==lines.APTS_Combination_Key__c && lines.APTS_Product_Code__c==asl.APTS_Material_Number__c && asl.Apttus_Config2__ListPrice__c!=null && lines.APTS_FL_Current_price__c == asl.Apttus_Config2__NetPrice__c){
                                         pdTotalrenewcancelNetPrice = pdTotalrenewcancelNetPrice + asl.Apttus_Config2__ListPrice__c;                                    
                                         break;
                                         }
                                     
                                     }                                 
                                 else{
                                     if(lines.APTS_Product_Code__c==asl.APTS_Material_Number__c && asl.Apttus_Config2__ListPrice__c!=null && lines.APTS_FL_Current_price__c == asl.Apttus_Config2__NetPrice__c){                                       
                                           pdTotalrenewcancelNetPrice = pdTotalrenewcancelNetPrice + asl.Apttus_Config2__ListPrice__c;                                        
                                           break;

                                       }
                                     }                                                         
                             }
                          } 
                       }                     
                  }  
                   
                   pdTotalAssetListPrice = pdTotalListprice-pdTotalrenewcancelNetPrice;
             }        
         
         pdProposedlistprice = pdCartPrice + pdRenewalPrice + pdTotalAssetListPrice;
         System.debug(LoggingLevel.WARN,'pdProposedlistprice '+pdProposedlistprice ); 
         if(pdProposedlistprice!=0){
            proposedDiscount = (pdProposedlistprice - ProposedNetPrice)/pdProposedlistprice;
         }
         proposedDiscount = proposedDiscount * 100;
         System.debug(LoggingLevel.WARN,'proposedDiscount  '+proposedDiscount);         
         Decimal num = proposedDiscount.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
         String output = String.valueOf(num) + '%'; //SOC-5938
         return output;
     }
     
     /**
     * @description
     * @return ''
     */
     public String getProposedOverallDiscount() {
         proposedOverallDiscount = 0;
         Decimal newProductDiscount = 0;
         if(currentDiscount == 0) {
            getCurrentDiscount(); 
         }
         if(lineItem != null && lineItem.size() >0) {
             for(Apttus_Config2__LineItem__c li : lineItem) {
                 if(li.APTS_Discount_Percent_Retail__c == null) {
                     newProductDiscount = newProductDiscount + (getProposedMaterialWeight(li) * 0); 
                 } else {
                     newProductDiscount = newProductDiscount + ((getProposedMaterialWeight(li) * li.APTS_Discount_Percent_Retail__c)/100); 
                 }
             }
         }
         proposedOverallDiscount = (currentDiscount + newProductDiscount); 
         Decimal num  = proposedOverallDiscount.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
         //String output = String.valueOf(proposedDiscount.format()) + '%';
         String output = String.valueOf(num.format()) + '%';
         return output;
     }
     /**
     * @description
     * @return ''
     */
     public String getDiscountChange() {
         
         Decimal num = (proposedDiscount - currentDiscount).setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
         return (String.valueOf(num) + '%');
     }
     /**
     * @description
     * @return ''
     */
     public String getOverallDiscountChange() {         
         overallDiscountChange = 0;
         Decimal num = overallDiscountChange.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
        return (String.valueOf(num) + '%');
     }
     /**
     * @description
     * @return ''
     */
     public String getCurrentACV() { 
         System.Debug(LoggingLevel.WARN,' --------------- > '+currentNetPrice);
         currentACV = (currentNetPrice * 12);         
         Decimal num = currentACV.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
        // return ('USD $' + String.valueOf(num.format())); //SOC-5938
        return ('USD $' + String.valueOf(num)); 
     }
     /**
     * @description
     * @return ''
     */
     public String getProposedACV() {
         proposedACV = (proposedNetPrice * 12);
         Decimal num = proposedACV.setScale(2,System.RoundingMode.HALF_UP);         
        return ('USD $ ' + String.valueOf(num));
     }
     /**
     * @description
     * @return ''
     */
     public String getIncrementalGrowthPer() {
         if(proposedNetPrice == 0) {
             getProposedNetPrice();
         }
         if(CurrentNetPrice== 0) {
             getCurrentNetPrice();
         }    
       
        decimal percentage= CurrentNetPrice== 0 ? 0 : ((proposedNetPrice-CurrentNetPrice)/CurrentNetPrice)*100;      
        Decimal num = percentage.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
        System.Debug(LoggingLevel.WARN,' ---------Incre------ > '+num); 
        return (String.valueOf(num) + '%');   
                        
     }
     /**
     * @description
     * @return ''
     */
     public String getIncrementalGrowthDollor() {
         if(proposedNetPrice == 0) {
             getProposedNetPrice();
         }
         if(CurrentNetPrice== 0) {
             getCurrentNetPrice();
         }              
         decimal pertage=CurrentNetPrice== 0 ? 0 :  proposedNetPrice-CurrentNetPrice; 
         Decimal num = (pertage).setScale(2,System.RoundingMode.HALF_UP);
         System.Debug(LoggingLevel.WARN,' ---------Incre------ > '+num);  
         return ('USD $ ' + String.valueOf(num));
         
     }
     /**
     * @description
     * @return ''
     */
     public String getIncrementalGrowthPercent() {
        Decimal percent =  currentACV == 0 ? 0 : ((proposedACV - currentACV)/currentACV)*100;
        Decimal num = percent.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
        System.Debug(LoggingLevel.WARN,' ---------Incre------ > '+num);  
        return (String.valueOf(num) + '%');//5938;  
        
           
     }
     /**
     * @description
     * @return ''
     */
     public String getIncrementalGrowthDollorAcv() {
        Decimal percent =  currentACV == 0 ? 0 : ((proposedACV - currentACV));        
        Decimal num = (percent).setScale(2,System.RoundingMode.HALF_UP);
        System.Debug(LoggingLevel.WARN,' ---------Incre------ > '+percent);  
        return ('USD $ ' + String.valueOf(num));  
        
           
     }
     /**
     * @description
     * @return ''
     */
     public Decimal getAssetNetPrice() {
     Decimal totalAssetNetPrice  = 0;
         if(allAssetList!= null && allAssetList.size() > 0) {
             totalAssetNetPrice = 0;
                for(Apttus_Config2__AssetLineItem__c asl : allAssetList) {
                 if(asl.Apttus_Config2__NetPrice__c != null) {
                     totalAssetNetPrice = totalAssetNetPrice + asl.Apttus_Config2__NetPrice__c;
                 }
             }
         }
         return totalAssetNetPrice;
     }     
     /**
     * @description
     * @return ''
     */
    public String getCurrentTCV() {                 
        if(currentOnlineSoftwareList!= null && currentOnlineSoftwareList.size() > 0) {             
            currentTCV = 0;
            Date term = null;
            Integer remainingMonths =null;
            Date systemDate = null;
                for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList){                           
                    if(asl.APTS_Info_RenewalDate__c!=null){               
                        term = asl.APTS_Info_RenewalDate__c; 
                        System.Debug(LoggingLevel.WARN,' --------------- > term '+term);                    
                        systemDate = Date.today(); 
                            if(term!=null && term >systemDate ){
                            remainingMonths = systemDate.monthsBetween(term);
                            System.Debug(LoggingLevel.WARN,' --------------- > remainingMonths '+remainingMonths); 
                        }
                        if(remainingMonths>0){
                            currentTCV=currentTCV+ (asl.Apttus_Config2__NetPrice__c*remainingMonths); 
                            }      
                    }
                }
            }
            Decimal num = currentTCV.setScale(2,System.RoundingMode.HALF_UP);  
            return ('USD $' + String.valueOf(num));
        
    }     
    /**
     * @description
     * @return ''
     */
     public String getTCVChange() {
         getCurrentTCV();
         getProposedTCV();
         tCVChange=0;   
         System.Debug(LoggingLevel.WARN,' --------------- > proposedTCV '+proposedTCV); 
         System.Debug(LoggingLevel.WARN,' --------------- > currentTCV'+currentTCV);       
         if(currentTCV!=0){         
             tCVChange=(proposedTCV-currentTCV);             
         }
         else{
         tCVChange=proposedTCV;
         }
         Decimal num = tCVChange.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
         return ('USD $' + String.valueOf(num));
         //return (String.valueOf(num))+'%';
     }
     /**
     * @description
     * @return ''
     */
     global class Document implements Comparable{
         /**
         * @description
         * @return ''
         */
         public String fileId {get; set;}
         /**
         * @description
         * @return ''
         */
         public String fileName {get; set;}
         /**
         * @description
         * @return ''
         */
         public String Type {get; set;}
         /**
         * @description
         * @return ''
         */
         public String parentId {get; set;}
         /**
         * @description
         * @return ''
         */
         public String parentName {get;set;}
         /**
         * @description
         * @return ''
         */
         public String modifiedDate {get; set;}
         /**
         * @description
         * @return ''
         */
         public String createdBy {get; set;}
        /**
         * @description
         * @param id
         * @param name
         * @param pId
         * @param pName
         * @param typ
         * @param modifyDate
         * @param crtBy
         */      
         public Document(String id, String name, String pId, String pName, String typ, DateTime modifyDate, String crtBy) {
             fileId = id;
             fileName = name;
             parentId = pId;
             parentName = pName;
             Type = typ;
             modifiedDate = modifyDate.format('MMM dd, yyyy hh:mm a');
             createdBy = crtBy;          
         }
         /**
         * @description
         * @return 0
         * @param compareTo
         */
         global Integer compareTo(Object compareTo) {
             Document obj = (Document) compareTo;
             //Integer value = 0;
             if(modifiedDate > obj.modifiedDate) {
                 return -1;
             } else if(modifiedDate < obj.modifiedDate) {
                 return 1;
             } else {
                 return 0;
             }
         }
     }  
        /**
         * @description
         * 
         */
public class PrintProview {
        /**
         * @description
         * 
         */
         public String lineItemId {get;set;}
         /**
         * @description
         * 
         */
         public String productFamily {get;set;}
         /**
         * @description
         * 
         */
         public String productName {get;set;}
         /**
         * @description
         * 
         */
         public List<PurchaseOption> purchaseOptions {get;set;}
         
         /**
         * @description
         * @param liId
         * @param pFamily
         * @param pName
         */
         public PrintProview(String liId, String pFamily, String pName) {
             lineItemId = liId;
             productFamily = pFamily;
             productName = pName;
             purchaseOptions = getPurchaseOptions();
         }
         /**
         * @description
         * @return ''
         */
         public List<PurchaseOption> getPurchaseOptions() {
             List<Apttus_Config2__ProductAttributeValue__c> attributeList;
             List<PurchaseOption> purchaseOptions = new List<PurchaseOption>();
             if(productFamily.equals(Label.APTS_Print_Product_Family_Value)) {
                 attributeList = [SELECT Id, SCS_Print_Purchase_Options__c FROM Apttus_Config2__ProductAttributeValue__c av 
                     WHERE av.Apttus_Config2__LineItemId__c =:lineItemId];
                 if(attributeList != null && attributeList.size()>0) {
                     for(Apttus_Config2__ProductAttributeValue__c attribute : attributeList) {
                         purchaseOptions.add(new PurchaseOption(attribute.SCS_Print_Purchase_Options__c));
                     }
                 }
                     
             } else If(productFamily.equals(Label.APTS_Proview_Product_Family_Value)) {
                 attributeList = [SELECT Id, eBook_Purchase_Options__c FROM Apttus_Config2__ProductAttributeValue__c av 
                     WHERE av.Apttus_Config2__LineItemId__c =:lineItemId];
                 if(attributeList != null && attributeList.size()>0) {
                     for(Apttus_Config2__ProductAttributeValue__c attribute : attributeList) {
                         purchaseOptions.add(new PurchaseOption(attribute.eBook_Purchase_Options__c));
                     }
                 }
             }
             return purchaseOptions;      
         }    
     } 
     /**
         * @description
         * 
         */
     public class PurchaseOption {
         /**
         * @description
         * @return ''
         */
         public String purchaseOption {get;set;} 
         /**
         * @description
         * @param option
         */
         public PurchaseOption(String option) {
             purchaseOption = option;
         }
     }     
    /*Code added by Khushboo Vaidya as part of DOC-9111 (Tax Prof) for adding Files & attach a file button starts*/
    /**
         * @description
         * @param id
         * @param qName
         * @return ''
         */
    @RemoteAction
     public static List<Document> getFileList(String id, String qName) {
         if(!(Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Note.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible())) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
       } 
         List<Document> documents = new List<Document>();
         List<id> contLinkIds  = new List<id>();
         List<ContentDocumentLink> contLink;
         if (!Schema.sObjectType.ContentDocumentLink.isAccessible())  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
         }      
         ContLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId =: id];
         System.debug(LoggingLevel.WARN,'Kh*** ContLink===>'+ContLink); 
         if(!ContLink.isEmpty()) 
         {
             for(ContentDocumentLink cD : ContLink) 
             { ContLinkIds.add(cD.ContentDocumentId);}
             
         }
         List<contentversion> contVerion;
         if(!Schema.sObjectType.contentversion.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
         }
         contVerion =[Select id, ContentDocumentId, title,FileExtension, versiondata, LastModifiedDate, CreatedBy.name from contentversion where (ContentDocumentId IN : ContLinkIds) ORDER BY LastModifiedDate ASC NULLS LAST];
         System.debug(LoggingLevel.WARN,'Kh*** contVerion===>'+contVerion);
         
         if(contVerion != null && contVerion.size() > 0) 
         {
             for(contentversion contVer : contVerion) {
                 documents.add(new Document(contVer.Id, contVer.title, Id, qName, 'File', 
                                            contVer.LastModifiedDate, contVer.CreatedBy.name));
             }
         }
         documents.sort();
         return documents;   
     }
      
     /**
         * @description
         * @param cvId
         * @param parentId
         * @return ''
         */
    @RemoteAction
     public static boolean associateFilesWithQuote(String cvId,String parentId) { 
         
        if(cvId != null && parentID != null)
        {
            ContentVersion cv;
            if(!Schema.sObjectType.ContentVersion.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cvId AND ContentDocumentId != null LIMIT 1];
            if(cv != null)
            {
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.LinkedEntityId = parentId;
                cdl.ShareType = 'V';
                if (!Schema.sObjectType.ContentDocumentLink.IsCreateable()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
                }
                insert cdl;
                return true;
            }
            else {
                return false; }
            }
            else {
                return false; }
     }
     /*Code added by Khushboo Vaidya as part of DOC-9111 (Tax Prof) for adding Files & attach a file button ends*/
}