/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-04-18   Shiva Sri Arun        DLT-8515 - [NEW CUSTOMER - Buy Plan SL] Create Proposal and Cart
 * 2019-03-26   Ramesh Reddy          DLT-14561 - Tech Story[NSE SL/CP] Replace Promotion Codes to APPTUS
 * 2019-04-20   Ramesh Reddy          DLT-16233 - Tech Story[NSE SL/CP] Replace Promotion Codes to APPTUS and should support user friendly codes
 * ==================================================================================================================================   
 */
public with sharing class Ecom_Cart
{   
    
    public static Apttus_Config2__ProductConfiguration__c createCart(List<Apttus_Proposal__Proposal__c> lstProposal, Ecom_OrderRequest.cls_storeOrder storeOrder, List<APTSECOM_Store__c> stores)
    {
     
        String store = storeOrder.storeName;
        String planId = storeOrder.planId;
        String planName = storeOrder.plan;
        if(lstProposal == null || lstProposal.isEmpty()) 
        {
            return null;
        }                               

        List<Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO> priceresList = new List<Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO>();
        List<Apttus_Config2__ProductConfiguration__c> cartList = new List<Apttus_Config2__ProductConfiguration__c>();
        List<Digital_Exception_Log__c> exList = new List<Digital_Exception_Log__c>();
        List<Id> successCartList = new List<Id>();
        Map<Id,Id> AccCartMap = new Map<Id,Id>();
        Map<Id,Id> QuoteCartMap = new Map<Id,Id>();
        Map<Id,list<Apttus_CPQApi.CPQ.SelectedProductDO>> AccPrdListMap = new Map<Id,list<Apttus_CPQApi.CPQ.SelectedProductDO>>(); 
        Map<Id,list<Apttus_CPQApi.CPQ.AssetActionDO>> AccAssetListMap = new Map<Id,list<Apttus_CPQApi.CPQ.AssetActionDO>>(); 
        Map<Id,Id> quoteSoldToAccMap = new Map<Id,Id>();
        Map<Id,set<String>> accCancelProductsMap = new Map<Id,set<String>>();
        String DigitalContractTerm = System.label.Digital_Contract_Term.trim();    
        Map<Id,Apttus_Config2__PriceListItem__c> priceListMap = new Map<Id,Apttus_Config2__PriceListItem__c>();
        Map<Id,Apttus_Config2__PriceMatrixEntry__c> priceListEntryMap = new Map<Id,Apttus_Config2__PriceMatrixEntry__c>();
        Map<Id,Product_Account_Detail__c> bestValueProductMap = new Map<Id,Product_Account_Detail__c>();
        Map<Id,String> campOptyMap = new Map<Id, String>();        
        Map<Integer, DC_Contract_Term_V2__mdt> contract_TermMap = new Map<Integer, DC_Contract_Term_V2__mdt>();
        Map<Integer, DC_Contract_Term_V2__mdt> tempContract_TermMap = new Map<Integer, DC_Contract_Term_V2__mdt>();
        DC_Contract_Term_V2__mdt defaultContractTermSetting;
        List<String> customFields = new List<String>{'APTS_Contract_Term__c', 
                                                     'Apttus_Config2__SellingTerm__c','Apttus_Config2__Comments__c', 'Apttus_Config2__BillingFrequency__c',
                                                     'Apttus_Config2__SellingFrequency__c','Apttus_Config2__PriceType__c','Apttus_Config2__Frequency__c',
                                                     'Apttus_Config2__PriceListItemId__c','Apttus_Config2__ChargeType__c','Apttus_Config2__PriceUom__c',
                                                     'Apttus_Config2__PriceMethod__c','Apttus_Config2__AdjustmentType__c','Apttus_Config2__AdjustmentAmount__c'};
       
       
        Map<Id,Apttus_Proposal__Proposal__c> proposalMap = new Map<Id, Apttus_Proposal__Proposal__c>(); 
        for(Apttus_Proposal__Proposal__c  proposal : [SELECT Id,APTS_SSD_ship_to__c, APTS_SSD_bill_to__c,Apttus_Proposal__Account__c,Digital_Quote_Failure_Reason__c,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Opportunity__r.Name 
                                                        FROM Apttus_Proposal__Proposal__c WHERE Id IN : lstProposal])
        {
            if(String.isEmpty(proposal.Apttus_Proposal__Account__c)) continue;
            quoteSoldToAccMap.put(proposal.Id, proposal.Apttus_Proposal__Account__c);   
          
        }
        
        for(Apttus_Proposal__Proposal__c  proposal : lstProposal)
        {
            cartList.add(new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposal.Id,
                                                                     Apttus_Config2__BusinessObjectType__c = 'Proposal',
                                                                     Apttus_Config2__BusinessObjectRefId__c = proposal.Id,
                                                                     Apttus_Config2__SummaryGroupType__c= 'Ad Hoc',
                                                                     Apttus_Config2__PriceListId__c = stores[0].APTSECOM_Price_List__c,
                                                                     Apttus_Config2__BillToAccountId__c = quoteSoldToAccMap.get(proposal.Id),
                                                                     Apttus_Config2__AccountId__c = quoteSoldToAccMap.get(proposal.Id),
                                                                     Apttus_Config2__ShipToAccountId__c = quoteSoldToAccMap.get(proposal.Id),
                                                                     OwnerID = proposal.OwnerId,
                                                                     CreatedById = proposal.OwnerId,
                                                                     Apttus_Config2__EffectivePriceListId__c = stores[0].APTSECOM_Price_List__c,
                                                                     Apttus_Config2__VersionNumber__c = 1,
                                                                     Apttus_Config2__Status__c = 'Finalized',
                                                                     APTS_SSD_ship_to__c=  proposal.APTS_SSD_ship_to__c,
                                                                     APTS_SSD_bill_to__c= proposal.APTS_SSD_bill_to__c ,                                                                     
                                                                     Apttus_Config2__IsPricePending__c = TRUE,
                                                                     Apttus_CQApprov__Approval_Preview_Status__c = 'Complete',
                                                                     Digital_Pending_Cart__c = TRUE));
        }
        
        if(stores[0].Store_Promotions__r != null && stores[0].Store_Promotions__r.size() > 0 ) {
         	cartList[0].Apttus_Config2__CouponCodes__c = stores[0].Store_Promotions__r[0].IncentiveId__r.Apttus_Config2__IncentiveCode__c ;   
        }
            
        if(planName != null && System.Label.Ecom_PlanNames.contains(planName) && !cartList.isEmpty() )
        {
            cartList[0].Apttus_Config2__Status__c = 'New';
        }
        else
        {
            cartList[0].Apttus_Config2__FinalizedDate__c = DateTime.now();
        }
        Database.SaveResult[] lsr = Database.insert(cartList,false);
        for(Integer i = 0; i < lsr.size(); i++)
        {
            if(lsr.get(i).isSuccess())
            { 
                System.debug('============cardID========='+lsr.get(i).getId());
                successCartList.add(lsr.get(i).getId());
                AccCartMap.put(quoteSoldToAccMap.get(cartList.get(i).Apttus_QPConfig__Proposald__c),lsr.get(i).getId());
                QuoteCartMap.put(cartList.get(i).Apttus_QPConfig__Proposald__c, lsr.get(i).getId());
            }
            else if(!lsr.get(i).isSuccess())
            {
                Database.Error error = lsr.get(i).getErrors().get(0);
                String additionalInfo;
                for(string errorField : error.getfields())
                {
                    additionalInfo = errorField + ',';            
                }
                Digital_Exception_Log__c ex = createExceptionLog( error.getMessage(), 'Cart Creation - Quote Id - '+cartList.get(i).Apttus_QPConfig__Proposald__c, additionalInfo, String.Valueof(error.getStatusCode()), 'Ecom_Cart > CartCreation');
                exList.add(ex);
            }  
        }
        
        // get Aggregated adjustments
        Ecom_StoreResponse.Adjustments adjustments = Ecom_OrderService.getAggregatedAdjustments(stores[0]);
        //Add Products to cart    
        Ecom_OrderService.addMultipleProducts(cartList[0].id, storeOrder.selectedProducts, storeOrder.planID,stores[0], adjustments);
      
        if(exList != Null && exList.size() > 0){
            try{
                if (Schema.sObjectType.Digital_Exception_Log__c.isCreateable())
                insert exList;
            }
            Catch(Exception e){
                System.debug('Exception'+e);
            }  
        }
      
       return cartList[0]; 
    }
    
    
    private static Digital_Exception_Log__c createExceptionLog(String exMessage, String exType, String additionalInfo, String userMessage, String classRef) 
    {
        return new Digital_Exception_Log__c(Exception_Message__c = exMessage, Exception_Type__c = exType, Additional_Information__c = additionalInfo, 
                                            User_Message__c = userMessage, Class_Reference__c = classRef);
    }
    
}