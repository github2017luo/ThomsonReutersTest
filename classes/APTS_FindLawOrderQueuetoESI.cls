/**
* Interface to send the FindLaw order details to ESI 
* Order Details
*
* @author  TCS
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                            Description 
* 2018-03-02    Mohammad Zakeer                 Created(SOC-6820)
* 2019-17-04    Shiva Sri Arun Koralla          Modified(DLT - 16201)
* 2019-09-15    David Hoel                      DLT-17340: added business unit to ESI payload.
* 2019-12-13  Rahul Natarajan          DLT-18706 : Send the Digital Signature document for NSE to SAP
* =============================================================================
* As part SOC-6820  ::replaced Bill to,Ship to,Sold to related fields of account 
*                     with Bill to SSD,Ship to SSD,Sold to SSD  related fields of SSD in whole class
*                   ::all account lookup related fields wrt to objects queried in the class are replaced with ssd related fields
*                   ::removed Queueable and AllowCallouts interface
*/
// this class is calling from Aptts_BatchOrderSubmission class
 /**
     * @description APTS_FindLawOrderQueuetoESI
     
     */
    public without sharing class APTS_FindLawOrderQueuetoESI  {

        public static CreateOrderRequest orderReq;
        public static CreateOrderRequest.orderLines orderLine;
        public static Decimal adjamount;
        
        // method to execute and callout to ESI
         /**
           * @description florderSubmissionToESI
           * @param orderId
           * @return  Boolean
           */
        public static APTS_Ordersubmissionwrapper florderSubmissionToESI(Id orderId) {
        
        system.debug(LoggingLevel.WARN,'$$$$$$Enter FLorderSubmissionToESI'+orderId);
        Apttus_Config2__Order__c order;
        User proposalOwner = new User();
        //processOrderLineItems Variables
        //CreateOrderRequest.orderLines orderLine; // single Line item  
        integer lineNumber = 0;
        integer dealSerialNumber = 0;
        integer rlNumber = 0; // Related Line number
        Decimal revewalValue = null;
        Decimal netAmount = 0;
        Boolean isPrimaryLineItem = False;
        CreateOrderRequest.orderDeal oDeal;
        orderline = new CreateOrderRequest.orderLines();
        APTS_Ordersubmissionwrapper ordersubwrap = new APTS_Ordersubmissionwrapper();
        String loggerId;
        List<Integration_Logger__c> intLogList = new List<Integration_Logger__c>();
        Boolean runOldOrderProcess = false;
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        if(keyValueListRec !=NULL){
            runOldOrderProcess = TRUE;
        }

       try { 
        if (Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()){
        order = [SELECT Id, Name,Apttus_QPConfig__ProposalId__r.APTS_Wet_Signature__c,CreatedDate,Retry_Count__c,Apttus_Config2__OrderReferenceNumber__c, Apttus_QPConfig__ProposalId__c,CreatedBy.Apts_Revenue_Channel__c,
            CreatedBy.Sales_Force_Description__c,CreatedBy.Market_Segment_Description__c,Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c,
            Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c,Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Zipcode__c,
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
            Apttus_QPConfig__ProposalId__r.APTS_Account_Credit_Risk_Category__c,
            Apttus_QPConfig__ProposalId__r.ownerid,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email,
            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Extension__c,
            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName,Number_of_Attorneys__c, 
            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Net_Amount__c,
            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Contact_Type__c,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,
            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Proposal_Name__c,Apttus_QPConfig__ProposalId__r.name,
            Apttus_QPConfig__ProposalId__r.CreatedBy.EmployeeNumber, Apttus_QPConfig__ProposalId__r.APTS_Align_Contract_End_Dates__c, 
            Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c, Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.LastName,Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.FirstName,
            Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Email,Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Contact_Type__c,Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c,
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
            APTS_SSD_Bill_To__r.LCRM_Fax__c,
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
            APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
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
            APTS_SSD_Ship_To__r.Name,
            /*APTS_SSD_Sold_To__r.BillingState,*/APTS_SSD_Sold_To__r.LCRM_Customer_Group__c, 
            /*APTS_SSD_Sold_To__r.BillingStreet, APTS_SSD_Sold_To__r.BillingPostalCode,
            /*APTS_SSD_Sold_To__r.BillingCountry,APTS_SSD_Sold_To__r.SAPAccountNumber__c,
            APTS_SSD_Sold_To__r.NameThree__c,*/
            APTS_SSD_Sold_To__r.LCRM_WLD_ID__c,APTS_SSD_Bill_To__c,
            APTS_SSD_Ship_To__c,
            APTS_SSD_Sold_To__c,
            APTS_SSD_Sold_To__r.Name,Apttus_Config2__SoldToAccountId__r.Customer_Group__c,/*APTS_SSD_Sold_To__r.NameTwo__c,APTS_SSD_Sold_To__r.Street_Address_2__c,
            APTS_SSD_Sold_To__r.Street_Address_3__c,*/APTS_SSD_Sold_To__r.CreatedBy.Rep_Employee_Number__c,
            /*APTS_SSD_Sold_To__r.Fax,APTS_SSD_Sold_To__r.Street_Address_4__c,*/
            APTS_SSD_Sold_To__r.LCRM_PO_Box__c,APTS_SSD_Sold_To__r.County__c,
            /*Apttus_Config2__SoldToAccountId__r.WLD_ID__c,
             Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__c,
            
            Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.SAPAccountNumber__c, 
            Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.Name,
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.NameTwo__c, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.NameThree__c, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.BillingStreet, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.Street_Address_2__c,
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.Street_Address_3__c, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.Street_Address_4__c, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.BillingCity, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.BillingState,
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.BillingCountry, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.BillingPostalCode, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.Phone, 
                    Apttus_Config2__Order__c.Apttus_Config2__BillToAccountId__r.Fax, */
            /*APTS_SSD_Sold_To__r.AccountNumber, */
            
            //APTS_SSD_Ship_To__c,
            /*APTS_SSD_bill_to__r.BillingStreet,APTS_SSD_bill_to__r.BillingCity,APTS_SSD_bill_to__r.BillingState,
            APTS_SSD_bill_to__r.BillingCountry, APTS_SSD_bill_to__r.BillingPostalCode, 
            APTS_SSD_bill_to__r.AccountNumber,
                APTS_SSD_bill_to__r.SAPAccountNumber__c,*/
                APTS_SSD_bill_to__r.Name,
                /*APTS_SSD_bill_to__r.NameThree__c,
            APTS_SSD_bill_to__r.Billing_City_State__c,APTS_SSD_bill_to__r.Street_Address_3__c,
            APTS_SSD_bill_to__r.Street_Address_4__c,APTS_SSD_bill_to__r.Phone,
                APTS_SSD_bill_to__r.Fax,*/
                APTS_SSD_bill_to__r.LCRM_PO_Box__c,
            /*APTS_SSD_bill_to__r.NameTwo__c,APTS_SSD_bill_to__r.Street_Address_2__c,*/
            /*APTS_SSD_Ship_To__r.BillingStreet, APTS_SSD_Ship_To__r.BillingPostalCode,
            APTS_SSD_Ship_To__r.SAPAccountNumber__c,
            APTS_SSD_Ship_To__r.Name,APTS_SSD_Ship_To__r.NameTwo__c,APTS_SSD_Ship_To__r.NameThree__c,
            APTS_SSD_Ship_To__r.Street_Address_4__c,
            APTS_SSD_Ship_To__r.Street_Address_3__c,APTS_SSD_Ship_To__r.Street_Address_2__c,
            APTS_SSD_Ship_To__r.BillingState,APTS_SSD_Ship_To__r.BillingCountry,
            APTS_SSD_Ship_To__r.Phone,APTS_SSD_Ship_To__c.Fax,APTS_SSD_Ship_To__r.BillingCity,*/
            APTS_SSD_Ship_To__r.LCRM_PO_Box__c, Apttus_Config2__Status__c,
            Apttus_Config2__OrderDate__c,
            Apttus_Config2__Type__c,CurrencyIsoCode,APTS_Periodic_Value__c,APTS_FL_Periodic_Value_FL__c,
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
            APTS_Payer__r.LCRM_Fax__c       
            FROM Apttus_Config2__Order__c WHERE Id =:orderId];
            }
            List<Apttus_Config2__OrderLineItem__c> orderLineItems=new List<Apttus_Config2__OrderLineItem__c>();
            if(Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__OrderLineItem__c.isQueryable()){
            orderLineItems=[SELECT Name,Apttus_Config2__LineNumber__c,APTS_Years_2_Plus_Adjustment__c,Apttus_QPConfig__ProposalLineItemId__r.Net_Qty_Difference__c,
            Apttus_QPConfig__ProposalLineItemId__r.Name,
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
            /*Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c,*/
            Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c,
            APTS_New_Bridge_Discount__c,
            Apttus_Config2__OrderId__r.APTS_Order_Value__c,bridge_net_price__c,APTS_Group_Primary_Material__c,Apttus_Config2__AdjustmentAmount__c,
            APTS_SAP_Deal_Primary_Material__c,APTS_Subscription_Number__c, Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,
            Apttus_Config2__ChargeType__c, Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c,Apttus_Config2__PriceType__c, 
            Apttus_Config2__LineType__c, Apttus_Config2__OptionId__c, Apttus_Config2__OptionId__r.ProductCode,
            Apttus_QPConfig__ProposalId__r.APTS_Renewal_Opt_out__c,Apttus_Config2__AdjustedPrice__c,Apttus_Config2__BasePrice__c,
            Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.APTS_CAT_L5__c,Apttus_Config2__ProductId__r.APTS_Practice_Area_Code__c,
            Apttus_Config2__ProductId__r.APTS_Location_Code__c,
            Apttus_Config2__ProductId__r.Product_Level_5__c,
            Apttus_Config2__ProductId__r.APTS_Find_Law_Practice_Area__c,
            Apttus_Config2__OptionId__r.APTS_Find_Law_Practice_Area__c,Apttus_Config2__OptionId__r.APTS_Location_Code__c,
            Apttus_Config2__OptionId__r.APTS_Practice_Area_Code__c, APTS_FL_Price_Increase_Percentage__c, APTS_Years_2_3_Charges_Disc_Surc__c,
            Apttus_Config2__ProductId__r.WLEC_Progam_ID__c,Apttus_QPConfig__ProposalLineItemId__r.APTS_SAP_MLA_Agreement_Number__c,APTS_Number_of_Attorneys__c,APTS_Combination_Key__r.APTS_Attribute_Value1__r.APTS_SAP_Attribute_Code__c,APTS_Combination_Key__r.APTS_Attribute_Value3__r.APTS_SAP_Attribute_Code__c,
            Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, APTS_SAP_MLA_Agreement_Number__c, APTS_Service_Number__c, 
            APTS_Priced_Number_of_Attorneys__c,APTS_Contract_End_Date__c,APTS_FL_Qty__c, Apttus_Config2__BaseExtendedPrice__c FROM Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c=: order.id ];
            }
            if (Schema.sObjectType.User.isAccessible()){
            proposalOwner = [SELECT id,FirstName,LastName,Email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,
                                Market_Segment_Description__c FROM User where Id=:order.Apttus_QPConfig__ProposalId__r.OwnerId];
            }             
            // Logic to process the Order details and assign to ESI request Start
         //   Task task=[Select id,Subject,Description from Task where What.Id=:order.Apttus_QPConfig__ProposalId__c AND Subject LIKE '%Quote/Proposal eSigned by%'];
            orderReq = new CreateOrderRequest();
            Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
                List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
                for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
                    //String flvalue= pb.value__c;               
                    flcodeMap.put(pb.name,pb.value__c.split(','));
                }
                System.debug(LoggingLevel.WARN,'flcode'+flcodeMap);
             //variables
             adjamount = 0;
            // CreateOrderRequest.orderAddress ordaddress;
             //Assign ESI Header
             orderReq.CreateOrderRequest.ESIHeader.applicationId = 'SF05';
             orderReq.CreateOrderRequest.ESIHeader.transactionId = 'WEST';
             List<SAP_Originating_System_Mapping__mdt> sapMapQuery=new List<SAP_Originating_System_Mapping__mdt>();
             if(Schema.sObjectType.SAP_Originating_System_Mapping__mdt .isAccessible() && Schema.sObjectType.SAP_Originating_System_Mapping__mdt.isQueryable()){  
              //New Sales ZPEND Application Id and SapOriginating System - DLT - 16201
                sapMapQuery = [ SELECT Id,QuoteType__c,SAP_Originating_System__c,BusinessUnit__c 
                FROM SAP_Originating_System_Mapping__mdt 
                WHERE QuoteType__c =: order.Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c 
                AND BusinessUnit__c =: order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c LIMIT 1];
             }
             if( !sapMapQuery.isEmpty() ) {         
                orderReq.CreateOrderRequest.ESIHeader.applicationId = sapMapQuery[0].SAP_Originating_System__c;           
                //orderReq.CreateOrderRequest.ESIHeader.extensibleAttributes.value = sapMapQuery[0].BusinessUnit__c;        // DLT-17340
             }
             //Assign Order Header
             orderReq.CreateOrderRequest.OrderHeader.originatingOrderNumber = order.Apttus_QPConfig__ProposalId__r.name;
             orderReq.CreateOrderRequest.OrderHeader.oaMode='W';
             orderReq.CreateOrderRequest.OrderHeader.type = 'NEW_ORDER';
             orderReq.CreateOrderRequest.OrderHeader.description=order.Apttus_Config2__Description__c;
             orderReq.CreateOrderRequest.OrderHeader.orderTimestamp =order.Apttus_Config2__OrderDate__c;
             orderReq.CreateOrderRequest.OrderHeader.quoteNumber=order.Apttus_QPConfig__ProposalId__r.name;
             orderReq.CreateOrderRequest.OrderHeader.orderCurrency=order.CurrencyIsoCode;
             //DOC-4208 
              orderReq.CreateOrderRequest.OrderHeader.creditApproval=order.Apttus_QPConfig__ProposalId__r.APTS_Account_Credit_Risk_Category__c;
             //orderReq.CreateOrderRequest.OrderHeader.esignDate=order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Proposal_Name__c;         
             //SOC-8762 Added by Gowthami Nov'18 release (Adding contract signed timestamp)
              if(order.Apttus_QPConfig__ProposalId__r.APTS_Wet_Signature__c == true){
                 DateTime dt = order.CreatedDate;
                 orderReq.CreateOrderRequest.OrderHeader.esignDate = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                 system.debug(LoggingLevel.WARN,'@@@@@@@'+orderReq.CreateOrderRequest.OrderHeader.esignDate);
                 }else{
                     List<Task> taskobj;
                     if (Schema.sObjectType.Task.isAccessible()){
                     taskobj=[Select id,Subject,Description from Task where What.Id=:order.Apttus_QPConfig__ProposalId__c AND Subject LIKE '%Quote/Proposal eSigned by%' limit 1];
                     }
                     system.debug(LoggingLevel.WARN,'Task'+taskobj);
                     if(!taskobj.isEmpty()){
                        String subject= taskobj[0].Subject;
                        String subList= subject.substringAfterLast('@');
                        System.debug(LoggingLevel.WARN,'subList'+subList);
                        String finalString=subList.replace(' GMT','Z');
                        System.debug(LoggingLevel.WARN,'!!!!'+finalString);
                        orderReq.CreateOrderRequest.OrderHeader.esignDate = finalString;
                     }else if(taskobj.isEmpty()){
                        DateTime dtme = order.CreatedDate;
                        orderReq.CreateOrderRequest.OrderHeader.esignDate = dtme.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                        system.debug(LoggingLevel.WARN,'TaskNull'+orderReq.CreateOrderRequest.OrderHeader.esignDate);
                     }
                }        
             orderReq.CreateOrderRequest.OrderHeader.poNumber=order.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c;
             orderReq.CreateOrderRequest.OrderHeader.revenueChannel=proposalOwner.Apts_Revenue_Channel__c;
             //orderReq.CreateOrderRequest.orderHeader.holdForReview='Y';
             orderReq.CreateOrderRequest.orderHeader.profileId = '1';
             //orderReq.CreateOrderRequest.orderHeader.WLDID = order.Apttus_Config2__SoldToAccountId__r.WLD_ID__c;
             orderReq.CreateOrderRequest.orderHeader.WLDID = order.APTS_SSD_Sold_To__r.LCRM_WLD_ID__c;
             
             //assign Revenue Channel of Order Header
             if(!string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c)){         
                 orderReq.CreateOrderRequest.OrderHeader.revenueChannel=order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c;
             }
             else if(string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c) && string.isEmpty(proposalOwner.Apts_Revenue_Channel__c)) {
                 if(proposalOwner.Market_Segment_Description__c == 'Inside'){
                 orderReq.CreateOrderRequest.OrderHeader.revenueChannel = '05';}
                 else if(proposalOwner.Sales_Force_Description__c == 'Home Office'){
                 orderReq.CreateOrderRequest.OrderHeader.revenueChannel = '06'; }           
                 else {
                 orderReq.CreateOrderRequest.OrderHeader.revenueChannel = '01';}
             } 
             //Revenue channel assignment Latest
             if(((proposalOwner.Market_Segment_Description__c == 'FindLaw' || proposalOwner.Market_Segment_Description__c == 'RSC FindLaw' || proposalOwner.Market_Segment_Description__c == 'FL Open Coverage' || proposalOwner.Market_Segment_Description__c == 'FindLaw Full Terr') && proposalOwner.Sales_Force_Description__c == 'Home Office') 
                 || (proposalOwner.Market_Segment_Description__c == 'FindLaw' && proposalOwner.Sales_Force_Description__c == 'SAM')){
                 orderReq.CreateOrderRequest.OrderHeader.revenueChannel = '01';}
             else if(proposalOwner.Market_Segment_Description__c == 'Super Lawyers' && proposalOwner.Sales_Force_Description__c == 'SAM'){
             orderReq.CreateOrderRequest.OrderHeader.revenueChannel = 'Z4';}
                       
             orderReq.CreateOrderRequest.OrderHeader.orderSource='20';
             //assign OrderRep Details
             orderReq.CreateOrderRequest.orderHeader.orderRep.repNumber = proposalOwner.Rep_Employee_Number__c;
             orderReq.CreateOrderRequest.orderHeader.orderRep.firstName = proposalOwner.FirstName;
             orderReq.CreateOrderRequest.orderHeader.orderRep.lastName = proposalOwner.LastName;
             orderReq.CreateOrderRequest.orderHeader.orderRep.email = proposalOwner.Email;
             orderReq.CreateOrderRequest.orderHeader.completeDelivery = null;
             orderReq.CreateOrderRequest.OrderHeader.eBillExempt =order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c;
               
             //skg orderReq.CreateOrderRequest.orderHeader.orderPeriodicValue= string.valueOf(order.APTS_Periodic_Value__c); //String.valueof(PeriodicValue);
             orderReq.CreateOrderRequest.orderHeader.orderPeriodicValue= string.valueOf(order.APTS_FL_Periodic_Value_FL__c); //String.valueof(PeriodicValue);
             orderReq.CreateOrderRequest.orderHeader.oneTimeValue=String.valueof(order.APTS_One_Time_Value__c.setscale(2)); //string.valueof(onetimevalue);
      
             if(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c == 'Ground Shipping - U.S. Only' || string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c)){          
             orderReq.CreateOrderRequest.OrderHeader.incoTerms='FOB'; }           
             else{
             orderReq.CreateOrderRequest.OrderHeader.incoTerms='ZCH';}
             //assign Credit card details to Order Header
             if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Credit Card' || order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge'){
                 if(order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c != null){                
                     orderReq.CreateOrderRequest.orderHeader.creditCardPayment.expiration = DateTime.newInstance(order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c.year(),order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c.month(),order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c.day()).format('yyyyMMdd');   
                 }               
                 orderReq.CreateOrderRequest.orderHeader.creditCardPayment.authorizationNumber = order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c;
                 orderReq.CreateOrderRequest.orderHeader.creditCardPayment.authorizationTransaction = order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Transaction__c;
                 orderReq.CreateOrderRequest.orderHeader.creditCardPayment.amount = string.valueof(order.Apttus_QPConfig__ProposalId__r.APTS_amount__c);
                 orderReq.CreateOrderRequest.orderHeader.creditCardPayment.cardType = order.Apttus_QPConfig__ProposalId__r.APTS_Card_Type__c;
                 orderReq.CreateOrderRequest.orderHeader.creditCardPayment.cardNumber = order.Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c;
             }
             
             //Added by Sakshi on 9/11/2018 for SOC-8652(To pass Cust Sup No.)
             if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Bill to Account'){
                    orderReq.CreateOrderRequest.orderHeader.accountPayment.accountNumber=order.APTS_SSD_bill_to__r.Source_System_Account_Number__c;
                    }
             //assign BillTo Account to Order Header      
             //SOC-6820 yet to change SSD fields
             //if(order.Apttus_Config2__BillToAccountId__c != null) {
             system.debug(LoggingLevel.WARN,'SoldTo'+order.APTS_SSD_Sold_To__c);
                      system.debug(LoggingLevel.WARN,'SoldTo'+order.APTS_SSD_Ship_To__c);
      
             if(order.APTS_SSD_Bill_To__c != null) {
                 //call a util method to assign the address values
                 orderReq.CreateOrderRequest.orderHeader.orderAddress.add(assignAddessValues('billTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Bill_To__r.Source_System_Account_Number__c, order.APTS_SSD_Bill_To__r.Name,
                     order.APTS_SSD_Bill_To__r.LCRM_Name_2__c,order.APTS_SSD_Bill_To__r.LCRM_Name_3__c, order.APTS_SSD_Bill_To__r.Number_Street__c, order.APTS_SSD_Bill_To__r.LCRM_Street_2__c,
                     order.APTS_SSD_Bill_To__r.LCRM_Street3__c, order.APTS_SSD_Bill_To__r.LCRM_Street4__c, order.APTS_SSD_Bill_To__r.City__c, order.APTS_SSD_Bill_To__r.State__c,
                     order.APTS_SSD_Bill_To__r.Country__c, order.APTS_SSD_Bill_To__r.Postal_Code__c, order.APTS_SSD_Bill_To__r.LCRM_Phone__c, order.APTS_SSD_Bill_To__r.LCRM_Fax__c, order.APTS_SSD_Bill_To__r.LCRM_PO_Box__c));                                                                          
                 
             }
             //assign SoldTo Account to Order Header
             //SOC-6820 yet to change SSD fields
             //if(order.Apttus_Config2__SoldToAccountId__c!=null) {
             if(order.APTS_SSD_Sold_To__c != null) {
                 orderReq.CreateOrderRequest.orderHeader.orderAddress.add(assignAddessValues('soldTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Sold_To__r.Source_System_Account_Number__c, order.APTS_SSD_Sold_To__r.Name,
                     order.APTS_SSD_Sold_To__r.LCRM_Name_2__c,order.APTS_SSD_Sold_To__r.LCRM_Name_3__c, order.APTS_SSD_Sold_To__r.Number_Street__c, order.APTS_SSD_Sold_To__r.LCRM_Street_2__c,
                     order.APTS_SSD_Sold_To__r.LCRM_Street3__c, order.APTS_SSD_Sold_To__r.LCRM_Street4__c, order.APTS_SSD_Sold_To__r.City__c, order.APTS_SSD_Sold_To__r.State__c,
                     order.APTS_SSD_Sold_To__r.Country__c, order.APTS_SSD_Sold_To__r.Postal_Code__c, order.APTS_SSD_Sold_To__r.LCRM_Phone__c, order.APTS_SSD_Sold_To__r.LCRM_Fax__c, order.APTS_SSD_Sold_To__r.LCRM_PO_Box__c));                 
                     
             }         
            //assign ShipTo Account to Order header and assign same values of Sold to Account
            //SOC-6820 yet to change SSD fields
            //if(order.Apttus_Config2__ShipToAccountId__c!=null) {
            if(order.APTS_SSD_Ship_To__c != null) {
                //call a util method to assign the address values
              /* old account   orderReq.CreateOrderRequest.orderHeader.orderAddress.add(assignAddessValues('shipTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Ship_To__r.Source_System_Account_Number__c, order.Apttus_Config2__ShipToAccountId__r.Name,
                     order.Apttus_Config2__ShipToAccountId__r.NameTwo__c, order.Apttus_Config2__ShipToAccountId__r.NameThree__c, order.Apttus_Config2__ShipToAccountId__r.BillingStreet, order.Apttus_Config2__ShipToAccountId__r.Street_Address_2__c,
                     order.Apttus_Config2__ShipToAccountId__r.Street_Address_3__c, order.Apttus_Config2__ShipToAccountId__r.Street_Address_4__c, order.Apttus_Config2__ShipToAccountId__r.BillingCity, order.Apttus_Config2__ShipToAccountId__r.BillingState,
                     order.Apttus_Config2__ShipToAccountId__r.BillingCountry, order.Apttus_Config2__ShipToAccountId__r.BillingPostalCode, order.Apttus_Config2__ShipToAccountId__r.Phone, order.Apttus_Config2__ShipToAccountId__r.Fax, order.APTS_SSD_Ship_To__r.LCRM_PO_Box__c));  */                                                                       
      
                 orderReq.CreateOrderRequest.orderHeader.orderAddress.add(assignAddessValues('shipTo', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_SSD_Ship_To__r.Source_System_Account_Number__c, order.APTS_SSD_Ship_To__r.Name,
                     order.APTS_SSD_Ship_To__r.LCRM_Name_2__c,order.APTS_SSD_Ship_To__r.LCRM_Name_3__c, order.APTS_SSD_Ship_To__r.Number_Street__c, order.APTS_SSD_Ship_To__r.LCRM_Street_2__c,
                     order.APTS_SSD_Ship_To__r.LCRM_Street3__c, order.APTS_SSD_Ship_To__r.LCRM_Street4__c, order.APTS_SSD_Ship_To__r.City__c, order.APTS_SSD_Ship_To__r.State__c,
                     order.APTS_SSD_Ship_To__r.Country__c, order.APTS_SSD_Ship_To__r.Postal_Code__c, order.APTS_SSD_Ship_To__r.LCRM_Phone__c, order.APTS_SSD_Ship_To__r.LCRM_Fax__c, order.APTS_SSD_Ship_To__r.LCRM_PO_Box__c));                 
            }  
             //SOC-8298 - Payer SSD added by Keerthana
            if(order.APTS_Payer__c!=null) {
                    orderReq.CreateOrderRequest.orderHeader.orderAddress.add(assignAddessValues('payer', order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c, order.APTS_Payer__r.Source_System_Account_Number__c, order.APTS_Payer__r.Name,
                     order.APTS_Payer__r.LCRM_Name_2__c,order.APTS_Payer__r.LCRM_Name_3__c, order.APTS_Payer__r.Number_Street__c, order.APTS_Payer__r.LCRM_Street_2__c,
                     order.APTS_Payer__r.LCRM_Street3__c, order.APTS_Payer__r.LCRM_Street4__c, order.APTS_Payer__r.City__c, order.APTS_Payer__r.State__c,
                     order.APTS_Payer__r.Country__c, order.APTS_Payer__r.Postal_Code__c, order.APTS_Payer__r.LCRM_Phone__c, order.APTS_Payer__r.LCRM_Fax__c, order.APTS_Payer__r.LCRM_PO_Box__c));                              
                }//SOC-8298 ends
            //assign Order contact to Order Header
            CreateOrderRequest.orderContact ordcontact = new CreateOrderRequest.orderContact();
            ordcontact.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName;
            ordcontact.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName;        
            ordcontact.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email;
            //ordcontact.phone=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Phone;
            //ordcontact.phoneExtension=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Extension__c        
            ordcontact.phone = '1111111111';
            ordcontact.phoneExtension ='001';
            ordcontact.function=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Contact_Type__c;        
            ordcontact.ContactType= '28';
            orderReq.CreateOrderRequest.OrderHeader.orderContact.add(ordcontact);
            
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c!=null){
                CreateOrderRequest.orderContact ebcontact = new CreateOrderRequest.orderContact();
                ebcontact.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.FirstName;
                ebcontact.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.LastName; 
                ebcontact.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Email;
                ebcontact.phone=null;
                ebcontact.phoneExtension=null;
                ebcontact.contactNumber=null;
                ebcontact.department=null;
                ebcontact.fax=null;
                ebcontact.function=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Contact_Type__c;
                ebcontact.building=null;
                ebcontact.floor=null;
                ebcontact.room=null;
                ebcontact.ContactType= '30';
                orderReq.CreateOrderRequest.OrderHeader.orderContact.add(ebcontact);
            }
             else if(order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c==null){ 
                CreateOrderRequest.orderContact ebcontact = new CreateOrderRequest.orderContact();
                
                ebcontact.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName;
                ebcontact.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName; 
                ebcontact.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email;
                ebcontact.phone='1111111111';
                ebcontact.phoneExtension='001';
                ebcontact.contactNumber=null;
                ebcontact.department=null;
                ebcontact.fax=null;
                ebcontact.function=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Contact_Type__c;
                ebcontact.building=null;
                ebcontact.floor=null;
                ebcontact.room=null;
                ebcontact.ContactType= '30';
                
                orderReq.CreateOrderRequest.OrderHeader.orderContact.add(ebcontact);
                }
      
           //Assign the signed document to the Order Header        
         /*  for(Attachment att : [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%signed%') ORDER BY LastModifiedDate ASC NULLS LAST LIMIT 1]) {
                CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();
                attachment.path = att.Id;
                attachment.type= 'OR';
                attachment.status= 'E'; 
                orderReq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
               //system.debug('attachment...'+attachment);
      
            } 
        // DLT-18706 Starts Here
        for(Attachment att : [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%Signature%') ORDER BY LastModifiedDate ASC NULLS LAST LIMIT 1]) {
                CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();
                attachment.path = att.Id;
                attachment.type= 'OR';
                attachment.status= 'E'; 
                orderReq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
               //system.debug('Sends Digital Attachment...'+attachment);
      
            } // DLT-18706 Ends Here
            // Logic to process the Order details and assign to ESI request End.
            */
            //Co-term logic SOC-9837 starts  
           //orderheaderAttachment Method Moved to APTS_OrderSubmissionUtility Class for Content Version(Files)
            APTS_OrderSubmissionUtility.orderheaderAttachment(order.Apttus_QPConfig__ProposalId__c, orderReq);
            Date farthestEndDate;
            Date finalfarthestEndDate;
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Align_Contract_End_Dates__c == true){
                for(Apttus_Config2__OrderLineItem__c oli :orderLineItems){
                    if(oli.Apttus_Config2__LineStatus__c == 'Renewed'){
                        if(farthestEndDate == null){
                            farthestEndDate = oli.APTS_Contract_End_Date__c;
                        }
                        else{
                            if(farthestEndDate < oli.APTS_Contract_End_Date__c){
                            farthestEndDate = oli.APTS_Contract_End_Date__c;}
                        }
                        
                        if(oli.APTS_Contract_End_Date__c == farthestEndDate){
                            finalfarthestEndDate = farthestEndDate.addDays(-1);
                            /*if(oli.APTS_Contract_Term__c == '1 Year')
                                finalfarthestEndDate = finalfarthestEndDate.addYears(1);
                            else if(oli.APTS_Contract_Term__c == '2 Years')
                                finalfarthestEndDate = finalfarthestEndDate.addYears(2);
                            else if(oli.APTS_Contract_Term__c == '3 Years')
                                finalfarthestEndDate = finalfarthestEndDate.addYears(3); */
                        }
                    }
                    system.debug(LoggingLevel.WARN,'###### orderLineItems'+orderLineItems);
                }
            }
            
            //Co-term logic SOC-9837 ends
            
            //Logic to Process Order Line Items and assigns to ESI Request Start.
            for(Apttus_Config2__OrderLineItem__c oli :orderLineItems) {
                system.debug(LoggingLevel.WARN,'@@@@@oli'+oli);
                 orderLine = new CreateOrderRequest.orderLines();
                 //if(oDeal==null)
                 
                 if(revewalValue == null){
                 revewalValue = 0; }            
                 if(oli.Apttus_Config2__LineStatus__c == 'New' || oli.Apttus_Config2__LineStatus__c == 'Renewed'){
                 system.debug(LoggingLevel.WARN,'@@@@@oli'+oli);
                     lineNumber += 1;                 
                     orderLine.referenceNumber = oli.Apttus_QPConfig__ProposalLineItemId__r.Name;
                     /* commented out next two lines per SOC-7447
                     orderLine.subscriptionDetail.contractStartDate = oli.Apttus_Config2__StartDate__c;
                     orderLine.subscriptionDetail.contractEndDate = oli.Apttus_Config2__EndDate__c;*/
                     orderLine.subscriptionDetail.subscriptionType = oli.Apttus_Config2__Type__c; 
                     if(!string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c)){
                     orderLine.saID = order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c.substringAfter('(').remove(')');}
                     orderLine.outClause = oli.Apttus_QPConfig__ProposalId__r.APTS_Renewal_Opt_out__c;
                     orderLine.material.description = oli.Apttus_Config2__Description__c;
                     orderLine.material.materialId = oli.Apttus_Config2__ProductId__r.ProductCode;
                  //   if(oli.Apttus_Config2__ProductId__r.ProductCode == '40477192' || oli.Apttus_Config2__OptionId__r.ProductCode == '40477192')
                      //SOC-7668 starts added by Keerthana
                       if(oli.Apttus_Config2__OptionId__r.ProductCode == '40475630' || oli.Apttus_Config2__OptionId__r.ProductCode == '40588593' || oli.Apttus_Config2__OptionId__r.ProductCode == '40588594' || oli.Apttus_Config2__OptionId__r.ProductCode == '40592656' ){
                                 orderLine.material.locationCode = '3115';                
                                 orderLine.material.practiceArea = '134';   
                          }
                        
                      //Commented following lines as part of SOC-7668
                      /*orderLine.material.locationCode = oli.Apttus_Config2__ProductId__r.APTS_Location_Code__c;                
                      orderLine.material.practiceArea = oli.Apttus_Config2__ProductId__r.APTS_Practice_Area_Code__c;*/
                      //SOC-7668 ends
                    // SOC-6820               
                     orderLine.numberOfAttorneys = string.valueOf(oli.APTS_Priced_Number_of_Attorneys__c);
                     orderLine.billPlanType = oli.Apttus_Config2__SellingFrequency__c;
                     orderLine.unitOfMeasure='EA'; 
                     if(oli.APTS_Bridge__c=='N/a' || String.isEmpty(oli.APTS_Bridge__c) ){
                     orderLine.freeServiceDays ='0'; }                           
                     else{
                     orderLine.freeServiceDays = String.valueOf(Integer.valueOf(oli.APTS_Bridge__c.substringBefore(' '))*30);}                    
                     
                     if(oli.Apttus_Config2__LineType__c == 'Product/Service') {
                         isPrimaryLineItem = True;
                          oDeal = new CreateOrderRequest.orderDeal();
                    //SOC-6820
                  /*      system.debug('$$$$$$numberOfAttorneys1'+orderReq.CreateOrderRequest.OrderHeader.numberOfAttorneys);
                                            system.debug('$$$$$$numberOfAttorneys2'+oli.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c); */
                /* SKG SOC-6993 */
                
                        //SOC-9204 added by Sakshi for FL Exposure Pack
                        if(oli.Apttus_Config2__ProductId__r.ProductCode == '40656701'){
                            orderLine.programId = 'CS03';
                        } 
                        if(flcodeMap!=null && flcodeMap.get('FL NATIONAL AD PACKAGES')!=null && flcodeMap.get('FL NATIONAL AD PACKAGES').contains(oli.Apttus_Config2__ProductId__r.PRODUCTCODE)){
                                 orderLine.programId = 'CS03';
                                 orderLine.itemCategory='ZSBY';
                                 oDeal.programId = 'CS03';
                                 dealSerialNumber += 1;                     
                                 oDeal.dealSerialNumber = string.valueOf(dealSerialNumber);
                                 oDeal.startDate = Order.CreatedDate.format('yyyyMMdd');                     
                                 oDeal.endDate = DateTime.newInstance(9999, 12, 31).format('yyyyMMdd');
                                 oDeal.lineItems.add(assignDealLines('PRI', lineNumber));
                                 orderReq.CreateOrderRequest.OrderHeader.orderDeal.add(oDeal);
                        }
                    
                   //added by Gowthami as part of SOC-8888
                    if(oli.APTS_FL_Qty__c!= null && oli.Apttus_Config2__ProductId__r.ProductCode=='41053157'){
                        orderReq.CreateOrderRequest.OrderHeader.numberOfAttorneys= string.valueof(oli.APTS_FL_Qty__c.setscale(0));
                    }
          
                      if((orderReq.CreateOrderRequest.OrderHeader.numberOfAttorneys==null || orderReq.CreateOrderRequest.OrderHeader.numberOfAttorneys== '')&&(oli.Apttus_Config2__AttributeValueId__c!=null ) &&(oli.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c!=null) ){ 
                      orderReq.CreateOrderRequest.OrderHeader.numberOfAttorneys= string.valueof(oli.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c.setscale(0));  }   
                       
                         rlNumber = lineNumber; // assign the Primiary Line number value to Related Line Number
                         //Assign OrderDeal info for Primary Line item
                         //skg dealSerialNumber += 1;                     
                         //skg oDeal.dealSerialNumber = string.valueOf(dealSerialNumber);
                         //skg oDeal.startDate = Order.CreatedDate.format('yyyyMMdd');                     
                         //skg oDeal.endDate = DateTime.newInstance(9999, 12, 31).format('yyyyMMdd');
                         //skg oDeal.lineItems.add(assignDealLines('PRI', lineNumber));
                         
                         //As part of SOC-4580 removing conditions for 'CONVERSION SOLUTIONS','RETURNS RESERVE L4' and 'VISIBILITY' by Keerthana
                         //Removed the Category FS1,FS2,FS3&FS4 and replaced those with the Products in Website-other as part of SOC-9757 
                         if( (oli.Apttus_Config2__ProductId__r.ProductCode == '40475630' ||
                              oli.Apttus_Config2__ProductId__r.ProductCode == '40483693' ||
                              oli.Apttus_Config2__ProductId__r.ProductCode == '40592656' ||
                              oli.Apttus_Config2__ProductId__r.ProductCode == '40483696' ||
                              oli.Apttus_Config2__ProductId__r.ProductCode == '40588593' ||
                              oli.Apttus_Config2__ProductId__r.ProductCode == '40483699' ||
                              oli.Apttus_Config2__ProductId__r.ProductCode == '40588594' ||
                              oli.Apttus_Config2__ProductId__r.ProductCode == '40485592' ||
                              oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c=='L5_L0175_FP'
                             ) && 
                             (oli.Apttus_Config2__ProductId__r.ProductCode != '42564669' &&
                             oli.Apttus_Config2__ProductId__r.ProductCode != '42595567' &&
                             oli.Apttus_Config2__ProductId__r.ProductCode != '42565164' &&
                             oli.Apttus_Config2__ProductId__r.ProductCode != '42595564' &&
                             oli.Apttus_Config2__ProductId__r.ProductCode != '42595563')) {
                             //skg orderLine.programId = 'CS02';
                             orderLine.itemCategory='ZSBY';
                             if(oli.Apttus_Config2__LineStatus__c  != 'Renewed') {
                                 orderLine.programId = 'CS02';
                                 oDeal.programId = 'CS02';
                                 dealSerialNumber += 1;                     
                                 oDeal.dealSerialNumber = string.valueOf(dealSerialNumber);
                                 oDeal.startDate = Order.CreatedDate.format('yyyyMMdd');                     
                                 oDeal.endDate = DateTime.newInstance(9999, 12, 31).format('yyyyMMdd');
                                 //skg if(oli.Apttus_Config2__LineStatus__c  != 'Renewed') 
                                 oDeal.lineItems.add(assignDealLines('PRI', lineNumber));
                             }
                         //skgif(oDeal != null)
                         System.debug('########1234'+oDeal);
                         System.debug('########1234'+orderReq);       
                         orderReq.CreateOrderRequest.OrderHeader.orderDeal.add(oDeal);                                                  
                         }
                          else if(flcodeMap!=null && flcodeMap.get('PPC MANAGEMENT')!=null && flcodeMap.get('PPC MANAGEMENT').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c)){ // added by gayatri -date 20/12/17
                              if(oli.Apttus_Config2__LineType__c == 'Product/Service') { 
                               orderLine.material.materialId = oli.Apttus_Config2__ProductId__r.ProductCode;
                              }
                              if(oli.Apttus_Config2__ChargeType__c == 'Subscription Fee'&& oli.Apttus_Config2__PriceType__c == 'Recurring'){                          
                                 orderLine.itemCategory='ZGR3';
                              }
                              orderLine.noBomExplosion = 'X';                           
                         } 
                         //Merged code for FindLawChanges start            
                         //Added by Sakshi for SOC-6993 on 3/21/2018
                         //Added Product Family 'FL NATIONAL AD PACKAGES' for SOC-9204 by Sakshi on 11/21/2018 FEB Release
                         //Clause for 'connect soln' added by sakshi for SOC-8860 on 9/19/2018
                         //Added "LANDING PAGES" by Gowthami for SOC-9189 for FEB Release
                         if(flcodeMap!=null && flcodeMap.get('LI TOPSPOT')!=null && (flcodeMap.get('LI TOPSPOT').contains(oli.Apttus_Config2__ProductId__r.productcode)) || 
                         (flcodeMap!=null && flcodeMap.get('FL TOPSPOT')!=null && flcodeMap.get('FL TOPSPOT').contains(oli.Apttus_Config2__ProductId__r.productcode)) || 
                         (flcodeMap!=null && flcodeMap.get('SL TOPSPOT')!=null && flcodeMap.get('SL TOPSPOT').contains(oli.Apttus_Config2__ProductId__r.productcode)) || 
                         (flcodeMap!=null && flcodeMap.get('AB TOPSPOT')!=null && flcodeMap.get('AB TOPSPOT').contains(oli.Apttus_Config2__ProductId__r.productcode))|| 
                         (flcodeMap!=null && flcodeMap.get('LI SPOTLIGHT')!=null && flcodeMap.get('LI SPOTLIGHT').contains(oli.Apttus_Config2__ProductId__r.productcode)) ||
                            (flcodeMap!=null && flcodeMap.get('FL SPOTLIGHT')!=null &&flcodeMap.get('FL SPOTLIGHT').contains(oli.Apttus_Config2__ProductId__r.productcode))||
                            (flcodeMap!=null && flcodeMap.get('SL SPOTLIGHT')!=null &&flcodeMap.get('SL SPOTLIGHT').contains(oli.Apttus_Config2__ProductId__r.productcode)) || 
                            (flcodeMap!=null && flcodeMap.get('AB SPOTLIGHT')!=null &&flcodeMap.get('AB SPOTLIGHT').contains(oli.Apttus_Config2__ProductId__r.productcode) )|| 
                            (flcodeMap!=null && flcodeMap.get('BLOGS')!=null &&flcodeMap.get('BLOGS').contains(oli.Apttus_Config2__ProductId__r.productcode)) || 
                            (flcodeMap!=null && flcodeMap.get('DMA')!=null &&flcodeMap.get('DMA' ).contains(oli.Apttus_Config2__ProductId__r.productcode))|| 
                            (flcodeMap!=null && flcodeMap.get('FL PROFILES')!=null &&flcodeMap.get('FL PROFILES').contains(oli.Apttus_Config2__ProductId__r.productcode)) || 
                            (flcodeMap!=null && flcodeMap.get('FL FOCUS PAGES')!=null &&flcodeMap.get('FL FOCUS PAGES').contains(oli.Apttus_Config2__ProductId__r.productcode))|| 
                            (flcodeMap!=null && flcodeMap.get('VENDOR DIGITAL ADS')!=null &&flcodeMap.get('VENDOR DIGITAL ADS').contains(oli.Apttus_Config2__ProductId__r.productcode)) ||
                            (flcodeMap!=null && flcodeMap.get('ASK SL ONLINE')!=null &&flcodeMap.get('ASK SL ONLINE' ).contains(oli.Apttus_Config2__ProductId__r.productcode))|| 
                            (flcodeMap!=null && flcodeMap.get('Answering Services')!=null &&flcodeMap.get('Answering Services' ).contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c))|| 
                            (flcodeMap!=null && flcodeMap.get('CONNECT SOLUTIONS')!=null &&flcodeMap.get('CONNECT SOLUTIONS').contains(oli.Apttus_Config2__ProductId__r.productcode)) || 
                            (flcodeMap!=null && flcodeMap.get('FL NATIONAL AD PACKAGES')!=null &&flcodeMap.get('FL NATIONAL AD PACKAGES').contains(oli.Apttus_Config2__ProductId__r.productcode)) ||
                            (flcodeMap!=null && flcodeMap.get('LANDING PAGES')!=null &&flcodeMap.get('LANDING PAGES' ).contains(oli.Apttus_Config2__ProductId__r.productcode))|| 
                            (flcodeMap!=null && flcodeMap.get('FINDLAW LANDING PAGE HOSTIN')!=null &&flcodeMap.get('FINDLAW LANDING PAGE HOSTIN').contains(oli.Apttus_Config2__ProductId__r.productcode) )||
                            (flcodeMap!=null && flcodeMap.get('AB PROFILES')!=null && flcodeMap.get('AB PROFILES').contains(oli.Apttus_Config2__ProductId__r.productcode))){
                            //Added by Keerthana for SOC-7617
                              if(oli.Apttus_Config2__LineStatus__c =='New'){
                                  system.debug('Entered new loop');
                                orderLine.material.locationCode = oli.APTS_Combination_Key__r.APTS_Attribute_Value1__r.APTS_SAP_Attribute_Code__c;                
                                orderLine.material.practiceArea = oli.APTS_Combination_Key__r.APTS_Attribute_Value3__r.APTS_SAP_Attribute_Code__c;
                                
                                //Added by Shreekanth for SOC-6993 on 4/26/2018
                                 if(oli.APTS_Contract_Term__c=='N/a'){
                                    orderLine.billPlanUpdateRule='0';
                                    }
                                else if(oli.APTS_Contract_Term__c=='1 Month'){
                                    orderLine.billPlanUpdateRule='1';
                                    }
                                else if(oli.APTS_Contract_Term__c=='2 Months'){
                                    orderLine.billPlanUpdateRule='2';
                                    }
                                else if(oli.APTS_Contract_Term__c=='3 Months'){
                                    orderLine.billPlanUpdateRule='3';
                                    }
                                else if(oli.APTS_Contract_Term__c=='4 Months'){
                                    orderLine.billPlanUpdateRule='4';
                                    }
                                else if(oli.APTS_Contract_Term__c=='5 Months'){
                                    orderLine.billPlanUpdateRule='5';
                                    }
                                else if(oli.APTS_Contract_Term__c=='6 Months'){
                                    orderLine.billPlanUpdateRule='6';
                                    }
                                else if(oli.APTS_Contract_Term__c=='7 Months'){
                                    orderLine.billPlanUpdateRule='7';
                                    }
                                else if(oli.APTS_Contract_Term__c=='8 Months'){
                                    orderLine.billPlanUpdateRule='8';
                                    }
                                else if(oli.APTS_Contract_Term__c=='9 Months'){
                                    orderLine.billPlanUpdateRule='9';
                                    }
                                else if(oli.APTS_Contract_Term__c=='10 Months'){
                                    orderLine.billPlanUpdateRule='10';
                                    }
                                else if(oli.APTS_Contract_Term__c=='11 Months'){
                                    orderLine.billPlanUpdateRule='11';
                                    }
                              }
                             system.debug('Entered renew loop');
                           /*      orderLine.numberOfAttorneys = string.valueOf(oli.APTS_Number_of_Attorneys__c);
                                                    system.debug('$$$$$$numberOfAttorneys5'+orderReq.CreateOrderRequest.OrderHeader.numberOfAttorneys);
                                            system.debug('$$$$$$numberOfAttorneys6'+string.valueOf(oli.APTS_Number_of_Attorneys__c));
                                orderReq.CreateOrderRequest.OrderHeader.numberOfAttorneys= string.valueOf(oli.APTS_Number_of_Attorneys__c);
                                
                                                    system.debug('$$$$$$numberOfAttorneys7'+orderReq.CreateOrderRequest.OrderHeader.numberOfAttorneys);
                                            system.debug('$$$$$$numberOfAttorneys8'+string.valueOf(oli.APTS_Number_of_Attorneys__c)); */
                            }
                         
                      //Merged code for FindLawChanges ends    
                         //skg if(oli.Apttus_Config2__ChargeType__c == 'Subscription Fee'&& oli.Apttus_Config2__PriceType__c == 'Recurring' &&  ! (oli.Apttus_Config2__LineStatus__c  == 'Renewed') && oli.Apttus_Config2__ProductId__r.ProductCode !='30010890'){
                         if(oli.Apttus_Config2__ChargeType__c == 'Subscription Fee'&& oli.Apttus_Config2__PriceType__c == 'Recurring' &&  ! (oli.Apttus_Config2__LineStatus__c  == 'Renewed')){
                             netAmount = netAmount + oli.Apttus_Config2__NetPrice__c; }   
                         if(oli.Apttus_Config2__ProductId__r.ProductCode !='30010890'){
                             //Added by Sakshi for SOC-9615,starts
                             if(oli.Apttus_Config2__Quantity__c != 0){
                             orderLine.netAmount = oli.Apttus_Config2__NetPrice__c/oli.Apttus_Config2__Quantity__c;  
                             System.debug(LoggingLevel.WARN,'netAmount>>'+netAmount);
                             }
                             //SOC-9615 ends
                             orderLine.listAmount = oli.Apttus_Config2__ExtendedPrice__c;} 
                                else{
                             orderLine.netAmount = 0;                     
                             orderLine.listAmount = 0;                     
                              }            
                         //adjustment
                         CreateOrderRequest.adjustments adjustment= new CreateOrderRequest.adjustments();
                         if(oli.Apttus_Config2__AdjustmentType__c=='% Discount'&&oli.Apttus_Config2__LineStatus__c != 'Renewed') {
                            adjustment.type = 'PERCENT';
                            adjustment.amount = oli.Apttus_Config2__AdjustmentAmount__c != null ? (oli.Apttus_Config2__AdjustmentAmount__c).setScale(9)
                                                : oli.Apttus_Config2__AdjustmentAmount__c; // DOC-5742
                            adjamount = adjustment.amount;
                            adjustment.promotionCode=oli.Apttus_Config2__IncentiveCode__c;
                         } 
                         
                         //Start: DOC-8939 - send '% Markup' and relavent details to ESI / SAP
                         else if (oli.Apttus_Config2__AdjustmentType__c == '% Markup' 
                             && oli.Apttus_Config2__LineStatus__c != 'Renewed') {
                              adjustment.type='FIXED_MARKUP';
                              adjustment.discountType='NormalSurcharge';
                              adjustment.amount= oli.Apttus_Config2__AdjustedPrice__c != null ? ((oli.Apttus_Config2__AdjustedPrice__c - oli.Apttus_Config2__ExtendedPrice__c)).setScale(2)
                                                 : 0;
                         }//End DOC-8939
                         
                         orderLine.adjustments.add(adjustment);
                         if(oli.Apttus_Config2__LineStatus__c == 'Renewed'){                         
                            revewalValue = revewalValue + oli.Apttus_Config2__NetPrice__c;
                            //skg added contract infor
                            orderline.subscriptionDetail.contractLineNumber=string.valueof(oli.APTS_Contract_Line_Number__c);
                            orderline.subscriptionDetail.contractNumber=String.valueOf(oli.APTS_Contract_Number__c);   
                            orderLine.netAmount= 0.0; 
                            orderLine.RevType= 'R';  
                            orderLine.itemCategory='ZRNW';
                            //Date date1= Date.Today();
                           // Date date2= oli.APTS_Contract_End_Date__c;
                             // Commented by Gokila for SOC-7447
                           /* if(date1 < date2 ){
                             orderLine.AdjRnwlStDate = oli.APTS_Contract_End_Date__c;
                             // JIRA SOC-5886
                             orderLine.subscriptionDetail.contractStartDate = oli.APTS_Contract_End_Date__c;
                            }
                            else if(date1 > date2){
                             orderLine.AdjRnwlStDate = system.today().addMonths(1).toStartofMonth();
                             // JIRA SOC-5886
                             orderLine.subscriptionDetail.contractStartDate = system.today().addMonths(1).toStartofMonth();
                            }
                           // orderLine.AdjRnwlStDate = oli.APTS_Contract_End_Date__c;*/
                            orderLine.listAmount = 0;   
      
                            //SOC-9837 starts
                            if(order.Apttus_QPConfig__ProposalId__r.APTS_Align_Contract_End_Dates__c == true){
                                if(oli.Apttus_Config2__LineStatus__c == 'Renewed'){
                                    if(oli.APTS_Contract_End_Date__c != farthestEndDate){
                                        orderLine.subscriptionDetail.contractStartDate = oli.Apttus_Config2__StartDate__c;
                                        orderLine.subscriptionDetail.contractEndDate = finalfarthestEndDate;
                                    }
                                }
                            }
                            //SOC-9837 ends
                         }
                      // skg
                      //SOC-9204 starts, added by Sakshi
                        if(oli.Apttus_Config2__LineStatus__c == 'Renewed' && oli.Apttus_Config2__ProductId__r.ProductCode == '40656701'){
                            orderTerms(oli.APTS_Contract_Term__c, 0.0, 0.0,oli.Apttus_QPConfig__ProposalLineItemId__r.APTS_Net_Price_display__c, oli.Apttus_Config2__LineStatus__c);
                        }
                    //SOC-9204 ends
                        if(oli.Apttus_Config2__LineStatus__c == 'New' && oli.Apttus_Config2__ProductId__r.ProductCode !='30010890'){
                         orderTerms(oli.APTS_Contract_Term__c, oli.Base_Value__c,oli.APTS_Years_2_3_Charges_Disc_Surc__c,oli.Apttus_QPConfig__ProposalLineItemId__r.APTS_Net_Price_display__c,oli.Apttus_Config2__LineStatus__c);
                        }
                        if(oli.Apttus_Config2__LineStatus__c == 'Renewed' && flcodeMap!=null && flcodeMap.get('PPC MANAGEMENT')!=null && 
                         !flcodeMap.get('PPC MANAGEMENT').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c) && oli.Apttus_Config2__ProductId__r.ProductCode != '40656701'){ Double unitPrice = 0;
                          //SOC-10076
                          if(oli.Apttus_Config2__Quantity__c != 0){
                            unitPrice = oli.Apttus_QPConfig__ProposalLineItemId__r.APTS_Net_Price_display__c/oli.Apttus_Config2__Quantity__c;
                          }
                          orderTerms(oli.APTS_Contract_Term__c, oli.Base_Value__c, oli.APTS_FL_Price_Increase_Percentage__c, unitPrice, oli.Apttus_Config2__LineStatus__c);
                        }
              }
                     //skg added && oli.Apttus_Config2__LineStatus__c != 'Renewed'
                     if(oli.Apttus_Config2__LineType__c == 'Option' &&oli.Apttus_Config2__LineStatus__c != 'Renewed') {
                         system.debug(LoggingLevel.WARN,'@@@@@oli'+oli);
                         orderLine.material.materialId = oli.Apttus_Config2__OptionId__r.ProductCode;
                         orderLine.material.locationCode = oli.Apttus_Config2__OptionId__r.APTS_Location_Code__c;
                         orderLine.material.practiceArea = oli.Apttus_Config2__OptionId__r.APTS_Practice_Area_Code__c;                     
                         orderLine.relatedLine = string.valueof(rlNumber);  //SV 0807 Need realted line for FL.ESI will block for SAP
                         //Assign OrderDeal info of Secondary Line item
                         //Added national ad pkg for SOC-9204 by Sakshi on 11/21/2018 FEB Release
                         System.debug('######123->'+lineNumber);
                         System.debug('######123->'+oDeal);
                         if(!Test.isRunningTest()){
                            oDeal.lineItems.add(assignDealLines('SEC', lineNumber));   
                         }
                            if(flcodeMap!=null && flcodeMap.get('FL NATIONAL AD PACKAGES')!=null && flcodeMap.get('FL NATIONAL AD PACKAGES').contains(oli.Apttus_Config2__ProductId__r.PRODUCTCODE)){
                                orderLine.material.locationCode = oli.APTS_Combination_Key__r.APTS_Attribute_Value1__r.APTS_SAP_Attribute_Code__c;                
                                orderLine.material.practiceArea = oli.APTS_Combination_Key__r.APTS_Attribute_Value3__r.APTS_SAP_Attribute_Code__c;
                                orderLine.programId = 'CS03';
                                orderLine.itemCategory='ZSBY'; 
                             }
      
                         if(flcodeMap!=null && (flcodeMap!=null && flcodeMap.get('CONVERSION SOLUTIONS')!=null && 
                         flcodeMap.get('CONVERSION SOLUTIONS').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c)) || 
                         (flcodeMap!=null && flcodeMap.get('INTEGRATED MARKETING SOLUTIONS')!=null  && 
                         flcodeMap.get('INTEGRATED MARKETING SOLUTIONS').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c))||
                             (flcodeMap!=null && flcodeMap.get('RETURNS RESERVE L4')!=null  &&
                               flcodeMap.get('RETURNS RESERVE L4').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c))|| 
                             (flcodeMap!=null && flcodeMap.get('VISIBILITY')!=null  && 
                             flcodeMap.get('VISIBILITY').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c)) || 
                             (flcodeMap!=null && flcodeMap.get('WEBSITES')!=null  && 
                              flcodeMap.get('WEBSITES').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c))) {
                             orderLine.programId = 'CS02';
                             orderLine.itemCategory='ZSBY';                         
                         }     
                         //oDeal.programId = 'CS02';
                         if(flcodeMap!=null && flcodeMap.get('PPC MANAGEMENT')!=null &&  flcodeMAP.get('PPC MANAGEMENT').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c)){
                            orderLine.netAmount = oli.Apttus_Config2__NetPrice__c;                     
                            orderLine.listAmount = oli.Apttus_Config2__ExtendedPrice__c;
                            // skg remove if(oli.APTS_Contract_Term__c != '1 Year' || oli.APTS_Contract_Term__c != '2 Years' ||  oli.APTS_Contract_Term__c != '3 Years' ){           
                            if(oli.APTS_Contract_Term__c=='N/a'){
                                    orderLine.billPlanUpdateRule='0';
                                    }
                                else if(oli.APTS_Contract_Term__c=='1 Month'){
                                    orderLine.billPlanUpdateRule='1';
                                    }
                                else if(oli.APTS_Contract_Term__c=='2 Months'){
                                    orderLine.billPlanUpdateRule='2';
                                    }
                                else if(oli.APTS_Contract_Term__c=='3 Months'){
                                    orderLine.billPlanUpdateRule='3';
                                    }
                                else if(oli.APTS_Contract_Term__c=='4 Months'){
                                    orderLine.billPlanUpdateRule='4';
                                    }
                                else if(oli.APTS_Contract_Term__c=='5 Months'){
                                    orderLine.billPlanUpdateRule='5';
                                    }
                                else if(oli.APTS_Contract_Term__c=='6 Months'){
                                    orderLine.billPlanUpdateRule='6';
                                    }
                                else if(oli.APTS_Contract_Term__c=='7 Months'){
                                    orderLine.billPlanUpdateRule='7';
                                    }
                                else if(oli.APTS_Contract_Term__c=='8 Months'){
                                    orderLine.billPlanUpdateRule='8';
                                    }
                                else if(oli.APTS_Contract_Term__c=='9 Months'){
                                    orderLine.billPlanUpdateRule='9';
                                    }
                                else if(oli.APTS_Contract_Term__c=='10 Months'){
                                    orderLine.billPlanUpdateRule='10';
                                    }
                                else if(oli.APTS_Contract_Term__c=='11 Months'){
                                    orderLine.billPlanUpdateRule='11';
                                    }
                             // skg remove }****
                         }else {
                            orderLine.netAmount = 0;
                            orderLine.listAmount = 0; 
                         }
                        // oDeal.lineItems.add(assignDealLines('SEC', lineNumber));
                     }
      
      
      
                     
                     // SOC-6366
                    If(oli.Apttus_Config2__LineType__c == 'Option'){
                     if(flcodeMap!=null && flcodeMap.get('PPC MANAGEMENT')!=null && 
                     flcodeMap.get('PPC MANAGEMENT').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c) 
                     && oli.Apttus_Config2__LineStatus__c == 'Renewed'){                         
                            revewalValue = revewalValue + oli.Apttus_Config2__NetPrice__c;
                            orderLine.material.materialId = oli.Apttus_Config2__OptionId__r.ProductCode;
                            orderline.subscriptionDetail.contractLineNumber=string.valueof(oli.APTS_Contract_Line_Number__c);
                            orderline.subscriptionDetail.contractNumber=String.valueOf(oli.APTS_Contract_Number__c);   
                            orderLine.netAmount= 0.0; 
                            orderLine.RevType= 'R';  
                            orderLine.itemCategory='ZRNW';
                            //Date date1= Date.Today();
                           // Date date2= oli.APTS_Contract_End_Date__c;
                            //Commented by Gokila for SOC-7447
                           /*if(date1 < date2 ){
                             orderLine.AdjRnwlStDate = oli.APTS_Contract_End_Date__c;
                             // JIRA SOC-5886
                             orderLine.subscriptionDetail.contractStartDate = oli.APTS_Contract_End_Date__c;
                            }
                            else if(date1 > date2){
                             orderLine.AdjRnwlStDate = system.today().addMonths(1).toStartofMonth();
                             // JIRA SOC-5886
                             orderLine.subscriptionDetail.contractStartDate = system.today().addMonths(1).toStartofMonth();
                            }*/
                            orderLine.listAmount = 0;      
                        }
                        system.debug(LoggingLevel.WARN,'@@@@@Enter in the option condition');
                    }
                     
                    if ((flcodeMap!=null && flcodeMap.get('PPC MANAGEMENT')!=null &&
                     flcodeMap.get('PPC MANAGEMENT').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c) && 
                     oli.Apttus_Config2__LineStatus__c == 'Renewed' && oli.Apttus_Config2__ProductId__r.ProductCode !='30010890' )  ||
                    (flcodeMap!=null && flcodeMap.get('PPC MANAGEMENT')!=null && 
                    flcodeMap.get('PPC MANAGEMENT').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c) && oli.Apttus_Config2__LineStatus__c == 'Renewed' && oli.Apttus_Config2__LineType__c == 'Option' ) || 
                    (flcodeMap!=null && flcodeMap.get('PPC MANAGEMENT')!=null && 
                    flcodeMap.get('PPC MANAGEMENT').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c) && 
                    oli.Apttus_Config2__LineStatus__c == 'New' && oli.Apttus_Config2__LineType__c == 'Option' ))
                    {
                    orderTerms(oli.APTS_Contract_Term__c, oli.Base_Value__c, oli.APTS_FL_Price_Increase_Percentage__c,oli.Apttus_QPConfig__ProposalLineItemId__r.APTS_FL_Current_Renewal_User_Rate__c,oli.Apttus_Config2__LineStatus__c);
                    }           
                     orderLine.quantity = oli.Apttus_Config2__Quantity__c != null ? oli.Apttus_Config2__Quantity__c.setscale(3) : null;
                     orderLine.lineNumber= string.valueof(lineNumber);                 
                     orderReq.CreateOrderRequest.OrderHeader.renewalValue = String.valueOf(revewalValue);   
                     orderReq.CreateOrderRequest.OrderHeader.netAnnualAmount = netAmount;
                     //skg added && oli.Apttus_Config2__LineStatus__c != 'Renewed'  t   his was added for the renewed because we can't add the orderline then.
                     if((oli.Apttus_Config2__LineType__c == 'Option'&& oli.Apttus_Config2__LineStatus__c != 'Renewed')||
                        (oli.Apttus_Config2__LineType__c == 'Option'&& oli.Apttus_Config2__LineStatus__c == 'Renewed' && 
                        flcodeMap!=null && flcodeMap.get('PPC MANAGEMENT')!=null && 
                        flcodeMap.get('PPC MANAGEMENT').contains(oli.Apttus_Config2__ProductId__r.APTS_CAT_L5__c))){   //SOC-6366 -added by gayatri- 23/01/2018                  
                            orderReq.CreateOrderRequest.orderLines.add(orderLine);
                     }
                     else if(oli.Apttus_Config2__LineType__c == 'Product/Service') {
                         if((oli.Apttus_Config2__ProductId__r.ProductCode !='30010890' && oli.Apttus_Config2__LineStatus__c=='Renewed')||oli.Apttus_Config2__LineStatus__c=='New'){ //SOC-6366 -added by gayatri- 22/01/2018
                            orderReq.CreateOrderRequest.orderLines.add(orderLine);
                          }
                     }          
                 } 
                 
                 //LAPSE ORDER Added by Sakshi for SOC-4552 on 3/23/2018
                   
                    if(oli.Apttus_Config2__LineStatus__c=='Cancelled'){
                        CreateOrderRequest.orderLapseLines laps = new CreateOrderRequest.orderLapseLines();
                        laps.materialId=oli.Apttus_Config2__ProductId__r.ProductCode;
                        laps.contractNumber=string.valueOf(oli.APTS_Contract_Number__c);
                        laps.dealType=oli.APTS_Deal_Type__c ;
                        laps.contractLineNumber= string.valueOf(oli.APTS_Contract_Line_Number__c);
                        //laps.description=lapse.Apttus_Config2__Description__c;
                        laps.reasonCode='OL';
                        laps.dealNumber=string.valueOf(oli.APTS_Deal_Number__c);                    
                        //laps.lapseDate=oli.Apttus_Config2__EndDate__c;commented as part of SOC-8407
                        laps.lapseCode='OL';//changed code to 'OL' as part of SOC-8407 by Keerthana
                        laps.lapseQuantity=string.valueOf(oli.Apttus_Config2__Quantity__c.setscale(0));
                        //system.debug('laps...'+laps);
                        orderReq.CreateOrderRequest.orderLapseLines.add(laps);             
                    }
             }
            
             // Method to make a callout to ESI
             system.debug(LoggingLevel.WARN,'@@@@@orderReq'+orderReq);
             String strBody = JSON.serialize(orderReq);
             if(runOldOrderProcess){
                HTTPResponse response = new HTTPResponse();
                response = OrderSubmissionCalloutUtil.sendRequest(orderReq, 'Quote/Proposal ESI call SFDC Error', 'Quote/Proposal', 'OrdersubmissionESI', 'POST', 'application/json', orderId,order.Retry_Count__c); 
                OrderSubmissionCalloutUtil.sendEmailtoQuoteOwner(response, order.Apttus_QPConfig__ProposalId__r.Name, proposalOwner.Email, 'Order Not got processed Sucessfully for the order:', 'Order Failed', 'Quote/Proposal ESI Call Failed', 'Quote/Proposal', OrderId,order.Retry_Count__c);                        
                system.debug(LoggingLevel.WARN,'response...'+response);
                    if(response.getStatusCode()==200){ 
                        APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process : Quote/Proposal ESI success : '+response.getStatusCode()+' : '+response.getbody()},order.Id,order.Retry_Count__c);
                        //loggerId = IntegrationLogger.OCAddMessage('Old Order Process','', 'Order', '', 'Outbound','OrderSubmission',false,orderId);
                        //ordersubwrap.loggerrecordId = loggerId;
                        ordersubwrap.isSuccess = true;
                        ordersubwrap.applicationId = '';
                        ordersubwrap.companyId = '';
                        return ordersubwrap;
                    }
                    else{
                        APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process : Quote/Proposal ESI Call Failed : '+response.getStatusCode()+' : '+response.getbody()},order.Id,order.Retry_Count__c);
                        //loggerId = IntegrationLogger.OCAddMessage('Old Order Process','', 'Order', '', 'Outbound','OrderSubmission',false,orderId);
                        //ordersubwrap.loggerrecordId = loggerId;
                        ordersubwrap.isSuccess = false;
                        ordersubwrap.applicationId = '';
                        ordersubwrap.companyId = '';
                        return ordersubwrap;
                }
             }else{
                /*if(Schema.sObjectType.Integration_Logger__c.isAccessible()){       
                    intLogList=[Select Id from Integration_Logger__c where Order__c =: orderId];
                }
                if(intLogList!=null && intLogList.size()==1){
                    IntegrationLogger.TaxupdateMessage(intLogList[0].Id, true,'',strBody);
                    loggerId = intLogList[0].Id;
                }else{
                    loggerId = IntegrationLogger.OCAddMessage('','', 'Order', strBody, 'Outbound','OrderSubmission',true,orderId);         
                }
                ordersubwrap.orderId = orderId;
                ordersubwrap.orderNo = orderReq.CreateOrderRequest.OrderHeader.originatingOrderNumber;
                ordersubwrap.applicationId = orderReq.CreateOrderRequest.ESIHeader.applicationId;
                ordersubwrap.isSuccess = true;
                ordersubwrap.loggerrecordId = loggerId;*/
                APTS_OrderSubmissionUtilityExt4.createLoggerforPE(orderId, orderReq, ordersubwrap);
                return ordersubwrap;
             }
       } catch(Exception ex){    
                System.debug(LoggingLevel.WARN,'Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
                 System.debug(LoggingLevel.WARN,'Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
                //logException(ex.getMessage(),'Quote/Proposal ESI Call Failed', 'Quote/Proposal', False, OrderId);  
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
                ordersubwrap.isSuccess = false;
                ordersubwrap.loggerrecordId = loggerId;*/
                APTS_OrderSubmissionUtilityExt4.handleException(orderId, ex, ordersubwrap);
                return ordersubwrap;
            }
       
        }
        
        
        //assign the Deal Linte Item Values 
         /**
           * @description assignDealLines
           * @param recType
           * @param lNo
           * @return CreateOrderRequest.lineItems
           */
         public static  CreateOrderRequest.lineItems  assignDealLines(string recType, integer lNo) {
             System.debug('######123->'+recType);
             System.debug('######123->'+lNo);
             CreateOrderRequest.lineItems ln = new CreateOrderRequest.lineItems();         
             ln.recordType = recType;
             ln.lineNumber = string.valueof(lNo);
             System.debug('######123->'+ln);
             return ln;
         }
        
      
        /*=================================================================================
        Method to set MYR Terms details
        ===================================================================================*/
          /**
           * @description orderTermsUtil
           * @param contractTerm
           * @param baseValue
           * @param adjustment
           * @param  isRenewel
           * @param period
           * @param userRate
           */
       public static void orderTermsUtil(string contractTerm, Decimal baseValue, Decimal adjustment,Boolean isRenewel, Integer period, Decimal userRate) {
            //integer count = null;
            for(Integer i=1; i <= period; i++) {
                if(i == 1 && isRenewel) {                   
                   orderLine.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,0.0,userRate));
                }
                else if(i != 1 && isRenewel){
                    orderLine.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),0.0,0.0,userRate));
                }   
                // If it is not renewel and First term then send Adjustment as 0
                else if(i == 1 && !isRenewel) {
                  orderLine.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),0.0,baseValue,0.0));
                                             System.debug(LoggingLevel.WARN,'contractTerm'+contractTerm); 
                            System.debug(LoggingLevel.WARN,'string.ValueOf(i)'+string.ValueOf(i)); 
                            System.debug(LoggingLevel.WARN,'baseValue'+baseValue); 
                }
                else if(i == 2 && !isRenewel && adjustment < 0.0){
                     orderLine.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,baseValue,0.0));
                }   
                else if(i == 3 && !isRenewel){
                     orderLine.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),0.0,baseValue,0.0));
                }           
               else {
                     orderLine.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),0.0,baseValue,0.0));
               }
            }
            if(period==0){
            orderLine.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(period),adjustment,baseValue,userRate));}
        }      
         
         /*=================================================================================
        Method to set MYR Terms details for renewals
        ===================================================================================*/
        /**
           * @description orderTerms
           * @param contractTerm
           * @param baseValue
           * @param adjustment
           * @param userRate
           * @param status
           */
       public static void orderTerms(string contractTerm, Decimal baseValue, Decimal adjustment,Decimal userRate, string status) {
            //Contract Term =1
            if(string.valueof(contractTerm)=='1 Year')
            {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
                if(status=='Renewed'){            
                orderTermsUtil('1',baseValue,adjustment,true,1,userRate);
                }
                else{
                orderTermsUtil('1',baseValue,adjustment,false,1,userRate);
                }
            }
            //Contract Term =2  
            if(string.valueof(contractTerm)=='2 Years')
            {  // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
               if(status=='Renewed'){            
                orderTermsUtil('2',baseValue,adjustment,true,2,userRate);
                }
                else{
                orderTermsUtil('2',baseValue,adjustment,false,2,userRate);
                }
            }
            //Contract Term =3
            if(string.valueof(contractTerm)=='3 Years')
            {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
               if(status=='Renewed'){            
                orderTermsUtil('3',baseValue,adjustment,true,3,userRate);
                }
                else{
                orderTermsUtil('3',baseValue,adjustment,false,3,userRate);
                }
            }
            //Contract Term =4
            if(string.valueof(contractTerm)=='4 Years')
            {  // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
                if(status=='Renewed'){            
                orderTermsUtil('4',baseValue,adjustment,true,4,userRate);
                }
                else{
                orderTermsUtil('4',baseValue,adjustment,false,4,userRate);
                }
            }
            //Contract Term =5
            if(string.valueof(contractTerm)=='5 Years')
            {  
                // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
                if(status=='Renewed'){            
                orderTermsUtil('5',baseValue,adjustment,true,5,userRate);
                }
                else{
                orderTermsUtil('5',baseValue,adjustment,false,5,userRate);
                }
            }
            //Contract Term =10
            /* Commented as part of DOC-12762
            if(string.valueof(contractTerm)=='10 Years')
            {
                // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
                if(status=='Renewed'){            
                orderTermsUtil('10',baseValue,adjustment,true,10,userRate);
                }
                else{
                orderTermsUtil('10',baseValue,adjustment,false,10,userRate);
                }
            }*/
            //SOC-7868 starts,added by Keerthana
          //if(adjustment>=100){
            if(adjamount>=100){ 
              if(string.valueof(contractTerm)=='1 Month' || string.valueof(contractTerm)=='2 Months' || string.valueof(contractTerm)=='3 Months' || string.valueof(contractTerm)=='4 Months'
               || string.valueof(contractTerm)=='5 Months'  || string.valueof(contractTerm)=='6 Months' || string.valueof(contractTerm)=='7 Months' || string.valueof(contractTerm)=='8 Months'
                || string.valueof(contractTerm)=='9 Months' || string.valueof(contractTerm)=='10 Months' || string.valueof(contractTerm)=='11 Months'){
                     orderTermsUtil('0',baseValue,adjustment,false,0,userRate);
                     adjamount=0;
                }
                adjamount=0;
            }
            //SOC-7868 ends
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
           * @return CreateOrderRequest.terms
           */
           public static  CreateOrderRequest.terms termUtil(string tLen, string period, Decimal percInc, Decimal bValue, Decimal uRate) {
                                   System.debug(LoggingLevel.WARN,'tLen'+tLen); 
      
                CreateOrderRequest.terms term = new CreateOrderRequest.terms();
                term.termLength= tLen;
                term.period= period;
                term.percentIncrease= String.valueOf(percInc);
                term.baseValue= bValue;
                term.userRate= uRate;
                return term;
            }
            
        //method to assign the Address field values to the Order address
        /**
           * @description assignAddessValues
           * @param partnerType
           * @param shipping
           * @param sapNumber
           * @param name
           * @param nameTwo
           * @param nameThree
           * @param st1
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
           * @return CreateOrderRequest.orderAddress
           */
        public static CreateOrderRequest.orderAddress assignAddessValues(string partnerType, string shipping, string sapNumber, string name, string nameTwo, string nameThree, string st1, string st2, string st3, string st4, string city, string state, string country, string postalCode, string phone, string fax, string poBox) {
            CreateOrderRequest.orderAddress ordaddress = new CreateOrderRequest.orderAddress();
            ordaddress.partnerType = partnerType;
            if(!string.isEmpty(shipping)){
                ordaddress.shippingMethod = Shipping_Method__c.getInstance(shipping).Value__c;
            ordaddress.account.accountNumber = sapNumber;
            ordaddress.name1 = name;
            ordaddress.name2 = nameTwo;
            ordaddress.name3 = nameThree;
            ordaddress.street1 = st1;
            ordaddress.street2 = st2;
            ordaddress.street3 = st3;
            ordaddress.street4 = st4;
            ordaddress.city = city;         
            ordaddress.region = state;
            ordaddress.country = country;
            ordaddress.postal = postalCode;
            ordaddress.phone = phone;
            ordaddress.fax = fax;
            ordaddress.poBox = poBox;
            }
            return ordaddress;
        } 
       
      }