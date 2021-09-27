({
    
    handleRecordUpdated : function(component, event, helper) {
       
        var recordId =component.get("v.recordId");
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var sapAccountNum = component.get("v.simpleTrial.ODT_SAP_Account_Number__c");
            var sapContactId = component.get("v.simpleTrial.Contact_id_SAP__c");
            var trialCategory = component.get("v.simpleTrial.ODT_Trial_Product_Category__c");
            var gsi = component.get("v.simpleTrial.GSI_Trial__c");
            var trialId = component.get("v.simpleTrial.Trial_Id__c");   
            
            
            var action1 = component.get("c.UserProfileName");
            action1.setCallback(this, function(response1) {       
                var state1 = response1.getState();
                if (state1 === "SUCCESS") {
                    $A.get("e.force:closeQuickAction").fire();
                    var roleProfile = response1.getReturnValue();                          
                    var userProfile= roleProfile[0];
                    //alert("userProfile "+userProfile);
                    //alert("roleProfile "+roleProfile);
                    
                    if(userProfile == "TR Sales Ops - Lightning" || userProfile == "GLI Sales User" || userProfile == "GLI Sales Ops User" || userProfile == "System Administrator" || userProfile == "TR Sales - Lightning" || userProfile == "TR Sales Ops - Lightning") 
                        
                    {
                        //console.log('aa '+sapAccountNum+ 'bb '+sapContactId+'cc '+trialId);
						if(gsi==true)
						{
							 alert($A.get("$Label.c.GSI"));
						}
                        else if(sapAccountNum==null || sapContactId==null || trialId==null) 
                        {   
                            confirm('This Trial is not eligible to End');
                        }
                        else if(confirm('Are you sure you want to end this trial now?')) 
                        {
                            var action2 = $A.get('e.force:navigateToURL');
                            if(action2){
                                action2.setParams({
                                    "url":'/apex/ODT_trialEnd?id='+recordId
                                });
                            }
                            
                            action2.fire(); 
                        } 
                        
                    } 
                    else 
                    { 
                        alert('You are not eligible to end the trial'); 
                    }
                    
                } 
                
            })
            $A.enqueueAction(action1);
        }
    }                                          
    
})