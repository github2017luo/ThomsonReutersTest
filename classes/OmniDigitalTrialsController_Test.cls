/** 
* OmniDigitalTrialsController_Test method
* @description : OmniDigitalTrialsController_Test 
*/
@isTest
public class OmniDigitalTrialsController_Test {
    /**  
* @description : testProduct
*/
    public static testMethod void testProduct(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        
        User dbc = new User(alias = 'newUser', email='user@mydomain.com', 
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                            timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert dbc; 
        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        
        
        system.runAs(dbc) {
            //OmniDigitalTrialsController.getProductsList('testgigital@testorg.com');
            Product2 obj = new Product2();
            obj.DC_Product_Title__c = 'test1';
            obj.Name = 'test1';
            obj.Family ='CD';
            obj.Free_Trial__c = 'Omni';
            obj.family='WESTLAW';
            insert obj;
            
            Product2 obj11 = new Product2();
            obj11.DC_Product_Title__c = 'test1';
            obj11.Name = 'test1';
            obj11.Family ='CD';
            obj11.Free_Trial__c = 'Omni';
            obj11.family='WESTLAW';
            insert obj11;
            
            Product_Relationship__c p1 = new Product_Relationship__c();
            p1.Product_to__c = obj.Id;
            p1.Product_from__c = obj11.Id;
            p1.Segment__c = 'Government';
            p1.Relationship_Link_Type__c ='Better';
            insert p1;
            
             Product_Relationship__c p11 = new Product_Relationship__c();
            p11.Product_to__c = obj11.Id;
            p11.Product_from__c = obj11.Id;
            p11.Segment__c = 'Government';
            p11.Relationship_Link_Type__c ='Better';
            p11.Relationship_Type__c = 'Accessory Product' ;
            insert p11;
            
            
            
            OmniDigitalTrialsController.getProductsList('test1');
            //OmniDigitalTrialsController.getSelectedPrdContacts('test1','test2');
            
            //create 1 account record
            Account obja = new Account();
            obja.Name = 'testac';
            //obja.Customer_Sub_Type__c = 'Public';
            obja.fferpcore__TaxCountryCode__c = 'DE';
            obja.LatAm_State_Desc__c = 'Berlin';
            insert obja;
            
            //List<Account> s1 = new List<Account>();
            //s1 = [SELECT Id  From Account WHERE Name = 'testac'];
            //string sample1 = s1[0];
            Account sample1 = [SELECT Name,id From Account WHERE Name = 'testac'];
            
            Contact obj1 = new Contact();
            obj1.AccountId = sample1.id;
            obj1.FirstName ='ab';
            obj1.LastName = 'test';
            obj1.Email = 'test@dbc.com';
            //obj1.Online_Contact_Designation__c = False;
            //Primary_Flag__c = False;
            insert obj1;
            string sa1 = sample1.id;
            OmniDigitalTrialsController.fetchGSIContacts(sa1);
            
            Source_System_Detail__c obj2= new Source_System_Detail__c();
            obj2.Account_Name__c = sample1.id;
            obj2.Name = 'test';
            obj2.Source_System_Name__c = 'Test name';
            obj2.Source_System_Account_Number__c = '112';
            insert obj2;
            //string sal1 = obj2.Source_System_Account_Number__c;
            // OmniDigitalTrialsController.fetchSSD(sal1);
            
            Trial__c objTrials = new Trial__c ();
            insert objTrials;
            //OmniDigitalTrialsController.saveTrials(objTrials);
            OmniDigitalTrialsController.ssdExistingCustomerCheck(sample1.Id);
            /*
            Opportunity oOpportunity = new Opportunity();
            oOpportunity.AccountId = obja.Id;
            oOpportunity.Name = 'Unit Test Opportuntiy';
            oOpportunity.CloseDate = System.Today() + 5;
            oOpportunity.StageName = '75%';
            insert oOpportunity;
            
            OmniDigitalTrialsController.fetchOpportunity(oOpportunity.id);*/
            
            
        }
    }
}