/********************************************************************** 
Name: LTS_ApplicationAutomationUtilityTest  
====================================================== 
Req: Exclusion Framework - LOTUS Program
====================================================== 
Purpose: Test class for utility class "LTS_ApplicationAutomationUtility"
====================================================== 
History 
------- 
VERSION    AUTHOR             DATE             DETAIL 
1.0        TCS Developer     25/10/2018     Initial Development  
***********************************************************************/
@isTest
public without sharing class LTS_ApplicationAutomationUtilityTest {
    
    @isTest
    public static void checkTriggerApplicabilityTest(){
        Test.startTest();
        Boolean isTriggerDisabled = LTS_ApplicationAutomationUtility.checkTriggerApplicability();
        system.assertEquals(false, isTriggerDisabled);	
        Test.stopTest();
    }    

}