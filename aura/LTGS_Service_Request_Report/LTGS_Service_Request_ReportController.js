({
	recordServiceRequest : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") { 
            alert("Error in loading the record");
        }
        else if (changeType === "LOADED") 
        { 
        	var service_request = component.get("v.Oppty.LCRM_Service_Request__c");
            //console.log('aaa '+service_request)
			var action = $A.get('e.force:navigateToURL');
        	if(action){
            	action.setParams({
                	"url":'http://elitedb.int.thomsonreuters.com/ReportServer?%2FSR-GLI%2Fform&SRNumber='+ service_request +'&rc%3AToolbar=False'
            	});
        	}
            
            action.fire();
		}
    }
})