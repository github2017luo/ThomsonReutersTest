({
	handleRecordUpdated : function(component, event, helper) {
		var recordId =component.get("v.recordId");
        //alert("RecordId" + recordId);
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var approval_Stage = component.get("v.sampleQuote.Apttus_Proposal__Approval_Stage__c");
            var business_unit = component.get("v.sampleQuote.APTS_Proposal_Business_Unit__c");
            var reason = component.get("v.sampleQuote.Latam_APTS_Reason__c");
            var order_is_created = component.get("v.sampleQuote.APTS_Order_Is_Created__c");
            console.log("Approval Stage"+ approval_Stage);
            //var recordTypeId = component.get("v.sampleQuote.RecordTypeId");
            var recordTypeName = component.get("v.sampleQuote.RecordType.Name");
            				if(order_is_created){
                                message="The order has already been submitted!!! Cannot be re-submitted!!!";
                                var type= "ERROR";
                                helper.showToast(component,event,helper,message,type);
                                $A.get("e.force:closeQuickAction").fire();
                            }
                            else if(approval_Stage == "Accepted"){
                                var message = $A.get("$Label.c.LTGC_OrderSubmit");
                                var type= "SUCCESS";                                
                                helper.showToast(component,event,helper,message,type); 
                                //alert(message);
                                $A.get("e.force:closeQuickAction").fire();
                            }
                            else if(approval_Stage != "Generated" && recordTypeName != "SpecialOffer"){
                                var message = $A.get("$Label.c.LTGC_OrderContract");
                                var type= "ERROR";
                                //alert(SubmitOrderContract);
                                helper.showToast(component,event,helper,message,type);
                                $A.get("e.force:closeQuickAction").fire();
                            }
            				else if(reason == null || reason == ''){
                                var message = $A.get("$Label.c.LTGC_TaxReason");
                                var type= "ERROR";
                                helper.showToast(component,event,helper,message,type);
                                $A.get("e.force:closeQuickAction").fire();
                            }
                            else {
                                var callSubmitOrder = component.get("c.submitOrder");
                                if(callSubmitOrder){
                                    callSubmitOrder.setParams({
										"proposalId":recordId
                                    });
                                }
                                console.log('bbb');
								callSubmitOrder.setCallback(this, function(response1){
                                    console.log('in else method');
										var state1 = response1.getState();
                                    //alert("callSubmitOrder-State:"+state1);								
									if (state1 === "SUCCESS") { 
                  						//$A.get("e.force:closeQuickAction").fire();
                                        var message = response1.getReturnValue();
                                        	if(message == 'Order submitted successfully!!!'){
                                            	var type="SUCCESS";
                                            	helper.showToast(component,event,helper,message,type);
                                        	}
                                            else if(message == 'WARNING:Your order is NOT yet complete! Please go fill out the Client Order Brief, after completion of the COB your order will be submitted for processing.'){
                                                var type = 'WARNING';
                                                helper.showToast(component,event,helper,message,type);
                                            }
                                            else{
                                        		var type="ERROR";
                                        		//alert("Result:"+message);
                                        		helper.showToast(component,event,helper,message,type);  
                                            }
                                        $A.get("e.force:refreshView").fire();
                                        $A.get("e.force:closeQuickAction").fire();
                                    }
                                    else{
                                        message="Encountered system error, please try again";
                            			//alert("Encountered system error, please try again");
                                        helper.showToast(component,event,helper,message);
                                        $A.get("e.force:closeQuickAction").fire();
                        				}
                                })
									$A.enqueueAction(callSubmitOrder);
        							
                                }
	}
 }
})