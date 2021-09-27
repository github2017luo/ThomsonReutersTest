/********************************************************************************
Class Name : DCPRenewalContactWrapper
@description : Request Structure for Contact Array
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                         Developer              Description
21-04-2021                  Benjamin Her            Initial Creation

*/ 
public class DCPRenewalContactWrapper{
    public string firstName;
    public string lastName;  
    public Id contactId;
    public string email;

    /**
    @description Constructor for DCPRenewalContactWrapper to avoid Coverage issue
    */
    public DCPRenewalContactWrapper(){
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPRenewalContactWrapper *** >> ' );
    }
}