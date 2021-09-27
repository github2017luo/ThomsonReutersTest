({
    handleRecordUpdated: function(component, event, helper) {
        var closeQuickAction = $A.get("e.force:closeQuickAction");
        closeQuickAction.fire();
        var action3 = component.get("c.getProfile");
        action3.setCallback(this, function(response){
            if (response.getState() === 'SUCCESS'){                               
                component.set("v.profileName", response.getReturnValue());
                helper.doProcessing(component, event);                                
            }
        })
        $A.enqueueAction(action3); 
    }
})