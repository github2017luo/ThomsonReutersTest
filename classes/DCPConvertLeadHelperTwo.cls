/**
* @description
* Class: DCPCovertLeadHelperTwo
* Purpose: Serves to store the details for lead conversion
* Created: 06/14/2021
* Author: Kunal Mishra
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 08/30/2021   Kunal M         DCP-4147    Created
* =============================================================================
**/

public with sharing class DCPConvertLeadHelperTwo{

    /****************************************************
     * @description
     Wrapper class to store details for lead conversion
     ***************************************************/
    public class ConvertLeadWrapperDetails{
    
        public string leadId;
        public string cartId;
        public string emailId;  
        public string quoteId ; 
        public Map<string,decimal> leadToContractTermMap;
        public String trialID;//Added as part of DCP-4147
        public string trialStatus;//Added as part of DCP-4147
        public boolean reviewRequired;//Added as part of DCP-4147 & DCP-4231
        public string reviewRequiredNotes;//Added as part of DCP-4147
     }
     
         /****************************************************
     * @description
     wrapper class to store details for process trial conversion
     ***************************************************/
     public class ProcessTRStoreWrapperDetails{
        /**@return 
         * @description 
         * @param 
        */
        public string quoteId{get;set;}
        /**@description
         * @return
         * @param
         */
         public string cartId{get;set;}
         /**@description
         * @return
         * @param
         */
         public string leadId{get;set;}
         /**@description
         * @return
         * @param
         */
         public string trialId{get;set;}
         /**@return 
         * @description 
         * @param 
        */
          
       //  public boolean reviewRequired{get;set;} //Added by priyanka for dcp-4231
         /**@return 
         * @description 
         * @param 
        */
          
        // public string reviewRequiredNotes{get;set;} //Added by priyanka for dcp-4231

     }
}