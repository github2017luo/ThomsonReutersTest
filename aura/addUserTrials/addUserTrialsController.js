({
    
    doInit : function(component, event, helper) {
         var value = component.get("v.trial.Opportunity__c");
         component.set("v.optyId", value);
         
    },
    closeQuickAction_AuraMethod : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})