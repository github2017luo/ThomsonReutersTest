({
	doInit : function(component, event, helper) {
		//alert("on load");
		component.set("v.Spinner", true);
        component.set("v.cssStyle", "<style>.cuf-scroller-outside {background: rgb(255, 255, 255) !important;}</style>");
        var recID = component.get("v.recordId");
        console.log("ID:" + recID);
        var action = component.get("c.closeCase");
        action.setParams({
            "caseId" : recID
        });
        console.log("action:" + action);
        action.setCallback(this, function(response){
            component.set("v.Spinner", false);
            console.log("response");
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                var responseValue = response.getReturnValue();
                if(responseValue == 'No Error')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type" : "success",
                        "message" : "Case is successfully closed."
                    });
                    resultsToast.fire();
                    
                    helper.refreshPage(component, event, helper);
                }
            }
            else
            {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "error",
                    "message" : "Error"
                });
                resultsToast.fire();
            }
        });
        $A.enqueueAction(action);
	},
    
    handleSubmit : function(component, event, helper) {
        component.set("v.Spinner", true);
        component.find('editForm').submit();
    },
    handleSuccess : function(component, event, helper) {
        component.set("v.Spinner", false);
    	
        var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type" : "success",
                        "message" : "Case is successfully closed."
                    });
                    resultsToast.fire();
        helper.refreshPage(component, event, helper);
    },
    
   handleError : function(component, event, helper) {
        component.set("v.Spinner", false);
    	        
    }
    
})