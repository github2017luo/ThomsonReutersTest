/*

PURPOSE:      Contains all the testMethods for CampaignOfferCodeUpdateonOpp and CampaignOfferCodeUpdateonTE 

FUNCTIONALITY:  Test Methods

COMMENTS:      

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
                                        
2012-01-03      Nandita                 Created
===============================================================================
*/
@isTest
private class CampaignOfferCodeUpdate_Test {

  public static List<Campaign> listCampaign = new list<Campaign>();
  public static List<Opportunity> listOpportunity = new list<Opportunity>();
  public static List<Training_Event__c> listTrainingEvents = new List<Training_Event__c>();
  public static Set<Id> OptyIds = new Set<ID>();
  public static Set<Id> TEIds = new Set<ID>();    

    public static testMethod void testCampaignOfferCodeUpdate()
    {
        
        Map<Id,String> mapCampaignOffercode = new map<Id,String>();
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
        List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds;
        
        for(Integer i=0 ; i<10;i++){
            listCampaign.add(new Campaign(Name='Test Campaign'+String.valueOf(i),Offer_Code__c='123'+String.valueOf(i), IsActive = True, Status = 'In Progress'));
        }
        insert listCampaign;
        
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1; 
        
        for(Campaign oCampaign : listCampaign){
            listOpportunity.add(new Opportunity(AccountId = testAcc1.Id,Name = 'Unit Test Opportuntiy',
                                                CloseDate = System.Today() + 5,StageName = 'Prospect',Campaignid=oCampaign.Id));
            listTrainingEvents.add(new Training_Event__c(Training_Name__c='test1',Campaign_name__c=oCampaign.Id));
            
        
        }
        
        insert listOpportunity;
        insert listTrainingEvents;
        
        Test.StartTest();
        for(Campaign oCampaign : listCampaign){
           oCampaign.Offer_Code__c = oCampaign.Offer_Code__c + '0'; 
           mapCampaignOffercode.put(oCampaign.Id,oCampaign.Offer_Code__c);
        }
        update listCampaign;
       CampaignOfferCodeUpdateonOpp oCampaignOfferCodeUpdateonOpp = new CampaignOfferCodeUpdateonOpp();
       Database.executeBatch(oCampaignOfferCodeUpdateonOpp);
       CampaignOfferCodeUpdateonTE oCampaignOfferCodeUpdateonTE = new CampaignOfferCodeUpdateonTE();
       Database.executeBatch(oCampaignOfferCodeUpdateonTE);
            
       Test.StopTest();  
       listOpportunity = [Select Offer_Code__c,Campaignid from Opportunity where CampaignId IN : listCampaign];
       for(Opportunity oOpportunity : listOpportunity){
           OptyIds.add(oOpportunity.Id);
            System.assertEquals(oOpportunity.Offer_Code__c,mapCampaignOffercode.get(oOpportunity.Campaignid),'Error:The offer code should be same');
        }
        
        listTrainingEvents = [Select Offer_Code__c,Campaign_name__c from Training_Event__c where Campaign_name__c IN : listCampaign];
        for(Training_Event__c oTrainingEvent : listTrainingEvents){
            System.assertEquals(oTrainingEvent.Offer_Code__c,mapCampaignOffercode.get(oTrainingEvent.Campaign_name__c),'Error:The offer code should be same');
        }
       }
       
       public static testMethod void testOfferCodeUpdate(){
            Test.StartTest();
            KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
            insert oANZProfileId;
            CampaignOfferCodeUpdateonOpp oCampaignOfferCodeUpdateonOpp = new CampaignOfferCodeUpdateonOpp();
            ID batchprocessid = Database.executeBatch(oCampaignOfferCodeUpdateonOpp);
       
            
            
            AsyncApexJob OAsyncApexJob = [Select NumberOfErrors,JobItemsProcessed,TotalJobItems From AsyncApexJob where Id =:batchprocessid];
            System.assertEquals(0,OAsyncApexJob.NumberOfErrors,'Error');
           
            
            for(Id TestId : OptyIds){     
              System.assertEquals(true,oCampaignOfferCodeUpdateonOpp.RecordIds.contains(TestId));
           
           }
           CampaignOfferCodeUpdateonTE oCampaignOfferCodeUpdateonTE = new CampaignOfferCodeUpdateonTE();
            ID batchprocessid_TE = Database.executeBatch(oCampaignOfferCodeUpdateonTE );
            
            AsyncApexJob OAsyncApexJob_TE = [Select NumberOfErrors,JobItemsProcessed,TotalJobItems From AsyncApexJob where Id =:batchprocessid_TE];
            System.assertEquals(0,OAsyncApexJob_TE.NumberOfErrors,'Error');
           
            
       
           for(Id TestId : TEIds){     
                  System.assertEquals(true,oCampaignOfferCodeUpdateonTE.RecordIds.contains(TestId));

               
           }
           
           Test.StopTest();
      }
      
      // Test Method
    static testMethod void test_ScheduledCampaignOfferCodeUpdate(){
        Test.startTest();  
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;     
        ScheduledCampaignOfferCodeUpdateonOpp TestScheduler = new ScheduledCampaignOfferCodeUpdateonOpp();
        SchedulableContext sc;
        TestScheduler.execute(sc);
        
        ScheduledCampaignOfferCodeUpdateonTE TestScheduler_TE = new ScheduledCampaignOfferCodeUpdateonTE();
        SchedulableContext sc_TE;
        TestScheduler_TE.execute(sc_TE);
        Test.stopTest();    
    }

}