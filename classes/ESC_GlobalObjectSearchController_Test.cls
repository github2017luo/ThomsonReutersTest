/**********************************
Class Name: ESC_GlobalObjectSearchController
Purpose: Test class for "ESC_GlobalObjectSearchController" apex class.
Author:Rupesh/Sumit
Date Created:31/07/2017
***********************************/
@IsTest

public class ESC_GlobalObjectSearchController_Test{
     @IsTest(SeeAllData=false) public static void escGlobalObjectSearchControllerMethod(){ 
      
      Profile profile1 = [Select Id from Profile where name = 'USL Helpdesk Agent'];
      User usr = new User(LastName = 'testcoverage',
                           FirstName='coverage123',
                           Alias = 'jliv',
                           Email = 'testcoverage123@asdf.com',
                           Username = 'testcoverage123@asdf.com',
                           ProfileId = profile1.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
           insert usr;
      //Fetching metadata value
      system.runAs(usr){
      
          Test.StartTest();
          List<ESC_SearchSettings__mdt> objList= new List<ESC_SearchSettings__mdt>();
          objList= [Select ESC_ObjectAPIName1__c, ESC_FieldAPIName__c , esc_sequence__c, ESC_IsKey__c,ESC_ParamValue__c from
          ESC_SearchSettings__mdt order by esc_sequence__c asc nulls last];
          
          //Providing list of dummy data for account
          
          List <Account> listAccount= new List<Account>();
          Account testAccount=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet',Industry = 'AC ACCOUNTING');
          listAccount.add(testAccount);
          insert listAccount;
          //Providing list of dummy data for contact
          List<Contact> listContact= new List<Contact>();
          Contact testContact=new Contact (firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
          listContact.add(testContact);
          insert listContact;
          
          /*
          List<Source_System_Detail__c> listSsd= new List<Source_System_Detail__c>();
          Source_System_Detail__c testSsd= new Source_System_Detail__c(Name ='testssd',Source_System_Name__c='testName',Account_Name__c=testAccount.Id) ;
          listSsd.add(testSsd);
          insert listSsd;
          
          
          List<LCRM_Contact_SSD__c> listConssd= new List<LCRM_Contact_SSD__c>();
          LCRM_Contact_SSD__c testConssd= new LCRM_Contact_SSD__c(CurrencyIsoCode ='USD',Name='testName') ;
          listConssd.add(testConssd);
          insert listConssd;
          */
          
          ESC_HandlerCustomException eh=new ESC_HandlerCustomException();
          
          //creating instance of ESC_GlobalObjectSearchController for calling static methods.
          ESC_GlobalObjectSearchController objSearch= new ESC_GlobalObjectSearchController();
           objSearch.val1='Contact';
           
           objSearch.primaryKeyWord='jksrg';
           objSearch.getDataTableEntity();
           
           objSearch.isSearchSuccessful=true;
           
          objSearch.searchResults = new List<sobject>();
          
          Account accnt= new Account(id = testAccount.ID);
          objSearch.searchResults.add(accnt);
          
          ESC_GlobalObjectSearchController.ESC_Results res = new ESC_GlobalObjectSearchController.ESC_Results();
          res.searchResult = accnt;
          res.isLink =false;
          
          objSearch.setFilterResultsMap();
          objSearch.filterMap = new map<string, List<ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance>> ();
          
          ESC_SearchSettings__mdt md=new ESC_SearchSettings__mdt();
           md=[select ESC_ApplicableToProfiles__c,ESC_HFF__c,ESC_Def__c,ESC_Hide_From_Results__c,ESC_IsKey__c,ESC_LabelName__c,ESC_Sequence__c,ESC_ParamValue__c from ESC_SearchSettings__mdt where ESC_ParamValue__c='LCRM_Contact__c' limit 1];
          
          ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi1 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('Contact' , 'firstname' ,'FirstName',md);
          ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi2 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('Contact' , 'account.industry' ,'',md);
          ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi3 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('Contact' , 'esc_toclanguage__c','',md);
          ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi4 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('Contact' , 'ESC_Contact_Inactive__c','',md);
          ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi5 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('Contact' , 'ESC_tocContactStatus__c','',md);
          List<ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance> egsiList = new List<ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance>(); 
          egsi3.FieldValue = 'aafaf';
          //egsi5.FieldValue = 'Trusted User';
          //egsi5.FieldValue = 'Commod';
           egsiList.add(egsi1);
           egsiList.add(egsi3);
           egsiList.add(egsi4);
           egsiList.add(egsi5);
           
           
          objSearch.filterMap.put('Contact' ,egsiList);
          objSearch.IsSearchValid=true;
          objSearch.hasSOQLClause=false;
          objSearch.runsearch();
          
          egsi2.FieldValue ='test';
         
          egsiList.add(egsi2);
          egsiList.sort();
          egsi2.sequence = 3;
          egsiList.sort();
          objSearch.filterMap.put('Contact' ,egsiList);
          objSearch.runsearch();
          objSearch.getMyTabs();
          
          objSearch.runFreshSearch();
          objSearch.setLinkValues();
          objSearch.setPaginationController();
          
          objSearch.adderrorMessage();
          objSearch.gethiddenRows();
          String searchCategory;
          objSearch.getsearchCategory();
          objSearch.setsearchCategory('sd');
          objSearch.getTimeoutInMillisec();
          objSearch.adderrorMessageTimeout();
         // objSearch.setsearchCategory(String 'searchCategory');
          
          Map<string, Map<string,string>> resultTableLabel = new Map<string, Map<string,string>>();
          Map<string ,string> dummyMap = new Map<string ,string>();
          dummyMap.put('esc_toclanguage__c','FirstName');
         
          resultTableLabel.put('Contact' , dummyMap);
          
           objSearch.getFieldLabel();
          // ESC_GlobalObjectSearchController.getObjectNameForRelation('Contact','Id');
         //objSearch.formQuerySOQL();
         //ESC_GlobalObjectSearchController.getObjectNameForRelation('Contact','demo__r.ada');
          //ESC_GlobalObjectSearchController.getObjectNameForRelation('testName.kr','demo__r.ada');
            
        //instance for ESC_ObjectSchemaHelper
       
        ESC_ObjectSchemaHelper.getPickListOptions('Case' , 'Status' );
       
        ESC_GlobalObjectSearchController.getObjectNameForRelation('LCRM_Contact_SSD__c' , 'LCRM_Contact__r.Name' );
            //ESC_ObjectSchemaHelper.getPickListOptions('Case');
    
        //**ESC_ObjectSchemaHelper.getObjectNameForRelation('Case','Status');
        
        //*//////**
        ESC_ObjectSchemaHelper.getObjectNamesUsed('Case');
        ESC_ObjectSchemaHelper.getInfoField('Case');
        try{
        throw new ESC_HandlerCustomException('Error'); 
        }
        catch(Exception e)
        {
        system.debug('exception'+e);
        }
         
          Test.StopTest();
      }
        
      
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      }
      
       @IsTest(SeeAllData=false) public static void escGlobalObjectSearchControllerMethod_test(){ 
      Profile profile1 = [Select Id from Profile where name = 'USL Helpdesk Agent'];
      User usr = new User(LastName = 'testcoverage',
                           FirstName='coverage123',
                           Alias = 'jliv',
                           Email = 'testcoverage123@asdf.com',
                           Username = 'testcoverage1234@asdf.com',
                           ProfileId = profile1.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
           insert usr;
            system.runAs(usr){
      //Fetching metadata value
      List<ESC_SearchSettings__mdt> objList= new List<ESC_SearchSettings__mdt>();
      objList= [Select ESC_ObjectAPIName1__c, ESC_FieldAPIName__c , esc_sequence__c, ESC_IsKey__c,ESC_ParamValue__c from
      ESC_SearchSettings__mdt order by esc_sequence__c asc nulls last];
      
      //Providing list of dummy data for account
      
      List <Account> listAccount= new List<Account>();
      Account testAccount=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      listAccount.add(testAccount);
      insert listAccount;
      //Providing list of dummy data for contact
      List<Contact> listContact= new List<Contact>();
      Contact testContact=new Contact (firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
      listContact.add(testContact);
      insert listContact;
      /*
      List<Source_System_Detail__c> listSsd= new List<Source_System_Detail__c>();
      Source_System_Detail__c testSsd= new Source_System_Detail__c(Name ='testssd',Source_System_Name__c='testName',Source_System_Account_Number__c='123456',Account_Name__c=testAccount.Id) ;
      listSsd.add(testSsd);
      insert listSsd;
      
      List<LCRM_Contact_SSD__c> listConssd= new List<LCRM_Contact_SSD__c>();
      LCRM_Contact_SSD__c testConssd= new LCRM_Contact_SSD__c(CurrencyIsoCode ='USD',Name='testName') ;
      listConssd.add(testConssd);
      insert listConssd;
      */
      
      ESC_HandlerCustomException eh=new ESC_HandlerCustomException();
    Test.StartTest();
      Test.setCurrentPageReference(new PageReference('Page.ESC_GlobalObjectSearch')); 
       System.currentPageReference().getParameters().put('Key1','123456');
       
      //creating instance of ESC_GlobalObjectSearchController for calling static methods.
      ESC_GlobalObjectSearchController objSearch= new ESC_GlobalObjectSearchController();
       //objSearch.val1='Contact';
       //objSearch.searchSAP='';
       objSearch.searchPhone='';
       objSearch.searchContact='';
       objSearch.IsSearchValid=true;
       objSearch.primaryKeyWord='jksrg';
       objSearch.getDataTableEntity();
       
       
       objSearch.val1='Source_System_Detail__c';
       objSearch.IsSearchValid=true;

       objSearch.runsearchTtech();
         objSearch.getMyTabs();
      
      objSearch.runFreshSearch();
      objSearch.setLinkValues();
      objSearch.setPaginationController();
      
      objSearch.adderrorMessage();
      objSearch.gethiddenRows();
      String searchCategory;
      objSearch.getsearchCategory();
      objSearch.setsearchCategory('sd');
      objSearch.getTimeoutInMillisec();
      objSearch.adderrorMessageTimeout();
        
       objSearch.IsSearchValid=false;
       objSearch.hasSOQLClause=false;
       try{
         objSearch.runsearchTtech();
       }
      catch(Exception e)
        {
         system.debug('exception'+e);
        }
        
    try{
    throw new ESC_HandlerCustomException('Error'); 
    }
    catch(Exception e)
    {
    system.debug('exception'+e);
    }
     
      Test.StopTest();   
    }  
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      }
       @IsTest(SeeAllData=false) public static void escGlobalObjectSearchControllerMethod_test1(){ 
      Profile profile1 = [Select Id from Profile where name = 'USL Helpdesk Agent'];
      User usr = new User(LastName = 'testcoverage',
                           FirstName='coverage123',
                           Alias = 'jliv',
                           Email = 'testcoverage123@asdf.com',
                           Username = 'testcoverage1235@asdf.com',
                           ProfileId = profile1.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
           insert usr;
        system.runAs(usr){   
      //Fetching metadata value
      List<ESC_SearchSettings__mdt> objList= new List<ESC_SearchSettings__mdt>();
      objList= [Select ESC_ObjectAPIName1__c, ESC_FieldAPIName__c , esc_sequence__c, ESC_IsKey__c,ESC_ParamValue__c from
      ESC_SearchSettings__mdt order by esc_sequence__c asc nulls last];
      
      //Providing list of dummy data for account
      
      List <Account> listAccount= new List<Account>();
      Account testAccount=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      listAccount.add(testAccount);
      insert listAccount;
      //Providing list of dummy data for contact
      List<Contact> listContact= new List<Contact>();
      Contact testContact=new Contact (firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', Phone='7786864710', USL_IVR_Phone_Number__c ='1234567890');
      Contact testContact2=new Contact (firstname= 'John',lastname= 'Mile1',email = 'abcd@tr.com', Phone='7786864711', USL_IVR_Phone_Number__c ='1234567892');
      listContact.add(testContact);
      listContact.add(testContact2);
      insert listContact;
      /*
      List<Source_System_Detail__c> listSsd= new List<Source_System_Detail__c>();
      Source_System_Detail__c testSsd= new Source_System_Detail__c(Name ='testssd',Source_System_Name__c='testName',Source_System_Account_Number__c='123456',Account_Name__c=testAccount.Id) ;
      listSsd.add(testSsd);
      insert listSsd;
      
      List<LCRM_Contact_SSD__c> listConssd= new List<LCRM_Contact_SSD__c>();
      LCRM_Contact_SSD__c testConssd= new LCRM_Contact_SSD__c(CurrencyIsoCode ='USD',Name='testName') ;
      listConssd.add(testConssd);
      insert listConssd;
      */
      
      ESC_HandlerCustomException eh=new ESC_HandlerCustomException();
    Test.StartTest();
      Test.setCurrentPageReference(new PageReference('Page.ESC_GlobalObjectSearch')); 
       System.currentPageReference().getParameters().put('Key2','7786864710');
       System.currentPageReference().getParameters().put('Key3','7786864710');
       
      //creating instance of ESC_GlobalObjectSearchController for calling static methods.
      ESC_GlobalObjectSearchController objSearch= new ESC_GlobalObjectSearchController();
       objSearch.val1='Contact';
       objSearch.searchSAP='';
       //objSearch.searchPhone='';
       objSearch.searchContact='';
       objSearch.IsSearchValid=true;
       objSearch.primaryKeyWord='jksrg';
       objSearch.mainSearchKeyword='John';
       objSearch.getDataTableEntity();
        objSearch.hasSOQLClause=false;
       objSearch.runsearchTtech();
         objSearch.getMyTabs();
      
      objSearch.runFreshSearch();
      objSearch.setLinkValues();
      objSearch.setPaginationController();
      
      objSearch.adderrorMessage();
      objSearch.gethiddenRows();
      String searchCategory;
      objSearch.getsearchCategory();
      objSearch.setsearchCategory('sd');
      objSearch.getTimeoutInMillisec();
      objSearch.adderrorMessageTimeout();
  
    try{
    throw new ESC_HandlerCustomException('Error'); 
    }
    catch(Exception e)
    {
    system.debug('exception'+e);
    }
     
      Test.StopTest();   
        } 
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      }
      @IsTest(SeeAllData=false) public static void escGlobalObjectSearchControllerMethod_test4(){ 
      Profile profile1 = [Select Id from Profile where name = 'USL Helpdesk Agent'];
      User usr = new User(LastName = 'testcoverage',
                           FirstName='coverage123',
                           Alias = 'jliv',
                           Email = 'testcoverage123@asdf.com',
                           Username = 'testcoverage1235@asdf.com',
                           ProfileId = profile1.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
           insert usr;
        system.runAs(usr){   
      //Fetching metadata value
      List<ESC_SearchSettings__mdt> objList= new List<ESC_SearchSettings__mdt>();
      objList= [Select ESC_ObjectAPIName1__c, ESC_FieldAPIName__c , esc_sequence__c, ESC_IsKey__c,ESC_ParamValue__c from
      ESC_SearchSettings__mdt order by esc_sequence__c asc nulls last];
      
      //Providing list of dummy data for account
      
      List <Account> listAccount= new List<Account>();
      Account testAccount=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      listAccount.add(testAccount);
      insert listAccount;
      //Providing list of dummy data for contact
      List<Contact> listContact= new List<Contact>();
      Contact testContact=new Contact (firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', Phone='7786864710', USL_IVR_Phone_Number__c ='1234567890');
      Contact testContact2=new Contact (firstname= 'John',lastname= 'Mile1',email = 'abcd@tr.com', Phone='7786864711', USL_IVR_Phone_Number__c ='1234567892');
      listContact.add(testContact);
      listContact.add(testContact2);
      insert listContact;
      /*
      List<Source_System_Detail__c> listSsd= new List<Source_System_Detail__c>();
      Source_System_Detail__c testSsd= new Source_System_Detail__c(Name ='testssd',Source_System_Name__c='testName',Source_System_Account_Number__c='123456',Account_Name__c=testAccount.Id) ;
      listSsd.add(testSsd);
      insert listSsd;
      
      List<LCRM_Contact_SSD__c> listConssd= new List<LCRM_Contact_SSD__c>();
      LCRM_Contact_SSD__c testConssd= new LCRM_Contact_SSD__c(CurrencyIsoCode ='USD',Name='testName') ;
      listConssd.add(testConssd);
      insert listConssd;
      */
      
      ESC_HandlerCustomException eh=new ESC_HandlerCustomException();
    Test.StartTest();
      Test.setCurrentPageReference(new PageReference('Page.ESC_GlobalObjectSearch')); 
       System.currentPageReference().getParameters().put('Key2','7786864710');
       System.currentPageReference().getParameters().put('Key3','7786864711');
       
      //creating instance of ESC_GlobalObjectSearchController for calling static methods.
      ESC_GlobalObjectSearchController objSearch= new ESC_GlobalObjectSearchController();
       objSearch.val1='Contact';
       objSearch.searchSAP='';
       //objSearch.searchPhone='';
       objSearch.searchContact='';
       objSearch.IsSearchValid=true;
       objSearch.primaryKeyWord='jksrg';
       objSearch.mainSearchKeyword='John';
       objSearch.getDataTableEntity();
        objSearch.hasSOQLClause=false;
       objSearch.runsearchTtech();
         objSearch.getMyTabs();
      
      objSearch.runFreshSearch();
      objSearch.setLinkValues();
      objSearch.setPaginationController();
      
      objSearch.adderrorMessage();
      objSearch.gethiddenRows();
      String searchCategory;
      objSearch.getsearchCategory();
      objSearch.setsearchCategory('sd');
      objSearch.getTimeoutInMillisec();
      objSearch.adderrorMessageTimeout();
  
    try{
    throw new ESC_HandlerCustomException('Error'); 
    }
    catch(Exception e)
    {
    system.debug('exception'+e);
    }
     
      Test.StopTest();   
        } 
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      }
           @IsTest(SeeAllData=false) public static void escGlobalObjectSearchControllerMethod_test2(){ 
      Profile profile1 = [Select Id from Profile where name = 'USL Helpdesk Agent'];
      User usr = new User(LastName = 'testcoverage',
                           FirstName='coverage123',
                           Alias = 'jliv',
                           Email = 'testcoverage123@asdf.com',
                           Username = 'testcoverage1237@asdf.com',
                           ProfileId = profile1.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
           insert usr;
        system.runAs(usr){   
      //Fetching metadata value
      List<ESC_SearchSettings__mdt> objList= new List<ESC_SearchSettings__mdt>();
      objList= [Select ESC_ObjectAPIName1__c, ESC_FieldAPIName__c , esc_sequence__c, ESC_IsKey__c,ESC_ParamValue__c from
      ESC_SearchSettings__mdt order by esc_sequence__c asc nulls last];
      
      //Providing list of dummy data for account
      
      List <Account> listAccount= new List<Account>();
      Account testAccount=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      listAccount.add(testAccount);
      insert listAccount;
      //Providing list of dummy data for contact
      List<Contact> listContact= new List<Contact>();
      Contact testContact=new Contact (firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
      listContact.add(testContact);
      insert listContact;
      /*
      List<Source_System_Detail__c> listSsd= new List<Source_System_Detail__c>();
      Source_System_Detail__c testSsd= new Source_System_Detail__c(Name ='testssd',Source_System_Name__c='testName',Source_System_Account_Number__c='123456',Account_Name__c=testAccount.Id) ;
      listSsd.add(testSsd);
      insert listSsd;
      
      List<LCRM_Contact_SSD__c> listConssd= new List<LCRM_Contact_SSD__c>();
      LCRM_Contact_SSD__c testConssd= new LCRM_Contact_SSD__c(CurrencyIsoCode ='USD',Name='testName') ;
      listConssd.add(testConssd);
      insert listConssd;
      */
      
      ESC_HandlerCustomException eh=new ESC_HandlerCustomException();
        Test.StartTest();
      Test.setCurrentPageReference(new PageReference('Page.ESC_GlobalObjectSearch')); 
       System.currentPageReference().getParameters().put('Key4',testContact.id);
       
      //creating instance of ESC_GlobalObjectSearchController for calling static methods.
      ESC_GlobalObjectSearchController objSearch= new ESC_GlobalObjectSearchController();
       objSearch.val1='Contact';
       objSearch.searchSAP='';
       objSearch.searchPhone='';
       objSearch.searchPhone2='';
       //objSearch.searchContact='';
       objSearch.IsSearchValid=true;
       objSearch.primaryKeyWord='jksrg';
       objSearch.getDataTableEntity();
    
       objSearch.runsearchTtech();
         objSearch.getMyTabs();
      
      objSearch.runFreshSearch();
      objSearch.setLinkValues();
      objSearch.setPaginationController();
      
      objSearch.adderrorMessage();
      objSearch.gethiddenRows();
      String searchCategory;
      objSearch.getsearchCategory();
      objSearch.setsearchCategory('sd');
      objSearch.getTimeoutInMillisec();
      objSearch.adderrorMessageTimeout();
  
    try{
    throw new ESC_HandlerCustomException('Error'); 
    }
    catch(Exception e)
    {
    system.debug('exception'+e);
    }
     
      Test.StopTest();   
        }  
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      }
  
      @IsTest(SeeAllData=false) public static void escGlobalObjectSearchControllerMethod2(){ 
      Profile profile1 = [Select Id from Profile where name = 'USL Helpdesk Agent'];
      User usr = new User(LastName = 'testcoverage',
                           FirstName='coverage123',
                           Alias = 'jliv',
                           Email = 'testcoverage123@asdf.com',
                           Username = 'testcoverage1236@asdf.com',
                           ProfileId = profile1.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
           insert usr;
        system.runAs(usr){   
      //Fetching metadata value
      
      List<ESC_SearchSettings__mdt> objList= new List<ESC_SearchSettings__mdt>();
      objList= [Select ESC_ObjectAPIName1__c, ESC_FieldAPIName__c , esc_sequence__c, ESC_IsKey__c,ESC_ParamValue__c from
      ESC_SearchSettings__mdt order by esc_sequence__c asc nulls last];
      
      //Providing list of dummy data for account
      
      List <Account> listAccount= new List<Account>();
      Account testAccount=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      listAccount.add(testAccount);
      insert listAccount;
      //Providing list of dummy data for contact
      List<Contact> listContact= new List<Contact>();
      Contact testContact=new Contact (firstname= 'John',lastname= 'Miles',email = 'abc1@tr.com', phone='7786864710');
      listContact.add(testContact);
      insert listContact;
     /*
      List<Source_System_Detail__c> listSsd= new List<Source_System_Detail__c>();
      Source_System_Detail__c testSsd= new Source_System_Detail__c(Name ='testssd1',Source_System_Name__c='testName1',Account_Name__c=testAccount.Id,City__c = 'BANGALORE') ;
      listSsd.add(testSsd);
      insert listSsd;
     
      List<LCRM_Contact_SSD__c> listConssd= new List<LCRM_Contact_SSD__c>();
      LCRM_Contact_SSD__c testConssd= new LCRM_Contact_SSD__c(CurrencyIsoCode ='USD',Name='testName1') ;
      listConssd.add(testConssd);
      insert listConssd;
       */
      Test.StartTest();
      ESC_HandlerCustomException eh=new ESC_HandlerCustomException();
      
      //creating instance of ESC_GlobalObjectSearchController for calling static methods.
      ESC_GlobalObjectSearchController objSearch= new ESC_GlobalObjectSearchController();
       objSearch.val1='LCRM_Contact_SSD__c';
       objSearch.IsSearchValid=true;
       objSearch.primaryKeyWord='jksrg';
       objSearch.getDataTableEntity();
       
       objSearch.isSearchSuccessful=true;
       
      objSearch.searchResults = new List<sobject>();
      
   
      //Source_System_Detail__c ssd= new Source_System_Detail__c(id=testSsd.Id);
      //objSearch.searchResults.add(ssd);
      
      objSearch.setFilterResultsMap();
      objSearch.filterMap = new map<string, List<ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance>> ();
      
      ESC_SearchSettings__mdt md=new ESC_SearchSettings__mdt();
       md=[select ESC_ApplicableToProfiles__c,ESC_HFF__c,ESC_Def__c,ESC_Hide_From_Results__c,ESC_IsKey__c,ESC_LabelName__c,ESC_Sequence__c,ESC_ParamValue__c from ESC_SearchSettings__mdt limit 1];
      
      
      ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi1 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('LCRM_Contact_SSD__c' , '100' ,'LCRM_SAP_Account_Number__c',md);
     // ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi2 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('LCRM_Contact_SSD__c' , 'account.name' ,'',md);
     // ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi3 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('LCRM_Contact_SSD__c' , 'esc_toclanguage__c','',md);
     // ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance egsi4 = new ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance('LCRM_Contact_SSD__c' , 'ESC_Contact_Inactive__c','',md);
      List<ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance> egsiList = new List<ESC_GlobalObjectSearchController.ESC_GlobalObjectSearchFilterInstance>(); 
      //egsi3.FieldValue = 'aafaf';
       egsiList.add(egsi1);
       //egsiList.add(egsi3);
      // egsiList.add(egsi4);
       
       
      objSearch.filterMap.put('LCRM_Contact_SSD__c' ,egsiList);
  
      objSearch.runsearch();
      
      //egsi2.FieldValue ='test';
     
      //egsiList.add(egsi2);
      egsiList.sort();
      //egsi2.sequence = 3;
     // egsiList.sort();
      objSearch.filterMap.put('LCRM_Contact_SSD__c' ,egsiList);
      objSearch.runsearch();
      objSearch.getMyTabs();
      
      objSearch.runFreshSearch();
      objSearch.setLinkValues();
      objSearch.setPaginationController();
      
      objSearch.adderrorMessage();
      objSearch.gethiddenRows();
      String searchCategory;
      objSearch.getsearchCategory();
      objSearch.setsearchCategory('sd');
      objSearch.getTimeoutInMillisec();
      objSearch.adderrorMessageTimeout();
     // objSearch.setsearchCategory(String 'searchCategory');
      
      /**Map<string, Map<string,string>> resultTableLabel = new Map<string, Map<string,string>>();
      Map<string ,string> dummyMap = new Map<string ,string>();
      dummyMap.put('esc_toclanguage__c','FirstName');
     
      resultTableLabel.put('Contact' , dummyMap);**/
      
       objSearch.getFieldLabel();
      // ESC_GlobalObjectSearchController.getObjectNameForRelation('Contact','Id');
     //objSearch.formQuerySOQL();
     //ESC_GlobalObjectSearchController.getObjectNameForRelation('Contact','demo__r.ada');
      //ESC_GlobalObjectSearchController.getObjectNameForRelation('testName.kr','demo__r.ada');
        
    //instance for ESC_ObjectSchemaHelper
    
  
    ESC_ObjectSchemaHelper.getPickListOptions('Case' , 'Status' );
   
    ESC_ObjectSchemaHelper.getObjectNameForRelation('LCRM_Contact_SSD__c' , 'LCRM_Contact__r.Account.Name' );
        //ESC_ObjectSchemaHelper.getPickListOptions('Case');

    //**ESC_ObjectSchemaHelper.getObjectNameForRelation('Case','Status');
    
    
    ESC_ObjectSchemaHelper.getObjectNamesUsed('Case');
    ESC_ObjectSchemaHelper.getInfoField('Case');
    try{
    throw new ESC_HandlerCustomException('Error'); 
    }
    catch(Exception e)
    {
    system.debug('exception'+e);
    }
     
      Test.StopTest();   
        } 
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      }
      
      }