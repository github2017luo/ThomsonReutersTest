/* APTS_ApprovalRequestTriggerHelper
 * A helper class for APTS_ApprovalRequestTrigger
 *
 * Developer: Akshay Mewada, APTTUS
 * Business Owner: 
 *
 * Scenario:
 * 
 * 
 *
 * History:
 
 * 08/11/2016, Akshay Mewada, APTTUS - created APTS_ApprovalRequestTriggerHelper. 
 * 08/11/2016, Akshay Mewada, APTTUS - added populateQuoteOnApprovalRequest(). 
 */
public with sharing class APTS_ApprovalRequestTriggerHelper {
    //SOC-7061
    public static boolean approvalRequest =false;
    public APTS_ApprovalRequestTriggerHelper() {
        
    }
    
    //SOC-4809 Update On Hold field if approval comments contains "On-Hold"     Added by Chirag 10/17/2017
    public void updateOnHold(List<Apttus_Approval__Approval_Request__c> approvalReqList){
        for(Apttus_Approval__Approval_Request__c approvalReq : approvalReqList){
            if(approvalReq.Apttus_Approval__Approver_Comments__c != NULL && approvalReq.Apttus_Approval__Approver_Comments__c != ' '){
                String comments = approvalReq.Apttus_Approval__Approver_Comments__c;
                if(comments.contains('On-Hold')){
                    approvalReq.APTS_On_Hold__c = TRUE;
                }
            }
        }
    }

    //Populate the Quote/Proposal Id on Approval request record, so that the approval request appear in the related list of Quote/Proposal
    public void populateQuoteOnApprovalRequest(List<Apttus_Approval__Approval_Request__c> approvalReqList)
    {
        //SOC-7061
        approvalRequest =True;
        //Added By Poonam Garg to fix Too many SOQL DOC 10322. Removed Query from Product Configuration and added custom formula field to capture proposalId from Cart.
        for(Apttus_Approval__Approval_Request__c approvalReq : approvalReqList)
        {
            if(approvalReq.Apttus_CQApprov__CartId__c!=null){
                approvalReq.Apttus_QPApprov__ProposalId__c =approvalReq.APTS_Related_ProposalID__c;
            }
        }
   }

}