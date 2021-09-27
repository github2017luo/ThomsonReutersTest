({    
    
    handleRecordUpdated : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        var recordId =component.get("v.recordId");
        
        
        
        var trial_Status = component.get("v.checkNCJ.Trial_Status__c");
        
       
        if(trial_Status =='Entitlement Error')
        {
            var action = $A.get('e.force:navigateToURL');
            if(action){
                action.setParams({
                    "url":'/apex/NCJCreateEntitlementINC?id='+recordId
                });
            }
            
            action.fire(); 
        }
        else{
            alert($A.get("This Invited Colleague is not eligible for entitlement"));
        }
    }
})