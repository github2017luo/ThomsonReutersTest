/**
* @file name          : DCPLeadRequest
* @description        : This is class for Lead Services API
* @author             : Servendra Kumar
* @group              : TR
* @last modified by   : Servendra Kumar
* @last modified on   : 05/20/2021
* @modification log   : CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA         Description
* 05/24/2021   Servendra Kumar    DCP-1678     Created 
* =============================================================================
**/
@RestResource(urlMapping='/newsale/DCPLeadCreateService')
global without sharing class DCPLeadRequest {

    /**
        @description POST method
        @param dcpOrder
        @return Returns the response for the appropriate service
     */
    @httppost
    global static DCPLeadRequestHandler.DCPResponse processLead(DCPLeadRequestHandler.DCPOrders dcpOrder){
        
          
        DCPLeadRequestHandler.ActionParams ac = dcpOrder.actionParamsDetails;
        DCPLeadRequestHandler.DCPResponse leadResponse = new DCPLeadRequestHandler.DCPResponse();
        DCPLeadService processCreate = new DCPLeadService();
        system.debug(LoggingLevel.Info,'object '+dcpOrder);
        try{
            if(ac.leadAction.equalsIgnoreCase('Create') || ac.leadAction.equalsIgnoreCase('Update')){
                leadResponse = processCreate.processLead(dcpOrder);
            }             
            
        }catch(exception e){
            system.debug(LoggingLevel.INFO, 'Exception FetchDetails......'+e);
        }
            
        return leadResponse;
    }

}