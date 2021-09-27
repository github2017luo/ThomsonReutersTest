@isTest
(seeAllData=true)

public with sharing class CampaignTriggerHandler_Test
{
    public static testMethod void testCampaignTriggerHandler()
    {
      
        campaign ocampaign = new campaign();
        ocampaign.name = 'test';
        ocampaign.Offer_Code__c ='12345';
        list<Campaign> listCampaign = new list<Campaign>();
        listCampaign.add(ocampaign);
        
        //listCampaign = [select name,Offer_Code__c from Campaign limit 1];
        //listcampaign[1].campaing.name = 'test';
        //campaign.Offer_code__C = '12345';
        insert listCampaign;
        update listCampaign;
          
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1; 
        
        opportunity testOpty = UnitTest.getOpportunityInstance(testAcc1.id);
        testOpty.Campaignid=listCampaign[0].id;
        insert testOpty;
        
       
        
        Training_Event__c testTrainingEvent = new Training_Event__c(Training_Name__c='test1',Offer_Code__c='ABC');
        testTrainingEvent.Campaign_name__c=listCampaign[0].id;
        insert testTrainingEvent;
        
        
     
        CampaignTriggerHandler.UpdateOfferCode(listCampaign);
    
        
    }
}