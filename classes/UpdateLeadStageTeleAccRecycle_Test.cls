/*
    process builder test class: Update Lead Stage to Tele accepted and Recycle
*/
@isTest
public class UpdateLeadStageTeleAccRecycle_Test{
    
    @testSetup static void addKeyValueStore() {
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
    }
    
    public static testmethod void testPB1(){
        
        Profile ProfileId = [SELECT Id FROM Profile WHERE Name = 'TR Legal US Sales User' limit 1];
        User u1 = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfileId .Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='UKI');
        insert u1;              
        
        //public boolean salesOrgSection ='TRUE';
        //insert new MinimizeLeadCreation__c (Field__c = 'Value');
        
        MinimizeLeadCreation__c cs = new MinimizeLeadCreation__c();
        cs.Name='Customer Class Default';
        cs.Value__c='None';
        insert cs;
        
        MinimizeLeadCreation__c cs1 = new MinimizeLeadCreation__c();
        cs1.Name='Customer Type Default';
        cs1.Value__c='None';
        insert cs1;
        
        MinimizeLeadCreation__c cs2 = new MinimizeLeadCreation__c();
        cs2.Name='SalesOrgDefaultedProfiles';
        cs2.Value__c='WEST';
        insert cs2;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        ILMGeneral__c ilmGen1=new ILMGeneral__c();
        ilmGen1.name= 'AllowedProfilesForSLAEmails';
        ilmGen1.Value__C = 'TR Legal FindLaw Advanced Lead Mgmt';        
        insert ilmGen1;
        
        system.runAs(u1)   {
            Account account = UnitTest.getAccountInstance();
            account.Name = 'UTLeadAccount';
            account.BillingCountry = 'US';
            account.ShippingCountry = 'US';            
            account.BillingState = 'IL';
            insert account;
            
            Contact contact= UnitTest.getContactInstance(account.id);
            insert contact;
            
            
            Test.startTest();
            List<Lead> listLead = new List<Lead>();
            Lead oLead = UnitTest.getLeadInstance();
            
            oLead.Company = 'Test 1 New Company';
            oLead.LastName = 'Martha';
            oLead.Account__c= account.Id;
            oLead.Customer_Type__c = 'Individual';
            oLead.Customer_Class__c = 'None';
            oLead.Sales_Org__c = 'WEST'; 
            oLead.email = 'WEST@ema.com'; 
            oLead.phone = '12345'; 
            olead.Language_Preference__c = 'English';
            oLead.MobilePhone = '1234567890';
            oLead.Contact__c= contact.id;      
            oLead.PO_Box__c='ass';
            oLead.Billing_Street__c='itpl';
            oLead.Billing_City__c='bangalore';
            oLead.Billing_Country__c='ka';
            oLead.status = 'Discarded';
            olead.Discard_Reason__c = 'Do Not Call';
            listLead.add(oLead);
           
            insert listLead;
            test.stoptest();
        }
    }
    
    public static testmethod void testPB(){
        
        Profile ProfileId = [SELECT Id FROM Profile WHERE Name = 'TR Legal US Sales User' limit 1];
        User u1 = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfileId .Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='UKI');
        insert u1;              
        
        //public boolean salesOrgSection ='TRUE';
        //insert new MinimizeLeadCreation__c (Field__c = 'Value');
        
        MinimizeLeadCreation__c cs = new MinimizeLeadCreation__c();
        cs.Name='Customer Class Default';
        cs.Value__c='None';
        insert cs;
        
        MinimizeLeadCreation__c cs1 = new MinimizeLeadCreation__c();
        cs1.Name='Customer Type Default';
        cs1.Value__c='None';
        insert cs1;
        
        MinimizeLeadCreation__c cs2 = new MinimizeLeadCreation__c();
        cs2.Name='SalesOrgDefaultedProfiles';
        cs2.Value__c='WEST';
        insert cs2;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        ILMGeneral__c ilmGen1=new ILMGeneral__c();
        ilmGen1.name= 'AllowedProfilesForSLAEmails';
        ilmGen1.Value__C = 'TR Legal FindLaw Advanced Lead Mgmt';        
        insert ilmGen1;
        
        system.runAs(u1)   {
            Account account = UnitTest.getAccountInstance();
            account.Name = 'UTLeadAccount';
            account.BillingCountry = 'US';
            account.ShippingCountry = 'US';            
            account.BillingState = 'IL';
            insert account;
            
            Contact contact= UnitTest.getContactInstance(account.id);
            insert contact;
            
            
            Test.startTest();
            List<Lead> listLead = new List<Lead>();
            Lead oLead = UnitTest.getLeadInstance();
            
            oLead.Company = 'Test 1 New Company';
            oLead.LastName = 'Martha';
            oLead.Account__c= account.Id;
            oLead.Customer_Type__c = 'Individual';
            oLead.Customer_Class__c = 'None';
            oLead.Sales_Org__c = 'WEST'; 
            oLead.email = 'WEST@ema.com'; 
            oLead.phone = '12345'; 
            olead.Language_Preference__c = 'English';
            oLead.MobilePhone = '1234567890';
            oLead.Contact__c= contact.id;      
            oLead.PO_Box__c='ass';
            oLead.Billing_Street__c='itpl';
            oLead.Billing_City__c='bangalore';
            oLead.Billing_Country__c='ka';
            oLead.status = 'Unworked';
            olead.Discard_Reason__c = 'Do Not Call';
            listLead.add(oLead);
           
            insert listLead;
            
            oLead.status = 'Contacting';
            update oLead;
            test.stoptest();
        }
    }
    
    public static testmethod void testPB2(){
        
        Profile ProfileId = [SELECT Id FROM Profile WHERE Name = 'TR Legal US Sales User' limit 1];
        User u1 = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfileId .Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='UKI');
        insert u1;              
        
        //public boolean salesOrgSection ='TRUE';
        //insert new MinimizeLeadCreation__c (Field__c = 'Value');
        
        MinimizeLeadCreation__c cs = new MinimizeLeadCreation__c();
        cs.Name='Customer Class Default';
        cs.Value__c='None';
        insert cs;
        
        MinimizeLeadCreation__c cs1 = new MinimizeLeadCreation__c();
        cs1.Name='Customer Type Default';
        cs1.Value__c='None';
        insert cs1;
        
        MinimizeLeadCreation__c cs2 = new MinimizeLeadCreation__c();
        cs2.Name='SalesOrgDefaultedProfiles';
        cs2.Value__c='WEST';
        insert cs2;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        ILMGeneral__c ilmGen1=new ILMGeneral__c();
        ilmGen1.name= 'AllowedProfilesForSLAEmails';
        ilmGen1.Value__C = 'TR Legal FindLaw Advanced Lead Mgmt';        
        insert ilmGen1;
        
        system.runAs(u1)   {
            Account account = UnitTest.getAccountInstance();
            account.Name = 'UTLeadAccount';
            account.BillingCountry = 'US';
            account.ShippingCountry = 'US';            
            account.BillingState = 'IL';
            insert account;
            
            Contact contact= UnitTest.getContactInstance(account.id);
            insert contact;
            
            
            Test.startTest();
            List<Lead> listLead = new List<Lead>();
            Lead oLead = UnitTest.getLeadInstance();
            
            oLead.Company = 'Test 1 New Company';
            oLead.LastName = 'Martha';
            oLead.Account__c= account.Id;
            oLead.Customer_Type__c = 'Individual';
            oLead.Customer_Class__c = 'None';
            oLead.Sales_Org__c = 'WEST'; 
            oLead.email = 'WEST@ema.com'; 
            oLead.phone = '12345'; 
            olead.Language_Preference__c = 'English';
            oLead.MobilePhone = '1234567890';
            oLead.Contact__c= contact.id;      
            oLead.PO_Box__c='ass';
            oLead.Billing_Street__c='itpl';
            oLead.Billing_City__c='bangalore';
            oLead.Billing_Country__c='ka';
            oLead.status = 'Unworked';
            olead.Discard_Reason__c = 'Do Not Call';
            listLead.add(oLead);
           
            insert listLead;
            
            oLead.status = 'Interested';
            update oLead;
            test.stoptest();
        }
    }

}