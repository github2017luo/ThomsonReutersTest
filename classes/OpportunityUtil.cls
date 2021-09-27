/**
 * Provides methods helper methods for working with opportunities
 *
 * @author  John De Santiago
 * @version 2012-04-24
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-04-24   John De Santiago        Created  
 * 2017-03-31   Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1                                                               
 * =============================================================================
 */
public without sharing class OpportunityUtil{
    //Added as part of SOQL Error- MASTERSAF
    public static boolean syncRevenueAmountsRecCheck = false; 
    public static string strProfileName = ContactUtil.getProfileName();    
    public static void syncRevenueAmounts(Set<Id> opportunityIds){
        if(strProfileName != Label.Latam_Profile && strProfileName !=  Label.Partner_Portal_Profile){ //Added this profile check -MASTERSAF
            List<Opportunity> listUpdateOpportunities = new list<Opportunity>();
            Id ANZUsersProfileId = KeyValueListStore__c.getInstance('ANZUsersProfileId').TextValue__c;
            Set<String> sANZSalesOrgs = new Set<String>{'LRA','BKRS','SMHK'};
            List<Opportunity> listOpportunities = queryOpportunitiesForRevenueAmountRollup(opportunityIds);
            List<Id> listANZOpportunityIds = new List<Id>();
            for (Opportunity oOpportunity : listOpportunities){
                if(!((oOpportunity.Renewal_Flag__c && sANZSalesOrgs.contains(oOpportunity.Selling_Organization__c))||(oOpportunity.Owner.ProfileId == ANZUsersProfileId && !oOpportunity.Renewal_Flag__c))){
                    RevenueAmounts oCurrentAmounts = new RevenueAmounts(oOpportunity);
                    RevenueAmounts oRevenueAmounts = rollUpRevenueAmounts(oOpportunity.Product_Types__r);
                    if(oCurrentAmounts.match(oRevenueAmounts) == false){
                        Opportunity oOpportunityUpdate = new Opportunity(Id=oOpportunity.Id);
                        oOpportunityUpdate.Total_Renewal__c = oRevenueAmounts.TotalRenewalAmount;
                        oOpportunityUpdate.Total_Incremental__c = oRevenueAmounts.TotalIncrementalAmount;
                        listUpdateOpportunities.add(oOpportunityUpdate);
                    }
                }
                else{
                    listANZOpportunityIds.add(oOpportunity.Id);
                }
            }
            if(!listANZOpportunityIds.isEmpty()){
                OpportunityLineItemTriggerHandler.updateOppRenewal_IncrAmounts(null,listANZOpportunityIds);
            }
            if(listUpdateOpportunities.isEmpty() == false){
                update listUpdateOpportunities;
            }
        }
    }

    
  //  ***************************************************************************************************************
    
        public void callAddToSalesTeam(){
            user u = new user();// system.debug('**********************PageReference ='+newOpportunityPageReference+'*****************************');
            u = [select id from user where id=:userinfo.getuserid()];
            String oppid= ApexPages.currentPage().getparameters().get('id').escapeHtml4(); //Added by Radhika Pawar to avoid PMD violation;
            Opportunity oOpp = [Select OwnerId from Opportunity where Id =: oppid limit 1];
            // Opportunity oOppId = (opportunity)Controller.getId(); system.debug('************************user='+u.id+'******************opportunity='+oppid);
           Opportunityteammember oteamMember = new Opportunityteammember(UserId=u.id,OpportunityId=oppid);
           database.insert(oteamMember);
           // system.debug('**********************oteamMember='+oteamMember+'*****************************');
           if(u.id!=oOpp.OwnerId){
           OpportunityShare oppshare = new OpportunityShare(UserorGroupId=u.id,OpportunityId=oppid,OpportunityAccessLevel = 'edit');
           database.insert(oppshare);
         }
      }
   
  //  *****************************************************************************************************************
    
    public static Set<Id> getOpportunityIdsFromProductTypes(List<Opportunity_Product_Type__c> listOpportunityProductTypes){
        Set<Id> opportunityIds = new Set<Id>();
        for (Opportunity_Product_Type__c oOpportunityProductType : listOpportunityProductTypes){
            opportunityIds.add(oOpportunityProductType.Opportunity__c);
        }
        return opportunityIds;
    }
    
    private static RevenueAmounts rollUpRevenueAmounts(List<Opportunity_Product_Type__c> listOpportunityProductTypes){
        RevenueAmounts oRevenueAmounts = new RevenueAmounts();
        if (listOpportunityProductTypes != null && !listOpportunityProductTypes.isEmpty()) { /* listOpportunityProductTypes.isEmpty() == false has been changed */
            for (Opportunity_Product_Type__c oOpportunityProductType : listOpportunityProductTypes) {
                oRevenueAmounts.TotalRenewalAmount += AppUtil.isNull(oOpportunityProductType.Renewal_Amount__c, 0);
                oRevenueAmounts.TotalIncrementalAmount += AppUtil.isNull(oOpportunityProductType.Incremental_Amount__c, 0);
            }
        }
        return oRevenueAmounts;
    }
    
    private static List<Opportunity> queryOpportunitiesForRevenueAmountRollup(Set<Id> opportunityIds){
        return [SELECT Id, Total_Incremental__c, Total_Renewal__c, Owner.ProfileId, Selling_Organization__c, Renewal_Flag__c
                ,(SELECT Id , Incremental_Amount__c , Renewal_Amount__c FROM Product_Types__r) FROM Opportunity 
                WHERE  Id IN :opportunityIds AND Override_Revenue_Amounts__c = false];
    }
    
    public class RevenueAmounts{
        public decimal TotalRenewalAmount {get;set;}
        public decimal TotalIncrementalAmount {get;set;}
        public RevenueAmounts(){
            TotalRenewalAmount = 0;
            TotalIncrementalAmount = 0;
        }
        
        public RevenueAmounts(Opportunity oOpportunity){
            this();
            TotalRenewalAmount = AppUtil.isNull(oOpportunity.Total_Renewal__c, 0);
            TotalIncrementalAmount = AppUtil.isNull(oOpportunity.Total_Incremental__c, 0);
        }
        
        public boolean match(RevenueAmounts oRevenueAmounts){
            boolean matches = false;
            if(TotalRenewalAmount == oRevenueAmounts.TotalRenewalAmount
                && TotalIncrementalAmount == oRevenueAmounts.TotalIncrementalAmount){
                matches = true;
            }
            return matches;
        }
    }
}