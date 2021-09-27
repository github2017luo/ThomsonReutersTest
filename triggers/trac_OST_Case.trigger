trigger trac_OST_Case on Case (before insert, after insert, after update, before update) {
//LTS_6301 : Exclusion framework
System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
{return;}
 Boolean ESCCoreCheck = false;
    if(trigger.newMap != NULL && !trigger.newMap.isEmpty()){
               for(Case c:trigger.new){
                   if(c.Is_ESC_Case__c || (c.origin=='UE') || (c.origin=='My TR')) 
                      ESCCoreCheck = true;
                   else
                      ESCCoreCheck = false;        
             }
    }
    if(Trigger.isAfter && Trigger.isInsert) {
      if(ESCCoreCheck ==false){
        trac_OST.handleNewCases( trigger.new );
        }
    }
    if(Trigger.isAfter && Trigger.isUpdate) {
      if(ESCCoreCheck ==false){
        trac_OST.handleUpdatedCases( trigger.new, trigger.oldMap );
        }
    }

}