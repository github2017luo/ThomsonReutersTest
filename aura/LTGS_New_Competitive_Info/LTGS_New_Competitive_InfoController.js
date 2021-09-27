({
	recordUpdated : function(component, event, helper) {
		 
       var opptyId= component.get( "v.recordId" );
        //alert('Record id'+opptyId);
        var changeType = event.getParams().changeType;
    /*if (changeType === "ERROR") { 
        alert("Error in loading the record");
    }
    else if (changeType === "LOADED") 
    { */
         var accountCheck = opptyId.startsWith("001");
        if(accountCheck){
            
            var createRecordEvent = $A.get('e.force:createRecord');
        	if ( createRecordEvent ) {
            createRecordEvent.setParams({
                'entityApiName': 'Competitive_Info__c',
                'defaultFieldValues': {
                    'Account__c' : opptyId
                    
                }
            });
            $A.get("e.force:closeQuickAction").fire();
            createRecordEvent.fire();
            
        }
            
            
        } else {
        
        var accountId= component.get("v.Oppty.AccountId");
        //console.log("aaa "+ accountId);
        var createRecordEvent = $A.get('e.force:createRecord');
        if ( createRecordEvent ) {
            
            //console.log("bbb "+opptyId);
            createRecordEvent.setParams({
                'entityApiName': 'Competitive_Info__c',
                'defaultFieldValues': {
                    'Account__c' : accountId,
                    'Opportunity__c' : opptyId
                }
            });
            $A.get("e.force:closeQuickAction").fire();
            createRecordEvent.fire();
            
        }
        else{
            alert("You are not allowed to create New Competitive Info");
        }
        }}
          
	//}
})