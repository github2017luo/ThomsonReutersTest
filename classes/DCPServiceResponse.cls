/**
    @description Class to hold DCP REST service response
 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPServiceResponse{

    public string status;
    public integer code;
    public string response;

    /**
    @description Constructor for DCPServiceResponse to avoid coverage issue
    */
    public DCPServiceResponse(){
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DCPServiceResponse *** >> ' );
    }
}