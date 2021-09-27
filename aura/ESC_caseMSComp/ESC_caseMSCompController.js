({
doInit : function(component, event, helper) {
    
 var recID = component.get("v.recordId");
    //alert('recID');
var action = component.get("c.getCaseMS");
action.setParams({
"caseId": recID

});
   
action.setCallback(this, function(a) {
component.set("v.caseMSTable", a.getReturnValue());
});
$A.enqueueAction(action);
},
    
    handleClick: function (component, event, helper) {
		
        var navEvt = $A.get("e.force:navigateToSObject");
        var recid = event.target.id;
        //alert('recid'+recid);
		//alert(component.get("v.caseMSTable")[0].Id);
        navEvt.setParams({
            "recordId": recid
            //component.get("v.caseMSTable")[0].Id
        });

        navEvt.fire();

    }

})