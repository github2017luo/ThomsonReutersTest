({
    
    doInit : function(component, event, helper) {
        var objId = component.get("v.recordId");
        var obj='Account';
       
       var action = component.get("c.getSObjDetails");
        action.setParams({
            "objId": objId,
            "obj" : obj
        });
        var recordCaseId;
        var action1 = component.get("c.getCaseRecordTypeID");
    	action1.setCallback(this, function(response1) {
        var state = response1.getState();
            if (state === "SUCCESS") {
                  recordCaseId = response1.getReturnValue();
                 component.set("v.recordCaseId",recordCaseId);
            }
            else {
                console.log("Failed with state: " + state);
            }
    	});

   		 $A.enqueueAction(action1);
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var objList = response.getReturnValue();
                component.set("v.sObjList",objList);
                if(obj === 'Account'){
                    var createCase = $A.get("e.force:createRecord");
 //var RecTypeID  = response.getReturnValue();
                    createCase.setParams({
                        "entityApiName": "Case",
                        "recordTypeId" : recordCaseId,
                        "defaultFieldValues": {
                            "AccountId": objId,
                            "Type"     : "Activate Account",
                            "Status"   : "New" ,
                            "Origin"   : "Internal Users",
                            "Subject"  : 'Account Reactivation Request '+ objList[0].Name
                        }
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    createCase.fire(); 
                }
            }else{
                alert('Error in fetching account/contact info, please contact system administrator');
            }
        });
        $A.enqueueAction(action);
    },
    
})