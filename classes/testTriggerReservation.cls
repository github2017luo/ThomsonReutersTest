@isTest (seeAllData=true)
private class testTriggerReservation {


    static testMethod void myUnitTest() {
        
        List<Reservation__c> ListReservation = new List<Reservation__c>();
        User userWithRole;
        if(UserInfo.getUserRoleId() == null) {
            UserRole r = new UserRole(name = 'TEST ROLE');
            Database.insert(r);
            userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', 
                                    LanguageLocaleKey='es',                  
                                    LocaleSidKey='es_AR',
                                    TimeZoneSidKey='America/Argentina/Buenos_Aires',
                                    profileid = UserInfo.getProfileId(), 
                                    username='userwithrole@testorg.com');
           
        }
        else{
            userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
        }
        Account testAcc;
        Contact testcontact;
        
        System.runAs(userWithRole) {
        
            testAcc = UnitTest.getAccountInstance();
            insert testAcc;
            
            testcontact= UnitTest.getContactInstance(testAcc.Id);
            testcontact.LastName = 'testContact';
            testcontact.FirstName = 'testContact';
            testcontact.AccountId = testAcc.Id;
            testcontact.email = 'testfirst.testlast@thomson.com';
            insert testcontact;
        
        
         Profile p = [select id from profile where name = 'Partner Portal User' limit 1];   
         
         User pu = new User(profileId = p.id, username = 'Portalusername@tr.com', email = 'testportal.testlast@thomson.com', 
                           emailencodingkey = 'UTF-8', 
                            LanguageLocaleKey='es',                  
                            LocaleSidKey='es_AR',
              TimeZoneSidKey='America/Argentina/Buenos_Aires',
                           alias='cspu', lastname='lastname', contactId = testcontact.id);
                           
        insert pu;                 
        


User unUser = [select id, Contact.AccountID from User where id = :pu.id ] ;



        
    // 1° reserva --> unUser [0]
    Reservation__c Re = new Reservation__c();
    Re.Partner_Portal_User__c = unUser.Id;  
    Re.Account__c = testAcc.id;
    Re.Active__c = true;
    Re.End_Date__c =System.today().addDays(90);
    Re.Start_Date__c =  System.today();
  
     
    Test.startTest();

    system.assertEquals(0, [select count() from AccountShare where AccountID = :testAcc.Id and RowCause = 'Manual' ], 'la cuenta No tiene Shares Manuales');
        


        system.assertEquals(null  ,Re.Partner_Account__c, 'La cuenta del User del portal debe ser la misma que la de la reserva');
        



     insert Re;
 

        system.assertEquals(1, [select count() from AccountShare where UserOrGroupId =:unUser.Id and AccountID = :testAcc.Id and RowCause = 'Manual' ], 'la cuenta tiene 1 Shares Manuales para unUser');
        
                        
        system.assertEquals(unUser.Contact.AccountID    ,[select Partner_Account__c  from Reservation__c where id = :Re.id].Partner_Account__c, 'La cuenta del User del portal debe ser la misma que la de la reserva');
        

// test update Activa__c = FALSE

    Re.Active__c = false;
    Re.Partner_Account__c = null;
    
    system.assertEquals(true, [select Active__c  from Reservation__c where id = :Re.id].Active__c , 'la cuenta tiene 1 Shares Manuales para unUser');
    
    
    update Re ;

        system.assertEquals(0, [select count() from AccountShare where UserOrGroupId =:Re.Partner_Portal_User__c and AccountID = :testAcc.Id and RowCause = 'Manual' ], 'la cuenta tiene 1 Shares Manuales para unUser');
       
    system.assertEquals(false, [select Active__c  from Reservation__c where id = :Re.id].Active__c , 'la cuenta tiene 1 Shares Manuales para unUser');
        
// test update Activa__c = TRUE    
    Re.Active__c = true;
   
    update Re ;
        
        system.assertEquals(1, [select count() from AccountShare where UserOrGroupId =:Re.Partner_Portal_User__c and AccountID = :testAcc.Id and RowCause = 'Manual' ], 'la cuenta tiene 1 Shares Manuales para unUser');
        
    system.assertEquals(true, [select Active__c  from Reservation__c where id = :Re.id].Active__c , 'la cuenta tiene 1 Shares Manuales para unUser');

// test update FECHA
    Re.Start_Date__c = system.today().addDays(1);
    Re.Partner_Account__c = null;

    
    update Re ;
    
        system.assertEquals(0, [select count() from AccountShare where UserOrGroupId =:Re.Partner_Account__c and AccountID = :testAcc.Id and RowCause = 'Manual' ], 'la cuenta tiene 1 Shares Manuales para unUser');
        
    system.assertEquals(false, [select Active__c  from Reservation__c where id = :Re.id].Active__c , 'la cuenta tiene 1 Shares Manuales para unUser');
        system.assertEquals(unUser.Contact.AccountID  ,[select Partner_Account__c  from Reservation__c where id = :Re.id].Partner_Account__c, 'La cuenta del User del portal debe ser la misma que la de la reserva');


       Re.Start_Date__c = system.today();
       update Re ;  
       
       


    
Test.stopTest();
    }
        
    }
    
  /*  public static testMethod void testPortalUser() {
            Account testAcc;
            Contact testcontact;

            testAcc = UnitTest.getAccountInstance();
            insert testAcc;
            
            testcontact= UnitTest.getContactInstance(testAcc.Id);
            testcontact.LastName = 'testContact';
            testcontact.FirstName = 'testContact';
            testcontact.AccountId = testAcc.Id;
            testcontact.email = 'testfirst.testlast@thomson.com';
            insert testcontact;
            
        Profile p = [select id from profile where name = 'Partner Portal User' limit 1];   
         
         User pu = new User(profileId = p.id, username = 'Portalusername@tr.com', email = 'testportal.testlast@thomson.com', 
                           emailencodingkey = 'UTF-8', 
                            LanguageLocaleKey='es',                  
                            LocaleSidKey='es_AR',
              TimeZoneSidKey='America/Argentina/Buenos_Aires',
                           alias='cspu', lastname='lastname', contactId = testcontact.id);
                           
        insert pu;    
        Reservation__c rs = new Reservation__c ();
        System.RunAs(pu) {
            try {
                
                rs.End_Date__c =System.today().addDays(90);
                rs.Start_Date__c =  System.today();
                insert rs;
                }
            catch(Exception Ex) {}
            system.assertNotEquals(null, rs.Start_Date__c );        
        }
    }   */ 
}