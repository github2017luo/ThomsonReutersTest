({
	handleRecordUpdated : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        var recordId = component.get("v.recordId");
        var trial_Status = component.get("v.startImmediate.Trial_Status__c");
        var trial_Source = component.get("v.startImmediate.Trial_Source__c");
        var profile_Type = component.get("v.startImmediate.Profile_Type__c");
        var gsi = component.get("v.startImmediate.GSI_Trial__c");
        
        if(gsi==true)
        {
           alert($A.get("$Label.c.GSI"));
        }
        else if(trial_Source == 'SFDC' && (trial_Status =='Invited' || trial_Status =='Rep Initiated') && profile_Type == 'EXISTING_USER_SAME_DOMAIN')
        {
            var action = $A.get('e.force:navigateToURL');
            if(action){
                action.setParams({
                    "url":'/apex/ODT_StartImmediateTrial?id='+recordId+'&action=Resend'
                });
            }
            
            action.fire(); 
        }
        else{
            alert($A.get("$Label.c.ODT_TrialStartImmediate_Error"));
        }
    }
})