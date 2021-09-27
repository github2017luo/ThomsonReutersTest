({
    init : function(comp, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
         var recordTypeId = comp.get("v.pageReference").state.recordTypeId;
        
        createRecordEvent.setParams({
            "entityApiName": "Account",
            "recordTypeId": recordTypeId,
        });

        createRecordEvent.fire();
    }
})