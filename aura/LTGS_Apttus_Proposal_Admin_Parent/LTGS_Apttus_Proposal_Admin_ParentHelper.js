({
    helperOrderId : function(component,  Apttus_Proposal__Approval_Stage__c) {
        var action = component.get("c.getApttus_Config2_OrderId");
        console.log('The user has access to the required permission set to invoke the order submission');
        action.setParams({
            "ProposalId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if (response.getState() === 'SUCCESS'){
                var Apttus_Config2_Order_Id = action.getReturnValue();
                if ((Apttus_Proposal__Approval_Stage__c !='Accepted')||(Apttus_Config2_Order_Id > 0)) {                 
                    
                    this.showToast("warning", "sticky", "The order cannot be submitted!!!");
                    console.log('The order cannot be submitted, either the proposal is not in accepted stage or the order is already submitted');
                    // alert('The order cannot be submitted!!!');
                    $A.get("e.force:closeQuickAction").fire();
                } 
                else {
                    var action1 = component.get("c.acceptQuote");
                    action1.setParams({
                        "ProposalId" : component.get("v.recordId")
                    });
                    action1.setCallback(this, function(response1){
                        if (response1.getState() === 'SUCCESS'){
                            var result = action.getReturnValue();
                            
                            this.showToast("success", "sticky", "The order submitted Successfully !!!");
                            //alert('The order submitted Successfully !!!');
                            this.reloadRecord();
                            $A.get("e.force:closeQuickAction").fire();
                        }else {
                            this.showToast("error", "sticky", "Encountered system error, please try again");
                            console.log('Error occured while calling the Apttus class which is responsible for order creation, please check if the user has required permission set access');
                            //alert("Encountered system error, please try again");
                            $A.get("e.force:closeQuickAction").fire();
                        }
                    })
                    $A.enqueueAction(action1);    
                }  
            } 
        })
        $A.enqueueAction(action);
    },
    reloadRecord : function() {
        $A.get("e.force:refreshView").fire();
        
    },
    
    showToast : function(type, mode, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "mode" : mode,
            "message": message
        });
        toastEvent.fire();
        
    }
})