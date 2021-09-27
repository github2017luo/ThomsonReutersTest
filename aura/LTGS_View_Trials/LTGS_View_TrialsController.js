({
  doInit : function(component, event, helper) {
        var recordId= component.get("v.recordId");
        var action = component.get("c.getCustomSettings");
        var recordName='LCRM_ViewTrails_TW';
      
        action.setParams({"recordName":recordName});
                action.setCallback(this, function(response1) {       
                var state = response1.getState();
                    if (state === "SUCCESS") {
              
                  var url = response1.getReturnValue();
                   var action1 = component.get("c.optyDetails");
                   //console.log('222 '+recordName);
                    action1.setParams({"recordId":recordId});
                            action1.setCallback(this, function(response1) {       
                            var state = response1.getState();
                                if (state === "SUCCESS") {
                            
                            var Oppty = response1.getReturnValue();
                            var opportunityID18= Oppty.OpportunityID18__c;
                           //console.log('555 '+opportunityID18);
                             $A.get("e.force:closeQuickAction").fire();
                            var action2 = $A.get('e.force:navigateToURL');
                        if(action2){
                        action2.setParams({
                            "url":url+opportunityID18
                        });
                    }
                        action2.fire();
                    }   
    			});
                $A.enqueueAction(action1);               
            	}
            else {
                alert('Trail Wizard records not present in Custom Setting. Please contact your System Admin');
            		}
    		});
                $A.enqueueAction(action);
        
                
    }
})