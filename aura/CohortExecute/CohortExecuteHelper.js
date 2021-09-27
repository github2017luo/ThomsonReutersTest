({
	getCohortResult : function(component,event,helper) {
		var fetchData = component.get('c.dsCreation');
        var recordId = component.get('v.recordId');
        fetchData.setParams({dsId: recordId,dsDataList:null});
        fetchData.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                component.set("v.serverresponse", response.getReturnValue());
                console.log(response.getReturnValue());

            }else{
                alert('Server not responding');
            }
        });
        $A.enqueueAction(fetchData);
	},
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: ($A.get("$Label.c.DVS_True")),
            duration:'1000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
        
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:($A.get("$Label.c.DVS_False")),
            duration:'1000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }
})