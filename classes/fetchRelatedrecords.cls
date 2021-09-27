global class fetchRelatedrecords {
    webService static integer fetchRecords(String LeadId){
        LIST<Lead_Product__c> lp=new LIST<Lead_Product__c>();
        lp=[SELECT id, Lead__c from Lead_Product__c WHERE Lead__c=:LeadId];
        integer i=lp.size();
        system.debug('size ' +i);
        return i;
    }
}