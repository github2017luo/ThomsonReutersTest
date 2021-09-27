({
	doInit : function(component, event, helper) {
        //alert("in do int")
        component.set("v.Spinner", true);
		var recId = component.get("v.recordId");
        console.log(recId);
        var action = component.get("c.reopenCase");
        action.setParams({"caseId" : component.get("v.recordId")});
        action.setCallback(this, function(response){
            component.set("v.Spinner", false);
            console.log("response");
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "success",
                    "message" : "Case has been re-opened successfully"
                });
                //console.log("Before refresh");
                
                resultsToast.fire();
                //console.log("after refresh");
                
                $A.get("e.force:refreshView").fire();
            }
            else
            {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "error",
                    "message" : "Case failed to be re-opened"
                });
                //$A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
	}
})