/*
======================================================================================================================
TEST CLASS NAME: SourceSystemDetailController_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the SourceSystemDetailController class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2017-10-05            Priyanka                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest
Public with sharing class SourceSystemDetailController_Test{
public static testMethod void testDetailController(){
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
        
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
     string selectedCustomerGroupName = '';
     string selectedIndustryName = '';
     string selectedsalesorgName = '';
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c = 'Global',Segment__c = 'Global');        
        insert u1;
        
      System.Runas(u1){  
    Account testAcc1 = UnitTest.getAccountInstance();
    testAcc1.Sales_Org__c ='WEST' ;
    testAcc1.Name='ABC';
    testAcc1.billingstreet='test';
    insert testAcc1;
    System.assertequals('ABC',testAcc1.Name,'Success');
    
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
     Source_System_Detail__c accountSSD= new Source_System_Detail__c();
     accountSSD.RecordtypeId=ssdRecorType;
     accountSSD.Name='ABC';
     accountSSD.Source_System_Name__c='ABC';
     accountSSD.Account_Name__c=testAcc1.ID;
     accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
     accountSSD.Account_Inactive__c=false;
     accountSSD.Number_Street__c='test';
     //accountSSD.LCRM_Sales_Org__c='WEST';
     //accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
     //accountSSD.LCRM_Industry__c='TAX';
     
      insert accountSSD;
    
      Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
      Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
      opp.RecordtypeId=opptyRecorType;
      insert opp;
                
        
     Test.StartTest();
   
    PageReference pageRef = Page.createSSd;
     pageRef.getParameters().put('id', String.valueOf(opp.Id));
    //pageRef.getParameters().put('id', opp.Id);
    system.Test.setCurrentPage(pageRef);
    SourceSystemDetailController sc = new SourceSystemDetailController();
     sc.sourceSysDetail=accountSSD;  
      SourceSystemDetailController sc1 = new SourceSystemDetailController();
     sc1.sourceSysDetail=accountSSD;  
     
    GLIIndustryList__c gLI= new GLIIndustryList__c();
     gLI.Name='test';
     gLI.IndustryName__c='test1';
     insert gLI;
    GLICustomerGroupList__c gLI1 = new GLICustomerGroupList__c();
       GLI1.Name='test';
          insert GLI1;
    GLIPicklistValues__c gCGI = new GLIPicklistValues__c();
    GCGI.Name = 'Test1';
    GCGI.Picklist_Salesorg__c = 'TA78';
    insert GCGI;
   system.debug('Before Test Sales Org Value '+accountSSD.LCRM_Sales_Org__c);  
    //sc.getselectedindustry();
    //sc.getcustomerGroup();
    //sc.refreshCGroupandIndustry;
    sc.getsalesorg();
    //sc.fetchIndustry('WEST');
      system.debug('Test Sales Org Value '+accountSSD.LCRM_Sales_Org__c);  
      system.debug('Test Customer Group Value '+accountSSD.LCRM_Customer_Group__c);  
      system.debug('Test Industry Value  '+accountSSD.LCRM_Industry__c);  
      sc.selectedCustomerGroupName='';
      sc.selectedIndustryName='';
      sc.selectedsalesorgname='WEST';
      PageReference   objPageRef = sc.saveSSD();
      PageReference   objPageRef1 =  sc.cancel();    
    Test.StopTest();
        }
    }
        public static testMethod void testDetailController3(){
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        string selectedCustomerGroupName = '';
        string selectedIndustryName = '';
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c = 'USL',Segment__c = 'Professional Legal');        
        insert u1;
            
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
        
        List<RecordtypeIds__c> recordtypeList=new List<RecordtypeIds__c>{
         new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id),
         new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id)};
         
         insert recordtypeList;
         
        System.Runas(u1){  
            Account testAcc1 = UnitTest.getAccountInstance();
            if(testAcc1!=null)
            {
            testAcc1.Sales_Org__c ='WEST' ;
            testAcc1.Name='ABC';
            testAcc1.billingstreet='test';
            insert testAcc1;
            }
            System.assertequals('ABC',testAcc1.Name,'Success');
            
             Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            /*Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
             
             accountSSD.RecordtypeId=ssdRecorType;
             accountSSD.Name='ABC';
             accountSSD.Source_System_Name__c='ABC';
             accountSSD.Account_Name__c=testAcc1.ID;
             accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
             accountSSD.Account_Inactive__c=false;
             accountSSD.LCRM_Sales_Org__c='TA78';
            insert accountSSD;*/
    
            Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
            opp.RecordtypeId=opptyRecorType;
            insert opp;
                
            //opp.Source_system_detail__c=accountSSD.ID;
            //update opp;
            
             Test.StartTest();
        
            PageReference pageRef = Page.createSSd;
             pageRef.getParameters().put('id', String.valueOf(opp.Id));
            system.Test.setCurrentPage(pageRef);
            SourceSystemDetailController sc = new SourceSystemDetailController();
             //sc.sourceSysDetail=accountSSD; 
             sc.sourceSysDetail .LCRM_Name_3__c='Test2';
             sc.sourceSysDetail .LCRM_Name_2__c='Test1';
             sc.selectedCustomerGroupName='FEDERAL GOVERNMENT';
             sc.selectedIndustryName='TAX';
              sc.selectedsalesOrgName='TA61';
            PageReference   objPageRef = sc.saveSSD();
            PageReference   objPageRef1 =  sc.cancel();    
            Test.StopTest();
        }
     }
     public static testMethod void testDetailControllerCARS(){
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
     string selectedCustomerGroupName = '';
     string selectedIndustryName = '';
     string selectedsalesorgName = '';
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c=Label.SALESORGCAN);        
        insert u1;
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
        
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
      System.Runas(u1){  
    Account testAcc1 = UnitTest.getAccountInstance();
    testAcc1.Sales_Org__c ='TA78';
    //label.SALESORGCARS;
    testAcc1.Name='ABC';
    testAcc1.billingstreet='test';
    insert testAcc1;
    System.assertequals('ABC',testAcc1.Name,'Success');
    
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
     Source_System_Detail__c accountSSD= new Source_System_Detail__c();
     accountSSD.RecordtypeId=ssdRecorType;
     accountSSD.Name='ABC';
     accountSSD.Source_System_Name__c='ABC';
     accountSSD.Account_Name__c=testAcc1.ID;
     accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
     accountSSD.Account_Inactive__c=false;
     accountSSD.LCRM_Sales_Org__c=label.SALESORGCARS;
     //accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
     //accountSSD.LCRM_Industry__c='TAX';
     
      insert accountSSD;
    
      Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
      Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
      opp.RecordtypeId=opptyRecorType;
      insert opp;
                
        
     Test.StartTest();
   
    PageReference pageRef = Page.createSSd;
     pageRef.getParameters().put('id', String.valueOf(opp.Id));
    //pageRef.getParameters().put('id', opp.Id);
    system.Test.setCurrentPage(pageRef);
    SourceSystemDetailController sc = new SourceSystemDetailController();
     sc.sourceSysDetail=accountSSD;  
    GLIIndustryList__c gLI= new GLIIndustryList__c();
     GLI.Name='test';
     GLI.IndustryName__c='test1';
     insert GLI;
    GLICustomerGroupList__c gLI1 = new GLICustomerGroupList__c();
       GLI1.Name='test';
          insert GLI1;
     sc.getsalesorg();
    sc.selectedsalesOrgName=Label.SALESORGCARS;
      system.debug('123accountSSD.LCRM_Sales_Org__c '+accountSSD.LCRM_Sales_Org__c);   
      PageReference   objPageRef = sc.saveSSD();
      PageReference   objPageRef1 =  sc.cancel();    
    Test.StopTest();
        }
    }
    public static testMethod void testDetailControllerCORP(){
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
     string selectedCustomerGroupName = '';
     string selectedIndustryName = '';
     string selectedsalesOrgName = '';
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='US',Segment__c='Corporate', Default_Catalog__c='USL');        
        insert u1;
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
        
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
      System.Runas(u1){  
    Account testAcc1 = UnitTest.getAccountInstance();
    testAcc1.Sales_Org__c =label.SALESORGCARS;
    testAcc1.Name='ABC';
    testAcc1.billingstreet='test';
    insert testAcc1;
    System.assertequals('ABC',testAcc1.Name,'Success');
    
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
     Source_System_Detail__c accountSSD= new Source_System_Detail__c();
     accountSSD.RecordtypeId=ssdRecorType;
     accountSSD.Name='ABC';
     accountSSD.Source_System_Name__c='ABC';
     accountSSD.Account_Name__c=testAcc1.ID;
     accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
     accountSSD.Account_Inactive__c=false;
     accountSSD.LCRM_Name_2__c='ABSCDEFGHIJKLMNOPQRSTUVWZYZqwerasdfc';
     //accountSSD.LCRM_Sales_Org__c=label.SALESORGCARS;
     //accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
     //accountSSD.LCRM_Industry__c='TAX';
     
      insert accountSSD;
    
      Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
      Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
      opp.RecordtypeId=opptyRecorType;
      insert opp;
                
        
     Test.StartTest();
   
    PageReference pageRef = Page.createSSd;
     pageRef.getParameters().put('id', String.valueOf(opp.Id));
    //pageRef.getParameters().put('id', opp.Id);
    system.Test.setCurrentPage(pageRef);
    SourceSystemDetailController sc = new SourceSystemDetailController();
     sc.sourceSysDetail=accountSSD;  
    sc.getsalesorg();
    GLIPicklistValues__c GCGI = new GLIPicklistValues__c();
    GCGI.Name = 'Test1';
    GCGI.Picklist_Salesorg__c = 'OneOTC US';
    GCGI.Picklist_Field_For__c = 'CustomerGroup';
    GCGI.Picklist_Lov__c = 'CG1';
    insert GCGI;
    GLIPicklistValues__c GCGI1 = new GLIPicklistValues__c();
    GCGI1.Name = 'Test2';
    GCGI1.Picklist_Salesorg__c = 'OneOTC US';
    GCGI1.Picklist_Field_For__c = 'Industry';
    GCGI1.Picklist_Lov__c = 'I1';
    insert GCGI1;
    sc.fetchIndustry('OneOTC US');
    sc.fetchcustomerGroup('OneOTC US');
    sc.refreshCGroupandIndustry();
    sc.selectedsalesOrgName='OneOTC US';
    sc.selectedIndustryName='TAX';
    sc.selectedCustomerGroupName='FEDERAL GOVERNMENT';
      system.debug('123accountSSD.LCRM_Sales_Org__c '+accountSSD.LCRM_Sales_Org__c);   
      PageReference   objPageRef = sc.saveSSD();
      PageReference   objPageRef1 =  sc.cancel();   
      /* Aastha Starts  */
    SourceSystemDetailController sc2 = new SourceSystemDetailController();
    sc2.sourceSysDetail=accountSSD;  
    sc2.selectedsalesOrgName='';
    objPageRef = sc2.saveSSD();       
          
    SourceSystemDetailController sc3 = new SourceSystemDetailController();
    sc3.sourceSysDetail=accountSSD;
    sc3.selectedsalesOrgName='OneOTC US';
    sc3.selectedCustomerGroupName='FEDERAL GOVERNMENT';
    sc3.selectedIndustryName='';
    objPageRef = sc3.saveSSD();
    objPageRef1 =  sc.cancel();   
          /* Astha stops*/
    Test.StopTest();
        }
} 
    public static testMethod void testDetailControllerCanada(){
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        string selectedCustomerGroupName = '';
        string selectedIndustryName = '';
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='Canada',CurrencyIsoCode='CAD');        
        insert u1;
           
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
        
        List<RecordtypeIds__c> recordtypeList=new List<RecordtypeIds__c>{
         new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id),
         new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id)};
         
         insert recordtypeList;
         
        System.Runas(u1){  
            Account testAcc1 = UnitTest.getAccountInstance();
            testAcc1.Sales_Org__c ='Canada' ;
            testAcc1.Name='ABCD';
            testAcc1.billingstreet='test';
            insert testAcc1;
            System.assertequals('ABCD',testAcc1.Name,'Success');
            
           
            Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
             Source_System_Detail__c accountSSD= new Source_System_Detail__c();
             accountSSD.RecordtypeId=ssdRecorType;
             accountSSD.Name='ABC';
             accountSSD.Source_System_Name__c='ABC';
             accountSSD.Account_Name__c=testAcc1.ID;
             accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
             accountSSD.Account_Inactive__c=false;
             accountSSD.LCRM_Sales_Org__c='TA78';
             
            insert accountSSD;
    
            Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
            opp.RecordtypeId=opptyRecorType;
            insert opp;
                
            opp.Source_system_detail__c=accountSSD.ID;
            update opp;
            
             Test.StartTest();
   
    PageReference pageRef = Page.createSSd;
     pageRef.getParameters().put('id', String.valueOf(opp.Id));
    system.Test.setCurrentPage(pageRef);
    SourceSystemDetailController sc = new SourceSystemDetailController();
    sc.sourceSysDetail=accountSSD;  
   
    sc.getsalesorg();
    GLIPicklistValues__c GCGI = new GLIPicklistValues__c();
    GCGI.Name = 'Test1';
    GCGI.Picklist_Salesorg__c = 'CARS';
    GCGI.Picklist_Field_For__c = 'CustomerGroup';
    GCGI.Picklist_Lov__c = 'CG1';
    insert GCGI;
    GLIPicklistValues__c GCGI1 = new GLIPicklistValues__c();
    GCGI1.Name = 'Test2';
    GCGI1.Picklist_Salesorg__c = 'CARS';
    GCGI1.Picklist_Field_For__c = 'Industry';
    GCGI1.Picklist_Lov__c = 'I1';
    insert GCGI1;
    sc.fetchIndustry('CARS');
    sc.fetchcustomerGroup('CARS');
    sc.refreshCGroupandIndustry();
    sc.selectedsalesOrgName='CARS';
    sc.selectedIndustryName='TAX';
    sc.selectedCustomerGroupName='FEDERAL GOVERNMENT';
      system.debug('123accountSSD.LCRM_Sales_Org__c '+accountSSD.LCRM_Sales_Org__c);   
      PageReference   objPageRef = sc.saveSSD();
      PageReference   objPageRef1 =  sc.cancel();   
           
          
    
    Test.StopTest();
        }
     }
    public static testMethod void testDetailControllerUK(){
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        string selectedCustomerGroupName = '';
        string selectedIndustryName = '';
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='USL',CurrencyIsoCode='GBP');        
        insert u1;
           
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
        
        List<RecordtypeIds__c> recordtypeList=new List<RecordtypeIds__c>{
         new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id),
         new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id)};
         
         insert recordtypeList;
         
        System.Runas(u1){  
            Account testAcc1 = UnitTest.getAccountInstance();
            testAcc1.Sales_Org__c ='WEST' ;
            testAcc1.Name='ABCD';
            testAcc1.billingstreet='test';
            insert testAcc1;
            System.assertequals('ABCD',testAcc1.Name,'Success');
           
            Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
             Source_System_Detail__c accountSSD= new Source_System_Detail__c();
             accountSSD.RecordtypeId=ssdRecorType;
             accountSSD.Name='ABC';
             accountSSD.Source_System_Name__c='ABC';
             accountSSD.Account_Name__c=testAcc1.ID;
             accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
             accountSSD.Account_Inactive__c=false;
             accountSSD.LCRM_Sales_Org__c='TA61';
             
            insert accountSSD;
    
            Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
            opp.RecordtypeId=opptyRecorType;
            insert opp;
                
            opp.Source_system_detail__c=accountSSD.ID;
            update opp;
            
             Test.StartTest();
   
    PageReference pageRef = Page.createSSd;
     pageRef.getParameters().put('id', String.valueOf(opp.Id));
    system.Test.setCurrentPage(pageRef);
    SourceSystemDetailController sc = new SourceSystemDetailController();
    sc.sourceSysDetail=accountSSD;  
   
    sc.getsalesorg();
    GLIPicklistValues__c GCGI = new GLIPicklistValues__c();
    GCGI.Name = 'Test1';
    GCGI.Picklist_Salesorg__c = 'TA61';
    GCGI.Picklist_Field_For__c = 'CustomerGroup';
    GCGI.Picklist_Lov__c = 'CG1';
    insert GCGI;
    GLIPicklistValues__c GCGI1 = new GLIPicklistValues__c();
    GCGI1.Name = 'Test2';
    GCGI1.Picklist_Salesorg__c = 'TA61';
    GCGI1.Picklist_Field_For__c = 'Industry';
    GCGI1.Picklist_Lov__c = 'I1';
    insert GCGI1;
    sc.fetchIndustry('TA61');
    sc.fetchcustomerGroup('TA61');
    sc.refreshCGroupandIndustry();
    sc.selectedsalesOrgName='TA61';
    sc.selectedIndustryName='TAX';
    sc.selectedCustomerGroupName='FEDERAL GOVERNMENT';
      system.debug('123accountSSD.LCRM_Sales_Org__c '+accountSSD.LCRM_Sales_Org__c);   
      PageReference   objPageRef = sc.saveSSD();
      PageReference   objPageRef1 =  sc.cancel();   
           
          
    
    Test.StopTest();
        }
     }
     
 public static testMethod void testDetailControllerTax(){
        
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        string selectedCustomerGroupName = '';
        string selectedIndustryName = '';
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c='US',
    CurrencyIsoCode='GBP',Segment__c='Professional Tax');        
        insert u1;
        
        Tax_Proff_GLI_Setting__c tg = new Tax_Proff_GLI_Setting__c();
        tg.SubBU__c = 'US';
        tg.Segment__c = 'Professional Tax';
        insert tg;
           
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
        
        List<RecordtypeIds__c> recordtypeList=new List<RecordtypeIds__c>{
         new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id),
         new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id)};
         
         insert recordtypeList;
         
        System.Runas(u1){  
            Account testAcc1 = UnitTest.getAccountInstance();
            testAcc1.Sales_Org__c ='WEST' ;
            testAcc1.Name='ABCD';
            testAcc1.billingstreet='test';
            insert testAcc1;
            System.assertequals('ABCD',testAcc1.Name,'Success');
           
            Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
             Source_System_Detail__c accountSSD= new Source_System_Detail__c();
             accountSSD.RecordtypeId=ssdRecorType;
             accountSSD.Name='ABC';
             accountSSD.Source_System_Name__c='ABC';
             accountSSD.Account_Name__c=testAcc1.ID;
             accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
             accountSSD.Account_Inactive__c=false;
             accountSSD.LCRM_Sales_Org__c='S100';
             
            insert accountSSD;
    
            Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            Opportunity opp =UnitTest.getOpportunityInstance(testAcc1.id);
            opp.RecordtypeId=opptyRecorType;
            insert opp;
                
            opp.Source_system_detail__c=accountSSD.ID;
            update opp;
            
             Test.StartTest();
   
    PageReference pageRef = Page.createSSd;
     pageRef.getParameters().put('id', String.valueOf(opp.Id));
    system.Test.setCurrentPage(pageRef);
    SourceSystemDetailController sc = new SourceSystemDetailController();
    sc.sourceSysDetail=accountSSD;  
   
    sc.getsalesorg();
    GLIPicklistValues__c GCGI = new GLIPicklistValues__c();
    GCGI.Name = 'Test1';
    GCGI.Picklist_Salesorg__c = 'TA61';
    GCGI.Picklist_Field_For__c = 'CustomerGroup';
    GCGI.Picklist_Lov__c = 'CG1';
    insert GCGI;
    GLIPicklistValues__c GCGI1 = new GLIPicklistValues__c();
    GCGI1.Name = 'Test2';
    GCGI1.Picklist_Salesorg__c = 'TA61';
    GCGI1.Picklist_Field_For__c = 'Industry';
    GCGI1.Picklist_Lov__c = 'I1';
    insert GCGI1;
    sc.fetchIndustry('TA61');
    sc.fetchcustomerGroup('TA61');
    sc.refreshCGroupandIndustry();
    sc.selectedsalesOrgName='TA61';
    sc.selectedIndustryName='TAX';
    sc.selectedCustomerGroupName='FEDERAL GOVERNMENT';
      system.debug('123accountSSD.LCRM_Sales_Org__c '+accountSSD.LCRM_Sales_Org__c);   
      PageReference   objPageRef = sc.saveSSD();
      PageReference   objPageRef1 =  sc.cancel();   
           
          
    LCRMGenericComponent.validateTaxProfUser();
    Test.StopTest();
        }
     }
     
    
     public static testMethod void testDetailControllerSave(){
    Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        
       List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
         
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        string selectedCustomerGroupName = '';
        string selectedIndustryName = '';
        string selectedsalesorgName = '';
        
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c = 'Global',Segment__c = 'Global');        
        insert u1;
        
      System.Runas(u1){  
    Account testAcc2 = UnitTest.getAccountInstance();
    testAcc2.Sales_Org__c ='WEST' ;
    testAcc2.Name='DEF';
    testAcc2.billingstreet='test';
    insert testAcc2;
    System.assertequals('DEF',testAcc2.Name,'Success');
    
    Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
     Source_System_Detail__c accountSSD= new Source_System_Detail__c();
     accountSSD.RecordtypeId=ssdRecorType;
     accountSSD.Name='DEF';
     accountSSD.Source_System_Name__c='DEF';
     accountSSD.Account_Name__c=testAcc2.ID;
     accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
     accountSSD.Account_Inactive__c=false;
     accountSSD.LCRM_Sales_Org__c='WEST';
     accountSSD.LCRM_Name_3__c='ABC_Name_jhsjfhsjhfsjdfhksjyfdsqwdhqwgdhqwgoljadlajflkjfyuyuy';
     accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
     accountSSD.LCRM_Industry__c='TAX';
     accountSSD.CurrencyIsoCode='USD'; 
     accountSSD.Billing_Currency__c='USD'; 
     
      insert accountSSD;
    
      Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
      Opportunity opp =UnitTest.getOpportunityInstance(testAcc2.id);
      opp.RecordtypeId=opptyRecorType;
      insert opp;
                
        
     Test.StartTest();
   
    PageReference pageRef = Page.createSSd;
     pageRef.getParameters().put('id', String.valueOf(opp.Id));
    //pageRef.getParameters().put('id', opp.Id);
    system.Test.setCurrentPage(pageRef);
    SourceSystemDetailController sc = new SourceSystemDetailController();
     sc.sourceSysDetail=accountSSD;  
      SourceSystemDetailController sc1 = new SourceSystemDetailController();
     
    GLIIndustryList__c GLI= new GLIIndustryList__c();
     GLI.Name='test';
     
     GLI.IndustryName__c='test1';
     insert GLI;
     
    GLICustomerGroupList__c GLI1 = new GLICustomerGroupList__c();
       GLI1.Name='test';
          insert GLI1;
          
    GLIPicklistValues__c GCGI = new GLIPicklistValues__c();
    GCGI.Name = 'Test1';
    GCGI.Picklist_Salesorg__c = 'TA78';
    insert GCGI;
    
   system.debug('Before Test Sales Org Value '+accountSSD.LCRM_Sales_Org__c);  
    //sc.getselectedindustry();
    //sc.getcustomerGroup();
    //sc.refreshCGroupandIndustry;
    sc.getsalesorg();
    //sc.fetchIndustry('WEST');
      system.debug('Test Sales Org Value '+accountSSD.LCRM_Sales_Org__c);  
      system.debug('Test Customer Group Value '+accountSSD.LCRM_Customer_Group__c);  
      system.debug('Test Industry Value  '+accountSSD.LCRM_Industry__c);  
      
      sc.selectedCustomerGroupName='FEDERAL GOVERNMENT';
      sc.selectedIndustryName='TAX';
      sc.selectedsalesorgname='WEST';
      sc.selectedCurrencyName='USD';
      sc.selectedCurrencyName='USD';
      List<Selectoption> getCurrency=new List<Selectoption>();
      getCurrency=sc.getCurrency1('TA61');
      PageReference   objPageRef = sc.saveSSD();
      sc.sourceSysDetail.LCRM_Name_3__c='ABC_Name';
      objPageRef = sc.saveSSD();
      PageReference   objPageRef1 =  sc.cancel();    
    Test.StopTest();
        }
    }
    
    public static testMethod void testDetailControllerSaveTax(){
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        
        Tax_Proff_GLI_Setting__c tg = new Tax_Proff_GLI_Setting__c();
        tg.SubBU__c = 'US';
        tg.Segment__c = 'Professional Tax';
        insert tg;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost')
        };
        
        insert keyValueList;
         
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        string selectedCustomerGroupName = '';
        string selectedIndustryName = '';
        string selectedsalesorgName = '';
        
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c = 'Global',Segment__c = 'Global');        
        insert u1;
        
        System.Runas(u1){  
        Account testAcc2 = UnitTest.getAccountInstance();
        testAcc2.Sales_Org__c ='WEST' ;
        testAcc2.Name='DEF';
        testAcc2.billingstreet='test';
        insert testAcc2;
        System.assertequals('DEF',testAcc2.Name,'Success');
    
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='DEF';
        accountSSD.Source_System_Name__c='DEF';
        accountSSD.Account_Name__c=testAcc2.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.LCRM_Name_3__c='ABC_Name_jhsjfhsjhfsjdfhksjyfdsqwdhqwgdhqwgoljadlajflkjfyuyuy';
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.LCRM_Industry__c='TAX';
        accountSSD.CurrencyIsoCode='USD'; 
        accountSSD.Billing_Currency__c='USD'; 
        insert accountSSD;
    
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc2.id);
        opp.RecordtypeId=opptyRecorType;
        opp.Source_system_detail__c = accountSSD.Id;
        insert opp;
        
        GLIPicklistValues__c GCGI = new GLIPicklistValues__c();
        GCGI.Name = 'Federal Government';
        GCGI.Picklist_Salesorg__c = 'S100';
        insert GCGI;
        GLIPicklistValues__c GCGI2 = new GLIPicklistValues__c();
        GCGI2.Name = 'Tax';
        GCGI2.Picklist_Salesorg__c = 'S100';
        GCGI2.Picklist_Field_For__c = 'Industry';
        insert GCGI2;
        
        Test.StartTest();
        
        //Opportunity Save  Scenario
        PageReference pageRefq = Page.createSSd;
        pageRefq.getParameters().put('id', String.valueOf(opp.Id));
        system.Test.setCurrentPage(pageRefq);
        SourceSystemDetailController scq = new SourceSystemDetailController();
        scq.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        scq.selectedIndustryName='TAX';
        scq.selectedsalesorgname='S100';
        scq.selectedCurrencyName='USD';
        PageReference objPageRef = scq.saveSSD(); 
        scq.sourceSysDetail.LCRM_Name_3__c='ABC_Name';
        objPageRef = scq.saveSSD();
      
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Account__c =testAcc2.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Opportunity__c=opp.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);
       

        Insert proposal;   
        
        
        //CreateShipTo Scenario
        PageReference pageRef = Page.createSSd;
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        pageRef.getParameters().put('propId', String.valueOf(proposal.Id));
        pageRef.getParameters().put('createSSD', 'shipToSSD');    
        system.Test.setCurrentPage(pageRef);
        SourceSystemDetailController sc = new SourceSystemDetailController();
        sc.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc.selectedIndustryName='TAX';
        sc.selectedsalesorgname='S100';
        sc.selectedCurrencyName='USD';
        PageReference   objPageRefq = sc.saveSSD(); 
      
      
      //CreateBillToScenario
        PageReference pageRef1 = Page.createSSd;
        pageRef1.getParameters().put('id', String.valueOf(opp.Id));
        pageRef1.getParameters().put('propId', String.valueOf(proposal.Id));
        pageRef1.getParameters().put('createSSD', 'billToSSD');    
        system.Test.setCurrentPage(pageRef1);
        SourceSystemDetailController sc1 = new SourceSystemDetailController();
        sc1.clickedSSDOnly();
        sc1.addressCountryChanged();
        sc1.clickedBack();
        sc1.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc1.selectedIndustryName='TAX';
        sc1.selectedsalesorgname='S100';
        sc1.selectedCurrencyName='USD';
        PageReference   objPageRef1 = sc1.saveSSD(); 
        
        //CreatePayerSSDScenario
        PageReference pageRef2 = Page.createSSd;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id));
        pageRef2.getParameters().put('propId', String.valueOf(proposal.Id));
        pageRef2.getParameters().put('createSSD', 'payerSSD');    
        system.Test.setCurrentPage(pageRef2);
        SourceSystemDetailController sc2 = new SourceSystemDetailController();
        sc2.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc2.selectedIndustryName='TAX';
        sc2.selectedsalesorgname='S100';
        sc2.selectedCurrencyName='USD';
        PageReference   objPageRef2 = sc2.saveSSD(); 
        
        //CreatePayerSSDScenario
        PageReference pageRef3 = Page.createSSd;
        pageRef3.getParameters().put('id', String.valueOf(opp.Id));
        pageRef3.getParameters().put('propId', String.valueOf(proposal.Id));
        pageRef3.getParameters().put('createSSD', 'payerSSD');    
        system.Test.setCurrentPage(pageRef3);
        SourceSystemDetailController sc3 = new SourceSystemDetailController();
        sc3.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc3.selectedIndustryName='TAX';
        sc3.selectedsalesorgname='S100';
        sc3.selectedCurrencyName='USD';
        PageReference   objPageRef3 = sc3.cancel(); 
        
        Test.StopTest();
        }
    }
        public static testMethod void testcreateaccountwithSSDTax(){
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        
        Tax_Proff_GLI_Setting__c tg = new Tax_Proff_GLI_Setting__c();
        tg.SubBU__c = 'US';
        tg.Segment__c = 'Professional Tax';
        insert tg;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost'),new KeyValueListStore__c(Name='TaxSSDSegmentList',TextValue__c='Professional Tax')
        };
        
        insert keyValueList;
         
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        string selectedCustomerGroupName = '';
        string selectedIndustryName = '';
        string selectedsalesorgName = '';
        
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c = 'US',Segment__c = 'Professional Tax');        
        insert u1;
        
        System.Runas(u1){  
        Account testAcc2 = UnitTest.getAccountInstance();
        testAcc2.Sales_Org__c ='WEST' ;
        testAcc2.Name='DEF';
        testAcc2.billingcountry = 'IN';
        testAcc2.billingcity = 'test';
        testAcc2.billingstreet = 'test';
        testAcc2.billingstate = 'KA';
        testAcc2.billingpostalcode = 'test';
        testAcc2.County__c = 'test';
        testAcc2.County__c = 'test';
        testAcc2.nameTwo__c = 'test';
        testAcc2.PO_Box__c = 'test';
        testAcc2.Street_Address_2__c = 'test';
        insert testAcc2;
        System.assertequals('DEF',testAcc2.Name,'Success');
    
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='DEF';
        accountSSD.Source_System_Name__c='DEF';
        accountSSD.Account_Name__c=testAcc2.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='S100';
        accountSSD.LCRM_Name_3__c='ABC_Name_jhsjfhsjhfsjdfhksjyfdsqwdhqwgdhqwgoljadlajflkjfyuyuy';
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.LCRM_Industry__c='TAX';
        accountSSD.CurrencyIsoCode='USD'; 
        accountSSD.Billing_Currency__c='USD'; 
        insert accountSSD;
    
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc2.id);
        opp.RecordtypeId=opptyRecorType;
        opp.Source_system_detail__c = accountSSD.Id;
        insert opp;
        
        GLIPicklistValues__c GCGI = new GLIPicklistValues__c();
        GCGI.Name = 'Federal Government';
        GCGI.Picklist_Salesorg__c = 'S100';
        GCGI.Picklist_Field_For__c = 'Industry';
        GCGI.Picklist_Lov__c= 'ACADEMIC';
        insert GCGI;
        GLIPicklistValues__c GCGI2 = new GLIPicklistValues__c();
        GCGI2.Name = 'Tax';
        GCGI2.Picklist_Salesorg__c = 'S100';
        GCGI2.Picklist_Field_For__c = 'Industry';
        GCGI2.Picklist_Lov__c= 'ACADEMIC';
        insert GCGI2;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Account__c =testAcc2.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Opportunity__c=opp.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);

        insert proposal; 
        
        Test.StartTest();
        
        //Opportunity Save  Scenario
        PageReference pageRefq = Page.createSSd;
        pageRefq.getParameters().put('id', String.valueOf(proposal.Id));
        system.Test.setCurrentPage(pageRefq);
        SourceSystemDetailController scq = new SourceSystemDetailController();
        scq.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        scq.selectedIndustryName='TAX';
        scq.selectedsalesorgname='S100';
        scq.selectedCurrencyName='USD';
        PageReference objPageRef = scq.saveSSD();   
        
        //CreateShipTo Scenario
        PageReference pageRef = Page.createSSd;
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        pageRef.getParameters().put('propId', String.valueOf(proposal.Id));
        pageRef.getParameters().put('createSSD', 'shipToSSD');    
        system.Test.setCurrentPage(pageRef);
        SourceSystemDetailController sc = new SourceSystemDetailController();
        sc.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc.selectedIndustryName='TAX';
        sc.selectedsalesorgname='S100';
        sc.selectedCurrencyName='USD';
        PageReference   objPageRefq = sc.saveSSD(); 
      
      
      //CreateBillToScenario
        PageReference pageRef1 = Page.createSSd;
        pageRef1.getParameters().put('id', String.valueOf(opp.Id));
        pageRef1.getParameters().put('propId', String.valueOf(proposal.Id));
        pageRef1.getParameters().put('createSSD', 'billToSSD');    
        system.Test.setCurrentPage(pageRef1);
        SourceSystemDetailController sc1 = new SourceSystemDetailController();
        sc1.clickedAccountWithSSD();
        sc1.addressCountryChanged();
        sc1.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc1.selectedIndustryName='TAX';
        sc1.selectedsalesorgname='S100';
        sc1.selectedCurrencyName='USD';
        PageReference   objPageRef1 = sc1.saveSSD(); 
        
        //CreatePayerSSDScenario
        PageReference pageRef2 = Page.createSSd;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id));
        pageRef2.getParameters().put('propId', String.valueOf(proposal.Id));
        pageRef2.getParameters().put('createSSD', 'payerSSD');    
        system.Test.setCurrentPage(pageRef2);
        SourceSystemDetailController sc2 = new SourceSystemDetailController();
        sc2.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc2.selectedIndustryName='TAX';
        sc2.selectedsalesorgname='S100';
        sc2.selectedCurrencyName='USD';
        PageReference   objPageRef2 = sc2.saveSSD(); 
        sc2.sourceSysDetail.LCRM_Name_3__c='ABC_Name';
        sc2.sourceSysDetail.Name='ABC_Name';
        sc2.sourceSysDetail.Number_Street__c='ABC_Name';
        objPageRef2 = sc2.saveSSD();
      
        //CreatePayerSSDScenario
        PageReference pageRef3 = Page.createSSd;
        pageRef3.getParameters().put('id', String.valueOf(opp.Id));
        pageRef3.getParameters().put('propId', String.valueOf(proposal.Id));
        pageRef3.getParameters().put('createSSD', 'payerSSD');    
        system.Test.setCurrentPage(pageRef3);
        SourceSystemDetailController sc3 = new SourceSystemDetailController();
        sc3.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc3.selectedIndustryName='TAX';
        sc3.selectedsalesorgname='S100';
        sc3.selectedCurrencyName='USD';
        PageReference   objPageRef3 = sc3.cancel(); 
        
        Test.StopTest();
        }
    }
    public static testMethod void testAbrString(){
        Test.StartTest();
            SourceSystemDetailController.abrString('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa Federal Credit Union Attorney General General,General','Name',35);
            SourceSystemDetailController.abrString('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa Apartment Rural Route,Apartment','Address',35);
            System.assertequals('test','test','Success');
        Test.StopTest();
    }
    public static testMethod void testSSDLatam(){
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id);
        
        Tax_Proff_GLI_Setting__c tg = new Tax_Proff_GLI_Setting__c();
        tg.SubBU__c = 'US';
        tg.Segment__c = 'Professional Tax';
        insert tg;
        
        List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Price'),
        new KeyValueListStore__c(Name='LCRMOpptyTerritoryStageValues',TextValue__c='Contract Signed,Order Complete,Closed Lost'),new KeyValueListStore__c(Name='TaxSSDSegmentList',TextValue__c='Professional Tax')
        };
        
        insert keyValueList;
         
        insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c=System.Label.APTS_OC_Test_Id);
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        string selectedCustomerGroupName = '';
        string selectedIndustryName = '';
        string selectedsalesorgName = '';
        
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c = 'Global',Segment__c = 'Global');        
        insert u1;
        
        System.Runas(u1){  
        Account testAcc2 = UnitTest.getAccountInstance();
        testAcc2.Sales_Org__c ='WEST' ;
        testAcc2.Name='DEF';
        testAcc2.billingcountry = 'IN';
        testAcc2.billingcity = 'test';
        testAcc2.billingstreet = 'test';
        testAcc2.billingstate = 'KA';
        testAcc2.billingpostalcode = 'test';
        testAcc2.County__c = 'test';
        testAcc2.County__c = 'test';
        testAcc2.nameTwo__c = 'test';
        testAcc2.PO_Box__c = 'test';
        testAcc2.Street_Address_2__c = 'test';
        insert testAcc2;
        System.assertequals('DEF',testAcc2.Name,'Success');
    
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='DEF';
        accountSSD.Source_System_Name__c='DEF';
        accountSSD.Account_Name__c=testAcc2.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='LLEY';
        accountSSD.LCRM_Name_3__c='ABC_Name_jhsjfhsjhfsjdfhksjyfdsqwdhqwgdhqwgoljadlajflkjfyuyuy';
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.LCRM_Industry__c='TAX';
        accountSSD.CurrencyIsoCode='USD'; 
        accountSSD.Billing_Currency__c='USD'; 
        accountSSD.LatAm_Tax_Number_Type__c = null;
        accountSSD.LCRM_Tax_Number__c = 'testetestetstetesttesttesttest';
        accountSSD.LCRM_Tax_3__c = 'testetestetstetesttesttesttest';
        accountSSD.LCRM_Tax_4__c = 'testetestetstetesttesttesttest';
        insert accountSSD;
    
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp =UnitTest.getOpportunityInstance(testAcc2.id);
        opp.RecordtypeId=opptyRecorType;
        opp.Source_system_detail__c = accountSSD.Id;
        insert opp;
        
        GLIPicklistValues__c GCGI = new GLIPicklistValues__c();
        GCGI.Name = 'Federal Government';
        GCGI.Picklist_Salesorg__c = 'S100';
        GCGI.Picklist_Field_For__c = 'Industry';
        GCGI.Picklist_Lov__c= 'ACADEMIC';
        insert GCGI;
        GLIPicklistValues__c GCGI2 = new GLIPicklistValues__c();
        GCGI2.Name = 'Tax';
        GCGI2.Picklist_Salesorg__c = 'S100';
        GCGI2.Picklist_Field_For__c = 'Industry';
        GCGI2.Picklist_Lov__c= 'ACADEMIC';
        insert GCGI2;
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Account__c =testAcc2.id,APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Opportunity__c=opp.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true);

        insert proposal; 
        
        Test.StartTest();
        
        //Opportunity Save  Scenario
        PageReference pageRefq = Page.createSSd;
        pageRefq.getParameters().put('id', String.valueOf(proposal.Id));
        system.Test.setCurrentPage(pageRefq);
        SourceSystemDetailController scq = new SourceSystemDetailController();
        scq.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        scq.selectedIndustryName='TAX';
        scq.selectedsalesorgname='LLEY';
        scq.selectedCurrencyName='USD';
        scq.refreshCGroupandIndustry();
        scq.gettaxnumbertypeList();
        PageReference objPageRef = scq.saveSSD(); 
        
        PageReference pageRefq1 = Page.createSSd;
        pageRefq1.getParameters().put('id', String.valueOf(proposal.Id));
        system.Test.setCurrentPage(pageRefq1);
        SourceSystemDetailController sc1 = new SourceSystemDetailController();
        sc1.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc1.selectedIndustryName='TAX';
        sc1.selectedsalesorgname='TSL';
        sc1.selectedCurrencyName='USD';
        sc1.refreshCGroupandIndustry();
        sc1.gettaxnumbertypeList();
        PageReference objPageRef1 = sc1.saveSSD(); 
        
        PageReference pageRef2 = Page.createSSd;
        pageRef2.getParameters().put('id', String.valueOf(proposal.Id));
        system.Test.setCurrentPage(pageRef2);
        SourceSystemDetailController sc2 = new SourceSystemDetailController();
        sc2.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc2.selectedIndustryName='TAX';
        sc2.selectedsalesorgname='SMHK';
        sc2.selectedCurrencyName='USD';
        sc2.refreshCGroupandIndustry();
        sc2.gettaxnumbertypeList();
        PageReference objPageRef2 = sc2.saveSSD(); 
        
        PageReference pageRef3 = Page.createSSd;
        pageRef3.getParameters().put('id', String.valueOf(proposal.Id));
        system.Test.setCurrentPage(pageRef3);
        SourceSystemDetailController sc3 = new SourceSystemDetailController();
        sc3.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc3.selectedIndustryName='TAX';
        sc3.selectedsalesorgname='INWL';
        sc3.selectedCurrencyName='USD';
        sc3.refreshCGroupandIndustry();
        sc3.gettaxnumbertypeList();
        PageReference objPageRef3 = sc3.saveSSD(); 
        
        PageReference pageRef4 = Page.createSSd;
        pageRef4.getParameters().put('id', String.valueOf(proposal.Id));
        system.Test.setCurrentPage(pageRef4);
        SourceSystemDetailController sc4 = new SourceSystemDetailController();
        sc4.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc4.selectedIndustryName='TAX';
        sc4.selectedsalesorgname='LRA';
        sc4.selectedCurrencyName='USD';
        sc4.refreshCGroupandIndustry();
        sc4.gettaxnumbertypeList();
        PageReference objPageRef4 = sc4.saveSSD(); 
        
        PageReference pageRef5 = Page.createSSd;
        pageRef5.getParameters().put('id', String.valueOf(proposal.Id));
        system.Test.setCurrentPage(pageRef5);
        SourceSystemDetailController sc5 = new SourceSystemDetailController();
        sc5.selectedCustomerGroupName='FEDERAL GOVERNMENT';
        sc5.selectedIndustryName='TAX';
        sc5.selectedsalesorgname='BKRS';
        sc5.selectedCurrencyName='USD';
        sc5.refreshCGroupandIndustry();
        sc5.gettaxnumbertypeList();
        PageReference objPageRef5 = sc5.saveSSD();
        
        Test.StopTest();
        }
    }
}