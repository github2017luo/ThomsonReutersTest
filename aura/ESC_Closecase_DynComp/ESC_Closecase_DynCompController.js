({
    handleClick : function(component, event, helper) {
        component.set("v.Spinner", true);
        var recId = component.get('v.recordId');
        var action1 = component.get("c.closeCase");
        action1.setParams({
            "caseId" : recId
        });
        action1.setCallback(this, function(response){
            component.set("v.Spinner", false);
            var state = response.getState();
            if(state === "SUCCESS"){
                var responseValue = response.getReturnValue();
                if(responseValue == 'No Error'){                    
                    helper.showToast(component, event, helper);
                    $A.get("e.force:refreshView").fire();                    
                }else{
                    component.set('v.render',true);
                    var action2 = component.get("c.getRecTypeId");
                    action2.setParams({
                        "caseId": recId
                    });
                    action2.setCallback(this, function(a) {
                        var state = a.getState();
                        if(state === "SUCCESS"){
                            var result = a.getReturnValue();
                            component.set("v.rType", result[0].RecordTypeId);
                            component.set("v.rTypeName", result[0].RecordType.DeveloperName);
                            component.set('v.isOpen',true);
                        }else{
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type" : "Error",
                                "message" : "Something went wrong, please contact System Administrator."
                            });
                            resultsToast.fire();
                            $A.get("e.force:refreshView").fire();
                        }
                    });
                    $A.enqueueAction(action2);
                }
            }
        });
        $A.enqueueAction(action1);
    },
    
    handleSubmit : function(component, event, helper) {
        component.set("v.Spinner", true);
        //component.find('editForm').submit();
    },
    handleSuccess : function(component, event, helper) {
        component.set("v.Spinner", false);
        component.set('v.isOpen',false);
        helper.showToast(component, event, helper);
        $A.get("e.force:refreshView").fire();
    },
    handleError : function(component, event, helper) {
        component.set("v.Spinner", false);
    },
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
        
    },
    
})