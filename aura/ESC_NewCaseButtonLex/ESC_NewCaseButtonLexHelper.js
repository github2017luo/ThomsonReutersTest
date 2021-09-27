({
    showCreateRecordModal : function(component, recordTypeId, entityApiName) {
        var recordId= component.get("v.recordId");
        var createRecordEvent = $A.get("e.force:createRecord");
        if(createRecordEvent){ //checking if the event is supported
            if(recordTypeId){//if recordTypeId is supplied, then set recordTypeId parameter
                createRecordEvent.setParams({
                    "entityApiName": entityApiName,
                    "recordTypeId": recordTypeId,
                    "defaultFieldValues": {
                        "AccountId": recordId
                    }
                    
                });
                createRecordEvent.fire(); 
            }
            else{//else create record under master recordType
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": "Please select record type"
                });
                toastEvent.fire();
            }         
        } else{
            alert('This event is not supported');
        }     
    },
    
    /*closing quickAction modal window */
    
    closeModal : function(){
        var closeEvent = $A.get("e.force:closeQuickAction");
        if(closeEvent){
            closeEvent.fire();
        } else{
            alert('force:closeQuickAction event is not supported in this Ligthning Context');
        }
    },
})