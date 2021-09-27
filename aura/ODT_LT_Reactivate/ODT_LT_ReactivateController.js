({
    
    handleRecordUpdated : function(component, event, helper) {
  
        var recordId =component.get("v.recordId");
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var trialLead = component.get("v.simpleTrial.Contact_LeadId__c");
            var isLeadConverted = component.get("v.simpleTrial.Is_Lead_Converted__c");
            var trialStatus = component.get("v.simpleTrial.Trial_Status__c");
            var trialSource = component.get("v.simpleTrial.Trial_Source__c");   
            var trialId = component.get("v.simpleTrial.Trial_Id__c");
            var trialEndReason = component.get("v.simpleTrial.Early_End_Reason__c");
            var gsi = component.get("v.simpleTrial.GSI_Trial__c");
            var action1 = component.get("c.UserProfileName");
            action1.setCallback(this, function(response1) {       
                var state1 = response1.getState();
                if (state1 === "SUCCESS") {
                    $A.get("e.force:closeQuickAction").fire();
                    var roleProfile = response1.getReturnValue();                          
                    var userRole= roleProfile[1];       
                    var userProfile= roleProfile[0];
                    
                  if(userProfile == "TR Sales Ops - Lightning" || userProfile == "GLI Sales User" || userProfile == "GLI Sales Ops User" || userProfile == "System Administrator" || userProfile == "TR Sales - Lightning" || userProfile == "TR Sales Ops - Lightning" || (trialStatus=='Ended' && trialEndReason=='Trial Abuse' && ("{!$UserRole.Name}"!="{!$Label.ODT_Trial_Manager_Role}"))) 
                        
                    {
                        if(gsi==true)
                        {
                             alert($A.get("$Label.c.GSI"));
                        }
                        else if(trialStatus==null || trialSource==null || trialId==null) 
                        { 
                            
                            alert('This Trial is not eligible for reactivation');
                        }
                        else if(trialLead!=null && isLeadConverted==false && userRole != $A.get("$Label.c.ODT_Trial_Manager_Role")) 
                        {
                            alert('Please convert the lead associated to this trial before reactivating'); 
                            
                        } 
                            else 
                            { 
                                var action2 = $A.get('e.force:navigateToURL');
                                    if(action2){
                                        action2.setParams({
                                            "url":'/apex/ODT_TrialReactivate?id='+recordId
                                    });
                                }
                                
                                action2.fire(); 
                            } 
                    }} 
                else 
                { 
                    alert('You are not eligible to reactivate the Trial'); 
                }
                
            })
            $A.enqueueAction(action1);
        }
    }                                          
    
})