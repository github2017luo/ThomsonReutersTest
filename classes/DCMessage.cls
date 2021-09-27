/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 6/18/2018   Navleen Kaur            DLT-10233 -[Code Scan] Fix DCMessage
 * ==================================================================================================================================   
 */

Global class DCMessage {
    
    Global Integer code; // 200(Success),404(Any Error/Exception), 406(Insufficient data)
    Global string severity;
    Global string cause;
    Global boolean isSuccess;
    Global Boolean isPending;
    Global DCMessage(){}
    
    Global DCMessage(String severity,Integer code, String cause){
        this.code = code;
        this.severity = severity;
        this.cause = cause;
    }
   
}