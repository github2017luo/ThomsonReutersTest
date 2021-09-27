({
	doProcessing : function(component, event) {
        var recordId = component.get("v.recordId");
        var business_unit = component.get("v.sampleQuote.APTS_Proposal_Business_Unit__c");
        var urlEvent = $A.get("e.force:navigateToURL");
		if(business_unit == 'Tax Professional'){
            urlEvent.setParams({
                    "url": "/apex/Tax_APTS_Online_Contact?id="+recordId
            });
            urlEvent.fire();
        }
        else{
            urlEvent.setParams({
                    "url": "/apex/OnlineContacts?id="+recordId
            });
            urlEvent.fire();
        }
	}
})