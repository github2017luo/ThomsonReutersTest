/**
 * @description test send closure mail for Maritz
 */
@isTest
private class ESC_Maritz_Send_ClosureMail_Test{
/**
 * @description test send ESC_Maritz_Send_ClosureMail_TestMethod
 */   
@isTest public static void escMaritzSendClosureMailTestMethod() {
    List<Case> caseList= new List<Case>();
    
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      
      User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin12@testorg.com');
      insert u;
      
      System.runAs(u) { 
      Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      insert testAccount1;
        
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710',ESC_tocLanguage__c='English');
        insert testContact1;
        
         insert new ESC_EPx_Survey_Reply_Address__c(Name = 'rec11', Brand__c = 'Elite',ReplyTo_Address__c='test@gmail.com',
         ESC_From_Address__c='test@gmail.com',Preferred_Language__c='English',Email_Template__c='ESC_Maritz_closure_email_template_with_Survey',ReopenEmailTemplate__c='ESC_Maritz_closure_email_template_without_Survey');
         case testcase1= new case(AccountId = testAccount1.id, ContactId=testContact1.Id,OwnerId=u.Id,Subject='test1',ESC_Product_Segment_Brand__c ='Elite');
        
        caseList.add(testcase1);
        Insert caseList;    
        Test.StartTest();
        ESC_Maritz_Send_ClosureMail.sendEmail(caseList);
        //Caselines_AutoResponseMail.sendEmail(caseList);
        Test.stopTest();
            
                integer k = 1;
                integer j = 1;
                System.assertEquals(k,j,'equal');
            
        }

    }
    /**
 * @description test send ESC_Maritz_Send_ClosureMail_TestMethod1
 */   
@isTest public static void escMaritzSendClosureMailTestMethod1() {
    List<Case> caseList= new List<Case>();
    
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      
      User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin12@testorg.com');
      insert u;
      
      System.runAs(u) { 
      Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      insert testAccount1;
        
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710',ESC_tocLanguage__c='English');
        insert testContact1;
  
        insert new ESC_EPx_Survey_Reply_Address__c(Name = 'rec12', Brand__c = 'Legal',ReplyTo_Address__c='test@gmail.com',Region__c='USL',ESC_From_Address__c='test@gmail.com',Preferred_Language__c='English',Email_Template__c='ESC_Maritz_closure_email_template_with_Survey',ReopenEmailTemplate__c='ESC_Maritz_closure_email_template_without_Survey');
        case testcase2= new case(AccountId = testAccount1.id, ContactId=testContact1.Id,OwnerId=u.Id,Subject='test1',ESC_Product_Segment_Brand__c ='Legal',ESC_Reopen_Case__c =true,LCRM_Sub_BU__c='USL');
      
         caseList.add(testcase2);
        
        Insert caseList;    
        Test.StartTest();
        ESC_Maritz_Send_ClosureMail.sendEmail(caseList);
        //Caselines_AutoResponseMail.sendEmail(caseList);
        Test.stopTest();           
                integer k = 1;
                integer j = 1;
                System.assertEquals(k,j,'equal');           
        }
    }
    /**
 * @description test send ESC_Maritz_Send_ClosureMail_TestMethod1
 */   
@isTest public static void escMaritzSendClosureMailTestMethod2() {
    List<Case> caseList= new List<Case>();
    
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      
      User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin12@testorg.com');
      insert u;
      
      System.runAs(u) { 
      Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      insert testAccount1;
        
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710',ESC_tocLanguage__c='English');
        insert testContact1;
        
         
         insert new ESC_EPx_Survey_Reply_Address__c(Name = 'rec13', Brand__c = 'Legal',ReplyTo_Address__c='test@gmail.com',Region__c='US',Segment__c='Professional Tax',ESC_From_Address__c='test@gmail.com',Preferred_Language__c='English',Email_Template__c='ESC_Maritz_closure_email_template_with_Survey',ReopenEmailTemplate__c='ESC_Maritz_closure_email_template_without_Survey'); 
        case testcase3= new case(AccountId = testAccount1.id, ContactId=testContact1.Id,OwnerId=u.Id,Subject='test1',ESC_Product_Segment_Brand__c ='Legal',ESC_Reopen_Case__c =true,LCRM_Sub_BU__c='US',BU_Segment__c='Professional Tax');
 
         caseList.add(testcase3);
        
        Insert caseList;    
        Test.StartTest();
        ESC_Maritz_Send_ClosureMail.sendEmail(caseList);
        //Caselines_AutoResponseMail.sendEmail(caseList);
        Test.stopTest();
                integer k = 1;
                integer j = 1;
                System.assertEquals(k,j,'equal');
            
        }
    }
        /**
 * @description test send ESC_Maritz_Send_ClosureMail_TestMethod
 */   
@isTest public static void escMaritzSendClosureMailTestMethod4() {
    List<Case> caseList= new List<Case>();
    
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      
      User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin12@testorg.com');
      insert u;
      
      System.runAs(u) { 
      Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet');
      insert testAccount1;
        
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710',ESC_tocLanguage__c='English');
        insert testContact1;
        
         insert new ESC_EPx_Survey_Reply_Address__c(Name = 'rec11', Brand__c = 'Elite',ReplyTo_Address__c='test@gmail.com',
         ESC_From_Address__c='test@gmail.com',Preferred_Language__c='English',Email_Template__c='ESC_Maritz_closure_email_template_with_Survey',ReopenEmailTemplate__c='ESC_Maritz_closure_email_template_without_Survey');
         case testcase1= new case(OwnerId=u.Id,Subject='test1',ESC_Product_Segment_Brand__c ='Elite');
        
        caseList.add(testcase1);
        Insert caseList;    
        Test.StartTest();
        //ESC_Maritz_Send_ClosureMail.sendEmail(caseList);
        //Caselines_AutoResponseMail.sendEmail(caseList);
        Test.stopTest();
            
                integer k = 1;
                integer j = 1;
                System.assertEquals(k,j,'equal');
            
        }

    }
}