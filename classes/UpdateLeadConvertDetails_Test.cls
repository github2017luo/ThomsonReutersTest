@istest
public class UpdateLeadConvertDetails_Test {

    
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
        
        KeyValueListStore__c oKeyValue = new KeyValueListStore__c();
        oKeyValue.name = 'ANZUsersProfileId';       
        oKeyValue.TextValue__c = [SELECT Id FROM Profile WHERE Name = 'ANZ Users' LIMIT 1].Id;
        INSERT oKeyValue;
        
        //
        RecordtypeIds__c orecordType = new RecordtypeIds__c ();
        orecordType.name ='ANZ Case';        
        orecordType.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND DeveloperName = 'ANZ' LIMIT 1].Id; 
        INSERT orecordType;
        
        //
        RecordtypeIds__c orecordType1 = new RecordtypeIds__c ();
        orecordType1.name ='Pipeline Opportunities';       
        orecordType1.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Pipeline_Opportunity' LIMIT 1].Id; 
        INSERT orecordType1;
        
        //
        RecordtypeIds__c orecordType2 = new RecordtypeIds__c ();
        orecordType2.name ='Pre-Pipeline Opportunities';       
        orecordType2.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Pre_Pipeline_Opportunity' LIMIT 1].Id; 
        INSERT orecordType2;
        
        //
        RecordtypeIds__c orecordType3 = new RecordtypeIds__c ();
        orecordType3.name ='Prospect';        
        orecordType3.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Prospect' LIMIT 1].Id;
        INSERT orecordType3;
        
        //
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';       
        orecordType5.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'LATAM_Renewal_Opportunity' LIMIT 1].Id;
        INSERT orecordType5;
        
        //
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';        
        orecordType6.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Quote' AND DeveloperName = 'LATAM_Renewal_Quote' LIMIT 1].Id;
        INSERT orecordType6;
    }
    
    @isTest static void testLeadDescriptionGliLightning1(){       
        
        
        
        
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; //System Administrator ,TR Sales - Lightning
        User u1 = new User(alias = 'newUser', email='user@mydomain2.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        system.runas(u1){
            
            
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
            ltstemp.LTS_Disable_Process_Builders__c = false;
            ltstemp.LTS_Disable_Triggers__c = false;
            ltstemp.LTS_Disable_Validation_Rules__c = true;
            ltstemp.LTS_Disable_Workflow_Rules__c = true;
            ltstemp.Name = 'temp';
            ltstemp.SetupOwnerId = userinfo.getuserid();
            insert ltstemp;
            
            //recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
            recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            
            Account gliAccount = UnitTest.getAccountInstance();
            gliAccount.Name = 'Test Account Training Event';
            gliAccount.Is_GLI__c = true;
            gliAccount.RecordTypeId=accountRT.Id;
            gliAccount.sales_org__c = 'WEST';
            gliAccount.OwnerId = u1.Id;
            insert gliAccount;
            
            Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
            gliContact.RecordTypeId = conRT.Id;
            gliContact.OwnerId = u1.Id;
            insert gliContact;
            
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
            gliOpty.OwnerId = u1.Id;
            gliOpty.LCRM_Territory_Update_Timestamp__c=system.today();
            insert gliOpty;
            
            recordtype leadRt= [select id from recordtype where developername ='GLI' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead testLead1 = UnitTest.getLeadInstance();
            testLead1.LeadSource='Customer Service'; 
            testLead1 .RecordTypeId=leadRt.Id;      
            testLead1.SAPAccountNumber__c = '98711';
            testLead1.FirstName = 'Unit';
            testLead1.LastName = 'Tester1';
            testLead1.Company = 'Unit Test Company';
            testLead1.isConverted = true;
            testLead1.ConvertedAccountId = gliAccount.Id;
            testLead1.ConvertedContactId=   gliContact.Id;            
            testLead1.ConvertedOpportunityId = gliOpty.ID;
            testLead1.is_GLI__c =true;
            testLead1.Sales_Org__c='GLI';
            testLead1.Status = 'Contacting';         
            testLead1.Billing_Country__c='US';
            testLead1.Description='Lead is created for GLI';
            listlead.add(testLead1);
            
            if(listlead.size()>0){
                insert listlead;
                System.assertEquals(true, listlead[0].id != null,'Lead Id');
                leadMap.put(listlead[0].id, listlead[0]);
                UpdateLeadConvertDetails.updateDetails(leadMap);
                
            }
            
            
            Test.stoptest();
            
        }
        
    }
     @isTest static void testLeadDescriptionGliLightning2(){       
        
        
        
        
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; //System Administrator ,TR Sales - Lightning
        User u1 = new User(alias = 'newUser', email='user@mydomain2.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        system.runas(u1){
            
            
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
            ltstemp.LTS_Disable_Process_Builders__c = false;
            ltstemp.LTS_Disable_Triggers__c = false;
            ltstemp.LTS_Disable_Validation_Rules__c = true;
            ltstemp.LTS_Disable_Workflow_Rules__c = true;
            ltstemp.Name = 'temp';
            ltstemp.SetupOwnerId = userinfo.getuserid();
            insert ltstemp;
            
            //recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
            recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            
            Account gliAccount = UnitTest.getAccountInstance();
            gliAccount.Name = 'Test Account Training Event';
            gliAccount.Is_GLI__c = true;
            gliAccount.RecordTypeId=accountRT.Id;
            gliAccount.sales_org__c = 'WEST';
            gliAccount.OwnerId = u1.Id;
            insert gliAccount;
            
            Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
            gliContact.RecordTypeId = conRT.Id;
            gliContact.OwnerId = u1.Id;
            insert gliContact;
            
            Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
            gliOpty.Name = 'Test Opportunity Training Event';
            gliOpty.Key_Contact__c = gliContact.id;
            gliOpty.Renewal_Flag__c = true;
            gliOpty.Description = 'Test description opp';
            gliOpty.currencyIsoCode = 'USD';
            gliOpty.StageName = 'Needs Analysis';
            gliOpty.is_gli__c = true;
            gliOpty.Lead_ID__c = '123';
            gliOpty.LCRM_Status__c = 'Open';
            gliOpty.RecordTypeId = opptyRT.Id;
            gliOpty.CurrencyIsoCode = 'USD';
            gliOpty.Expiration_Date__c=Date.Today();
            gliOpty.OwnerId = u1.Id;
            gliOpty.LCRM_Territory_Update_Timestamp__c=system.today();
            insert gliOpty;
            
            recordtype leadRt= [select id from recordtype where developername ='GLI' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead testLead1 = UnitTest.getLeadInstance();
            testLead1.LeadSource='Customer Service'; 
            testLead1 .RecordTypeId=leadRt.Id;      
            testLead1.SAPAccountNumber__c = '98711';
            testLead1.FirstName = 'Unit';
            testLead1.LastName = 'Tester1';
            testLead1.Company = 'Unit Test Company';
            testLead1.isConverted = true;
            testLead1.ConvertedAccountId = gliAccount.Id;
            testLead1.ConvertedContactId=   gliContact.Id;            
            testLead1.ConvertedOpportunityId = gliOpty.ID;
            testLead1.is_GLI__c =true;
            testLead1.Sales_Org__c='GLI';
            testLead1.Status = 'Contacting';         
            testLead1.Billing_Country__c='US';
            testLead1.Description='Lead is created for GLI';
            listlead.add(testLead1);
            
            if(listlead.size()>0){
                insert listlead;
                System.assertEquals(true, listlead[0].id != null,'Lead Id');
                leadMap.put(listlead[0].id, listlead[0]);
                UpdateLeadConvertDetails.updateDetails(leadMap);
                
            }
            
            
            Test.stoptest();
            
        }
        
    }
    @isTest static void testLeadDescriptionGliLightning3(){       
        
        
        
        
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; //System Administrator ,TR Sales - Lightning
        User u1 = new User(alias = 'newUser', email='user@mydomain2.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        system.runas(u1){
            
            
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
            ltstemp.LTS_Disable_Process_Builders__c = false;
            ltstemp.LTS_Disable_Triggers__c = false;
            ltstemp.LTS_Disable_Validation_Rules__c = true;
            ltstemp.LTS_Disable_Workflow_Rules__c = true;
            ltstemp.Name = 'temp';
            ltstemp.SetupOwnerId = userinfo.getuserid();
            insert ltstemp;
            
            //recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
            recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            
            Account gliAccount = UnitTest.getAccountInstance();
            gliAccount.Name = 'Test Account Training Event';
            gliAccount.Is_GLI__c = true;
            gliAccount.RecordTypeId=accountRT.Id;
            gliAccount.sales_org__c = 'WEST';
            gliAccount.OwnerId = u1.Id;
            insert gliAccount;
            
            Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
            gliContact.RecordTypeId = conRT.Id;
            gliContact.OwnerId = u1.Id;
            insert gliContact;
            
            Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
            gliOpty.Name = 'Test Opportunity Training Event';
            gliOpty.Key_Contact__c = gliContact.id;
            gliOpty.Renewal_Flag__c = true;
            gliOpty.Description = 'Test description opp';
            gliOpty.currencyIsoCode = 'USD';
            gliOpty.StageName = 'Needs Analysis';
            gliOpty.is_gli__c = true;
            gliOpty.Lead_ID__c = '123';
            gliOpty.LCRM_Status__c = 'Open';
            gliOpty.RecordTypeId = opptyRT.Id;
            gliOpty.CurrencyIsoCode = 'USD';
            gliOpty.Expiration_Date__c=Date.Today();
            gliOpty.OwnerId = u1.Id;
            gliOpty.LCRM_Territory_Update_Timestamp__c=system.today();
            insert gliOpty;
            
            recordtype leadRt= [select id from recordtype where developername ='GLI' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead testLead1 = UnitTest.getLeadInstance();
            testLead1.LeadSource='Customer Service'; 
            testLead1 .RecordTypeId=leadRt.Id;      
            testLead1.SAPAccountNumber__c = '98711';
            testLead1.FirstName = 'Unit';
            testLead1.LastName = 'Tester1';
            testLead1.Company = 'Unit Test Company';
            testLead1.isConverted = true;
            testLead1.ConvertedAccountId = gliAccount.Id;
            testLead1.ConvertedContactId=   gliContact.Id;            
            testLead1.ConvertedOpportunityId = gliOpty.ID;
            testLead1.is_GLI__c =true;
            testLead1.Sales_Org__c='GLI';
            testLead1.Status = 'Contacting';         
            testLead1.Billing_Country__c='US';
            testLead1.Description='Lead is created for GLI';
            listlead.add(testLead1);
            
            if(listlead.size()>0){
                insert listlead;
                System.assertEquals(true, listlead[0].id != null,'Lead Id');
                listlead[0].description = 'Test';
                UpdateLeadConvertDetails.isInSalesforceLightning = true;
                update listlead[0];
                leadMap.put(listlead[0].id, listlead[0]);
                //UpdateLeadConvertDetails.updateDetails(leadMap);
                
            }
            
            
            Test.stoptest();
            
        }
        
    }
}