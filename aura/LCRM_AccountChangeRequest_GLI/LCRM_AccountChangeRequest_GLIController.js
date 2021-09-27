({
    handleSubmit : function(component, event, helper) {
       event.preventDefault();
        component.set("v.Spinner", true);
        var eventFields = event.getParam("fields");
		eventFields["Status"] = "New";
        eventFields["Priority"] = "Medium";
        eventFields["Type"] = "Edit Account Fields";
        eventFields["Origin"] = "Internal Users";
        eventFields["Sales_Org__c"] = "GLI";
        
        var recordCaseId;
        var action1 = component.get("c.getCaseRecordTypeID");
        action1.setCallback(this, function(response1) {
            var state = response1.getState();
            if (state === "SUCCESS") {
                recordCaseId = response1.getReturnValue();
                component.set("v.recordCaseId",recordCaseId);
                eventFields["RecordTypeId"] = recordCaseId;
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action1);
        
        component.find("editForm").submit(eventFields);
    },
    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id;
        var navEvt = $A.get("e.force:navigateToSObject");
	    navEvt.setParams({
      "recordId": myRecordId,
      "slideDevName": "related"
    });
    navEvt.fire();
        /*var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        "mode": 'sticky', 
        "duration":' 5000',    
        "title": "Success --!",
        "message": "The case has been successfully saved and assigned to the appropriate user or queue according to the active assignment rule.You no longer have access to view or edit this case."
    });
    	toastEvent.fire();
        $A. get("e.force:closeQuickAction").fire();*/
    },
    handleError : function(component, event, helper) {
        /*var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        "mode": 'sticky', 
        "duration":' 5000',    
        "title": "Success!",
        "message": "The case has been successfully saved and assigned to the appropriate user or queue according to the active assignment rule.You no longer have access to view or edit this case."
    });
    toastEvent.fire();
        $A. get("e.force:closeQuickAction").fire();*/
    },
    doInit: function(component, event, helper) {
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
        var status = response.getState();
            if (status === "SUCCESS") {
                var objList = response.getReturnValue();
                component.set("v.accName",objList[0].Name);
                component.set("v.caseSubject","Update Account Fields "+objList[0].Name+"");
                console.log('act name:'+component.get("v.accName"));
                //component.set("recordTypeId",recordCaseId);
                
            }else if(status === "ERROR"){
                
            }else{
                alert('Please contact System administrator');
            }
        });
         
         $A.enqueueAction(action);
   },
   showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    }
    
   
})