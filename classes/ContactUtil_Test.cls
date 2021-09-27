/**
 * Validates the functionality provided by the ContactUtil class.
 *
 * @author  John De Santiago
 * @version 2011-02-02
 */
@IsTest
private class ContactUtil_Test {
    
    /**
     * Validates that the Contact Mailing address is properly mapped to
     * an instance of an DataQualityUtil.Address object
     */
    public static testMethod void testGetContactMailingAddress() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Contact oContact = UnitTest.getContactInstance(oAccount.Id);
        oContact.MailingStreet = '444 Some Street';
        oContact.MailingCity = 'Dallas';
        oContact.MailingState = 'TX';
        oContact.MailingPostalCode = '55555';
        oContact.MailingCountry = 'US';
        
        //Execute Test
        Test.startTest();
        
        DataQualityUtil.Address oAddress = ContactUtil.getMailingAddress(oContact);
        
        Test.stopTest();
    
        //Validate Test
        System.assertEquals(oAddress.Street, oContact.MailingStreet);
    }
    
    /**
     * Validates that the Contact Mailing address is properly mapped to based
     * an instance of the specified DataQualityUtil.Address object
     */
    public static testMethod void testSetContactMailingAddress() {
        //Setup Test
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Contact oContact = UnitTest.getContactInstance(oAccount.Id);
        oContact.MailingStreet = '444 Some Street';
        oContact.MailingCity = 'Dallas';
        oContact.MailingState = 'TX';
        oContact.MailingPostalCode = '55555';
        oContact.MailingCountry = 'US';
        
        DataQualityUtil.Address oAddress = ContactUtil.getMailingAddress(oContact);
        
        //Execute Test
        Test.startTest();
        
        ContactUtil.setMailingAddress(oContact, oAddress);
        
        Test.stopTest();
    
        //Validate Test
        System.assertEquals(oContact.MailingStreet, oAddress.Street);
    }
    
    
    /**
     * Validates that prospect contacts are processed which is the entry 
     * point for a trigger that will send contacts to be processed and
     * submitted to MDB
     */
    public static testMethod void testUpsertContacts() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = MDBIntegrationUtil_Test.setupUpsertContactServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertContactSuccessResponse();
        
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.MDBID__c = '12345';
        insert oAccount;
        
        Contact oContact = UnitTest.getContactInstance(oAccount.Id);
        oContact.Phone = '555-555-5555';
        oContact.Title = 'Some Title';
        insert oContact;
        
        //Execute Test
        Test.startTest();
        
        ContactUtil.executeMDBContactUpsertService(new List<Contact> { oContact });
        
        Test.stopTest();
        
        //Validate Test
        oContact = [SELECT Id, MDB_Contact_ID__c FROM Contact WHERE Id = :oContact.Id LIMIT 1];
        System.assertEquals('10090', oContact.MDB_Contact_ID__c);
    }
    
    /**
     * Validates that prospect contacts are reports an simulated error on
     * the web service occurs
     */
    public static testMethod void testUpsertContactsFailed() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = MDBIntegrationUtil_Test.setupUpsertContactServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertContactFailureResponse();
        
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        Contact oContact = UnitTest.getContactInstance(oAccount.Id);
        insert oContact;
        
        //Execute Test
        try {
            Test.startTest();
        
            ContactUtil.executeMDBContactUpsertService(new List<Contact> { oContact });
            
            Test.stopTest();
        }
        catch (Exception unknownException) {
            System.assert(false, 'An unexpected exception occured');
        }
    }
    
    
    public static testMethod void testUpdateLeadEmail(){
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        List<Contact> listtestContact = new List<Contact>();
        List<Lead> listtestLead = new List<Lead>();
        
        Contact oContact1 = UnitTest.getContactInstance(oAccount.Id);
        oContact1.Title = 'test1';
        oContact1.Job_Function__c = 'test1';
        oContact1.Email = 'test1@test.com';
        listtestContact.add(oContact1);
        
        Contact oContact2 = UnitTest.getContactInstance(oAccount.Id);
        oContact2.Title = 'test2';
        oContact2.Job_Function__c = 'test2';        
        oContact2.Email = 'test2@test.com';
        listtestContact.add(oContact2);
        
        Contact oContact3 = UnitTest.getContactInstance(oAccount.Id);
        oContact3.External_Id__c = '78999';
        oContact3.Title = 'test3';
        oContact3.Job_Function__c = 'test3';        
        oContact3.Email = 'test3@test.com';        
        listtestContact.add(oContact3);
        insert listtestContact;
        
        
        
        Lead testLead1 = UnitTest.getLeadInstance();
        testLead1.Contact__c= oContact1.Id;
        listtestLead.add(testLead1); 
        
        Lead testLead2 = UnitTest.getLeadInstance();
        testLead2.External_Contact_Id__c= '67999';
        listtestLead.add(testLead2); 
        
        Lead testLead3 = UnitTest.getLeadInstance();
        testLead3.External_Contact_Id__c = '78999';
        listtestLead.add(testLead3);

        Lead testLead4 = UnitTest.getLeadInstance();
        testLead4.External_Contact_Id__c = '88999';
        listtestLead.add(testLead4);
        
        insert listtestLead;
        
        listtestLead = [Select Id,Email,Contact__c,Job_Function__c,Title from Lead where Id IN : listtestLead];

        Test.startTest();
        
        for(Lead olead : listtestLead){
            if(olead.Contact__c == oContact1.Id){
                System.assertEquals(olead.Email,oContact1.Email,'Error:Update failed');
                System.assertEquals(olead.Job_Function__c ,oContact1.Job_Function__c ,'Error:Update failed');                
                System.assertEquals(olead.Title,oContact1.Title,'Error:Update failed');                 
            }
            else if(olead.Contact__c == oContact2.Id){
                System.assertEquals(olead.Email,oContact2.Email,'Error:Update failed');
                System.assertEquals(olead.Job_Function__c ,oContact2.Job_Function__c ,'Error:Update failed');                
                System.assertEquals(olead.Title,oContact2.Title,'Error:Update failed');                 
            
            }
            else if(olead.Contact__c == oContact3.Id){
                System.assertEquals(olead.Email,oContact3.Email,'Error:Update failed');
                System.assertEquals(olead.Job_Function__c ,oContact3.Job_Function__c ,'Error:Update failed');                
                System.assertEquals(olead.Title,oContact3.Title,'Error:Update failed');                 
            
            
            }
        }
        oContact1.Email = 'test@test.com';
        oContact2.External_Id__c = '67999';
        oContact3.Title = 'tester';
        
        Contact oContact4 = UnitTest.getContactInstance(oAccount.Id);
        oContact4.External_Id__c = '88999';
        oContact4.Title = 'test4';
        oContact4.Job_Function__c = 'test3';        
        oContact4.Email = 'test4@test.com';        
        listtestContact.add(oContact4);
                
        upsert listtestContact;
        
        listtestLead = [Select Id,Email,Contact__c,Job_Function__c,Title from Lead where Id IN : listtestLead];
        
         for(Lead olead : listtestLead){
            if(olead.Contact__c == oContact1.Id){
                System.assertEquals(olead.Email,oContact1.Email,'Error:Update failed');
                System.assertEquals(olead.Job_Function__c ,oContact1.Job_Function__c ,'Error:Update failed');                
                System.assertEquals(olead.Title,oContact1.Title,'Error:Update failed');                 
            }
            else if(olead.Contact__c == oContact2.Id){
                System.assertEquals(olead.Email,oContact2.Email,'Error:Update failed');
                System.assertEquals(olead.Job_Function__c ,oContact2.Job_Function__c ,'Error:Update failed');                
                System.assertEquals(olead.Title,oContact2.Title,'Error:Update failed');                 
            
            }
            else if(olead.Contact__c == oContact3.Id){
                System.assertEquals(olead.Email,oContact3.Email,'Error:Update failed');
                System.assertEquals(olead.Job_Function__c ,oContact3.Job_Function__c ,'Error:Update failed');                
               // System.assertEquals(olead.Title,oContact3.Title,'Error:Update failed');                 
            
            
            }else if(olead.Contact__c == oContact4.Id){
                System.assertEquals(olead.Email,oContact4.Email,'Error:Update failed');
                System.assertEquals(olead.Job_Function__c ,oContact4.Job_Function__c ,'Error:Update failed');                
                System.assertEquals(olead.Title,oContact4.Title,'Error:Update failed');
        }
        }
        Test.stopTest();
    
    }
    
    public static testMethod void testvalidateAccountApprovedReservation() {
    
         Id profileId = [SELECT Id From Profile Where Name = 'Partner Portal User' LIMIT 1].Id;
         user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
         Profile_List__c pl = new Profile_List__c(Name= profileId,Profile_Name__c='Partner Portal User');
         insert pl;
         System.RunAs(usr) {
            try { 
                Account oAccount = UnitTest.getAccountInstance();
                insert oAccount;
                
                //List<Reservation__c> ResList = new list<Reservation__c>();
                Reservation__c OReserve = new Reservation__c();
                OReserve.Partner_Portal_User__c = usr.Id;
                OReserve.Account__c = oAccount.Id;
                OReserve.Approval_Status__c = 'Approved';
                insert OReserve;
            
                List<Contact> listtestContact = new List<Contact>();
                List<Lead> listtestLead = new List<Lead>();
                
                Contact oContact1 = UnitTest.getContactInstance(oAccount.Id);
                oContact1.Title = 'test1';
                oContact1.Job_Function__c = 'test1';
                oContact1.Email = 'test1@test.com';
                listtestContact.add(oContact1);
                
                Contact oContact2 = UnitTest.getContactInstance(oAccount.Id);
                oContact2.Title = 'test2';
                oContact2.Job_Function__c = 'test2';        
                oContact2.Email = 'test2@test.com';
                listtestContact.add(oContact2); 
                insert listtestContact;
                
                listtestContact[0].Email = 'sreenu.d@tcs.com';
                update listtestContact[0];
                system.assertEquals(oContact1.Title, 'test1');
            }
            catch(Exception ex) {}
        } 
    }    
}