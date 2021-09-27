({
    doInit: function(component, event, helper) {
        
        //helper.getLeadList(component);
        component.set("v.leadListViewName",$A.get("$Label.c.LTS_PartnerLeadListView"));
    },
    
    
    createlead: function(component, event, helper){
      
        var createRecordEvent = $A.get("e.force:createRecord");
       
        createRecordEvent.setParams({
            "entityApiName": "Lead"            
        });
       
        createRecordEvent.fire();
        
        
    }
    
})