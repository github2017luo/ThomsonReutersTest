({
    handleRecordUpdated : function(component, event, helper) {
        var action = component.get("c.PermissiontoButton");
        action.setParams({
            "quoteId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if (response.getState() === 'SUCCESS'){
                var errorCheck = action.getReturnValue();
                component.set("v.errorcheck", errorCheck);
                if(errorCheck){  
                    helper.helperOrderId(component,  component.get("v.simpleProposal.Apttus_Proposal__Approval_Stage__c"));                
                }else{
                    helper.showToast("error", "sticky", "Sorry, you must be an Admin to use this button!");                   
                    $A.get("e.force:closeQuickAction").fire();
                    helper.reloadRecord();
                }
            }
        })
        $A.enqueueAction(action); 
    }
})