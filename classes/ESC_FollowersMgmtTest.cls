/**********************************
Class Name: ESC_FollowersMgmtTest
Purpose:
Author:Rupesh Sharma
Date Created:06/08/2017
Date Updated:V1:
**********************************/
@isTest(SeeAllData=false)
public class ESC_FollowersMgmtTest{


        testMethod static void test_ESC_FollowersMgmt(){
        /*Profile Prof = [SELECT Id FROM profile WHERE name='Sample Helpdesk Agent']; 
        User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        //insert Us;
        ESC_Static_Values__c es= new ESC_Static_Values__c();
        es.Name='CaseIdFromReferral';
        es.ESC_Value__c='CF0000000';
        insert es;*/
       
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'United States';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Product2 prod = new Product2(name='Teest Prod');
         
        insert prod;

        Case cs3 = new Case();
        cs3.Type='Data';
        cs3.Status='Work In Progress';
        cs3.Subject='Test Subject';
        cs3.Description = 'Test Description111';
        cs3.contactid=con.id;
        cs3.accountid=acct.id;
        cs3.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs3.productId = prod.id;
        insert cs3;
        
        /*cs3 = [Select OwnerID, Owner.ID From Case where ID = :cs3.id];
        system.debug('ownerid after select'+cs3);
        cs3.OwnerID=cs3.OwnerID;
        update cs3;*/
       
        
        map<id,case> oldmap=new map<id,case>();
         oldmap.put(cs3.id,cs3);
         
         system.debug('value of record type in oldmap in test class'+oldmap.get(cs3.id).RecordTypeId);
         
        cs3.Status='Work In Progress';
        cs3.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action (Read Only)').getRecordTypeId();
       // cs3.Is_ESC_Case__c='True';
        update cs3;
        
          list<case> cslist=new List<case>();
         cslist.add(cs3);
         System.debug('Value in List(newMap) in test class'+cslist);
          
        ESC_FollowersMgmt.manageCaseFollowers(cslist,oldmap);
        ESC_FollowersMgmt.removeCasefollowers(cslist,true);
        
        ESC_Case_Collaborator__c cc1 = new ESC_Case_Collaborator__c();
        cc1.ESC_Case__c = cs3.id;
        cc1.ESC_Role__c = 'Collaborator';
        cc1.ESC_referral_status__c = 'New';
        //cc1.OwnerId = null ;
        insert  cc1;
        
        cc1.ESC_referral_status__c = 'Completed';
        update cc1;
        
       //insert listc;
            
}
        
}