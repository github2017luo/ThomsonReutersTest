/**
* Interface to send the Lotus Corporate order details to ESI 
* Order Details
*
* @author  TCS
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                            Description 
* 2019-01-18   Keerthana Thallam                 Created(DOC-286 and DOC-326)
* 2019-17-04   Shiva Sri Arun Koralla          Modified(DLT - 16201)
* =============================================================================

*/
// this class is calling from Aptts_BatchOrderSubmission class
 /**
     * @description APTS_CORP_OrderQueuetoESI
 
     */
    public with sharing class APTS_CORP_OrderQueuetoESI  {
    
        public static CorpCreateOrderRequest orderReq;
        public static CorpCreateOrderRequest.OrderLines orderLine;
        public static CorpCreateOrderRequest.orderLapseLines laps;
        public static CorpCreateOrderRequest.Material lstOfMaterial;    
        public static Decimal adjamount;
        
        public static boolean psFlag = false;
         /**
         * @description corporateorderSubmissionToESI
         * @param orderId
        * @return Boolean
         */ 
        public static APTS_Ordersubmissionwrapper corporateorderSubmissionToESI(Id orderId) {
            Apttus_Config2__Order__c order;
            User proposalOwner = new User();
            Decimal oneTimeValue = 0;
            integer lineNumber = 0;
          //  integer rlNumber = 0;
            Decimal netAmount = 0;         
            Set<String> setContactSSDIds=new Set<String>(); // DOC-2023
            orderline = new CorpCreateOrderRequest.OrderLines();
            List<Online_Contacts__c> onlinecon = new List<Online_Contacts__c>();//DOC-2390
            APTS_Ordersubmissionwrapper ordersubwrap = new APTS_Ordersubmissionwrapper();
            String loggerId;
            List<Integration_Logger__c> intLogList = new List<Integration_Logger__c>();
            
            Boolean runOldOrderProcess = false;
            KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
            if(keyValueListRec !=NULL){
                runOldOrderProcess = TRUE;
            }    
            try{   
                if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()&&Schema.sObjectType.Apttus_Config2__Order__c.isQueryable()){
                    order = [SELECT Id, Name,Apttus_QPConfig__ProposalId__r.APTS_Wet_Signature__c,CreatedDate,Retry_Count__c,Apttus_Config2__OrderReferenceNumber__c, Apttus_QPConfig__ProposalId__c,CreatedBy.Apts_Revenue_Channel__c,Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c,
                             CreatedBy.Sales_Force_Description__c,CreatedBy.Market_Segment_Description__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c,Apttus_Config2__Source__c,Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Zipcode__c,
                             Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Country__c,Apttus_QPConfig__ProposalId__r.APTS_Authorization_Transaction__c,
                             Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.City__c, Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Phone__c,
                             Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To_Attention__c,Apttus_QPConfig__ProposalId__r.APTS_MLA_Quote__c,
                             Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Name,Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.State__c, 
                             Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street_Address_3__c, Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street_Address_4__c,
                             Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street__c,Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__c,
                             Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c,Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Assent_Name_of_Rep__r.FirstName,Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Assent_Customer_Name__c,
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
                             Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__c,Apttus_QPConfig__ProposalId__r.APTS_VAT_Number__c,
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
                             Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_Source_Contact_Id__c,Apttus_QPConfig__ProposalId__r.APTS_Notes__c,
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
                             /*        APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
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
                             APTS_SSD_Sold_To__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c,
                             APTS_SSD_Sold_To__r.Name,Apttus_Config2__SoldToAccountId__r.Customer_Group__c,APTS_SSD_Sold_To__r.CreatedBy.Rep_Employee_Number__c,
                             APTS_SSD_Sold_To__r.LCRM_PO_Box__c,
                             APTS_SSD_bill_to__r.Name,APTS_SSD_bill_to__r.LCRM_PO_Box__c,
                             APTS_SSD_Ship_To__r.LCRM_PO_Box__c, Apttus_Config2__Status__c,
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
                             APTS_Payer__r.LCRM_VAT__c, APTS_Payer__r.LCRM_Tax_Number__c,APTS_Payer__r.County__c
                             FROM Apttus_Config2__Order__c WHERE Id =:orderId];
            }
            List<Apttus_Config2__OrderLineItem__c> orderLineItems=new List<Apttus_Config2__OrderLineItem__c>();
            if(Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isQueryable()){
                    orderLineItems=[SELECT Name,Apttus_Config2__LineNumber__c,APTS_Years_2_Plus_Adjustment__c,Apttus_QPConfig__ProposalLineItemId__r.Net_Qty_Difference__c,
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
                              Apttus_Config2__AdjustmentType__c,APTS_Contract_Term__c,Apttus_Config2__ProductId__r.Apttus_Config2__Uom__c,Apttus_Config2__ProductId__r.Product_Level_4__c,Apttus_Config2__ProductId__r.APTS_Cat_L5__c, //Added By Poonam Garg DOC 12648
                              Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c,
                              /*Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c,*/
                              Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c,
                              APTS_New_Bridge_Discount__c,Apttus_Config2__NetUnitPrice__c,
                              Apttus_Config2__OrderId__r.APTS_Order_Value__c,bridge_net_price__c,APTS_Group_Primary_Material__c,Apttus_Config2__AdjustmentAmount__c,
                              APTS_SAP_Deal_Primary_Material__c,APTS_Subscription_Number__c, Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,
                              Apttus_Config2__ChargeType__c, Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c,Apttus_Config2__PriceType__c, 
                              Apttus_Config2__LineType__c, Apttus_Config2__OptionId__c, Apttus_Config2__OptionId__r.ProductCode,
                              Apttus_QPConfig__ProposalId__r.APTS_Renewal_Opt_out__c, Apttus_QPConfig__ProposalId__r.APTS_Fiscal_Filer__c,Apttus_Config2__AdjustedPrice__c,Apttus_Config2__BasePrice__c,
                              Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.APTS_Practice_Area_Code__c,
                              Apttus_Config2__ProductId__r.APTS_Location_Code__c,
                              Apttus_Config2__ProductId__r.Product_Level_5__c,Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,
                              Apttus_Config2__ProductId__r.APTS_Find_Law_Practice_Area__c,
                              Apttus_Config2__OptionId__r.APTS_Find_Law_Practice_Area__c,Apttus_Config2__OptionId__r.APTS_Location_Code__c,
                              Apttus_Config2__OptionId__r.APTS_Practice_Area_Code__c, APTS_FL_Price_Increase_Percentage__c, APTS_Years_2_3_Charges_Disc_Surc__c,
                              /*Apttus_Config2__ProductId__r.WLEC_Progam_ID__c,*/Apttus_QPConfig__ProposalLineItemId__r.APTS_SAP_MLA_Agreement_Number__c,APTS_Number_of_Attorneys__c,APTS_Combination_Key__r.APTS_Attribute_Value1__r.APTS_SAP_Attribute_Code__c,APTS_Combination_Key__r.APTS_Attribute_Value3__r.APTS_SAP_Attribute_Code__c,
                              Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, APTS_SAP_MLA_Agreement_Number__c, APTS_Service_Number__c,Apttus_Config2__ProductId__r.APTS_Pricing_Qty__c, Apttus_Config2__ProductId__r.APTS_Pricing_Qty_Type__c, 
                              APTS_Priced_Number_of_Attorneys__c,APTS_Contract_End_Date__c,APTS_FL_Qty__c,Apttus_Config2__BaseExtendedPrice__c,APTS_WLEC_Product_Category__c,APTS_Fiscal_Year_End__c,
                              APTS_Calculated_Year_1__c,APTS_Calculated_Year_2__c,APTS_Calculated_Year_3__c,APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c,APTS_Is_Multi_Tiered_Pricing__c ,
                              Apttus_Config2__AttributeValueId__c, Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c FROM Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c=: order.id];
            }
            
                if(Schema.sObjectType.User.isAccessible()&&Schema.sObjectType.User.isQueryable()){
                    proposalOwner = [SELECT id,FirstName,LastName,Email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,
                                     Market_Segment_Description__c FROM User where Id=:order.Apttus_QPConfig__ProposalId__r.OwnerId];
                } 
                //DOC-2390 
                if(Schema.sObjectType.Online_Contacts__c.isAccessible()&&Schema.sObjectType.Online_Contacts__c.isQueryable()){
                    onlinecon = [SELECT First_Name__c,
                                 Name,
                                 Material__c,SAP_Account_Number__c,
                                 APTS_Source_System_Detail__c,
                                 APTS_Source_System_Detail__r.Source_System_Account_Number__c,
                                 Account__c,Account__r.SAPAccountNumber__c,
                                 Last_Name__c,
                                 APTS_Source_System_Detail__r.Account_Name__r.AccountNumber,
                                 Email__c,
                                 Is_Banded_Product__c,
                                 ContactID__c,Contact_Name__r.SAP_Contact_ID__c,
                                 ProductId__r.APTS_Media_High_Level_Code__c,
                                 QuoteId__c,
                                 Type__c,
                                 QuoteLineItem__c,
                                 QuoteLineItem__r.Apttus_QPConfig__LineNumber__c,
                                 QuoteLineItem__r.Apttus_Proposal__Product__r.Product_Level_4__c,
                                 QuoteLineItem__r.Apttus_Proposal__Product__r.APTS_Cat_L5__c,//Added By Poonam Garg DOC 12648
                                 Position__c FROM Online_Contacts__c where QuoteId__c =:order.Apttus_QPConfig__ProposalId__c ];        
                }// Logic to process the Order details and assign to ESI request Start
                orderReq = new CorpCreateOrderRequest();
                CorpCreateOrderRequest.orderAddress ordHeaderAddress = new CorpCreateOrderRequest.orderAddress();
                //Assign ESI Header
                orderReq.ESIHeader.applicationId = 'SF10';
                orderReq.ESIHeader.transactionId = order.APTS_SSD_Sold_To__r.LCRM_Sales_Org__c;
                if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Corp OneOTC US'){                  
                    //orderReq.ESIHeader.transactionId = 'TA78';
                    orderReq.ESIHeader.companyId='1078';
                }
                else if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Corp OneOTC UK'){
                    //orderReq.ESIHeader.transactionId = 'TA61';                
                    orderReq.ESIHeader.companyId='3361';
                }
                
                //CXD New Sales ZPEND Application Id and SapOriginating System - DLT - 16201
                if(!Schema.sObjectType.SAP_Originating_System_Mapping__mdt.isAccessible()&& !Schema.sObjectType.SAP_Originating_System_Mapping__mdt.isQueryable()){
                    return null;
                }
                List<SAP_Originating_System_Mapping__mdt> sapMapQuery = [SELECT Id,QuoteType__c,SAP_Originating_System__c,BusinessUnit__c from SAP_Originating_System_Mapping__mdt WHERE QuoteType__c =: order.Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c AND BusinessUnit__c =: order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c LIMIT 1];
                if( !sapMapQuery.isEmpty() )
                {        
                    orderReq.ESIHeader.applicationId = sapMapQuery[0].SAP_Originating_System__c;
                }
                
                //Assign Order Header
                orderReq.orderHeader.OrderNumber = order.Apttus_QPConfig__ProposalId__r.name;
                orderReq.orderHeader.orderAutomationMode='W';
                orderReq.orderHeader.orderType = 'ZNEW';
                orderReq.orderHeader.eBillExempt =order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c;
                orderReq.orderHeader.orderRepresentative.emailAddress = proposalOwner.email;
                if(proposalOwner.Rep_Employee_Number__c!=null && proposalOwner.Rep_Employee_Number__c.startsWithIgnoreCase('X')){
                orderReq.orderHeader.orderRepresentative.representativeNumber = proposalOwner.Rep_Employee_Number__c.removeStart('X');}
                //orderReq.orderHeader.orderReason = order.APTS_Reason__c;
                //orderReq.orderHeader.orderSource = order.Apttus_Config2__Source__c;
                orderReq.orderHeader.orderSource = '37';
                //orderReq.orderHeader.revenueChannel = order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel__c;
                orderReq.orderHeader.orderDescription=order.Apttus_Config2__Description__c;
                orderReq.orderHeader.CreditApproval=order.Apttus_QPConfig__ProposalId__r.APTS_Account_Credit_Risk_Category__c; //Doc-2388
                //orderReq.orderHeader.orderType = order.Apttus_Config2__Type__c;              
                orderReq.orderHeader.orderTimestamp =order.Apttus_Config2__OrderDate__c;
                orderReq.orderHeader.orderCurrency=order.CurrencyIsoCode;
                orderReq.orderHeader.completeDelivery = null;
                //orderReq.orderHeader.internationCodificationTerms = 'FOB';
                ordHeaderAddress.vatNumber = order.Apttus_QPConfig__ProposalId__r.APTS_VAT_Number__c;//DOC-4143
                ordHeaderAddress.Account.salesOrg = order.APTS_SSD_Sold_To__r.LCRM_Sales_Org__c;
                /*if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Corp OneOTC US'){
                ordHeaderAddress.Account.salesOrg = 'TA78';
                }
                else if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Corp OneOTC UK'){
                ordHeaderAddress.Account.salesOrg = 'TA61';
                }*/
                ordHeaderAddress.Account.distributionChannel = 'T';
                ordHeaderAddress.Account.division = 'T';
                orderReq.orderHeader.orderAddress.add(ordHeaderAddress);
                orderReq.orderHeader.noOfAttorneys=order.Number_of_Attorneys__c;
                orderReq.orderHeader.confirmURL = '';
                orderReq.orderHeader.orderPeriodicValue = order.APTS_Periodic_Value__c;
                orderReq.orderHeader.paymentMethod ='';
                
                if(order.Apttus_QPConfig__ProposalId__r.APTS_Wet_Signature__c == true){
                    DateTime dt = order.CreatedDate;
                    orderReq.orderHeader.esignDate = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                    system.debug(LoggingLevel.WARN,'@@@@@@@'+orderReq.orderHeader.esignDate);
                }else{ 
                    if(Schema.sObjectType.Task.fields.id.isAccessible()&&Schema.sObjectType.Task.fields.Subject.isAccessible()&&Schema.sObjectType.Task.fields.Description.isAccessible()){
                        List<Task> taskobj=[Select id,Subject,Description from Task where What.Id=:order.Apttus_QPConfig__ProposalId__c AND Subject LIKE '%Quote/Proposal eSigned by%' limit 1];
                        system.debug(LoggingLevel.WARN,'Task'+taskobj);
                        if(!taskobj.isEmpty()){                       
                            String finalString=taskobj[0].Subject.substringAfterLast('@').replace(' GMT','Z');
                            System.debug(LoggingLevel.WARN,'!!!!'+finalString);
                            orderReq.orderHeader.esignDate = finalString;
                        }else if(taskobj.isEmpty()){
                            DateTime dtme = order.CreatedDate;
                            orderReq.orderHeader.esignDate = dtme.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                        }
                    }      
                }  
                //orderReq.CorpCreateOrderRequest.orderHeader.profileId = '1';
                //orderReq.CorpCreateOrderRequest.orderHeader.WLDID = order.APTS_SSD_Sold_To__r.LCRM_WLD_ID__c;
                
                //assign Revenue Channel of Order Header
                if(!string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c)){         
                orderReq.orderHeader.revenueChannel=order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c;}
                else if(string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c) && string.isEmpty(proposalOwner.Apts_Revenue_Channel__c)) {
                    if(proposalOwner.Market_Segment_Description__c == 'Inside'){
                    orderReq.orderHeader.revenueChannel = '05';}
                    else if(proposalOwner.Sales_Force_Description__c == 'Home Office'){
                    orderReq.orderHeader.revenueChannel = '06';}            
                    else{ 
                    orderReq.orderHeader.revenueChannel = '01';}
                } 
                //DOC-5742 - Rishi Kumar
                orderReq.orderHeader.purchaseOrderNumber = order.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c;
                if(!String.isBlank(orderReq.orderHeader.purchaseOrderNumber) && orderReq.orderHeader.purchaseOrderNumber.length() >= 35){
                    orderReq.orderHeader.purchaseOrderNumber=orderReq.orderHeader.purchaseOrderNumber.substring(0,35);
                }
                //End
                orderReq.orderHeader.actionCode = 'NEW';
                orderReq.orderHeader.quoteDetails.quoteNumber = order.Apttus_QPConfig__ProposalId__r.name;
                //assign OrderRepresentative Details
                /* orderReq.CorpCreateOrderRequest.OrderHeader.OrderRepresentative.firstName = proposalOwner.FirstName;
                orderReq.CorpCreateOrderRequest.OrderHeader.OrderRepresentative.lastName = proposalOwner.LastName;
                orderReq.CorpCreateOrderRequest.OrderHeader.OrderRepresentative.emailAddress = proposalOwner.Email;
                orderReq.CorpCreateOrderRequest.OrderHeader.completeDelivery = null;
                orderReq.CorpCreateOrderRequest.OrderHeader.orderPeriodicValue= string.valueOf(order.APTS_FL_Periodic_Value_FL__c); //String.valueof(PeriodicValue);
                orderReq.CorpCreateOrderRequest.OrderHeader.oneTimeValue=String.valueof(order.APTS_One_Time_Value__c.setScale(2)); //string.valueof(onetimevalue);*/
                
                if(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c == 'Ground Shipping - U.S. Only' || string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c)){          
                orderReq.orderHeader.internationCodificationTerms = 'FOB';}
                else{
                orderReq.orderHeader.internationCodificationTerms = 'ZCH';}
                
                //assign Credit card details to Order Header- DOC-2000 //DLT - 16201
                if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Credit Card' || order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge'){
                    if(order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c != null) { 
                        Datetime expDate= order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c;                 
                        orderReq.orderHeader.CreditCardPayment.CreditCard.expiration = expDate.formatGMT('yyyyMMdd'); //DOC-3186
                    }
                    orderReq.orderHeader.CreditCardPayment.CreditCardAuthorization.authorizationNumber = order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c;
                    orderReq.orderHeader.CreditCardPayment.CreditCardAuthorization.transactionId = order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Transaction__c;
                    orderReq.orderHeader.creditCardPayment.amount = order.Apttus_QPConfig__ProposalId__r.APTS_amount__c; 
                    orderReq.orderHeader.CreditCardPayment.CreditCard.cardType = order.Apttus_QPConfig__ProposalId__r.APTS_Card_Type__c;
                    orderReq.orderHeader.CreditCardPayment.CreditCard.creditCardNumber = order.Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c;
                    orderReq.orderHeader.CreditCardPayment.CreditCard.token = order.Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c;
                    orderReq.orderHeader.CreditCardPayment.CreditCard.customerName = order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__c;
                }
                /*if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Bill to Account'){
                orderReq.orderHeader.accountPayment.accountNumber=order.APTS_SSD_bill_to__r.Source_System_Account_Number__c;
                }*/
                if(order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c != null && !('').equals(order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c)){
                    if(order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c.contains('-')){
                        orderReq.orderHeader.accountPayment.paymentTerm = order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c.split('-')[0].trim().toUpperCase();
                        orderReq.orderHeader.CreditCardPayment.CreditCard.paymentTerm = order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c.split('-')[0].trim().toUpperCase();
                        orderReq.orderHeader.accountPayment.accountNumber= order.APTS_Payer__r.Source_System_Account_Number__c;
                    }else{
                        orderReq.orderHeader.accountPayment.paymentTerm = order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c.toUpperCase();
                        orderReq.orderHeader.CreditCardPayment.CreditCard.paymentTerm = order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Payment_Term__c.toUpperCase();
                        orderReq.orderHeader.accountPayment.accountNumber= order.APTS_Payer__r.Source_System_Account_Number__c;
                    }
                }
                if(order.APTS_SSD_Bill_To__c != null) {
                    //call a util method to assign the address values
                    orderReq.orderHeader.orderAddress.add(assignAddessValues('billTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Bill_To__r.Source_System_Account_Number__c, order.APTS_SSD_Bill_To__r.Name,
                                                                             order.APTS_SSD_Bill_To__r.LCRM_Name_2__c,order.APTS_SSD_Bill_To__r.LCRM_Name_3__c, order.APTS_SSD_Bill_To__r.Number_Street__c, order.APTS_SSD_Bill_To__r.LCRM_Street_2__c,
                                                                             order.APTS_SSD_Bill_To__r.LCRM_Street3__c, order.APTS_SSD_Bill_To__r.LCRM_Street4__c, order.APTS_SSD_Bill_To__r.City__c, order.APTS_SSD_Bill_To__r.State__c,
                                                                             order.APTS_SSD_Bill_To__r.Country__c, order.APTS_SSD_Bill_To__r.Postal_Code__c, order.APTS_SSD_Bill_To__r.LCRM_Phone__c, order.APTS_SSD_Bill_To__r.LCRM_Fax__c, 
                                                                             order.APTS_SSD_Bill_To__r.LCRM_PO_Box__c, order.APTS_SSD_Bill_To__r.LCRM_Email__c, order.APTS_SSD_Bill_To__r.County__c, order.APTS_SSD_Bill_To__r.LCRM_Building__c, 
                                                                             order.Apttus_QPConfig__ProposalId__r.APTS_VAT_Number__c, order.APTS_SSD_Bill_To__r.LCRM_Tax_Number__c, order.APTS_SSD_Bill_To__c));                                                                                      
                }
                if(order.APTS_SSD_Sold_To__c != null) {
                    orderReq.orderHeader.orderAddress.add(assignAddessValues('soldTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Sold_To__r.Source_System_Account_Number__c, order.APTS_SSD_Sold_To__r.Name,
                                                                             order.APTS_SSD_Sold_To__r.LCRM_Name_2__c,order.APTS_SSD_Sold_To__r.LCRM_Name_3__c, order.APTS_SSD_Sold_To__r.Number_Street__c, order.APTS_SSD_Sold_To__r.LCRM_Street_2__c,
                                                                             order.APTS_SSD_Sold_To__r.LCRM_Street3__c, order.APTS_SSD_Sold_To__r.LCRM_Street4__c, order.APTS_SSD_Sold_To__r.City__c, order.APTS_SSD_Sold_To__r.State__c,
                                                                             order.APTS_SSD_Sold_To__r.Country__c, order.APTS_SSD_Sold_To__r.Postal_Code__c, order.APTS_SSD_Sold_To__r.LCRM_Phone__c, order.APTS_SSD_Sold_To__r.LCRM_Fax__c, 
                                                                             order.APTS_SSD_Sold_To__r.LCRM_PO_Box__c,order.APTS_SSD_Sold_To__r.LCRM_Email__c, order.APTS_SSD_Sold_To__r.County__c, order.APTS_SSD_Sold_To__r.LCRM_Building__c, 
                                                                             order.Apttus_QPConfig__ProposalId__r.APTS_VAT_Number__c, order.APTS_SSD_Sold_To__r.LCRM_Tax_Number__c, order.APTS_SSD_Sold_To__c));                                  
                }     
                if(order.APTS_SSD_Ship_To__c != null) {
                    orderReq.orderHeader.orderAddress.add(assignAddessValues('shipTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Ship_To__r.Source_System_Account_Number__c, order.APTS_SSD_Ship_To__r.Name,
                                                                             order.APTS_SSD_Ship_To__r.LCRM_Name_2__c,order.APTS_SSD_Ship_To__r.LCRM_Name_3__c, order.APTS_SSD_Ship_To__r.Number_Street__c, order.APTS_SSD_Ship_To__r.LCRM_Street_2__c,
                                                                             order.APTS_SSD_Ship_To__r.LCRM_Street3__c, order.APTS_SSD_Ship_To__r.LCRM_Street4__c, order.APTS_SSD_Ship_To__r.City__c, order.APTS_SSD_Ship_To__r.State__c,
                                                                             order.APTS_SSD_Ship_To__r.Country__c, order.APTS_SSD_Ship_To__r.Postal_Code__c, order.APTS_SSD_Ship_To__r.LCRM_Phone__c, order.APTS_SSD_Ship_To__r.LCRM_Fax__c, 
                                                                             order.APTS_SSD_Ship_To__r.LCRM_PO_Box__c, order.APTS_SSD_Ship_To__r.LCRM_Email__c, order.APTS_SSD_Ship_To__r.County__c, order.APTS_SSD_Ship_To__r.LCRM_Building__c, 
                                                                             order.Apttus_QPConfig__ProposalId__r.APTS_VAT_Number__c, order.APTS_SSD_Ship_To__r.LCRM_Tax_Number__c, order.APTS_SSD_Ship_To__c));                           
                }
                if(order.APTS_Payer__c!=null)                 {
                    orderReq.orderHeader.orderAddress.add(assignAddessValues('payer', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_Payer__r.Source_System_Account_Number__c, order.APTS_Payer__r.Name,
                                                                             order.APTS_Payer__r.LCRM_Name_2__c,order.APTS_Payer__r.LCRM_Name_3__c, order.APTS_Payer__r.Number_Street__c, order.APTS_Payer__r.LCRM_Street_2__c,
                                                                             order.APTS_Payer__r.LCRM_Street3__c, order.APTS_Payer__r.LCRM_Street4__c, order.APTS_Payer__r.City__c, order.APTS_Payer__r.State__c,
                                                                             order.APTS_Payer__r.Country__c, order.APTS_Payer__r.Postal_Code__c, order.APTS_Payer__r.LCRM_Phone__c, order.APTS_Payer__r.LCRM_Fax__c, 
                                                                             order.APTS_Payer__r.LCRM_PO_Box__c,order.APTS_Payer__r.LCRM_Email__c, order.APTS_Payer__r.County__c, order.APTS_Payer__r.LCRM_Building__c,order.Apttus_QPConfig__ProposalId__r.APTS_VAT_Number__c, 
                                                                             order.APTS_Payer__r.LCRM_Tax_Number__c, order.APTS_Payer__c));                              
                }
                //DOC- 2023 Send Partner Info and Contact SSd Info for Ship to Type                  
                if(order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__c!=null){
                    orderReq.orderHeader.orderAddress.add(assignAddessValuesContactSSD('ShipToContact',
                                                                                       order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_Source_Contact_Id__c,
                                                                                       order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__c)); 
                    if(!setContactSSDIds.contains(order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__c) && order!=null &&  order.Apttus_QPConfig__ProposalId__c!=null &&
                       order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__c!=null &&
                       order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_Source_Contact_Id__c==null){
                           orderReq.OrderHeader.OrderContact.add(assignOrderContacts(order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_First_Name__c, 
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_Last_Name__c,
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__r.LCRM_Email__c, 
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__c));   
                           setContactSSDIds.add(order.Apttus_QPConfig__ProposalId__r.APTS_Ship_To_Contact__c);
                       }
                }      
                //DOC- 2023 Send Partner Info and Contact SSd Info for Sold to Type
                if(order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c!=null){
                    orderReq.orderHeader.orderAddress.add(assignAddessValuesContactSSD('SoldToContact',
                                                                                       order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_Source_Contact_Id__c,
                                                                                       order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c));                            
                    if(!setContactSSDIds.contains(order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c) && order!=null &&  order.Apttus_QPConfig__ProposalId__c!=null &&
                       order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c!=null &&
                       order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_Source_Contact_Id__c==null){
                           orderReq.OrderHeader.OrderContact.add(assignOrderContacts(order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_First_Name__c, 
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_Last_Name__c,
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__r.LCRM_Email__c, 
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c));  
                           setContactSSDIds.add(order.Apttus_QPConfig__ProposalId__r.APTS_Sold_To_Contact__c);
                       }
                }   
                //DOC- 2023 Send Partner Info and Contact SSd Info for Bill to Type
                if(order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__c!=null){
                    orderReq.orderHeader.orderAddress.add(assignAddessValuesContactSSD('BillToContact',
                                                                                       order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_Source_Contact_Id__c,
                                                                                       order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__c)); 
                    if(!setContactSSDIds.contains(order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__c) && order!=null &&  order.Apttus_QPConfig__ProposalId__c!=null &&
                       order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__c!=null &&
                       order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_Source_Contact_Id__c==null){
                           orderReq.OrderHeader.OrderContact.add(assignOrderContacts(order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_First_Name__c, 
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_Last_Name__c,
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__r.LCRM_Email__c, 
                                                                                     order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__c)); 
                           setContactSSDIds.add(order.Apttus_QPConfig__ProposalId__r.APTS_Bill_To_Contact__c);
                       }
                }    
                //assign Order contact to Order Header
                CorpCreateOrderRequest.orderContact ordcontact = new CorpCreateOrderRequest.orderContact();
                ordcontact.address.firstName = order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName;
                ordcontact.address.lastName = order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName;        
                ordcontact.address.emailAddress = order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email;
                ordcontact.ContactType = '55';
                //ordcontact.ContactFunction.functionValue = order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Contact_Type__c;
                ordcontact.contactFunction.functionValue = '55';
                ordcontact.address.phone=null;//DOC-2992
                ordcontact.address.externalContactId=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c;
                ordcontact.address.extension=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Extension__c;
                orderReq.OrderHeader.OrderContact.add(ordcontact);  
                
                
                //DOC-2002 starts added by Keerthana         
                if(order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c!=null){
                    CorpCreateOrderRequest.orderContact eBillingContact = new CorpCreateOrderRequest.orderContact();
                    eBillingContact.address.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.FirstName;
                    eBillingContact.address.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.LastName; 
                    eBillingContact.address.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Email;
                    eBillingContact.address.phone=null;
                    eBillingContact.address.extension=null;
                    eBillingContact.address.externalContactId=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c;//DOC-2391
                    eBillingContact.address.fax=null;
                    eBillingContact.contactFunction.functionValue=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Contact_Type__c;
                    eBillingContact.address.building=null;
                    eBillingContact.address.floor=null;
                    eBillingContact.address.room=null;
                    eBillingContact.ContactType= '30';
                    orderReq.OrderHeader.OrderContact.add(eBillingContact);       
                }
                else if(order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c==null){ 
                CorpCreateOrderRequest.orderContact ebcontact = new CorpCreateOrderRequest.orderContact();
                
                ebcontact.address.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName;
                ebcontact.address.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName; 
                ebcontact.address.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email;
                ebcontact.address.phone=null;
                ebcontact.address.extension=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Extension__c;
                ebcontact.address.externalContactId=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c;
                ebcontact.address.fax=null;
                ebcontact.contactFunction.functionValue='55';
                ebcontact.address.building=null;
                ebcontact.address.floor=null;
                ebcontact.address.room=null;
                ebcontact.ContactType= '30';
                
                orderReq.OrderHeader.OrderContact.add(ebcontact);
                }
                //DOC-2002 ends
                //Assign the signed document to the Order Header        
               /* for(Attachment att : [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%signed%') ORDER BY LastModifiedDate ASC NULLS LAST LIMIT 1]) {
                    CorpCreateOrderRequest.attachments attachment = new CorpCreateOrderRequest.attachments();
                    attachment.attachmentPath = att.Id;
                    attachment.attachmentType= 'OR';
                    attachment.attchmentStatus= 'E'; 
                    orderReq.OrderHeader.attachments.add(attachment);
                } */ 
                 Integer indexOF = 0;
                    Integer counter = 1;
                    Set<String> attNameset=new  Set<String>{'%signed%','%CVMS Offer Sheet%', '%Product User Detail%', '%Digital Signature Detail%','%Order Form%'};
                    //List<ContentDocumentLink> conDocList=new List<ContentDocumentLink>();
                    Set<String> contentDocIds=new Set<String>();
                if(Schema.sObjectType.ContentDocumentLink.isAccessible() && Schema.sObjectType.ContentDocumentLink.isQueryable()){
                    for(ContentDocumentLink contentDocId: [SELECT ContentDocumentId  FROM ContentDocumentLink WHERE LinkedEntityId =: order.Apttus_QPConfig__ProposalId__c]){
                    contentDocIds.add(contentDocId.ContentDocumentId  );
                    }              
                }
                List<ContentVersion> contVLst=new List<ContentVersion>();
                Boolean signedflag=false;
                if(!contentDocIds.isEmpty() && Schema.sObjectType.ContentVersion.isAccessible() && Schema.sObjectType.ContentVersion.isQueryable()){
                    /*for(ContentVersion cv : [SELECT Id,ContentDocumentId,Title FROM ContentVersion WHERE (ContentDocumentId IN :contentDocIds AND Title LIKE :attNameset) ORDER BY LastModifiedDate ASC, Title DESC NULLS LAST] ){
                             if(cv.Title!=null && cv.Title.containsIgnoreCase('signed')){
                                counter++;
                                signedflag=true;
                                 if((indexOF > 0) && !contVLst.isEmpty()){
                                     contVLst.remove(indexOF);
                                 }
                                contVLst.add(cv);
                                System.debug(LoggingLevel.WARN,'Signed Flag Return'+signedflag);
                            }
                            if(cv.Title!=null && cv.Title.containsIgnoreCase('CVMS Offer Sheet')){
                                counter++;
                                contVLst.add(cv);
                            }
                            if(cv.Title!=null && cv.Title.containsIgnoreCase('Product User Detail')){
                                counter++;
                                contVLst.add(cv);
                            }
                            if(cv.Title!=null && cv.Title.containsIgnoreCase('Digital Signature Detail')){
                                counter++;
                                contVLst.add(cv);
                            }
                            if(cv.Title!=null && cv.Title.containsIgnoreCase('Order Form') &&  !signedflag){
                                counter++;
                                contVLst.add(cv);
                                System.debug(LoggingLevel.WARN,'counter:' + counter);
                                indexOF = counter--;
                                System.debug(LoggingLevel.WARN,'IndexOF:' + indexOF);
                               
                            }
                        }*/
                    contVLst = APTS_OrderSubmissionUtility.createContentVersion(attNameset, contentDocIds, contVLst);
                    
                       
                }                
                           
                System.debug(LoggingLevel.WARN,'contVLst'+contVLst);
                          // Set<String> sTitle=new Set<String>();
                           if(!contVLst.isEmpty()) {
                             For(ContentVersion cv: contVLst)
                            {                       
                          CorpCreateOrderRequest.attachments attachment = new CorpCreateOrderRequest.attachments();
                        attachment.attachmentPath = cv.ContentDocumentId;
                            attachment.attachmentType= 'OR';
                         attachment.attchmentStatus= 'E'; 
                        orderReq.OrderHeader.attachments.add(attachment);
                             }     
                       }
                   
                
                Map<String, Decimal> mapMaterialNumberTolineNumber = new Map<String, Decimal>(); //DOC_4742
                
                // Logic to process the Order details and assign to ESI request End.      
                //Logic to Process Order Line Items and assigns to ESI Request Start.
                for(Apttus_Config2__OrderLineItem__c oli :orderLineItems) {
                    orderLine = new CorpCreateOrderRequest.orderLines();
                    lstOfMaterial = new CorpCreateOrderRequest.Material();              
                    system.debug(LoggingLevel.WARN,'===>here'+oli);                     
                    mapMaterialNumberTolineNumber.put(oli.Apttus_Config2__ProductId__r.ProductCode, oli.Apttus_Config2__LineNumber__c); //DOC-4742
                    //DOC-2390, 4742                  
                    if(oli.Apttus_Config2__ProductId__r.APTS_Cat_L5__c==Label.APTS_GSCPW_RP_Product_Family){
                      if (oli.Apttus_Config2__ProductId__r.APTS_Pricing_Qty_Type__c != null) {
                            //Start:DOC 4570 (Owner - Jinal Bhatt)
                            if (oli.Apttus_Config2__AttributeValueId__c != null) {
                                orderLine.quantity = Integer.valueOf(oli.Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c);
                            } else {
                                  orderLine.quantity = oli.Apttus_Config2__Quantity__c.intValue(); //Else part is added as part of 4570
                            }
                            lstOfMaterial.quantity = 1;      
                       } else {
                            lstOfMaterial.quantity =oli.Apttus_Config2__Quantity__c.intValue();
                       }
                    }    
                    //End DOC-2391, 4742
                    CorpCreateOrderRequest.onlineContacts onlineContact = new CorpCreateOrderRequest.onlineContacts();
                    onlineContact.contactNumber = '';
                    onlineContact.externalContactNumber = order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c;
                    onlineContact.onlineContactType = 'PAN';
                    CorpCreateOrderRequest.LineNumberLink linenumlink = new CorpCreateOrderRequest.LineNumberLink();
                    linenumlink.lineNumber = Integer.valueOf(oli.Apttus_Config2__LineNumber__c);    
                    onlineContact.lineNumberLink.add(linenumlink); 
                    CorpCreateOrderRequest.JobRole jobrol = new CorpCreateOrderRequest.JobRole();                      
                    jobrol.role = '16';
                    linenumlink.jobRole.add(jobrol);                               
                    orderReq.OrderHeader.onlineContacts.add(onlineContact);                       
                    //DOC-2391 ends
                    
                    if(oli.Apttus_Config2__LineStatus__c == 'New' || oli.Apttus_Config2__LineStatus__c == 'Renewed'){
                                                                 
                        if(!oli.Apttus_Config2__LineType__c.equals('Option') || oli.Apttus_Config2__LineType__c.equals('Product/Service')){
                            if(oli.Apttus_Config2__NetPrice__c!=null){
                            oneTimeValue = oneTimeValue + oli.Apttus_Config2__NetPrice__c;}
                            //orderLine.relatedLine = String.valueOf(oli.Apttus_Config2__LineNumber__c);
                            if(oli.APTS_Renewal_Type__c!=null && oli.APTS_Renewal_Type__c!=System.Label.APTS_CORP_EverGreen && oli.Apttus_Config2__LineStatus__c != 'Renewed'){  //DOC-4182-renewalcondition added     
                                //As part of DOC-2534 removed yoy1renewal% reference from this method,using yoy2 in that place                      
                            orderTerms(oli.APTS_Contract_Term__c, oli.Base_Value__c, oli.APTS_Years_2_Plus_Adjustment__c, oli.Apttus_Config2__LineStatus__c,oli.APTS_Term_Type__c,oli.APTS_Prorate_base_Value__c,oli.APTS_Calculated_Year_1__c,oli.APTS_Calculated_Year_2__c,oli.APTS_Calculated_Year_3__c,oli.APTS_Calculated_Year_4__c,oli.APTS_Calculated_Year_5__c,oli.APTS_Is_Multi_Tiered_Pricing__c);}
                            if((orderReq.orderHeader.noOfAttorneys ==0)&&(oli.Apttus_Config2__AttributeValueId__c!=null ) &&(oli.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c!=null) ) {
                            orderReq.orderHeader.noOfAttorneys = oli.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c.setScale(0); }                 
                        } 
                        if(oli.Apttus_Config2__ChargeType__c!=null && oli.Apttus_Config2__ChargeType__c.equals('Subscription Fee') && oli.Apttus_Config2__PriceType__c.equals('One Time') ){
                            orderLine.material.materialId = oli.APTS_Subscription_Number__c;                    
                            orderLine.netAmount = null;
                        }else{
                            if(oli.Apttus_Config2__NetPrice__c!=null ){
                            orderLine.netAmount = oli.Apttus_Config2__NetPrice__c.setScale(2);}
                        }                       
                        
                        if(oli.Apttus_Config2__BaseExtendedPrice__c !=null){
                        orderLine.listAmount = oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2);} //DOC-3113
                        //orderLine.referenceNumber = oli.Apttus_QPConfig__ProposalLineItemId__r.Name;
                        //orderLine.unitOfMeasure = oli.Apttus_Config2__Uom__c;
                        //DOC-1854
                        if(oli.APTS_Fiscal_Year_End__c != null && oli.Apttus_QPConfig__ProposalId__r.APTS_Fiscal_Filer__c == true){
                            orderLine.fiscalFilerMonth = oli.APTS_Fiscal_Year_End__c.substring(0,2);
                        } else{
                            orderLine.fiscalFilerMonth = '';
                        }
                        //DOC-1866
                        if((oli.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '55' && oli.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='TT')||
                           (oli.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '55' && oli.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='ST')){
                               orderLine.adtlCustSpecPrice  = true;
                           } else{
                               orderLine.adtlCustSpecPrice  = false;
                           }
                        if(oli.Apttus_Config2__LineStatus__c == 'New'){                     
                            orderLine.actionCode = 'N';                             
                            //DOC-2209, Start: DOC-7506 (Jinal Bhatt)                         
                            if(oli.Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c == 'Yes'){
                                if (oli.APTS_Contract_Term__c == '1 Year') {
                                    orderLine.subscriptionDetail.donotRenewFlag = true;
                                } else {
                                    orderLine.subscriptionDetail.donotRenewFlag = false;
                                }
                            } 
                            //End DOC-7506  
                            //Doc-2202 changes
                            if(oli.APTS_Term_Type__c == 'Delivery Date'){
                                orderLine.subscriptionDetail.contractStartDate = oli.APTS_Start_Date__c;
                                orderLine.subscriptionDetail.contractEndDate = null;
                            } 
                            //DOC-2200 changes
                            if(oli.APTS_Term_Type__c == 'ProRate'){
                                if(oli.APTS_Start_Date__c <= order.Apttus_Config2__OrderDate__c){
                                orderLine.subscriptionDetail.contractStartDate = null;}
                                else if (oli.APTS_Start_Date__c > order.Apttus_Config2__OrderDate__c){
                                orderLine.subscriptionDetail.contractStartDate = oli.APTS_Start_Date__c;}
                                orderLine.subscriptionDetail.contractEndDate = oli.APTS_End_Date__c;//DOC-3592
                                if(oli.Apttus_Config2__BaseExtendedPrice__c !=null){ //DOC-2832,DOC-3113
                                orderLine.listAmount = oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2);}
                                if(oli.APTS_Prorate_base_Value__c !=null ){ 
                                orderLine.netAmount = oli.APTS_Prorate_base_Value__c;}
                            }                           
                            //DOC-2198 changes
                            if(oli.APTS_Term_Type__c == 'Co-Term'){
                                
                                orderLine.subscriptionDetail.contractStartDate = null;                                                                                                                                        
                                orderLine.subscriptionDetail.contractEndDate = oli.APTS_End_Date__c ;
                                if(oli.Apttus_Config2__BaseExtendedPrice__c !=null){ //DOC-2832,DOC-3113
                                orderLine.listAmount = oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2);}
                                if(oli.Apttus_Config2__NetPrice__c!=null ){ 
                            orderLine.netAmount = oli.Apttus_Config2__NetPrice__c.setScale(2);}
                            } 
                            if(oli.APTS_Term_Type__c == 'Co-Term and ProRate'){
                                
                                if(oli.APTS_Start_Date__c <= order.Apttus_Config2__OrderDate__c){
                                orderLine.subscriptionDetail.contractStartDate = null;}
                                else if (oli.APTS_Start_Date__c > order.Apttus_Config2__OrderDate__c){
                                orderLine.subscriptionDetail.contractStartDate = oli.APTS_Start_Date__c;}
                                orderLine.subscriptionDetail.contractEndDate = oli.APTS_End_Date__c ;
                                if(oli.Apttus_Config2__BaseExtendedPrice__c !=null){ //DOC-2832,DOC-3113
                                orderLine.listAmount = oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2);}
                                if(oli.APTS_Prorate_base_Value__c !=null ){
                                orderLine.netAmount = oli.APTS_Prorate_base_Value__c;}
                            }
                            //DOC-1646
                            if(oli.Apttus_Config2__ProductId__r.APTS_Availability_Date__c != null && (oli.Apttus_Config2__ProductId__r.APTS_Availability_Date__c > order.Apttus_Config2__OrderDate__c)){
                                orderLine.subscriptionDetail.contractStartDate = oli.Apttus_Config2__ProductId__r.APTS_Availability_Date__c ;
                                orderLine.subscriptionDetail.contractEndDate = null;
                            }
                            //DOC-1646 ends
                        }                   
                        orderLine.unitOfMeasure = 'EA';
                        //DOC-1866
                        //orderLine.quantity = oli.Apttus_Config2__Quantity__c.intValue(); Commented this line as part of DOC-4570
                        //orderLine.subscriptionDetail.contractStartDate = System.today();
                        //orderLine.subscriptionDetail.contractEndDate = oli.Apttus_Config2__EndDate__c;   
                        orderLine.effectiveDate = oli.Apttus_Config2__StartDate__c;
                        orderLine.endDate = oli.Apttus_Config2__EndDate__c;                   
                        orderLine.subscriptionDetail.subscriptionType = oli.Apttus_Config2__Type__c;
                        orderLine.orderLineNumber = oli.Apttus_Config2__LineNumber__c;
                        lstOfMaterial.materialDescription = oli.Apttus_Config2__Description__c;
                        orderLine.material.materialId = oli.Apttus_Config2__ProductId__r.ProductCode;
                        lstOfMaterial.materialId = oli.Apttus_Config2__ProductId__r.ProductCode;
                        //DOC-3868/DOC-3757 change to send target quantity as 1 when pricing quantity is true
                        if (oli.Apttus_Config2__ProductId__r.APTS_Cat_L5__c!=Label.APTS_GSCPW_RP_Product_Family 
                            && oli.Apttus_Config2__ProductId__r.APTS_Pricing_Qty_Type__c != null) {
                           //Start:DOC 4570 (Owner - Jinal Bhatt)
                            if (oli.Apttus_Config2__AttributeValueId__c != null) {
                                orderLine.quantity = Integer.valueOf(oli.Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c);
                            } else {
                                orderLine.quantity = oli.Apttus_Config2__Quantity__c.intValue(); //Else part is added as part of 4570
                            }
                            lstOfMaterial.quantity = oli.Apttus_Config2__Quantity__c.intValue();
                        } 
                        if (oli.Apttus_Config2__ProductId__r.APTS_Cat_L5__c!=Label.APTS_GSCPW_RP_Product_Family 
                            && oli.Apttus_Config2__ProductId__r.APTS_Pricing_Qty_Type__c == null) {
                            lstOfMaterial.quantity = oli.Apttus_Config2__Quantity__c.intValue();
                        }  
                        //End DOC-4742
                        //DOC-3868/DOC-3757 ends
                        //DOC-2361 starts
                        if(oli.Apttus_Config2__LineStatus__c == 'Renewed' && oli.Apttus_Config2__ProductId__r.APTS_SwapAndVersion__c != null){
                            lstOfMaterial.materialId = oli.Apttus_Config2__ProductId__r.APTS_SwapAndVersion__c ;                                    
                        }
                        //DOC-2361 ends
                        //lstOfMaterial.configType = order.Apttus_QPConfig__ProposalId__r.Latam_APTS_Sales_Org__c;
                        orderLine.material.material.add(lstOfMaterial);           
                        
                        //DOC-8448: Jinal Bhatt
                        if (oli.Apttus_Config2__LineStatus__c == 'New' && oli.APTS_WLEC_Product_Category__c != 'PS'
                            && oli.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '52' 
                            && oli.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='TH') {
                            orderLine.billPlanType = 'Yearly';
                            orderLine.subscriptionDetail.donotRenewFlag=true;
                        } else {
                            orderLine.billPlanType = oli.Apttus_Config2__BillingFrequency__c; 
                        }//End DOC-8448
                        
                        if(oli.APTS_WLEC_Product_Category__c != null && oli.APTS_WLEC_Product_Category__c == 'PS' ){
                            psFlag = true;
                            orderLine.productType = oli.APTS_WLEC_Product_Category__c;
                            orderLine.itemCategoryGroupCode = oli.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c;
                            if(oli.APTS_Renewal_Type__c != null && oli.APTS_Renewal_Type__c != System.Label.NonRenewable ){    //Added Non-Renewable condition as part of DOC-12842
                                orderLine.subscriptionDetail.donotRenewFlag=false;}
                            else{
                                orderLine.subscriptionDetail.donotRenewFlag=true;}                          
                            if(oli.APTS_Start_Date__c == null || oli.APTS_Start_Date__c < System.today()){
                                orderLine.subscriptionDetail.contractStartDate = System.today();
                            }
                            else{orderLine.subscriptionDetail.contractStartDate = oli.APTS_Start_Date__c ;}
                            if(oli.APTS_End_Date__c == null){
                                if(oli.APTS_Start_Date__c == null || oli.APTS_Start_Date__c < System.today()){
                                    orderLine.subscriptionDetail.contractEndDate = System.today().addDays(365); 
                                }
                                else{orderLine.subscriptionDetail.contractEndDate = oli.APTS_Start_Date__c.addDays(365);}
                            }
                            else{orderLine.subscriptionDetail.contractEndDate = oli.APTS_End_Date__c;}                            
                        } 
                        if(oli.APTS_Renewal_Type__c!=null){
                            orderLine.subscriptionDetail.renewalPlanType = oli.APTS_Renewal_Type__c;
                            if(oli.APTS_Renewal_Type__c==System.Label.APTS_CORP_EverGreen){
                                //As part of DOC-2534 removed yoy1renewal% reference from this method,using yoy2 in that place
                                orderTerms(oli.APTS_Contract_Term__c, 0.0, '',oli.Apttus_Config2__LineStatus__c,oli.APTS_Term_Type__c,oli.APTS_Prorate_base_Value__c,oli.APTS_Calculated_Year_1__c,oli.APTS_Calculated_Year_2__c,oli.APTS_Calculated_Year_3__c,oli.APTS_Calculated_Year_4__c,oli.APTS_Calculated_Year_5__c,oli.APTS_Is_Multi_Tiered_Pricing__c);                                   
                            }
                            //Added as part of DOC-12842
                            if(oli.APTS_Renewal_Type__c==System.Label.NonRenewable){
                                orderLine.subscriptionDetail.donotRenewFlag=true;
                            }   
                        }  //Doc-3660 -starts
                        if(oli.Apttus_Config2__ProductId__r.APTS_Cat_L5__c==Label.APTS_GSCPW_RP_Product_Family  && oli.APTS_Contract_Term__c =='Short Term Trial' ){
                            CorpCreateOrderRequest.adjustments adjustment= new CorpCreateOrderRequest.adjustments();
                            if(oli.Apttus_Config2__LineStatus__c != 'Renewed' && oli.APTS_New_Bridge_Discount__c!=null){                             
                                orderLine.netAmount = oli.bridge_net_price__c;
                                //orderLine.netAmount = oli.Apttus_Config2__ListPrice__c - (oli.Apttus_Config2__ListPrice__c * oli.APTS_New_Bridge_Discount__c/100);                             
                            }
                            if(oli.APTS_Bridge__c=='N/a'){
                                orderLine.billPlanUpdateRule='0';
                            }
                            else if(oli.APTS_Bridge__c=='1 Month'){orderLine.billPlanUpdateRule='1';}
                            else if(oli.APTS_Bridge__c=='2 Months'){orderLine.billPlanUpdateRule='2';}
                            else if(oli.APTS_Bridge__c=='3 Months'){orderLine.billPlanUpdateRule='3';}
                            else if(oli.APTS_Bridge__c=='4 Months'){orderLine.billPlanUpdateRule='4';}
                            else if(oli.APTS_Bridge__c=='5 Months'){orderLine.billPlanUpdateRule='5';}
                            else if(oli.APTS_Bridge__c=='6 Months'){orderLine.billPlanUpdateRule='6';}
                            else if(oli.APTS_Bridge__c=='7 Months'){orderLine.billPlanUpdateRule='7';}
                            else if(oli.APTS_Bridge__c=='8 Months'){orderLine.billPlanUpdateRule='8';}
                            else if(oli.APTS_Bridge__c=='9 Months'){orderLine.billPlanUpdateRule='9';}
                            else if(oli.APTS_Bridge__c=='10 Months'){orderLine.billPlanUpdateRule='10';}
                            else if(oli.APTS_Bridge__c=='11 Months'){orderLine.billPlanUpdateRule='11';}                           
                            else if(oli.APTS_Bridge__c=='7 Days'){orderLine.billPlanUpdateRule='7D';}
                            else if(oli.APTS_Bridge__c=='14 Days'){orderLine.billPlanUpdateRule='14D';}
                            else if(oli.APTS_Bridge__c=='28 Days'){orderLine.billPlanUpdateRule='28D';}
                            adjustment.discountType='BridgeDiscount';
                            
                            //DOC-5742 (Jinal Bhatt) - Added setScale(2) for adjustment.discountAmount
                            //Start DOC-4511
                            if (oli.Apttus_Config2__ListPrice__c != null && oli.Apttus_Config2__ListPrice__c > 0
                                && oli.APTS_New_Bridge_Discount__c != null && oli.APTS_New_Bridge_Discount__c > 0) {
                                adjustment.discountAmount= String.valueOf((oli.Apttus_Config2__ListPrice__c * oli.APTS_New_Bridge_Discount__c/100).setScale(2));
                            } else {
                                adjustment.discountAmount = '0.00';
                            }
                            //End DOC-4511
                            
                            orderLine.subscriptionDetail.contractStartDate = oli.APTS_Start_Date__c;
                            orderLine.adjustments.add(adjustment);
                        }//DOC-3660 Ends                            
                        
                        orderLine.sourceOrTargetReferenceLineNumber = oli.Apttus_QPConfig__ProposalLineItemId__r.Name;                                           
                        orderLine.noOfAttorneys = string.valueOf(oli.APTS_Priced_Number_of_Attorneys__c);
                        
                        if(oli.APTS_Bridge__c=='N/a' || String.isEmpty(oli.APTS_Bridge__c) ){
                            orderLine.freeServiceDays ='0';}                            
                        else{
                            orderLine.freeServiceDays = String.valueOf(Integer.valueOf(oli.APTS_Bridge__c.substringBefore(' '))*30);}
                        CorpCreateOrderRequest.adjustments adjustment= new CorpCreateOrderRequest.adjustments();
                        //Start: DOC 5381, added if /else condition 
                        if (oli.Apttus_Config2__LineStatus__c == 'Renewed') {  //Renewals
                            //DOC-4069 
                            decimal renewalnetamt;
                            //integer yoy2;
                            if (oli.Apttus_Config2__NetPrice__c != null) {
                                //Start DOC-4990
                                /*String str= oli.APTS_Years_2_Plus_Adjustment__c; 
                                if(str != null){                                
                                    yoy2 = integer.valueOf(str);
                                }                                    
                                decimal temp1= ((oli.Apttus_Config2__NetPrice__c.setScale(2)* yoy2 )/100);                                     
                                decimal tempnetamt =  oli.Apttus_Config2__NetPrice__c.setScale(2)+temp1;                                   
                                renewalnetamt  =  tempnetamt.setScale(2);//DOC-4183*/
                                //End DOC-4990
                                orderLine.netAmount =  oli.APTS_Calculated_Year_1__c;//DOC-4183
                                system.debug(LoggingLevel.WARN,'====netAmount ==>'+orderLine.netAmount);
                                orderLine.listAmount = oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2);//DOC-4589
                                
                                //Start: Jinal Bhatt - DOC_6364
                                if (oli.APTS_Calculated_Year_1__c != null && oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2) != null) {
                                    if(oli.APTS_Calculated_Year_1__c - oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2) < 0) {
                                        adjustment.discountAmount = String.valueOf((oli.APTS_Calculated_Year_1__c- oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2)) * (-1));
                                        adjustment.discountType='PERCENT';//DOC-4589
                                    } else {
                                        adjustment.discountAmount=String.valueOf(oli.APTS_Calculated_Year_1__c- oli.Apttus_Config2__BaseExtendedPrice__c.setScale(2));
                                        adjustment.discountType='FIXED_MARKUP';//DOC-4589
                                    }
                                    
                                }
                                //End DOC-6364
                                orderLine.adjustments.add(adjustment);
                            }
                            if(oli.APTS_Renewal_Type__c!=System.Label.APTS_CORP_EverGreen){//DOC-4182
                                orderTerms(oli.APTS_Contract_Term__c,renewalnetamt, oli.APTS_Years_2_Plus_Adjustment__c, oli.Apttus_Config2__LineStatus__c,oli.APTS_Term_Type__c,oli.APTS_Prorate_base_Value__c,oli.APTS_Calculated_Year_1__c,oli.APTS_Calculated_Year_2__c,oli.APTS_Calculated_Year_3__c,oli.APTS_Calculated_Year_4__c,oli.APTS_Calculated_Year_5__c,oli.APTS_Is_Multi_Tiered_Pricing__c);                                                            
                            }
                            orderLine.actionCode = 'R';                                       
                            //skg added contract infor
                            // orderLine.SubscriptionDetail.contractLineNumber=string.valueof(oli.APTS_Contract_Line_Number__c); //commenting as part of DOC-3109
                            // orderLine.SubscriptionDetail.contractNumber=String.valueOf(oli.APTS_Contract_Number__c); //commenting as part of DOC-3109
                            //DOC-1578 and DOC-1962
                            // orderLine.itemCategory='ZRNW';                                
                            //orderLine.listAmount = 0;                                                                   
                            orderLine.SubscriptionDetail.contractStartDate=oli.APTS_Contract_End_Date__c; 
                            if(orderLine.SubscriptionDetail.contractStartDate != null){//DOC-4184
                                orderLine.subscriptionDetail.contractEndDate = orderLine.SubscriptionDetail.contractStartDate.addDays(365); }                       
                        } else if (oli.Apttus_Config2__LineStatus__c == 'New') {
                            //DOC-1859 condition added
                            if((oli.Apttus_Config2__AdjustmentType__c=='% Discount' || oli.Apttus_Config2__AdjustmentType__c=='% Markup'|| oli.Apttus_Config2__AdjustmentType__c=='Price Override'||  oli.Apttus_Config2__AdjustmentType__c=='Discount Amount' || oli.Apttus_Config2__AdjustmentType__c=='Markup Amount' || oli.Apttus_Config2__AdjustmentType__c==''  || oli.Apttus_Config2__AdjustmentType__c==null)
                               && (oli.APTS_Term_Type__c=='ProRate' ||  oli.APTS_Term_Type__c=='Co-Term and ProRate') && (!(oli.APTS_WLEC_Product_Category__c == 'PS' && oli.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZRRB'))){
                                   if(oli.APTS_Prorate_base_Value__c !=null ) {
                                       orderLine.netAmount = oli.APTS_Prorate_base_Value__c;}
                                   if(oli.APTS_Prorate_base_Value__c > oli.Apttus_Config2__BaseExtendedPrice__c){
                                       adjustment.discountType='FIXED_MARKUP';
                                       adjustment.discountAmount=String.valueOf((oli.APTS_Prorate_base_Value__c-oli.Apttus_Config2__BaseExtendedPrice__c).setScale(2));
                                       orderLine.adjustments.add(adjustment);
                                   }else if(oli.Apttus_Config2__BaseExtendedPrice__c > oli.APTS_Prorate_base_Value__c){
                                       adjustment.discountType='PERCENT';
                                       adjustment.discountAmount= String.valueOf((oli.Apttus_Config2__BaseExtendedPrice__c -oli.APTS_Prorate_base_Value__c).setScale(2));
                                       orderLine.adjustments.add(adjustment);
                                   }
                               }   
                            //DOC-1859 condition added
                            else if(oli.Apttus_Config2__AdjustmentType__c=='% Discount' || (oli.Apttus_Config2__AdjustmentType__c=='Price Override' && oli.Apttus_Config2__BaseExtendedPrice__c > oli.Apttus_Config2__AdjustedPrice__c) && (!(oli.APTS_WLEC_Product_Category__c == 'PS' && oli.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZRRB')))
                            {
                                adjustment.discountType='PERCENT';
                                adjustment.discountAmount=String.valueOf((oli.Apttus_Config2__BaseExtendedPrice__c-oli.Apttus_Config2__AdjustedPrice__c).setScale(2));
                                orderLine.adjustments.add(adjustment);
                            }                                         
                            //DOC-1859 condition added
                            else if(oli.Apttus_Config2__AdjustmentType__c=='% Markup' || (oli.Apttus_Config2__AdjustmentType__c=='Price Override' && oli.Apttus_Config2__AdjustedPrice__c > oli.Apttus_Config2__BaseExtendedPrice__c) && (!(oli.APTS_WLEC_Product_Category__c == 'PS' && oli.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZRRB')))
                            {
                                //adjustment.type='FIXED_MARKUP';
                                adjustment.discountType='FIXED_MARKUP';
                                adjustment.discountAmount=String.valueOf((oli.Apttus_Config2__AdjustedPrice__c-oli.Apttus_Config2__BaseExtendedPrice__c).setScale(2));
                                orderLine.adjustments.add(adjustment);
                            } 
                        } //End DOC-5381  
                        orderReq.orderLines.add(orderLine);
                    }
                    
                    if(oli.Apttus_Config2__LineStatus__c=='Cancelled'){
                        //orderLine.actionCode = 'LAPSE';
                        laps = new CorpCreateOrderRequest.orderLapseLines();
                        laps.materialId=oli.Apttus_Config2__ProductId__r.ProductCode;
                        laps.contractNumber=Integer.valueOf(oli.APTS_Contract_Number__c);
                        laps.dealType=oli.APTS_Deal_Type__c ;
                        laps.contractLineNumber= Integer.valueOf(oli.APTS_Contract_Line_Number__c);
                        laps.reasonCode='OL';
                        laps.dealNumber=string.valueOf(oli.APTS_Deal_Number__c);                    
                        laps.lapseDate=oli.Apttus_Config2__EndDate__c;//commented as part of SOC-8407
                        laps.lapseCode='OL';//changed code to 'OL' as part of SOC-8407 by Keerthana
                        laps.lapseQuantity=Integer.valueOf(oli.Apttus_Config2__Quantity__c.setScale(0));
                        //system.debug('laps...'+laps);
                        orderReq.orderLapseLines.add(laps);             
                    }
                }
                
                //Start: Doc-4742
                if(onlinecon.size()>0){
                    for(Online_Contacts__c onlinecon1 : onlinecon){     
                        CorpCreateOrderRequest.onlineContacts onlineContact = new CorpCreateOrderRequest.onlineContacts();                      
                        if(onlinecon1.Contact_Name__r.SAP_Contact_ID__c != null){
                            onlineContact.contactNumber = onlinecon1.Contact_Name__r.SAP_Contact_ID__c;}
                        else{ onlineContact.contactNumber = null;  }
                        onlineContact.location = onlinecon1.SAP_Account_Number__c;  
                        onlineContact.firstName=onlinecon1.First_Name__c;
                        onlineContact.lastName=onlinecon1.Last_Name__c;
                        onlineContact.onlineContactType='0095';
                        onlineContact.emailAddress=onlinecon1.Email__c;                        
                        onlineContact.externalContactNumber =onlinecon1.ContactID__c;                        
                        CorpCreateOrderRequest.LineNumberLink linenumlink = new CorpCreateOrderRequest.LineNumberLink();
                        linenumlink.lineNumber = Integer.valueOf(mapMaterialNumberTolineNumber.get(onlinecon1.Material__c));
                        onlineContact.lineNumberLink.add(linenumlink);
                        onlineContact.phone=null;
                        //DOC-4477                      
                        if(onlinecon1.QuoteLineItem__r.Apttus_Proposal__Product__r.APTS_Cat_L5__c==Label.APTS_GSCPW_RP_Product_Family){
                          if(onlinecon1.Position__c  =='Tax Professional'){
                          onlineContact.contactType = '0095';}
                        }                       
                        orderReq.OrderHeader.onlineContacts.add(onlineContact);
                    }
                }
                //End Doc-4742
                
                if(psFlag == true){
                    if(order.Apttus_QPConfig__ProposalId__r.APTS_Notes__c != null){
                        CorpCreateOrderRequest.orderNotes orderNote1= new CorpCreateOrderRequest.orderNotes();
                        orderNote1.notes=order.Apttus_QPConfig__ProposalId__r.APTS_Notes__c;
                        if(orderNote1.notes.length() >= 132){
                            orderNote1.notes=orderNote1.notes.substring(0,131);
                        }   
                        orderReq.OrderHeader.orderNotes.add(orderNote1);}
                }
                orderReq.orderHeader.oneTimeValue = String.valueof(oneTimeValue.setScale(2));
                system.debug(LoggingLevel.WARN,'orderReq'+orderReq);
                if(runOldOrderProcess){
                    // Method to make a callout to ESI
                    HTTPResponse response = new HTTPResponse();
                    response = CorpOrderSubmissionCalloutUtil.sendCorpRequest(orderReq, 'Quote/Proposal ESI call SFDC Error', 'Quote/Proposal', 'OrderSubmissionESICorporate', 'POST', 'application/json', orderId,order.Retry_Count__c); 
                    String strBody = JSON.serialize(orderReq);
                    CorpOrderSubmissionCalloutUtil.sendEmailtoQuoteOwner(response, order.Apttus_QPConfig__ProposalId__r.Name, proposalOwner.Email, 'Order Not got processed Sucessfully for the order:', 'Order Failed', 'Quote/Proposal ESI Call Failed', 'Quote/Proposal', OrderId,order.Retry_Count__c);                        
                    system.debug(LoggingLevel.WARN,'response...'+response);
                    loggerId = IntegrationLogger.OCAddMessage('Old Order Process','', 'Order', '', 'Outbound','OrderSubmission',false,orderId);         
                    if(response.getStatusCode()==200){ 
                        APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process : Quote/Proposal ESI success : '+response.getStatusCode()+' : '+response.getbody()},order.Id,order.Retry_Count__c);
                        ordersubwrap.isSuccess = true;ordersubwrap.applicationId = '';ordersubwrap.companyId = '';return ordersubwrap;}
                    else{ 
                        APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process : Quote/Proposal ESI Call Failed : '+response.getStatusCode()+' : '+response.getbody()},order.Id,order.Retry_Count__c);
                        ordersubwrap.isSuccess = false;ordersubwrap.applicationId = '';ordersubwrap.companyId = '';return ordersubwrap;
                    }
                }else{
                    String strBody = JSON.serialize(orderReq);
                    if(Schema.sObjectType.Integration_Logger__c.isAccessible()){       
                        intLogList=[Select Id from Integration_Logger__c where Order__c =: orderId];
                    }
                    if(intLogList!=null && intLogList.size()==1){
                        IntegrationLogger.TaxupdateMessage(intLogList[0].Id, true,'',strBody);
                        loggerId = intLogList[0].Id;
                    }else{
                        loggerId = IntegrationLogger.OCAddMessage('','', 'Order', strBody, 'Outbound','OrderSubmission',true,orderId);         
                    }
                    ordersubwrap.orderId = orderId;
                    ordersubwrap.orderNo = orderReq.orderHeader.OrderNumber;
                    ordersubwrap.applicationId = orderReq.ESIHeader.applicationId;
                    ordersubwrap.companyId = orderReq.ESIHeader.companyId;
                    ordersubwrap.isSuccess = true;
                    ordersubwrap.loggerrecordId = loggerId;
                    return ordersubwrap;
                }
            }catch(Exception ex){
                System.debug(LoggingLevel.WARN,'Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
                /*logException(ex.getMessage()+' : '+ex.getLineNumber()+' : '+ex.getStackTraceString(),'Quote/Proposal ESI call SFDC Error',order.Id,order.Retry_Count__c); 
                return false;*/
                /*if(Schema.sObjectType.Integration_Logger__c.isAccessible()){       
                    intLogList=[Select Id from Integration_Logger__c where Order__c =: orderId and Service_Name__c='OrderSubmission'];
                }
                if(intLogList!=null && intLogList.size()==1){
                    IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,ex.getMessage()+ex.getLineNumber(),'');
                    loggerId = intLogList[0].Id;
                }else{
                    loggerId = IntegrationLogger.OCAddMessage(ex.getMessage()+ex.getLineNumber(),'', 'Order', '', 'Outbound','OrderSubmission',false,orderId);         
                }
                ordersubwrap.orderId = orderId;
                ordersubwrap.applicationId = '';
                ordersubwrap.companyId = '';
                ordersubwrap.isSuccess = false;
                ordersubwrap.loggerrecordId = loggerId;*/
                APTS_OrderSubmissionUtilityExt4.handleException(orderId, ex, ordersubwrap);
                return ordersubwrap;
            }
            
        }
        /*=================================================================================
        Method to set MYR Terms details for renewals
        ===================================================================================*/
        //As part of DOC-2534 removed yoy1renewal% reference from this method,using yoy2 in that place
        //As Part of DOC-3883 Few other parameters are added to the orderterms method
        /**
         * @description orderTerms
         * @param contractTerm
         * @param baseValue
         * @param adjustment
         * @param status
         * @param termtype
         * @param proratevalue
        * @param  year1
         * @param  year2
         * @param  year3
         * @param  year4
         * @param  year5
         * @param ismultitier
         */  
        public static void orderTerms(string contractTerm, Decimal baseValue, string adjustment, string status,String termtype ,Decimal proratevalue, Decimal year1,Decimal year2,Decimal year3,Decimal year4,Decimal year5, boolean ismultitier) {
            //Contract Term =0 //SOC-6437 May Bijeta For short term
            if(string.valueof(contractTerm)=='Short Term Trial')
            {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate,multitiercheck,calculatedyr1,calculatedyr2,calculatedyr3,calculatedyr4,calculatedyr5
                
                orderTermsUtil('0', baseValue, adjustment, status, 0, proratevalue, termtype,ismultitier, year1, year2, year3, year4, year5);           
            }
            //Contract Term =1
            if(string.valueof(contractTerm)=='1 Year')
            {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate, multitiercheck,calculatedyr1,calculatedyr2,calculatedyr3,calculatedyr4,calculatedyr5             
                if(status == 'New' && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate')){
                    orderTermsUtil('1',proratevalue,adjustment,status,1, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5);
                }
                else {
                    orderTermsUtil('1',year1,adjustment,status,1, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5);
                }
            }        
            //Contract Term =2  
            if(string.valueof(contractTerm)=='2 Years')
            {  
                // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate ,multitiercheck,calculatedyr1,calculatedyr2,calculatedyr3,calculatedyr4,calculatedyr5            
                orderTermsUtil('2',year2,adjustment,status,2, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5);
            }
            //Contract Term =3
            if(string.valueof(contractTerm)=='3 Years')
            {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate ,multitiercheck,calculatedyr1,calculatedyr2,calculatedyr3,calculatedyr4,calculatedyr5                                 
                orderTermsUtil('3',year3,adjustment,status,3, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5);         
            }
            //Contract Term =4
            if(string.valueof(contractTerm)=='4 Years')
            {  // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate ,multitiercheck,calculatedyr1,calculatedyr2,calculatedyr3,calculatedyr4,calculatedyr5                                
                orderTermsUtil('4',year4,adjustment,status,4,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5);
            }
            //Contract Term =5
            if(string.valueof(contractTerm)=='5 Years')
            {  
                // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate,multitiercheck,calculatedyr1,calculatedyr2,calculatedyr3,calculatedyr4,calculatedyr5                                  
                orderTermsUtil('5',year5,adjustment,status,5, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5);            
            }
            /* Commented Contract Term =10 as part of DOC-12762
            if(string.valueof(contractTerm)=='10 Years')
            {
                // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate,multitiercheck,calculatedyr1,calculatedyr2,calculatedyr3,calculatedyr4,calculatedyr5                        
                orderTermsUtil('10',baseValue,adjustment,status,10, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5);           
            }*/
        }
        
        /*=================================================================================
        Method to set MYR Terms details
        ===================================================================================*/
         /**
         * @description orderTermsUtil
         * @param contractTerm
         * @param baseValue
         * @param adjustment
         * @param status
         * @param period 
         * @param proratevalue
         * @param termtype
         * @param ismultitier
         * @param  year1
         * @param  year2
         * @param  year3
         * @param  year4
         * @param  year5
         */  
        public static void orderTermsUtil(string contractTerm, Decimal baseValue, string adjustment,String status, Integer period, Decimal proratevalue,String termtype,boolean ismultitier,Decimal year1,Decimal year2,Decimal year3,Decimal year4,Decimal year5) {
          //  Integer count = null;
            
            if(period == 0){//SOC-6437 May Bijeta For short term        
                // If it is not renewel and First term then send Adjustment as 0           
                if(status=='New') {
                    orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(0),'0',baseValue,0));
                }
                else{
                    orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(0),adjustment,baseValue,0));
                }
            }
            else{//SOC-6437 May Bijeta For short term   
                for(Integer i=1; i <= period; i++) {
                    if (i == 1 && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate') && !ismultitier){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,proratevalue,0));
                    }
                    //DOC-3883 starts 
                    else if(i == 1 && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate') && ismultitier){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'4',proratevalue,0));
                    }
                    else if(ismultitier){
                        if(i == 1 && (!(termtype == 'ProRate' || termtype == 'Co-Term and ProRate'))){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'4',year1,0));}
                        if(i == 2){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',year2,0));} //DOC-4992
                        if(i == 3){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',year3,0)); }//DOC-4992
                        if(i == 4){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',year4,0));} //DOC-4992
                        if(i == 5){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',year5,0));} //DOC-4992                   
                    } 
                   else if(!ismultitier){
                        if(i == 1 && (!(termtype == 'ProRate' || termtype == 'Co-Term and ProRate'))){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year1,0));}
                        if(i == 2){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',year2,0));} //DOC-4992
                        if(i == 3){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',year3,0));} //DOC-4992
                        if(i == 4){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',year4,0));} //DOC-4992
                        if(i == 5){
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),'0',year5,0));} //DOC-4992           
                    } //DOC-3883 Ends                   
                    else {
                        orderLine.subscriptionDetail.subscriptionTerms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,baseValue,0));
                    }
                }
            }
        }
        /*=================================================================================
        Method For MYR details
        ===================================================================================*/  
        /**
         * @description termUtil
         * @param tLen
         * @param period
         * @param percInc
         * @param bValue
         * @param uRate
         * @return CorpCreateOrderRequest.terms
         */  
        public static CorpCreateOrderRequest.terms termUtil(string tLen, string period, string percInc, Decimal bValue, Decimal uRate) {
            CorpCreateOrderRequest.terms term = new CorpCreateOrderRequest.terms();
            term.termLength = tLen;
            term.period = period;
            term.percentIncrease = percInc;
            term.baseValue = bValue;
            term.userRate = uRate;
            return term;
        }   
        
        //method to assign the Address field values to the Order address
         /**
         * @description assignAddessValues
         * @param partnerType
         * @param shipping
        * @param sapNumber 
          *@param name 
          *@param nameTwo
          *@param nameThree
          *@param st1
          *@param st2
          *@param  st3
          *@param  st4
          *@param  city
          *@param  state
          *@param  country
          *@param postalCode
          *@param phone
         * @param fax
          *@param  poBox
          *@param  email
          *@param  county
          *@param building
          *@param  vatNumber
          *@param  taxNumber
          *@param extId
         * @return CorpCreateOrderRequest.OrderAddress
         */
        public static CorpCreateOrderRequest.OrderAddress assignAddessValues(string partnerType, string shipping, string sapNumber, string name, string nameTwo, string nameThree, string st1, string st2, string st3, string st4, string city, string state, string country, string postalCode, string phone, string fax, string poBox, string email, string county, string building, string vatNumber, string taxNumber, id extId) {
            CorpCreateOrderRequest.orderAddress ordaddress = new CorpCreateOrderRequest.orderAddress();
            ordaddress.partnerType = partnerType;
            if(!string.isEmpty(shipping)){
                ordaddress.shippingMethod = Shipping_Method__c.getInstance(shipping).Value__c;}
            ordaddress.account.accountNumber = sapNumber;
            ordaddress.name=name;
            ordaddress.firstName = name;
            ordaddress.lastName = nameTwo;
            ordaddress.middleName = nameThree;
            ordaddress.street1 = st1;
            ordaddress.street2 = st2;
            ordaddress.street3 = st3;
            ordaddress.street4 = st4;
            ordaddress.city = city;         
            ordaddress.region = state;
            ordaddress.country = country;
            ordaddress.postalcode = postalCode;
            ordaddress.phone = null; //DOC-2992
            ordaddress.fax = fax;
            ordaddress.poBox = poBox;
            ordaddress.emailAddress = email;
            ordaddress.county = county;
            ordaddress.building = building;
            ordaddress.vatNumber = vatNumber;
            ordaddress.taxReferenceNumber = taxNumber;
            ordaddress.extAccountNumber = extId;
            return ordaddress;
        } 
        //method to assign the Address field values to the Order address for Contact SSD Doc -2023
        /**
         * @description assignOrderContacts
         * @param partnerType
         * @param sapAcctNum
        * @param sfdcContactId
         * @return CorpCreateOrderRequest.OrderAddress
         */
        public static CorpCreateOrderRequest.OrderAddress assignAddessValuesContactSSD(String partnerType,String sapAcctNum, String sfdcContactId){
            CorpCreateOrderRequest.orderAddress ordaddress = new CorpCreateOrderRequest.orderAddress();
            ordaddress.partnerType = partnerType;
            ordaddress.extAccountNumber = sfdcContactId;
            ordaddress.account.accountNumber = sapAcctNum;
            return ordaddress;
        }  
        //method to assign the Contact SSD values to the Order Contact SSD Doc -2023
       /**
         * @description assignOrderContacts
         * @param firstName
         * @param lastName
         * @param emailStr
         * @param sfdcContactId
         * @return CorpCreateOrderRequest.orderContact
         */
        public static CorpCreateOrderRequest.orderContact assignOrderContacts(String firstName, String lastName, String emailStr, String sfdcContactId){ 
            CorpCreateOrderRequest.orderContact ordcontact = new CorpCreateOrderRequest.orderContact();
            ordcontact.address.firstName =firstName;
            ordcontact.address.lastName =lastName;
            ordcontact.address.emailAddress = emailStr;
            ordcontact.ContactType = '55';
            ordcontact.address.externalContactId=sfdcContactId;
            return ordcontact;
        }
    }