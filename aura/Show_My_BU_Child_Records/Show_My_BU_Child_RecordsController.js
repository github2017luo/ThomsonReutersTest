({
        doInit : function(component, event, helper) {
            var recordId = component.get("v.recordId");  
            var action1=component.get("c.GLIServiceUserCheck");
               var resultgli;
                action1.setCallback(this, function(response1) {
                  var state = response1.getState();
                    if (state === "SUCCESS") {
                     resultgli= response1.getReturnValue();
                    } 
                else {
                    console.log("Failed with state: " + state);
                }
               
                });
                $A.enqueueAction(action1);
         
            
            var action = component.get("c.UserProfileName");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    $A.get("e.force:closeQuickAction").fire();
                    var profileName = response.getReturnValue(); 
                  
                    if( resultgli===true || profileName==="GLI Sales User" || profileName==="GLI Sales Ops User" || profileName==="GLI Read Only" || profileName==="GLI Marketing User" || profileName==="ANZ Users" || profileName==="System Administrator" || profileName==="LMS - User" || profileName==="Elite User" || profileName==="UKI Users" || profileName==="DQA User" || profileName=="Elite Sales Ops" || profileName==="UKI Sales Ops" || profileName==="GLI Marketing User" || profileName==="GLI Read Only"
                     || profileName==="USL Helpdesk Agent" || profileName==="USL Accountable Resolver" || profileName==="USL Helpdesk Manager"|| profileName==="USL Hybrid Agent"|| profileName==="GLI Helpdesk Agent"|| profileName==="GLI Helpdesk Manager" || profileName==="TR Sales - Lightning")
                    {
                        var action = $A.get('e.force:navigateToURL');
                        if(action){
                            action.setParams({
                                "url":'/apex/LCRMControlOnDemandShare?Id='+ recordId +'&Operation=unShare'
                            });
                        }
                        
                        action.fire();
                    }
                    else
                    {
                        var errorString='You do not have permission to perform this action';
                        var toastEvent = $A.get("e.force:showToast");
                        if(toastEvent)
                        {
                            toastEvent.setParams({
                                title : 'Error Message',
                                message: errorString,
                                duration:'5000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();
                        }
                        else{
                            alert(errorString);
                        }
                        $A.get("e.force:closeQuickAction").fire();
                    }
                }
            })
            $A.enqueueAction(action);
        },
        
})