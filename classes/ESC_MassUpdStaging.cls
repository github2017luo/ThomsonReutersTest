public without sharing class ESC_MassUpdStaging {

    ApexPages.StandardSetController setCon;
    Map<String, String> allParameters = new Map<String, String>();
    public ESC_ServiceNow_Scheduler_Settings__c snSettings = ESC_ServiceNow_Scheduler_Settings__c.getInstance('ServiceNowSettings');
    public List<ESC_ServiceNow_Staging__c> updStgList = new List<ESC_ServiceNow_Staging__c>();
    public Integer noOfRetries = Integer.valueOf(snSettings.ESC_No_Of_Retries__c);

    public ESC_MassUpdStaging(ApexPages.StandardSetController controller) {
         allParameters = ApexPages.currentPage().getParameters();
        setCon = controller;
        
    }
    
    public pagereference updsel(){
        for(ESC_ServiceNow_Staging__c stg:[Select Id,ESC_No_Of_Retries__c from ESC_ServiceNow_Staging__c where id  In:setCon.getSelected()]){
            if(stg.ESC_No_Of_Retries__c>noOfRetries){
            stg.ESC_No_Of_Retries__c=0;
            updStgList.add(stg);
            }
        }
        if(updStgList.size()>0 && (Schema.sObjectType.ESC_ServiceNow_Staging__c.isAccessible() || Schema.sObjectType.ESC_ServiceNow_Staging__c.isUpdateable())){
        update updStgList;
        }
        Pagereference backpage = new Pagereference(allParameters.get('retURL'));
        backpage.setRedirect(true);
        return backpage;
    }

}