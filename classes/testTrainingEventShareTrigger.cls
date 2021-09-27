/*
 * CHANGE HISTORY
 * ===============================================================================
 * Date                Name                         Description
 * 2017-10-13     Harika Devi Kalidindi       Added testTaskTriggerandEventTrigger method as a part of CRM-6180 
 * ===============================================================================
 */
@isTest (seealldata = true)
public class testTrainingEventShareTrigger
{
    public static testmethod void testTaskTriggerandEventTrigger()
    {
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        System.assertNotEquals(null, testTrainingEvent.Id);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='GLI Sales User'];

        User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com');
        insert u;
        User u1 = new User(Alias = 'test1', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing1', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser1@trpcorelegal.com');
        insert u1;
        User u2 = new User(Alias = 'test2', Email='testuser@thomsonreuters.com',EmailEncodingKey='UTF-8', LastName ='Testing2', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser2@trpcorelegal.com');
        insert u2;
        
        Training_Event_Team__c testTrainingEventTeam = new Training_Event_Team__c();
        testTrainingEventTeam .Training_Event_Team__c= testTrainingEvent.Id;
        testTrainingEventTeam .Training_Team_Member__c = u.Id;
        testTrainingEventTeam.Send_Notification__c = true;
        insert testTrainingEventTeam ;
        System.assertEquals(testTrainingEventTeam.Training_Event_Team__c,testTrainingEvent.Id);
        System.assertNotEquals(null, testTrainingEventTeam.Id);
        Training_Event__Share teShareinsert = [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id and AccessLevel='Edit'];
        System.assertEquals(teShareinsert.UserOrGroupId,u.Id);
        
        Training_Event_Team__c testTrainingEventTeam1 = new Training_Event_Team__c();
        testTrainingEventTeam1.Training_Event_Team__c= testTrainingEvent.Id;
        testTrainingEventTeam1.Training_Team_Member__c = u1.Id;
        insert testTrainingEventTeam1 ;
        System.assertNotEquals(null ,testTrainingEventTeam1.Training_Team_Member__c);
        Training_Event__Share teShareinsert1 = [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id  and UserOrGroupId=:u1.id];
        System.assertEquals(teShareinsert1.AccessLevel,'Edit');
        
        Training_Event_Team__c testTrainingeventedit = [select Id,Training_Team_Member__c,Training_Event_Team__c from Training_Event_Team__c where Training_Team_Member__c =:u1.Id];
        testTrainingeventedit.Training_Team_Member__c = u2.Id;
        testTrainingeventedit .Send_Notification__c = true;
        update testTrainingeventedit;
        Training_Event__Share teShareinsert2 = [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id  and UserOrGroupId=:u2.id];
        System.assertEquals(teShareinsert2.AccessLevel,'Edit');
        
        List<Training_Event__Share> lstteShareupdate= [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id  and UserOrGroupId=:u1.id and AccessLevel ='Edit'];
        System.assertEquals(lstteShareupdate.isEmpty(),true);
        
        Training_Event_Team__c testTrainingeventdelete = [select Id,Training_Team_Member__c,Training_Event_Team__c from Training_Event_Team__c where Training_Team_Member__c =: u.Id];
        
        delete testTrainingeventdelete ;
        
        List<Training_Event__Share> lstteSharedelete = [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id  and UserOrGroupId=: u.id and AccessLevel ='Edit'];
        System.assertEquals(lstteSharedelete.isEmpty(),true);
        
               
    }
    
    public static testmethod void testcompletedte()
    {
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        System.assertNotEquals(null, testTrainingEvent.Id);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='GLI Sales User'];

        User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com');
        insert u;
        User u1 = new User(Alias = 'test1', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing1', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser1@trpcorelegal.com');
        insert u1;
        User u2 = new User(Alias = 'test2', Email='testuser@thomsonreuters.com',EmailEncodingKey='UTF-8', LastName ='Testing2', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser2@trpcorelegal.com');
        insert u2;
        
        Training_Event_Team__c testTrainingEventTeam = new Training_Event_Team__c();
        testTrainingEventTeam .Training_Event_Team__c= testTrainingEvent.Id;
        testTrainingEventTeam .Training_Team_Member__c = u.Id;
        testTrainingEventTeam.Send_Notification__c = true;
        insert testTrainingEventTeam ;
        System.assertEquals(testTrainingEventTeam.Training_Event_Team__c,testTrainingEvent.Id);
        System.assertNotEquals(null, testTrainingEventTeam.Id);
        Training_Event__Share teShareinsert = [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id and AccessLevel='Edit'];
        System.assertEquals(teShareinsert.UserOrGroupId,u.Id);
        
        Training_Event_Team__c testTrainingEventTeam1 = new Training_Event_Team__c();
        testTrainingEventTeam1.Training_Event_Team__c= testTrainingEvent.Id;
        testTrainingEventTeam1.Training_Team_Member__c = u1.Id;
        insert testTrainingEventTeam1 ;
        System.assertNotEquals(null ,testTrainingEventTeam1.Training_Team_Member__c);
        Training_Event__Share teShareinsert1 = [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id  and UserOrGroupId=:u1.id];
        System.assertEquals(teShareinsert1.AccessLevel,'Edit');
        
        Training_Event_Team__c testTrainingeventedit = [select Id,Training_Team_Member__c,Training_Event_Team__c from Training_Event_Team__c where Training_Team_Member__c =:u1.Id];
        testTrainingeventedit.Training_Team_Member__c = u2.Id;
        testTrainingeventedit .Send_Notification__c = true;
        update testTrainingeventedit;
        Training_Event__Share teShareinsert2 = [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id  and UserOrGroupId=:u2.id];
        System.assertEquals(teShareinsert2.AccessLevel,'Edit');
        
        List<Training_Event__Share> lstteShareupdate= [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id  and UserOrGroupId=:u1.id and AccessLevel ='Edit'];
        System.assertEquals(lstteShareupdate.isEmpty(),true);
        
        Training_Event_Team__c testTrainingeventdelete = [select Id,Training_Team_Member__c,Training_Event_Team__c from Training_Event_Team__c where Training_Team_Member__c =: u.Id];
        
        delete testTrainingeventdelete ;
        
        List<Training_Event__Share> lstteSharedelete = [Select Id,AccessLevel,UserOrGroupId  from Training_Event__Share where   ParentId = :testTrainingEvent.Id  and UserOrGroupId=: u.id and AccessLevel ='Edit'];
        System.assertEquals(lstteSharedelete.isEmpty(),true);
        
        testTrainingEvent.Status__c = 'Completed';
        update testTrainingEvent;
        
               
    }
}