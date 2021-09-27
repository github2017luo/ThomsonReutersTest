({
    openSubscriptions : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        //alert(JSON.stringify(event));
        window.open('/apex/LCRMSubscriptions?Id=' + recordId,'_blank');
    },
    
    closeAction: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})