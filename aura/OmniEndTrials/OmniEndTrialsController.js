({
    
    doInit : function(component, event, helper) {
                
    },
    closeQuickAction_AuraMethod : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})