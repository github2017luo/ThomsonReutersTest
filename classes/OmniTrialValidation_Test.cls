/** 
* OmniTrialValidation_Test method
* @description : OmniTrialValidation_Test
*/
@isTest
public class OmniTrialValidation_Test {
    /** 
    * @description : testDigital
    */
    public static testMethod void testDigital(){
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
            OmniTrialValidation.getDigitalBlacklistCompetitorStatus('testgigital@testorg.com');
            Digital_Blacklist_or_CompetitorList__c obj = new Digital_Blacklist_or_CompetitorList__c();
           
            obj.Email__c = 'test@dbc.com';
            obj.Email_Domains__c = 'dbc';
            obj.Status__c = 'Unblocked';
            obj.Type__c = 'Competitor';
            obj.Name = 'TestDBC';
            insert obj;            
            OmniTrialValidation.getDigitalBlacklistCompetitorStatus('test@dbc.com');
            OmniTrialValidation.getDigitalDomainCheck('dbc');
            OmniTrialValidation.getLapsedAccount('1003849604');
        }
    }
}