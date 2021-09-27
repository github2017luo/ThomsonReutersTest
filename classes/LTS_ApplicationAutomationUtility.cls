/********************************************************************** 
Name: LTS_ApplicationAutomationUtility()  
====================================================== 
Req: Exclusion Framework - LOTUS Program
====================================================== 
Purpose: Utility class to be used for Exclusion Framework 
====================================================== 
History 
------- 
VERSION    AUTHOR             DATE             DETAIL 
1.0        TCS Developer     25/10/2018     Initial Development  
***********************************************************************/

public without sharing class LTS_ApplicationAutomationUtility{

    private static Boolean isTriggerDisabled = false;
    
    /******************************************************************* 
    Purpose: To check if whether triggers can be executed or not 
    Parameters: None
    Returns: Boolean 
    ********************************************************************/
    public static Boolean checkTriggerApplicability()
    {
        isTriggerDisabled = LTS_Disable_Application_Automation__c.getInstance().LTS_Disable_Triggers__c; 
        return isTriggerDisabled;
    }
}