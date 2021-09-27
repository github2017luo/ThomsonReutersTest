({
    doinit : function(component, event, helper) {
        var objId = component.get('v.recordId');
        var obj;
        var accval;
        var rType;
        var rId;
        var splval;
        
        if(objId.startsWith('001')){
            obj='Account';
        }else if(objId.startsWith('003')){
            obj = 'Contact';
        }
        component.set('v.obj',obj);
        var accdata = component.get('c.getSObjDetails');
        accdata.setParams({
            "objId":objId,
            "obj" : obj,
        });
        accdata.setCallback(this, function (response){
            if(response.getState()=='SUCCESS'){
                accval = response.getReturnValue();
                component.set('v.sObjectdata',accval);
                var action = component.get('c.getRecordTypeId');
                action.setCallback(this, function (response1){
                    if(response1.getState()=='SUCCESS'){
                        splval = response1.getReturnValue();
                        for(var i=0;i<splval.length;i++ ){
                            if((splval[i].Name ==='Account Instruction') && obj === 'Account'){
                                rType = splval[i].Name;
                                rId = splval[i].Id;
                            }else if((splval[i].Name === 'Contact Instruction') && obj === 'Contact'){
                                rType = splval[i].Name;
                                rId = splval[i].Id;
                            }
                        }
                        component.set('v.rType',rType);
                        component.set('v.rId',rId);
                    }
                });
                $A.enqueueAction(action); 
            }
        });
        $A.enqueueAction(accdata);
    },
    handleSubmit : function(component, event, helper) {
        
    },
    handleSuccess : function(component, event, helper) {
        
         /* var splInst = event.getParam("response");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": splInst.id,
            "slideDevName": "related"
        });
        navEvt.fire();
        helper.showToast(component, event, helper);
      
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "type" : "success",
            "message" : "Special Instruction is successfully created.",
            messageTemplate: "The record '{0}' has been updated successfully.",
            messageTemplateData: [{
                label:event.getParam("response").Id,
                url: event.getParam("response").Id
            }]
        });
        resultsToast.fire();
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();

        */
        $A.get("e.force:closeQuickAction").fire();
            helper.closeModal(component,event);
        	helper.showToast(component,event);
    },
   
})