({
    doInit : function(component, event, helper) {
        var records;
        var msg;
        var currentUserId= $A.get("$SObjectType.CurrentUser.Id");
        var recordId= component.get("v.recordId");
        var action = component.get("c.getProposal");
        action.setParams({"recordId":recordId});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
                records= response.getReturnValue();
                if(records.length>0)
                {
                    var optyOwnerId = records[0].Apttus_Proposal__Opportunity__r.OwnerId;    
                    var optyOwnerName = records[0].Apttus_Proposal__Opportunity__r.Owner.Name;
                    if(currentUserId != optyOwnerId){
                        var errorString='Only the Opportunity owner can expire the Digital Proposals. '+optyOwnerName + ' is the Opportunity owner';
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
                        var action1 = component.get("c.updateSuccess");
                        action1.setParams({listProposal:records,
                                           recordId:recordId});
                        action1.setCallback(this,function(response){
                            
                            var state=response.getState(); 
                            if(state==="SUCCESS"){
                                
                                var result=response.getReturnValue();
                                $A.get("e.force:closeQuickAction").fire(); 
                                var toastEvent = $A.get("e.force:showToast");
                                if(toastEvent)
                                {
                                    if(result==0)
                                    {
                                        msg= $A.get("$Label.c.LTGS_Expire_Proposal_Success");
                                        toastEvent.setParams({
                                            title : 'Error Message',
                                            message: msg,
                                            duration:'5000',
                                            type: 'success',
                                            mode: 'sticky'
                                        });
                                    }
                                    else
                                    {
                                        if(result==2)
                                            msg= $A.get("$Label.c.LTGS_Expire_All_Proposal_update_error");
                                        else if(result==3)
                                        	msg= $A.get("$Label.c.LTGS_Expire_All_Proposal_Opty_update_error");
                                        else
                                            msg= $A.get("$Label.c.LTGS_Expire_All_Proposal_Exception");
                                            
                                        toastEvent.setParams({
                                            title : 'Error Message',
                                            message: msg,
                                            duration:'5000',
                                            type: 'error',
                                            mode: 'sticky'
                                        });  
                                    }
                                    
                                    toastEvent.fire();
                                } 
                            }
                            else{
                                msg= $A.get("$Label.c.LTGS_Expire_All_Proposal_Exception");
                                alert(msg);
                            }
                        });
                        $A.enqueueAction(action1);
                        
                    }
                }
                else
                {
                    var errorString='There are No/Valid Digital Proposals to expire on this Opportunity..!!';
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
            }
        });
        $A.enqueueAction(action);
        //$A.get("e.force:closeQuickAction").fire();
    }
})