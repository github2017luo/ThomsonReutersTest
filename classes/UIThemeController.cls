/********************************************************************************************************* 
Name: UIThemeController
==========================================================================================================
Purpose:  Aura enabled utility class to identify logged in user's theme.
==========================================================================================================
* CHANGE HISTORY
* ========================================================================================================
* JIRA             Date               Name                            Project               Description
* DPS-16572        1-July-2020        Debarghya Sen                   LCRM                  Created
* =========================================================================================================
***********************************************************************************************************/

public with sharing class UIThemeController {
   @AuraEnabled
    public String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
}