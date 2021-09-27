/********************************************************************************
Class Name : DCPRenewalOpportunityWrapper
@description : Request Structure for Opportunity Array
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                         Developer              Description
21-04-2021                  Benjamin Her            Initial Creation
24-06-2021                  Vishnu Santhosh         DCP-2214 | Added min & max attorney variables
25-06-2021                  Dinesh                  DCP-2211 | Added autoRenwalDate
*/ 
public class DCPRenewalOpportunityWrapper{
    public boolean isDigital;
    public Date renewalDate;
    public id opportunityId;
    public Integer minimumAttorneys;
    public Integer maximumAttorneys;
    public Date autoRenewalDate; //Add by Dinesh
    public String campaignCode;
    public String subCampaignCode;

    /**
    @description Constructor for DCPRenewalOpportunityWrapper to avoid coverage issue
    */
    public DCPRenewalOpportunityWrapper(){
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPRenewalOpportunityWrapper *** >> ' );
    }
}