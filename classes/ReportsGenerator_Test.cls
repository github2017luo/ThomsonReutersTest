/**
===============================================================================
ReportsGenerator_Test
===============================================================================

PURPOSE:      Contains all the testMethods for ReportsGenerator.cls

FUNCTIONALITY:  

COMMENTS:    
CHANGE HISTORY
===============================================================================
DATE             NAME          DESC
2011-12-01      Partha        Created
2017-03-31      Karthi        Optimized the coverage as per JIRA STORY: PS0-1
===============================================================================
*/
@isTest
private class ReportsGenerator_Test {
    
    static testMethod void CoverFunction(){ 
        //Test.startTest(); 
        Account Acc = UnitTest.getAccountInstance();
        Acc.BillingStreet = '18321 kerrville';
        Acc.BillingCity = 'lakeville';
        Acc.BillingCountry = 'US';
        Acc.BillingState = 'MN';
        Acc.BillingPostalCode = '55044';
        acc.Sapaccountnumber__c='1';
        acc.Sales_Org__c = 'EDIC';
        insert Acc; 
        
        Account Acc1 = UnitTest.getAccountInstance();
        Acc1.BillingStreet = '18321 kerrville';
        Acc1.BillingCity = 'lakeville';
        Acc.BillingCountry = 'US';
        Acc.BillingState = 'MN';
        Acc1.BillingPostalCode = '55044';
        acc1.Sapaccountnumber__c='11';
        insert Acc1;
        
        Account Acc2 = UnitTest.getAccountInstance();
        Acc2.BillingStreet = '18321 kerrville';
        Acc2.BillingCity = 'lakeville';
        Acc.BillingCountry = 'US';
        Acc.BillingState = 'MN';
        Acc2.BillingPostalCode = '55044';
        acc2.Sapaccountnumber__c='';
        acc2.Sales_Org__c = 'EDIC';
        insert Acc2; 
        
        
        
        Source_System_Detail__c sc =new Source_System_Detail__c();
        sc.Name='TestSSD';
        sc.Account_Name__c=Acc.id;
        sc.LCRM_Sales_Org__c='WEST';
        sc.Source_System_Name__c='testSSD';
        sc.Source_System_Account_Number__c='1000405629';
        
        Insert sc;
        
        Source_System_Detail__c sc1 =new Source_System_Detail__c();
        sc1.Name='TestSSD1';
        sc1.Account_Name__c=Acc.id;
        sc.LCRM_Sales_Org__c='EDIC';
        sc1.Source_System_Name__c='testSSD1';
        sc1.Source_System_Account_Number__c='1000405629';
        Insert sc1;
        
        Source_System_Detail__c sc2 =new Source_System_Detail__c();
        sc2.Name='TestSSD2';
        sc2.Account_Name__c=Acc1.id;
        sc.LCRM_Sales_Org__c='WEST';
        sc2.Source_System_Name__c='testSSD2';
        Insert sc2;
        
        KeyValueListStore__c cs =new KeyValueListStore__c();
        cs.Name='LCRMSubBuValues';
        cs.TextValue__c='USL,LMS,FindLaw';
        
        insert cs;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'newUr91', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user001232@mydomain.com',Rep_Type_Description__c = 'Acct Manager');        
        insert u1;
        
        ESC_GSI_Comms_Payment_Model_Mapping__c comms1 = new ESC_GSI_Comms_Payment_Model_Mapping__c ();
        comms1.ESC_GSI_Rep_Type_Description__c = 'Acct Manager';
        comms1.ESC_GSI_Model_Type__c  = 'Model 1';
        insert comms1;
        
        KeyValueListStore__c KVL =new KeyValueListStore__c ();
        KVL.TextValue__c='LCRMSubBuValues';
        KVL.Name='TestSDD';
        
        insert KVL;
        
        
        List<ExternalReport__c> reportlist = new List<ExternalReport__c>();
        
        ExternalReport__c testReport = new ExternalReport__c(System_Type__c='Webapplication',Display_Level__c ='Global', Report_System_Name__c='test',Available_for_Use__c=true,Name='test',Location__c='<test>');
        reportlist.add(testReport);
        
        ExternalReport__c testReport0 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='/<account:sapaccountnumber__c>-SAE');
        reportlist.add(testReport0);
        
        ExternalReport__c testReport1 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='?<account:BillingState>-SAE.xls');
        reportlist.add(testReport1);
        
        ExternalReport__c testReport2= new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                             Location__c='<User:Rep_Employee_Number__c>-SAE.xls');
        reportlist.add(testReport2);
        
        ExternalReport__c testReport3 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='<User:lastname>-SAE.xls');
        reportlist.add(testReport3);
        
        ExternalReport__c testReport4 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='<Business_Partner_Function__c:sapaccountnumber__c:Sapaccountnumber__c>-SAE.xls');
        reportlist.add(testReport4);      
        
        
        insert reportlist;
        
        Business_Partner_Function__c testBusinessPartnerFunction = new Business_Partner_Function__c(Related_Account__c = Acc.Id,sold_to_Account__c = Acc.Id,Related_Account_GLI__c=sc1.id,Sold_To_Account_GLI__c=sc1.id,Relationship_Type__c='sapaccountnumber__c');  
        insert testBusinessPartnerFunction;
        
        List<URL_Parameter__c> paralist = new List<URL_Parameter__c>();
        URL_Parameter__c testURLpara1 = new URL_Parameter__c(Parameter_Type__c='Default',Data_Type__c='String',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c'); //Query String
        paralist.add(testURLpara1);
        URL_Parameter__c testURLpara2 = new URL_Parameter__c(Parameter_Type__c='Field',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c');
        paralist.add(testURLpara2);
        URL_Parameter__c testURLpara5 = new URL_Parameter__c(Parameter_Type__c='Default',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c:Contact'); //Query String
        paralist.add(testURLpara5);
        URL_Parameter__c testURLpara6 = new URL_Parameter__c(Parameter_Type__c='Field',Data_Type__c='String',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c:Contact');
        paralist.add(testURLpara6);
        URL_Parameter__c testURLpara3 = new URL_Parameter__c(Parameter_Type__c='Query String',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c');
        paralist.add(testURLpara3);
        URL_Parameter__c testURLpara4 = new URL_Parameter__c(Parameter_Type__c='Query String',Data_Type__c='String',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c:Contact');
        paralist.add(testURLpara4);         
        
        
        
        insert paralist;
        Test.startTest(); 
        System.runAs(u1){        
            ReportsGenerator reportsGeneratorObject = new ReportsGenerator();
            reportsGeneratorObject.searchText = 'test';
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.searchText = '';
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.accountid=acc.id;
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.pageDisplay=true;
            
            // acc.sapaccountnumber__c = '';
            // Update acc;
            reportsGeneratorObject.getListWrapReportsObj();
            
            reportsGeneratorObject.repDisplay();
            for(ExternalReport__c otestReport : reportlist){    
                ReportsGenerator.wrapReports wrapReportsobject = new ReportsGenerator.wrapReports(otestReport,Acc.Id,u1.employeenumber,acc.Sapaccountnumber__c,acc.Sales_Org__c);
            }
            
            testBusinessPartnerFunction.Related_Account__c =Acc1.Id;
            update testBusinessPartnerFunction;
            
            ReportsGenerator.wrapReports wrapReportsobject = new ReportsGenerator.wrapReports(testReport4,Acc.Id,u1.employeenumber,acc.Sapaccountnumber__c,acc.Sales_Org__c);
            reportsGeneratorObject.showSearch();
        }
             
        
        Test.stopTest();    
    } 
    //CRM-6396   
    @isTest
    static void SSDfunctionality(){
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u2 = new User(alias = 'new78', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144021',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain78.com',Sub_Bu__c='Canada');
        
        insert u2;
        
        System.debug('Sub_Bu__c U2 : '+u2.Sub_Bu__c);
        
        List<ExternalReport__c> reportlist = new List<ExternalReport__c>();
        
        KeyValueListStore__c cs =new KeyValueListStore__c();
        cs.Name='LCRMSubBuValues';
        cs.TextValue__c='USL,LMS,FindLaw,Canada';
        insert cs;
        
        Account Acc = UnitTest.getAccountInstance();
        Acc.BillingStreet = '18321 kerrville';
        Acc.BillingCity = 'lakeville';
        Acc.BillingCountry = 'US';
        Acc.BillingState = 'MN';
        Acc.BillingPostalCode = '55044';
        acc.Sapaccountnumber__c='1';
        acc.Sales_Org__c = 'WEST';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
        insert Acc; 
        
        Source_System_Detail__c sc1 =new Source_System_Detail__c();
        sc1.Name='TestSSD1';
        sc1.Account_Name__c=Acc.id;
        sc1.LCRM_Sales_Org__c='WEST';
        sc1.Source_System_Name__c='testSSD1';
        sc1.Source_System_Account_Number__c='1000405629';
        //sc1.Account_Name__r.SAPAccountNumber__c = 1000405629; 
        //sc1.Account_Name__r.Sales_Org__c = 'WEST';
        sc1.RecordTypeid =  Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        Insert sc1;      
        
        ExternalReport__c testReport = new ExternalReport__c(System_Type__c='Webapplication',
                                                             Display_Level__c ='Global;Account;SSD',
                                                             Report_System_Name__c='GLI LMA Report Test',
                                                             Available_for_Use__c=true,
                                                             LCRM_SUB_BU__c='USL;Canada',
                                                             Name='test',
                                                             LCRM_Is_GLI__c = true,
                                                             Location__c='https://www.index.html');
        reportlist.add(testReport);
        
         
        insert reportlist;
        //insert reportlist;
        List<URL_Parameter__c> paralist = new List<URL_Parameter__c>();
        for(ExternalReport__c testext :reportlist ){
            URL_Parameter__c testURLpara4 = new URL_Parameter__c();
            testURLpara4.name = 'test0';
            testURLpara4.Parameter_Type__c='Query String';
            testURLpara4.Data_Type__c='Numeric';
            testURLpara4.ExternalReport__c=testext.id;
            testURLpara4.Value__c ='Business_Partner_Function__c:WESTLAW Reporting:Source_System_Account_Number__c';
            paralist.add(testURLpara4);
        }
       
        
        
        
        
        insert paralist;
        
        
        Business_Partner_Function__c testBusinessPartnerFunction = new Business_Partner_Function__c(Related_Account__c = Acc.Id,
                                                                                                    sold_to_Account__c = Acc.Id,
                                                                                                    Related_Account_GLI__c=sc1.id,
                                                                                                    Sold_To_Account_GLI__c=sc1.id,
                                                                                                    Relationship_Type__c='WESTLAW Reporting');  
        insert testBusinessPartnerFunction;
        
        
        
        System.runAs(u2){
            test.startTest();           
            
            ApexPages.StandardController sc = new ApexPages.StandardController(sc1);           
            
            PageReference pageRef = Page.SourceSystemDetail_Report; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(sc1.Id));
            Test.setCurrentPage(pageRef);
            
            ReportsGenerator reportsGeneratorObject = new ReportsGenerator(); 
            reportsGeneratorObject.SSDId = sc1.id;   
            reportsGeneratorObject.getListWrapReportsObj();
                        
 System.debug(' reportsGeneratorObject.getListWrapReportsObj()'+ reportsGeneratorObject.getListWrapReportsObj().size());
 system.assertEquals(1, reportsGeneratorObject.getListWrapReportsObj().size());
            reportsGeneratorObject.pageDisplay=true;
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.searchText = 'test';            
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.searchText = '';            
            reportsGeneratorObject.getListWrapReportsObj();
            

                       
            reportsGeneratorObject.repDisplay();
            for(ExternalReport__c otestReport : reportlist){ 
                ReportsGenerator.wrapReports wrapReportsobject = new ReportsGenerator.wrapReports(
                    otestReport,
                    Acc.Id,
                    u2.employeenumber,
                    sc1.Source_System_Account_Number__c,
                    sc1.LCRM_Sales_Org__c);
                
            }
            
            
            
            test.stopTest(); 
        }
        
        
        
        
    }
    
     @isTest
    static void testSSDfunctionality(){
        List<Account> acclist = new List<Account>();
        List<Source_System_Detail__c> ssdlist = new List<Source_System_Detail__c>();
        //Test.startTest(); 
        Account Acc = UnitTest.getAccountInstance();
        Acc.BillingStreet = '18321 kerrville';
        Acc.BillingCity = 'lakeville';
        Acc.BillingCountry = 'US';
        Acc.BillingState = 'MN';
        Acc.BillingPostalCode = '55044';
        acc.Sapaccountnumber__c='1';
        acc.Sales_Org__c = 'EDIC';
        acclist.add(Acc); 
        
        Account Acc1 = UnitTest.getAccountInstance();
        Acc1.BillingStreet = '18321 kerrville';
        Acc1.BillingCity = 'lakeville';
        Acc.BillingCountry = 'US';
        Acc.BillingState = 'MN';
        Acc1.BillingPostalCode = '55044';
        acc1.Sapaccountnumber__c='11';
        acclist.add(Acc1);
        insert acclist;
       
        
       
        
        Source_System_Detail__c sc =new Source_System_Detail__c();
        sc.Name='TestSSD';
        sc.Account_Name__c=Acc.id;
        sc.LCRM_Sales_Org__c='WEST';
        sc.Source_System_Name__c='testSSD';
        sc.Source_System_Account_Number__c='1000405629';
        
        ssdlist.add(sc);
        
        Source_System_Detail__c sc1 =new Source_System_Detail__c();
        sc1.Name='TestSSD1';
        sc1.Account_Name__c=Acc.id;
        sc.LCRM_Sales_Org__c='EDIC';
        sc1.Source_System_Name__c='testSSD1';
        sc1.Source_System_Account_Number__c='1000405629';
        ssdlist.add(sc1);
        insert ssdlist; 
        
        KeyValueListStore__c cs =new KeyValueListStore__c();
        cs.Name='LCRMSubBuValues';
        cs.TextValue__c='USL,LMS,FindLaw';
        
        insert cs;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'newUr33', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id,employeenumber='0144022',
                           timezonesidkey='America/Los_Angeles', username='user003432@mydomain.com',Rep_Type_Description__c='Acct Manager');        
        insert u1;
        
        
        ESC_GSI_Comms_Payment_Model_Mapping__c comms1 = new ESC_GSI_Comms_Payment_Model_Mapping__c ();
        comms1.ESC_GSI_Rep_Type_Description__c = 'Acct Manager';
        comms1.ESC_GSI_Model_Type__c  = 'Model 2';
        insert comms1;
        
        List<ExternalReport__c> reportlist = new List<ExternalReport__c>();
        
        ExternalReport__c testReport = new ExternalReport__c(System_Type__c='Webapplication',Display_Level__c ='Global', Report_System_Name__c='test',Available_for_Use__c=true,Name='test',Location__c='<test>');
        reportlist.add(testReport);
        
        ExternalReport__c testReport0 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='/<account:sapaccountnumber__c>-SAE');
        reportlist.add(testReport0);
        
       ExternalReport__c testReport1 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='?<account:BillingState>-SAE.xls');
        reportlist.add(testReport1);
        
        ExternalReport__c testReport2= new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                             Location__c='<User:Rep_Employee_Number__c>-SAE.xls');
        reportlist.add(testReport2);
        
        ExternalReport__c testReport3 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='<User:lastname>-SAE.xls');
        reportlist.add(testReport3);
        
        ExternalReport__c testReport4 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='<Business_Partner_Function__c:sapaccountnumber__c:Sapaccountnumber__c>-SAE.xls');
        reportlist.add(testReport4);      
        
        ExternalReport__c testReport5 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='<Source_System_Detail__c:Source_System_Account_Number__c>-SAE.xls');
        reportlist.add(testReport5);  
        
        ExternalReport__c testReport6 = new ExternalReport__c(System_Type__c='Filesystem',Report_System_Name__c='test',Available_for_Use__c=true,Name='test',
                                                              Location__c='<Source_System_Detail__c:Name>-SAE.xls');
        reportlist.add(testReport6);  
        
        
        insert reportlist;
        
        Business_Partner_Function__c testBusinessPartnerFunction = new Business_Partner_Function__c(Related_Account__c = Acc.Id,sold_to_Account__c = Acc.Id,Related_Account_GLI__c=sc1.id,Sold_To_Account_GLI__c=sc1.id,Relationship_Type__c='sapaccountnumber__c');  
        insert testBusinessPartnerFunction;
        List<URL_Parameter__c> paralist = new List<URL_Parameter__c>();
        URL_Parameter__c testURLpara1 = new URL_Parameter__c(Parameter_Type__c='Default',Data_Type__c='String',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c'); //Query String
        paralist.add(testURLpara1);
        URL_Parameter__c testURLpara2 = new URL_Parameter__c(Parameter_Type__c='Field',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c');
        paralist.add(testURLpara2);
        URL_Parameter__c testURLpara5 = new URL_Parameter__c(Parameter_Type__c='Default',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c:Contact'); //Query String
        paralist.add(testURLpara5);
        URL_Parameter__c testURLpara6 = new URL_Parameter__c(Parameter_Type__c='Field',Data_Type__c='String',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c:Contact');
        paralist.add(testURLpara6);
        URL_Parameter__c testURLpara3 = new URL_Parameter__c(Parameter_Type__c='Query String',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c');
        paralist.add(testURLpara3);
        URL_Parameter__c testURLpara4 = new URL_Parameter__c(Parameter_Type__c='Query String',Data_Type__c='String',ExternalReport__c=testReport.Id, Value__c ='Account:SAPAccountNumber__c:Contact');
        paralist.add(testURLpara4);         
               
        
        insert paralist;
        
        
        Test.startTest(); 
        System.runAs(u1){        
            ReportsGenerator reportsGeneratorObject = new ReportsGenerator();
            reportsGeneratorObject.searchText = 'test';
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.searchText = '';
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.accountid=acc.id;
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.pageDisplay=true;
            
            // acc.sapaccountnumber__c = '';
            // Update acc;
            reportsGeneratorObject.getListWrapReportsObj();
            
            reportsGeneratorObject.repDisplay();
            Test.stopTest();
            /*for(ExternalReport__c otestReport : reportlist){    
                ReportsGenerator.wrapReports wrapReportsobject = new ReportsGenerator.wrapReports(otestReport,Acc.Id,u1.employeenumber,acc.Sapaccountnumber__c,acc.Sales_Org__c);
            }*/
            
            testBusinessPartnerFunction.Related_Account__c =acc1.Id;
            update testBusinessPartnerFunction;
            
           /* ReportsGenerator.wrapReports wrapReportsobject = new ReportsGenerator.wrapReports(testReport6,Acc.Id,u1.employeenumber,acc.Sapaccountnumber__c,acc.Sales_Org__c);
            reportsGeneratorObject.showSearch();*/
        }
             
        
        
       }
      
          @istest
        static void SSDfunctionality2(){
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u2 = new User(alias = 'new78', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144023',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain78.com',Sub_Bu__c='Canada');
        
        insert u2;
        
        System.debug('Sub_Bu__c U2 : '+u2.Sub_Bu__c);
        
        List<ExternalReport__c> reportlist = new List<ExternalReport__c>();
        
        KeyValueListStore__c cs =new KeyValueListStore__c();
        cs.Name='LCRMSubBuValues';
        cs.TextValue__c='USL,LMS,FindLaw,Canada';
        insert cs;
        
        Account Acc = UnitTest.getAccountInstance();
        Acc.BillingStreet = '18321 kerrville';
        Acc.BillingCity = 'lakeville';
        Acc.BillingCountry = 'US';
        Acc.BillingState = 'MN';
        Acc.BillingPostalCode = '55044';
        acc.Sapaccountnumber__c='1';
        acc.Sales_Org__c = 'WEST';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
        insert Acc; 
        
        Source_System_Detail__c sc1 =new Source_System_Detail__c();
        sc1.Name='TestSSD1';
        sc1.Account_Name__c=Acc.id;
        sc1.LCRM_Sales_Org__c='WEST';
        sc1.Source_System_Name__c='testSSD1';
        sc1.Source_System_Account_Number__c='1000405629';
        //sc1.Account_Name__r.SAPAccountNumber__c = 1000405629; 
        //sc1.Account_Name__r.Sales_Org__c = 'WEST';
        sc1.RecordTypeid =  Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        //Insert sc1;      
        
        ExternalReport__c testReport = new ExternalReport__c(System_Type__c='Webapplication',
                                                             Display_Level__c ='Global;Account;SSD',
                                                             Report_System_Name__c='GLI LMA Report Test',
                                                             Available_for_Use__c=true,
                                                             LCRM_SUB_BU__c='USL;Canada',
                                                             Name='test',
                                                             LCRM_Is_GLI__c = true,
                                                             Location__c='https://www.index.html');
        reportlist.add(testReport);
        
         
        insert reportlist;
        //insert reportlist;
        List<URL_Parameter__c> paralist = new List<URL_Parameter__c>();
        for(ExternalReport__c testext :reportlist ){
            URL_Parameter__c testURLpara4 = new URL_Parameter__c();
            testURLpara4.name = 'test0';
            testURLpara4.Parameter_Type__c='Query String';
            testURLpara4.Data_Type__c='Numeric';
            testURLpara4.ExternalReport__c=testext.id;
            testURLpara4.Value__c ='Business_Partner_Function__c:WESTLAW Reporting:Source_System_Account_Number__c';
            paralist.add(testURLpara4);
        }
       
        
        
        
        
        insert paralist;
        
        
        Business_Partner_Function__c testBusinessPartnerFunction = new Business_Partner_Function__c(Related_Account__c = Acc.Id,
                                                                                                    sold_to_Account__c = Acc.Id,
                                                                                                    Related_Account_GLI__c=sc1.id,
                                                                                                    Sold_To_Account_GLI__c=sc1.id,
                                                                                                    Relationship_Type__c='WESTLAW Reporting');  
        insert testBusinessPartnerFunction;
        
        
        
        System.runAs(u2){
            test.startTest();           
            
            ApexPages.StandardController sc = new ApexPages.StandardController(sc1);           
            
            PageReference pageRef = Page.SourceSystemDetail_Report; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(sc1.Id));
            Test.setCurrentPage(pageRef);
            
            ReportsGenerator reportsGeneratorObject = new ReportsGenerator(); 
            reportsGeneratorObject.SSDId = sc1.id;   
            reportsGeneratorObject.getListWrapReportsObj();
                        
 System.debug(' reportsGeneratorObject.getListWrapReportsObj()'+ reportsGeneratorObject.getListWrapReportsObj().size());
 system.assertEquals(1, reportsGeneratorObject.getListWrapReportsObj().size());
            reportsGeneratorObject.pageDisplay=true;
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.searchText = 'test';            
            reportsGeneratorObject.getListWrapReportsObj();
            reportsGeneratorObject.searchText = '';            
            reportsGeneratorObject.getListWrapReportsObj();
            

                       
            reportsGeneratorObject.repDisplay();
            for(ExternalReport__c otestReport : reportlist){ 
                ReportsGenerator.wrapReports wrapReportsobject = new ReportsGenerator.wrapReports(
                    otestReport,
                    Acc.Id,
                    u2.employeenumber,
                    sc1.Source_System_Account_Number__c,
                    sc1.LCRM_Sales_Org__c);
                
            }
            
            
            
            test.stopTest(); 
        }
        
        
        
        
    }
  
      
    }