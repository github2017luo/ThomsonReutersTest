@isTest
private class ContractTriggerTest {

	private static testMethod void testContractSubBu() {
	    
	    
	    Profile p = [SELECT Id FROM profile WHERE name='UKI Users'];   
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];// Updated this method to fix test class error for CRM-1324
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'UKI',timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test', UserRoleId = ukiRole.Id);        
        insert u1;
        
        GenericObject__c obj = new GenericObject__c(name = 'Contract', Apifieldname__c = 'LCRM_Sub_BU__c' ,Isglifieldapiname__c	= 'LCRM_Is_GLI__c');
        insert obj;
            
        }
        system.runAs(u1){
            
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            Account childAccount = new Account();
            childAccount.Name = 'Child Test Account';
            childAccount.Phone = '91 80 67254199';
            childAccount.BillingCountry = 'US';
            childAccount.BillingState='IL';
            childAccount.BillingPostalCode = '60603-3801';
            //childAccount.Operational_Ultimate_Parent_Name1__c = parentAccount.Id;
            childAccount.Is_GLI__c = true;
			childAccount.Sales_Org__c = 'GLI';
            childAccount.RecordTypeId=accountRT.Id;
            insert childAccount;
            
            Test.startTest();
            
            Contract ctr = new Contract();
            ctr.Accountid = childAccount.id;
            ctr.startDate = system.Today();
            ctr.ContractTerm = 12;
            insert ctr;

            Contract ctrRetrieved = [Select Id, AccountId,LCRM_Sub_BU__c, LCRM_Is_GLI__c
                                    from Contract
                                    where id=:ctr.id];
                                    
        //    system.assertEquals('UKI', ctrRetrieved.LCRM_Sub_BU__c);
         //   system.assertEquals(true, ctrRetrieved.LCRM_Is_GLI__c);
            
            Test.stopTest();
            
        }
            
	}

}