({
	handleRecordUpdated : function(component, event, helper) {
        //var recordId = component.get("v.recordId");
		//var business_unit = component.get("v.sampleQuote.APTS_Proposal_Business_Unit__c");
		//var closeQuickAction = $A.get("e.force:closeQuickAction");
        //closeQuickAction.fire();
        helper.doProcessing(component, event);
	}
})