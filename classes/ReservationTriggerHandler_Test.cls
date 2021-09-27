@isTest (seeAllData=true)
public class ReservationTriggerHandler_Test{
    static testMethod void myUnitTest(){
    
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'System Administrator'];
        
        User user1 = UnitTest.getUserInstance();
        User user2 = UnitTest.getUserInstance();
        
        user2.Username = 'Testmng@case.com';
        user2.LastName = 'XYZMNG';
        user2.Email = 'abcmng@xyz.com';
        user2.Alias = 'abmngtst';
        user2.CommunityNickname = 'CommunityNicknamemng.test';
        user2.ProfileId = lstProfile[0].Id;
        insert user2;
        
        user1.Username = 'TestUnit@tcscase.com';
        user1.ManagerId = user2.Id;
        user1.ProfileId = lstProfile[0].Id;
        insert user1;
        
        Account testAccount = UnitTest.getAccountInstance();
        insert testAccount;
            
        Opportunity testOpportunity = UnitTest.getOpportunityInstance(testAccount.Id);
       // testOpportunity.RecordTypeId = RecordtypeIds__c.getValues('LATAM Renewal Opportunity').recTypeId__c;
       testOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpportunity;
        
        Reservation__c testReservation = new Reservation__c();
        testReservation.Partner_Portal_User__c = user1.Id;
        testReservation.Partner_Account__c = testAccount.Id;
        testReservation.Account__c = testAccount.Id;
        testReservation.Start_Date__c = System.today();
        testReservation.End_Date__c = System.today().addDays(180);
        testReservation.Business_Unit__c = 'MASTERSAF';
        testReservation.Product__c = 'DW;DFE';
        testReservation.Active__c = True;
        testReservation.Partner_Manager__c = user2.Id;
        insert testReservation;
        
        Reservation__c testReservation1 = new Reservation__c();
        testReservation1.Partner_Portal_User__c = user1.Id;
        testReservation1.Partner_Account__c = testAccount.Id;
        testReservation1.Account__c = testAccount.Id;
        testReservation1.Start_Date__c = System.today();
        testReservation1.End_Date__c = System.today().addDays(180);
        testReservation1.Business_Unit__c = 'MASTERSAF';
        testReservation1.Product__c = 'DW;DFE';
        testReservation1.Active__c = True;
        testReservation1.Partner_Manager__c = user2.Id;
        insert testReservation1;
        
        Quote testQuote = new Quote();
        testQuote.Name = 'Test Quote';
        testQuote.Status = 'Draft';
        testQuote.OpportunityId = testOpportunity.id;
        // testQuote.Activity_Type__c = 'Removed';
        testQuote.Remove_Renewal_Requested__c = true;
        //testQuote.Remove_Reason__c = 'Trial';
        testQuote.Remove_Renewal_Comments__c = 'ABC'; 
        //testQuote.Remove_Renewal_Update_Status__c = 'Open';
        testQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM New Quote').getRecordTypeId();   
        insert testQuote;
        
        testOpportunity.Reservation_Number__c = testReservation.Id;
        update testOpportunity;
        
        testReservation.Partner_Manager__c = user1.Id;
        update testReservation;
        
        testOpportunity.Reservation_Number__c = testReservation1.Id;
        update testOpportunity;
    
    }
    static testMethod void mandatePartnerManagerOnApprovalTest(){
    List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'System Administrator'];
    
    User user1 = UnitTest.getUserInstance();
    user1.Username = 'TestUnit@tcscase.com';
    user1.ProfileId = lstProfile[0].Id;
    insert user1;
    
    Account testAccount = UnitTest.getAccountInstance();
    insert testAccount;
    
    Reservation__c testReservation = new Reservation__c();
    testReservation.Partner_Portal_User__c = user1.Id;
    testReservation.Partner_Account__c = testAccount.Id;
    testReservation.Account__c = testAccount.Id;
    testReservation.Start_Date__c = System.today();
    testReservation.End_Date__c = System.today().addDays(180);
    testReservation.Business_Unit__c = 'MASTERSAF';
    testReservation.Product__c = 'DW;DFE';
    //testReservation.Active__c = True;
    //testReservation.Partner_Manager__c = user2.Id;
    insert testReservation;
    
    testReservation.Approval_Status__c =  'Approved';
        try{
         update testReservation;
        } catch (Exception e){}
}
}