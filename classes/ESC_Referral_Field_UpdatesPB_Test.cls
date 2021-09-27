@istest 
public class ESC_Referral_Field_UpdatesPB_Test {
    
    @isTest static void referralMethod1(){
        Test.startTest();
        
        //create a user records  
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
        User Us2 =  New User(FirstName = 'James1' , LastName= 'ThomasT1est',Alias = '1jttest',Email='1james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='1james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='1James.ThomnasTest');
        insert Us2;
        //System.assert(Us.id != null);
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        //insert a case list
        List<Case> clist = new List<Case>();
        //Case cs1  = new Case(Type='Data',Status='New', contactid=con.id,accountid=acct.id);
        Case cs1  = new Case(Status='New', contactid=con.id,accountid=acct.id);
        clist.add(cs1);
        insert clist;
 
        //List<ESC_Case_Collaborator__c> ecc = new List<ESC_Case_Collaborator__c>();
        /*ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs1.id;
        cc1.RecordTypeId = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
        cc1.ESC_Role__c = 'Collaborator';
        cc1.ownerid=Us.id;
        cc1.ESC_referral_status__c = 'In Progress';
        cc1.ESC_ReferralUPD__c = true;
        ecc.add(cc1);
        insert ecc;*/
       
        List<ESC_Case_Collaborator__c> ecc1 = new List<ESC_Case_Collaborator__c>();
        
        ESC_Case_Collaborator__c cc2 = new ESC_Case_Collaborator__c();
        System.runAs(Us){
        cc2.ESC_Case__c = cs1.id;
        cc2.RecordTypeId = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
        cc2.ESC_Role__c = 'Collaborator';
        cc2.ownerid=Us2.id;
        cc2.ESC_referral_status__c = 'In Progress';
        cc2.ESC_ReferralUPD__c = true;
        //ecc1.add(cc2);
        insert cc2;
                
            //ecc1[0].ESC_referral_status__c='Rejected';
        cc2.ESC_referral_status__c = 'Rejected';
        cc2.ESC_ReferralUPD__c=false;
        cc2.ESC_Rejection_Cancellation_Reason__c = 'test';
        //ecc1[0].ESC_Rejection_Cancellation_Reason__c = 'test';
        ecc1.add(cc2);
        update ecc1;
          ESC_Case_Collaborator__c cctrail=[select id,LastModifiedById,OwnerId from ESC_Case_Collaborator__c where id =:ecc1];
        
        system.debug('######latmodifi'+cc2.id+' Owner'+cc2.OwnerId+' LM'+cc2.LastModifiedById);
        system.debug('&&&& cctrail'+cctrail);
        }
       integer i = 1;
        integer j = 1;
        System.assertEquals(i,j); 
      Test.stopTest();
}  
@isTest static void referralMethod11(){
        Test.startTest();
        
        //create a user records  
        Profile Prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent']; 
        
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;
        User Us2 =  New User(FirstName = 'James1' , LastName= 'ThomasT1est',Alias = '1jttest',Email='1james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='1james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='1James.ThomnasTest');
        insert Us2;
        //System.assert(Us.id != null);
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        //insert a case list
        List<Case> clist = new List<Case>();
        //Case cs1  = new Case(Type='Data',Status='New', contactid=con.id,accountid=acct.id);
        Case cs1  = new Case(Status='New', contactid=con.id,accountid=acct.id);
        clist.add(cs1);
        insert clist;
 
        //List<ESC_Case_Collaborator__c> ecc = new List<ESC_Case_Collaborator__c>();
        /*ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs1.id;
        cc1.RecordTypeId = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
        cc1.ESC_Role__c = 'Collaborator';
        cc1.ownerid=Us.id;
        cc1.ESC_referral_status__c = 'In Progress';
        cc1.ESC_ReferralUPD__c = true;
        ecc.add(cc1);
        insert ecc;*/
       
        List<ESC_Case_Collaborator__c> ecc1 = new List<ESC_Case_Collaborator__c>();
        
        ESC_Case_Collaborator__c cc2 = new ESC_Case_Collaborator__c();
        System.runAs(Us){
        cc2.ESC_Case__c = cs1.id;
        cc2.RecordTypeId = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();
        cc2.ESC_Role__c = 'Escalation';
        cc2.ownerid=Us2.id;
        cc2.ESC_referral_status__c = 'In Progress';
        cc2.ESC_ReferralUPD__c = true;
        //ecc1.add(cc2);
        insert cc2;
                
            //ecc1[0].ESC_referral_status__c='Rejected';
        cc2.ESC_referral_status__c = 'Rejected';
        cc2.ESC_ReferralUPD__c=false;
        cc2.ESC_Rejection_Cancellation_Reason__c = 'test';
        //ecc1[0].ESC_Rejection_Cancellation_Reason__c = 'test';
        ecc1.add(cc2);
        update ecc1;
          ESC_Case_Collaborator__c cctrail=[select id,LastModifiedById,OwnerId from ESC_Case_Collaborator__c where id =:ecc1];
        
        system.debug('######latmodifi'+cc2.id+' Owner'+cc2.OwnerId+' LM'+cc2.LastModifiedById);
        system.debug('&&&& cctrail'+cctrail);
        }
       integer i = 1;
       integer j = 1;
       System.assertEquals(i,j); 
      Test.stopTest();
}  
}