/**
* Interface to send the Lotus Tax professional Order to Dell boomi
* Order Details
*
* @author  TCS
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                            Description 
* 2019-06-04   Priyanka Pawar                
* 
* =============================================================================

*/
// this class is calling from Aptts_BatchOrderSubmission class
public with sharing class APTS_Hana_OrderQueuetoBOOMI{

    public static CreateS4HANAOrderRequest orderReq;
    public static CreateS4HANAOrderRequest.OrderLines orderLine;
    public static CreateS4HANAOrderRequest.Material lstOfMaterial;    
    public static Decimal adjamount;
    public static boolean PSFlag = false;
    static Map<string, Decimal> materialMap;
       public static  Boolean DellBoomiorderSubmissionToBOOMI(id orderId) {
          Apttus_Config2__Order__c order;
          User proposalOwner = new User();
          Decimal oneTimeValue = 0;
          integer lineNumber = 0;
          integer rlNumber = 0;
          Decimal netAmount = 0;
          Set<String> setContactSSDIds=new Set<String>();
          materialMap = new Map<string, Decimal>();
          
          orderline = new CreateS4HANAOrderRequest.OrderLines();
        try{   
        List<Online_Contacts__c> onlinecon = new List<Online_Contacts__c>();    //Added By Poorva
        if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()&&Schema.sObjectType.Apttus_Config2__Order__c.isQueryable()&&Schema.SObjectType.Apttus_Config2__OrderLineItem__c.fields.Apttus_Config2__OrderId__c.isAccessible()){
        order = [SELECT Id, Name,Apttus_QPConfig__ProposalId__r.APTS_Wet_Signature__c,CreatedDate,Retry_Count__c,Apttus_Config2__OrderReferenceNumber__c, 
         Apttus_QPConfig__ProposalId__c,CreatedBy.Apts_Revenue_Channel__c,Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c,
       /* CreatedBy.Sales_Force_Description__c,CreatedBy.Market_Segment_Description__c,*/
        Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c,Apttus_Config2__Source__c,Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Zipcode__c,
        Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Country__c,Apttus_QPConfig__ProposalId__r.APTS_Authorization_Transaction__c,
        Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.City__c, Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Phone__c,
        Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To_Attention__c,Apttus_QPConfig__ProposalId__r.APTS_MLA_Quote__c,
        Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Name,Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.State__c, 
        Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street_Address_3__c, Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street_Address_4__c,
        Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street__c,Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__c,
        Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c,Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c,
        Apttus_QPConfig__ProposalId__r.APTS_Assent_Name_of_Rep__r.FirstName,Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c,
        Apttus_QPConfig__ProposalId__r.APTS_Assent_Customer_Name__c,Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PODate__c,
        Apttus_QPConfig__ProposalId__r.APTS_Assent_Name_of_Rep__r.LastName,Apttus_QPConfig__ProposalId__r.APTS_Assent_DateTime__c, 
        Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c,Apttus_QPConfig__ProposalId__r.CreatedBy.Rep_Employee_Number__c,
        Apttus_QPConfig__ProposalId__r.APTS_Card_Type__c,Apttus_QPConfig__ProposalId__r.APTS_amount__c,
        Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c,Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c,
        Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName,
        Apttus_QPConfig__ProposalId__r.APTS_Print_Branding__c,Apttus_Config2__Description__c,
        Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Phone,
        Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Department,
        Apttus_QPConfig__ProposalId__r.ownerid,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email,
        Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Extension__c,
        Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName,Number_of_Attorneys__c, 
        Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Net_Amount__c,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c,
        Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Contact_Type__c,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,
        Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Proposal_Name__c,Apttus_QPConfig__ProposalId__r.name,
        Apttus_QPConfig__ProposalId__r.CreatedBy.EmployeeNumber,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__c,Apttus_QPConfig__ProposalId__r.APTS_Account_Credit_Risk_Category__c,
        Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c, Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.LastName,Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.FirstName,
        Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Email,Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Contact_Type__c,Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c,
        Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c,
        Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Person_ID__c,
        Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__c,
        Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c,
        Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__c,
        Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_First_Name__c,
        Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_First_Name__c,
        Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_First_Name__c,
        Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_Last_Name__c,
        Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_Last_Name__c,
        Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_Last_Name__c,
        Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_Email__c,
        Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_Email__c,
        Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_Email__c,
        Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_Source_Contact_Id__c,
        Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_Source_Contact_Id__c,
        Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_Source_Contact_Id__c,Apttus_QPConfig__ProposalId__r.APTS_Notes__c,Apttus_QPConfig__ProposalId__r.APTS_Bank_Account_Number__c,Apttus_QPConfig__ProposalId__r.APTS_Bank_Name__c,Apttus_QPConfig__ProposalId__r.APTS_Bank_Routing_Number__c,
        APTS_SSD_Bill_To__r.LCRM_SAP_Account_Number__c,
        APTS_SSD_Bill_To__r.Source_System_Account_Number__c,
        APTS_SSD_Bill_To__r.LCRM_Name_2__c,
        APTS_SSD_Bill_To__r.LCRM_Street3__c,
        APTS_SSD_Bill_To__r.LCRM_Name_3__c,
        APTS_SSD_Bill_To__r.Number_Street__c,
        APTS_SSD_Bill_To__r.LCRM_Street_2__c,
        APTS_SSD_Bill_To__r.LCRM_Street4__c,
        APTS_SSD_Bill_To__r.City__c,
        APTS_SSD_Bill_To__r.State__c,
        APTS_SSD_Bill_To__r.Country__c,
        APTS_SSD_Bill_To__r.Postal_Code__c,
        APTS_SSD_Bill_To__r.LCRM_Phone__c,
        APTS_SSD_Bill_To__r.LCRM_Fax__c,APTS_SSD_Bill_To__r.LCRM_Email__c, 
        APTS_SSD_Bill_To__r.LCRM_Building__c, APTS_SSD_Bill_To__r.LCRM_VAT__c, APTS_SSD_Bill_To__r.LCRM_Tax_Number__c,
        APTS_SSD_Bill_To__r.County__c,APTS_SSD_Bill_To__r.LCRM_Sales_Org__c,
/*      APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
        Apttus_Config2__SoldToAccountId__r.Name,
        Apttus_Config2__SoldToAccountId__r.NameTwo__c,
        Apttus_Config2__SoldToAccountId__r.NameThree__c,*/
        APTS_SSD_Sold_To__r.LCRM_SAP_Account_Number__c,
        APTS_SSD_Sold_To__r.LCRM_Name_2__c,
        APTS_SSD_Sold_To__r.LCRM_Street3__c,
        APTS_SSD_Sold_To__r.LCRM_Name_3__c,
        APTS_SSD_Sold_To__r.Number_Street__c,
        APTS_SSD_Sold_To__r.LCRM_Street_2__c,
        APTS_SSD_Sold_To__r.LCRM_Street4__c,
        APTS_SSD_Sold_To__r.City__c,
        APTS_SSD_Sold_To__r.State__c,
        APTS_SSD_Sold_To__r.Country__c,
        APTS_SSD_Sold_To__r.Postal_Code__c,
        APTS_SSD_Sold_To__r.LCRM_Phone__c,
        APTS_SSD_Sold_To__r.LCRM_Fax__c,
        APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Email__c, 
        APTS_SSD_Sold_To__r.LCRM_Building__c, APTS_SSD_Sold_To__r.LCRM_VAT__c, 
        APTS_SSD_Sold_To__r.LCRM_Tax_Number__c,
        APTS_SSD_Sold_To__r.County__c,
        APTS_SSD_Ship_To__r.LCRM_SAP_Account_Number__c,
        APTS_SSD_Ship_To__r.LCRM_Name_2__c,
        APTS_SSD_Ship_To__r.LCRM_Street3__c,
        APTS_SSD_Ship_To__r.LCRM_Name_3__c,
        APTS_SSD_Ship_To__r.Number_Street__c,
        APTS_SSD_Ship_To__r.LCRM_Street_2__c,
        APTS_SSD_Ship_To__r.LCRM_Street4__c,
        APTS_SSD_Ship_To__r.City__c,
        APTS_SSD_Ship_To__r.State__c,
        APTS_SSD_Ship_To__r.Country__c,
        APTS_SSD_Ship_To__r.Postal_Code__c,
        APTS_SSD_Ship_To__r.LCRM_Phone__c,
        APTS_SSD_Ship_To__r.LCRM_Fax__c,
        APTS_SSD_Ship_To__r.Source_System_Account_Number__c,
        APTS_SSD_Ship_To__r.Name,APTS_SSD_Ship_To__r.LCRM_Sales_Org__c,
        APTS_SSD_Ship_To__r.LCRM_Email__c, APTS_SSD_Ship_To__r.LCRM_Building__c, 
        APTS_SSD_Ship_To__r.LCRM_VAT__c, APTS_SSD_Ship_To__r.LCRM_Tax_Number__c,
        APTS_SSD_Ship_To__r.County__c,
        APTS_SSD_Sold_To__r.LCRM_Customer_Group__c,
        APTS_SSD_Sold_To__r.LCRM_WLD_ID__c,APTS_SSD_Bill_To__c,
        APTS_SSD_Ship_To__c,
        APTS_SSD_Sold_To__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c,APTS_SSD_Sold_To__r.Default_Payment_Method__c,APTS_SSD_Sold_To__r.APTS_Is_Customer__c,
        APTS_SSD_Sold_To__r.Name,Apttus_Config2__SoldToAccountId__r.Customer_Group__c,APTS_SSD_Sold_To__r.CreatedBy.Rep_Employee_Number__c,
        APTS_SSD_Sold_To__r.LCRM_PO_Box__c,
        APTS_SSD_bill_to__r.Name,APTS_SSD_bill_to__r.LCRM_PO_Box__c,
        APTS_SSD_Ship_To__r.LCRM_PO_Box__c, Apttus_Config2__Status__c,
        APTS_SSD_Ship_To__r.CurrencyIsoCode,      
        APTS_SSD_Bill_To__r.CurrencyIsoCode,       
        APTS_SSD_Sold_To__r.CurrencyIsoCode,
        APTS_Payer__r.CurrencyIsoCode,
        Apttus_Config2__OrderDate__c,        
        Apttus_Config2__Type__c,CurrencyIsoCode,APTS_Periodic_Value__c,
        APTS_One_Time_Value__c,APTS_Payer__c,APTS_Payer__r.name,APTS_Payer__r.Source_System_Account_Number__c,APTS_Payer__r.LCRM_SAP_Account_Number__c,
        APTS_Payer__r.LCRM_Name_2__c,
        APTS_Payer__r.LCRM_Street3__c,
        APTS_Payer__r.LCRM_Name_3__c,
        APTS_Payer__r.Number_Street__c,
        APTS_Payer__r.LCRM_Street_2__c,
        APTS_Payer__r.LCRM_Street4__c,
        APTS_Payer__r.LCRM_PO_Box__c,
        APTS_Payer__r.City__c,
        APTS_Payer__r.State__c,
        APTS_Payer__r.Country__c,
        APTS_Payer__r.Postal_Code__c,
        APTS_Payer__r.LCRM_Phone__c,
        APTS_Payer__r.LCRM_Fax__c,APTS_Payer__r.LCRM_Sales_Org__c,
        APTS_Payer__r.LCRM_Email__c, APTS_Payer__r.LCRM_Building__c, 
        APTS_Payer__r.LCRM_VAT__c, APTS_Payer__r.LCRM_Tax_Number__c,APTS_Payer__r.County__c,
        createdBy.LanguageLocaleKey,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.Person_ID__c,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.FirstName,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.LastName,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.Email,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__c,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.Person_ID__c,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.FirstName,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.LastName,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.Email,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__c,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.Person_ID__c,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.FirstName,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.LastName,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.Email,
        Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c,

        (SELECT Name,Apttus_Config2__PriceUom__c,Apttus_Config2__LineNumber__c,APTS_Years_2_Plus_Adjustment__c,Apttus_QPConfig__ProposalLineItemId__r.Net_Qty_Difference__c,
        Apttus_QPConfig__ProposalLineItemId__r.Name,APTS_One_time_value__c,Apttus_Config2__ProductId__r.APTS_Availability_Date__c,
        Apttus_Config2__ProductId__r.APTS_SwapAndVersion__c,APTS_Renewal_Type__c,APTS_Term_Type__c,APTS_End_Date__c ,APTS_Prorate_base_Value__c,APTS_Start_Date__c,
        Apttus_QPConfig__ProposalLineItemId__r.Apttus_QPConfig__OptionId__c,Apttus_QPConfig__ProposalLineItemId__r.APTS_Category_Name__c,
        Apttus_QPConfig__ProposalLineItemId__r.APTS_Product_Name_Override__c,Apttus_QPConfig__ProposalLineItemId__r.Apttus_QPConfig__NetPrice__c,
        Apttus_QPConfig__ProposalLineItemId__r.APTS_Net_Price_display__c,Apttus_QPConfig__ProposalLineItemId__r.APTS_FL_Current_Renewal_User_Rate__c,
        APTS_Program_ID__c,APTS_Group__c,Base_Value__c,APTS_Yr_1_Renewal_Adjustment__c,Apttus_Config2__Quantity__c,
        Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c,Apttus_QPConfig__ProposalLineItemId__r.APTS_Subscription_Number_Override__c,
        Apttus_Config2__Uom__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ExtendedPrice__c,APTS_Contract_Line_Number__c,
        Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__SellingFrequency__c,
        Apttus_Config2__NetPrice__c,APTS_Bridge__c,Apttus_Config2__LineStatus__c,Apttus_Config2__Description__c,Apttus_Config2__PricingDate__c,
        APTS_Deal_Number__c,APTS_Contract_Number__c,Apttus_Config2__IncentiveCode__c,APTS_Deal_Type__c ,Apttus_Config2__Type__c,
        Apttus_Config2__AdjustmentType__c,APTS_Contract_Term__c,Apttus_Config2__ProductId__r.Apttus_Config2__Uom__c,
        Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c,
        Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c,
        APTS_New_Bridge_Discount__c,Apttus_Config2__NetUnitPrice__c,
        Apttus_Config2__OrderId__r.APTS_Order_Value__c,bridge_net_price__c,APTS_Group_Primary_Material__c,Apttus_Config2__AdjustmentAmount__c,
        APTS_SAP_Deal_Primary_Material__c,APTS_Subscription_Number__c, Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,
        Apttus_Config2__ChargeType__c, Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c,Apttus_Config2__PriceType__c, 
        Apttus_Config2__LineType__c,Apttus_Config2__HasOptions__c, Apttus_Config2__OptionId__c, Apttus_Config2__OptionId__r.ProductCode,
        Apttus_QPConfig__ProposalId__r.APTS_Renewal_Opt_out__c, Apttus_QPConfig__ProposalId__r.APTS_Fiscal_Filer__c,Apttus_Config2__AdjustedPrice__c,Apttus_Config2__BasePrice__c,
        Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.APTS_Practice_Area_Code__c,
        Apttus_Config2__ProductId__r.APTS_Location_Code__c,Apttus_Config2__DerivedFromId__r.APTS_Product_Delivery__c,
        Apttus_Config2__ProductId__r.Product_Level_5__c,Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
        Apttus_Config2__ProductId__r.APTS_Find_Law_Practice_Area__c,
        Apttus_Config2__OptionId__r.APTS_Find_Law_Practice_Area__c,Apttus_Config2__OptionId__r.APTS_Location_Code__c,
        Apttus_Config2__OptionId__r.APTS_Practice_Area_Code__c, APTS_FL_Price_Increase_Percentage__c, APTS_Years_2_3_Charges_Disc_Surc__c,
        Apttus_QPConfig__ProposalLineItemId__r.APTS_SAP_MLA_Agreement_Number__c,APTS_Number_of_Attorneys__c,APTS_Combination_Key__r.APTS_Attribute_Value1__r.APTS_SAP_Attribute_Code__c,APTS_Combination_Key__r.APTS_Attribute_Value3__r.APTS_SAP_Attribute_Code__c,
        Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, APTS_SAP_MLA_Agreement_Number__c, APTS_Service_Number__c,Apttus_Config2__ProductId__r.APTS_Pricing_Qty__c, 
        APTS_Priced_Number_of_Attorneys__c,APTS_Calculated_Year_1__c,APTS_Calculated_Year_2__c,APTS_Calculated_Year_3__c,APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c,APTS_FL_Qty__c,Apttus_Config2__BaseExtendedPrice__c,APTS_WLEC_Product_Category__c,APTS_Fiscal_Year_End__c,Apttus_Config2__AssetLineItemId__r.Asset_Auto_Number__c,Apttus_Config2__AssetLineItemId__r.Tax_Asset_Auto_Number__c,APTS_Product_Variant_ID__c,
        Apttus_QPConfig__ProposalLineItemId__c, Apttus_QPConfig__ProposalLineItemId__r.IP_Address_Check__c, Apttus_QPConfig__ProposalLineItemId__r.APTS_Online_Contacts_Validation__c, APTS_CUAS1__c   FROM Apttus_Config2__OrderLineItems__r) 
        FROM Apttus_Config2__Order__c WHERE Id =:orderId ];
        }
        System.debug('order  : '+order);
        List<Apttus_Config2__AssetLineItem__c> tempALIList = new List<Apttus_Config2__AssetLineItem__c>();
        for(Apttus_Config2__OrderLineItem__c  oliTemp : order.Apttus_Config2__OrderLineItems__r){
            if(String.isBlank(oliTemp.Apttus_Config2__AssetLineItemId__r.Asset_Auto_Number__c) && oliTemp.Apttus_Config2__AssetLineItemId__c!=null){
                Apttus_Config2__AssetLineItem__c tempALI = new Apttus_Config2__AssetLineItem__c(ID=oliTemp.Apttus_Config2__AssetLineItemId__c, Asset_Auto_Number__c=oliTemp.Apttus_Config2__AssetLineItemId__r.Tax_Asset_Auto_Number__c);
                tempALIList.add(tempALI);
            }
        }
        if(tempALIList!=null && tempALIList.size()>0){
            update tempALIList;
            DellBoomiOrderSubmissionCalloutUtil.logException('', 'Had issue in Asset Number. \nThis execution synced Asset Numbers. \nNext Re-try will submit order.',  'Quote/Proposal', False, orderId,0);          
            return false;
        }
        if(Schema.sObjectType.User.isAccessible()&&Schema.sObjectType.User.isQueryable()){
            proposalOwner = [SELECT id,FirstName,LastName,Email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,
            Market_Segment_Description__c FROM User where Id=:order.Apttus_QPConfig__ProposalId__r.OwnerId];
        } 
           // Added By Poorva    online contacts 
        if(Schema.sObjectType.Online_Contacts__c.isAccessible()){
            onlinecon = [SELECT First_Name__c, Name, QuoteLineItem__c,QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c, Material__c, APTS_Source_System_Detail__c, Latam_Action__c,
            APTS_Source_System_Detail__r.Source_System_Account_Number__c, Account__c, Last_Name__c, 
            APTS_Source_System_Detail__r.Account_Name__r.AccountNumber, Email__c, Is_Banded_Product__c, ContactID__c,
            ProductId__r.APTS_Media_High_Level_Code__c, QuoteId__c, Tax_Type__c, Position__c, Tax_Position__c ,Type__c  FROM Online_Contacts__c
            where QuoteId__c =:order.Apttus_QPConfig__ProposalId__c AND Latam_Action__c != ''];
        } // Poorva code ends here
                 // Logic to process the Order details and assign to BOOMI request Start
                 orderReq = new CreateS4HANAOrderRequest();
                 CreateS4HANAOrderRequest.orderAddress ordHeaderAddress = new CreateS4HANAOrderRequest.orderAddress();
                 orderReq.BOOMIHeader.applicationId = 'SF12';
                 orderReq.BOOMIHeader.transactionId = 'S100';
                 orderReq.BoomiHeader.timestamp=String.valueof(order.Apttus_Config2__OrderDate__c);
                 DateTime datme =order.Apttus_Config2__OrderDate__c;
                 orderReq.BOOMIHeader.timeStamp= datme.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');              
                 //orderReq.orderHeader.orderTimestamp =String.valueof(order.Apttus_Config2__OrderDate__c);
                 //orderReq.orderHeader.orderTimestamp ='2019-06-12T16:36:08.208Z';
                 orderReq.orderHeader.orderTimestamp = datme.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
                 orderReq.orderHeader.orderCurrency=order.CurrencyIsoCode;
                 orderReq.OrderHeader.purchaseOrderNumber=order.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c;
                 orderReq.OrderHeader.purchaseDate=order.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PODate__c;
                 orderReq.OrderHeader.esignDate=String.valueof(order.CreatedDate);
                 orderReq.OrderHeader.orderPeriodicValue=String.valueof(order.APTS_Periodic_Value__c);
                 orderReq.OrderHeader.oneTimeValue=String.valueof(order.APTS_One_Time_Value__c);
                 orderReq.OrderHeader.salesOffice='';
                 //orderReq.OrderHeader.paymentMethod='K';
                 orderReq.OrderHeader.orderType='SALE';
                 orderReq.OrderHeader.orderNumber = order.Name;
                 orderReq.OrderHeader.actionCode= 'CREATE';
                  //Added By Poorva for DOC-8886
                 orderReq.OrderHeader.orderRepresentative.representativeName = proposalOwner.FirstName +' ' +proposalOwner.LastName;
                 orderReq.OrderHeader.orderRepresentative.representativeNumber = proposalOwner.Rep_Employee_Number__c;
                 //Ends here
                 
                 orderReq.OrderHeader.orderRepresentative.emailAddress = proposalOwner.Email; //Commented as it will go in prod/UAT
                 //orderReq.OrderHeader.orderRepresentative.emailAddress = 'poorva.sinha@thomsonreuters.com';
                
                 if(order.Apttus_QPConfig__ProposalId__r.APTS_Wet_Signature__c == true){
                    DateTime dt = order.CreatedDate;
                    orderReq.orderHeader.esignDate = dt.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                    system.debug('@@@@@@@'+orderReq.orderHeader.esignDate);
                 }else{ 
                      if(Schema.sObjectType.Task.fields.id.isAccessible()&&Schema.sObjectType.Task.fields.Subject.isAccessible()&&Schema.sObjectType.Task.fields.Description.isAccessible()){
                    List<Task> taskobj=[Select id,Subject,Description from Task where What.Id=:order.Apttus_QPConfig__ProposalId__c AND Subject LIKE '%Quote/Proposal eSigned by%' limit 1];
                    system.debug('Task'+taskobj);
                    if(!taskobj.isEmpty()){                       
                       String finalString=taskobj[0].Subject.substringAfterLast('@').replace(' GMT','Z');
                       System.debug('!!!!'+finalString);
                       orderReq.orderHeader.esignDate = finalString;
                    }else if(taskobj.isEmpty()){
                       DateTime dtme = order.CreatedDate;
                       orderReq.orderHeader.esignDate = dtme.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                    }
                   }      
                 }  
                 
                  if(order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c!=null){
                      if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Payment Express Auto EFT/Auto Charge'){
                          orderReq.orderHeader.accountPayment.paymentTerm='0001';
                      }
                      else{
                          orderReq.orderHeader.accountPayment.paymentTerm='NT30';
                      }
                  }         
                 if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c!=null)
                 {
                 if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Auto EFT/Auto Charge')
                  orderReq.OrderHeader.paymentMethod='A';
                 else if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Bill to Account')
                  orderReq.OrderHeader.paymentMethod='B';
                 else if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Payment Express Auto EFT/Auto Charge')
                  orderReq.OrderHeader.paymentMethod='P';
                 else if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Credit Card')
                  orderReq.OrderHeader.paymentMethod='C';
                  else if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='One Time EFT')
                  orderReq.OrderHeader.paymentMethod='E';
                  }
                  
                 orderReq.orderHeader.purchaseOrderNumber = order.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c;                 
                 CreateS4HANAOrderRequest.quoteDetails quoteRec = new CreateS4HANAOrderRequest.quoteDetails();
                 quoteRec.quoteNumber =order.Apttus_QPConfig__ProposalId__r.name;
                 quoteRec.quoteType='';
                 quoteRec.orderItemNumber='';
                 quoteRec.RetractQuoteNumber='';
                 orderReq.orderHeader.quoteDetails.add(quoteRec);
                 //assign Credit card details to Order Header
                  if(order.APTS_SSD_Sold_To__r.APTS_Is_Customer__c == false || (order.APTS_SSD_Sold_To__r.APTS_Is_Customer__c == true && order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c != order.APTS_SSD_Sold_To__r.Default_Payment_Method__c)){
                     if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'One Time EFT'){
                        orderReq.OrderHeader.eftPayment.bankAccount = order.Apttus_QPConfig__ProposalId__r.APTS_Bank_Account_Number__c;
                        orderReq.OrderHeader.eftPayment.bankName = order.Apttus_QPConfig__ProposalId__r.APTS_Bank_Name__c;
                        orderReq.OrderHeader.eftPayment.bankRouting = order.Apttus_QPConfig__ProposalId__r.APTS_Bank_Routing_Number__c;
                     }
                     else if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Credit Card'){
                      if(order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c != null) { 
                           Datetime expDate= order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c;                 
                           orderReq.orderHeader.CreditCardPayment.CreditCard.expiration = expDate.formatGMT('yyyy-MM-dd');
                        }
                           orderReq.OrderHeader.CreditCardPayment.CreditCard.paymentTerm='D030';                   
                           orderReq.orderHeader.CreditCardPayment.CreditCardAuthorization.authorizationNumber = order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c;
                           orderReq.orderHeader.CreditCardPayment.CreditCardAuthorization.transactionId = order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Transaction__c;
                           orderReq.orderHeader.creditCardPayment.CreditCardAuthorization.authorizationAmount= order.Apttus_QPConfig__ProposalId__r.APTS_amount__c; 
                           orderReq.orderHeader.CreditCardPayment.CreditCard.cardType = order.Apttus_QPConfig__ProposalId__r.APTS_Card_Type__c;
                          // orderReq.orderHeader.CreditCardPayment.CreditCard.expiration=order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c;
                           orderReq.orderHeader.CreditCardPayment.CreditCard.cardNumber = order.Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c;
                          // orderReq.orderHeader.CreditCardPayment.CreditCard.token = order.Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c;
                           orderReq.orderHeader.CreditCardPayment.CreditCard.customerName = order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__c;
                           
                      }
                  }
                  //orderReq.orderHeader.accountPayment.paymentTerm ='0001';
                 
                  if(order.APTS_SSD_Bill_To__c != null) {
                      //call a util method to assign the address values
                     orderReq.orderHeader.orderAddress.add(assignAddessValues('billTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Bill_To__r.Source_System_Account_Number__c, order.APTS_SSD_Bill_To__r.Name,
                        order.APTS_SSD_Bill_To__r.LCRM_Name_2__c,order.APTS_SSD_Bill_To__r.LCRM_Name_3__c, order.APTS_SSD_Bill_To__r.Number_Street__c, order.APTS_SSD_Bill_To__r.LCRM_Street_2__c,
                        order.APTS_SSD_Bill_To__r.LCRM_Street3__c, order.APTS_SSD_Bill_To__r.LCRM_Street4__c, order.APTS_SSD_Bill_To__r.City__c, order.APTS_SSD_Bill_To__r.State__c,
                        order.APTS_SSD_Bill_To__r.Country__c, order.APTS_SSD_Bill_To__r.Postal_Code__c, order.APTS_SSD_Bill_To__r.LCRM_Phone__c, order.APTS_SSD_Bill_To__r.LCRM_Fax__c, 
                        order.APTS_SSD_Bill_To__r.LCRM_PO_Box__c, order.APTS_SSD_Bill_To__r.LCRM_Email__c, order.APTS_SSD_Bill_To__r.County__c, order.APTS_SSD_Bill_To__r.LCRM_Building__c, 
                        order.APTS_SSD_Bill_To__r.LCRM_VAT__c, order.APTS_SSD_Bill_To__r.LCRM_Tax_Number__c, order.APTS_SSD_Bill_To__c,order.APTS_SSD_Bill_To__r.CurrencyIsoCode));                                                                                      
                       
                  }
                  
                  if(order.APTS_SSD_Sold_To__c != null) {
                     orderReq.orderHeader.orderAddress.add(assignAddessValues('soldTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Sold_To__r.Source_System_Account_Number__c, order.APTS_SSD_Sold_To__r.Name,
                        order.APTS_SSD_Sold_To__r.LCRM_Name_2__c,order.APTS_SSD_Sold_To__r.LCRM_Name_3__c, order.APTS_SSD_Sold_To__r.Number_Street__c, order.APTS_SSD_Sold_To__r.LCRM_Street_2__c,
                        order.APTS_SSD_Sold_To__r.LCRM_Street3__c, order.APTS_SSD_Sold_To__r.LCRM_Street4__c, order.APTS_SSD_Sold_To__r.City__c, order.APTS_SSD_Sold_To__r.State__c,
                        order.APTS_SSD_Sold_To__r.Country__c, order.APTS_SSD_Sold_To__r.Postal_Code__c, order.APTS_SSD_Sold_To__r.LCRM_Phone__c, order.APTS_SSD_Sold_To__r.LCRM_Fax__c, 
                        order.APTS_SSD_Sold_To__r.LCRM_PO_Box__c,order.APTS_SSD_Sold_To__r.LCRM_Email__c, order.APTS_SSD_Sold_To__r.County__c, order.APTS_SSD_Sold_To__r.LCRM_Building__c, 
                        order.APTS_SSD_Sold_To__r.LCRM_VAT__c, order.APTS_SSD_Sold_To__r.LCRM_Tax_Number__c, order.APTS_SSD_Sold_To__c,order.APTS_SSD_Sold_To__r.CurrencyIsoCode));                                  
                  
                  }     
                  if(order.APTS_SSD_Ship_To__c != null) {
                     orderReq.orderHeader.orderAddress.add(assignAddessValues('shipTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Ship_To__r.Source_System_Account_Number__c, order.APTS_SSD_Ship_To__r.Name,
                        order.APTS_SSD_Ship_To__r.LCRM_Name_2__c,order.APTS_SSD_Ship_To__r.LCRM_Name_3__c, order.APTS_SSD_Ship_To__r.Number_Street__c, order.APTS_SSD_Ship_To__r.LCRM_Street_2__c,
                        order.APTS_SSD_Ship_To__r.LCRM_Street3__c, order.APTS_SSD_Ship_To__r.LCRM_Street4__c, order.APTS_SSD_Ship_To__r.City__c, order.APTS_SSD_Ship_To__r.State__c,
                        order.APTS_SSD_Ship_To__r.Country__c, order.APTS_SSD_Ship_To__r.Postal_Code__c, order.APTS_SSD_Ship_To__r.LCRM_Phone__c, order.APTS_SSD_Ship_To__r.LCRM_Fax__c, 
                        order.APTS_SSD_Ship_To__r.LCRM_PO_Box__c, order.APTS_SSD_Ship_To__r.LCRM_Email__c, order.APTS_SSD_Ship_To__r.County__c, order.APTS_SSD_Ship_To__r.LCRM_Building__c, 
                        order.APTS_SSD_Ship_To__r.LCRM_VAT__c, order.APTS_SSD_Ship_To__r.LCRM_Tax_Number__c, order.APTS_SSD_Ship_To__c,order.APTS_SSD_Ship_To__r.CurrencyIsoCode));                           
                  }
                  if(order.APTS_Payer__c!=null)                 {
                     orderReq.orderHeader.orderAddress.add(assignAddessValues('payer', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_Payer__r.Source_System_Account_Number__c, order.APTS_Payer__r.Name,
                        order.APTS_Payer__r.LCRM_Name_2__c,order.APTS_Payer__r.LCRM_Name_3__c, order.APTS_Payer__r.Number_Street__c, order.APTS_Payer__r.LCRM_Street_2__c,
                        order.APTS_Payer__r.LCRM_Street3__c, order.APTS_Payer__r.LCRM_Street4__c, order.APTS_Payer__r.City__c, order.APTS_Payer__r.State__c,
                        order.APTS_Payer__r.Country__c, order.APTS_Payer__r.Postal_Code__c, order.APTS_Payer__r.LCRM_Phone__c, order.APTS_Payer__r.LCRM_Fax__c, 
                        order.APTS_Payer__r.LCRM_PO_Box__c,order.APTS_Payer__r.LCRM_Email__c, order.APTS_Payer__r.County__c, order.APTS_Payer__r.LCRM_Building__c, order.APTS_Payer__r.LCRM_VAT__c, 
                        order.APTS_Payer__r.LCRM_Tax_Number__c, order.APTS_Payer__c,order.APTS_Payer__r.CurrencyIsoCode));                              
                  }
                  System.debug(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__c + '************' +order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c!=null);
                  // Send Partner Info and Contact SSd Info for Ship to Type                  
                  if(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__c!=null){
                        orderReq.orderHeader.orderAddress.add(assignAddressValuesGLIContact('ShipToContact',
                        order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.Person_ID__c,
                        order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__c,'',order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.FirstName,order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.LastName,order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.Email)); 
                        if(!setContactSSDIds.contains(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__c) && order!=null &&  order.Apttus_QPConfig__ProposalId__c!=null &&
                           order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__c!=null){
                                orderReq.OrderHeader.OrderContact.add(assignOrderContacts(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.FirstName, 
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.LastName,
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__r.Email, 
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__c));   
                                setContactSSDIds.add(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Ship_To_Contact__c);
                        }
                  }   
                  // Send Partner Info and Contact SSd Info for Sold to Type
                  if(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r!=null){
                   orderReq.orderHeader.orderAddress.add(assignAddressValuesGLIContact('SoldToContact',
                           order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.Person_ID__c,
                           order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__c,'',order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.FirstName,order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.LastName,order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.Email));                            
                           if(!setContactSSDIds.contains(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__c) && order!=null &&  order.Apttus_QPConfig__ProposalId__c!=null &&
                           order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__c!=null){
                                orderReq.OrderHeader.OrderContact.add(assignOrderContacts(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.FirstName, 
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.LastName,
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__r.Email, 
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__c));  
                                setContactSSDIds.add(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Sold_To_Contact__c);
                            }
                  }   
                  // Send Partner Info and Contact SSd Info for Bill to Type
                  if(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c==false){   
                            orderReq.orderHeader.orderAddress.add(assignAddressValuesGLIContact('BillToContact',
                           order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.Person_ID__c,
                           order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c,'Ebill',order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.FirstName,order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.LastName,order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.Email)); 
                           if(!setContactSSDIds.contains(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c) && order!=null &&  order.Apttus_QPConfig__ProposalId__c!=null &&
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c!=null){
                                orderReq.OrderHeader.OrderContact.add(assignOrderContacts(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.FirstName, 
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.LastName,
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.Email, 
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c)); 
                                setContactSSDIds.add(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c);
                               }
                  }   
                  else if(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c==True){
                   orderReq.orderHeader.orderAddress.add(assignAddressValuesGLIContact('BillToContact',
                           order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.Person_ID__c,
                           order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c,'',order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.FirstName,order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.LastName,order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.Email)); 
                           if(!setContactSSDIds.contains(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c) && order!=null &&  order.Apttus_QPConfig__ProposalId__c!=null &&
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c!=null){
                                orderReq.OrderHeader.OrderContact.add(assignOrderContacts(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.FirstName, 
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.LastName,
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__r.Email, 
                                order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c)); 
                                setContactSSDIds.add(order.Apttus_QPConfig__ProposalId__r.APTS_GLI_Bill_To_Contact__c);
                               }
                  }  
                  //assign Order contact to Order Header
                  CreateS4HANAOrderRequest.orderContact ordcontact = new CreateS4HANAOrderRequest.orderContact();
                  ordcontact.ContactType = '55';
                  ordcontact.department= order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Department;
                  ordcontact.language='';
                  ordcontact.systemReferenceID='';
                  ordcontact.sourceId='';
                  ordcontact.status='';
                  ordcontact.createDate='';
                  ordcontact.enddate='';
                  ordcontact.hardBounce='';         
                  ordcontact.address.firstName = order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName;
                  ordcontact.address.lastName = order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName;
                  ordcontact.address.emailAddress = order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email;
                  orderReq.OrderHeader.OrderContact.add(ordcontact);  
                  
               /*   if(order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c!=null){
                     CreateS4HANAOrderRequest.orderContact eBillingContact = new CreateS4HANAOrderRequest.orderContact();
                     eBillingContact.address.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.FirstName;
                     eBillingContact.address.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.LastName; 
                     eBillingContact.address.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Email;
                     eBillingContact.address.phone=null;
                     eBillingContact.address.extension=null;
                     eBillingContact.address.externalContactId=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c;
                     eBillingContact.address.fax=null;
                     eBillingContact.contactFunction.functionValue=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Contact_Type__c;
                     eBillingContact.address.building=null;
                     eBillingContact.address.floor=null;
                     eBillingContact.address.room=null;
                     eBillingContact.ContactType= '30';
                    
                     orderReq.OrderHeader.OrderContact.add(eBillingContact);  
                         
                  } */ 
                  //Logic to process the Order details and assign to BOOMI request End.   
                  
                  List<Apttus_Config2__OrderLineItem__c> olirecord = [Select Id,Apttus_Config2__OrderId__r.id from Apttus_Config2__OrderLineItem__c 
                  where Apttus_Config2__OrderId__r.id=: orderId];
                  Integer olisize = 1,bundleline;
                  DateTime sysNow;
                  System.debug('$$$$$$$$$$ oli size' +olirecord.size());
                  for(Apttus_Config2__OrderLineItem__c oli :order.Apttus_Config2__OrderLineItems__r) {
                      system.debug('oli : '+oli);
                      orderLine = new CreateS4HANAOrderRequest.orderLines();
                      //orderLine.orderLineNumber=String.valueof(oli.Apttus_Config2__LineNumber__c);
                      orderLine.orderLineNumber = String.valueof(olisize);
                      if(oli.Apttus_Config2__LineType__c == 'Product/Service' && oli.Apttus_Config2__HasOptions__c == true){
                        bundleline = olisize;
                      } 
                      orderLine.sourceOrTargetReferenceLineNumber=oli.Name;
                      //orderLine.sourceOrTargetReferenceLineNumber=oli.Apttus_QPConfig__ProposalLineItemId__r.Name; Commented By Poorva
                      orderLine.quantity = oli.Apttus_Config2__Quantity__c.intvalue();
                      orderLine.unitOfMeasure = 'EA';
                      orderLine.priceDate =String.valueof(oli.Apttus_Config2__PricingDate__c);
                      orderLine.paymentMethod ='';
                      orderLine.copyCreditCardInfo='';
                         //Added for DOC-8629 by Poorva
                      if(oli.Apttus_QPConfig__ProposalLineItemId__c != null){
                          orderLine.ipFlag = oli.Apttus_QPConfig__ProposalLineItemId__r.IP_Address_Check__c;
                          orderLine.isOnlinecontactsExist = oli.Apttus_QPConfig__ProposalLineItemId__r.APTS_Online_Contacts_Validation__c;
                      }
                      //DOC- 8629 ends
                      
                      DateTime effectivdate;
                      /*effectivdate = oli.APTS_Start_Date__c== null ? oli.Apttus_Config2__StartDate__c : oli.APTS_Start_Date__c;
                      //orderLine.effectiveDate=oli.APTS_Start_Date__c;
                      if(effectivdate != null ){
                          orderLine.effectiveDate=effectivdate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
                      }
                      orderLine.endDate=oli.Apttus_Config2__EndDate__c;*/
                      orderLine.acceptanceDate = '';
                      orderLine.taxAmount=NULL;
                      orderLine.shippingMethod='';
                      orderLine.onlineChargesEligible='';
                      orderLine.taxExempt='';
                      orderLine.linePurchaseOrderNumber='';
                      orderLine.numberOfUsers=NULL;
                      orderLine.billPlanType = oli.Apttus_Config2__BillingFrequency__c;
                      if(oli.Apttus_Config2__SellingFrequency__c == 'Monthly'){
                          orderLine.listAmount= (oli.Apttus_Config2__ListPrice__c).setScale(2);
                          orderLine.netAmount= (oli.Apttus_Config2__NetUnitPrice__c).setScale(2);
                      }
                      else if(oli.Apttus_Config2__SellingFrequency__c == 'Yearly'){
                          orderLine.listAmount= (oli.Apttus_Config2__ListPrice__c/12).setScale(2);
                          orderLine.netAmount= (oli.Apttus_Config2__NetUnitPrice__c/12).setScale(2);
                      }
                      //DOC-10224 : CUAS + 1: send True / False
                      orderLine.numberOfAdditionalUsers = oli.APTS_CUAS1__c  == null ? false : oli.APTS_CUAS1__c;
                      orderReq.orderLines.add(orderLine);
                      
                      lstOfMaterial = new CreateS4HANAOrderRequest.Material(); 
                      orderLine.subscriptionDetail.contractNumber=String.valueof(oli.APTS_Contract_Number__c);
                      orderLine.subscriptionDetail.contractLineNumber=String.valueOf(oli.APTS_Contract_Line_Number__c);
                      // Added for coterm integration by Poorva
                     if(oli.APTS_Term_Type__c == 'Co-Term' || oli.APTS_Term_Type__c == 'Future Start Date and Co-Term'){
                          orderLine.subscriptionDetail.cotermPrice= oli.APTS_Calculated_Year_1__c.setScale(2) ;
                      }
                        //Roma Starts
                       if(oli.Apttus_Config2__LineStatus__c =='New')
                           orderLine.subscriptionDetail.revenueType='N';
                       else if(oli.Apttus_Config2__LineStatus__c =='Renewed')
                       orderLine.subscriptionDetail.revenueType='R';
                          
                       if(oli.APTS_Renewal_Type__c == 'Auto Renew')
                           orderLine.subscriptionDetail.renewalPlanType= 'A';
                       else if(oli.APTS_Renewal_Type__c == 'Non-Renewable')
                           orderLine.subscriptionDetail.renewalPlanType= 'NR';
                       else if(oli.APTS_Renewal_Type__c == 'Term Commitment')
                           orderLine.subscriptionDetail.renewalPlanType= 'T';
                       else if(oli.APTS_Renewal_Type__c == 'Evergreen')
                           orderLine.subscriptionDetail.renewalPlanType= 'E';
                           
                        //Roma Ends 
                        
                      //Term Type: Differentiate whether coterm or future date 
                      if(oli.APTS_Term_Type__c != null){
                      if(oli.APTS_Term_Type__c == 'Future Start Date' || (oli.APTS_Term_Type__c == 'Future Start Date and Co-Term' && oli.APTS_Bridge__c == NULL))
                           orderLine.subscriptionDetail.termType = 'X';
                       else if(oli.APTS_Term_Type__c == 'Co-Term' || (oli.APTS_Term_Type__c == 'Future Start Date and Co-Term' && oli.APTS_Bridge__c != NULL))
                           orderLine.subscriptionDetail.termType = 'Y'; 
                      }     
                        
            /* Description: MYR
              Created On 12 Sep 2019 , Roma
              DOC-5499
            */
                CreateS4HANAOrderRequest.SubscriptionTerms subsTerms = new CreateS4HANAOrderRequest.SubscriptionTerms();
                    Integer period =0;
                    Integer myrMonths = 0;
                    String myrPeriod;
                    double bvalue;
                    if(oli.APTS_Contract_Term__c!= null){
                    if(oli.APTS_Contract_Term__c== '1 Year'){
                        period =1 ;
                        myrPeriod = '01YEAR';
                        myrMonths = 12;}
                    if(oli.APTS_Contract_Term__c== '2 Years'){
                        period =2 ;
                        myrPeriod = '02YEAR';
                        myrMonths = 24;}
                    if(oli.APTS_Contract_Term__c== '3 Years'){
                        period =3 ;
                        myrPeriod = '03YEAR';
                        myrMonths=36;}
                    if(oli.APTS_Contract_Term__c== '4 Years'){
                        myrMonths = 48;
                        myrPeriod = '04YEAR';
                        period =4 ;}
                    if(oli.APTS_Contract_Term__c== '5 Years'){
                        period =5 ;
                        myrPeriod = '05YEAR';
                        myrMonths =60;}
                    for(integer i=0; i<period ;i++)
                    {
                    
                    
                    bvalue = 0;
                        system.debug('@@@@@@@RKK'+subsTerms.termLength + 'PI$$$ ' + subsTerms.percentIncrease + 'BV%% ' + subsTerms.baseValue );
                       
                        if(i==0)
                            bvalue = Double.valueOf(oli.APTS_Calculated_Year_1__c);
                        if(i==1)
                            bvalue = Double.valueOf(oli.APTS_Calculated_Year_2__c);
                        if(i==2)
                            bvalue = Double.valueOf(oli.APTS_Calculated_Year_3__c);
                        if(i==3)
                            bvalue = Double.valueOf(oli.APTS_Calculated_Year_4__c);
                        if(i==4)
                            bvalue = Double.valueOf(oli.APTS_Calculated_Year_5__c);
                        if(oli.APTS_Contract_Term__c != null && oli.APTS_Years_2_Plus_Adjustment__c != null){
                           subsTerms = new CreateS4HANAOrderRequest.SubscriptionTerms();
                            subsTerms.period = i;
                            subsTerms.termLength = String.valueOf(period);
                            if(i==0){
                                subsTerms.percentIncrease = 0;
                            }
                            else
                            {
                                subsTerms.percentIncrease = Double.valueOf(oli.APTS_Years_2_Plus_Adjustment__c);
                            } 
                            subsTerms.baseValue = bvalue;
                            orderLine.subscriptionDetail.SubscriptionTerms.add(subsTerms);
                            system.debug('RK @@@@@@@RKK'+subsTerms.termLength + 'PI$$$ ' + subsTerms.percentIncrease + 'BV%% ' + subsTerms.baseValue );
                            system.debug('RRKKK @@@@@@@RKK '+ oli.APTS_Contract_Term__c + 'PI$$$ ' + oli.APTS_Years_2_Plus_Adjustment__c + 'BV%% ' + bvalue);
                           } 
                     }
                   }  
                     Date contractstartdate,contractenddate;
                     //MYR Date Starts by Roma
                         if(oli.Apttus_Config2__LineStatus__c =='New' || oli.Apttus_Config2__LineStatus__c =='Existing'){
                                if(oli.APTS_Bridge__c == null && oli.APTS_Term_Type__c == null)
                                {
                                    contractstartdate = System.Date.today();
                                    contractenddate = System.Date.today().addMonths(1).toStartOfMonth().addMonths(myrMonths).addDays(-1);
                                     system.debug(' END DATe RRKKK @@@@@@@RKK '+ contractenddate + ' RKK START DATE **' + contractstartdate );
                                }
                                else if(oli.APTS_Bridge__c == null && oli.APTS_Term_Type__c == 'Future Start Date')
                                {
                                    contractstartdate = oli.Apttus_Config2__StartDate__c;contractenddate = oli.Apttus_Config2__StartDate__c.addMonths(myrMonths).addDays(-1);
                                    system.debug(' END DATe RRKKK @@@@@@@RKK '+ contractenddate + ' RKK START DATE **' + contractstartdate + ' ***APTS_Term_Type__c ** ' + oli.APTS_Term_Type__c );
                                }
                                //DOC-4652 Added by Nandha
                                else if(oli.APTS_Bridge__c == null && oli.APTS_Term_Type__c == 'Co-Term'){          
                                        contractstartdate = System.Date.today();contractenddate = oli.Apttus_Config2__EndDate__c;
                                        system.debug(' END DATe RRKKK @@@@@@@RKK '+ contractenddate + ' RKK START DATE **' + contractstartdate + ' ***APTS_Term_Type__c ** ' + oli.APTS_Term_Type__c );
                                    }
                                //DOC-7345 Added by Nandha
                                else if(oli.APTS_Bridge__c == null && oli.APTS_Term_Type__c == 'Future Start Date and Co-Term'){          
                                        contractstartdate = oli.Apttus_Config2__StartDate__c;contractenddate = oli.Apttus_Config2__EndDate__c;
                                        system.debug(' END DATe RRKKK @@@@@@@RKK '+ contractenddate + ' RKK START DATE **' + contractstartdate + ' ***APTS_Term_Type__c ** ' + oli.APTS_Term_Type__c );
                                    }
                             }
                             //MYR Date Ends
                             
                             //Renewal Date Calculation by Roma
                             if(oli.Apttus_Config2__LineStatus__c =='Renewed' && oli.Apttus_Config2__StartDate__c != null){
                                 contractstartdate = oli.Apttus_Config2__StartDate__c;
                                 contractenddate = oli.Apttus_Config2__StartDate__c.addMonths(myrMonths).addDays(-1);
                                 System.debug('contractstartdate : '+contractstartdate);
                             }
                     
                     //Bridge Changes to Enddate - Added by Nandha
                     Integer bridgemonths =0;
                     String bridgetosom;
                     if(oli.APTS_Bridge__c != NULL){
                         System.debug('Kh*** oli.APTS_Bridge__c===>'+oli.APTS_Bridge__c);
                         if(oli.APTS_Bridge__c == '1 Month' || oli.APTS_Bridge__c == '2 Months' || oli.APTS_Bridge__c == '3 Months' || oli.APTS_Bridge__c == '4 Months' || oli.APTS_Bridge__c == '5 Months' || oli.APTS_Bridge__c == '6 Months' || oli.APTS_Bridge__c == '7 Months' || oli.APTS_Bridge__c == '8 Months' || oli.APTS_Bridge__c == '9 Months'){
                            bridgetosom = oli.APTS_Bridge__c;
                            bridgetosom = '0'+bridgetosom.left(1);
                            bridgemonths = integer.valueof(bridgetosom);
                            bridgetosom = bridgetosom+'MONTH';
                            System.debug('Kh*** 1. bridgemonths===>'+bridgemonths);
                            System.debug('Kh*** 1. bridgetosom===>'+bridgetosom);
                         }
                         if(oli.APTS_Bridge__c == '10 Months' || oli.APTS_Bridge__c == '11 Months'){
                            bridgetosom = oli.APTS_Bridge__c;bridgetosom = bridgetosom.left(2);bridgemonths = integer.valueof(bridgetosom);bridgetosom = bridgetosom+'MONTH';
                         }
                         System.debug('Kh*** 2. bridgemonths===>'+bridgemonths);
                         System.debug('Kh*** 2. bridgetosom===>'+bridgetosom);
                         System.debug('bridgemonths'+bridgemonths+'bridgetosom'+bridgetosom);
                         
                         System.debug('Kh*** APTS_Term_Type__c===>'+oli.APTS_Term_Type__c);
                        if(oli.APTS_Term_Type__c == 'Future Start Date'){
                            contractstartdate = oli.Apttus_Config2__StartDate__c;
                            contractenddate = oli.Apttus_Config2__StartDate__c.addMonths(bridgemonths).addMonths(myrMonths).addDays(-1);
                            System.debug('Bridge @ 3a : '+oli.Apttus_Config2__EndDate__c+' : '+contractstartdate);
                            System.debug('Kh*** 3. contractstartdate===>'+oli.Apttus_Config2__StartDate__c);
                            System.debug('Kh*** 3. contractenddate===>'+contractenddate);
                        }
                        else if(oli.APTS_Term_Type__c == 'Future Start Date and Co-term'){
                            contractstartdate = System.Date.today();
                            contractenddate = oli.Apttus_Config2__EndDate__c;
                            System.debug('Bridge @ 3b : '+oli.Apttus_Config2__EndDate__c+' : '+contractstartdate);
                        }
                        else if(oli.Apttus_Config2__LineStatus__c =='New'){ 
                            System.debug('Kh*** Apttus_Config2__LineStatus__c===>'+oli.Apttus_Config2__LineStatus__c);
                            contractstartdate = System.Date.today();
                            contractenddate = System.Date.today().addMonths(1).toStartOfMonth().addMonths(myrMonths).addMonths(bridgemonths).addDays(-1);
                             System.debug('Bridge @ 3c : '+oli.Apttus_Config2__EndDate__c+' : '+contractstartdate);
                          }   
                     }
                     //Bridge Changes to Enddate - Added by Nandha
                     
                       // commented by Roma
                      /* DateTime stdate=  oli.Apttus_Config2__StartDate__c;
                       DateTime enddate=  oli.Apttus_Config2__EndDate__c;
                       if(stdate != null ){
                          orderLine.subscriptionDetail.contractStartDate =stdate.format('yyyy-MM-dd\'T\'HH:mm:ss');
                       }
                       if(enddate != null ){
                          orderLine.subscriptionDetail.contractEndDate=enddate.format('yyyy-MM-dd\'T\'HH:mm:ss'); 
                      }*/
                      
                        //Added by Roma                        
                       // Added By Poorva as part of DOC-8740
                        if(oli.Apttus_Config2__LineType__c == 'Product/Service'){
                           sysNow = System.now();
                        }
                        System.debug('contractstartdate : '+contractstartdate+' : '+sysNow);
                        DateTime stdate=  DateTime.newInstanceGmt(contractstartdate, sysNow.time());
                        DateTime enddate=  DateTime.newInstanceGmt(contractenddate,sysNow.time());
                        
                           if(stdate != null ){
                                orderLine.subscriptionDetail.contractStartDate = stdate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                                System.debug('CONTRACT START DATE **** ' + orderLine.subscriptionDetail.contractStartDate );
                                // Added By Poorva for entitlement date
                                orderLine.effectiveDate= stdate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
                           }
                           if(enddate != null ){
                              orderLine.subscriptionDetail.contractEndDate = enddate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                              System.debug('CONTRACT START DATE **** ' + orderLine.subscriptionDetail.contractEndDate );
                               orderLine.endDate= enddate.Date();
                          }
                     
                     // Commented By Roma
                       /*DateTime stdate=  oli.APTS_Start_Date__c== null ? oli.Apttus_Config2__StartDate__c : oli.Apttus_Config2__StartDate__c;
                       DateTime enddate=  oli.Apttus_Config2__EndDate__c;
                       if(stdate != null ){
                          orderLine.subscriptionDetail.contractStartDate =stdate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
                       }
                       if(enddate != null ){
                          orderLine.subscriptionDetail.contractEndDate=enddate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss'); 
                      }*/
                      //orderLine.subscriptionDetail.contractStartDate =oli.Apttus_Config2__StartDate__c;
                      //orderLine.subscriptionDetail.contractEndDate=oli.Apttus_Config2__EndDate__c; 
                      if(oli.Apttus_Config2__LineStatus__c == 'New'){
                          orderLine.actionCode = 'NEW'; 
                      }else if(oli.Apttus_Config2__LineStatus__c == 'Renewed'){
                           orderLine.actionCode = 'RENEW'; 
                      }else if(oli.Apttus_Config2__LineStatus__c == 'Cancelled'){
                           orderLine.actionCode = 'LAPSE'; 
                      }    
                      if(oli.Apttus_Config2__PriceUom__c == 'Concurrent'){
                          orderLine.numberOfConcurrentUsers =  oli.Apttus_Config2__Quantity__c.intvalue(); 
                      }    
                      system.debug('oli.Apttus_Config2__AssetLineItemId__r.Asset_Auto_Number__c : '+oli.Apttus_Config2__AssetLineItemId__r.Asset_Auto_Number__c);            
                      //Added By Poorva for getting asset numbers
                      if(oli.Apttus_Config2__LineType__c == 'Product/Service'){
                    materialMap.put(oli.Apttus_QPConfig__ProposalLineItemId__c, decimal.valueOf(olisize));
                      }
              if(oli.Apttus_Config2__AssetLineItemId__r.Asset_Auto_Number__c != null)
                      {
                        //materialMap.put(oli.Apttus_Config2__AssetLineItemId__r.Asset_Auto_Number__c, oli.Apttus_Config2__LineNumber__c);
                        CreateS4HANAOrderRequest.assets assetObj = new CreateS4HANAOrderRequest.assets();
                        assetObj.assetId = oli.Apttus_Config2__AssetLineItemId__r.Asset_Auto_Number__c;
                        orderLine.assets.add(assetObj);
                      }/*else if(oli.Apttus_Config2__LineStatus__c =='Renewed'){
                          //materialMap.put(oli.Asset_Auto_Number__c, oli.Apttus_Config2__LineNumber__c);
                          CreateS4HANAOrderRequest.assets assetObj = new CreateS4HANAOrderRequest.assets();
                          assetObj.assetId = oli.Apttus_Config2__AssetLineItemId__r.Asset_Auto_Number__c;
                          orderLine.assets.add(assetObj);
                      }*/
                      olisize = olisize + 1;
                                            
                      CreateS4HANAOrderRequest.adjustments adjustment= new CreateS4HANAOrderRequest.adjustments();
                      //adjustment.discountType='PERCENT';
                       if(oli.Apttus_Config2__AdjustmentType__c=='% Discount' || (oli.Apttus_Config2__AdjustmentType__c=='Price Override' && oli.Apttus_Config2__BaseExtendedPrice__c > oli.Apttus_Config2__AdjustedPrice__c))
                       {
                       adjustment.discountType='PERCENT';
                      if(oli.Apttus_Config2__AdjustmentAmount__c != null){
                          adjustment.discountPercent=oli.Apttus_Config2__AdjustmentAmount__c.setScale(2);
                          //adjustment.discountPercent=(oli.Apttus_Config2__BaseExtendedPrice__c-oli.Apttus_Config2__AdjustedPrice__c).intvalue();
                      }    
                      orderLine.adjustments.add(adjustment);
                      }
                      if(oli.Apttus_Config2__AdjustmentType__c=='% Markup' || (oli.Apttus_Config2__AdjustmentType__c=='Price Override' && oli.Apttus_Config2__AdjustedPrice__c > oli.Apttus_Config2__BaseExtendedPrice__c)){
                       adjustment.discountType='FIXED_MARKUP';
                       adjustment.discountPercent= adjustment.discountPercent=oli.Apttus_Config2__AdjustmentAmount__c.setScale(2);
                       // adjustment.discountPercent=(oli.Apttus_Config2__AdjustedPrice__c-oli.Apttus_Config2__BaseExtendedPrice__c).intvalue();
                            orderLine.adjustments.add(adjustment);
                        }
                       //Bridges added by Priyanka 09/11
                        if(oli.APTS_New_Bridge_Discount__c!=null && oli.APTS_Bridge__c !=null){
                        // value is overiding so created new instance of adjustments
                        CreateS4HANAOrderRequest.adjustments adjustment1 = new CreateS4HANAOrderRequest.adjustments();
                        adjustment1.discountPeriod = bridgetosom;
                        adjustment1.discountType = 'Z_BRIDGE_DUR';
                        adjustment1.discountPercent =oli.APTS_New_Bridge_Discount__c.setScale(2);
                        orderline.adjustments.add(adjustment1);                                          
                        }
                       // Contract duration Roma 
                        if(oli.APTS_Contract_Term__c != null){
                        // value is overiding so created new instance of adjustments
                        CreateS4HANAOrderRequest.adjustments adjustmentContDur = new CreateS4HANAOrderRequest.adjustments();
                        adjustmentContDur.discountPeriod = myrPeriod;
                        adjustmentContDur.discountType = 'CONTDURA';
                       
                        orderline.adjustments.add(adjustmentContDur);  
                       }  
                        
                      lstOfMaterial = new CreateS4HANAOrderRequest.Material(); 
                        if(oli.Apttus_Config2__ProductId__r.APTS_Pricing_Qty__c)
                          orderLine.quantity = oli.Apttus_Config2__Quantity__c.intValue();
                        if(oli.Apttus_Config2__Description__c != null && oli.Apttus_Config2__Description__c.length() > 40){
                            lstOfMaterial.materialDescription = oli.Apttus_Config2__Description__c.substring(0, 40);
                        }else{
                            lstOfMaterial.materialDescription = oli.Apttus_Config2__Description__c;
                        }    
                        if(oli.Apttus_Config2__LineType__c == 'Option'){
                            lstOfMaterial.materialNumber = oli.Apttus_Config2__OptionId__r.ProductCode;
                            lstOfMaterial.materialId = oli.Apttus_Config2__OptionId__r.ProductCode;
                        }
                        else{
                            lstOfMaterial.materialNumber = oli.Apttus_Config2__ProductId__r.ProductCode;
                            lstOfMaterial.materialId = oli.Apttus_Config2__ProductId__r.ProductCode;
                        }
                        lstOfMaterial.materialType = 'ONLINE';
                        if(oli.Apttus_Config2__DerivedFromId__r.APTS_Product_Delivery__c != NULL){
                            lstOfMaterial.productDelivery = oli.Apttus_Config2__DerivedFromId__r.APTS_Product_Delivery__c;
                        }
                        if(oli.APTS_Product_Variant_ID__c != NULL){
                            lstOfMaterial.productVarient = oli.APTS_Product_Variant_ID__c;
                        }
                        orderLine.material.material =lstOfMaterial;
                        if(oli.Apttus_Config2__LineType__c == 'Product/Service' && oli.Apttus_Config2__HasOptions__c == true){
                             orderLine.bundleIdentifier = 'H';
                             if(bundleline != NULL){
                                  orderLine.relatedLine = String.valueof(bundleline);
                             }                               
                        }
                        else if(oli.Apttus_Config2__LineType__c == 'Option'){
                             orderLine.bundleIdentifier = 'C';
                             if(bundleline != NULL){
                                 orderLine.relatedLine = String.valueof(bundleline);
                             }
                        }
                       //DOC-4999 Gokila
                  }
                  
                  
                 //*****************Online Contact Changes - done By Poorva*****************
                CreateS4HANAOrderRequest.onlineContacts onlineContact = new CreateS4HANAOrderRequest.onlineContacts();
                
                Map <String,CreateS4HANAOrderRequest.onlineContacts> onlineConMap = new Map<String,CreateS4HANAOrderRequest.onlineContacts>();
                CreateS4HANAOrderRequest.onlineContacts objOnlineCont = new CreateS4HANAOrderRequest.onlineContacts();
                List<CreateS4HANAOrderRequest.lineNumberLink> lstConLineNumberLinks = new List<CreateS4HANAOrderRequest.lineNumberLink>();
                CreateS4HANAOrderRequest.lineNumberLink objConLineNumberLinks = new CreateS4HANAOrderRequest.lineNumberLink();
                Map<String, Online_Contacts__c> mapOfAssetNoOnlineContacts = new Map<String, Online_Contacts__c>();
                CreateS4HANAOrderRequest.jobRole jobRole = new CreateS4HANAOrderRequest.jobRole();
                /*
                 *  @Poorva
                 *  This checks if there are same online contacts available for multiple products
                */ 
                System.debug('materialMap : '+materialMap);
                system.debug('onlinecon : '+onlinecon);
                For(Online_Contacts__c onlinecon1 : onlinecon)
                {
                    objConLineNumberLinks = new CreateS4HANAOrderRequest.lineNumberLink();
                    
                    /*if(onlineConMap != null && onlineConMap.containsKey(onlinecon1.Email__c)){
                        
                        onlineContact = new CreateS4HANAOrderRequest.onlineContacts();
                        onlineContact = onlineConMap.get(onlinecon1.Email__c);
                        system.debug('!!$$$$ onlineContact >>>>>'+onlineContact);
                        system.debug('!!$$$$ onlineContact-assetNumber >>>>>'+onlinecon1.QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c);
                        if(onlineContact.onlineContactType!=onlinecon1.Tax_Type__c && (onlineContact.onlineContactType!=null && !onlineContact.onlineContactType.contains(onlinecon1.Tax_Type__c))){
                            onlineContact.onlineContactType = onlineContact.onlineContactType + ',' +onlinecon1.Tax_Type__c;
                            if(onlineContact.onlineContactType != null){
                                if(onlineContact.onlineContactType.contains(';')){
                                    onlineContact.onlineContactType = onlineContact.onlineContactType.replace(';',',');
                                }
                                onlineContact.onlineContactType = removeDups(onlineContact.onlineContactType);
                            }
                        }
                        //if(materialMap.containsKey(onlinecon1.QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c))
                        if(materialMap.containsKey(onlinecon1.QuoteLineItem__c))
                        {
                            lstConLineNumberLinks = onlineContact.lineNumberLink;
                            //objConLineNumberLinks.lineNumber = materialMap.get(onlinecon1.QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c)+'';
                            objConLineNumberLinks.lineNumber = materialMap.get(onlinecon1.QuoteLineItem__c)+'';
                            objConLineNumberLinks.actionCode = onlinecon1.Latam_Action__c.toUpperCase();
                            jobRole = new CreateS4HANAOrderRequest.jobRole();
                            jobRole.role = onlinecon1.Tax_Position__c;
                            objConLineNumberLinks.jobRole.add(jobRole);
                            onlineContact.lineNumberLink.add(objConLineNumberLinks);
                        }
                        onlineConMap.put(onlinecon1.Email__c, onlineContact);             
                    }else
                    {*/
                        onlineContact = new CreateS4HANAOrderRequest.onlineContacts();
                        mapOfAssetNoOnlineContacts.put(onlinecon1.QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c, onlinecon1);
                        
                        onlineContact.firstName = onlinecon1.First_Name__c;
                        onlineContact.lastName = onlinecon1.Last_Name__c;
                        onlineContact.emailAddress = onlinecon1.Email__c;
                        onlineContact.locationAccount = onlinecon1.APTS_Source_System_Detail__r.Source_System_Account_Number__c;
                        onlineContact.onlineContactType = onlinecon1.Tax_Type__c;
                        if(onlineContact.onlineContactType != null && onlineContact.onlineContactType.contains(';')){
                            onlineContact.onlineContactType = onlineContact.onlineContactType.replace(';',',');
                        }
                        onlineContact.phone = null;
                        onlineContact.language = order.createdBy.LanguageLocaleKey;
                        onlineContact.contactNumber = onlinecon1.ContactID__c;
                        system.debug('!!$$$$ onlineContact-assetNumber >>>>>'+onlinecon1.QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c);
                        //if(materialMap.containsKey(onlinecon1.QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c))
                        if(materialMap.containsKey(onlinecon1.QuoteLineItem__c))
                        {
                            //objConLineNumberLinks.lineNumber = materialMap.get(onlinecon1.QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c)+'';
                            objConLineNumberLinks.lineNumber = materialMap.get(onlinecon1.QuoteLineItem__c)+'';
                            objConLineNumberLinks.actionCode = onlinecon1.Latam_Action__c.toUpperCase();
                            jobRole = new CreateS4HANAOrderRequest.jobRole();
                            jobRole.role = onlinecon1.Tax_Position__c;
                            objConLineNumberLinks.jobRole.add(jobRole);
                            onlineContact.lineNumberLink.add(objConLineNumberLinks);
                            // onlineContact.lineNumberLink.lineNumber.add(String.valueof(materialMap.get(onlinecon1.Material__c))); 
                        }
                        orderReq.orderHeader.onlineContacts.add(onlineContact);
                        //onlineContact.externalContactNumber = null;
                        //onlineConMap.put(onlinecon1.Email__c, onlineContact);
                        //system.debug('onlineConMap ### :'+onlineConMap);
                    //}

                    onlinecon1.Latam_Action__c = '';
                }
                //for(CreateS4HANAOrderRequest.onlineContacts onlineCont : onlineConMap.values()){
                //    orderReq.orderHeader.onlineContacts.add(onlineCont);
                //}
               
                  orderReq.orderHeader.oneTimeValue = String.valueof(oneTimeValue.setscale(2));
                  system.debug('orderReq'+orderReq);
                  // Method to make a callout to Dell Boomi
                  HTTPResponse response = new HTTPResponse();
                  
                  response = DellBoomiOrderSubmissionCalloutUtil.sendS4Request(orderReq, 'Quote/Proposal BOOMI call SFDC Error', 'Quote/Proposal', 'OrderSubmissionDellBoomi', 'POST', 'application/json', orderId,order.Retry_Count__c); 
                  String requestBodyStringSafe = JSON.serialize(orderReq);
                  requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"currency_x\":', '\"currency\":');
                  requestBodyStringSafe =requestBodyStringSafe.replaceAll('\"number_x\":', '\"number\":');           
                  DellBoomiOrderSubmissionCalloutUtil.sendEmailtoQuoteOwner(requestBodyStringSafe, response, order.Apttus_QPConfig__ProposalId__r.Name, proposalOwner.Email, 'Order Not got processed Sucessfully for the order:', 'Order Failed', 'Quote/Proposal BOOMI Call Failed', 'Quote/Proposal', orderId,order.Retry_Count__c);                        
                  system.debug('response...'+response);
                   if(response.getStatusCode()==200){
                   System.debug('GK$$$$$$$$$$-returning true');
                    return true;
                    //System.debug('GK$$$$$$$$$$-returned true');
                    }
                     System.debug('GK$$$$$$$$$$-returning false');
                         return false;
                         // System.debug('GK$$$$$$$$$$-returned false');
             }catch(Exception ex){
                 System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
                 System.debug('Something went wrong trace '+ex.getstacktracestring()); 
                 System.debug('Something went wrong so printing false');
                 DellBoomiOrderSubmissionCalloutUtil.logException('', 'Something went wrong trace : \n'+ex.getMessage()+'\n'+ex.getstacktracestring(), 'Quote/Proposal', false, orderId,0);
                 return false;
             }
       
       }
       
       /*public static String removeDups(String input){
            String tempStr='';
            Set<String> tempSet = new Set<String>();
            for(String str : input.trim().split(',')){
                if(str!=null && str!=''){
                    tempSet.add(str.trim());
                }
            }
            for(String str : tempSet){
                tempStr=(tempStr==null || tempStr=='')?str:tempStr+','+str;
            }          
            system.debug('tempStr : '+tempStr);
            return tempStr;
       }*/
       /*=================================================================================
    Method to set MYR Terms details for renewals
    ===================================================================================
   
    public static void orderTerms(string contractTerm, Decimal baseValue, string adjustment, string status,String termtype ,Decimal proratevalue) {
        //Contract Term =0 //SOC-6437 May Bijeta For short term
        if(string.valueof(contractTerm)=='Short Term Trial')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
                        
                orderTermsUtil('0', baseValue, adjustment, status, 0, proratevalue, termtype);           
        }
        //Contract Term =1
        if(string.valueof(contractTerm)=='1 Year')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status == 'New' && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate')){
                orderTermsUtil('1',proratevalue,adjustment,status,1, proratevalue,termtype);
            }
            else {
                orderTermsUtil('1',baseValue,adjustment,status,1, proratevalue,termtype);
            }
        }
        
        //Contract Term =2  
        if(string.valueof(contractTerm)=='2 Years')
        {  
        // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
                orderTermsUtil('2',baseValue,adjustment,status,2, proratevalue,termtype);
        }
        //Contract Term =3
        if(string.valueof(contractTerm)=='3 Years')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate                      
                orderTermsUtil('3',baseValue,adjustment,status,3, proratevalue,termtype);         
        }
        //Contract Term =4
        if(string.valueof(contractTerm)=='4 Years')
        {  // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate                     
                orderTermsUtil('4',baseValue,adjustment,status,4,proratevalue,termtype);
        }
        //Contract Term =5
        if(string.valueof(contractTerm)=='5 Years')
        {  
            // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate                      
                orderTermsUtil('5',baseValue,adjustment,status,5, proratevalue,termtype);            
        }
        //Contract Term =10
        if(string.valueof(contractTerm)=='10 Years')
        {
            // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate            
                orderTermsUtil('10',baseValue,adjustment,status,10, proratevalue,termtype);           
        }
    }
    */
    /*=================================================================================
    Method to set MYR Terms details
    ===================================================================================
    public static void orderTermsUtil(string contractTerm, Decimal baseValue, string adjustment,String status, Integer period, Decimal proratevalue,String termtype) {
        Integer count = null;
       
        if(period == 0){        
            // If it is not renewel and First term then send Adjustment as 0           
           if(status=='New') {
                orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(0),'0',baseValue,0));
            }
            else {
                orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(0),adjustment,baseValue,0));
            }
        }
        else{
            for(Integer i=1; i <= period; i++) {
                if (i == 1 && status=='New' && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate') ){
                    orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,proratevalue,0));
                }
                // If it is not renewel and First term then send Adjustment as 0
                 //commenting as part of story 
               /* else if(i == 1 && !isRenewel) {
                    orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',baseValue,0));
                }*/             
               /* else {
                    orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,baseValue,0));
                }
            }
        }
    }*/
    /*=================================================================================
    Method For MYR details
    =================================================================================== 
    public static CreateS4HANAOrderRequest.terms termUtil(string tLen, string period, string percInc, Decimal bValue, Decimal uRate) {
        CreateS4HANAOrderRequest.terms term = new CreateS4HANAOrderRequest.terms();
        term.termLength = tLen;
        term.period = period;
        term.percentIncrease = percInc;
        term.baseValue = bValue;
        term.userRate = uRate;
        return term;
    }   
   */ 
        //method to assign the Address field values to the Order address
       public static CreateS4HANAOrderRequest.OrderAddress assignAddessValues(string partnerType, string shipping, string sapNumber, string name, string nameTwo, string nameThree, string st1, string st2, string st3, string st4, string city, string state, string country, string postalCode, string phone, string fax, string poBox, string email, string county, string building, string vatNumber, string taxNumber, id extId,String currencyiso) {
          CreateS4HANAOrderRequest.orderAddress ordaddress = new CreateS4HANAOrderRequest.orderAddress();
          ordaddress.Account = new CreateS4HANAOrderRequest.account();
          ordaddress.partnerType =partnerType ;
          ordaddress.account.accountNumber =sapNumber;
          ordaddress.account.currency_x=currencyiso;
          ordaddress.account.salesOrg= 'S100';
          ordaddress.account.companyId= 'S100';
          ordaddress.account.companyCode= '1078';
          ordaddress.account.companyName= name;
          ordaddress.account.distributionChannel = '00';
          ordaddress.account.division = '00';
          return ordaddress;
    } 
   //method to assign the Address field values to the Order address for Contact SSD 
       public static CreateS4HANAOrderRequest.OrderAddress assignAddressValuesGLIContact(String partnerType,String sapAcctNum, String sfdcContactId,String accountType,String firstname,String lastname,String email){
           CreateS4HANAOrderRequest.orderAddress ordaddress = new CreateS4HANAOrderRequest.orderAddress();
           ordaddress.partnerType = partnerType;
           ordaddress.account.accountType=accountType;
           //ordaddress.extAccountNumber = sfdcContactId;
           ordaddress.account.externalAccountId = sapAcctNum;
           CreateS4HANAOrderRequest.address accaddress = new CreateS4HANAOrderRequest.address();
           accaddress.firstName = firstname;
           accaddress.lastName = lastname;
           accaddress.emailAddress = email;
           ordaddress.account.address.add(accaddress);
           return ordaddress;
       }   
           //method to assign the Contact SSD values to the Order Contact SSD 
       public static CreateS4HANAOrderRequest.orderContact assignOrderContacts(String firstName, String lastName, String emailStr, String sfdcContactId){ 
           CreateS4HANAOrderRequest.orderContact ordcontact = new CreateS4HANAOrderRequest.orderContact();
           ordcontact.address.firstName =firstName;
           ordcontact.address.lastName =lastName;
           ordcontact.address.emailAddress = emailStr;
           ordcontact.contactType = '55';
           ordcontact.contactNumber=sfdcContactId;
           return ordcontact;
       }
}