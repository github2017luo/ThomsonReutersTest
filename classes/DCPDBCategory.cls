/********************************************************************************
Class Name : DCPDBCategory 
@description : This code is used in Validate CRUD Permissions
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                 Description
29-06-2021                      Dinesh            DCP-2214 | Initial Creation
23-07-2021                   Vishnu Santhosh      DCP-2870 | Added 'addWestProflexProducts' method
26-08-2021                   Sudhanshu Upadhayay    DCP-3943 | logic to have bundle products features in plan compare response
*********************************************************************************/ 

public without sharing class DCPDBCategory {
    /**
@description To update the getCBCats
@param opptyId contains the request for opportunitiesList
@param ssdId contains the request for opportunitiesList.
@return Returns the status planCompareResponse.
*/
    
    public static DCPPlanCompareResponse getCBCats(String opptyId, String ssdId ){
        DCPPlanCompareResponse planCompareResponse = new DCPPlanCompareResponse();
        //Fetching Proposals through Opportunity
        List<Opportunity> opportunitiesList = [SELECT Id, Name, (SELECT Id, Name, Digital_Quote_Type__c FROM R00N70000001yUfDEAU__r) FROM Opportunity WHERE Id =: opptyId and Source_System_Detail__c =: ssdId WITH SECURITY_ENFORCED LIMIT 1];
        
        Map<String, Apttus_Proposal__Proposal__c> proposalMap = new Map<String, Apttus_Proposal__Proposal__c>();
        for(Apttus_Proposal__Proposal__c proposal: opportunitiesList[0].R00N70000001yUfDEAU__r){
            proposalMap.put(proposal.Id, proposal);
        }
        
        
        
        //Fetching Configurations and it's LineItems using proposals 
        List<Apttus_Config2__ProductConfiguration__c> cartList = [SELECT Id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                                                                  (SELECT Id, Apttus_Config2__ProductId__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,
                                                                   Apttus_Config2__Quantity__c,
                                                                   APTS_Product_Name__c,Apttus_Config2__LineType__c,Apttus_Config2__OptionId__c,
                                                                   Apttus_Config2__AssetLineItemId__r.Apttus_QPConfig__ProposalId__c
                                                                   FROM Apttus_Config2__LineItems__r
                                                                   WHERE Apttus_Config2__LineStatus__c != 'Cancelled')
                                                                  FROM Apttus_Config2__ProductConfiguration__c
                                                                  WHERE Apttus_QPConfig__Proposald__c IN: opportunitiesList[0].R00N70000001yUfDEAU__r AND Apttus_Config2__Status__c ='Finalized'
                                                                  WITH SECURITY_ENFORCED];
        
        Map<String, List<String>> proposalProdMap = new Map<String, List<String>>();
        
        
        
        //Mapping Proposal Ids, Product Ids together
        if(cartList.size() > 0){
            for(Apttus_Config2__ProductConfiguration__c cart : cartList){
                cartofprop(cart,proposalProdMap);
                
            }
        }
        
        //Prod Ids to query on Digital Product Plans
        List<String> productIdList = new List<String>();
        for(List<String> prodIdList: proposalProdMap.values()){
            productIdList.addAll(prodIdList);
        }
        
        //Adding West Proflex associated Products to the product Id List and proposalProdMap-
        //when the proposal type is 'Straight Renewal' or 'Manual'
        addWestProflexProducts(cartList,productIdList,proposalProdMap);
        
        // Check for bundle product in given quotes/proposal and return of digital product plan(features) related to it
        // DCP-3493
        // Added By:Sudhanshu Upadhayay
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemsList= [Select Id,Apttus_Proposal__Proposal__c,APTS_Service_Number_Override__c,APTS_Subscription_Number_Override__c,Apttus_Proposal__Product__c,Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =: proposalProdMap.keySet() and Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c='Bundle' and APTS_Subscription_Number_Override__c != '' WITH SECURITY_ENFORCED];
        List<string> lstMaterialNumberList = new List<string>();
        Map<string,List<string>> proposalToBundleProductsMap = new Map<string,List<string>>();
        if(proposalLineItemsList.size()>0){
            // Map to hold Proposals and the respective material number list to query digital products plan/features
            proposalToBundleProductsMap=getProposalToBundleProductsMap(proposalLineItemsList);
            lstMaterialNumberList= getMaterialNumberFromBundleProductsMap(proposalToBundleProductsMap);
        }
         
        
        //Fetching digi prod plans using prod ids
        List<Digital_Product_Plans__c> digitalProdPlansList = [SELECT Id, Name, Product__c, Material_Number__c, Subscription_Number__c,
                                                               Material_Description__c, SLF_Help_Text__c, Additional_Help_Text__c, SLF_Jurisdiction__c,
                                                               DB_Category__c, DB_Category_Sort_Order__c, DB_Group__c, DB_Group_Sort_Order__c 
                                                               FROM Digital_Product_Plans__c WHERE Product__c IN: productIdList OR Material_Number__c IN :lstMaterialNumberList
                                                               WITH SECURITY_ENFORCED  order by CreatedDate ASC];
        
        if(digitalProdPlansList.size() > 0){
            DCPPlanCompareResponse.DCPObjects offerProdPlan = new DCPPlanCompareResponse.DCPObjects();            
            List<DCPPlanCompareResponse.DCPProductPlan> prodPlanList = new List<DCPPlanCompareResponse.DCPProductPlan>();
            
            //testing
            // integer countoflinesitems =[select count() from Digital_Product_Plans__c WHERE Product__c IN: productIdList
            //                                           WITH SECURITY_ENFORCED ];
            //test
            
            
            //Looping over Proposals
            for(String proposalId: proposalProdMap.keySet()){                        
                DCPPlanCompareResponse.DCPProductPlan prodPlan = new DCPPlanCompareResponse.DCPProductPlan();
                prodPlan.proposalId = proposalId;
                prodPlan.proposalType = proposalMap.get(proposalId).Digital_Quote_Type__c;
                List<DCPDBCategoryWrapper> dbCatList = new List<DCPDBCategoryWrapper>();
                DCPDBCategoryWrapper.DCPProductsByProposals dcpProductsByProposals = new DCPDBCategoryWrapper.DCPProductsByProposals();
                dcpProductsByProposals.proposalId =proposalId;
                dcpProductsByProposals.proposalToBundleProductsMap =proposalToBundleProductsMap;
                dbCatList = dblistdata(digitalProdPlansList,proposalProdMap,dcpProductsByProposals);
                prodPlan.featurecount =  dbCatList.size();
                prodPlan.dbCatData = dbCatList;
                prodPlanList.add(prodPlan);
                
            }
            offerProdPlan.offerProductPlan = prodPlanList;
            planCompareResponse.data = offerProdPlan;
        }
        return planCompareResponse;
    }
    /**
@description To update the getCBCats
@param cart cart contains the request for cartofprop
@param proposalProdMap contains the request for cartofprop.

*/
    public static void cartofprop(Apttus_Config2__ProductConfiguration__c cart,Map<String, List<String>> proposalProdMap){
        
        for(Apttus_Config2__LineItem__c lineItem: cart.Apttus_Config2__LineItems__r){
            if(proposalProdMap.containsKey(cart.Apttus_QPConfig__Proposald__c)){
                List<String> prodIds = (List<String>)proposalProdMap.get(cart.Apttus_QPConfig__Proposald__c);
                // adding product Id for option product in the product id list
                prodIds= getProductIds(lineItem,prodIds);
                proposalProdMap.put(cart.Apttus_QPConfig__Proposald__c, prodIds);
            }
            else{
                // adding product Id for option product in the product id list
                if(lineItem.Apttus_Config2__LineType__c=='Option'){
                    proposalProdMap.put(cart.Apttus_QPConfig__Proposald__c, new List<String>{lineItem.Apttus_Config2__OptionId__c});
                } else{
                    proposalProdMap.put(cart.Apttus_QPConfig__Proposald__c, new List<String>{lineItem.Apttus_Config2__ProductId__c});
                } 
                
                
            }
            
        }
    }
    /**
@description To update the getCBCats
@param digitalProdPlansList  contains the request for dblistdata
@param proposalProdMap contains the request for dblistdata
@param dcpProductsByProposals contains the proposal Id and its product Ids in wrapper class
@return  the dbcatlist data

*/
    // too many arguments liable to be mixed up
    public static List<DCPDBCategoryWrapper> dblistdata(list<Digital_Product_Plans__c> digitalProdPlansList,Map<String, List<String>> proposalProdMap,DCPDBCategoryWrapper.DCPProductsByProposals dcpProductsByProposals){
        string proposalId= dcpProductsByProposals.proposalId;
        Map<string, List<string>> proposalToBundleProductsMap = dcpProductsByProposals.proposalToBundleProductsMap;
        List<DCPDBCategoryWrapper> dbCatList = new List<DCPDBCategoryWrapper>();
        //Looping over Digital Product Plans 
        for(Digital_Product_Plans__c digiProdPlan: digitalProdPlansList){
            //Checking if the Product Id belongs to Proposal Id
            if(proposalProdMap.get(proposalId).contains(digiProdPlan.Product__c) || (proposalToBundleProductsMap.get(proposalId)!=null&& proposalToBundleProductsMap.get(proposalId).size()>0&&proposalToBundleProductsMap.get(proposalId).contains(digiProdPlan.Material_Number__c)) ){
                
                DCPDBCategoryWrapper dbCat = new DCPDBCategoryWrapper();
                dbCat.materialId = digiProdPlan.Id;
                dbCat.productPlanId = digiProdPlan.Product__c;
                dbCat.materialNumber = digiProdPlan.Material_Number__c;
                dbCat.subscriptionNumber = digiProdPlan.Subscription_Number__c;
                dbCat.materialDescription = digiProdPlan.Material_Description__c;
                dbCat.internalDescription = digiProdPlan.SLF_Help_Text__c;
                dbCat.additionalInternalDescription = digiProdPlan.Additional_Help_Text__c;
                dbCat.jurisdiction = digiProdPlan.SLF_Jurisdiction__c;
                dbCat.classificationValue = digiProdPlan.DB_Category__c;
                dbCat.classificationValueSortOrder = digiProdPlan.DB_Category_Sort_Order__c;
                dbCat.productGroup = digiProdPlan.DB_Group__c;
                dbCat.productGroupSortOrder = digiProdPlan.DB_Group_Sort_Order__c;
                dbCatList.add(dbCat);
                
                
            }
            
        }
        return dbCatList;           
    }
    
    
    /**
@description Add west proflex associated products to the productId list and proposalProdMap
@param cartList List of all carts(Product Configurations) from all the proposals
@param productIdList List of all product Id in all the line Items of all the carts 
@param proposalProdMap proposal to product map
*/
    private static void addWestProflexProducts(List<Apttus_Config2__ProductConfiguration__c> cartList,List<String> productIdList, Map<String,List<String>> proposalProdMap){
        
        List<DCPRenewalProductWrapper> westProflexProducts = new List<DCPRenewalProductWrapper>();
        List<String> westProflexProductIds = new List<String>();
        
        for(Apttus_Config2__ProductConfiguration__c cart :cartList){
            
            System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPDBCategory *** >> Digital Quote Type :  '+ cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c);
            
            if(     cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase('Straight Renewal')
               ||  cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c.equalsIgnoreCase('Manual')) {
                   
                   for(Apttus_Config2__LineItem__c lineItem : cart.Apttus_Config2__LineItems__r){
                       if(lineItem.APTS_Product_Name__c.equalsIgnoreCase('West Proflex')){
                           
                           westProflexProducts = DCPRenewalProduct.getWestProflexProducts(lineItem);
                           westProflexProductIds = getWestProflexIdList(westProflexProducts);
                           productIdList.addAll(westProflexProductIds);
                           List<String> prodIds = (List<String>)proposalProdMap.get(cart.Apttus_QPConfig__Proposald__c);
                           prodIds.addAll(westProflexProductIds);
                           proposalProdMap.put(cart.Apttus_QPConfig__Proposald__c, prodIds);
                           
                           System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPDBCategory *** >> West Proflex Product id  :  '+ lineItem.Apttus_Config2__ProductId__c);
                           System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPDBCategory *** >> West Proflex Associated Product Ids :  '+ westProflexProductIds);
                           System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPDBCategory *** >> Proposal Product Map  :  '+ proposalProdMap);
                       }
                   }
               }
        }
    }
    
    /**
@description Get West proflex -Associated Products - Ids List
@param westProflexProducts List of West Proflex Associated Products
@return Associated Products - Ids List
*/
    private static List<String> getWestProflexIdList(List<DCPRenewalProductWrapper> westProflexProducts){
        
        List<String> westProflexProductIds = new List<String>();
        
        for(DCPRenewalProductWrapper westProflexProduct : westProflexProducts){
            westProflexProductIds.add(westProflexProduct.productId);
        }
        
        return westProflexProductIds;
    }
    
    /**
@description To get the mapped bundle products with its proposals 
@param lstBundleProductsLineItems contains list of bundle products to get its bundle products map w.r.t proposal
@return proposalToBundleProdMap
*/
    public static Map<String, List<String>> getProposalToBundleProductsMap(List<Apttus_Proposal__Proposal_Line_Item__c> lstBundleProductsLineItems){
        
        Map<String, List<String>> proposalToBundleProdMap  = new Map<String, List<String>>();          
        for(Apttus_Proposal__Proposal_Line_Item__c item: lstBundleProductsLineItems){
            if(proposalToBundleProdMap.containsKey(item.Apttus_Proposal__Proposal__c)){
                List<String> prodIds = (List<String>)proposalToBundleProdMap.get(item.Apttus_Proposal__Proposal__c);
                prodIds.add(item.APTS_Service_Number_Override__c);
                proposalToBundleProdMap.put(item.Apttus_Proposal__Proposal__c, prodIds);
            }
            else{
                proposalToBundleProdMap.put(item.Apttus_Proposal__Proposal__c, new List<String>{item.APTS_Service_Number_Override__c});
                
            }}    return  proposalToBundleProdMap;
    }
    
    
    private static List<string>  getMaterialNumberFromBundleProductsMap(Map<string,List<string>> proposalToBundleProductsMap ){
        List<string> lstMaterialNumber = new List<string>();
        for(List<String> item: proposalToBundleProductsMap.values()){
            lstMaterialNumber.addAll(item);
        }
        return lstMaterialNumber;
    }
    private static List<string> getProductIds(Apttus_Config2__LineItem__c lineItem,List<string> lstProductIds){
        List<string> productIds = new List<string>();
        productIds = lstProductIds;
        if(lineItem.Apttus_Config2__LineType__c=='Option'){
            productIds.add(lineItem.Apttus_Config2__OptionId__c); 
        } else{
            productIds.add(lineItem.Apttus_Config2__ProductId__c);
        }
        return productIds;
    }
    
}