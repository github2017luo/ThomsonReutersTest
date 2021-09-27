({
    showToast: function(component, event, helper){
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "type" : "success",
            "message" : "Case is successfully closed."
        });
        resultsToast.fire();
    }
})