/**
 * @description Helper class for APTS_OrderQueueToESI    
 */
public with sharing class APTS_OrderSubmissionUtilityExt{
    
    /**
     * @description Method to query Order records
     * @param orderId of String
     * @return Apttus_Config2__Order__c
     */
    public static Apttus_Config2__Order__c queryOrders(Id orderId){
        Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
        if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible() && Schema.sObjectType.Apttus_Config2__Order__c.isQueryable()){
            order = [SELECT Id,Name,CreatedDate,Retry_Count__c,APTS_Payer__c,
                                Apttus_Config2__OrderReferenceNumber__c,
                                Apttus_QPConfig__ProposalId__r.APTS_VisaTransNumber__c,
                                Apttus_QPConfig__ProposalId__r.APTS_VisaMessageType__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Account_Credit_Risk_Category__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Zipcode__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Country__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Authorization_Transaction__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.City__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To_Attention__c,
                                Apttus_QPConfig__ProposalId__r.APTS_MLA_Quote__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Name,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.State__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__c,
                                Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c,
                                CreatedBy.Sales_Force_Description__c,
                                CreatedBy.Market_Segment_Description__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Assent_Name_of_Rep__r.FirstName,
                                Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Assent_Customer_Name__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Assent_Name_of_Rep__r.LastName,
                                Apttus_QPConfig__ProposalId__r.APTS_Assent_DateTime__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c,
                                Apttus_QPConfig__ProposalId__r.CreatedBy.Rep_Employee_Number__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Card_Type__c,
                                Apttus_QPConfig__ProposalId__r.APTS_amount__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Print_Branding__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c,
                                Apttus_Config2__Description__c,
                                APTS_SSD_Sold_To__r.LCRM_Customer_Group__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName,Apttus_QPConfig__ProposalId__r.ownerid,
                                Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email,
                                Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Department,
                                CreatedBy.Apts_Revenue_Channel__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName,
                                Number_of_Attorneys__c,
                                Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Net_Amount__c,
                                Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c, 
                                Apttus_QPConfig__ProposalId__r.APTS_Quote_Type__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.LastName,
                                Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.FirstName,
                                Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Email,
                                Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Contact_Type__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Contact_Type__c, Apttus_QPConfig__ProposalId__r.APTS_Cost_Center__c,
                                APTS_SSD_Sold_To__r.State__c,
                                APTS_SSD_Sold_To__r.Country__c,
                                Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,
                                APTS_SSD_Sold_To__r.OLC_Account_Number__c, //Doc-15792
                                APTS_SSD_Sold_To__r.LCRM_SAP_Account_Number__c,//Doc-15792
                                APTS_SSD_bill_to__r.City__c,
                                APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                                APTS_SSD_bill_to__r.Account_Name__r.AccountNumber,
                                Apttus_QPConfig__ProposalId__c,
                                APTS_SSD_bill_to__r.Source_System_Account_Number__c,
                                APTS_SSD_bill_to__r.LCRM_Name_3__c,
                                APTS_SSD_Sold_To__r.LCRM_Name_3__c,
                                Apttus_Config2__OrderDate__c,
                                Apttus_Config2__Type__c,
                                CurrencyIsoCode,
                                APTS_Periodic_Value__c,
                                APTS_SSD_bill_to__r.Account_Name__r.Billing_City_State__c,
                                APTS_SSD_bill_to__r.LCRM_Street3__c,
                                APTS_SSD_bill_to__r.LCRM_Street4__c,
                                APTS_SSD_bill_to__r.LCRM_Phone__c,
                                APTS_SSD_bill_to__r.LCRM_Fax__c,
                                APTS_SSD_bill_to__r.LCRM_PO_Box__c,
                                APTS_SSD_Ship_To__r.Source_System_Account_Number__c,
                                APTS_SSD_Ship_To__r.LCRM_Name_2__c,
                                APTS_SSD_Ship_To__r.LCRM_Name_3__c,
                                APTS_SSD_Ship_To__r.LCRM_Street4__c,
                                APTS_SSD_Ship_To__r.LCRM_Street3__c,
                                APTS_SSD_Ship_To__r.LCRM_Street_2__c,
                                APTS_SSD_Ship_To__r.State__c,
                                APTS_SSD_Ship_To__r.Country__c,
                                APTS_SSD_Ship_To__r.LCRM_Phone__c,
                                APTS_SSD_Ship_To__r.LCRM_Fax__c,
                                APTS_SSD_Ship_To__r.LCRM_PO_Box__c,
                                APTS_SSD_Ship_To__r.City__c, 
                                Apttus_Config2__Status__c,
                                APTS_SSD_bill_to__r.LCRM_Name_2__c,
                                APTS_SSD_bill_to__r.LCRM_Street_2__c,
                                APTS_SSD_Sold_To__r.Account_Name__r.Parent.Parent_Type__c,
                                APTS_SSD_Sold_To__r.City__c,
                                APTS_SSD_Sold_To__c,
                                APTS_SSD_Sold_To__r.LCRM_Phone__c,
                                APTS_SSD_Ship_To__c,
                                APTS_SSD_Sold_To__r.LCRM_PO_Box__c,
                                APTS_SSD_Sold_To__r.County__c,
                                APTS_SSD_Sold_To__r.Account_Name__r.AccountNumber,
                                Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Proposal_Name__c,
                                Apttus_QPConfig__ProposalId__r.name,
                                APTS_SSD_Sold_To__r.LCRM_Name_2__c,
                                APTS_SSD_Sold_To__r.LCRM_Street_2__c,
                                APTS_SSD_Sold_To__r.LCRM_Street3__c,
                                APTS_SSD_Sold_To__r.CreatedBy.Rep_Employee_Number__c, 
                                APTS_SSD_Sold_To__r.LCRM_Fax__c,
                                APTS_SSD_Sold_To__r.LCRM_Street4__c,
                                APTS_Payer__r.Source_System_Account_Number__c,
                                Apttus_QPConfig__ProposalId__r.CreatedBy.EmployeeNumber,
                                Apttus_QPConfig__ProposalId__r.APTS_HAS_DYNAMIC_BUNDLE__c,  //DOC 13835 Poonam Garg
                                Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.LCRM_eOutput_Eligibility__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Phone__c,
                                Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street_Address_3__c,
                                Apttus_QPConfig__ProposalId__r.TR_Store_Source__c,
                                Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Opportunity__c, //doc-15792 
                                Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Opportunity__r.Active_Trial__c//doc-15792
                                FROM Apttus_Config2__Order__c WHERE Id =: orderId];
        }
        return order;
    }
    
    /**
     * @description Method to query Order Line Item records
     * @param orderId of Id
     * @return List<Apttus_Config2__OrderLineItem__c>
     */
    public static List<Apttus_Config2__OrderLineItem__c> queryOrderLineItems(Id orderId){
        List<Apttus_Config2__OrderLineItem__c> orderLineItems = new List<Apttus_Config2__OrderLineItem__c>();
        if(Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isQueryable()){
            orderLineItems = [SELECT Name,
                    Apttus_Config2__LineNumber__c,
                    APTS_Years_2_Plus_Adjustment__c,
                    Apttus_QPConfig__ProposalLineItemId__r.Net_Qty_Difference__c,
                    Apttus_QPConfig__ProposalLineItemId__r.Name,
                    Apttus_QPConfig__ProposalLineItemId__r.APTS_Product_Name_Override__c,
                    Apttus_QPConfig__ProposalLineItemId__r.APTS_Bridge_Length__c,
                    Apttus_QPConfig__ProposalLineItemId__r.APTS_Lapse_Date__c,
                    APTS_Program_ID__c,
                    APTS_Group__c,Base_Value__c,
                    APTS_Yr_1_Renewal_Adjustment__c,
                    Apttus_Config2__Quantity__c,
                    Apttus_Config2__PriceMethod__c,
                    Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c,
                    Apttus_QPConfig__ProposalLineItemId__r.APTS_Subscription_Number_Override__c,
                    Apttus_Config2__Uom__c,Apttus_Config2__ListPrice__c,
                    APTS_Contract_Line_Number__c,
                    Apttus_Config2__StartDate__c,
                    Apttus_Config2__EndDate__c,
                    Apttus_Config2__BillingFrequency__c,
                    Apttus_Config2__SellingFrequency__c,
                    Apttus_Config2__NetPrice__c,
                    APTS_Bridge__c,
                    Apttus_Config2__LineStatus__c,
                    Apttus_Config2__Description__c,
                    Apttus_Config2__PricingDate__c,
                    APTS_Deal_Number__c,
                    APTS_Contract_Number__c,
                    Apttus_Config2__IncentiveCode__c,
                    APTS_Deal_Type__c ,
                    Apttus_Config2__Type__c,
                    Apttus_Config2__AdjustmentType__c,
                    APTS_Contract_Term__c,
                    Apttus_Config2__ProductId__r.Apttus_Config2__Uom__c,
                    Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,
                    Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c,
                    Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c,
                    Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c, // GLP-183
                    APTS_New_Bridge_Discount__c,
                    Apttus_Config2__OrderId__r.APTS_Order_Value__c,
                    bridge_net_price__c,APTS_Group_Primary_Material__c,
                    Apttus_Config2__AdjustmentAmount__c,
                    APTS_SAP_Deal_Primary_Material__c,
                    APTS_Subscription_Number__c,
                    Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,
                    Apttus_Config2__ChargeType__c,
                    Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c,
                    Apttus_Config2__PriceType__c,
                    Apttus_Config2__LineType__c,
                    Apttus_Config2__OptionId__c,
                    Apttus_Config2__OptionId__r.ProductCode,
                    Apttus_QPConfig__ProposalId__r.APTS_Renewal_Opt_out__c,
                    Apttus_Config2__AdjustedPrice__c,
                    Apttus_Config2__BasePrice__c,
                    Apttus_Config2__ProductId__r.ProductCode,
                    Apttus_Config2__ProductId__r.WLEC_Progam_ID__c,
                    Apttus_QPConfig__ProposalLineItemId__r.APTS_SAP_MLA_Agreement_Number__c,
                    Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, 
                    Apttus_Config2__BaseExtendedPrice__c ,
                    APTS_SAP_MLA_Agreement_Number__c,
                    APTS_Bridge_Monthly_Charge__c,
                    APTS_Decentralized__c,
                    APTS_MLA__c,
                    APTS_Service_Number__c,
                    APTS_One_time_value__c,
                    Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c,
                    Apttus_Config2__ProductId__r.APTS_Corporate_Select__c,
                    Apttus_Config2__ProductId__r.Name, //SOC-8627 Patron
                    APTS_Term_Type__c,APTS_Prorate_base_Value__c,APTS_Calculated_Year_1__c, APTS_Calculated_Year_2__c, APTS_Calculated_Year_3__c, APTS_Calculated_Year_4__c,APTS_Calculated_Year_5__c, APTS_Is_Multi_Tiered_Pricing__c,   //Added as part of TP
                    APTS_Increase_Yr1_Yr2__c,APTS_Increase_Yr2_Yr3__c,APTS_Increase_Yr3_Yr4__c,APTS_Increase_Yr4_Yr5__c,
                    Apttus_Config2__ProductId__r.APTS_Cat_L2__c,Apttus_Config2__ProductId__r.APTS_Cat_L3__c,  //Added by Poonam Garg for DOC 12648
                    APTS_Info_PlanType__c, Apttus_Config2__ProductId__r.Family, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c,APTS_Keep_Terms__c,Apttus_QPConfig__ProposalId__r.APTS_Is_HighQ_Quote__c,APTS_is_Primary_in_Bundle__c,
                    APTS_Cars_One_time_value_c__c,
                    APTS_Proposal_Business_Unit__c,
                    Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c,
                    APTS_Start_Date__c,
                    Apttus_Config2__AssetLineItemId__c, APTS_SSD_Sold_To__c, Apttus_Config2__BillToAccountId__c,
                    Apttus_Config2__AssetLineItemId__r.APTS_SAP_MLA_Agreement_Number__c,
                    Apttus_Config2__AssetLineItemId__r.APTS_Info_RenewalDate__c
                    FROM Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c=: orderId];
        }
        system.debug(LoggingLevel.Warn,'attribute value in ext'+orderLineItems.get(0).Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c);
        system.debug(LoggingLevel.Warn,'attribute value in ext'+orderLineItems.get(0).Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c); 
        system.debug(LoggingLevel.Warn,'attribute value in ext'+orderLineItems.get(0).Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c); 
        system.debug(LoggingLevel.Warn,'attribute value in ext'+orderLineItems.get(0).Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c); 
        return orderLineItems;
    }
    
    /**
     * @description Method to query User record
     * @param ownerId of Id
     * @return User
     */
    public static User queryUser(Id ownerId){
        User proposalOwner = new User();
        if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.isQueryable()){
            proposalOwner = [SELECT id,
                                        Name,
                                        email,
                                        Apts_Revenue_Channel__c,
                                        Sales_Force_Description__c,
                                        Rep_Employee_Number__c,
                                        Market_Segment_Description__c FROM User where Id=:ownerId];
        }
        return proposalOwner;
    }
    
    /**
     * @description Method to query Online Contacts
     * @param propId of Id
     * @return List<Online_Contacts__c>
     */
    public static List<Online_Contacts__c> queryonlinecontacts(Id propId){
        List<Online_Contacts__c> onlinecon = new List<Online_Contacts__c>();
        if(Schema.sObjectType.Online_Contacts__c.isAccessible() && Schema.sObjectType.Online_Contacts__c.isQueryable()){
            onlinecon = [SELECT First_Name__c,
                                Name,
                                Material__c,
                                APTS_Source_System_Detail__c,
                                APTS_Source_System_Detail__r.Source_System_Account_Number__c,
                                Account__c,
                                Last_Name__c,
                                APTS_Source_System_Detail__r.Account_Name__r.AccountNumber,
                                Email__c,
                                Is_Banded_Product__c,
                                ContactID__c,
                                ProductId__r.APTS_Media_High_Level_Code__c,
                                QuoteId__c,
                                Type__c,
                                Position__c,
                                NAIC_Name__c,
                                NAIC_Number__c FROM Online_Contacts__c where QuoteId__c =:propId ];
        }
        return onlinecon;
    }
    
    /**
     * @description Method to query Master Contacts
     * @param propId of Id
     * @return List<Customer_Master_Contacts__c>
     */
    public static List<Customer_Master_Contacts__c> querymastercontacts(Id propId){
        List<Customer_Master_Contacts__c> mastercon = new List<Customer_Master_Contacts__c>();
        if(Schema.sObjectType.Customer_Master_Contacts__c.isAccessible() && Schema.sObjectType.Customer_Master_Contacts__c.isQueryable()){
            mastercon = [SELECT Customer_Type_Description__c,
                                From_IP_Address1__c,
                                From_IP_Address2__c,
                                To_IP_Address1__c,
                                To_IP_Address2__c,
                                From_IP_Address__c,
                                To_IP_Address__c,
                                Email_Address__c,
                                First_Name__c,
                                Quote__c,
                                Last_Name__c,
                                Phone__c FROM Customer_Master_Contacts__c where Quote__c =: propId ];
        }
        return mastercon;
    }
    
    /**
     * @description Method to query Additional Subscriptions
     * @param propId of Id
     * @return List<APTS_Additional_Subscription_Actions__c>
     */
    public static List<APTS_Additional_Subscription_Actions__c> querysubscriptionlist(Id propId){
        List<APTS_Additional_Subscription_Actions__c> additionalSublist= new List<APTS_Additional_Subscription_Actions__c>();
        if(Schema.sObjectType.APTS_Additional_Subscription_Actions__c.isAccessible() && Schema.sObjectType.APTS_Additional_Subscription_Actions__c.isQueryable()){
            additionalSublist= [SELECT APTS_Line_Status__c,
                                       APTS_Contract_Line_Number__c,
                                       APTS_Contract_Number__c,
                                       APTS_Product__c,
                                       APTS_Subscription_Number__c from APTS_Additional_Subscription_Actions__c where APTS_Quote_Proposal__c =: propId ];
        }
        return additionalSublist;
    }
    
    /**
     * @description Method to query Agreement Locations
     * @param propId of Id
     * @return List<APTS_Quote_Agreement_Locations__c>
     */
    public static List<APTS_Quote_Agreement_Locations__c> queryagreementlocations(Id propId){
        List<APTS_Quote_Agreement_Locations__c> multiLocAccount = new List<APTS_Quote_Agreement_Locations__c>();
        if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isAccessible() && Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isQueryable()){
            multiLocAccount =[SELECT APTS_Bundle_Primary__c,
                                     APTS_Proposal_Line_Item__r.Apttus_QPConfig__LineNumber__c,
                                     APTS_Quote_Proposal__r.Apttus_Proposal__Account__c,
                                     APTS_Subscriber_Location_SSD__c,
                                     APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c,
                                     APTS_Proposal_Line_Item__r.Apttus_Proposal__Product__r.ProductCode,
                                     APTS_Proposal_Line_Item__r.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c,
                                     APTS_Proposal_Line_Item__r.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c,
                                     APTS_Status__c,
                                     APTS_Proposal_Line_Item__r.Apttus_Proposal__Quantity__c,
                                     APTS_Quote_Proposal__r.APTS_Sold_To_SAP_Account_Number__c,
                                     APTS_Agreement_Number__c
                                     FROM APTS_Quote_Agreement_Locations__c where APTS_Quote_Proposal__c =:propId ];
        }
        return multiLocAccount;
    }
    
    /**
     * @description Method to query Dynamic Bundles
     * @param propId of Id
     * @return List<APTS_Dynamic_Bundle__c>
     */
    public static List<APTS_Dynamic_Bundle__c> querydynamicbundles(Id propId){
        List<APTS_Dynamic_Bundle__c> dynamicbundlelist = new List<APTS_Dynamic_Bundle__c>();
        if(Schema.sObjectType.APTS_Dynamic_Bundle__c.isAccessible() && Schema.sObjectType.APTS_Dynamic_Bundle__c.isQueryable()){
            dynamicbundlelist = [SELECT APTS_Bundle_Primary_Material__c,
                                        APTS_MLA__c,
                                        APTS_Bridge_Discount_Number__c,
                                        APTS_Bridge_Length__c,
                                        APTS_Bridge__c,
                                        APTS_Bridge_Discount__c,
                                        APTS_Decentralized__c,
                                        APTS_Quote_Proposal__r.APTS_MLA_Quote__c,
                                        APTS_MLA_Agreement_Number__c,
                                        APTS_Keep_Terms__c,
                                        APTS_Bundle_Adjustment_Type__c,
                                        APTS_Program_ID__c,
                                        APTS_Bundle_Adjustment_Amount__c,
                                        APTS_YoY_1_Renewal__c,
                                        Name,APTS_Group__c,
                                        APTS_YoY_2_Plus__c,
                                        APTS_Contract_Terms__c,
                                        APTS_Net_Price__c,
                                        APTS_Bridge_Monthly_Charges__c,
                                        APTS_Quote_Proposal__c,
                                        APTS_Quantity__c, //May Release - added APTS_Quantity__c - SOC-5982
                                        APTS_Quote_Proposal__r.APTS_Is_HighQ_Quote__c,APTS_Billing_Frequency__c, APTS_isBLINotCreated__c, //Added by Kruti Shah DOC-11650
                                        APTS_Deal_Number__c FROM APTS_Dynamic_Bundle__c where APTS_Quote_Proposal__c =: propId AND  APTS_Bundle_Primary_Material__c!= NULL ];  
        }
        return dynamicbundlelist;
    }
    
    /**
     * @description Method to query Line Items
     * @param propId of Id
     * @return List<Apttus_Config2__LineItem__c>
     */
    public static List<Apttus_Config2__LineItem__c> querylineitems(Id propId){
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
        if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()){
            lineItemList = [select Id,
                                   APTS_Program_ID__c,
                                   Apttus_Config2__LineStatus__c,
                                   APTS_Deal_Number__c,
                                   APTS_Group_Primary_Material__c,
                                   APTS_Group__c,
                                   APTS_Contract_Number__c,
                                   APTS_Deal_Type__c,
                                   Apttus_Config2__Quantity__c,
                                   Apttus_Config2__OptionId__r.APTS_Corporate_Select__c,
                                   Apttus_Config2__ProductId__r.APTS_Corporate_Select__c,
                                   Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c,                                   
                                   APTS_Media_High_Level_Code__c,
                                   APTS_Media_Lower_Level_Code__c,
                                   Apttus_Config2__OptionId__c,Apttus_Config2__LineNumber__c,                                   
                                   APTS_Contract_Line_Number__c,Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c,
                                   APTS_Proposal_Business_Unit__c,
                                   Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,
                                   Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,
                                   Apttus_Config2__ProductId__r.Name
                            from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = : propId and Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = 'Finalized'  order by Apttus_Config2__LineNumber__c,Apttus_Config2__LineType__c   ];
        }
        return lineItemList;
    }
    
    /**
     * @description Method to query Aggregate results of Online Contacts
     * @param propId of Id
     * @return List<AggregateResult>
     */
    public static List<AggregateResult> queryaggregateresults(Id propId){
        List<AggregateResult> results = new List<AggregateResult>();
        if(Schema.sObjectType.Online_Contacts__c.isAccessible() && Schema.sObjectType.Online_Contacts__c.isQueryable()){
            results = [SELECT Material__c,
                              Account__c,
                              APTS_Source_System_Detail__c,
                              count(Id) total FROM Online_Contacts__c WHERE QuoteId__c = : propId Group By Material__c,Account__c,APTS_Source_System_Detail__c];
        }
        return results;
    }
  
}