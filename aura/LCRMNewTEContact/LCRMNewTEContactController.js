({
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        //alert(payload.id);
        //alert(component.get("v.recordId"));
        var action = component.get("c.createContact");
        action.setParams({
            "contactId": payload.id,
            "teId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.find('notifLib').showToast({
                    "variant": "success",
                    "title": "Contact Created"
                });
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }
            else {
                console.log("Failed with state: " + state);
                alert('Cannot create Contact, please validate if you are using Archived Account');
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    handleSubmit : function(component, event, helper) {
        
    },
    handleError : function(component, event, helper) {
        
    },
    showSpinner: function(component, event, helper) {
       component.set("v.Spinner", true); 
   },
    
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    }
})