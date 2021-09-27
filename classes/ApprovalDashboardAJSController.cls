/*
Change Items:
1. Neeharika Upadrasta, 11/Aug/2017, Approval Dashboard changes
    - Current Net Price - Removed Print Proview products from calculation
    - Current RPA - Rounded to 2 decimals
    - Proposed Net Price - Modified to Net Price of (Installed Products + New Products – Lapsed Products) – Online Software 
    - Added Submission Comments to Approval Requests table (Exception Details & Notes)
    - Added Approval Request History to Approval Requests table
    - Changed labels from Name to Product in Current Subscription and New Subsription
2. Neeharika Upadrasta, 23/Aug/2017-24/Aug/2017, Approval Dashboard changes 2
    - Current Discount - Replaced Net Price with List Price in getCurrentMaterialWeight method
    - Current Overall Discount - Replaced Net Price with List Price in getCurrentMaterialWeight method
    - Proposed Discount - Replaced Net Price with List Price in getProposedMaterialWeight method
    - Proposed Overall Discount - Replaced Net Price with List Price in getCurrentMaterialWeight method
3. Neeharika Upadrasta, 30/Aug/2017, Approval Dashboard changes 3
    - Modified proposedOnlineSoftwareList to include all products (removed Charge Type = Subscription filter from query)
    - Modified Proposed Net Price to include only Online/Software products
    - Rounded for currency fields to 2 and Percentage fields to 1
    - Removed Charge Type = 'Subscription Fee' filter from Line Items list in order to include Print&Proview products
4. Neeharika Upadrasta, 06/Sep/2017-08/Sep/2017, Approval Dashboard changes 4
    - Proposed Net Price - Removed existing calculation. 
      Using Current Holdings + New Holdings - Lapsed Holdings from Product Configuration. Adding Incremental Growth to the 
      calculation.
    - Added 'Line Item status = New' condition to Proposed Attorneys
    - Removed Attorney Band from Approval Dashboard page since it's a duplicate of Proposed Attorneys 
5. Neeharika Upadrasta, 12/Sep/2017, Approval Dashboard changes 5
    - Current Net Price - Removed EDISCOVERY and CASE LOGISTIX products from Current Net Price query
    - Current Monthly Online/Software Spend - Removed EDISCOVERY and CASE LOGISTIX from Current Online/Software query
6. Neeharika Upadrasta, 27/Sep/2017, Approval Dashboard changes 6
    - Replaced Base Price in the Current Subscription Section to List Price
7. Neeharika Upadrasta, 04/Oct/2017, Discount changes 7
    - Modified Current Discount = (Total List Price - Total Net Price)/Total List Price, of all Asset Line Items
    - Modified Proposed Discount = (Total List Price - Total Net Price)/Total List Price, of all Line Items(except 'Renewed') 
      including Asset Line Items
8. Neeharika Upadrasta, 05/Oct/2017, Discount changes 8
    - All assets will include even Pending cancellation prices in Current Discount. For Line Items, the cancelled lines prices 
      will be deducted from total net price/list price.
    - Since Net Price is $0 for Cancelled Assets, retrieving the Net Price from related Asset Line Item for Proposed Discount
9. Neeharika Upadrasta, 18/Oct/2017, PROD error changes 9
    - To fix Prod error - Attempt to dereference null object when user enters cart after it is Finalized
    - Selects the latest Product Configuration
10. Neeharika Upadrasta, 07/Nov/2017, PROD error changes 10
    - Added null check for Current Holdings, New Holdings and Lapsed Holdings to avoid Null object error in PROD.
*/

global with sharing class ApprovalDashboardAJSController {

    public String quoteID {get; set;}
    public String quoteName {get; set;}
    public String ssdID {get; set;} 
    public String productConfigurationID {get; set;}
    private  Apttus_Config2__ProductConfiguration__c productConfiguration;
    public List<Apttus_Config2__LineItem__c> lineItem {get; set;}
    public Source_System_Detail__c ssd {get; set;}

    private Apttus_Proposal__Proposal__c quoteProposal {get; set;}
    public List<Apttus_Config2__LineItem__c> lineItems {get; set;} 
    public List<Apttus_Config2__AssetLineItem__c> assetLineItem {get; set;} 
    public List<Apttus_Config2__AssetLineItem__c> lapsedProducts;  
    public List<Apttus_Config2__AssetLineItem__c> currentTCVList {get; set;}  
    public List<Apttus_Config2__AssetLineItem__c> printProviewList {get; set;}
    public List<Apttus_Config2__AssetLineItem__c> findlawList {get; set;}   
    public List<Apttus_Config2__AssetLineItem__c> currentOnlineSoftwareList {get; set;} 
    public List<Apttus_Config2__LineItem__c> proposedOnlineSoftwareList {get; set;}  
    public List<SObject> proposedDiscountList = new List<SObject>();
    public List<SObject> proposedOverAllDiscountList = new List<SObject>();
    public List<Apttus_Config2__AssetLineItem__c> allAssetList = new List<Apttus_Config2__AssetLineItem__c>();
    private List<Apttus_Config2__LineItem__c> listOfTaxLineitems {get; set;}
    private Boolean bTaxCurrentDiscountCalc {get;set;} //DOC-3230
    private Boolean bTaxProposedDiscountCalc {get;set;} //DOC-3230
    private Boolean bTaxCurrentTCVCalc {get;set;} //DOC-3230
    private Boolean bTaxProposedTCVCalc {get;set;} //DOC-3230
    private String strTaxBundleProductDelAttributes ; //DOC-10825
    
    public Boolean additionalApprovalLegal {get;set;}
    public Boolean additionalApprovalother {get;set;}
    List<Apttus_Config2__LineItem__c>  cartLinesProposednet = new List<Apttus_Config2__LineItem__c>();
    List<Apttus_Config2__LineItem__c>  cartLinesProposeddis = new List<Apttus_Config2__LineItem__c>();
    private decimal currentOnlineSpendPrice=0;//added by ssuri@apttus.com on 28-july-2017
    private Decimal currentNetPrice = 0;
    private Decimal currentNetPriceTax = 0; //DOC-10825
    private Decimal currentBand = 0;//added by ssuri@apttus.com on 26-july-2017
    private Decimal attorneyBand = 0;//added by ssuri@apttus.com on 26-july-2017
    private Decimal tCVChange = 0;//added by ssuri@apttus.com on 26-july-2017
  private Decimal tCVChangeTax = 0; //DOC-10825
    private Decimal currentNetPriceTCV = 0;
    private Decimal proposedNetPrice = 0;
  private Decimal proposedNetPriceTax = 0; //DOC-10825
    private Decimal currentDiscount = 0;
    private Decimal currentOverallDiscount = 0;
    private Decimal currentTotalDiscount = 0;
    private Decimal proposedDiscount = 0;
    private Decimal proposedOverallDiscount = 0;
    private Decimal overall_DiscountChange = 0;
    private Decimal proposedTotalDiscount = 0;
    // ACV = Annual Contract Value
    private Decimal currentACV = 0;  
    private decimal percentage = 0; 
    private Decimal proposedACV = 0;
  private Decimal proposedACVTax = 0; //DOC-10825
    private Decimal currentTotalAttorneys = 0;
    private Decimal proposedTotalAttorneys = 0;
    // TCV = (Total Contract Value)
    private Decimal currentTCV = 0;
  private Decimal currentTCVTax = 0; //DOC-10825
    private Decimal proposedTCV = 0; 
  private Decimal proposedTCVTax = 0; //DOC-10825  
    private set<Id> liPrdId= new Set<Id>();
    //For Discounts added as Change 7
    private Decimal totalAssetNetPrice = 0;
    private Decimal totalAssetListPrice = 0;
    private Boolean isCanada; //DOC 331 Added By Poonam Garg  
  public Boolean isTax {get;set;}//Added by Khushboo Vaidya for Tax Professional
    public String billingFrequency;
    public String currencyStr{get;set;}
    public ApprovalDashboardAJSController() {
        isCanada=false;//DOC 331 Added By Poonam Garg
    isTax=false;//Added by Khushboo Vaidya for Tax Professional
    bTaxCurrentDiscountCalc = false;
        bTaxProposedDiscountCalc = false;
        bTaxCurrentTCVCalc = false;
        bTaxProposedTCVCalc = false;
    
        billingFrequency='';
        List<Apttus_Config2__AssetLineItem__c> assetLineItemList;  
        String returnId = string.escapeSingleQuotes('retId');
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get(returnId))) {
            quoteID = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(returnId)));
        }
        getPrintProviewLineItems(quoteID);
        System.Debug(' --------------- > '+quoteID);
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        quoteProposal = [SELECT Id, Name, Owner.Name, qp.APTS_SSD_Sold_To__c,APTS_Proposal_Business_Unit__c  from Apttus_Proposal__Proposal__c qp 
            where qp.Id =: quoteID ];
        quoteName = quoteProposal.Name;
        isCanada=quoteProposal.APTS_Proposal_Business_Unit__c==label.SALESORGCAN ? true : false;  //DOC 331 Added By Poonam Garg
        isTax =quoteProposal.APTS_Proposal_Business_Unit__c=='Tax Professional' ? true : false;  //Added by Khushboo Vaidya for Tax Professional
    currencyStr=isCanada ? 'CAD $' : 'USD $';
        if(!Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
         //SOC-9796 PMD Fix
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
        ssd = [SELECT ID, act.Name, act.Source_System_Account_Number__c, act.LCRM_Market_Segment__c, act.LCRM_APTS_Band_Number__c,
                      act.APTS_Customer_Category__c FROM Source_System_Detail__c act WHERE act.Id =:  quoteProposal.APTS_SSD_Sold_To__c];
        ssdID = ssd.Id;
        }
        
        try {
            if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
              //SOC-9796 PMD Fix
        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()) {
            productConfiguration = [select Name, Id, APTS_New_Holdings__c, APTS_Lapsed_Holdings__c, APTS_Current_Holdings__c, Apttus_QPConfig__Proposald__r.Name,  APTS_Additional_Approval_Legal__c, 
                                        APTS_Additional_Approval_Other__c,APTS_Incremental_Growth__c,
                    APTS_Tax_New_Holdings__c,APTS_Tax_Lapsed_Holdings__c,APTS_Tax_Current_Holdings__c
                    from Apttus_Config2__ProductConfiguration__c 
                                        where Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:quoteProposal.Id ORDER BY CreatedDate DESC LIMIT 1];
           
           } productConfigurationID = productConfiguration.Id;                            
            additionalApprovalLegal = productConfiguration.APTS_Additional_Approval_Legal__c;
            additionalApprovalother = productConfiguration.APTS_Additional_Approval_Other__c;
        }catch(Exception e) {
            additionalApprovalLegal = false;
            additionalApprovalother = false;                    
        }
 
        //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
          //SOC-9796 PMD Fix
        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()){
        assetLineItem = [SELECT Name, Apttus_Config2__ListPrice__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.List_Price__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,Apttus_Config2__BasePrice__c,
                            APTS_Contract_Term__c, APTS_Year_2_Adjustment__c, Apttus_Config2__AssetStatus__c, APTS_Discount_Percent_Retail__c,Apttus_Config2__Quantity__c,APTS_Info_PlanType__c,Apttus_Config2__PriceUom__c,APTS_Contract_Exit_Amount__c FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id AND APTS_Proposal_Business_Unit__c != 'FindLaw' AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false ];//SOC-7795--Added condition Apttus_Config2__AssetStatus__c by Priyanka
                            
        lapsedProducts = [SELECT Name, Apttus_Config2__NetPrice__c FROM Apttus_Config2__AssetLineItem__c WHERE APTS_SSD_Sold_To__c =: ssd.Id AND Apttus_Config2__AssetStatus__c='Cancelled'];             
                            
        currentTCVList = [SELECT Name, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Term_Remaining__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,
                            APTS_Contract_Term__c, APTS_Year_2_Adjustment__c,APTS_Info_PlanType__c, Apttus_Config2__AssetStatus__c, APTS_Discount_Percent_Retail__c,APTS_Contract_Exit_Amount__c FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id

                            AND (APTS_Contract_Term__c != NULL
                            AND APTS_Contract_Term__c != '') AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false];  //SOC-7795 --Added condition Apttus_Config2__AssetStatus__c by Priyanka                 
                            
        printProviewList = [SELECT Name, Apttus_Config2__ProductId__r.Family, Apttus_Config2__ProductId__r.APTS_Cat_L2__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name,APTS_Contract_Term__c, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c,Apttus_Config2__ProductId__r.List_Price__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c,APTS_Contract_Exit_Amount__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id 

                            AND (Apttus_Config2__ProductId__r.Family = 'FINDLAW' 
                            OR Apttus_Config2__ProductId__r.APTS_Cat_L2__c =: System.Label.APTS_Proview_Product_Family) AND Apttus_Config2__AssetStatus__c!='Cancelled'];//Added condition Apttus_Config2__AssetStatus__c!='Cancelled' by ssuri@apttus on 27-July-2017
                            
        findlawList = [SELECT Name, Apttus_Config2__ProductId__r.Family, Apttus_Config2__ProductId__r.APTS_Cat_L2__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,APTS_Contract_Term__c,
                            APTS_Material_Description__c,Apttus_Config2__ProductId__r.List_Price__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id 

                            AND Apttus_Config2__ProductId__r.Family = 'FINDLAW' AND Apttus_Config2__AssetStatus__c!='Cancelled']; //Added condition Apttus_Config2__AssetStatus__c!='Cancelled' by ssuri@apttus on 27-July-2017
        
    /*Code added by Khushboo Vaidya as part of DOC-10825 for Tax Professional changes starts*/
        if(isTax)  
        {
            currentOnlineSoftwareList = [SELECT Name, Apttus_Config2__Quantity__c,Apttus_Config2__ListPrice__c, Apttus_Config2__ProductId__r.Family, APTS_Info_RenewalDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,APTS_Contract_Term__c,  APTS_Number_of_Attorneys__c, //SOC-7761
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__EndDate__c, Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c,APTS_Year_2_Adjustment__c, APTS_Discount_Percent_Retail__c,Apttus_Config2__BillingFrequency__c, 
                            Apttus_Config2__SellingTerm__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__NetUnitPrice__c,Apttus_Config2__LineType__c /*DOC-10261*/,
                            Apttus_Config2__ProductId__r.APTS_Cat_L3__c,APTS_Contract_Exit_Amount__c
                            FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssd.Id 
                            AND APTS_Proposal_Business_Unit__c != 'FindLaw'  
                            AND Apttus_Config2__LineType__c = 'Product/Service'
                            AND (Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: System.Label.APTS_Print_Product_Family 
                            AND Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: System.Label.APTS_Proview_Product_Family
                            AND Apttus_Config2__ProductId__r.Family != 'FINDLAW'
                            AND Apttus_Config2__ProductId__r.APTS_Cat_L3__c !=: System.Label.APTS_Ediscovery_Product_Family
                            AND Apttus_Config2__ProductId__r.APTS_Cat_L3__c !=: System.Label.APTS_Case_Logistix_Product_Family) AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false]; //SOC-7795 -- Added condition Apttus_Config2__AssetStatus__c by Priyanka
        }
        /*Code added by Khushboo Vaidya as part of DOC-10825 for Tax Professional changes ends*/
        else
        {
      currentOnlineSoftwareList = [SELECT Name, Apttus_Config2__Quantity__c,Apttus_Config2__ListPrice__c, Apttus_Config2__ProductId__r.Family, APTS_Info_RenewalDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,APTS_Contract_Term__c,  APTS_Number_of_Attorneys__c, //SOC-7761
                APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__EndDate__c, Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__NetUnitPrice__c,
                Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c,APTS_Year_2_Adjustment__c, APTS_Discount_Percent_Retail__c,Apttus_Config2__BillingFrequency__c,
                Apttus_Config2__ProductId__r.APTS_Cat_L2__c, Apttus_Config2__ProductId__r.APTS_Cat_L3__c,APTS_Contract_Exit_Amount__c
                FROM Apttus_Config2__AssetLineItem__c ali
                WHERE APTS_SSD_Sold_To__c =: ssd.Id 
                AND APTS_Proposal_Business_Unit__c != 'FindLaw' AND Apttus_Config2__PriceType__c!='One Time'     //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
                AND (Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: System.Label.APTS_Print_Product_Family 
                AND Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: System.Label.APTS_Proview_Product_Family
                AND Apttus_Config2__ProductId__r.Family != 'FINDLAW'
                AND Apttus_Config2__ProductId__r.APTS_Cat_L3__c !=: System.Label.APTS_Ediscovery_Product_Family
                AND Apttus_Config2__ProductId__r.APTS_Cat_L3__c !=: System.Label.APTS_Case_Logistix_Product_Family) AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false]; //SOC-7795 -- Added condition Apttus_Config2__AssetStatus__c by Priyanka
    }
          if(!currentOnlineSoftwareList .isEmpty()){
              if(currentOnlineSoftwareList [0]!=null && currentOnlineSoftwareList [0].Apttus_Config2__BillingFrequency__c !=null){
                  billingfrequency=currentOnlineSoftwareList [0].Apttus_Config2__BillingFrequency__c;
              }
          }                  
                            
        }                    
        System.Debug(' ------------- '+currentOnlineSoftwareList.size());      
                                  
        if(productConfiguration != null) 
    {
            if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            //SOC-9796 PMD Fix
            lineItem = [Select Apttus_Config2__ListPrice__c, Apttus_Config2__LineStatus__c,APTS_Approval_Segment__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c ,APTS_is_Primary_in_Bundle__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, APTS_Years_2_Plus_Adjustment__c, 
                                        APTS_Number_of_Attorneys__c, Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c, APTS_Discount_Percent_Retail__c, 
                                        Apttus_Config2__NetPrice__c, APTS_Bridge__c, APTS_Service_Number__c, APTS_Product_Name__c,Apttus_Config2__PriceUom__c,Apttus_Config2__Quantity__c,
                                        APTS_Bundle__c,Apttus_Config2__IncentiveCode__c,Apttus_Config2__NetUnitPrice__c,APTS_Calculated_Year_1__c,APTS_Calculated_Year_2__c,
                                        APTS_Calculated_Year_3__c,APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c,APTS_Increase_Yr1_Yr2__c,APTS_Increase_Yr2_Yr3__c,APTS_Increase_Yr3_Yr4__c,APTS_Increase_Yr4_Yr5__c  from  Apttus_Config2__LineItem__c li 
                                        where li.Apttus_Config2__ConfigurationId__c =: productConfiguration.Id
                                        AND li.Apttus_Config2__ChargeType__c = 'Subscription Fee'
                                        AND APTS_Proposal_Business_Unit__c != 'FindLaw']; //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
              //SOC-7776 -- Added by Priyanka
                 for(Apttus_Config2__LineItem__c li:lineItem){
                  if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){
                      li.APTS_Years_2_Plus_Adjustment__c = null;
                      li.APTS_Contract_Term__c = null;
                      li.APTS_Yr_1_Renewal_Adjustment__c = null;
                      li.Apttus_Config2__Quantity__c = null;
                  }
                 }                            
             //SOC-9796 PMD Fix
            if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()) 
      {
                /*Code added by Khushboo Vaidya as part of DOC-10825 for Tax Professional changes starts*/
                if(isTax) 
                {
                    proposedOnlineSoftwareList = [Select Apttus_Config2__ListPrice__c,APTS_is_Primary_in_Bundle__c,APTS_Year_2_Adjustment__c,APTS_Product_Code__c,APTS_Asset_Contract_Term__c,APTS_Asset_Net_Price__c, Apttus_Config2__LineStatus__c,APTS_Info_RenewalDate__c,APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c,
                                        APTS_Number_of_Attorneys__c, Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c, APTS_Discount_Percent_Retail__c, Apttus_Config2__AssetLineItemId__c,Apttus_Config2__SellingTerm__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__NetUnitPrice__c,Apttus_Config2__LineType__c,/*DOC-10261*/
                                        Apttus_Config2__NetPrice__c, APTS_Bridge__c, APTS_Service_Number__c, APTS_Product_Name__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c ,APTS_Proposal_Business_Unit__c,Apttus_Config2__BillingFrequency__c, //SOC-7761 Added by Chirag 8/28/2018 
                                        APTS_Calculated_Year_1__c, APTS_Calculated_Year_2__c,APTS_Calculated_Year_3__c, APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c /*DOC-10825*/  ,
                                        Apttus_Config2__ProductId__r.APTS_Cat_L2__c
                                        from  Apttus_Config2__LineItem__c li 
                                        where li.Apttus_Config2__ConfigurationId__c =: productConfiguration.Id
                                        AND APTS_Proposal_Business_Unit__c != 'FindLaw'      //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
                                        AND Apttus_Config2__LineType__c = 'Product/Service'
                                        AND (Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: System.Label.APTS_Print_Product_Family 
                                        AND Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: System.Label.APTS_Proview_Product_Family
                                        AND Apttus_Config2__ProductId__r.Family != 'FINDLAW')]; 
                }
                /*Code added by Khushboo Vaidya as part of DOC-10825 for Tax Professional changes ends*/
                else
                {
          proposedOnlineSoftwareList = [Select Apttus_Config2__ListPrice__c,APTS_Year_2_Adjustment__c,APTS_Bundle__c,APTS_Product_Code__c,APTS_is_Primary_in_Bundle__c,APTS_Asset_Contract_Term__c,APTS_Asset_Net_Price__c, Apttus_Config2__LineStatus__c,APTS_Info_RenewalDate__c,APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, APTS_Years_2_Plus_Adjustment__c, 
                        APTS_Number_of_Attorneys__c, Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c, APTS_Discount_Percent_Retail__c, Apttus_Config2__AssetLineItemId__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__SellingTerm__c,Apttus_Config2__NetUnitPrice__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c,
                        APTS_Calculated_Year_1__c, APTS_Calculated_Year_2__c,APTS_Calculated_Year_3__c, APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c,
                        Apttus_Config2__NetPrice__c, APTS_Bridge__c, APTS_Service_Number__c, APTS_Product_Name__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c ,APTS_Proposal_Business_Unit__c,Apttus_Config2__BillingFrequency__c,      //SOC-7761 Added by Chirag 8/28/2018
                        Apttus_Config2__ProductId__r.APTS_Cat_L2__c 
                        from  Apttus_Config2__LineItem__c li 
                        where li.Apttus_Config2__ConfigurationId__c =: productConfiguration.Id
                        AND APTS_Proposal_Business_Unit__c != 'FindLaw'      //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
                        AND (Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=:  System.Label.APTS_Print_Product_Family 
                        AND Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: System.Label.APTS_Proview_Product_Family
                        AND Apttus_Config2__ProductId__r.Family != 'FINDLAW')];                        
        }
      }
        if(!proposedOnlineSoftwareList .isEmpty())
      {
        if(proposedOnlineSoftwareList [0]!=null && proposedOnlineSoftwareList [0].Apttus_Config2__BillingFrequency__c !=null){
          billingfrequency=proposedOnlineSoftwareList [0].Apttus_Config2__BillingFrequency__c;
              }
            }     

        if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        
    /*Code added by Khushboo Vaidya as part of DOC-3230 for Tax Professional changes starts*/
        listOfTaxLineitems = [Select Id, APTS_Product_Delivery__c, Apttus_Config2__LineStatus__c,
                              Apttus_Config2__ProductId__r.Family,APTS_Proposal_Business_Unit__c,APTS_Contract_Term__c,
                              Apttus_Config2__ProductId__r.APTS_Cat_L2__c, Apttus_Config2__ProductId__r.APTS_Cat_L3__c
                              FROM  Apttus_Config2__LineItem__c li 
                              WHERE li.Apttus_Config2__ConfigurationId__c =: productConfiguration.Id
                              AND APTS_Proposal_Business_Unit__c = 'Tax Professional'];
        System.Debug('Kh***TAD listOfTaxLineitems' + listOfTaxLineitems.size());
        System.Debug('Kh***TAD listOfTaxLineitems value===>' + listOfTaxLineitems);
        
        if(listOfTaxLineitems != null && listOfTaxLineitems.size() > 0)
        {
            for(Apttus_Config2__LineItem__c oLi:listOfTaxLineitems)
            {
                System.Debug('Kh***TAD Apttus_Config2__LineStatus__c===>'+ oLi.Apttus_Config2__LineStatus__c);
                System.Debug('Kh***TAD APTS_Product_Delivery__c===>'+ oLi.APTS_Product_Delivery__c);
                //DOC-10825
                if(oLi.APTS_Product_Delivery__c != null)
                {
                    strTaxBundleProductDelAttributes = oLi.APTS_Product_Delivery__c;
                }
                
                if(oLi.Apttus_Config2__LineStatus__c != null && (oLi.Apttus_Config2__LineStatus__c.equalsIgnoreCase('New')
                   || oLi.Apttus_Config2__LineStatus__c.equalsIgnoreCase('Renewed') || oLi.Apttus_Config2__LineStatus__c.equalsIgnoreCase('Amended')
                   || oLi.Apttus_Config2__LineStatus__c.equalsIgnoreCase('Existing') || oLi.Apttus_Config2__LineStatus__c.equalsIgnoreCase('Incremented')
                   || oLi.Apttus_Config2__LineStatus__c.equalsIgnoreCase('Upgraded'))
                   && oLi.APTS_Product_Delivery__c != null 
                   && (oLi.APTS_Product_Delivery__c.equalsIgnoreCase('Online/Internet') 
                      || oLi.APTS_Product_Delivery__c.equalsIgnoreCase('Download')
                      || strTaxBundleProductDelAttributes.contains('Bundle')
                      || strTaxBundleProductDelAttributes.contains('Pick')))/*DOC-10825*/
                {
                    System.Debug('Kh***TAD INSIDE MAIN IF');
                    System.Debug('Kh***TAD APTS_Contract_Term__c===>'+ oLi.APTS_Contract_Term__c);
                    if(oLi.APTS_Contract_Term__c != null)
                    {
                        bTaxCurrentTCVCalc = true;
                    }
                    System.Debug('Kh***TAD bTaxCurrentTCVCalc===>'+ bTaxCurrentTCVCalc);
                    System.Debug('Kh***TAD Apttus_Config2__ProductId__r.Family===>'+ oLi.Apttus_Config2__ProductId__r.Family);
                    System.Debug('Kh***TAD bTaxCurrentTCVCalc===>'+ bTaxCurrentTCVCalc);
                    if(oLi.Apttus_Config2__ProductId__r.Family != null && oLi.Apttus_Config2__ProductId__r.APTS_Cat_L2__c != null
                        && oLi.Apttus_Config2__ProductId__r.APTS_Cat_L3__c != null && oLi.Apttus_Config2__ProductId__r.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family 
                        && oLi.Apttus_Config2__ProductId__r.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family && oLi.Apttus_Config2__ProductId__r.Family != 'FINDLAW'
                        && oLi.Apttus_Config2__ProductId__r.APTS_Cat_L3__c != System.Label.APTS_Ediscovery_Product_Family  && oLi.Apttus_Config2__ProductId__r.APTS_Cat_L3__c != System.Label.APTS_Case_Logistix_Product_Family)
                    {
                        bTaxCurrentDiscountCalc = true;   
                    }
                    System.Debug('Kh***TAD bTaxCurrentDiscountCalc ===>'+ bTaxCurrentDiscountCalc ); 
                }
                System.Debug('Kh***TAD 2 oLi.APTS_Product_Delivery__c===>'+ oLi.APTS_Product_Delivery__c);  
                System.Debug('Kh***TAD 2 oLi.Apttus_Config2__ProductId__r.Family===>'+ oLi.Apttus_Config2__ProductId__r.Family);  
                System.Debug('Kh***TAD 2 oLi.APTS_Proposal_Business_Unit__c===>'+ oLi.APTS_Proposal_Business_Unit__c);  
                if(oLi.APTS_Product_Delivery__c != null 
                   && (oLi.APTS_Product_Delivery__c.equalsIgnoreCase('Online/Internet') 
                   || oLi.APTS_Product_Delivery__c.equalsIgnoreCase('Download')
                   || strTaxBundleProductDelAttributes.contains('Bundle')
                   || strTaxBundleProductDelAttributes.contains('Pick')) /*DOC-10825*/
                   && oLi.Apttus_Config2__ProductId__r.Family != null && oLi.Apttus_Config2__ProductId__r.Family != System.Label.APTS_Print_Product_Family 
                   && oLi.Apttus_Config2__ProductId__r.Family != System.Label.APTS_Proview_Product_Family && oLi.Apttus_Config2__ProductId__r.Family != 'FINDLAW'
                   && oLi.APTS_Proposal_Business_Unit__c != null && oLi.APTS_Proposal_Business_Unit__c != 'FindLaw')
                {
                    bTaxProposedTCVCalc = true;
                    bTaxProposedDiscountCalc = true;
                }
                System.Debug('Kh***TAD bTaxProposedTCVCalc ===>'+ bTaxProposedTCVCalc );
                System.Debug('Kh***TAD bTaxProposedDiscountCalc ===>'+ bTaxProposedDiscountCalc );
            } 
        }
        /*Code added by Khushboo Vaidya as part of DOC-3230 for Tax Professional changes ends*/                                
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
      
    @RemoteAction
    public static Source_System_Detail__c getAccountDetail(String ssdID){
         //SOC-9796 PMD Fix
            if(Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
        Source_System_Detail__c ssd = [SELECT ID, act.Name, act.Source_System_Account_Number__c, act.LCRM_Market_Segment__c, act.LCRM_APTS_Band_Number__c,
                      act.APTS_Customer_Category__c FROM Source_System_Detail__c act WHERE act.Id =:  ssdID];              
        return ssd;             
        }
        return null;
    }
    
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getAssetLineItem(String ssdID,string productConfigurationID) {
        System.debug('productConfigurationID>>>>'+productConfigurationID);

        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
    Apttus_Config2__ProductConfiguration__c config;
    if(productConfigurationID != null)
        {
      if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible())
            {
                config = [Select APTS_Proposal_Business_Unit__c from Apttus_Config2__ProductConfiguration__c where id =: productConfigurationID LIMIT 1];
            }  
      //Added following changes based on Approval Dashboard fixes for DOC-10825 by Rishi
            if(config != null && config.APTS_Proposal_Business_Unit__c == 'Tax Professional' && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) 
            {
        assetLineItem = [SELECT Name,Id, APTS_SSD_Sold_To__c,APTS_Contract_Term__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c,  //added soc-7832
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c,APTS_Info_RenewalDate__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,Apttus_Config2__NetUnitPrice__c,Apttus_Config2__BasePriceMethod__c FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_SSD_Sold_To__c =: ssdID AND APTS_Proposal_Business_Unit__c = 'Tax Professional' AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false AND Apttus_Config2__LineType__c = 'Product/Service'];
      }
      else
      {
        //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'    
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        assetLineItem = [SELECT Name,Id, APTS_SSD_Sold_To__c,APTS_Contract_Term__c,  APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,
                        Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,
                        Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c, Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, 
                        APTS_Discount_Percent_Retail__c,APTS_Info_RenewalDate__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,Apttus_Config2__NetUnitPrice__c,APTS_Contract_Exit_Amount__c FROM Apttus_Config2__AssetLineItem__c 
                        WHERE APTS_SSD_Sold_To__c =: ssdID AND APTS_Proposal_Business_Unit__c != 'FindLaw' AND Apttus_Config2__AssetStatus__c IN 
                        ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false]; // APTS_Info_RenewalDate__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c added by ssuri@apttus.com on 26-July-2017  //SOC-7795 --Added condition Apttus_Config2__AssetStatus__c by Priyanka                                   
      }
    }
        //SOC-9796 PMD Fix
        /*    if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible())
        assetLineItem = [SELECT Name,Id, APTS_SSD_Sold_To__c,APTS_Contract_Term__c,  APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c, APTS_Number_of_Attorneys__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c,  //added soc-7832
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c,APTS_Info_RenewalDate__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_SSD_Sold_To__c =: ssdID AND APTS_Proposal_Business_Unit__c != 'FindLaw' AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false]; // APTS_Info_RenewalDate__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c added by ssuri@apttus.com on 26-July-2017  //SOC-7795 --Added condition Apttus_Config2__AssetStatus__c by Priyanka */                 
        return assetLineItem;
     }
     
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getCurrentOnlineSoftwareList(String ssdID,string productConfigurationID) {
        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
        //SOC-9796 PMD Fix
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        
        assetLineItem = [SELECT Name,Id, Apttus_Config2__ProductId__r.Family,APTS_Contract_Term__c,  APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,Apttus_Config2__BasePrice__c, Apttus_Config2__ListPrice__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c, //soc-7832
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,APTS_Info_RenewalDate__c,
                            Apttus_Config2__ProductId__r.APTS_Cat_L2__c,APTS_Contract_Exit_Amount__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssdID 
                            AND APTS_Proposal_Business_Unit__c != 'FindLaw'       //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
                            AND (Apttus_Config2__ProductId__r.APTS_Cat_L2__c != : System.Label.APTS_Print_Product_Family 
                            AND Apttus_Config2__ProductId__r.APTS_Cat_L2__c !=: System.Label.APTS_Proview_Product_Family
                            AND Apttus_Config2__ProductId__r.Family != 'FINDLAW') AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false];//SOC-7795 --Added condition Apttus_Config2__AssetStatus__c by Priyanka
        return assetLineItem;
    }
    
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getPrintProviewList(String ssdID,string productConfigurationID) {
        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
        //SOC-9796 PMD Fix
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
       
        assetLineItem = [SELECT Name,Id, Apttus_Config2__ProductId__r.Family, Apttus_Config2__ProductId__r.APTS_Cat_L2__c, APTS_Contract_Term__c ,APTS_Info_RenewalDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,Apttus_Config2__BasePrice__c, Apttus_Config2__ListPrice__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,Apttus_Config2__ProductId__r.List_Price__c, Apttus_Config2__NetPrice__c,Apttus_Config2__Quantity__c, //soc-7832
                            Apttus_Config2__AssetStatus__c,APTS_Info_PlanType__c, APTS_Discount_Percent_Retail__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,APTS_Contract_Exit_Amount__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssdID 
                            AND APTS_Proposal_Business_Unit__c != 'FindLaw'       //SOC-8653 added APTS_Proposal_Business_Unit__c != 'FindLaw'
                            AND (Apttus_Config2__ProductId__r.APTS_Cat_L2__c = :  System.Label.APTS_Print_Product_Family 
                            OR Apttus_Config2__ProductId__r.APTS_Cat_L2__c =: System.Label.APTS_Proview_Product_Family)AND Apttus_Config2__AssetStatus__c IN ('New','Activated','Renewed','Amended','Suspended','Incremented','Superseded') AND Apttus_Config2__IsInactive__c = false];//SOC-7795 -- Added condition Apttus_Config2__AssetStatus__c by Priyanka 
        return assetLineItem;
     }
     
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getFindLawList(String ssdID,string productConfigurationID) {
        List<Apttus_Config2__AssetLineItem__c> assetLineItem;
        
        
        //SOC-9796 PMD Fix
        if(!Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }

        assetLineItem = [SELECT Name,Id, Apttus_Config2__ProductId__r.Family,APTS_Contract_Term__c ,APTS_Info_RenewalDate__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, APTS_Material_Number__c,Apttus_Config2__BasePrice__c, Apttus_Config2__ListPrice__c, APTS_Number_of_Attorneys__c,
                            APTS_Material_Description__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__NetPrice__c,
                            Apttus_Config2__AssetStatus__c,Apttus_Config2__ProductId__r.List_Price__c, APTS_Discount_Percent_Retail__c,APTS_Info_PlanType__c,APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c,APTS_Contract_Exit_Amount__c FROM Apttus_Config2__AssetLineItem__c ali
                            WHERE APTS_SSD_Sold_To__c =: ssdID 

                            AND Apttus_Config2__ProductId__r.Family = 'FINDLAW' AND Apttus_Config2__AssetStatus__c!='Cancelled']; //Added condition Apttus_Config2__AssetStatus__c!='Cancelled' by ssuri@apttus on 27-July-2017
        return assetLineItem;
     }
    
     @RemoteAction
     public static List<Apttus_Config2__LineItem__c> getLineItem(String configurationId) {
        List<Apttus_Config2__LineItem__c> lineItem;
    Apttus_Config2__ProductConfiguration__c config;
        if(configurationId != null)
    {
      if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()) 
      {
        config = [Select APTS_Proposal_Business_Unit__c from Apttus_Config2__ProductConfiguration__c where id =: configurationId LIMIT 1];
      }
      //Added following changes based on Approval Dashboard fixes for DOC-10825 by Rishi
            if(config != null && config.APTS_Proposal_Business_Unit__c == 'Tax Professional' && Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()) 
            {
                lineItem = [Select APTS_Contract_Term__c,APTS_Print_Purchase_Options__c,APTS_Approval_Segment__c ,APTS_Product_Code__c,Id,Apttus_Config2__ListPrice__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__AdjustmentAmount__c,APTS_Yr_1_Renewal_Adjustment__c ,Apttus_Config2__PriceUom__c, APTS_Years_2_Plus_Adjustment__c, 
                                APTS_Number_of_Attorneys__c, Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c, APTS_Discount_Percent_Retail__c,Apttus_Config2__Quantity__c, 
                                Apttus_Config2__NetPrice__c, APTS_Bridge__c,Apttus_Config2__LineStatus__c, APTS_Service_Number__c, APTS_Product_Name__c,APTS_Bundle__c,Apttus_Config2__IncentiveCode__c,Apttus_Config2__NetUnitPrice__c from  Apttus_Config2__LineItem__c li 
                                where li.Apttus_Config2__ConfigurationId__c =: configurationId AND li.APTS_Proposal_Business_Unit__c = 'Tax Professional' AND li.Apttus_Config2__LineType__c = 'Product/Service' Order By Apttus_Config2__LineStatus__c ]; 
                                
            }
            else
            {
        if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }

        lineItem = [Select APTS_Contract_Term__c,APTS_Print_Purchase_Options__c,APTS_Approval_Segment__c ,Id,Apttus_Config2__ListPrice__c,APTS_Product_Code__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__AdjustmentAmount__c,APTS_Yr_1_Renewal_Adjustment__c ,Apttus_Config2__PriceUom__c, APTS_Years_2_Plus_Adjustment__c, 
                                APTS_Number_of_Attorneys__c, Apttus_Config2__Uom__c, Apttus_Config2__BasePrice__c, APTS_Discount_Percent_Retail__c,Apttus_Config2__Quantity__c, 
                                Apttus_Config2__NetPrice__c, APTS_Bridge__c,Apttus_Config2__LineStatus__c, APTS_Service_Number__c, APTS_Product_Name__c,APTS_Bundle__c,Apttus_Config2__IncentiveCode__c,Apttus_Config2__NetUnitPrice__c,
                                APTS_Calculated_Year_1__c,APTS_Calculated_Year_2__c,
                                APTS_Calculated_Year_3__c,APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c,APTS_Increase_Yr1_Yr2__c,APTS_Increase_Yr2_Yr3__c,APTS_Increase_Yr3_Yr4__c,APTS_Increase_Yr4_Yr5__c from  Apttus_Config2__LineItem__c li 
                                where li.Apttus_Config2__ConfigurationId__c =: configurationId Order By Apttus_Config2__LineStatus__c ];
                                // APTS_Bundle__c added by ssuri@apttus.com on 26-July-2017        
      }          
         //SOC-7776 --Added by Priyanka
         for(Apttus_Config2__LineItem__c li:lineItem){
          if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){
              li.APTS_Years_2_Plus_Adjustment__c = null;
              li.APTS_Contract_Term__c = null;
              li.Apttus_Config2__Quantity__c = null;
              li.APTS_Yr_1_Renewal_Adjustment__c = null;
          }
         }
        
        } 
        return lineItem;   
     }
     
     @RemoteAction 
     public static List<Document> getDocumentList(String id) {
         if(!(Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Note.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible())) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
         }
         Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id, Name, (SELECT Id, Name, LastModifiedDate, CreatedBy.name FROM Attachments), 
                             (SELECT Id, Title, LastModifiedDate, CreatedBy.name FROM Notes),
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
         documents.sort();
         return documents;   
     }
    
  /*Code added by Khushboo Vaidya as part of DOC-9111 (Tax Prof) for adding Files & attach a file button starts*/
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
         System.debug('Kh*** ContLink===>'+ContLink); 
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
         System.debug('Kh*** contVerion===>'+contVerion);
         
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
     
   //SOC-7796
    @RemoteAction
     public static List<Apttus_Approval__Approval_Request__c> getApprovalRequestList(String id) {
         if(!(Schema.sObjectType.Apttus_Approval__Approval_Request__c.isAccessible())) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
       
         List<Apttus_Approval__Approval_Request__c> approvalList = [SELECT Id, Name, Apttus_Approval__Request_Comments__c, Apttus_Approval__Assigned_To_Link__c, 
                     Apttus_Approval__Assigned_To_Name__c,Apttus_Approval__Date__c, Apttus_Approval__Approval_Status__c, Apttus_Approval__Approver_Comments__c, Apttus_Approval__SubmissionComment1__c ,Apttus_Approval__Initial_Submitter__r.Name
                     FROM Apttus_Approval__Approval_Request__c ar WHERE ar.Apttus_QPApprov__ProposalId__c =: Id AND Apttus_Approval__Assigned_To_Name__c!=NULL Order By Apttus_Approval__Date__c DESC Nulls Last]; // SOC 5935 JKK
         return approvalList; 
     } 
     
      @RemoteAction
     public static List<Apttus_Approval__Approval_Request__c> getApprovalRequestList1(String id) {
         List<Apttus_Approval__Approval_Request__c> approvalListComm =  [SELECT Id, Name, Apttus_Approval__Request_Comments__c, Apttus_Approval__Assigned_To_Link__c, 
                     Apttus_Approval__DateAssigned__c ,Apttus_Approval__Assigned_To_Name__c, Apttus_Approval__Date__c,Apttus_Approval__Approval_Status__c, Apttus_Approval__Approver_Comments__c, Apttus_Approval__SubmissionComment1__c,Apttus_Approval__Initial_Submitter__r.Name
                     FROM Apttus_Approval__Approval_Request__c ar WHERE ar.Apttus_QPApprov__ProposalId__c =: Id AND Apttus_Approval__Assigned_To_Name__c!=NULL AND Apttus_Approval__Approval_Status__c !='Cancelled' Order By Apttus_Approval__Date__c DESC Nulls Last]; // SOC 5935 JKK //SOC-7797 //SOC-7796
         //SOC- 7796 changes for date formatting
         List<Apttus_Approval__Approval_Request__c>approvalList1 = new List<Apttus_Approval__Approval_Request__c>();         
         for(Apttus_Approval__Approval_Request__c apr:approvalListComm ){
          if(apr.Apttus_Approval__Approver_Comments__c != null && apr.Apttus_Approval__Approver_Comments__c !=''){
              System.debug('In if :::::');
              String commentFull = apr.Apttus_Approval__Approver_Comments__c;
              String comments = commentFull.substring(0,commentFull.length()-24);
              comments = comments + ' ' +apr.Apttus_Approval__Date__c.format('M/d/yyyy h:mm a'); 
              comments = comments.replaceAll('(19|2[0-9])[0-9]{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01]) (0[0-9]|1[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])((\\+|-)[0-1][0-9]{3})?',' ');
              apr.Apttus_Approval__Approver_Comments__c = comments ;
              }
               if(apr.Apttus_Approval__SubmissionComment1__c != null && apr.Apttus_Approval__SubmissionComment1__c !=''){
              System.debug('In if :::::');
              String comments = apr.Apttus_Approval__SubmissionComment1__c ;
               if(apr.Apttus_Approval__DateAssigned__c != null) {
                comments = comments + ' ' +apr.Apttus_Approval__DateAssigned__c.format('M/d/yyyy h:mm a'); 
               } 
              apr.Apttus_Approval__SubmissionComment1__c = comments ;            
                           
              }
              if(apr.Apttus_Approval__Approver_Comments__c != null && apr.Apttus_Approval__Approver_Comments__c !=''){
                 if(!apr.Apttus_Approval__Approver_Comments__c.containsIgnoreCase('On-Hold for consolidation')) {
                    approvalList1.add(apr);
                 }
                   
                 }
                else if(apr.Apttus_Approval__Approver_Comments__c != null && apr.Apttus_Approval__Approver_Comments__c !='') {
                    approvalList1.add(apr);
                }
                // Added for SOC-9444 - INC1522022
                else {
                    approvalList1.add(apr);
                }
          } 
         
         return approvalList1; 
     } 
     
    
         //SOC-7796   
      @RemoteAction
     public static List<Apttus_Approval__Approval_Request_History__c> getApprovalRequestHistoryList(String id) {
         if(!Schema.sObjectType.Apttus_Approval__Approval_Request_History__c.isAccessible()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
     }
         List<Apttus_Approval__Approval_Request_History__c> approvalHistList = [SELECT Id, Name, Apttus_Approval__Request_Comments__c, Apttus_Approval__Assigned_To_Link__c, 
                     Apttus_Approval__Assigned_To_Name__c, Apttus_Approval__Approval_Status__c, Apttus_Approval__Approver_Comments__c, Apttus_Approval__SubmissionComment1__c ,Apttus_Approval__Date__c
                     FROM Apttus_Approval__Approval_Request_History__c arh WHERE arh.Apttus_QPApprov__ProposalId__c =: Id AND Apttus_Approval__Assigned_To_Name__c!=NULL Order By Apttus_Approval__Date__c DESC Nulls Last];  //SOC-5935 JKK 
         return approvalHistList;
     } 
     
    
     @RemoteAction
     public static List<Apttus_Approval__Approval_Request_History__c> getApprovalRequestHistoryList1(String id) {
         List<Apttus_Approval__Approval_Request_History__c> approvalHistListComm = [SELECT Id, Name, Apttus_Approval__Request_Comments__c, Apttus_Approval__Assigned_To_Link__c,
                     Apttus_Approval__DateAssigned__c ,Apttus_Approval__Assigned_To_Name__c, Apttus_Approval__Approval_Status__c, Apttus_Approval__Approver_Comments__c, Apttus_Approval__SubmissionComment1__c,Apttus_Approval__Initial_Submitter__r.Name,Apttus_Approval__Date__c
                     FROM Apttus_Approval__Approval_Request_History__c arh WHERE arh.Apttus_QPApprov__ProposalId__c =: Id AND Apttus_Approval__Assigned_To_Name__c!=NULL AND Apttus_Approval__Approval_Status__c !='Cancelled' Order By Apttus_Approval__Date__c DESC Nulls Last];  // SOC 5935 JKK //SOC-7796 //SOC-7797
         //SOC- 7796 changes for date formatting 
         List<Apttus_Approval__Approval_Request_History__c> approvalHistList1 = new List<Apttus_Approval__Approval_Request_History__c>();      
          for(Apttus_Approval__Approval_Request_History__c apr:approvalHistListComm ){
          if(apr.Apttus_Approval__Approver_Comments__c != null && apr.Apttus_Approval__Approver_Comments__c !=''){
              System.debug('In if :::::');
              String commentFull = apr.Apttus_Approval__Approver_Comments__c;
              String comments = commentFull.substring(0,commentFull.length()-24);
              comments = comments + ' ' +apr.Apttus_Approval__Date__c.format('M/d/yyyy h:mm a'); 
              comments = comments.replaceAll('(19|2[0-9])[0-9]{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01]) (0[0-9]|1[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])((\\+|-)[0-1][0-9]{3})?',' ');
              apr.Apttus_Approval__Approver_Comments__c = comments ;
              }
              if(apr.Apttus_Approval__SubmissionComment1__c != null && apr.Apttus_Approval__SubmissionComment1__c !=''){
              System.debug('In if :::::');
              String comments = apr.Apttus_Approval__SubmissionComment1__c ;
              if(apr.Apttus_Approval__DateAssigned__c != null) {
                comments = comments + ' ' +apr.Apttus_Approval__DateAssigned__c.format('M/d/yyyy h:mm a'); 
                apr.Apttus_Approval__SubmissionComment1__c = comments ;
              }
              }
              
              if(apr.Apttus_Approval__Approver_Comments__c != null && apr.Apttus_Approval__Approver_Comments__c !=''){            
                  if(!apr.Apttus_Approval__Approver_Comments__c.containsIgnoreCase('On-Hold for consolidation')) {
                    approvalHistList1.add(apr);              
                  }
             }
             else if(apr.Apttus_Approval__Approver_Comments__c == null || apr.Apttus_Approval__Approver_Comments__c =='') {
                approvalHistList1.add(apr);
             }
             
          } 
         
         return approvalHistList1;
     }      
    
     @RemoteAction
     public static List<PrintProview> getPrintProviewLineItems(String id) {
         Apttus_Config2__ProductConfiguration__c configuration;
         List<Apttus_Config2__LineItem__c> lineItem;
         List<PrintProview> ppList = new List<PrintProview>();
         try {
             if(!(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible())) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
             configuration = [select Name, Id, Apttus_QPConfig__Proposald__r.Name, 
                         (select Id, Name, APTS_Product_Family__c, APTS_Product_Name__c,
                         Apttus_Config2__ProductId__r.APTS_Cat_L2__c from Apttus_Config2__LineItems__r li where 
                         (li.Apttus_Config2__ProductId__r.APTS_Cat_L2__c = :  System.Label.APTS_Print_Product_Family 
                         OR li.Apttus_Config2__ProductId__r.APTS_Cat_L2__c =: System.Label.APTS_Proview_Product_Family)) 
                         from Apttus_Config2__ProductConfiguration__c 
                         where Apttus_Config2__ProductConfiguration__c.Apttus_QPConfig__Proposald__c=:Id WITH SECURITY_ENFORCED];           
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
     
     public String getOwnerName() {
         if(quoteProposal != null) {
             return quoteProposal.Owner.Name;
         } else {
             return '';
         }    
     }
     
     //SOC-5720 AND SOC-6588 Added by CG overriding currentholdings value from product config  
     public String getCurrentNetPrice() {
         String retPrice='';
         if(productConfiguration.APTS_Current_Holdings__c != NULL){
         currentNetPrice = productConfiguration.APTS_Current_Holdings__c;
         }else{
             currentNetPrice = 0;
         }
         /*if(currentOnlineSoftwareList != null && currentOnlineSoftwareList.size() >0) {
             currentNetPrice = 0;
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList) {
                 if(asl.Apttus_Config2__NetPrice__c != null) {
                     currentNetPrice = currentNetPrice + asl.Apttus_Config2__NetPrice__c;
                 }
             }
         }*/

         Decimal num = currentNetPrice.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3 
         retPrice=isCanada ? ('CAD ' + String.valueOf(num.format())) : ('USD ' + String.valueOf(num.format())); //DOC 331 Added By Poonam Garg
         return retPrice;
     }
     
   //Added following changes based on Approval Dashboard fixes for DOC-10261 by Rishi
     public String getCurrentNetPriceTax() {
         String retPrice='';
         system.debug('Value of Tax Current Holding ='+productConfiguration.APTS_Tax_Current_Holdings__c);
         if(productConfiguration.APTS_Tax_Current_Holdings__c != NULL){
         currentNetPriceTax = productConfiguration.APTS_Tax_Current_Holdings__c;
         }else{
             currentNetPriceTax = 0;
         }
         Decimal num = currentNetPriceTax.setScale(2,System.RoundingMode.HALF_UP);
         retPrice=isTax ? ('USD $' + String.valueOf(num.format())) :'0' ; 
         system.debug('Tax currentNetPriceTax = '+currentNetPriceTax);
         return retPrice;
     }
   
     public String getCurrentOnlineSpendPrice() {
         String retPrice='';
         if(currentOnlineSoftwareList != null && currentOnlineSoftwareList.size() >0) {
             CurrentOnlineSpendPrice = 0;
             for(Apttus_Config2__AssetLineItem__c cosl : currentOnlineSoftwareList) {
                 if(cosl.Apttus_Config2__NetPrice__c != null) {
                     CurrentOnlineSpendPrice = CurrentOnlineSpendPrice + cosl.Apttus_Config2__NetPrice__c;
                 }
             }
         }
         Decimal num = CurrentOnlineSpendPrice.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         retPrice=isCanada ? ('CAD $ ' + String.valueOf(num)) : ('USD $ ' + String.valueOf(num)); //DOC 331 Added By Poonam Garg
         return retPrice;
     }
     
     //added by ssuri@apttus on 26-july-2017 Starts
     public String getCurrentBand() {
         if(assetLineItem != null && assetLineItem.size() >0) {
             CurrentBand = 0;
             for(Apttus_Config2__AssetLineItem__c asl : assetLineItem) {
                 if(asl.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c != null) {
                     CurrentBand = asl.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c;
                 }
             }
         }
         return (String.valueOf(CurrentBand));
     }
     
     public String getAttorneyBand() {
         if( lineItem!= null && lineItem.size() >0) {
             AttorneyBand = 0;
             for(Apttus_Config2__LineItem__c li : lineItem) {
                 if(li.Apttus_Config2__PriceUom__c != null && li.Apttus_Config2__PriceUom__c=='Attorneys' && li.Apttus_Config2__LineStatus__c=='New') {
                     AttorneyBand = li.Apttus_Config2__Quantity__c.setScale(0);
                 }
             }
         }
         return (String.valueOf(AttorneyBand));
     }
     
      
     
     //added by ssuri@apttus on 26-july-2017 ends
     private void setCurrentNetPriceTCV() {
         currentNetPriceTCV = 0;
         if(currentTCVList != null && currentTCVList.size() >0) {
             for(Apttus_Config2__AssetLineItem__c asl : currentTCVList) {
                 if(asl.Apttus_Config2__NetPrice__c != null) {
                     currentNetPriceTCV = currentNetPriceTCV + asl.Apttus_Config2__NetPrice__c;
                 }
             }
         }
     }
     
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
     
      public String getProposedNetPrice() {         
         proposedNetPrice = 0;            
         Decimal cartPrice= 0;
         Decimal renewalPrice= 0;                           
         //Decimal lapsedProdPrice = 0; 
         Decimal totalAssetNetPrice =0; 
         Decimal totalrenewcancelNetPrice =0;
         Decimal totalAssetlineNetPrice =0;
         Decimal totalAmendNetPrice =0;
         Decimal yoyPercent = 0;
         //Map<Apttus_Config2__AssetLineItem__c ,Boolean> assetMap = new  Map<Apttus_Config2__AssetLineItem__c,Boolean>();                            
         if(proposedOnlineSoftwareList != null && proposedOnlineSoftwareList.size() > 0){                          
             for(Apttus_Config2__LineItem__c li : proposedOnlineSoftwareList) { 
                     System.Debug('totalAssetNetPrice'+li.APTS_is_Primary_in_Bundle__c);                
                     if(li.Apttus_Config2__LineStatus__c == 'New' && li.Apttus_Config2__NetPrice__c!=null && ((li.APTS_is_Primary_in_Bundle__c==true && li.APTS_Bundle__c !=null) || (li.APTS_is_Primary_in_Bundle__c ==false && li.APTS_Bundle__c ==null))){
                         System.Debug('totalAssetNetPrice'+li.APTS_is_Primary_in_Bundle__c);
                         cartPrice= cartPrice+li.Apttus_Config2__NetPrice__c ;
                     }
                     if(li.Apttus_Config2__LineStatus__c == 'Amended' && li.Apttus_Config2__NetPrice__c!=null && li.APTS_is_Primary_in_Bundle__c==true){
                          totalAmendNetPrice  = totalAmendNetPrice +li.Apttus_Config2__NetPrice__c;
                          //li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c);
                          cartLinesProposednet.add(li);
                          System.debug('Inside if'+totalAmendNetPrice);      
                     }                                          
                     if(li.Apttus_Config2__NetPrice__c != null && li.Apttus_Config2__LineStatus__c == 'Renewed') {
                     if(li.APTS_Years_2_Plus_Adjustment__c!=null && li.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US'){
                         yoyPercent = (Decimal.valueOf(li.APTS_Years_2_Plus_Adjustment__c))/100;
                     }
                     else if(li.Apttus_Config2__LineStatus__c == 'Renewed' && li.APTS_Yr_1_Renewal_Adjustment__c!=null){
                         yoyPercent = (Decimal.valueOf(li.APTS_Yr_1_Renewal_Adjustment__c))/100;
                     }
                     else{
                         yoyPercent = 0;
                     }   System.Debug('yoyPercent'+yoyPercent);
                   System.Debug('totalrenewcancelNetPrice'+li.Apttus_Config2__NetPrice__c);
                         /*renewalPrice = renewalPrice+(yoyPercent*li.Apttus_Config2__NetPrice__c);
                         renewalPrice = renewalPrice + li.Apttus_Config2__NetPrice__c;*/
                         renewalPrice += li.Apttus_Config2__NetPrice__c + (yoyPercent*li.Apttus_Config2__NetPrice__c);
                         cartLinesProposednet.add(li); 
                     }                                         
                     if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){                         
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
                                  system.debug(lines.Apttus_Config2__AssetLineItemId__c);
                                       system.debug(asl.id);
                                       
                                 if(lines.Apttus_Config2__AssetLineItemId__c==asl.id && lines.Apttus_Config2__LineStatus__c!='Amended'){
                                       system.debug('Matched');
                                       totalrenewcancelNetPrice = totalrenewcancelNetPrice + asl.Apttus_Config2__NetPrice__c;                                        
                                       break;
                                   }
                                   if(lines.Apttus_Config2__AssetLineItemId__c==asl.id && lines.Apttus_Config2__LineStatus__c=='Amended' && lines.APTS_is_Primary_in_Bundle__c==true){
                                       totalrenewcancelNetPrice = totalrenewcancelNetPrice + asl.Apttus_Config2__NetPrice__c; 
                                       System.debug('Inside if'+totalrenewcancelNetPrice);                                        
                                       break;
                                   }
                                 }                                                         
                         }
                      } 
                    }                 
                   
                   totalAssetlineNetPrice = totalAssetNetPrice -totalrenewcancelNetPrice;
                   System.Debug('totalAssetNetPrice'+totalAssetNetPrice );
                   System.Debug('totalrenewcancelNetPrice'+totalrenewcancelNetPrice );
                  // System.Debug('totalAssetlineNetPrice'+totalAssetlineNetPrice);
             }
             
         proposedNetPrice = cartPrice+totalAmendNetPrice+renewalPrice + totalAssetlineNetPrice;         
         Decimal num = proposedNetPrice.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         return ('USD $' + String.valueOf(num)); //SOC-5938
     }
     
   //Added following changes based on Approval Dashboard fixes for DOC-10261 by Rishi
     public String getProposedNetPriceTax() {
         
         String retPrice='';
         proposedNetPriceTax = 0;             
         Decimal newOnlineSoftNetPriceTax = 0;
         Decimal currentOnlineNetPriceTax = 0;
         Decimal lapsedProdPriceTax = 0;
         Decimal incrementalRevInstallProdTax = 0;
         Decimal yoyPercentTax = 0;
         
         if(productConfiguration!=null){
             System.Debug('Kh***GPNT APTS_Tax_New_Holdings__c===>'+productConfiguration.APTS_Tax_New_Holdings__c);
             System.Debug('Kh***GPNT APTS_Tax_Current_Holdings__c===>'+productConfiguration.APTS_Tax_Current_Holdings__c);//1770
             System.Debug('Kh***GPNT APTS_Tax_Lapsed_Holdings__c===>'+productConfiguration.APTS_Tax_Lapsed_Holdings__c);
             newOnlineSoftNetPriceTax = productConfiguration.APTS_Tax_New_Holdings__c!=null ? productConfiguration.APTS_Tax_New_Holdings__c : 0;
             currentOnlineNetPriceTax = productConfiguration.APTS_Tax_Current_Holdings__c!=null ? productConfiguration.APTS_Tax_Current_Holdings__c : 0;
             lapsedProdPriceTax = productConfiguration.APTS_Tax_Lapsed_Holdings__c!=null ? productConfiguration.APTS_Tax_Lapsed_Holdings__c : 0;
         }
         //Incremental Growth for all renewed Online/Software Products 
         System.Debug('Kh***GPNT proposedOnlineSoftwareList SIZE===>'+proposedOnlineSoftwareList.size());
         System.Debug('Kh***GPNT proposedOnlineSoftwareList===>'+ proposedOnlineSoftwareList);
         System.Debug('Kh***GPNT newOnlineSoftNetPrice===>'+ newOnlineSoftNetPriceTax);//0
         System.Debug('Kh***GPNT currentOnlineNetPrice===>'+ currentOnlineNetPriceTax);//1770
         System.Debug('Kh***GPNT lapsedProdPrice===>'+ lapsedProdPriceTax);//0
         if(proposedOnlineSoftwareList != null && proposedOnlineSoftwareList.size() > 0){  
             for(Apttus_Config2__LineItem__c li : proposedOnlineSoftwareList) {
                 System.Debug('Kh***GPNT li.Apttus_Config2__NetPrice__c===>'+li.Apttus_Config2__NetUnitPrice__c);//1770
                 if(li.Apttus_Config2__NetUnitPrice__c != null ) {
                     if(li.Apttus_Config2__LineStatus__c == 'Renewed' && li.APTS_Yr_1_Renewal_Adjustment__c!=null){
                         yoyPercentTax = (Decimal.valueOf(li.APTS_Yr_1_Renewal_Adjustment__c))/100;
                     }
                     else{
                         yoyPercentTax = 0;
                     }
                     incrementalRevInstallProdTax = incrementalRevInstallProdTax + (yoyPercentTax*li.Apttus_Config2__NetUnitPrice__c);
                 }
             } 
         }
         System.Debug('Kh***GPNT currentOnlineNetPrice===>'+currentOnlineNetPriceTax);//1770
         System.Debug('Kh***GPNT incrementalRevInstallProd ===>'+incrementalRevInstallProdTax);
         System.Debug('Kh***GPNT newOnlineSoftNetPrice===>'+newOnlineSoftNetPriceTax);
         System.Debug('Kh***GPNT lapsedProdPrice===>'+lapsedProdPriceTax);
         proposedNetPriceTax = ((currentOnlineNetPriceTax + incrementalRevInstallProdTax + newOnlineSoftNetPriceTax) - lapsedProdPriceTax);
         System.debug('Kh***GPNT currentOnlineNetPriceTax '+currentOnlineNetPriceTax+' incrementalRevInstallProdTax '+incrementalRevInstallProdTax+' newOnlineSoftNetPriceTax '+newOnlineSoftNetPriceTax +' lapsedProdPriceTax '+lapsedProdPriceTax);
         Decimal num = proposedNetPriceTax.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         retPrice=isTax ? ('USD $ ' + String.valueOf(num.format())) : '0'; //DOC 331 Added By Poonam Garg
         return retPrice;
     }
   
     public String getCurrentAttorneysTotal() {
         currentTotalAttorneys = 0;
         if(assetLineItem != null && assetLineItem.size() >0) {
             for(Apttus_Config2__AssetLineItem__c asl : assetLineItem) {
                /* if(asl.APTS_Number_of_Attorneys__c != null) {
                     currentTotalAttorneys = currentTotalAttorneys + asl.APTS_Number_of_Attorneys__c;
                 }*/
                if(asl.APTS_SSD_Sold_To__c!= null) {
                        if(asl.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c!=null){
                        currentTotalAttorneys = asl.APTS_SSD_Sold_To__r.LCRM_APTS_Band_Number__c;}
                }
             }
         } 
         return (String.valueOf(currentTotalAttorneys.format()));
     }
     
    public String getProposedAttorneysTotal() {
         proposedTotalAttorneys = 0;
        if(lineItem != null && lineItem.size() >0) {
            for(Apttus_Config2__LineItem__c li : lineItem) {
                 /*if(li.APTS_Number_of_Attorneys__c != null ) {
                     proposedTotalAttorneys = proposedTotalAttorneys + li.APTS_Number_of_Attorneys__c;*/
                if(li.Apttus_Config2__PriceUom__c != null && li.Apttus_Config2__PriceUom__c=='Attorneys' && (li.Apttus_Config2__LineStatus__c=='New' || li.Apttus_Config2__LineStatus__c=='Amended' || li.Apttus_Config2__LineStatus__c=='Renewed'))//Added as part of Change 4
                {
                     proposedTotalAttorneys=li.Apttus_Config2__Quantity__c;//Updated by ssuri@apttus.com on 28-july-2017 as discussed on Call with Mark
                }                
            }
        }
         return (String.valueOf(proposedTotalAttorneys.format()));
    }
     
     public String getCurrentRPA() {
         String retPrice='';
         if(currentNetPrice == 0) {
             getCurrentNetPrice();
         }
         if(currentTotalAttorneys == 0) {
             getCurrentAttorneysTotal();
         }
         
         Decimal rpa = (currentTotalAttorneys == 0 ? 0 : (currentNetPrice/currentTotalAttorneys));
         Decimal num = rpa.setScale(2,System.RoundingMode.HALF_UP);//Rounding added as part of Approval dashboard changes Aug 11th 2017, Neeharika Upadrasta 
         retPrice=isCanada ? ('CAD $ ' + String.valueOf(num)) : ('USD $ ' + String.valueOf(num)); //DOC 331 Added By Poonam Garg
         return retPrice;
     }
     
     public String getProposedRPA() {
         String retPrice='';
         if(proposedNetPrice == 0) {
             getProposedNetPrice();
         }
         if(proposedTotalAttorneys == 0) {
             getProposedAttorneysTotal();
         }
         
         Decimal rpa = (proposedTotalAttorneys == 0 ? 0 : (proposedNetPrice/proposedTotalAttorneys));
         Decimal num = rpa.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         retPrice=isCanada ? ('CAD $ ' + String.valueOf(num)) : ('USD $ ' + String.valueOf(num)); //DOC 331 Added By Poonam Garg
         return retPrice;
     }
     
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
     
     public String getCurrentDiscount() {
         currentDiscount = 0;
         totalAssetNetPrice = 0;
         totalAssetListPrice = 0;
         //Commented as part of Approval dashboard changes Aug 11th 2017, Neeharika Upadrasta
     System.Debug('Kh***GCDcurrentOnlineSoftwareList.size==>'+ currentOnlineSoftwareList.size());
         System.Debug('Kh***GCDcurrentOnlineSoftwareList==>'+ currentOnlineSoftwareList);
         System.Debug('Kh***GCDbTaxCurrentDiscountCalc==>'+ bTaxCurrentDiscountCalc);
         if((currentOnlineSoftwareList != null && currentOnlineSoftwareList.size() >0)
            || (bTaxCurrentDiscountCalc == true && currentOnlineSoftwareList != null && currentOnlineSoftwareList.size() >0)) 
         {
         // currentOnlineSoftwareList
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList) 
       {
                     System.Debug('Kh***GCD isTax==>'+ isTax);
           System.Debug('Kh***GCD asl.Apttus_Config2__ListPrice__c==>'+ asl.Apttus_Config2__ListPrice__c);
           System.Debug('Kh***GCD asl.Apttus_Config2__BasePriceMethod__c==>'+ asl.Apttus_Config2__BasePriceMethod__c);
           /*Code added by Khushboo Vaidya as part of DOC-10261 Standalone prod starts*/
           if(isTax && asl.Apttus_Config2__ListPrice__c!=null && asl.Apttus_Config2__BasePriceMethod__c != null)
           {
            if(asl.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
            {
              totalAssetListPrice = totalAssetListPrice + (asl.Apttus_Config2__ListPrice__c); 
            }
            else if (asl.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
            {
              totalAssetListPrice = totalAssetListPrice + (asl.Apttus_Config2__ListPrice__c * asl.Apttus_Config2__Quantity__c);
            }
           }
           else if(!isTax && asl.Apttus_Config2__ListPrice__c!=null)
             {
                         totalAssetListPrice = totalAssetListPrice + (asl.Apttus_Config2__ListPrice__c * asl.Apttus_Config2__Quantity__c); //SOC-7761
           }
                     /*Code added by Khushboo Vaidya as part of DOC-10261 Standalone prod ends */
           
           /*Code added by Khushboo Vaidya as part of DOC-10261 for Tax Professional changes starts*/ 
           if(isTax && asl.Apttus_Config2__NetUnitPrice__c!=null && asl.Apttus_Config2__BasePriceMethod__c != null )
           {
            System.Debug('Kh***GCD Asset Apttus_Config2__NetUnitPrice__c==>'+ asl.Apttus_Config2__NetUnitPrice__c);
            System.Debug('Kh***GCD Asset asl.Apttus_Config2__BasePriceMethod__c==>'+ asl.Apttus_Config2__BasePriceMethod__c);
            if(asl.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
            {
              totalAssetNetPrice = totalAssetNetPrice + asl.Apttus_Config2__NetUnitPrice__c;
            }
            else if (asl.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
            {
              totalAssetNetPrice = totalAssetNetPrice + (asl.Apttus_Config2__NetUnitPrice__c * asl.Apttus_Config2__Quantity__c);
            }
           }
           else if(!isTax && asl.Apttus_Config2__NetPrice__c!=null)
           {
                         totalAssetNetPrice = totalAssetNetPrice + asl.Apttus_Config2__NetPrice__c;
           }
           /*Code added by Khushboo Vaidya as part of DOC-10261 for Tax Professional changes ends*/ 
                     System.Debug('Kh***GCD Asset totalAssetNetPrice==>'+ totalAssetNetPrice);                    
                     /*if(asl.APTS_Discount_Percent_Retail__c == null) {
                         currentDiscount = currentDiscount + (getCurrentMaterialWeight(asl) * 0);
                     } else {
                         currentDiscount = currentDiscount + ((getCurrentMaterialWeight(asl) * asl.APTS_Discount_Percent_Retail__c)/100); 
                     }*/ //Commented as part of Change 7
             }
         }
         //Decimal num = currentDiscount.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3 //Commented as part of Change 7
     System.debug('Kh***GCD totalAssetListPrice==> '+totalAssetListPrice+' totalAssetNetPrice ===>'+totalAssetNetPrice);
         if(totalAssetListPrice!=0) {
            currentDiscount = ((totalAssetListPrice - totalAssetNetPrice )/totalAssetListPrice)*100; //Added as part of Change 
         }
     System.Debug('Kh***GCD currentDiscount==>'+ currentDiscount); 
     
        //SOC-5938
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
     
     public String getProposedDiscount() {
         proposedDiscount = 0;
         Decimal newProductDiscount = 0;
         Decimal totalLineNetPrice = 0;//Added as Change 7
         Decimal totalLineListPrice = 0;//Added as Change 7
         Decimal cancelledListPrice = 0;//Added as Change 7
         Decimal cancelledNetPrice = 0;//Added as Change 8
         Decimal cartNetPrice = 0;
         Decimal yoyPercent = 0;
         Decimal cartListPrice = 0;
         Decimal totalAmendNetdisPrice = 0;
         Decimal totalAmendListdisPrice = 0;
         Decimal renewalNetPrice = 0;
         Decimal renewalListPrice = 0;
         Decimal totalAssetNetdisPrice = 0;
         Decimal totalAssetListdisPrice = 0;
         Decimal totalrenewcancelNetdisPrice = 0;
         Decimal totalrenewcancelListdisPrice = 0;
         Decimal totalcartNetPrice = 0;
         Decimal totalcartListPrice = 0;
         if(isTax){
         if(lineItem != null && lineItem.size() >0 || (bTaxProposedDiscountCalc == true && lineItem != null && lineItem.size() >0 
            && proposedOnlineSoftwareList != null & proposedOnlineSoftwareList.size() > 0)) 
        {
            // for(Apttus_Config2__LineItem__c li : lineItem) //Commented out by ssuri@apttus.com after 3rd-Aug-2017 Call with Mark
                for(Apttus_Config2__LineItem__c li : proposedOnlineSoftwareList) {// added by ssuri@apttus.com on 4th-Aug-2017
                    if(li.Apttus_Config2__LineStatus__c!='Renewed'){
                        system.debug('#### li.Apttus_Config2__LineStatus__c'+li.Apttus_Config2__LineStatus__c);
                       if(li.Apttus_Config2__LineStatus__c =='Cancelled'){
                           /*Code added by Khushboo Vaidya as part of DOC-10261 Standalone prod starts*/
                           if(isTax && li.Apttus_Config2__ListPrice__c !=null && li.Apttus_Config2__BasePriceMethod__c != null)   
                           {
                               System.Debug('Kh***GPD ELSE li.Apttus_Config2__NetUnitPrice__c==>'+ li.Apttus_Config2__NetUnitPrice__c);
                               if(li.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
                               {
                                   cancelledListPrice = cancelledListPrice + li.Apttus_Config2__ListPrice__c; 
                               }
                               else if (li.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
                               {
                                   cancelledListPrice = cancelledListPrice + (li.Apttus_Config2__ListPrice__c * li.Apttus_Config2__Quantity__c);
                               }
                           }
                           else if(!isTax && li.Apttus_Config2__ListPrice__c!=null)
                           {
                               cancelledListPrice = cancelledListPrice + li.Apttus_Config2__ListPrice__c;
                           }
                           /*Code added by Khushboo Vaidya as part of DOC-10261 Standalone prod ends*/     
                           System.Debug('Kh***GPDAsset s Net price==>'+ li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c);
                           
                           /*Code added by Khushboo Vaidya as part of DOC-10261 Standalone prod starts*/
                           if(isTax && li.Apttus_Config2__ListPrice__c !=null && li.Apttus_Config2__BasePriceMethod__c != null)   
                           {
                               System.Debug('Kh***GPD ELSE li.Apttus_Config2__NetUnitPrice__c==>'+ li.Apttus_Config2__NetUnitPrice__c);
                               if(li.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
                               {
                                   cancelledNetPrice = cancelledNetPrice + li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c; 
                               }
                               else if (li.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
                               {
                                   cancelledNetPrice = cancelledNetPrice + (li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c* li.Apttus_Config2__Quantity__c);
                               }
                           }
                           else if(li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c!=null)
                           {
                                cancelledNetPrice = cancelledNetPrice + li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c;
                           }
                           /*Code added by Khushboo Vaidya as part of DOC-10261 Standalone prod ends*/ 
                       }
                       else{
                           System.Debug('Kh***GPD ELSE li.Apttus_Config2__ListPrice__c==>'+ li.Apttus_Config2__ListPrice__c);
                           System.Debug('Kh***GPD ELSE li.Apttus_Config2__SellingTerm__c==>'+ li.Apttus_Config2__SellingTerm__c);
                           /*Code added by Khushboo Vaidya as part of DOC-10261 Standalone prod starts*/
                           if(isTax && li.Apttus_Config2__ListPrice__c !=null && li.Apttus_Config2__BasePriceMethod__c != null)   
                           {
                               System.Debug('Kh***GPD ELSE li.Apttus_Config2__NetUnitPrice__c==>'+ li.Apttus_Config2__NetUnitPrice__c);
                               if(li.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
                               {
                                   totalLineListPrice = totalLineListPrice + (li.Apttus_Config2__ListPrice__c ); //57
                               }
                               else if (li.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
                               {
                                   totalLineListPrice = totalLineListPrice + (li.Apttus_Config2__ListPrice__c * li.Apttus_Config2__Quantity__c);
                               }
                           }
                           else if (!isTax && li.Apttus_Config2__ListPrice__c !=null)
                           {
                               //SOC-7761 Added  * Quantity by Chirag 8/28/2018
                               totalLineListPrice = totalLineListPrice + li.Apttus_Config2__ListPrice__c;
                           }
                           
                           System.Debug('Kh***GPD ELSE totalLineListPrice==>'+ totalLineListPrice);
                           System.Debug('Kh***GPD ELSE isTax==>'+ isTax);
                           System.Debug('Kh***GPD ELSE li.Apttus_Config2__NetUnitPrice__c==>'+ li.Apttus_Config2__NetUnitPrice__c);
                           /*Code added by Khushboo Vaidya as part of DOC-10261 for Tax Professional changes starts*/
                           if(isTax && li.Apttus_Config2__NetUnitPrice__c!=null && li.Apttus_Config2__BasePriceMethod__c != null)   
                           {
                               System.Debug('Kh***GPD ELSE li.Apttus_Config2__BasePriceMethod__c==>'+ li.Apttus_Config2__BasePriceMethod__c);
                               
                               if(li.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Flat Price'))
                               {
                                   totalLineNetPrice = totalLineNetPrice + li.Apttus_Config2__NetUnitPrice__c;//57
                               }
                               else if (li.Apttus_Config2__BasePriceMethod__c.equalsIgnoreCase('Per Unit'))
                               {
                                   totalLineNetPrice = totalLineNetPrice + (li.Apttus_Config2__NetUnitPrice__c * li.Apttus_Config2__Quantity__c);
                               }
                           }
                           else if(!isTax && li.Apttus_Config2__NetPrice__c!=null)
                           {
                               System.Debug('Kh***GPD ELSE li.Apttus_Config2__NetPrice__c==>'+ li.Apttus_Config2__NetPrice__c);
                               totalLineNetPrice = totalLineNetPrice + li.Apttus_Config2__NetPrice__c;
                           }      
                           /*Code added by Khushboo Vaidya as part of DOC-10261 for Tax Professional changes ends*/
                           System.Debug('Kh***GPD ELSE totalLineNetPrice==>'+ totalLineNetPrice);                                              
                      }
                               
                    } 
             }
             totalLineListPrice = totalLineListPrice - cancelledListPrice;
             totalLineNetPrice = totalLineNetPrice - cancelledNetPrice;
         }
         System.debug('totalLineListPrice '+totalLineListPrice+' totalAssetListPrice '+totalAssetListPrice+' totalLineNetPrice '+totalLineNetPrice+' totalAssetNetPrice '+totalAssetNetPrice);
         if((totalLineListPrice+totalAssetListPrice)!=0) {
             proposedDiscount = ((totalLineListPrice+totalAssetListPrice) - (totalLineNetPrice+totalAssetNetPrice))/(totalLineListPrice+totalAssetListPrice);
             proposedDiscount = proposedDiscount * 100;
         }
        }
        else{
            if(proposedOnlineSoftwareList != null && proposedOnlineSoftwareList.size() > 0){                          
             for(Apttus_Config2__LineItem__c li : proposedOnlineSoftwareList) { 
                     System.Debug('totalAssetNetPrice'+li.APTS_is_Primary_in_Bundle__c);                
                     if(li.Apttus_Config2__LineStatus__c == 'New' && li.Apttus_Config2__NetPrice__c!=null && li.Apttus_Config2__ListPrice__c!=null && ((li.APTS_is_Primary_in_Bundle__c==true && li.APTS_Bundle__c !=null) || (li.APTS_is_Primary_in_Bundle__c ==false && li.APTS_Bundle__c ==null))){
                         System.Debug('totalAssetNetPrice'+li.APTS_is_Primary_in_Bundle__c);
                         cartNetPrice = cartNetPrice+li.Apttus_Config2__NetPrice__c ;
                         cartListPrice = cartListPrice + li.Apttus_Config2__ListPrice__c ;
                     }
                     if(li.Apttus_Config2__LineStatus__c == 'Amended' && li.Apttus_Config2__NetPrice__c!=null && li.APTS_is_Primary_in_Bundle__c==true && li.Apttus_Config2__ListPrice__c!=null){
                          totalAmendNetdisPrice  = totalAmendNetdisPrice +li.Apttus_Config2__NetPrice__c;
                          totalAmendListdisPrice  = totalAmendListdisPrice +li.Apttus_Config2__ListPrice__c;
                          //li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c);
                          cartLinesProposeddis.add(li);
                          System.debug('Inside if'+totalAmendListdisPrice );      
                     }                                          
                     if(li.Apttus_Config2__NetPrice__c != null && li.Apttus_Config2__LineStatus__c == 'Renewed' && li.Apttus_Config2__ListPrice__c!=null) {
                     if(li.APTS_Years_2_Plus_Adjustment__c!=null && li.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US'){
                         yoyPercent = (Decimal.valueOf(li.APTS_Years_2_Plus_Adjustment__c))/100;
                     }
                     else if(li.Apttus_Config2__LineStatus__c == 'Renewed' && li.APTS_Yr_1_Renewal_Adjustment__c!=null){
                         yoyPercent = (Decimal.valueOf(li.APTS_Yr_1_Renewal_Adjustment__c))/100;
                     }
                     else{
                         yoyPercent = 0;
                     }   System.Debug('yoyPercent'+yoyPercent);
                   System.Debug('totalrenewcancelNetPrice'+li.Apttus_Config2__NetPrice__c);
                         renewalNetPrice = renewalNetPrice+(yoyPercent*li.Apttus_Config2__NetPrice__c);
                         renewalNetPrice = renewalNetPrice + li.Apttus_Config2__NetPrice__c;
                         renewalListPrice = renewalListPrice+(yoyPercent*li.Apttus_Config2__ListPrice__c);
                         renewalListPrice = renewalListPrice+li.Apttus_Config2__ListPrice__c;
                         cartLinesProposeddis.add(li); 
                     }                                         
                     if(li.Apttus_Config2__LineStatus__c == 'Cancelled'){                         
                         cartLinesProposeddis.add(li);
                        }
                     
             }          
                totalcartNetPrice = totalcartNetPrice+cartNetPrice+totalAmendNetdisPrice+renewalNetPrice;
                totalcartListPrice = totalcartListPrice +cartListPrice+totalAmendListdisPrice+renewalListPrice;
                
         }         
         if(currentOnlineSoftwareList!= null && currentOnlineSoftwareList.size() > 0){ 
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList) {
                     if(asl.Apttus_Config2__NetPrice__c!=null && asl.Apttus_Config2__ListPrice__c!=null){ 
                         totalAssetNetdisPrice = totalAssetNetdisPrice + asl.Apttus_Config2__NetPrice__c; 
                         totalAssetListdisPrice = totalAssetListdisPrice + asl.Apttus_Config2__ListPrice__c; 
                         System.Debug('totalAssetNetdisPrice '+totalAssetNetdisPrice );
                         if(cartLinesProposeddis!=null && cartLinesProposeddis.size() > 0) {                       
                         for(Apttus_Config2__LineItem__c lines : cartLinesProposeddis){                      
                              
                                 if(lines.Apttus_Config2__AssetLineItemId__c==asl.id && lines.Apttus_Config2__LineStatus__c!='Amended'){
                                       totalrenewcancelNetdisPrice = totalrenewcancelNetdisPrice + asl.Apttus_Config2__NetPrice__c;totalrenewcancelListdisPrice = totalrenewcancelListdisPrice + asl.Apttus_Config2__ListPrice__c;
                                       break;
                                   }
                                   if(lines.Apttus_Config2__AssetLineItemId__c==asl.id && lines.Apttus_Config2__LineStatus__c=='Amended' && lines.APTS_is_Primary_in_Bundle__c==true){
                                       totalrenewcancelNetdisPrice = totalrenewcancelNetdisPrice + asl.Apttus_Config2__NetPrice__c; 
                                       totalrenewcancelListdisPrice = totalrenewcancelListdisPrice + asl.Apttus_Config2__ListPrice__c;
                                       System.debug('Inside if'+totalrenewcancelNetdisPrice);                                        
                                       break;
                                   }
                                 }                                                         
                         }
                      } 
                    }                 
                   System.Debug('totalAssetNetdisPrice '+totalAssetNetdisPrice );
                   System.Debug('totalrenewcancelNetdisPrice'+totalrenewcancelNetdisPrice);
                   totalAssetNetdisPrice = totalAssetNetdisPrice -totalrenewcancelNetdisPrice;
                   totalAssetListdisPrice = totalAssetListdisPrice - totalrenewcancelListdisPrice;
                   System.Debug('totalAssetNetdisPrice '+totalAssetNetdisPrice );
                   System.Debug('totalAssetListdisPrice '+totalAssetListdisPrice );
                  // System.Debug('totalAssetlineNetPrice'+totalAssetlineNetPrice);
             }
             
             if(totalAssetListdisPrice+totalcartListPrice!=0){
                 proposedDiscount = ((totalcartListPrice+totalAssetListdisPrice) - (totalcartNetPrice+totalAssetNetdisPrice))/(totalAssetListdisPrice+totalcartListPrice);
                proposedDiscount = proposedDiscount * 100;

             }
        }
           
         System.debug('proposedDiscount  '+proposedDiscount);
         //proposedDiscount = (currentDiscount + newProductDiscount)*100;
         Decimal num = proposedDiscount.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
        String output = String.valueOf(num) + '%'; //SOC-5938
        return output;
     }
     
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
     
     public String getDiscountChange() {
         
         Decimal num = (proposedDiscount - currentDiscount).setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
         return (String.valueOf(num) + '%');
     }
     
     public String getOverallDiscountChange() {
         //Commented as part of Approval dashboard changes Aug 11th 2017, Neeharika Upadrasta
         //Overall_DiscountChange = (proposedOverallDiscount - currentOverallDiscount)*100;
         Overall_DiscountChange = 0;
         Decimal num = Overall_DiscountChange.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
        return (String.valueOf(num) + '%'); //SOC-5938
     }
     
     public String getCurrentACV() {
         String retPrice='';
         //Uncommented as part of Approval dashboard changes Aug 11th 2017, Neeharika Upadrasta 
         currentACV =getYearlyPrice(currentNetPrice ,billingFrequency); 
         Decimal num = currentACV.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         retPrice=isCanada ? ('CAD $ ' + String.valueOf(num)) : ('USD $ ' + String.valueOf(num)); //DOC 331 Added By Poonam Garg
         return retPrice; 
     }
     
     public String getProposedACV() {
         String retPrice='';
         proposedACV =getYearlyPrice(proposedNetPrice ,billingFrequency); 
         
         Decimal num = proposedACV.setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
         retPrice=isCanada ? ('CAD $ ' + String.valueOf(num)) : ('USD $ ' + String.valueOf(num)); //DOC 331 Added By Poonam Garg
         return retPrice;
     }
     
   /*DOC-10825*/
     public String getProposedACVTax() {         
         proposedACVTax = 0;         
         Decimal calculatedYearPrice = 0;
         String retPrice='';   
         if(proposedOnlineSoftwareList!= null && proposedOnlineSoftwareList.size() > 0) 
         {    
           for(Apttus_Config2__LineItem__c oLineitem : proposedOnlineSoftwareList)
            {
                System.Debug('Kh***TAXPTCV proposedOnlineSoftwareList==>'+proposedOnlineSoftwareList.size());
                System.Debug('Kh***TAXPTCV calculatedYearPrice==>'+calculatedYearPrice); 
                System.Debug('Kh***TAXPTCV APTS_Calculated_Year_1__c==>'+oLineitem.APTS_Calculated_Year_1__c);
                if(oLineitem.APTS_Calculated_Year_1__c != null)
                {
                  calculatedYearPrice = calculatedYearPrice + oLineitem.APTS_Calculated_Year_1__c;
                }
            } 
         }          
         proposedACVTax =proposedACVTax+calculatedYearPrice;
         proposedACVTax =  proposedACVTax+CurrentACV;
         System.debug('Kh***TAXPTCV calculatedYearPrice===>'+calculatedYearPrice);
         System.debug('Kh***TAXPTCV proposedTCV===>'+proposedACVTax );
         Decimal num = proposedACVTax.setScale(2,System.RoundingMode.HALF_UP);   
         retPrice=isTax ? ('USD $' + String.valueOf(num.format())) :'0' ; 
         return retPrice;
    }
     
   public String getIncrementalGrowthPer() {
         //for(){
        percentage = productConfiguration.APTS_Incremental_Growth__c ;
         //}
         //return percentage;
        Decimal num = percentage.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
        return (String.valueOf(num) + '%');         //SOC-5938         
     }
     
     public String getIncrementalGrowthDollor() {
         String retPrice='';
         decimal pert_age=productConfiguration.APTS_Incremental_Growth__c/100 ; 
         Decimal num = (pert_age*currentACV).setScale(2,System.RoundingMode.HALF_UP);//Added as part of Change 3
           // return ('USD $ ' + String.valueOf(num.format())); //SOC-5938
         retPrice=isCanada ? ('CAD $ ' + String.valueOf(num)) : ('USD $ ' + String.valueOf(num)); //DOC 331 Added By Poonam Garg
         return retPrice;
     }
     
     public String getIncrementalGrowthPercent() {
        Decimal percent =  (currentACV == 0 ? 0 : (((proposedACV - currentACV)/currentACV)*100));
        Decimal num = percent.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
        return (String.valueOf(num) + '%');//5938;         
     }
     
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
     
   //SOC-5932 by Prabhu Issac
     public String getCurrentTCV() {     
         String retPrice='';    
         if(currentOnlineSoftwareList!= null && currentOnlineSoftwareList.size() > 0) {             


             currentTCV = 0;
             Decimal contractValue = 0;
             Integer index=0;
             Date term = null;
             Integer remainingMonths =null;
             Date systemDate = null;
             Integer yOYPercent = 0;                 
             Decimal yOYValue = 0;  
             Decimal calculatedYearPrice;
             Decimal calculatedMonthlyPrice;                 
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList){     
                    String billingFrequency=asl.Apttus_Config2__BillingFrequency__c;
                 if(asl.APTS_Info_RenewalDate__c!=null){               
                     term = asl.APTS_Info_RenewalDate__c;                     
                     systemDate = Date.today(); 
                     if(term!=null){
                     remainingMonths = systemDate.monthsBetween(term); 
                    }
                     YOYValue = (4.6*100)/100;               
                     calculatedMonthlyPrice = asl.Apttus_Config2__NetPrice__c;  
                     if(remainingMonths <0){
                         currentTCV=currentTCV;
                     }                  
                     else if(remainingMonths < 12){                    
                     currentTCV=currentTCV+(asl.Apttus_Config2__NetPrice__c*remainingMonths);                     
                     }
                     
                     else if(remainingMonths == 12){                     
                     calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                     currentTCV=currentTCV+ getYearlyPrice(calculatedMonthlyPrice,billingFrequency);                     
                     } 
                     else if(remainingMonths > 12){                     
                     calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                     currentTCV=currentTCV+ getYearlyPrice(calculatedMonthlyPrice,billingFrequency);   
                     }  
                     Integer totalmonth=remainingMonths;                   
                     if(totalmonth-12>0){        
                        while(totalmonth-12>0)                
                        { 
                        Integer months=totalmonth-12;                        
                        if(months>12)
                         {
                        calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                        currentTCV=currentTCV+ getYearlyPrice(calculatedMonthlyPrice,billingFrequency);   
                        totalmonth=totalmonth-12;
                         }else{
                        currentTCV=currentTCV+ (asl.Apttus_Config2__NetPrice__c*months);                        
                        totalmonth=totalmonth-12;                        
                        }
                    }        
                }
                                
            }
       }

   }

         Decimal num = currentTCV.setScale(2,System.RoundingMode.HALF_UP);  
         retPrice=isCanada ? ('CAD $ ' + String.valueOf(num)) : ('USD $ ' + String.valueOf(num)); //DOC 331 Added By Poonam Garg
         return retPrice;
    }
     
   /*DOC-10825*/
     public String getCurrentTCVTax() {     
         String retPrice='';    
         if(bTaxCurrentTCVCalc == true && currentOnlineSoftwareList!= null && currentOnlineSoftwareList.size() > 0 )
         {             
             currentTCVTax = 0;
             Decimal contractValue = 0;
             Integer index=0;
             Date term = null;
             Integer remainingMonths =null;
             Date systemDate = null;
             Integer yOYPercent = 0;                 
             Decimal yOYValue = 0;  
             Decimal calculatedYearPrice;
             Decimal calculatedMonthlyPrice;                 
             for(Apttus_Config2__AssetLineItem__c asl : currentOnlineSoftwareList)
             {     
                String billingFrequency=asl.Apttus_Config2__BillingFrequency__c;
                 System.debug('Kh***CTCV asl.APTS_Info_RenewalDate__c===>'+asl.APTS_Info_RenewalDate__c); 
                 if(asl.APTS_Info_RenewalDate__c!=null)
                 {               
                     term = asl.APTS_Info_RenewalDate__c;                     
                     systemDate = Date.today(); 
                     if(term!=null){
                     remainingMonths = systemDate.monthsBetween(term); 
                 }
                 System.debug('Kh***CTCV remainingMonths===>'+remainingMonths); 
                 System.debug('Kh***CTCV Apttus_Config2__NetUnitPrice__c===>'+asl.Apttus_Config2__NetUnitPrice__c);  
                 
                 YOYValue = (4.6*100)/100; 
                 calculatedMonthlyPrice = asl.Apttus_Config2__NetPrice__c; 
                 System.debug('Kh***CTCV YOYValue===>'+YOYValue);   
                 System.debug('Kh***CTCV calculatedMonthlyPrice===>'+calculatedMonthlyPrice);  
                 
                 if(remainingMonths <0)
                 {
                    currentTCVTax=currentTCVTax;
                     System.debug('Kh***CTCV <0 currentTCVTax===>'+currentTCVTax);
                 }                  
                 else if(remainingMonths < 12)
                 {     
                    currentTCVTax=currentTCVTax+(asl.Apttus_Config2__NetUnitPrice__c*remainingMonths); 
                     System.debug('Kh***CTCV <12 currentTCVTax===>'+currentTCVTax);                    
                 } 
                 else if(remainingMonths == 12)
                 {                     
                    calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                     currentTCVTax=currentTCVTax+ getYearlyPrice(calculatedMonthlyPrice,billingFrequency); 
                     System.debug('Kh***CTCV =12 currentTCVTax===>'+currentTCVTax);                    
                 } 
                 else if(remainingMonths > 12)
                 {                     
                     calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                     currentTCVTax=currentTCVTax+ getYearlyPrice(calculatedMonthlyPrice,billingFrequency);
                     System.debug('Kh***CTCV >12 currentTCVTax===>'+currentTCVTax);   
                 }  
                
                 Integer totalmonth=remainingMonths;                   
                 if(totalmonth-12>0)
                 {        
                        System.debug('Kh***CTCV totalmonth===>'+totalmonth);
                        while(totalmonth-12>0)                
                        { 
                        Integer months=totalmonth-12; 
                        System.debug('Kh***CTCV months===>'+months);                       
                        if(months>12)
                         {
                            calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                            currentTCVTax=currentTCVTax+ getYearlyPrice(calculatedMonthlyPrice,billingFrequency);   
                            totalmonth=totalmonth-12;
                            System.debug('Kh***CTCV mONTHS>12 calculatedMonthlyPrice===>'+calculatedMonthlyPrice); 
                            System.debug('Kh***CTCV mONTHS>12 currentTCVTax===>'+currentTCVTax); 
                            System.debug('Kh***CTCV mONTHS>12 totalmonth===>'+totalmonth); 
                         }
                         else
                         {
                            currentTCVTax=currentTCVTax+ (asl.Apttus_Config2__NetUnitPrice__c*months);       
                            totalmonth=totalmonth-12;                        
                            System.debug('Kh***CTCV mONTHS>12 currentTCVTax===>'+currentTCVTax); 
                            System.debug('Kh***CTCV mONTHS>12 totalmonth===>'+totalmonth);
                         }
                    }        
                }
                                
            }
       }

      }

         Decimal num = currentTCVTax.setScale(2,System.RoundingMode.HALF_UP);  
         retPrice=isTax ? ('USD $' + String.valueOf(num.format())) :'0' ; 
         return retPrice;
    }
   
   //SOC-5932 by Prabhu Issac
   public String getProposedTCV() {         
         proposedTCV = 0;         
         Integer term = 0;         
         Integer yOYPercent = 0;


         Integer index=0;
         Integer renewYOYPercent = 0;
         Decimal renewYOYValue = 0;
         Decimal yOYValue = 0; 
         Decimal calculatedYearPrice;
         Decimal calculatedMonthlyPrice;  
         Date term1 = null;
         Date systemDate = null;
         Integer remainingMonths =null;
         Decimal lapseCalculatedYearPrice = 0; 
         String retPrice='';   
         if(proposedOnlineSoftwareList!= null && proposedOnlineSoftwareList.size() > 0) {    
         for(Apttus_Config2__LineItem__c proposedLi : proposedOnlineSoftwareList){
            System.Debug('proposedOnlineSoftwareList'+proposedLi.APTS_Info_RenewalDate__c); 
            String billingFrequency=proposedLi.Apttus_Config2__BillingFrequency__c;
            if(proposedLi.Apttus_Config2__LineStatus__c=='Cancelled' && proposedLi.APTS_Info_RenewalDate__c!=null){
               System.Debug('APTS_Info_RenewalDate__c'+proposedLi.APTS_Info_RenewalDate__c);  
               term1 = proposedLi.APTS_Info_RenewalDate__c;
               systemDate = Date.today(); 
                if(term1!=null){
                     remainingMonths = systemDate.monthsBetween(term1); 
                     System.Debug('remainingMonths '+remainingMonths);                     
                }
                YOYValue = (4.6*100)/100;               
                calculatedMonthlyPrice = proposedLi.APTS_Asset_Net_Price__c;                    
                if(remainingMonths<=12){                    
                     lapseCalculatedYearPrice=lapseCalculatedYearPrice+(proposedLi.APTS_Asset_Net_Price__c*remainingMonths);                     
                }
                else if(remainingMonths == 12){
                      calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                      //DOC 331 Added By Poonam Garg
                      
                      lapseCalculatedYearPrice=lapseCalculatedYearPrice + getYearlyPrice(calculatedMonthlyPrice,billingFrequency);
                 }
                 else if(remainingMonths > 12){                     
                     calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                     //DOC 331 Added By Poonam Garg
                      
                      lapseCalculatedYearPrice=lapseCalculatedYearPrice + getYearlyPrice(calculatedMonthlyPrice,billingFrequency);
                 }  
                 Integer totalmonth=remainingMonths;                   
                 if(totalmonth-12>0){    
                    while(totalmonth-12>0)                
                    {                        
                        Integer months=totalmonth-12;                        
                        if(months>12)
                        {                         
                            calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                            //DOC 331 Added By Poonam Garg
                            lapseCalculatedYearPrice=lapseCalculatedYearPrice + getYearlyPrice(calculatedMonthlyPrice,billingFrequency);
                            totalmonth=totalmonth-12;
                        }
                        else{                        
                            lapseCalculatedYearPrice=lapseCalculatedYearPrice+ (proposedLi.APTS_Asset_Net_Price__c*months);                           
                            totalmonth=totalmonth-12;                        
                        }
                    }        
                 }
            }
            else{ 
              if(proposedLi.APTS_Contract_Term__c!=null){              
                 index = (proposedLi.APTS_Contract_Term__c).indexOfIgnoreCase('Years');}         
                 else{
                     index=0;
                 }       
             if(index > 0) {
                 term = Integer.valueof(((proposedLi.APTS_Contract_Term__c).subString(0, index-1)).trim());
             }
                 System.debug(term );      
                 if(proposedLi.APTS_Years_2_Plus_Adjustment__c!= null && proposedLi.Apttus_Config2__LineStatus__c!='Renewed') {


                    YOYPercent = Integer.valueof(proposedLi.APTS_Years_2_Plus_Adjustment__c);                 
                    YOYValue = (YOYPercent*100)/100;   
                    calculatedMonthlyPrice = proposedLi.Apttus_Config2__NetPrice__c; 
                    
                    System.debug(calculatedMonthlyPrice );
                    proposedTCV =proposedTCV+ getYearlyPrice(proposedLi.Apttus_Config2__NetPrice__c,billingFrequency);                   
                    for(Integer i=2; i <= term ; i++) {    
                      calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                      proposedTCV =proposedTCV + getYearlyPrice(calculatedMonthlyPrice,billingFrequency); 
                      System.debug('calculatedMonthlyPrice ***'+calculatedMonthlyPrice);
                      System.debug('proposedTCV ***'+proposedTCV );
                 }
              }
              else if(proposedLi.APTS_Years_2_Plus_Adjustment__c!= null && proposedLi.Apttus_Config2__LineStatus__c == 'Renewed') {
                     YOYPercent = Integer.valueof(proposedLi.APTS_Years_2_Plus_Adjustment__c);   
                     if(proposedLi.APTS_Yr_1_Renewal_Adjustment__c!= null) {
                        RenewYOYPercent = Integer.valueof(proposedLi.APTS_Yr_1_Renewal_Adjustment__c);  
                     }                
                     YOYValue = (YOYPercent*100)/100;   
                     if(proposedLi.APTS_Yr_1_Renewal_Adjustment__c!= null) {
                        RenewYOYValue=(RenewYOYPercent*100)/100;
                     }
                     calculatedMonthlyPrice = proposedLi.Apttus_Config2__NetPrice__c;             
                     calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * RenewYOYValue)/100);
                     
                     proposedTCV =proposedTCV+getYearlyPrice(calculatedMonthlyPrice,billingFrequency);
                     System.debug('calculatedMonthlyPrice ***'+calculatedMonthlyPrice);
                      System.debug('proposedTCV ***'+proposedTCV );
                     for(Integer i=2; i <= term ; i++) {    
                      calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                      proposedTCV =proposedTCV+ getYearlyPrice(calculatedMonthlyPrice,billingFrequency); 
                      System.debug('calculatedMonthlyPrice ***'+calculatedMonthlyPrice);
                      System.debug('proposedTCV ***'+proposedTCV );
              }
            }
        } 
        } 
        }          
         proposedTCV =proposedTCV-lapseCalculatedYearPrice;
         proposedTCV =  proposedTCV+CurrentTCV;      
        System.debug('lapseCalculatedYearPrice***'+lapseCalculatedYearPrice);
        System.debug('proposedTCV ***'+proposedTCV );
         Decimal num = proposedTCV.setScale(2,System.RoundingMode.HALF_UP);   
         retPrice=isCanada ? ('CAD $ ' + String.valueOf(num)) : ('USD $ ' + String.valueOf(num)); //DOC 331 Added By Poonam Garg
         return retPrice;
    }
    
     /*DOC-10825*/
     public String getProposedTCVTax() {         
         proposedTCVTax = 0;         
         Integer term = 0;         
         Integer yOYPercent = 0;
         Integer index=0;
         Integer renewYOYPercent = 0;
         Decimal renewYOYValue = 0;
         Decimal yOYValue = 0; 
         Decimal calculatedYearPrice = 0;
         Decimal calculatedMonthlyPrice;  
         Date term1 = null;
         Date systemDate = null;
         Integer remainingMonths =null;
         Decimal lapseCalculatedYearPrice = 0; 
         String retPrice='';   
         if(bTaxProposedTCVCalc == true && proposedOnlineSoftwareList!= null && proposedOnlineSoftwareList.size() > 0)
         {    
           for(Apttus_Config2__LineItem__c oLineitem : proposedOnlineSoftwareList)
            {
                System.Debug('Kh***TAXPTCV proposedOnlineSoftwareList==>'+proposedOnlineSoftwareList.size());
                System.Debug('Kh***TAXPTCV calculatedYearPrice==>'+calculatedYearPrice); 
                System.Debug('Kh***TAXPTCV APTS_Calculated_Year_1__c==>'+oLineitem.APTS_Calculated_Year_1__c);
                System.Debug('Kh***TAXPTCV APTS_Calculated_Year_2__c==>'+oLineitem.APTS_Calculated_Year_2__c);
                System.Debug('Kh***TAXPTCV APTS_Calculated_Year_3__c==>'+oLineitem.APTS_Calculated_Year_3__c);
                System.Debug('Kh***TAXPTCV APTS_Calculated_Year_4__c==>'+oLineitem.APTS_Calculated_Year_4__c);
                System.Debug('Kh***TAXPTCV APTS_Calculated_Year_5__c==>'+oLineitem.APTS_Calculated_Year_5__c);
                if(oLineitem.Apttus_Config2__LineStatus__c!='Cancelled')
                {
                    if(oLineitem.APTS_Calculated_Year_1__c != null)
                    {
                        calculatedYearPrice = calculatedYearPrice + oLineitem.APTS_Calculated_Year_1__c;
                    }
                    if (oLineitem.APTS_Calculated_Year_2__c != null )
                    {
                        calculatedYearPrice = calculatedYearPrice + oLineitem.APTS_Calculated_Year_2__c;
                    }
                    if (oLineitem.APTS_Calculated_Year_3__c != null)
                    {
                        calculatedYearPrice = calculatedYearPrice + oLineitem.APTS_Calculated_Year_3__c;
                    }
                    if (oLineitem.APTS_Calculated_Year_4__c != null)
                    {
                        calculatedYearPrice = calculatedYearPrice + oLineitem.APTS_Calculated_Year_4__c;
                    }
                    if (oLineitem.APTS_Calculated_Year_5__c != null)
                    {
                        calculatedYearPrice = calculatedYearPrice + oLineitem.APTS_Calculated_Year_5__c;
                    }
                }    
                else if(oLineitem.Apttus_Config2__LineStatus__c=='Cancelled' && oLineitem.APTS_Info_RenewalDate__c!=null){
                   System.Debug('APTS_Info_RenewalDate__c'+oLineitem.APTS_Info_RenewalDate__c);  
                   term1 = oLineitem.APTS_Info_RenewalDate__c;
                   systemDate = Date.today(); 
                    if(term1!=null){
                         remainingMonths = systemDate.monthsBetween(term1); 
                         System.Debug('remainingMonths '+remainingMonths);                     
                    }
                    YOYValue = (4.6*100)/100;               
                    calculatedMonthlyPrice = oLineitem.APTS_Asset_Net_Price__c;                    
                    if(remainingMonths<=12){                    
                         lapseCalculatedYearPrice=lapseCalculatedYearPrice+(oLineitem.APTS_Asset_Net_Price__c*remainingMonths);                     
                    }
                    else if(remainingMonths == 12){
                          calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                          lapseCalculatedYearPrice=lapseCalculatedYearPrice + getYearlyPrice(calculatedMonthlyPrice,billingFrequency);
                     }
                     else if(remainingMonths > 12){                     
                         calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                          lapseCalculatedYearPrice=lapseCalculatedYearPrice + getYearlyPrice(calculatedMonthlyPrice,billingFrequency);
                     }  
                     Integer totalmonth=remainingMonths;                   
                     if(totalmonth-12>0){    
                        while(totalmonth-12>0)                
                        {                        
                            Integer months=totalmonth-12;                        
                            if(months>12)
                            {                         
                                calculatedMonthlyPrice=calculatedMonthlyPrice+((calculatedMonthlyPrice * YOYValue)/100);
                                lapseCalculatedYearPrice=lapseCalculatedYearPrice + getYearlyPrice(calculatedMonthlyPrice,billingFrequency);
                                totalmonth=totalmonth-12;
                            }
                            else{                        
                                lapseCalculatedYearPrice=lapseCalculatedYearPrice+ (oLineitem.APTS_Asset_Net_Price__c*months);                           
                                totalmonth=totalmonth-12;                        
                            }
                        }        
                     }
                }
            } 
         }          
        proposedTCVTax =proposedTCVTax-lapseCalculatedYearPrice;     
        proposedTCVTax =proposedTCVTax+calculatedYearPrice;
             proposedTCVTax =  proposedTCVTax+CurrentTCVTax;  
             System.debug('Kh***TAXPTCV calculatedYearPrice===>'+calculatedYearPrice);
             System.debug('Kh***TAXPTCV CurrentTCV===>'+CurrentTCVTax);
             System.debug('Kh***TAXPTCV proposedTCV===>'+proposedTCVTax );
             Decimal num = proposedTCVTax.setScale(2,System.RoundingMode.HALF_UP);   
             retPrice=isTax ? ('USD $' + String.valueOf(num.format())) :'0' ; 
             return retPrice;
    }
   
   private decimal getYearlyPrice(Decimal yearPrice,String billingFrequency){
        Decimal yearlyPrice=0;
        //Added by Khushboo Vaidya for Tax Prof
        system.debug('##### istax'+istax);
        if((isCanada && billingFrequency =='Yearly') 
           || (istax && (billingFrequency =='Yearly' || billingFrequency =='Monthly'))){
            yearlyPrice=yearPrice;  
        }
        else{
            yearlyPrice= (yearPrice*12); 
        }
        return yearlyPrice; 
     }
     //Prabhu Ends
     
     public String getTCVChange() {
         getCurrentTCV();
         getProposedTCV();
         TCVChange=0;         
         if(currentTCV!=0){         
             TCVChange=((proposedTCV-currentTCV)/currentTCV)*100;             
         }
         Decimal num = TCVChange.setScale(1,System.RoundingMode.HALF_UP);//Added as part of Change 3
         return (String.valueOf(num))+'%';
     }
     
   //DOC-10825 by Rishi
     public String getTCVChangeTax() {
         getCurrentTCVTax();
         getProposedTCVTax();
         TCVChangeTax=0;         
         if(currentTCVTax!=0){         
             TCVChangeTax=((proposedTCVTax-currentTCVTax)/currentTCVTax)*100;             
         }
         Decimal num = TCVChangeTax.setScale(1,System.RoundingMode.HALF_UP);
         return (String.valueOf(num))+'%';
     }
   
     global class Document implements Comparable{
         public String fileId {get; set;}
         public String fileName {get; set;}
         public String Type {get; set;}
         public String parentId {get; set;}
         public String parentName {get;set;}
         public String modifiedDate {get; set;}
         public String createdBy {get; set;}
                  
         public Document(String id, String name, String pId, String pName, String typ, DateTime modifyDate, String crtBy) {
             fileId = id;
             fileName = name;
             parentId = pId;
             parentName  = pName;
             Type = typ;
             modifiedDate = modifyDate.format('MMM dd, yyyy hh:mm a');
             createdBy = crtBy;          
         }
         
         global Integer compareTo(Object compareTo) {
             Document obj = (Document) compareTo;
             Integer value = 0;
             if(modifiedDate > obj.modifiedDate) {
                 return -1;
             } else if(modifiedDate < obj.modifiedDate) {
                 return 1;
             } else {
                 return 0;
             }
         }
     } 
     
     public class PrintProview {
         public String lineItemId {get;set;}
         public String productFamily {get;set;}
         public String productName {get;set;}
         public List<PurchaseOption> purchaseOptions {get;set;}
         
         public PrintProview(String liId, String pFamily, String pName) {
             lineItemId = liId;
             productFamily = pFamily;
             productName = pName;
             purchaseOptions = getPurchaseOptions();
         }
         
         public List<PurchaseOption> getPurchaseOptions() {
             List<Apttus_Config2__ProductAttributeValue__c> attributeList;
             List<PurchaseOption> purchaseOptions = new List<PurchaseOption>();
             if(productFamily.equalsIgnoreCase(System.Label.APTS_Print_Product_Family)) {
                 attributeList = [SELECT Id, SCS_Print_Purchase_Options__c FROM Apttus_Config2__ProductAttributeValue__c av 
                     WHERE av.Apttus_Config2__LineItemId__c =:lineItemId];
                 if(attributeList != null && attributeList.size()>0) {
                     for(Apttus_Config2__ProductAttributeValue__c attribute : attributeList) {
                         purchaseOptions.add(new PurchaseOption(attribute.SCS_Print_Purchase_Options__c));
                     }
                 }
                     
             } else If(productFamily.equals(System.Label.APTS_Proview_Product_Family)) {
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
     
     public class PurchaseOption {
         public String purchaseOption {get;set;} 
         
         public PurchaseOption(String option) {
             purchaseOption = option;
         }
     }     

}