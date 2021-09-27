({
    openOrders : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        //alert(JSON.stringify(event));
        window.open('/apex/LCRMOrderService?Id=' + recordId,'_blank');
    },
    
    closeAction: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})