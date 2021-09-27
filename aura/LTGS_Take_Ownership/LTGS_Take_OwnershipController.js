({
	
    doInit : function(component, event, helper) {

        var opptyId= component.get( "v.recordId" );
       $A.get("e.force:closeQuickAction").fire(); 
        var action1 = component.get("c.returnStageName");
                   action1.setParams({"recordId":opptyId});
                	//console.log("kkk "+action);
                	 action1.setCallback(this, function(response){ 
                        var state = response.getState();
                            if (state === "SUCCESS") {
                         var stageName = response.getReturnValue();
 
                                var action = component.get("c.UserProfileName");
                                 action.setCallback(this, function(response){ 
                                    var state = response.getState();
                                    if (state === "SUCCESS") {
                                     var profileName = response.getReturnValue();    

                     if(profileName==="TR Legal Read-Only User")
                    		{
                              var errorString='You are not allowed to Take Ownership.';

                               var toastEvent = $A.get("e.force:showToast");
                                      if(toastEvent)
                                    {
                                          toastEvent.setParams({
                                          title : 'Error Message',
                                           message: errorString,
                                           duration:'5000',
                                            type: 'error',
                                             mode: 'sticky'
                                                });
                                            toastEvent.fire();
                                            }
                                            else{
                                                alert(errorString);
                                            }
                                $A.get("e.force:closeQuickAction").fire();
                                      }
              else if(stageName=="100%")
        				{

            			console.log("bbb "+probability);
                        var errorString='You are not allowed to take ownership at Stage 100%';
                       var toastEvent = $A.get("e.force:showToast");
                            if(toastEvent)
                            {
                                toastEvent.setParams({
                                    title : 'Error Message',
                                    message: errorString,
                                    duration:'5000',
                                    type: 'error',
                                    mode: 'sticky'
                                });
                            toastEvent.fire();
                            }
                            else{
                                alert(errorString);
                            }
                            $A.get("e.force:closeQuickAction").fire();
        				}
                  else{
                      var action2 = component.get("c.ChangeOwner");
                   action2.setParams({"recordId":opptyId});

                	 action2.setCallback(this, function(response){ 
                        var state = response.getState();
                            if (state === "SUCCESS") {
                             console.log("eee "+ state);   
                         $A.get('e.force:refreshView').fire();
                       $A.get("e.force:closeQuickAction").fire();
                     }
                    });
                		$A.enqueueAction(action2);   
                  }
                                        
                          }
                    });
                        
                $A.enqueueAction(action);      
     
                      }
                    });
                $A.enqueueAction(action1);
        
         
    }
})