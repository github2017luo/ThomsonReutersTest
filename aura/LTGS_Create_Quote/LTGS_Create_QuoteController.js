({
 doInit : function(component, event, helper) {
        var recordId= component.get("v.recordId");
        var recordName='CW.CreateQuote';
        var success= true;
        var strArray=[];
        
        
     			 		var action = component.get("c.getCustomSettings");
                           action.setParams({"recordName":recordName});
                           console.log('111 '+success);
                		   action.setCallback(this, function(response1) {       
                			var state = response1.getState();
                    		if (state === "SUCCESS") {
                                  console.log('333 '+state);
                                  var url = response1.getReturnValue();
                                            
                           var action1 = component.get("c.optyDetails");
                           //console.log('222 '+recordName);
                            action1.setParams({"recordId":recordId});
                               action1.setCallback(this, function(response1) {       
                                    var state = response1.getState();
                                        if (state === "SUCCESS") {
                            
                            var Oppty = response1.getReturnValue();
                            var opportunityID18= Oppty.OpportunityID18__c;
                             
                             $A.get("e.force:closeQuickAction").fire();
                                    
                                var stageName= Oppty.StageName;
                                if(stageName=='Closed Lost' || stageName=='Order Complete')
                                {
                                     strArray.push('Opportunity Stage should not be Closed Lost or Order Complete');
                                    success= false;
                                }
                                
                                var transactionType= Oppty.LCRM_Transaction_Type__c;
                                if(transactionType==null)
                                {
                                    strArray.push('Transaction Type is required'); 
                                    success = false;
                                }
                                var status= Oppty.LCRM_Status__c;
                                if(status== 'Cancelled' || status== 'Terminated' || status== 'Suspended')
                                {
                                    strArray.push('Opportunity Status should not be Cancelled, Terminated or Suspended'); 
                                    success = false;
                                }
                                var productCount= Oppty.LCRM_Product_Count__c;
                                if(productCount==0)
                                {
                                    strArray.push('Opportunity Product count should be atleast 1'); 
                                    success = false; 
                                }
                                        var errorString=''; 
                                        for(var i=0;i < strArray.length ; i++){ 
                                         //alert('error is '+strArray[i] ); 
                                         errorString +=(i+1)+'.'+ ' '+ strArray[i] + '\n';
                                        }    
                                if(!success){ 
               
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
                                              }    
                                
                              else{

                                       var action2 = $A.get('e.force:navigateToURL');
                                            if(action2){
                                                action2.setParams({
                                                    "url":url+opportunityID18
                                                    });
                                                }
                        
                                                action2.fire();  
                                        }
                            
                          }
                        });
                			$A.enqueueAction(action1);     
       					}
                      else {
                                alert('Contract Wizard records not present in Custom Setting. Please contact your System Admin');
                            }
    			});
                $A.enqueueAction(action);               
        },           
})