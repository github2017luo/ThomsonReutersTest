({
	gotoURL : function(component, event, helper) {
		var recordId = component.get('v.recordId');
        
        window.open('/00O4O0000042upF?pv0=' + recordId,'_blank');
     	 
	},
    
    doneRendering: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})