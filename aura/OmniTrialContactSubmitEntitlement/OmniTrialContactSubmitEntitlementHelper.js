({
    doInitHelper : function(component,event) {
        var action = component.get("c.processRec");
        action.setParams({recId:component.get("v.recordId")});
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                component.set("v.loaded",false);
                component.set("v.message",response.getReturnValue());
                $A.get("e.force:closeQuickAction").fire();
				this.showToastMsg(component,event,response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    showToastMsg : function(component,event,message,isError) {
        var toastEvent = $A.get("e.force:showToast");
        if(message == $A.get("$Label.c.OmniContactSubmitTrialValidaionMsg")){
            toastEvent.setParams({            
                "type": "error",
                "mode": 'sticky',
                "message":message
            });
        }
        else{
            toastEvent.setParams({            
                "type": "success",
                "mode": 'sticky',
                "message":message
            }); 
        }
        toastEvent.fire();
    }
})