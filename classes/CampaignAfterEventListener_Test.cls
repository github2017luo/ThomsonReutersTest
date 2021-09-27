@isTest
public class CampaignAfterEventListener_Test {
    public static testMethod void testRuleChildRecord()
    {
        Campaign c1 = new Campaign();
        c1.Name = 'Test Campaign 1';
        insert c1;
        
        Campaign c2 = new Campaign();
        c2.Name = 'Test Campaign 2';
        c2.ParentId = c1.Id;
        insert c2;
        
        Campaign c3 = new Campaign();
        c3.Name = 'Test Campaign 3';        
        c3.ParentId = c2.id;
        c3.Campaign_Level__c = 'Tactic';
        insert c3;
        
        Campaign c11 = new Campaign();
        c11.Name = 'Test Campaign 11';
        insert c11;
        
        Campaign c21 = new Campaign();
        c21.Name = 'Test Campaign 21';
        c21.ParentId = c11.Id;
        insert c21;
        
        Campaign c31 = new Campaign();
        c31.Name = 'Test Campaign 31';        
        c31.ParentId = c21.id;
        c31.Campaign_Level__c = 'Tactic';
        insert c31;
       
        c2.Program_Type__c = 'Live Webinar';
        update c2;
        
        c1.Campaign_Theme__c = 'Fearless';
        update c1;
        
        c1.Operating_Unit__c = 'Corporate';
        update c1;
        
        c11.Campaign_Theme__c = 'Like A Boss';        
        c11.Operating_Unit__c = 'Government';
        update c11;
        
        
        
    }
    
}