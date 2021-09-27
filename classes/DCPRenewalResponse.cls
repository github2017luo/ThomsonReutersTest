/**
    @description Response wrapper for Json response
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-04-14      Benjamin Her        DCP-1414 Initial Creation
    2021-04-29      Vishnu Santhosh     DCP-1118 Added the acc instance
    2021-06-29      Dinesh              DCP-2214 Added the DCPRenewalDBCatWrapper
    2021-06-30      Vishnu Santhosh     DCP-2439 | Supressed PMD Warning and removed changes made by Dinesh
 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPRenewalResponse{
    
    public string status;
    public integer code;
    public string message;
    public DCPObjects data;
    /**
        @description  
     */
    public DCPRenewalResponse(){
        data = new DCPObjects();
    }

    /**
        @description  DCPObject class
     */
    public class DCPObjects{
        public DCPRenewalContactWrapper contactData;
        public DCPRenewalOpportunityWrapper opportunityData;
        public List<DCPRenewalProposalWrapper> proposalData;
        public DCPRenewalAccountWrapper accountData;
        
        /**
        @description  Constructor
         */
        public DCPObjects(){
            contactData = new DCPRenewalContactWrapper();
            opportunityData = new DCPRenewalOpportunityWrapper();
            proposalData = new List<DCPRenewalProposalWrapper>();
            accountData =  new DCPRenewalAccountWrapper();
           }
    }
    
}