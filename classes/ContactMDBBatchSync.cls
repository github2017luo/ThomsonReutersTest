global without sharing class ContactMDBBatchSync implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    public set<string> salesorgs{get;set;}
    private set<string> defaultOrgs;
       
    global ContactMDBBatchSync() {
        
        salesorgs = new set<string>();  
        defaultOrgs = new Set<String>();
        Map<String,String> salesorgMap = new Map<String,String>();
        salesorgMap = MexicoUtility.classBasedOrgValues('ContactMDBBatchSync','Sales_Org__c');
        /*LaTam_Mexico_Static_Values__mdt sOrgmdt = LaTam_Mexico_Static_Values__mdt.getInstance('ContactMDBBatchSync');
        List<String> salesOrgList = (sOrgmdt.Sales_Org__c).split(',');*/
        for(String st : salesorgMap.values()){
                defaultOrgs.add(st);
            }
        //defaultOrgs.add('WEST');
        
        /*for (SalesOrgDetail__c oSalesOrgDetail : [SELECT  Sales_Org_Code__c 
                                                    FROM 
                                                        SalesOrgDetail__c
                                                    WHERE
                                                        Sales_Org_Code__c != null ]) {
            defaultOrgs.add(oSalesOrgDetail.Sales_Org_Code__c);
        }*/
    }
    
    global Database.Querylocator start(Database.BatchableContext bcContext) {
        //return Database.getQueryLocator([SELECT Id FROM Account where (Sales_Org__c = 'LRA' or Sales_Org__c = 'BKRS' or Sales_Org__c = 'SMHK') and MDBID__C = '' and recordtype.name = 'Prospect']);
        if (SalesOrgs == null || SalesOrgs.isEmpty()) {
            SalesOrgs = defaultOrgs;
        }
        //return Database.getQueryLocator([SELECT Id FROM Account WHERE Sales_Org__c IN :SalesOrgs and MDBID__C = '' and recordtype.name = 'Prospect']);
        return Database.getQueryLocator([SELECT Id FROM Contact where account.sales_org__C IN :SalesOrgs and MDB_Contact_ID__c = '' and sap_contact_ID__C = null]);
    }
    
    global void execute(Database.BatchableContext bcContext, List<sObject> listContacts)
    {
        if (listContacts != null && listContacts.isEmpty() == false) {
            for (sObject contact: listContacts){
                ContactUtil.upsertMDBContact(contact.Id);
            }
        }
    }
    
    global void finish(Database.BatchableContext bcContext) {}
}