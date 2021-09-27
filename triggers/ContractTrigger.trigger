/*
======================================================================================================================
TRIGGER NAME:  ContractTrigger
======================================================================================================================
=
PURPOSE: Processes Contract records before a DML event is processed by the system

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-09-25        TCS Developer     CRM-7843 - Populate Sub BU and is GLI field on Contract
======================================================================================================================
*/
trigger ContractTrigger on Contract (before insert) {
//LTS_6301 : Exclusion framework
System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
{return;}
    
    //Update Sub bu and Gli field on Contract object
    if(Boolean.valueOf(System.Label.Legal_CRM_Switch) == True) 
        LCRMGenericComponent.populateSubbu(trigger.new); 
}