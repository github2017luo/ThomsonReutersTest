/* Class: DCP_NonTrail
* Purpose: An invocable class to send temporary password emails
* Created: 7/21/2021
**/
/**
* @description An invocable class to send temporary password emails
*/
public  without sharing class DCP_NonTrail {
    

    /********************************************************************************************************
    *  @description getqid  - get the quote Id and execute promotion call
    *  @param qIdList - list of proposal Ids 
    *********************************************************************************************************/
       
    @InvocableMethod(label='DCP ST emails' description='It gets the NSE proposal Id from Proposal when its accepted and triggers short term credentials mail')
    public static void getqid(List<Id> qIdList) {
        
        for(Id ql : qIdList)
        {
            promotionCall(ql);            
        }
        
    }
    
    /********************************************************************************************************
    *  @description  promotionCall - invoke promotions  
    *  @param proposalId - expected the product parameters 
    *********************************************************************************************************/

    public static void promotionCall(Id proposalId) {
        try {
            promotions(proposalId);
        } catch(Exception ex) {
            DCUtils.trackLog(ex,'DCP_NonTrail','promotionCall, Queuable Job');
        }        
        
    }

    /********************************************************************************************************
    *  @description promotions  - invoke queuable method  
    *  @param proposalId - expected the product parameters 
    *********************************************************************************************************/
    public static void promotions(String proposalId) {
      AsyncExecution exec = new AsyncExecution();
      exec.proposalId = proposalId;
        System.enqueueJob(exec);       
    }
    
    /********************************************************************************************************
    *  @description AsyncExecution  - Execute the promotions call asynchronously 
    *********************************************************************************************************/
	public class AsyncExecution implements Queueable, Database.AllowsCallouts {
        public String proposalId;
        private String storeName;
        /**************************************a******************************************************************
        *  @description execute  - Execute the context
        *  @param context - queuable context 
        *********************************************************************************************************/
        public void execute(QueueableContext context) {
            If(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible())
            {
                Apttus_Proposal__Proposal__c proposal = [
                    SELECT Id, Apttus_Proposal__Account__c, Apttus_Proposal__Proposal_Name__c, APTS_Customer_Pricing_Segment__c, APTS_Proposal_Business_Unit__c,is_Digital_Channel__c 
                    FROM Apttus_Proposal__Proposal__c 
                    WHERE Id = :proposalId
                ];
                
                try {
                	Ecom_NonTrailPromoPassword.requestOpenPromotionsCall('WestlawNext', proposal);
                } catch(Exception ex) {
                    DCUtils.trackLog(ex,'DCP_NonTrail','requestOpenPromotionsCall');
                }
                
            }
        }
    }    
}