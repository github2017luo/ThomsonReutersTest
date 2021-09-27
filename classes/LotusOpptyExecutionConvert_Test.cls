@isTest
public class LotusOpptyExecutionConvert_Test {
    @isTest
    public  static void testLeadCampaign(){
        
        List<Profile> lstProfile1 =[SELECT Id FROM Profile WHERE Name = 'TR Sales - Lightning'];
        User user2 = UnitTest.getUserInstance();
        user2.Username = 'Test@xyzAccountregion1.com';
        user2.CommunityNickname = 'ghel';
        user2.LastName = 'XYZ';
        user2.Email = 'abc@xyz.com';
        user2.Alias = 'abcd';       
        user2.ProfileId = lstProfile1[0].Id;        
        user2.Segment__c = ' Corporate';
        insert user2;
        
        
        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        List<KeyValueListStore__c> lstOfKeyStore = new List<KeyValueListStore__c>();
        KeyValueListStore__c KeyvalueStore3 = new KeyValueListStore__c();
        KeyvalueStore3.Name= 'LCRMCheckInformaticaUser';
        KeyvalueStore3.TextValue__c = 'Informatica GLI Integration';
        lstOfKeyStore.add(KeyvalueStore3);
        KeyValueListStore__c KeyvalueStore = new KeyValueListStore__c();
        KeyvalueStore.Name = 'LCRM Oppty Reason';
        KeyvalueStore.TextValue__c = 'Billing System Cancellation';
        lstOfKeyStore.add(KeyvalueStore);
        
        KeyValueListStore__c KeyvalueStore1 = new KeyValueListStore__c();
        KeyvalueStore1.Name='LCRM Oppty Win Loss'; 
        KeyvalueStore1.TextValue__c = 'Lost';
        lstOfKeyStore.add(KeyvalueStore1);
        
        KeyValueListStore__c KeyvalueStore2 = new KeyValueListStore__c();
        KeyvalueStore2.Name= 'ANZUsersProfileId';
        KeyvalueStore2.TextValue__c = '00e30000001ZUki';
        lstOfKeyStore.add(KeyvalueStore2);
        
        
        
        KeyValueListStore__c KeyvalueStore4 = new KeyValueListStore__c();
        KeyvalueStore4.Name= 'LCRMOpptyTerritoryStageValues';
        KeyvalueStore4.TextValue__c = 'Contract Signed,Order Complete,Closed Lost';
        lstOfKeyStore.add(KeyvalueStore4);
        //End Opportunity
        
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        if(lstOfKeyStore.size()>0){ 
            insert lstOfKeyStore;
        }
        
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        
        campaign cam = new campaign();
        cam.Name = 'Test Campaign';
        insert cam;
        
        recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account Training Event';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        gliAccount.sales_org__c = 'WEST';
        //gliAccount.OwnerId = oUser.Id;
        insert gliAccount;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
        gliContact.RecordTypeId = conRT.Id;
        //gliContact.OwnerId = gliUser.Id;
        insert gliContact;
        
        List<Opportunity> OpptyList = new  List<Opportunity>();
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Test Opportunity Training Event';
        gliOpty.Key_Contact__c = gliContact.id;
        gliOpty.Renewal_Flag__c = true;
        gliOpty.currencyIsoCode = 'USD';
        gliOpty.StageName = 'Needs Analysis';
        gliOpty.is_gli__c = true;
        gliOpty.Lead_ID__c = '123';
        gliOpty.LCRM_Status__c = 'Open';
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.CurrencyIsoCode = 'USD';
        gliOpty.Expiration_Date__c=Date.Today();
        gliOpty.OwnerId = user2.Id;
        gliOpty.LCRM_Territory_Update_Timestamp__c=system.today();
        System.debug('gliOpty : '+gliOpty);
        OpptyList.add(gliOpty);
        
        insert OpptyList;
        Lead lead = UnitTest.getLeadInstance();
        lead.LastName='Ghosh';
        lead.OwnerId = user2.id;
        lead.leadSource = 'Rep Generated';
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.street = 'test';
        lead.State='TX';
        lead.city='IN';
        lead.country = 'US';
        lead.PostalCode='12345';
        //lead.country='12345';
        //lead.Billing_State__c = 'CA';
        //lead.Billing_Zip__c = 'test';
        lead.Billing_Country__c = 'US';
        lead.DoNotCall = true;
        lead.primary_campaign_source__c=cam.id;
        lead.email = 'abc@gmail.com';
        lead.IsConverted=true;
        lead.ConvertedAccountId = gliAccount.id;
        lead.ConvertedContactId = gliContact.id;
        lead.ConvertedOpportunityId= OpptyList[0].id;
        insert lead;
        
        System.runAs(user2){
            Test.startTest();
            LotusOpptyExecutionAfterLeadConversion.addCampaignDetails(lead);
            LotusOpptyExecutionAfterLeadConversion.addOpportunityMemberAfterLeadConversion(OpptyList);
            Test.stopTest();
        }
        
    }
    
}