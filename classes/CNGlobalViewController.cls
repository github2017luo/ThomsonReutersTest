/**
* {Purpose} –   
*       Visualforce controller to allow Remoting.
*
* @author   David Sarbello
* @version  2014-08-28
*/ 
  
/** 
* CHANGE HISTORY
* =============================================================================
* Date          Name                            Description
* 2014-08-28    David Sarbello                  Created
* =============================================================================
*/   
Global with sharing class CNGlobalViewController {
    public CNGlobalViewController(ApexPages.StandardController controller) {    
    }
    //
    @RemoteAction
    Global static void LogEntry(String sComponentSource, String sActionType, String sActionDesc, Id acctID, Id contID) {
        CNAppUtils.insertLogEntry(sComponentSource, sActionType, sActionDesc, acctID, contID);
    }    
}