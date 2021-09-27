({
    doInit : function(component,event,helper) {
        helper.getCohortResult(component,event,helper);
    },
    showmsg : function(component,event,helper) {
        var res = component.get("v.serverresponse");
        component.set("v.showLoader", false);
        
        if(res==true){
            helper.showSuccess(component, event, helper);
        }else if(res==false){
            helper.showError(component, event, helper);
        }
        var dismissActionPanel=$A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        
    }
})