({
    
    doInit : function(component, event, helper) {
        var objId = component.get("v.recordId");
        var obj;
        if(objId.startsWith('001')){
            obj='Account';
        }else if(objId.startsWith('003')){
            obj = 'Contact';
        }
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
                                "Type"     : "Edit Account Fields",
                                "Status"   : "New",
                            	"Origin"   : "Internal Users",
                                "Subject"  : 'Update Account Fields '+ objList[0].Name,
                                "Priority" : 'Medium',
                                "Sales_Org__c": 'GLI',
                                "Owner"	   : objList[0].OwnerID,
                            }
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    createCase.fire(); 
                }else if(obj === 'Contact'){
                    var createCase = $A.get("e.force:createRecord");
                    createCase.setParams({
                        "entityApiName": "Case",
                        "recordTypeId" : recordCaseId,
                        "defaultFieldValues": {
                            "AccountId": objList[0].AccountId,
                            "ContactId": objId,
                            "Type"     : "Edit Contact Fields",
                            "Status"   : "New" ,
                            "Priority" : 'Medium',
                            "Sales_Org__c": 'GLI',
                            "Origin"   : "Internal Users",
                            "Owner"	   : objList[0].OwnerID,
                            "Subject"  : 'Update Contact Fields '+ objList[0].Name
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