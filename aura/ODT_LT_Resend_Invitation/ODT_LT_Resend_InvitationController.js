({    
    
    handleRecordUpdated : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        var recordId =component.get("v.recordId");
        var Trial_Status = component.get("v.simpleTrial.Trial_Status__c");
        var Trial_Source = component.get("v.simpleTrial.Trial_Source__c");
        var gsi = component.get("v.simpleTrial.GSI_Trial__c");
        
        if(gsi==true)
        {
            alert($A.get("$Label.c.GSI"));
        }
        else if(Trial_Source == 'SFDC' && (Trial_Status =='Invited' || Trial_Status =='Rep Initiated' || Trial_Status =='Bounceback' || Trial_Status =='Timed-out'))
        {
            var action2 = $A.get('e.force:navigateToURL');
            if(action2){
                action2.setParams({
                    "url":'/apex/ODT_TrialReInitiatePage?id='+recordId+'&action=Resend'
                });
            }
            
            action2.fire(); 
        }
        else{
            alert($A.get("$Label.c.ODT_TrialReinitiation_Error"));
        }
    }
})