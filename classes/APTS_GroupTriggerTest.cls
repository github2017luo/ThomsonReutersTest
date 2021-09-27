@isTest
private class APTS_GroupTriggerTest{
  static testMethod void test_GroupApproval() {
       String s;
       
       Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
         List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
    
       Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='0%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=a.id,Source_System_Detail__c=accountSSD.id);
       insert o;
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', CurrencyIsoCode='USD', Apttus_Proposal__Account__c=a.id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Presented', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true, APTS_Wet_Signature__c=true,ownerid='0051300000C0dRn');
       System.debug('PriceList before inserting new proposal: ' + p.Apttus_QPConfig__PriceListId__c);
       insert p;
       
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(p.Id);
        insert prodConfig;
        
        APTS_Group__c ag = new APTS_Group__c(APTS_ProductConfiguration__c = prodConfig.id, APTS_Primary_Material__c = 'West Complete Library Sub', Group_Approval_Required__c= True);
        insert ag;
        Test.startTest();
        ag.Group_Approval_Required__c = False;
        update ag;
        Test.stopTest();
    }       
}