@isTest
public class fetchRelatedrecordsTest {
    
    @isTest static void testfetchRecords()
    {
        Lead_Product__c lp = new Lead_Product__c();
        Lead l = new lead();
        l.FirstName='test';
        l.LastName='tessst';
        l.company='test';
        insert l ;
        lp.Lead__c = l.Id;
        insert lp;
        
        integer i = fetchRelatedrecords.fetchRecords(l.id);
        
        system.assertEquals(1, i);
        
    }
}