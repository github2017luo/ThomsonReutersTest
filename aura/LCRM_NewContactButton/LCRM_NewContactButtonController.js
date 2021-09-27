({
    doInit : function(component, event, helper) {
        var objId = component.get("v.recordId");   
        //alert('objId'+objId);
        $A.get("e.force:closeQuickAction").fire();
        var conrecordId;
        /*var action1 = component.get("c.getContactRecordTypeID");
        //alert('action1'+action1);
         //var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        //alert('recordTypeId'+recordTypeId);
    	action1.setCallback(this, function(response1) {
            //alert('1');
        var state = response1.getState();
            //alert('state'+state);
            if (state === "SUCCESS") {
                //alert('2');
                  conrecordId = response1.getReturnValue();
                //alert('3');
                 component.set("v.conrecordId",conrecordId);
                //alert('4');
            }
            else {
                console.log("Failed with state: " + state);
            }
    	});

   		 $A.enqueueAction(action1);*/
		/*var action = component.get("c.getAccountDetails");
        action.setParams({
            "objId": objId
             
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var objList = response.getReturnValue();
                alert('11'+objlist);
                component.set("v.sObjList",objList);*/
                    var createOpp = $A.get("e.force:createRecord");
                
                    createOpp.setParams({
                        "entityApiName": "Contact",
                        //"recordTypeId" : recordTypeId,
                        "defaultFieldValues": {
                            "AccountId": objId,
                        }
                   });
                //$A.get("e.force:closeQuickAction").fire();
                    createOpp.fire(); 
                
            //}else{
               // alert('Error in fetching recordType info, please contact system administrator');
            //}
        //});
        //$A.enqueueAction(action);
    },
})