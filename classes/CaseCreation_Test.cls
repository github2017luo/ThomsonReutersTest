/****
Test Class : Process Builder - Case Creation when Stage is 95
JIRA : DPS-15966
****/
@isTest(SeeAllData=false)
public class CaseCreation_Test{
  
  public static testmethod void oppGTMTestMethod(){  
        
        LCRMOpportunityTerritoryService obj= new LCRMOpportunityTerritoryService();
        test.starttest();
        KeyValueListStore__c kvc = new KeyValueListStore__c();
        kvc.name='ANZUsersProfileId';
        kvc.TextValue__c='00e30000001ZUki';
        insert kvc;
        KeyValueListStore__c kvc2 = new KeyValueListStore__c();
        kvc2.name='ReasonWithCompetitor';
        kvc2.TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other';
        insert kvc2;
        RecordtypeIds__c rt = new RecordtypeIds__c();
        rt.name = 'Pre-Pipeline Opportunities';
        rt.recTypeId__c = '01230000001MA4h';
        insert rt;
        RecordtypeIds__c rt2 = new RecordtypeIds__c();
        rt2.name = 'Pipeline Opportunities';
        rt2.recTypeId__c = '01230000001MA4g';
        insert rt2;
        //List<Opportunity> listobj = new List<Opportunity>();  
        Account accObj = new Account();
        accObj.name = 'test acc';
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        accObj.BU_Region__c = 'Canada';
        accObj.Bu_Segment__c = 'Professional Tax';
        accObj.Is_GLI__c = true;
        insert accObj;
        
        Opportunity opp1= UnitTest.getOpportunityInstance(accObj.Id);
        opp1.Renewal_Flag__c = false;
        opp1.Selling_Organization__c = 'LRA';
        opp1.Expiration_Date__c = Date.Today().adddays(300);
        opp1.Expected_Revenue_Date__c = date.today();
        //listobj.add(testOpportunity);
        
        insert opp1;
        
        opp1.Sales_org__c = 'TSL';
        opp1.LATAM_Business_Unit__c = 'GTM';
        opp1.LATAM_Entitlement_Provided__c = FALSE;
        opp1.StageName = '95%';
        //opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        //opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.Category__c='SOFTWARE, RENOVACIÓN Y SERVICIOS';
        opp1.Sub_Category__c ='Migración';
        opp1.Sub_Category_2__c ='DFe';
        update opp1;
        
        
        
     }
     
     public static testmethod void oppGTMTestMethod2(){  
         
         LCRMOpportunityTerritoryService obj= new LCRMOpportunityTerritoryService();
        test.starttest();
        KeyValueListStore__c kvc = new KeyValueListStore__c();
        kvc.name='ANZUsersProfileId';
        kvc.TextValue__c='00e30000001ZUki';
        insert kvc;
        KeyValueListStore__c kvc2 = new KeyValueListStore__c();
        kvc2.name='ReasonWithCompetitor';
        kvc2.TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other';
        insert kvc2;
        RecordtypeIds__c rt = new RecordtypeIds__c();
        rt.name = 'Pre-Pipeline Opportunities';
        rt.recTypeId__c = '01230000001MA4h';
        insert rt;
        RecordtypeIds__c rt2 = new RecordtypeIds__c();
        rt2.name = 'Pipeline Opportunities';
        rt2.recTypeId__c = '01230000001MA4g';
        insert rt2;
        //List<Opportunity> listobj = new List<Opportunity>();  
        Account accObj = new Account();
        accObj.name = 'test acc';
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        accObj.BU_Region__c = 'Canada';
        accObj.Bu_Segment__c = 'Professional Tax';
        accObj.Is_GLI__c = true;
        insert accObj;
        
        Opportunity opp1= UnitTest.getOpportunityInstance(accObj.Id);
        opp1.Renewal_Flag__c = false;
        opp1.Selling_Organization__c = 'LRA';
        opp1.Expiration_Date__c = Date.Today().adddays(300);
        opp1.Expected_Revenue_Date__c = date.today();
        //listobj.add(testOpportunity);
        
        insert opp1;
        
        opp1.Sales_org__c = 'TSL';
        opp1.LATAM_Business_Unit__c = 'Mastersaf';
        opp1.LATAM_Entitlement_Provided__c = FALSE;
        opp1.StageName = '95%';
        //opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        //opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.Category__c='SOFTWARE, RENOVACIÓN Y SERVICIOS';
        opp1.Sub_Category__c ='Migración';
        opp1.Sub_Category_2__c ='DFe';
        update opp1;
        
     }
     
     public static testmethod void oppGTMTestMethod4(){  
        
        LCRMOpportunityTerritoryService obj= new LCRMOpportunityTerritoryService();
        test.starttest();
        KeyValueListStore__c kvc = new KeyValueListStore__c();
        kvc.name='ANZUsersProfileId';
        kvc.TextValue__c='00e30000001ZUki';
        insert kvc;
        KeyValueListStore__c kvc2 = new KeyValueListStore__c();
        kvc2.name='ReasonWithCompetitor';
        kvc2.TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other';
        insert kvc2;
        RecordtypeIds__c rt = new RecordtypeIds__c();
        rt.name = 'Pre-Pipeline Opportunities';
        rt.recTypeId__c = '01230000001MA4h';
        insert rt;
        RecordtypeIds__c rt2 = new RecordtypeIds__c();
        rt2.name = 'Pipeline Opportunities';
        rt2.recTypeId__c = '01230000001MA4g';
        insert rt2;
        //List<Opportunity> listobj = new List<Opportunity>();  
        Account accObj = new Account();
        accObj.name = 'test acc';
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        accObj.BU_Region__c = 'Canada';
        accObj.Bu_Segment__c = 'Professional Tax';
        accObj.Is_GLI__c = true;
        insert accObj;
        
        Opportunity opp1= UnitTest.getOpportunityInstance(accObj.Id);
        opp1.Renewal_Flag__c = false;
        opp1.Selling_Organization__c = 'LRA';
        opp1.Expiration_Date__c = Date.Today().adddays(300);
        opp1.Expected_Revenue_Date__c = date.today();
        //listobj.add(testOpportunity);
        
        insert opp1;
        
         opp1.Sales_org__c = 'TSL';
        opp1.LATAM_Business_Unit__c = 'Mastersaf';
        opp1.LATAM_Entitlement_Provided__c = FALSE;
        opp1.StageName = '95%';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        //opp1.Category__c='SOFTWARE, RENOVACIÓN Y SERVICIOS';
        opp1.Sub_Category__c ='Software';
        update opp1;
        
     }
     
     public static testmethod void oppGTMTestMethod3(){  
        
        LCRMOpportunityTerritoryService obj= new LCRMOpportunityTerritoryService();
        test.starttest();
        KeyValueListStore__c kvc = new KeyValueListStore__c();
        kvc.name='ANZUsersProfileId';
        kvc.TextValue__c='00e30000001ZUki';
        insert kvc;
        KeyValueListStore__c kvc2 = new KeyValueListStore__c();
        kvc2.name='ReasonWithCompetitor';
        kvc2.TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other';
        insert kvc2;
        RecordtypeIds__c rt = new RecordtypeIds__c();
        rt.name = 'Pre-Pipeline Opportunities';
        rt.recTypeId__c = '01230000001MA4h';
        insert rt;
        RecordtypeIds__c rt2 = new RecordtypeIds__c();
        rt2.name = 'Pipeline Opportunities';
        rt2.recTypeId__c = '01230000001MA4g';
        insert rt2;
        //List<Opportunity> listobj = new List<Opportunity>();  
        Account accObj = new Account();
        accObj.name = 'test acc';
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        accObj.BU_Region__c = 'Canada';
        accObj.Bu_Segment__c = 'Professional Tax';
        accObj.Is_GLI__c = true;
        insert accObj;
        
        Opportunity opp1= UnitTest.getOpportunityInstance(accObj.Id);
        opp1.Renewal_Flag__c = false;
        opp1.Selling_Organization__c = 'LRA';
        opp1.Expiration_Date__c = Date.Today().adddays(300);
        opp1.Expected_Revenue_Date__c = date.today();
        //listobj.add(testOpportunity);
        
        insert opp1;
        
        opp1.Sales_org__c = 'TSL';
        opp1.LATAM_Business_Unit__c = 'Mastersaf';
        opp1.LATAM_Entitlement_Provided__c = FALSE;
        opp1.StageName = '95%';
        //opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Category__c= 'SUSCRIPCION';
        //opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.Sub_Category__c ='Nueva';
        opp1.Sub_Category_2__c ='Checkpoint';
        update opp1;
        
     }
  
}