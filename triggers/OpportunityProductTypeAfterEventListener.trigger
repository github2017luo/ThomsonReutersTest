trigger OpportunityProductTypeAfterEventListener on Opportunity_Product_Type__c (after delete, after insert, after undelete, after update) {

	if (trigger.isInsert || trigger.isUpdate || trigger.isUnDelete) {
		Set<Id> opportunityIds = OpportunityUtil.getOpportunityIdsFromProductTypes(trigger.new);
		OpportunityUtil.syncRevenueAmounts(opportunityIds);	
	}
	else if (trigger.isDelete) {
		Set<Id> opportunityIds = OpportunityUtil.getOpportunityIdsFromProductTypes(trigger.old);
		OpportunityUtil.syncRevenueAmounts(opportunityIds);
	}
}