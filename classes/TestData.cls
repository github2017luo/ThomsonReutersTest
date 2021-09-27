/*
    @Author: Radhika
    @Purpose: This class creates the data for testing purpose
    @Created Date: 18/8/2017
    @Last Modified Date: 
*/
public class TestData {
    //Insert test user
    public static User createTestUser(){
        Profile stdProfile = [SELECT Id,name FROM Profile WHERE Name='System Administrator'];
        User testUser = new User(
          Alias = 'standt', 
          Email='abc1@testorg.com',
          EmailEncodingKey='UTF-8', 
          LastName='Testing', 
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', 
          ProfileId = stdProfile.Id,
          TimeZoneSidKey='America/Los_Angeles',
          Sub_Bu__c ='UKI ',
          UserName='abc1@testorg.com'
        ); 
        return testUser;
    }
    //Insert test account
    public static Account createTestAccount(){
        Account testAccount = new Account(
        Name = 'Test To Check For Abbriviated Name', 
        Phone = '3198374720',
        BillingCountry ='US',
        BillingState='IL',
        BillingPostalCode = '60603-3801',        
        Description='Good'
        );
        insert testAccount;
        return testAccount;
    }
    //Insert test contact
    public static Contact createTestContact(Account testAccount){
        Contact testContact = new Contact(
            FirstName='Test' ,
            LastName = 'TestLastName To Check For Abbriviated Name', 
            Title='senior devloper',
            Phone = '3198374720', 
            AccountId = testAccount.Id, 
            DoNotCall=true,
            Do_not_Mail__c=false,
            Email = 'test@gmail.com'
         
        );
        insert testContact; 
         return testContact;
    }
    
    public static Lead createTestLead(Contact testContact){
        
        Lead testLead = new lead(
        firstName = 'Cole', 
        lastName = 'Swain', 
        company = 'BlueWave',
        status = 'contacted',
        Contact__c= testContact.Id,
        Billing_Country__c ='US'
        
        );
        insert testLead;
        return testLead;
    }
    //Insert test Preference Center
    public static LCRM_Preference_Center__c createTestPreferenceCenter(){
        LCRM_Preference_Center__c PreferenceCenter = new LCRM_Preference_Center__c(
            name='US',
            LCRM_Preference_Center_Link__c='http://ask.legalsolutions.thomsonreuters.info/gli-preference-center'
        );
        insert PreferenceCenter;
        return PreferenceCenter;
    }
   //Get Profile
   public static Profile TestDataProfile(){
    Profile stdProfile = [SELECT Id,name FROM Profile WHERE Name='System Administrator'];
    return stdProfile;
   }
   
  /* public static KeyValueListStore__c getKeyValueListStore(){
   
       KeyValueListStore__c keyList = new KeyValueListStore__c();
       keyList.Name = 'TPS Screening';
       keyList.TextValue__c = 'TPS Screening';
       insert keyList;
       return keyList;
   }
   
   public static ContentDocumentLink getContentDoc(){
   
       
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'TPS Screening';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         

        ContentVersion testContent = [SELECT id,ContentDocument.title,ContentDocumentId FROM ContentVersion where Id = :cv.Id and ContentDocument.title=:cv.title];
        
        system.debug('@@ testContent' + testContent.ContentDocument.title);
        ContentWorkSpace conWork = new ContentWorkSpace();
        conWork.Name = 'TPS Screening';
        insert conWork;
        
        ContentWorkspaceDoc conWorkDoc = new ContentWorkspaceDoc();
        conWorkDoc.contentWorkspaceId= conWork.id;
        conWorkDoc.contentDocumentId= testContent.ContentDocumentId ;
        insert conWorkDoc;
        
        
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = conWork.Id;
        //contentlink.LinkedEntityId = availableRateDeck.Id; 
        contentlink.ContentDocumentId = testcontent.ContentDocumentId;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        
        system.debug('@@ ContentDocumentLink' + contentlink);
        
        return contentlink;
    
   }*/
    
}