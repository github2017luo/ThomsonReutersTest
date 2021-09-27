@istest(SeeAllData=false)
 public class LATAMRenewalLoad_Test {
  public static testmethod void LATAMRenewalLoad_Test(){
        UnitTest.createTestData();
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;

        Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.currencyIsoCode = 'USD';
       // opp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
       
        insert opp1;

        Quote Q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
       // Q1.Approval_Status__c = 'Quote Rejected';
        Q1.Primary_Quote__c = true;
       // opp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c;
        Insert Q1;
        
        LATAM_Load_Tracker__c lat1 = New LATAM_Load_Tracker__c();
        lat1.Load_Datetimestamp__c= datetime.newInstance(2014, 9, 15, 12, 30, 0);
        Insert lat1;
        
        Test.StartTest();
       // try {
            UPDATE lat1;
      //  } catch (Exception e) {
     //       system.assertEquals('You can\'t update this record!', e.getMessage());
     //   }
        
        Test.StopTest();
        
        }
   }