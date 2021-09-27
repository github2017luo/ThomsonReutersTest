({
    // Search function after entering value
    searchHelper : function(component,event,getInputkeyWord) {	      
        var action = component.get("c.fetchCampaignValues");       
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'filter' : component.get("v.filter")
        });         
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();             
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                } 
                component.set("v.IconName" , "standard:campaign"); 
                component.set("v.listOfSearchRecords", storeResponse);
            } else if (state === "ERROR"){
                var errors = action.getError();
                if(errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.message", errors[0].message);
                    }
                }
            }
        });      
        $A.enqueueAction(action);
    },
    // Clears the value
    clearValue : function(component,event,helper){
        window.setTimeout( $A.getCallback(function() {  
            var pillTarget = component.find("lookup-pill");
            var lookUpTarget = component.find("lookupField"); 
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            
            component.set("v.SearchKeyWord",null);
            component.set("v.listOfSearchRecords", null );
           component.set("v.selectedCampaignRecord", {} );
            console.log('selected campaign deails-----'+component.get("v.selectedCampaignRecord").Id);
            
        }), 300 );
    }
})