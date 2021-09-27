({
	recordUpdated : function(component, event, helper) {
		 
       var opptyId= component.get( "v.recordId" );
        var changeType = event.getParams().changeType;
    if (changeType === "ERROR") { 
        alert("Error in loading the record");
    }
    else if (changeType === "LOADED") 
    { 
        var accountId= component.get("v.Oppty.AccountId");
        //console.log("aaa "+ accountId);
        var createRecordEvent = $A.get('e.force:createRecord');
        if ( createRecordEvent ) {
            
            //console.log("bbb "+opptyId);
            createRecordEvent.setParams({
                'entityApiName': 'SFDC_Strategy__c',
                'defaultFieldValues': {
                    'Account__c' : accountId,
                    'Opportunity__c' : opptyId
                }
            });
            $A.get("e.force:closeQuickAction").fire();
            createRecordEvent.fire();
            
        }
        else{
            alert("You are not allowed to create New Strategy");
        }
    }
          
	}
})