({
    openmodel : function(component, event, helper) {
      component.set("v.isOpen", true);  
    },
    
	doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
        component.set("v.isOpen", false);
		var recID = component.get("v.recordId");
        var caseType = "Feedback";
        var action = component.get("c.validateCaseHasParentId");
        action.setParams({
            "caseId" : recID,
            "type" : caseType
        });
        action.setCallback(this, function(response){
            //component.set("v.Spinner", false);
            //console.log("response");
            var state = response.getState();
            //console.log(state);
            if(state === "SUCCESS"){
                component.set("v.Spinner", false);
                var hasParentID = response.getReturnValue();
                if(hasParentID)
                {
                    var resultsToast = $A.get("e.force:showToast");
                	resultsToast.setParams({
                        "type" : "error",
                        "message" : $A.get("$Label.c.ESC_ParentExistingAlready")
                	});
                	resultsToast.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else
                {
                    var actionFeedback = component.get("c.sendCaseRequest");
                    actionFeedback.setParams({
                        "caseId" : recID,
                        "type" : caseType
                    });
                    actionFeedback.setCallback(this, function(responseNew){
                        console.log(responseNew);
                        var callbackState = responseNew.getState();
                        console.log(callbackState);
                        if(callbackState === "SUCCESS"){
                            var newCaseID = responseNew.getReturnValue();
                            var sObjectEvent = $A.get("e.force:navigateToSObject");
                                sObjectEvent.setParams({
                                    "recordId": newCaseID
                                })
                            sObjectEvent.fire();
                            $A.get('e.force:refreshView').fire();
                            
                        }
                        else{
                            resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type" : "error",
                                "message" : "Some error has occurred. Please contact System Administrator."
                            });
                            resultsToast.fire();
                            $A.get('e.force:refreshView').fire();
                        }
                    });
                    $A.enqueueAction(actionFeedback);
                }  
            }
            else
            {
                component.set("v.Spinner", false);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "error",
                    "message" : "Some error has occurred on validation. Please contact System Administrator."
                });
                //$A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
	},
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   }
})