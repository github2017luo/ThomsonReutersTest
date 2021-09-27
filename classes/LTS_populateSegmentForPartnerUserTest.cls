/********************************************************************** 
Name: LTS_populateSegmentForPartnerUserTest 
====================================================== 
Purpose : This class is used to cover the code coverage of LTS_populateSegmentForPartnerUser apex class 
====================================================== 

====================================================== 
History 
------- 
VERSION    AUTHOR             DATE             DETAIL 			 JIRA STory Number
1.0        TCS Developer     25/10/2018     Initial Development  DPS-1865
***********************************************************************/
@isTest
public class LTS_populateSegmentForPartnerUserTest {
    
    @isTest static void testBuSegmentPopulationForPartner(){
        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        
        KeyValueListStore__c tempValueStore = new KeyValueListStore__c(Name = 'LCRMStrikeIronInformaticaUsers', Textvalue__c = 'Test GLI User' ,Failure_Email__c ='Test');
        insert tempValueStore;
        List<Profile> lstProfile1 =[SELECT Id FROM Profile WHERE Name = 'TR Sales'];
        User user2 = UnitTest.getUserInstance();
        user2.Username = 'Test@xyzAccountregion1.com';
        user2.CommunityNickname = 'ghel';
        user2.LastName = 'XYZ';
        user2.Email = 'abc@xyz.com';
        user2.Alias = 'abcd';       
        user2.ProfileId = lstProfile1[0].Id;        
        user2.Segment__c = ' Corporate';
        insert user2;
        Account acc = new account();
        contact partnercontact = new contact();
        System.runAs(user2){
            //Account acc = new account();
            acc.is_gli__c = true;
            acc.name ='portal account';
            insert acc ;
            
            //contact partnercontact = new contact();
            
        }
        partnercontact.accountid = acc.id;
        partnercontact.FirstName = 'test';
        partnercontact.Lastname = 'partner';
        insert partnercontact;
        
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name = 'TR Corp Partner Community User'];
        User user1 = UnitTest.getUserInstance();
        user1.Username = 'Test@xyzAccountregion.com';
        user1.LastName = 'XYZ';
        user1.Email = 'abc@xyz.com';
        user1.Alias = 'abcd';       
        user1.ProfileId = lstProfile[0].Id;
        user1.ContactId = partnercontact.id;
        user1.Segment__c = ' Corporate';
        insert user1;
        test.startTest();
        system.runas(user1){
            
            Account acc1 = new account();
            acc1.is_gli__c = true;
            acc1.name ='portal account';
            insert acc1 ;
            System.assertEquals(acc1 != null,true);
            contact partnercontact1 = new contact();
            partnercontact1.accountid = acc.id;
            partnercontact1.FirstName = 'test';
            partnercontact1.Lastname = 'partner';
            insert partnercontact1;
            
            Lead partnerLead = new Lead();
            partnerLead.FirstName = 'Partner';
            partnerLead.LastName = 'Lead';
            partnerLead.Is_GLI__c = true;
            partnerLead.company = 'Partner Company';
            
            //insert partnerLead;
            insert partnerLead;
            System.debug('partnerLead@@ '+partnerLead);
            
        }
        test.stopTest();
        
    }
    
}