({
    doInit : function(component, event, helper) {
        var objId = component.get("v.recordId");              
        var recordOppId;
        var action1 = component.get("c.getOppRecordTypeID");
    	action1.setCallback(this, function(response1) {
        var state = response1.getState();
            if (state === "SUCCESS") {
                  recordOppId = response1.getReturnValue();
                 component.set("v.recordOppId",recordOppId);
            }
            else {
                console.log("Failed with state: " + state);
            }
    	});

   		 $A.enqueueAction(action1);
        
        var action = component.get("c.getSObjDetails");
        action.setParams({
            "objId": objId
             
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var objList = response.getReturnValue();
                component.set("v.sObjList",objList);
                    var createOpp = $A.get("e.force:createRecord");
                    createOpp.setParams({
                        "entityApiName": "Opportunity",
                        "recordTypeId" : recordOppId,
                        "defaultFieldValues": {
                            "AccountId": objList[0].AccountId,
                            "Key_Contact__c": objId,
                            "ForecastCategoryName" : "Pipeline"
                        }
                   });
                $A.get("e.force:closeQuickAction").fire();
                    createOpp.fire(); 
                
            }else{
                alert('Error in fetching recordType info, please contact system administrator');
            }
        });
        $A.enqueueAction(action);
    },
})