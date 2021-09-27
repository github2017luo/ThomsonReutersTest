/********************************************************************************
Class Name : DCPRenewalProposal
@description : This class is used by DCPGetRenewal class to populate manual proposals.
***************************************************************************************

Modification Details
Date             Description                                                              Owner
30/07/2021        Class Created                                                            By Sudhanshu Upadhayay


*********************************************************************************/

public without sharing class DCPManualOffferReplacementProposals {
// US 2681
// Added By: Sudhanshu Upadhayay
// Date Added: 26-07-2021
private static final String DIGITAL_QUOTE_TYPE_PLUS = 'Best Value';
private static final String DIGITAL_QUOTE_TYPE_MANUAL = 'Manual';
private static final String DIGITAL_QUOTE_TYPE_STRAIGHT = 'Straight Renewal'; 
private static final String DIGITAL_QUOTE_TYPE_PREMIUM = 'Premium'; 

    
    
//manualOfferReplacementHelper() method
//Builds the final cart list with manual propsal and automated proposals
//manualOfferReplacementHelper() method
//Builds the final cart list with manual propsal and automated proposals
/**
    @description Pulls manual offers and add it to proposal list with digital proposal 
    @param manualProposalList it contains list of manual proposals
    @param digitalProposals it contains all digitally generated proposals
    @return Returns DCPRenewalResponse data
    */

public static List < Apttus_Proposal__Proposal__c > manualOfferReplacementHelper(List < Apttus_Proposal__Proposal__c > manualProposalList,
    DigitalProposalWrapper digitalProposals) {
Apttus_Proposal__Proposal__c straightProposal =digitalProposals.straightProposal ;
Apttus_Proposal__Proposal__c bestProposal =digitalProposals.bestProposal;
Apttus_Proposal__Proposal__c premiumProposal = digitalProposals.premiumProposal;
    List < Apttus_Proposal__Proposal__c > configlist = new List < Apttus_Proposal__Proposal__c > ();
        //Landing page only supports up to 3 offers, so add Straight and Best Value only if the new list size < 3
    
        // If manual proposal list contains only one item for proposal
        if(manualProposalList.size()==1){
            configlist.addAll(manualProposalList); 
            if(straightProposal!=null){
                configlist.add(0,straightProposal); 
            }
                configlist=  getCongifListIfBestProposalIsNotNull(straightProposal,bestProposal,configlist); 
                
            if(premiumProposal!=null && configlist.size()<3){
                
                DigitalProposalWrapper dpw = new DigitalProposalWrapper();
                dpw.straightProposal=straightProposal;
                    dpw.bestProposal=bestProposal;
                    dpw.premiumProposal=premiumProposal;
                configlist=getCongifListIfPremiumProposalIsNotNull(configlist,dpw);
                    
            }
        }
                
        // If manual proposal list contains two item for proposal
        else if(manualProposalList.size()==2){
            configlist.addAll(manualProposalList); 
            configlist= getCongifListIfStaightProposalIsNotNull(straightProposal,configlist);
            
            DigitalProposalWrapper dpw = new DigitalProposalWrapper();
                dpw.straightProposal=straightProposal;
                    dpw.bestProposal=bestProposal;
                    dpw.premiumProposal=premiumProposal;
         configlist=getCongifManualListIsTwo(configlist,dpw);       
            
                
            
        }
// If manual proposal list contains thre item for proposal
        else if(manualProposalList.size()==3){
            configlist = manualProposalList; 
            return configlist;
        }
        else if (manualProposalList.size()>3){
            for(Integer i=0; i<3; i++){
                configlist.add(manualProposalList[i]); 
            }
            return configlist;
        }

    return configlist;
}






private static List<Apttus_Proposal__Proposal__c> getCongifListIfBestProposalIsNotNull(Apttus_Proposal__Proposal__c straightProposal,Apttus_Proposal__Proposal__c bestProposal,List<Apttus_Proposal__Proposal__c> configlist){
        if(bestProposal!=null && configlist.size()<3){        
    if(straightProposal!=null){
                    configlist.add(1,bestProposal); 
                }else{
                    configlist.add(0,bestProposal); 
                }}
    return configlist;
}

private static List<Apttus_Proposal__Proposal__c> getCongifListIfPremiumProposalIsNotNull(List<Apttus_Proposal__Proposal__c> configlist,DigitalProposalWrapper digitalWrapper){
        if(digitalWrapper.straightProposal!=null && digitalWrapper.bestProposal==null){
                    configlist.add(1,digitalWrapper.premiumProposal);  
                }
                else if(digitalWrapper.straightProposal==null && digitalWrapper.bestProposal==null){
                configlist.add(0, digitalWrapper.premiumProposal); 
                }
                else if(digitalWrapper.straightProposal==null && digitalWrapper.bestProposal!=null){
                    configlist.add(1,digitalWrapper.premiumProposal);  
                }
    return configlist;
} 
//@SuppressWarnings('PMD.CognitiveComplexity', 'PMD.CyclomaticComplexity')
//
// 
//   @suppresswarnings('pmd.CyclomaticComplexity','pmd.CognitiveComplexity')
    private static List<Apttus_Proposal__Proposal__c> getCongifManualListIsTwo(List<Apttus_Proposal__Proposal__c> configlist,DigitalProposalWrapper digitalWrapper){
        if(digitalWrapper.bestProposal!=null){
               
            configlist = getCongifListIfStraightProposalIsNotNull(digitalWrapper,configlist);
                if(configlist.size()==3){
                    return configlist;  
                }    
            }
            if(digitalWrapper.premiumProposal!=null && configlist.size()<3 ){
                if(configlist.size()==3){
                    return configlist;  
                } 
                else if(digitalWrapper.straightProposal==null && digitalWrapper.bestProposal==null){
                    configlist.add(0,digitalWrapper.premiumProposal);
                }else {
                    configlist.add(1,digitalWrapper.premiumProposal);
                }
                // configlist.add(premiumProposal); 
                if(configlist.size()==3){
                    return configlist;  
                }    
            }
        return configlist;
} 
private static List<Apttus_Proposal__Proposal__c> getCongifListIfStraightProposalIsNotNull(DigitalProposalWrapper digitalWrapper,List<Apttus_Proposal__Proposal__c> configlist){
if(digitalWrapper.straightProposal==null && configlist.size()<3 ){
                configlist.add(0,digitalWrapper.bestProposal); 
                    }else if(configlist.size()<3){
                    configlist.add(1,digitalWrapper.bestProposal);  
                    }
return configlist;
}

    private static List<Apttus_Proposal__Proposal__c> getCongifListIfStaightProposalIsNotNull(Apttus_Proposal__Proposal__c straightProposal,List<Apttus_Proposal__Proposal__c> configlist){
        if(straightProposal!=null){
                configlist.add(0,straightProposal); 
                    if(configlist.size()==3){
                    return configlist;  
                }  
            }
    return configlist;
}

 
}