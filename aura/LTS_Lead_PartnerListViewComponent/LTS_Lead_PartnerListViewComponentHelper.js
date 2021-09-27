({
      // Fetch the leads from the Apex controller
      getLeadList: function(component) {
        var action = component.get('c.getLeads');
     
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            concole.log(actionresult.getReturnValue());
         component.set('v.leads', actionResult.getReturnValue());
        
        });
        $A.enqueueAction(action);
      }
    })