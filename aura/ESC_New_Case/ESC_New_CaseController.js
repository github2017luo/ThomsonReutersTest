({
	doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
		//alert("In Do Init");
        //alert("Record Id: "+ component.get("v.recId"));
        
        var contactId = component.get("v.recordId");
        console.log(contactId);
        
        var action = component.get("c.createCaseFromContact");
        action.setParams({
            "contactID" : contactId  
        });
        
        console.log("action: "+ action);
        action.setCallback(this, function(response){
            component.set("v.Spinner", false);
            console.log("response");
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                var newCaseID = response.getReturnValue();
                console.log("New Case Id: "+ newCaseID);
                
                helper.navigateToCase(component, newCaseID);
                
               /* var sObjectEvent = $A.get("e.force:navigateToSObject");
                sObjectEvent.setParams({
                    "recordId": newCaseID
                })
                sObjectEvent.fire();*/
                $A.get("e.force:closeQuickAction").fire();
                //$A.get('e.force:refreshView').fire();
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "success",
                    "message" : "Case successfully created."
                });
                resultsToast.fire();
            }
            else{
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "error",
                    "message" : "Some error has occurred. Please contact System Administrator."
                });
                resultsToast.fire();
                $A.get("e.force:closeQuickAction").fire();
                //$A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
	}
})