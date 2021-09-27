({
    init : function(comp, event, helper) {
        
        var recordTypeId = comp.get("v.pageReference").state.recordTypeId;
        var pageRef = comp.get("v.pageReference");
        var state = pageRef.state; // state holds any query params
        var base64Context = state.inContextOfRef;
        
        /*
            *For some reason, the string starts with "1.", if somebody knows why,
            *this solution could be better generalized.
        */
         if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
       
        var accId= addressableContext.attributes.recordId;
        //alert('account id'+accId);
		
        if (accId ==="" || accId === "undefined" || $A.util.isEmpty(accId)) {
            //alert('entered');
            comp.set("v.errors", "New contacts should be created from an account record. Please search for the appropriate account to create the new contact. If an account does not exist, please create a lead record.: ");
        } 
        else{
    
   	 //var accId= addressableContext.attributes.recordId;
        
        var createRecordEvent = $A.get("e.force:createRecord");
         createRecordEvent.setParams({
            "entityApiName": "Contact",
            "recordTypeId": recordTypeId,
            "defaultFieldValues": {
                        			'AccountId' : accId
                    		}
        });

        createRecordEvent.fire();
    }
    
    }
})