({
    showToast : function(component,event,helper){
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "type" : "success",
            "message" : "Special Instruction is successfully created."
        });
        resultsToast.fire();
    },
     closeModal : function(component,event) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.getParams().response.id,
            "slideDevName": "related"
        });
        
        navEvt.fire();
    }
})