@isTest
public class LTS_TestDataFactory {
    public static List<Opportunity> createOpps(Integer numOpps) {
        
        
        List<Opportunity> opps = new List<Opportunity>();
        
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
         keyvaluestore.Name='ANZUsersProfileId';
         keyvaluestore.TextValue__c='00e30000001ZUki';
         insert keyvaluestore;
        

        
                List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        // For each account just inserted, add opportunities
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account Training Event';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        //gliAccount.OwnerId = oUser.Id;
        insert gliAccount;
        for (Integer k=0;k<numOpps;k++) {
            LCRMConvertLeadController.lcrmConvertLeadFlag = false;
            OpportunityUtil.syncRevenueAmountsRecCheck = true;
            opps.add(new Opportunity(Name='Test Opportunity'+ k,
                                     Is_GLI__c = true,
                                     TRWaySales__Park_Opportunity__c = false,
                                     StageName='Needs Analysis',
                                     CloseDate=System.today().addMonths(1),
                                     recordtypeid = opptyRecorType,
                                     accountid = gliAccount.id,
                                     Territory2Id  = null
                                     ));
        }
        
        // Insert all opportunities for all accounts.
        Database.insert(opps,true);
        
        return opps;
    }
}