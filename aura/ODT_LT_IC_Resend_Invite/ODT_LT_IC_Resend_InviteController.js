({    
    
    handleRecordUpdated : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        var recordId =component.get("v.recordId");
        var Trial_Status = component.get("v.resendInvite.Trial_Status__c");
        
        
        if(Trial_Status =='Invited')
        {
            var action = $A.get('e.force:navigateToURL');
            if(action){
                action.setParams({
                    "url":'/apex/ODTResendInviteINC?id='+recordId
                });
            }
            
            action.fire(); 
        }
        else{
            alert($A.get("This Trial is not eligible to resend invitation"));
        }
    }
})