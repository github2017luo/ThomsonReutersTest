({  /* On the component Load this function call the apex class method,which will return the list of RecordTypes of object 
    * and set it to the lstOfRecordType attribute to display record Type values on ui:inputSelect component. and for ESC Cases onload it will display error */  
    onload: function(component, event, helper) {
        //action3 to fetch record types where we need to create case
        var action3 = component.get("c.fetchRecordTypeValues");
        action3.setParams({
            "objectName" : "Case"
        });
        
        action3.setCallback(this, function(response) {
            var mapOfRecordTypes = response.getReturnValue();
            if(response.getState()==='SUCCESS'){
                component.set("v.mapOfRecordType", mapOfRecordTypes);
                
                var recordTypeList = [];
                //Creating recordTypeList from retrieved Map
                recordTypeList.push('---None--- ');
                for(var key in mapOfRecordTypes){
                    recordTypeList.push(mapOfRecordTypes[key]);
                    if(recordTypeList.length == 0){//Object does not have any record types                       
                        //Close Quick Action Modal here                        
                        helper.closeModal();
                        //Calling CreateRecord modal here without providing recordTypeId	
                        helper.showCreateRecordModal(component, "", "Case");
                        
                    }	
                    else{
                        component.set("v.lstOfRecordType", recordTypeList);
                    }
                }
            }
            else if (response.getState()==='ERROR') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action3);
    },
    
    /* In this "createRecord" function, first we have call apex class method and pass the selected RecordType values[label] and this "getRecTypeId"
    * apex method return the selected recordType ID.
    * When RecordType ID comes, we have call  "e.force:createRecord" event and pass object API Name and 
    * set the record type ID in recordTypeId parameter. and fire this event if response state is not equal = "SUCCESS" then display message on various situations.
    */
    createRecord: function(component, event, helper) {
        var recordTypeLabel = component.find("selectid").get("v.value");
        if(recordTypeLabel != ""){
            var selectedRecordTypeMap = component.get("v.mapOfRecordType");
            var selectedRecordTypeId;
            //finding selected recordTypeId from recordTypeName
            for(var key in selectedRecordTypeMap){
                if(recordTypeLabel == selectedRecordTypeMap[key]){
                    selectedRecordTypeId = key;//match found, set value in selectedRecordTypeId variable
                    break;
                }
            }
            helper.closeModal();
            //Calling CreateRecord modal here without providing recordTypeId
            helper.showCreateRecordModal(component, selectedRecordTypeId, "Case");
        }
        else{
            alert('You did not select any record type');
        }
    },
    
    closeModal: function(component, event, helper) {
        helper.closeModal();
    },
})