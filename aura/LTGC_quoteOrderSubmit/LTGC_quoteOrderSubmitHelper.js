({
	showToast : function(component,event,helper,message,type) {
        
        //alert('helper inside'+type+'message:'+message);
        var toastEvent1 = $A.get("e.force:showToast");
        toastEvent1.setParams({
            "type" : type,
            "mode" : "sticky",
            "message": message
        });
        toastEvent1.fire();      
    }
})