({
	navigateToCase : function(component, newCaseID) {
		console.log("in navigate Case method");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response1) {
            console.log(response1);
            if(response1 == true){
                console.log("in console");
                workspaceAPI.getFocusedTabInfo().then(function(response2) {
                    var parentId = response2.tabId;
                    workspaceAPI.openSubtab({
                        parentTabId: parentId,
                        recordId: newCaseID,
                        focus: true
                    });
                    
                    
                });
            }
            else
            {
                console.log("not in console");
                var sObjectEvent = $A.get("e.force:navigateToSObject");
                sObjectEvent.setParams({
                    "recordId": newCaseID
                })
                sObjectEvent.fire();
                //$A.get("e.force:refreshView").fire();
            }
        });
	}
})