@isTest
public class LCRMAccountCustomRollupService_Test{

    static Account testData(){
        
        List<Account> accList = new List<Account>(); 
        
        Account acc1 = new Account();
        acc1.Name = 'Test Account 1';
        acc1.Is_GLI__c = true;
        insert acc1;
        return acc1;
    
    }
    
    static void customsettingData(){
    
        KeyValueListStore__c obj = new KeyValueListStore__c();
        obj.Name = 'LCRMCheckInformaticaUser';
        obj.TextValue__c = 'Informatica GLI Integration,Test Informatica GLI Integration';
        insert obj;
        
    }
    
    static List<Source_System_Detail__c> ssdData(Account a)
    {
        
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        Source_System_Detail__c ssd1 = new Source_System_Detail__c();
        
        ssd1.Account_Name__c = a.id;
        ssd1.LCRM_Count_of_Subscriptions__c  = 1;
        ssd1.Name = 'Test ELite';
        ssd1.Source_System_Name__c='Test ELite ';
        ssdList.add(ssd1);
        
        Source_System_Detail__c ssd2 = new Source_System_Detail__c();
        
        ssd2.Account_Name__c = a.id;
        ssd2.LCRM_Count_of_Subscriptions__c  = 2;
        ssd2.Name = 'Test ELite 1';
        ssd2.Source_System_Name__c='Test ELite 1';
        ssdList.add(ssd2);
        
        return ssdList;
    
    
    
    }
    
    static testMethod void testAccountSSDOldMap(){
    
        Account a = testData();
        List<Source_System_Detail__c> ssdList = ssdData(a);
        insert ssdList;
        
        List<Source_System_Detail__c> ssdDelete = [Select id,LCRM_Count_of_Subscriptions__c from Source_System_Detail__c where id in:ssdList];
        
        Test.startTest();
        delete ssdDelete;
        system.assertNotEquals(null,ssdDelete);
        Test.stopTest();
      }
        
        static testMethod void testAccountSSDNewMap(){
    
        Test.startTest();
            Account a = testData();
            List<Source_System_Detail__c> ssdList = ssdData(a);
            system.assertNotEquals(null,ssdList);
            insert ssdList;
        Test.stopTest();
        }
    
    static testMethod void testInformaticaUSer(){
    
        customsettingData();
        Account a = testData();
        List<Source_System_Detail__c> ssdList = ssdData(a);
        
        Test.startTest();
         insert ssdList;
        Test.stoptest();
    
    }
    
    static testMethod void testAccountSSdBatch(){
    
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        
        User gliUser1 = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8',firstName = 'Informatica', LastName ='GLI Integration', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = adminProfile.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com');
        
        system.runAs(gliUser1){
        
        customsettingData();
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <50;i++)
        {
            Account acc = new Account();
            acc.Name ='Name'+i;
            acc.Is_GLI__c = true;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        for(Account acc:lstAccount){
        
            
            Source_System_Detail__c ssd1 = new Source_System_Detail__c();
            
            ssd1.Account_Name__c = acc.id;
            ssd1.LCRM_Count_of_Subscriptions__c  = 1;
            ssd1.Name = 'Test ELite';
            ssd1.Source_System_Name__c='Test ELite ';
            ssdList.add(ssd1);
            
            Source_System_Detail__c ssd2 = new Source_System_Detail__c();
            
            ssd2.Account_Name__c = acc.id;
            ssd2.LCRM_Count_of_Subscriptions__c  = 2;
            ssd2.Name = 'Test ELite 1';
            ssd2.Source_System_Name__c='Test ELite 1';
            ssdList.add(ssd2);
        }
        
        insert ssdList;
        List<Source_System_Detail__c> ssdData = [Select Account_Name__c,id,LCRM_Count_of_Subscriptions__c from Source_System_Detail__c where Account_Name__c!=null and Account_Name__c in :lstAccount];
        system.assertEquals(100,ssdData.size());
        }
        
        
            
            Test.startTest();
            LCRMAccountSSDRollUp_Batch obj = new LCRMAccountSSDRollUp_Batch();
            DataBase.executeBatch(obj); 
            Test.stopTest();
            
            
        
        
        
    }
}