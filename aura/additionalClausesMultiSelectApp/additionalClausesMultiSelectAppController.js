({
    selectedRecords : function(component, event, helper) {
        var selectRecName = event.getParam('selRecords');
        if(selectRecName != undefined) {
            console.log('prec:'+JSON.stringify(selectRecName));
            component.set("v.selectedRecordsList", selectRecName);
        }
    },

    doInit: function(cmp) {
        // Set the attribute value. 
        // You could also fire an event here instead.
        console.log("1");
        var action = cmp.get("c.getdefaultitems");
        console.log("1");
        action.setParams({ 
            ObjectName : "APTS_Additional_Clauses__c",
            fieldName : "APTS_Clause_Title__c",
            recordid : cmp.get("v.recordid")
     });
     console.log("1.2");
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                console.log("1.4"+JSON.stringify(response.getReturnValue()));
                cmp.set("v.selectedRecordsList", response.getReturnValue().savedresult);
                cmp.set("v.searchedRecordsList", response.getReturnValue().searchedresult);
 
            }
            else if (state === "INCOMPLETE") {
                console.log("1.1");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
 
        // optionally set storable, abortable, background flag here
 
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    }
})