@isTest
public class QuickQuoteFromContactSSDControllerTest {
      
      static testMethod void testQuickQuotePage() {  
            
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
            Account testAccount = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
            insert testAccount;
            
              KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
              keyvaluestore.Name='ANZUsersProfileId';
              keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
              insert keyvaluestore;
              
              
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype); 
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        /*Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'dpate', Sub_Bu__c = 'USL', Email='dpatel48@gmail.comcom',FirstName = 'Dipti',EmailEncodingKey='UTF-8', LastName='Singh', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='Subhadeep.t@tr.com');
        insert u;*/

       
            Source_system_detail__c testSource = new Source_system_detail__c (Account_Name__c = testAccount.id,Name=testAccount.name,Source_System_Name__c=testAccount.name,LCRM_Sales_Org__c='TA78');
            insert testSource;    
      
      System.assertequals('TA78',testSource.LCRM_Sales_Org__c,'Success');
             
            Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
            Contact testContact = new Contact(lastName='Test',accountId=testAccount.id,RecordTypeId=conRecordTypeId,firstName='Contact');
            insert testContact;
            
            LCRM_Contact_SSD__c testContactSSD=new LCRM_Contact_SSD__c(LCRM_Contact__c=testContact.id,LCRM_Account_SSD__c=testSource.id,LCRM_SAP_Account_Number__c='TS12345');
            insert testContactSSD;
            
            Apttus_Config2__PriceList__c testPriceList=new Apttus_Config2__PriceList__c(name='Thomson Reuters Master - US Legal');
            insert testPriceList;
            
             Pricebook2 gliPriceBook = new Pricebook2(Name='Standard Price Book', isActive=true);
             insert gliPriceBook;
             Pricebook2 gliPriceBook1 = new Pricebook2(Name='TR PriceBook', isActive=true);
            insert gliPriceBook1;
            //Pricebook2 gliPriceBookCars = new Pricebook2(Name='LOTUS Price Book - Canada', isActive=true);
            //insert gliPriceBookCars;
          
            Business_Partner_Function__c BPF = new Business_Partner_Function__c(Related_Account__c = testAccount.id, Relationship_Type__c = 'Sold To',Sold_To_Account_GLI__c=testSource.id,Sold_To_Account__c=testAccount.id);
            insert BPF;
                        
            PageReference pageRef = Page.APTS_QuickQuoteFromContactSSD;
            pageRef.getParameters().put('contactId',testContact.Id);
            pageRef.getParameters().put('accountId',testAccount.Id);
            pageRef.getParameters().put('accountName',testAccount.Name);
            pageRef.getParameters().put('ssdId',testSource.Id);
            Test.setCurrentPage(pageRef);
            APTS_QuickQuoteFromContactSSDController qc = new APTS_QuickQuoteFromContactSSDController();
            test.startTest();                    
               qc.doCreateQuote();
            test.stopTest();
    }
    
    static testMethod void testQuickQuotePageWithoutSSD() {  
            
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
            Account testAccount = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
            insert testAccount;
            
              KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
              keyvaluestore.Name='ANZUsersProfileId';
              keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
              insert keyvaluestore;
              
              
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype); 
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
       
            Source_system_detail__c testSource = new Source_system_detail__c (Account_Name__c = testAccount.id,Name=testAccount.name,Source_System_Name__c=testAccount.name,LCRM_Sales_Org__c='West');
            insert testSource;   
      System.assertequals('West',testSource.LCRM_Sales_Org__c,'Success');
             
            Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
            Contact testContact = new Contact(lastName='Test',accountId=testAccount.id,RecordTypeId=conRecordTypeId,firstName='Contact');
            insert testContact;
            
            LCRM_Contact_SSD__c testContactSSD=new LCRM_Contact_SSD__c(LCRM_Contact__c=testContact.id,LCRM_Account_SSD__c=testSource.id,LCRM_SAP_Account_Number__c='TS12345');
            insert testContactSSD;
            
            Apttus_Config2__PriceList__c testPriceList=new Apttus_Config2__PriceList__c(name='Thomson Reuters Master - US Legal');
            insert testPriceList;
            
             Pricebook2 gliPriceBook = new Pricebook2(Name='Standard Price Book', isActive=true);
            insert gliPriceBook;
            Pricebook2 gliPriceBook1 = new Pricebook2(Name='TR PriceBook', isActive=true);
            insert gliPriceBook1;
            Pricebook2 gliPriceBookCars = new Pricebook2(Name='LOTUS Price Book - Canada', isActive=true);
            insert gliPriceBookCars;
                        
            PageReference pageRef = Page.APTS_QuickQuoteFromContactSSD;
            pageRef.getParameters().put('contactId',testContact.Id);
            pageRef.getParameters().put('accountId',testAccount.Id);
            pageRef.getParameters().put('accountName',testAccount.Name);
            pageRef.getParameters().put('ssdId',null);
            Test.setCurrentPage(pageRef);
            APTS_QuickQuoteFromContactSSDController qc = new APTS_QuickQuoteFromContactSSDController();
            test.startTest();                    
             qc.doCreateQuote();
            test.stopTest();
    }
    static testMethod void testQuickQuotePage1() {  
            
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
            Account testAccount = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
            insert testAccount;
            
              KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
              keyvaluestore.Name='ANZUsersProfileId';
              keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
              insert keyvaluestore;
              
              
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype); 
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        
        /*Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'dpate', Sub_Bu__c = 'USL', Email='dpatel48@gmail.comcom',FirstName = 'Dipti',EmailEncodingKey='UTF-8', LastName='Singh', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='Subhadeep.t@tr.com');
        insert u;*/

       
            Source_system_detail__c testSource = new Source_system_detail__c (Account_Name__c = testAccount.id,Name=testAccount.name,Source_System_Name__c=testAccount.name,LCRM_Sales_Org__c='CARS');
            insert testSource;  
      System.assertequals('CARS',testSource.LCRM_Sales_Org__c,'Success');
             
            Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
            Contact testContact = new Contact(lastName='Test',accountId=testAccount.id,RecordTypeId=conRecordTypeId,firstName='Contact');
            insert testContact;
            
            LCRM_Contact_SSD__c testContactSSD=new LCRM_Contact_SSD__c(LCRM_Contact__c=testContact.id,LCRM_Account_SSD__c=testSource.id,LCRM_SAP_Account_Number__c='TS12345');
            insert testContactSSD;
            
            Apttus_Config2__PriceList__c testPriceList=new Apttus_Config2__PriceList__c(name='Thomson Reuters Master - US Legal');
            insert testPriceList;
            
             Pricebook2 gliPriceBook = new Pricebook2(Name='Standard Price Book', isActive=true);
             insert gliPriceBook;
             Pricebook2 gliPriceBook1 = new Pricebook2(Name='TR PriceBook', isActive=true);
            insert gliPriceBook1;
            Pricebook2 gliPriceBookCars = new Pricebook2(Name='LOTUS Price Book - Canada', isActive=true);
            insert gliPriceBookCars;
            
            Business_Partner_Function__c BPF = new Business_Partner_Function__c(Related_Account__c = testAccount.id, Relationship_Type__c = 'Sold To',Sold_To_Account_GLI__c=testSource.id,Sold_To_Account__c=testAccount.id);
            insert BPF;
                        
            PageReference pageRef = Page.APTS_QuickQuoteFromContactSSD;
            pageRef.getParameters().put('contactId',testContact.Id);
            pageRef.getParameters().put('accountId',testAccount.Id);
            pageRef.getParameters().put('accountName',testAccount.Name);
            pageRef.getParameters().put('ssdId',testSource.Id);
            Test.setCurrentPage(pageRef);
            APTS_QuickQuoteFromContactSSDController qc = new APTS_QuickQuoteFromContactSSDController();
            test.startTest();                    
               qc.doCreateQuote();
            test.stopTest();
    }
}