/********************************************************************************
Class Name : DCPRenewalProduct 
@description : This class is used by DCPRenewalProposal class to populate products JSON data. 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                          Developer                 Description
15-07-2021                  Vishnu Santhosh            DCP-2144 | Initial Creation
15-07-2021                  Vishnu Santhosh            DCP-2144 | Moved 'getProductDetails' method from DCPRenewalProposal Class to this class.
16-07-2021                  Vishnu Santhosh            DCP-2144 | Added 'getWestProflexProducts' method.
*********************************************************************************/ 
public without sharing class DCPRenewalProduct{
    /**
    @description Retrieves product details from the associated cart
    @param cart From which related products needs to be retrieved
    @param proposal To get the Straight Renewal Filter
    @return List of related Products from cart line items
    */
    public static List<DCPRenewalProductWrapper> getProductDetails(Apttus_Config2__ProductConfiguration__c cart, Apttus_Proposal__Proposal__c proposal) {
        
        List<DCPRenewalProductWrapper> productList = new List<DCPRenewalProductWrapper>();
        List<Apttus_Config2__LineItem__c> retrievedLineItems = new List<Apttus_Config2__LineItem__c>();
        Boolean isWestProflex=false;
        Apttus_Config2__LineItem__c westProflexLineItem;
        
        if(cart.APTS_Proposal_Business_Unit__c == 'FindLaw'){
            productList = DCPRenewalFindlaw.getFindlawProducts(cart.Id);
        }else{
            retrievedLineItems = DCPCart.getCartLineItems(cart.Id);
            
            for(Apttus_Config2__LineItem__c lineItem : retrievedLineItems){
            
                //Check for Straight Renewal Type - West Profle Product
                if(lineItem.APTS_Product_Name__c.equalsIgnoreCase('West Proflex')
                    &&  proposal.Digital_Quote_Type__c.equalsIgnoreCase('Straight Renewal')){
                            isWestProflex = true;
                            westProflexLineItem = lineItem;
                }
                                
                DCPRenewalProductWrapper product = populateProductDetails(lineItem);
                productList.add(product);
            }
            
            if(isWestProflex){
                productList.addAll(getWestProflexProducts(westProflexLineItem));
            }
        }
        
        return productList;
    }

    /**
    @description Retrieving products assoiciated with West Proflex
    @param westProflexLineItem Cart Line item having the West Proflex Product.
    @return List of West proflex product and associated products.
    */
    public static List<DCPRenewalProductWrapper> getWestProflexProducts(Apttus_Config2__LineItem__c westProflexLineItem) {
         
        List<DCPRenewalProductWrapper> westProflexProductsList = new List<DCPRenewalProductWrapper>();
        List<Apttus_Proposal__Proposal_Line_Item__c> retrievedProposalLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        List<Id> requiredProposalId = new List<Id>();

        requiredProposalId.add(westProflexLineItem.Apttus_Config2__AssetLineItemId__r.Apttus_QPConfig__ProposalId__c);
        retrievedProposalLineItems = DCPProposal.getProposalLineItems(requiredProposalId[0]);
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >>  requiredProposalId :  '+ requiredProposalId);
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >>  retrievedProposalLineItems :  '+ retrievedProposalLineItems);

        for(Apttus_Proposal__Proposal_Line_Item__c lineItem : retrievedProposalLineItems){

            DCPRenewalProductWrapper product = new DCPRenewalProductWrapper();
            product.productName = lineItem.Apttus_Proposal__Product__r.Name;
            product.productId=lineItem.Apttus_Proposal__Product__r.Id;
            product.qualifier = lineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c != null? lineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c : 'Banded';
            if(product.productName.toLowerCase().contains('westlaw edge')){
                product.isEdge=true;
            }
            else{
                product.isEdge=false;
            } 
            westProflexProductsList.add(product);
        }
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> westProflexProductsList  :  '+westProflexProductsList );
        return westProflexProductsList;
    }

    //populateProductDetails- added by Herin Acharya to fix the PMD issue for deployment of US-0001215
    private static DCPRenewalProductWrapper populateProductDetails(Apttus_Config2__LineItem__c lineItem){

        DCPRenewalProductWrapper product = new DCPRenewalProductWrapper();       
        product.productName = lineItem.APTS_Product_Name__c;
        //US 2215
        //Added by:Sudhanshu Upadhayay
        //Logic to add Edge flag if a products contains keyword westlaw edge for a product configuration
            
        if(product.productName.toLowerCase().contains('westlaw edge')){
            product.isEdge=true;
        }
        else{
            product.isEdge=false;
        }
            
        product.productId=lineItem.Apttus_Config2__ProductId__c;
        //Sets qualifier as 'Banded' if Product Pricing Model is null.
        product.qualifier = lineItem.APTS_Product_Pricing_Model__c != null? lineItem.APTS_Product_Pricing_Model__c : 'Banded';

        return product;
    }
}