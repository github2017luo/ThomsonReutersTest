trigger LATAMRenewalLoad on LATAM_Load_Tracker__c (after update) {

If(trigger.isUpdate)
{ RenewalsQuoteSyncLoad renQuoteSyncLoad = new RenewalsQuoteSyncLoad();
        Database.executeBatch(renQuoteSyncLoad,100);  
        }
}