/**
@description Main GET logic for DCP Renewal Service
CHANGE HISTORY
================================================
Date            Developer           Description
2021-04-14      Benjamin Her        DCP-1414 Initial Creation
2021-04-29      Vishnu Santhosh     DCP-1118 acc Instance added
2021-06-25      Vishnu Santhosh     DCP-2212 | Added 'ssd' parameter to opp. data response
2021-06-29      Dinesh              DCP-2214 | Added  populate wrapper data

*/
//@suppresswarnings({})
//@SuppressWarnings({'pmd.CyclomaticComplexity','pmd.CognitiveComplexity'})
public without sharing class DCPGetRenewal{
private static final string STR_OPPID = 'oppId';
private static final string STR_SSDID = 'ssdId';
private static Opportunity opp;
private static Contact con;
private static List<Apttus_Proposal__Proposal__c> propList;
private static List<Apttus_Config2__ProductConfiguration__c> cartList;
private static Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap = new Map<String,Apttus_Config2__ProductConfiguration__c>();
private static Source_System_Detail__c ssd;
private static Account acc;  
// US 2681
// Added By: Sudhanshu Upadhayay
// Date Added: 26-07-2021
private static final String DIGITAL_QUOTE_TYPE_PLUS = 'Best Value';
private static final String DIGITAL_QUOTE_TYPE_MANUAL = 'Manual';
private static final String DIGITAL_QUOTE_TYPE_STRAIGHT = 'Straight Renewal'; 
private static final String DIGITAL_QUOTE_TYPE_PREMIUM = 'Premium'; 
//Commented out Sprint 13 Changes for deployment - Vishnu
//private static List<DCPRenewalDBCatWrapper> dbCatWrapperList;//Add by Dinesh

/**
    @description Pulls DCPRenewalResponse data
    @param reqParameter Request parameter pull from URL
    @return Returns DCPRenewalResponse data
    */
public static DCPRenewalResponse getDCPRenewalResponse(Map<String, String> reqParameter){

    if(reqParameter == null || reqParameter.isEmpty()){
        throw new DCCustomException('Request Parameters do not exist');
    }

    queryData(reqParameter);

    return populateDCPRenewalResponse();
}

private static void queryData(Map<String, String> reqParameter){
    string oppId;
    string ssdId;

    if(reqParameter.containsKey(STR_OPPID) && String.isNotBlank(reqParameter.get(STR_OPPID))
        && reqParameter.containsKey(STR_SSDID) && String.isNotBlank(reqParameter.get(STR_SSDID))){

        oppId = reqParameter.get(STR_OPPID);
        ssdId = reqParameter.get(STR_SSDID);
        opp = DCPOpportunity.getOpportunity(new List<Id>{oppId})[0];
        con = DCPContact.getContact(new List<Id>{opp.Key_Contact__c})[0];
        propList = DCPProposal.getPresentedProposal(oppId,ssdId);
        propList =manualOfferReplacement(propList);// for manual proposal logic and fixing cart size to 3
        cartList = DCPCart.getFinalizeCartFromProposal(propList);
        for(Apttus_Config2__ProductConfiguration__c cart : cartList){
            proposalIDToCartMap.put(cart.Apttus_QPConfig__Proposald__c, cart);
        }
        DCPRenewalSetting.getRenewalSetting();
        ssd = DCPSSD.getSSD(new List<Id>{ssdId})[0];
        acc = DCPAccount.getAccounts(new List<id>{ssd.Account_Name__c})[0];
        
        //Commented out Sprint 13 Changes for deployment - Vishnu    
        //dbCatWrapperList = DCPDBCategory.getCBCats(oppId,ssdId);//Add by Dinesh
    

        }
    else{
        throw new DCCustomException('Error with request parameter. Parameter is missing or blank');
    }
}

private static DCPRenewalResponse populateDCPRenewalResponse(){
    
    DCPRenewalResponse response = new DCPRenewalResponse();
    response.data.opportunityData = DCPRenewalOpportunity.populateOpportunityDetails(opp,ssd);       
    response.data.contactData = DCPRenewalContact.populateContactDetails(con);
    response.data.proposalData = DCPRenewalProposal.getProposalDetails(propList,proposalIDToCartMap, opp);
    response.data.accountData = DCPRenewalAccount.populateAccountDetails(acc, ssd);
    
    
    //Commented out Sprint 13 Changes for deployment - Vishnu
    //response.data.dbData = dbCatWrapperList;//Add by Dinesh


    return response;
}

/**
    @description manualOfferReplacement() method.Updated DCP-2691 - Replaces automated offers with up to 3 manual offers
    @param carts
    @return List <Apttus_Proposal__Proposal__c>
    */
public static List <Apttus_Proposal__Proposal__c> manualOfferReplacement(List < Apttus_Proposal__Proposal__c> carts) {
    //List < Apttus_Proposal__Proposal__c > configlist = new List < Apttus_Proposal__Proposal__c> ();
    List < Apttus_Proposal__Proposal__c > manualProposalList = new List < Apttus_Proposal__Proposal__c > ();
        Apttus_Proposal__Proposal__c bestProposal;
        Apttus_Proposal__Proposal__c straightProposal;
    Apttus_Proposal__Proposal__c plusProposal;
    Apttus_Proposal__Proposal__c premiumProposal;


    //Data validation check. Return passed in cart.
    if (carts == null || carts.isEmpty()) {
        return carts;
    }

    //Iterates over passed in cart list and stores any 'Manual' proposals
    //Stores Straight and Best proposals for easier access
    DigitalProposalWrapper dpw = new DigitalProposalWrapper();
    dpw = getProposalsFromCart(carts);
    manualProposalList = dpw.manualProposals;
    straightProposal=dpw.straightProposal;
    plusProposal=dpw.bestProposal;
    premiumProposal=dpw.premiumProposal;



    //If zero manual offers exists, return original cart
    if (manualProposalList.isEmpty() && carts.size()<=3 ) {
        return carts;
    } 
    // If existing carts contains more than 3 items and no rep generated proposals
    else if(manualProposalList.isEmpty()&& carts.size() > 3 ){
            List < Apttus_Proposal__Proposal__c > configList = new List < Apttus_Proposal__Proposal__c > ();
        for(Integer i=0; i<3; i++){
            if(carts[i].Digital_Quote_Type__c != DIGITAL_QUOTE_TYPE_MANUAL){
                configlist.add(carts[i]);  
            }
            }
        return configlist;
    } 
    else {
        //Build/Return new list since manual proposals are present
        DigitalProposalWrapper digitalProposals = new DigitalProposalWrapper();
        digitalProposals.straightProposal = straightProposal;
        digitalProposals.bestProposal = plusProposal;
        digitalProposals.premiumProposal = premiumProposal;
        return DCPManualOffferReplacementProposals.manualOfferReplacementHelper(manualProposalList,digitalProposals);
        //return manualProposalList;

    }
} //end of manualOfferReplacement() method
    

private static DigitalProposalWrapper getProposalsFromCart(List<Apttus_Proposal__Proposal__c> carts){
            //Iterates over passed in cart list and stores any 'Manual' proposals
    //Stores Straight and Best proposals for easier access
    DigitalProposalWrapper dpr = new DigitalProposalWrapper();
    for (Apttus_Proposal__Proposal__c pconfig: carts) {
        if (pconfig.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_MANUAL && pconfig.Display_in_CXD_Renewals__c==true ) { //add manual proposals to list.
            dpr.manualProposals.add(pconfig);
        }  if (pconfig.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_STRAIGHT) { //assign straight proposal
            dpr.straightProposal = pconfig;
        }  if (pconfig.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_PLUS) { //assign plus proposal.
            dpr.bestProposal = pconfig;
        }
            if (pconfig.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_PREMIUM) { //assign premium proposal.
            dpr.premiumProposal = pconfig;
        }
    }
return dpr;
}  

}