({
    doInit: function(comp, event, helper) {
        //alert('hi');        
        //var recordTypeId = comp.get("v.pageReference").state.recordTypeId;
        var pageRef = comp.get("v.pageReference");
        //alert('h1i');
        var state = pageRef.state; // state holds any query params
        var base64Context = state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));       
        var objId= addressableContext.attributes.recordId;
        //alert('account id'+objId);
		var obj;
        if (objId ==="" || objId === "undefined" || $A.util.isEmpty(objId)) {
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Lead"
            });
            createRecordEvent.fire();
        } 
        else{
    
			 if(objId.startsWith('001')){
					obj='Account';
				}else if(objId.startsWith('003')){
					obj = 'Contact';
				}else if(objId.startsWith('701')){
                    obj = 'Campaign';
                }
//alert('hi'+obj)        ;
        var createRecordEvent = $A.get("e.force:createRecord");
            if(obj=='Account'){
         createRecordEvent.setParams({
            "entityApiName": "Lead",            
            "defaultFieldValues": {
               
                        			'Account__c' : objId
            
                    		}
         });}
            if(obj=='Contact'){
         createRecordEvent.setParams({
            "entityApiName": "Lead",            
            "defaultFieldValues": {
               
                        			'Contact__c' : objId
            
                    		}
         });}
            if(obj=='Campaign'){
         createRecordEvent.setParams({
            "entityApiName": "Lead",            
            "defaultFieldValues": {
               
                        			'Primary_Campaign_Source__c' : objId
            
                    		}
         });}

        createRecordEvent.fire();
    }
    
    }
    
})