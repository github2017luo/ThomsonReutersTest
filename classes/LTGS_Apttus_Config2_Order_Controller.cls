/**
* CHANGE HISTORY
* Date         Name                    Description
*  
* 2019-04-04   Lovedeep Singh          [DPS-4098] This class is created as part of the new Lightning components(LTGS_Apttus_Proposal_Admin and LTGS_Apttus_Proposal_Admin_Parent) which are created to replace the Javascript button (Admin) with 
										New Button(Admin) compatible with Lightning experience. This class has methods to check if the Proposal ID is already submitted and another method to call the Apttus webservice to submit the order.
* =============================================================================
*/
public without sharing class LTGS_Apttus_Config2_Order_Controller {
    @AuraEnabled
    public static Integer getApttus_Config2_OrderId(Id ProposalId){
        Integer size=0;
        if(Schema.sObjectType.UserRecordAccess.isAccessible()){
            size= [SELECT id FROM Apttus_Config2__Order__c WHERE Apttus_QPConfig__ProposalId__c =: ProposalId LIMIT 1].size();
            
        }
        return size;
    }
    @AuraEnabled
    public static Boolean acceptQuote(Id ProposalId){
        Boolean result = false;  
        System.debug('Calling Apttus web service for order submission');
        result = Apttus_QPConfig.QPConfigWebService.acceptQuote(ProposalId);
        return result;
    }
}