trigger CustomAssetlineitemtrigger on Apttus_Config2__AssetLineItem__c(before insert,after insert,after update, before update) 
{    
	//Added by Kruti Shah for DOC-9128
    Boolean isBulkLoad=false;
    Boolean isTestrun=false;
    
    if(!Test.isRunningTest()){
        isTestrun=false;
        GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());        
        if(loadValues!=null && (loadValues.APTS_Disable_Triggers__c)) isBulkLoad=true;
    }else{        
        isTestrun=true;        
    }
    //End of trigger Deactivate logic
	
	if(isTestrun || (isTestrun== false && isBulkLoad ==false))
    {
		if(trigger.isInsert && trigger.isBefore)
		{        
			System.debug('Kh***Before insert called from trigger');
			APTS_AssetLineItemTriggerHandler.onBeforeInsert(trigger.new,trigger.OldMap);
		}
			 
		if(trigger.isUpdate && trigger.isBefore)
		{
			System.debug('Kh***BU called from trigger');
			APTS_AssetLineItemTriggerHandler.onBeforeUpdate(trigger.new,trigger.OldMap);
		} 
	}
}