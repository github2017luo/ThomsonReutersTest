({
	refreshPage: function(component, event, helper){
        console.log("in refresh page method");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response1) {
            console.log(response1);
            if(response1 == true){
                console.log("in console");
                workspaceAPI.getFocusedTabInfo().then(function(response2) {
                    var focusedTabId = response2.tabId;
                    workspaceAPI.refreshTab({
                        tabId: focusedTabId,
                        includeAllSubtabs: true
                    });
                });
            }
            else
            {
                console.log("not in console");
                $A.get("e.force:refreshView").fire();
            }
        });
    }
})